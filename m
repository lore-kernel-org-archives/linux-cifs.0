From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/4] FS: cifs, remove unneeded NULL tests
Date: Wed, 27 Oct 2010 12:14:32 -0400
Message-ID: <20101027161431.GA20363@infradead.org>
References: <1288180220-19869-1-git-send-email-jslaby@suse.cz>
 <20101027121338.2984b9d8@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jirislaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20101027121338.2984b9d8-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Oct 27, 2010 at 12:13:38PM -0400, Jeff Layton wrote:
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index 45af003..db7eaf7 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -1031,7 +1031,7 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
> >  	cifs_stats_bytes_written(pTcon, total_written);
> >  
> >  	/* since the write may have blocked check these pointers again */
> > -	if ((file->f_path.dentry) && (file->f_path.dentry->d_inode)) {
> > +	if (file->f_path.dentry->d_inode) {
> 
> 		^^^^^^
> 	This check is bogus too. An open filp on a negative dentry
> 	isn't possible, right?

Indeed, it's impossible.
