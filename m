From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 11/19] cifs: add new "Unspecified" securityEnum value
Date: Tue, 28 May 2013 09:43:44 +0400
Message-ID: <CAKywueRNZ1FdoVY51wLOQtmejNveUm3Jictb7=PBbBpxwHvpuQ@mail.gmail.com>
References: <1369321563-16893-1-git-send-email-jlayton@redhat.com>
	<1369321563-16893-12-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369321563-16893-12-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/5/23 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Add a new securityEnum value to cover the case where a sec= option
> was not explicitly set.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 874b29b..a858037 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -101,11 +101,11 @@ enum statusEnum {
>  };
>
>  enum securityEnum {
> -       LANMAN = 0,                     /* Legacy LANMAN auth */
> +       Unspecified = 0,        /* not specified */
> +       LANMAN,                 /* Legacy LANMAN auth */
>         NTLM,                   /* Legacy NTLM012 auth with NTLM hash */
>         NTLMv2,                 /* Legacy NTLM auth with NTLMv2 hash */
>         RawNTLMSSP,             /* NTLMSSP without SPNEGO, NTLMv2 hash */
> -/*     NTLMSSP, */ /* can use rawNTLMSSP instead of NTLMSSP via SPNEGO */
>         Kerberos,               /* Kerberos via SPNEGO */
>  };
>
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--
Best regards,
Pavel Shilovsky.
