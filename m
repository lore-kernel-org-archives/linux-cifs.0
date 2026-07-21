Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC63F38238F
	for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 23:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784678161; cv=none; b=s9JbtbFcIe5ALQiWD2nXX9STiTbngcBxOwQSpo32AB/BlUYgyhkWyDa4KpN3c0W/C7r4gJecU+IeDPwrlTjwnPUoC6zSU6/DTvo0HDO8iyr+K26aMFFDr5rGrXbiI0PpKFxQt+09YDGFuaStcf6pKi6WLw3RYMhN48JduNg0/4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784678161; c=relaxed/simple;
	bh=qj5U3YHhz4CiJjM6ogek7lxuMp2Jq6SVQqO1rMgfvxU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQTWoKaRCqvloG4qIcWvUgCed5RY6vaG6omxeqHLYqSqf70eQMx+yWHNmcMGjQug6jInOqA9MxImBpRtOaNWhhb0DbaZzcFIvp3GRBbGM94f1OSn14t8osXV5CfUjtnkDNEG9onmgX9o0CrKHFqADpr3yMEiUGseDm3cWB7uJfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MfuKLYu4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pz5u8ZFf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MfuKLYu4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pz5u8ZFf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784678158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ZKHQi1FrW8tIx5hCdpwSRTS/1MYApCE4GYSUC3MX5w=;
	b=MfuKLYu4PftcOFEsk9CKGfQxOUF2TZbrXSsxvyGi7Z7Dnxt+rkP6A7gnhZLfhcdXat0/9v
	l/ME1chioPPVkpDnTGXXSF5w8Txs1RGfM+6jjdq7+s6OKXa5tBN7cpwOV0ZSX2/zAYN9LB
	tg2txshinoHH+ySHHQTrIgLlSc0ItJg=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-4VhWpGtNMxin3IhApX1ZIA-1; Tue, 21 Jul 2026 19:55:57 -0400
X-MC-Unique: 4VhWpGtNMxin3IhApX1ZIA-1
X-Mimecast-MFC-AGG-ID: 4VhWpGtNMxin3IhApX1ZIA_1784678157
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6a372a5be46so13483675eaf.1
        for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 16:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784678157; x=1785282957; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/ZKHQi1FrW8tIx5hCdpwSRTS/1MYApCE4GYSUC3MX5w=;
        b=Pz5u8ZFfa0MxiuBoUAwc/0/5wu7DnHAkTL8kIm9nMVHh1IRr8ECg8EcJeHuhQsizOT
         aRGzrEB0H8GKppQd0mfztQgKyuJbQe5PkBV+4i6t7e65pFOR5UHWvVafen8Ly6sXDOmc
         ndEwOgBY2xxaFzEniBsdbmXGd+eCLUmTuk+JnMQZq/FHoTY1WdzuzuEaH26p4PiBOPBW
         Peq0fQ+g4nK2P1gh36+iVkcYuCf+Z1E81vqA1PLo1Q1a7w5LXVtSZGf/4Tlj9z7yMRHE
         rv/OJsD89V2b2Ny5dNQCEcAGkaNpG/EDxonLYG5P8I8Q5W5yltlo5wv1RGIJjGNQ2m8P
         UdPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784678157; x=1785282957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=/ZKHQi1FrW8tIx5hCdpwSRTS/1MYApCE4GYSUC3MX5w=;
        b=EPpss40QqaaCyBNE60XFeLLeyog1N5wslc+yis786FtDuD5DUUpZ8W36o/VdS5PmCA
         NGIkU49S37arQ3WOM+WdDACjyJY9PwAj30YPnVpSXlbP1GOnJtKHEQvDrKnhyug+DOLf
         vT4PbvID76taIV0tOcw+mzZ+HCodLn8DwAYmlY/wjtexqsHN0Jy6uvZK/5sE9gnJQlgc
         M3pjdH+2J1SBqZ2s4X/gg2pS7NRGLvcJX9TqOKtNAInZsTiPmFWkeXMvHqOs5WYdM0wO
         DfEBQcn6mx3is7JTwM+zlCR51Lm/Y7TL4VBzz9bFMEaTB7iuvFeisop5U0dMjb3Ltqcv
         GTTw==
X-Gm-Message-State: AOJu0YwiCnm7xB/R+asRusuLoRG5i/ueZOTSesxxKYFi/9U3UsbgXDEc
	HCRJyhGIZ/o/sAEEBa7orPeJGBGOmcEHfIEgPDlL0nXKF2+7dlkrieQO2XDirJcMGvoUVtkq5eE
	Zsu2CrinnYTjAOeWatC+B0j0hO4S6nKZlC0cbicnOjqxWuBnMSqixu3vL8gD8DQFPKGnjovWSoZ
	VyD35xLMMQ0j+gBNo6mdMXGZv9eY6d4aETrWFuf6Oat3yo1vg=
X-Gm-Gg: AfdE7clBcumhT5ULqNV/idHfQ4SBF2ciiUVRGRZkixNg/Alg2sYkUMYfbnRX6H8Ht45
	xG8onws2/JCG21J3RxFMPlE90MESGNLXlPdzYG9GoXYLvM66uaE/LXN+xLIpEecd923bBnv8tYq
	r2Lz4ffw8UTvHriOlgzi2Wx92gtkaSmm83+1vGl7WZQVa1mHVIAuJH0LACP/yc0DfQXgouivMwt
	bhNe+32Zo5cNsW7ulN7vSdwI1z732C5fEIozP8uIhU6W2NGLjPSp3U6ij8kAm9JML1wUi5wvNmu
	qf9NB25bD88/B2sy3TDtMUQXUK0LcFBwJUqBIyj3Pm7JzgWoDB2C6WEvKPjgpfG2NbyDIZSWESG
	ghWaEUYMpCpRyc4PirPUnHwA17Zyu2aw00NqVwz3ddPepeJVA2jf41gfzigUX
X-Received: by 2002:a05:6820:2910:b0:6a3:8e51:7a4b with SMTP id 006d021491bc7-6a536680360mr10037397eaf.10.1784678156402;
        Tue, 21 Jul 2026 16:55:56 -0700 (PDT)
X-Received: by 2002:a05:6820:2910:b0:6a3:8e51:7a4b with SMTP id 006d021491bc7-6a536680360mr10037380eaf.10.1784678155836;
        Tue, 21 Jul 2026 16:55:55 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-457673e1f1fsm731805fac.9.2026.07.21.16.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 16:55:54 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH v4 1/2] cifs: prevent readdir from changing file size due to stale directory metadata
Date: Tue, 21 Jul 2026 18:55:51 -0500
Message-ID: <20260721235552.1839780-2-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721235552.1839780-1-sorenson@redhat.com>
References: <20260721235552.1839780-1-sorenson@redhat.com>
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

Once _cifsFileInfo_put() removes the last writable handle from
openFileList, is_size_safe_to_change() permits readdir to overwrite
i_size.  smb2_close_getattr() then stamps cifs_i->time = jiffies, making
the corrupt cached value appear fresh to the next stat().

The existing check (see Fixes:) only blocked stale size updates while
an active RW lease was held, not after the last writable handle closes.

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

Fixes: e4b61f3b1c67 ("cifs: prevent updating file size from server if we have a read/write lease")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
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
index 968740e7c9c3..b279a44be729 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1423,11 +1423,21 @@ void smb2_deferred_work_close(struct work_struct *work)
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
+	if (OPEN_FMODE(cfile->f_flags) & FMODE_WRITE) {
+		/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
+		smp_store_release(&cinode->time_last_write, jiffies);
+	}
 	_cifsFileInfo_put(cfile, true, false);
 }
 
@@ -1457,6 +1467,10 @@ int cifs_close(struct inode *inode, struct file *file)
 	if (file->private_data != NULL) {
 		cfile = file->private_data;
 		file->private_data = NULL;
+		if (file->f_mode & FMODE_WRITE) {
+			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
+			smp_store_release(&cinode->time_last_write, jiffies);
+		}
 		dclose = kmalloc_obj(struct cifs_deferred_close);
 		if ((cfile->status_file_deleted == false) &&
 		    (smb2_can_defer_close(inode, dclose))) {
@@ -3225,13 +3239,26 @@ static int is_inode_writable(struct cifsInodeInfo *cifs_inode)
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
@@ -3243,8 +3270,40 @@ bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file,
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
+		/* Pairs with smp_store_release() at close and truncate sites. */
+		tlw = smp_load_acquire(&cifsInode->time_last_write);
+		if (tlw && time_before(jiffies, tlw + cifs_sb->ctx->acregmax))
+			return false;
+	}
+
+	return true;
 }
 
 void cifs_oplock_break(struct work_struct *work)
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index deed04dd9b91..b2806371bfde 100644
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
@@ -3277,6 +3279,8 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 
 	if ((attrs->ia_valid & ATTR_SIZE) &&
 	    attrs->ia_size != i_size_read(inode)) {
+		/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
+		smp_store_release(&cifsInode->time_last_write, jiffies);
 		truncate_setsize(inode, attrs->ia_size);
 		netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
 		fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
@@ -3478,6 +3482,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 
 	if ((attrs->ia_valid & ATTR_SIZE) &&
 	    attrs->ia_size != i_size_read(inode)) {
+		/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
+		smp_store_release(&cifsInode->time_last_write, jiffies);
 		truncate_setsize(inode, attrs->ia_size);
 		netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
 		fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index e4bac2a0b85d..0301ca932ce9 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -524,7 +524,14 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 	spin_unlock(&cifs_inode->open_file_lock);
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
-		_cifsFileInfo_put(tmp_list->cfile, false, false);
+		struct cifsFileInfo *cfile = tmp_list->cfile;
+
+		if (OPEN_FMODE(cfile->f_flags) & FMODE_WRITE) {
+			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
+			smp_store_release(&CIFS_I(d_inode(cfile->dentry))->time_last_write,
+					  jiffies);
+		}
+		_cifsFileInfo_put(cfile, false, false);
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}
@@ -557,7 +564,14 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 	spin_unlock(&tcon->open_file_lock);
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
-		_cifsFileInfo_put(tmp_list->cfile, true, false);
+		struct cifsFileInfo *cfile = tmp_list->cfile;
+
+		if (OPEN_FMODE(cfile->f_flags) & FMODE_WRITE) {
+			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
+			smp_store_release(&CIFS_I(d_inode(cfile->dentry))->time_last_write,
+					  jiffies);
+		}
+		_cifsFileInfo_put(cfile, true, false);
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}
@@ -626,7 +640,14 @@ void cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon,
 	spin_unlock(&tcon->open_file_lock);
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
-		_cifsFileInfo_put(tmp_list->cfile, true, false);
+		struct cifsFileInfo *cfile = tmp_list->cfile;
+
+		if (OPEN_FMODE(cfile->f_flags) & FMODE_WRITE) {
+			/* Pairs with smp_load_acquire() in is_size_safe_to_change(). */
+			smp_store_release(&CIFS_I(d_inode(cfile->dentry))->time_last_write,
+					  jiffies);
+		}
+		_cifsFileInfo_put(cfile, true, false);
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}

---
2.55.0

