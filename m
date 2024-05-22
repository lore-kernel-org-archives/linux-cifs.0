Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00083146A69
	for <linux-cifs@vger.kernel.org>; Wed, 22 May 2024 21:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716412156; cv=none; b=O+Kz4XhhTpbJU4s8iW926eKB02f5KzJprgSv/JpeUbb5z6q4z+06chHigTajDNF0r5CIQ0dQX1kDn8SSRUeXQMXDUsKMkI5jdH/XCWd+d7g2D+gaLvenjJi1DXArVq377qv39EwUl8GPbbWSTRMMIkQhJoJOg6Ne+nYLzevYZ0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716412156; c=relaxed/simple;
	bh=FL8TX/ZAVoB1PP91BvAGdWUewzyVdl+tkLkyIR/IPlA=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=oCER0EUcvZVCcsnLmZqg/JoyE7SuPqA5SLSeW3UUGl211Tucq1CB7TkxAmHnQjr91QW8yFefSjVtbdfrHqGMr0ns05wTo14tNJEhxKhXaG44G4Kkug6BkTRgEtCAL95Jsy4ig70MSETYYrGWpE0ftlxp23w/sPyZV9+DjOYcSrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JhmpbyVF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JhmpbyVF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716412153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=16PqWbFEFWjkwJI4FUe2h6WfSs9KhKFVVUB3JvoJi30=;
	b=JhmpbyVF7CgVv1Di/+n3i9dm7VqA2+AqpClypicwIHOOGpMzE1P+Vhxc1mZZnqXWc0ljlm
	E+vqPkknIvJjvaVoRvEbnYc1Io0PGZf+KEwAmR+v7TdGPN1HPIsZbFyzDKtvZYR7NWJo6y
	uRLbtWVp6oTG7vpt4kSu1AYB4bbKUyI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-yNBlmEh6PjCfKwIsNvsRQg-1; Wed, 22 May 2024 17:09:07 -0400
X-MC-Unique: yNBlmEh6PjCfKwIsNvsRQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7C40801190;
	Wed, 22 May 2024 21:09:06 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.20])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 656161050178;
	Wed, 22 May 2024 21:09:04 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Zkr8i9XxpkJ9AABZ@codewreck.org>
References: <Zkr8i9XxpkJ9AABZ@codewreck.org> <0000000000005be0aa061846f8d6@google.com>
To: syzbot+df038d463cca332e8414@syzkaller.appspotmail.com
Cc: dhowells@redhat.com, asmadeus@codewreck.org, ericvh@kernel.org,
    linux-kernel@vger.kernel.org, linux_oss@crudebyte.com,
    lucho@ionkov.net, syzkaller-bugs@googlegroups.com,
    v9fs@lists.linux.dev, Jeff Layton <jlayton@kernel.org>,
    Steve French <sfrench@samba.org>,
    Christian Brauner <brauner@kernel.org>,
    linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
    netfs@lists.linux.dev
Subject: Re: [syzbot] [v9fs?] KASAN: slab-use-after-free Write in v9fs_free_request
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <463667.1716412143.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 May 2024 22:09:03 +0100
Message-ID: <463668.1716412143@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t master

netfs, 9p: Fix race between umount and async request completion

There's a problem in 9p's interaction with netfslib whereby a crash occurs
because the 9p_fid structs get forcibly destroyed during client teardown
(without paying attention to their refcounts) before netfslib has finished
with them.  However, it's not a simple case of deferring the clunking that
p9_fid_put() does as that requires the client.

The problem is that netfslib has to unlock pages and clear the IN_PROGRESS
flag before destroying the objects involved - including the pid - and, in
any case, nothing checks to see if writeback completed barring looking at
the page flags.

Fix this by keeping a count of outstanding I/O requests (of any type) and
waiting for it to quiesce during inode eviction.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric Van Hensbergen <ericvh@kernel.org>
cc: Latchesar Ionkov <lucho@ionkov.net>
cc: Dominique Martinet <asmadeus@codewreck.org>
cc: Christian Schoenebeck <linux_oss@crudebyte.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: Steve French <sfrench@samba.org>
cc: v9fs@lists.linux.dev
cc: linux-afs@lists.infradead.org
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/9p/vfs_inode.c      |    5 ++++-
 fs/afs/inode.c         |    1 +
 fs/netfs/objects.c     |    5 +++++
 fs/smb/client/cifsfs.c |    1 +
 include/linux/netfs.h  |   18 ++++++++++++++++++
 5 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 8c9a896d691e..57cfa9f65046 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -354,6 +354,7 @@ void v9fs_evict_inode(struct inode *inode)
 		version =3D cpu_to_le32(v9inode->qid.version);
 		netfs_clear_inode_writeback(inode, &version);
 =

+		netfs_wait_for_outstanding_io(inode);
 		clear_inode(inode);
 		filemap_fdatawrite(&inode->i_data);
 =

@@ -361,8 +362,10 @@ void v9fs_evict_inode(struct inode *inode)
 		if (v9fs_inode_cookie(v9inode))
 			fscache_relinquish_cookie(v9fs_inode_cookie(v9inode), false);
 #endif
-	} else
+	} else {
+		netfs_wait_for_outstanding_io(inode);
 		clear_inode(inode);
+	}
 }
 =

 struct inode *
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 94fc049aff58..c831e711a4ac 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -652,6 +652,7 @@ void afs_evict_inode(struct inode *inode)
 =

 	afs_set_cache_aux(vnode, &aux);
 	netfs_clear_inode_writeback(inode, &aux);
+	netfs_wait_for_outstanding_io(inode);
 	clear_inode(inode);
 =

 	while (!list_empty(&vnode->wb_keys)) {
diff --git a/fs/netfs/objects.c b/fs/netfs/objects.c
index c90d482b1650..f4a642727479 100644
--- a/fs/netfs/objects.c
+++ b/fs/netfs/objects.c
@@ -72,6 +72,7 @@ struct netfs_io_request *netfs_alloc_request(struct addr=
ess_space *mapping,
 		}
 	}
 =

+	atomic_inc(&ctx->io_count);
 	trace_netfs_rreq_ref(rreq->debug_id, 1, netfs_rreq_trace_new);
 	netfs_proc_add_rreq(rreq);
 	netfs_stat(&netfs_n_rh_rreq);
@@ -124,6 +125,7 @@ static void netfs_free_request(struct work_struct *wor=
k)
 {
 	struct netfs_io_request *rreq =3D
 		container_of(work, struct netfs_io_request, work);
+	struct netfs_inode *ictx =3D netfs_inode(rreq->inode);
 	unsigned int i;
 =

 	trace_netfs_rreq(rreq, netfs_rreq_trace_free);
@@ -142,6 +144,9 @@ static void netfs_free_request(struct work_struct *wor=
k)
 		}
 		kvfree(rreq->direct_bv);
 	}
+
+	if (atomic_dec_and_test(&ictx->io_count))
+		wake_up_var(&ictx->io_count);
 	call_rcu(&rreq->rcu, netfs_free_request_rcu);
 }
 =

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index ec5b639f421a..21c9e173ea9a 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -435,6 +435,7 @@ cifs_evict_inode(struct inode *inode)
 	if (inode->i_state & I_PINNING_NETFS_WB)
 		cifs_fscache_unuse_inode_cookie(inode, true);
 	cifs_fscache_release_inode_cookie(inode);
+	netfs_wait_for_outstanding_io(inode);
 	clear_inode(inode);
 }
 =

diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index d2d291a9cdad..3ca3906bb8da 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -68,6 +68,7 @@ struct netfs_inode {
 	loff_t			remote_i_size;	/* Size of the remote file */
 	loff_t			zero_point;	/* Size after which we assume there's no data
 						 * on the server */
+	atomic_t		io_count;	/* Number of outstanding reqs */
 	unsigned long		flags;
 #define NETFS_ICTX_ODIRECT	0		/* The file has DIO in progress */
 #define NETFS_ICTX_UNBUFFERED	1		/* I/O should not use the pagecache */
@@ -474,6 +475,7 @@ static inline void netfs_inode_init(struct netfs_inode=
 *ctx,
 	ctx->remote_i_size =3D i_size_read(&ctx->inode);
 	ctx->zero_point =3D LLONG_MAX;
 	ctx->flags =3D 0;
+	atomic_set(&ctx->io_count, 0);
 #if IS_ENABLED(CONFIG_FSCACHE)
 	ctx->cache =3D NULL;
 #endif
@@ -517,4 +519,20 @@ static inline struct fscache_cookie *netfs_i_cookie(s=
truct netfs_inode *ctx)
 #endif
 }
 =

+/**
+ * netfs_wait_for_outstanding_io - Wait for outstanding I/O to complete
+ * @ctx: The netfs inode to wait on
+ *
+ * Wait for outstanding I/O requests of any type to complete.  This is in=
tended
+ * to be called from inode eviction routines.  This makes sure that any
+ * resources held by those requests are cleaned up before we let the inod=
e get
+ * cleaned up.
+ */
+static inline void netfs_wait_for_outstanding_io(struct inode *inode)
+{
+	struct netfs_inode *ictx =3D netfs_inode(inode);
+
+	wait_var_event(&ictx->io_count, atomic_read(&ictx->io_count) =3D=3D 0);
+}
+
 #endif /* _LINUX_NETFS_H */

