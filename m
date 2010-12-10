From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Support NTLM2 session security during NTLMSSP
 authentication [try #4]
Date: Fri, 10 Dec 2010 15:55:52 -0600
Message-ID: <AANLkTimsbcSv2F27UHWe4BUbOUL_A3GUdMzms36Xqs=s@mail.gmail.com>
References: <1291998647-10763-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101210161326.2cebfef0@tlielax.poochiereds.net>
	<AANLkTinkfcOg6VUGOxo5eb9ujz0zTk3-FDzXYz=48EpH@mail.gmail.com>
	<20101210164808.3fb88e53@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101210164808.3fb88e53-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Dec 10, 2010 at 3:48 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Fri, 10 Dec 2010 15:43:17 -0600
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Fri, Dec 10, 2010 at 3:13 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wro=
te:
>> > On Fri, 10 Dec 2010 10:30:47 -0600
>> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> >
>> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >>
>> >>
>> >> Indicate to the server a capability of NTLM2 session security (NT=
LM2 Key)
>> >> during ntlmssp protocol exchange in one of the bits of the flags =
field.
>> >> If server supports this capability, send NTLM2 key even if signin=
g is not
>> >> required on the server.
>> >>
>> >> If the server requires signing, the session keys exchanged for NT=
LMv2
>> >> and NTLM2 session security in auth packet of the nlmssp exchange =
are same.
>> >>
>> >> Send the same flags in authenticate message (type 3) that client =
sent in
>> >> negotiate message (type 1).
>> >>
>> >> Remove function setup_ntlmssp_neg_req() and allocate zero'ed buff=
ers
>> >> to prepare ntlmssp negotiate and authenticat requests.
>> >>
>> >>
>> >> Reported-and-Tested-by: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
>> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> ---
>> >> =A0fs/cifs/sess.c | =A0 46 +++++++++++++++++++++++++-------------=
--------
>> >> =A01 files changed, 25 insertions(+), 21 deletions(-)
>> >>
>> >> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> >> index 7b01d3f..56e945a 100644
>> >> --- a/fs/cifs/sess.c
>> >> +++ b/fs/cifs/sess.c
>> >> @@ -425,7 +425,7 @@ static int decode_ntlmssp_challenge(char *bcc=
_ptr, int blob_len,
>> >>
>> >> =A0/* We do not malloc the blob, it is passed in pbuffer, because
>> >> =A0 =A0 it is fixed size, and small, making this approach cleaner=
 */
>> >> -static void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
>> >> +static void build_ntlmssp_negotiate_blob(char *pbuffer,
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0struct cifsSesInfo *ses)
>> >> =A0{
>> >> =A0 =A0 =A0 NEGOTIATE_MESSAGE *sec_blob =3D (NEGOTIATE_MESSAGE *)=
pbuffer;
>> >> @@ -437,7 +437,7 @@ static void build_ntlmssp_negotiate_blob(unsi=
gned char *pbuffer,
>> >> =A0 =A0 =A0 /* BB is NTLMV2 session security format easier to use=
 here? */
>> >> =A0 =A0 =A0 flags =3D NTLMSSP_NEGOTIATE_56 | =A0NTLMSSP_REQUEST_T=
ARGET |
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOT=
IATE_UNICODE |
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTI=
ATE_EXTENDED_SEC;
>> >> =A0 =A0 =A0 if (ses->server->secMode &
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (SECMODE_SIGN_REQUIRE=
D | SECMODE_SIGN_ENABLED)) {
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_SIGN;
>> >> @@ -446,7 +446,7 @@ static void build_ntlmssp_negotiate_blob(unsi=
gned char *pbuffer,
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMS=
SP_NEGOTIATE_EXTENDED_SEC;
>> >> =A0 =A0 =A0 }
>> >>
>> >> - =A0 =A0 sec_blob->NegotiateFlags |=3D cpu_to_le32(flags);
>> >> + =A0 =A0 sec_blob->NegotiateFlags =3D cpu_to_le32(flags);
>> >>
>> >> =A0 =A0 =A0 sec_blob->WorkstationName.BufferOffset =3D 0;
>> >> =A0 =A0 =A0 sec_blob->WorkstationName.Length =3D 0;
>> >> @@ -477,7 +477,7 @@ static int build_ntlmssp_auth_blob(unsigned c=
har *pbuffer,
>> >> =A0 =A0 =A0 flags =3D NTLMSSP_NEGOTIATE_56 |
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_REQUEST_TARGET | NTLMSSP_NEGO=
TIATE_TARGET_INFO |
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOT=
IATE_UNICODE |
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTI=
ATE_EXTENDED_SEC;
>> >> =A0 =A0 =A0 if (ses->server->secMode &
>> >> =A0 =A0 =A0 =A0 =A0(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)=
)
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_SIGN;
>> >> @@ -485,7 +485,7 @@ static int build_ntlmssp_auth_blob(unsigned c=
har *pbuffer,
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_ALWAYS_S=
IGN;
>> >>
>> >> =A0 =A0 =A0 tmp =3D pbuffer + sizeof(AUTHENTICATE_MESSAGE);
>> >> - =A0 =A0 sec_blob->NegotiateFlags |=3D cpu_to_le32(flags);
>> >> + =A0 =A0 sec_blob->NegotiateFlags =3D cpu_to_le32(flags);
>> >>
>> >> =A0 =A0 =A0 sec_blob->LmChallengeResponse.BufferOffset =3D
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_t=
o_le32(sizeof(AUTHENTICATE_MESSAGE));
>> >> @@ -544,8 +544,9 @@ static int build_ntlmssp_auth_blob(unsigned c=
har *pbuffer,
>> >> =A0 =A0 =A0 sec_blob->WorkstationName.MaximumLength =3D 0;
>> >> =A0 =A0 =A0 tmp +=3D 2;
>> >>
>> >> - =A0 =A0 if ((ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_KEY=
_XCH) &&
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !calc_seckey(ses)) {
>> >> + =A0 =A0 if (((ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_KE=
Y_XCH) ||
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 (ses->ntlmssp->server_flags & NTLMSSP_N=
EGOTIATE_EXTENDED_SEC))
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && !calc_seckey(ses)) {
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(tmp, ses->ntlmssp->ciphertext,=
 CIFS_CPHTXT_SIZE);
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.BufferOffset =3D=
 cpu_to_le32(tmp - pbuffer);
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.Length =3D cpu_t=
o_le16(CIFS_CPHTXT_SIZE);
>> >> @@ -562,16 +563,6 @@ setup_ntlmv2_ret:
>> >> =A0 =A0 =A0 *buflen =3D tmp - pbuffer;
>> >> =A0 =A0 =A0 return rc;
>> >> =A0}
>> >> -
>> >> -
>> >> -static void setup_ntlmssp_neg_req(SESSION_SETUP_ANDX *pSMB,
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stru=
ct cifsSesInfo *ses)
>> >> -{
>> >> - =A0 =A0 build_ntlmssp_negotiate_blob(&pSMB->req.SecurityBlob[0]=
, ses);
>> >> - =A0 =A0 pSMB->req.SecurityBlobLength =3D cpu_to_le16(sizeof(NEG=
OTIATE_MESSAGE));
>> >> -
>> >> - =A0 =A0 return;
>> >> -}
>> > =A0 =A0 =A0 =A0^^^^^
>> > I like that you removed the above function. It was useless indirec=
tion.
>> >
>> >> =A0#endif
>> >>
>> >> =A0int
>> >> @@ -595,6 +586,7 @@ CIFS_SessSetup(unsigned int xid, struct cifsS=
esInfo *ses,
>> >> =A0 =A0 =A0 __le32 phase =3D NtLmNegotiate; /* NTLMSSP, if needed=
, is multistage */
>> >> =A0 =A0 =A0 u16 blob_len;
>> >> =A0 =A0 =A0 char *ntlmsspblob =3D NULL;
>> >> + =A0 =A0 char *ntlmsspnblob =3D NULL;
>> >>
>> >> =A0 =A0 =A0 if (ses =3D=3D NULL)
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> >> @@ -828,16 +820,26 @@ ssetup_ntlmssp_authenticate:
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 capabilities |=3D CAP=
_EXTENDED_SECURITY;
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req.Capabilitie=
s |=3D cpu_to_le32(capabilities);
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (phase =3D=3D NtLm=
Negotiate) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 setup_n=
tlmssp_neg_req(pSMB, ses);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntlmssp=
nblob =3D kzalloc(
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sizeof(struct _NEGOTIATE_MESSAGE),
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 GFP_KERNEL);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!nt=
lmsspnblob) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 cERROR(1, "Can't allocate NTLMSSPN");
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 rc =3D -ENOMEM;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 goto ssetup_exit;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 build_n=
tlmssp_negotiate_blob(ntlmsspnblob, ses);
>> >
>> > Why did you decide to allocate a new buffer here? Was the Security=
Blob
>> > not big enough? If not, then I think it would make more sense to j=
ust
>> > memset the existing buffer to 0.
>>
>> No the buffer allocated by small_smb_init is sufficient to hold the
>> ntlmssp negotiate request. I do not need to allocate a new buffer.
>> And header_assemble memsets that buffer to 0, so no need to redo it =
again.
>>
>> So only ntlmsspblob needs to be kzalloc'ed.
>>
>
> header_assemble does this:
>
> =A0 =A0 =A0 =A0memset(temp, 0, 256); /* bigger than MAX_CIFS_HDR_SIZE=
 */
>
> ...is that enough? (I haven't measured it).

I think so. That is what it had been all along (till I changed the code=
 here).
So small_int_buf allocated 256 byte long buf should be enough to carry
ntlmssp negotiate request with session setup request headed by
SMB header.  So I think we can keep the same code, no need to
allocate additional buffer for ntlmssp negotiate request.


>
>
>> >
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1=
].iov_len =3D sizeof(NEGOTIATE_MESSAGE);
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].=
iov_base =3D &pSMB->req.SecurityBlob[0];
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].=
iov_base =3D ntlmsspnblob;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->r=
eq.SecurityBlobLength =3D
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 cpu_to_le16(sizeof(NEGOTIATE_MESSAGE));
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (phase =3D=3D=
 NtLmAuthenticate) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* 5 is=
 an empirical value, large enought to
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* 5 is=
 an empirical value, large enough to
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =
hold authenticate message, max 10 of
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =
av paris, doamin,user,workstation mames,
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =
flags etc..
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntlmssp=
blob =3D kmalloc(
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntlmssp=
blob =3D kzalloc(
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 5*sizeof(struct _AUTHENTICATE_MESSAGE),
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 GFP_KERNEL);
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!=
ntlmsspblob) {
>> >> @@ -960,6 +962,8 @@ ssetup_exit:
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 key_put(spnego_key);
>> >> =A0 =A0 =A0 }
>> >> =A0 =A0 =A0 kfree(str_area);
>> >> + =A0 =A0 kfree(ntlmsspnblob);
>> >> + =A0 =A0 ntlmsspnblob =3D NULL;
>> >
>> > If we did decide that we needed a new buffer for this, I don't thi=
nk we
>> > need a new pointer on the stack for it. ntlmsspblob would suffice =
in
>> > that case.
>> >
>> >> =A0 =A0 =A0 kfree(ntlmsspblob);
>> >> =A0 =A0 =A0 ntlmsspblob =3D NULL;
>> >> =A0 =A0 =A0 if (resp_buf_type =3D=3D CIFS_SMALL_BUFFER) {
>> >
>> > --
>> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
