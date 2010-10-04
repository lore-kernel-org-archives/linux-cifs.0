From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/7 cifs] ntlm authentication and signing - Calculate auth
 response per smb session
Date: Mon, 4 Oct 2010 07:52:08 -0500
Message-ID: <AANLkTi=6gVCRSmpjDVz16qQN+CJK0VQqcy0PM0S7bDfc@mail.gmail.com>
References: <1285771177-23146-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101004070212.74b7968f@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101004070212.74b7968f-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Oct 4, 2010 at 6:02 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 29 Sep 2010 09:39:37 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Start calculation auth response within a session. =A0Move/Add pertin=
et
>> data structures like session key, server challenge and ntlmv2_hash i=
n
>> a session structure. =A0We should do the calculations within a sessi=
on
>> before copying session key and response over to server data
>> structures because a session setup can fail.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsencrypt.c | =A0 16 ++++++++--------
>> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 =A06 ++++--
>> =A0fs/cifs/cifssmb.c =A0 =A0 | =A0 =A04 ++--
>> =A0fs/cifs/connect.c =A0 =A0 | =A0 =A07 ++++---
>> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 17 ++++++++---------
>> =A05 files changed, 26 insertions(+), 24 deletions(-)
>>
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index 7ca9c80..0dda565 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -458,7 +458,7 @@ calc_exit_1:
>> =A0calc_exit_2:
>> =A0 =A0 =A0 /* BB FIXME what about bytes 24 through 40 of the signin=
g key?
>> =A0 =A0 =A0 =A0 =A0compare with the NTLM example */
>> - =A0 =A0 hmac_md5_final(ses->server->ntlmv2_hash, pctxt);
>> + =A0 =A0 hmac_md5_final(ses->ntlmv2_hash, pctxt);
>>
>> =A0 =A0 =A0 kfree(pctxt);
>> =A0 =A0 =A0 return rc;
>> @@ -502,14 +502,14 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, char=
 *resp_buf,
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 CalcNTLMv2_response(ses, resp_buf);
>>
>> - =A0 =A0 /* now calculate the MAC key for NTLMv2 */
>> - =A0 =A0 hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &co=
ntext);
>> + =A0 =A0 /* now calculate the session key for NTLMv2 */
>> + =A0 =A0 hmac_md5_init_limK_to_64(ses->ntlmv2_hash, 16, &context);
>> =A0 =A0 =A0 hmac_md5_update(resp_buf, 16, &context);
>> - =A0 =A0 hmac_md5_final(ses->server->session_key.data.ntlmv2.key, &=
context);
>> + =A0 =A0 hmac_md5_final(ses->auth_key.data.ntlmv2.key, &context);
>>
>> - =A0 =A0 memcpy(&ses->server->session_key.data.ntlmv2.resp, resp_bu=
f,
>> + =A0 =A0 memcpy(&ses->auth_key.data.ntlmv2.resp, resp_buf,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct ntlmv2_resp));
>> - =A0 =A0 ses->server->session_key.len =3D 16 + sizeof(struct ntlmv2=
_resp);
>> + =A0 =A0 ses->auth_key.len =3D 16 + sizeof(struct ntlmv2_resp);
>>
>> =A0 =A0 =A0 return 0;
>>
>> @@ -526,8 +526,8 @@ void CalcNTLMv2_response(const struct cifsSesInf=
o *ses,
>> =A0{
>> =A0 =A0 =A0 struct HMACMD5Context context;
>> =A0 =A0 =A0 /* rest of v2 struct already generated */
>> - =A0 =A0 memcpy(v2_session_response + 8, ses->server->cryptKey, 8);
>> - =A0 =A0 hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &co=
ntext);
>> + =A0 =A0 memcpy(v2_session_response + 8, ses->cryptKey, 8);
>> + =A0 =A0 hmac_md5_init_limK_to_64(ses->ntlmv2_hash, 16, &context);
>>
>> =A0 =A0 =A0 hmac_md5_update(v2_session_response+8,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct ntlmv2_res=
p) - 8, &context);
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index c265ebd..4ae331c 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -179,12 +179,10 @@ struct TCP_Server_Info {
>> =A0 =A0 =A0 int capabilities; /* allow selective disabling of caps b=
y smb sess */
>> =A0 =A0 =A0 int timeAdj; =A0/* Adjust for difference in server time =
zone in sec */
>> =A0 =A0 =A0 __u16 CurrentMid; =A0 =A0 =A0 =A0 /* multiplex id - rota=
ting counter */
>> - =A0 =A0 char cryptKey[CIFS_CRYPTO_KEY_SIZE];
>> =A0 =A0 =A0 /* 16th byte of RFC1001 workstation name is always null =
*/
>> =A0 =A0 =A0 char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL=
];
>> =A0 =A0 =A0 __u32 sequence_number; /* needed for CIFS PDU signature =
*/
>> =A0 =A0 =A0 struct session_key session_key;
>> - =A0 =A0 char ntlmv2_hash[16];
>> =A0 =A0 =A0 unsigned long lstrp; /* when we got last response from t=
his server */
>> =A0 =A0 =A0 u16 dialect; /* dialect index that server chose */
>> =A0 =A0 =A0 /* extended security flavors that server supports */
>> @@ -192,6 +190,7 @@ struct TCP_Server_Info {
>> =A0 =A0 =A0 bool =A0 =A0sec_mskerberos; =A0 =A0 =A0 =A0 /* supports =
legacy MS Kerberos */
>> =A0 =A0 =A0 bool =A0 =A0sec_kerberosu2u; =A0 =A0 =A0 =A0/* supports =
U2U Kerberos */
>> =A0 =A0 =A0 bool =A0 =A0sec_ntlmssp; =A0 =A0 =A0 =A0 =A0 =A0/* suppo=
rts NTLMSSP */
>> + =A0 =A0 bool session_estab; /* mark when very first sess is establ=
ished */
>> =A0#ifdef CONFIG_CIFS_FSCACHE
>> =A0 =A0 =A0 struct fscache_cookie =A0 *fscache; /* client index cach=
e cookie */
>> =A0#endif
>> @@ -223,6 +222,9 @@ struct cifsSesInfo {
>> =A0 =A0 =A0 char userName[MAX_USERNAME_SIZE + 1];
>> =A0 =A0 =A0 char *domainName;
>> =A0 =A0 =A0 char *password;
>> + =A0 =A0 char cryptKey[CIFS_CRYPTO_KEY_SIZE];
>> + =A0 =A0 struct session_key auth_key;
>> + =A0 =A0 char ntlmv2_hash[16];
>> =A0 =A0 =A0 unsigned int tilen; /* length of the target info blob */
>> =A0 =A0 =A0 unsigned char *tiblob; /* target info blob in challenge =
response */
>> =A0 =A0 =A0 bool need_reconnect:1; /* connection reset, uid now inva=
lid */
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index 13c854e..0dbc51c 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -486,7 +486,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSe=
sInfo *ses)
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rsp->EncryptionKeyLength =3D=3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_l=
e16(CIFS_CRYPTO_KEY_SIZE)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(server->cryptKey, r=
sp->EncryptionKey,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->cryptKey, rsp-=
>EncryptionKey,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_CRY=
PTO_KEY_SIZE);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (server->secMode & SECMODE_PW_=
ENCRYPT) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO; /* need cry=
ptkey unless plain text */
>> @@ -557,7 +557,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSe=
sInfo *ses)
>> =A0 =A0 =A0 server->timeAdj =3D (int)(__s16)le16_to_cpu(pSMBr->Serve=
rTimeZone);
>> =A0 =A0 =A0 server->timeAdj *=3D 60;
>> =A0 =A0 =A0 if (pSMBr->EncryptionKeyLength =3D=3D CIFS_CRYPTO_KEY_SI=
ZE) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 memcpy(server->cryptKey, pSMBr->u.Encrypti=
onKey,
>> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->cryptKey, pSMBr->u.EncryptionK=
ey,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_CRYPTO_KEY_SIZE);
>> =A0 =A0 =A0 } else if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && (pSMBr->EncryptionKey=
Length =3D=3D 0)) {
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index f6a3091..12a6e20 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -200,6 +200,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus !=3D=
 CifsExiting)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->=
tcpStatus =3D CifsGood;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->sequence_number =
=3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_estab =3D =
false;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_L=
ock);
>> =A0 =A0 =A0 /* =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_set(&server->inFlig=
ht,0);*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&server->respons=
e_q);
>> @@ -1616,6 +1617,7 @@ cifs_get_tcp_session(struct smb_vol *volume_in=
fo)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 volume_info->source_rfc1001_name, RFC100=
1_NAME_LEN_WITH_NULL);
>> =A0 =A0 =A0 memcpy(tcp_ses->server_RFC1001_name,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 volume_info->target_rfc1001_name, RFC100=
1_NAME_LEN_WITH_NULL);
>> + =A0 =A0 tcp_ses->session_estab =3D false;
>> =A0 =A0 =A0 tcp_ses->sequence_number =3D 0;
>> =A0 =A0 =A0 INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
>> =A0 =A0 =A0 INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
>> @@ -2914,14 +2916,13 @@ CIFSTCon(unsigned int xid, struct cifsSesInf=
o *ses,
>> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((global_secflags & CIFSSEC_MAY_LANMA=
N) &&
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (ses->server->secType =3D=3D LAN=
MAN))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 calc_lanman_hash(tcon->pas=
sword, ses->server->cryptKey,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 calc_lanman_hash(tcon->pas=
sword, ses->cryptKey,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0ses->server->secMode &
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 SECMODE_PW_ENCRYPT ? true : false,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0bcc_ptr);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> =A0#endif /* CIFS_WEAK_PW_HASH */
>> - =A0 =A0 =A0 =A0 =A0 =A0 SMBNTencrypt(tcon->password, ses->server->=
cryptKey,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bcc_ptr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 SMBNTencrypt(tcon->password, ses->cryptKey=
, bcc_ptr);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D CIFS_SESS_KEY_SIZE;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->capabilities & CAP_UNICODE) {
>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> index 9148fd8..d632331 100644
>> --- a/fs/cifs/sess.c
>> +++ b/fs/cifs/sess.c
>> @@ -402,7 +402,7 @@ static int decode_ntlmssp_challenge(char *bcc_pt=
r, int blob_len,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 memcpy(ses->server->cryptKey, pblob->Challenge, CIFS_CRYPT=
O_KEY_SIZE);
>> + =A0 =A0 memcpy(ses->cryptKey, pblob->Challenge, CIFS_CRYPTO_KEY_SI=
ZE);
>> =A0 =A0 =A0 /* BB we could decode pblob->NegotiateFlags; some may be=
 useful */
>> =A0 =A0 =A0 /* In particular we can examine sign flags */
>> =A0 =A0 =A0 /* BB spec says that if AvId field of MsvAvTimestamp is =
populated then
>> @@ -672,7 +672,7 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB calculate hash with password */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* and copy into bcc */
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 calc_lanman_hash(ses->password, ses->serve=
r->cryptKey,
>> + =A0 =A0 =A0 =A0 =A0 =A0 calc_lanman_hash(ses->password, ses->crypt=
Key,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ses->=
server->secMode & SECMODE_PW_ENCRYPT ?
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 true : false, lnm_session_key);
>>
>> @@ -699,12 +699,11 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(CIFS_SESS_KE=
Y_SIZE);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* calculate session key */
>> - =A0 =A0 =A0 =A0 =A0 =A0 SMBNTencrypt(ses->password, ses->server->c=
ryptKey,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ntlm_session_ke=
y);
>> + =A0 =A0 =A0 =A0 =A0 =A0 SMBNTencrypt(ses->password, ses->cryptKey,=
 ntlm_session_key);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (first_time) /* should this be moved =
into common code
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 with s=
imilar ntlmv2 path? */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_calculate_session_key=
(&ses->server->session_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wit=
h similar ntlmv2 path? */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_calculate_session_key=
(&ses->auth_key,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ntlm_ses=
sion_key, ses->password);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* copy session key */
>>
>> @@ -794,15 +793,15 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* bail out if key is too long */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (msg->sesskey_len >
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(ses->server->session_key.da=
ta.krb5)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(ses->auth_key.data.krb5)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Kerberos sign=
ing key too long (%u bytes)",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msg->ses=
skey_len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EOVERFLOW;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (first_time) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->session_key.l=
en =3D msg->sesskey_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->server->sessio=
n_key.data.krb5,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->auth_key.len =3D msg-=
>sesskey_len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->auth_key.data.=
krb5,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msg->dat=
a, msg->sesskey_len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req.hdr.Flags2 |=3D SMBFLG2_EXT_SE=
C;
>
> Ok, so basically this moves all of the session key data structures fr=
om
> the server to session. Once you calculate the key however and have a
> successful session setup, don't you need to copy that key from the
> session to the server? Where does that happen?
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Jeff, that code is in 5/7 patch.
