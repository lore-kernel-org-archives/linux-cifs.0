From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS} NTLM auth and sign - Use appropriate server challenge
Date: Wed, 27 Oct 2010 10:44:30 -0500
Message-ID: <AANLkTikqVrzCv8gopNmc+2g0zgZoS=fZyzVLJEuE2SDU@mail.gmail.com>
References: <1288192890-7400-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1288192890-7400-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following line is a little hard to read (comment or clarification n=
eeded?):

               calc_lanman_hash(ses->password, ses->server->cryptKey,
                                ses->server->secMode & SECMODE_PW_ENCRY=
PT ?
                                       true : false, lnm_session_key);

Minor nit - spelling mistake userd



On Wed, Oct 27, 2010 at 10:21 AM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> Need to have cryptKey or server challenge in smb connection
> (struct TCP_Server_Info) for ntlm and ntlmv2 auth types for which
> cryptKey (Encryption Key) is supplied just once in Negotiate Protocol
> response during an smb connection setup for all the smb sessions over
> that smb connection.
>
> For ntlmssp, cryptKey or server challenge is provided for every
> smb session in type 2 packet of ntlmssp negotiation, the cryptKey
> provided during Negotiation Protocol response before smb connection
> does not count.
>
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifsencrypt.c | =A0 10 +++++++---
> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 =A03 ++-
> =A0fs/cifs/cifssmb.c =A0 =A0 | =A0 =A04 ++--
> =A0fs/cifs/connect.c =A0 =A0 | =A0 =A04 ++--
> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 =A02 +-
> =A05 files changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 17d603a..10d3d0f 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -249,7 +249,7 @@ int setup_ntlm_response(struct cifsSesInfo *ses)
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0ses->auth_key.len =3D temp_len;
>
> - =A0 =A0 =A0 SMBNTencrypt(ses->password, ses->cryptKey,
> + =A0 =A0 =A0 SMBNTencrypt(ses->password, ses->server->cryptKey,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ses->auth_key.response=
 + CIFS_SESS_KEY_SIZE);
>
> =A0 =A0 =A0 =A0E_md4hash(ses->password, temp_key);
> @@ -537,8 +537,12 @@ CalcNTLMv2_response(const struct cifsSesInfo *se=
s)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 memcpy(ses->auth_key.response + offset,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->cryptKey, CIFS_SERVER_CHALLENGE_SI=
ZE);
> + =A0 =A0 =A0 if (ses->server->secType =3D=3D RawNTLMSSP)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->auth_key.response + offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->cryptKey, CIFS_SER=
VER_CHALLENGE_SIZE);
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->auth_key.response + offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->cryptKey, =
CIFS_SERVER_CHALLENGE_SIZE);
> =A0 =A0 =A0 =A0crypto_shash_update(&ses->server->secmech.sdeschmacmd5=
->shash,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ses->auth_key.response + offset, ses->=
auth_key.len - offset);
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 67d6a22..badb0b3 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -196,6 +196,7 @@ struct TCP_Server_Info {
> =A0 =A0 =A0 =A0int capabilities; /* allow selective disabling of caps=
 by smb sess */
> =A0 =A0 =A0 =A0int timeAdj; =A0/* Adjust for difference in server tim=
e zone in sec */
> =A0 =A0 =A0 =A0__u16 CurrentMid; =A0 =A0 =A0 =A0 /* multiplex id - ro=
tating counter */
> + =A0 =A0 =A0 char cryptKey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlm, n=
tlmv2 etc */
> =A0 =A0 =A0 =A0/* 16th byte of RFC1001 workstation name is always nul=
l */
> =A0 =A0 =A0 =A0char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NU=
LL];
> =A0 =A0 =A0 =A0__u32 sequence_number; /* needed for CIFS PDU signatur=
e */
> @@ -240,7 +241,7 @@ struct cifsSesInfo {
> =A0 =A0 =A0 =A0char userName[MAX_USERNAME_SIZE + 1];
> =A0 =A0 =A0 =A0char *domainName;
> =A0 =A0 =A0 =A0char *password;
> - =A0 =A0 =A0 char cryptKey[CIFS_CRYPTO_KEY_SIZE];
> + =A0 =A0 =A0 char cryptKey[CIFS_CRYPTO_KEY_SIZE]; /* userd by ntlmss=
p */
> =A0 =A0 =A0 =A0struct session_key auth_key;
> =A0 =A0 =A0 =A0char ntlmv2_hash[16];
> =A0 =A0 =A0 =A0unsigned int tilen; /* length of the target info blob =
*/
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index e98f1f3..a32a42e 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -503,7 +503,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSes=
Info *ses)
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rsp->EncryptionKeyLength =3D=3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to=
_le16(CIFS_CRYPTO_KEY_SIZE)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->cryptKey, r=
sp->EncryptionKey,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->server->cry=
ptKey, rsp->EncryptionKey,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_C=
RYPTO_KEY_SIZE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (server->secMode & SECMODE_P=
W_ENCRYPT) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; /* need c=
ryptkey unless plain text */
> @@ -574,7 +574,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSes=
Info *ses)
> =A0 =A0 =A0 =A0server->timeAdj =3D (int)(__s16)le16_to_cpu(pSMBr->Ser=
verTimeZone);
> =A0 =A0 =A0 =A0server->timeAdj *=3D 60;
> =A0 =A0 =A0 =A0if (pSMBr->EncryptionKeyLength =3D=3D CIFS_CRYPTO_KEY_=
SIZE) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->cryptKey, pSMBr->u.Encrypti=
onKey,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->server->cryptKey, pSMBr->u.=
EncryptionKey,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_CRYPTO_KEY_SIZE);
> =A0 =A0 =A0 =A0} else if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&& (pSMBr->EncryptionK=
eyLength =3D=3D 0)) {
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 469c3dd..f8f1ec6 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3002,13 +3002,13 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo=
 *ses,
> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((global_secflags & CIFSSEC_MAY_LAN=
MAN) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(ses->server->secType =3D=3D L=
ANMAN))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 calc_lanman_hash(tcon->=
password, ses->cryptKey,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 calc_lanman_hash(tcon->=
password, ses->server->cryptKey,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ses->server->secMode &
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0SECMODE_PW_ENCRYPT ? true : false,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 bcc_ptr);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0#endif /* CIFS_WEAK_PW_HASH */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 SMBNTencrypt(tcon->password, ses->crypt=
Key, bcc_ptr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 SMBNTencrypt(tcon->password, ses->serve=
r->cryptKey, bcc_ptr);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bcc_ptr +=3D CIFS_SESS_KEY_SIZE;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ses->capabilities & CAP_UNICODE) {
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index e0515a6..9c7ca2b 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -670,7 +670,7 @@ ssetup_ntlmssp_authenticate:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB calculate hash with password */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* and copy into bcc */
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 calc_lanman_hash(ses->password, ses->cr=
yptKey,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 calc_lanman_hash(ses->password, ses->se=
rver->cryptKey,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->=
server->secMode & SECMODE_PW_ENCRYPT ?
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0true : false, lnm_session_key);
>
> --
> 1.6.0.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
