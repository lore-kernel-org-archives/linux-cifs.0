From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: More crypto cleanup (try #2)
Date: Thu, 27 Jan 2011 09:58:04 -0600
Message-ID: <1296143884-5359-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Replaced md4 hashing function local to cifs module with kernel crypto APIs.
As a result, md4 hashing function and its supporting functions in
file md4.c are not needed anymore.

Cleaned up function declarations, removed forward function declarations,
and removed a header file that is being deleted from being included.

Verified that sec=ntlm/i, sec=ntlmv2/i, and sec=ntlmssp/i work correctly.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/Makefile      |    2 +-
 fs/cifs/cifsencrypt.c |   32 +++++---
 fs/cifs/cifsencrypt.h |   33 --------
 fs/cifs/cifsproto.h   |    9 ++-
 fs/cifs/connect.c     |    6 +-
 fs/cifs/link.c        |    5 +-
 fs/cifs/md4.c         |  205 -------------------------------------------------
 fs/cifs/smbdes.c      |    1 -
 fs/cifs/smbencrypt.c  |   90 +++++++++++++++------
 9 files changed, 97 insertions(+), 286 deletions(-)
 delete mode 100644 fs/cifs/cifsencrypt.h
 delete mode 100644 fs/cifs/md4.c

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index e132229..d875584 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -5,7 +5,7 @@ obj-$(CONFIG_CIFS) += cifs.o
 
 cifs-y := cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o inode.o \
 	  link.o misc.o netmisc.o smbdes.o smbencrypt.o transport.o asn1.o \
-	  md4.o cifs_unicode.o nterr.o xattr.o cifsencrypt.o \
+	  cifs_unicode.o nterr.o xattr.o cifsencrypt.o \
 	  readdir.o ioctl.o sess.o export.o
 
 cifs-$(CONFIG_CIFS_ACL) += cifsacl.o
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 35bf329..0db5f1d 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -36,11 +36,6 @@
 /* Note that the smb header signature field on input contains the
 	sequence number before this function is called */
 
-extern void mdfour(unsigned char *out, unsigned char *in, int n);
-extern void E_md4hash(const unsigned char *passwd, unsigned char *p16);
-extern void SMBencrypt(unsigned char *passwd, const unsigned char *c8,
-		       unsigned char *p24);
-
 static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
 				struct TCP_Server_Info *server, char *signature)
 {
@@ -233,6 +228,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_pdu,
 /* first calculate 24 bytes ntlm response and then 16 byte session key */
 int setup_ntlm_response(struct cifsSesInfo *ses)
 {
+	int rc = 0;
 	unsigned int temp_len = CIFS_SESS_KEY_SIZE + CIFS_AUTH_RESP_SIZE;
 	char temp_key[CIFS_SESS_KEY_SIZE];
 
@@ -246,13 +242,26 @@ int setup_ntlm_response(struct cifsSesInfo *ses)
 	}
 	ses->auth_key.len = temp_len;
 
-	SMBNTencrypt(ses->password, ses->server->cryptkey,
+	rc = SMBNTencrypt(ses->password, ses->server->cryptkey,
 			ses->auth_key.response + CIFS_SESS_KEY_SIZE);
+	if (rc) {
+		cFYI(1, "%s Can't generate NTLM response, error: %d",
+			__func__, rc);
+		return rc;
+	}
+
+	rc = E_md4hash(ses->password, temp_key);
+	if (rc) {
+		cFYI(1, "%s Can't generate NT hash, error: %d", __func__, rc);
+		return rc;
+	}
 
-	E_md4hash(ses->password, temp_key);
-	mdfour(ses->auth_key.response, temp_key, CIFS_SESS_KEY_SIZE);
+	rc = mdfour(ses->auth_key.response, temp_key, CIFS_SESS_KEY_SIZE);
+	if (rc)
+		cFYI(1, "%s Can't generate NTLM session key, error: %d",
+			__func__, rc);
 
-	return 0;
+	return rc;
 }
 
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
@@ -699,14 +708,13 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
 	unsigned int size;
 
 	server->secmech.hmacmd5 = crypto_alloc_shash("hmac(md5)", 0, 0);
-	if (!server->secmech.hmacmd5 ||
-			IS_ERR(server->secmech.hmacmd5)) {
+	if (IS_ERR(server->secmech.hmacmd5)) {
 		cERROR(1, "could not allocate crypto hmacmd5\n");
 		return PTR_ERR(server->secmech.hmacmd5);
 	}
 
 	server->secmech.md5 = crypto_alloc_shash("md5", 0, 0);
-	if (!server->secmech.md5 || IS_ERR(server->secmech.md5)) {
+	if (IS_ERR(server->secmech.md5)) {
 		cERROR(1, "could not allocate crypto md5\n");
 		rc = PTR_ERR(server->secmech.md5);
 		goto crypto_allocate_md5_fail;
diff --git a/fs/cifs/cifsencrypt.h b/fs/cifs/cifsencrypt.h
deleted file mode 100644
index 15d2ec0..0000000
--- a/fs/cifs/cifsencrypt.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- *   fs/cifs/cifsencrypt.h
- *
- *   Copyright (c) International Business Machines  Corp., 2005
- *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
- *
- *   Externs for misc. small encryption routines
- *   so we do not have to put them in cifsproto.h
- *
- *   This library is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU Lesser General Public License as published
- *   by the Free Software Foundation; either version 2.1 of the License, or
- *   (at your option) any later version.
- *
- *   This library is distributed in the hope that it will be useful,
- *   but WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
- *   the GNU Lesser General Public License for more details.
- *
- *   You should have received a copy of the GNU Lesser General Public License
- *   along with this library; if not, write to the Free Software
- *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- */
-
-/* md4.c */
-extern void mdfour(unsigned char *out, unsigned char *in, int n);
-/* smbdes.c */
-extern void E_P16(unsigned char *p14, unsigned char *p16);
-extern void E_P24(unsigned char *p21, const unsigned char *c8,
-		  unsigned char *p24);
-
-
-
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 35c989f..8096f27 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -375,7 +375,7 @@ extern int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *,
 extern int cifs_verify_signature(struct smb_hdr *,
 				 struct TCP_Server_Info *server,
 				__u32 expected_sequence_number);
-extern void SMBNTencrypt(unsigned char *, unsigned char *, unsigned char *);
+extern int SMBNTencrypt(unsigned char *, unsigned char *, unsigned char *);
 extern int setup_ntlm_response(struct cifsSesInfo *);
 extern int setup_ntlmv2_rsp(struct cifsSesInfo *, const struct nls_table *);
 extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
@@ -425,4 +425,11 @@ extern bool CIFSCouldBeMFSymlink(const struct cifs_fattr *fattr);
 extern int CIFSCheckMFSymlink(struct cifs_fattr *fattr,
 		const unsigned char *path,
 		struct cifs_sb_info *cifs_sb, int xid);
+extern int mdfour(unsigned char *, unsigned char *, int);
+extern int E_md4hash(const unsigned char *passwd, unsigned char *p16);
+extern void SMBencrypt(unsigned char *passwd, const unsigned char *c8,
+			unsigned char *p24);
+extern void E_P16(unsigned char *p14, unsigned char *p16);
+extern void E_P24(unsigned char *p21, const unsigned char *c8,
+			unsigned char *p24);
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 47034af..47d8ff6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -55,9 +55,6 @@
 /* SMB echo "timeout" -- FIXME: tunable? */
 #define SMB_ECHO_INTERVAL (60 * HZ)
 
-extern void SMBNTencrypt(unsigned char *passwd, unsigned char *c8,
-			 unsigned char *p24);
-
 extern mempool_t *cifs_req_poolp;
 
 struct smb_vol {
@@ -2990,7 +2987,8 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *ses,
 					 bcc_ptr);
 		else
 #endif /* CIFS_WEAK_PW_HASH */
-		SMBNTencrypt(tcon->password, ses->server->cryptkey, bcc_ptr);
+		rc = SMBNTencrypt(tcon->password, ses->server->cryptkey,
+					bcc_ptr);
 
 		bcc_ptr += CIFS_AUTH_RESP_SIZE;
 		if (ses->capabilities & CAP_UNICODE) {
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index d3444ea..02cd60a 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -54,10 +54,9 @@ symlink_hash(unsigned int link_len, const char *link_str, u8 *md5_hash)
 	struct sdesc *sdescmd5;
 
 	md5 = crypto_alloc_shash("md5", 0, 0);
-	if (!md5 || IS_ERR(md5)) {
-		rc = PTR_ERR(md5);
+	if (IS_ERR(md5)) {
 		cERROR(1, "%s: Crypto md5 allocation error %d\n", __func__, rc);
-		return rc;
+		return PTR_ERR(md5);
 	}
 	size = sizeof(struct shash_desc) + crypto_shash_descsize(md5);
 	sdescmd5 = kmalloc(size, GFP_KERNEL);
diff --git a/fs/cifs/md4.c b/fs/cifs/md4.c
deleted file mode 100644
index a725c26..0000000
--- a/fs/cifs/md4.c
+++ /dev/null
@@ -1,205 +0,0 @@
-/*
-   Unix SMB/Netbios implementation.
-   Version 1.9.
-   a implementation of MD4 designed for use in the SMB authentication protocol
-   Copyright (C) Andrew Tridgell 1997-1998.
-   Modified by Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org) 2002-2003
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
-#include <linux/module.h>
-#include <linux/fs.h>
-#include "cifsencrypt.h"
-
-/* NOTE: This code makes no attempt to be fast! */
-
-static __u32
-F(__u32 X, __u32 Y, __u32 Z)
-{
-	return (X & Y) | ((~X) & Z);
-}
-
-static __u32
-G(__u32 X, __u32 Y, __u32 Z)
-{
-	return (X & Y) | (X & Z) | (Y & Z);
-}
-
-static __u32
-H(__u32 X, __u32 Y, __u32 Z)
-{
-	return X ^ Y ^ Z;
-}
-
-static __u32
-lshift(__u32 x, int s)
-{
-	x &= 0xFFFFFFFF;
-	return ((x << s) & 0xFFFFFFFF) | (x >> (32 - s));
-}
-
-#define ROUND1(a,b,c,d,k,s) (*a) = lshift((*a) + F(*b,*c,*d) + X[k], s)
-#define ROUND2(a,b,c,d,k,s) (*a) = lshift((*a) + G(*b,*c,*d) + X[k] + (__u32)0x5A827999,s)
-#define ROUND3(a,b,c,d,k,s) (*a) = lshift((*a) + H(*b,*c,*d) + X[k] + (__u32)0x6ED9EBA1,s)
-
-/* this applies md4 to 64 byte chunks */
-static void
-mdfour64(__u32 *M, __u32 *A, __u32 *B, __u32 *C, __u32 *D)
-{
-	int j;
-	__u32 AA, BB, CC, DD;
-	__u32 X[16];
-
-
-	for (j = 0; j < 16; j++)
-		X[j] = M[j];
-
-	AA = *A;
-	BB = *B;
-	CC = *C;
-	DD = *D;
-
-	ROUND1(A, B, C, D, 0, 3);
-	ROUND1(D, A, B, C, 1, 7);
-	ROUND1(C, D, A, B, 2, 11);
-	ROUND1(B, C, D, A, 3, 19);
-	ROUND1(A, B, C, D, 4, 3);
-	ROUND1(D, A, B, C, 5, 7);
-	ROUND1(C, D, A, B, 6, 11);
-	ROUND1(B, C, D, A, 7, 19);
-	ROUND1(A, B, C, D, 8, 3);
-	ROUND1(D, A, B, C, 9, 7);
-	ROUND1(C, D, A, B, 10, 11);
-	ROUND1(B, C, D, A, 11, 19);
-	ROUND1(A, B, C, D, 12, 3);
-	ROUND1(D, A, B, C, 13, 7);
-	ROUND1(C, D, A, B, 14, 11);
-	ROUND1(B, C, D, A, 15, 19);
-
-	ROUND2(A, B, C, D, 0, 3);
-	ROUND2(D, A, B, C, 4, 5);
-	ROUND2(C, D, A, B, 8, 9);
-	ROUND2(B, C, D, A, 12, 13);
-	ROUND2(A, B, C, D, 1, 3);
-	ROUND2(D, A, B, C, 5, 5);
-	ROUND2(C, D, A, B, 9, 9);
-	ROUND2(B, C, D, A, 13, 13);
-	ROUND2(A, B, C, D, 2, 3);
-	ROUND2(D, A, B, C, 6, 5);
-	ROUND2(C, D, A, B, 10, 9);
-	ROUND2(B, C, D, A, 14, 13);
-	ROUND2(A, B, C, D, 3, 3);
-	ROUND2(D, A, B, C, 7, 5);
-	ROUND2(C, D, A, B, 11, 9);
-	ROUND2(B, C, D, A, 15, 13);
-
-	ROUND3(A, B, C, D, 0, 3);
-	ROUND3(D, A, B, C, 8, 9);
-	ROUND3(C, D, A, B, 4, 11);
-	ROUND3(B, C, D, A, 12, 15);
-	ROUND3(A, B, C, D, 2, 3);
-	ROUND3(D, A, B, C, 10, 9);
-	ROUND3(C, D, A, B, 6, 11);
-	ROUND3(B, C, D, A, 14, 15);
-	ROUND3(A, B, C, D, 1, 3);
-	ROUND3(D, A, B, C, 9, 9);
-	ROUND3(C, D, A, B, 5, 11);
-	ROUND3(B, C, D, A, 13, 15);
-	ROUND3(A, B, C, D, 3, 3);
-	ROUND3(D, A, B, C, 11, 9);
-	ROUND3(C, D, A, B, 7, 11);
-	ROUND3(B, C, D, A, 15, 15);
-
-	*A += AA;
-	*B += BB;
-	*C += CC;
-	*D += DD;
-
-	*A &= 0xFFFFFFFF;
-	*B &= 0xFFFFFFFF;
-	*C &= 0xFFFFFFFF;
-	*D &= 0xFFFFFFFF;
-
-	for (j = 0; j < 16; j++)
-		X[j] = 0;
-}
-
-static void
-copy64(__u32 *M, unsigned char *in)
-{
-	int i;
-
-	for (i = 0; i < 16; i++)
-		M[i] = (in[i * 4 + 3] << 24) | (in[i * 4 + 2] << 16) |
-		    (in[i * 4 + 1] << 8) | (in[i * 4 + 0] << 0);
-}
-
-static void
-copy4(unsigned char *out, __u32 x)
-{
-	out[0] = x & 0xFF;
-	out[1] = (x >> 8) & 0xFF;
-	out[2] = (x >> 16) & 0xFF;
-	out[3] = (x >> 24) & 0xFF;
-}
-
-/* produce a md4 message digest from data of length n bytes */
-void
-mdfour(unsigned char *out, unsigned char *in, int n)
-{
-	unsigned char buf[128];
-	__u32 M[16];
-	__u32 b = n * 8;
-	int i;
-	__u32 A = 0x67452301;
-	__u32 B = 0xefcdab89;
-	__u32 C = 0x98badcfe;
-	__u32 D = 0x10325476;
-
-	while (n > 64) {
-		copy64(M, in);
-		mdfour64(M, &A, &B, &C, &D);
-		in += 64;
-		n -= 64;
-	}
-
-	for (i = 0; i < 128; i++)
-		buf[i] = 0;
-	memcpy(buf, in, n);
-	buf[n] = 0x80;
-
-	if (n <= 55) {
-		copy4(buf + 56, b);
-		copy64(M, buf);
-		mdfour64(M, &A, &B, &C, &D);
-	} else {
-		copy4(buf + 120, b);
-		copy64(M, buf);
-		mdfour64(M, &A, &B, &C, &D);
-		copy64(M, buf + 64);
-		mdfour64(M, &A, &B, &C, &D);
-	}
-
-	for (i = 0; i < 128; i++)
-		buf[i] = 0;
-	copy64(M, buf);
-
-	copy4(out, A);
-	copy4(out + 4, B);
-	copy4(out + 8, C);
-	copy4(out + 12, D);
-
-	A = B = C = D = 0;
-}
diff --git a/fs/cifs/smbdes.c b/fs/cifs/smbdes.c
index b6b6dcb..0472148 100644
--- a/fs/cifs/smbdes.c
+++ b/fs/cifs/smbdes.c
@@ -45,7 +45,6 @@
    up with a different answer to the one above)
 */
 #include <linux/slab.h>
-#include "cifsencrypt.h"
 #define uchar unsigned char
 
 static uchar perm1[56] = { 57, 49, 41, 33, 25, 17, 9,
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 3013500..b5450e9 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -33,7 +33,7 @@
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifs_debug.h"
-#include "cifsencrypt.h"
+#include "cifsproto.h"
 
 #ifndef false
 #define false 0
@@ -47,14 +47,57 @@
 #define SSVALX(buf,pos,val) (CVAL(buf,pos)=(val)&0xFF,CVAL(buf,pos+1)=(val)>>8)
 #define SSVAL(buf,pos,val) SSVALX((buf),(pos),((__u16)(val)))
 
-/*The following definitions come from  libsmb/smbencrypt.c  */
+/* produce a md4 message digest from data of length n bytes */
+int
+mdfour(unsigned char *md4_hash, unsigned char *link_str, int link_len)
+{
+	int rc;
+	unsigned int size;
+	struct crypto_shash *md4;
+	struct sdesc *sdescmd4;
+
+	md4 = crypto_alloc_shash("md4", 0, 0);
+	if (IS_ERR(md4)) {
+		cERROR(1, "%s: Crypto md4 allocation error %d\n", __func__, rc);
+		return PTR_ERR(md4);
+	}
+	size = sizeof(struct shash_desc) + crypto_shash_descsize(md4);
+	sdescmd4 = kmalloc(size, GFP_KERNEL);
+	if (!sdescmd4) {
+		rc = -ENOMEM;
+		cERROR(1, "%s: Memory allocation failure\n", __func__);
+		goto mdfour_err;
+	}
+	sdescmd4->shash.tfm = md4;
+	sdescmd4->shash.flags = 0x0;
+
+	rc = crypto_shash_init(&sdescmd4->shash);
+	if (rc) {
+		cERROR(1, "%s: Could not init md4 shash\n", __func__);
+		goto mdfour_err;
+	}
+	crypto_shash_update(&sdescmd4->shash, link_str, link_len);
+	rc = crypto_shash_final(&sdescmd4->shash, md4_hash);
 
-void SMBencrypt(unsigned char *passwd, const unsigned char *c8,
-		unsigned char *p24);
-void E_md4hash(const unsigned char *passwd, unsigned char *p16);
-static void SMBOWFencrypt(unsigned char passwd[16], const unsigned char *c8,
-		   unsigned char p24[24]);
-void SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned char *p24);
+mdfour_err:
+	crypto_free_shash(md4);
+	kfree(sdescmd4);
+
+	return rc;
+}
+
+/* Does the des encryption from the NT or LM MD4 hash. */
+static void
+SMBOWFencrypt(unsigned char passwd[16], const unsigned char *c8,
+	      unsigned char p24[24])
+{
+	unsigned char p21[21];
+
+	memset(p21, '\0', 21);
+
+	memcpy(p21, passwd, 16);
+	E_P24(p21, c8, p24);
+}
 
 /*
    This implements the X/Open SMB password encryption
@@ -117,9 +160,10 @@ _my_mbstowcs(__u16 *dst, const unsigned char *src, int len)
  * Creates the MD4 Hash of the users password in NT UNICODE.
  */
 
-void
+int
 E_md4hash(const unsigned char *passwd, unsigned char *p16)
 {
+	int rc;
 	int len;
 	__u16 wpwd[129];
 
@@ -138,8 +182,10 @@ E_md4hash(const unsigned char *passwd, unsigned char *p16)
 	/* Calculate length in bytes */
 	len = _my_wcslen(wpwd) * sizeof(__u16);
 
-	mdfour(p16, (unsigned char *) wpwd, len);
+	rc = mdfour(p16, (unsigned char *) wpwd, len);
 	memset(wpwd, 0, 129 * 2);
+
+	return rc;
 }
 
 #if 0 /* currently unused */
@@ -211,19 +257,6 @@ ntv2_owf_gen(const unsigned char owf[16], const char *user_n,
 }
 #endif
 
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
 /* Does the des encryption from the FIRST 8 BYTES of the NT or LM MD4 hash. */
 #if 0 /* currently unused */
 static void
@@ -241,16 +274,21 @@ NTLMSSPOWFencrypt(unsigned char passwd[8],
 #endif
 
 /* Does the NT MD4 hash then des encryption. */
-
-void
+int
 SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned char *p24)
 {
+	int rc;
 	unsigned char p21[21];
 
 	memset(p21, '\0', 21);
 
-	E_md4hash(passwd, p21);
+	rc = E_md4hash(passwd, p21);
+	if (rc) {
+		cFYI(1, "%s Can't generate NT hash, error: %d", __func__, rc);
+		return rc;
+	}
 	SMBOWFencrypt(p21, c8, p24);
+	return rc;
 }
 
 
-- 
1.6.0.2
