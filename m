From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] ntlmv2 within ntlmssp authenticate
Date: Tue, 7 Sep 2010 08:58:06 -0400
Message-ID: <20100907085806.0d9cccb1@corrin.poochiereds.net>
References: <1283830523-25110-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100907083514.63e94838@corrin.poochiereds.net>
	<AANLkTin-Z6gHvPA2fHSXA6XA18+yrUpFBhJW95UhE-=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin-Z6gHvPA2fHSXA6XA18+yrUpFBhJW95UhE-=g@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 7 Sep 2010 07:38:45 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Sep 7, 2010 at 7:35 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> > On Mon, =A06 Sep 2010 22:35:23 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/cifsencrypt.c | =A0 33 ++++++++++++--------
> >> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 =A02 +-
> >> =A0fs/cifs/cifsproto.h =A0 | =A0 =A02 +-
> >> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 80 ++++++++++++++++++++++++=
+++++++++---------------
> >> =A0fs/cifs/transport.c =A0 | =A0 =A06 ++--
> >> =A05 files changed, 80 insertions(+), 43 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> >> index 5f0fc6b..5fbd19b 100644
> >> --- a/fs/cifs/cifsencrypt.c
> >> +++ b/fs/cifs/cifsencrypt.c
> >> @@ -80,7 +80,7 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, stru=
ct TCP_Server_Info *server,
> >> =A0 =A0 =A0 server->sequence_number++;
> >> =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
> >>
> >> - =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, &server->mac_s=
igning_key,
> >> + =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, &server->sessi=
on_key,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 smb_signature);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(cifs_pdu->Signature.SecuritySig=
nature, 0, 8);
> >> @@ -147,7 +147,7 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec=
, struct TCP_Server_Info *server,
> >> =A0 =A0 =A0 server->sequence_number++;
> >> =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
> >>
> >> - =A0 =A0 rc =3D cifs_calc_signature2(iov, n_vec, &server->mac_sig=
ning_key,
> >> + =A0 =A0 rc =3D cifs_calc_signature2(iov, n_vec, &server->session=
_key,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 smb_signature);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(cifs_pdu->Signature.SecuritySig=
nature, 0, 8);
> >> @@ -211,7 +211,7 @@ int cifs_verify_signature(struct smb_hdr *cifs=
_pdu,
> >> =A0}
> >>
> >> =A0/* We fill in key by putting in 40 byte array which was allocat=
ed by caller */
> >> -int cifs_calculate_mac_key(struct session_key *key, const char *r=
n,
> >> +int cifs_calculate_session_key(struct session_key *key, const cha=
r *rn,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *pas=
sword)
> >> =A0{
> >> =A0 =A0 =A0 char temp_key[16];
> >> @@ -319,7 +319,7 @@ static int calc_ntlmv2_hash(struct cifsSesInfo=
 *ses,
> >> =A0{
> >> =A0 =A0 =A0 int rc =3D 0;
> >> =A0 =A0 =A0 int len;
> >> - =A0 =A0 char nt_hash[16];
> >> + =A0 =A0 char nt_hash[CIFS_NTHASH_SIZE];
> >> =A0 =A0 =A0 struct HMACMD5Context *pctxt;
> >> =A0 =A0 =A0 wchar_t *user;
> >> =A0 =A0 =A0 wchar_t *domain;
> >> @@ -377,7 +377,7 @@ int
> >> =A0setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *nl=
s_cp)
> >> =A0{
> >> - =A0 =A0 int rc;
> >> + =A0 =A0 int rc =3D 0;
> >> =A0 =A0 =A0 struct ntlmv2_resp *buf =3D (struct ntlmv2_resp *)resp=
_buf;
> >> =A0 =A0 =A0 struct HMACMD5Context context;
> >>
> >> @@ -404,11 +404,11 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, ch=
ar *resp_buf,
> >> =A0 =A0 =A0 /* now calculate the MAC key for NTLMv2 */
> >> =A0 =A0 =A0 hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16,=
 &context);
> >> =A0 =A0 =A0 hmac_md5_update(resp_buf, 16, &context);
> >> - =A0 =A0 hmac_md5_final(ses->server->mac_signing_key.data.ntlmv2.=
key, &context);
> >> + =A0 =A0 hmac_md5_final(ses->server->session_key.data.ntlmv2.key,=
 &context);
> >>
> >> - =A0 =A0 memcpy(&ses->server->mac_signing_key.data.ntlmv2.resp, r=
esp_buf,
> >> + =A0 =A0 memcpy(&ses->server->session_key.data.ntlmv2.resp, resp_=
buf,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct ntlmv2_resp));
> >> - =A0 =A0 ses->server->mac_signing_key.len =3D 16 + sizeof(struct =
ntlmv2_resp);
> >> + =A0 =A0 ses->server->session_key.len =3D 16 + sizeof(struct ntlm=
v2_resp);
> >>
> >> =A0 =A0 =A0 return rc;
> >> =A0}
> >> @@ -418,11 +418,18 @@ void CalcNTLMv2_response(const struct cifsSe=
sInfo *ses,
> >> =A0{
> >> =A0 =A0 =A0 struct HMACMD5Context context;
> >> =A0 =A0 =A0 /* rest of v2 struct already generated */
> >> - =A0 =A0 memcpy(v2_session_response + 8, ses->server->cryptKey, 8=
);
> >> - =A0 =A0 hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &=
context);
> >> -
> >> - =A0 =A0 hmac_md5_update(v2_session_response+8,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct ntlmv2_res=
p) - 8, &context);
> >> + =A0 =A0 memcpy(v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ses->server->cryptKey, CIFS_SERVER_CHALL=
ENGE_SIZE);
> >> + =A0 =A0 hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 CIFS_HMAC_MD5_HASH_SIZE, &context);
> >> +
> >> + =A0 =A0 hmac_md5_update(v2_session_response + CIFS_SERVER_CHALLE=
NGE_SIZE,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct ntlmv2_resp) - CIFS_SERVER=
_CHALLENGE_SIZE,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 &context);
> >> +
> >> + =A0 =A0 if (ses->server->tilen)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 hmac_md5_update(ses->server->tiblob,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tilen, &con=
text);
> >>
> >> =A0 =A0 =A0 hmac_md5_final(v2_session_response, &context);
> >> =A0/* =A0 cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32);=
 */
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index 6b7249e..f67a5d7 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -201,7 +201,7 @@ struct TCP_Server_Info {
> >> =A0 =A0 =A0 /* 16th byte of RFC1001 workstation name is always nul=
l */
> >> =A0 =A0 =A0 char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NU=
LL];
> >> =A0 =A0 =A0 __u32 sequence_number; /* needed for CIFS PDU signatur=
e */
> >> - =A0 =A0 struct session_key mac_signing_key;
> >> + =A0 =A0 struct session_key session_key;
> >> =A0 =A0 =A0 char ntlmv2_hash[16];
> >> =A0 =A0 =A0 unsigned long lstrp; /* when we got last response from=
 this server */
> >> =A0 =A0 =A0 u16 dialect; /* dialect index that server chose */
> >> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> >> index ccc6d57..d1b9bc4 100644
> >> --- a/fs/cifs/cifsproto.h
> >> +++ b/fs/cifs/cifsproto.h
> >> @@ -363,7 +363,7 @@ extern int cifs_sign_smb2(struct kvec *iov, in=
t n_vec, struct TCP_Server_Info *,
> >> =A0extern int cifs_verify_signature(struct smb_hdr *,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0con=
st struct session_key *session_key,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 =
expected_sequence_number);
> >> -extern int cifs_calculate_mac_key(struct session_key *key, const =
char *rn,
> >> +extern int cifs_calculate_session_key(struct session_key *key, co=
nst char *rn,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0con=
st char *pass);
> >> =A0extern int CalcNTLMv2_partial_mac_key(struct cifsSesInfo *,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table=
 *);
> >> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> >> index 6551b17..f7fc3dc 100644
> >> --- a/fs/cifs/sess.c
> >> +++ b/fs/cifs/sess.c
> >> @@ -442,7 +442,7 @@ static void build_ntlmssp_negotiate_blob(unsig=
ned char *pbuffer,
> >> =A0 =A0 =A0 /* BB is NTLMV2 session security format easier to use =
here? */
> >> =A0 =A0 =A0 flags =3D NTLMSSP_NEGOTIATE_56 | =A0NTLMSSP_REQUEST_TA=
RGET |
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTI=
ATE_UNICODE |
> >> - =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGO=
TIATE_NTLM;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
> >> =A0 =A0 =A0 if (ses->server->secMode &
> >> =A0 =A0 =A0 =A0 =A0(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_SIGN;
> >> @@ -468,10 +468,12 @@ static int build_ntlmssp_auth_blob(unsigned =
char *pbuffer,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
struct cifsSesInfo *ses,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
const struct nls_table *nls_cp, bool first)
> >> =A0{
> >> + =A0 =A0 int rc;
> >> + =A0 =A0 unsigned int size;
> >> =A0 =A0 =A0 AUTHENTICATE_MESSAGE *sec_blob =3D (AUTHENTICATE_MESSA=
GE *)pbuffer;
> >> =A0 =A0 =A0 __u32 flags;
> >> =A0 =A0 =A0 unsigned char *tmp;
> >> - =A0 =A0 char ntlm_session_key[CIFS_SESS_KEY_SIZE];
> >> + =A0 =A0 struct ntlmv2_resp ntlmv2_response =3D {};
> >>
> >> =A0 =A0 =A0 memcpy(sec_blob->Signature, NTLMSSP_SIGNATURE, 8);
> >> =A0 =A0 =A0 sec_blob->MessageType =3D NtLmAuthenticate;
> >> @@ -479,7 +481,7 @@ static int build_ntlmssp_auth_blob(unsigned ch=
ar *pbuffer,
> >> =A0 =A0 =A0 flags =3D NTLMSSP_NEGOTIATE_56 |
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_REQUEST_TARGET | NTLMSSP_NEGOT=
IATE_TARGET_INFO |
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTI=
ATE_UNICODE |
> >> - =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGO=
TIATE_NTLM;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
> >> =A0 =A0 =A0 if (ses->server->secMode &
> >> =A0 =A0 =A0 =A0 =A0(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_SIGN;
> >> @@ -494,19 +496,25 @@ static int build_ntlmssp_auth_blob(unsigned =
char *pbuffer,
> >> =A0 =A0 =A0 sec_blob->LmChallengeResponse.Length =3D 0;
> >> =A0 =A0 =A0 sec_blob->LmChallengeResponse.MaximumLength =3D 0;
> >>
> >> - =A0 =A0 /* calculate session key, =A0BB what about adding simila=
r ntlmv2 path? */
> >> - =A0 =A0 SMBNTencrypt(ses->password, ses->server->cryptKey, ntlm_=
session_key);
> >> - =A0 =A0 if (first)
> >> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_calculate_mac_key(&ses->server->mac=
_signing_key,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0ntlm_session_key, ses->password);
> >> -
> >> - =A0 =A0 memcpy(tmp, ntlm_session_key, CIFS_SESS_KEY_SIZE);
> >> =A0 =A0 =A0 sec_blob->NtChallengeResponse.BufferOffset =3D cpu_to_=
le32(tmp - pbuffer);
> >> - =A0 =A0 sec_blob->NtChallengeResponse.Length =3D cpu_to_le16(CIF=
S_SESS_KEY_SIZE);
> >> - =A0 =A0 sec_blob->NtChallengeResponse.MaximumLength =3D
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_l=
e16(CIFS_SESS_KEY_SIZE);
> >> + =A0 =A0 rc =3D setup_ntlmv2_rsp(ses, (char *)&ntlmv2_response, n=
ls_cp);
> >> + =A0 =A0 if (rc) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "error rc: %d during ntlmssp n=
tlmv2 setup", rc);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 goto setup_ntlmv2_ret;
> >> + =A0 =A0 }
> >> + =A0 =A0 size =3D =A0sizeof(struct ntlmv2_resp);
> >> + =A0 =A0 memcpy(tmp, (char *)&ntlmv2_response, size);
> >> + =A0 =A0 tmp +=3D size;
> >> + =A0 =A0 if (ses->server->tilen > 0) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(tmp, ses->server->tiblob, ses->se=
rver->tilen);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 tmp +=3D ses->server->tilen;
> >> + =A0 =A0 } else
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tilen =3D 0;
> >>
> >> - =A0 =A0 tmp +=3D CIFS_SESS_KEY_SIZE;
> >> + =A0 =A0 sec_blob->NtChallengeResponse.Length =3D cpu_to_le16(siz=
e +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tilen);
> >> + =A0 =A0 sec_blob->NtChallengeResponse.MaximumLength =3D
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(size + ses->=
server->tilen);
> >>
> >> =A0 =A0 =A0 if (ses->domainName =3D=3D NULL) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.BufferOffset =3D =
cpu_to_le32(tmp - pbuffer);
> >> @@ -518,7 +526,6 @@ static int build_ntlmssp_auth_blob(unsigned ch=
ar *pbuffer,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)tmp, s=
es->domainName,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 MAX_USERNAME_SIZE, nls_cp);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len *=3D 2; /* unicode is 2 bytes each=
 */
> >> - =A0 =A0 =A0 =A0 =A0 =A0 len +=3D 2; /* trailing null */
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.BufferOffset =3D =
cpu_to_le32(tmp - pbuffer);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.Length =3D cpu_to=
_le16(len);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.MaximumLength =3D=
 cpu_to_le16(len);
> >> @@ -535,7 +542,6 @@ static int build_ntlmssp_auth_blob(unsigned ch=
ar *pbuffer,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)tmp, s=
es->userName,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 MAX_USERNAME_SIZE, nls_cp);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len *=3D 2; /* unicode is 2 bytes each=
 */
> >> - =A0 =A0 =A0 =A0 =A0 =A0 len +=3D 2; /* trailing null */
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.BufferOffset =3D cp=
u_to_le32(tmp - pbuffer);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.Length =3D cpu_to_l=
e16(len);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.MaximumLength =3D c=
pu_to_le16(len);
> >> @@ -551,6 +557,7 @@ static int build_ntlmssp_auth_blob(unsigned ch=
ar *pbuffer,
> >> =A0 =A0 =A0 sec_blob->SessionKey.Length =3D 0;
> >> =A0 =A0 =A0 sec_blob->SessionKey.MaximumLength =3D 0;
> >>
> >> +setup_ntlmv2_ret:
> >> =A0 =A0 =A0 if (ses->server->tilen > 0)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(ses->server->tiblob);
> >>
> >> @@ -567,15 +574,14 @@ static void setup_ntlmssp_neg_req(SESSION_SE=
TUP_ANDX *pSMB,
> >> =A0 =A0 =A0 return;
> >> =A0}
> >>
> >> -static int setup_ntlmssp_auth_req(SESSION_SETUP_ANDX *pSMB,
> >> +static int setup_ntlmssp_auth_req(char *ntlmsspblob,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 st=
ruct cifsSesInfo *ses,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 co=
nst struct nls_table *nls, bool first_time)
> >> =A0{
> >> =A0 =A0 =A0 int bloblen;
> >>
> >> - =A0 =A0 bloblen =3D build_ntlmssp_auth_blob(&pSMB->req.SecurityB=
lob[0], ses, nls,
> >> + =A0 =A0 bloblen =3D build_ntlmssp_auth_blob(ntlmsspblob, ses, nl=
s,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 first_time);
> >> - =A0 =A0 pSMB->req.SecurityBlobLength =3D cpu_to_le16(bloblen);
> >>
> >> =A0 =A0 =A0 return bloblen;
> >> =A0}
> >> @@ -711,7 +717,7 @@ ssetup_ntlmssp_authenticate:
> >>
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (first_time) /* should this be move=
d into common code
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wi=
th similar ntlmv2 path? */
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_calculate_mac_key(&=
ses->server->mac_signing_key,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_calculate_session_k=
ey(&ses->server->session_key,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntlm_s=
ession_key, ses->password);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* copy session key */
> >>
> >> @@ -751,10 +757,19 @@ ssetup_ntlmssp_authenticate:
> >>
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* calculate session key */
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D setup_ntlmv2_rsp(ses, v2_sess_k=
ey, nls_cp);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(v2_sess_key);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, (char *)v2_sess_key,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct ntlmv2_re=
sp));
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D sizeof(struct ntlmv2_resp=
);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(v2_sess_key);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (ses->server->tilen > 0) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, ses->ser=
ver->tiblob,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->ser=
ver->tilen);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D ses->server=
->tilen;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->capabilities & CAP_UNICODE) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (iov[0].iov_len % 2=
) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *bcc_p=
tr =3D 0;
> >> @@ -785,15 +800,15 @@ ssetup_ntlmssp_authenticate:
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* bail out if key is too long */
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (msg->sesskey_len >
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(ses->server->mac_signing_=
key.data.krb5)) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(ses->server->session_key.=
data.krb5)) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Kerberos si=
gning key too long (%u bytes)",
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msg->s=
esskey_len);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EOVERFLOW;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (first_time) {
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->mac_signing=
_key.len =3D msg->sesskey_len;
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->server->mac_=
signing_key.data.krb5,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->session_key=
=2Elen =3D msg->sesskey_len;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->server->sess=
ion_key.data.krb5,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msg->d=
ata, msg->sesskey_len);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req.hdr.Flags2 |=3D SMBFLG2_EXT_=
SEC;
> >> @@ -835,12 +850,28 @@ ssetup_ntlmssp_authenticate:
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (phase =3D=3D NtLmN=
egotiate) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 setup_=
ntlmssp_neg_req(pSMB, ses);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1]=
=2Eiov_len =3D sizeof(NEGOTIATE_MESSAGE);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].i=
ov_base =3D &pSMB->req.SecurityBlob[0];
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (phase =3D=3D=
 NtLmAuthenticate) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int bl=
ob_len;
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blob_len=
 =3D setup_ntlmssp_auth_req(pSMB, ses,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *nt=
lmsspblob;
> >> +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntlmsspb=
lob =3D kmalloc(5 *
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0Why 5 here?
> >
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 sizeof(struct _AUTHENTICATE_MESSAGE),
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 GFP_KERNEL);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ntl=
msspblob) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 cERROR(1, "Can't allocate NTLMSSP");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 rc =3D -ENOMEM;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 goto ssetup_exit;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blob_len=
 =3D setup_ntlmssp_auth_req(ntlmsspblob,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nls_cp,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 first_time=
);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1]=
=2Eiov_len =3D blob_len;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].i=
ov_base =3D ntlmsspblob;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->re=
q.SecurityBlobLength =3D
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 cpu_to_le16(blob_len);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Mak=
e sure that we tell the server that we
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
are using the uid that it just gave us back
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
on the response (challenge) */
> >> @@ -850,7 +881,6 @@ ssetup_ntlmssp_authenticate:
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D=
 -ENOSYS;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto s=
setup_exit;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov_base =3D &pSM=
B->req.SecurityBlob[0];
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* unicode strings mus=
t be word aligned */
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((iov[0].iov_len + =
iov[1].iov_len) % 2) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *bcc_p=
tr =3D 0;
> >> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> >> index 82f78c4..a66c91e 100644
> >> --- a/fs/cifs/transport.c
> >> +++ b/fs/cifs/transport.c
> >> @@ -543,7 +543,7 @@ SendReceive2(const unsigned int xid, struct ci=
fsSesInfo *ses,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (ses->server->secMode & (SECMO=
DE_SIGN_REQUIRED |
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0SECMODE_SIGN_ENABLED))) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_verify_sig=
nature(midQ->resp_buf,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 &ses->server->mac_signing_key,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 &ses->server->session_key,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 midQ->sequence_number+1);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR=
(1, "Unexpected SMB signature");
> >> @@ -731,7 +731,7 @@ SendReceive(const unsigned int xid, struct cif=
sSesInfo *ses,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (ses->server->secMode & (SECMO=
DE_SIGN_REQUIRED |
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0SECMODE_SIGN_ENABLED))) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_verify_sig=
nature(out_buf,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 &ses->server->mac_signing_key,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 &ses->server->session_key,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 midQ->sequence_number+1);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR=
(1, "Unexpected SMB signature");
> >> @@ -981,7 +981,7 @@ SendReceiveBlockingLock(const unsigned int xid=
, struct cifsTconInfo *tcon,
> >> =A0 =A0 =A0 =A0 =A0 (ses->server->secMode & (SECMODE_SIGN_REQUIRED=
 |
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0SECMODE_SIGN_ENABLED))) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_verify_signature(out_buf,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0&ses->server->mac_signing_key,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0&ses->server->session_key,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0midQ->sequence_number+1);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Unexpected =
SMB signature");
> >
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >
>=20
> An empirical value, that is good enough to hold even if we had all 10=
 fields
> in AV pairs/Target Info.  Even if we decide to include LM2 key (for
> whatever reason
> like passthrough authentication, if at all), that size would be good =
enough.
>=20

That deserves a comment in the code.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
