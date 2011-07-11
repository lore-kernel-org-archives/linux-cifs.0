From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: don't start signing too early
Date: Mon, 11 Jul 2011 09:28:24 -0500
Message-ID: <CADT32eJzF_imsZ37enNC12xkwCyAgWyYXPYrquyBCygzb82AHg@mail.gmail.com>
References: <1310393813-12443-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1310393813-12443-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jul 11, 2011 at 9:16 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Sniffing traffic on the wire shows that windows clients send a zeroed
> out signature field in a NEGOTIATE request, and send "BSRSPYL" in the
> signature field during SESSION_SETUP. Make the cifs client behave the
> same way.
>
> It doesn't seem to make much difference in any server that I've teste=
d
> against, but it's probably best to follow windows behavior as closely=
 as
> possible here.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsencrypt.c | =A0 16 ++++++++++++++--
> =A01 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 5a0ee7f..45ae18e 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -77,9 +77,15 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct=
 TCP_Server_Info *server,
> =A0 =A0 =A0 =A0if ((cifs_pdu =3D=3D NULL) || (server =3D=3D NULL))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>
> - =A0 =A0 =A0 if ((cifs_pdu->Flags2 & SMBFLG2_SECURITY_SIGNATURE) =3D=
=3D 0)
> + =A0 =A0 =A0 if (!(cifs_pdu->Flags2 & SMBFLG2_SECURITY_SIGNATURE) ||
> + =A0 =A0 =A0 =A0 =A0 server->tcpStatus =3D=3D CifsNeedNegotiate)

Jeff, why do we need to set the tcpStatus here?  Not sure what would be
a value of tcpStatus at this point.

> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> + =A0 =A0 =A0 if (!server->session_estab) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 strncpy(cifs_pdu->Signature.SecuritySig=
nature, "BSRSPYL", 8);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0cifs_pdu->Signature.Sequence.SequenceNumber =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le32(server->se=
quence_number);
> =A0 =A0 =A0 =A0cifs_pdu->Signature.Sequence.Reserved =3D 0;
> @@ -154,9 +160,15 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, =
struct TCP_Server_Info *server,
> =A0 =A0 =A0 =A0if ((cifs_pdu =3D=3D NULL) || (server =3D=3D NULL))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>
> - =A0 =A0 =A0 if ((cifs_pdu->Flags2 & SMBFLG2_SECURITY_SIGNATURE) =3D=
=3D 0)
> + =A0 =A0 =A0 if (!(cifs_pdu->Flags2 & SMBFLG2_SECURITY_SIGNATURE) ||
> + =A0 =A0 =A0 =A0 =A0 server->tcpStatus =3D=3D CifsNeedNegotiate)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> + =A0 =A0 =A0 if (!server->session_estab) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 strncpy(cifs_pdu->Signature.SecuritySig=
nature, "BSRSPYL", 8);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0cifs_pdu->Signature.Sequence.SequenceNumber =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to=
_le32(server->sequence_number);
> =A0 =A0 =A0 =A0cifs_pdu->Signature.Sequence.Reserved =3D 0;
> --
> 1.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
