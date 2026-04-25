Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A65939D6F8
	for <linux-cifs@vger.kernel.org>; Sat, 25 Apr 2026 12:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777121773; cv=none; b=IwsFEvsnPtrtaLprfJHrqXbnc3WGXz8J6q2MX9IDqpom4TH3H2ZT5M3YOxRxfmKMsZznTULNiUcqx0mKDxe1AfMwfKVUObNaq3GW34CxYfgxSFt5hbEzL6kJEp3W81XYcg46jwzPoeyH3iYrVEdGK6c+QJyXaMASxrTRfm3Nos0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777121773; c=relaxed/simple;
	bh=kw2ph8ABWMFW8tR55XpKSH31TjAqka9pQ8vYplEDMbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dqm7shJ+yNyzi+QfYagOZL6WwO1rbyGTT/E6xc2bI0vsmn8LYfeKixfbv8D1Qxqu5y7KVCuY9JepbmMBvX5aeObpxMqQIzH6qLgYsvUzIabzQpkWGvYR8+Zf1Ch5dU3Hg90aXyAIja2E4ElfTX+0zoqDXUdpzERyxcvFxB9dMTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xf/9MhIx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xf/9MhIx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777121770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IWpVZfCnfPMvlRQ9r7wWIQ56Qq3yXfMQ6qgWCReefRo=;
	b=Xf/9MhIxICIuddpPNdcr9sSzxgG9OSCT3Fd1hIMmPMIhSe07ceezZ/bjzadc3ll/Wd3JaD
	HvvhMdfrRYOsssJh2U010QPw99It2sa7XQXwcg3oeeujUrj/DjTxFdBFVNy+FzpZWbLAFD
	XNlYtUoi/gGsWxvySGCPX2Zj87fb4+M=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-250-zJ_0kpNLMbqgjL8Oyj5Llw-1; Sat,
 25 Apr 2026 08:56:07 -0400
X-MC-Unique: zJ_0kpNLMbqgjL8Oyj5Llw-1
X-Mimecast-MFC-AGG-ID: zJ_0kpNLMbqgjL8Oyj5Llw_1777121765
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 991C319560AF;
	Sat, 25 Apr 2026 12:56:05 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.17])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 953061944CED;
	Sat, 25 Apr 2026 12:56:02 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Marc Dionne <marc.dionne@auristor.com>
Subject: [PATCH v3 19/19] afs: Fix RCU handling of symlinks in RCU pathwalk
Date: Sat, 25 Apr 2026 13:54:23 +0100
Message-ID: <20260425125426.3855807-20-dhowells@redhat.com>
In-Reply-To: <20260425125426.3855807-1-dhowells@redhat.com>
References: <20260425125426.3855807-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

The afs filesystem in the kernel doesn't handle RCU pathwalk of symlinks
correctly.  The problem is twofold: firstly, it doesn't treat the buffer
pointers as RCU pointers with the appropriate barriering; and secondly, it
can race with another thread updating the contents of the symlink because a
third party updated it on the server.

Fix this by the following means:

 (1) Keep a separate copy of the symlink contents with an rcu_head.  This
     is always going to be a lot smaller than a page, so it can be
     kmalloc'd and save quite a bit of memory.  It also needs a refcount
     for non-RCU pathwalk.

 (2) Split the symlink read and write-to-cache routines in afs from those
     for directories.

 (3) Discard the I/O buffer as soon as the write-to-cache completes as this
     is a full page (plus a folio_queue).

 (4) If there's no cache, discard the I/O buffer immediately after reading
     and copying if there is no cache.

Fixes: 6698c02d64b2 ("afs: Locally initialise the contents of a new symlink on creation")
Closes: https://sashiko.dev/#/patchset/20260326104544.509518-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/afs/Makefile    |   1 +
 fs/afs/dir.c       |  33 +++++--
 fs/afs/fsclient.c  |   4 +-
 fs/afs/inode.c     | 105 +-------------------
 fs/afs/internal.h  |  35 +++++--
 fs/afs/symlink.c   | 242 +++++++++++++++++++++++++++++++++++++++++++++
 fs/afs/yfsclient.c |   4 +-
 7 files changed, 303 insertions(+), 121 deletions(-)
 create mode 100644 fs/afs/symlink.c

diff --git a/fs/afs/Makefile b/fs/afs/Makefile
index b49b8fe682f3..0d8f1982d596 100644
--- a/fs/afs/Makefile
+++ b/fs/afs/Makefile
@@ -30,6 +30,7 @@ kafs-y := \
 	server.o \
 	server_list.o \
 	super.o \
+	symlink.o \
 	validation.o \
 	vlclient.o \
 	vl_alias.o \
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index aaaa55878ffd..40f6791114ec 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -68,7 +68,7 @@ const struct inode_operations afs_dir_inode_operations = {
 };
 
 const struct address_space_operations afs_dir_aops = {
-	.writepages	= afs_single_writepages,
+	.writepages	= afs_dir_writepages,
 };
 
 const struct dentry_operations afs_fs_dentry_operations = {
@@ -294,7 +294,7 @@ static ssize_t afs_do_read_single(struct afs_vnode *dvnode, struct file *file)
 	return ret;
 }
 
-ssize_t afs_read_single(struct afs_vnode *dvnode, struct file *file)
+static ssize_t afs_read_single(struct afs_vnode *dvnode, struct file *file)
 {
 	ssize_t ret;
 
@@ -1763,13 +1763,20 @@ static int afs_link(struct dentry *from, struct inode *dir,
 	return ret;
 }
 
+static void afs_symlink_put(struct afs_operation *op)
+{
+	kfree(op->create.symlink);
+	op->create.symlink = NULL;
+	afs_create_put(op);
+}
+
 static const struct afs_operation_ops afs_symlink_operation = {
 	.issue_afs_rpc	= afs_fs_symlink,
 	.issue_yfs_rpc	= yfs_fs_symlink,
 	.success	= afs_create_success,
 	.aborted	= afs_check_for_remote_deletion,
 	.edit_dir	= afs_create_edit_dir,
-	.put		= afs_create_put,
+	.put		= afs_symlink_put,
 };
 
 /*
@@ -1779,7 +1786,9 @@ static int afs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		       struct dentry *dentry, const char *content)
 {
 	struct afs_operation *op;
+	struct afs_symlink *symlink;
 	struct afs_vnode *dvnode = AFS_FS_I(dir);
+	size_t clen = strlen(content);
 	int ret;
 
 	_enter("{%llx:%llu},{%pd},%s",
@@ -1791,12 +1800,20 @@ static int afs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		goto error;
 
 	ret = -EINVAL;
-	if (strlen(content) >= AFSPATHMAX)
+	if (clen >= AFSPATHMAX)
+		goto error;
+
+	ret = -ENOMEM;
+	symlink = kmalloc_flex(struct afs_symlink, content, clen + 1, GFP_KERNEL);
+	if (!symlink)
 		goto error;
+	refcount_set(&symlink->ref, 1);
+	memcpy(symlink->content, content, clen + 1);
 
 	op = afs_alloc_operation(NULL, dvnode->volume);
 	if (IS_ERR(op)) {
 		ret = PTR_ERR(op);
+		kfree(symlink);
 		goto error;
 	}
 
@@ -1808,7 +1825,7 @@ static int afs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	op->dentry		= dentry;
 	op->ops			= &afs_symlink_operation;
 	op->create.reason	= afs_edit_dir_for_symlink;
-	op->create.symlink	= content;
+	op->create.symlink	= symlink;
 	op->mtime		= current_time(dir);
 	ret = afs_do_sync_operation(op);
 	afs_dir_unuse_cookie(dvnode, ret);
@@ -2192,10 +2209,10 @@ static int afs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 }
 
 /*
- * Write the file contents to the cache as a single blob.
+ * Write the directory contents to the cache as a single blob.
  */
-int afs_single_writepages(struct address_space *mapping,
-			  struct writeback_control *wbc)
+int afs_dir_writepages(struct address_space *mapping,
+		       struct writeback_control *wbc)
 {
 	struct afs_vnode *dvnode = AFS_FS_I(mapping->host);
 	struct iov_iter iter;
diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index 95494d5f2b8a..a2ffd60889f8 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -886,7 +886,7 @@ void afs_fs_symlink(struct afs_operation *op)
 	namesz = name->len;
 	padsz = (4 - (namesz & 3)) & 3;
 
-	c_namesz = strlen(op->create.symlink);
+	c_namesz = strlen(op->create.symlink->content);
 	c_padsz = (4 - (c_namesz & 3)) & 3;
 
 	reqsz = (6 * 4) + namesz + padsz + c_namesz + c_padsz + (6 * 4);
@@ -910,7 +910,7 @@ void afs_fs_symlink(struct afs_operation *op)
 		bp = (void *) bp + padsz;
 	}
 	*bp++ = htonl(c_namesz);
-	memcpy(bp, op->create.symlink, c_namesz);
+	memcpy(bp, op->create.symlink->content, c_namesz);
 	bp = (void *) bp + c_namesz;
 	if (c_padsz > 0) {
 		memset(bp, 0, c_padsz);
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 5207c4a003f6..ff2b8fc7f3df 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -25,105 +25,6 @@
 #include "internal.h"
 #include "afs_fs.h"
 
-void afs_init_new_symlink(struct afs_vnode *vnode, struct afs_operation *op)
-{
-	size_t size = strlen(op->create.symlink) + 1;
-	size_t dsize = 0;
-	char *p;
-
-	if (netfs_alloc_folioq_buffer(NULL, &vnode->directory, &dsize, size,
-				      mapping_gfp_mask(vnode->netfs.inode.i_mapping)) < 0)
-		return;
-
-	vnode->directory_size = dsize;
-	p = kmap_local_folio(folioq_folio(vnode->directory, 0), 0);
-	memcpy(p, op->create.symlink, size);
-	kunmap_local(p);
-	set_bit(AFS_VNODE_DIR_READ, &vnode->flags);
-	netfs_single_mark_inode_dirty(&vnode->netfs.inode);
-}
-
-static void afs_put_link(void *arg)
-{
-	struct folio *folio = virt_to_folio(arg);
-
-	kunmap_local(arg);
-	folio_put(folio);
-}
-
-const char *afs_get_link(struct dentry *dentry, struct inode *inode,
-			 struct delayed_call *callback)
-{
-	struct afs_vnode *vnode = AFS_FS_I(inode);
-	struct folio *folio;
-	char *content;
-	ssize_t ret;
-
-	if (!dentry) {
-		/* RCU pathwalk. */
-		if (!test_bit(AFS_VNODE_DIR_READ, &vnode->flags) || !afs_check_validity(vnode))
-			return ERR_PTR(-ECHILD);
-		goto good;
-	}
-
-	if (test_bit(AFS_VNODE_DIR_READ, &vnode->flags))
-		goto fetch;
-
-	ret = afs_validate(vnode, NULL);
-	if (ret < 0)
-		return ERR_PTR(ret);
-
-	if (!test_and_clear_bit(AFS_VNODE_ZAP_DATA, &vnode->flags) &&
-	    test_bit(AFS_VNODE_DIR_READ, &vnode->flags))
-		goto good;
-
-fetch:
-	if (down_write_killable(&vnode->validate_lock) < 0)
-		return ERR_PTR(-ERESTARTSYS);
-	if (test_and_clear_bit(AFS_VNODE_ZAP_DATA, &vnode->flags) ||
-	    !test_bit(AFS_VNODE_DIR_READ, &vnode->flags)) {
-		ret = afs_read_single(vnode, NULL);
-		if (ret < 0) {
-			up_write(&vnode->validate_lock);
-			return ERR_PTR(ret);
-		}
-		set_bit(AFS_VNODE_DIR_READ, &vnode->flags);
-	}
-
-	up_write(&vnode->validate_lock);
-
-good:
-	folio = folioq_folio(vnode->directory, 0);
-	folio_get(folio);
-	content = kmap_local_folio(folio, 0);
-	set_delayed_call(callback, afs_put_link, content);
-	return content;
-}
-
-int afs_readlink(struct dentry *dentry, char __user *buffer, int buflen)
-{
-	DEFINE_DELAYED_CALL(done);
-	const char *content;
-	int len;
-
-	content = afs_get_link(dentry, d_inode(dentry), &done);
-	if (IS_ERR(content)) {
-		do_delayed_call(&done);
-		return PTR_ERR(content);
-	}
-
-	len = umin(strlen(content), buflen);
-	if (copy_to_user(buffer, content, len))
-		len = -EFAULT;
-	do_delayed_call(&done);
-	return len;
-}
-
-static const struct inode_operations afs_symlink_inode_operations = {
-	.get_link	= afs_get_link,
-	.readlink	= afs_readlink,
-};
-
 static noinline void dump_vnode(struct afs_vnode *vnode, struct afs_vnode *parent_vnode)
 {
 	static unsigned long once_only;
@@ -223,7 +124,7 @@ static int afs_inode_init_from_status(struct afs_operation *op,
 			inode->i_mode	= S_IFLNK | status->mode;
 			inode->i_op	= &afs_symlink_inode_operations;
 		}
-		inode->i_mapping->a_ops	= &afs_dir_aops;
+		inode->i_mapping->a_ops	= &afs_symlink_aops;
 		inode_nohighmem(inode);
 		mapping_set_release_always(inode->i_mapping);
 		break;
@@ -765,12 +666,14 @@ void afs_evict_inode(struct inode *inode)
 			.range_end = LLONG_MAX,
 		};
 
-		afs_single_writepages(inode->i_mapping, &wbc);
+		inode->i_mapping->a_ops->writepages(inode->i_mapping, &wbc);
 	}
 
 	netfs_wait_for_outstanding_io(inode);
 	truncate_inode_pages_final(&inode->i_data);
 	netfs_free_folioq_buffer(vnode->directory);
+	if (vnode->symlink)
+		afs_replace_symlink(vnode, NULL);
 
 	afs_set_cache_aux(vnode, &aux);
 	netfs_clear_inode_writeback(inode, &aux);
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 599353c33337..c7adc3677e41 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -710,6 +710,7 @@ struct afs_vnode {
 #define AFS_VNODE_DIR_READ	11		/* Set if we've read a dir's contents */
 
 	struct folio_queue	*directory;	/* Directory contents */
+	struct afs_symlink __rcu *symlink;	/* Symlink content */
 	struct list_head	wb_keys;	/* List of keys available for writeback */
 	struct list_head	pending_locks;	/* locks waiting to be granted */
 	struct list_head	granted_locks;	/* locks granted on this file */
@@ -776,6 +777,15 @@ struct afs_permits {
 	struct afs_permit	permits[] __counted_by(nr_permits);	/* List of permits sorted by key pointer */
 };
 
+/*
+ * Copy of symlink content for normal use.
+ */
+struct afs_symlink {
+	struct rcu_head		rcu;
+	refcount_t		ref;
+	char			content[];
+};
+
 /*
  * Error prioritisation and accumulation.
  */
@@ -887,7 +897,7 @@ struct afs_operation {
 		struct {
 			int	reason;		/* enum afs_edit_dir_reason */
 			mode_t	mode;
-			const char *symlink;
+			struct afs_symlink *symlink;
 		} create;
 		struct {
 			bool	need_rehash;
@@ -1098,13 +1108,12 @@ extern const struct inode_operations afs_dir_inode_operations;
 extern const struct address_space_operations afs_dir_aops;
 extern const struct dentry_operations afs_fs_dentry_operations;
 
-ssize_t afs_read_single(struct afs_vnode *dvnode, struct file *file);
 ssize_t afs_read_dir(struct afs_vnode *dvnode, struct file *file)
 	__acquires(&dvnode->validate_lock);
 extern void afs_d_release(struct dentry *);
 extern void afs_check_for_remote_deletion(struct afs_operation *);
-int afs_single_writepages(struct address_space *mapping,
-			  struct writeback_control *wbc);
+int afs_dir_writepages(struct address_space *mapping,
+		       struct writeback_control *wbc);
 
 /*
  * dir_edit.c
@@ -1246,10 +1255,6 @@ extern void afs_fs_probe_cleanup(struct afs_net *);
  */
 extern const struct afs_operation_ops afs_fetch_status_operation;
 
-void afs_init_new_symlink(struct afs_vnode *vnode, struct afs_operation *op);
-const char *afs_get_link(struct dentry *dentry, struct inode *inode,
-			 struct delayed_call *callback);
-int afs_readlink(struct dentry *dentry, char __user *buffer, int buflen);
 extern void afs_vnode_commit_status(struct afs_operation *, struct afs_vnode_param *);
 extern int afs_fetch_status(struct afs_vnode *, struct key *, bool, afs_access_t *);
 extern int afs_ilookup5_test_by_fid(struct inode *, void *);
@@ -1599,6 +1604,20 @@ void afs_detach_volume_from_servers(struct afs_volume *volume, struct afs_server
 extern int __init afs_fs_init(void);
 extern void afs_fs_exit(void);
 
+/*
+ * symlink.c
+ */
+extern const struct inode_operations afs_symlink_inode_operations;
+extern const struct address_space_operations afs_symlink_aops;
+
+void afs_replace_symlink(struct afs_vnode *vnode, struct afs_symlink *symlink);
+void afs_init_new_symlink(struct afs_vnode *vnode, struct afs_operation *op);
+const char *afs_get_link(struct dentry *dentry, struct inode *inode,
+			 struct delayed_call *callback);
+int afs_readlink(struct dentry *dentry, char __user *buffer, int buflen);
+int afs_symlink_writepages(struct address_space *mapping,
+			   struct writeback_control *wbc);
+
 /*
  * validation.c
  */
diff --git a/fs/afs/symlink.c b/fs/afs/symlink.c
new file mode 100644
index 000000000000..8d2521c5f19d
--- /dev/null
+++ b/fs/afs/symlink.c
@@ -0,0 +1,242 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* AFS filesystem symbolic link handling
+ *
+ * Copyright (C) 2026 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/pagemap.h>
+#include <linux/iov_iter.h>
+#include "internal.h"
+
+static void afs_put_symlink(struct afs_symlink *symlink)
+{
+	if (refcount_dec_and_test(&symlink->ref))
+		kfree_rcu(symlink, rcu);
+}
+
+void afs_replace_symlink(struct afs_vnode *vnode, struct afs_symlink *symlink)
+{
+	struct afs_symlink *old;
+
+	old = rcu_replace_pointer(vnode->symlink, symlink,
+				  lockdep_is_held(&vnode->validate_lock));
+	if (old)
+		afs_put_symlink(old);
+}
+
+/*
+ * Set up a locally created symlink inode for immediate write to the cache.
+ */
+void afs_init_new_symlink(struct afs_vnode *vnode, struct afs_operation *op)
+{
+	size_t dsize = 0;
+	size_t size = strlen(op->create.symlink->content) + 1;
+	char *p;
+
+	rcu_assign_pointer(vnode->symlink, op->create.symlink);
+	op->create.symlink = NULL;
+
+	if (!fscache_cookie_enabled(netfs_i_cookie(&vnode->netfs)))
+		return;
+
+	if (netfs_alloc_folioq_buffer(NULL, &vnode->directory, &dsize, size,
+				      mapping_gfp_mask(vnode->netfs.inode.i_mapping)) < 0)
+		return;
+
+	vnode->directory_size = dsize;
+	p = kmap_local_folio(folioq_folio(vnode->directory, 0), 0);
+	memcpy(p, vnode->symlink, size);
+	kunmap_local(p);
+	netfs_single_mark_inode_dirty(&vnode->netfs.inode);
+}
+
+/*
+ * Read a symlink in a single download.
+ */
+static ssize_t afs_do_read_symlink(struct afs_vnode *vnode)
+{
+	struct afs_symlink *symlink;
+	struct iov_iter iter;
+	ssize_t ret;
+	loff_t i_size;
+
+	i_size = i_size_read(&vnode->netfs.inode);
+	if (i_size > PAGE_SIZE - 1) {
+		trace_afs_file_error(vnode, -EFBIG, afs_file_error_dir_big);
+		return -EFBIG;
+	}
+
+	if (!vnode->directory) {
+		size_t cur_size = 0;
+
+		ret = netfs_alloc_folioq_buffer(NULL,
+						&vnode->directory, &cur_size, PAGE_SIZE,
+						mapping_gfp_mask(vnode->netfs.inode.i_mapping));
+		vnode->directory_size = PAGE_SIZE - 1;
+		if (ret < 0)
+			return ret;
+	}
+
+	iov_iter_folio_queue(&iter, ITER_DEST, vnode->directory, 0, 0, PAGE_SIZE);
+
+	/* AFS requires us to perform the read of a symlink as a single unit to
+	 * avoid issues with the content being changed between reads.
+	 */
+	ret = netfs_read_single(&vnode->netfs.inode, NULL, &iter);
+	if (ret >= 0) {
+		i_size = i_size_read(&vnode->netfs.inode);
+		if (i_size > PAGE_SIZE - 1) {
+			trace_afs_file_error(vnode, -EFBIG, afs_file_error_dir_big);
+			return -EFBIG;
+		}
+		vnode->directory_size = i_size;
+
+		/* Copy the symlink. */
+		symlink = kmalloc_flex(struct afs_symlink, content, i_size + 1,
+				       GFP_KERNEL);
+		if (!symlink)
+			return -ENOMEM;
+
+		refcount_set(&symlink->ref, 1);
+		symlink->content[i_size] = 0;
+
+		const char *s = kmap_local_folio(folioq_folio(vnode->directory, 0), 0);
+
+		memcpy(symlink->content, s, i_size);
+		kunmap_local(s);
+
+		afs_replace_symlink(vnode, symlink);
+	}
+
+	if (!fscache_cookie_enabled(netfs_i_cookie(&vnode->netfs))) {
+		netfs_free_folioq_buffer(vnode->directory);
+		vnode->directory = NULL;
+		vnode->directory_size = 0;
+	}
+
+	return ret;
+}
+
+static ssize_t afs_read_symlink(struct afs_vnode *vnode)
+{
+	ssize_t ret;
+
+	fscache_use_cookie(afs_vnode_cache(vnode), false);
+	ret = afs_do_read_symlink(vnode);
+	fscache_unuse_cookie(afs_vnode_cache(vnode), NULL, NULL);
+	return ret;
+}
+
+static void afs_put_link(void *arg)
+{
+	afs_put_symlink(arg);
+}
+
+const char *afs_get_link(struct dentry *dentry, struct inode *inode,
+			 struct delayed_call *callback)
+{
+	struct afs_symlink *symlink;
+	struct afs_vnode *vnode = AFS_FS_I(inode);
+	ssize_t ret;
+
+	if (!dentry) {
+		/* RCU pathwalk. */
+		if (!vnode->symlink || !afs_check_validity(vnode))
+			return ERR_PTR(-ECHILD);
+		set_delayed_call(callback, NULL, NULL);
+		return rcu_dereference(vnode->symlink)->content;
+	}
+
+	if (vnode->symlink) {
+		ret = afs_validate(vnode, NULL);
+		if (ret < 0)
+			return ERR_PTR(ret);
+
+		down_read(&vnode->validate_lock);
+		if (!test_bit(AFS_VNODE_ZAP_DATA, &vnode->flags))
+			goto good;
+		up_read(&vnode->validate_lock);
+	}
+
+	if (down_write_killable(&vnode->validate_lock) < 0)
+		return ERR_PTR(-ERESTARTSYS);
+	if (!vnode->symlink ||
+	    test_and_clear_bit(AFS_VNODE_ZAP_DATA, &vnode->flags)) {
+		ret = afs_read_symlink(vnode);
+		if (ret < 0) {
+			up_write(&vnode->validate_lock);
+			return ERR_PTR(ret);
+		}
+	}
+
+	downgrade_write(&vnode->validate_lock);
+	
+good:
+	symlink = rcu_dereference_protected(vnode->symlink,
+					    lockdep_is_held(&vnode->validate_lock));
+	refcount_inc(&symlink->ref);
+	up_read(&vnode->validate_lock);
+
+	set_delayed_call(callback, afs_put_link, symlink);
+	return symlink->content;
+}
+
+int afs_readlink(struct dentry *dentry, char __user *buffer, int buflen)
+{
+	DEFINE_DELAYED_CALL(done);
+	const char *content;
+	int len;
+
+	content = afs_get_link(dentry, d_inode(dentry), &done);
+	if (IS_ERR(content)) {
+		do_delayed_call(&done);
+		return PTR_ERR(content);
+	}
+
+	len = umin(strlen(content), buflen);
+	if (copy_to_user(buffer, content, len))
+		len = -EFAULT;
+	do_delayed_call(&done);
+	return len;
+}
+
+/*
+ * Write the symlink contents to the cache as a single blob.  We then throw
+ * away the page we used to receive it.
+ */
+int afs_symlink_writepages(struct address_space *mapping,
+			   struct writeback_control *wbc)
+{
+	struct afs_vnode *vnode = AFS_FS_I(mapping->host);
+	struct iov_iter iter;
+	int ret = 0;
+
+	down_write(&vnode->validate_lock);
+
+	if (vnode->directory &&
+	    atomic64_read(&vnode->cb_expires_at) != AFS_NO_CB_PROMISE) {
+		iov_iter_folio_queue(&iter, ITER_SOURCE, vnode->directory, 0, 0,
+				     i_size_read(&vnode->netfs.inode));
+		ret = netfs_writeback_single(mapping, wbc, &iter);
+	}
+
+	netfs_free_folioq_buffer(vnode->directory);
+	vnode->directory = NULL;
+	vnode->directory_size = 0;
+
+	up_write(&vnode->validate_lock);
+	return ret;
+}
+
+const struct inode_operations afs_symlink_inode_operations = {
+	.get_link	= afs_get_link,
+	.readlink	= afs_readlink,
+};
+
+const struct address_space_operations afs_symlink_aops = {
+	.writepages	= afs_symlink_writepages,
+};
diff --git a/fs/afs/yfsclient.c b/fs/afs/yfsclient.c
index 24fb562ebd33..d941179730a9 100644
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -960,7 +960,7 @@ void yfs_fs_symlink(struct afs_operation *op)
 
 	_enter("");
 
-	contents_sz = strlen(op->create.symlink);
+	contents_sz = strlen(op->create.symlink->content);
 	call = afs_alloc_flat_call(op->net, &yfs_RXYFSSymlink,
 				   sizeof(__be32) +
 				   sizeof(struct yfs_xdr_RPCFlags) +
@@ -981,7 +981,7 @@ void yfs_fs_symlink(struct afs_operation *op)
 	bp = xdr_encode_u32(bp, 0); /* RPC flags */
 	bp = xdr_encode_YFSFid(bp, &dvp->fid);
 	bp = xdr_encode_name(bp, name);
-	bp = xdr_encode_string(bp, op->create.symlink, contents_sz);
+	bp = xdr_encode_string(bp, op->create.symlink->content, contents_sz);
 	bp = xdr_encode_YFSStoreStatus(bp, &mode, &op->mtime);
 	yfs_check_req(call, bp);
 

