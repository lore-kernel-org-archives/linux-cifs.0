From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cif: fix dead code
Date: Wed, 16 Apr 2014 23:10:03 -0500
Message-ID: <CAH2r5mt2CZi039PMfb52-3yEcny9ZpCVZXaYxWAg=nbNgywL9g@mail.gmail.com>
References: <1397549210-29445-1-git-send-email-michael.opdenacker@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Michael Opdenacker <michael.opdenacker-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1397549210-29445-1-git-send-email-michael.opdenacker-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

On Tue, Apr 15, 2014 at 3:06 AM, Michael Opdenacker
<michael.opdenacker-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org> wrote:
> This issue was found by Coverity (CID 1202536)
>
> This proposes a fix for a statement that creates dead code.
> The "rc < 0" statement is within code that is run
> with "rc > 0".
>
> It seems like "err < 0" was meant to be used here.
> This way, the error code is returned by the function.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
> ---
>  fs/cifs/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 8add25538a3b..b6e78632fa97 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2599,7 +2599,7 @@ cifs_writev(struct kiocb *iocb, const struct iovec *iov,
>                         ssize_t err;
>
>                         err = generic_write_sync(file, iocb->ki_pos - rc, rc);
> -                       if (rc < 0)
> +                       if (err < 0)
>                                 rc = err;
>                 }
>         } else {
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
