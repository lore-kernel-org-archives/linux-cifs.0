From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Support NTLM2 session security during NTLMSSP
 authentication [try #4]
Date: Fri, 10 Dec 2010 15:43:17 -0600
Message-ID: <AANLkTinkfcOg6VUGOxo5eb9ujz0zTk3-FDzXYz=48EpH@mail.gmail.com>
References: <1291998647-10763-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101210161326.2cebfef0@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101210161326.2cebfef0-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Dec 10, 2010 at 3:13 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Fri, 10 Dec 2010 10:30:47 -0600
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Indicate to the server a capability of NTLM2 session security (NTLM2=
 Key)
>> during ntlmssp protocol exchange in one of the bits of the flags fie=
ld.
>> If server supports this capability, send NTLM2 key even if signing i=
s not
>> required on the server.
>>
>> If the server requires signing, the session keys exchanged for NTLMv=
2
>> and NTLM2 session security in auth packet of the nlmssp exchange are=
 same.
>>
>> Send the same flags in authenticate message (type 3) that client sen=
t in
>> negotiate message (type 1).
>>
>> Remove function setup_ntlmssp_neg_req() and allocate zero'ed buffers
>> to prepare ntlmssp negotiate and authenticat requests.
>>
>>
>> Reported-and-Tested-by: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/sess.c | =A0 46 +++++++++++++++++++++++++----------------=
-----
>> =A01 files changed, 25 insertions(+), 21 deletions(-)
>>
>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> index 7b01d3f..56e945a 100644
>> --- a/fs/cifs/sess.c
>> +++ b/fs/cifs/sess.c
>> @@ -425,7 +425,7 @@ static int decode_ntlmssp_challenge(char *bcc_pt=
r, int blob_len,
>>
>> =A0/* We do not malloc the blob, it is passed in pbuffer, because
>> =A0 =A0 it is fixed size, and small, making this approach cleaner */
>> -static void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
>> +static void build_ntlmssp_negotiate_blob(char *pbuffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0struct cifsSesInfo *ses)
>> =A0{
>> =A0 =A0 =A0 NEGOTIATE_MESSAGE *sec_blob =3D (NEGOTIATE_MESSAGE *)pbu=
ffer;
>> @@ -437,7 +437,7 @@ static void build_ntlmssp_negotiate_blob(unsigne=
d char *pbuffer,
>> =A0 =A0 =A0 /* BB is NTLMV2 session security format easier to use he=
re? */
>> =A0 =A0 =A0 flags =3D NTLMSSP_NEGOTIATE_56 | =A0NTLMSSP_REQUEST_TARG=
ET |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIAT=
E_UNICODE |
>> - =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE=
_EXTENDED_SEC;
>> =A0 =A0 =A0 if (ses->server->secMode &
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (SECMODE_SIGN_REQUIRED |=
 SECMODE_SIGN_ENABLED)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_SIGN;
>> @@ -446,7 +446,7 @@ static void build_ntlmssp_negotiate_blob(unsigne=
d char *pbuffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_=
NEGOTIATE_EXTENDED_SEC;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 sec_blob->NegotiateFlags |=3D cpu_to_le32(flags);
>> + =A0 =A0 sec_blob->NegotiateFlags =3D cpu_to_le32(flags);
>>
>> =A0 =A0 =A0 sec_blob->WorkstationName.BufferOffset =3D 0;
>> =A0 =A0 =A0 sec_blob->WorkstationName.Length =3D 0;
>> @@ -477,7 +477,7 @@ static int build_ntlmssp_auth_blob(unsigned char=
 *pbuffer,
>> =A0 =A0 =A0 flags =3D NTLMSSP_NEGOTIATE_56 |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_REQUEST_TARGET | NTLMSSP_NEGOTIA=
TE_TARGET_INFO |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIAT=
E_UNICODE |
>> - =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE=
_EXTENDED_SEC;
>> =A0 =A0 =A0 if (ses->server->secMode &
>> =A0 =A0 =A0 =A0 =A0(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_SIGN;
>> @@ -485,7 +485,7 @@ static int build_ntlmssp_auth_blob(unsigned char=
 *pbuffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_ALWAYS_SIGN=
;
>>
>> =A0 =A0 =A0 tmp =3D pbuffer + sizeof(AUTHENTICATE_MESSAGE);
>> - =A0 =A0 sec_blob->NegotiateFlags |=3D cpu_to_le32(flags);
>> + =A0 =A0 sec_blob->NegotiateFlags =3D cpu_to_le32(flags);
>>
>> =A0 =A0 =A0 sec_blob->LmChallengeResponse.BufferOffset =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_l=
e32(sizeof(AUTHENTICATE_MESSAGE));
>> @@ -544,8 +544,9 @@ static int build_ntlmssp_auth_blob(unsigned char=
 *pbuffer,
>> =A0 =A0 =A0 sec_blob->WorkstationName.MaximumLength =3D 0;
>> =A0 =A0 =A0 tmp +=3D 2;
>>
>> - =A0 =A0 if ((ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_KEY_XC=
H) &&
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !calc_seckey(ses)) {
>> + =A0 =A0 if (((ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_KEY_X=
CH) ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 (ses->ntlmssp->server_flags & NTLMSSP_NEGO=
TIATE_EXTENDED_SEC))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && !calc_seckey(ses)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(tmp, ses->ntlmssp->ciphertext, CI=
=46S_CPHTXT_SIZE);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.BufferOffset =3D cp=
u_to_le32(tmp - pbuffer);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.Length =3D cpu_to_l=
e16(CIFS_CPHTXT_SIZE);
>> @@ -562,16 +563,6 @@ setup_ntlmv2_ret:
>> =A0 =A0 =A0 *buflen =3D tmp - pbuffer;
>> =A0 =A0 =A0 return rc;
>> =A0}
>> -
>> -
>> -static void setup_ntlmssp_neg_req(SESSION_SETUP_ANDX *pSMB,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct =
cifsSesInfo *ses)
>> -{
>> - =A0 =A0 build_ntlmssp_negotiate_blob(&pSMB->req.SecurityBlob[0], s=
es);
>> - =A0 =A0 pSMB->req.SecurityBlobLength =3D cpu_to_le16(sizeof(NEGOTI=
ATE_MESSAGE));
>> -
>> - =A0 =A0 return;
>> -}
> =A0 =A0 =A0 =A0^^^^^
> I like that you removed the above function. It was useless indirectio=
n.
>
>> =A0#endif
>>
>> =A0int
>> @@ -595,6 +586,7 @@ CIFS_SessSetup(unsigned int xid, struct cifsSesI=
nfo *ses,
>> =A0 =A0 =A0 __le32 phase =3D NtLmNegotiate; /* NTLMSSP, if needed, i=
s multistage */
>> =A0 =A0 =A0 u16 blob_len;
>> =A0 =A0 =A0 char *ntlmsspblob =3D NULL;
>> + =A0 =A0 char *ntlmsspnblob =3D NULL;
>>
>> =A0 =A0 =A0 if (ses =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> @@ -828,16 +820,26 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 capabilities |=3D CAP_EX=
TENDED_SECURITY;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req.Capabilities |=
=3D cpu_to_le32(capabilities);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (phase =3D=3D NtLmNeg=
otiate) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 setup_ntlm=
ssp_neg_req(pSMB, ses);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntlmsspnbl=
ob =3D kzalloc(
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 sizeof(struct _NEGOTIATE_MESSAGE),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 GFP_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ntlms=
spnblob) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 cERROR(1, "Can't allocate NTLMSSPN");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 rc =3D -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 goto ssetup_exit;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 build_ntlm=
ssp_negotiate_blob(ntlmsspnblob, ses);
>
> Why did you decide to allocate a new buffer here? Was the SecurityBlo=
b
> not big enough? If not, then I think it would make more sense to just
> memset the existing buffer to 0.

No the buffer allocated by small_smb_init is sufficient to hold the
ntlmssp negotiate request. I do not need to allocate a new buffer.
And header_assemble memsets that buffer to 0, so no need to redo it aga=
in.

So only ntlmsspblob needs to be kzalloc'ed.

>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].i=
ov_len =3D sizeof(NEGOTIATE_MESSAGE);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov=
_base =3D &pSMB->req.SecurityBlob[0];
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov=
_base =3D ntlmsspnblob;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req.=
SecurityBlobLength =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 cpu_to_le16(sizeof(NEGOTIATE_MESSAGE));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (phase =3D=3D =
NtLmAuthenticate) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* 5 is an=
 empirical value, large enought to
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* 5 is an=
 empirical value, large enough to
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* hol=
d authenticate message, max 10 of
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* av =
paris, doamin,user,workstation mames,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* fla=
gs etc..
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntlmsspblo=
b =3D kmalloc(
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntlmsspblo=
b =3D kzalloc(
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 5*sizeof(struct _AUTHENTICATE_MESSAGE),
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 GFP_KERNEL);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ntl=
msspblob) {
>> @@ -960,6 +962,8 @@ ssetup_exit:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 key_put(spnego_key);
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 kfree(str_area);
>> + =A0 =A0 kfree(ntlmsspnblob);
>> + =A0 =A0 ntlmsspnblob =3D NULL;
>
> If we did decide that we needed a new buffer for this, I don't think =
we
> need a new pointer on the stack for it. ntlmsspblob would suffice in
> that case.
>
>> =A0 =A0 =A0 kfree(ntlmsspblob);
>> =A0 =A0 =A0 ntlmsspblob =3D NULL;
>> =A0 =A0 =A0 if (resp_buf_type =3D=3D CIFS_SMALL_BUFFER) {
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
