From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: simplify SMB header check routine
Date: Thu, 30 Dec 2010 17:05:30 +0300
Message-ID: <AANLkTi=0iPxOeJgq2TsGHoo=Txw6wX1SOtfExj9dTTkB@mail.gmail.com>
References: <1293716194-23140-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293716194-23140-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/30 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/misc.c | =A0 46 ++++++++++++++++++++++++------------------=
----
> =A01 files changed, 24 insertions(+), 22 deletions(-)
>
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index b3df037..c1f2a51 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -381,29 +381,31 @@ header_assemble(struct smb_hdr *buffer, char sm=
b_command /* command */ ,
> =A0}
>
> =A0static int
> -checkSMBhdr(struct smb_hdr *smb, __u16 mid)
> +check_smb_hdr(struct smb_hdr *smb, __u16 mid)
> =A0{
> - =A0 =A0 =A0 /* Make sure that this really is an SMB, that it is a r=
esponse,
> - =A0 =A0 =A0 =A0 =A0and that the message ids match */
> - =A0 =A0 =A0 if ((*(__le32 *) smb->Protocol =3D=3D cpu_to_le32(0x424=
d53ff)) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 (mid =3D=3D smb->Mid)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (smb->Flags & SMBFLG_RESPONSE)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* only one valid case where server sen=
ds us request */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (smb->Command =3D=3D=
 SMB_COM_LOCKING_ANDX)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(=
1, "Received Request not response");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 } else { /* bad signature or mid */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (*(__le32 *) smb->Protocol !=3D cpu_=
to_le32(0x424d53ff))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Bad protocol=
 string signature header %x",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(unsig=
ned int *) smb->Protocol);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid !=3D smb->Mid)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Mids do not =
match");
> + =A0 =A0 =A0 /* does it have the right SMB "signature" ? */
> + =A0 =A0 =A0 if (*(__le32 *) smb->Protocol !=3D cpu_to_le32(0x424d53=
ff)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Bad protocol string signatur=
e header 0x%x",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(unsigned int *)smb->P=
rotocol);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Make sure that message ids match */
> + =A0 =A0 =A0 if (mid !=3D smb->Mid) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Mids do not match. received=3D=
%u expected=3D%u",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb->Mid, mid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 cERROR(1, "bad smb detected. The Mid=3D%d", smb->Mid);
> +
> + =A0 =A0 =A0 /* if it's a response then accept */
> + =A0 =A0 =A0 if (smb->Flags & SMBFLG_RESPONSE)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> + =A0 =A0 =A0 /* only one valid case where server sends us request */
> + =A0 =A0 =A0 if (smb->Command =3D=3D SMB_COM_LOCKING_ANDX)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> + =A0 =A0 =A0 cERROR(1, "Server sent request, not response. mid=3D%u"=
, smb->Mid);
> =A0 =A0 =A0 =A0return 1;
> =A0}
>
> @@ -448,7 +450,7 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsigned=
 int length)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 if (checkSMBhdr(smb, mid))
> + =A0 =A0 =A0 if (check_smb_hdr(smb, mid))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
> =A0 =A0 =A0 =A0clc_len =3D smbCalcSize_LE(smb);
>
> --
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Good cleanup. Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
