From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix regression during share-level security mounts
Date: Tue, 18 Jan 2011 22:56:35 +0300
Message-ID: <AANLkTi=JUCKsWAbRjEdbvc1xjt9kgwPLamz8yrS5b8=F@mail.gmail.com>
References: <1294327443-24293-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294327443-24293-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/1/6  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> NTLM response length was changed during to 16 bytes instead of 24 byt=
es
> that get sent in Tree Connection Request during share-level security
> share mounts. =A0Revert it back to 24 bytes.
>
>
> Reported-by: Grzegorz Ozanski <grzegorz.ozanski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 =A04 ++--
> =A01 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 41f002f..cdba196 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2966,7 +2966,7 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *=
ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bcc_ptr++; =A0 =A0 =A0 =A0 =A0 =A0 =A0=
/* skip password */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* already aligned so no need to do it=
 below */
> =A0 =A0 =A0 =A0} else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->PasswordLength =3D cpu_to_le16(CI=
=46S_SESS_KEY_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->PasswordLength =3D cpu_to_le16(CI=
=46S_AUTH_RESP_SIZE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB FIXME add code to fail this if N=
TLMv2 or Kerberos
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 specified as required (when that =
support is added to
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 the vfs in the future) as only NT=
LM or the much
> @@ -2984,7 +2984,7 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *=
ses,
> =A0#endif /* CIFS_WEAK_PW_HASH */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SMBNTencrypt(tcon->password, ses->serv=
er->cryptkey, bcc_ptr);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D CIFS_SESS_KEY_SIZE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D CIFS_AUTH_RESP_SIZE;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ses->capabilities & CAP_UNICODE) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* must align unicode =
strings */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*bcc_ptr =3D 0; /* nul=
l byte password */
> --
> 1.6.0.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Looks good to me. Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
