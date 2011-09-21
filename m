From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Assume passwords are encoded according to iocharset
Date: Wed, 21 Sep 2011 11:12:15 -0500
Message-ID: <CADT32eLX5i8a0ONHkFNvKyY852BRFRsfu_uQh7=RvUPO8TauXg@mail.gmail.com>
References: <20110327125648.GA3621@osk.mine.nu>
	<20110408093148.748eda25@corrin.poochiereds.net>
	<20110408141112.GA20074@osk.mine.nu>
	<20110408103118.0f1b2e8b@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	nimbus1_03087-/E1597aS9LQAvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110408103118.0f1b2e8b-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Apr 8, 2011 at 9:31 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 8 Apr 2011 16:11:12 +0200
> Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org> wrote:
>
>> On Friday, April 08, 2011 at 09:48, Jeff Layton wrote:
>> > On Sun, 27 Mar 2011 14:56:48 +0200
>> > Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org> wrote:
>> >
>> > > Modify cifs to assume that the supplied password is encoded acco=
rding to
>> > > iocharset. =A0Before this patch passwords would be treated as ra=
w 8-bit data,
>> > > which made authentication with Unicode passwords impossible (at =
least
>> > > passwords with characters > 0xFF).
>> > >
>> > > The previous code would as a side effect accept passwords encode=
d with ISO
>> > > 8859-1, since Unicode < 0x100 basically is ISO 8859-1. =A0Softwa=
re which
>> > > relies on that will no longer support password chars > 0x7F unle=
ss it also
>> > > uses iocharset=3Diso8859-1. =A0(mount.cifs does not care about t=
he encoding so
>> > > it will work as expected.)
>> > >
>> > > Signed-off-by: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
>> > > ---
>> > > =A0fs/cifs/cifsencrypt.c | =A0 =A08 +++---
>> > > =A0fs/cifs/cifsproto.h =A0 | =A0 =A08 ++++--
>> > > =A0fs/cifs/connect.c =A0 =A0 | =A0 =A02 +-
>> > > =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 =A02 +-
>> > > =A0fs/cifs/smbencrypt.c =A0| =A0 60 +++++++++-------------------=
---------------------
>> > > =A05 files changed, 22 insertions(+), 58 deletions(-)
>> > >
>> > > diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> > > index 5bb4b09..3c1306d 100644
>> > > --- a/fs/cifs/cifsencrypt.c
>> > > +++ b/fs/cifs/cifsencrypt.c
>> > > @@ -226,7 +226,7 @@ int cifs_verify_signature(struct smb_hdr *ci=
fs_pdu,
>> > > =A0}
>> > >
>> > > =A0/* first calculate 24 bytes ntlm response and then 16 byte se=
ssion key */
>> > > -int setup_ntlm_response(struct cifs_ses *ses)
>> > > +int setup_ntlm_response(struct cifs_ses *ses, const struct nls_=
table *nls_cp)
>> > > =A0{
>> > > =A0 int rc =3D 0;
>> > > =A0 unsigned int temp_len =3D CIFS_SESS_KEY_SIZE + CIFS_AUTH_RES=
P_SIZE;
>> > > @@ -243,14 +243,14 @@ int setup_ntlm_response(struct cifs_ses *s=
es)
>> > > =A0 ses->auth_key.len =3D temp_len;
>> > >
>> > > =A0 rc =3D SMBNTencrypt(ses->password, ses->server->cryptkey,
>> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->auth_key.response + CIFS_=
SESS_KEY_SIZE);
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->auth_key.response + CIFS_=
SESS_KEY_SIZE, nls_cp);
>> > > =A0 if (rc) {
>> > > =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s Can't generate NTLM response, er=
ror: %d",
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, rc);
>> > > =A0 =A0 =A0 =A0 =A0 return rc;
>> > > =A0 }
>> > >
>> > > - rc =3D E_md4hash(ses->password, temp_key);
>> > > + rc =3D E_md4hash(ses->password, temp_key, nls_cp);
>> > > =A0 if (rc) {
>> > > =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s Can't generate NT hash, error: %=
d", __func__, rc);
>> > > =A0 =A0 =A0 =A0 =A0 return rc;
>> > > @@ -458,7 +458,7 @@ static int calc_ntlmv2_hash(struct cifs_ses =
*ses, char *ntlmv2_hash,
>> > > =A0 }
>> > >
>> > > =A0 /* calculate md4 hash of password */
>> > > - E_md4hash(ses->password, nt_hash);
>> > > + E_md4hash(ses->password, nt_hash, nls_cp);
>> > >
>> > > =A0 crypto_shash_setkey(ses->server->secmech.hmacmd5, nt_hash,
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_NTHASH_=
SIZE);
>> > > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> > > index e42dc82..fd6d873 100644
>> > > --- a/fs/cifs/cifsproto.h
>> > > +++ b/fs/cifs/cifsproto.h
>> > > @@ -376,8 +376,9 @@ extern int cifs_sign_smb2(struct kvec *iov, =
int n_vec, struct TCP_Server_Info *,
>> > > =A0extern int cifs_verify_signature(struct smb_hdr *,
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct TC=
P_Server_Info *server,
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 expect=
ed_sequence_number);
>> > > -extern int SMBNTencrypt(unsigned char *, unsigned char *, unsig=
ned char *);
>> > > -extern int setup_ntlm_response(struct cifs_ses *);
>> > > +extern int SMBNTencrypt(unsigned char *, unsigned char *, unsig=
ned char *,
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *);
>> > > +extern int setup_ntlm_response(struct cifs_ses *, const struct =
nls_table *);
>> > > =A0extern int setup_ntlmv2_rsp(struct cifs_ses *, const struct n=
ls_table *);
>> > > =A0extern int cifs_crypto_shash_allocate(struct TCP_Server_Info =
*);
>> > > =A0extern void cifs_crypto_shash_release(struct TCP_Server_Info =
*);
>> > > @@ -429,7 +430,8 @@ extern int CIFSCheckMFSymlink(struct cifs_fa=
ttr *fattr,
>> > > =A0 =A0 =A0 =A0 =A0 const unsigned char *path,
>> > > =A0 =A0 =A0 =A0 =A0 struct cifs_sb_info *cifs_sb, int xid);
>> > > =A0extern int mdfour(unsigned char *, unsigned char *, int);
>> > > -extern int E_md4hash(const unsigned char *passwd, unsigned char=
 *p16);
>> > > +extern int E_md4hash(const unsigned char *passwd, unsigned char=
 *p16,
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct nls_table *codepage);
>> > > =A0extern int SMBencrypt(unsigned char *passwd, const unsigned c=
har *c8,
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned char *p24);
>> > > =A0#endif =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* _CIFSPROTO_H */
>> > > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> > > index 96544a4..3c0190f 100644
>> > > --- a/fs/cifs/connect.c
>> > > +++ b/fs/cifs/connect.c
>> > > @@ -3060,7 +3060,7 @@ CIFSTCon(unsigned int xid, struct cifs_ses=
 *ses,
>> > > =A0 =A0 =A0 =A0 =A0 else
>> > > =A0#endif /* CIFS_WEAK_PW_HASH */
>> > > =A0 =A0 =A0 =A0 =A0 rc =3D SMBNTencrypt(tcon->password, ses->ser=
ver->cryptkey,
>> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 bcc_ptr);
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 bcc_ptr, nls_codepage);
>> > >
>> > > =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D CIFS_AUTH_RESP_SIZE;
>> > > =A0 =A0 =A0 =A0 =A0 if (ses->capabilities & CAP_UNICODE) {
>> > > diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> > > index 6b140e1..17ae0db 100644
>> > > --- a/fs/cifs/sess.c
>> > > +++ b/fs/cifs/sess.c
>> > > @@ -694,7 +694,7 @@ ssetup_ntlmssp_authenticate:
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(CIFS_AUTH_RESP_S=
IZE);
>> > >
>> > > =A0 =A0 =A0 =A0 =A0 /* calculate ntlm response and session key *=
/
>> > > - =A0 =A0 =A0 =A0 rc =3D setup_ntlm_response(ses);
>> > > + =A0 =A0 =A0 =A0 rc =3D setup_ntlm_response(ses, nls_cp);
>> > > =A0 =A0 =A0 =A0 =A0 if (rc) {
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error %d during N=
TLM authentication", rc);
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
>> > > diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
>> > > index 1525d5e..92291c1 100644
>> > > --- a/fs/cifs/smbencrypt.c
>> > > +++ b/fs/cifs/smbencrypt.c
>> > > @@ -195,46 +195,13 @@ SMBencrypt(unsigned char *passwd, const un=
signed char *c8, unsigned char *p24)
>> > > =A0 return rc;
>> > > =A0}
>> > >
>> > > -/* Routines for Windows NT MD4 Hash functions. */
>> > > -static int
>> > > -_my_wcslen(__u16 *str)
>> > > -{
>> > > - int len =3D 0;
>> > > - while (*str++ !=3D 0)
>> > > - =A0 =A0 =A0 =A0 len++;
>> > > - return len;
>> > > -}
>> > > -
>> > > -/*
>> > > - * Convert a string into an NT UNICODE string.
>> > > - * Note that regardless of processor type
>> > > - * this must be in intel (little-endian)
>> > > - * format.
>> > > - */
>> > > -
>> > > -static int
>> > > -_my_mbstowcs(__u16 *dst, const unsigned char *src, int len)
>> > > -{ =A0 =A0 =A0 =A0/* BB not a very good conversion routine - cha=
nge/fix */
>> > > - int i;
>> > > - __u16 val;
>> > > -
>> > > - for (i =3D 0; i < len; i++) {
>> > > - =A0 =A0 =A0 =A0 val =3D *src;
>> > > - =A0 =A0 =A0 =A0 SSVAL(dst, 0, val);
>> > > - =A0 =A0 =A0 =A0 dst++;
>> > > - =A0 =A0 =A0 =A0 src++;
>> > > - =A0 =A0 =A0 =A0 if (val =3D=3D 0)
>> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> > > - }
>> > > - return i;
>> > > -}
>> > > -
>> > > =A0/*
>> > > =A0 * Creates the MD4 Hash of the users password in NT UNICODE.
>> > > =A0 */
>> > >
>> > > =A0int
>> > > -E_md4hash(const unsigned char *passwd, unsigned char *p16)
>> > > +E_md4hash(const unsigned char *passwd, unsigned char *p16,
>> > > + =A0 const struct nls_table *codepage)
>> > > =A0{
>> > > =A0 int rc;
>> > > =A0 int len;
>> > > @@ -242,20 +209,14 @@ E_md4hash(const unsigned char *passwd, uns=
igned char *p16)
>> > >
>> > > =A0 /* Password cannot be longer than 128 characters */
>> > > =A0 if (passwd) {
>> > > - =A0 =A0 =A0 =A0 len =3D strlen((char *) passwd);
>> > > - =A0 =A0 =A0 =A0 if (len > 128)
>> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D 128;
>> > > -
>> > > =A0 =A0 =A0 =A0 =A0 /* Password must be converted to NT unicode =
*/
>> > > - =A0 =A0 =A0 =A0 _my_mbstowcs(wpwd, passwd, len);
>> > > - } else
>> > > + =A0 =A0 =A0 =A0 len =3D cifs_strtoUCS(wpwd, passwd, 128, codep=
age);
>> > > + } else {
>> > > =A0 =A0 =A0 =A0 =A0 len =3D 0;
>> > > + =A0 =A0 =A0 =A0 *wpwd =3D 0; /* Ensure string is null terminat=
ed */
>> > > + }
>> > >
>> > > - wpwd[len] =3D 0; =A0/* Ensure string is null terminated */
>> > > - /* Calculate length in bytes */
>> > > - len =3D _my_wcslen(wpwd) * sizeof(__u16);
>> > > -
>> > > - rc =3D mdfour(p16, (unsigned char *) wpwd, len);
>> > > + rc =3D mdfour(p16, (unsigned char *) wpwd, len * sizeof(__u16)=
);
>> > > =A0 memset(wpwd, 0, 129 * 2);
>> > >
>> > > =A0 return rc;
>> > > @@ -275,7 +236,7 @@ nt_lm_owf_gen(char *pwd, unsigned char nt_p1=
6[16], unsigned char p16[16])
>> > > =A0 =A0 =A0 =A0 =A0 memcpy(passwd, pwd, 512);
>> > > =A0 /* Calculate the MD4 hash (NT compatible) of the password */
>> > > =A0 memset(nt_p16, '\0', 16);
>> > > - E_md4hash(passwd, nt_p16);
>> > > + E_md4hash(passwd, nt_p16, /* put nls codepage here */);
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ^^^^^^^^^^^^^
>> > =A0 =A0 =A0 =A0 =A0 =A0 Won't this fail to compile?
>>
>> Yes, but it's inside a function which is commented out and not compi=
led. Instead
>> of adding an extra parameter to the function (which would be require=
d) I
>> decided just to put a reminder there if that function is ever used i=
n the
>> future.
>>
>> #if 0 /* currently unused */
>> /* Does both the NT and LM owfs of a user's password */
>> static void
>> nt_lm_owf_gen(char *pwd, unsigned char nt_p16[16], unsigned char p16=
[16])
>> {
>> =A0 =A0 =A0 =A0 char passwd[514];
>>
>> =A0 =A0 =A0 =A0 memset(passwd, '\0', 514);
>> =A0 =A0 =A0 =A0 if (strlen(pwd) < 513)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strcpy(passwd, pwd);
>> =A0 =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(passwd, pwd, 512);
>> =A0 =A0 =A0 =A0 /* Calculate the MD4 hash (NT compatible) of the pas=
sword */
>> =A0 =A0 =A0 =A0 memset(nt_p16, '\0', 16);
>> =A0 =A0 =A0 =A0 E_md4hash(passwd, nt_p16, /* put nls codepage here *=
/);
>>
>> =A0 =A0 =A0 =A0 /* Mangle the passwords into Lanman format */
>> =A0 =A0 =A0 =A0 passwd[14] =3D '\0';
>> /* =A0 =A0 =A0strupper(passwd); */
>>
>> =A0 =A0 =A0 =A0 /* Calculate the SMB (lanman) hash functions of the =
password */
>>
>> =A0 =A0 =A0 =A0 memset(p16, '\0', 16);
>> =A0 =A0 =A0 =A0 E_P16((unsigned char *) passwd, (unsigned char *) p1=
6);
>>
>> =A0 =A0 =A0 =A0 /* clear out local copy of user's password (just bei=
ng paranoid). */
>> =A0 =A0 =A0 =A0 memset(passwd, '\0', sizeof(passwd));
>> }
>> #endif
>
> Ahh, ok. A perfect case to demonstrate why leaving unused crap lying
> around like this is a bad idea. Perhaps a better scheme would be a
> separate patch to just remove this function and then rebase your patc=
h
> on top of that?
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

I will resubmit this patch in a day to two with Jeff's comments incorpo=
rated.
It fixes bug 7386 on Samba bugzilla.
