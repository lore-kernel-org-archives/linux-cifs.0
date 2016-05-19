From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: linux-next: manual merge of the vfs tree with Linus' tree
Date: Thu, 19 May 2016 11:17:02 +1000
Message-ID: <20160519111702.752921f8@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in:

  fs/cifs/cifsfs.c

between commit:

  a9ae008f407b ("cifs: Switch to generic xattr handlers")

from Linus' tree and commit:

  51085a1f913a ("cifs: use C99 syntax for inode_operations initializer")

from the vfs tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

Al: the c99 fixup is not really necessary as the line is commented out
and you didn't fix the one in the line above ... a better fix might be
to delete both those lines?
-- 
Cheers,
Stephen Rothwell

diff --cc fs/cifs/cifsfs.c
index 67f622df0858,586d4eadd49e..000000000000
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@@ -917,11 -919,13 +917,11 @@@ const struct inode_operations cifs_syml
  	.permission = cifs_permission,
  	/* BB add the following two eventually */
  	/* revalidate: cifs_revalidate,
- 	   setattr:    cifs_notify_change, *//* BB do we need notify change */
+ 	.setattr = cifs_notify_change, *//* BB do we need notify change */
 -#ifdef CONFIG_CIFS_XATTR
 -	.setxattr = cifs_setxattr,
 -	.getxattr = cifs_getxattr,
 +	.setxattr = generic_setxattr,
 +	.getxattr = generic_getxattr,
  	.listxattr = cifs_listxattr,
 -	.removexattr = cifs_removexattr,
 -#endif
 +	.removexattr = generic_removexattr,
  };
  
  static int cifs_clone_file_range(struct file *src_file, loff_t off,
