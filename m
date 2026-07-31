Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3874499BC
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 17:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785518021; cv=none; b=a3ECacFFU7SE/fam9H7W8/5G6rmbnzr76SlKF+RnsVpoR5eGvCC/nJ+uTGGeXA8J+QSScePk3Z8iW9M/tlmNw5CriT7/49PKrTjYWT5GSO75THGZTCr7ZYMCxuln4djtSTaL3jUxjAIqVZwyZwN2aozTom1BJQSG7Qexhq9jejY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785518021; c=relaxed/simple;
	bh=9yjp3s39FPi+R1POVoUtgFiwrIxOIHLCwRrv9oEOrbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJGFvNDXYIdujKDwq43SWz5kiYcxyukDBHiYu3NP6k42nBhL/C4gwXnpw42nDxC9aKif+SUSjPR+GU71Q9WXTMV5bDJaqjBOm6kHRDBqqAoHLNiyqI5sm76MxeKLYf5p0JTpdWREAR2n3An5bn+VAkQBJoC1MW0vWeLct/Dg3e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eBVb+8ZT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZxSqaPSQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eBVb+8ZT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZxSqaPSQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785518017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lblueWsjbHl23xri8KHQtjB5nLycM/C1Fy5fVuzIFyE=;
	b=eBVb+8ZT5+SSGgXxXvgoIMuJK3C334ku6Zrzcxo39d7BZq27u4IJqLJ7P3DlCMYs/wY5jr
	OJTlz83pHDen/s/Yecn+LV5CFB1CYvgcCUCwZ50WF//yNirTGHU/+McJvzrZBDrg1zFsWo
	DwtTfjdn3kcP17YY13grfAmHn4SaU8c=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-33yDwASQOZa9JKEm6uiL7Q-1; Fri, 31 Jul 2026 13:13:35 -0400
X-MC-Unique: 33yDwASQOZa9JKEm6uiL7Q-1
X-Mimecast-MFC-AGG-ID: 33yDwASQOZa9JKEm6uiL7Q_1785518015
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8fc6b670b4bso13072386d6.1
        for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 10:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785518015; x=1786122815; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lblueWsjbHl23xri8KHQtjB5nLycM/C1Fy5fVuzIFyE=;
        b=ZxSqaPSQe7/jwGShMRa1amA/x4ss7cqKvbCieCSuim85TNnfR6UOw7MnPdL70M6UxA
         maDDnQQl1c34YmDjdBpiKKVBrnTK8/VgXtO2XDSvpYcRDi5XBlXVXxJiETYgFp3kdW5Q
         Yf8RfgivVdy5XiSs29jwS7vJPXMyyxviLXs+6vzdP+au7dgTThwdUaySSJYQu6YoVyHg
         2358xEQBX6tn3u66SUvn+rgq1b+ryfNGgEfNAopmv96t8imLBeyRKx3321PgApgjSrB+
         8os6jotlM6PV8nDpKhN14ah/3xPiqx/cuCV6p4YR9prLq6ujTiZlqJWm5wAPDNXnSQ6x
         7ntA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785518015; x=1786122815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lblueWsjbHl23xri8KHQtjB5nLycM/C1Fy5fVuzIFyE=;
        b=pxuY5ef7KAsJGTMcEmoHMsUjUBZw8ZqZc+BQPQbRq//F5XdjEjlLkLApLu+16zNymg
         /tkAqyQPlKjSUuc/z8AjmnQTQm1QA3lnrw4bXp5ZyyfYDsJ/1f1/4lo90l23d09tGZOj
         yvCqqQXf3ot4ZJRejYeDmk1S95q+01zSpKZHYBCicgKZsEKR3JHUVrJgd+WngQNzyRvV
         Oc51Jq4WxTqS0CvRZKnEwzX8OngqcdNkXS0YdYE1HXOaeHOC6fUESIwJ69FVyV+mvhYn
         VF/mDpR6pU73UK/N26uybn4vp2PUbC62WoDg5xEEItkEjIC0MMKivzFQvNMEswGMsnlD
         mJmA==
X-Gm-Message-State: AOJu0YxKpEsvpQ9Ym5BZ4rvXvFikp+UE9zgIz25WbWcuiUyZmib0pZJr
	lD+kwFNR+9xAPja31sbljqb/F0ACglp2IaTzzdNE0VLvDPlnlzf4KhkoN/JNtxGlRTKGyuAJLkJ
	3FUJBwkVniohA6EBkwF6vt6jBKZHHCPLEPRVcVCs8vwt94SlgQe0T71I1EZg898/l96BohvAzmB
	E7r48S3AUFzI/csYxsIjgQEMUcyuQ7feGBFO5mszo703KE6O+u+w==
X-Gm-Gg: AR+sD12h56n3rGBqZV2nJLYu6Ff68gd6fDCD/mWdGZ5NQQlfB4IA5TrOx1kwN1GTvhZ
	1LtHxpR0RM7Oarn05CI27v7O3UrIIPRe2+0QSacDlUEkClDGLolB4tsqEPvlpvZC2BuKP0tskBg
	fAh6+8+86GnUrJZbU76Qj7pfONPp33XqJ0vKqjN4DVjDyfI4V/Rub6ilFogx10vxcp39lpZHPS6
	ZrNH04NR5jwcIeMpFr5OJyQ2UHgQZeRHJJb7NrzXt3npwjo80D+AwgGxvEW+dN+0lm9EJhhuMqa
	yEEU6fh6KuXLlu+r/a9fXicrPYowce0mnn64/O1UkYsnjk7jOl71bqiaMJfQozGwMt0HNWFrSlX
	rh75loMHH4C9raSNrWrJ0cFmf0xBAP/Strw93Q/ot2FhlNkOkYxLTTAFr/edw
X-Received: by 2002:a05:6214:1bce:b0:8f2:3472:5b33 with SMTP id 6a1803df08f44-9084969236dmr12079476d6.23.1785518015014;
        Fri, 31 Jul 2026 10:13:35 -0700 (PDT)
X-Received: by 2002:a05:6214:1bce:b0:8f2:3472:5b33 with SMTP id 6a1803df08f44-9084969236dmr12078376d6.23.1785518014225;
        Fri, 31 Jul 2026 10:13:34 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908434a250csm14676316d6.13.2026.07.31.10.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 10:13:22 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com,
	hehuiwen@kylinos.cn
Cc: stable@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH v3 2/4] cifs: add cifs_resize_file_locked() to guard fscache_resize_cookie() under i_rwsem
Date: Fri, 31 Jul 2026 12:12:29 -0500
Message-ID: <20260731171231.686427-3-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731171231.686427-1-sorenson@redhat.com>
References: <20260731171231.686427-1-sorenson@redhat.com>
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
 fs/smb/client/inode.c   | 24 +++++++++++++++++++-----
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
@@ -3059,7 +3059,23 @@ void cifs_setsize(struct inode *inode, loff_t offset)
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

