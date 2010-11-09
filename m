From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: fix a memleak in cifs_setattr_nounix()
Date: Tue,  9 Nov 2010 12:27:41 +0530
Message-ID: <1289285861-12033-1-git-send-email-sjayaraman@suse.de>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Andrew Hendry reported a kmemleak warning in 2.6.37-rc1 while editing a
text file with gedit over cifs.

unreferenced object 0xffff88022ee08b40 (size 32):
  comm "gedit", pid 2524, jiffies 4300160388 (age 2633.655s)
  hex dump (first 32 bytes):
    5c 2e 67 6f 75 74 70 75 74 73 74 72 65 61 6d 2d  \.goutputstream-
    35 42 41 53 4c 56 00 de 09 00 00 00 2c 26 78 ee  5BASLV......,&x.
  backtrace:
    [<ffffffff81504a4d>] kmemleak_alloc+0x2d/0x60
    [<ffffffff81136e13>] __kmalloc+0xe3/0x1d0
    [<ffffffffa0313db0>] build_path_from_dentry+0xf0/0x230 [cifs]
    [<ffffffffa031ae1e>] cifs_setattr+0x9e/0x770 [cifs]
    [<ffffffff8115fe90>] notify_change+0x170/0x2e0
    [<ffffffff81145ceb>] sys_fchmod+0x10b/0x140
    [<ffffffff8100c172>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

The commit 1025774c that removed inode_setattr() seems to have introduced this
memleak by returning early without freeing 'full_path'.

Reported-by: Andrew Hendry <andrew.hendry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/inode.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 39869c3..ef3a55b 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2177,7 +2177,6 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 
 	setattr_copy(inode, attrs);
 	mark_inode_dirty(inode);
-	return 0;
 
 cifs_setattr_exit:
 	kfree(full_path);
