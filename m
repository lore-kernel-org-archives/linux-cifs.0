From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/1] FS: cifs, remove unneeded NULL tests
Date: Mon, 1 Nov 2010 12:23:15 -0400
Message-ID: <20101101122315.5bcf6bac@tlielax.poochiereds.net>
References: <1288624135-24170-1-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	jirislaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
To: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1288624135-24170-1-git-send-email-jslaby-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon,  1 Nov 2010 16:08:55 +0100
Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org> wrote:

> Stanse found that pSMBFile in cifs_ioctl and file->f_path.dentry in
> cifs_user_write are dereferenced prior their test to NULL.
> 
> The alternative is not to dereference them before the tests. The patch is
> to point out the problem, you have to decide.
> 
> While at it we cache the inode in cifs_user_write to a local variable
> and use all over the function.
> 
> Signed-off-by: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
> Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> ---
>  fs/cifs/file.c  |   25 +++++++++++--------------
>  fs/cifs/ioctl.c |    4 ----
>  2 files changed, 11 insertions(+), 18 deletions(-)
> 

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
