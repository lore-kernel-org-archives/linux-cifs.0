From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 13/19] cifs: add new fields to smb_vol to track the
 requested security flavor
Date: Tue, 28 May 2013 09:49:33 +0400
Message-ID: <CAKywueQ2bd9ZRSejYsMkRiWpVbyh6W5NWOrmKHzAswpQAJJbrw@mail.gmail.com>
References: <1369321563-16893-1-git-send-email-jlayton@redhat.com>
	<1369321563-16893-14-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369321563-16893-14-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/5/23 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> We have this to some degree already in secFlgs, but those get "or'ed" so
> there's no way to know what the last option requested was. Add new fields
> that will eventually supercede the secFlgs field in the cifs_ses.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |  2 ++
>  fs/cifs/connect.c  | 25 +++++++++++++++++++++++++
>  2 files changed, 27 insertions(+)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index c2ef6c1..9f88a35 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -402,6 +402,8 @@ struct smb_vol {
>         umode_t file_mode;
>         umode_t dir_mode;
>         unsigned secFlg;
> +       enum securityEnum sectype; /* sectype requested via mnt opts */
> +       bool sign; /* was signing requested via mnt opts? */
>         bool retry:1;
>         bool intr:1;
>         bool setuids:1;
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index b367a5a..7b71961 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1024,11 +1024,21 @@ static int cifs_parse_security_flavors(char *value,
>
>         substring_t args[MAX_OPT_ARGS];
>
> +       /*
> +        * With mount options, the last one should win. Reset any existing
> +        * settings back to default.
> +        */
> +       vol->sectype = Unspecified;
> +       vol->sign = false;
> +
>         switch (match_token(value, cifs_secflavor_tokens, args)) {
>         case Opt_sec_krb5:
> +               vol->sectype = Kerberos;
>                 vol->secFlg |= CIFSSEC_MAY_KRB5 | CIFSSEC_MAY_SIGN;
>                 break;
>         case Opt_sec_krb5i:
> +               vol->sectype = Kerberos;
> +               vol->sign = true;
>                 vol->secFlg |= CIFSSEC_MAY_KRB5 | CIFSSEC_MUST_SIGN;
>                 break;
>         case Opt_sec_krb5p:
> @@ -1036,26 +1046,36 @@ static int cifs_parse_security_flavors(char *value,
>                 cifs_dbg(VFS, "sec=krb5p is not supported!\n");
>                 return 1;
>         case Opt_sec_ntlmssp:
> +               vol->sectype = RawNTLMSSP;
>                 vol->secFlg |= CIFSSEC_MAY_NTLMSSP;
>                 break;
>         case Opt_sec_ntlmsspi:
> +               vol->sectype = RawNTLMSSP;
> +               vol->sign = true;
>                 vol->secFlg |= CIFSSEC_MAY_NTLMSSP | CIFSSEC_MUST_SIGN;
>                 break;
>         case Opt_ntlm:
>                 /* ntlm is default so can be turned off too */
> +               vol->sectype = NTLM;
>                 vol->secFlg |= CIFSSEC_MAY_NTLM;
>                 break;
>         case Opt_sec_ntlmi:
> +               vol->sectype = NTLM;
> +               vol->sign = true;
>                 vol->secFlg |= CIFSSEC_MAY_NTLM | CIFSSEC_MUST_SIGN;
>                 break;
>         case Opt_sec_ntlmv2:
> +               vol->sectype = NTLMv2;
>                 vol->secFlg |= CIFSSEC_MAY_NTLMV2;
>                 break;
>         case Opt_sec_ntlmv2i:
> +               vol->sectype = NTLMv2;
> +               vol->sign = true;
>                 vol->secFlg |= CIFSSEC_MAY_NTLMV2 | CIFSSEC_MUST_SIGN;
>                 break;
>  #ifdef CONFIG_CIFS_WEAK_PW_HASH
>         case Opt_sec_lanman:
> +               vol->sectype = LANMAN;
>                 vol->secFlg |= CIFSSEC_MAY_LANMAN;
>                 break;
>  #endif
> @@ -1425,6 +1445,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>                         break;
>                 case Opt_sign:
>                         vol->secFlg |= CIFSSEC_MUST_SIGN;
> +                       vol->sign = true;
>                         break;
>                 case Opt_noac:
>                         printk(KERN_WARNING "CIFS: Mount option noac not "
> @@ -3880,6 +3901,10 @@ cifs_set_vol_auth(struct smb_vol *vol, struct cifs_ses *ses)
>         case LANMAN:
>                 vol->secFlg = CIFSSEC_MUST_LANMAN;
>                 break;
> +       default:
> +               /* should never happen */
> +               vol->secFlg = 0;
> +               break;
>         }
>
>         return cifs_set_cifscreds(vol, ses);
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
