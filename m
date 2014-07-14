From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] fs/cifs: Fix build warnings
Date: Mon, 14 Jul 2014 10:29:35 -0500
Message-ID: <CAH2r5mucVFOYuVxL=qU+T_uMJAdO8dyXvVFJms-reo_H546S2A@mail.gmail.com>
References: <1405334329-25271-1-git-send-email-thierry.reding@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405334329-25271-1-git-send-email-thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I don't see this build warning, and I do see these functions used
outside the CONFIG_CIFS_WEAK_PW_HASH - are you using current
linux-next (or equivalently cifs-2.6.git for-next branch)There were
some updates to fs/cifs late last week.

On Mon, Jul 14, 2014 at 5:38 AM, Thierry Reding
<thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>
> The sess_alloc_buffer(), sess_free_buffer(), sess_establish_session()
> and sess_sendreceive() functions are only used by sess_auth_lanman(),
> therefore should be guarded by the same #ifdef to prevent the following
> compiler warnings:
>
>         fs/cifs/sess.c:542:1: warning: 'sess_alloc_buffer' defined but not used [-Wunused-function]
>          sess_alloc_buffer(struct sess_data *sess_data, int wct)
>          ^
>         fs/cifs/sess.c:580:1: warning: 'sess_free_buffer' defined but not used [-Wunused-function]
>          sess_free_buffer(struct sess_data *sess_data)
>          ^
>         fs/cifs/sess.c:589:1: warning: 'sess_establish_session' defined but not used [-Wunused-function]
>          sess_establish_session(struct sess_data *sess_data)
>          ^
>         fs/cifs/sess.c:621:1: warning: 'sess_sendreceive' defined but not used [-Wunused-function]
>          sess_sendreceive(struct sess_data *sess_data)
>          ^
>
> Signed-off-by: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/sess.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index db6ecdf0974c..5fb7606b81ef 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -538,6 +538,7 @@ struct sess_data {
>         struct kvec iov[3];
>  };
>
> +#ifdef CONFIG_CIFS_WEAK_PW_HASH
>  static int
>  sess_alloc_buffer(struct sess_data *sess_data, int wct)
>  {
> @@ -644,7 +645,6 @@ sess_sendreceive(struct sess_data *sess_data)
>   * in proc/fs/cifs or via mount parm.  Unfortunately this is
>   * needed for old Win (e.g. Win95), some obscure NAS and OS/2
>   */
> -#ifdef CONFIG_CIFS_WEAK_PW_HASH
>  static void
>  sess_auth_lanman(struct sess_data *sess_data)
>  {
> --
> 2.0.1
>



-- 
Thanks,

Steve
