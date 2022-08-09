Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5157C00140
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Aug 2022 02:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiHICMg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Aug 2022 22:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiHICMe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Aug 2022 22:12:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F3AB18B09
        for <linux-cifs@vger.kernel.org>; Mon,  8 Aug 2022 19:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660011151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PXM1d8Uok41O48+K5amnx6mdUbG4W4xv3HefM2tivX8=;
        b=BuJzn86QJHUf1PI/zv50EmS4uuodgNdKeg9V/UCxPysUj+IUUBlXA2xWH8aTjvinshe17M
        QYzJz5idjKE7C2InMNP+T9GiY/K9I1SANrTtmUbAJYi2esmkcA9v7DUbppYdjbpgVf+CwI
        eg+NGx8pxxJ6XUwaCJBupHhz+l4mpo8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-eLZNSmluMnesjuKb8BkupQ-1; Mon, 08 Aug 2022 22:12:28 -0400
X-MC-Unique: eLZNSmluMnesjuKb8BkupQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECCA83804535;
        Tue,  9 Aug 2022 02:12:27 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-16.bne.redhat.com [10.64.52.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1C21400F36;
        Tue,  9 Aug 2022 02:12:26 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 9/9] cifs: start caching all directories we open and get a lease for
Date:   Tue,  9 Aug 2022 12:11:56 +1000
Message-Id: <20220809021156.3086869-10-lsahlber@redhat.com>
In-Reply-To: <20220809021156.3086869-1-lsahlber@redhat.com>
References: <20220809021156.3086869-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cached_dir.c | 396 ++++++++++++++++++++++++-------------------
 fs/cifs/cached_dir.h |  18 +-
 fs/cifs/inode.c      |   7 +-
 fs/cifs/smb2ops.c    |   2 +-
 4 files changed, 240 insertions(+), 183 deletions(-)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index 9d221f0bf976..4ae9c897eeae 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -11,7 +11,55 @@
 #include "smb2proto.h"
 #include "cached_dir.h"
 
-struct cached_fid *init_cached_dir(const char *path);
+static struct cached_fid *init_cached_dir(const char *path);
+static void smb2_close_cached_fid(struct kref *ref);
+static void smb2_drop_cached_fid_locked(struct kref *ref);
+static void free_cached_dir(struct cached_fid *cfid);
+
+static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
+						    const char *path,
+						    bool lookup_only)
+{
+	struct cached_fid *cfid;
+
+	spin_lock(&cfids->cfid_list_lock);
+	list_for_each_entry(cfid, &cfids->entries, entry) {
+		if (!strcmp(cfid->path, path)) {
+			/*
+			 * If it doesn't have a lease it is either not yet
+			 * fully cached or it may be in the process of
+			 * being deleted due to a lease break.
+			 */
+			if (!cfid->has_lease) {
+				spin_unlock(&cfids->cfid_list_lock);
+				return NULL;
+			}
+			kref_get(&cfid->refcount);
+			spin_unlock(&cfids->cfid_list_lock);
+			return cfid;
+		}
+	}
+	if (lookup_only) {
+		spin_unlock(&cfids->cfid_list_lock);
+		return NULL;
+	}
+	if (cfids->num_entries >= MAX_CACHED_FIDS) {
+		spin_unlock(&cfids->cfid_list_lock);
+		return NULL;
+	}
+	cfid = init_cached_dir(path);
+	if (cfid == NULL) {
+		spin_unlock(&cfids->cfid_list_lock);
+		return NULL;
+	}
+	cfid->cfids = cfids;
+	cfids->num_entries++;
+	list_add(&cfid->entry, &cfids->entries);
+	/* should we do this get in open_cached_dir() instead ? */
+	kref_get(&cfid->refcount);
+	spin_unlock(&cfids->cfid_list_lock);
+	return cfid;
+}
 
 /*
  * Open the and cache a directory handle.
@@ -33,42 +81,45 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
 	struct kvec qi_iov[1];
 	int rc, flags = 0;
-	__le16 utf16_path = 0; /* Null - since an open of top of share */
+	__le16 *utf16_path = NULL;
 	u8 oplock = SMB2_OPLOCK_LEVEL_II;
 	struct cifs_fid *pfid;
-	struct dentry *dentry;
+	struct dentry *dentry = NULL;
 	struct cached_fid *cfid;
+	struct cached_fids *cfids;
 	  
-	if (tcon == NULL || tcon->nohandlecache ||
+
+	if (tcon == NULL || tcon->cfids == NULL || tcon->nohandlecache ||
 	    is_smb1_server(tcon->ses->server))
 		return -ENOTSUPP;
 
 	ses = tcon->ses;
 	server = ses->server;
+	cfids = tcon->cfids;
 
 	if (cifs_sb->root == NULL)
 		return -ENOENT;
 
+	/*
+	 * TODO: for better caching we need to find and use the dentry also
+	 * for non-root directories.
+	 */
 	if (!strlen(path))
 		dentry = cifs_sb->root;
 
-	if (strlen(path))
-		return -ENOENT;
+	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
+	if (!utf16_path)
+		return -ENOMEM;
 
-	cfid = tcon->cfids->cfid;
+	cfid = find_or_create_cached_dir(cfids, path, lookup_only);
 	if (cfid == NULL) {
-		cfid = init_cached_dir(path);
-		tcon->cfids->cfid = cfid;
+		kfree(utf16_path);
+		return -ENOENT;
 	}
-	if (cfid == NULL)
-		return -ENOMEM;
-
-	mutex_lock(&cfid->fid_mutex);
-	if (cfid->is_valid) {
+	if (cfid->has_lease) {
 		cifs_dbg(FYI, "found a cached root file handle\n");
 		*ret_cfid = cfid;
-		kref_get(&cfid->refcount);
-		mutex_unlock(&cfid->fid_mutex);
+		kfree(utf16_path);
 		return 0;
 	}
 
@@ -78,17 +129,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	 * cifs_mark_open_files_invalid() which takes the lock again
 	 * thus causing a deadlock
 	 */
-	mutex_unlock(&cfid->fid_mutex);
-
-	if (lookup_only)
-		return -ENOENT;
-
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	if (!server->ops->new_lease_key)
+	if (!server->ops->new_lease_key) {
+		kfree(utf16_path);
 		return -EIO;
-
+	}
 	pfid = &cfid->fid;
 	server->ops->new_lease_key(pfid);
 
@@ -109,7 +156,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	oparms.reconnect = false;
 
 	rc = SMB2_open_init(tcon, server,
-			    &rqst[0], &oplock, &oparms, &utf16_path);
+			    &rqst[0], &oplock, &oparms, utf16_path);
 	if (rc)
 		goto oshr_free;
 	smb2_set_next_command(tcon, &rqst[0]);
@@ -132,47 +179,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	rc = compound_send_recv(xid, ses, server,
 				flags, 2, rqst,
 				resp_buftype, rsp_iov);
-	mutex_lock(&cfid->fid_mutex);
-
-	/*
-	 * Now we need to check again as the cached root might have
-	 * been successfully re-opened from a concurrent process
-	 */
-
-	if (cfid->is_valid) {
-		/* work was already done */
-
-		/* stash fids for close() later */
-		struct cifs_fid fid = {
-			.persistent_fid = pfid->persistent_fid,
-			.volatile_fid = pfid->volatile_fid,
-		};
-
-		/*
-		 * caller expects this func to set the fid in cfid to valid
-		 * cached root, so increment the refcount.
-		 */
-		kref_get(&cfid->refcount);
-
-		mutex_unlock(&cfid->fid_mutex);
-
-		if (rc == 0) {
-			/* close extra handle outside of crit sec */
-			SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
-		}
-		rc = 0;
-		goto oshr_free;
-	}
-
-	/* Cached root is still invalid, continue normaly */
-
 	if (rc) {
 		if (rc == -EREMCHG) {
 			tcon->need_reconnect = true;
 			pr_warn_once("server share %s deleted\n",
 				     tcon->treeName);
 		}
-		goto oshr_exit;
+		goto oshr_free;
 	}
 
 	atomic_inc(&tcon->num_remote_opens);
@@ -185,30 +198,23 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 #endif /* CIFS_DEBUG2 */
 
 	cfid->tcon = tcon;
-	cfid->is_valid = true;
-	cfid->dentry = dentry;
-	if (dentry)
+	if (dentry) {
+		cfid->dentry = dentry;
 		dget(dentry);
-	kref_init(&cfid->refcount);
-
+	}
 	/* BB TBD check to see if oplock level check can be removed below */
-	if (o_rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE) {
-		/*
-		 * See commit 2f94a3125b87. Increment the refcount when we
-		 * get a lease for root, release it if lease break occurs
-		 */
-		kref_get(&cfid->refcount);
-		cfid->has_lease = true;
-		smb2_parse_contexts(server, o_rsp,
-				&oparms.fid->epoch,
-				    oparms.fid->lease_key, &oplock,
-				    NULL, NULL);
-	} else
-		goto oshr_exit;
+	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
+		goto oshr_free;
+	}
 
+	smb2_parse_contexts(server, o_rsp,
+			    &oparms.fid->epoch,
+			    oparms.fid->lease_key, &oplock,
+			    NULL, NULL);
+	
 	qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
 	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
-		goto oshr_exit;
+		goto oshr_free;
 	if (!smb2_validate_and_copy_iov(
 				le16_to_cpu(qi_rsp->OutputBufferOffset),
 				sizeof(struct smb2_file_all_info),
@@ -216,15 +222,23 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 				(char *)&cfid->file_all_info))
 		cfid->file_all_info_is_valid = true;
 	cfid->time = jiffies;
+	cfid->has_lease = true;
 
 
-oshr_exit:
-	mutex_unlock(&cfid->fid_mutex);
 oshr_free:
+	kfree(utf16_path);
 	SMB2_open_free(&rqst[0]);
 	SMB2_query_info_free(&rqst[1]);
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
+	if (!cfid->has_lease) {
+		spin_lock(&cfids->cfid_list_lock);
+		cfids->num_entries--;
+		list_del_init(&cfid->entry);
+		spin_unlock(&cfids->cfid_list_lock);
+		free_cached_dir(cfid);
+		rc = -ENOENT;
+	}
 	if (rc == 0) {
 		*ret_cfid = cfid;	
 	}
@@ -236,85 +250,90 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 			      struct cached_fid **ret_cfid)
 {
 	struct cached_fid *cfid;
+	struct cached_fids *cfids = tcon->cfids;
 
-	cfid = tcon->cfids->cfid;
-	if (cfid == NULL)
+	if (cfids == NULL)
 		return -ENOENT;
 
-	mutex_lock(&cfid->fid_mutex);
-	if (cfid->dentry == dentry) {
-		cifs_dbg(FYI, "found a cached root file handle by dentry\n");
-		*ret_cfid = cfid;
-		kref_get(&cfid->refcount);
-		mutex_unlock(&cfid->fid_mutex);
-		return 0;
+	spin_lock(&cfids->cfid_list_lock);
+	list_for_each_entry(cfid, &cfids->entries, entry) {
+		if (dentry && cfid->dentry == dentry) {
+			cifs_dbg(FYI, "found a cached root file handle by dentry\n");
+			kref_get(&cfid->refcount);
+			*ret_cfid = cfid;	
+			spin_unlock(&cfids->cfid_list_lock);
+			return 0;
+		}
 	}
-	mutex_unlock(&cfid->fid_mutex);
+	spin_unlock(&cfids->cfid_list_lock);
 	return -ENOENT;
 }
 
 static void
-smb2_close_cached_fid(struct kref *ref)
+smb2_close_cached_fid_internal(struct kref *ref, bool locked)
 {
 	struct cached_fid *cfid = container_of(ref, struct cached_fid,
 					       refcount);
-	struct cached_dirent *dirent, *q;
 
-	if (cfid->is_valid) {
+	if (!locked)
+		spin_lock(&cfid->cfids->cfid_list_lock);
+	cfid->cfids->num_entries--;
+	list_del_init(&cfid->entry);
+	if (cfid->dentry)
+		dput(cfid->dentry);
+	if (!locked)
+		spin_unlock(&cfid->cfids->cfid_list_lock);
+
+	if (cfid->has_lease) {
 		cifs_dbg(FYI, "clear cached root file handle\n");
 		SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
 			   cfid->fid.volatile_fid);
 	}
 
+	free_cached_dir(cfid);
+}
+
+static void
+smb2_close_cached_fid(struct kref *ref)
+{
+	smb2_close_cached_fid_internal(ref, false);
+}
+
+static void
+smb2_drop_cached_fid_locked(struct kref *ref)
+{
+	struct cached_fid *cfid = container_of(ref, struct cached_fid,
+					       refcount);
 	/*
-	 * We only check validity above to send SMB2_close,
-	 * but we still need to invalidate these entries
-	 * when this function is called
+	 * If the caller already holds cfid_list_lock we must force have_lease
+	 * to be false in order to avoid calling the blocking function
+	 * SMB2_close(). This could leave the file open on the server so we
+	 * must only call smb2_drop_cached_fid_locked IFF
+	 * - we know all handles are closed becase we are about to disconnect
+	 *   the share during umount.
+	 * - we have lost the session so all open files are implicitely closed
+	 *   anyway.
 	 */
-	cfid->is_valid = false;
-	cfid->file_all_info_is_valid = false;
 	cfid->has_lease = false;
-	if (cfid->dentry) {
-		dput(cfid->dentry);
-		cfid->dentry = NULL;
-	}
-	/*
-	 * Delete all cached dirent names
-	 */
-	mutex_lock(&cfid->dirents.de_mutex);
-	list_for_each_entry_safe(dirent, q, &cfid->dirents.entries, entry) {
-		list_del(&dirent->entry);
-		kfree(dirent->name);
-		kfree(dirent);
-	}
-	cfid->dirents.is_valid = 0;
-	cfid->dirents.is_failed = 0;
-	cfid->dirents.ctx = NULL;
-	cfid->dirents.pos = 0;
-	mutex_unlock(&cfid->dirents.de_mutex);
-
+	smb2_close_cached_fid_internal(ref, true);
 }
 
 void close_cached_dir(struct cached_fid *cfid)
 {
-	mutex_lock(&cfid->fid_mutex);
 	kref_put(&cfid->refcount, smb2_close_cached_fid);
-	mutex_unlock(&cfid->fid_mutex);
-}
-
-void close_cached_dir_lease_locked(struct cached_fid *cfid)
-{
-	if (cfid->has_lease) {
-		cfid->has_lease = false;
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
-	}
 }
 
-void close_cached_dir_lease(struct cached_fid *cfid)
+static void close_cached_dir_lease(struct cached_fid *cfid)
 {
-	mutex_lock(&cfid->fid_mutex);
-	close_cached_dir_lease_locked(cfid);
-	mutex_unlock(&cfid->fid_mutex);
+	/*
+	 * TODO: If this is not the last reference then we
+	 * we must send a lease break ack and flag this dir as not
+	 * being cached.
+	 * This is to handle the situation where an app holds opendir()
+	 * open for a long time during which we get a lease break from the
+	 * server.
+	 */
+	kref_put(&cfid->refcount, smb2_close_cached_fid);
 }
 
 /*
@@ -327,41 +346,41 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 	struct cached_fid *cfid;
 	struct cifs_tcon *tcon;
 	struct tcon_link *tlink;
+	struct cached_fids *cfids;
 
 	for (node = rb_first(root); node; node = rb_next(node)) {
 		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
 		tcon = tlink_tcon(tlink);
 		if (IS_ERR(tcon))
 			continue;
-		cfid = tcon->cfids->cfid;
-		if (cfid == NULL)
+		cfids = tcon->cfids;
+		if (cfids == NULL)
 			continue;
-		mutex_lock(&cfid->fid_mutex);
-		if (cfid->dentry) {
-			dput(cfid->dentry);
-			cfid->dentry = NULL;
+		list_for_each_entry(cfid, &cfids->entries, entry) {
+			if (cfid->dentry) {
+				dput(cfid->dentry);
+				cfid->dentry = NULL;
+			}
 		}
-		mutex_unlock(&cfid->fid_mutex);
 	}
 }
 
 /*
- * Invalidate and close all cached dirs when a TCON has been reset
+ * Invalidate all cached dirs when a TCON has been reset
  * due to a session loss.
  */
 void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 {
-	struct cached_fid *cfid = tcon->cfids->cfid;
-
-	if (cfid == NULL)
-		return;
-
-	mutex_lock(&cfid->fid_mutex);
-	cfid->is_valid = false;
-	/* cached handle is not valid, so SMB2_CLOSE won't be sent below */
-	close_cached_dir_lease_locked(cfid);
-	memset(&cfid->fid, 0, sizeof(struct cifs_fid));
-	mutex_unlock(&cfid->fid_mutex);
+	struct cached_fids *cfids = tcon->cfids;
+	struct cached_fid *cfid, *q;
+
+	spin_lock(&cfids->cfid_list_lock);
+	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
+		cfids->num_entries--;
+		list_del_init(&cfid->entry);
+		kref_put(&cfid->refcount, smb2_drop_cached_fid_locked);
+	}
+	spin_unlock(&cfids->cfid_list_lock);
 }
 
 static void
@@ -375,33 +394,39 @@ smb2_cached_lease_break(struct work_struct *work)
 
 int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 {
-	struct cached_fid *cfid = tcon->cfids->cfid;
+	struct cached_fids *cfids = tcon->cfids;
+	struct cached_fid *cfid;
 
-	if (cfid == NULL)
+	if (cfids == NULL)
 		return false;
 
-	if (cfid->is_valid &&
-	    !memcmp(lease_key,
-		    cfid->fid.lease_key,
-		    SMB2_LEASE_KEY_SIZE)) {
-		cfid->time = 0;
-		INIT_WORK(&cfid->lease_break,
-			  smb2_cached_lease_break);
-		queue_work(cifsiod_wq,
-			   &cfid->lease_break);
-		return true;
+	spin_lock(&cfids->cfid_list_lock);
+	list_for_each_entry(cfid, &cfids->entries, entry) {
+		if (cfid->has_lease &&
+		    !memcmp(lease_key,
+			    cfid->fid.lease_key,
+			    SMB2_LEASE_KEY_SIZE)) {
+			cfid->time = 0;
+			INIT_WORK(&cfid->lease_break,
+				  smb2_cached_lease_break);
+			queue_work(cifsiod_wq,
+				   &cfid->lease_break);
+			spin_unlock(&cfids->cfid_list_lock);
+			return true;
+		}
 	}
+	spin_unlock(&cfids->cfid_list_lock);
 	return false;
 }
 
-struct cached_fid *init_cached_dir(const char *path)
+static struct cached_fid *init_cached_dir(const char *path)
 {
 	struct cached_fid *cfid;
 
-	cfid = kzalloc(sizeof(*cfid), GFP_KERNEL);
+	cfid = kzalloc(sizeof(*cfid), GFP_ATOMIC);
 	if (!cfid)
 		return NULL;
-	cfid->path = kstrdup(path, GFP_KERNEL);
+	cfid->path = kstrdup(path, GFP_ATOMIC);
 	if (!cfid->path) {
 		kfree(cfid);
 		return NULL;
@@ -409,12 +434,29 @@ struct cached_fid *init_cached_dir(const char *path)
 
 	INIT_LIST_HEAD(&cfid->dirents.entries);
 	mutex_init(&cfid->dirents.de_mutex);
-	mutex_init(&cfid->fid_mutex);
+	spin_lock_init(&cfid->fid_lock);
+	kref_init(&cfid->refcount);
 	return cfid;
 }
 
-void free_cached_dir(struct cached_fid *cfid)
+static void free_cached_dir(struct cached_fid *cfid)
 {
+	struct cached_dirent *dirent, *q;
+
+	if (cfid->dentry) {
+		dput(cfid->dentry);
+		cfid->dentry = NULL;
+	}
+
+	/*
+	 * Delete all cached dirent names
+	 */
+	list_for_each_entry_safe(dirent, q, &cfid->dirents.entries, entry) {
+		list_del(&dirent->entry);
+		kfree(dirent->name);
+		kfree(dirent);
+	}
+
 	kfree(cfid->path);
 	cfid->path = NULL;
 	kfree(cfid);
@@ -427,15 +469,25 @@ struct cached_fids *init_cached_dirs(void)
 	cfids = kzalloc(sizeof(*cfids), GFP_KERNEL);
 	if (!cfids)
 		return NULL;
-	mutex_init(&cfids->cfid_list_mutex);
+	spin_lock_init(&cfids->cfid_list_lock);
+	INIT_LIST_HEAD(&cfids->entries);
 	return cfids;
 }
 
+/*
+ * Called from tconInfoFree when we are tearing down the tcon.
+ * There are no active users or open files/directories at this point.
+ */
 void free_cached_dirs(struct cached_fids *cfids)
 {
-	if (cfids->cfid) {
-		free_cached_dir(cfids->cfid);
-		cfids->cfid = NULL;
+	struct cached_fid *cfid, *q;
+
+	spin_lock(&cfids->cfid_list_lock);
+	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
+		cfids->num_entries--;
+		list_del_init(&cfid->entry);
+		free_cached_dir(cfid);
 	}
-	kfree(cfids);
+	spin_unlock(&cfids->cfid_list_lock);
+ 	kfree(cfids);
 }
diff --git a/fs/cifs/cached_dir.h b/fs/cifs/cached_dir.h
index d34ff3e31488..c6df8804afb4 100644
--- a/fs/cifs/cached_dir.h
+++ b/fs/cifs/cached_dir.h
@@ -31,14 +31,15 @@ struct cached_dirents {
 };
 
 struct cached_fid {
+	struct list_head entry;
+	struct cached_fids *cfids;
 	const char *path;
-	bool is_valid:1;	/* Do we have a useable root fid */
-	bool file_all_info_is_valid:1;
 	bool has_lease:1;
+	bool file_all_info_is_valid:1;
 	unsigned long time; /* jiffies of when lease was taken */
 	struct kref refcount;
 	struct cifs_fid fid;
-	struct mutex fid_mutex;
+	spinlock_t fid_lock;
 	struct cifs_tcon *tcon;
 	struct dentry *dentry;
 	struct work_struct lease_break;
@@ -46,9 +47,14 @@ struct cached_fid {
 	struct cached_dirents dirents;
 };
 
+#define MAX_CACHED_FIDS 16
 struct cached_fids {
-	struct mutex cfid_list_mutex;
-	struct cached_fid *cfid;
+	/* Must be held when:
+	 * - accessing the cfids->entries list
+	 */
+	spinlock_t cfid_list_lock;
+	int num_entries;
+	struct list_head entries;
 };
 
 extern struct cached_fids *init_cached_dirs(void);
@@ -61,8 +67,6 @@ extern int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 				     struct dentry *dentry,
 				     struct cached_fid **cfid);
 extern void close_cached_dir(struct cached_fid *cfid);
-extern void close_cached_dir_lease(struct cached_fid *cfid);
-extern void close_cached_dir_lease_locked(struct cached_fid *cfid);
 extern void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
 extern void invalidate_all_cached_dirs(struct cifs_tcon *tcon);
 extern int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16]);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 7714f47d199b..7d17d20502ca 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2225,15 +2225,16 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 		return true;
 
 	if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfid)) {
-		mutex_lock(&cfid->fid_mutex);
+		spin_lock(&cfid->fid_lock);
 		if (cfid->time && cifs_i->time > cfid->time) {
-			mutex_unlock(&cfid->fid_mutex);
+			spin_unlock(&cfid->fid_lock);
 			close_cached_dir(cfid);
 			return false;
 		}
-		mutex_unlock(&cfid->fid_mutex);
+		spin_unlock(&cfid->fid_lock);
 		close_cached_dir(cfid);
 	}
+
 	/*
 	 * depending on inode type, check if attribute caching disabled for
 	 * files or directories
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 4727ee537f11..2204a19517cd 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -787,7 +787,7 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = open_cached_dir(xid, tcon, full_path, cifs_sb, true, &cfid);
 	if (!rc) {
-		if (cfid->is_valid) {
+		if (cfid->has_lease) {
 			close_cached_dir(cfid);
 			return 0;
 		}
-- 
2.35.3

