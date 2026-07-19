Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8F543F0BE
	for <linux-cifs@vger.kernel.org>; Sun, 19 Jul 2026 21:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784498064; cv=none; b=n5frPvFaX9z5u10lkEzGK0evzhnfxOzx+TuRNnM8eHxutiLk1Nda0tPYdkDEwNBiMTQG42oyOjB+9H6wW6wqEh/PqRDa6vHixBa8WbOM82WRrBJeAkq5NqtKhy/YracsCq85GhvGzdv/9Du9J6PgPxiAYcz3u0Jnn9wE3uMAWEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784498064; c=relaxed/simple;
	bh=UZ8fRi4vcMq+rxdYwHUKauAQ4Du9YPdMTnDfSRB2xec=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KS4xoIa7HPT35HhUfb4/D0CSZqyPv68H6B9sIdsZG//mVm9z8szaIQr3eoYJF9UHYFuUZwp2EkhXIe3JL4pEG7wjYLD/RoQzR/DSeBana/MLaPqlGAGTktYKmddKSjGt0BxHCZoiZvrFJZfZClu4TuPnZG9/AUlD9ySz2Zf7tLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C4NpN/pZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nlhY68Q2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C4NpN/pZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nlhY68Q2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784498061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3RKSl6H5sakL+5H6jt0dN475I7QrFwJGOd/1pBTZeY0=;
	b=C4NpN/pZ1tA3zYvPkd4atYBdB4pKqR58NUSi/b5pPI7/AmMCI6eO8rGwvf9eGdSTv/QmeV
	d9jcDmgBVdtIR1EknLnVvjM2BRCIkHBXOwEySAA8ugNIzmGCq/yme5Iuao7lGZ+az2m3Pz
	XqTz9hkWOh2NYk+mPmyMmAnpudTuYgY=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-vw2DSmHAO3mBI7G0R0Iynw-1; Sun, 19 Jul 2026 17:54:20 -0400
X-MC-Unique: vw2DSmHAO3mBI7G0R0Iynw-1
X-Mimecast-MFC-AGG-ID: vw2DSmHAO3mBI7G0R0Iynw_1784498059
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e9f565a6e7so9388895a34.2
        for <linux-cifs@vger.kernel.org>; Sun, 19 Jul 2026 14:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784498059; x=1785102859; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=3RKSl6H5sakL+5H6jt0dN475I7QrFwJGOd/1pBTZeY0=;
        b=nlhY68Q2bFJxHFrHTcuoDMJE2Ho/7xumMdHEA+M0EJu1xFM1ad2Aql3M7+cvfj98RX
         /HL5WxU0RKJaC2jmprfm0LeDmREc4jI0a2SPdiHgiOKk8YsXUts6sAp0E3kACN17PciI
         Rb4JDi3xV+e/rND8jfPKmVdaLEYEsRtHK2jdMMjMck/3jm0171UKG5PjdgOXBbUfxH+i
         CEwvCFm+DoBE4Ubgpus+UkEfl/P2S6BxFLmTZMjPb+fNoOH4b+t0qVovOl21EgV8GprW
         qx8869cNetu7AhsbtMcg1PZ40jJakmozFG+4sHZvNjgn5d934Wf1bsoSXFOcUuh0wUvN
         oCPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784498059; x=1785102859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=3RKSl6H5sakL+5H6jt0dN475I7QrFwJGOd/1pBTZeY0=;
        b=NW7pE9cyCDEfagN7sUMhrH2DDH1Hb/5Pv535ZwPkWgxINgT1eqlbMyg2/lc16gPvRC
         FEheEwAxAwflBo1874ZlWxkUh069wtExR9eo8Pq6Pji/ixfAtYYQmP7jqOJY8EjqsNLf
         UUisE9+j2M0/iY5JC4zWI3zqa//UUyjvxT/7SEguDPtAZUYcgEMbiJdpWzV3o9Jd49On
         1jDXJPDrhJaF7Ug3N9B6TYWfDQ+UVr0L3BXTj5+lErdTmA2kgBvvvgRUCFh+0HDOZdO0
         iBpbtR45CwxyZPhgnfmKVPF9flzUCdzZ04V5qPHumjUoCW6xiSYO8eeZLQaK5WkeKoNU
         /V6Q==
X-Gm-Message-State: AOJu0Yzom4L6+t/JfYv/vyJxa466FnBYOCl7owxr04Ezhu79Sl0VezaT
	W/AlNGxAL3/vbATQknvk6+mNvnS7Fc5rXt3WzCHbGdosFb/WA39Pzsrr8WAMond5jrmX+7Dm0+n
	cyypNkKUEoxE17rJjmnPUNcX/9DMJ28IhDBao65OI0q4jXr+7DCF9Qx8YeogGZ040lKC/N9keKf
	qyYZSO5SwFlZb5ETa7x0LwdvywymomQsHqxV82DjofHJbofsA=
X-Gm-Gg: AfdE7clc+tBElWtoOe071LYQQvNWJGZ/h6Twq4UF+CjK1hSwfMZKn1Oyq4GW1fvSVXA
	cHwNVSPQUipj4pJH6ED+DzGR/a4XxQpijXaVY0ydgHmIx6xjM0CQL1PUF/5jddgBddILsRz4pcM
	KqrMtQJbtnuLmFVwkFlzZcpb1MhFlq0iHOzZvFQHiVUM2sHWw4BM+1cfyVL/rC6rdpuoz8admDZ
	3oxroLZH10oWiP7voi1mu/DtwAZT3oOA26Q/fZqRqRvefldH2mMoM+wxXzeoiBDaJbeICy2dbrd
	yHPx+BZBYg3EEFOJHyR9qsT6Had9oJP8WqrrOnquN1g3MvKzRIONVdfCtmMmy+JnCGtGjKKTr5a
	1MebQ3swluVhCbRHSNWaSgx6BORIdieF47VY6RW1h1IFswa/BRFt12phrU7Xt
X-Received: by 2002:a05:6830:82e7:b0:7e9:e709:44f6 with SMTP id 46e09a7af769-7ed9aa39f44mr6172525a34.12.1784498059072;
        Sun, 19 Jul 2026 14:54:19 -0700 (PDT)
X-Received: by 2002:a05:6830:82e7:b0:7e9:e709:44f6 with SMTP id 46e09a7af769-7ed9aa39f44mr6172508a34.12.1784498058509;
        Sun, 19 Jul 2026 14:54:18 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7edaf98c5f4sm6469018a34.20.2026.07.19.14.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 14:54:16 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH 2/2] cifs: prevent readdir from changing file size due to stale directory metadata
Date: Sun, 19 Jul 2026 16:54:12 -0500
Message-ID: <20260719215412.1218034-3-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260719215412.1218034-1-sorenson@redhat.com>
References: <20260719215412.1218034-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Windows Server's directory enumeration metadata (EndOfFile) lags behind
the actual file size immediately after a write and close.  If a concurrent
readdir() runs in the window between close() returning to userspace and
stat() being called, it receives a stale size from the server's directory
listing and overwrites the correct cached i_size.  A subsequent stat()
within the actimeo window then returns this incorrect value.

The actual race sequence:

  1. Thread A: write N bytes to file, then close()
  2. cifs_close() calls cifsFileInfo_put(), removing the handle from
     openFileList -- is_inode_writable() now returns false
  3. Thread B: readdir() runs, server returns stale EndOfFile=0 in the
     directory enumeration response
  4. is_size_safe_to_change() returns true (no writable handles, no RW
     lease), so cifs_fattr_to_inode() overwrites i_size with 0
  5. smb2_close_getattr() completes and stamps cifs_i->time = jiffies,
     marking the (now corrupt) cache as valid
  6. Thread A: stat() finds the cache valid and returns i_size=0

The existing is_size_safe_to_change() check blocks stale size updates
from readdir while an active RW lease is held, but does not cover the
window after the last writable handle is closed.  This is a
cross-syscall-boundary race: kernel locking alone cannot prevent it
because the stale data arrives from the server after close() has
returned.

Fix this by tracking the time of the last writable close or truncate in
a new cifsInodeInfo->time_last_write field.  When readdir attempts to
change i_size, is_size_safe_to_change() now first checks whether we are
still within acregmax jiffies of the last local write.  If so, the
update is blocked regardless of whether any file handles remain open.

When the size update is blocked and the server-reported size differs from
the locally cached value, cifs_i->time is set to zero.  This invalidates
the attribute cache so that the next stat() issues a fresh QUERY_INFO
to the server, which returns the authoritative size from the server's
open-file table rather than the stale directory enumeration metadata.
This is the same mechanism used by actimeo=0, which prevents the bug
entirely by bypassing the attribute cache on every stat().

Additionally, when the file has writable handles open or holds an active
RW lease, readdir is now unconditionally blocked from changing i_size
(previously it could grow i_size from readdir data in those cases).
With writable handles or an exclusive lease, the client is the
authoritative source for the file's size and readdir data is unreliable.

time_last_write is also set in the setattr truncation paths so that
truncate() followed by write()+close()+stat() is protected by the same
mechanism.

Reproducer: concurrent write+close+stat and readdir with 2 or more
threads against a Windows Server share.  The bug does not reproduce
against Samba (no directory metadata lag) or with actimeo=0 (attribute
cache bypassed).

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/cifsfs.c   |  1 +
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/file.c     | 24 +++++++++++++++++++++---
 fs/smb/client/inode.c    |  4 ++++
 4 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 4df6ca03a8de..505b9ef1a08a 100644
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
index 08e94633a9c1..bf8dc8d16fae 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1566,6 +1566,7 @@ struct cifsInodeInfo {
 	spinlock_t writers_lock;
 	unsigned int writers;		/* Number of writers on this inode */
 	unsigned long time;		/* jiffies of last update of inode */
+	unsigned long time_last_write;	/* jiffies of last local write/close */
 	u64  uniqueid;			/* server inode number */
 	u64  createtime;		/* creation time on server */
 	__u8 lease_key[SMB2_LEASE_KEY_SIZE];	/* lease key for this inode */
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 968740e7c9c3..84ecbca01d69 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1452,6 +1452,9 @@ int cifs_close(struct inode *inode, struct file *file)
 	struct cifs_deferred_close *dclose;
 	struct cifs_tcon *tcon;

+	if (file->f_mode & FMODE_WRITE)
+		cinode->time_last_write = jiffies;
+
 	cifs_fscache_unuse_inode_cookie(inode, file->f_mode & FMODE_WRITE);

 	if (file->private_data != NULL) {
@@ -3225,13 +3228,21 @@ static int is_inode_writable(struct cifsInodeInfo *cifs_inode)
 bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file,
 			    bool from_readdir)
 {
+	struct cifs_sb_info *cifs_sb;
+
 	if (!cifsInode)
 		return true;

+	cifs_sb = CIFS_SB(cifsInode);
+
+	if (from_readdir) {
+		if (time_before(jiffies, cifsInode->time_last_write + cifs_sb->ctx->acregmax))
+			return false;
+	}
+
 	if (is_inode_writable(cifsInode) ||
 		((cifsInode->oplock & CIFS_CACHE_RW_FLG) != 0 && from_readdir)) {
 		/* This inode is open for write at least once */
-		struct cifs_sb_info *cifs_sb = CIFS_SB(cifsInode);

 		if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_DIRECT_IO) {
 			/* since no page cache to corrupt on directio
@@ -3239,12 +3250,19 @@ bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file,
 			return true;
 		}

+		/* Readdir data is unreliable when we have writable handles or
+		 * an exclusive lease -- never allow it to change i_size. */
+		if (from_readdir)
+			return false;
+
 		if (i_size_read(&cifsInode->netfs.inode) < end_of_file)
 			return true;

 		return false;
-	} else
-		return true;
+	}
+
+	return true;
 }

 void cifs_oplock_break(struct work_struct *work)
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index e75138f5f6bc..026382b7d4fe 100644
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
@@ -3280,6 +3282,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 		truncate_setsize(inode, attrs->ia_size);
 		netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
 		fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
+		cifsInode->time_last_write = jiffies;
 	}

 	setattr_copy(&nop_mnt_idmap, inode, attrs);
@@ -3481,6 +3484,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 		truncate_setsize(inode, attrs->ia_size);
 		netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
 		fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
+		cifsInode->time_last_write = jiffies;
 	}

 	setattr_copy(&nop_mnt_idmap, inode, attrs);
--
2.55.0

