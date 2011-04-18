From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix extended security auth failure
Date: Mon, 18 Apr 2011 08:24:56 -0400
Message-ID: <20110418082456.36406423@tlielax.poochiereds.net>
References: <1302097566-11576-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110408094028.61a2f507@corrin.poochiereds.net>
	<BANLkTik=Mgbbu7G0U6oPvELEktCFQTArDg@mail.gmail.com>
	<BANLkTikuFDcUHuN9HeY=5KLodWo3_2dDpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikuFDcUHuN9HeY=5KLodWo3_2dDpg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 18 Apr 2011 07:16:36 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Apr 8, 2011 at 8:49 AM, Shirish Pargaonkar
> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > On Fri, Apr 8, 2011 at 8:40 AM, Jeff Layton <jlayton-vpEMnDpepFvY2uhgrK1nQg@public.gmane.org=
t> wrote:
> >> On Wed, =C2=A06 Apr 2011 08:46:06 -0500
> >> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >>
> >>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>>
> >>>
> >>> Fix authentication failures using extended security mechanisms.
> >>> cifs client does not take into consideration extended security bi=
t
> >>> in capabilities field in negotiate protocol response from the ser=
ver.
> >>>
> >>> Please refer to Samba bugzilla 8046.
> >>>
> >>>
> >>> Reported-and-tested by: Werner Maes <Werner.Maes-UiU5zyVfpuo0a//2gYcwQw@public.gmane.org=
>
> >>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>> ---
> >>> =C2=A0fs/cifs/cifssmb.c | =C2=A0 17 ++++++-----------
> >>> =C2=A01 files changed, 6 insertions(+), 11 deletions(-)
> >>>
> >>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> >>> index 3291770..e119d70 100644
> >>> --- a/fs/cifs/cifssmb.c
> >>> +++ b/fs/cifs/cifssmb.c
> >>> @@ -570,18 +570,10 @@ CIFSSMBNegotiate(unsigned int xid, struct c=
ifs_ses *ses)
> >>> =C2=A0 =C2=A0 =C2=A0 if (pSMBr->EncryptionKeyLength =3D=3D CIFS_C=
RYPTO_KEY_SIZE) {
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(ses->serv=
er->cryptkey, pSMBr->u.EncryptionKey,
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0CIFS_CRYPTO_KEY_SIZE);
> >>> - =C2=A0 =C2=A0 } else if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC)
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 && (pSMBr->EncryptionKeyLength =3D=3D 0)) {
> >>> + =C2=A0 =C2=A0 } else if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC |=
|
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 server->capabilities & CAP_EXTENDED_SECURITY) &&
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (pSMBr->EncryptionKeyLength =3D=3D 0=
)) {
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* decode securi=
ty blob */
> >>
> >> This looks wrong to me. CAP_EXTENDED_SECURITY just means that the
> >> server supports extended security, not that it's in use, right? Ar=
en't
> >> we just working around server brokenness here. Why isn't it settin=
g
> >> SMBFLG2_EXT_SEC if it's using extended security?
> >>
> >> Are there cases where the server might set EncryptionKeyLength to =
0,
> >> and *not* be using extended security? If not, then why bother to c=
heck
> >> the flags or capabilities at all?
> >>
> >>> - =C2=A0 =C2=A0 } else if (server->sec_mode & SECMODE_PW_ENCRYPT)=
 {
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -EIO; /* no cr=
ypt key only if plain text pwd */
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto neg_err_exit;
> >>> - =C2=A0 =C2=A0 }
> >>> -
> >>> - =C2=A0 =C2=A0 /* BB might be helpful to save off the domain of =
server here */
> >>> -
> >>> - =C2=A0 =C2=A0 if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC) &&
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (server->capabilities=
 & CAP_EXTENDED_SECURITY)) {
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 count =3D get_bc=
c(&pSMBr->hdr);
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (count < 16) =
{
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rc =3D -EIO;
> >>> @@ -624,6 +616,9 @@ CIFSSMBNegotiate(unsigned int xid, struct cif=
s_ses *ses)
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 } else
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D=
 -EOPNOTSUPP;
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >>> + =C2=A0 =C2=A0 } else if (server->sec_mode & SECMODE_PW_ENCRYPT)=
 {
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -EIO; /* no cr=
ypt key only if plain text pwd */
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto neg_err_exit;
> >>> =C2=A0 =C2=A0 =C2=A0 } else
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 server->capabili=
ties &=3D ~CAP_EXTENDED_SECURITY;
> >>>
> >>
> >>
> >> --
> >> Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
> >>
> >
> > I checked in ms-cifs and ms-smb, and there is no mention of server =
needing
> > to set extended security bit in flags2 in smb header but ms-smb doe=
s mention
> > about server setting extended security bit in capabilities field in
> > negotiate protocol response (there is an example of the exchange in=
 ms-smb).
> > When server is indicating it supports extended security, it should =
set
> > encryptionkeylength to 0 since the ensuing exchange will involve an
> > encryption key (challenge).
> >
>=20
> Jeff, any further comments on this?
>=20

No. As long as you're fairly sure that this won't cause regressions
when we don't intend to use extended security then I'm ok with it.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
