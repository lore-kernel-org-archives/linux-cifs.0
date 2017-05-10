From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: silence lockdep splat in cifs_relock_file()
Date: Tue, 9 May 2017 18:34:01 -0700
Message-ID: <CAKywueRqQyaN4AQCDx_F7qVAW3-Gkwar1Q0KjOkcAz+ZcDovUw@mail.gmail.com>
References: <1493824641-9455-1-git-send-email-rabin.vincent@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
To: Rabin Vincent <rabin.vincent-VrBV9hrLPhE@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493824641-9455-1-git-send-email-rabin.vincent-VrBV9hrLPhE@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-05-03 8:17 GMT-07:00 Rabin Vincent <rabin.vincent-VrBV9hrLPhE@public.gmane.org>:
> From: Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
>
> cifs_relock_file() can perform a down_write() on the inode's lock_sem even
> though it was already performed in cifs_strict_readv().  Lockdep complains
> about this.  AFAICS, there is no problem here, and lockdep just needs to be
> told that this nesting is OK.
>
>  =============================================
>  [ INFO: possible recursive locking detected ]
>  4.11.0+ #20 Not tainted
>  ---------------------------------------------
>  cat/701 is trying to acquire lock:
>   (&cifsi->lock_sem){++++.+}, at: cifs_reopen_file+0x7a7/0xc00
>
>  but task is already holding lock:
>   (&cifsi->lock_sem){++++.+}, at: cifs_strict_readv+0x177/0x310
>
>  other info that might help us debug this:
>   Possible unsafe locking scenario:
>
>         CPU0
>         ----
>    lock(&cifsi->lock_sem);
>    lock(&cifsi->lock_sem);
>
>   *** DEADLOCK ***
>
>   May be due to missing lock nesting notation
>
>  1 lock held by cat/701:
>   #0:  (&cifsi->lock_sem){++++.+}, at: cifs_strict_readv+0x177/0x310
>
>  stack backtrace:
>  CPU: 0 PID: 701 Comm: cat Not tainted 4.11.0+ #20
>  Call Trace:
>   dump_stack+0x85/0xc2
>   __lock_acquire+0x17dd/0x2260
>   ? trace_hardirqs_on_thunk+0x1a/0x1c
>   ? preempt_schedule_irq+0x6b/0x80
>   lock_acquire+0xcc/0x260
>   ? lock_acquire+0xcc/0x260
>   ? cifs_reopen_file+0x7a7/0xc00
>   down_read+0x2d/0x70
>   ? cifs_reopen_file+0x7a7/0xc00
>   cifs_reopen_file+0x7a7/0xc00
>   ? printk+0x43/0x4b
>   cifs_readpage_worker+0x327/0x8a0
>   cifs_readpage+0x8c/0x2a0
>   generic_file_read_iter+0x692/0xd00
>   cifs_strict_readv+0x29f/0x310
>   generic_file_splice_read+0x11c/0x1c0
>   do_splice_to+0xa5/0xc0
>   splice_direct_to_actor+0xfa/0x350
>   ? generic_pipe_buf_nosteal+0x10/0x10
>   do_splice_direct+0xb5/0xe0
>   do_sendfile+0x278/0x3a0
>   SyS_sendfile64+0xc4/0xe0
>   entry_SYSCALL_64_fastpath+0x1f/0xbe
>
> Signed-off-by: Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
> ---
>  fs/cifs/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 21d4045..64b590b 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -582,7 +582,7 @@ cifs_relock_file(struct cifsFileInfo *cfile)
>         struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
>         int rc = 0;
>
> -       down_read(&cinode->lock_sem);
> +       down_read_nested(&cinode->lock_sem, SINGLE_DEPTH_NESTING);
>         if (cinode->can_cache_brlcks) {
>                 /* can cache locks - no need to relock */
>                 up_read(&cinode->lock_sem);
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Acked-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

Best regards,
Pavel Shilovsky
