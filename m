From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/7] cifs: simplify id_to_sid and sid_to_id mapping code
Date: Wed, 17 Oct 2012 14:09:01 -0400
Message-ID: <1350497343-7155-6-git-send-email-jlayton@redhat.com>
References: <1350497343-7155-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350497343-7155-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The cifs.idmap handling code currently causes the kernel to cache the
data from userspace twice. It first looks in a rbtree to see if there is
a matching entry for the given id. If there isn't then it calls
request_key which then checks its cache and then calls out to userland
if it doesn't have one. If the userland program establishes a mapping
and downcalls with that info, it then gets cached in the keyring and in
this rbtree.

Aside from the double memory usage and the performance penalty in doing
all of these extra copies, there are some nasty bugs in here too. The
code declares four rbtrees and spinlocks to protect them, but only seems
to use two of them. The upshot is that the same tree is used to hold
(eg) uid:sid and sid:uid mappings. The comparitors aren't equipped to
deal with that.

I think we'd be best off to remove a layer of caching in this code. If
this was originally done for performance reasons, then that really seems
like a premature optimization.

This patch does that -- it removes the rbtrees and the locks that
protect them and simply has the code do a request_key call on each call
into sid_to_id and id_to_sid. This greatly simplifies this code and
should roughly halve the memory utilization from using the idmapping
code.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsacl.c   | 535 +++++++++-------------------------------------------
 fs/cifs/cifsacl.h   |  23 +--
 fs/cifs/cifsfs.c    |   1 -
 fs/cifs/cifsproto.h |   1 -
 4 files changed, 99 insertions(+), 461 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 42b3fe9..f4508ee 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -44,128 +44,6 @@ static const struct cifs_sid sid_user = {1, 2 , {0, 0, 0, 0, 0, 5}, {} };
 
 static const struct cred *root_cred;
 
-static void
-shrink_idmap_tree(struct rb_root *root, int nr_to_scan, int *nr_rem,
-			int *nr_del)
-{
-	struct rb_node *node;
-	struct rb_node *tmp;
-	struct cifs_sid_id *psidid;
-
-	node = rb_first(root);
-	while (node) {
-		tmp = node;
-		node = rb_next(tmp);
-		psidid = rb_entry(tmp, struct cifs_sid_id, rbnode);
-		if (nr_to_scan == 0 || *nr_del == nr_to_scan)
-			++(*nr_rem);
-		else {
-			if (time_after(jiffies, psidid->time + SID_MAP_EXPIRE)
-						&& psidid->refcount == 0) {
-				rb_erase(tmp, root);
-				++(*nr_del);
-			} else
-				++(*nr_rem);
-		}
-	}
-}
-
-/*
- * Run idmap cache shrinker.
- */
-static int
-cifs_idmap_shrinker(struct shrinker *shrink, struct shrink_control *sc)
-{
-	int nr_to_scan = sc->nr_to_scan;
-	int nr_del = 0;
-	int nr_rem = 0;
-	struct rb_root *root;
-
-	root = &uidtree;
-	spin_lock(&siduidlock);
-	shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
-	spin_unlock(&siduidlock);
-
-	root = &gidtree;
-	spin_lock(&sidgidlock);
-	shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
-	spin_unlock(&sidgidlock);
-
-	root = &siduidtree;
-	spin_lock(&uidsidlock);
-	shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
-	spin_unlock(&uidsidlock);
-
-	root = &sidgidtree;
-	spin_lock(&gidsidlock);
-	shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
-	spin_unlock(&gidsidlock);
-
-	return nr_rem;
-}
-
-static void
-sid_rb_insert(struct rb_root *root, unsigned long cid,
-		struct cifs_sid_id **psidid, char *typestr)
-{
-	char *strptr;
-	struct rb_node *node = root->rb_node;
-	struct rb_node *parent = NULL;
-	struct rb_node **linkto = &(root->rb_node);
-	struct cifs_sid_id *lsidid;
-
-	while (node) {
-		lsidid = rb_entry(node, struct cifs_sid_id, rbnode);
-		parent = node;
-		if (cid > lsidid->id) {
-			linkto = &(node->rb_left);
-			node = node->rb_left;
-		}
-		if (cid < lsidid->id) {
-			linkto = &(node->rb_right);
-			node = node->rb_right;
-		}
-	}
-
-	(*psidid)->id = cid;
-	(*psidid)->time = jiffies - (SID_MAP_RETRY + 1);
-	(*psidid)->refcount = 0;
-
-	sprintf((*psidid)->sidstr, "%s", typestr);
-	strptr = (*psidid)->sidstr + strlen((*psidid)->sidstr);
-	sprintf(strptr, "%ld", cid);
-
-	clear_bit(SID_ID_PENDING, &(*psidid)->state);
-	clear_bit(SID_ID_MAPPED, &(*psidid)->state);
-
-	rb_link_node(&(*psidid)->rbnode, parent, linkto);
-	rb_insert_color(&(*psidid)->rbnode, root);
-}
-
-static struct cifs_sid_id *
-sid_rb_search(struct rb_root *root, unsigned long cid)
-{
-	struct rb_node *node = root->rb_node;
-	struct cifs_sid_id *lsidid;
-
-	while (node) {
-		lsidid = rb_entry(node, struct cifs_sid_id, rbnode);
-		if (cid > lsidid->id)
-			node = node->rb_left;
-		else if (cid < lsidid->id)
-			node = node->rb_right;
-		else /* node found */
-			return lsidid;
-	}
-
-	return NULL;
-}
-
-static struct shrinker cifs_shrinker = {
-	.shrink = cifs_idmap_shrinker,
-	.seeks = DEFAULT_SEEKS,
-};
-
 static int
 cifs_idmap_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
 {
@@ -195,30 +73,39 @@ static struct key_type cifs_idmap_key_type = {
 	.match       = user_match,
 };
 
-static void
-sid_to_str(struct cifs_sid *sidptr, char *sidstr)
+static char *
+sid_to_key_str(struct cifs_sid *sidptr, unsigned int type)
 {
-	int i;
+	int i, len;
 	unsigned int saval;
-	char *strptr;
+	char *sidstr, *strptr;
 
-	strptr = sidstr;
+	/* 3 bytes for prefix */
+	sidstr = kmalloc(3 + SID_STRING_BASE_SIZE +
+			 (SID_STRING_SUBAUTH_SIZE * sidptr->num_subauth),
+			 GFP_KERNEL);
+	if (!sidstr)
+		return sidstr;
 
-	sprintf(strptr, "S-%hhu", sidptr->revision);
-	strptr = sidstr + strlen(sidstr);
+	strptr = sidstr;
+	len = sprintf(strptr, "%cs:S-%hhu", type == SIDOWNER ? 'o' : 'g',
+			sidptr->revision);
+	strptr += len;
 
 	for (i = 0; i < NUM_AUTHS; ++i) {
 		if (sidptr->authority[i]) {
-			sprintf(strptr, "-%hhu", sidptr->authority[i]);
-			strptr = sidstr + strlen(sidstr);
+			len = sprintf(strptr, "-%hhu", sidptr->authority[i]);
+			strptr += len;
 		}
 	}
 
 	for (i = 0; i < sidptr->num_subauth; ++i) {
 		saval = le32_to_cpu(sidptr->sub_auth[i]);
-		sprintf(strptr, "-%u", saval);
-		strptr = sidstr + strlen(sidstr);
+		len = sprintf(strptr, "-%u", saval);
+		strptr += len;
 	}
+
+	return sidstr;
 }
 
 /*
@@ -284,184 +171,38 @@ cifs_copy_sid(struct cifs_sid *dst, const struct cifs_sid *src)
 		dst->sub_auth[i] = src->sub_auth[i];
 }
 
-static void
-id_rb_insert(struct rb_root *root, struct cifs_sid *sidptr,
-		struct cifs_sid_id **psidid, char *typestr)
-{
-	int rc;
-	char *strptr;
-	struct rb_node *node = root->rb_node;
-	struct rb_node *parent = NULL;
-	struct rb_node **linkto = &(root->rb_node);
-	struct cifs_sid_id *lsidid;
-
-	while (node) {
-		lsidid = rb_entry(node, struct cifs_sid_id, rbnode);
-		parent = node;
-		rc = compare_sids(sidptr, &((lsidid)->sid));
-		if (rc > 0) {
-			linkto = &(node->rb_left);
-			node = node->rb_left;
-		} else if (rc < 0) {
-			linkto = &(node->rb_right);
-			node = node->rb_right;
-		}
-	}
-
-	cifs_copy_sid(&(*psidid)->sid, sidptr);
-	(*psidid)->time = jiffies - (SID_MAP_RETRY + 1);
-	(*psidid)->refcount = 0;
-
-	sprintf((*psidid)->sidstr, "%s", typestr);
-	strptr = (*psidid)->sidstr + strlen((*psidid)->sidstr);
-	sid_to_str(&(*psidid)->sid, strptr);
-
-	clear_bit(SID_ID_PENDING, &(*psidid)->state);
-	clear_bit(SID_ID_MAPPED, &(*psidid)->state);
-
-	rb_link_node(&(*psidid)->rbnode, parent, linkto);
-	rb_insert_color(&(*psidid)->rbnode, root);
-}
-
-static struct cifs_sid_id *
-id_rb_search(struct rb_root *root, struct cifs_sid *sidptr)
-{
-	int rc;
-	struct rb_node *node = root->rb_node;
-	struct cifs_sid_id *lsidid;
-
-	while (node) {
-		lsidid = rb_entry(node, struct cifs_sid_id, rbnode);
-		rc = compare_sids(sidptr, &((lsidid)->sid));
-		if (rc > 0) {
-			node = node->rb_left;
-		} else if (rc < 0) {
-			node = node->rb_right;
-		} else /* node found */
-			return lsidid;
-	}
-
-	return NULL;
-}
-
-static int
-sidid_pending_wait(void *unused)
-{
-	schedule();
-	return signal_pending(current) ? -ERESTARTSYS : 0;
-}
-
 static int
-id_to_sid(unsigned long cid, uint sidtype, struct cifs_sid *ssid)
+id_to_sid(unsigned int cid, uint sidtype, struct cifs_sid *ssid)
 {
-	int rc = 0;
+	int rc;
 	struct key *sidkey;
+	char desc[3 + 10 + 1]; /* 3 byte prefix + 10 bytes for value + NULL */
 	const struct cred *saved_cred;
-	struct cifs_sid *lsid;
-	struct cifs_sid_id *psidid, *npsidid;
-	struct rb_root *cidtree;
-	spinlock_t *cidlock;
-
-	if (sidtype == SIDOWNER) {
-		cidlock = &siduidlock;
-		cidtree = &uidtree;
-	} else if (sidtype == SIDGROUP) {
-		cidlock = &sidgidlock;
-		cidtree = &gidtree;
-	} else
-		return -EINVAL;
-
-	spin_lock(cidlock);
-	psidid = sid_rb_search(cidtree, cid);
-
-	if (!psidid) { /* node does not exist, allocate one & attempt adding */
-		spin_unlock(cidlock);
-		npsidid = kzalloc(sizeof(struct cifs_sid_id), GFP_KERNEL);
-		if (!npsidid)
-			return -ENOMEM;
-
-		npsidid->sidstr = kmalloc(SID_STRING_MAX, GFP_KERNEL);
-		if (!npsidid->sidstr) {
-			kfree(npsidid);
-			return -ENOMEM;
-		}
-
-		spin_lock(cidlock);
-		psidid = sid_rb_search(cidtree, cid);
-		if (psidid) { /* node happened to get inserted meanwhile */
-			++psidid->refcount;
-			spin_unlock(cidlock);
-			kfree(npsidid->sidstr);
-			kfree(npsidid);
-		} else {
-			psidid = npsidid;
-			sid_rb_insert(cidtree, cid, &psidid,
-					sidtype == SIDOWNER ? "oi:" : "gi:");
-			++psidid->refcount;
-			spin_unlock(cidlock);
-		}
-	} else {
-		++psidid->refcount;
-		spin_unlock(cidlock);
-	}
 
-	/*
-	 * If we are here, it is safe to access psidid and its fields
-	 * since a reference was taken earlier while holding the spinlock.
-	 * A reference on the node is put without holding the spinlock
-	 * and it is OK to do so in this case, shrinker will not erase
-	 * this node until all references are put and we do not access
-	 * any fields of the node after a reference is put .
-	 */
-	if (test_bit(SID_ID_MAPPED, &psidid->state)) {
-		cifs_copy_sid(ssid, &psidid->sid);
-		psidid->time = jiffies; /* update ts for accessing */
-		goto id_sid_out;
-	}
+	rc = snprintf(desc, sizeof(desc), "%ci:%u",
+			sidtype == SIDOWNER ? 'o' : 'g', cid);
+	if (rc >= sizeof(desc))
+		return -EINVAL;
 
-	if (time_after(psidid->time + SID_MAP_RETRY, jiffies)) {
+	rc = 0;
+	saved_cred = override_creds(root_cred);
+	sidkey = request_key(&cifs_idmap_key_type, desc, "");
+	if (IS_ERR(sidkey)) {
 		rc = -EINVAL;
-		goto id_sid_out;
-	}
-
-	if (!test_and_set_bit(SID_ID_PENDING, &psidid->state)) {
-		saved_cred = override_creds(root_cred);
-		sidkey = request_key(&cifs_idmap_key_type, psidid->sidstr, "");
-		if (IS_ERR(sidkey)) {
-			rc = -EINVAL;
-			cFYI(1, "%s: Can't map and id to a SID", __func__);
-		} else if (sidkey->datalen < CIFS_SID_BASE_SIZE) {
-			rc = -EIO;
-			cFYI(1, "%s: Downcall contained malformed key "
-				"(datalen=%hu)", __func__, sidkey->datalen);
-		} else {
-			lsid = (struct cifs_sid *)sidkey->payload.data;
-			cifs_copy_sid(&psidid->sid, lsid);
-			cifs_copy_sid(ssid, &psidid->sid);
-			set_bit(SID_ID_MAPPED, &psidid->state);
-			key_put(sidkey);
-			kfree(psidid->sidstr);
-		}
-		psidid->time = jiffies; /* update ts for accessing */
-		revert_creds(saved_cred);
-		clear_bit(SID_ID_PENDING, &psidid->state);
-		wake_up_bit(&psidid->state, SID_ID_PENDING);
-	} else {
-		rc = wait_on_bit(&psidid->state, SID_ID_PENDING,
-				sidid_pending_wait, TASK_INTERRUPTIBLE);
-		if (rc) {
-			cFYI(1, "%s: sidid_pending_wait interrupted %d",
-					__func__, rc);
-			--psidid->refcount;
-			return rc;
-		}
-		if (test_bit(SID_ID_MAPPED, &psidid->state))
-			cifs_copy_sid(ssid, &psidid->sid);
-		else
-			rc = -EINVAL;
-	}
-id_sid_out:
-	--psidid->refcount;
+		cFYI(1, "%s: Can't map %cid %u to a SID", __func__,
+			sidtype == SIDOWNER ? 'u' : 'g', cid);
+		goto out_revert_creds;
+	} else if (sidkey->datalen < CIFS_SID_BASE_SIZE) {
+		rc = -EIO;
+		cFYI(1, "%s: Downcall contained malformed key "
+			"(datalen=%hu)", __func__, sidkey->datalen);
+		goto out_key_put;
+	}
+	cifs_copy_sid(ssid, (struct cifs_sid *)sidkey->payload.data);
+out_key_put:
+	key_put(sidkey);
+out_revert_creds:
+	revert_creds(saved_cred);
 	return rc;
 }
 
@@ -470,111 +211,66 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 		struct cifs_fattr *fattr, uint sidtype)
 {
 	int rc;
-	unsigned long cid;
-	struct key *idkey;
+	struct key *sidkey;
+	char *sidstr;
 	const struct cred *saved_cred;
-	struct cifs_sid_id *psidid, *npsidid;
-	struct rb_root *cidtree;
-	spinlock_t *cidlock;
-
-	if (sidtype == SIDOWNER) {
-		cid = cifs_sb->mnt_uid; /* default uid, in case upcall fails */
-		cidlock = &siduidlock;
-		cidtree = &uidtree;
-	} else if (sidtype == SIDGROUP) {
-		cid = cifs_sb->mnt_gid; /* default gid, in case upcall fails */
-		cidlock = &sidgidlock;
-		cidtree = &gidtree;
-	} else
-		return -ENOENT;
-
-	spin_lock(cidlock);
-	psidid = id_rb_search(cidtree, psid);
-
-	if (!psidid) { /* node does not exist, allocate one & attempt adding */
-		spin_unlock(cidlock);
-		npsidid = kzalloc(sizeof(struct cifs_sid_id), GFP_KERNEL);
-		if (!npsidid)
-			return -ENOMEM;
-
-		npsidid->sidstr = kmalloc(SID_STRING_MAX, GFP_KERNEL);
-		if (!npsidid->sidstr) {
-			kfree(npsidid);
-			return -ENOMEM;
-		}
-
-		spin_lock(cidlock);
-		psidid = id_rb_search(cidtree, psid);
-		if (psidid) { /* node happened to get inserted meanwhile */
-			++psidid->refcount;
-			spin_unlock(cidlock);
-			kfree(npsidid->sidstr);
-			kfree(npsidid);
-		} else {
-			psidid = npsidid;
-			id_rb_insert(cidtree, psid, &psidid,
-					sidtype == SIDOWNER ? "os:" : "gs:");
-			++psidid->refcount;
-			spin_unlock(cidlock);
-		}
-	} else {
-		++psidid->refcount;
-		spin_unlock(cidlock);
-	}
+	uid_t fuid = cifs_sb->mnt_uid;
+	gid_t fgid = cifs_sb->mnt_gid;
 
 	/*
-	 * If we are here, it is safe to access psidid and its fields
-	 * since a reference was taken earlier while holding the spinlock.
-	 * A reference on the node is put without holding the spinlock
-	 * and it is OK to do so in this case, shrinker will not erase
-	 * this node until all references are put and we do not access
-	 * any fields of the node after a reference is put .
+	 * If we have too many subauthorities, then something is really wrong.
+	 * Just return an error.
 	 */
-	if (test_bit(SID_ID_MAPPED, &psidid->state)) {
-		cid = psidid->id;
-		psidid->time = jiffies; /* update ts for accessing */
-		goto sid_to_id_out;
+	if (unlikely(psid->num_subauth > SID_MAX_SUB_AUTHORITIES)) {
+		cFYI(1, "%s: %u subauthorities is too many!", __func__,
+			psid->num_subauth);
+		return -EIO;
 	}
 
-	if (time_after(psidid->time + SID_MAP_RETRY, jiffies))
-		goto sid_to_id_out;
-
-	if (!test_and_set_bit(SID_ID_PENDING, &psidid->state)) {
-		saved_cred = override_creds(root_cred);
-		idkey = request_key(&cifs_idmap_key_type, psidid->sidstr, "");
-		if (IS_ERR(idkey))
-			cFYI(1, "%s: Can't map SID to an id", __func__);
-		else {
-			cid = *(unsigned long *)idkey->payload.value;
-			psidid->id = cid;
-			set_bit(SID_ID_MAPPED, &psidid->state);
-			key_put(idkey);
-			kfree(psidid->sidstr);
-		}
-		revert_creds(saved_cred);
-		psidid->time = jiffies; /* update ts for accessing */
-		clear_bit(SID_ID_PENDING, &psidid->state);
-		wake_up_bit(&psidid->state, SID_ID_PENDING);
-	} else {
-		rc = wait_on_bit(&psidid->state, SID_ID_PENDING,
-				sidid_pending_wait, TASK_INTERRUPTIBLE);
-		if (rc) {
-			cFYI(1, "%s: sidid_pending_wait interrupted %d",
-					__func__, rc);
-			--psidid->refcount; /* decremented without spinlock */
-			return rc;
-		}
-		if (test_bit(SID_ID_MAPPED, &psidid->state))
-			cid = psidid->id;
+	sidstr = sid_to_key_str(psid, sidtype);
+	if (!sidstr)
+		return -ENOMEM;
+
+	saved_cred = override_creds(root_cred);
+	sidkey = request_key(&cifs_idmap_key_type, sidstr, "");
+	if (IS_ERR(sidkey)) {
+		rc = -EINVAL;
+		cFYI(1, "%s: Can't map SID %s to a %cid", __func__, sidstr,
+			sidtype == SIDOWNER ? 'u' : 'g');
+		goto out_revert_creds;
+	}
+
+	/*
+	 * FIXME: Here we assume that uid_t and gid_t are same size. It's
+	 * probably a safe assumption but might be better to check based on
+	 * sidtype.
+	 */
+	if (sidkey->datalen < sizeof(uid_t)) {
+		rc = -EIO;
+		cFYI(1, "%s: Downcall contained malformed key "
+			"(datalen=%hu)", __func__, sidkey->datalen);
+		goto out_key_put;
 	}
 
-sid_to_id_out:
-	--psidid->refcount; /* decremented without spinlock */
 	if (sidtype == SIDOWNER)
-		fattr->cf_uid = cid;
+		fuid = *(uid_t *)sidkey->payload.value;
 	else
-		fattr->cf_gid = cid;
+		fgid = *(gid_t *)sidkey->payload.value;
 
+out_key_put:
+	key_put(sidkey);
+out_revert_creds:
+	revert_creds(saved_cred);
+	kfree(sidstr);
+
+	/*
+	 * Note that we return 0 here unconditionally. If the mapping
+	 * fails then we just fall back to using the mnt_uid/mnt_gid.
+	 */
+	if (sidtype == SIDOWNER)
+		fattr->cf_uid = fuid;
+	else
+		fattr->cf_gid = fgid;
 	return 0;
 }
 
@@ -621,17 +317,6 @@ init_cifs_idmap(void)
 	cred->jit_keyring = KEY_REQKEY_DEFL_THREAD_KEYRING;
 	root_cred = cred;
 
-	spin_lock_init(&siduidlock);
-	uidtree = RB_ROOT;
-	spin_lock_init(&sidgidlock);
-	gidtree = RB_ROOT;
-
-	spin_lock_init(&uidsidlock);
-	siduidtree = RB_ROOT;
-	spin_lock_init(&gidsidlock);
-	sidgidtree = RB_ROOT;
-	register_shrinker(&cifs_shrinker);
-
 	cFYI(1, "cifs idmap keyring: %d", key_serial(keyring));
 	return 0;
 
@@ -648,41 +333,9 @@ exit_cifs_idmap(void)
 	key_revoke(root_cred->thread_keyring);
 	unregister_key_type(&cifs_idmap_key_type);
 	put_cred(root_cred);
-	unregister_shrinker(&cifs_shrinker);
 	cFYI(1, "Unregistered %s key type", cifs_idmap_key_type.name);
 }
 
-void
-cifs_destroy_idmaptrees(void)
-{
-	struct rb_root *root;
-	struct rb_node *node;
-
-	root = &uidtree;
-	spin_lock(&siduidlock);
-	while ((node = rb_first(root)))
-		rb_erase(node, root);
-	spin_unlock(&siduidlock);
-
-	root = &gidtree;
-	spin_lock(&sidgidlock);
-	while ((node = rb_first(root)))
-		rb_erase(node, root);
-	spin_unlock(&sidgidlock);
-
-	root = &siduidtree;
-	spin_lock(&uidsidlock);
-	while ((node = rb_first(root)))
-		rb_erase(node, root);
-	spin_unlock(&uidsidlock);
-
-	root = &sidgidtree;
-	spin_lock(&gidsidlock);
-	while ((node = rb_first(root)))
-		rb_erase(node, root);
-	spin_unlock(&gidsidlock);
-}
-
 /* copy ntsd, owner sid, and group sid from a security descriptor to another */
 static void copy_sec_desc(const struct cifs_ntsd *pntsd,
 				struct cifs_ntsd *pnntsd, __u32 sidsoffset)
diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
index 249c94f..4b34e37 100644
--- a/fs/cifs/cifsacl.h
+++ b/fs/cifs/cifsacl.h
@@ -23,7 +23,7 @@
 #define _CIFSACL_H
 
 
-#define NUM_AUTHS 6 /* number of authority fields */
+#define NUM_AUTHS (6)	/* number of authority fields */
 #define SID_MAX_SUB_AUTHORITIES (15) /* max number of sub authority fields */
 #define NUM_WK_SIDS 7 /* number of well known sids */
 #define SIDNAMELENGTH 20 /* long enough for the ones we care about */
@@ -51,15 +51,12 @@
  * u32: max 10 bytes in decimal
  *
  * "S-" + 3 bytes for version field + 4 bytes for each authority field (3 bytes
- * per number + 1 for '-') + 11 bytes for each subauthority field (10 bytes
  * per number + 1 for '-') + NULL terminator.
+ *
+ * Add 11 bytes for each subauthority field (10 bytes each + 1 for '-')
  */
-#define SID_STRING_MAX (195)
-
-#define SID_ID_MAPPED 0
-#define SID_ID_PENDING 1
-#define SID_MAP_EXPIRE (3600 * HZ) /* map entry expires after one hour */
-#define SID_MAP_RETRY (300 * HZ)   /* wait 5 minutes for next attempt to map */
+#define SID_STRING_BASE_SIZE (2 + 3 + (4 * NUM_AUTHS) + 1)
+#define SID_STRING_SUBAUTH_SIZE (11) /* size of a single subauth string */
 
 struct cifs_ntsd {
 	__le16 revision; /* revision level */
@@ -99,14 +96,4 @@ struct cifs_wksid {
 	char sidname[SIDNAMELENGTH];
 } __attribute__((packed));
 
-struct cifs_sid_id {
-	unsigned int refcount; /* increment with spinlock, decrement without */
-	unsigned long id;
-	unsigned long time;
-	unsigned long state;
-	char *sidstr;
-	struct rb_node rbnode;
-	struct cifs_sid sid;
-};
-
 #endif /* _CIFSACL_H */
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e7931cc..423f7d8 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1205,7 +1205,6 @@ exit_cifs(void)
 	unregister_filesystem(&cifs_fs_type);
 	cifs_dfs_release_automount_timer();
 #ifdef CONFIG_CIFS_ACL
-	cifs_destroy_idmaptrees();
 	exit_cifs_idmap();
 #endif
 #ifdef CONFIG_CIFS_UPCALL
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 5144e9f..2d2ae69 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -58,7 +58,6 @@ do {								\
 } while (0)
 extern int init_cifs_idmap(void);
 extern void exit_cifs_idmap(void);
-extern void cifs_destroy_idmaptrees(void);
 extern char *build_path_from_dentry(struct dentry *);
 extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
 extern char *cifs_compose_mount_options(const char *sb_mountdata,
-- 
1.7.11.7
