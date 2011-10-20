From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Assume passwords are encoded according to iocharset
 (try #2)
Date: Thu, 20 Oct 2011 16:39:24 -0500
Message-ID: <CADT32eJ1t=MYCgn6-7Bpac7W1Xa5qeGUdR3zFvO+TU34kQQ-yw@mail.gmail.com>
References: <1319134919-4300-1-git-send-email-shirishpargaonkar@gmail.com>
	<CADT32eKSE1DLpTnpNxhAvcLHPmb_8Fx+jEJUdUzo17eSHByETA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eKSE1DLpTnpNxhAvcLHPmb_8Fx+jEJUdUzo17eSHByETA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 20, 2011 at 4:26 PM, Shirish Pargaonkar
<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Oct 20, 2011 at 1:21 PM, =A0<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Re-posting a patch originally posted by Oskar Liljeblad after
>> rebasing on 3.2.
>>
>>
>> Modify cifs to assume that the supplied password is encoded accordin=
g
>> to iocharset. =A0Before this patch passwords would be treated as
>> raw 8-bit data, which made authentication with Unicode passwords imp=
ossible
>> (at least passwords with characters > 0xFF).
>>
>> The previous code would as a side effect accept passwords encoded wi=
th
>> ISO 8859-1, since Unicode < 0x100 basically is ISO 8859-1. =A0Softwa=
re which
>> relies on that will no longer support password chars > 0x7F unless i=
t also
>> uses iocharset=3Diso8859-1. =A0(mount.cifs does not care about the e=
ncoding so
>> it will work as expected.)
>>
>> Signed-off-by: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Tested-by: A <nimbus1_03087-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsencrypt.c | =A0 =A08 +++---
>> =A0fs/cifs/cifsproto.h =A0 | =A0 =A08 ++++--
>> =A0fs/cifs/connect.c =A0 =A0 | =A0 =A02 +-
>> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 =A02 +-
>> =A0fs/cifs/smbencrypt.c =A0| =A0 63 +++++++++-----------------------=
----------------
>> =A05 files changed, 23 insertions(+), 60 deletions(-)
>>
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index 2cfb695..5d9b9ac 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -204,7 +204,7 @@ int cifs_verify_signature(struct kvec *iov, unsi=
gned int nr_iov,
>> =A0}
>>
>> =A0/* first calculate 24 bytes ntlm response and then 16 byte sessio=
n key */
>> -int setup_ntlm_response(struct cifs_ses *ses)
>> +int setup_ntlm_response(struct cifs_ses *ses, const struct nls_tabl=
e *nls_cp)
>> =A0{
>> =A0 =A0 =A0 =A0int rc =3D 0;
>> =A0 =A0 =A0 =A0unsigned int temp_len =3D CIFS_SESS_KEY_SIZE + CIFS_A=
UTH_RESP_SIZE;
>> @@ -221,14 +221,14 @@ int setup_ntlm_response(struct cifs_ses *ses)
>> =A0 =A0 =A0 =A0ses->auth_key.len =3D temp_len;
>>
>> =A0 =A0 =A0 =A0rc =3D SMBNTencrypt(ses->password, ses->server->crypt=
key,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->auth_key.response=
 + CIFS_SESS_KEY_SIZE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->auth_key.response=
 + CIFS_SESS_KEY_SIZE, nls_cp);
>> =A0 =A0 =A0 =A0if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "%s Can't generate NTLM respo=
nse, error: %d",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__, rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>> =A0 =A0 =A0 =A0}
>>
>> - =A0 =A0 =A0 rc =3D E_md4hash(ses->password, temp_key);
>> + =A0 =A0 =A0 rc =3D E_md4hash(ses->password, temp_key, nls_cp);
>> =A0 =A0 =A0 =A0if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "%s Can't generate NT hash, e=
rror: %d", __func__, rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>> @@ -404,7 +404,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses=
, char *ntlmv2_hash,
>> =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0/* calculate md4 hash of password */
>> - =A0 =A0 =A0 E_md4hash(ses->password, nt_hash);
>> + =A0 =A0 =A0 E_md4hash(ses->password, nt_hash, nls_cp);
>>
>> =A0 =A0 =A0 =A0rc =3D crypto_shash_setkey(ses->server->secmech.hmacm=
d5, nt_hash,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_=
NTHASH_SIZE);
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index c25d063..17ad887 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -392,8 +392,9 @@ extern int cifs_sign_smb2(struct kvec *iov, int =
n_vec, struct TCP_Server_Info *,
>> =A0extern int cifs_verify_signature(struct kvec *iov, unsigned int n=
r_iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stru=
ct TCP_Server_Info *server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32=
 expected_sequence_number);
>> -extern int SMBNTencrypt(unsigned char *, unsigned char *, unsigned =
char *);
>> -extern int setup_ntlm_response(struct cifs_ses *);
>> +extern int SMBNTencrypt(unsigned char *, unsigned char *, unsigned =
char *,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table=
 *);
>> +extern int setup_ntlm_response(struct cifs_ses *, const struct nls_=
table *);
>> =A0extern int setup_ntlmv2_rsp(struct cifs_ses *, const struct nls_t=
able *);
>> =A0extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
>> =A0extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
>> @@ -445,7 +446,8 @@ extern int CIFSCheckMFSymlink(struct cifs_fattr =
*fattr,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const unsigned char *path,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb, int xid=
);
>> =A0extern int mdfour(unsigned char *, unsigned char *, int);
>> -extern int E_md4hash(const unsigned char *passwd, unsigned char *p1=
6);
>> +extern int E_md4hash(const unsigned char *passwd, unsigned char *p1=
6,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table=
 *codepage);
>> =A0extern int SMBencrypt(unsigned char *passwd, const unsigned char =
*c8,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned char *p24);
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index f70d87d..4737e95 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -3452,7 +3452,7 @@ CIFSTCon(unsigned int xid, struct cifs_ses *se=
s,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
>> =A0#endif /* CIFS_WEAK_PW_HASH */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D SMBNTencrypt(tcon->password, s=
es->server->cryptkey,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 bcc_ptr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 bcc_ptr, nls_codepage);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bcc_ptr +=3D CIFS_AUTH_RESP_SIZE;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ses->capabilities & CAP_UNICODE) =
{
>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> index c7d80e2..4ec3ee9 100644
>> --- a/fs/cifs/sess.c
>> +++ b/fs/cifs/sess.c
>> @@ -683,7 +683,7 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le16(CIFS_AUTH=
_RESP_SIZE);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* calculate ntlm response and sessio=
n key */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D setup_ntlm_response(ses);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D setup_ntlm_response(ses, nls_cp=
);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Error %d d=
uring NTLM authentication", rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto ssetup_exit;
>> diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
>> index ac1221d..7cacba1 100644
>> --- a/fs/cifs/smbencrypt.c
>> +++ b/fs/cifs/smbencrypt.c
>> @@ -199,75 +199,36 @@ SMBencrypt(unsigned char *passwd, const unsign=
ed char *c8, unsigned char *p24)
>> =A0 =A0 =A0 =A0return rc;
>> =A0}
>>
>> -/* Routines for Windows NT MD4 Hash functions. */
>> -static int
>> -_my_wcslen(__u16 *str)
>> -{
>> - =A0 =A0 =A0 int len =3D 0;
>> - =A0 =A0 =A0 while (*str++ !=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 len++;
>> - =A0 =A0 =A0 return len;
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
>> -{ =A0 =A0 =A0/* BB not a very good conversion routine - change/fix =
*/
>> - =A0 =A0 =A0 int i;
>> - =A0 =A0 =A0 __u16 val;
>> -
>> - =A0 =A0 =A0 for (i =3D 0; i < len; i++) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 val =3D *src;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 SSVAL(dst, 0, val);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dst++;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 src++;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (val =3D=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> - =A0 =A0 =A0 }
>> - =A0 =A0 =A0 return i;
>> -}
>> -
>> =A0/*
>> =A0* Creates the MD4 Hash of the users password in NT UNICODE.
>> =A0*/
>>
>> =A0int
>> -E_md4hash(const unsigned char *passwd, unsigned char *p16)
>> +E_md4hash(const unsigned char *passwd, unsigned char *p16,
>> + =A0 =A0 =A0 const struct nls_table *codepage)
>> =A0{
>> =A0 =A0 =A0 =A0int rc;
>> =A0 =A0 =A0 =A0int len;
>> =A0 =A0 =A0 =A0__u16 wpwd[129];
>>
>> =A0 =A0 =A0 =A0/* Password cannot be longer than 128 characters */
>> - =A0 =A0 =A0 if (passwd) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D strlen((char *) passwd);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (len > 128)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D 128;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Password must be converted to NT un=
icode */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 _my_mbstowcs(wpwd, passwd, len);
>> - =A0 =A0 =A0 } else
>> + =A0 =A0 =A0 if (passwd) /* Password must be converted to NT unicod=
e */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS(wpwd, passwd, 12=
8, codepage);
>> + =A0 =A0 =A0 else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0len =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *wpwd =3D 0; /* Ensure string is null =
terminated */
>> + =A0 =A0 =A0 }
>>
>> - =A0 =A0 =A0 wpwd[len] =3D 0; =A0/* Ensure string is null terminate=
d */
>> - =A0 =A0 =A0 /* Calculate length in bytes */
>> - =A0 =A0 =A0 len =3D _my_wcslen(wpwd) * sizeof(__u16);
>> -
>> - =A0 =A0 =A0 rc =3D mdfour(p16, (unsigned char *) wpwd, len);
>> - =A0 =A0 =A0 memset(wpwd, 0, 129 * 2);
>> + =A0 =A0 =A0 rc =3D mdfour(p16, (unsigned char *) wpwd, len * sizeo=
f(__u16));
>> + =A0 =A0 =A0 memset(wpwd, 0, 129 * sizeof(__u16));
>>
>> =A0 =A0 =A0 =A0return rc;
>> =A0}
>>
>> =A0/* Does the NT MD4 hash then des encryption. */
>> =A0int
>> -SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned cha=
r *p24)
>> +SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned cha=
r *p24,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *codepage)
>> =A0{
>> =A0 =A0 =A0 =A0int rc;
>> =A0 =A0 =A0 =A0unsigned char p16[16], p21[21];
>> @@ -275,7 +236,7 @@ SMBNTencrypt(unsigned char *passwd, unsigned cha=
r *c8, unsigned char *p24)
>> =A0 =A0 =A0 =A0memset(p16, '\0', 16);
>> =A0 =A0 =A0 =A0memset(p21, '\0', 21);
>>
>> - =A0 =A0 =A0 rc =3D E_md4hash(passwd, p16);
>> + =A0 =A0 =A0 rc =3D E_md4hash(passwd, p16, codepage);
>> =A0 =A0 =A0 =A0if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "%s Can't generate NT hash, e=
rror: %d", __func__, rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>> --
>> 1.6.0.2
>>
>>
>
> I think the basic problem is, whether/how a
> client can identify every character in a given
> password in order to generate a unicode
> password to be used to calculate ntlm response
> that matches the unicode password that server
> uses in order to calculate ntlm response and
> match both the responses.
>
> Regards,
>
> Shirish
>

The code page used by client could be different  than
the code page used by the server, so password could
have characters that do not belong to the code page
on the client.

Even if the code pages are same, encoding could
be different.  So the same unicode blob generated
on the client would look different that the unicode
blob generated on the server.
