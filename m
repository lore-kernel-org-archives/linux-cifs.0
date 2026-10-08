Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5204AA57E
	for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2026 13:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466516; cv=none; b=lfLdW4gU5nNTDLYn/7qrzDzWhtM7h6OqAW9xSyNcz1dV+YSkNs0oQEwc3J+5j5a/YCDvGe7wXrxHWJ4mRYs80ypU9Hef196oAvHkg6b5AVTCC3cPpoGyZlbo4UCCa8EsVxFC0LXIBDCeII11ShK1DEnKQaH52O53ZYgcJcefRYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466516; c=relaxed/simple;
	bh=8z8wA/e8nE8koCmO5qZsRTZdCHSWdRhoCddw8xtahVY=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=mWjHA3oE7PMTnUWko09Rc0OhniVhGXMYkToY2nrBYPYj+ftNVIkPTRWQwN5qpasvM1DsAofSP7iaUmp538xIF/Wc+DLiEiW6tHrCLJtcxCxcIJSnrhofWXLa3RqTEyBFytBkFkbMeFEG3MJpde6+5I5vi8vtAFH5k6fTSt/3l9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aQGFPdFs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aQGFPdFs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791466509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=u2OpvBR4t1NvbLnU8i3AzAMGAzr6OL5iIbWS5zRYTsQ=;
	b=aQGFPdFsiZmDZgPSI4mQYUG9P4CuegMx7lsTNm9spe1fmLobR0S0m6mxSoF27UHoXqyDuL
	wNdrDym12hZp9tgjxmsSSGVL/dXYvx77KZA5vaPgVz/aFSnW4e2U8JOg5aOnPutfiBGat9
	9JBN9NgCwXXFw8ia1k11AeS2+LIVWf0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-452-RWkYOKOvNM2f_x1zIoKe-w-1; Thu,
 08 Oct 2026 09:35:00 -0400
X-MC-Unique: RWkYOKOvNM2f_x1zIoKe-w-1
X-Mimecast-MFC-AGG-ID: RWkYOKOvNM2f_x1zIoKe-w_1791466494
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 02E8B1954AE8;
	Thu,  8 Oct 2026 13:34:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.90])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 11F761956044;
	Thu,  8 Oct 2026 13:34:47 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <brauner@kernel.org>
cc: dhowells@redhat.com, Marc Dionne <marc.dionne@auristor.com>,
    Ilya Dryomov <idryomov@gmail.com>,
    Alex Markuze <amarkuze@redhat.com>,
    Viacheslav Dubeyko <slava@dubeyko.com>,
    Paulo Alcantara <pc@manguebit.org>,
    Matthew Wilcox <willy@infradead.org>, v9fs@lists.linux.dev,
    linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
    linux-cifs@vger.kernel.org, netfs@lists.linux.dev,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] fscache, cachefiles: Fix resize handling
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1029096.1791466484.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 14:34:44 +0100
Message-ID: <1029097.1791466484@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

    =

Fix the resize handling in fscache and cachefiles by passing down a flag t=
o
indicate if the file is being shrunk as the cache's idea of how big the
file should be may be stale and thus not useful in comparison to the
object's size.

The issue is that netfs_perform_write() updates the network filesystem's
file's i_size as it adds data to the pagecache, but the cache isn't update=
d
until writeback flushes that data.  A truncation may then scrap that data
and so the cache never sees it and doesn't update before it is told to
resize.  In the resize, cachefiles was comparing the new size against the
current cache size and then thinking the file was being expanded.

Note that this is a bit more complicated for ceph than other filesystems a=
s
ceph splits the truncation of the local pagecache and fscache to after the
RPC reply handler has updated the inode record - the reply handler
communicates the need for the truncation finalisation through ceph inode
flags.  Further, the same mechanism appears to be used to handle truncatio=
n
in response to CAP changes and might actually be better off invalidating
the cache rather than just resizing it.

To this end, ceph is changed such that the outstanding truncation count in=
 the
inode turns into a bool and just set instead of being incremented (the cod=
e
only cares if it's zero or non-zero) and then a second bool is added to re=
cord
if the file was being shrunk.

Reported-by: Marc Dionne <marc.dionne@auristor.com>
Fixes: 1a9fe4b6e787 ("cachefiles: Don't rely on backing fs storage map for=
 most use cases")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Viacheslav Dubeyko <slava@dubeyko.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: v9fs@lists.linux.dev
cc: linux-afs@lists.infradead.org
cc: ceph-devel@vger.kernel.org
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---    =

 Changes
 =3D=3D=3D=3D=3D=3D=3D
 ver #2)
 - Fix issues reported by sashiko[1]:
   - In cifs_file_copychunk_range(), use the old size of the target inode,
     not the source inode.
   - Switch to passing down a flag to indicate if the file shrank rather
     than the old file size.
   - In ceph, cache the truncate-shrank flag in the ceph inode.
 =

 [1] https://sashiko.dev/#/patchset/938341.1791446974%40warthog.procyon.or=
g.uk

 Documentation/filesystems/caching/backend-api.rst |    2 +-
 Documentation/filesystems/caching/netfs-api.rst   |    2 +-
 fs/9p/vfs_inode.c                                 |    4 +++-
 fs/9p/vfs_inode_dotl.c                            |    3 ++-
 fs/afs/inode.c                                    |    4 ++--
 fs/cachefiles/interface.c                         |    8 ++++----
 fs/ceph/cache.h                                   |    6 +++---
 fs/ceph/inode.c                                   |   20 ++++++++++++++--=
----
 fs/ceph/super.h                                   |    3 ++-
 fs/netfs/fscache_io.c                             |    4 ++--
 fs/smb/client/cifsfs.c                            |   11 +++++++----
 fs/smb/client/inode.c                             |    2 +-
 fs/smb/client/smb2ops.c                           |   14 ++++++++------
 include/linux/fscache-cache.h                     |    2 +-
 include/linux/fscache.h                           |   11 ++++++-----
 15 files changed, 57 insertions(+), 39 deletions(-)

diff --git a/Documentation/filesystems/caching/backend-api.rst b/Documenta=
tion/filesystems/caching/backend-api.rst
index 3a199fc50828..df837531b3fd 100644
--- a/Documentation/filesystems/caching/backend-api.rst
+++ b/Documentation/filesystems/caching/backend-api.rst
@@ -339,7 +339,7 @@ pointers to methods to allow fscache to request manage=
ment of the cache:
    * Change the size of a data storage object [mandatory]::
 =

 	void (*resize_cookie)(struct netfs_cache_resources *cres,
-			      loff_t new_size);
+			      loff_t new_size, bool shrank);
 =

      This method is called to inform the cache backend of a change in siz=
e of
      the netfs file due to local truncation.  The cache backend should ma=
ke all
diff --git a/Documentation/filesystems/caching/netfs-api.rst b/Documentati=
on/filesystems/caching/netfs-api.rst
index 665b27f1556e..3154a1686480 100644
--- a/Documentation/filesystems/caching/netfs-api.rst
+++ b/Documentation/filesystems/caching/netfs-api.rst
@@ -226,7 +226,7 @@ If a network filesystem file is resized locally by tru=
ncation, the following
 should be called to notify the cache::
 =

 	void fscache_resize_cookie(struct fscache_cookie *cookie,
-				   loff_t new_size);
+				   loff_t new_size, bool shrank);
 =

 The caller must have first marked the cookie in-use.  The cookie and the =
new
 size are passed in and the cache is synchronously resized.  This is expec=
ted to
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 3829554ca369..5216c3267e9b 100644
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
+					      iattr->ia_size, iattr->ia_size < old_size);
 		}
 #endif
 	}
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 116b29e95f21..06ed94c2a497 100644
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
+					      iattr->ia_size, iattr->ia_size < old_size);
 #endif
 	}
 =

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 634fbf8eb212..ed908d051bd0 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -744,7 +744,7 @@ static void afs_setattr_edit_file(struct afs_operation=
 *op)
 		if (size !=3D old) {
 			truncate_pagecache(inode, size);
 			netfs_resize_file(&vnode->netfs, size, true);
-			fscache_resize_cookie(afs_vnode_cache(vnode), size);
+			fscache_resize_cookie(afs_vnode_cache(vnode), size, size < old);
 		}
 	}
 }
@@ -817,7 +817,7 @@ int afs_setattr(struct mnt_idmap *idmap, struct dentry=
 *dentry,
 			truncate_setsize(inode, attr->ia_size);
 			netfs_resize_file(&vnode->netfs, size, false);
 			fscache_resize_cookie(afs_vnode_cache(vnode),
-					      attr->ia_size);
+					      attr->ia_size, i_size < attr->ia_size);
 			ret =3D 0;
 			goto out_unlock;
 		}
diff --git a/fs/cachefiles/interface.c b/fs/cachefiles/interface.c
index 789ff6abe926..4a31904aaf0e 100644
--- a/fs/cachefiles/interface.c
+++ b/fs/cachefiles/interface.c
@@ -204,7 +204,7 @@ static bool cachefiles_shorten_object(struct cachefile=
s_object *object,
  * Resize the backing object.
  */
 static void cachefiles_resize_cookie(struct netfs_cache_resources *cres,
-				     uoff_t new_size)
+				     uoff_t new_size, bool shrank)
 {
 	struct cachefiles_object *object =3D cachefiles_cres_object(cres);
 	struct cachefiles_cache *cache =3D object->volume->cache;
@@ -215,10 +215,10 @@ static void cachefiles_resize_cookie(struct netfs_ca=
che_resources *cres,
 =

 	_enter("%llu->%llu", object->object_size, new_size);
 =

-	/* If the file is being shrunk, we need to downsize the backing file
-	 * and clear the end of the final block.
+	/* If the file shrank, we need to downsize the backing file and clear
+	 * the end of the final block.
 	 */
-	if (new_size < object->object_size) {
+	if (shrank) {
 		if (new_size >=3D i_size)
 			goto out;
 		cachefiles_begin_secure(cache, &saved_cred);
diff --git a/fs/ceph/cache.h b/fs/ceph/cache.h
index 20efac020394..892b18c31741 100644
--- a/fs/ceph/cache.h
+++ b/fs/ceph/cache.h
@@ -31,14 +31,14 @@ static inline struct fscache_cookie *ceph_fscache_cook=
ie(struct ceph_inode_info
 	return netfs_i_cookie(&ci->netfs);
 }
 =

-static inline void ceph_fscache_resize(struct inode *inode, loff_t to)
+static inline void ceph_fscache_resize(struct inode *inode, loff_t to, bo=
ol shrank)
 {
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
 	struct fscache_cookie *cookie =3D ceph_fscache_cookie(ci);
 =

 	if (cookie) {
 		ceph_fscache_use_cookie(inode, true);
-		fscache_resize_cookie(cookie, to);
+		fscache_resize_cookie(cookie, to, shrank);
 		ceph_fscache_unuse_cookie(inode, true);
 	}
 }
@@ -96,7 +96,7 @@ static inline struct fscache_cookie *ceph_fscache_cookie=
(struct ceph_inode_info
 	return NULL;
 }
 =

-static inline void ceph_fscache_resize(struct inode *inode, loff_t to)
+static inline void ceph_fscache_resize(struct inode *inode, loff_t to, bo=
ol shrank)
 {
 }
 =

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index d52e2b389e0b..eb8c4ec1a594 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -680,7 +680,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 	mutex_init(&ci->i_truncate_mutex);
 	ci->i_truncate_seq =3D 0;
 	ci->i_truncate_size =3D 0;
-	ci->i_truncate_pending =3D 0;
+	ci->i_truncate_pending =3D false;
 	ci->i_truncate_pagecache_size =3D 0;
 =

 	ci->i_max_size =3D 0;
@@ -847,7 +847,9 @@ int ceph_fill_file_size(struct inode *inode, int issue=
d,
 				       CEPH_CAP_FILE_BUFFER)) ||
 			    mapping_mapped(inode->i_mapping) ||
 			    __ceph_is_file_opened(ci)) {
-				ci->i_truncate_pending++;
+				ci->i_truncate_pending =3D true;
+				if (size < isize)
+					ci->i_truncate_shrank =3D true;
 				queue_trunc =3D 1;
 			}
 		}
@@ -2303,13 +2305,13 @@ void __ceph_do_pending_vmtruncate(struct inode *in=
ode)
 {
 	struct ceph_client *cl =3D ceph_inode_to_client(inode);
 	struct ceph_inode_info *ci =3D ceph_inode(inode);
-	u64 to;
+	uoff_t to;
 	int wrbuffer_refs, finish =3D 0;
 =

 	mutex_lock(&ci->i_truncate_mutex);
 retry:
 	spin_lock(&ci->i_ceph_lock);
-	if (ci->i_truncate_pending =3D=3D 0) {
+	if (!ci->i_truncate_pending) {
 		doutc(cl, "%p %llx.%llx none pending\n", inode,
 		      ceph_vinop(inode));
 		spin_unlock(&ci->i_ceph_lock);
@@ -2339,12 +2341,18 @@ void __ceph_do_pending_vmtruncate(struct inode *in=
ode)
 	      ci->i_truncate_pending, to);
 	spin_unlock(&ci->i_ceph_lock);
 =

-	ceph_fscache_resize(inode, to);
+	/*
+	 * TODO: This needs fixing to pass in the old inode size - or an
+	 * indication that the file shrank.  Possibly this should actually be
+	 * invalidating the file for some of its callers.
+	 */
+	ceph_fscache_resize(inode, to, ci->i_truncate_shrank);
 	truncate_pagecache(inode, to);
 =

 	spin_lock(&ci->i_ceph_lock);
 	if (to =3D=3D ci->i_truncate_pagecache_size) {
-		ci->i_truncate_pending =3D 0;
+		ci->i_truncate_shrank =3D false;
+		ci->i_truncate_pending =3D false;
 		finish =3D 1;
 	}
 	spin_unlock(&ci->i_ceph_lock);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 72d4e30304dc..e6eaf1647fe5 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -481,7 +481,8 @@ struct ceph_inode_info {
 	struct mutex i_truncate_mutex;
 	u32 i_truncate_seq;        /* last truncate to smaller size */
 	u64 i_truncate_size;       /*  and the size we last truncated down to */
-	int i_truncate_pending;    /*  still need to call vmtruncate */
+	bool i_truncate_pending;   /*  still need to call vmtruncate */
+	bool i_truncate_shrank;		/* Truncate shrank the file */
 	/*
 	 * For none fscrypt case it equals to i_truncate_size or it will
 	 * equals to fscrypt_file_size
diff --git a/fs/netfs/fscache_io.c b/fs/netfs/fscache_io.c
index 056a2bae5d99..ea0b11807034 100644
--- a/fs/netfs/fscache_io.c
+++ b/fs/netfs/fscache_io.c
@@ -267,7 +267,7 @@ EXPORT_SYMBOL(__fscache_write_to_cache);
 /*
  * Change the size of a backing object.
  */
-void __fscache_resize_cookie(struct fscache_cookie *cookie, uoff_t new_si=
ze)
+void __fscache_resize_cookie(struct fscache_cookie *cookie, uoff_t new_si=
ze, bool shrank)
 {
 	struct netfs_cache_resources cres;
 =

@@ -281,7 +281,7 @@ void __fscache_resize_cookie(struct fscache_cookie *co=
okie, uoff_t new_size)
 		 * netfs's inode lock so that we're serialised with respect to
 		 * writes.
 		 */
-		cookie->volume->cache->ops->resize_cookie(&cres, new_size);
+		cookie->volume->cache->ops->resize_cookie(&cres, new_size, shrank);
 		fscache_end_operation(&cres);
 	} else {
 		fscache_stat(&fscache_n_resizes_null);
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 98b610b2a114..86ae1154bd58 100644
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
+	fscache_resize_cookie(cifs_inode_cookie(src_inode), src_end, src_end < o=
ld_size);
 	return 0;
 =

 set_failed:
@@ -1538,6 +1539,7 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	struct cifs_tcon *src_tcon;
 	struct cifs_tcon *target_tcon;
 	ssize_t rc;
+	uoff_t old_size, new_size;
 =

 	if (len =3D=3D 0)
 		return 0;
@@ -1621,14 +1623,15 @@ ssize_t cifs_file_copychunk_range(unsigned int xid=
,
 =

 	rc =3D file_modified(dst_file);
 	if (!rc) {
+		old_size =3D netfs_read_remote_i_size(target_inode);
 		rc =3D target_tcon->ses->server->ops->copychunk_range(xid,
 			smb_file_src, smb_file_target, off, len, destoff);
 		if (rc > 0 && destoff + rc > i_size_read(target_inode)) {
 			truncate_setsize(target_inode, destoff + rc);
-			netfs_resize_file(&target_cifsi->netfs,
-					  i_size_read(target_inode), true);
+			new_size =3D i_size_read(target_inode);
+			netfs_resize_file(&target_cifsi->netfs, new_size, true);
 			fscache_resize_cookie(cifs_inode_cookie(target_inode),
-					      i_size_read(target_inode));
+					      new_size, new_size < old_size);
 		}
 		if (rc > 0) {
 			spin_lock(&target_inode->i_lock);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index f29555f3c7d0..fb1afe72e6d2 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3097,7 +3097,7 @@ void cifs_resize_file_locked(struct inode *inode, lo=
ff_t old_size,
 		return;
 =

 	fscache_use_cookie(cookie, true);
-	fscache_resize_cookie(cookie, offset);
+	fscache_resize_cookie(cookie, offset, offset < old_size);
 	cifs_fscache_unuse_inode_cookie(inode, true);
 }
 =

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1e9018880639..1f3b352201aa 100644
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
@@ -3611,7 +3612,8 @@ static long smb3_zero_range(struct file *file, struc=
t cifs_tcon *tcon,
 			if (offset < cifsi->netfs._zero_point)
 				netfs_write_zero_point(inode, offset);
 			spin_unlock(&inode->i_lock);
-			fscache_resize_cookie(cifs_inode_cookie(inode), new_size);
+			fscache_resize_cookie(cifs_inode_cookie(inode),
+					      new_size, new_size < old_size);
 		}
 	}
 =

@@ -4146,7 +4148,7 @@ static long smb3_collapse_range(struct file *file, s=
truct cifs_tcon *tcon,
 	netfs_resize_file(&cifsi->netfs, new_eof, true);
 	netfs_write_zero_point(inode, new_eof);
 	spin_unlock(&inode->i_lock);
-	fscache_resize_cookie(cifs_inode_cookie(inode), new_eof);
+	fscache_resize_cookie(cifs_inode_cookie(inode), new_eof, new_eof < old_e=
of);
 out_2:
 	filemap_invalidate_unlock(inode->i_mapping);
 out:
@@ -4206,9 +4208,9 @@ static long smb3_insert_range(struct file *file, str=
uct cifs_tcon *tcon,
 =

 	truncate_setsize(inode, new_eof);
 	spin_lock(&inode->i_lock);
-	netfs_resize_file(&cifsi->netfs, i_size_read(inode), true);
+	netfs_resize_file(&cifsi->netfs, new_eof, true);
 	spin_unlock(&inode->i_lock);
-	fscache_resize_cookie(cifs_inode_cookie(inode), i_size_read(inode));
+	fscache_resize_cookie(cifs_inode_cookie(inode), new_eof, new_eof < old_e=
of);
 =

 	/*
 	 * Move [off, old_eof) right by len. The helper copies backwards if the
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index ee524c863fa9..2b83ffa4510e 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -67,7 +67,7 @@ struct fscache_cache_ops {
 =

 	/* Change the size of a data object */
 	void (*resize_cookie)(struct netfs_cache_resources *cres,
-			      uoff_t new_size);
+			      uoff_t new_size, bool shrank);
 =

 	/* Invalidate an object */
 	bool (*invalidate_cookie)(struct fscache_cookie *cookie);
diff --git a/include/linux/fscache.h b/include/linux/fscache.h
index f2d958bd1f48..ecd14d645690 100644
--- a/include/linux/fscache.h
+++ b/include/linux/fscache.h
@@ -184,7 +184,7 @@ extern struct fscache_cookie *__fscache_acquire_cookie=
(
 extern void __fscache_use_cookie(struct fscache_cookie *, bool);
 extern void __fscache_unuse_cookie(struct fscache_cookie *, const void *,=
 const uoff_t *);
 extern void __fscache_relinquish_cookie(struct fscache_cookie *, bool);
-extern void __fscache_resize_cookie(struct fscache_cookie *, uoff_t);
+void __fscache_resize_cookie(struct fscache_cookie *cookie, uoff_t new_si=
ze, bool shrank);
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
+ * @new_size: The new size of the object
+ * @shrank: True if the file shrank; false if it expanded
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
+void fscache_resize_cookie(struct fscache_cookie *cookie, uoff_t new_size=
, bool shrank)
 {
 	if (fscache_cookie_enabled(cookie))
-		__fscache_resize_cookie(cookie, new_size);
+		__fscache_resize_cookie(cookie, new_size, shrank);
 }
 =

 /**

