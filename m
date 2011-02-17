From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Use ecb des kernel crypto APIs instead of local
 cifs functions
Date: Thu, 17 Feb 2011 11:00:43 -0600
Message-ID: <AANLkTimjoHyeSLcE6Qnrwc0noU=Gggb6mQT7_G2RTVJL@mail.gmail.com>
References: <1297726423-10547-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1297726423-10547-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Feb 14, 2011 at 5:33 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> Use kernel crypto APIs for DES encryption during LM and NT hash gener=
ation
> instead of local functions within cifs.
> Source file smbdes.c is deleted excpet four functions, one of which
> uses ecb des functionality provided by kernel crypto apis.
>
> Change lnm_session_key back to 24 bytes instead of 16 bytes.
> Remove function SMBOWFencrypt.
>
> Add return codes to various functions such as calc_lanman_hash,
> SMBencrypt, and SMBencrypt.
>
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/Kconfig =A0 =A0 =A0 | =A0 =A01 +
> =A0fs/cifs/Makefile =A0 =A0 =A0| =A0 =A02 +-
> =A0fs/cifs/cifsencrypt.c | =A0 10 +-
> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 =A03 +-
> =A0fs/cifs/cifsproto.h =A0 | =A0 =A07 +-
> =A0fs/cifs/connect.c =A0 =A0 | =A0 =A03 +-
> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 =A04 +-
> =A0fs/cifs/smbdes.c =A0 =A0 =A0| =A0418 -----------------------------=
--------------------
> =A0fs/cifs/smbencrypt.c =A0| =A0125 ++++++++++++---
> =A09 files changed, 115 insertions(+), 458 deletions(-)
> =A0delete mode 100644 fs/cifs/smbdes.c
>
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index 7cb0f7f..99ff2ca 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -7,6 +7,7 @@ config CIFS
> =A0 =A0 =A0 =A0select CRYPTO_MD5
> =A0 =A0 =A0 =A0select CRYPTO_HMAC
> =A0 =A0 =A0 =A0select CRYPTO_ARC4
> + =A0 =A0 =A0 select CRYPTO_DES
> =A0 =A0 =A0 =A0help
> =A0 =A0 =A0 =A0 =A0This is the client VFS module for the Common Inter=
net File System
> =A0 =A0 =A0 =A0 =A0(CIFS) protocol which is the successor to the Serv=
er Message Block
> diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
> index d875584..005d524 100644
> --- a/fs/cifs/Makefile
> +++ b/fs/cifs/Makefile
> @@ -4,7 +4,7 @@
> =A0obj-$(CONFIG_CIFS) +=3D cifs.o
>
> =A0cifs-y :=3D cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o=
 inode.o \
> - =A0 =A0 =A0 =A0 link.o misc.o netmisc.o smbdes.o smbencrypt.o trans=
port.o asn1.o \
> + =A0 =A0 =A0 =A0 link.o misc.o netmisc.o smbencrypt.o transport.o as=
n1.o \
> =A0 =A0 =A0 =A0 =A0cifs_unicode.o nterr.o xattr.o cifsencrypt.o \
> =A0 =A0 =A0 =A0 =A0readdir.o ioctl.o sess.o export.o
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index a51585f..7a54624 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -265,10 +265,11 @@ int setup_ntlm_response(struct cifsSesInfo *ses=
)
> =A0}
>
> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
> -void calc_lanman_hash(const char *password, const char *cryptkey, bo=
ol encrypt,
> +int calc_lanman_hash(const char *password, const char *cryptkey, boo=
l encrypt,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char *lnm_session_key)
> =A0{
> =A0 =A0 =A0 =A0int i;
> + =A0 =A0 =A0 int rc;
> =A0 =A0 =A0 =A0char password_with_pad[CIFS_ENCPWD_SIZE];
>
> =A0 =A0 =A0 =A0memset(password_with_pad, 0, CIFS_ENCPWD_SIZE);
> @@ -279,7 +280,7 @@ void calc_lanman_hash(const char *password, const=
 char *cryptkey, bool encrypt,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memset(lnm_session_key, 0, CIFS_SESS_K=
EY_SIZE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy(lnm_session_key, password_with_=
pad,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_ENCPWD_SIZE);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/* calculate old style session key */
> @@ -296,10 +297,9 @@ void calc_lanman_hash(const char *password, cons=
t char *cryptkey, bool encrypt,
> =A0 =A0 =A0 =A0for (i =3D 0; i < CIFS_ENCPWD_SIZE; i++)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0password_with_pad[i] =3D toupper(passw=
ord_with_pad[i]);
>
> - =A0 =A0 =A0 SMBencrypt(password_with_pad, cryptkey, lnm_session_key=
);
> + =A0 =A0 =A0 rc =3D SMBencrypt(password_with_pad, cryptkey, lnm_sess=
ion_key);
>
> - =A0 =A0 =A0 /* clear password before we return/free memory */
> - =A0 =A0 =A0 memset(password_with_pad, 0, CIFS_ENCPWD_SIZE);
> + =A0 =A0 =A0 return rc;
> =A0}
> =A0#endif /* CIFS_WEAK_PW_HASH */
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 17afb0f..0b5c950 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -710,7 +710,8 @@ require use of the stronger protocol */
> =A0#define =A0 CIFSSEC_MUST_SEAL =A0 =A00x40040 /* not supported yet =
*/
> =A0#define =A0 CIFSSEC_MUST_NTLMSSP 0x80080 /* raw ntlmssp with ntlmv=
2 */
>
> -#define =A0 CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLM | CIFSS=
EC_MAY_NTLMV2)
> +#define =A0 CIFSSEC_DEF (CIFSSEC_MAY_LANMAN | CIFSSEC_MAY_SIGN | \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSEC_MAY_NTLM | CIFS=
SEC_MAY_NTLMV2)
> =A0#define =A0 CIFSSEC_MAX (CIFSSEC_MUST_SIGN | CIFSSEC_MUST_NTLMV2)
> =A0#define =A0 CIFSSEC_AUTH_MASK (CIFSSEC_MAY_NTLM | CIFSSEC_MAY_NTLM=
V2 | CIFSSEC_MAY_LANMAN | CIFSSEC_MAY_PLNTXT | CIFSSEC_MAY_KRB5 | CIFSS=
EC_MAY_NTLMSSP)
> =A0/*
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 8096f27..e131f85 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -383,7 +383,7 @@ extern void cifs_crypto_shash_release(struct TCP_=
Server_Info *);
> =A0extern int calc_seckey(struct cifsSesInfo *);
>
> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
> -extern void calc_lanman_hash(const char *password, const char *crypt=
key,
> +extern int calc_lanman_hash(const char *password, const char *cryptk=
ey,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool e=
ncrypt, char *lnm_session_key);
> =A0#endif /* CIFS_WEAK_PW_HASH */
> =A0extern int CIFSSMBCopy(int xid,
> @@ -427,9 +427,6 @@ extern int CIFSCheckMFSymlink(struct cifs_fattr *=
fattr,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb, int xid)=
;
> =A0extern int mdfour(unsigned char *, unsigned char *, int);
> =A0extern int E_md4hash(const unsigned char *passwd, unsigned char *p=
16);
> -extern void SMBencrypt(unsigned char *passwd, const unsigned char *c=
8,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned char *p24);
> -extern void E_P16(unsigned char *p14, unsigned char *p16);
> -extern void E_P24(unsigned char *p21, const unsigned char *c8,
> +extern int SMBencrypt(unsigned char *passwd, const unsigned char *c8=
,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned char *p24);
> =A0#endif =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* _CIFSPROTO_H */
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 8d6c17a..25fdfb7 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3004,7 +3004,8 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *=
ses,
> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((global_secflags & CIFSSEC_MAY_LAN=
MAN) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(ses->server->secType =3D=3D L=
ANMAN))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 calc_lanman_hash(tcon->=
password, ses->server->cryptkey,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D calc_lanman_hash=
(tcon->password,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->se=
rver->cryptkey,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ses->server->secMode &
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0SECMODE_PW_ENCRYPT ? true : false,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 bcc_ptr);
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 1adc962..6d3143c 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -656,7 +656,7 @@ ssetup_ntlmssp_authenticate:
>
> =A0 =A0 =A0 =A0if (type =3D=3D LANMAN) {
> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 char lnm_session_key[CIFS_SESS_KEY_SIZE=
];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 char lnm_session_key[CIFS_AUTH_RESP_SIZ=
E];
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->req.hdr.Flags2 &=3D ~SMBFLG2_UNI=
CODE;
>
> @@ -670,7 +670,7 @@ ssetup_ntlmssp_authenticate:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * to use challenge/response method (i=
=2Ee. Password bit is 1).
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 calc_lanman_hash(ses->password, ses->se=
rver->cryptkey,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D calc_lanman_hash(ses->password, =
ses->server->cryptkey,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->=
server->secMode & SECMODE_PW_ENCRYPT ?
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0true : false, lnm_session_key);
>
> diff --git a/fs/cifs/smbdes.c b/fs/cifs/smbdes.c
> deleted file mode 100644
> index 0472148..0000000
> --- a/fs/cifs/smbdes.c
> +++ /dev/null
> @@ -1,418 +0,0 @@
> -/*
> - =A0 Unix SMB/Netbios implementation.
> - =A0 Version 1.9.
> -
> - =A0 a partial implementation of DES designed for use in the
> - =A0 SMB authentication protocol
> -
> - =A0 Copyright (C) Andrew Tridgell 1998
> - =A0 Modified by Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org) 2002,2004
> -
> - =A0 This program is free software; you can redistribute it and/or m=
odify
> - =A0 it under the terms of the GNU General Public License as publish=
ed by
> - =A0 the Free Software Foundation; either version 2 of the License, =
or
> - =A0 (at your option) any later version.
> -
> - =A0 This program is distributed in the hope that it will be useful,
> - =A0 but WITHOUT ANY WARRANTY; without even the implied warranty of
> - =A0 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =A0See the
> - =A0 GNU General Public License for more details.
> -
> - =A0 You should have received a copy of the GNU General Public Licen=
se
> - =A0 along with this program; if not, write to the Free Software
> - =A0 Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> -*/
> -
> -/* NOTES:
> -
> - =A0 This code makes no attempt to be fast! In fact, it is a very
> - =A0 slow implementation
> -
> - =A0 This code is NOT a complete DES implementation. It implements o=
nly
> - =A0 the minimum necessary for SMB authentication, as used by all SM=
B
> - =A0 products (including every copy of Microsoft Windows95 ever sold=
)
> -
> - =A0 In particular, it can only do a unchained forward DES pass. Thi=
s
> - =A0 means it is not possible to use this code for encryption/decryp=
tion
> - =A0 of data, instead it is only useful as a "hash" algorithm.
> -
> - =A0 There is no entry point into this code that allows normal DES o=
peration.
> -
> - =A0 I believe this means that this code does not come under ITAR
> - =A0 regulations but this is NOT a legal opinion. If you are concern=
ed
> - =A0 about the applicability of ITAR regulations to this code then y=
ou
> - =A0 should confirm it for yourself (and maybe let me know if you co=
me
> - =A0 up with a different answer to the one above)
> -*/
> -#include <linux/slab.h>
> -#define uchar unsigned char
> -
> -static uchar perm1[56] =3D { 57, 49, 41, 33, 25, 17, 9,
> - =A0 =A0 =A0 1, 58, 50, 42, 34, 26, 18,
> - =A0 =A0 =A0 10, 2, 59, 51, 43, 35, 27,
> - =A0 =A0 =A0 19, 11, 3, 60, 52, 44, 36,
> - =A0 =A0 =A0 63, 55, 47, 39, 31, 23, 15,
> - =A0 =A0 =A0 7, 62, 54, 46, 38, 30, 22,
> - =A0 =A0 =A0 14, 6, 61, 53, 45, 37, 29,
> - =A0 =A0 =A0 21, 13, 5, 28, 20, 12, 4
> -};
> -
> -static uchar perm2[48] =3D { 14, 17, 11, 24, 1, 5,
> - =A0 =A0 =A0 3, 28, 15, 6, 21, 10,
> - =A0 =A0 =A0 23, 19, 12, 4, 26, 8,
> - =A0 =A0 =A0 16, 7, 27, 20, 13, 2,
> - =A0 =A0 =A0 41, 52, 31, 37, 47, 55,
> - =A0 =A0 =A0 30, 40, 51, 45, 33, 48,
> - =A0 =A0 =A0 44, 49, 39, 56, 34, 53,
> - =A0 =A0 =A0 46, 42, 50, 36, 29, 32
> -};
> -
> -static uchar perm3[64] =3D { 58, 50, 42, 34, 26, 18, 10, 2,
> - =A0 =A0 =A0 60, 52, 44, 36, 28, 20, 12, 4,
> - =A0 =A0 =A0 62, 54, 46, 38, 30, 22, 14, 6,
> - =A0 =A0 =A0 64, 56, 48, 40, 32, 24, 16, 8,
> - =A0 =A0 =A0 57, 49, 41, 33, 25, 17, 9, 1,
> - =A0 =A0 =A0 59, 51, 43, 35, 27, 19, 11, 3,
> - =A0 =A0 =A0 61, 53, 45, 37, 29, 21, 13, 5,
> - =A0 =A0 =A0 63, 55, 47, 39, 31, 23, 15, 7
> -};
> -
> -static uchar perm4[48] =3D { 32, 1, 2, 3, 4, 5,
> - =A0 =A0 =A0 4, 5, 6, 7, 8, 9,
> - =A0 =A0 =A0 8, 9, 10, 11, 12, 13,
> - =A0 =A0 =A0 12, 13, 14, 15, 16, 17,
> - =A0 =A0 =A0 16, 17, 18, 19, 20, 21,
> - =A0 =A0 =A0 20, 21, 22, 23, 24, 25,
> - =A0 =A0 =A0 24, 25, 26, 27, 28, 29,
> - =A0 =A0 =A0 28, 29, 30, 31, 32, 1
> -};
> -
> -static uchar perm5[32] =3D { 16, 7, 20, 21,
> - =A0 =A0 =A0 29, 12, 28, 17,
> - =A0 =A0 =A0 1, 15, 23, 26,
> - =A0 =A0 =A0 5, 18, 31, 10,
> - =A0 =A0 =A0 2, 8, 24, 14,
> - =A0 =A0 =A0 32, 27, 3, 9,
> - =A0 =A0 =A0 19, 13, 30, 6,
> - =A0 =A0 =A0 22, 11, 4, 25
> -};
> -
> -static uchar perm6[64] =3D { 40, 8, 48, 16, 56, 24, 64, 32,
> - =A0 =A0 =A0 39, 7, 47, 15, 55, 23, 63, 31,
> - =A0 =A0 =A0 38, 6, 46, 14, 54, 22, 62, 30,
> - =A0 =A0 =A0 37, 5, 45, 13, 53, 21, 61, 29,
> - =A0 =A0 =A0 36, 4, 44, 12, 52, 20, 60, 28,
> - =A0 =A0 =A0 35, 3, 43, 11, 51, 19, 59, 27,
> - =A0 =A0 =A0 34, 2, 42, 10, 50, 18, 58, 26,
> - =A0 =A0 =A0 33, 1, 41, 9, 49, 17, 57, 25
> -};
> -
> -static uchar sc[16] =3D { 1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, =
2, 1 };
> -
> -static uchar sbox[8][4][16] =3D {
> - =A0 =A0 =A0 {{14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7}=
,
> - =A0 =A0 =A0 =A0{0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, =
8},
> - =A0 =A0 =A0 =A0{4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, =
0},
> - =A0 =A0 =A0 =A0{15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 1=
3} },
> -
> - =A0 =A0 =A0 {{15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10}=
,
> - =A0 =A0 =A0 =A0{3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, =
5},
> - =A0 =A0 =A0 =A0{0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 1=
5},
> - =A0 =A0 =A0 =A0{13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, =
9} },
> -
> - =A0 =A0 =A0 {{10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8}=
,
> - =A0 =A0 =A0 =A0{13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, =
1},
> - =A0 =A0 =A0 =A0{13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, =
7},
> - =A0 =A0 =A0 =A0{1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 1=
2} },
> -
> - =A0 =A0 =A0 {{7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15}=
,
> - =A0 =A0 =A0 =A0{13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, =
9},
> - =A0 =A0 =A0 =A0{10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, =
4},
> - =A0 =A0 =A0 =A0{3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 1=
4} },
> -
> - =A0 =A0 =A0 {{2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9}=
,
> - =A0 =A0 =A0 =A0{14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, =
6},
> - =A0 =A0 =A0 =A0{4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 1=
4},
> - =A0 =A0 =A0 =A0{11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, =
3} },
> -
> - =A0 =A0 =A0 {{12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11}=
,
> - =A0 =A0 =A0 =A0{10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, =
8},
> - =A0 =A0 =A0 =A0{9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, =
6},
> - =A0 =A0 =A0 =A0{4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 1=
3} },
> -
> - =A0 =A0 =A0 {{4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1}=
,
> - =A0 =A0 =A0 =A0{13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, =
6},
> - =A0 =A0 =A0 =A0{1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, =
2},
> - =A0 =A0 =A0 =A0{6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 1=
2} },
> -
> - =A0 =A0 =A0 {{13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7}=
,
> - =A0 =A0 =A0 =A0{1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, =
2},
> - =A0 =A0 =A0 =A0{7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, =
8},
> - =A0 =A0 =A0 =A0{2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 1=
1} }
> -};
> -
> -static void
> -permute(char *out, char *in, uchar *p, int n)
> -{
> - =A0 =A0 =A0 int i;
> - =A0 =A0 =A0 for (i =3D 0; i < n; i++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 out[i] =3D in[p[i] - 1];
> -}
> -
> -static void
> -lshift(char *d, int count, int n)
> -{
> - =A0 =A0 =A0 char out[64];
> - =A0 =A0 =A0 int i;
> - =A0 =A0 =A0 for (i =3D 0; i < n; i++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 out[i] =3D d[(i + count) % n];
> - =A0 =A0 =A0 for (i =3D 0; i < n; i++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 d[i] =3D out[i];
> -}
> -
> -static void
> -concat(char *out, char *in1, char *in2, int l1, int l2)
> -{
> - =A0 =A0 =A0 while (l1--)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 *out++ =3D *in1++;
> - =A0 =A0 =A0 while (l2--)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 *out++ =3D *in2++;
> -}
> -
> -static void
> -xor(char *out, char *in1, char *in2, int n)
> -{
> - =A0 =A0 =A0 int i;
> - =A0 =A0 =A0 for (i =3D 0; i < n; i++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 out[i] =3D in1[i] ^ in2[i];
> -}
> -
> -static void
> -dohash(char *out, char *in, char *key, int forw)
> -{
> - =A0 =A0 =A0 int i, j, k;
> - =A0 =A0 =A0 char *pk1;
> - =A0 =A0 =A0 char c[28];
> - =A0 =A0 =A0 char d[28];
> - =A0 =A0 =A0 char *cd;
> - =A0 =A0 =A0 char (*ki)[48];
> - =A0 =A0 =A0 char *pd1;
> - =A0 =A0 =A0 char l[32], r[32];
> - =A0 =A0 =A0 char *rl;
> -
> - =A0 =A0 =A0 /* Have to reduce stack usage */
> - =A0 =A0 =A0 pk1 =3D kmalloc(56+56+64+64, GFP_KERNEL);
> - =A0 =A0 =A0 if (pk1 =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> -
> - =A0 =A0 =A0 ki =3D kmalloc(16*48, GFP_KERNEL);
> - =A0 =A0 =A0 if (ki =3D=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(pk1);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 cd =3D pk1 + 56;
> - =A0 =A0 =A0 pd1 =3D cd =A0+ 56;
> - =A0 =A0 =A0 rl =3D pd1 + 64;
> -
> - =A0 =A0 =A0 permute(pk1, key, perm1, 56);
> -
> - =A0 =A0 =A0 for (i =3D 0; i < 28; i++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 c[i] =3D pk1[i];
> - =A0 =A0 =A0 for (i =3D 0; i < 28; i++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 d[i] =3D pk1[i + 28];
> -
> - =A0 =A0 =A0 for (i =3D 0; i < 16; i++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 lshift(c, sc[i], 28);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 lshift(d, sc[i], 28);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 concat(cd, c, d, 28, 28);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 permute(ki[i], cd, perm2, 48);
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 permute(pd1, in, perm3, 64);
> -
> - =A0 =A0 =A0 for (j =3D 0; j < 32; j++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 l[j] =3D pd1[j];
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 r[j] =3D pd1[j + 32];
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 for (i =3D 0; i < 16; i++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *er; =A0/* er[48] =A0*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *erk; /* erk[48] */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 char b[8][6];
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *cb; =A0/* cb[32] =A0*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *pcb; /* pcb[32] */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *r2; =A0/* r2[32] =A0*/
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 er =3D kmalloc(48+48+32+32+32, GFP_KERN=
EL);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (er =3D=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(pk1);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(ki);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 erk =3D er+48;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cb =A0=3D erk+48;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pcb =3D cb+32;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 r2 =A0=3D pcb+32;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 permute(er, r, perm4, 48);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 xor(erk, er, ki[forw ? i : 15 - i], 48)=
;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (j =3D 0; j < 8; j++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (k =3D 0; k < 6; k+=
+)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 b[j][k]=
 =3D erk[j * 6 + k];
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (j =3D 0; j < 8; j++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int m, n;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 m =3D (b[j][0] << 1) | =
b[j][5];
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 n =3D (b[j][1] << 3) | =
(b[j][2] << 2) | (b[j][3] <<
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A01) | b[j][4];
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (k =3D 0; k < 4; k+=
+)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 b[j][k]=
 =3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 (sbox[j][m][n] & (1 << (3 - k))) ? 1 : 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (j =3D 0; j < 8; j++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (k =3D 0; k < 4; k+=
+)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cb[j * =
4 + k] =3D b[j][k];
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 permute(pcb, cb, perm5, 32);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 xor(r2, l, pcb, 32);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (j =3D 0; j < 32; j++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 l[j] =3D r[j];
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (j =3D 0; j < 32; j++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 r[j] =3D r2[j];
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(er);
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 concat(rl, r, l, 32, 32);
> -
> - =A0 =A0 =A0 permute(out, rl, perm6, 64);
> - =A0 =A0 =A0 kfree(pk1);
> - =A0 =A0 =A0 kfree(ki);
> -}
> -
> -static void
> -str_to_key(unsigned char *str, unsigned char *key)
> -{
> - =A0 =A0 =A0 int i;
> -
> - =A0 =A0 =A0 key[0] =3D str[0] >> 1;
> - =A0 =A0 =A0 key[1] =3D ((str[0] & 0x01) << 6) | (str[1] >> 2);
> - =A0 =A0 =A0 key[2] =3D ((str[1] & 0x03) << 5) | (str[2] >> 3);
> - =A0 =A0 =A0 key[3] =3D ((str[2] & 0x07) << 4) | (str[3] >> 4);
> - =A0 =A0 =A0 key[4] =3D ((str[3] & 0x0F) << 3) | (str[4] >> 5);
> - =A0 =A0 =A0 key[5] =3D ((str[4] & 0x1F) << 2) | (str[5] >> 6);
> - =A0 =A0 =A0 key[6] =3D ((str[5] & 0x3F) << 1) | (str[6] >> 7);
> - =A0 =A0 =A0 key[7] =3D str[6] & 0x7F;
> - =A0 =A0 =A0 for (i =3D 0; i < 8; i++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 key[i] =3D (key[i] << 1);
> -}
> -
> -static void
> -smbhash(unsigned char *out, const unsigned char *in, unsigned char *=
key,
> - =A0 =A0 =A0 int forw)
> -{
> - =A0 =A0 =A0 int i;
> - =A0 =A0 =A0 char *outb; /* outb[64] */
> - =A0 =A0 =A0 char *inb; =A0/* inb[64] =A0*/
> - =A0 =A0 =A0 char *keyb; /* keyb[64] */
> - =A0 =A0 =A0 unsigned char key2[8];
> -
> - =A0 =A0 =A0 outb =3D kmalloc(64 * 3, GFP_KERNEL);
> - =A0 =A0 =A0 if (outb =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> -
> - =A0 =A0 =A0 inb =A0=3D outb + 64;
> - =A0 =A0 =A0 keyb =3D inb + =A064;
> -
> - =A0 =A0 =A0 str_to_key(key, key2);
> -
> - =A0 =A0 =A0 for (i =3D 0; i < 64; i++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 inb[i] =3D (in[i / 8] & (1 << (7 - (i %=
 8)))) ? 1 : 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 keyb[i] =3D (key2[i / 8] & (1 << (7 - (=
i % 8)))) ? 1 : 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 outb[i] =3D 0;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 dohash(outb, inb, keyb, forw);
> -
> - =A0 =A0 =A0 for (i =3D 0; i < 8; i++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 out[i] =3D 0;
> -
> - =A0 =A0 =A0 for (i =3D 0; i < 64; i++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (outb[i])
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 out[i / 8] |=3D (1 << (=
7 - (i % 8)));
> - =A0 =A0 =A0 }
> - =A0 =A0 =A0 kfree(outb);
> -}
> -
> -void
> -E_P16(unsigned char *p14, unsigned char *p16)
> -{
> - =A0 =A0 =A0 unsigned char sp8[8] =3D
> - =A0 =A0 =A0 =A0 =A0 { 0x4b, 0x47, 0x53, 0x21, 0x40, 0x23, 0x24, 0x2=
5 };
> - =A0 =A0 =A0 smbhash(p16, sp8, p14, 1);
> - =A0 =A0 =A0 smbhash(p16 + 8, sp8, p14 + 7, 1);
> -}
> -
> -void
> -E_P24(unsigned char *p21, const unsigned char *c8, unsigned char *p2=
4)
> -{
> - =A0 =A0 =A0 smbhash(p24, c8, p21, 1);
> - =A0 =A0 =A0 smbhash(p24 + 8, c8, p21 + 7, 1);
> - =A0 =A0 =A0 smbhash(p24 + 16, c8, p21 + 14, 1);
> -}
> -
> -#if 0 /* currently unused */
> -static void
> -D_P16(unsigned char *p14, unsigned char *in, unsigned char *out)
> -{
> - =A0 =A0 =A0 smbhash(out, in, p14, 0);
> - =A0 =A0 =A0 smbhash(out + 8, in + 8, p14 + 7, 0);
> -}
> -
> -static void
> -E_old_pw_hash(unsigned char *p14, unsigned char *in, unsigned char *=
out)
> -{
> - =A0 =A0 =A0 smbhash(out, in, p14, 1);
> - =A0 =A0 =A0 smbhash(out + 8, in + 8, p14 + 7, 1);
> -}
> -/* these routines are currently unneeded, but may be
> - =A0 =A0 =A0 needed later */
> -void
> -cred_hash1(unsigned char *out, unsigned char *in, unsigned char *key=
)
> -{
> - =A0 =A0 =A0 unsigned char buf[8];
> -
> - =A0 =A0 =A0 smbhash(buf, in, key, 1);
> - =A0 =A0 =A0 smbhash(out, buf, key + 9, 1);
> -}
> -
> -void
> -cred_hash2(unsigned char *out, unsigned char *in, unsigned char *key=
)
> -{
> - =A0 =A0 =A0 unsigned char buf[8];
> - =A0 =A0 =A0 static unsigned char key2[8];
> -
> - =A0 =A0 =A0 smbhash(buf, in, key, 1);
> - =A0 =A0 =A0 key2[0] =3D key[7];
> - =A0 =A0 =A0 smbhash(out, buf, key2, 1);
> -}
> -
> -void
> -cred_hash3(unsigned char *out, unsigned char *in, unsigned char *key=
, int forw)
> -{
> - =A0 =A0 =A0 static unsigned char key2[8];
> -
> - =A0 =A0 =A0 smbhash(out, in, key, forw);
> - =A0 =A0 =A0 key2[0] =3D key[7];
> - =A0 =A0 =A0 smbhash(out + 8, in + 8, key2, forw);
> -}
> -#endif /* unneeded routines */
> diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
> index b5041c8..1735e1b 100644
> --- a/fs/cifs/smbencrypt.c
> +++ b/fs/cifs/smbencrypt.c
> @@ -47,6 +47,89 @@
> =A0#define SSVALX(buf,pos,val) (CVAL(buf,pos)=3D(val)&0xFF,CVAL(buf,p=
os+1)=3D(val)>>8)
> =A0#define SSVAL(buf,pos,val) SSVALX((buf),(pos),((__u16)(val)))
>
> +static void
> +str_to_key(unsigned char *str, unsigned char *key)
> +{
> + =A0 =A0 =A0 int i;
> +
> + =A0 =A0 =A0 key[0] =3D str[0] >> 1;
> + =A0 =A0 =A0 key[1] =3D ((str[0] & 0x01) << 6) | (str[1] >> 2);
> + =A0 =A0 =A0 key[2] =3D ((str[1] & 0x03) << 5) | (str[2] >> 3);
> + =A0 =A0 =A0 key[3] =3D ((str[2] & 0x07) << 4) | (str[3] >> 4);
> + =A0 =A0 =A0 key[4] =3D ((str[3] & 0x0F) << 3) | (str[4] >> 5);
> + =A0 =A0 =A0 key[5] =3D ((str[4] & 0x1F) << 2) | (str[5] >> 6);
> + =A0 =A0 =A0 key[6] =3D ((str[5] & 0x3F) << 1) | (str[6] >> 7);
> + =A0 =A0 =A0 key[7] =3D str[6] & 0x7F;
> + =A0 =A0 =A0 for (i =3D 0; i < 8; i++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 key[i] =3D (key[i] << 1);
> +}

Crypto folks, have a question. If we do not add odd partity bits
to the bytes of a key that would be used in ecb des encryption,
does the encryption function add odd parity bit to the each byte
of the key?

> +
> +static int
> +smbhash(unsigned char *out, const unsigned char *in, unsigned char *=
key,
> + =A0 =A0 =A0 int forw)
> +{
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 unsigned char key2[8];
> + =A0 =A0 =A0 struct crypto_blkcipher *tfm_des;
> + =A0 =A0 =A0 struct scatterlist sgin, sgout;
> + =A0 =A0 =A0 struct blkcipher_desc desc;
> +
> + =A0 =A0 =A0 str_to_key(key, key2);
> +
> + =A0 =A0 =A0 tfm_des =3D crypto_alloc_blkcipher("ecb(des)", 0, CRYPT=
O_ALG_ASYNC);
> + =A0 =A0 =A0 if (IS_ERR(tfm_des)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D PTR_ERR(tfm_des);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate des crypt=
o API\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto smbhash_err;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 desc.tfm =3D tfm_des;
> +
> + =A0 =A0 =A0 crypto_blkcipher_setkey(tfm_des, key2, 8);
> +
> + =A0 =A0 =A0 sg_init_one(&sgin, in, 8);
> + =A0 =A0 =A0 sg_init_one(&sgout, out, 8);
> +
> + =A0 =A0 =A0 rc =3D crypto_blkcipher_encrypt(&desc, &sgout, &sgin, 8=
);
> + =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not encrypt crypt key =
rc: %d\n", rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_free_blkcipher(tfm_des);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto smbhash_err;
> + =A0 =A0 =A0 }
> +
> +smbhash_err:
> + =A0 =A0 =A0 return rc;
> +}
> +
> +static int
> +E_P16(unsigned char *p14, unsigned char *p16)
> +{
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 unsigned char sp8[8] =3D
> + =A0 =A0 =A0 =A0 =A0 { 0x4b, 0x47, 0x53, 0x21, 0x40, 0x23, 0x24, 0x2=
5 };
> +
> + =A0 =A0 =A0 rc =3D smbhash(p16, sp8, p14, 1);
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 rc =3D smbhash(p16 + 8, sp8, p14 + 7, 1);
> + =A0 =A0 =A0 return rc;
> +}
> +
> +static int
> +E_P24(unsigned char *p21, const unsigned char *c8, unsigned char *p2=
4)
> +{
> + =A0 =A0 =A0 int rc;
> +
> + =A0 =A0 =A0 rc =3D smbhash(p24, c8, p21, 1);
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 rc =3D smbhash(p24 + 8, c8, p21 + 7, 1);
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 rc =3D smbhash(p24 + 16, c8, p21 + 14, 1);
> + =A0 =A0 =A0 return rc;
> +}
> +
> =A0/* produce a md4 message digest from data of length n bytes */
> =A0int
> =A0mdfour(unsigned char *md4_hash, unsigned char *link_str, int link_=
len)
> @@ -87,40 +170,30 @@ mdfour_err:
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> -/* Does the des encryption from the NT or LM MD4 hash. */
> -static void
> -SMBOWFencrypt(unsigned char passwd[16], const unsigned char *c8,
> - =A0 =A0 =A0 =A0 =A0 =A0 unsigned char p24[24])
> -{
> - =A0 =A0 =A0 unsigned char p21[21];
> -
> - =A0 =A0 =A0 memset(p21, '\0', 21);
> -
> - =A0 =A0 =A0 memcpy(p21, passwd, 16);
> - =A0 =A0 =A0 E_P24(p21, c8, p24);
> -}
> -
> =A0/*
> =A0 =A0This implements the X/Open SMB password encryption
> =A0 =A0It takes a password, a 8 byte "crypt key" and puts 24 bytes of
> =A0 =A0encrypted password into p24 */
> =A0/* Note that password must be uppercased and null terminated */
> -void
> +int
> =A0SMBencrypt(unsigned char *passwd, const unsigned char *c8, unsigne=
d char *p24)
> =A0{
> - =A0 =A0 =A0 unsigned char p14[15], p21[21];
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 unsigned char p14[15], p16[16], p21[21];
>
> + =A0 =A0 =A0 memset(p14, '\0', 15);
> + =A0 =A0 =A0 memset(p16, '\0', 16);
> =A0 =A0 =A0 =A0memset(p21, '\0', 21);
> - =A0 =A0 =A0 memset(p14, '\0', 14);
> - =A0 =A0 =A0 strncpy((char *) p14, (char *) passwd, 14);
>
> -/* =A0 =A0 strupper((char *)p14); *//* BB at least uppercase the eas=
y range */
> - =A0 =A0 =A0 E_P16(p14, p21);
> + =A0 =A0 =A0 memcpy(p14, passwd, 14);
> + =A0 =A0 =A0 rc =3D E_P16(p14, p16);
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>
> - =A0 =A0 =A0 SMBOWFencrypt(p21, c8, p24);
> + =A0 =A0 =A0 memcpy(p21, passwd, 16);
> + =A0 =A0 =A0 rc =3D E_P24(p21, c8, p24);
>
> - =A0 =A0 =A0 memset(p14, 0, 15);
> - =A0 =A0 =A0 memset(p21, 0, 21);
> + =A0 =A0 =A0 return rc;
> =A0}
>
> =A0/* Routines for Windows NT MD4 Hash functions. */
> @@ -279,16 +352,18 @@ int
> =A0SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned ch=
ar *p24)
> =A0{
> =A0 =A0 =A0 =A0int rc;
> - =A0 =A0 =A0 unsigned char p21[21];
> + =A0 =A0 =A0 unsigned char p16[16], p21[21];
>
> + =A0 =A0 =A0 memset(p16, '\0', 21);
> =A0 =A0 =A0 =A0memset(p21, '\0', 21);
>
> - =A0 =A0 =A0 rc =3D E_md4hash(passwd, p21);
> + =A0 =A0 =A0 rc =3D E_md4hash(passwd, p16);
> =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "%s Can't generate NT hash, er=
ror: %d", __func__, rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 SMBOWFencrypt(p21, c8, p24);
> + =A0 =A0 =A0 memcpy(p21, p16, 16);
> + =A0 =A0 =A0 rc =3D E_P24(p21, c8, p24);
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> --
> 1.6.0.2
>
>
