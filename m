From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: linux-next: build failure after merge of the vfs tree
Date: Wed, 4 Aug 2010 11:47:52 +1000
Message-ID: <20100804114752.e15af863.sfr@canb.auug.org.au>
References: <20100719102520.a2d4f103.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100719102520.a2d4f103.sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Al,

On Mon, 19 Jul 2010 10:25:20 +1000 Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> wrote:
>
> After merging the vfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/cifs/cifsfs.c:498: error: unknown field 'clear_inode' specified in initializer
> 
> Caused by commit 139f224817a203ff434eda5e6d3f457bc1579f27 ("cifs: define
> inode-level cache object and register them") from the cifs tree
> interacting with commit a8036d5aec0547a2bd7e3040c69bd172e474d860
> ("convert remaining ->clear_inode() to ->evict_inode()") from the vfs
> tree.
> 
> I added the following merge fix patch (by effectively copy and paste from
> some of the other file system fixups in the vfs commit).  I have no idea
> if this is correct - someone should check.  I can carry this patch as
> necessary.

The cifs tree has been merged by Linus, so this patch can be applied to
the vfs tree, now.

From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Date: Mon, 19 Jul 2010 10:15:47 +1000
Subject: [PATCH] cifs: fix for clear_inode -> evict_inode API change

Signed-off-by: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
---
 fs/cifs/cifsfs.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index ba893b9..2fc5ed1 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -330,8 +330,10 @@ cifs_destroy_inode(struct inode *inode)
 }
 
 static void
-cifs_clear_inode(struct inode *inode)
+cifs_evict_inode(struct inode *inode)
 {
+	truncate_inode_pages(&inode->i_data, 0);
+	end_writeback(inode);
 	cifs_fscache_release_inode_cookie(inode);
 }
 
@@ -495,7 +497,7 @@ static const struct super_operations cifs_super_ops = {
 	.alloc_inode = cifs_alloc_inode,
 	.destroy_inode = cifs_destroy_inode,
 	.drop_inode	= cifs_drop_inode,
-	.clear_inode	= cifs_clear_inode,
+	.evict_inode	= cifs_evict_inode,
 /*	.delete_inode	= cifs_delete_inode,  */  /* Do not need above
 	function unless later we add lazy close of inodes or unless the
 	kernel forgets to call us with the same number of releases (closes)
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
http://www.canb.auug.org.au/~sfr/
