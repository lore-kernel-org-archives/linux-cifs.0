From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -v2 2/6] ntlmv2/ntlmssp ntlmssp autentication code
Date: Sun, 12 Sep 2010 20:59:46 -0500
Message-ID: <AANLkTintaxP-BGTRWH-3GmYERvM7g_WYXYYT0StZJaGj@mail.gmail.com>
References: <1284055960-792-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100912085214.08fea91e@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100912085214.08fea91e-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Sep 12, 2010 at 7:52 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Thu, =A09 Sep 2010 13:12:40 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> To calculate ntlmv2 response we need ti/av pair blob.
>>
>> For sec mech like ntlmssp, the blob is plucked from type 2 response =
from
>> the server. =A0From this blob, netbios name of the domain is retriev=
ed,
>> if user has not already provided, to be included in the Target Strin=
g
>> as part of ntlmv2 hash calculations.
>>
>> For sec mech like ntlmv2, create a minimal, two av pair blob.
>>
>> The allocated blob is freed in case of error. =A0In case there is no=
 error,
>> this blob is used in calculating ntlmv2 response (in CalcNTLMv2_resp=
onse)
>> and is also copied on the response to the server, and then freed.
>>
>> The type 3 ntlmssp response is prepared on a buffer,
>> 5 * sizeof of struct _AUTHENTICATE_MESSAGE, an empirical value large
>> enough to hold _AUTHENTICATE_MESSAGE plus a blob with max possible
>> 10 values as part of ntlmv2 response and lmv2 keys and domain, user,
>> workstation =A0names etc.
>>
>> Also, kerberos gets selected as a default mechanism if server suppor=
ts it,
>> over the other security mechanisms.
>>
>> The reason mac_key was changed to session key is, this structure doe=
s not hold
>> message authentication code, it holds the session key (for ntlmv2, n=
tlmv1 etc.).
>> mac is generated as a signature in cifs_calc* functions.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsencrypt.c | =A0 58 +++++++++++++++++++++++-------
>> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 =A04 +-
>> =A0fs/cifs/cifsproto.h =A0 | =A0 =A06 ++--
>> =A0fs/cifs/cifssmb.c =A0 =A0 | =A0 16 +++++----
>> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 93 ++++++++++++++++++++++++++=
++++++++--------------
>> =A0fs/cifs/transport.c =A0 | =A0 =A06 ++--
>> =A06 files changed, 128 insertions(+), 55 deletions(-)
>>
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index 346fb64..7e15cd0 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -43,7 +43,8 @@ extern void SMBencrypt(unsigned char *passwd, cons=
t unsigned char *c8,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned char *p24);
>>
>> =A0static int cifs_calculate_signature(const struct smb_hdr *cifs_pd=
u,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 co=
nst struct mac_key *key, char *signature)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 co=
nst struct session_key *key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 char *signature)
>> =A0{
>> =A0 =A0 =A0 struct =A0MD5Context context;
>>
>> @@ -79,7 +80,7 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct=
 TCP_Server_Info *server,
>> =A0 =A0 =A0 server->sequence_number++;
>> =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>>
>> - =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, &server->mac_sig=
ning_key,
>> + =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, &server->session=
_key,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 smb_signature);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(cifs_pdu->Signature.SecuritySigna=
ture, 0, 8);
>> @@ -90,7 +91,7 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct=
 TCP_Server_Info *server,
>> =A0}
>>
>> =A0static int cifs_calc_signature2(const struct kvec *iov, int n_vec=
,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const stru=
ct mac_key *key, char *signature)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const stru=
ct session_key *key, char *signature)
>> =A0{
>> =A0 =A0 =A0 struct =A0MD5Context context;
>> =A0 =A0 =A0 int i;
>> @@ -146,7 +147,7 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, =
struct TCP_Server_Info *server,
>> =A0 =A0 =A0 server->sequence_number++;
>> =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>>
>> - =A0 =A0 rc =3D cifs_calc_signature2(iov, n_vec, &server->mac_signi=
ng_key,
>> + =A0 =A0 rc =3D cifs_calc_signature2(iov, n_vec, &server->session_k=
ey,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 smb_signature);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(cifs_pdu->Signature.SecuritySigna=
ture, 0, 8);
>> @@ -157,14 +158,14 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec=
, struct TCP_Server_Info *server,
>> =A0}
>>
>> =A0int cifs_verify_signature(struct smb_hdr *cifs_pdu,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct mac_key *=
mac_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct session_k=
ey *session_key,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 expected_seque=
nce_number)
>> =A0{
>> =A0 =A0 =A0 unsigned int rc;
>> =A0 =A0 =A0 char server_response_sig[8];
>> =A0 =A0 =A0 char what_we_think_sig_should_be[20];
>>
>> - =A0 =A0 if ((cifs_pdu =3D=3D NULL) || (mac_key =3D=3D NULL))
>> + =A0 =A0 if (cifs_pdu =3D=3D NULL || session_key =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>>
>> =A0 =A0 =A0 if (cifs_pdu->Command =3D=3D SMB_COM_NEGOTIATE)
>> @@ -193,7 +194,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_p=
du,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 cpu_to_le32(expected_sequence_number);
>> =A0 =A0 =A0 cifs_pdu->Signature.Sequence.Reserved =3D 0;
>>
>> - =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, mac_key,
>> + =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, session_key,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 what_we_think_sig_should_be);
>>
>> =A0 =A0 =A0 if (rc)
>> @@ -210,7 +211,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_p=
du,
>> =A0}
>>
>> =A0/* We fill in key by putting in 40 byte array which was allocated=
 by caller */
>> -int cifs_calculate_mac_key(struct mac_key *key, const char *rn,
>> +int cifs_calculate_session_key(struct session_key *key, const char =
*rn,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *passw=
ord)
>> =A0{
>> =A0 =A0 =A0 char temp_key[16];
>> @@ -395,7 +396,8 @@ calc_exit_2:
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> -void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
>> +int
>> +setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *nls_=
cp)
>> =A0{
>> =A0 =A0 =A0 int rc;
>> @@ -408,20 +410,46 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses,=
 char *resp_buf,
>> =A0 =A0 =A0 get_random_bytes(&buf->client_chal, sizeof(buf->client_c=
hal));
>> =A0 =A0 =A0 buf->reserved2 =3D 0;
>>
>> + =A0 =A0 if (ses->server->secType =3D=3D RawNTLMSSP) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->domainName) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D find_domain_name(se=
s);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, =
"error %d finding domain name", rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto setup=
_ntlmv2_rsp_ret;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D build_avpair_blob(ses);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "error %d buildi=
ng av pair blob", rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 /* calculate buf->ntlmv2_hash */
>> =A0 =A0 =A0 rc =3D calc_ntlmv2_hash(ses, nls_cp);
>> - =A0 =A0 if (rc)
>> + =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not get v2 hash rc %d",=
 rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto setup_ntlmv2_rsp_ret;
>> + =A0 =A0 }
>> =A0 =A0 =A0 CalcNTLMv2_response(ses, resp_buf);
>>
>> =A0 =A0 =A0 /* now calculate the MAC key for NTLMv2 */
>> =A0 =A0 =A0 hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &=
context);
>> =A0 =A0 =A0 hmac_md5_update(resp_buf, 16, &context);
>> - =A0 =A0 hmac_md5_final(ses->server->mac_signing_key.data.ntlmv2.ke=
y, &context);
>> + =A0 =A0 hmac_md5_final(ses->server->session_key.data.ntlmv2.key, &=
context);
>>
>> - =A0 =A0 memcpy(&ses->server->mac_signing_key.data.ntlmv2.resp, res=
p_buf,
>> + =A0 =A0 memcpy(&ses->server->session_key.data.ntlmv2.resp, resp_bu=
f,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct ntlmv2_resp));
>> - =A0 =A0 ses->server->mac_signing_key.len =3D 16 + sizeof(struct nt=
lmv2_resp);
>> + =A0 =A0 ses->server->session_key.len =3D 16 + sizeof(struct ntlmv2=
_resp);
>> +
>> + =A0 =A0 return 0;
>> +
>> +setup_ntlmv2_rsp_ret:
>> + =A0 =A0 kfree(ses->tiblob);
>> + =A0 =A0 ses->tilen =3D 0;
>> +
>> + =A0 =A0 return rc;
>> =A0}
>>
>> =A0void CalcNTLMv2_response(const struct cifsSesInfo *ses,
>> @@ -435,6 +463,10 @@ void CalcNTLMv2_response(const struct cifsSesIn=
fo *ses,
>> =A0 =A0 =A0 hmac_md5_update(v2_session_response+8,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct ntlmv2_res=
p) - 8, &context);
>>
>> + =A0 =A0 if (ses->tilen)
>> + =A0 =A0 =A0 =A0 =A0 =A0 hmac_md5_update(ses->tiblob,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tilen, &context);
>> +
>> =A0 =A0 =A0 hmac_md5_final(v2_session_response, &context);
>> =A0/* =A0 cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); *=
/
>> =A0}
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 2bfe682..c68f31c 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -97,7 +97,7 @@ enum protocolEnum {
>> =A0 =A0 =A0 /* Netbios frames protocol not supported at this time */
>> =A0};
>>
>> -struct mac_key {
>> +struct session_key {
>> =A0 =A0 =A0 unsigned int len;
>> =A0 =A0 =A0 union {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 char ntlm[CIFS_SESS_KEY_SIZE + 16];
>> @@ -182,7 +182,7 @@ struct TCP_Server_Info {
>> =A0 =A0 =A0 /* 16th byte of RFC1001 workstation name is always null =
*/
>> =A0 =A0 =A0 char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL=
];
>> =A0 =A0 =A0 __u32 sequence_number; /* needed for CIFS PDU signature =
*/
>> - =A0 =A0 struct mac_key mac_signing_key;
>> + =A0 =A0 struct session_key session_key;
>> =A0 =A0 =A0 char ntlmv2_hash[16];
>> =A0 =A0 =A0 unsigned long lstrp; /* when we got last response from t=
his server */
>> =A0 =A0 =A0 u16 dialect; /* dialect index that server chose */
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 1d60c65..c155479 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -362,12 +362,12 @@ extern int cifs_sign_smb(struct smb_hdr *, str=
uct TCP_Server_Info *, __u32 *);
>> =A0extern int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP=
_Server_Info *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 *);
>> =A0extern int cifs_verify_signature(struct smb_hdr *,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const s=
truct mac_key *mac_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const s=
truct session_key *session_key,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 ex=
pected_sequence_number);
>> -extern int cifs_calculate_mac_key(struct mac_key *key, const char *=
rn,
>> +extern int cifs_calculate_session_key(struct session_key *key, cons=
t char *rn,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const=
 char *pass);
>> =A0extern void CalcNTLMv2_response(const struct cifsSesInfo *, char =
*);
>> -extern void setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
>> +extern int setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct =
nls_table *);
>> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> =A0extern void calc_lanman_hash(const char *password, const char *cr=
yptkey,
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index c65c341..13c854e 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -603,13 +603,15 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs=
SesInfo *ses)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -=
EINVAL;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->sec_kerberos |=
| server->sec_mskerberos)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->se=
cType =3D Kerberos;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (server->sec_ntlms=
sp)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->se=
cType =3D RawNTLMSSP;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EO=
PNOTSUPP;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->secType =3D=3D=
 Kerberos) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!serve=
r->sec_kerberos &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 !server->sec_mskerberos)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 rc =3D -EOPNOTSUPP;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (server->secType=
 =3D=3D RawNTLMSSP) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!serve=
r->sec_ntlmssp)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 rc =3D -EOPNOTSUPP;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 rc =3D -EOPNOTSUPP;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^^^
> =A0 =A0 =A0 =A0This was a separate patch before. It probably ought to=
 remain
> =A0 =A0 =A0 =A0one.

This was added here because without this patch, sec=3Dntlmsspi option w=
ould fail
against a server like Windows 2003, so it seemed logical to make this
change here,
along with other authentication specific changes.

>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 } else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->capabilities &=3D ~CAP_EXTENDED_=
SECURITY;
>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> index 2de5f08..8f44fde 100644
>> --- a/fs/cifs/sess.c
>> +++ b/fs/cifs/sess.c
>> @@ -440,7 +440,7 @@ static void build_ntlmssp_negotiate_blob(unsigne=
d char *pbuffer,
>> =A0 =A0 =A0 /* BB is NTLMV2 session security format easier to use he=
re? */
>> =A0 =A0 =A0 flags =3D NTLMSSP_NEGOTIATE_56 | =A0NTLMSSP_REQUEST_TARG=
ET |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIAT=
E_UNICODE |
>> - =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGOTI=
ATE_NTLM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
>> =A0 =A0 =A0 if (ses->server->secMode &
>> =A0 =A0 =A0 =A0 =A0(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_SIGN;
>> @@ -466,10 +466,12 @@ static int build_ntlmssp_auth_blob(unsigned ch=
ar *pbuffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0s=
truct cifsSesInfo *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0c=
onst struct nls_table *nls_cp, bool first)
>> =A0{
>> + =A0 =A0 int rc;
>> + =A0 =A0 unsigned int size;
>> =A0 =A0 =A0 AUTHENTICATE_MESSAGE *sec_blob =3D (AUTHENTICATE_MESSAGE=
 *)pbuffer;
>> =A0 =A0 =A0 __u32 flags;
>> =A0 =A0 =A0 unsigned char *tmp;
>> - =A0 =A0 char ntlm_session_key[CIFS_SESS_KEY_SIZE];
>> + =A0 =A0 struct ntlmv2_resp ntlmv2_response =3D {};
>>
>> =A0 =A0 =A0 memcpy(sec_blob->Signature, NTLMSSP_SIGNATURE, 8);
>> =A0 =A0 =A0 sec_blob->MessageType =3D NtLmAuthenticate;
>> @@ -477,7 +479,7 @@ static int build_ntlmssp_auth_blob(unsigned char=
 *pbuffer,
>> =A0 =A0 =A0 flags =3D NTLMSSP_NEGOTIATE_56 |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_REQUEST_TARGET | NTLMSSP_NEGOTIA=
TE_TARGET_INFO |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIAT=
E_UNICODE |
>> - =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGOTI=
ATE_NTLM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP_NEGOTIATE_NTLM;
>> =A0 =A0 =A0 if (ses->server->secMode &
>> =A0 =A0 =A0 =A0 =A0(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_SIGN;
>> @@ -492,19 +494,26 @@ static int build_ntlmssp_auth_blob(unsigned ch=
ar *pbuffer,
>> =A0 =A0 =A0 sec_blob->LmChallengeResponse.Length =3D 0;
>> =A0 =A0 =A0 sec_blob->LmChallengeResponse.MaximumLength =3D 0;
>>
>> - =A0 =A0 /* calculate session key, =A0BB what about adding similar =
ntlmv2 path? */
>> - =A0 =A0 SMBNTencrypt(ses->password, ses->server->cryptKey, ntlm_se=
ssion_key);
>> - =A0 =A0 if (first)
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_calculate_mac_key(&ses->server->mac_s=
igning_key,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0ntlm_session_key, ses->password);
>> -
>> - =A0 =A0 memcpy(tmp, ntlm_session_key, CIFS_SESS_KEY_SIZE);
>> =A0 =A0 =A0 sec_blob->NtChallengeResponse.BufferOffset =3D cpu_to_le=
32(tmp - pbuffer);
>> - =A0 =A0 sec_blob->NtChallengeResponse.Length =3D cpu_to_le16(CIFS_=
SESS_KEY_SIZE);
>> - =A0 =A0 sec_blob->NtChallengeResponse.MaximumLength =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le1=
6(CIFS_SESS_KEY_SIZE);
>> + =A0 =A0 rc =3D setup_ntlmv2_rsp(ses, (char *)&ntlmv2_response, nls=
_cp);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error %d during NTLMSSP authent=
ication", rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto setup_ntlmv2_ret;
>> + =A0 =A0 }
>> + =A0 =A0 size =3D =A0sizeof(struct ntlmv2_resp);
>> + =A0 =A0 memcpy(tmp, (char *)&ntlmv2_response, size);
>> + =A0 =A0 tmp +=3D size;
>> + =A0 =A0 if (ses->tilen > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(tmp, ses->tiblob, ses->tilen);
>> + =A0 =A0 =A0 =A0 =A0 =A0 tmp +=3D ses->tilen;
>> + =A0 =A0 }
>>
>> - =A0 =A0 tmp +=3D CIFS_SESS_KEY_SIZE;
>> + =A0 =A0 sec_blob->NtChallengeResponse.Length =3D cpu_to_le16(size =
+
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tilen);
>> + =A0 =A0 sec_blob->NtChallengeResponse.MaximumLength =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(size + ses->ti=
len);
>> + =A0 =A0 kfree(ses->tiblob);
>> + =A0 =A0 ses->tilen =3D 0;
>>
>> =A0 =A0 =A0 if (ses->domainName =3D=3D NULL) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.BufferOffset =3D cp=
u_to_le32(tmp - pbuffer);
>> @@ -516,7 +525,6 @@ static int build_ntlmssp_auth_blob(unsigned char=
 *pbuffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)tmp, ses=
->domainName,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
MAX_USERNAME_SIZE, nls_cp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len *=3D 2; /* unicode is 2 bytes each *=
/
>> - =A0 =A0 =A0 =A0 =A0 =A0 len +=3D 2; /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.BufferOffset =3D cp=
u_to_le32(tmp - pbuffer);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.Length =3D cpu_to_l=
e16(len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->DomainName.MaximumLength =3D c=
pu_to_le16(len);
>> @@ -533,7 +541,6 @@ static int build_ntlmssp_auth_blob(unsigned char=
 *pbuffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)tmp, ses=
->userName,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
MAX_USERNAME_SIZE, nls_cp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len *=3D 2; /* unicode is 2 bytes each *=
/
>> - =A0 =A0 =A0 =A0 =A0 =A0 len +=3D 2; /* trailing null */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.BufferOffset =3D cpu_=
to_le32(tmp - pbuffer);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.Length =3D cpu_to_le1=
6(len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->UserName.MaximumLength =3D cpu=
_to_le16(len);
>> @@ -548,6 +555,8 @@ static int build_ntlmssp_auth_blob(unsigned char=
 *pbuffer,
>> =A0 =A0 =A0 sec_blob->SessionKey.BufferOffset =3D cpu_to_le32(tmp - =
pbuffer);
>> =A0 =A0 =A0 sec_blob->SessionKey.Length =3D 0;
>> =A0 =A0 =A0 sec_blob->SessionKey.MaximumLength =3D 0;
>> +
>> +setup_ntlmv2_ret:
>> =A0 =A0 =A0 return tmp - pbuffer;
>> =A0}
>>
>> @@ -561,15 +570,14 @@ static void setup_ntlmssp_neg_req(SESSION_SETU=
P_ANDX *pSMB,
>> =A0 =A0 =A0 return;
>> =A0}
>>
>> -static int setup_ntlmssp_auth_req(SESSION_SETUP_ANDX *pSMB,
>> +static int setup_ntlmssp_auth_req(char *ntlmsspblob,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stru=
ct cifsSesInfo *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cons=
t struct nls_table *nls, bool first_time)
>> =A0{
>> =A0 =A0 =A0 int bloblen;
>>
>> - =A0 =A0 bloblen =3D build_ntlmssp_auth_blob(&pSMB->req.SecurityBlo=
b[0], ses, nls,
>> + =A0 =A0 bloblen =3D build_ntlmssp_auth_blob(ntlmsspblob, ses, nls,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 first_time);
>> - =A0 =A0 pSMB->req.SecurityBlobLength =3D cpu_to_le16(bloblen);
>>
>> =A0 =A0 =A0 return bloblen;
>> =A0}
>> @@ -705,7 +713,7 @@ ssetup_ntlmssp_authenticate:
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (first_time) /* should this be moved =
into common code
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 with=
 similar ntlmv2 path? */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_calculate_mac_key(&se=
s->server->mac_signing_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_calculate_session_key=
(&ses->server->session_key,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntlm_ses=
sion_key, ses->password);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* copy session key */
>>
>> @@ -744,12 +752,23 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(sizeof(struc=
t ntlmv2_resp));
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* calculate session key */
>> - =A0 =A0 =A0 =A0 =A0 =A0 setup_ntlmv2_rsp(ses, v2_sess_key, nls_cp)=
;
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* FIXME: calculate MAC key */
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D setup_ntlmv2_rsp(ses, v2_sess_key, =
nls_cp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error %d during=
 NTLMv2 authentication", rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(v2_sess_key);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, (char *)v2_sess_key,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct ntlmv2_resp=
));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D sizeof(struct ntlmv2_resp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(v2_sess_key);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (ses->tilen > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, ses->tiblo=
b,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tilen=
);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D ses->tilen;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(ses->tiblob);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tilen =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->capabilities & CAP_UNICODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (iov[0].iov_len % 2) =
{
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *bcc_ptr=
 =3D 0;
>> @@ -780,15 +799,15 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* bail out if key is too long */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (msg->sesskey_len >
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(ses->server->mac_signing_ke=
y.data.krb5)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(ses->server->session_key.da=
ta.krb5)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Kerberos sign=
ing key too long (%u bytes)",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msg->ses=
skey_len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EOVERFLOW;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (first_time) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->mac_signing_k=
ey.len =3D msg->sesskey_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->server->mac_si=
gning_key.data.krb5,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->session_key.l=
en =3D msg->sesskey_len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->server->sessio=
n_key.data.krb5,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msg->dat=
a, msg->sesskey_len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req.hdr.Flags2 |=3D SMBFLG2_EXT_SE=
C;
>> @@ -830,12 +849,33 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (phase =3D=3D NtLmNeg=
otiate) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 setup_nt=
lmssp_neg_req(pSMB, ses);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].i=
ov_len =3D sizeof(NEGOTIATE_MESSAGE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov=
_base =3D &pSMB->req.SecurityBlob[0];
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (phase =3D=3D =
NtLmAuthenticate) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int blob=
_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blob_len =3D=
 setup_ntlmssp_auth_req(pSMB, ses,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *ntlm=
sspblob;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* 5 is an=
 empirical value, large enought to
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* hold =
authenticate message, max 10 of
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* av pa=
ris, doamin,user,workstation mames,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* flags=
 etc..
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntlmsspblo=
b =3D kmalloc(5 *
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 sizeof(struct _AUTHENTICATE_MESSAGE),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 GFP_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ntlms=
spblob) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 cERROR(1, "Can't allocate NTLMSSP");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 rc =3D -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 goto ssetup_exit;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blob_len =3D=
 setup_ntlmssp_auth_req(ntlmsspblob,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nls_cp,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 first_time)=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].i=
ov_len =3D blob_len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov=
_base =3D ntlmsspblob;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req.=
SecurityBlobLength =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 cpu_to_le16(blob_len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Make =
sure that we tell the server that we
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0a=
re using the uid that it just gave us back
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0o=
n the response (challenge) */
>> @@ -845,7 +885,6 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -=
ENOSYS;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto sse=
tup_exit;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov_base =3D &pSMB-=
>req.SecurityBlob[0];
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* unicode strings must =
be word aligned */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((iov[0].iov_len + io=
v[1].iov_len) % 2) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *bcc_ptr=
 =3D 0;
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index 82f78c4..a66c91e 100644
>> --- a/fs/cifs/transport.c
>> +++ b/fs/cifs/transport.c
>> @@ -543,7 +543,7 @@ SendReceive2(const unsigned int xid, struct cifs=
SesInfo *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (ses->server->secMode & (SECMODE=
_SIGN_REQUIRED |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0SECMODE_SIGN_ENABLED))) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_verify_signa=
ture(midQ->resp_buf,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 &ses->server->mac_signing_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 &ses->server->session_key,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 midQ->sequence_number+1);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1=
, "Unexpected SMB signature");
>> @@ -731,7 +731,7 @@ SendReceive(const unsigned int xid, struct cifsS=
esInfo *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (ses->server->secMode & (SECMODE=
_SIGN_REQUIRED |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0SECMODE_SIGN_ENABLED))) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_verify_signa=
ture(out_buf,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 &ses->server->mac_signing_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 &ses->server->session_key,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 midQ->sequence_number+1);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1=
, "Unexpected SMB signature");
>> @@ -981,7 +981,7 @@ SendReceiveBlockingLock(const unsigned int xid, =
struct cifsTconInfo *tcon,
>> =A0 =A0 =A0 =A0 =A0 (ses->server->secMode & (SECMODE_SIGN_REQUIRED |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0SECMODE_SIGN_ENABLED))) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_verify_signature(out_buf,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0&ses->server->mac_signing_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0&ses->server->session_key,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0midQ->sequence_number+1);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Unexpected SM=
B signature");
>
>
> Would it be reasonable to split the simple mac_key to session_key
> rename part into a separate patch from the ones that actually change
> behavior?

OK. But I am not sure what we are trying to achieve here churning
these patches so
many times for a simple change.  Not sure who the audience is.

>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
