From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Ratelimit kernel log messages
Date: Sun, 29 Nov 2015 22:07:01 -0600
Message-ID: <CAH2r5muynQt7iCq=mVpjWq1EWq-z_pdKjiZntEWEXaxLsR6JjQ@mail.gmail.com>
References: <7094bd3a2ef3c030463aa04fbce8369bfb33be9c.1446897962.git.jamie.bainbridge@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jamie Bainbridge <jamie.bainbridge-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7094bd3a2ef3c030463aa04fbce8369bfb33be9c.1446897962.git.jamie.bainbridge-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

repushed to cifs-2.6.git (after finding out that the kbuild test robot
warning messages for ARCH=mn10300 is likely not a real problem.

On Sat, Nov 7, 2015 at 6:13 AM, Jamie Bainbridge
<jamie.bainbridge-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Under some conditions, CIFS can repeatedly call the cifs_dbg() logging
> wrapper. If done rapidly enough, the console framebuffer can softlockup
> or "rcu_sched self-detected stall". Apply the built-in log ratelimiters
> to prevent such hangs.
>
> Signed-off-by: Jamie Bainbridge <jamie.bainbridge-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifs_debug.c | 2 +-
>  fs/cifs/cifs_debug.h | 9 ++++-----
>  2 files changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 7febcf2475c5ab675c04dfd2fddaa3ed574522a0..50b268483302922ee63d205a2fa560ec27676eed 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -50,7 +50,7 @@ void cifs_vfs_err(const char *fmt, ...)
>         vaf.fmt = fmt;
>         vaf.va = &args;
>
> -       pr_err("CIFS VFS: %pV", &vaf);
> +       pr_err_ratelimited("CIFS VFS: %pV", &vaf);
>
>         va_end(args);
>  }
> diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
> index f40fbaca1b2a2c1d7457d71bd1a5e7dd4b477859..66cf0f9fff8984cb12eed1c89d91bc9c6ccc6a9d 100644
> --- a/fs/cifs/cifs_debug.h
> +++ b/fs/cifs/cifs_debug.h
> @@ -51,14 +51,13 @@ __printf(1, 2) void cifs_vfs_err(const char *fmt, ...);
>  /* information message: e.g., configuration, major event */
>  #define cifs_dbg(type, fmt, ...)                                       \
>  do {                                                                   \
> -       if (type == FYI) {                                              \
> -               if (cifsFYI & CIFS_INFO) {                              \
> -                       pr_debug("%s: " fmt, __FILE__, ##__VA_ARGS__);  \
> -               }                                                       \
> +       if (type == FYI && cifsFYI & CIFS_INFO) {                       \
> +               pr_debug_ratelimited("%s: "                             \
> +                           fmt, __FILE__, ##__VA_ARGS__);              \
>         } else if (type == VFS) {                                       \
>                 cifs_vfs_err(fmt, ##__VA_ARGS__);                       \
>         } else if (type == NOISY && type != 0) {                        \
> -               pr_debug(fmt, ##__VA_ARGS__);                           \
> +               pr_debug_ratelimited(fmt, ##__VA_ARGS__);               \
>         }                                                               \
>  } while (0)
>
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
