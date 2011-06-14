From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: invalidate any mapped pages before turning cache off
Date: Tue, 14 Jun 2011 20:36:30 +0530
Message-ID: <4DF778F6.3040704@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When disabling inode cookie, we were returning the cookie and setting
cifsi->fscache to NULL but failed to invalidate any previously mapped
pages. This resulted in "Bad page state" errors and manifested in other
kind of errors when running fsstress. Fix it by invalidating mapped
pages when we disable the inode cookie.

Also make cifs_fscache_disable_inode_cookie() return error if
invalidate_inode_pages2() fails

This patch fixes the following oops and "Bad page state" errors seen
during fsstress testing.

[  417.302635] ------------[ cut here ]------------
[  417.304903] kernel BUG at fs/cachefiles/namei.c:201!
[  417.307613] invalid opcode: 0000 [#1] SMP 
[  417.309860] last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
[  417.313868] CPU 1 
[  417.314855] Modules linked in: fuse nls_utf8 cifs sunrpc cachefiles fscache ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables joydev microcode i2c_piix4 virtio_balloon i2c_core virtio_net ipv6 virtio_blk [last unloaded: mperf]
[  417.328983] 
[  417.329923] Pid: 5, comm: kworker/u:0 Not tainted 2.6.38.7-30.fc15.x86_64 #1 Bochs Bochs
[  417.333928] RIP: 0010:[<ffffffffa00bebe4>]  [<ffffffffa00bebe4>] cachefiles_walk_to_object+0x436/0x745 [cachefiles]
[  417.338967] RSP: 0018:ffff88002ce6dd00  EFLAGS: 00010282
[  417.341761] RAX: ffff88002ef165f0 RBX: ffff88001811f500 RCX: 0000000000000000
[  417.344943] RDX: 0000000000000000 RSI: 0000000000000100 RDI: 0000000000000282
[  417.348639] RBP: ffff88002ce6dda0 R08: 0000000000000100 R09: ffffffff81b3a300
[  417.351813] R10: 0000ffff00066c0a R11: 0000000000000003 R12: ffff88002ae54840
[  417.355522] R13: ffff88002ae54840 R14: ffff880029c29c00 R15: ffff88001811f4b0
[  417.358879] FS:  00007f394dd32720(0000) GS:ffff88002ef00000(0000) knlGS:0000000000000000
[  417.362780] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  417.365651] CR2: 00007fffcb62ddf8 CR3: 000000001825f000 CR4: 00000000000006e0
[  417.368830] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  417.372688] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  417.375876] Process kworker/u:0 (pid: 5, threadinfo ffff88002ce6c000, task ffff88002ce55cc0)
[  417.379863] Stack:
[  417.380891]  0000000000000246 ffff88002ce55cc0 ffff88002ce6dd58 ffff88001815dc00
[  417.384864]  ffff8800185246c0 ffff88001811f618 ffff880029c29d18 ffff88001811f380
[  417.388935]  ffff88002ce6dd50 ffffffff814757e4 ffff88002ce6dda0 ffffffff8106ac56
[  417.392907] Call Trace:
[  417.394580]  [<ffffffff814757e4>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[  417.397739]  [<ffffffff8106ac56>] ? __queue_work+0x256/0x265
[  417.400607]  [<ffffffffa00bd91f>] cachefiles_lookup_object+0x78/0xd4 [cachefiles]
[  417.403898]  [<ffffffffa00a9977>] ? fscache_object_work_func+0x0/0x669 [fscache]
[  417.407659]  [<ffffffffa00a95da>] fscache_lookup_object+0x131/0x16d [fscache]
[  417.410832]  [<ffffffffa00a9b33>] fscache_object_work_func+0x1bc/0x669 [fscache]
[  417.414598]  [<ffffffffa00a9977>] ? fscache_object_work_func+0x0/0x669 [fscache]
[  417.417956]  [<ffffffff8106afb6>] process_one_work+0x186/0x298
[  417.420876]  [<ffffffff8106b343>] worker_thread+0xda/0x15d
[  417.423693]  [<ffffffff8106b269>] ? worker_thread+0x0/0x15d
[  417.426546]  [<ffffffff8106b269>] ? worker_thread+0x0/0x15d
[  417.428877]  [<ffffffff8106ebaf>] kthread+0x84/0x8c
[  417.431712]  [<ffffffff8100a9e4>] kernel_thread_helper+0x4/0x10
[  417.434615]  [<ffffffff8106eb2b>] ? kthread+0x0/0x8c
[  417.436809]  [<ffffffff8100a9e0>] ? kernel_thread_helper+0x0/0x10
[  417.439746] Code: 05 77 2a 48 c7 c7 ce 1c 0c a0 31 c0 e8 c6 db 3a e1 48 c7 c7 77 1f 0c a0 31 c0 e8 b8 db 3a e1 48 8b 75 98 48 89 df e8 ae 23 00 00 <0f> 0b 48 8b 55 98 f0 ff 82 20 01 00 00 48 8b 7d 90 e8 86 f5 ff 
[  417.453802] RIP  [<ffffffffa00bebe4>] cachefiles_walk_to_object+0x436/0x745 [cachefiles]
[  417.457781]  RSP <ffff88002ce6dd00>
[  417.459638] ---[ end trace 1d481c9af1804caa ]---

Reported-and-Tested-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/file.c    |    4 +++-
 fs/cifs/fscache.c |   23 +++++++++++++++++++----
 fs/cifs/fscache.h |    4 ++--
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index bb71471..e960072 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -415,7 +415,9 @@ int cifs_open(struct inode *inode, struct file *file)
 		goto out;
 	}
 
-	cifs_fscache_set_inode_cookie(inode, file);
+	rc = cifs_fscache_set_inode_cookie(inode, file);
+	if (rc)
+		goto out;
 
 	if ((oplock & CIFS_CREATE_ACTION) && !posix_open_ok && tcon->unix_ext) {
 		/* time to set mode which we can not set earlier due to
diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index d368a47..8a1070f 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -87,24 +87,39 @@ void cifs_fscache_release_inode_cookie(struct inode *inode)
 	}
 }
 
-static void cifs_fscache_disable_inode_cookie(struct inode *inode)
+static int cifs_fscache_disable_inode_cookie(struct inode *inode)
 {
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
+	int ret = 0;
 
 	if (cifsi->fscache) {
 		cFYI(1, "CIFS disabling inode cookie (0x%p)",
 				cifsi->fscache);
+		/* invalidate any mapped pages that were read in before */
+		if (inode->i_mapping && inode->i_mapping->nrpages) {
+			ret = invalidate_inode_pages2(inode->i_mapping);
+			if (ret) {
+				cERROR(1, "CIFS couldn't invalidate inode %p",
+						inode);
+				return ret;
+			}
+		}
+
 		fscache_relinquish_cookie(cifsi->fscache, 1);
 		cifsi->fscache = NULL;
 	}
+
+	return ret;
 }
 
-void cifs_fscache_set_inode_cookie(struct inode *inode, struct file *filp)
+int cifs_fscache_set_inode_cookie(struct inode *inode, struct file *filp)
 {
 	if ((filp->f_flags & O_ACCMODE) != O_RDONLY)
-		cifs_fscache_disable_inode_cookie(inode);
-	else
+		return cifs_fscache_disable_inode_cookie(inode);
+	else {
 		cifs_fscache_enable_inode_cookie(inode);
+		return 0;
+	}
 }
 
 void cifs_fscache_reset_inode_cookie(struct inode *inode)
diff --git a/fs/cifs/fscache.h b/fs/cifs/fscache.h
index 6353932..8f8f9f4 100644
--- a/fs/cifs/fscache.h
+++ b/fs/cifs/fscache.h
@@ -44,7 +44,7 @@ extern void cifs_fscache_get_super_cookie(struct cifs_tcon *);
 extern void cifs_fscache_release_super_cookie(struct cifs_tcon *);
 
 extern void cifs_fscache_release_inode_cookie(struct inode *);
-extern void cifs_fscache_set_inode_cookie(struct inode *, struct file *);
+extern int cifs_fscache_set_inode_cookie(struct inode *, struct file *);
 extern void cifs_fscache_reset_inode_cookie(struct inode *);
 
 extern void __cifs_fscache_invalidate_page(struct page *, struct inode *);
@@ -104,7 +104,7 @@ static inline void
 cifs_fscache_release_super_cookie(struct cifs_tcon *tcon) {}
 
 static inline void cifs_fscache_release_inode_cookie(struct inode *inode) {}
-static inline void cifs_fscache_set_inode_cookie(struct inode *inode,
+static inline int cifs_fscache_set_inode_cookie(struct inode *inode,
 						 struct file *filp) {}
 static inline void cifs_fscache_reset_inode_cookie(struct inode *inode) {}
 static inline int cifs_fscache_release_page(struct page *page, gfp_t gfp)
