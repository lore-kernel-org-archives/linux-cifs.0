From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: don't start signing too early
Date: Mon, 11 Jul 2011 10:29:51 -0400
Message-ID: <20110711102951.709ec595@tlielax.poochiereds.net>
References: <1310393813-12443-1-git-send-email-jlayton@redhat.com>
	<CADT32eJzF_imsZ37enNC12xkwCyAgWyYXPYrquyBCygzb82AHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eJzF_imsZ37enNC12xkwCyAgWyYXPYrquyBCygzb82AHg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 11 Jul 2011 09:28:24 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Jul 11, 2011 at 9:16 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > Sniffing traffic on the wire shows that windows clients send a zero=
ed
> > out signature field in a NEGOTIATE request, and send "BSRSPYL" in t=
he
> > signature field during SESSION_SETUP. Make the cifs client behave t=
he
> > same way.
> >
> > It doesn't seem to make much difference in any server that I've tes=
ted
> > against, but it's probably best to follow windows behavior as close=
ly as
> > possible here.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/cifsencrypt.c | =C2=A0 16 ++++++++++++++--
> > =C2=A01 files changed, 14 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> > index 5a0ee7f..45ae18e 100644
> > --- a/fs/cifs/cifsencrypt.c
> > +++ b/fs/cifs/cifsencrypt.c
> > @@ -77,9 +77,15 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, stru=
ct TCP_Server_Info *server,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((cifs_pdu =3D=3D NULL) || (server =3D=
=3D NULL))
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINV=
AL;
> >
> > - =C2=A0 =C2=A0 =C2=A0 if ((cifs_pdu->Flags2 & SMBFLG2_SECURITY_SIG=
NATURE) =3D=3D 0)
> > + =C2=A0 =C2=A0 =C2=A0 if (!(cifs_pdu->Flags2 & SMBFLG2_SECURITY_SI=
GNATURE) ||
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 server->tcpStatus =3D=3D CifsN=
eedNegotiate)
>=20
> Jeff, why do we need to set the tcpStatus here?  Not sure what would =
be
> a value of tcpStatus at this point.
>=20

Uhh...that's a check to see if it's in CifsNeedNegotiate.

If it is, then we don't want to do anything -- just leave it zeroed out=
=2E

> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> >
> > + =C2=A0 =C2=A0 =C2=A0 if (!server->session_estab) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strncpy(cifs_pdu=
->Signature.SecuritySignature, "BSRSPYL", 8);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_pdu->Signature.Sequence.SequenceNum=
ber =3D
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0cpu_to_le32(server->sequence_number);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_pdu->Signature.Sequence.Reserved =3D=
 0;
> > @@ -154,9 +160,15 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec=
, struct TCP_Server_Info *server,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((cifs_pdu =3D=3D NULL) || (server =3D=
=3D NULL))
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINV=
AL;
> >
> > - =C2=A0 =C2=A0 =C2=A0 if ((cifs_pdu->Flags2 & SMBFLG2_SECURITY_SIG=
NATURE) =3D=3D 0)
> > + =C2=A0 =C2=A0 =C2=A0 if (!(cifs_pdu->Flags2 & SMBFLG2_SECURITY_SI=
GNATURE) ||
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 server->tcpStatus =3D=3D CifsN=
eedNegotiate)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> >
> > + =C2=A0 =C2=A0 =C2=A0 if (!server->session_estab) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strncpy(cifs_pdu=
->Signature.SecuritySignature, "BSRSPYL", 8);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_pdu->Signature.Sequence.SequenceNum=
ber =3D
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cpu_to_le32(server->sequence_=
number);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_pdu->Signature.Sequence.Reserved =3D=
 0;
> > --
> > 1.7.6
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
