Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987DFC00140
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Aug 2022 02:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiHICMQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Aug 2022 22:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiHICMP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Aug 2022 22:12:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C8F6918B09
        for <linux-cifs@vger.kernel.org>; Mon,  8 Aug 2022 19:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660011132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3vZN4//OuvwR+7MCkcThDbHj1pl2MXNlS2VTuZOBY0s=;
        b=UTuPrcYe3JPSNLWHpebBO1jsC/g3qRgsQLrH8nr4rimVNOC6gacNQc8DcRsFX8oUgWfcRd
        SboZUlXCqCYQbWbZgEA57HIIcHBUtDmVBd32Mar60a0XzLCATEvokyIkabCC8FpwtEuIDa
        ELf35fqU1ixEeplaOJAu9/Ppu3ent2M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-it5lNo13MjaBQoKwT2SERg-1; Mon, 08 Aug 2022 22:12:11 -0400
X-MC-Unique: it5lNo13MjaBQoKwT2SERg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB6DE811E84;
        Tue,  9 Aug 2022 02:12:10 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-16.bne.redhat.com [10.64.52.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65CE7492C3B;
        Tue,  9 Aug 2022 02:12:09 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 3/9] cifs: Add constructor/destructors for tcon->cfid
Date:   Tue,  9 Aug 2022 12:11:50 +1000
Message-Id: <20220809021156.3086869-4-lsahlber@redhat.com>
In-Reply-To: <20220809021156.3086869-1-lsahlber@redhat.com>
References: <20220809021156.3086869-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

and move the structure definitions into cached_dir.h

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cached_dir.c | 114 ++++++++++++++++++++++++++-----------------
 fs/cifs/cached_dir.h |  38 +++++++++++++++
 fs/cifs/cifsglob.h   |  38 +--------------
 fs/cifs/misc.c       |  20 ++++----
 fs/cifs/smb2inode.c  |   4 +-
 fs/cifs/smb2ops.c    |   8 +--
 6 files changed, 123 insertions(+), 99 deletions(-)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index f2e17c1d5196..7ca085299890 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -18,7 +18,7 @@
 int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		const char *path,
 		struct cifs_sb_info *cifs_sb,
-		struct cached_fid **cfid)
+		struct cached_fid **ret_cfid)
 {
 	struct cifs_ses *ses;
 	struct TCP_Server_Info *server;
@@ -35,7 +35,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	u8 oplock = SMB2_OPLOCK_LEVEL_II;
 	struct cifs_fid *pfid;
 	struct dentry *dentry;
-
+	struct cached_fid *cfid;
+	  
 	if (tcon == NULL || tcon->nohandlecache ||
 	    is_smb1_server(tcon->ses->server))
 		return -ENOTSUPP;
@@ -51,12 +52,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 
 	dentry = cifs_sb->root;
 
-	mutex_lock(&tcon->cfid.fid_mutex);
-	if (tcon->cfid.is_valid) {
+	cfid = tcon->cfid;
+	mutex_lock(&cfid->fid_mutex);
+	if (cfid->is_valid) {
 		cifs_dbg(FYI, "found a cached root file handle\n");
-		*cfid = &tcon->cfid;
-		kref_get(&tcon->cfid.refcount);
-		mutex_unlock(&tcon->cfid.fid_mutex);
+		*ret_cfid = cfid;
+		kref_get(&cfid->refcount);
+		mutex_unlock(&cfid->fid_mutex);
 		return 0;
 	}
 
@@ -67,7 +69,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	 * thus causing a deadlock
 	 */
 
-	mutex_unlock(&tcon->cfid.fid_mutex);
+	mutex_unlock(&cfid->fid_mutex);
 
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
@@ -75,7 +77,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	if (!server->ops->new_lease_key)
 		return -EIO;
 
-	pfid = tcon->cfid.fid;
+	pfid = &cfid->fid;
 	server->ops->new_lease_key(pfid);
 
 	memset(rqst, 0, sizeof(rqst));
@@ -118,14 +120,14 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	rc = compound_send_recv(xid, ses, server,
 				flags, 2, rqst,
 				resp_buftype, rsp_iov);
-	mutex_lock(&tcon->cfid.fid_mutex);
+	mutex_lock(&cfid->fid_mutex);
 
 	/*
 	 * Now we need to check again as the cached root might have
 	 * been successfully re-opened from a concurrent process
 	 */
 
-	if (tcon->cfid.is_valid) {
+	if (cfid->is_valid) {
 		/* work was already done */
 
 		/* stash fids for close() later */
@@ -138,9 +140,9 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		 * caller expects this func to set the fid in cfid to valid
 		 * cached root, so increment the refcount.
 		 */
-		kref_get(&tcon->cfid.refcount);
+		kref_get(&cfid->refcount);
 
-		mutex_unlock(&tcon->cfid.fid_mutex);
+		mutex_unlock(&cfid->fid_mutex);
 
 		if (rc == 0) {
 			/* close extra handle outside of crit sec */
@@ -170,11 +172,11 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
 
-	tcon->cfid.tcon = tcon;
-	tcon->cfid.is_valid = true;
-	tcon->cfid.dentry = dentry;
+	cfid->tcon = tcon;
+	cfid->is_valid = true;
+	cfid->dentry = dentry;
 	dget(dentry);
-	kref_init(&tcon->cfid.refcount);
+	kref_init(&cfid->refcount);
 
 	/* BB TBD check to see if oplock level check can be removed below */
 	if (o_rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE) {
@@ -182,8 +184,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		 * See commit 2f94a3125b87. Increment the refcount when we
 		 * get a lease for root, release it if lease break occurs
 		 */
-		kref_get(&tcon->cfid.refcount);
-		tcon->cfid.has_lease = true;
+		kref_get(&cfid->refcount);
+		cfid->has_lease = true;
 		smb2_parse_contexts(server, o_rsp,
 				&oparms.fid->epoch,
 				    oparms.fid->lease_key, &oplock,
@@ -198,37 +200,41 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 				le16_to_cpu(qi_rsp->OutputBufferOffset),
 				sizeof(struct smb2_file_all_info),
 				&rsp_iov[1], sizeof(struct smb2_file_all_info),
-				(char *)&tcon->cfid.file_all_info))
-		tcon->cfid.file_all_info_is_valid = true;
-	tcon->cfid.time = jiffies;
+				(char *)&cfid->file_all_info))
+		cfid->file_all_info_is_valid = true;
+	cfid->time = jiffies;
 
 
 oshr_exit:
-	mutex_unlock(&tcon->cfid.fid_mutex);
+	mutex_unlock(&cfid->fid_mutex);
 oshr_free:
 	SMB2_open_free(&rqst[0]);
 	SMB2_query_info_free(&rqst[1]);
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 	if (rc == 0) {
-		*cfid = &tcon->cfid;	
-}
+		*ret_cfid = cfid;	
+	}
 	return rc;
 }
 
 int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 			      struct dentry *dentry,
-			      struct cached_fid **cfid)
+			      struct cached_fid **ret_cfid)
 {
-	mutex_lock(&tcon->cfid.fid_mutex);
-	if (tcon->cfid.dentry == dentry) {
+	struct cached_fid *cfid;
+
+	cfid = tcon->cfid;
+
+	mutex_lock(&cfid->fid_mutex);
+	if (cfid->dentry == dentry) {
 		cifs_dbg(FYI, "found a cached root file handle by dentry\n");
-		*cfid = &tcon->cfid;
-		kref_get(&tcon->cfid.refcount);
-		mutex_unlock(&tcon->cfid.fid_mutex);
+		*ret_cfid = cfid;
+		kref_get(&cfid->refcount);
+		mutex_unlock(&cfid->fid_mutex);
 		return 0;
 	}
-	mutex_unlock(&tcon->cfid.fid_mutex);
+	mutex_unlock(&cfid->fid_mutex);
 	return -ENOENT;
 }
 
@@ -241,8 +247,8 @@ smb2_close_cached_fid(struct kref *ref)
 
 	if (cfid->is_valid) {
 		cifs_dbg(FYI, "clear cached root file handle\n");
-		SMB2_close(0, cfid->tcon, cfid->fid->persistent_fid,
-			   cfid->fid->volatile_fid);
+		SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
+			   cfid->fid.volatile_fid);
 	}
 
 	/*
@@ -312,7 +318,7 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 		tcon = tlink_tcon(tlink);
 		if (IS_ERR(tcon))
 			continue;
-		cfid = &tcon->cfid;
+		cfid = tcon->cfid;
 		mutex_lock(&cfid->fid_mutex);
 		if (cfid->dentry) {
 			dput(cfid->dentry);
@@ -328,12 +334,12 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
  */
 void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 {
-	mutex_lock(&tcon->cfid.fid_mutex);
-	tcon->cfid.is_valid = false;
+	mutex_lock(&tcon->cfid->fid_mutex);
+	tcon->cfid->is_valid = false;
 	/* cached handle is not valid, so SMB2_CLOSE won't be sent below */
-	close_cached_dir_lease_locked(&tcon->cfid);
-	memset(tcon->cfid.fid, 0, sizeof(struct cifs_fid));
-	mutex_unlock(&tcon->cfid.fid_mutex);
+	close_cached_dir_lease_locked(tcon->cfid);
+	memset(&tcon->cfid->fid, 0, sizeof(struct cifs_fid));
+	mutex_unlock(&tcon->cfid->fid_mutex);
 }
 
 static void
@@ -347,17 +353,35 @@ smb2_cached_lease_break(struct work_struct *work)
 
 int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 {
-	if (tcon->cfid.is_valid &&
+	if (tcon->cfid->is_valid &&
 	    !memcmp(lease_key,
-		    tcon->cfid.fid->lease_key,
+		    tcon->cfid->fid.lease_key,
 		    SMB2_LEASE_KEY_SIZE)) {
-		tcon->cfid.time = 0;
-		INIT_WORK(&tcon->cfid.lease_break,
+		tcon->cfid->time = 0;
+		INIT_WORK(&tcon->cfid->lease_break,
 			  smb2_cached_lease_break);
 		queue_work(cifsiod_wq,
-			   &tcon->cfid.lease_break);
+			   &tcon->cfid->lease_break);
 		spin_unlock(&cifs_tcp_ses_lock);
 		return true;
 	}
 	return false;
 }
+
+struct cached_fid *init_cached_dir(void)
+{
+	struct cached_fid *cfid;
+
+	cfid = kzalloc(sizeof(*cfid), GFP_KERNEL);
+	if (!cfid)
+		return NULL;
+	INIT_LIST_HEAD(&cfid->dirents.entries);
+	mutex_init(&cfid->dirents.de_mutex);
+	mutex_init(&cfid->fid_mutex);
+	return cfid;
+}
+
+void free_cached_dir(struct cifs_tcon *tcon)
+{
+	kfree(tcon->cfid);
+}
diff --git a/fs/cifs/cached_dir.h b/fs/cifs/cached_dir.h
index 3731c755eea5..b44edfbd8e1a 100644
--- a/fs/cifs/cached_dir.h
+++ b/fs/cifs/cached_dir.h
@@ -9,6 +9,44 @@
 #define _CACHED_DIR_H
 
 
+struct cached_dirent {
+	struct list_head entry;
+	char *name;
+	int namelen;
+	loff_t pos;
+
+	struct cifs_fattr fattr;
+};
+
+struct cached_dirents {
+	bool is_valid:1;
+	bool is_failed:1;
+	struct dir_context *ctx; /*
+				  * Only used to make sure we only take entries
+				  * from a single context. Never dereferenced.
+				  */
+	struct mutex de_mutex;
+	int pos;		 /* Expected ctx->pos */
+	struct list_head entries;
+};
+
+struct cached_fid {
+	bool is_valid:1;	/* Do we have a useable root fid */
+	bool file_all_info_is_valid:1;
+	bool has_lease:1;
+	unsigned long time; /* jiffies of when lease was taken */
+	struct kref refcount;
+	struct cifs_fid fid;
+	struct mutex fid_mutex;
+	struct cifs_tcon *tcon;
+	struct dentry *dentry;
+	struct work_struct lease_break;
+	struct smb2_file_all_info file_all_info;
+	struct cached_dirents dirents;
+};
+
+extern struct cached_fid *init_cached_dir(void);
+extern void free_cached_dir(struct cifs_tcon *tcon);
 extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			   const char *path,
 			   struct cifs_sb_info *cifs_sb,
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 657fabb9067b..d3b233a2737d 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1125,42 +1125,6 @@ struct cifs_fattr {
 	u32             cf_cifstag;
 };
 
-struct cached_dirent {
-	struct list_head entry;
-	char *name;
-	int namelen;
-	loff_t pos;
-
-	struct cifs_fattr fattr;
-};
-
-struct cached_dirents {
-	bool is_valid:1;
-	bool is_failed:1;
-	struct dir_context *ctx; /*
-				  * Only used to make sure we only take entries
-				  * from a single context. Never dereferenced.
-				  */
-	struct mutex de_mutex;
-	int pos;		 /* Expected ctx->pos */
-	struct list_head entries;
-};
-
-struct cached_fid {
-	bool is_valid:1;	/* Do we have a useable root fid */
-	bool file_all_info_is_valid:1;
-	bool has_lease:1;
-	unsigned long time; /* jiffies of when lease was taken */
-	struct kref refcount;
-	struct cifs_fid *fid;
-	struct mutex fid_mutex;
-	struct cifs_tcon *tcon;
-	struct dentry *dentry;
-	struct work_struct lease_break;
-	struct smb2_file_all_info file_all_info;
-	struct cached_dirents dirents;
-};
-
 /*
  * there is one of these for each connection to a resource on a particular
  * session
@@ -1253,7 +1217,7 @@ struct cifs_tcon {
 	struct fscache_volume *fscache;	/* cookie for share */
 #endif
 	struct list_head pending_opens;	/* list of incomplete opens */
-	struct cached_fid cfid; /* Cached root fid */
+	struct cached_fid *cfid; /* Cached root fid */
 	/* BB add field for back pointer to sb struct(s)? */
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	struct list_head ulist; /* cache update list */
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index fa1a03ddbbe2..4e2e3b557591 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -23,6 +23,7 @@
 #include "dns_resolve.h"
 #endif
 #include "fs_context.h"
+#include "cached_dir.h"
 
 extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
@@ -115,13 +116,11 @@ tconInfoAlloc(void)
 	ret_buf = kzalloc(sizeof(*ret_buf), GFP_KERNEL);
 	if (!ret_buf)
 		return NULL;
-	ret_buf->cfid.fid = kzalloc(sizeof(*ret_buf->cfid.fid), GFP_KERNEL);
-	if (!ret_buf->cfid.fid) {
+	ret_buf->cfid = init_cached_dir();
+	if (!ret_buf->cfid) {
 		kfree(ret_buf);
 		return NULL;
 	}
-	INIT_LIST_HEAD(&ret_buf->cfid.dirents.entries);
-	mutex_init(&ret_buf->cfid.dirents.de_mutex);
 
 	atomic_inc(&tconInfoAllocCount);
 	ret_buf->status = TID_NEW;
@@ -129,7 +128,6 @@ tconInfoAlloc(void)
 	INIT_LIST_HEAD(&ret_buf->openFileList);
 	INIT_LIST_HEAD(&ret_buf->tcon_list);
 	spin_lock_init(&ret_buf->open_file_lock);
-	mutex_init(&ret_buf->cfid.fid_mutex);
 	spin_lock_init(&ret_buf->stat_lock);
 	atomic_set(&ret_buf->num_local_opens, 0);
 	atomic_set(&ret_buf->num_remote_opens, 0);
@@ -138,17 +136,17 @@ tconInfoAlloc(void)
 }
 
 void
-tconInfoFree(struct cifs_tcon *buf_to_free)
+tconInfoFree(struct cifs_tcon *tcon)
 {
-	if (buf_to_free == NULL) {
+	if (tcon == NULL) {
 		cifs_dbg(FYI, "Null buffer passed to tconInfoFree\n");
 		return;
 	}
+	free_cached_dir(tcon);
 	atomic_dec(&tconInfoAllocCount);
-	kfree(buf_to_free->nativeFileSystem);
-	kfree_sensitive(buf_to_free->password);
-	kfree(buf_to_free->cfid.fid);
-	kfree(buf_to_free);
+	kfree(tcon->nativeFileSystem);
+	kfree_sensitive(tcon->password);
+	kfree(tcon);
 }
 
 struct smb_hdr *
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 09f01f70e020..9696184a09e3 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -524,8 +524,8 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 					       &cfid->file_all_info);
 		} else {
 			rc = SMB2_query_info(xid, tcon,
-					     cfid->fid->persistent_fid,
-					     cfid->fid->volatile_fid, smb2_data);
+					     cfid->fid.persistent_fid,
+					     cfid->fid.volatile_fid, smb2_data);
 			if (!rc)
 				move_smb2_info_to_cifs(data, smb2_data);
 		}
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 01aafedc477e..e50b6ef309e1 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -722,7 +722,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = open_cached_dir(xid, tcon, "", cifs_sb, &cfid);
 	if (rc == 0)
-		memcpy(&fid, cfid->fid, sizeof(struct cifs_fid));
+		memcpy(&fid, &cfid->fid, sizeof(struct cifs_fid));
 	else
 		rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL,
 			       NULL, NULL);
@@ -784,7 +784,7 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
 
-	if ((*full_path == 0) && tcon->cfid.is_valid)
+	if ((*full_path == 0) && tcon->cfid->is_valid)
 		return 0;
 
 	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
@@ -2458,8 +2458,8 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	if (cfid) {
 		rc = SMB2_query_info_init(tcon, server,
 					  &rqst[1],
-					  cfid->fid->persistent_fid,
-					  cfid->fid->volatile_fid,
+					  cfid->fid.persistent_fid,
+					  cfid->fid.volatile_fid,
 					  class, type, 0,
 					  output_len, 0,
 					  NULL);
-- 
2.35.3

