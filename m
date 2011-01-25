From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Invoke id mapping functions
Date: Tue, 25 Jan 2011 16:36:29 -0600
Message-ID: <1295994989-8741-1-git-send-email-shirishpargaonkar@gmail.com>
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
If found in a tree, a (mapped) id from that node is assigned to
uid or gid as appropriated.

Otherwise, the SID is mapped and looked-up with the help of
Winbind via upcall mechanism and a node with mapping is inserted
in one of the caches while again making sure that the node does not exist.

To map a SID, which can be either a Owner SID or a Group SID, key
description starts with the string "os" or "gs" followed by SID converted
to a string. Without "os" or "gs", cifs.upcall does not know whether
SID needs to be mapped to either an uid or a gid.

For now, cifs.upcall is only used to map a SID to an id (uid or gid) but
it would be used to obtain an SID (string) for an id.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsacl.c |  213 ++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/cifs/cifsacl.h |   15 ++++
 2 files changed, 211 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index b165496..2b5294d 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -99,6 +99,159 @@ struct key_type cifs_idmap_key_type = {
 	.match       = user_match,
 };
 
+static unsigned long
+id_rb_search(struct rb_root *root, struct cifs_sid *sidptr)
+{
+	unsigned int nds = 0;
+	int rc;
+	unsigned long id = 0;
+	struct rb_node *node = root->rb_node;
+	struct cifs_sid_id *sididptr;
+
+	while (node) {
+		++nds;
+		sididptr = rb_entry(node, struct cifs_sid_id, rbnode);
+		rc = compare_sids(sidptr, &sididptr->sid);
+		if (rc > 0)
+			node = node->rb_left;
+		else if (rc < 0)
+			node = node->rb_right;
+		else {
+			id = sididptr->id;
+			break;
+		}
+	}
+
+	return id;
+}
+
+static void
+id_rb_insert(struct rb_root *root, struct cifs_sid_id *new_sididptr,
+		unsigned long id)
+{
+	int rc;
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+	struct cifs_sid_id *sididptr;
+
+	while (*new) {
+		sididptr = rb_entry(*new, struct cifs_sid_id, rbnode);
+		parent = *new;
+
+		rc = compare_sids(&sididptr->sid, &new_sididptr->sid);
+		if (rc < 0)
+			new = &((*new)->rb_left);
+		if (rc > 0)
+			new = &((*new)->rb_right);
+		else {
+			kfree(new_sididptr);
+			return;
+		}
+	}
+
+	rb_link_node(&new_sididptr->rbnode, parent, new);
+	rb_insert_color(&new_sididptr->rbnode, root);
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
+sid_to_id(struct cifs_sid *psid, struct cifs_fattr *fattr, uint sidtype)
+{
+	int rc = 0;
+	unsigned long id;
+	char *sidstr, *strptr;
+	struct key *idkey;
+	const struct cred *saved_cred;
+	struct cifs_sid_id *sididptr;
+
+	if (sidtype == SIDOWNER) {
+		spin_lock(&siduidlock);
+		id = id_rb_search(&uidtree, psid);
+		spin_unlock(&siduidlock);
+	} else if (sidtype == SIDGROUP) {
+		spin_lock(&sidgidlock);
+		id = id_rb_search(&gidtree, psid);
+		spin_unlock(&sidgidlock);
+	} else
+		return -ENOENT;
+
+	if (!id) {
+		sidstr = kzalloc(SIDLEN, GFP_KERNEL);
+		if (!sidstr)
+			return -ENOMEM;
+
+		sididptr = kzalloc(sizeof(struct cifs_sid_id), GFP_KERNEL);
+		if (!sididptr) {
+			kfree(sidstr);
+			return -ENOMEM;
+		}
+
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
+			cFYI(1, "%s: Can't resolve SID to an uid", __func__);
+		else {
+			id = *(unsigned long *)idkey->payload.value;
+			key_put(idkey);
+			memcpy(&sididptr->sid, psid, sizeof(struct cifs_sid));
+			sididptr->id = id;
+			if (sidtype == SIDOWNER) {
+				spin_lock(&siduidlock);
+				id_rb_insert(&uidtree, sididptr, id);
+				spin_unlock(&siduidlock);
+			} else {
+				spin_lock(&sidgidlock);
+				id_rb_insert(&gidtree, sididptr, id);
+				spin_unlock(&sidgidlock);
+			}
+		}
+		revert_creds(saved_cred);
+		kfree(sidstr);
+	}
+
+	if (sidtype == SIDOWNER)
+		fattr->cf_uid = id;
+	else
+		fattr->cf_gid = id;
+
+	return rc;
+}
+
 int
 init_cifs_idmap(void)
 {
@@ -240,16 +393,24 @@ int compare_sids(const struct cifs_sid *ctsid, const struct cifs_sid *cwsid)
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
@@ -258,12 +419,16 @@ int compare_sids(const struct cifs_sid *ctsid, const struct cifs_sid *cwsid)
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
 
 
@@ -514,22 +679,22 @@ static void parse_dacl(struct cifs_acl *pdacl, char *end_of_acl,
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
@@ -608,9 +773,9 @@ static int parse_sid(struct cifs_sid *psid, char *end_of_acl)
 
 /* Convert CIFS ACL to POSIX form */
 static int parse_sec_desc(struct cifs_ntsd *pntsd, int acl_len,
-			  struct cifs_fattr *fattr)
+			struct cifs_fattr *fattr)
 {
-	int rc;
+	int rc = 0;
 	struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
 	struct cifs_acl *dacl_ptr; /* no need for SACL ptr */
 	char *end_of_acl = ((char *)pntsd) + acl_len;
@@ -632,12 +797,26 @@ static int parse_sec_desc(struct cifs_ntsd *pntsd, int acl_len,
 		 le32_to_cpu(pntsd->sacloffset), dacloffset);
 /*	cifs_dump_mem("owner_sid: ", owner_sid_ptr, 64); */
 	rc = parse_sid(owner_sid_ptr, end_of_acl);
-	if (rc)
+	if (rc) {
+		cFYI(1, "%s: Error %d parsing Owner SID", __func__, rc);
+		return rc;
+	}
+	rc = sid_to_id(owner_sid_ptr, fattr, SIDOWNER);
+	if (rc) {
+		cFYI(1, "%s: Error %d mapping Owner SID to uid", __func__, rc);
 		return rc;
+	}
 
 	rc = parse_sid(group_sid_ptr, end_of_acl);
-	if (rc)
+	if (rc) {
+		cFYI(1, "%s: Error %d mapping Owner SID to uid", __func__, rc);
+		return rc;
+	}
+	rc = sid_to_id(group_sid_ptr, fattr, SIDGROUP);
+	if (rc) {
+		cFYI(1, "%s: Error %d mapping Group SID to uid", __func__, rc);
 		return rc;
+	}
 
 	if (dacloffset)
 		parse_dacl(dacl_ptr, end_of_acl, owner_sid_ptr,
@@ -652,7 +831,7 @@ static int parse_sec_desc(struct cifs_ntsd *pntsd, int acl_len,
 	memcpy((void *)(&(cifscred->gsid)), (void *)group_sid_ptr,
 			sizeof(struct cifs_sid)); */
 
-	return 0;
+	return rc;
 }
 
 
diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
index c4ae7d0..d103ad3 100644
--- a/fs/cifs/cifsacl.h
+++ b/fs/cifs/cifsacl.h
@@ -39,6 +39,10 @@
 #define ACCESS_ALLOWED	0
 #define ACCESS_DENIED	1
 
+#define SIDOWNER 1
+#define SIDGROUP 2
+#define SIDLEN 150 /* S- 1 revision- 6 authorities- max 5 sub authorities */
+
 struct cifs_ntsd {
 	__le16 revision; /* revision level */
 	__le16 type;
@@ -74,6 +78,17 @@ struct cifs_wksid {
 	char sidname[SIDNAMELENGTH];
 } __attribute__((packed));
 
+struct cifs_sid_id {
+	struct rb_node rbnode;
+	struct cifs_sid sid;
+	unsigned long id;
+} __attribute__((packed));
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
