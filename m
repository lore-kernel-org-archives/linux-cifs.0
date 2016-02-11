From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix erroneous return value
Date: Wed, 10 Feb 2016 18:25:13 -0600
Message-ID: <CAH2r5msGBsAX49vtd-3H=NKH5-WGU8=b=m1oodiZ98GMwxFocQ@mail.gmail.com>
References: <1455126621-28052-1-git-send-email-a.s.protopopov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Anton Protopopov <a.s.protopopov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455126621-28052-1-git-send-email-a.s.protopopov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into cifs-2.6.git and added cc: stable

On Wed, Feb 10, 2016 at 11:50 AM, Anton Protopopov
<a.s.protopopov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> The setup_ntlmv2_rsp() function may return positive value ENOMEM instead
> of -ENOMEM in case of kmalloc failure.
>
> Signed-off-by: Anton Protopopov <a.s.protopopov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index afa09fc..e682b36 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -714,7 +714,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
>
>         ses->auth_key.response = kmalloc(baselen + tilen, GFP_KERNEL);
>         if (!ses->auth_key.response) {
> -               rc = ENOMEM;
> +               rc = -ENOMEM;
>                 ses->auth_key.len = 0;
>                 goto setup_ntlmv2_rsp_ret;
>         }
> --
> 2.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
