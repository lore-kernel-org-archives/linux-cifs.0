Return-Path: <SRS0=uMGe=VT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1076DC76197
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Jul 2019 11:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF4FC20821
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Jul 2019 11:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563793689;
	bh=edXYnkeSeLyw7z/3m5e6W4hSCPSrcMqY8VW8GLtxSVg=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=YEWaoeRGEgJCokYUlbnQmPOOz0OsbkoJzgj2ZOVCRJubL0/OizthRcKjrDlOqa8Yv
	 gnUQUhjz62Up3YL1jdifHOPANhIqRxk9Jrw9hwOHpF1HpSmUJhQ3yzP5Qvb9pjtTDj
	 zkr79bHZ61gkW3QbIkm0IDUp2g/eVY3thy07FcEU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729869AbfGVLIJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Jul 2019 07:08:09 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35554 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729832AbfGVLH7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Jul 2019 07:07:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AS5oxtIdo2yG09411/sIu1r84zBQ65Tq3DN/Tw97Q3I=; b=KQtnhzelgtCOjykf4X/wmsmthe
        vwKSBc8Slqm/Em4pBgQCuY5vrdmMSj2BrFDZ8UzAhToyj6TasMxX54nmDjyUVIF57ywWAY/poC/RE
        ZisqG6sD4WK/VEZei77B6pg7MIwtOJffs02wrd8wfRDwMhSeEIGUmX6tM7OXtaM6gSpnWcseL8m8O
        2Is8FMHcToyp7Nf5Z8thvk/ubuCSV6na7Zsa08VzVGWw762fzOcxhm+zc/BRHzEAjuJIRlCcuDARx
        POGO4i8dW12OzwwxMSCbXHhZrNALAvl6T9Qtg/F8nTjl1cyX/H1tuhBGVxcL744pkDT276rTZZ6s4
        lv9c4r/g==;
Received: from 177.157.124.3.dynamic.adsl.gvt.net.br ([177.157.124.3] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hpWAe-000252-HC; Mon, 22 Jul 2019 11:07:57 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hpWAa-00041Q-B7; Mon, 22 Jul 2019 08:07:52 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Steve French <sfrench@samba.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        linux-doc@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, devel@lists.orangefs.org
Subject: [PATCH 13/22] docs: fs: convert docs without extension to ReST
Date:   Mon, 22 Jul 2019 08:07:40 -0300
Message-Id: <1254cdba5f4e8254a4ead829502d07d8d7cff3d2.1563792334.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1563792333.git.mchehab+samsung@kernel.org>
References: <cover.1563792333.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There are 3 remaining files without an extension inside the fs docs
dir.

Manually convert them to ReST.

In the case of the nfs/exporting.rst file, as the nfs docs
aren't ported yet, I opted to convert and add a :orphan: there,
with should be removed when it gets added into a nfs-specific
part of the fs documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 ...irectory-locking => directory-locking.rst} |  40 ++-
 Documentation/filesystems/index.rst           |   2 +
 .../filesystems/{Locking => locking.rst}      | 257 ++++++++++++------
 .../nfs/{Exporting => exporting.rst}          |  31 ++-
 Documentation/filesystems/vfs.rst             |   2 +-
 fs/cifs/export.c                              |   2 +-
 fs/exportfs/expfs.c                           |   2 +-
 fs/isofs/export.c                             |   2 +-
 fs/orangefs/file.c                            |   2 +-
 include/linux/dcache.h                        |   2 +-
 include/linux/exportfs.h                      |   2 +-
 11 files changed, 225 insertions(+), 119 deletions(-)
 rename Documentation/filesystems/{directory-locking => directory-locking.rst} (86%)
 rename Documentation/filesystems/{Locking => locking.rst} (79%)
 rename Documentation/filesystems/nfs/{Exporting => exporting.rst} (91%)

diff --git a/Documentation/filesystems/directory-locking b/Documentation/filesystems/directory-locking.rst
similarity index 86%
rename from Documentation/filesystems/directory-locking
rename to Documentation/filesystems/directory-locking.rst
index 4e32cb961e5b..de12016ee419 100644
--- a/Documentation/filesystems/directory-locking
+++ b/Documentation/filesystems/directory-locking.rst
@@ -1,12 +1,17 @@
-	Locking scheme used for directory operations is based on two
+=================
+Directory Locking
+=================
+
+
+Locking scheme used for directory operations is based on two
 kinds of locks - per-inode (->i_rwsem) and per-filesystem
 (->s_vfs_rename_mutex).
 
-	When taking the i_rwsem on multiple non-directory objects, we
+When taking the i_rwsem on multiple non-directory objects, we
 always acquire the locks in order by increasing address.  We'll call
 that "inode pointer" order in the following.
 
-	For our purposes all operations fall in 5 classes:
+For our purposes all operations fall in 5 classes:
 
 1) read access.  Locking rules: caller locks directory we are accessing.
 The lock is taken shared.
@@ -27,25 +32,29 @@ NB: we might get away with locking the the source (and target in exchange
 case) shared.
 
 5) link creation.  Locking rules:
+
 	* lock parent
 	* check that source is not a directory
 	* lock source
 	* call the method.
+
 All locks are exclusive.
 
 6) cross-directory rename.  The trickiest in the whole bunch.  Locking
 rules:
+
 	* lock the filesystem
 	* lock parents in "ancestors first" order.
 	* find source and target.
 	* if old parent is equal to or is a descendent of target
-		fail with -ENOTEMPTY
+	  fail with -ENOTEMPTY
 	* if new parent is equal to or is a descendent of source
-		fail with -ELOOP
+	  fail with -ELOOP
 	* If it's an exchange, lock both the source and the target.
 	* If the target exists, lock it.  If the source is a non-directory,
 	  lock it.  If we need to lock both, do so in inode pointer order.
 	* call the method.
+
 All ->i_rwsem are taken exclusive.  Again, we might get away with locking
 the the source (and target in exchange case) shared.
 
@@ -54,10 +63,11 @@ read, modified or removed by method will be locked by caller.
 
 
 If no directory is its own ancestor, the scheme above is deadlock-free.
+
 Proof:
 
 	First of all, at any moment we have a partial ordering of the
-objects - A < B iff A is an ancestor of B.
+	objects - A < B iff A is an ancestor of B.
 
 	That ordering can change.  However, the following is true:
 
@@ -77,32 +87,32 @@ objects - A < B iff A is an ancestor of B.
     non-directory object, except renames, which take locks on source and
     target in inode pointer order in the case they are not directories.)
 
-	Now consider the minimal deadlock.  Each process is blocked on
+Now consider the minimal deadlock.  Each process is blocked on
 attempt to acquire some lock and already holds at least one lock.  Let's
 consider the set of contended locks.  First of all, filesystem lock is
 not contended, since any process blocked on it is not holding any locks.
 Thus all processes are blocked on ->i_rwsem.
 
-	By (3), any process holding a non-directory lock can only be
+By (3), any process holding a non-directory lock can only be
 waiting on another non-directory lock with a larger address.  Therefore
 the process holding the "largest" such lock can always make progress, and
 non-directory objects are not included in the set of contended locks.
 
-	Thus link creation can't be a part of deadlock - it can't be
+Thus link creation can't be a part of deadlock - it can't be
 blocked on source and it means that it doesn't hold any locks.
 
-	Any contended object is either held by cross-directory rename or
+Any contended object is either held by cross-directory rename or
 has a child that is also contended.  Indeed, suppose that it is held by
 operation other than cross-directory rename.  Then the lock this operation
 is blocked on belongs to child of that object due to (1).
 
-	It means that one of the operations is cross-directory rename.
+It means that one of the operations is cross-directory rename.
 Otherwise the set of contended objects would be infinite - each of them
 would have a contended child and we had assumed that no object is its
 own descendent.  Moreover, there is exactly one cross-directory rename
 (see above).
 
-	Consider the object blocking the cross-directory rename.  One
+Consider the object blocking the cross-directory rename.  One
 of its descendents is locked by cross-directory rename (otherwise we
 would again have an infinite set of contended objects).  But that
 means that cross-directory rename is taking locks out of order.  Due
@@ -112,7 +122,7 @@ try to acquire lock on descendent before the lock on ancestor.
 Contradiction.  I.e.  deadlock is impossible.  Q.E.D.
 
 
-	These operations are guaranteed to avoid loop creation.  Indeed,
+These operations are guaranteed to avoid loop creation.  Indeed,
 the only operation that could introduce loops is cross-directory rename.
 Since the only new (parent, child) pair added by rename() is (new parent,
 source), such loop would have to contain these objects and the rest of it
@@ -123,13 +133,13 @@ new parent had been equal to or a descendent of source since the moment when
 we had acquired filesystem lock and rename() would fail with -ELOOP in that
 case.
 
-	While this locking scheme works for arbitrary DAGs, it relies on
+While this locking scheme works for arbitrary DAGs, it relies on
 ability to check that directory is a descendent of another object.  Current
 implementation assumes that directory graph is a tree.  This assumption is
 also preserved by all operations (cross-directory rename on a tree that would
 not introduce a cycle will leave it a tree and link() fails for directories).
 
-	Notice that "directory" in the above == "anything that might have
+Notice that "directory" in the above == "anything that might have
 children", so if we are going to introduce hybrid objects we will need
 either to make sure that link(2) doesn't work for them or to make changes
 in is_subdir() that would make it work even in presence of such beasts.
diff --git a/Documentation/filesystems/index.rst b/Documentation/filesystems/index.rst
index 2de2fe2ab078..08320c35d03b 100644
--- a/Documentation/filesystems/index.rst
+++ b/Documentation/filesystems/index.rst
@@ -20,6 +20,8 @@ algorithms work.
    path-lookup
    api-summary
    splice
+   locking
+   directory-locking
 
 Filesystem support layers
 =========================
diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/locking.rst
similarity index 79%
rename from Documentation/filesystems/Locking
rename to Documentation/filesystems/locking.rst
index 204dd3ea36bb..fc3a0704553c 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/locking.rst
@@ -1,14 +1,22 @@
-	The text below describes the locking rules for VFS-related methods.
+=======
+Locking
+=======
+
+The text below describes the locking rules for VFS-related methods.
 It is (believed to be) up-to-date. *Please*, if you change anything in
 prototypes or locking protocols - update this file. And update the relevant
 instances in the tree, don't leave that to maintainers of filesystems/devices/
 etc. At the very least, put the list of dubious cases in the end of this file.
 Don't turn it into log - maintainers of out-of-the-tree code are supposed to
 be able to use diff(1).
-	Thing currently missing here: socket operations. Alexey?
 
---------------------------- dentry_operations --------------------------
-prototypes:
+Thing currently missing here: socket operations. Alexey?
+
+dentry_operations
+=================
+
+prototypes::
+
 	int (*d_revalidate)(struct dentry *, unsigned int);
 	int (*d_weak_revalidate)(struct dentry *, unsigned int);
 	int (*d_hash)(const struct dentry *, struct qstr *);
@@ -24,23 +32,30 @@ prototypes:
 	struct dentry *(*d_real)(struct dentry *, const struct inode *);
 
 locking rules:
-		rename_lock	->d_lock	may block	rcu-walk
-d_revalidate:	no		no		yes (ref-walk)	maybe
-d_weak_revalidate:no		no		yes	 	no
-d_hash		no		no		no		maybe
-d_compare:	yes		no		no		maybe
-d_delete:	no		yes		no		no
-d_init:	no		no		yes		no
-d_release:	no		no		yes		no
-d_prune:        no              yes             no              no
-d_iput:		no		no		yes		no
-d_dname:	no		no		no		no
-d_automount:	no		no		yes		no
-d_manage:	no		no		yes (ref-walk)	maybe
-d_real		no		no		yes 		no
 
---------------------------- inode_operations --------------------------- 
-prototypes:
+================== ===========	========	==============	========
+ops		   rename_lock	->d_lock	may block	rcu-walk
+================== ===========	========	==============	========
+d_revalidate:	   no		no		yes (ref-walk)	maybe
+d_weak_revalidate: no		no		yes	 	no
+d_hash		   no		no		no		maybe
+d_compare:	   yes		no		no		maybe
+d_delete:	   no		yes		no		no
+d_init:		   no		no		yes		no
+d_release:	   no		no		yes		no
+d_prune:           no		yes		no		no
+d_iput:		   no		no		yes		no
+d_dname:	   no		no		no		no
+d_automount:	   no		no		yes		no
+d_manage:	   no		no		yes (ref-walk)	maybe
+d_real		   no		no		yes 		no
+================== ===========	========	==============	========
+
+inode_operations
+================
+
+prototypes::
+
 	int (*create) (struct inode *,struct dentry *,umode_t, bool);
 	struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
 	int (*link) (struct dentry *,struct inode *,struct dentry *);
@@ -68,7 +83,10 @@ prototypes:
 
 locking rules:
 	all may block
-		i_rwsem(inode)
+
+============	=============================================
+ops		i_rwsem(inode)
+============	=============================================
 lookup:		shared
 create:		exclusive
 link:		exclusive (both)
@@ -89,17 +107,21 @@ fiemap:		no
 update_time:	no
 atomic_open:	exclusive
 tmpfile:	no
+============	=============================================
 
 
 	Additionally, ->rmdir(), ->unlink() and ->rename() have ->i_rwsem
 	exclusive on victim.
 	cross-directory ->rename() has (per-superblock) ->s_vfs_rename_sem.
 
-See Documentation/filesystems/directory-locking for more detailed discussion
+See Documentation/filesystems/directory-locking.rst for more detailed discussion
 of the locking scheme for directory operations.
 
------------------------ xattr_handler operations -----------------------
-prototypes:
+xattr_handler operations
+========================
+
+prototypes::
+
 	bool (*list)(struct dentry *dentry);
 	int (*get)(const struct xattr_handler *handler, struct dentry *dentry,
 		   struct inode *inode, const char *name, void *buffer,
@@ -110,13 +132,20 @@ prototypes:
 
 locking rules:
 	all may block
-		i_rwsem(inode)
+
+=====		==============
+ops		i_rwsem(inode)
+=====		==============
 list:		no
 get:		no
 set:		exclusive
+=====		==============
+
+super_operations
+================
+
+prototypes::
 
---------------------------- super_operations ---------------------------
-prototypes:
 	struct inode *(*alloc_inode)(struct super_block *sb);
 	void (*free_inode)(struct inode *);
 	void (*destroy_inode)(struct inode *);
@@ -138,7 +167,10 @@ prototypes:
 
 locking rules:
 	All may block [not true, see below]
-			s_umount
+
+======================	============	========================
+ops			s_umount	note
+======================	============	========================
 alloc_inode:
 free_inode:				called from RCU callback
 destroy_inode:
@@ -157,6 +189,7 @@ show_options:		no		(namespace_sem)
 quota_read:		no		(see below)
 quota_write:		no		(see below)
 bdev_try_to_free_page:	no		(see below)
+======================	============	========================
 
 ->statfs() has s_umount (shared) when called by ustat(2) (native or
 compat), but that's an accident of bad API; s_umount is used to pin
@@ -164,31 +197,44 @@ the superblock down when we only have dev_t given us by userland to
 identify the superblock.  Everything else (statfs(), fstatfs(), etc.)
 doesn't hold it when calling ->statfs() - superblock is pinned down
 by resolving the pathname passed to syscall.
+
 ->quota_read() and ->quota_write() functions are both guaranteed to
 be the only ones operating on the quota file by the quota code (via
 dqio_sem) (unless an admin really wants to screw up something and
 writes to quota files with quotas on). For other details about locking
 see also dquot_operations section.
+
 ->bdev_try_to_free_page is called from the ->releasepage handler of
 the block device inode.  See there for more details.
 
---------------------------- file_system_type ---------------------------
-prototypes:
+file_system_type
+================
+
+prototypes::
+
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
 	void (*kill_sb) (struct super_block *);
+
 locking rules:
-		may block
+
+=======		=========
+ops		may block
+=======		=========
 mount		yes
 kill_sb		yes
+=======		=========
 
 ->mount() returns ERR_PTR or the root dentry; its superblock should be locked
 on return.
+
 ->kill_sb() takes a write-locked superblock, does all shutdown work on it,
 unlocks and drops the reference.
 
---------------------------- address_space_operations --------------------------
-prototypes:
+address_space_operations
+========================
+prototypes::
+
 	int (*writepage)(struct page *page, struct writeback_control *wbc);
 	int (*readpage)(struct file *, struct page *);
 	int (*writepages)(struct address_space *, struct writeback_control *);
@@ -218,14 +264,16 @@ prototypes:
 locking rules:
 	All except set_page_dirty and freepage may block
 
-			PageLocked(page)	i_rwsem
+======================	======================== =========
+ops			PageLocked(page)	 i_rwsem
+======================	======================== =========
 writepage:		yes, unlocks (see below)
 readpage:		yes, unlocks
 writepages:
 set_page_dirty		no
 readpages:
-write_begin:		locks the page		exclusive
-write_end:		yes, unlocks		exclusive
+write_begin:		locks the page		 exclusive
+write_end:		yes, unlocks		 exclusive
 bmap:
 invalidatepage:		yes
 releasepage:		yes
@@ -239,17 +287,18 @@ is_partially_uptodate:	yes
 error_remove_page:	yes
 swap_activate:		no
 swap_deactivate:	no
+======================	======================== =========
 
-	->write_begin(), ->write_end() and ->readpage() may be called from
+->write_begin(), ->write_end() and ->readpage() may be called from
 the request handler (/dev/loop).
 
-	->readpage() unlocks the page, either synchronously or via I/O
+->readpage() unlocks the page, either synchronously or via I/O
 completion.
 
-	->readpages() populates the pagecache with the passed pages and starts
+->readpages() populates the pagecache with the passed pages and starts
 I/O against them.  They come unlocked upon I/O completion.
 
-	->writepage() is used for two purposes: for "memory cleansing" and for
+->writepage() is used for two purposes: for "memory cleansing" and for
 "sync".  These are quite different operations and the behaviour may differ
 depending upon the mode.
 
@@ -297,70 +346,81 @@ will leave the page itself marked clean but it will be tagged as dirty in the
 radix tree.  This incoherency can lead to all sorts of hard-to-debug problems
 in the filesystem like having dirty inodes at umount and losing written data.
 
-	->writepages() is used for periodic writeback and for syscall-initiated
+->writepages() is used for periodic writeback and for syscall-initiated
 sync operations.  The address_space should start I/O against at least
-*nr_to_write pages.  *nr_to_write must be decremented for each page which is
-written.  The address_space implementation may write more (or less) pages
-than *nr_to_write asks for, but it should try to be reasonably close.  If
-nr_to_write is NULL, all dirty pages must be written.
+``*nr_to_write`` pages.  ``*nr_to_write`` must be decremented for each page
+which is written.  The address_space implementation may write more (or less)
+pages than ``*nr_to_write`` asks for, but it should try to be reasonably close.
+If nr_to_write is NULL, all dirty pages must be written.
 
 writepages should _only_ write pages which are present on
 mapping->io_pages.
 
-	->set_page_dirty() is called from various places in the kernel
+->set_page_dirty() is called from various places in the kernel
 when the target page is marked as needing writeback.  It may be called
 under spinlock (it cannot block) and is sometimes called with the page
 not locked.
 
-	->bmap() is currently used by legacy ioctl() (FIBMAP) provided by some
+->bmap() is currently used by legacy ioctl() (FIBMAP) provided by some
 filesystems and by the swapper. The latter will eventually go away.  Please,
 keep it that way and don't breed new callers.
 
-	->invalidatepage() is called when the filesystem must attempt to drop
+->invalidatepage() is called when the filesystem must attempt to drop
 some or all of the buffers from the page when it is being truncated. It
 returns zero on success. If ->invalidatepage is zero, the kernel uses
 block_invalidatepage() instead.
 
-	->releasepage() is called when the kernel is about to try to drop the
+->releasepage() is called when the kernel is about to try to drop the
 buffers from the page in preparation for freeing it.  It returns zero to
 indicate that the buffers are (or may be) freeable.  If ->releasepage is zero,
 the kernel assumes that the fs has no private interest in the buffers.
 
-	->freepage() is called when the kernel is done dropping the page
+->freepage() is called when the kernel is done dropping the page
 from the page cache.
 
-	->launder_page() may be called prior to releasing a page if
+->launder_page() may be called prior to releasing a page if
 it is still found to be dirty. It returns zero if the page was successfully
 cleaned, or an error value if not. Note that in order to prevent the page
 getting mapped back in and redirtied, it needs to be kept locked
 across the entire operation.
 
-	->swap_activate will be called with a non-zero argument on
+->swap_activate will be called with a non-zero argument on
 files backing (non block device backed) swapfiles. A return value
 of zero indicates success, in which case this file can be used for
 backing swapspace. The swapspace operations will be proxied to the
 address space operations.
 
-	->swap_deactivate() will be called in the sys_swapoff()
+->swap_deactivate() will be called in the sys_swapoff()
 path after ->swap_activate() returned success.
 
------------------------ file_lock_operations ------------------------------
-prototypes:
+file_lock_operations
+====================
+
+prototypes::
+
 	void (*fl_copy_lock)(struct file_lock *, struct file_lock *);
 	void (*fl_release_private)(struct file_lock *);
 
 
 locking rules:
-			inode->i_lock	may block
+
+===================	=============	=========
+ops			inode->i_lock	may block
+===================	=============	=========
 fl_copy_lock:		yes		no
-fl_release_private:	maybe		maybe[1]
+fl_release_private:	maybe		maybe[1]_
+===================	=============	=========
 
-[1]:	->fl_release_private for flock or POSIX locks is currently allowed
-to block. Leases however can still be freed while the i_lock is held and
-so fl_release_private called on a lease should not block.
+.. [1]:
+   ->fl_release_private for flock or POSIX locks is currently allowed
+   to block. Leases however can still be freed while the i_lock is held and
+   so fl_release_private called on a lease should not block.
+
+lock_manager_operations
+=======================
+
+prototypes::
 
------------------------ lock_manager_operations ---------------------------
-prototypes:
 	void (*lm_notify)(struct file_lock *);  /* unblock callback */
 	int (*lm_grant)(struct file_lock *, struct file_lock *, int);
 	void (*lm_break)(struct file_lock *); /* break_lease callback */
@@ -368,24 +428,33 @@ prototypes:
 
 locking rules:
 
-			inode->i_lock	blocked_lock_lock	may block
+==========		=============	=================	=========
+ops			inode->i_lock	blocked_lock_lock	may block
+==========		=============	=================	=========
 lm_notify:		yes		yes			no
 lm_grant:		no		no			no
 lm_break:		yes		no			no
 lm_change		yes		no			no
+==========		=============	=================	=========
+
+buffer_head
+===========
+
+prototypes::
 
---------------------------- buffer_head -----------------------------------
-prototypes:
 	void (*b_end_io)(struct buffer_head *bh, int uptodate);
 
 locking rules:
-	called from interrupts. In other words, extreme care is needed here.
+
+called from interrupts. In other words, extreme care is needed here.
 bh is locked, but that's all warranties we have here. Currently only RAID1,
 highmem, fs/buffer.c, and fs/ntfs/aops.c are providing these. Block devices
 call this method upon the IO completion.
 
---------------------------- block_device_operations -----------------------
-prototypes:
+block_device_operations
+=======================
+prototypes::
+
 	int (*open) (struct block_device *, fmode_t);
 	int (*release) (struct gendisk *, fmode_t);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
@@ -399,7 +468,10 @@ prototypes:
 	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
 
 locking rules:
-			bd_mutex
+
+======================= ===================
+ops			bd_mutex
+======================= ===================
 open:			yes
 release:		yes
 ioctl:			no
@@ -410,6 +482,7 @@ unlock_native_capacity:	no
 revalidate_disk:	no
 getgeo:			no
 swap_slot_free_notify:	no	(see below)
+======================= ===================
 
 media_changed, unlock_native_capacity and revalidate_disk are called only from
 check_disk_change().
@@ -418,8 +491,11 @@ swap_slot_free_notify is called with swap_lock and sometimes the page lock
 held.
 
 
---------------------------- file_operations -------------------------------
-prototypes:
+file_operations
+===============
+
+prototypes::
+
 	loff_t (*llseek) (struct file *, loff_t, int);
 	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
 	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
@@ -455,7 +531,6 @@ prototypes:
 			size_t, unsigned int);
 	int (*setlease)(struct file *, long, struct file_lock **, void **);
 	long (*fallocate)(struct file *, int, loff_t, loff_t);
-};
 
 locking rules:
 	All may block.
@@ -490,8 +565,11 @@ in sys_read() and friends.
 the lease within the individual filesystem to record the result of the
 operation
 
---------------------------- dquot_operations -------------------------------
-prototypes:
+dquot_operations
+================
+
+prototypes::
+
 	int (*write_dquot) (struct dquot *);
 	int (*acquire_dquot) (struct dquot *);
 	int (*release_dquot) (struct dquot *);
@@ -503,20 +581,26 @@ a proper locking wrt the filesystem and call the generic quota operations.
 
 What filesystem should expect from the generic quota functions:
 
-		FS recursion	Held locks when called
+==============	============	=========================
+ops		FS recursion	Held locks when called
+==============	============	=========================
 write_dquot:	yes		dqonoff_sem or dqptr_sem
 acquire_dquot:	yes		dqonoff_sem or dqptr_sem
 release_dquot:	yes		dqonoff_sem or dqptr_sem
 mark_dirty:	no		-
 write_info:	yes		dqonoff_sem
+==============	============	=========================
 
 FS recursion means calling ->quota_read() and ->quota_write() from superblock
 operations.
 
 More details about quota locking can be found in fs/dquot.c.
 
---------------------------- vm_operations_struct -----------------------------
-prototypes:
+vm_operations_struct
+====================
+
+prototypes::
+
 	void (*open)(struct vm_area_struct*);
 	void (*close)(struct vm_area_struct*);
 	vm_fault_t (*fault)(struct vm_area_struct*, struct vm_fault *);
@@ -525,7 +609,10 @@ prototypes:
 	int (*access)(struct vm_area_struct *, unsigned long, void*, int, int);
 
 locking rules:
-		mmap_sem	PageLocked(page)
+
+=============	========	===========================
+ops		mmap_sem	PageLocked(page)
+=============	========	===========================
 open:		yes
 close:		yes
 fault:		yes		can return with page locked
@@ -533,8 +620,9 @@ map_pages:	yes
 page_mkwrite:	yes		can return with page locked
 pfn_mkwrite:	yes
 access:		yes
+=============	========	===========================
 
-	->fault() is called when a previously not present pte is about
+->fault() is called when a previously not present pte is about
 to be faulted in. The filesystem must find and return the page associated
 with the passed in "pgoff" in the vm_fault structure. If it is possible that
 the page may be truncated and/or invalidated, then the filesystem must lock
@@ -542,7 +630,7 @@ the page, then ensure it is not already truncated (the page lock will block
 subsequent truncate), and then return with VM_FAULT_LOCKED, and the page
 locked. The VM will unlock the page.
 
-	->map_pages() is called when VM asks to map easy accessible pages.
+->map_pages() is called when VM asks to map easy accessible pages.
 Filesystem should find and map pages associated with offsets from "start_pgoff"
 till "end_pgoff". ->map_pages() is called with page table locked and must
 not block.  If it's not possible to reach a page without blocking,
@@ -551,25 +639,26 @@ page table entry. Pointer to entry associated with the page is passed in
 "pte" field in vm_fault structure. Pointers to entries for other offsets
 should be calculated relative to "pte".
 
-	->page_mkwrite() is called when a previously read-only pte is
+->page_mkwrite() is called when a previously read-only pte is
 about to become writeable. The filesystem again must ensure that there are
 no truncate/invalidate races, and then return with the page locked. If
 the page has been truncated, the filesystem should not look up a new page
 like the ->fault() handler, but simply return with VM_FAULT_NOPAGE, which
 will cause the VM to retry the fault.
 
-	->pfn_mkwrite() is the same as page_mkwrite but when the pte is
+->pfn_mkwrite() is the same as page_mkwrite but when the pte is
 VM_PFNMAP or VM_MIXEDMAP with a page-less entry. Expected return is
 VM_FAULT_NOPAGE. Or one of the VM_FAULT_ERROR types. The default behavior
 after this call is to make the pte read-write, unless pfn_mkwrite returns
 an error.
 
-	->access() is called when get_user_pages() fails in
+->access() is called when get_user_pages() fails in
 access_process_vm(), typically used to debug a process through
 /proc/pid/mem or ptrace.  This function is needed only for
 VM_IO | VM_PFNMAP VMAs.
 
-================================================================================
+--------------------------------------------------------------------------------
+
 			Dubious stuff
 
 (if you break something or notice that it is broken and do not fix it yourself
diff --git a/Documentation/filesystems/nfs/Exporting b/Documentation/filesystems/nfs/exporting.rst
similarity index 91%
rename from Documentation/filesystems/nfs/Exporting
rename to Documentation/filesystems/nfs/exporting.rst
index 63889149f532..33d588a01ace 100644
--- a/Documentation/filesystems/nfs/Exporting
+++ b/Documentation/filesystems/nfs/exporting.rst
@@ -1,3 +1,4 @@
+:orphan:
 
 Making Filesystems Exportable
 =============================
@@ -42,9 +43,9 @@ filehandle fragment, there is no automatic creation of a path prefix
 for the object.  This leads to two related but distinct features of
 the dcache that are not needed for normal filesystem access.
 
-1/ The dcache must sometimes contain objects that are not part of the
+1. The dcache must sometimes contain objects that are not part of the
    proper prefix. i.e that are not connected to the root.
-2/ The dcache must be prepared for a newly found (via ->lookup) directory
+2. The dcache must be prepared for a newly found (via ->lookup) directory
    to already have a (non-connected) dentry, and must be able to move
    that dentry into place (based on the parent and name in the
    ->lookup).   This is particularly needed for directories as
@@ -52,7 +53,7 @@ the dcache that are not needed for normal filesystem access.
 
 To implement these features, the dcache has:
 
-a/ A dentry flag DCACHE_DISCONNECTED which is set on
+a. A dentry flag DCACHE_DISCONNECTED which is set on
    any dentry that might not be part of the proper prefix.
    This is set when anonymous dentries are created, and cleared when a
    dentry is noticed to be a child of a dentry which is in the proper
@@ -71,48 +72,52 @@ a/ A dentry flag DCACHE_DISCONNECTED which is set on
    dentries.  That guarantees that we won't need to hunt them down upon
    umount.
 
-b/ A primitive for creation of secondary roots - d_obtain_root(inode).
+b. A primitive for creation of secondary roots - d_obtain_root(inode).
    Those do _not_ bear DCACHE_DISCONNECTED.  They are placed on the
    per-superblock list (->s_roots), so they can be located at umount
    time for eviction purposes.
 
-c/ Helper routines to allocate anonymous dentries, and to help attach
+c. Helper routines to allocate anonymous dentries, and to help attach
    loose directory dentries at lookup time. They are:
+
     d_obtain_alias(inode) will return a dentry for the given inode.
       If the inode already has a dentry, one of those is returned.
+
       If it doesn't, a new anonymous (IS_ROOT and
-        DCACHE_DISCONNECTED) dentry is allocated and attached.
+      DCACHE_DISCONNECTED) dentry is allocated and attached.
+
       In the case of a directory, care is taken that only one dentry
       can ever be attached.
+
     d_splice_alias(inode, dentry) will introduce a new dentry into the tree;
       either the passed-in dentry or a preexisting alias for the given inode
       (such as an anonymous one created by d_obtain_alias), if appropriate.
       It returns NULL when the passed-in dentry is used, following the calling
       convention of ->lookup.
- 
+
 Filesystem Issues
 -----------------
 
 For a filesystem to be exportable it must:
- 
-   1/ provide the filehandle fragment routines described below.
-   2/ make sure that d_splice_alias is used rather than d_add
+
+   1. provide the filehandle fragment routines described below.
+   2. make sure that d_splice_alias is used rather than d_add
       when ->lookup finds an inode for a given parent and name.
 
-      If inode is NULL, d_splice_alias(inode, dentry) is equivalent to
+      If inode is NULL, d_splice_alias(inode, dentry) is equivalent to::
 
 		d_add(dentry, inode), NULL
 
       Similarly, d_splice_alias(ERR_PTR(err), dentry) = ERR_PTR(err)
 
-      Typically the ->lookup routine will simply end with a:
+      Typically the ->lookup routine will simply end with a::
 
 		return d_splice_alias(inode, dentry);
 	}
 
 
 
-  A file system implementation declares that instances of the filesystem
+A file system implementation declares that instances of the filesystem
 are exportable by setting the s_export_op field in the struct
 super_block.  This field must point to a "struct export_operations"
 struct which has the following members:
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 0f85ab21c2ca..7d4d09dd5e6d 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -20,7 +20,7 @@ kernel which allows different filesystem implementations to coexist.
 
 VFS system calls open(2), stat(2), read(2), write(2), chmod(2) and so on
 are called from a process context.  Filesystem locking is described in
-the document Documentation/filesystems/Locking.
+the document Documentation/filesystems/locking.rst.
 
 
 Directory Entry Cache (dcache)
diff --git a/fs/cifs/export.c b/fs/cifs/export.c
index ce8b7f677c58..eb0bb8ca8e63 100644
--- a/fs/cifs/export.c
+++ b/fs/cifs/export.c
@@ -24,7 +24,7 @@
  */
 
  /*
-  * See Documentation/filesystems/nfs/Exporting
+  * See Documentation/filesystems/nfs/exporting.rst
   * and examples in fs/exportfs
   *
   * Since cifs is a network file system, an "fsid" must be included for
diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index f0e549783caf..09bc68708d28 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -7,7 +7,7 @@
  * and for mapping back from file handles to dentries.
  *
  * For details on why we do all the strange and hairy things in here
- * take a look at Documentation/filesystems/nfs/Exporting.
+ * take a look at Documentation/filesystems/nfs/exporting.rst.
  */
 #include <linux/exportfs.h>
 #include <linux/fs.h>
diff --git a/fs/isofs/export.c b/fs/isofs/export.c
index 85a9093769a9..35768a63fb1d 100644
--- a/fs/isofs/export.c
+++ b/fs/isofs/export.c
@@ -10,7 +10,7 @@
  *
  * The following files are helpful:
  *
- *     Documentation/filesystems/nfs/Exporting
+ *     Documentation/filesystems/nfs/exporting.rst
  *     fs/exportfs/expfs.c.
  */
 
diff --git a/fs/orangefs/file.c b/fs/orangefs/file.c
index 960f9a3c012d..a5612abc0936 100644
--- a/fs/orangefs/file.c
+++ b/fs/orangefs/file.c
@@ -555,7 +555,7 @@ static int orangefs_fsync(struct file *file,
  * Change the file pointer position for an instance of an open file.
  *
  * \note If .llseek is overriden, we must acquire lock as described in
- *       Documentation/filesystems/Locking.
+ *       Documentation/filesystems/locking.rst.
  *
  * Future upgrade could support SEEK_DATA and SEEK_HOLE but would
  * require much changes to the FS
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 9451011ac014..10090f11ab95 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -151,7 +151,7 @@ struct dentry_operations {
 
 /*
  * Locking rules for dentry_operations callbacks are to be found in
- * Documentation/filesystems/Locking. Keep it updated!
+ * Documentation/filesystems/locking.rst. Keep it updated!
  *
  * FUrther descriptions are found in Documentation/filesystems/vfs.rst.
  * Keep it updated too!
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index 0d3037419bc7..cf6571fc9c01 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -139,7 +139,7 @@ struct fid {
  * @get_parent:     find the parent of a given directory
  * @commit_metadata: commit metadata changes to stable storage
  *
- * See Documentation/filesystems/nfs/Exporting for details on how to use
+ * See Documentation/filesystems/nfs/exporting.rst for details on how to use
  * this interface correctly.
  *
  * encode_fh:
-- 
2.21.0

