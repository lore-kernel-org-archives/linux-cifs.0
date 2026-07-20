Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433F643F4C4
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 16:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784565355; cv=none; b=g/5ll73jJpSqxhJZdA0SgyKBIdx5gsPm2P7jAlRig8f4l3/6ZC24HMsreMfsYCTxj+3WX4UnOG7BAfrMXEbad6yzTOEcfcAMYXwaTOOu9fdgZuH7PzxGCi6TEvWRWwkFni/I7hAugmYuMAydaoTXZb9UwZkTizMjKpievwhA6Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784565355; c=relaxed/simple;
	bh=hSu36/k5dMQ/DQLFJ7bN1nSK2gF3nnTCZUvllCYHAek=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7CX/f08mYDo+J8ua5OREwGNHVFdpUz+IvkTM+lpxy/XjH299BXdrdO/OjtshZ4yogapqwPNzNWyh8eDxgTr6VQ2aRpql9VeZVdUl1ei7kDMaXFh9Aktj3qr9FjU+1LcRSHY08tzn4mAZcgmn4bVj8X42AOXqAch2A4aJ/fV5A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EAJZ9c+E; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=TnTGUmTg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EAJZ9c+E";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="TnTGUmTg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784565350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WN4i2zuSFtb+GJAOx53/sEiNJfqqiB/S5ytlLPuvNfU=;
	b=EAJZ9c+ErSzbI5yjGtHbiCLeWK9vyz2+kV7fkka7F5mtVVn8eN0CkVheExbIhyvUCELBCt
	c8G9RZCwXNiVW37pB5yny4jPMxpWE5CU4G2WMP1ND9Yl8ixrjrHUt07AUum19l1wfZrR7v
	C/vctZCdeeA9110DhJNtNS7B8sX1G58=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-ykdOYXnqMo6gjgx5HUFc7g-1; Mon, 20 Jul 2026 12:35:48 -0400
X-MC-Unique: ykdOYXnqMo6gjgx5HUFc7g-1
X-Mimecast-MFC-AGG-ID: ykdOYXnqMo6gjgx5HUFc7g_1784565347
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7eb60cfd476so6844007a34.3
        for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 09:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784565347; x=1785170147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=WN4i2zuSFtb+GJAOx53/sEiNJfqqiB/S5ytlLPuvNfU=;
        b=TnTGUmTgYUI1R27Z3hTJL00hvZcCVpKyLaw3W37WtYWehezEbGjqGuJfbI3Pmj7GV/
         0s8fBybTQ19yyOk7QO71OcXNjzqt5gWx51+jjpB6FEtl2wT3if8Bq7QAu04bY10pVJEQ
         CKjNHqvvIA0Cf3sAwvSQXTJ7Y7PHY7h0pJz/5WbznbHtnVelHDjMvwRjUEyKO83amjUk
         iRLxRJbTQhznQjm7WIa7ooPyBOZc9+3W7gLS6MRaXIj1l5MUWWVqQIXEuK10rPa1AAbX
         wnmTGP7lizj3i3ZjM922W1CbA3GP4eBLLvHyTz283ch5VqDoPZbUFQsX7QsMjS0DZuFd
         WBTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784565347; x=1785170147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=WN4i2zuSFtb+GJAOx53/sEiNJfqqiB/S5ytlLPuvNfU=;
        b=fs5uHAKC+2DTkyKIpHZJaB3duMnzgboLJ4ZTpA45LwUaYc7xZrtQkthYFFsyTht43H
         cilNSpxz1FarvJJaQXcy3etfUYTcU2s7J3WHSDjjKRWP4+JmJsvvZh2GdvwbWwEnP5Lu
         lqSX0USBzAmtFG5iiPwAygsZALkGQg8bayJgrvebPSlkIUaCaxtddDuh0Tc1I0BvWjI/
         Ccz5BDd39PbSKQIMAgU3A6lCxxk0B8oS6kqrRrO+T8VDxqIN+yaz74IIbLrLie/p1tYe
         Kut/B1bq2LrraB3h7tFp/M9vXEstIvxC7Rq86VYv3xqKXqptdAFFIdN7Ll08kqO3DZPb
         cVEg==
X-Gm-Message-State: AOJu0YyqvSF7QXbs48qP4X56MESxTjcQ2iLvTj+KW/j/W/LSKlwXS+7b
	gL96BBUC4zjP80QOnRhyqbNsnMMjpv8X00tPFcjfPuDH4bbPrJy85AOb2TMRjqj8X1iMGVbanPu
	wNjEBbPNDSdnQDkpbhMIOLdsNRk5zgJCyEKCY/pBZx7WQJOpOY18MLUac1KSXSK/0+l8dO4gqVi
	azONulwSm8o9ZAbYfPEWUqJFWgv6VImQDeICoudWpD82e8/hQ=
X-Gm-Gg: AfdE7cnr/09ryV9Mw/pNy7P/sOWNWmrGkw9+CWKUX0fuGyk1uAspTOhRJmxoADnos51
	o7x8TE0TNIeEGiVA2g8h3CBfysKfxEyStG17pKlrTgmUKbBXJ7gFSSya2Dkdu9AHlz1beD9GwLK
	UeXszq+4j4BvnA6QxHA6XbASCd+Gl7nSMtdtp+DaS/eMqHOiKbEoWoq4trqOEwaZ1HdxTxQnYhY
	jg8YsuHXuBQvOh+7A4U/Cj8Kn6EyDtwD6ikVEAPU82Ub+izFA0FkXMPGTOqPZkZ8CogjE8+i90X
	zmbc3OfWvJPwb5edAof6W2pqa+a05Ekk5RbdXyH2MIyQpei5brFVY9WHSzQRVFFvdUuw17RuDQw
	bf8W8GD4n580FFz3oMxb92VqW6rEjHGQiCseZ0b8YDg4abP3yVrHLt+oSUoMA
X-Received: by 2002:a05:6830:2b09:b0:7e7:8dc0:3951 with SMTP id 46e09a7af769-7eda0700a00mr7984132a34.8.1784565347329;
        Mon, 20 Jul 2026 09:35:47 -0700 (PDT)
X-Received: by 2002:a05:6830:2b09:b0:7e7:8dc0:3951 with SMTP id 46e09a7af769-7eda0700a00mr7984109a34.8.1784565346769;
        Mon, 20 Jul 2026 09:35:46 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7edaf9cd6f4sm8662312a34.23.2026.07.20.09.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 09:35:44 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH v2 2/2] cifs: prevent readdir from changing file size due to stale directory metadata
Date: Mon, 20 Jul 2026 11:35:41 -0500
Message-ID: <20260720163541.1428872-3-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720163541.1428872-1-sorenson@redhat.com>
References: <20260720163541.1428872-1-sorenson@redhat.com>
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
@@ -3239,12 +3250,18 @@ bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file,
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

