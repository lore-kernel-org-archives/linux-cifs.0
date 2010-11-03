From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH v2 1/1] FS: cifs, remove unneeded NULL tests
Date: Wed, 3 Nov 2010 10:00:12 +0000
Message-ID: <20101103100012.GA19804@ZenIV.linux.org.uk>
References: <1288624135-24170-1-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jirislaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
To: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1288624135-24170-1-git-send-email-jslaby-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Nov 01, 2010 at 04:08:55PM +0100, Jiri Slaby wrote:
> Stanse found that pSMBFile in cifs_ioctl and file->f_path.dentry in
> cifs_user_write are dereferenced prior their test to NULL.

file->f_path.dentry is never NULL for an opened file, neither is
file->f_path.dentry->d_inode (which cannot change for the entire
lifetime of dentry, BTW).  IOW,

> -	/* since the write may have blocked check these pointers again */
> -	if ((file->f_path.dentry) && (file->f_path.dentry->d_inode)) {
> -		struct inode *inode = file->f_path.dentry->d_inode;

in there had always been junk.  So yes, losing these tests is the right
thing to do.
