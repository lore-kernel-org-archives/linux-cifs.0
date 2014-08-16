From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: handle lease F_UNLCK requests properly
Date: Fri, 15 Aug 2014 23:05:57 -0500
Message-ID: <CAH2r5ms6arPJ7_-rhknvkSWnO7rNQmxNDGp_3MiPVTCZiZ8E4Q@mail.gmail.com>
References: <1407593804-28053-1-git-send-email-jlayton@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407593804-28053-1-git-send-email-jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into cifs-2.6.git

Did you find this with a test case or by inspection?

On Sat, Aug 9, 2014 at 9:16 AM, Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org> wrote:
> Currently any F_UNLCK request for a lease just gets back -EAGAIN. Allow
> them to go immediately to generic_setlease instead.
>
> Signed-off-by: Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 2c90d07c0b3a..f1a93d2b108d 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -799,8 +799,9 @@ static int cifs_setlease(struct file *file, long arg, struct file_lock **lease)
>         if (!(S_ISREG(inode->i_mode)))
>                 return -EINVAL;
>
> -       /* check if file is oplocked */
> -       if (((arg == F_RDLCK) && CIFS_CACHE_READ(CIFS_I(inode))) ||
> +       /* Check if file is oplocked if this is request for new lease */
> +       if (arg == F_UNLCK ||
> +           ((arg == F_RDLCK) && CIFS_CACHE_READ(CIFS_I(inode))) ||
>             ((arg == F_WRLCK) && CIFS_CACHE_WRITE(CIFS_I(inode))))
>                 return generic_setlease(file, arg, lease);
>         else if (tlink_tcon(cfile->tlink)->local_lease &&
> --
> 1.9.3
>



-- 
Thanks,

Steve
