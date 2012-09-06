From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: remove support for CIFS_IOC_CHECKUMOUNT ioctl
Date: Thu, 6 Sep 2012 16:21:24 +0400
Message-ID: <CAKywueRi=G7S5E=GD+Hr0rdr9nmNc8pbUMa719xVNPudFdArVA@mail.gmail.com>
References: <1346853509-13438-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346853509-13438-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/9/5 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> ...as promised for 3.7.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/ioctl.c | 19 -------------------
>  1 file changed, 19 deletions(-)
>
> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> index 5b3481b..fd5009d 100644
> --- a/fs/cifs/ioctl.c
> +++ b/fs/cifs/ioctl.c
> @@ -28,8 +28,6 @@
>  #include "cifs_debug.h"
>  #include "cifsfs.h"
>
> -#define CIFS_IOC_CHECKUMOUNT _IO(0xCF, 2)
> -
>  long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
>  {
>         struct inode *inode = filep->f_dentry->d_inode;
> @@ -51,23 +49,6 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
>         cifs_sb = CIFS_SB(inode->i_sb);
>
>         switch (command) {
> -               static bool warned = false;
> -               case CIFS_IOC_CHECKUMOUNT:
> -                       if (!warned) {
> -                               warned = true;
> -                               cERROR(1, "the CIFS_IOC_CHECKMOUNT ioctl will "
> -                                         "be deprecated in 3.7. Please "
> -                                         "migrate away from the use of "
> -                                         "umount.cifs");
> -                       }
> -                       cFYI(1, "User unmount attempted");
> -                       if (cifs_sb->mnt_uid == current_uid())
> -                               rc = 0;
> -                       else {
> -                               rc = -EACCES;
> -                               cFYI(1, "uids do not match");
> -                       }
> -                       break;
>  #ifdef CONFIG_CIFS_POSIX
>                 case FS_IOC_GETFLAGS:
>                         if (pSMBFile == NULL)
> --
> 1.7.11.4
>

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

-- 
Best regards,
Pavel Shilovsky.
