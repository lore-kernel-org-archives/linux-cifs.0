Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3579443C07
	for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2026 08:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791446988; cv=none; b=hIqV8vlxboALTTImYdFyi13W06l0r13lWG7kAraeeQwQnA/JxJEFpE8lkRPUO5a7rvf9ApJjLA+xuC7ye0mbXNff4M4CMokzr/UezQ99sSSutuqgsK684hR/RA3kJqctliDdw7bCGFLsMtZu+GdD6FdjhE/mBbxAVethAzgNtyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791446988; c=relaxed/simple;
	bh=21aJ63VUo4assiJ4EhA3h3Gkv7SbokahbICkYTJ84m8=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=cdH1bP4KKF4QevAvTRKsCIDA5ITKWeIQ5r1kcBYwwSiiiVYEP8vTqPri0XVmENqczK7iJENjTbd7197u6Ma+/KGWRRjTxUJToWf9I/9TRcHmj+EfTjsnlWi/a2H3nuZeAEHx6uIJGpozvMbY114yjDQYNj0vAt5kb/7KtCPYh9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=flf8+bbO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="flf8+bbO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791446984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=54+mKQeJFrXIb4ohYXgmPSTrEPH3oJGTGlC9cG/RNlk=;
	b=flf8+bbOC3fE3SgUe1A3YCZYdgiT3Hg3v/wvcYL+zMqMk96o2eBMTXYxmGzRfan/SuwPo6
	gSRGyQV15EWG9nmece0vThQOQyEo9AHBnwL3LYqmbDXpvtZTQYIqAICMzLYABSBNv+X3M0
	NmJZiqIsTxLZ8/WvlMZ0tFm1PIoOUN0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-151-YWhcksGfPFW6uvpRqzv4Zg-1; Thu,
 8 Oct 2026 08:09:41 +0000
X-MC-Unique: YWhcksGfPFW6uvpRqzv4Zg-1
X-Mimecast-MFC-AGG-ID: YWhcksGfPFW6uvpRqzv4Zg_1791446979
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 833F21955F12;
	Thu,  8 Oct 2026 08:09:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.90])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0B7371956086;
	Thu,  8 Oct 2026 08:09:35 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <brauner@kernel.org>
cc: dhowells@redhat.com, Marc Dionne <marc.dionne@auristor.com>,
    Paulo Alcantara <pc@manguebit.org>,
    Matthew Wilcox <willy@infradead.org>, v9fs@lists.linux.dev,
    linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
    linux-cifs@vger.kernel.org, netfs@lists.linux.dev,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fscache, cachefiles: Fix resize handling
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <938340.1791446974.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 09:09:34 +0100
Message-ID: <938341.1791446974@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Fix the resize handling in fscache and cachefiles by passing down the old
size as well as the new size so that the cache can work out whether the
file is being shrunk or expanded as the cache's idea of how big the file
should be may be stale.

The issue is that netfs_perform_write() updates the network filesystem's
file's i_size as it adds data to the pagecache, but the cache isn't update=
d
until writeback flushes that data.  A truncation may then scrap that data
and so the cache never sees it and doesn't update before it is told to
resize.  In the resize, cachefiles was comparing the new size against the
current cache size and then thinking the file was being expanded.

Reported-by: Marc Dionne <marc.dionne@auristor.com>
Fixes: 1a9fe4b6e787 ("cachefiles: Don't rely on backing fs storage map for=
 most use cases")
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Marc Dionne <marc.dionne@auristor.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: v9fs@lists.linux.dev
cc: linux-afs@lists.infradead.org
cc: ceph-devel@vger.kernel.org
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/9p/vfs_inode.c             |    4 +++-
 fs/9p/vfs_inode_dotl.c        |    3 ++-
 fs/afs/inode.c                |    4 ++--
 fs/cachefiles/interface.c     |    4 ++--
 fs/ceph/cache.h               |    6 +++---
 fs/ceph/inode.c               |    5 +++--
 fs/netfs/fscache_io.c         |    4 ++--
 fs/smb/client/cifsfs.c        |    9 ++++++---
 fs/smb/client/inode.c         |    2 +-
 fs/smb/client/smb2ops.c       |   11 ++++++-----
 include/linux/fscache-cache.h |    2 +-
 include/linux/fscache.h       |   11 ++++++-----
 12 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 3829554ca369..32f47c8ca45d 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1022,6 +1022,7 @@ static int v9fs_vfs_setattr(struct mnt_idmap *idmap,
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid =3D NULL;
 	struct p9_wstat wstat;
+	uoff_t old_size =3D i_size_read(inode);
 =

 	p9_debug(P9_DEBUG_VFS, "\n");
 	retval =3D setattr_prepare(&nop_mnt_idmap, dentry, iattr);
@@ -1086,7 +1087,8 @@ static int v9fs_vfs_setattr(struct mnt_idmap *idmap,
 		if (v9ses->cache & CACHE_FSCACHE) {
 			struct v9fs_inode *v9inode =3D V9FS_I(inode);
 =

-			fscache_resize_cookie(v9fs_inode_cookie(v9inode), iattr->ia_size);
+			fscache_resize_cookie(v9fs_inode_cookie(v9inode),
+					      old_size, iattr->ia_size);
 		}
 #endif
 	}
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 116b29e95f21..1a6a338eab08 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -519,6 +519,7 @@ int v9fs_vfs_setattr_dotl(struct mnt_idmap *idmap,
 		.uid =3D INVALID_UID,
 		.gid =3D INVALID_GID,
 	};
+	uoff_t old_size =3D i_size_read(inode);
 =

 	p9_debug(P9_DEBUG_VFS, "\n");
 =

@@ -580,7 +581,7 @@ int v9fs_vfs_setattr_dotl(struct mnt_idmap *idmap,
 #ifdef CONFIG_9P_FSCACHE
 		if (v9ses->cache & CACHE_FSCACHE)
 			fscache_resize_cookie(v9fs_inode_cookie(V9FS_I(inode)),
-				iattr->ia_size);
+					      old_size, iattr->ia_size);
 #endif
 	}
 =

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 634fbf8eb212..8fbca46a5755 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -744,7 +744,7 @@ static void afs_setattr_edit_file(struct afs_operation=
 *op)
 		if (size !=3D old) {
 			truncate_pagecache(inode, size);
 			netfs_resize_file(&vnode->netfs, size, true);
-			fscache_resize_cookie(afs_vnode_cache(vnode), size);
+			fscache_resize_cookie(afs_vnode_cache(vnode), old, size);
 		}
 	}
 }
@@ -817,7 +817,7 @@ int afs_setattr(struct mnt_idmap *idmap, struct dentry=
 *dentry,
 			truncate_setsize(inode, attr->ia_size);
 			netfs_resize_file(&vnode->netfs, size, false);
 			fscache_resize_cookie(afs_vnode_cache(vnode),
-					      attr->ia_size);
+					      i_size, attr->ia_size);
 			ret =3D 0;
 			goto out_unlock;
 		}
diff --git a/fs/cachefiles/interface.c b/fs/cachefiles/interface.c
index 789ff6abe926..3857c64275fe 100644
--- a/fs/cachefiles/interface.c
+++ b/fs/cachefiles/interface.c
@@ -204,7 +204,7 @@ static bool cachefiles_shorten_object(struct cachefile=
s_object *object,
  * Resize the backing object.
  */
 static void cachefiles_resize_cookie(struct netfs_cache_resources *cres,
-				     uoff_t new_size)
+				     uoff_t old_size, uoff_t new_size)
 {
 	struct cachefiles_object *object =3D cachefiles_cres_object(cres);
 	struct cachefiles_cache *cache =3D object->volume->cache;
@@ -218,7 +218,7 @@ static void cachefiles_resize_cookie(struct netfs_cach=
e_resources *cres,
 	/* If the file is being shrunk, we need to downsize the backing file
 	 * and clear the end of the final block.
 	 */
-	if (new_size < object->object_size) {
+	if (new_size < old_size) {
 		if (new_size >=3D i_size)
 			goto out;
 		cachefiles_begin_secure(cache, &saved_cred);
diff --git a/fs/ceph/cache.h b/fs/ceph/cache.h
index 20efac020394..705ecd4df75e 100644
--- a/fs/ceph/cache.h
+++ b/fs/ceph/cache.h
@@ -31,14 +31,14 @@ static inline struct fscache_cookie *ceph_fscache_cook=
ie(struct ceph_inode_info
 	return netfs_i_cookie(&ci->netfs);
 }
 =

-static inline void ceph_fscache_resize(struct inode *inode, loff_t to)
+static inline void ceph_fscache_resize(struct inode *inode, uoff_t old_si=
ze, loff_t to)
 {
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
 	struct fscache_cookie *cookie =3D ceph_fscache_cookie(ci);
 =

 	if (cookie) {
 		ceph_fscache_use_cookie(inode, true);
-		fscache_resize_cookie(cookie, to);
+		fscache_resize_cookie(cookie, old_size, to);
 		ceph_fscache_unuse_cookie(inode, true);
 	}
 }
@@ -96,7 +96,7 @@ static inline struct fscache_cookie *ceph_fscache_cookie=
(struct ceph_inode_info
 	return NULL;
 }
 =

-static inline void ceph_fscache_resize(struct inode *inode, loff_t to)
+static inline void ceph_fscache_resize(struct inode *inode, uoff_t old_si=
ze, loff_t to)
 {
 }
 =

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index d52e2b389e0b..b23e117380db 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2303,10 +2303,11 @@ void __ceph_do_pending_vmtruncate(struct inode *in=
ode)
 {
 	struct ceph_client *cl =3D ceph_inode_to_client(inode);
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
-	u64 to;
+	uoff_t old_size, to;
 	int wrbuffer_refs, finish =3D 0;
 =

 	mutex_lock(&ci->i_truncate_mutex);
+	old_size =3D i_size_read(inode);
 retry:
 	spin_lock(&ci->i_ceph_lock);
 	if (ci->i_truncate_pending =3D=3D 0) {
@@ -2339,7 +2340,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inod=
e)
 	      ci->i_truncate_pending, to);
 	spin_unlock(&ci->i_ceph_lock);
 =

-	ceph_fscache_resize(inode, to);
+	ceph_fscache_resize(inode, old_size, to);
 	truncate_pagecache(inode, to);
 =

 	spin_lock(&ci->i_ceph_lock);
diff --git a/fs/netfs/fscache_io.c b/fs/netfs/fscache_io.c
index 056a2bae5d99..bce0fa1f6e24 100644
--- a/fs/netfs/fscache_io.c
+++ b/fs/netfs/fscache_io.c
@@ -267,7 +267,7 @@ EXPORT_SYMBOL(__fscache_write_to_cache);
 /*
  * Change the size of a backing object.
  */
-void __fscache_resize_cookie(struct fscache_cookie *cookie, uoff_t new_si=
ze)
+void __fscache_resize_cookie(struct fscache_cookie *cookie, uoff_t old_si=
ze, uoff_t new_size)
 {
 	struct netfs_cache_resources cres;
 =

@@ -281,7 +281,7 @@ void __fscache_resize_cookie(struct fscache_cookie *co=
okie, uoff_t new_size)
 		 * netfs's inode lock so that we're serialised with respect to
 		 * writes.
 		 */
-		cookie->volume->cache->ops->resize_cookie(&cres, new_size);
+		cookie->volume->cache->ops->resize_cookie(&cres, old_size, new_size);
 		fscache_end_operation(&cres);
 	} else {
 		fscache_stat(&fscache_n_resizes_null);
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 98b610b2a114..ccc2cae2d06f 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1314,6 +1314,7 @@ static int cifs_precopy_set_eof(struct inode *src_in=
ode, struct cifsInodeInfo *s
 				unsigned int xid, loff_t src_end)
 {
 	struct cifsFileInfo *writeable_srcfile;
+	uoff_t old_size =3D i_size_read(src_inode);
 	int rc =3D -EINVAL;
 =

 	writeable_srcfile =3D find_writable_file(src_cifsi, FIND_FSUID_ONLY);
@@ -1332,7 +1333,7 @@ static int cifs_precopy_set_eof(struct inode *src_in=
ode, struct cifsInodeInfo *s
 		goto set_failed;
 =

 	netfs_resize_file(&src_cifsi->netfs, src_end, true);
-	fscache_resize_cookie(cifs_inode_cookie(src_inode), src_end);
+	fscache_resize_cookie(cifs_inode_cookie(src_inode), old_size, src_end);
 	return 0;
 =

 set_failed:
@@ -1538,6 +1539,7 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	struct cifs_tcon *src_tcon;
 	struct cifs_tcon *target_tcon;
 	ssize_t rc;
+	uoff_t old_size;
 =

 	if (len =3D=3D 0)
 		return 0;
@@ -1584,7 +1586,8 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	 * Advance the EOF marker after the flush above to the end of the range
 	 * if it's short of that.
 	 */
-	if (netfs_read_remote_i_size(src_inode) < off + len) {
+	old_size =3D netfs_read_remote_i_size(src_inode);
+	if (old_size < off + len) {
 		rc =3D cifs_precopy_set_eof(src_inode, src_cifsi, src_tcon, xid, off + =
len);
 		if (rc < 0)
 			goto unlock;
@@ -1628,7 +1631,7 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 			netfs_resize_file(&target_cifsi->netfs,
 					  i_size_read(target_inode), true);
 			fscache_resize_cookie(cifs_inode_cookie(target_inode),
-					      i_size_read(target_inode));
+					      old_size, i_size_read(target_inode));
 		}
 		if (rc > 0) {
 			spin_lock(&target_inode->i_lock);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index f29555f3c7d0..a398b2c10aaf 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3097,7 +3097,7 @@ void cifs_resize_file_locked(struct inode *inode, lo=
ff_t old_size,
 		return;
 =

 	fscache_use_cookie(cookie, true);
-	fscache_resize_cookie(cookie, offset);
+	fscache_resize_cookie(cookie, old_size, offset);
 	cifs_fscache_unuse_inode_cookie(inode, true);
 }
 =

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1e9018880639..fa019c67f9e5 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3545,7 +3545,7 @@ static long smb3_zero_range(struct file *file, struc=
t cifs_tcon *tcon,
 	struct inode *inode =3D file_inode(file);
 	struct cifsInodeInfo *cifsi =3D CIFS_I(inode);
 	struct cifsFileInfo *cfile =3D file->private_data;
-	unsigned long long i_size, new_size, remote_i_size, zero_point;
+	unsigned long long i_size, old_size, new_size, remote_i_size, zero_point=
;
 	long rc;
 	unsigned int xid;
 =

@@ -3554,8 +3554,9 @@ static long smb3_zero_range(struct file *file, struc=
t cifs_tcon *tcon,
 	trace_smb3_zero_enter(xid, cfile->fid.persistent_fid, tcon->tid,
 			      ses->Suid, offset, len);
 =

+	old_size =3D i_size_read(inode);
 	new_size =3D offset + len;
-	if (!keep_size && i_size_read(inode) < new_size) {
+	if (!keep_size && old_size < new_size) {
 		rc =3D inode_newsize_ok(inode, new_size);
 		if (rc)
 			goto out;
@@ -3611,7 +3612,7 @@ static long smb3_zero_range(struct file *file, struc=
t cifs_tcon *tcon,
 			if (offset < cifsi->netfs._zero_point)
 				netfs_write_zero_point(inode, offset);
 			spin_unlock(&inode->i_lock);
-			fscache_resize_cookie(cifs_inode_cookie(inode), new_size);
+			fscache_resize_cookie(cifs_inode_cookie(inode), old_size, new_size);
 		}
 	}
 =

@@ -4146,7 +4147,7 @@ static long smb3_collapse_range(struct file *file, s=
truct cifs_tcon *tcon,
 	netfs_resize_file(&cifsi->netfs, new_eof, true);
 	netfs_write_zero_point(inode, new_eof);
 	spin_unlock(&inode->i_lock);
-	fscache_resize_cookie(cifs_inode_cookie(inode), new_eof);
+	fscache_resize_cookie(cifs_inode_cookie(inode), old_eof, new_eof);
 out_2:
 	filemap_invalidate_unlock(inode->i_mapping);
 out:
@@ -4208,7 +4209,7 @@ static long smb3_insert_range(struct file *file, str=
uct cifs_tcon *tcon,
 	spin_lock(&inode->i_lock);
 	netfs_resize_file(&cifsi->netfs, i_size_read(inode), true);
 	spin_unlock(&inode->i_lock);
-	fscache_resize_cookie(cifs_inode_cookie(inode), i_size_read(inode));
+	fscache_resize_cookie(cifs_inode_cookie(inode), old_eof, i_size_read(ino=
de));
 =

 	/*
 	 * Move [off, old_eof) right by len. The helper copies backwards if the
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index ee524c863fa9..351a52186bf3 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -67,7 +67,7 @@ struct fscache_cache_ops {
 =

 	/* Change the size of a data object */
 	void (*resize_cookie)(struct netfs_cache_resources *cres,
-			      uoff_t new_size);
+			      uoff_t old_size, uoff_t new_size);
 =

 	/* Invalidate an object */
 	bool (*invalidate_cookie)(struct fscache_cookie *cookie);
diff --git a/include/linux/fscache.h b/include/linux/fscache.h
index f2d958bd1f48..05a562f7f0c1 100644
--- a/include/linux/fscache.h
+++ b/include/linux/fscache.h
@@ -184,7 +184,7 @@ extern struct fscache_cookie *__fscache_acquire_cookie=
(
 extern void __fscache_use_cookie(struct fscache_cookie *, bool);
 extern void __fscache_unuse_cookie(struct fscache_cookie *, const void *,=
 const uoff_t *);
 extern void __fscache_relinquish_cookie(struct fscache_cookie *, bool);
-extern void __fscache_resize_cookie(struct fscache_cookie *, uoff_t);
+void __fscache_resize_cookie(struct fscache_cookie *cookie, uoff_t old_si=
ze, uoff_t new_size);
 extern void __fscache_invalidate(struct fscache_cookie *, const void *, u=
off_t, unsigned int);
 extern int __fscache_begin_read_operation(struct netfs_cache_resources *,=
 struct fscache_cookie *);
 extern int __fscache_begin_write_operation(struct netfs_cache_resources *=
, struct fscache_cookie *);
@@ -394,8 +394,9 @@ void fscache_update_cookie(struct fscache_cookie *cook=
ie, const void *aux_data,
 =

 /**
  * fscache_resize_cookie - Request that a cache object be resized
- * @cookie: The cookie representing the cache object
- * @new_size: The new size of the object (may be NULL)
+ * @cookie: The cookie representing the cache object (may be NULL)
+ * @old_size: The old size of the object
+ * @new_size: The new size of the object
  *
  * Request that the size of an object be changed.
  *
@@ -403,10 +404,10 @@ void fscache_update_cookie(struct fscache_cookie *co=
okie, const void *aux_data,
  * description.
  */
 static inline
-void fscache_resize_cookie(struct fscache_cookie *cookie, uoff_t new_size=
)
+void fscache_resize_cookie(struct fscache_cookie *cookie, uoff_t old_size=
, uoff_t new_size)
 {
 	if (fscache_cookie_enabled(cookie))
-		__fscache_resize_cookie(cookie, new_size);
+		__fscache_resize_cookie(cookie, old_size, new_size);
 }
 =

 /**

