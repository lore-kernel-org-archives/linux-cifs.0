From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Use ecb des kernel crypto APIs instead of local cifs functions
Date: Tue, 15 Feb 2011 17:27:48 -0600
Message-ID: <1297812468-5499-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Using kernel crypto APIs for DES encryption during LM and NT hash generation
instead of local functions within cifs.
Source file smbdes.c is deleted sans five functions, one of which
uses ecb des functionality provided by kernel crypto APIs.

Remove function SMBOWFencrypt.

Add return codes to various functions such as calc_lanman_hash,
SMBencrypt, and SMBNTencrypt.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/Kconfig       |    1 +
 fs/cifs/Makefile      |    2 +-
 fs/cifs/cifsencrypt.c |   10 +-
 fs/cifs/cifsproto.h   |    7 +-
 fs/cifs/smbdes.c      |  435 -------------------------------------------------
 fs/cifs/smbencrypt.c  |  141 +++++++++++++---
 6 files changed, 125 insertions(+), 471 deletions(-)
 delete mode 100644 fs/cifs/smbdes.c

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 7cb0f7f..99ff2ca 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -7,6 +7,7 @@ config CIFS
 	select CRYPTO_MD5
 	select CRYPTO_HMAC
 	select CRYPTO_ARC4
+	select CRYPTO_DES
 	help
 	  This is the client VFS module for the Common Internet File System
 	  (CIFS) protocol which is the successor to the Server Message Block
diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index d875584..005d524 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -4,7 +4,7 @@
 obj-$(CONFIG_CIFS) += cifs.o
 
 cifs-y := cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o inode.o \
-	  link.o misc.o netmisc.o smbdes.o smbencrypt.o transport.o asn1.o \
+	  link.o misc.o netmisc.o smbencrypt.o transport.o asn1.o \
 	  cifs_unicode.o nterr.o xattr.o cifsencrypt.o \
 	  readdir.o ioctl.o sess.o export.o
 
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index a51585f..7a54624 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -265,10 +265,11 @@ int setup_ntlm_response(struct cifsSesInfo *ses)
 }
 
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
-void calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
+int calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
 			char *lnm_session_key)
 {
 	int i;
+	int rc;
 	char password_with_pad[CIFS_ENCPWD_SIZE];
 
 	memset(password_with_pad, 0, CIFS_ENCPWD_SIZE);
@@ -279,7 +280,7 @@ void calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
 		memset(lnm_session_key, 0, CIFS_SESS_KEY_SIZE);
 		memcpy(lnm_session_key, password_with_pad,
 			CIFS_ENCPWD_SIZE);
-		return;
+		return 0;
 	}
 
 	/* calculate old style session key */
@@ -296,10 +297,9 @@ void calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
 	for (i = 0; i < CIFS_ENCPWD_SIZE; i++)
 		password_with_pad[i] = toupper(password_with_pad[i]);
 
-	SMBencrypt(password_with_pad, cryptkey, lnm_session_key);
+	rc = SMBencrypt(password_with_pad, cryptkey, lnm_session_key);
 
-	/* clear password before we return/free memory */
-	memset(password_with_pad, 0, CIFS_ENCPWD_SIZE);
+	return rc;
 }
 #endif /* CIFS_WEAK_PW_HASH */
 
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 8096f27..e131f85 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -383,7 +383,7 @@ extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
 extern int calc_seckey(struct cifsSesInfo *);
 
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
-extern void calc_lanman_hash(const char *password, const char *cryptkey,
+extern int calc_lanman_hash(const char *password, const char *cryptkey,
 				bool encrypt, char *lnm_session_key);
 #endif /* CIFS_WEAK_PW_HASH */
 extern int CIFSSMBCopy(int xid,
@@ -427,9 +427,6 @@ extern int CIFSCheckMFSymlink(struct cifs_fattr *fattr,
 		struct cifs_sb_info *cifs_sb, int xid);
 extern int mdfour(unsigned char *, unsigned char *, int);
 extern int E_md4hash(const unsigned char *passwd, unsigned char *p16);
-extern void SMBencrypt(unsigned char *passwd, const unsigned char *c8,
-			unsigned char *p24);
-extern void E_P16(unsigned char *p14, unsigned char *p16);
-extern void E_P24(unsigned char *p21, const unsigned char *c8,
+extern int SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 			unsigned char *p24);
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/smbdes.c b/fs/cifs/smbdes.c
deleted file mode 100644
index dcfc379..0000000
--- a/fs/cifs/smbdes.c
+++ /dev/null
@@ -1,435 +0,0 @@
-/*
-   Unix SMB/Netbios implementation.
-   Version 1.9.
-
-   a partial implementation of DES designed for use in the
-   SMB authentication protocol
-
-   Copyright (C) Andrew Tridgell 1998
-   Modified by Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org) 2002,2004
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation; either version 2 of the License, or
-   (at your option) any later version.
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-
-/* NOTES:
-
-   This code makes no attempt to be fast! In fact, it is a very
-   slow implementation
-
-   This code is NOT a complete DES implementation. It implements only
-   the minimum necessary for SMB authentication, as used by all SMB
-   products (including every copy of Microsoft Windows95 ever sold)
-
-   In particular, it can only do a unchained forward DES pass. This
-   means it is not possible to use this code for encryption/decryption
-   of data, instead it is only useful as a "hash" algorithm.
-
-   There is no entry point into this code that allows normal DES operation.
-
-   I believe this means that this code does not come under ITAR
-   regulations but this is NOT a legal opinion. If you are concerned
-   about the applicability of ITAR regulations to this code then you
-   should confirm it for yourself (and maybe let me know if you come
-   up with a different answer to the one above)
-*/
-#include <linux/slab.h>
-#define uchar unsigned char
-
-static uchar perm1[56] = { 57, 49, 41, 33, 25, 17, 9,
-	1, 58, 50, 42, 34, 26, 18,
-	10, 2, 59, 51, 43, 35, 27,
-	19, 11, 3, 60, 52, 44, 36,
-	63, 55, 47, 39, 31, 23, 15,
-	7, 62, 54, 46, 38, 30, 22,
-	14, 6, 61, 53, 45, 37, 29,
-	21, 13, 5, 28, 20, 12, 4
-};
-
-static uchar perm2[48] = { 14, 17, 11, 24, 1, 5,
-	3, 28, 15, 6, 21, 10,
-	23, 19, 12, 4, 26, 8,
-	16, 7, 27, 20, 13, 2,
-	41, 52, 31, 37, 47, 55,
-	30, 40, 51, 45, 33, 48,
-	44, 49, 39, 56, 34, 53,
-	46, 42, 50, 36, 29, 32
-};
-
-static uchar perm3[64] = { 58, 50, 42, 34, 26, 18, 10, 2,
-	60, 52, 44, 36, 28, 20, 12, 4,
-	62, 54, 46, 38, 30, 22, 14, 6,
-	64, 56, 48, 40, 32, 24, 16, 8,
-	57, 49, 41, 33, 25, 17, 9, 1,
-	59, 51, 43, 35, 27, 19, 11, 3,
-	61, 53, 45, 37, 29, 21, 13, 5,
-	63, 55, 47, 39, 31, 23, 15, 7
-};
-
-static uchar perm4[48] = { 32, 1, 2, 3, 4, 5,
-	4, 5, 6, 7, 8, 9,
-	8, 9, 10, 11, 12, 13,
-	12, 13, 14, 15, 16, 17,
-	16, 17, 18, 19, 20, 21,
-	20, 21, 22, 23, 24, 25,
-	24, 25, 26, 27, 28, 29,
-	28, 29, 30, 31, 32, 1
-};
-
-static uchar perm5[32] = { 16, 7, 20, 21,
-	29, 12, 28, 17,
-	1, 15, 23, 26,
-	5, 18, 31, 10,
-	2, 8, 24, 14,
-	32, 27, 3, 9,
-	19, 13, 30, 6,
-	22, 11, 4, 25
-};
-
-static uchar perm6[64] = { 40, 8, 48, 16, 56, 24, 64, 32,
-	39, 7, 47, 15, 55, 23, 63, 31,
-	38, 6, 46, 14, 54, 22, 62, 30,
-	37, 5, 45, 13, 53, 21, 61, 29,
-	36, 4, 44, 12, 52, 20, 60, 28,
-	35, 3, 43, 11, 51, 19, 59, 27,
-	34, 2, 42, 10, 50, 18, 58, 26,
-	33, 1, 41, 9, 49, 17, 57, 25
-};
-
-static uchar sc[16] = { 1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1 };
-
-static uchar sbox[8][4][16] = {
-	{{14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7},
-	 {0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8},
-	 {4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0},
-	 {15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13} },
-
-	{{15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10},
-	 {3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5},
-	 {0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15},
-	 {13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9} },
-
-	{{10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8},
-	 {13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1},
-	 {13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7},
-	 {1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12} },
-
-	{{7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15},
-	 {13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9},
-	 {10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4},
-	 {3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14} },
-
-	{{2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9},
-	 {14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6},
-	 {4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14},
-	 {11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3} },
-
-	{{12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11},
-	 {10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8},
-	 {9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6},
-	 {4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13} },
-
-	{{4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1},
-	 {13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6},
-	 {1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2},
-	 {6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12} },
-
-	{{13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7},
-	 {1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2},
-	 {7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8},
-	 {2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11} }
-};
-
-static void
-permute(char *out, char *in, uchar *p, int n)
-{
-	int i;
-	for (i = 0; i < n; i++)
-		out[i] = in[p[i] - 1];
-}
-
-static void
-lshift(char *d, int count, int n)
-{
-	char out[64];
-	int i;
-	for (i = 0; i < n; i++)
-		out[i] = d[(i + count) % n];
-	for (i = 0; i < n; i++)
-		d[i] = out[i];
-}
-
-static void
-concat(char *out, char *in1, char *in2, int l1, int l2)
-{
-	while (l1--)
-		*out++ = *in1++;
-	while (l2--)
-		*out++ = *in2++;
-}
-
-static void
-xor(char *out, char *in1, char *in2, int n)
-{
-	int i;
-	for (i = 0; i < n; i++)
-		out[i] = in1[i] ^ in2[i];
-}
-
-static void
-dohash(char *out, char *in, char *key, int forw)
-{
-	int i, j, k;
-	char *pk1;
-	char c[28];
-	char d[28];
-	char *cd;
-	char (*ki)[48];
-	char *pd1;
-	char l[32], r[32];
-	char *rl;
-
-	/* Have to reduce stack usage */
-	pk1 = kmalloc(56+56+64+64, GFP_KERNEL);
-	if (pk1 == NULL)
-		return;
-
-	ki = kmalloc(16*48, GFP_KERNEL);
-	if (ki == NULL) {
-		kfree(pk1);
-		return;
-	}
-
-	cd = pk1 + 56;
-	pd1 = cd  + 56;
-	rl = pd1 + 64;
-
-	permute(pk1, key, perm1, 56);
-
-	for (i = 0; i < 28; i++)
-		c[i] = pk1[i];
-	for (i = 0; i < 28; i++)
-		d[i] = pk1[i + 28];
-
-	for (i = 0; i < 16; i++) {
-		lshift(c, sc[i], 28);
-		lshift(d, sc[i], 28);
-
-		concat(cd, c, d, 28, 28);
-		permute(ki[i], cd, perm2, 48);
-	}
-
-	permute(pd1, in, perm3, 64);
-
-	for (j = 0; j < 32; j++) {
-		l[j] = pd1[j];
-		r[j] = pd1[j + 32];
-	}
-
-	for (i = 0; i < 16; i++) {
-		char *er;  /* er[48]  */
-		char *erk; /* erk[48] */
-		char b[8][6];
-		char *cb;  /* cb[32]  */
-		char *pcb; /* pcb[32] */
-		char *r2;  /* r2[32]  */
-
-		er = kmalloc(48+48+32+32+32, GFP_KERNEL);
-		if (er == NULL) {
-			kfree(pk1);
-			kfree(ki);
-			return;
-		}
-		erk = er+48;
-		cb  = erk+48;
-		pcb = cb+32;
-		r2  = pcb+32;
-
-		permute(er, r, perm4, 48);
-
-		xor(erk, er, ki[forw ? i : 15 - i], 48);
-
-		for (j = 0; j < 8; j++)
-			for (k = 0; k < 6; k++)
-				b[j][k] = erk[j * 6 + k];
-
-		for (j = 0; j < 8; j++) {
-			int m, n;
-			m = (b[j][0] << 1) | b[j][5];
-
-			n = (b[j][1] << 3) | (b[j][2] << 2) | (b[j][3] <<
-							       1) | b[j][4];
-
-			for (k = 0; k < 4; k++)
-				b[j][k] =
-				    (sbox[j][m][n] & (1 << (3 - k))) ? 1 : 0;
-		}
-
-		for (j = 0; j < 8; j++)
-			for (k = 0; k < 4; k++)
-				cb[j * 4 + k] = b[j][k];
-		permute(pcb, cb, perm5, 32);
-
-		xor(r2, l, pcb, 32);
-
-		for (j = 0; j < 32; j++)
-			l[j] = r[j];
-
-		for (j = 0; j < 32; j++)
-			r[j] = r2[j];
-
-		kfree(er);
-	}
-
-	concat(rl, r, l, 32, 32);
-
-	permute(out, rl, perm6, 64);
-	kfree(pk1);
-	kfree(ki);
-}
-
-static int
-odd_parity(unsigned char c)
-{
-	int i;
-	int val = 0x80;
-	int count = 0;
-
-	for (i = 0; i < 7; ++i)
-		if (c & (val >> i))
-			++count;
-
-	return count % 2;
-}
-
-static void
-str_to_key(unsigned char *str, unsigned char *key)
-{
-	int i;
-
-	key[0] = str[0] >> 1;
-	key[1] = ((str[0] & 0x01) << 6) | (str[1] >> 2);
-	key[2] = ((str[1] & 0x03) << 5) | (str[2] >> 3);
-	key[3] = ((str[2] & 0x07) << 4) | (str[3] >> 4);
-	key[4] = ((str[3] & 0x0F) << 3) | (str[4] >> 5);
-	key[5] = ((str[4] & 0x1F) << 2) | (str[5] >> 6);
-	key[6] = ((str[5] & 0x3F) << 1) | (str[6] >> 7);
-	key[7] = str[6] & 0x7F;
-	for (i = 0; i < 8; i++) {
-		key[i] = (key[i] << 1);
-		if (!odd_parity(key[i]))
-			key[i] |= 0x1;
-	}
-}
-
-static void
-smbhash(unsigned char *out, const unsigned char *in, unsigned char *key,
-	int forw)
-{
-	int i;
-	char *outb; /* outb[64] */
-	char *inb;  /* inb[64]  */
-	char *keyb; /* keyb[64] */
-	unsigned char key2[8];
-
-	outb = kmalloc(64 * 3, GFP_KERNEL);
-	if (outb == NULL)
-		return;
-
-	inb  = outb + 64;
-	keyb = inb +  64;
-
-	str_to_key(key, key2);
-
-	for (i = 0; i < 64; i++) {
-		inb[i] = (in[i / 8] & (1 << (7 - (i % 8)))) ? 1 : 0;
-		keyb[i] = (key2[i / 8] & (1 << (7 - (i % 8)))) ? 1 : 0;
-		outb[i] = 0;
-	}
-
-	dohash(outb, inb, keyb, forw);
-
-	for (i = 0; i < 8; i++)
-		out[i] = 0;
-
-	for (i = 0; i < 64; i++) {
-		if (outb[i])
-			out[i / 8] |= (1 << (7 - (i % 8)));
-	}
-	kfree(outb);
-}
-
-void
-E_P16(unsigned char *p14, unsigned char *p16)
-{
-	unsigned char sp8[8] =
-	    { 0x4b, 0x47, 0x53, 0x21, 0x40, 0x23, 0x24, 0x25 };
-	smbhash(p16, sp8, p14, 1);
-	smbhash(p16 + 8, sp8, p14 + 7, 1);
-}
-
-void
-E_P24(unsigned char *p21, const unsigned char *c8, unsigned char *p24)
-{
-	smbhash(p24, c8, p21, 1);
-	smbhash(p24 + 8, c8, p21 + 7, 1);
-	smbhash(p24 + 16, c8, p21 + 14, 1);
-}
-
-#if 0 /* currently unused */
-static void
-D_P16(unsigned char *p14, unsigned char *in, unsigned char *out)
-{
-	smbhash(out, in, p14, 0);
-	smbhash(out + 8, in + 8, p14 + 7, 0);
-}
-
-static void
-E_old_pw_hash(unsigned char *p14, unsigned char *in, unsigned char *out)
-{
-	smbhash(out, in, p14, 1);
-	smbhash(out + 8, in + 8, p14 + 7, 1);
-}
-/* these routines are currently unneeded, but may be
-	needed later */
-void
-cred_hash1(unsigned char *out, unsigned char *in, unsigned char *key)
-{
-	unsigned char buf[8];
-
-	smbhash(buf, in, key, 1);
-	smbhash(out, buf, key + 9, 1);
-}
-
-void
-cred_hash2(unsigned char *out, unsigned char *in, unsigned char *key)
-{
-	unsigned char buf[8];
-	static unsigned char key2[8];
-
-	smbhash(buf, in, key, 1);
-	key2[0] = key[7];
-	smbhash(out, buf, key2, 1);
-}
-
-void
-cred_hash3(unsigned char *out, unsigned char *in, unsigned char *key, int forw)
-{
-	static unsigned char key2[8];
-
-	smbhash(out, in, key, forw);
-	key2[0] = key[7];
-	smbhash(out + 8, in + 8, key2, forw);
-}
-#endif /* unneeded routines */
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index b5041c8..1d34dd3 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -47,6 +47,105 @@
 #define SSVALX(buf,pos,val) (CVAL(buf,pos)=(val)&0xFF,CVAL(buf,pos+1)=(val)>>8)
 #define SSVAL(buf,pos,val) SSVALX((buf),(pos),((__u16)(val)))
 
+static int
+odd_parity(unsigned char c)
+{
+	int i;
+	int val = 0x80;
+	int count = 0;
+
+	for (i = 0; i < 7; ++i)
+		if (c & (val >> i))
+			++count;
+
+	return count % 2;
+}
+
+static void
+str_to_key(unsigned char *str, unsigned char *key)
+{
+	int i;
+
+	key[0] = str[0] >> 1;
+	key[1] = ((str[0] & 0x01) << 6) | (str[1] >> 2);
+	key[2] = ((str[1] & 0x03) << 5) | (str[2] >> 3);
+	key[3] = ((str[2] & 0x07) << 4) | (str[3] >> 4);
+	key[4] = ((str[3] & 0x0F) << 3) | (str[4] >> 5);
+	key[5] = ((str[4] & 0x1F) << 2) | (str[5] >> 6);
+	key[6] = ((str[5] & 0x3F) << 1) | (str[6] >> 7);
+	key[7] = str[6] & 0x7F;
+	for (i = 0; i < 8; i++) {
+		key[i] = (key[i] << 1);
+		if (!odd_parity(key[i]))
+			key[i] |= 0x1;
+	}
+}
+
+static int
+smbhash(unsigned char *out, const unsigned char *in, unsigned char *key)
+{
+	int rc;
+	unsigned char key2[8];
+	struct crypto_blkcipher *tfm_des;
+	struct scatterlist sgin, sgout;
+	struct blkcipher_desc desc;
+
+	str_to_key(key, key2);
+
+	tfm_des = crypto_alloc_blkcipher("ecb(des)", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(tfm_des)) {
+		rc = PTR_ERR(tfm_des);
+		cERROR(1, "could not allocate des crypto API\n");
+		goto smbhash_err;
+	}
+
+	desc.tfm = tfm_des;
+
+	crypto_blkcipher_setkey(tfm_des, key2, 8);
+
+	sg_init_one(&sgin, in, 8);
+	sg_init_one(&sgout, out, 8);
+
+	rc = crypto_blkcipher_encrypt(&desc, &sgout, &sgin, 8);
+	if (rc) {
+		cERROR(1, "could not encrypt crypt key rc: %d\n", rc);
+		crypto_free_blkcipher(tfm_des);
+		goto smbhash_err;
+	}
+
+smbhash_err:
+	return rc;
+}
+
+static int
+E_P16(unsigned char *p14, unsigned char *p16)
+{
+	int rc;
+	unsigned char sp8[8] =
+	    { 0x4b, 0x47, 0x53, 0x21, 0x40, 0x23, 0x24, 0x25 };
+
+	rc = smbhash(p16, sp8, p14);
+	if (rc)
+		return rc;
+	rc = smbhash(p16 + 8, sp8, p14 + 7);
+	return rc;
+}
+
+static int
+E_P24(unsigned char *p21, const unsigned char *c8, unsigned char *p24)
+{
+	int rc;
+
+	rc = smbhash(p24, c8, p21);
+	if (rc)
+		return rc;
+	rc = smbhash(p24 + 8, c8, p21 + 7);
+	if (rc)
+		return rc;
+	rc = smbhash(p24 + 16, c8, p21 + 14);
+	return rc;
+}
+
 /* produce a md4 message digest from data of length n bytes */
 int
 mdfour(unsigned char *md4_hash, unsigned char *link_str, int link_len)
@@ -87,40 +186,30 @@ mdfour_err:
 	return rc;
 }
 
-/* Does the des encryption from the NT or LM MD4 hash. */
-static void
-SMBOWFencrypt(unsigned char passwd[16], const unsigned char *c8,
-	      unsigned char p24[24])
-{
-	unsigned char p21[21];
-
-	memset(p21, '\0', 21);
-
-	memcpy(p21, passwd, 16);
-	E_P24(p21, c8, p24);
-}
-
 /*
    This implements the X/Open SMB password encryption
    It takes a password, a 8 byte "crypt key" and puts 24 bytes of
    encrypted password into p24 */
 /* Note that password must be uppercased and null terminated */
-void
+int
 SMBencrypt(unsigned char *passwd, const unsigned char *c8, unsigned char *p24)
 {
-	unsigned char p14[15], p21[21];
+	int rc;
+	unsigned char p14[14], p16[16], p21[21];
 
-	memset(p21, '\0', 21);
 	memset(p14, '\0', 14);
-	strncpy((char *) p14, (char *) passwd, 14);
+	memset(p16, '\0', 16);
+	memset(p21, '\0', 21);
 
-/*	strupper((char *)p14); *//* BB at least uppercase the easy range */
-	E_P16(p14, p21);
+	memcpy(p14, passwd, 14);
+	rc = E_P16(p14, p16);
+	if (rc)
+		return rc;
 
-	SMBOWFencrypt(p21, c8, p24);
+	memcpy(p21, p16, 16);
+	rc = E_P24(p21, c8, p24);
 
-	memset(p14, 0, 15);
-	memset(p21, 0, 21);
+	return rc;
 }
 
 /* Routines for Windows NT MD4 Hash functions. */
@@ -279,16 +368,18 @@ int
 SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned char *p24)
 {
 	int rc;
-	unsigned char p21[21];
+	unsigned char p16[16], p21[21];
 
+	memset(p16, '\0', 21);
 	memset(p21, '\0', 21);
 
-	rc = E_md4hash(passwd, p21);
+	rc = E_md4hash(passwd, p16);
 	if (rc) {
 		cFYI(1, "%s Can't generate NT hash, error: %d", __func__, rc);
 		return rc;
 	}
-	SMBOWFencrypt(p21, c8, p24);
+	memcpy(p21, p16, 16);
+	rc = E_P24(p21, c8, p24);
 	return rc;
 }
 
-- 
1.6.0.2
