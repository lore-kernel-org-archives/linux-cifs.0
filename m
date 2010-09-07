From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 8/8][ntlmv2 in ntlmssp 8/8] - use-kernel-crpto-apis-instead-of-cifs-crypto-functions
Date: Tue, 7 Sep 2010 08:00:04 -0500
Message-ID: <AANLkTi=T1zr5Xns3znfKyPmerTvpxgsnSeBoLcxiiXWZ@mail.gmail.com>
References: <1283830584-25158-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100907085126.1c58dfbf@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100907085126.1c58dfbf-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Sep 7, 2010 at 7:51 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, =A06 Sep 2010 22:36:24 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> Use kernel crypto sync hash apis insetead of cifs crypto functions.
>> The calls typically corrospond one to one except that insead of
>> key init, setkey is used.
>>
>> Use hmac-md5 to genereate ntlmv2 hash, ntlmv2 response, and HMAC (CR=
1 of
>> ntlmv2 auth blob.
>>
>> Use md5 to generate signature (during send of a request and to verif=
y response)
>>
>>
>> From 90c4637c66ce7ff7901b71526a9844cb658247f5 Mon Sep 17 00:00:00 20=
01
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Date: Mon, 6 Sep 2010 21:56:40 -0500
>> Subject: [PATCH] use kernel crpto apis instead of cifs crypto functi=
ons
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/Kconfig =A0 =A0 =A0 | =A0 =A03 +
>> =A0fs/cifs/cifsencrypt.c | =A0248 ++++++++++++++++++++++++++++++++++=
+--------------
>> =A0fs/cifs/cifsproto.h =A0 | =A0 =A05 +-
>> =A0fs/cifs/transport.c =A0 | =A0 =A06 +-
>> =A04 files changed, 184 insertions(+), 78 deletions(-)
>>
>> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
>> index 917b7d4..0ed2139 100644
>> --- a/fs/cifs/Kconfig
>> +++ b/fs/cifs/Kconfig
>> @@ -2,6 +2,9 @@ config CIFS
>> =A0 =A0 =A0 tristate "CIFS support (advanced network filesystem, SMB=
=46S successor)"
>> =A0 =A0 =A0 depends on INET
>> =A0 =A0 =A0 select NLS
>> + =A0 =A0 select CRYPTO
>> + =A0 =A0 select CRYPTO_MD5
>> + =A0 =A0 select CRYPTO_ARC4
>
> Shouldn't this change go earlier in the set? Without that, this set
> isn't really bisectable, right?

Will make this a change as part of the first set.

>
>> =A0 =A0 =A0 help
>> =A0 =A0 =A0 =A0 This is the client VFS module for the Common Interne=
t File System
>> =A0 =A0 =A0 =A0 (CIFS) protocol which is the successor to the Server=
 Message Block
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index 0c1e9f2..bb8ee23 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -43,20 +43,39 @@ extern void SMBencrypt(unsigned char *passwd, co=
nst unsigned char *c8,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned char *p24);
>>
>> =A0static int cifs_calculate_signature(const struct smb_hdr *cifs_pd=
u,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 co=
nst struct session_key *key,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 char *signature)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct TCP_Server_Info *se=
rver, char *signature)
>> =A0{
>> - =A0 =A0 struct =A0MD5Context context;
>> + =A0 =A0 int rc;
>>
>> - =A0 =A0 if ((cifs_pdu =3D=3D NULL) || (signature =3D=3D NULL) || (=
key =3D=3D NULL))
>> + =A0 =A0 if (cifs_pdu =3D=3D NULL || server =3D=3D NULL || signatur=
e =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>>
>> - =A0 =A0 cifs_MD5_init(&context);
>> - =A0 =A0 cifs_MD5_update(&context, (char *)&key->data, key->len);
>> - =A0 =A0 cifs_MD5_update(&context, cifs_pdu->Protocol, cifs_pdu->sm=
b_buf_length);
>> + =A0 =A0 if (!server->ntlmssp.sdescmd5) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "cifs_calculate_signature:=
 can't generate signature\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -1;
>> + =A0 =A0 }
>>
>> - =A0 =A0 cifs_MD5_final(signature, &context);
>> - =A0 =A0 return 0;
>> + =A0 =A0 rc =3D crypto_shash_init(&server->ntlmssp.sdescmd5->shash)=
;
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "cifs_calculate_signature: oould=
 not init md5\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (server->secType =3D=3D RawNTLMSSP)
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&server->ntlmssp.sdesc=
md5->shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->ntlmssp.sec_key, C=
IFS_NTLMV2_SESSKEY_SIZE);
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&server->ntlmssp.sdesc=
md5->shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (char *)&server->session_k=
ey.data,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.len);
>> +
>
> Very confusing. If the secType !=3D RawNTLMSSP (e.g. Kerberos), you s=
till
> have to dereference the ntlmssp field in the server struct here. Not
> exactly self documenting, no? Maybe that field should be renamed to
> something generic, or some comments should be added to make it clear
> that it's not *just* for NTLMSSP.

Agree, I can change the name to something pertinent to all security mec=
hanisms
and add comments to clarify.

>
>> + =A0 =A0 crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_pdu->Protocol, cifs_p=
du->smb_buf_length);
>> +
>> + =A0 =A0 rc =3D crypto_shash_final(&server->ntlmssp.sdescmd5->shash=
, signature);
>> +
>> + =A0 =A0 return rc;
>> =A0}
>>
>> =A0int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Inf=
o *server,
>> @@ -80,8 +99,7 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct=
 TCP_Server_Info *server,
>> =A0 =A0 =A0 server->sequence_number++;
>> =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>>
>> - =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, &server->session=
_key,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 smb_signature);
>> + =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, server, smb_sign=
ature);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(cifs_pdu->Signature.SecuritySigna=
ture, 0, 8);
>> =A0 =A0 =A0 else
>> @@ -91,21 +109,38 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, str=
uct TCP_Server_Info *server,
>> =A0}
>>
>> =A0static int cifs_calc_signature2(const struct kvec *iov, int n_vec=
,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const stru=
ct session_key *key, char *signature)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct TCP_Server_Info *se=
rver, char *signature)
>> =A0{
>> - =A0 =A0 struct =A0MD5Context context;
>> =A0 =A0 =A0 int i;
>> + =A0 =A0 int rc;
>>
>> - =A0 =A0 if ((iov =3D=3D NULL) || (signature =3D=3D NULL) || (key =3D=
=3D NULL))
>> + =A0 =A0 if (iov =3D=3D NULL || server =3D=3D NULL || signature =3D=
=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>>
>> - =A0 =A0 cifs_MD5_init(&context);
>> - =A0 =A0 cifs_MD5_update(&context, (char *)&key->data, key->len);
>> + =A0 =A0 if (!server->ntlmssp.sdescmd5) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "cifs_calc_signature2: can't gen=
erate signature\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -1;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 rc =3D crypto_shash_init(&server->ntlmssp.sdescmd5->shash)=
;
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "cifs_calc_signature2: oould not=
 init md5\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (server->secType =3D=3D RawNTLMSSP)
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&server->ntlmssp.sdesc=
md5->shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->ntlmssp.sec_key, C=
IFS_NTLMV2_SESSKEY_SIZE);
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&server->ntlmssp.sdesc=
md5->shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (char *)&server->session_k=
ey.data,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.len);
>> +
>> =A0 =A0 =A0 for (i =3D 0; i < n_vec; i++) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (iov[i].iov_len =3D=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (iov[i].iov_base =3D=3D NULL) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "null iovec entr=
y");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "cifs_calc_signa=
ture2: null iovec entry");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* The first entry includes a length fie=
ld (which does not get
>> @@ -113,18 +148,18 @@ static int cifs_calc_signature2(const struct k=
vec *iov, int n_vec,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (i =3D=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (iov[0].iov_len <=3D =
8) /* cmd field at offset 9 */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break; /=
* nothing to sign or corrupt header */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_MD5_update(&context, =
iov[0].iov_base+4,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[0]=
=2Eiov_len-4);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&serve=
r->ntlmssp.sdescmd5->shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[i].iov=
_base + 4, iov[i].iov_len - 4);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_MD5_update(&context, =
iov[i].iov_base, iov[i].iov_len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&serve=
r->ntlmssp.sdescmd5->shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[i].iov=
_base, iov[i].iov_len);
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 cifs_MD5_final(signature, &context);
>> + =A0 =A0 rc =3D crypto_shash_final(&server->ntlmssp.sdescmd5->shash=
, signature);
>>
>> - =A0 =A0 return 0;
>> + =A0 =A0 return rc;
>> =A0}
>>
>> -
>> =A0int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server=
_Info *server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 *pexpected_response_sequenc=
e_number)
>> =A0{
>> @@ -147,8 +182,7 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, =
struct TCP_Server_Info *server,
>> =A0 =A0 =A0 server->sequence_number++;
>> =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>>
>> - =A0 =A0 rc =3D cifs_calc_signature2(iov, n_vec, &server->session_k=
ey,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 smb_signature);
>> + =A0 =A0 rc =3D cifs_calc_signature2(iov, n_vec, server, smb_signat=
ure);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(cifs_pdu->Signature.SecuritySigna=
ture, 0, 8);
>> =A0 =A0 =A0 else
>> @@ -158,14 +192,14 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec=
, struct TCP_Server_Info *server,
>> =A0}
>>
>> =A0int cifs_verify_signature(struct smb_hdr *cifs_pdu,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct session_k=
ey *session_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct TCP_Server_Info=
 *server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 expected_seque=
nce_number)
>> =A0{
>> - =A0 =A0 unsigned int rc;
>> + =A0 =A0 int rc;
>> =A0 =A0 =A0 char server_response_sig[8];
>> =A0 =A0 =A0 char what_we_think_sig_should_be[20];
>>
>> - =A0 =A0 if ((cifs_pdu =3D=3D NULL) || (session_key =3D=3D NULL))
>> + =A0 =A0 if (cifs_pdu =3D=3D NULL || server =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>>
>> =A0 =A0 =A0 if (cifs_pdu->Command =3D=3D SMB_COM_NEGOTIATE)
>> @@ -194,7 +228,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_p=
du,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 cpu_to_le32(expected_sequence_number);
>> =A0 =A0 =A0 cifs_pdu->Signature.Sequence.Reserved =3D 0;
>>
>> - =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, session_key,
>> + =A0 =A0 rc =3D cifs_calculate_signature(cifs_pdu, server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 what_we_think_sig_should_be);
>>
>> =A0 =A0 =A0 if (rc)
>> @@ -320,37 +354,51 @@ static int calc_ntlmv2_hash(struct cifsSesInfo=
 *ses,
>> =A0 =A0 =A0 int rc =3D 0;
>> =A0 =A0 =A0 int len;
>> =A0 =A0 =A0 char nt_hash[CIFS_NTHASH_SIZE];
>> - =A0 =A0 struct HMACMD5Context *pctxt;
>> =A0 =A0 =A0 wchar_t *user;
>> =A0 =A0 =A0 wchar_t *domain;
>> + =A0 =A0 wchar_t *server;
>>
>> - =A0 =A0 pctxt =3D kmalloc(sizeof(struct HMACMD5Context), GFP_KERNE=
L);
>> -
>> - =A0 =A0 if (pctxt =3D=3D NULL)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 if (!ses->server->ntlmssp.sdeschmacmd5) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "calc_ntlmv2_hash: can't generat=
e ntlmv2 hash\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -1;
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 /* calculate md4 hash of password */
>> =A0 =A0 =A0 E_md4hash(ses->password, nt_hash);
>>
>> - =A0 =A0 /* convert Domainname to unicode and uppercase */
>> - =A0 =A0 hmac_md5_init_limK_to_64(nt_hash, 16, pctxt);
>> + =A0 =A0 crypto_shash_setkey(ses->server->ntlmssp.hmacmd5, nt_hash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_NTHAS=
H_SIZE);
>> +
>> + =A0 =A0 rc =3D crypto_shash_init(&ses->server->ntlmssp.sdeschmacmd=
5->shash);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "calc_ntlmv2_hash: could not ini=
t hmacmd5\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 /* convert ses->userName to unicode and uppercase */
>> =A0 =A0 =A0 len =3D strlen(ses->userName);
>> =A0 =A0 =A0 user =3D kmalloc(2 + (len * 2), GFP_KERNEL);
>> - =A0 =A0 if (user =3D=3D NULL)
>> + =A0 =A0 if (user =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "calc_ntlmv2_hash: user mem allo=
c failure\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto calc_exit_2;
>> + =A0 =A0 }
>> =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)user, ses->userName, len=
, nls_cp);
>> =A0 =A0 =A0 UniStrupr(user);
>> - =A0 =A0 hmac_md5_update((char *)user, 2*len, pctxt);
>> +
>> + =A0 =A0 crypto_shash_update(&ses->server->ntlmssp.sdeschmacmd5->sh=
ash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (char *)us=
er, 2 * len);
>>
>> =A0 =A0 =A0 /* convert ses->domainName to unicode and uppercase */
>> =A0 =A0 =A0 if (ses->domainName) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D strlen(ses->domainName);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 domain =3D kmalloc(2 + (len * 2), GFP_KE=
RNEL);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (domain =3D=3D NULL)
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (domain =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "calc_ntlmv2_has=
h: domain mem alloc failure");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto calc_exit_1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)domain, =
ses->domainName, len,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 nls_cp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* the following line was removed since =
it didn't work well
>> @@ -358,18 +406,77 @@ static int calc_ntlmv2_hash(struct cifsSesInfo=
 *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Maybe converting the domain name =
earlier makes sense */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* UniStrupr(domain); */
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 hmac_md5_update((char *)domain, 2*len, pct=
xt);
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&ses->server->ntlmssp.=
sdeschmacmd5->shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 (char *)domain, 2 * len);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(domain);
>> + =A0 =A0 } else if (ses->serverName) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 len =3D strlen(ses->serverName);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 server =3D kmalloc(2 + (len * 2), GFP_KERN=
EL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (server =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "calc_ntlmv2_has=
h: server mem alloc failure");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto calc_exit_1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS((__le16 *)server, se=
s->serverName, len,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 nls_cp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* the following line was removed since it=
 didn't work well
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0with lower cased domain name that p=
assed as an option.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Maybe converting the domain name ea=
rlier makes sense */
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* UniStrupr(domain); */
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&ses->server->ntlmssp.=
sdeschmacmd5->shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 (char *)server, 2 * len);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(server);
>> =A0 =A0 =A0 }
>> +
>> + =A0 =A0 rc =3D crypto_shash_final(&ses->server->ntlmssp.sdeschmacm=
d5->shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 ses->server->ntlmv2_hash);
>> +
>> =A0calc_exit_1:
>> =A0 =A0 =A0 kfree(user);
>> =A0calc_exit_2:
>> =A0 =A0 =A0 /* BB FIXME what about bytes 24 through 40 of the signin=
g key?
>> =A0 =A0 =A0 =A0 =A0compare with the NTLM example */
>> - =A0 =A0 hmac_md5_final(ses->server->ntlmv2_hash, pctxt);
>>
>> - =A0 =A0 kfree(pctxt);
>> + =A0 =A0 return rc;
>> +}
>> +
>> +static int
>> +CalcNTLMv2_response(const struct TCP_Server_Info *server,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char *v2_session_respon=
se)
>> +{
>> + =A0 =A0 int rc;
>> +
>> + =A0 =A0 if (!server->ntlmssp.sdeschmacmd5) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "calc_ntlmv2_hash: can't generat=
e ntlmv2 hash\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -1;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 crypto_shash_setkey(server->ntlmssp.hmacmd5, server->ntlmv=
2_hash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 CIFS_HMAC_MD5_HASH_SIZE);
>> +
>> + =A0 =A0 rc =3D crypto_shash_init(&server->ntlmssp.sdeschmacmd5->sh=
ash);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "CalcNTLMv2_response: could not =
init hmacmd5");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 memcpy(v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
>> + =A0 =A0 =A0 =A0 =A0 =A0 server->cryptKey, CIFS_SERVER_CHALLENGE_SI=
ZE);
>> + =A0 =A0 crypto_shash_update(&server->ntlmssp.sdeschmacmd5->shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 v2_session_response + CIFS_SERVER_CHALLENG=
E_SIZE,
>> + =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct ntlmv2_resp) - CIFS_SERVER_C=
HALLENGE_SIZE);
>> +
>> + =A0 =A0 if (server->tilen)
>> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_update(&server->ntlmssp.sdesc=
hmacmd5->shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 server->tiblob, server->tilen);
>> +
>> + =A0 =A0 rc =3D crypto_shash_final(&server->ntlmssp.sdeschmacmd5->s=
hash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 v2_session_response);
>> +
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> @@ -379,7 +486,6 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *=
resp_buf,
>> =A0{
>> =A0 =A0 =A0 int rc =3D 0;
>> =A0 =A0 =A0 struct ntlmv2_resp *buf =3D (struct ntlmv2_resp *)resp_b=
uf;
>> - =A0 =A0 struct HMACMD5Context context;
>>
>> =A0 =A0 =A0 buf->blob_signature =3D cpu_to_le32(0x00000101);
>> =A0 =A0 =A0 buf->reserved =3D 0;
>> @@ -397,44 +503,44 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, char=
 *resp_buf,
>>
>> =A0 =A0 =A0 /* calculate buf->ntlmv2_hash */
>> =A0 =A0 =A0 rc =3D calc_ntlmv2_hash(ses, nls_cp);
>> - =A0 =A0 if (rc)
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not get v2 hash rc %d", r=
c);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> + =A0 =A0 rc =3D CalcNTLMv2_response(ses->server, resp_buf);
>> + =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not get v2 hash rc %d",=
 rc);
>> - =A0 =A0 CalcNTLMv2_response(ses, resp_buf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>>
>> - =A0 =A0 /* now calculate the MAC key for NTLMv2 */
>> - =A0 =A0 hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &co=
ntext);
>> - =A0 =A0 hmac_md5_update(resp_buf, 16, &context);
>> - =A0 =A0 hmac_md5_final(ses->server->session_key.data.ntlmv2.key, &=
context);
>> + =A0 =A0 if (!ses->server->ntlmssp.sdeschmacmd5) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "calc_ntlmv2_hash: can't generat=
e ntlmv2 hash\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -1;
>> + =A0 =A0 }
>>
>> - =A0 =A0 memcpy(&ses->server->session_key.data.ntlmv2.resp, resp_bu=
f,
>> - =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct ntlmv2_resp));
>> - =A0 =A0 ses->server->session_key.len =3D 16 + sizeof(struct ntlmv2=
_resp);
>> + =A0 =A0 crypto_shash_setkey(ses->server->ntlmssp.hmacmd5,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->ntlmv2_hash, =
CIFS_HMAC_MD5_HASH_SIZE);
>>
>> - =A0 =A0 return rc;
>> -}
>> + =A0 =A0 rc =3D crypto_shash_init(&ses->server->ntlmssp.sdeschmacmd=
5->shash);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "setup_ntlmv2_rsp: could not ini=
t hmacmd5\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>>
>> -void CalcNTLMv2_response(const struct cifsSesInfo *ses,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char *v2_session_respon=
se)
>> -{
>> - =A0 =A0 struct HMACMD5Context context;
>> - =A0 =A0 /* rest of v2 struct already generated */
>> - =A0 =A0 memcpy(v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
>> - =A0 =A0 =A0 =A0 =A0 =A0 ses->server->cryptKey, CIFS_SERVER_CHALLEN=
GE_SIZE);
>> - =A0 =A0 hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash,
>> - =A0 =A0 =A0 =A0 =A0 =A0 CIFS_HMAC_MD5_HASH_SIZE, &context);
>> + =A0 =A0 crypto_shash_update(&ses->server->ntlmssp.sdeschmacmd5->sh=
ash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 resp_buf, =
CIFS_HMAC_MD5_HASH_SIZE);
>>
>> - =A0 =A0 hmac_md5_update(v2_session_response + CIFS_SERVER_CHALLENG=
E_SIZE,
>> - =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct ntlmv2_resp) - CIFS_SERVER_C=
HALLENGE_SIZE,
>> - =A0 =A0 =A0 =A0 =A0 =A0 &context);
>> + =A0 =A0 rc =3D crypto_shash_final(&ses->server->ntlmssp.sdeschmacm=
d5->shash,
>> + =A0 =A0 =A0 =A0 =A0 =A0 ses->server->session_key.data.ntlmv2.key);
>>
>> - =A0 =A0 if (ses->server->tilen)
>> - =A0 =A0 =A0 =A0 =A0 =A0 hmac_md5_update(ses->server->tiblob,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->tilen, &conte=
xt);
>> + =A0 =A0 memcpy(&ses->server->session_key.data.ntlmv2.resp, resp_bu=
f,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct ntlmv2_resp)=
);
>> + =A0 =A0 ses->server->session_key.len =3D 16 + sizeof(struct ntlmv2=
_resp);
>>
>> - =A0 =A0 hmac_md5_final(v2_session_response, &context);
>> -/* =A0 cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); */
>> + =A0 =A0 return rc;
>> =A0}
>>
>> +
>> =A0int
>> =A0calc_seckey(struct TCP_Server_Info *server)
>> =A0{
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 7c115a8..1378d91 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -361,13 +361,10 @@ extern int cifs_sign_smb(struct smb_hdr *, str=
uct TCP_Server_Info *, __u32 *);
>> =A0extern int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP=
_Server_Info *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 *);
>> =A0extern int cifs_verify_signature(struct smb_hdr *,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const s=
truct session_key *session_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct =
TCP_Server_Info *server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 ex=
pected_sequence_number);
>> =A0extern int cifs_calculate_session_key(struct session_key *key, co=
nst char *rn,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const=
 char *pass);
>> -extern int CalcNTLMv2_partial_mac_key(struct cifsSesInfo *,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *);
>> -extern void CalcNTLMv2_response(const struct cifsSesInfo *, char *)=
;
>> =A0extern int setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct =
nls_table *);
>> =A0extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index a66c91e..e0588cd 100644
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
 =A0 =A0 =A0 =A0 =A0 &ses->server->session_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 ses->server,
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
 =A0 =A0 =A0 =A0 =A0 &ses->server->session_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 ses->server,
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
 =A0 =A0 =A0&ses->server->session_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0ses->server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0midQ->sequence_number+1);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Unexpected SM=
B signature");
>
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
