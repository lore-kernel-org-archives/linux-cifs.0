From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS} [1/3] NTLM auth & signing - Allocate session
 key/client response dynamically
Date: Wed, 20 Oct 2010 10:31:18 -0500
Message-ID: <AANLkTimdRsFO=+nwrVyfFjzpWqmSACRyBZOGv1U8FV4o@mail.gmail.com>
References: <1287533637-22367-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287533637-22367-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 19, 2010 at 7:13 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> Start calculation auth response within a session. =A0Move/Add pertine=
t
> data structures like session key, server challenge and ntlmv2_hash in
> a session structure. =A0We should do the calculations within a sessio=
n
> before copying session key and response over to server data
> structures because a session setup can fail.
>
> Only after a very first smb session succeeds, it copy/make its
> session key, session key of smb connection. =A0This key stays with
> the smb connection throughout its life.
>
> The authentication response field within structure session_key
> is now dynamic. =A0Every authentication type allocates the response s=
ized
> memory within its session structure and later frees it once the
> client response is sent and if session's session key becomes
> connetion's session key.
>
> ntlm/ntlmi authentication functions are rearranged. =A0A function
> named setup_ntlm_resp(), similar to setup_ntlmv2_resp(), replaces
> function cifs_calculate_session_key().
>
> size of CIFS_SESS_KEY_SIZE is changed to 16, to reflect the byte size
> of the key it holds.
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifsencrypt.c | =A0 99 +++++++++++++++++++++++++----------=
------------
> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 10 +----
> =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A07 +++-
> =A0fs/cifs/cifsproto.h =A0 | =A0 11 ++---
> =A0fs/cifs/connect.c =A0 =A0 | =A0 33 ++++++++++++++--
> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0103 +++++++++++++++++++--------=
----------------------
> =A0fs/cifs/transport.c =A0 | =A0 =A06 +-
> =A07 files changed, 137 insertions(+), 132 deletions(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 7ac0056..05e052c 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -43,15 +43,17 @@ extern void SMBencrypt(unsigned char *passwd, con=
st unsigned char *c8,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned char *p24);
>
> =A0static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu=
,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const s=
truct session_key *key, char *signature)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
TCP_Server_Info *server, char *signature)
> =A0{
> =A0 =A0 =A0 =A0struct =A0MD5Context context;
>
> - =A0 =A0 =A0 if ((cifs_pdu =3D=3D NULL) || (signature =3D=3D NULL) |=
| (key =3D=3D NULL))
> + =A0 =A0 =A0 if (cifs_pdu =3D=3D NULL || signature =3D=3D NULL || se=
rver =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>
> =A0 =A0 =A0 =A0cifs_MD5_init(&context);
> - =A0 =A0 =A0 cifs_MD5_update(&context, (char *)&key->data, key->len)=
;
> + =A0 =A0 =A0 cifs_MD5_update(&context, server->session_key.key, 16);
> + =A0 =A0 =A0 cifs_MD5_update(&context, server->session_key.response,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server-=
>session_key.len);
> =A0 =A0 =A0 =A0cifs_MD5_update(&context, cifs_pdu->Protocol, cifs_pdu=
->smb_buf_length);
>
> =A0 =A0 =A0 =A0cifs_MD5_final(signature, &context);
> @@ -79,8 +81,7 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct =
TCP_Server_Info *server,
> =A0 =A0 =A0 =A0server->sequence_number++;
> =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
>
> - =A0 =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, &server->sess=
ion_key,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 smb_signature);
> + =A0 =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, server, smb_s=
ignature);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memset(cifs_pdu->Signature.SecuritySig=
nature, 0, 8);
> =A0 =A0 =A0 =A0else
> @@ -90,16 +91,18 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struc=
t TCP_Server_Info *server,
> =A0}
>
> =A0static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const s=
truct session_key *key, char *signature)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
TCP_Server_Info *server, char *signature)
> =A0{
> =A0 =A0 =A0 =A0struct =A0MD5Context context;
> =A0 =A0 =A0 =A0int i;
>
> - =A0 =A0 =A0 if ((iov =3D=3D NULL) || (signature =3D=3D NULL) || (ke=
y =3D=3D NULL))
> + =A0 =A0 =A0 if (iov =3D=3D NULL || signature =3D=3D NULL || server =
=3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>
> =A0 =A0 =A0 =A0cifs_MD5_init(&context);
> - =A0 =A0 =A0 cifs_MD5_update(&context, (char *)&key->data, key->len)=
;
> + =A0 =A0 =A0 cifs_MD5_update(&context, server->session_key.key, 16);
> + =A0 =A0 =A0 cifs_MD5_update(&context, server->session_key.response,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server-=
>session_key.len);
> =A0 =A0 =A0 =A0for (i =3D 0; i < n_vec; i++) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (iov[i].iov_len =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> @@ -146,8 +149,7 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, s=
truct TCP_Server_Info *server,
> =A0 =A0 =A0 =A0server->sequence_number++;
> =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
>
> - =A0 =A0 =A0 rc =3D cifs_calc_signature2(iov, n_vec, &server->sessio=
n_key,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 smb_signature);
> + =A0 =A0 =A0 rc =3D cifs_calc_signature2(iov, n_vec, server, smb_sig=
nature);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memset(cifs_pdu->Signature.SecuritySig=
nature, 0, 8);
> =A0 =A0 =A0 =A0else
> @@ -157,14 +159,14 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec,=
 struct TCP_Server_Info *server,
> =A0}
>
> =A0int cifs_verify_signature(struct smb_hdr *cifs_pdu,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct sessio=
n_key *session_key,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct TCP_Server_I=
nfo *server,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 expected_seq=
uence_number)
> =A0{
> =A0 =A0 =A0 =A0unsigned int rc;
> =A0 =A0 =A0 =A0char server_response_sig[8];
> =A0 =A0 =A0 =A0char what_we_think_sig_should_be[20];
>
> - =A0 =A0 =A0 if (cifs_pdu =3D=3D NULL || session_key =3D=3D NULL)
> + =A0 =A0 =A0 if (cifs_pdu =3D=3D NULL || server =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>
> =A0 =A0 =A0 =A0if (cifs_pdu->Command =3D=3D SMB_COM_NEGOTIATE)
> @@ -193,7 +195,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_pd=
u,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0cpu_to_le32(expected_sequence_number);
> =A0 =A0 =A0 =A0cifs_pdu->Signature.Sequence.Reserved =3D 0;
>
> - =A0 =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, session_key,
> + =A0 =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, server,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0what_we_think_sig_should_be);
>
> =A0 =A0 =A0 =A0if (rc)
> @@ -209,18 +211,18 @@ int cifs_verify_signature(struct smb_hdr *cifs_=
pdu,
>
> =A0}
>
> -/* We fill in key by putting in 40 byte array which was allocated by=
 caller */
> -int cifs_calculate_session_key(struct session_key *key, const char *=
rn,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *pass=
word)
> +/* first calculate 24 bytes ntlm response and then 16 byte session k=
ey */
> +int setup_ntlm_response(struct cifsSesInfo *ses)
> =A0{
> =A0 =A0 =A0 =A0char temp_key[16];
> - =A0 =A0 =A0 if ((key =3D=3D NULL) || (rn =3D=3D NULL))
> +
> + =A0 =A0 =A0 if (!ses)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
>
> - =A0 =A0 =A0 E_md4hash(password, temp_key);
> - =A0 =A0 =A0 mdfour(key->data.ntlm, temp_key, 16);
> - =A0 =A0 =A0 memcpy(key->data.ntlm+16, rn, CIFS_SESS_KEY_SIZE);
> - =A0 =A0 =A0 key->len =3D 40;
> + =A0 =A0 =A0 SMBNTencrypt(ses->password, ses->cryptKey, ses->auth_ke=
y.response);
> +
> + =A0 =A0 =A0 E_md4hash(ses->password, temp_key);
> + =A0 =A0 =A0 mdfour(ses->auth_key.key, temp_key, 16);
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> @@ -465,19 +467,13 @@ calc_exit_2:
> =A0}
>
> =A0int
> -setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *nls=
_cp)
> +setup_ntlmv2_rsp(struct cifsSesInfo *ses, const struct nls_table *nl=
s_cp)
> =A0{
> =A0 =A0 =A0 =A0int rc;
> - =A0 =A0 =A0 struct ntlmv2_resp *buf =3D (struct ntlmv2_resp *)resp_=
buf;
> + =A0 =A0 =A0 int baselen;
> + =A0 =A0 =A0 struct ntlmv2_resp *buf;
> =A0 =A0 =A0 =A0struct HMACMD5Context context;
>
> - =A0 =A0 =A0 buf->blob_signature =3D cpu_to_le32(0x00000101);
> - =A0 =A0 =A0 buf->reserved =3D 0;
> - =A0 =A0 =A0 buf->time =3D cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIM=
E));
> - =A0 =A0 =A0 get_random_bytes(&buf->client_chal, sizeof(buf->client_=
chal));
> - =A0 =A0 =A0 buf->reserved2 =3D 0;
> -
> =A0 =A0 =A0 =A0if (ses->server->secType =3D=3D RawNTLMSSP) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!ses->domainName) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D find_domain_nam=
e(ses);
> @@ -494,22 +490,36 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, char =
*resp_buf,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 baselen =3D sizeof(struct ntlmv2_resp);
> + =A0 =A0 =A0 ses->auth_key.len =3D baselen + ses->tilen;
> + =A0 =A0 =A0 ses->auth_key.response =3D kmalloc(ses->auth_key.len, G=
=46P_KERNEL);
> + =A0 =A0 =A0 if (!ses->auth_key.response) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Can't allocate auth blob=
", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto setup_ntlmv2_rsp_ret;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 buf =3D (struct ntlmv2_resp *)ses->auth_key.response;
> + =A0 =A0 =A0 buf->blob_signature =3D cpu_to_le32(0x00000101);
> + =A0 =A0 =A0 buf->reserved =3D 0;
> + =A0 =A0 =A0 buf->time =3D cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIM=
E));
> + =A0 =A0 =A0 get_random_bytes(&buf->client_chal, sizeof(buf->client_=
chal));
> + =A0 =A0 =A0 buf->reserved2 =3D 0;
> +
> + =A0 =A0 =A0 memcpy(ses->auth_key.response + baselen, ses->tiblob, s=
es->tilen);
> +
> =A0 =A0 =A0 =A0/* calculate buf->ntlmv2_hash */
> =A0 =A0 =A0 =A0rc =3D calc_ntlmv2_hash(ses, nls_cp);
> =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "could not get v2 hash rc %d=
", rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto setup_ntlmv2_rsp_ret;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 CalcNTLMv2_response(ses, resp_buf);
> + =A0 =A0 =A0 CalcNTLMv2_response(ses);
>
> =A0 =A0 =A0 =A0/* now calculate the session key for NTLMv2 */
> =A0 =A0 =A0 =A0hmac_md5_init_limK_to_64(ses->ntlmv2_hash, 16, &contex=
t);
> - =A0 =A0 =A0 hmac_md5_update(resp_buf, 16, &context);
> - =A0 =A0 =A0 hmac_md5_final(ses->auth_key.data.ntlmv2.key, &context)=
;
> -
> - =A0 =A0 =A0 memcpy(&ses->auth_key.data.ntlmv2.resp, resp_buf,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct ntlmv2_resp));
> - =A0 =A0 =A0 ses->auth_key.len =3D 16 + sizeof(struct ntlmv2_resp);
> + =A0 =A0 =A0 hmac_md5_update(ses->auth_key.response, 16, &context);
> + =A0 =A0 =A0 hmac_md5_final(ses->auth_key.key, &context);
>
> =A0 =A0 =A0 =A0return 0;
>
> @@ -521,20 +531,15 @@ setup_ntlmv2_rsp_ret:
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> -void CalcNTLMv2_response(const struct cifsSesInfo *ses,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char *v2_session_res=
ponse)
> +void CalcNTLMv2_response(const struct cifsSesInfo *ses)
> =A0{
> =A0 =A0 =A0 =A0struct HMACMD5Context context;
> =A0 =A0 =A0 =A0/* rest of v2 struct already generated */
> - =A0 =A0 =A0 memcpy(v2_session_response + 8, ses->cryptKey, 8);
> + =A0 =A0 =A0 memcpy(ses->auth_key.response + 8, ses->cryptKey, 8);
> =A0 =A0 =A0 =A0hmac_md5_init_limK_to_64(ses->ntlmv2_hash, 16, &contex=
t);
>
> - =A0 =A0 =A0 hmac_md5_update(v2_session_response+8,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct ntlmv2_re=
sp) - 8, &context);
> -
> - =A0 =A0 =A0 if (ses->tilen)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 hmac_md5_update(ses->tiblob, ses->tilen=
, &context);
> + =A0 =A0 =A0 hmac_md5_update(ses->auth_key.response + 8,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->auth_key.len - 8, =
&context);
>
> - =A0 =A0 =A0 hmac_md5_final(v2_session_response, &context);
> -/* =A0 =A0 cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); =
*/
> + =A0 =A0 =A0 hmac_md5_final(ses->auth_key.response, &context);
> =A0}
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 18ee0ad..c374859 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -98,15 +98,9 @@ enum protocolEnum {
> =A0};
>
> =A0struct session_key {
> + =A0 =A0 =A0 char key[16];
> + =A0 =A0 =A0 char *response;
> =A0 =A0 =A0 =A0unsigned int len;
> - =A0 =A0 =A0 union {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 char ntlm[CIFS_SESS_KEY_SIZE + 16];
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 char krb5[CIFS_SESS_KEY_SIZE + 16]; /* =
BB: length correct? */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char key[16];
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ntlmv2_resp resp=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } ntlmv2;
> - =A0 =A0 =A0 } data;
> =A0};
>
> =A0struct cifs_cred {
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index b0f4b56..a152cd6 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -131,9 +131,14 @@
> =A0#define CIFS_CRYPTO_KEY_SIZE (8)
>
> =A0/*
> + * Size of the ntlm client response
> + */
> +#define CIFS_AUTH_RESP_SIZE (24)
> +
> +/*
> =A0* Size of the session key (crypto key encrypted with the password
> =A0*/
> -#define CIFS_SESS_KEY_SIZE (24)
> +#define CIFS_SESS_KEY_SIZE (16)
>
> =A0/*
> =A0* Maximum user name length
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index e593c40..8c2d0cf 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -362,13 +362,12 @@ extern int cifs_sign_smb(struct smb_hdr *, stru=
ct TCP_Server_Info *, __u32 *);
> =A0extern int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_=
Server_Info *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 *);
> =A0extern int cifs_verify_signature(struct smb_hdr *,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cons=
t struct session_key *session_key,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stru=
ct TCP_Server_Info *server,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 =
expected_sequence_number);
> -extern int cifs_calculate_session_key(struct session_key *key, const=
 char *rn,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cons=
t char *pass);
> -extern void CalcNTLMv2_response(const struct cifsSesInfo *, char *);
> -extern int setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct=
 nls_table *);
> +extern void SMBNTencrypt(unsigned char *, unsigned char *, unsigned =
char *);
> +extern int setup_ntlm_response(struct cifsSesInfo *);
> +extern void CalcNTLMv2_response(const struct cifsSesInfo *);
> +extern int setup_ntlmv2_rsp(struct cifsSesInfo *, const struct nls_t=
able *);
> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
> =A0extern void calc_lanman_hash(const char *password, const char *cry=
ptkey,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool e=
ncrypt, char *lnm_session_key);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 019f003..1006dec 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -175,6 +175,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0server->sequence_number =3D 0;
> =A0 =A0 =A0 =A0server->session_estab =3D false;
> + =A0 =A0 =A0 kfree(server->session_key.response);
> + =A0 =A0 =A0 server->session_key.response =3D NULL;
> + =A0 =A0 =A0 server->session_key.len =3D 0;
>
> =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0list_for_each(tmp, &server->pending_mid_q) {
> @@ -1562,6 +1565,10 @@ cifs_put_tcp_session(struct TCP_Server_Info *s=
erver)
>
> =A0 =A0 =A0 =A0cifs_fscache_release_client_cookie(server);
>
> + =A0 =A0 =A0 kfree(server->session_key.response);
> + =A0 =A0 =A0 server->session_key.response =3D NULL;
> + =A0 =A0 =A0 server->session_key.len =3D 0;
> +
> =A0 =A0 =A0 =A0task =3D xchg(&server->tsk, NULL);
> =A0 =A0 =A0 =A0if (task)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0force_sig(SIGKILL, task);
> @@ -3162,6 +3169,7 @@ int cifs_setup_session(unsigned int xid, struct=
 cifsSesInfo *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct nls_table *nls_=
info)
> =A0{
> =A0 =A0 =A0 =A0int rc =3D 0;
> + =A0 =A0 =A0 unsigned int len;
> =A0 =A0 =A0 =A0struct TCP_Server_Info *server =3D ses->server;
>
> =A0 =A0 =A0 =A0ses->flags =3D 0;
> @@ -3178,10 +3186,22 @@ int cifs_setup_session(unsigned int xid, stru=
ct cifsSesInfo *ses,
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_lock(&ses->server->srv_mutex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!server->session_estab) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&server->session=
_key.data,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &ses->a=
uth_key.data, ses->auth_key.len);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.len=
 =3D ses->auth_key.len;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->session_es=
tab =3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->secType =3D=
=3D RawNTLMSSP)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D=
 16;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D=
 ses->auth_key.len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.res=
ponse =3D kmalloc(len, GFP_KERNEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!server->session_ke=
y.response) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
-ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_u=
nlock(&server->srv_mutex);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ci=
fs_setup_session_ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(server->session_=
key.response,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->au=
th_key.response, len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(server->session_=
key.key,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->au=
th_key.key, 16);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.len=
 =3D len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_estab =3D=
 true;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&server->srv_mutex);
>
> @@ -3192,6 +3212,11 @@ int cifs_setup_session(unsigned int xid, struc=
t cifsSesInfo *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0}
>
> +cifs_setup_session_ret:
> + =A0 =A0 =A0 kfree(ses->auth_key.response);
> + =A0 =A0 =A0 ses->auth_key.response =3D NULL;
> + =A0 =A0 =A0 ses->auth_key.len =3D 0;
> +
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index e35dc60..8bb4518 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -32,9 +32,6 @@
> =A0#include <linux/slab.h>
> =A0#include "cifs_spnego.h"
>
> -extern void SMBNTencrypt(unsigned char *passwd, unsigned char *c8,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned char *p24);
> -
> =A0/*
> =A0* Checks if this is the first smb session to be reconnected after
> =A0* the socket has been reestablished (so we know whether to use vc =
0).
> @@ -469,11 +466,9 @@ static int build_ntlmssp_auth_blob(unsigned char=
 *pbuffer,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 c=
onst struct nls_table *nls_cp)
> =A0{
> =A0 =A0 =A0 =A0int rc;
> - =A0 =A0 =A0 unsigned int size;
> =A0 =A0 =A0 =A0AUTHENTICATE_MESSAGE *sec_blob =3D (AUTHENTICATE_MESSA=
GE *)pbuffer;
> =A0 =A0 =A0 =A0__u32 flags;
> =A0 =A0 =A0 =A0unsigned char *tmp;
> - =A0 =A0 =A0 struct ntlmv2_resp ntlmv2_response =3D {};
>
> =A0 =A0 =A0 =A0memcpy(sec_blob->Signature, NTLMSSP_SIGNATURE, 8);
> =A0 =A0 =A0 =A0sec_blob->MessageType =3D NtLmAuthenticate;
> @@ -497,25 +492,17 @@ static int build_ntlmssp_auth_blob(unsigned cha=
r *pbuffer,
> =A0 =A0 =A0 =A0sec_blob->LmChallengeResponse.MaximumLength =3D 0;
>
> =A0 =A0 =A0 =A0sec_blob->NtChallengeResponse.BufferOffset =3D cpu_to_=
le32(tmp - pbuffer);
> - =A0 =A0 =A0 rc =3D setup_ntlmv2_rsp(ses, (char *)&ntlmv2_response, =
nls_cp);
> + =A0 =A0 =A0 rc =3D setup_ntlmv2_rsp(ses, nls_cp);
> =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Error %d during NTLMSSP aut=
hentication", rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto setup_ntlmv2_ret;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 size =3D =A0sizeof(struct ntlmv2_resp);
> - =A0 =A0 =A0 memcpy(tmp, (char *)&ntlmv2_response, size);
> - =A0 =A0 =A0 tmp +=3D size;
> - =A0 =A0 =A0 if (ses->tilen > 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(tmp, ses->tiblob, ses->tilen);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp +=3D ses->tilen;
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 memcpy(tmp, ses->auth_key.response, ses->auth_key.len);
> + =A0 =A0 =A0 tmp +=3D ses->auth_key.len;
>
> - =A0 =A0 =A0 sec_blob->NtChallengeResponse.Length =3D cpu_to_le16(si=
ze + ses->tilen);
> + =A0 =A0 =A0 sec_blob->NtChallengeResponse.Length =3D cpu_to_le16(se=
s->auth_key.len);
> =A0 =A0 =A0 =A0sec_blob->NtChallengeResponse.MaximumLength =3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_=
le16(size + ses->tilen);
> - =A0 =A0 =A0 kfree(ses->tiblob);
> - =A0 =A0 =A0 ses->tiblob =3D NULL;
> - =A0 =A0 =A0 ses->tilen =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_=
le16(ses->auth_key.len);
>
> =A0 =A0 =A0 =A0if (ses->domainName =3D=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sec_blob->DomainName.BufferOffset =3D =
cpu_to_le32(tmp - pbuffer);
> @@ -595,6 +582,7 @@ CIFS_SessSetup(unsigned int xid, struct cifsSesIn=
fo *ses,
> =A0 =A0 =A0 =A0__le32 phase =3D NtLmNegotiate; /* NTLMSSP, if needed,=
 is multistage */
> =A0 =A0 =A0 =A0u16 blob_len;
> =A0 =A0 =A0 =A0char *ntlmsspblob =3D NULL;
> + =A0 =A0 =A0 unsigned int resplen;
>
> =A0 =A0 =A0 =A0if (ses =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
> @@ -687,24 +675,29 @@ ssetup_ntlmssp_authenticate:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ascii_ssetup_strings(&bcc_ptr, ses, nl=
s_cp);
> =A0#endif
> =A0 =A0 =A0 =A0} else if (type =3D=3D NTLM) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 char ntlm_session_key[CIFS_SESS_KEY_SIZ=
E];
> -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->auth_key.len =3D CIFS_AUTH_RESP_SI=
ZE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->auth_key.response =3D kmalloc(ses-=
>auth_key.len, GFP_KERNEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->auth_key.response) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "NTLM can't a=
llocate (%u bytes) memory",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 resplen=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->req_no_secext.Capabilities =3D c=
pu_to_le32(capabilities);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->req_no_secext.CaseInsensitivePas=
swordLength =3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(CIFS_SESS_K=
EY_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(CIFS_AUTH_R=
ESP_SIZE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->req_no_secext.CaseSensitivePassw=
ordLength =3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(CIFS_SESS_K=
EY_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(CIFS_AUTH_R=
ESP_SIZE);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* calculate session key */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 SMBNTencrypt(ses->password, ses->cryptK=
ey, ntlm_session_key);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* calculate ntlm response and session =
key */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 setup_ntlm_response(ses);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* copy ntlm response */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, ses->auth_key.response,=
 CIFS_AUTH_RESP_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D CIFS_AUTH_RESP_SIZE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, ses->auth_key.response,=
 CIFS_AUTH_RESP_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D CIFS_AUTH_RESP_SIZE;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_calculate_session_key(&ses->auth_k=
ey,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ntlm_session_key, ses->password);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* copy session key */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, (char *)ntlm_session_ke=
y, CIFS_SESS_KEY_SIZE);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D CIFS_SESS_KEY_SIZE;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, (char *)ntlm_session_ke=
y, CIFS_SESS_KEY_SIZE);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D CIFS_SESS_KEY_SIZE;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ses->capabilities & CAP_UNICODE) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* unicode strings mus=
t be word aligned */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (iov[0].iov_len % 2=
) {
> @@ -715,47 +708,25 @@ ssetup_ntlmssp_authenticate:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ascii_ssetup_strings(&=
bcc_ptr, ses, nls_cp);
> =A0 =A0 =A0 =A0} else if (type =3D=3D NTLMv2) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *v2_sess_key =3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kmalloc(sizeof(struct n=
tlmv2_resp), GFP_KERNEL);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB FIXME change all users of v2_sess=
_key to
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct ntlmv2_resp */
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (v2_sess_key =3D=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->req_no_secext.Capabilities =3D c=
pu_to_le32(capabilities);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* LM2 password would be here if we su=
pported it */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->req_no_secext.CaseInsensitivePas=
swordLength =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* =A0 =A0 =A0cpu_to_le16(LM2_SESS_KEY=
_SIZE); */
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* calculate session key */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D setup_ntlmv2_rsp(ses, v2_sess_ke=
y, nls_cp);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* calculate nlmv2 response and session=
 key */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D setup_ntlmv2_rsp(ses, nls_cp);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Error %d du=
ring NTLMv2 authentication", rc);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(v2_sess_key);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto ssetup_exit;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, (char *)v2_sess_key,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(=
struct ntlmv2_resp));
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D sizeof(struct ntlmv2_resp)=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(v2_sess_key);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, ses->auth_key.response,=
 ses->auth_key.len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D ses->auth_key.len;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* set case sensitive password length =
after tilen may get
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * assigned, tilen is 0 otherwise.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->req_no_secext.CaseSensitivePassw=
ordLength =3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(sizeof(stru=
ct ntlmv2_resp) + ses->tilen);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->tilen > 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, ses->ti=
blob, ses->tilen);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D ses->tilen=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* we never did allocat=
e ses->domainName to free */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(ses->tiblob);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tiblob =3D NULL;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tilen =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(ses->auth_k=
ey.len);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ses->capabilities & CAP_UNICODE) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (iov[0].iov_len % 2=
) {
> @@ -785,16 +756,24 @@ ssetup_ntlmssp_authenticate:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EKEYREJECTED;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto ssetup_exit;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 resplen =3D CIFS_SESS_KEY_SIZE + CIFS_A=
UTH_RESP_SIZE;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* bail out if key is too long */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (msg->sesskey_len >
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(ses->auth_key.data.krb5)=
) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (msg->sesskey_len > resplen) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Kerberos si=
gning key too long (%u bytes)",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0msg->s=
esskey_len);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EOVERFLOW;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto ssetup_exit;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->auth_key.response =3D kmalloc(resp=
len, GFP_KERNEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->auth_key.response) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Kerberos can=
't allocate (%u bytes) memory",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 resplen=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ses->auth_key.len =3D msg->sesskey_len=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->auth_key.data.krb5, msg->da=
ta, msg->sesskey_len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->auth_key.response, msg->dat=
a, msg->sesskey_len);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->req.hdr.Flags2 |=3D SMBFLG2_EXT_=
SEC;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0capabilities |=3D CAP_EXTENDED_SECURIT=
Y;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->req.Capabilities =3D cpu_to_le32=
(capabilities);
> @@ -897,8 +876,6 @@ ssetup_ntlmssp_authenticate:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_STD_OP /* not=
 long */ | CIFS_LOG_ERROR);
> =A0 =A0 =A0 =A0/* SMB request buf freed in SendReceive2 */
>
> - =A0 =A0 =A0 cFYI(1, "ssetup rc from sendrecv2 is %d", rc);
> -
> =A0 =A0 =A0 =A0pSMB =3D (SESSION_SETUP_ANDX *)iov[0].iov_base;
> =A0 =A0 =A0 =A0smb_buf =3D (struct smb_hdr *)iov[0].iov_base;
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index a66c91e..e0588cd 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -543,7 +543,7 @@ SendReceive2(const unsigned int xid, struct cifsS=
esInfo *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(ses->server->secMode & (SECMO=
DE_SIGN_REQUIRED |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 SECMODE_SIGN_ENABLED))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_verify_sig=
nature(midQ->resp_buf,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 &ses->server->session_key,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 ses->server,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0midQ->sequence_number+1);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR=
(1, "Unexpected SMB signature");
> @@ -731,7 +731,7 @@ SendReceive(const unsigned int xid, struct cifsSe=
sInfo *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(ses->server->secMode & (SECMO=
DE_SIGN_REQUIRED |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 SECMODE_SIGN_ENABLED))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_verify_sig=
nature(out_buf,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 &ses->server->session_key,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 ses->server,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0midQ->sequence_number+1);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR=
(1, "Unexpected SMB signature");
> @@ -981,7 +981,7 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifsTconInfo *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0(ses->server->secMode & (SECMODE_SIGN_REQUIRED=
 |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 SECMODE_SIGN_ENABLED))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_verify_signature(out_buf,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0&ses->server->session_key,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0ses->server,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 midQ->sequence_number+1);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Unexpected =
SMB signature");
> --
> 1.6.0.2
>
>

An aside ...

Now that I realize, at least for ntlm, ntlmv2, the original name of
struct session_key which was
struct mac_key was the correct one.  It is a structure that contains a
session key and response i.e.
Message Authenication Key.
