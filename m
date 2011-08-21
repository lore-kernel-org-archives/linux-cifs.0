From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] smb2: Enable signing in smb2
Date: Sun, 21 Aug 2011 16:34:05 -0500
Message-ID: <CADT32e+9_OY4+REuvmb=2VMeOUZqp7Ly61UHENALu4NSKe6aqA@mail.gmail.com>
References: <1313609780-4606-1-git-send-email-shirishpargaonkar@gmail.com>
	<CAKywueRUzn8cDDRyha8oivy4P9wS4cRZSkZppFNqVR5Zy4Bw_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRUzn8cDDRyha8oivy4P9wS4cRZSkZppFNqVR5Zy4Bw_g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Aug 21, 2011 at 10:20 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 wrote:
> 2011/8/17 =A0<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Enable signing in smb2. =A0For smb2, hmac-sha256 is used insted
>> of hmac-md5 used for cifs/smb.
>> Signature field in smb2 header is 16 bytes instead of 8 bytes.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/Kconfig =A0 =A0 =A0 =A0 | =A0 =A01 +
>> =A0fs/cifs/cifsencrypt.c =A0 | =A0 30 ++++++++-
>> =A0fs/cifs/cifsglob.h =A0 =A0 =A0| =A0 =A02 +
>> =A0fs/cifs/smb2pdu.c =A0 =A0 =A0 | =A0 32 ++++++++-
>> =A0fs/cifs/smb2pdu.h =A0 =A0 =A0 | =A0 =A04 +
>> =A0fs/cifs/smb2transport.c | =A0175 ++++++++++++++++++++++++++++++++=
+++++++++++++--
>> =A06 files changed, 235 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
>> index f66cc16..ed5452e 100644
>> --- a/fs/cifs/Kconfig
>> +++ b/fs/cifs/Kconfig
>> @@ -9,6 +9,7 @@ config CIFS
>> =A0 =A0 =A0 =A0select CRYPTO_ARC4
>> =A0 =A0 =A0 =A0select CRYPTO_ECB
>> =A0 =A0 =A0 =A0select CRYPTO_DES
>> + =A0 =A0 =A0 select CRYPTO_SHA256
>> =A0 =A0 =A0 =A0help
>> =A0 =A0 =A0 =A0 =A0This is the client VFS module for the Common Inte=
rnet File System
>> =A0 =A0 =A0 =A0 =A0(CIFS) protocol which is the successor to the Ser=
ver Message Block
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index e76bfeb..bb7c234 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -774,12 +774,17 @@ calc_seckey(struct cifs_ses *ses)
>> =A0void
>> =A0cifs_crypto_shash_release(struct TCP_Server_Info *server)
>> =A0{
>> + =A0 =A0 =A0 if (server->secmech.hmacsha256)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_free_shash(server->secmech.hmac=
sha256);
>> +
>> =A0 =A0 =A0 =A0if (server->secmech.md5)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0crypto_free_shash(server->secmech.md5=
);
>>
>> =A0 =A0 =A0 =A0if (server->secmech.hmacmd5)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0crypto_free_shash(server->secmech.hma=
cmd5);
>>
>> + =A0 =A0 =A0 kfree(server->secmech.sdeschmacsha256);
>> +
>> =A0 =A0 =A0 =A0kfree(server->secmech.sdeschmacmd5);
>>
>> =A0 =A0 =A0 =A0kfree(server->secmech.sdescmd5);
>> @@ -804,6 +809,13 @@ cifs_crypto_shash_allocate(struct TCP_Server_In=
fo *server)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto crypto_allocate_md5_fail;
>> =A0 =A0 =A0 =A0}
>>
>> + =A0 =A0 =A0 server->secmech.hmacsha256 =3D crypto_alloc_shash("hma=
c(sha256)", 0, 0);
>> + =A0 =A0 =A0 if (IS_ERR(server->secmech.hmacsha256)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate crypto h=
macsha256\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D PTR_ERR(server->secmech.hmacsha=
256);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto crypto_allocate_hmacsha256_fail;
>> + =A0 =A0 =A0 }
>> +
>> =A0 =A0 =A0 =A0size =3D sizeof(struct shash_desc) +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0crypto_shash_descsize=
(server->secmech.hmacmd5);
>> =A0 =A0 =A0 =A0server->secmech.sdeschmacmd5 =3D kmalloc(size, GFP_KE=
RNEL);
>> @@ -815,7 +827,6 @@ cifs_crypto_shash_allocate(struct TCP_Server_Inf=
o *server)
>> =A0 =A0 =A0 =A0server->secmech.sdeschmacmd5->shash.tfm =3D server->s=
ecmech.hmacmd5;
>> =A0 =A0 =A0 =A0server->secmech.sdeschmacmd5->shash.flags =3D 0x0;
>>
>> -
>> =A0 =A0 =A0 =A0size =3D sizeof(struct shash_desc) +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0crypto_shash_descsize=
(server->secmech.md5);
>> =A0 =A0 =A0 =A0server->secmech.sdescmd5 =3D kmalloc(size, GFP_KERNEL=
);
>> @@ -827,12 +838,29 @@ cifs_crypto_shash_allocate(struct TCP_Server_I=
nfo *server)
>> =A0 =A0 =A0 =A0server->secmech.sdescmd5->shash.tfm =3D server->secme=
ch.md5;
>> =A0 =A0 =A0 =A0server->secmech.sdescmd5->shash.flags =3D 0x0;
>>
>> + =A0 =A0 =A0 size =3D sizeof(struct shash_desc) +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_descsize(=
server->secmech.hmacsha256);
>> + =A0 =A0 =A0 server->secmech.sdeschmacsha256 =3D kmalloc(size, GFP_=
KERNEL);
>> + =A0 =A0 =A0 if (!server->secmech.sdeschmacsha256) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Can't alloc hmacsha256\=
n", __func__);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto crypto_allocate_hmacsha256_sdesc_=
fail;
>> + =A0 =A0 =A0 }
>> + =A0 =A0 =A0 server->secmech.sdeschmacsha256->shash.tfm =3D server-=
>secmech.hmacsha256;
>> + =A0 =A0 =A0 server->secmech.sdeschmacsha256->shash.flags =3D 0x0;
>> +
>> =A0 =A0 =A0 =A0return 0;
>>
>> +crypto_allocate_hmacsha256_sdesc_fail:
>> + =A0 =A0 =A0 kfree(server->secmech.sdescmd5);
>> +
>> =A0crypto_allocate_md5_sdesc_fail:
>> =A0 =A0 =A0 =A0kfree(server->secmech.sdeschmacmd5);
>>
>> =A0crypto_allocate_hmacmd5_sdesc_fail:
>> + =A0 =A0 =A0 crypto_free_shash(server->secmech.hmacsha256);
>> +
>> +crypto_allocate_hmacsha256_fail:
>> =A0 =A0 =A0 =A0crypto_free_shash(server->secmech.md5);
>>
>> =A0crypto_allocate_md5_fail:
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 13d8f4d..4c38b98 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -136,8 +136,10 @@ struct sdesc {
>> =A0struct cifs_secmech {
>> =A0 =A0 =A0 =A0struct crypto_shash *hmacmd5; /* hmac-md5 hash functi=
on */
>> =A0 =A0 =A0 =A0struct crypto_shash *md5; /* md5 hash function */
>> + =A0 =A0 =A0 struct crypto_shash *hmacsha256; /* hmac-sha256 hash f=
unction */
>> =A0 =A0 =A0 =A0struct sdesc *sdeschmacmd5; =A0/* ctxt to generate nt=
lmv2 hash, CR1 */
>> =A0 =A0 =A0 =A0struct sdesc *sdescmd5; /* ctxt to generate cifs/smb =
signature */
>> + =A0 =A0 =A0 struct sdesc *sdeschmacsha256; =A0/* ctxt to generate =
smb2 signature */
>> =A0};
>>
>> =A0/* per smb session structure/fields */
>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>> index dad29aa..17f5f22 100644
>> --- a/fs/cifs/smb2pdu.c
>> +++ b/fs/cifs/smb2pdu.c
>> @@ -657,6 +657,37 @@ SMB2_negotiate(unsigned int xid, struct cifs_se=
s *ses)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto neg_exit;
>> =A0 =A0 =A0 =A0}
>> +
>> + =A0 =A0 =A0 if ((sec_flags & CIFSSEC_MAY_SIGN) =3D=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* MUST_SIGN already includes the MAY_=
SIGN FLAG
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0so if this is zero it means tha=
t signing is disabled */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Signing disabled");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->server->sec_mode & SMB2_NEGOT=
IATE_SIGNING_REQUIRED) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Server requ=
ires "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
"packet signing to be enabled in "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
"/proc/fs/cifs/SecurityFlags.");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EOPNOTSUPP;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->sec_mode &=3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ~(SECMODE_SIGN_ENABLED=
 | SECMODE_SIGN_REQUIRED);
>> + =A0 =A0 =A0 } else if ((sec_flags & CIFSSEC_MUST_SIGN) =3D=3D CIFS=
SEC_MUST_SIGN) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* signing required */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Must sign - sec_flags 0x%x", =
sec_flags);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((ses->server->sec_mode & (SMB2_NEG=
OTIATE_SIGNING_ENABLED |
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SMB2_N=
EGOTIATE_SIGNING_REQUIRED)) =3D=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "signing req=
uired but server lacks support");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EOPNOTSUPP;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->sec_mode
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |=3D S=
ECMODE_SIGN_REQUIRED;
>> + =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* signing optional ie CIFSSEC_MAY_SIG=
N */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((ses->server->sec_mode & SMB2_NEGO=
TIATE_SIGNING_REQUIRED)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =3D=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->sec_mode =
&=3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ~(SECM=
ODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED);
>> + =A0 =A0 =A0 }
>> +
>
> In this case we need to fix the check for in smb2_header_assemble fro=
m
> if (tcon->ses->server->sec_mode &
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SMB2_NEGOTIATE_SIGNING_REQUIR=
ED)
> to
> if (tcon->ses->server->sec_mode & SECMODE_SIGN_REQUIRED)
>
> to enable signing on the client. Without it we fail if the server
> responses with signing 'enabled' but 'sign' mount option is specified=
=2E
>
>> =A0#ifdef CONFIG_SMB2_ASN1 =A0/* BB REMOVEME when updated asn1.c rea=
dy */
>> =A0 =A0 =A0 =A0rc =3D decode_neg_token_init(security_blob, blob_leng=
th,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
&ses->server->sec_type);
>> @@ -929,7 +960,6 @@ SMB2_tcon(unsigned int xid, struct cifs_ses *ses=
,
>> =A0 =A0 =A0 =A0pSMB2->hdr.smb2_buf_length =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to_be32(be32_to_cpu(pSMB2->hdr.sm=
b2_buf_length)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0- 1 /* pad */=
 + unc_path_len);
>> -
>> =A0 =A0 =A0 =A0rc =3D smb2_sendrcv2(xid, ses, iov, 2, &resp_buftype =
/* ret */, &status,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_STD_OP | CI=
=46S_LOG_ERROR);
>> =A0 =A0 =A0 =A0cFYI(1, "tcon buftype %d rc %d status %d", resp_bufty=
pe, rc, status);
>> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
>> index 8dceea0..1d7bafc 100644
>> --- a/fs/cifs/smb2pdu.h
>> +++ b/fs/cifs/smb2pdu.h
>> @@ -1057,4 +1057,8 @@ struct symlink_reparse_data_buf {
>> =A0 =A0 =A0 =A0char pathbuffer[1];
>> =A0} __attribute__((packed));
>>
>> +#define SMB2FLG_SECURITY_SIGNATURE (8)
>
> We already have
>
> #define SMB2_FLAGS_SIGNED =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le32(=
0x00000008)
>
>> +#define SMB2_SIGNATURE_SIZE (16)
>> +#define SMB2_NTLMV2_SESSKEY_SIZE (16)
>> +#define SMB2_HMACSHA256_SIZE (32)
>> =A0#endif =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* _SMB2PD=
U_H */
>> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
>> index bc62e2d..a20bff8 100644
>> --- a/fs/cifs/smb2transport.c
>> +++ b/fs/cifs/smb2transport.c
>> @@ -37,6 +37,169 @@
>>
>> =A0extern mempool_t *smb2_mid_poolp;
>>
>> +static int smb2_calc_signature(struct smb2_hdr *smb2_pdu,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct TCP_Server_Info=
 *server, char *signature)
>> +{
>> + =A0 =A0 =A0 int rc;
>> + =A0 =A0 =A0 unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
>> + =A0 =A0 =A0 unsigned char *sigptr =3D smb2_signature;
>> +
>> + =A0 =A0 =A0 memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
>> + =A0 =A0 =A0 memset(smb2_pdu->Signature, 0x0, SMB2_SIGNATURE_SIZE);
>> +
>> + =A0 =A0 =A0 rc =3D crypto_shash_setkey(server->secmech.hmacsha256,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.response, SMB2_NTL=
MV2_SESSKEY_SIZE);
>> + =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not update with r=
esponse\n", __func__);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 rc =3D crypto_shash_init(&server->secmech.sdeschmacsha=
256->shash);
>> + =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not init md5\n", =
__func__);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 rc =3D crypto_shash_update(&server->secmech.sdeschmacs=
ha256->shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb2_p=
du->ProtocolId,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 be32_t=
o_cpu(smb2_pdu->smb2_buf_length));
>> + =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not update with p=
ayload\n", __func__);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 rc =3D crypto_shash_final(&server->secmech.sdeschmacsh=
a256->shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sigptr);
>> + =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not generate sha2=
56 hash\n", __func__);
>> +
>> + =A0 =A0 =A0 memcpy(smb2_pdu->Signature, sigptr, SMB2_NTLMV2_SESSKE=
Y_SIZE);
>> +
>> + =A0 =A0 =A0 return rc;
>> +}
>> +
>> +static int smb2_calc_signature2(const struct kvec *iov, int n_vec,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct TCP_Server_Info *server, struct=
 smb2_hdr *smb2_pdu)
>> +{
>> + =A0 =A0 =A0 int i, rc;
>> + =A0 =A0 =A0 unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
>> + =A0 =A0 =A0 unsigned char *sigptr =3D smb2_signature;
>> +
>> + =A0 =A0 =A0 memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
>> + =A0 =A0 =A0 memset(smb2_pdu->Signature, 0x0, SMB2_SIGNATURE_SIZE);
>> +
>> + =A0 =A0 =A0 rc =3D crypto_shash_setkey(server->secmech.hmacsha256,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.response, SMB2_NTL=
MV2_SESSKEY_SIZE);
>> + =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not update with r=
esponse\n", __func__);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 rc =3D crypto_shash_init(&server->secmech.sdeschmacsha=
256->shash);
>> + =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not init md5\n", =
__func__);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 for (i =3D 0; i < n_vec; i++) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (iov[i].iov_len =3D=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (iov[i].iov_base =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "null iovec =
entry");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* The first entry includes a length f=
ield (which does not get
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0signed that occupies the first =
4 bytes before the header */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (i =3D=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (iov[0].iov_len <=3D=
 8) /* cmd field at offset 9 */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;=
 /* nothing to sign or corrupt header */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &serve=
r->secmech.sdeschmacsha256->shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[i]=
=2Eiov_base + 4, iov[i].iov_len - 4);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &serve=
r->secmech.sdeschmacsha256->shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[i]=
=2Eiov_base, iov[i].iov_len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could n=
ot update with payload\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 rc =3D crypto_shash_final(&server->secmech.sdeschmacsh=
a256->shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sigptr);
>> + =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Could not generate sha2=
56 hash\n", __func__);
>> +
>> + =A0 =A0 =A0 memcpy(smb2_pdu->Signature, sigptr, SMB2_NTLMV2_SESSKE=
Y_SIZE);
>> +
>> + =A0 =A0 =A0 return rc;
>> +}
>> +
>> +/* must be called with server->srv_mutex held */
>> +int smb2_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_I=
nfo *server)
>> +{
>> + =A0 =A0 =A0 int rc =3D 0;
>> + =A0 =A0 =A0 struct smb2_hdr *smb2_pdu =3D iov[0].iov_base;
>> +
>> + =A0 =A0 =A0 if (!(smb2_pdu->Flags & SMB2FLG_SECURITY_SIGNATURE) ||
>> + =A0 =A0 =A0 =A0 =A0 server->tcpStatus =3D=3D CifsNeedNegotiate)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> +
>> + =A0 =A0 =A0 if (!server->session_estab) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 strncpy(smb2_pdu->Signature, "BSRSPYL"=
, 8);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 rc =3D smb2_calc_signature2(iov, n_vec, server, smb2_p=
du);
>> +
>> + =A0 =A0 =A0 return rc;
>> +}
>> +
>> +int
>> +smb2_verify_signature(struct smb2_hdr *smb2_pdu, struct TCP_Server_=
Info *server)
>> +{
>> + =A0 =A0 =A0 unsigned int rc;
>> + =A0 =A0 =A0 char server_response_sig[16];
>> + =A0 =A0 =A0 char what_we_think_sig_should_be[20];
>> +
>> + =A0 =A0 =A0 if ((smb2_pdu->Command =3D=3D SMB2_NEGOTIATE) ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (smb2_pdu->Command =3D=
=3D SMB2_OPLOCK_BREAK) ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (!server->session_esta=
b))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 =A0 /* BB what if signatures are supposed to be on for ses=
sion but
>> + =A0 =A0 =A0 =A0 =A0server does not send one? BB */
>> +
>> + =A0 =A0 =A0 /* Do not need to verify session setups with signature=
 "BSRSPYL " =A0*/
>> + =A0 =A0 =A0 if (memcmp(smb2_pdu->Signature, "BSRSPYL ", 8) =3D=3D =
0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "dummy signature received for =
smb command 0x%x",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb2_pdu->Command);
>> +
>> + =A0 =A0 =A0 /* save off the origiginal signature so we can modify =
the smb and check
>> + =A0 =A0 =A0 =A0 =A0our calculated signature against what the serve=
r sent */
>> + =A0 =A0 =A0 memcpy(server_response_sig, smb2_pdu->Signature, 16);
>> +
>> + =A0 =A0 =A0 memset(smb2_pdu->Signature, 0, 16);
>> +
>> + =A0 =A0 =A0 rc =3D smb2_calc_signature(smb2_pdu, server, what_we_t=
hink_sig_should_be);
>> +
>> + =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> +
>> +/* =A0 =A0 smb2_dump_mem("what we think it should be: ",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 what_we_think_sig_should_b=
e, 16); */
>> +
>> + =A0 =A0 =A0 if (memcmp(server_response_sig, what_we_think_sig_shou=
ld_be, 8))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EACCES;
>> + =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> +}
>> =A0/*
>> =A0* Set message id for the request. Should be called after wait_for=
_free_response
>> =A0* and locking srv_mutex. iov array must have at least 1 element.
>> @@ -292,18 +455,16 @@ int
>> =A0smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Inf=
o *server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int receive_len, bool l=
og_error)
>> =A0{
>> + =A0 =A0 =A0 int rc =3D 0;
>> =A0 =A0 =A0 =A0struct smb2_hdr *buf =3D (struct smb2_hdr *)mid->resp=
_buf;
>>
>> =A0 =A0 =A0 =A0dump_smb2(buf, 80);
>> =A0 =A0 =A0 =A0/* convert the length into a more usable form */
>> =A0 =A0 =A0 =A0if ((receive_len > 24) &&
>> =A0 =A0 =A0 =A0 =A0 =A0(server->sec_mode & SMB2_NEGOTIATE_SIGNING_RE=
QUIRED)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB fixme */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*rc =3D smb2_verify_signature(mid->re=
sp_buf,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &ses->server->mac_signing_key);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D smb2_verify_signature(mid->resp=
_buf, server);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Unexpected=
 SMB signature");
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } */
>> =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0return map_smb2_to_linux_error(buf, log_error);
>> @@ -371,12 +532,12 @@ smb2_sendrcv2(const unsigned int xid, struct c=
ifs_ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>> =A0 =A0 =A0 =A0}
>> - =A0 =A0 =A0 /* rc =3D sign_smb2(iov, n_vec, ses->server); BB
>> + =A0 =A0 =A0 rc =3D smb2_sign_smb2(iov, n_vec, ses->server);
>> =A0 =A0 =A0 =A0if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&ses->server->srv_mutex)=
;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_small_buf_release(buf);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>> - =A0 =A0 =A0 } */
>> + =A0 =A0 =A0 }
>
> It seems we also need this for smb2_call_async too.
>
>>
>> =A0 =A0 =A0 =A0midQ->mid_state =3D MID_REQUEST_SUBMITTED;
>> =A0 =A0 =A0 =A0cifs_in_send_inc(ses->server);
>> --
>> 1.6.0.2
>>
>>
>
>
>
> --
> Best regards,
> Pavel Shilovsky.
>


OK. Understood. Thanks.

Regards,

Shirish
