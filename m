Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6F040B10A
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 15:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512114; cv=none; b=PcAvdtCQaLdPPStSGeGJV+YAbaP8hYAX6K4ogzkIxsPUTP7GqDM0czjWii+2hDaf+KtHLqeb3fBqRYUjUfymhYOyIiHwftZ3Q4oYj8XFmdk6rZI2DYY07OqnA82+Ta2WJ5VAoAV96s0k2pGkDr7VxQSfHpRHVb811v900GWON/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512114; c=relaxed/simple;
	bh=5eLSGiUCN8iGOwEeRJziuepXnQX61i/bQlj83BnxNlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJpDhUey7zqqy56stOnjKtjOqF7xOLiuX4UMfgVCRCs8yu+DpRGXEPPhvyqVC5+jbfZzmVj/IzxXGxx7HAnbmsXQowHjlxaKxFXp/petlx3Yd//sJgx3ntz6vMXTI7kubXKN1CT0VirohTtX5nUWX+3jISKW1wOOGg1z+pL2Zc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h5cQSJ0q; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=CvislQLe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h5cQSJ0q";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="CvislQLe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785512111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zIQYiyBBm+UbJo+ijOe9n+wW+fdaMxBwNGjWkYVE3JU=;
	b=h5cQSJ0qlkKbPfXaQiQkDBnzDeYDkT5CaOqAdUWXfFT0M6hAgEF9DHfsYNeWLKaO+zkSRe
	vVP1iHaQF5cbO4v+NLCpQ1wUJlT2Ad2hek0M1JYGAiWZ2PVT+JFy70Ls1RnFrXyaqsE0jD
	Y8UNZQma5yPbbc9Q5GpIYBAEsCPNFwE=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-_LF8Z0yIMVSmvSyUZtfwfA-1; Fri, 31 Jul 2026 11:35:10 -0400
X-MC-Unique: _LF8Z0yIMVSmvSyUZtfwfA-1
X-Mimecast-MFC-AGG-ID: _LF8Z0yIMVSmvSyUZtfwfA_1785512110
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4a45b3f0bdfso1283387b6e.1
        for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 08:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785512109; x=1786116909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zIQYiyBBm+UbJo+ijOe9n+wW+fdaMxBwNGjWkYVE3JU=;
        b=CvislQLelCYyv23Oz6eM+o7jFmRUtSdWIh+QKR4walh+V6mmoHk5SZ44AiToE9wHBJ
         IXjFbaTqafVdYB20f7TTlAh5h6axbygsRQMTP1S1cznD8Q0QgmFJ3I2NlVT1qYxTSTTT
         Q3ffcOcIguQvaxa0+Rf/JDv5NKtccgk2Z2EfgEVUEVmE/vqVaunSWe1/E2DeoRekGvev
         rnv3wqPX18dVw1hlr9m7T4DEmutZ06qpCxWIb3Mta8PCm3SxubGHdmujODHmHIFkQrCN
         tjgguC62wrXqhEpJN29j38u4nrYdjQTglyFLXOscwEGNOsg+njyt7pKmZR4rKkGkqaPO
         ZdDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512109; x=1786116909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zIQYiyBBm+UbJo+ijOe9n+wW+fdaMxBwNGjWkYVE3JU=;
        b=ovU/0qwCPXqQGBKyOqDtF4OGQKJ1JfuYrPI/pFilWJ8uc2K2Aitje96VUIu/lv0ZGB
         1C6rOT08l+TAEq94OHQGXTBXwbzyw2+op9pRs3fElmBVMpIslldcfGBJGrBmait8ByXe
         VehVbYtAt+I3Tg/SR4FNCo0+UR/kWH99t0NOoYOJrCJOWp7jHezPuQMAEa4ntUDJGPCh
         DNG1Sery5IPeCf0ZUvMgWUl9dgafVDuWj0ILj+oOPJJG/ZGMRAM1uVXoWbwv7C7r5M6N
         XtyYGCLfqqWNyQ7J2gIqSb41uGDABo0XwThxOfUeWWnrC/3CYIDu1aver9fylPQVHXNA
         To1Q==
X-Gm-Message-State: AOJu0YylYlRpOy2cY+QrvvOgP5D65OHpNZL533LzZztKIEtjD3JgoZFp
	WkyPImr9Q5YlmRQWiGCkEcRrHFFaiTldoUN1MHQZxIU2SgqJIc6HrGLNKoQlm3sQL5uZQH/5/tK
	DdwVM2VvU1mXotnmAFv+UtgkokP+Sh+mAlAI/sEMZQbdbu35ZZ5IfN8ntMuKGBvDPRfcnYWejNT
	rZ7OOFBCFxpA/F7LeZK7uLi2m8UsRVlHl9HcysiBKr8pGd9sL+nw==
X-Gm-Gg: AR+sD13Mt6pqGACGH2LpaHMxwBROgMFgXVfK/LOtPObQC5e7sZRWxZ2bKpEEdcAs/pL
	BTrg1GP05d+ZPf3AGvbni13m+oFUwX8cbFyWd7RLsfbx9U/3O/3HbcIVxyhbs6xeXspHsvTsPB7
	/XG//7YTkbSqG6B7YH4NZ+ea/cr5Cbfnndf5dOFFu/rxuBJsBU0T5KrEx0H6SFfY5Hn6uA6iAMR
	r454vFMVIbEr+++i49+uLiZ1RF5A3LxItoFBFJrFTBCrqUdO1isFN+KBFrGDHqcdd7gyvKKGaUZ
	DEIZ+f7JKy1JMDLB8RqblhwpnQRGxTmAsulGIEnBAZ1iyz5ERn3OS0K0HFlqlpPXGZd+zZE9zwz
	z2so81cqGugoW5k0TSxQrjyPhnSzeGG+o0RW3iHN1IW289DUOTVgDDCV6ob7T
X-Received: by 2002:a05:6808:2225:b0:4ab:230c:5faa with SMTP id 5614622812f47-4af5e3e5522mr502530b6e.18.1785512109503;
        Fri, 31 Jul 2026 08:35:09 -0700 (PDT)
X-Received: by 2002:a05:6808:2225:b0:4ab:230c:5faa with SMTP id 5614622812f47-4af5e3e5522mr502472b6e.18.1785512108934;
        Fri, 31 Jul 2026 08:35:08 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4af58ce144esm855813b6e.1.2026.07.31.08.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:35:06 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com,
	hehuiwen@kylinos.cn
Cc: stable@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH v2 2/4] cifs: add cifs_resize_file_locked() to guard fscache_resize_cookie() under i_rwsem
Date: Fri, 31 Jul 2026 10:34:58 -0500
Message-ID: <20260731153500.660569-3-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731153500.660569-1-sorenson@redhat.com>
References: <20260731153500.660569-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_setsize() calls fscache_resize_cookie() without holding i_rwsem.
When the fscache cookie is active (FSCACHE_COOKIE_IS_CACHING is set),
fscache_resize_cookie() performs a real resize that requires i_rwsem
held exclusively.  If another file descriptor has the same inode open,
fscache_use_cookie() was already called from that cifs_open(), making
the cookie active.  In that case, calling cifs_setsize() from
cifs_do_truncate() (invoked from cifs_open() without i_rwsem) races
against concurrent fscache I/O.

Strip fscache_resize_cookie() from cifs_setsize(), making it a pure
size/page-cache helper.  Add cifs_resize_file_locked() for callers
that already hold i_rwsem: it calls netfs_resize_file() and
cifs_setsize(), then temporarily activates the cookie with
fscache_use_cookie() to perform the resize under the lock, then
deactivates it with cifs_fscache_unuse_inode_cookie().  Using
fscache_use_cookie() before the resize ensures correctness whether or
not another fd already holds the cookie active.

Switch cifs_file_set_size(), smb2_duplicate_extents(), and both size-
extension branches of smb3_simple_falloc() to the new wrapper; those
paths already hold i_rwsem via VFS setattr, lock_two_nondirectories(),
or cifs_fallocate() respectively.  cifs_do_truncate() continues to
call cifs_setsize() followed by cifs_invalidate_cache(), since it runs
without i_rwsem.

Fixes: fa724e235cfd ("cifs: add fscache_resize_cookie() to cifs_setsize()")
Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
---
 fs/smb/client/cifsfs.h  |  1 +
 fs/smb/client/inode.c   | 24 +++++++++++++++++++++---
 fs/smb/client/smb2ops.c |  9 +++------
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 854e672a4e37..651670c19c2b 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -147,6 +147,7 @@ ssize_t cifs_file_copychunk_range(unsigned int xid, struct file *src_file,
 
 long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg);
 void cifs_setsize(struct inode *inode, loff_t offset);
+void cifs_resize_file_locked(struct inode *inode, loff_t offset);
 
 struct fs_context;
 struct smb3_fs_context;
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 0afff761aab9..eaf27a9cf4f5 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3059,7 +3059,26 @@ void cifs_setsize(struct inode *inode, loff_t offset)
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	truncate_pagecache(inode, offset);
 	netfs_wait_for_outstanding_io(inode);
-	fscache_resize_cookie(cifs_inode_cookie(inode), offset);
+}
+
+void cifs_resize_file_locked(struct inode *inode, loff_t offset)
+{
+	struct fscache_cookie *cookie = cifs_inode_cookie(inode);
+
+	lockdep_assert_held_write(&inode->i_rwsem);
+
+	netfs_resize_file(netfs_inode(inode), offset, true);
+	cifs_setsize(inode, offset);
+
+	if (!cookie)
+		return;
+
+	fscache_use_cookie(cookie, true);
+	fscache_resize_cookie(cookie, offset);
+	cifs_fscache_unuse_inode_cookie(inode, true);
 }
 
 int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
@@ -3125,10 +3144,8 @@ int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
 	cifs_put_tlink(tlink);
 
 set_size_out:
-	if (rc == 0) {
-		netfs_resize_file(&cifsInode->netfs, size, true);
-		cifs_setsize(inode, size);
-	}
+	if (rc == 0)
+		cifs_resize_file_locked(inode, size);
 
 	return rc;
 }
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 192649fec25d..0e872d58fae7 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2222,8 +2222,7 @@ smb2_duplicate_extents(const unsigned int xid,
 		rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
 		if (rc)
 			goto duplicate_extents_out;
-		netfs_resize_file(netfs_inode(inode), dest_off + len, true);
-		cifs_setsize(inode, dest_off + len);
+		cifs_resize_file_locked(inode, dest_off + len);
 	}
 	rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
 			trgtfile->fid.volatile_fid,
@@ -3776,8 +3775,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 			}
 
 			new_eof = off + len;
-			netfs_resize_file(&cifsi->netfs, new_eof, true);
-			cifs_setsize(inode, new_eof);
+			cifs_resize_file_locked(inode, new_eof);
 
 			qrc = SMB2_query_info(xid, tcon,
 					      cfile->fid.persistent_fid,
@@ -3825,8 +3823,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		if (rc)
 			goto out;
 
-		netfs_resize_file(&cifsi->netfs, new_eof, true);
-		cifs_setsize(inode, new_eof);
+		cifs_resize_file_locked(inode, new_eof);
 
 		qrc = SMB2_query_info(xid, tcon,
 				      cfile->fid.persistent_fid,
-- 
2.55.0

