Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF60175A74
	for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 17:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655574; cv=none; b=He8WuyFHpuMauP2hDA4iNFkcMN55Wmp3k04+Y2us9usH7U+EK/R7zr6wSbY5tiogiKPUUvbsRY6MPriyxNubbFa9SkzwzN5CrFqB3sABzJMzsJ9uPLpBq52F7VL8jraGQtowbzrj0LpjZU6wYYH9uy4Kw9v+DQN0WEgSQ2ViEH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655574; c=relaxed/simple;
	bh=p/mFVvZAQJ2XnI+3JSY3lVg60BUU7u1G1xid2QOb6cg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmOCJx64HsUJbaZzSBiiJJQu65AqRrToWqXxzobsJYlH7k2NHTCuDAaFAqjiAcDUPnZTAmyAy6wE/XnTg2YxF2l8EMlBr7cozWa90q53TSnop4eHvpnHJyQMozIPijY1VrOBXOZfkzM+3SQx6xciZ5RDqGERMzEPeebiv1E4b7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cw03oD2I; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EX3fIs7C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cw03oD2I";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EX3fIs7C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784655571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GDFIDH7/yXWqPt1mEl09mXPw9/7zhL0mdFzPCLiIyVE=;
	b=Cw03oD2Iaimj1Vur42tqcBHfaAjSnhbpNDKQs41+oTugkZp/rwb4bwjUsc44zG+4Zr/HnX
	Cw2rTsXD36ZRmxEcbUFsBSMt8eabzgBHPDDoBa0AJRi4e6/mDFPENinh0OyGAWzvRVOBen
	/IHNG7GrzewMYoKx+yknXaYD84nvAlY=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-MjQ28R7-O--_Vfzo8gLm3w-1; Tue, 21 Jul 2026 13:39:26 -0400
X-MC-Unique: MjQ28R7-O--_Vfzo8gLm3w-1
X-Mimecast-MFC-AGG-ID: MjQ28R7-O--_Vfzo8gLm3w_1784655566
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-456ae656699so4606431fac.0
        for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 10:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784655566; x=1785260366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GDFIDH7/yXWqPt1mEl09mXPw9/7zhL0mdFzPCLiIyVE=;
        b=EX3fIs7CDgifKejKZN8XwSu80K4VuQdRTWOwCefQrdqKpjBUXQJmF4MFxG/Z9K/Mfc
         0uR1mZnONTDyCPL3fN0dC+e8sp2aZ04LzftV+Mm/D/zChLSkILUIm4sbBt4Z60NqSZEe
         DOLYokvLFeJ69gXMj4ITOjDyx/JBfbUZyRDZ5v+gHWNSeWsUDGxsef6qF0JZox7AZbhV
         HkaQDol/bNWb0Bwh90aH7kUqQyIdNxMdbaFy+FyiGMSE6Q2m9leaYE75m7KM4jKB1fb+
         UkCHZOjw1p7h4ZyBYQ1WJKJdBiiYZEmVBZrRvt73oUpTL8Wk55LWdTZmtLBlHXBCL+7o
         Ctaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784655566; x=1785260366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=GDFIDH7/yXWqPt1mEl09mXPw9/7zhL0mdFzPCLiIyVE=;
        b=pTRjCbTCUEmv7RFIFO5oSgFAf7BdRY/dU7e7h40CN1qXIlWbhGKbm511m0UjhMqNI0
         FjJFY8YQlGY+lGZ4pRR180Ns2FjPo527sYIgYUyv68R7VByID8t8qxRuXMa34Obl/les
         pDRlqewyGNOp/Cj9eMI+uEn0NgiP+uesItkBCZXDnDdCiDiA/INdmpdL738cqZpGg92U
         aeXZ3bWGXVRS4bzkqf6l/ETIU+T6KtthU9Heq/8H7dcDjGY4YzKYdQ0y1dKbvty90yac
         3xMuUOyQEM3uHf9kaffcJa2l4VuavasKanPVfsLmTPM0F4p0hxL+h02BDfrb/thTa7Hu
         1vzA==
X-Gm-Message-State: AOJu0YwrlIqbPNGrztKiNaTO6cmC4W8dErM0OdUeWLCUZP24BlZog1tO
	XmlB1z3a1z//VTTgMGefDhdiLV4oqwKMaLENO/ZgFbUtYKfhs8kvKXEZW6EvHimsZXteEnZw7dJ
	LPDqYgke0z0t26N/WMfZcMKCdQlt/BQRJy6IQ3ZGHHFmvCq+DR5EG8L+p4aJC2Otbh8Znek1rVC
	apsj8tng/CAc0u27q9RVUg64jyACud6aQF2F6cFFHp7TrjO28=
X-Gm-Gg: AR+sD12scEdvfx/L1Maa0b1TBwDWIHYj4PtFC1z0LO3hMT91UpGVHxSV6yiMUaMeIzB
	/mPU7mGQA5+bZjV1hUky2F9PUt9n/EZj23G5DI3jSF8tLxWf0OsyIQOdW88V5xBcE5wOzGqzjNp
	n6ERE40lM0djBQkPEDjFlB0ZHQT3PKd7/bM3csCZP/9Lc3WTO3gzjohgoeWU4jiUSR2CvGu1n1v
	1+LBgp6JWgN61956t8FZKcl8I61kMBDoVKI9/zyZ+mxeTS1MB9wEJ28exN6uAnmpoCuq5z+gmSC
	BZVY7whf6x+EkGyl9jCMMGrv9psTfUtFMeZlgGv3Ko4AERVm1QWcfm+87BJQR7Dwi/NbgNRDbqF
	/NPDOmofU0by21Z0nfXfYcwg+eKQXSwVAscCfERgidG6AxfYrOOp8Z793aTCM
X-Received: by 2002:a05:6870:c683:b0:451:3852:25a9 with SMTP id 586e51a60fabf-4569038e43emr9879244fac.21.1784655564072;
        Tue, 21 Jul 2026 10:39:24 -0700 (PDT)
X-Received: by 2002:a05:6870:c683:b0:451:3852:25a9 with SMTP id 586e51a60fabf-4569038e43emr9879223fac.21.1784655563513;
        Tue, 21 Jul 2026 10:39:23 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-457673e1f1fsm86696fac.9.2026.07.21.10.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:39:22 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH] cifs: prevent readdir from changing file size due to stale directory metadata
Date: Tue, 21 Jul 2026 12:39:19 -0500
Message-ID: <20260721173919.1762653-2-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721173919.1762653-1-sorenson@redhat.com>
References: <20260721173919.1762653-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Windows Server's directory enumeration metadata lags behind the actual
file size after a write+close or rename.  A concurrent readdir() in the
window between close() returning to userspace and stat() being called
overwrites the correct cached i_size with the stale server value, causing
stat() to return the wrong size.

Once _cifsFileInfo_put() removes the last writable handle from openFileList,
is_size_safe_to_change() permits readdir to overwrite i_size.
smb2_close_getattr() then stamps cifs_i->time = jiffies, making the
corrupt cached value appear fresh to the next stat().

The existing check only blocked stale size updates while an active RW
lease was held, not after the last writable handle closes.

Add cifsInodeInfo->time_last_write, written via smp_store_release() at
writable close and on setattr/truncate.  is_size_safe_to_change() checks
is_inode_writable() first (acquiring open_file_lock), then rejects a
readdir size update if time_last_write falls within acregmax jiffies.
The spinlock release in _cifsFileInfo_put() forms a store-release barrier
that pairs with the spin_lock() (load-acquire) in is_inode_writable(),
ensuring the subsequent smp_load_acquire() on time_last_write observes
any update from a concurrent close().  When a size update is rejected and
the server value differs from the cached one, cifs_i->time is cleared to
force a fresh QUERY_INFO on the next stat().

readdir is also blocked from changing i_size while writable handles are
open or an RW lease is held, even on direct-IO mounts.

For deferred close (closetimeo > 0), time_last_write is refreshed at the
actual server close in smb2_deferred_work_close() and in the
cifs_close_deferred_file*() drain paths invoked by lease/oplock breaks
and tcon teardown, anchoring the protection window to the real close time
rather than the earlier userspace close.

time_last_write == 0 skips the time_before() check to avoid false
positives near boot on 32-bit systems where jiffies starts close to
INITIAL_JIFFIES.

Does not reproduce against Samba or with actimeo=0.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/cifsfs.c   |  1 +
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/file.c     | 64 ++++++++++++++++++++++++++++++++++++----
 fs/smb/client/inode.c    |  4 +++
 fs/smb/client/misc.c     | 21 +++++++++++--
 5 files changed, 83 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 66b9104e7ca2..1788d93a2522 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -440,6 +440,7 @@ cifs_alloc_inode(struct super_block *sb)
 		return NULL;
 	cifs_inode->cifsAttrs = ATTR_ARCHIVE;	/* default */
 	cifs_inode->time = 0;
+	cifs_inode->time_last_write = 0;
 	/*
 	 * Until the file is open and we have gotten oplock info back from the
 	 * server, can not assume caching of file data or metadata.
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 08e94633a9c1..79e4e84f8985 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1566,6 +1566,7 @@ struct cifsInodeInfo {
 	spinlock_t writers_lock;
 	unsigned int writers;		/* Number of writers on this inode */
 	unsigned long time;		/* jiffies of last update of inode */
+	unsigned long time_last_write;	/* jiffies of last writable close or truncate */
 	u64  uniqueid;			/* server inode number */
 	u64  createtime;		/* creation time on server */
 	__u8 lease_key[SMB2_LEASE_KEY_SIZE];	/* lease key for this inode */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 968740e7c9c3..5f5717c2b9c5 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1423,11 +1423,19 @@ void smb2_deferred_work_close(struct work_struct *work)
 {
 	struct cifsFileInfo *cfile = container_of(work,
 			struct cifsFileInfo, deferred.work);
+	struct cifsInodeInfo *cinode = CIFS_I(d_inode(cfile->dentry));
 
-	spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
+	spin_lock(&cinode->deferred_lock);
 	cifs_del_deferred_close(cfile);
 	cfile->deferred_close_scheduled = false;
-	spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
+	spin_unlock(&cinode->deferred_lock);
+	/*
+	 * Refresh time_last_write immediately before the actual server close
+	 * so the protection window is anchored to the real close time, not
+	 * the earlier userspace close time stored by cifs_close().
+	 */
+	if (OPEN_FMODE(cfile->f_flags) & FMODE_WRITE)
+		smp_store_release(&cinode->time_last_write, jiffies);
 	_cifsFileInfo_put(cfile, true, false);
 }
 
@@ -1457,6 +1465,8 @@ int cifs_close(struct inode *inode, struct file *file)
 	if (file->private_data != NULL) {
 		cfile = file->private_data;
 		file->private_data = NULL;
+		if (file->f_mode & FMODE_WRITE)
+			smp_store_release(&cinode->time_last_write, jiffies);
 		dclose = kmalloc_obj(struct cifs_deferred_close);
 		if ((cfile->status_file_deleted == false) &&
 		    (smb2_can_defer_close(inode, dclose))) {
@@ -3225,13 +3235,26 @@ static int is_inode_writable(struct cifsInodeInfo *cifs_inode)
 bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file,
 			    bool from_readdir)
 {
+	struct cifs_sb_info *cifs_sb;
+	unsigned long tlw;
+
 	if (!cifsInode)
 		return true;
 
+	cifs_sb = CIFS_SB(cifsInode);
+
 	if (is_inode_writable(cifsInode) ||
 		((cifsInode->oplock & CIFS_CACHE_RW_FLG) != 0 && from_readdir)) {
 		/* This inode is open for write at least once */
-		struct cifs_sb_info *cifs_sb = CIFS_SB(cifsInode);
+
+		/*
+		 * Readdir data is unreliable when we have writable handles or
+		 * an exclusive lease -- never allow it to change i_size, even
+		 * on direct-IO mounts where the server's directory metadata
+		 * can still lag behind the actual file state.
+		 */
+		if (from_readdir)
+			return false;
 
 		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DIRECT_IO) {
 			/* since no page cache to corrupt on directio
@@ -3243,8 +3266,39 @@ bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file,
 			return true;
 
 		return false;
-	} else
-		return true;
+	}
+
+	/*
+	 * No writable handles open. Check whether we are within the attribute
+	 * cache validity window of a recent local modification.
+	 *
+	 * For the close() path: cifs_close() calls smp_store_release() on
+	 * time_last_write before _cifsFileInfo_put() removes the handle under
+	 * open_file_lock. That spin_unlock() is a store-release that pairs
+	 * with the spin_lock() (load-acquire) in is_inode_writable() above,
+	 * so if is_inode_writable() returned false the smp_load_acquire()
+	 * below is guaranteed to observe any time_last_write update from a
+	 * concurrent close().
+	 *
+	 * For the setattr/truncate paths: those callers use smp_store_release()
+	 * directly; the smp_load_acquire() below pairs with that store. There
+	 * is no shared lock between setattr and readdir, so this relies on
+	 * acquire-release semantics alone. The store propagation latency on
+	 * weakly-ordered architectures (nanoseconds) is negligible relative to
+	 * the acregmax window (seconds) and the readdir RPC round-trip
+	 * (milliseconds), making this a sound design choice in practice.
+	 *
+	 * time_last_write == 0 means the inode has never been written locally;
+	 * skip the window check to avoid false positives near boot time when
+	 * jiffies is still close to INITIAL_JIFFIES on 32-bit systems.
+	 */
+	if (from_readdir) {
+		tlw = smp_load_acquire(&cifsInode->time_last_write);
+		if (tlw && time_before(jiffies, tlw + cifs_sb->ctx->acregmax))
+			return false;
+	}
+
+	return true;
 }
 
 void cifs_oplock_break(struct work_struct *work)
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index deed04dd9b91..fb094d96f85d 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -237,6 +237,8 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
 	if (is_size_safe_to_change(cifs_i, fattr->cf_eof, from_readdir)) {
 		i_size_write(inode, fattr->cf_eof);
 		inode->i_blocks = CIFS_INO_BLOCKS(fattr->cf_bytes);
+	} else if (from_readdir && i_size_read(inode) != fattr->cf_eof) {
+		cifs_i->time = 0;
 	}
 
 	if (S_ISLNK(fattr->cf_mode) && fattr->cf_symlink_target) {
@@ -3277,6 +3279,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 
 	if ((attrs->ia_valid & ATTR_SIZE) &&
 	    attrs->ia_size != i_size_read(inode)) {
+		smp_store_release(&cifsInode->time_last_write, jiffies);
 		truncate_setsize(inode, attrs->ia_size);
 		netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
 		fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
@@ -3478,6 +3481,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 
 	if ((attrs->ia_valid & ATTR_SIZE) &&
 	    attrs->ia_size != i_size_read(inode)) {
+		smp_store_release(&cifsInode->time_last_write, jiffies);
 		truncate_setsize(inode, attrs->ia_size);
 		netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
 		fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index e4bac2a0b85d..1d2305e63ce8 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -524,7 +524,12 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 	spin_unlock(&cifs_inode->open_file_lock);
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
-		_cifsFileInfo_put(tmp_list->cfile, false, false);
+		struct cifsFileInfo *cfile = tmp_list->cfile;
+
+		if (OPEN_FMODE(cfile->f_flags) & FMODE_WRITE)
+			smp_store_release(&CIFS_I(d_inode(cfile->dentry))->time_last_write,
+					  jiffies);
+		_cifsFileInfo_put(cfile, false, false);
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}
@@ -557,7 +562,12 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 	spin_unlock(&tcon->open_file_lock);
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
-		_cifsFileInfo_put(tmp_list->cfile, true, false);
+		struct cifsFileInfo *cfile = tmp_list->cfile;
+
+		if (OPEN_FMODE(cfile->f_flags) & FMODE_WRITE)
+			smp_store_release(&CIFS_I(d_inode(cfile->dentry))->time_last_write,
+					  jiffies);
+		_cifsFileInfo_put(cfile, true, false);
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}
@@ -626,7 +636,12 @@ void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
 	spin_unlock(&tcon->open_file_lock);
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
-		_cifsFileInfo_put(tmp_list->cfile, true, false);
+		struct cifsFileInfo *cfile = tmp_list->cfile;
+
+		if (OPEN_FMODE(cfile->f_flags) & FMODE_WRITE)
+			smp_store_release(&CIFS_I(d_inode(cfile->dentry))->time_last_write,
+					  jiffies);
+		_cifsFileInfo_put(cfile, true, false);
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}
-- 
2.55.0

