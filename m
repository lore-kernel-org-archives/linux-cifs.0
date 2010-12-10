From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: Support NTLM2 session security during NTLMSSP
 authentication [try #4]
Date: Fri, 10 Dec 2010 17:06:54 -0500
Message-ID: <20101210170654.62eeb074@tlielax.poochiereds.net>
References: <1291998647-10763-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101210161326.2cebfef0@tlielax.poochiereds.net>
	<AANLkTinkfcOg6VUGOxo5eb9ujz0zTk3-FDzXYz=48EpH@mail.gmail.com>
	<20101210164808.3fb88e53@tlielax.poochiereds.net>
	<AANLkTimsbcSv2F27UHWe4BUbOUL_A3GUdMzms36Xqs=s@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimsbcSv2F27UHWe4BUbOUL_A3GUdMzms36Xqs=s@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 10 Dec 2010 15:55:52 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Dec 10, 2010 at 3:48 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > On Fri, 10 Dec 2010 15:43:17 -0600
> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Fri, Dec 10, 2010 at 3:13 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> w=
rote:
> >> > On Fri, 10 Dec 2010 10:30:47 -0600
> >> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >> >
> >> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> >>
> >> >>
> >> >> Indicate to the server a capability of NTLM2 session security (=
NTLM2 Key)
> >> >> during ntlmssp protocol exchange in one of the bits of the flag=
s field.
> >> >> If server supports this capability, send NTLM2 key even if sign=
ing is not
> >> >> required on the server.
> >> >>
> >> >> If the server requires signing, the session keys exchanged for =
NTLMv2
> >> >> and NTLM2 session security in auth packet of the nlmssp exchang=
e are same.
> >> >>
> >> >> Send the same flags in authenticate message (type 3) that clien=
t sent in
> >> >> negotiate message (type 1).
> >> >>
> >> >> Remove function setup_ntlmssp_neg_req() and allocate zero'ed bu=
ffers
> >> >> to prepare ntlmssp negotiate and authenticat requests.
> >> >>
> >> >>
> >> >> Reported-and-Tested-by: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
> >> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> >> ---
> >> >> =A0fs/cifs/sess.c | =A0 46 +++++++++++++++++++++++++-----------=
----------
> >> >> =A01 files changed, 25 insertions(+), 21 deletions(-)
> >> >>
> >> >> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> >> >> index 7b01d3f..56e945a 100644
> >> >> --- a/fs/cifs/sess.c
> >> >> +++ b/fs/cifs/sess.c
> >> >> @@ -425,7 +425,7 @@ static int decode_ntlmssp_challenge(char *b=
cc_ptr, int blob_len,
> >> >>
> >> >> =A0/* We do not malloc the blob, it is passed in pbuffer, becau=
se
> >> >> =A0 =A0 it is fixed size, and small, making this approach clean=
er */
> >> >> -static void build_ntlmssp_negotiate_blob(unsigned char *pbuffe=
r,
> >> >> +static void build_ntlmssp_negotiate_blob(char *pbuffer,
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0struct cifsSesInfo *ses)
> >> >> =A0{
> >> >> =A0 =A0 =A0 NEGOTIATE_MESSAGE *sec_blob =3D (NEGOTIATE_MESSAGE =
*)pbuffer;
> >> >> @@ -437,7 +437,7 @@ static void build_ntlmssp_negotiate_blob(un=
signed char *pbuffer,
> >> >> =A0 =A0 =A0 /* BB is NTLMV2 session security format easier to u=
se here? */
> >> >> =A0 =A0 =A0 flags =3D NTLMSSP_NEGOTIATE_56 | =A0NTLMSSP_REQUEST=
_TARGET |
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEG=
OTIATE_UNICODE |
> >> >> - =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGO=
TIATE_EXTENDED_SEC;
> >> >> =A0 =A0 =A0 if (ses->server->secMode &
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (SECMODE_SIGN_REQUI=
RED | SECMODE_SIGN_ENABLED)) {
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_SIGN;
> >> >> @@ -446,7 +446,7 @@ static void build_ntlmssp_negotiate_blob(un=
signed char *pbuffer,
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTL=
MSSP_NEGOTIATE_EXTENDED_SEC;
> >> >> =A0 =A0 =A0 }
> >> >>
> >> >> - =A0 =A0 sec_blob->NegotiateFlags |=3D cpu_to_le32(flags);
> >> >> + =A0 =A0 sec_blob->NegotiateFlags =3D cpu_to_le32(flags);
> >> >>
> >> >> =A0 =A0 =A0 sec_blob->WorkstationName.BufferOffset =3D 0;
> >> >> =A0 =A0 =A0 sec_blob->WorkstationName.Length =3D 0;
> >> >> @@ -477,7 +477,7 @@ static int build_ntlmssp_auth_blob(unsigned=
 char *pbuffer,
> >> >> =A0 =A0 =A0 flags =3D NTLMSSP_NEGOTIATE_56 |
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_REQUEST_TARGET | NTLMSSP_NE=
GOTIATE_TARGET_INFO |
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEG=
OTIATE_UNICODE |
> >> >> - =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGO=
TIATE_EXTENDED_SEC;
> >> >> =A0 =A0 =A0 if (ses->server->secMode &
> >> >> =A0 =A0 =A0 =A0 =A0(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLE=
D))
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_SIGN;
> >> >> @@ -485,7 +485,7 @@ static int build_ntlmssp_auth_blob(unsigned=
 char *pbuffer,
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_ALWAYS=
_SIGN;
> >> >>
> >> >> =A0 =A0 =A0 tmp =3D pbuffer + sizeof(AUTHENTICATE_MESSAGE);
> >> >> - =A0 =A0 sec_blob->NegotiateFlags |=3D cpu_to_le32(flags);
> >> >> + =A0 =A0 sec_blob->NegotiateFlags =3D cpu_to_le32(flags);
> >> >>
> >> >> =A0 =A0 =A0 sec_blob->LmChallengeResponse.BufferOffset =3D
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu=
_to_le32(sizeof(AUTHENTICATE_MESSAGE));
> >> >> @@ -544,8 +544,9 @@ static int build_ntlmssp_auth_blob(unsigned=
 char *pbuffer,
> >> >> =A0 =A0 =A0 sec_blob->WorkstationName.MaximumLength =3D 0;
> >> >> =A0 =A0 =A0 tmp +=3D 2;
> >> >>
> >> >> - =A0 =A0 if ((ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_K=
EY_XCH) &&
> >> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !calc_seckey(ses)) {
> >> >> + =A0 =A0 if (((ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_=
KEY_XCH) ||
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 (ses->ntlmssp->server_flags & NTLMSSP=
_NEGOTIATE_EXTENDED_SEC))
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && !calc_seckey(ses))=
 {
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(tmp, ses->ntlmssp->ciphertex=
t, CIFS_CPHTXT_SIZE);
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.BufferOffset =3D=
 cpu_to_le32(tmp - pbuffer);
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.Length =3D cpu=
_to_le16(CIFS_CPHTXT_SIZE);
> >> >> @@ -562,16 +563,6 @@ setup_ntlmv2_ret:
> >> >> =A0 =A0 =A0 *buflen =3D tmp - pbuffer;
> >> >> =A0 =A0 =A0 return rc;
> >> >> =A0}
> >> >> -
> >> >> -
> >> >> -static void setup_ntlmssp_neg_req(SESSION_SETUP_ANDX *pSMB,
> >> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0st=
ruct cifsSesInfo *ses)
> >> >> -{
> >> >> - =A0 =A0 build_ntlmssp_negotiate_blob(&pSMB->req.SecurityBlob[=
0], ses);
> >> >> - =A0 =A0 pSMB->req.SecurityBlobLength =3D cpu_to_le16(sizeof(N=
EGOTIATE_MESSAGE));
> >> >> -
> >> >> - =A0 =A0 return;
> >> >> -}
> >> > =A0 =A0 =A0 =A0^^^^^
> >> > I like that you removed the above function. It was useless indir=
ection.
> >> >
> >> >> =A0#endif
> >> >>
> >> >> =A0int
> >> >> @@ -595,6 +586,7 @@ CIFS_SessSetup(unsigned int xid, struct cif=
sSesInfo *ses,
> >> >> =A0 =A0 =A0 __le32 phase =3D NtLmNegotiate; /* NTLMSSP, if need=
ed, is multistage */
> >> >> =A0 =A0 =A0 u16 blob_len;
> >> >> =A0 =A0 =A0 char *ntlmsspblob =3D NULL;
> >> >> + =A0 =A0 char *ntlmsspnblob =3D NULL;
> >> >>
> >> >> =A0 =A0 =A0 if (ses =3D=3D NULL)
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> >> >> @@ -828,16 +820,26 @@ ssetup_ntlmssp_authenticate:
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 capabilities |=3D C=
AP_EXTENDED_SECURITY;
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req.Capabilit=
ies |=3D cpu_to_le32(capabilities);
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (phase =3D=3D Nt=
LmNegotiate) {
> >> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 setup=
_ntlmssp_neg_req(pSMB, ses);
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntlms=
spnblob =3D kzalloc(
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sizeof(struct _NEGOTIATE_MESSAGE),
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 GFP_KERNEL);
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!=
ntlmsspnblob) {
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 cERROR(1, "Can't allocate NTLMSSPN");
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 rc =3D -ENOMEM;
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 goto ssetup_exit;
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 build=
_ntlmssp_negotiate_blob(ntlmsspnblob, ses);
> >> >
> >> > Why did you decide to allocate a new buffer here? Was the Securi=
tyBlob
> >> > not big enough? If not, then I think it would make more sense to=
 just
> >> > memset the existing buffer to 0.
> >>
> >> No the buffer allocated by small_smb_init is sufficient to hold th=
e
> >> ntlmssp negotiate request. I do not need to allocate a new buffer.
> >> And header_assemble memsets that buffer to 0, so no need to redo i=
t again.
> >>
> >> So only ntlmsspblob needs to be kzalloc'ed.
> >>
> >
> > header_assemble does this:
> >
> > =A0 =A0 =A0 =A0memset(temp, 0, 256); /* bigger than MAX_CIFS_HDR_SI=
ZE */
> >
> > ...is that enough? (I haven't measured it).
>=20
> I think so. That is what it had been all along (till I changed the co=
de here).
> So small_int_buf allocated 256 byte long buf should be enough to carr=
y
> ntlmssp negotiate request with session setup request headed by
> SMB header.  So I think we can keep the same code, no need to
> allocate additional buffer for ntlmssp negotiate request.
>=20
>=20

I agree that we don't need a new buffer. I'm just wondering whether
header_assemble is zeroing enough of the old one. The safe thing to do
would be to do this in build_ntlmssp_negotiate_blob:

    memset(pbuffer, 0, sizeof(NEGOTIATE_MESSAGE));

=2E..or even better would be to consider zeroing all of the buffer in
smb_init or small_smb_init. We do need to be extra careful to not ever
send unintialized data on the wire.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
