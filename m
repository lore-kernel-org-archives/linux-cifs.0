From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 7/8] ntlmv2/ntlmssp generate secondary session key and
 ciphertext and send it if signing enabled
Date: Wed, 8 Sep 2010 10:34:42 -0500
Message-ID: <AANLkTikuVVhTnQZ2OD9e68a2KLtN6e4KrL4RJ9J+0yL7@mail.gmail.com>
References: <1283921280-13163-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283921280-13163-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Sep 7, 2010 at 11:48 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> A key is exchanged with the server if client indicates so in flags in
> type 1 messsage and server agrees in flag in type 2 message of ntlmss=
p
> negotiation. =A0If both client and agree, a key sent by client in
> type 3 message of ntlmssp negotiation in the session key field.
> The key is a ciphertext generated off of secondary key, a nonce, usin=
g
> ntlmv2 hash via rc4/arc4.
>
> If authentication is successful, the secondary key is the that client
> uses to calculate cifs/smb signature in the messages that client send=
s
> and to verify the messages sent by server.
> This key stays with the smb connection for its life and is the key us=
ed
> to generate (and verify) signatures for all the subsequent smb sessio=
ns
> for this smb connection.
>
> So only for the first smb session on any smb connection, type 1 messa=
ge
> of ntlmssp negotiation selects the flag NTLMSSP_NEGOTIATE_KEY_XCH.
> It is not used for subsequent smb sessions on this smb connection i.e=
=2E
> no need to generate secondary key, create ciphertext and send it etc.
>
> After the very first successful smb session, sequence number gets set
> to 0 and =A0variable cphready is used to mark that the key calculatio=
ns
> are done.
>
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifsencrypt.c | =A0 41 +++++++++++++++++++++++++++++++++++=
++++++
> =A0fs/cifs/cifsproto.h =A0 | =A0 =A01 +
> =A0fs/cifs/connect.c =A0 =A0 | =A0 =A01 +
> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 24 ++++++++++++++++++------
> =A04 files changed, 61 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index f9c140a..ff576a8 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -470,6 +470,47 @@ void CalcNTLMv2_response(const struct cifsSesInf=
o *ses,
> =A0/* =A0 =A0 cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32)=
; */
> =A0}
>
> +int
> +calc_seckey(struct TCP_Server_Info *server)
> +{
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 struct crypto_blkcipher *tfm_arc4;
> + =A0 =A0 =A0 struct scatterlist sgin, sgout;
> + =A0 =A0 =A0 struct blkcipher_desc desc;
> +
> + =A0 =A0 =A0 if (!server) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Can't determine cipherte=
xt key\n", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (server->cphready)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> + =A0 =A0 =A0 get_random_bytes(server->ntlmssp.sec_key, CIFS_NTLMV2_S=
ESSKEY_SIZE);
> +
> + =A0 =A0 =A0 tfm_arc4 =3D crypto_alloc_blkcipher("ecb(arc4)",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 0, CRYPTO_ALG_ASYNC);
> + =A0 =A0 =A0 if (!tfm_arc4 || IS_ERR(tfm_arc4)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate crypto AP=
I arc4\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 desc.tfm =3D tfm_arc4;
> +
> + =A0 =A0 =A0 crypto_blkcipher_setkey(tfm_arc4,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.data.ntlmv2.key, CI=
=46S_CPHTXT_SIZE);
> + =A0 =A0 =A0 sg_init_one(&sgin, server->ntlmssp.sec_key, CIFS_CPHTXT=
_SIZE);
> + =A0 =A0 =A0 sg_init_one(&sgout, server->ntlmssp.ciphertext, CIFS_CP=
HTXT_SIZE);
> + =A0 =A0 =A0 rc =3D crypto_blkcipher_encrypt(&desc, &sgout, &sgin, C=
IFS_CPHTXT_SIZE);
> +
> + =A0 =A0 =A0 crypto_free_blkcipher(tfm_arc4);
> +
> + =A0 =A0 =A0 server->sequence_number =3D 0;
> + =A0 =A0 =A0 server->cphready =3D true;
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> =A0void
> =A0cifs_crypto_shash_release(struct TCP_Server_Info *server)
> =A0{
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index fbfdd8e..b78bb77 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -370,6 +370,7 @@ extern int setup_ntlmv2_rsp(struct cifsSesInfo *,=
 char *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct =
nls_table *);
> =A0extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
> =A0extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
> +extern int calc_seckey(struct TCP_Server_Info *);
> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
> =A0extern void calc_lanman_hash(const char *password, const char *cry=
ptkey,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool e=
ncrypt, char *lnm_session_key);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 0621a72..e3883f3 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1587,6 +1587,7 @@ cifs_get_tcp_session(struct smb_vol *volume_inf=
o)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_err2;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 tcp_ses->cphready =3D false;
> =A0 =A0 =A0 =A0tcp_ses->noblocksnd =3D volume_info->noblocksnd;
> =A0 =A0 =A0 =A0tcp_ses->noautotune =3D volume_info->noautotune;
> =A0 =A0 =A0 =A0tcp_ses->tcp_nodelay =3D volume_info->sockopt_tcp_node=
lay;
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 68ea153..7c94d7b 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -444,10 +444,12 @@ static void build_ntlmssp_negotiate_blob(unsign=
ed char *pbuffer,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTI=
ATE_UNICODE |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NTLMSSP_NEGOTIATE_NTLM;
> =A0 =A0 =A0 =A0if (ses->server->secMode &
> - =A0 =A0 =A0 =A0 =A0(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (SECMODE_SIGN_REQUIRED =
| SECMODE_SIGN_ENABLED)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flags |=3D NTLMSSP_NEGOTIATE_SIGN;
> - =A0 =A0 =A0 if (ses->server->secMode & SECMODE_SIGN_REQUIRED)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGOTIATE_ALWAYS_SIG=
N;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->server->cphready)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D NTLMSSP_NEGO=
TIATE_KEY_XCH |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NTLMSSP=
_NEGOTIATE_EXTENDED_SEC;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0sec_blob->NegotiateFlags |=3D cpu_to_le32(flags);
>
> @@ -554,9 +556,19 @@ static int build_ntlmssp_auth_blob(unsigned char=
 *pbuffer,
> =A0 =A0 =A0 =A0sec_blob->WorkstationName.MaximumLength =3D 0;
> =A0 =A0 =A0 =A0tmp +=3D 2;
>
> - =A0 =A0 =A0 sec_blob->SessionKey.BufferOffset =3D cpu_to_le32(tmp -=
 pbuffer);
> - =A0 =A0 =A0 sec_blob->SessionKey.Length =3D 0;
> - =A0 =A0 =A0 sec_blob->SessionKey.MaximumLength =3D 0;
> + =A0 =A0 =A0 if ((ses->server->ntlmssp.server_flags & NTLMSSP_NEGOTI=
ATE_KEY_XCH) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !calc_seckey(ses->serve=
r)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(tmp, ses->server->ntlmssp.cipher=
text, CIFS_CPHTXT_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.BufferOffset =3D c=
pu_to_le32(tmp - pbuffer);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.Length =3D cpu_to_=
le16(CIFS_CPHTXT_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.MaximumLength =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(CIFS_CPHTXT=
_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp +=3D CIFS_CPHTXT_SIZE;
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.BufferOffset =3D c=
pu_to_le32(tmp - pbuffer);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.Length =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec_blob->SessionKey.MaximumLength =3D =
0;
> + =A0 =A0 =A0 }
>
> =A0setup_ntlmv2_ret:
> =A0 =A0 =A0 =A0return tmp - pbuffer;
> --
> 1.6.0.2
>
>

I probably should do the code within calc_seckey within srv_mutex to
prevent race of
smb sessions within a smb connection.
