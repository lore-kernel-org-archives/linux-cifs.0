From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Replace cifs md5 hashing functions with kernel crypto APIs
Date: Fri, 21 Jan 2011 09:04:05 -0600
Message-ID: <1295622245-10581-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Replace remaining use of md5 hash functions local to cifs module
with kernel crypto APIs.
Remove header and source file containing those local functions.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/Makefile      |    2 +-
 fs/cifs/cifsencrypt.c |    1 -
 fs/cifs/link.c        |   59 +++++++--
 fs/cifs/md5.c         |  366 -------------------------------------------------
 fs/cifs/md5.h         |   38 -----
 fs/cifs/smbencrypt.c  |    1 -
 6 files changed, 51 insertions(+), 416 deletions(-)
 delete mode 100644 fs/cifs/md5.c
 delete mode 100644 fs/cifs/md5.h

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index 43b19dd..e132229 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -5,7 +5,7 @@ obj-$(CONFIG_CIFS) += cifs.o
 
 cifs-y := cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o inode.o \
 	  link.o misc.o netmisc.o smbdes.o smbencrypt.o transport.o asn1.o \
-	  md4.o md5.o cifs_unicode.o nterr.o xattr.o cifsencrypt.o \
+	  md4.o cifs_unicode.o nterr.o xattr.o cifsencrypt.o \
 	  readdir.o ioctl.o sess.o export.o
 
 cifs-$(CONFIG_CIFS_ACL) += cifsacl.o
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 66f3d50..35bf329 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -24,7 +24,6 @@
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifs_debug.h"
-#include "md5.h"
 #include "cifs_unicode.h"
 #include "cifsproto.h"
 #include "ntlmssp.h"
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 306769d..d3444ea 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -28,7 +28,6 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "cifs_fs_sb.h"
-#include "md5.h"
 
 #define CIFS_MF_SYMLINK_LEN_OFFSET (4+1)
 #define CIFS_MF_SYMLINK_MD5_OFFSET (CIFS_MF_SYMLINK_LEN_OFFSET+(4+1))
@@ -47,6 +46,45 @@
 	md5_hash[12], md5_hash[13], md5_hash[14], md5_hash[15]
 
 static int
+symlink_hash(unsigned int link_len, const char *link_str, u8 *md5_hash)
+{
+	int rc;
+	unsigned int size;
+	struct crypto_shash *md5;
+	struct sdesc *sdescmd5;
+
+	md5 = crypto_alloc_shash("md5", 0, 0);
+	if (!md5 || IS_ERR(md5)) {
+		rc = PTR_ERR(md5);
+		cERROR(1, "%s: Crypto md5 allocation error %d\n", __func__, rc);
+		return rc;
+	}
+	size = sizeof(struct shash_desc) + crypto_shash_descsize(md5);
+	sdescmd5 = kmalloc(size, GFP_KERNEL);
+	if (!sdescmd5) {
+		rc = -ENOMEM;
+		cERROR(1, "%s: Memory allocation failure\n", __func__);
+		goto symlink_hash_err;
+	}
+	sdescmd5->shash.tfm = md5;
+	sdescmd5->shash.flags = 0x0;
+
+	rc = crypto_shash_init(&sdescmd5->shash);
+	if (rc) {
+		cERROR(1, "%s: Could not init md5 shash\n", __func__);
+		goto symlink_hash_err;
+	}
+	crypto_shash_update(&sdescmd5->shash, link_str, link_len);
+	rc = crypto_shash_final(&sdescmd5->shash, md5_hash);
+
+symlink_hash_err:
+	crypto_free_shash(md5);
+	kfree(sdescmd5);
+
+	return rc;
+}
+
+static int
 CIFSParseMFSymlink(const u8 *buf,
 		   unsigned int buf_len,
 		   unsigned int *_link_len,
@@ -56,7 +94,6 @@ CIFSParseMFSymlink(const u8 *buf,
 	unsigned int link_len;
 	const char *md5_str1;
 	const char *link_str;
-	struct MD5Context md5_ctx;
 	u8 md5_hash[16];
 	char md5_str2[34];
 
@@ -70,9 +107,11 @@ CIFSParseMFSymlink(const u8 *buf,
 	if (rc != 1)
 		return -EINVAL;
 
-	cifs_MD5_init(&md5_ctx);
-	cifs_MD5_update(&md5_ctx, (const u8 *)link_str, link_len);
-	cifs_MD5_final(md5_hash, &md5_ctx);
+	rc = symlink_hash(link_len, link_str, md5_hash);
+	if (rc) {
+		cFYI(1, "%s: MD5 hash failure: %d\n", __func__, rc);
+		return rc;
+	}
 
 	snprintf(md5_str2, sizeof(md5_str2),
 		 CIFS_MF_SYMLINK_MD5_FORMAT,
@@ -94,9 +133,9 @@ CIFSParseMFSymlink(const u8 *buf,
 static int
 CIFSFormatMFSymlink(u8 *buf, unsigned int buf_len, const char *link_str)
 {
+	int rc;
 	unsigned int link_len;
 	unsigned int ofs;
-	struct MD5Context md5_ctx;
 	u8 md5_hash[16];
 
 	if (buf_len != CIFS_MF_SYMLINK_FILE_SIZE)
@@ -107,9 +146,11 @@ CIFSFormatMFSymlink(u8 *buf, unsigned int buf_len, const char *link_str)
 	if (link_len > CIFS_MF_SYMLINK_LINK_MAXLEN)
 		return -ENAMETOOLONG;
 
-	cifs_MD5_init(&md5_ctx);
-	cifs_MD5_update(&md5_ctx, (const u8 *)link_str, link_len);
-	cifs_MD5_final(md5_hash, &md5_ctx);
+	rc = symlink_hash(link_len, link_str, md5_hash);
+	if (rc) {
+		cFYI(1, "%s: MD5 hash failure: %d\n", __func__, rc);
+		return rc;
+	}
 
 	snprintf(buf, buf_len,
 		 CIFS_MF_SYMLINK_LEN_FORMAT CIFS_MF_SYMLINK_MD5_FORMAT,
diff --git a/fs/cifs/md5.c b/fs/cifs/md5.c
deleted file mode 100644
index 98b66a5..0000000
--- a/fs/cifs/md5.c
+++ /dev/null
@@ -1,366 +0,0 @@
-/*
- * This code implements the MD5 message-digest algorithm.
- * The algorithm is due to Ron Rivest.  This code was
- * written by Colin Plumb in 1993, no copyright is claimed.
- * This code is in the public domain; do with it what you wish.
- *
- * Equivalent code is available from RSA Data Security, Inc.
- * This code has been tested against that, and is equivalent,
- * except that you don't need to include two pages of legalese
- * with every copy.
- *
- * To compute the message digest of a chunk of bytes, declare an
- * MD5Context structure, pass it to cifs_MD5_init, call cifs_MD5_update as
- * needed on buffers full of bytes, and then call cifs_MD5_final, which
- * will fill a supplied 16-byte array with the digest.
- */
-
-/* This code slightly modified to fit into Samba by
-   abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org Jun 2001
-   and to fit the cifs vfs by
-   Steve French sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org */
-
-#include <linux/string.h>
-#include "md5.h"
-
-static void MD5Transform(__u32 buf[4], __u32 const in[16]);
-
-/*
- * Note: this code is harmless on little-endian machines.
- */
-static void
-byteReverse(unsigned char *buf, unsigned longs)
-{
-	__u32 t;
-	do {
-		t = (__u32) ((unsigned) buf[3] << 8 | buf[2]) << 16 |
-		    ((unsigned) buf[1] << 8 | buf[0]);
-		*(__u32 *) buf = t;
-		buf += 4;
-	} while (--longs);
-}
-
-/*
- * Start MD5 accumulation.  Set bit count to 0 and buffer to mysterious
- * initialization constants.
- */
-void
-cifs_MD5_init(struct MD5Context *ctx)
-{
-	ctx->buf[0] = 0x67452301;
-	ctx->buf[1] = 0xefcdab89;
-	ctx->buf[2] = 0x98badcfe;
-	ctx->buf[3] = 0x10325476;
-
-	ctx->bits[0] = 0;
-	ctx->bits[1] = 0;
-}
-
-/*
- * Update context to reflect the concatenation of another buffer full
- * of bytes.
- */
-void
-cifs_MD5_update(struct MD5Context *ctx, unsigned char const *buf, unsigned len)
-{
-	register __u32 t;
-
-	/* Update bitcount */
-
-	t = ctx->bits[0];
-	if ((ctx->bits[0] = t + ((__u32) len << 3)) < t)
-		ctx->bits[1]++;	/* Carry from low to high */
-	ctx->bits[1] += len >> 29;
-
-	t = (t >> 3) & 0x3f;	/* Bytes already in shsInfo->data */
-
-	/* Handle any leading odd-sized chunks */
-
-	if (t) {
-		unsigned char *p = (unsigned char *) ctx->in + t;
-
-		t = 64 - t;
-		if (len < t) {
-			memmove(p, buf, len);
-			return;
-		}
-		memmove(p, buf, t);
-		byteReverse(ctx->in, 16);
-		MD5Transform(ctx->buf, (__u32 *) ctx->in);
-		buf += t;
-		len -= t;
-	}
-	/* Process data in 64-byte chunks */
-
-	while (len >= 64) {
-		memmove(ctx->in, buf, 64);
-		byteReverse(ctx->in, 16);
-		MD5Transform(ctx->buf, (__u32 *) ctx->in);
-		buf += 64;
-		len -= 64;
-	}
-
-	/* Handle any remaining bytes of data. */
-
-	memmove(ctx->in, buf, len);
-}
-
-/*
- * Final wrapup - pad to 64-byte boundary with the bit pattern
- * 1 0* (64-bit count of bits processed, MSB-first)
- */
-void
-cifs_MD5_final(unsigned char digest[16], struct MD5Context *ctx)
-{
-	unsigned int count;
-	unsigned char *p;
-
-	/* Compute number of bytes mod 64 */
-	count = (ctx->bits[0] >> 3) & 0x3F;
-
-	/* Set the first char of padding to 0x80.  This is safe since there is
-	   always at least one byte free */
-	p = ctx->in + count;
-	*p++ = 0x80;
-
-	/* Bytes of padding needed to make 64 bytes */
-	count = 64 - 1 - count;
-
-	/* Pad out to 56 mod 64 */
-	if (count < 8) {
-		/* Two lots of padding:  Pad the first block to 64 bytes */
-		memset(p, 0, count);
-		byteReverse(ctx->in, 16);
-		MD5Transform(ctx->buf, (__u32 *) ctx->in);
-
-		/* Now fill the next block with 56 bytes */
-		memset(ctx->in, 0, 56);
-	} else {
-		/* Pad block to 56 bytes */
-		memset(p, 0, count - 8);
-	}
-	byteReverse(ctx->in, 14);
-
-	/* Append length in bits and transform */
-	((__u32 *) ctx->in)[14] = ctx->bits[0];
-	((__u32 *) ctx->in)[15] = ctx->bits[1];
-
-	MD5Transform(ctx->buf, (__u32 *) ctx->in);
-	byteReverse((unsigned char *) ctx->buf, 4);
-	memmove(digest, ctx->buf, 16);
-	memset(ctx, 0, sizeof(*ctx));	/* In case it's sensitive */
-}
-
-/* The four core functions - F1 is optimized somewhat */
-
-/* #define F1(x, y, z) (x & y | ~x & z) */
-#define F1(x, y, z) (z ^ (x & (y ^ z)))
-#define F2(x, y, z) F1(z, x, y)
-#define F3(x, y, z) (x ^ y ^ z)
-#define F4(x, y, z) (y ^ (x | ~z))
-
-/* This is the central step in the MD5 algorithm. */
-#define MD5STEP(f, w, x, y, z, data, s) \
-	(w += f(x, y, z) + data,  w = w<<s | w>>(32-s),  w += x)
-
-/*
- * The core of the MD5 algorithm, this alters an existing MD5 hash to
- * reflect the addition of 16 longwords of new data.  cifs_MD5_update blocks
- * the data and converts bytes into longwords for this routine.
- */
-static void
-MD5Transform(__u32 buf[4], __u32 const in[16])
-{
-	register __u32 a, b, c, d;
-
-	a = buf[0];
-	b = buf[1];
-	c = buf[2];
-	d = buf[3];
-
-	MD5STEP(F1, a, b, c, d, in[0] + 0xd76aa478, 7);
-	MD5STEP(F1, d, a, b, c, in[1] + 0xe8c7b756, 12);
-	MD5STEP(F1, c, d, a, b, in[2] + 0x242070db, 17);
-	MD5STEP(F1, b, c, d, a, in[3] + 0xc1bdceee, 22);
-	MD5STEP(F1, a, b, c, d, in[4] + 0xf57c0faf, 7);
-	MD5STEP(F1, d, a, b, c, in[5] + 0x4787c62a, 12);
-	MD5STEP(F1, c, d, a, b, in[6] + 0xa8304613, 17);
-	MD5STEP(F1, b, c, d, a, in[7] + 0xfd469501, 22);
-	MD5STEP(F1, a, b, c, d, in[8] + 0x698098d8, 7);
-	MD5STEP(F1, d, a, b, c, in[9] + 0x8b44f7af, 12);
-	MD5STEP(F1, c, d, a, b, in[10] + 0xffff5bb1, 17);
-	MD5STEP(F1, b, c, d, a, in[11] + 0x895cd7be, 22);
-	MD5STEP(F1, a, b, c, d, in[12] + 0x6b901122, 7);
-	MD5STEP(F1, d, a, b, c, in[13] + 0xfd987193, 12);
-	MD5STEP(F1, c, d, a, b, in[14] + 0xa679438e, 17);
-	MD5STEP(F1, b, c, d, a, in[15] + 0x49b40821, 22);
-
-	MD5STEP(F2, a, b, c, d, in[1] + 0xf61e2562, 5);
-	MD5STEP(F2, d, a, b, c, in[6] + 0xc040b340, 9);
-	MD5STEP(F2, c, d, a, b, in[11] + 0x265e5a51, 14);
-	MD5STEP(F2, b, c, d, a, in[0] + 0xe9b6c7aa, 20);
-	MD5STEP(F2, a, b, c, d, in[5] + 0xd62f105d, 5);
-	MD5STEP(F2, d, a, b, c, in[10] + 0x02441453, 9);
-	MD5STEP(F2, c, d, a, b, in[15] + 0xd8a1e681, 14);
-	MD5STEP(F2, b, c, d, a, in[4] + 0xe7d3fbc8, 20);
-	MD5STEP(F2, a, b, c, d, in[9] + 0x21e1cde6, 5);
-	MD5STEP(F2, d, a, b, c, in[14] + 0xc33707d6, 9);
-	MD5STEP(F2, c, d, a, b, in[3] + 0xf4d50d87, 14);
-	MD5STEP(F2, b, c, d, a, in[8] + 0x455a14ed, 20);
-	MD5STEP(F2, a, b, c, d, in[13] + 0xa9e3e905, 5);
-	MD5STEP(F2, d, a, b, c, in[2] + 0xfcefa3f8, 9);
-	MD5STEP(F2, c, d, a, b, in[7] + 0x676f02d9, 14);
-	MD5STEP(F2, b, c, d, a, in[12] + 0x8d2a4c8a, 20);
-
-	MD5STEP(F3, a, b, c, d, in[5] + 0xfffa3942, 4);
-	MD5STEP(F3, d, a, b, c, in[8] + 0x8771f681, 11);
-	MD5STEP(F3, c, d, a, b, in[11] + 0x6d9d6122, 16);
-	MD5STEP(F3, b, c, d, a, in[14] + 0xfde5380c, 23);
-	MD5STEP(F3, a, b, c, d, in[1] + 0xa4beea44, 4);
-	MD5STEP(F3, d, a, b, c, in[4] + 0x4bdecfa9, 11);
-	MD5STEP(F3, c, d, a, b, in[7] + 0xf6bb4b60, 16);
-	MD5STEP(F3, b, c, d, a, in[10] + 0xbebfbc70, 23);
-	MD5STEP(F3, a, b, c, d, in[13] + 0x289b7ec6, 4);
-	MD5STEP(F3, d, a, b, c, in[0] + 0xeaa127fa, 11);
-	MD5STEP(F3, c, d, a, b, in[3] + 0xd4ef3085, 16);
-	MD5STEP(F3, b, c, d, a, in[6] + 0x04881d05, 23);
-	MD5STEP(F3, a, b, c, d, in[9] + 0xd9d4d039, 4);
-	MD5STEP(F3, d, a, b, c, in[12] + 0xe6db99e5, 11);
-	MD5STEP(F3, c, d, a, b, in[15] + 0x1fa27cf8, 16);
-	MD5STEP(F3, b, c, d, a, in[2] + 0xc4ac5665, 23);
-
-	MD5STEP(F4, a, b, c, d, in[0] + 0xf4292244, 6);
-	MD5STEP(F4, d, a, b, c, in[7] + 0x432aff97, 10);
-	MD5STEP(F4, c, d, a, b, in[14] + 0xab9423a7, 15);
-	MD5STEP(F4, b, c, d, a, in[5] + 0xfc93a039, 21);
-	MD5STEP(F4, a, b, c, d, in[12] + 0x655b59c3, 6);
-	MD5STEP(F4, d, a, b, c, in[3] + 0x8f0ccc92, 10);
-	MD5STEP(F4, c, d, a, b, in[10] + 0xffeff47d, 15);
-	MD5STEP(F4, b, c, d, a, in[1] + 0x85845dd1, 21);
-	MD5STEP(F4, a, b, c, d, in[8] + 0x6fa87e4f, 6);
-	MD5STEP(F4, d, a, b, c, in[15] + 0xfe2ce6e0, 10);
-	MD5STEP(F4, c, d, a, b, in[6] + 0xa3014314, 15);
-	MD5STEP(F4, b, c, d, a, in[13] + 0x4e0811a1, 21);
-	MD5STEP(F4, a, b, c, d, in[4] + 0xf7537e82, 6);
-	MD5STEP(F4, d, a, b, c, in[11] + 0xbd3af235, 10);
-	MD5STEP(F4, c, d, a, b, in[2] + 0x2ad7d2bb, 15);
-	MD5STEP(F4, b, c, d, a, in[9] + 0xeb86d391, 21);
-
-	buf[0] += a;
-	buf[1] += b;
-	buf[2] += c;
-	buf[3] += d;
-}
-
-#if 0   /* currently unused */
-/***********************************************************************
- the rfc 2104 version of hmac_md5 initialisation.
-***********************************************************************/
-static void
-hmac_md5_init_rfc2104(unsigned char *key, int key_len,
-		      struct HMACMD5Context *ctx)
-{
-	int i;
-
-	/* if key is longer than 64 bytes reset it to key=MD5(key) */
-	if (key_len > 64) {
-		unsigned char tk[16];
-		struct MD5Context tctx;
-
-		cifs_MD5_init(&tctx);
-		cifs_MD5_update(&tctx, key, key_len);
-		cifs_MD5_final(tk, &tctx);
-
-		key = tk;
-		key_len = 16;
-	}
-
-	/* start out by storing key in pads */
-	memset(ctx->k_ipad, 0, sizeof(ctx->k_ipad));
-	memset(ctx->k_opad, 0, sizeof(ctx->k_opad));
-	memcpy(ctx->k_ipad, key, key_len);
-	memcpy(ctx->k_opad, key, key_len);
-
-	/* XOR key with ipad and opad values */
-	for (i = 0; i < 64; i++) {
-		ctx->k_ipad[i] ^= 0x36;
-		ctx->k_opad[i] ^= 0x5c;
-	}
-
-	cifs_MD5_init(&ctx->ctx);
-	cifs_MD5_update(&ctx->ctx, ctx->k_ipad, 64);
-}
-#endif
-
-/***********************************************************************
- the microsoft version of hmac_md5 initialisation.
-***********************************************************************/
-void
-hmac_md5_init_limK_to_64(const unsigned char *key, int key_len,
-			 struct HMACMD5Context *ctx)
-{
-	int i;
-
-	/* if key is longer than 64 bytes truncate it */
-	if (key_len > 64)
-		key_len = 64;
-
-	/* start out by storing key in pads */
-	memset(ctx->k_ipad, 0, sizeof(ctx->k_ipad));
-	memset(ctx->k_opad, 0, sizeof(ctx->k_opad));
-	memcpy(ctx->k_ipad, key, key_len);
-	memcpy(ctx->k_opad, key, key_len);
-
-	/* XOR key with ipad and opad values */
-	for (i = 0; i < 64; i++) {
-		ctx->k_ipad[i] ^= 0x36;
-		ctx->k_opad[i] ^= 0x5c;
-	}
-
-	cifs_MD5_init(&ctx->ctx);
-	cifs_MD5_update(&ctx->ctx, ctx->k_ipad, 64);
-}
-
-/***********************************************************************
- update hmac_md5 "inner" buffer
-***********************************************************************/
-void
-hmac_md5_update(const unsigned char *text, int text_len,
-		struct HMACMD5Context *ctx)
-{
-	cifs_MD5_update(&ctx->ctx, text, text_len);	/* then text of datagram */
-}
-
-/***********************************************************************
- finish off hmac_md5 "inner" buffer and generate outer one.
-***********************************************************************/
-void
-hmac_md5_final(unsigned char *digest, struct HMACMD5Context *ctx)
-{
-	struct MD5Context ctx_o;
-
-	cifs_MD5_final(digest, &ctx->ctx);
-
-	cifs_MD5_init(&ctx_o);
-	cifs_MD5_update(&ctx_o, ctx->k_opad, 64);
-	cifs_MD5_update(&ctx_o, digest, 16);
-	cifs_MD5_final(digest, &ctx_o);
-}
-
-/***********************************************************
- single function to calculate an HMAC MD5 digest from data.
- use the microsoft hmacmd5 init method because the key is 16 bytes.
-************************************************************/
-#if 0 /* currently unused */
-static void
-hmac_md5(unsigned char key[16], unsigned char *data, int data_len,
-	 unsigned char *digest)
-{
-	struct HMACMD5Context ctx;
-	hmac_md5_init_limK_to_64(key, 16, &ctx);
-	if (data_len != 0)
-		hmac_md5_update(data, data_len, &ctx);
-
-	hmac_md5_final(digest, &ctx);
-}
-#endif
diff --git a/fs/cifs/md5.h b/fs/cifs/md5.h
deleted file mode 100644
index 6fba8cb..0000000
--- a/fs/cifs/md5.h
+++ /dev/null
@@ -1,38 +0,0 @@
-#ifndef MD5_H
-#define MD5_H
-#ifndef HEADER_MD5_H
-/* Try to avoid clashes with OpenSSL */
-#define HEADER_MD5_H
-#endif
-
-struct MD5Context {
-	__u32 buf[4];
-	__u32 bits[2];
-	unsigned char in[64];
-};
-#endif				/* !MD5_H */
-
-#ifndef _HMAC_MD5_H
-struct HMACMD5Context {
-	struct MD5Context ctx;
-	unsigned char k_ipad[65];
-	unsigned char k_opad[65];
-};
-#endif				/* _HMAC_MD5_H */
-
-void cifs_MD5_init(struct MD5Context *context);
-void cifs_MD5_update(struct MD5Context *context, unsigned char const *buf,
-			unsigned len);
-void cifs_MD5_final(unsigned char digest[16], struct MD5Context *context);
-
-/* The following definitions come from lib/hmacmd5.c  */
-
-/* void hmac_md5_init_rfc2104(unsigned char *key, int key_len,
-			struct HMACMD5Context *ctx);*/
-void hmac_md5_init_limK_to_64(const unsigned char *key, int key_len,
-			struct HMACMD5Context *ctx);
-void hmac_md5_update(const unsigned char *text, int text_len,
-			struct HMACMD5Context *ctx);
-void hmac_md5_final(unsigned char *digest, struct HMACMD5Context *ctx);
-/* void hmac_md5(unsigned char key[16], unsigned char *data, int data_len,
-			unsigned char *digest);*/
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 192ea51..3013500 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -32,7 +32,6 @@
 #include "cifs_unicode.h"
 #include "cifspdu.h"
 #include "cifsglob.h"
-#include "md5.h"
 #include "cifs_debug.h"
 #include "cifsencrypt.h"
 
-- 
1.6.0.2
