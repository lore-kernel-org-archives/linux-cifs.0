From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Assume passwords are encoded according to iocharset
Date: Fri, 8 Apr 2011 08:51:08 -0500
Message-ID: <BANLkTi=8PBg5YiQwZDG6vHqCr87aK0PWVA@mail.gmail.com>
References: <20110327125648.GA3621@osk.mine.nu>
	<20110408093148.748eda25@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110408093148.748eda25-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Apr 8, 2011 at 8:31 AM, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org> w=
rote:
> On Sun, 27 Mar 2011 14:56:48 +0200
> Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org> wrote:
>
>> Modify cifs to assume that the supplied password is encoded accordin=
g to
>> iocharset. =A0Before this patch passwords would be treated as raw 8-=
bit data,
>> which made authentication with Unicode passwords impossible (at leas=
t
>> passwords with characters > 0xFF).
>>
>> The previous code would as a side effect accept passwords encoded wi=
th ISO
>> 8859-1, since Unicode < 0x100 basically is ISO 8859-1. =A0Software w=
hich
>> relies on that will no longer support password chars > 0x7F unless i=
t also
>> uses iocharset=3Diso8859-1. =A0(mount.cifs does not care about the e=
ncoding so
>> it will work as expected.)
>>
>> Signed-off-by: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsencrypt.c | =A0 =A08 +++---
>> =A0fs/cifs/cifsproto.h =A0 | =A0 =A08 ++++--
>> =A0fs/cifs/connect.c =A0 =A0 | =A0 =A02 +-
>> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 =A02 +-
>> =A0fs/cifs/smbencrypt.c =A0| =A0 60 +++++++++-----------------------=
-----------------
>> =A05 files changed, 22 insertions(+), 58 deletions(-)
>>
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index 5bb4b09..3c1306d 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -226,7 +226,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_p=
du,
>> =A0}
>>
>> =A0/* first calculate 24 bytes ntlm response and then 16 byte sessio=
n key */
>> -int setup_ntlm_response(struct cifs_ses *ses)
>> +int setup_ntlm_response(struct cifs_ses *ses, const struct nls_tabl=
e *nls_cp)
>> =A0{
>> =A0 =A0 =A0 int rc =3D 0;
>> =A0 =A0 =A0 unsigned int temp_len =3D CIFS_SESS_KEY_SIZE + CIFS_AUTH=
_RESP_SIZE;
>> @@ -243,14 +243,14 @@ int setup_ntlm_response(struct cifs_ses *ses)
>> =A0 =A0 =A0 ses->auth_key.len =3D temp_len;
>>
>> =A0 =A0 =A0 rc =3D SMBNTencrypt(ses->password, ses->server->cryptkey=
,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->auth_key.response + C=
IFS_SESS_KEY_SIZE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->auth_key.response + C=
IFS_SESS_KEY_SIZE, nls_cp);
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s Can't generate NTLM response=
, error: %d",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 rc =3D E_md4hash(ses->password, temp_key);
>> + =A0 =A0 rc =3D E_md4hash(ses->password, temp_key, nls_cp);
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s Can't generate NT hash, erro=
r: %d", __func__, rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> @@ -458,7 +458,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses=
, char *ntlmv2_hash,
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 /* calculate md4 hash of password */
>> - =A0 =A0 E_md4hash(ses->password, nt_hash);
>> + =A0 =A0 E_md4hash(ses->password, nt_hash, nls_cp);
>>
>> =A0 =A0 =A0 crypto_shash_setkey(ses->server->secmech.hmacmd5, nt_has=
h,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_NTH=
ASH_SIZE);
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index e42dc82..fd6d873 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -376,8 +376,9 @@ extern int cifs_sign_smb2(struct kvec *iov, int =
n_vec, struct TCP_Server_Info *,
>> =A0extern int cifs_verify_signature(struct smb_hdr *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struc=
t TCP_Server_Info *server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 ex=
pected_sequence_number);
>> -extern int SMBNTencrypt(unsigned char *, unsigned char *, unsigned =
char *);
>> -extern int setup_ntlm_response(struct cifs_ses *);
>> +extern int SMBNTencrypt(unsigned char *, unsigned char *, unsigned =
char *,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *);
>> +extern int setup_ntlm_response(struct cifs_ses *, const struct nls_=
table *);
>> =A0extern int setup_ntlmv2_rsp(struct cifs_ses *, const struct nls_t=
able *);
>> =A0extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
>> =A0extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
>> @@ -429,7 +430,8 @@ extern int CIFSCheckMFSymlink(struct cifs_fattr =
*fattr,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 const unsigned char *path,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_sb_info *cifs_sb, int xid);
>> =A0extern int mdfour(unsigned char *, unsigned char *, int);
>> -extern int E_md4hash(const unsigned char *passwd, unsigned char *p1=
6);
>> +extern int E_md4hash(const unsigned char *passwd, unsigned char *p1=
6,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct nls_table *codepag=
e);
>> =A0extern int SMBencrypt(unsigned char *passwd, const unsigned char =
*c8,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned char *p24);
>> =A0#endif =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* _CIFSPROTO_=
H */
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 96544a4..3c0190f 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -3060,7 +3060,7 @@ CIFSTCon(unsigned int xid, struct cifs_ses *se=
s,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> =A0#endif /* CIFS_WEAK_PW_HASH */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D SMBNTencrypt(tcon->password, ses-=
>server->cryptkey,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 bcc_ptr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 bcc_ptr, nls_codepage);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D CIFS_AUTH_RESP_SIZE;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->capabilities & CAP_UNICODE) {
>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> index 6b140e1..17ae0db 100644
>> --- a/fs/cifs/sess.c
>> +++ b/fs/cifs/sess.c
>> @@ -694,7 +694,7 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(CIFS_AUTH_RE=
SP_SIZE);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* calculate ntlm response and session k=
ey */
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D setup_ntlm_response(ses);
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D setup_ntlm_response(ses, nls_cp);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error %d duri=
ng NTLM authentication", rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
>> diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
>> index 1525d5e..92291c1 100644
>> --- a/fs/cifs/smbencrypt.c
>> +++ b/fs/cifs/smbencrypt.c
>> @@ -195,46 +195,13 @@ SMBencrypt(unsigned char *passwd, const unsign=
ed char *c8, unsigned char *p24)
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> -/* Routines for Windows NT MD4 Hash functions. */
>> -static int
>> -_my_wcslen(__u16 *str)
>> -{
>> - =A0 =A0 int len =3D 0;
>> - =A0 =A0 while (*str++ !=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 len++;
>> - =A0 =A0 return len;
>> -}
>> -
>> -/*
>> - * Convert a string into an NT UNICODE string.
>> - * Note that regardless of processor type
>> - * this must be in intel (little-endian)
>> - * format.
>> - */
>> -
>> -static int
>> -_my_mbstowcs(__u16 *dst, const unsigned char *src, int len)
>> -{ =A0 =A0/* BB not a very good conversion routine - change/fix */
>> - =A0 =A0 int i;
>> - =A0 =A0 __u16 val;
>> -
>> - =A0 =A0 for (i =3D 0; i < len; i++) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 val =3D *src;
>> - =A0 =A0 =A0 =A0 =A0 =A0 SSVAL(dst, 0, val);
>> - =A0 =A0 =A0 =A0 =A0 =A0 dst++;
>> - =A0 =A0 =A0 =A0 =A0 =A0 src++;
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (val =3D=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> - =A0 =A0 }
>> - =A0 =A0 return i;
>> -}
>> -
>> =A0/*
>> =A0 * Creates the MD4 Hash of the users password in NT UNICODE.
>> =A0 */
>>
>> =A0int
>> -E_md4hash(const unsigned char *passwd, unsigned char *p16)
>> +E_md4hash(const unsigned char *passwd, unsigned char *p16,
>> + =A0 =A0 =A0 const struct nls_table *codepage)
>> =A0{
>> =A0 =A0 =A0 int rc;
>> =A0 =A0 =A0 int len;
>> @@ -242,20 +209,14 @@ E_md4hash(const unsigned char *passwd, unsigne=
d char *p16)
>>
>> =A0 =A0 =A0 /* Password cannot be longer than 128 characters */
>> =A0 =A0 =A0 if (passwd) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 len =3D strlen((char *) passwd);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (len > 128)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D 128;
>> -
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Password must be converted to NT unic=
ode */
>> - =A0 =A0 =A0 =A0 =A0 =A0 _my_mbstowcs(wpwd, passwd, len);
>> - =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS(wpwd, passwd, 128, c=
odepage);
>> + =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 *wpwd =3D 0; /* Ensure string is null term=
inated */
>> + =A0 =A0 }
>>
>> - =A0 =A0 wpwd[len] =3D 0; =A0/* Ensure string is null terminated */
>> - =A0 =A0 /* Calculate length in bytes */
>> - =A0 =A0 len =3D _my_wcslen(wpwd) * sizeof(__u16);
>> -
>> - =A0 =A0 rc =3D mdfour(p16, (unsigned char *) wpwd, len);
>> + =A0 =A0 rc =3D mdfour(p16, (unsigned char *) wpwd, len * sizeof(__=
u16));
>> =A0 =A0 =A0 memset(wpwd, 0, 129 * 2);
>>
>> =A0 =A0 =A0 return rc;
>> @@ -275,7 +236,7 @@ nt_lm_owf_gen(char *pwd, unsigned char nt_p16[16=
], unsigned char p16[16])
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(passwd, pwd, 512);
>> =A0 =A0 =A0 /* Calculate the MD4 hash (NT compatible) of the passwor=
d */
>> =A0 =A0 =A0 memset(nt_p16, '\0', 16);
>> - =A0 =A0 E_md4hash(passwd, nt_p16);
>> + =A0 =A0 E_md4hash(passwd, nt_p16, /* put nls codepage here */);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Won't this fail to compile?
>>
>> =A0 =A0 =A0 /* Mangle the passwords into Lanman format */
>> =A0 =A0 =A0 passwd[14] =3D '\0';
>> @@ -348,7 +309,8 @@ NTLMSSPOWFencrypt(unsigned char passwd[8],
>>
>> =A0/* Does the NT MD4 hash then des encryption. */
>> =A0int
>> -SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned cha=
r *p24)
>> +SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned cha=
r *p24,
>> + =A0 =A0 =A0 =A0 =A0const struct nls_table *codepage)
>> =A0{
>> =A0 =A0 =A0 int rc;
>> =A0 =A0 =A0 unsigned char p16[16], p21[21];
>> @@ -356,7 +318,7 @@ SMBNTencrypt(unsigned char *passwd, unsigned cha=
r *c8, unsigned char *p24)
>> =A0 =A0 =A0 memset(p16, '\0', 16);
>> =A0 =A0 =A0 memset(p21, '\0', 21);
>>
>> - =A0 =A0 rc =3D E_md4hash(passwd, p16);
>> + =A0 =A0 rc =3D E_md4hash(passwd, p16, codepage);
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s Can't generate NT hash, erro=
r: %d", __func__, rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
> --
> Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
>

Indeed, missed that.
