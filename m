From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/2] cifs: Add data structures and functions for uid/gid to SID mapping
Date: Fri, 17 Jun 2011 18:37:01 -0500
Message-ID: <1308353821-8750-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Add data structures and functions necessary to map a uid and gid to SID.
These functions are very similar to the ones used to map a SID to uid and gid.

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsacl.c  |  198 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsglob.h |    4 +
 2 files changed, 202 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 21de1d6..6f72ea6 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -91,9 +91,76 @@ cifs_idmap_shrinker(struct shrinker *shrink, struct shrink_control *sc)
 	shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
 	spin_unlock(&sidgidlock);
 
+	root = &siduidtree;
+	spin_lock(&uidsidlock);
+	shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
+	spin_unlock(&uidsidlock);
+
+	root = &sidgidtree;
+	spin_lock(&gidsidlock);
+	shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
+	spin_unlock(&gidsidlock);
+
 	return nr_rem;
 }
 
+static void
+sid_rb_insert(struct rb_root *root, unsigned long cid,
+		struct cifs_sid_id **psidid, char *typestr)
+{
+	char *strptr;
+	struct rb_node *node = root->rb_node;
+	struct rb_node *parent = NULL;
+	struct rb_node **linkto = &(root->rb_node);
+	struct cifs_sid_id *lsidid;
+
+	while (node) {
+		lsidid = rb_entry(node, struct cifs_sid_id, rbnode);
+		parent = node;
+		if (cid > lsidid->id) {
+			linkto = &(node->rb_left);
+			node = node->rb_left;
+		}
+		if (cid < lsidid->id) {
+			linkto = &(node->rb_right);
+			node = node->rb_right;
+		}
+	}
+
+	(*psidid)->id = cid;
+	(*psidid)->time = jiffies - (SID_MAP_RETRY + 1);
+	(*psidid)->refcount = 0;
+
+	sprintf((*psidid)->sidstr, "%s", typestr);
+	strptr = (*psidid)->sidstr + strlen((*psidid)->sidstr);
+	sprintf(strptr, "%ld", cid);
+
+	clear_bit(SID_ID_PENDING, &(*psidid)->state);
+	clear_bit(SID_ID_MAPPED, &(*psidid)->state);
+
+	rb_link_node(&(*psidid)->rbnode, parent, linkto);
+	rb_insert_color(&(*psidid)->rbnode, root);
+}
+
+static struct cifs_sid_id *
+sid_rb_search(struct rb_root *root, unsigned long cid)
+{
+	struct rb_node *node = root->rb_node;
+	struct cifs_sid_id *lsidid;
+
+	while (node) {
+		lsidid = rb_entry(node, struct cifs_sid_id, rbnode);
+		if (cid > lsidid->id)
+			node = node->rb_left;
+		else if (cid < lsidid->id)
+			node = node->rb_right;
+		else /* node found */
+			return lsidid;
+	}
+
+	return NULL;
+}
+
 static struct shrinker cifs_shrinker = {
 	.shrink = cifs_idmap_shrinker,
 	.seeks = DEFAULT_SEEKS,
@@ -110,6 +177,7 @@ cifs_idmap_key_instantiate(struct key *key, const void *data, size_t datalen)
 
 	memcpy(payload, data, datalen);
 	key->payload.data = payload;
+	key->datalen = datalen;
 	return 0;
 }
 
@@ -224,6 +292,120 @@ sidid_pending_wait(void *unused)
 }
 
 static int
+id_to_sid(unsigned long cid, uint sidtype, struct cifs_sid *ssid)
+{
+	int rc = 0;
+	struct key *sidkey;
+	const struct cred *saved_cred;
+	struct cifs_sid *lsid;
+	struct cifs_sid_id *psidid, *npsidid;
+	struct rb_root *cidtree;
+	spinlock_t *cidlock;
+
+	if (sidtype == SIDOWNER) {
+		cidlock = &siduidlock;
+		cidtree = &uidtree;
+	} else if (sidtype == SIDGROUP) {
+		cidlock = &sidgidlock;
+		cidtree = &gidtree;
+	} else
+		return -ENOENT;
+
+	spin_lock(cidlock);
+	psidid = sid_rb_search(cidtree, cid);
+
+	if (!psidid) { /* node does not exist, allocate one & attempt adding */
+		spin_unlock(cidlock);
+		npsidid = kzalloc(sizeof(struct cifs_sid_id), GFP_KERNEL);
+		if (!npsidid)
+			return -ENOMEM;
+
+		npsidid->sidstr = kmalloc(SIDLEN, GFP_KERNEL);
+		if (!npsidid->sidstr) {
+			kfree(npsidid);
+			return -ENOMEM;
+		}
+
+		spin_lock(cidlock);
+		psidid = sid_rb_search(cidtree, cid);
+		if (psidid) { /* node happened to get inserted meanwhile */
+			++psidid->refcount;
+			spin_unlock(cidlock);
+			kfree(npsidid->sidstr);
+			kfree(npsidid);
+		} else {
+			psidid = npsidid;
+			sid_rb_insert(cidtree, cid, &psidid,
+					sidtype == SIDOWNER ? "oi:" : "gi:");
+			++psidid->refcount;
+			spin_unlock(cidlock);
+		}
+	} else {
+		++psidid->refcount;
+		spin_unlock(cidlock);
+	}
+
+	/*
+	 * If we are here, it is safe to access psidid and its fields
+	 * since a reference was taken earlier while holding the spinlock.
+	 * A reference on the node is put without holding the spinlock
+	 * and it is OK to do so in this case, shrinker will not erase
+	 * this node until all references are put and we do not access
+	 * any fields of the node after a reference is put .
+	 */
+	if (test_bit(SID_ID_MAPPED, &psidid->state)) {
+		memcpy(ssid, &psidid->sid, sizeof(struct cifs_sid));
+		psidid->time = jiffies; /* update ts for accessing */
+		goto id_sid_out;
+	}
+
+	if (time_after(psidid->time + SID_MAP_RETRY, jiffies)) {
+		rc = -ENOENT;
+		goto id_sid_out;
+	}
+
+	if (!test_and_set_bit(SID_ID_PENDING, &psidid->state)) {
+		saved_cred = override_creds(root_cred);
+		sidkey = request_key(&cifs_idmap_key_type, psidid->sidstr, "");
+		if (IS_ERR(sidkey)) {
+			rc = -ENOENT;
+			cFYI(1, "%s: Can't map and id to a SID", __func__);
+		} else {
+			lsid = (struct cifs_sid *)sidkey->payload.data;
+			memcpy(&psidid->sid, lsid,
+				sidkey->datalen < sizeof(struct cifs_sid) ?
+				sidkey->datalen : sizeof(struct cifs_sid));
+			memcpy(ssid, &psidid->sid,
+				sidkey->datalen < sizeof(struct cifs_sid) ?
+				sidkey->datalen : sizeof(struct cifs_sid));
+			set_bit(SID_ID_MAPPED, &psidid->state);
+			key_put(sidkey);
+			kfree(psidid->sidstr);
+		}
+		psidid->time = jiffies; /* update ts for accessing */
+		revert_creds(saved_cred);
+		clear_bit(SID_ID_PENDING, &psidid->state);
+		wake_up_bit(&psidid->state, SID_ID_PENDING);
+	} else {
+		rc = wait_on_bit(&psidid->state, SID_ID_PENDING,
+				sidid_pending_wait, TASK_INTERRUPTIBLE);
+		if (rc) {
+			cFYI(1, "%s: sidid_pending_wait interrupted %d",
+					__func__, rc);
+			--psidid->refcount;
+			return rc;
+		}
+		if (test_bit(SID_ID_MAPPED, &psidid->state))
+			memcpy(ssid, &psidid->sid, sizeof(struct cifs_sid));
+		else
+			rc = -ENOENT;
+	}
+id_sid_out:
+	--psidid->refcount;
+	return rc;
+}
+
+static int
 sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 		struct cifs_fattr *fattr, uint sidtype)
 {
@@ -383,6 +565,10 @@ init_cifs_idmap(void)
 	spin_lock_init(&sidgidlock);
 	gidtree = RB_ROOT;
 
+	spin_lock_init(&uidsidlock);
+	siduidtree = RB_ROOT;
+	spin_lock_init(&gidsidlock);
+	sidgidtree = RB_ROOT;
 	register_shrinker(&cifs_shrinker);
 
 	cFYI(1, "cifs idmap keyring: %d\n", key_serial(keyring));
@@ -422,6 +608,18 @@ cifs_destroy_idmaptrees(void)
 	while ((node = rb_first(root)))
 		rb_erase(node, root);
 	spin_unlock(&sidgidlock);
+
+	root = &siduidtree;
+	spin_lock(&uidsidlock);
+	while ((node = rb_first(root)))
+		rb_erase(node, root);
+	spin_unlock(&uidsidlock);
+
+	root = &sidgidtree;
+	spin_lock(&gidsidlock);
+	while ((node = rb_first(root)))
+		rb_erase(node, root);
+	spin_unlock(&gidsidlock);
 }
 
 /* if the two SIDs (roughly equivalent to a UUID for a user or group) are
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 6255fa8..6b5e4a5 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -940,6 +940,10 @@ GLOBAL_EXTERN struct rb_root uidtree;
 GLOBAL_EXTERN struct rb_root gidtree;
 GLOBAL_EXTERN spinlock_t siduidlock;
 GLOBAL_EXTERN spinlock_t sidgidlock;
+GLOBAL_EXTERN struct rb_root siduidtree;
+GLOBAL_EXTERN struct rb_root sidgidtree;
+GLOBAL_EXTERN spinlock_t uidsidlock;
+GLOBAL_EXTERN spinlock_t gidsidlock;
 
 void cifs_oplock_break(struct work_struct *work);
 void cifs_oplock_break_get(struct cifsFileInfo *cfile);
-- 
1.6.0.2
