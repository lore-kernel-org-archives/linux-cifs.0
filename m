From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Support NTLM2 session security during NTLMSSP
 authentication [try #4]
Date: Fri, 10 Dec 2010 16:18:22 -0600
Message-ID: <AANLkTim=S7iofJuetKrDf=BnNtLRXD5n_wzT3gZcQf+3@mail.gmail.com>
References: <1291998647-10763-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101210161326.2cebfef0@tlielax.poochiereds.net>
	<AANLkTinkfcOg6VUGOxo5eb9ujz0zTk3-FDzXYz=48EpH@mail.gmail.com>
	<20101210164808.3fb88e53@tlielax.poochiereds.net>
	<AANLkTimsbcSv2F27UHWe4BUbOUL_A3GUdMzms36Xqs=s@mail.gmail.com>
	<20101210170654.62eeb074@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101210170654.62eeb074-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Dec 10, 2010 at 4:06 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Fri, 10 Dec 2010 15:55:52 -0600
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Fri, Dec 10, 2010 at 3:48 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wro=
te:
>> > On Fri, 10 Dec 2010 15:43:17 -0600
>> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> On Fri, Dec 10, 2010 at 3:13 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> =
wrote:
>> >> > On Fri, 10 Dec 2010 10:30:47 -0600
>> >> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> >> >
>> >> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> >>
>> >> >>
>> >> >> Indicate to the server a capability of NTLM2 session security =
(NTLM2 Key)
>> >> >> during ntlmssp protocol exchange in one of the bits of the fla=
gs field.
>> >> >> If server supports this capability, send NTLM2 key even if sig=
ning is not
>> >> >> required on the server.
>> >> >>
>> >> >> If the server requires signing, the session keys exchanged for=
 NTLMv2
>> >> >> and NTLM2 session security in auth packet of the nlmssp exchan=
ge are same.
>> >> >>
>> >> >> Send the same flags in authenticate message (type 3) that clie=
nt sent in
>> >> >> negotiate message (type 1).
>> >> >>
>> >> >> Remove function setup_ntlmssp_neg_req() and allocate zero'ed b=
uffers
>> >> >> to prepare ntlmssp negotiate and authenticat requests.
>> >> >>
>> >> >>
>> >> >> Reported-and-Tested-by: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
>> >> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
>
>> >> >> ---
>> >> >> =A0fs/cifs/sess.c | =A0 46 +++++++++++++++++++++++++----------=
-----------
>> >> >> =A01 files changed, 25 insertions(+), 21 deletions(-)
>> >> >>
>> >> >> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> >> >> index 7b01d3f..56e945a 100644
>> >> >> --- a/fs/cifs/sess.c
>> >> >> +++ b/fs/cifs/sess.c
>> >> >> @@ -425,7 +425,7 @@ static int decode_ntlmssp_challenge(char *=
bcc_ptr, int blob_len,
>> >> >>
>> >> >> =A0/* We do not malloc the blob, it is passed in pbuffer, beca=
use
>> >> >> =A0 =A0 it is fixed size, and small, making this approach clea=
ner */
>> >> >> -static void build_ntlmssp_negotiate_blob(unsigned char *pbuff=
er,
>> >> >> +static void build_ntlmssp_negotiate_blob(char *pbuffer,
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0struct cifsSesInfo *ses)
>> >> >> =A0{
>> >> >> =A0 =A0 =A0 NEGOTIATE_MESSAGE *sec_blob =3D (NEGOTIATE_MESSAGE=
 *)pbuffer;
>> >> >> @@ -437,7 +437,7 @@ static void build_ntlmssp_negotiate_blob(u=
nsigned char *pbuffer,
>> >> >> =A0 =A0 =A0 /* BB is NTLMV2 session security format easier to =
use here? */
>> >> >> =A0 =A0 =A0 flags =3D NTLMSSP_NEGOTIATE_56 | =A0NTLMSSP_REQUES=
T_TARGET |
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NE=
GOTIATE_UNICODE |
>> >> >> - =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEG=
OTIATE_EXTENDED_SEC;
>> >> >> =A0 =A0 =A0 if (ses->server->secMode &
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (SECMODE_SIGN_REQU=
IRED | SECMODE_SIGN_ENABLED)) {
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_SIGN;
>> >> >> @@ -446,7 +446,7 @@ static void build_ntlmssp_negotiate_blob(u=
nsigned char *pbuffer,
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NT=
LMSSP_NEGOTIATE_EXTENDED_SEC;
>> >> >> =A0 =A0 =A0 }
>> >> >>
>> >> >> - =A0 =A0 sec_blob->NegotiateFlags |=3D cpu_to_le32(flags);
>> >> >> + =A0 =A0 sec_blob->NegotiateFlags =3D cpu_to_le32(flags);
>> >> >>
>> >> >> =A0 =A0 =A0 sec_blob->WorkstationName.BufferOffset =3D 0;
>> >> >> =A0 =A0 =A0 sec_blob->WorkstationName.Length =3D 0;
>> >> >> @@ -477,7 +477,7 @@ static int build_ntlmssp_auth_blob(unsigne=
d char *pbuffer,
>> >> >> =A0 =A0 =A0 flags =3D NTLMSSP_NEGOTIATE_56 |
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_REQUEST_TARGET | NTLMSSP_N=
EGOTIATE_TARGET_INFO |
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NE=
GOTIATE_UNICODE |
>> >> >> - =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEG=
OTIATE_EXTENDED_SEC;
>> >> >> =A0 =A0 =A0 if (ses->server->secMode &
>> >> >> =A0 =A0 =A0 =A0 =A0(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABL=
ED))
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_SIGN;
>> >> >> @@ -485,7 +485,7 @@ static int build_ntlmssp_auth_blob(unsigne=
d char *pbuffer,
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_ALWAY=
S_SIGN;
>> >> >>
>> >> >> =A0 =A0 =A0 tmp =3D pbuffer + sizeof(AUTHENTICATE_MESSAGE);
>> >> >> - =A0 =A0 sec_blob->NegotiateFlags |=3D cpu_to_le32(flags);
>> >> >> + =A0 =A0 sec_blob->NegotiateFlags =3D cpu_to_le32(flags);
>> >> >>
>> >> >> =A0 =A0 =A0 sec_blob->LmChallengeResponse.BufferOffset =3D
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cp=
u_to_le32(sizeof(AUTHENTICATE_MESSAGE));
>> >> >> @@ -544,8 +544,9 @@ static int build_ntlmssp_auth_blob(unsigne=
d char *pbuffer,
>> >> >> =A0 =A0 =A0 sec_blob->WorkstationName.MaximumLength =3D 0;
>> >> >> =A0 =A0 =A0 tmp +=3D 2;
>> >> >>
>> >> >> - =A0 =A0 if ((ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_=
KEY_XCH) &&
>> >> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !calc_seckey(ses)) {
>> >> >> + =A0 =A0 if (((ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE=
_KEY_XCH) ||
>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 (ses->ntlmssp->server_flags & NTLMSS=
P_NEGOTIATE_EXTENDED_SEC))
>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && !calc_seckey(ses)=
) {
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(tmp, ses->ntlmssp->cipherte=
xt, CIFS_CPHTXT_SIZE);
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.BufferOffset =
=3D cpu_to_le32(tmp - pbuffer);
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.Length =3D cp=
u_to_le16(CIFS_CPHTXT_SIZE);
>> >> >> @@ -562,16 +563,6 @@ setup_ntlmv2_ret:
>> >> >> =A0 =A0 =A0 *buflen =3D tmp - pbuffer;
>> >> >> =A0 =A0 =A0 return rc;
>> >> >> =A0}
>> >> >> -
>> >> >> -
>> >> >> -static void setup_ntlmssp_neg_req(SESSION_SETUP_ANDX *pSMB,
>> >> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0s=
truct cifsSesInfo *ses)
>> >> >> -{
>> >> >> - =A0 =A0 build_ntlmssp_negotiate_blob(&pSMB->req.SecurityBlob=
[0], ses);
>> >> >> - =A0 =A0 pSMB->req.SecurityBlobLength =3D cpu_to_le16(sizeof(=
NEGOTIATE_MESSAGE));
>> >> >> -
>> >> >> - =A0 =A0 return;
>> >> >> -}
>> >> > =A0 =A0 =A0 =A0^^^^^
>> >> > I like that you removed the above function. It was useless indi=
rection.
>> >> >
>> >> >> =A0#endif
>> >> >>
>> >> >> =A0int
>> >> >> @@ -595,6 +586,7 @@ CIFS_SessSetup(unsigned int xid, struct ci=
fsSesInfo *ses,
>> >> >> =A0 =A0 =A0 __le32 phase =3D NtLmNegotiate; /* NTLMSSP, if nee=
ded, is multistage */
>> >> >> =A0 =A0 =A0 u16 blob_len;
>> >> >> =A0 =A0 =A0 char *ntlmsspblob =3D NULL;
>> >> >> + =A0 =A0 char *ntlmsspnblob =3D NULL;
>> >> >>
>> >> >> =A0 =A0 =A0 if (ses =3D=3D NULL)
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> >> >> @@ -828,16 +820,26 @@ ssetup_ntlmssp_authenticate:
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 capabilities |=3D =
CAP_EXTENDED_SECURITY;
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req.Capabili=
ties |=3D cpu_to_le32(capabilities);
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (phase =3D=3D N=
tLmNegotiate) {
>> >> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 setu=
p_ntlmssp_neg_req(pSMB, ses);
>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntlm=
sspnblob =3D kzalloc(
>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 sizeof(struct _NEGOTIATE_MESSAGE),
>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 GFP_KERNEL);
>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (=
!ntlmsspnblob) {
>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 cERROR(1, "Can't allocate NTLMSSPN");
>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 rc =3D -ENOMEM;
>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 goto ssetup_exit;
>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 buil=
d_ntlmssp_negotiate_blob(ntlmsspnblob, ses);
>> >> >
>> >> > Why did you decide to allocate a new buffer here? Was the Secur=
ityBlob
>> >> > not big enough? If not, then I think it would make more sense t=
o just
>> >> > memset the existing buffer to 0.
>> >>
>> >> No the buffer allocated by small_smb_init is sufficient to hold t=
he
>> >> ntlmssp negotiate request. I do not need to allocate a new buffer=
=2E
>> >> And header_assemble memsets that buffer to 0, so no need to redo =
it again.
>> >>
>> >> So only ntlmsspblob needs to be kzalloc'ed.
>> >>
>> >
>> > header_assemble does this:
>> >
>> > =A0 =A0 =A0 =A0memset(temp, 0, 256); /* bigger than MAX_CIFS_HDR_S=
IZE */
>> >
>> > ...is that enough? (I haven't measured it).
>>
>> I think so. That is what it had been all along (till I changed the c=
ode here).
>> So small_int_buf allocated 256 byte long buf should be enough to car=
ry
>> ntlmssp negotiate request with session setup request headed by
>> SMB header. =A0So I think we can keep the same code, no need to
>> allocate additional buffer for ntlmssp negotiate request.
>>
>>
>
> I agree that we don't need a new buffer. I'm just wondering whether
> header_assemble is zeroing enough of the old one. The safe thing to d=
o
> would be to do this in build_ntlmssp_negotiate_blob:
>
> =A0 =A0memset(pbuffer, 0, sizeof(NEGOTIATE_MESSAGE));

This change looks safe to me.  Will incorporate in the patch.

>
> ...or even better would be to consider zeroing all of the buffer in
> smb_init or small_smb_init. We do need to be extra careful to not eve=
r
> send unintialized data on the wire.

I do not mind undertaking this but would really prefer to do this in a
separate patch.  And can get rid of above memet and the one in
header_assemble().

>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
