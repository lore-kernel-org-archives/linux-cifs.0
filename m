From: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Subject: Re: ceph, cifs, nfs, fuse: boolean and / or confusion
Date: Tue, 13 Dec 2011 12:25:19 +0100
Message-ID: <87obvc3e8w.fsf@tucsk.pomaz.szeredi.hu>
References: <4EE688FC.8090606@gmail.com>
	<20111212152856.871a8301.akpm@linux-foundation.org>
	<1323733153.13849.17.camel@lade.trondhjem.org>
	<1323733511.13849.19.camel@lade.trondhjem.org>
	<20111212155423.24543d6a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.1112122123040.17811@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Trond Myklebust <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
	roel <roel.kluin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1112122123040.17811-vIokxiIdD2AQNTJnQDzGJqxOck334EZe@public.gmane.org> (Sage
	Weil's message of "Mon, 12 Dec 2011 21:29:51 -0800 (PST)")
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org> writes:

> On Mon, 12 Dec 2011, Andrew Morton wrote:
>> 
>> So please prepare and send the NFS patch, with a Reported-by:roel?

Fuse patch follows.  Also pushed to git tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

Thanks Roel.

Miklos

----
>From b48c6af2086ab2ba8a9c9b6ce9ecb34592ce500c Mon Sep 17 00:00:00 2001
From: Roel Kluin <roel.kluin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Tue, 13 Dec 2011 10:37:00 +0100
Subject: [PATCH] fuse: fix llseek bug

The test in fuse_file_llseek() "not SEEK_CUR or not SEEK_SET" always evaluates
to true.

This was introduced in 3.1 by commit 06222e49 (fs: handle SEEK_HOLE/SEEK_DATA
properly in all fs's that define their own llseek) and changed the behavior of
SEEK_CUR and SEEK_SET to always retrieve the file attributes.  This is a
performance regression.

Fix the test so that it makes sense.

Signed-off-by: Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>
CC: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: Josef Bacik <josef-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
---
 fs/fuse/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 594f07a..19029e9 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1556,7 +1556,7 @@ static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
 	struct inode *inode = file->f_path.dentry->d_inode;
 
 	mutex_lock(&inode->i_mutex);
-	if (origin != SEEK_CUR || origin != SEEK_SET) {
+	if (origin != SEEK_CUR && origin != SEEK_SET) {
 		retval = fuse_update_attributes(inode, NULL, file, NULL);
 		if (retval)
 			goto exit;
-- 
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
