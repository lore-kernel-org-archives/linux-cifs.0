From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/2] cifs: Invoke id mapping functions (try #8)
Date: Mon,  7 Mar 2011 22:47:07 -0600
Message-ID: <1299559627-15554-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

rb tree search and insertion routines.

A SID which needs to be mapped, is looked up in one of the rb trees
depending whether SID is either owner or group SID.
If found in the tree, a (mapped) id from that node is assigned to
uid or gid as appropriate.  If upcall returns an error, mapping
is retried after a timeout period.

Otherwise, an node is inserted in the tree and a mapping id for
that SID is looked-up with the help of Winbind via upcall mechanism.
If, for whatever reasons, winbind calls return error, SID for an
owner is mapped to 'nobody' and SID for a group is mapped to 'nogroup'.

To map a SID, which can be either a Owner SID or a Group SID, key
description starts with the string "os" or "gs" followed by SID converted
to a string. Without "os" or "gs", cifs.upcall does not know whether
SID needs to be mapped to either an uid or a gid.

Nodes in rb tree as fields to prevent multiple upcalls for
a SID.  Adding and removing nodes is done within global locks.
shrinker routine does not prune a node if mapping for that node
is either pending or or node was recently created (before timeout
period expires and node could be purged). The timeout period should
be long enough at least for an upcall to return back to cifs.

For now, cifs.upcall is only used to map a SID to an id (uid or gid) but
it would be used to obtain an SID (string) for an id.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsacl.c |  295 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/cifs/cifsacl.h |   23 ++++
 2 files changed, 294 insertions(+), 24 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index fc1ec64..e560b04 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -54,7 +54,31 @@ static const struct cifs_sid sid_authusers = {
 /* group users */
 static const struct cifs_sid sid_user = {1, 2 , {0, 0, 0, 0, 0, 5}, {} };
 
-static const struct cred *root_cred;
+const struct cred *root_cred;
+
+void
+shrink_idmap(struct rb_root *root, int nr_to_scan, int *nr_rem)
+{
+	int nr_del = 0;
+	struct rb_node *node;
+	struct rb_node *tmp;
+	struct cifs_sid_id *psidid;
+
+	node = rb_first(root);
+	while (node) {
+		tmp = node;
+		node = rb_next(tmp);
+		psidid = rb_entry(tmp, struct cifs_sid_id, rbnode);
+		if (time_after(psidid->time + SID_MAP_EXPIRE, jiffies) ||
+				test_bit(SID_ID_PENDING, &psidid->state) ||
+				(nr_to_scan == 0) || (nr_del == nr_to_scan))
+			++(*nr_rem);
+		else {
+			rb_erase(tmp, root);
+			++nr_del;
+		}
+	}
+}
 
 /*
  * Run idmap cache shrinker.
@@ -62,11 +86,23 @@ static const struct cred *root_cred;
 static int
 cifs_idmap_shrinker(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
 {
-	/* Use a pruning scheme in a subsequent patch instead */
-	cifs_destroy_idmaptrees();
-	return 0;
+	int nr_rem = 0;
+	struct rb_root *root;
+
+	root = &uidtree;
+	spin_lock(&siduidlock);
+	shrink_idmap(root, nr_to_scan, &nr_rem);
+	spin_unlock(&siduidlock);
+
+	root = &gidtree;
+	spin_lock(&sidgidlock);
+	shrink_idmap(root, nr_to_scan, &nr_rem);
+	spin_unlock(&sidgidlock);
+
+	return nr_rem;
 }
 
+
 static struct shrinker cifs_shrinker = {
 	.shrink = cifs_idmap_shrinker,
 	.seeks = DEFAULT_SEEKS,
@@ -92,7 +128,6 @@ cifs_idmap_key_destroy(struct key *key)
 	kfree(key->payload.data);
 }
 
-static
 struct key_type cifs_idmap_key_type = {
 	.name        = "cifs.cifs_idmap",
 	.instantiate = cifs_idmap_key_instantiate,
@@ -101,6 +136,192 @@ struct key_type cifs_idmap_key_type = {
 	.match       = user_match,
 };
 
+static int
+id_rb_search_insert(struct rb_root *root, struct cifs_sid *sidptr,
+		struct cifs_sid_id **psidid, struct cifs_sid_id **epsidid)
+{
+	int rc = 1;
+	struct rb_node *node = root->rb_node;
+	struct rb_node *parent = NULL;
+	struct rb_node **linkto = &(root->rb_node);
+
+	while (node) {
+		*epsidid = rb_entry(node, struct cifs_sid_id, rbnode);
+		parent = node;
+		rc = compare_sids(sidptr, &((*epsidid)->sid));
+		if (rc > 0) {
+			linkto = &(node->rb_left);
+			node = node->rb_left;
+		} else if (rc < 0) {
+			linkto = &(node->rb_right);
+			node = node->rb_right;
+		} else { /* node found */
+			if (test_bit(SID_ID_UNMAPPED, &(*epsidid)->state) &&
+				!time_after((*epsidid)->retry + SID_MAP_RETRY,
+						jiffies)) {
+				/* retry mapping this unmapped SID */
+				if (!test_and_set_bit(SID_ID_PENDING,
+						&(*epsidid)->state))
+					return 1;
+			}
+			/*
+			 * Found a node with either SID mapped to an id
+			 * or a node with unmapped SID but somebody else
+			 * get to map it.
+			 */
+			return 0;
+		}
+	}
+	*epsidid = NULL;
+
+	if (rc) { /* node not found, rc is not 0 */
+		memcpy(&(*psidid)->sid, sidptr, sizeof(struct cifs_sid));
+		set_bit(SID_ID_PENDING, &(*psidid)->state);
+		set_bit(SID_ID_UNMAPPED, &(*psidid)->state);
+
+		rb_link_node(&(*psidid)->rbnode, parent, linkto);
+		rb_insert_color(&(*psidid)->rbnode, root);
+	}
+
+	return rc;
+}
+
+static void
+sid_to_str(struct cifs_sid *sidptr, char *sidstr)
+{
+	int i;
+	unsigned long saval;
+	char *strptr;
+
+	strptr = sidstr;
+
+	sprintf(strptr, "%s", "S");
+	strptr = sidstr + strlen(sidstr);
+
+	sprintf(strptr, "-%d", sidptr->revision);
+	strptr = sidstr + strlen(sidstr);
+
+	for (i = 0; i < 6; ++i) {
+		if (sidptr->authority[i]) {
+			sprintf(strptr, "-%d", sidptr->authority[i]);
+			strptr = sidstr + strlen(sidstr);
+		}
+	}
+
+	for (i = 0; i < sidptr->num_subauth; ++i) {
+		saval = le32_to_cpu(sidptr->sub_auth[i]);
+		sprintf(strptr, "-%ld", saval);
+		strptr = sidstr + strlen(sidstr);
+	}
+}
+
+static int
+cifs_sid_pending_wait(void *unused)
+{
+	schedule();
+	return signal_pending(current) ? -ERESTARTSYS : 0;
+}
+
+static int
+sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
+		struct cifs_fattr *fattr, uint sidtype)
+{
+	int rc;
+	unsigned long id;
+	char *strptr;
+	char *sidstr;
+	struct key *idkey;
+	const struct cred *saved_cred;
+	struct cifs_sid_id *psidid;
+	struct cifs_sid_id *epsidid = NULL;
+
+	if (sidtype != SIDOWNER && sidtype != SIDGROUP)
+		return -ENOENT;
+
+	psidid = kzalloc(sizeof(struct cifs_sid_id), GFP_KERNEL);
+	if (!psidid)
+		return -ENOMEM;
+
+	if (sidtype == SIDOWNER) {
+		id = cifs_sb->mnt_uid;
+		spin_lock(&siduidlock);
+		rc = id_rb_search_insert(&uidtree, psid, &psidid, &epsidid);
+		spin_unlock(&siduidlock);
+	} else {
+		id = cifs_sb->mnt_gid;
+		spin_lock(&sidgidlock);
+		rc = id_rb_search_insert(&gidtree, psid, &psidid, &epsidid);
+		spin_unlock(&sidgidlock);
+	}
+
+	if (!epsidid)
+		epsidid = psidid;
+	else
+		kfree(psidid);
+
+	if (rc) {
+		sidstr = kzalloc(SIDLEN, GFP_KERNEL);
+		if (!sidstr)
+			rc = -ENOMEM;
+
+		/*
+		 * either a new node was created or an existing node
+		 * does not have a SID mapped to an id, so make an upcall.
+		 */
+		if (sidtype == SIDOWNER)
+			sprintf(sidstr, "%s", "os:");
+		else if (sidtype == SIDGROUP)
+			sprintf(sidstr, "%s", "gs:");
+
+		strptr = sidstr + strlen(sidstr);
+		sid_to_str(psid, strptr);
+
+		saved_cred = override_creds(root_cred);
+		idkey = request_key(&cifs_idmap_key_type, sidstr, "");
+		if (IS_ERR(idkey))
+			cFYI(1, "%s: Can't map SID to an id", __func__);
+		else {
+			id = *(unsigned long *)idkey->payload.value;
+			key_put(idkey);
+			clear_bit(SID_ID_UNMAPPED, &psidid->state);
+		}
+		epsidid->time = jiffies;
+		epsidid->retry = jiffies;
+		epsidid->id = id;
+		clear_bit(SID_ID_PENDING, &epsidid->state);
+		revert_creds(saved_cred);
+		kfree(sidstr);
+		rc = 0;
+	} else {
+		/*
+		 * eitehr an existing node with SID mapped or a node for
+		 * whom its SID is being mapped (in which case, wait).
+		 */
+		rc = wait_on_bit(&epsidid->state, SID_ID_PENDING,
+				cifs_sid_pending_wait, TASK_INTERRUPTIBLE);
+		if (rc) {
+			cERROR(1, "%s: cifs_sid_pending_wait interrupted %d",
+					__func__, rc);
+			return rc;
+		}
+
+		/*
+		 * No point in checking whether state has bit SID_ID_UNMAPPED
+		 * set. If SID_ID_UNMAPPED state bit is not set, upcall must
+		 * have returned an error.  No point in making an upcall here
+		 * again right away, it is likely to fail.
+		 */
+		id = epsidid->id;
+	}
+
+	if (sidtype == SIDOWNER)
+		fattr->cf_uid = id;
+	else
+		fattr->cf_gid = id;
+
+	return 0;
+}
+
 int
 init_cifs_idmap(void)
 {
@@ -242,16 +463,24 @@ int compare_sids(const struct cifs_sid *ctsid, const struct cifs_sid *cwsid)
 	int num_subauth, num_sat, num_saw;
 
 	if ((!ctsid) || (!cwsid))
-		return 0;
+		return 1;
 
 	/* compare the revision */
-	if (ctsid->revision != cwsid->revision)
-		return 0;
+	if (ctsid->revision != cwsid->revision) {
+		if (ctsid->revision > cwsid->revision)
+			return 1;
+		else
+			return -1;
+	}
 
 	/* compare all of the six auth values */
 	for (i = 0; i < 6; ++i) {
-		if (ctsid->authority[i] != cwsid->authority[i])
-			return 0;
+		if (ctsid->authority[i] != cwsid->authority[i]) {
+			if (ctsid->authority[i] > cwsid->authority[i])
+				return 1;
+			else
+				return -1;
+		}
 	}
 
 	/* compare all of the subauth values if any */
@@ -260,12 +489,16 @@ int compare_sids(const struct cifs_sid *ctsid, const struct cifs_sid *cwsid)
 	num_subauth = num_sat < num_saw ? num_sat : num_saw;
 	if (num_subauth) {
 		for (i = 0; i < num_subauth; ++i) {
-			if (ctsid->sub_auth[i] != cwsid->sub_auth[i])
-				return 0;
+			if (ctsid->sub_auth[i] != cwsid->sub_auth[i]) {
+				if (ctsid->sub_auth[i] > cwsid->sub_auth[i])
+					return 1;
+				else
+					return -1;
+			}
 		}
 	}
 
-	return 1; /* sids compare/match */
+	return 0; /* sids compare/match */
 }
 
 
@@ -520,22 +753,22 @@ static void parse_dacl(struct cifs_acl *pdacl, char *end_of_acl,
 #ifdef CONFIG_CIFS_DEBUG2
 			dump_ace(ppace[i], end_of_acl);
 #endif
-			if (compare_sids(&(ppace[i]->sid), pownersid))
+			if (compare_sids(&(ppace[i]->sid), pownersid) == 0)
 				access_flags_to_mode(ppace[i]->access_req,
 						     ppace[i]->type,
 						     &fattr->cf_mode,
 						     &user_mask);
-			if (compare_sids(&(ppace[i]->sid), pgrpsid))
+			if (compare_sids(&(ppace[i]->sid), pgrpsid) == 0)
 				access_flags_to_mode(ppace[i]->access_req,
 						     ppace[i]->type,
 						     &fattr->cf_mode,
 						     &group_mask);
-			if (compare_sids(&(ppace[i]->sid), &sid_everyone))
+			if (compare_sids(&(ppace[i]->sid), &sid_everyone) == 0)
 				access_flags_to_mode(ppace[i]->access_req,
 						     ppace[i]->type,
 						     &fattr->cf_mode,
 						     &other_mask);
-			if (compare_sids(&(ppace[i]->sid), &sid_authusers))
+			if (compare_sids(&(ppace[i]->sid), &sid_authusers) == 0)
 				access_flags_to_mode(ppace[i]->access_req,
 						     ppace[i]->type,
 						     &fattr->cf_mode,
@@ -613,10 +846,10 @@ static int parse_sid(struct cifs_sid *psid, char *end_of_acl)
 
 
 /* Convert CIFS ACL to POSIX form */
-static int parse_sec_desc(struct cifs_ntsd *pntsd, int acl_len,
-			  struct cifs_fattr *fattr)
+static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
+		struct cifs_ntsd *pntsd, int acl_len, struct cifs_fattr *fattr)
 {
-	int rc;
+	int rc = 0;
 	struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
 	struct cifs_acl *dacl_ptr; /* no need for SACL ptr */
 	char *end_of_acl = ((char *)pntsd) + acl_len;
@@ -638,12 +871,26 @@ static int parse_sec_desc(struct cifs_ntsd *pntsd, int acl_len,
 		 le32_to_cpu(pntsd->sacloffset), dacloffset);
 /*	cifs_dump_mem("owner_sid: ", owner_sid_ptr, 64); */
 	rc = parse_sid(owner_sid_ptr, end_of_acl);
-	if (rc)
+	if (rc) {
+		cFYI(1, "%s: Error %d parsing Owner SID", __func__, rc);
+		return rc;
+	}
+	rc = sid_to_id(cifs_sb, owner_sid_ptr, fattr, SIDOWNER);
+	if (rc) {
+		cFYI(1, "%s: Error %d mapping Owner SID to uid", __func__, rc);
 		return rc;
+	}
 
 	rc = parse_sid(group_sid_ptr, end_of_acl);
-	if (rc)
+	if (rc) {
+		cFYI(1, "%s: Error %d mapping Owner SID to gid", __func__, rc);
 		return rc;
+	}
+	rc = sid_to_id(cifs_sb, group_sid_ptr, fattr, SIDGROUP);
+	if (rc) {
+		cFYI(1, "%s: Error %d mapping Group SID to gid", __func__, rc);
+		return rc;
+	}
 
 	if (dacloffset)
 		parse_dacl(dacl_ptr, end_of_acl, owner_sid_ptr,
@@ -658,7 +905,7 @@ static int parse_sec_desc(struct cifs_ntsd *pntsd, int acl_len,
 	memcpy((void *)(&(cifscred->gsid)), (void *)group_sid_ptr,
 			sizeof(struct cifs_sid)); */
 
-	return 0;
+	return rc;
 }
 
 
@@ -865,7 +1112,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
 		rc = PTR_ERR(pntsd);
 		cERROR(1, "%s: error %d getting sec desc", __func__, rc);
 	} else {
-		rc = parse_sec_desc(pntsd, acllen, fattr);
+		rc = parse_sec_desc(cifs_sb, pntsd, acllen, fattr);
 		kfree(pntsd);
 		if (rc)
 			cERROR(1, "parse sec desc failed rc = %d", rc);
diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
index 025e943..5f075c0 100644
--- a/fs/cifs/cifsacl.h
+++ b/fs/cifs/cifsacl.h
@@ -39,6 +39,15 @@
 #define ACCESS_ALLOWED	0
 #define ACCESS_DENIED	1
 
+#define SIDOWNER 1
+#define SIDGROUP 2
+#define SIDLEN 150 /* S- 1 revision- 6 authorities- max 5 sub authorities */
+
+#define SID_ID_PENDING 0
+#define SID_ID_UNMAPPED 1
+#define SID_MAP_EXPIRE 1000 /* enough for an upcall to return? */
+#define SID_MAP_RETRY 100 /* retry mapping in case prior attempt failed */
+
 struct cifs_ntsd {
 	__le16 revision; /* revision level */
 	__le16 type;
@@ -74,6 +83,20 @@ struct cifs_wksid {
 	char sidname[SIDNAMELENGTH];
 } __attribute__((packed));
 
+struct cifs_sid_id {
+	struct rb_node rbnode;
+	struct cifs_sid sid;
+	unsigned long state;
+	unsigned long id;
+	unsigned long time;
+	unsigned long retry;
+};
+
+#ifdef __KERNEL__
+extern struct key_type cifs_idmap_key_type;
+extern const struct cred *root_cred;
+#endif /* KERNEL */
+
 extern int match_sid(struct cifs_sid *);
 extern int compare_sids(const struct cifs_sid *, const struct cifs_sid *);
 
-- 
1.6.0.2
