From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Assume passwords are encoded according to
 iocharset
Date: Mon, 11 Apr 2011 15:16:37 -0400
Message-ID: <20110411151637.640495a5@corrin.poochiereds.net>
References: <20110327125648.GA3621@osk.mine.nu>
	<BANLkTimEhsjo2vfSE1w-D888hWn72H7Y3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimEhsjo2vfSE1w-D888hWn72H7Y3A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 11 Apr 2011 12:21:59 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Sun, Mar 27, 2011 at 7:56 AM, Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org> =
wrote:
> > Modify cifs to assume that the supplied password is encoded accordi=
ng to
> > iocharset. =C2=A0Before this patch passwords would be treated as ra=
w 8-bit data,
> > which made authentication with Unicode passwords impossible (at lea=
st
> > passwords with characters > 0xFF).
> >
> > The previous code would as a side effect accept passwords encoded w=
ith ISO
> > 8859-1, since Unicode < 0x100 basically is ISO 8859-1. =C2=A0Softwa=
re which
> > relies on that will no longer support password chars > 0x7F unless =
it also
> > uses iocharset=3Diso8859-1. =C2=A0(mount.cifs does not care about t=
he encoding so
> > it will work as expected.)
> >
> > Signed-off-by: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/cifsencrypt.c | =C2=A0 =C2=A08 +++---
> > =C2=A0fs/cifs/cifsproto.h =C2=A0 | =C2=A0 =C2=A08 ++++--
> > =C2=A0fs/cifs/connect.c =C2=A0 =C2=A0 | =C2=A0 =C2=A02 +-
> > =C2=A0fs/cifs/sess.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A02 +-
> > =C2=A0fs/cifs/smbencrypt.c =C2=A0| =C2=A0 60 +++++++++-------------=
---------------------------
> > =C2=A05 files changed, 22 insertions(+), 58 deletions(-)
> >
> > diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> > index 5bb4b09..3c1306d 100644
> > --- a/fs/cifs/cifsencrypt.c
> > +++ b/fs/cifs/cifsencrypt.c
> > @@ -226,7 +226,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_=
pdu,
> > =C2=A0}
> >
> > =C2=A0/* first calculate 24 bytes ntlm response and then 16 byte se=
ssion key */
> > -int setup_ntlm_response(struct cifs_ses *ses)
> > +int setup_ntlm_response(struct cifs_ses *ses, const struct nls_tab=
le *nls_cp)
> > =C2=A0{
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int rc =3D 0;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int temp_len =3D CIFS_SESS_KEY_=
SIZE + CIFS_AUTH_RESP_SIZE;
> > @@ -243,14 +243,14 @@ int setup_ntlm_response(struct cifs_ses *ses)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0ses->auth_key.len =3D temp_len;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D SMBNTencrypt(ses->password, ses->=
server->cryptkey,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ses->auth_key.response + CIFS_SESS_KEY_SIZE);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ses->auth_key.response + CIFS_SESS_KEY_SIZE, nls_cp);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (rc) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cFYI(1, "%s =
Can't generate NTLM response, error: %d",
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0__func__, rc);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > - =C2=A0 =C2=A0 =C2=A0 rc =3D E_md4hash(ses->password, temp_key);
> > + =C2=A0 =C2=A0 =C2=A0 rc =3D E_md4hash(ses->password, temp_key, nl=
s_cp);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (rc) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cFYI(1, "%s =
Can't generate NT hash, error: %d", __func__, rc);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> > @@ -458,7 +458,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *se=
s, char *ntlmv2_hash,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* calculate md4 hash of password */
> > - =C2=A0 =C2=A0 =C2=A0 E_md4hash(ses->password, nt_hash);
> > + =C2=A0 =C2=A0 =C2=A0 E_md4hash(ses->password, nt_hash, nls_cp);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0crypto_shash_setkey(ses->server->secmech=
=2Ehmacmd5, nt_hash,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CIFS_NTHASH_SIZE);
> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> > index e42dc82..fd6d873 100644
> > --- a/fs/cifs/cifsproto.h
> > +++ b/fs/cifs/cifsproto.h
> > @@ -376,8 +376,9 @@ extern int cifs_sign_smb2(struct kvec *iov, int=
 n_vec, struct TCP_Server_Info *,
> > =C2=A0extern int cifs_verify_signature(struct smb_hdr *,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct TCP_Server_Info *serv=
er,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__u32 expected_sequence_numbe=
r);
> > -extern int SMBNTencrypt(unsigned char *, unsigned char *, unsigned=
 char *);
> > -extern int setup_ntlm_response(struct cifs_ses *);
> > +extern int SMBNTencrypt(unsigned char *, unsigned char *, unsigned=
 char *,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 const struct nls_table *);
> > +extern int setup_ntlm_response(struct cifs_ses *, const struct nls=
_table *);
> > =C2=A0extern int setup_ntlmv2_rsp(struct cifs_ses *, const struct n=
ls_table *);
> > =C2=A0extern int cifs_crypto_shash_allocate(struct TCP_Server_Info =
*);
> > =C2=A0extern void cifs_crypto_shash_release(struct TCP_Server_Info =
*);
> > @@ -429,7 +430,8 @@ extern int CIFSCheckMFSymlink(struct cifs_fattr=
 *fattr,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const unsign=
ed char *path,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cifs_=
sb_info *cifs_sb, int xid);
> > =C2=A0extern int mdfour(unsigned char *, unsigned char *, int);
> > -extern int E_md4hash(const unsigned char *passwd, unsigned char *p=
16);
> > +extern int E_md4hash(const unsigned char *passwd, unsigned char *p=
16,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0const struct nls_table *codepage);
> > =C2=A0extern int SMBencrypt(unsigned char *passwd, const unsigned c=
har *c8,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0unsigned char *p24);
> > =C2=A0#endif =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 /* _CIFSPROTO_H */
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 96544a4..3c0190f 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -3060,7 +3060,7 @@ CIFSTCon(unsigned int xid, struct cifs_ses *s=
es,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else
> > =C2=A0#endif /* CIFS_WEAK_PW_HASH */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D SMBNT=
encrypt(tcon->password, ses->server->cryptkey,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bcc_=
ptr);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bcc_=
ptr, nls_codepage);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bcc_ptr +=3D=
 CIFS_AUTH_RESP_SIZE;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ses->cap=
abilities & CAP_UNICODE) {
> > diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> > index 6b140e1..17ae0db 100644
> > --- a/fs/cifs/sess.c
> > +++ b/fs/cifs/sess.c
> > @@ -694,7 +694,7 @@ ssetup_ntlmssp_authenticate:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0cpu_to_le16(CIFS_AUTH_RESP_SIZE);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* calculate=
 ntlm response and session key */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D setup_ntl=
m_response(ses);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D setup_ntl=
m_response(ses, nls_cp);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (rc) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0cERROR(1, "Error %d during NTLM authentication", rc);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0goto ssetup_exit;
> > diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
> > index 1525d5e..92291c1 100644
> > --- a/fs/cifs/smbencrypt.c
> > +++ b/fs/cifs/smbencrypt.c
> > @@ -195,46 +195,13 @@ SMBencrypt(unsigned char *passwd, const unsig=
ned char *c8, unsigned char *p24)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> > =C2=A0}
> >
> > -/* Routines for Windows NT MD4 Hash functions. */
> > -static int
> > -_my_wcslen(__u16 *str)
> > -{
> > - =C2=A0 =C2=A0 =C2=A0 int len =3D 0;
> > - =C2=A0 =C2=A0 =C2=A0 while (*str++ !=3D 0)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 len++;
> > - =C2=A0 =C2=A0 =C2=A0 return len;
> > -}
> > -
> > -/*
> > - * Convert a string into an NT UNICODE string.
> > - * Note that regardless of processor type
> > - * this must be in intel (little-endian)
> > - * format.
> > - */
> > -
> > -static int
> > -_my_mbstowcs(__u16 *dst, const unsigned char *src, int len)
> > -{ =C2=A0 =C2=A0 =C2=A0/* BB not a very good conversion routine - c=
hange/fix */
> > - =C2=A0 =C2=A0 =C2=A0 int i;
> > - =C2=A0 =C2=A0 =C2=A0 __u16 val;
> > -
> > - =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < len; i++) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 val =3D *src;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 SSVAL(dst, 0, va=
l);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dst++;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 src++;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (val =3D=3D 0=
)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> > - =C2=A0 =C2=A0 =C2=A0 }
> > - =C2=A0 =C2=A0 =C2=A0 return i;
> > -}
> > -
> > =C2=A0/*
> > =C2=A0* Creates the MD4 Hash of the users password in NT UNICODE.
> > =C2=A0*/
> >
> > =C2=A0int
> > -E_md4hash(const unsigned char *passwd, unsigned char *p16)
> > +E_md4hash(const unsigned char *passwd, unsigned char *p16,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct nls_table *codepage)
> > =C2=A0{
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int rc;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int len;
> > @@ -242,20 +209,14 @@ E_md4hash(const unsigned char *passwd, unsign=
ed char *p16)
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Password cannot be longer than 128 ch=
aracters */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (passwd) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 len =3D strlen((=
char *) passwd);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (len > 128)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 len =3D 128;
> > -
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Password =
must be converted to NT unicode */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 _my_mbstowcs(wpw=
d, passwd, len);
> > - =C2=A0 =C2=A0 =C2=A0 } else
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 len =3D cifs_str=
toUCS(wpwd, passwd, 128, codepage);
> > + =C2=A0 =C2=A0 =C2=A0 } else {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0len =3D 0;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *wpwd =3D 0; /* =
Ensure string is null terminated */
> > + =C2=A0 =C2=A0 =C2=A0 }
> >
> > - =C2=A0 =C2=A0 =C2=A0 wpwd[len] =3D 0; =C2=A0/* Ensure string is n=
ull terminated */
> > - =C2=A0 =C2=A0 =C2=A0 /* Calculate length in bytes */
> > - =C2=A0 =C2=A0 =C2=A0 len =3D _my_wcslen(wpwd) * sizeof(__u16);
> > -
> > - =C2=A0 =C2=A0 =C2=A0 rc =3D mdfour(p16, (unsigned char *) wpwd, l=
en);
> > + =C2=A0 =C2=A0 =C2=A0 rc =3D mdfour(p16, (unsigned char *) wpwd, l=
en * sizeof(__u16));
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(wpwd, 0, 129 * 2);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> > @@ -275,7 +236,7 @@ nt_lm_owf_gen(char *pwd, unsigned char nt_p16[1=
6], unsigned char p16[16])
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0memcpy(passw=
d, pwd, 512);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Calculate the MD4 hash (NT compatible=
) of the password */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(nt_p16, '\0', 16);
> > - =C2=A0 =C2=A0 =C2=A0 E_md4hash(passwd, nt_p16);
> > + =C2=A0 =C2=A0 =C2=A0 E_md4hash(passwd, nt_p16, /* put nls codepag=
e here */);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Mangle the passwords into Lanman form=
at */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0passwd[14] =3D '\0';
> > @@ -348,7 +309,8 @@ NTLMSSPOWFencrypt(unsigned char passwd[8],
> >
> > =C2=A0/* Does the NT MD4 hash then des encryption. */
> > =C2=A0int
> > -SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned ch=
ar *p24)
> > +SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned ch=
ar *p24,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const struct nls_table *=
codepage)
> > =C2=A0{
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int rc;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned char p16[16], p21[21];
> > @@ -356,7 +318,7 @@ SMBNTencrypt(unsigned char *passwd, unsigned ch=
ar *c8, unsigned char *p24)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(p16, '\0', 16);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(p21, '\0', 21);
> >
> > - =C2=A0 =C2=A0 =C2=A0 rc =3D E_md4hash(passwd, p16);
> > + =C2=A0 =C2=A0 =C2=A0 rc =3D E_md4hash(passwd, p16, codepage);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (rc) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cFYI(1, "%s =
Can't generate NT hash, error: %d", __func__, rc);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
> >
>=20
> With this patch, I am unable to mount a share if user's password happ=
ens to
> contain characters like $ e.g. aa$a.
> A Windows client can.

If you compare traces in wireshark, are there differences in how the
username is encoded?
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
