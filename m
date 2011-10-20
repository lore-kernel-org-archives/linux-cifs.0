From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Assume passwords are encoded according to iocharset (try #2)
Date: Thu, 20 Oct 2011 13:21:59 -0500
Message-ID: <1319134919-4300-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Re-posting a patch originally posted by Oskar Liljeblad after
rebasing on 3.2.


Modify cifs to assume that the supplied password is encoded according
to iocharset.  Before this patch passwords would be treated as
raw 8-bit data, which made authentication with Unicode passwords impossible
(at least passwords with characters > 0xFF).

The previous code would as a side effect accept passwords encoded with
ISO 8859-1, since Unicode < 0x100 basically is ISO 8859-1.  Software which
relies on that will no longer support password chars > 0x7F unless it also
uses iocharset=iso8859-1.  (mount.cifs does not care about the encoding so
it will work as expected.)

Signed-off-by: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Tested-by: A <nimbus1_03087-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |    8 +++---
 fs/cifs/cifsproto.h   |    8 ++++--
 fs/cifs/connect.c     |    2 +-
 fs/cifs/sess.c        |    2 +-
 fs/cifs/smbencrypt.c  |   63 +++++++++---------------------------------------
 5 files changed, 23 insertions(+), 60 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 2cfb695..5d9b9ac 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -204,7 +204,7 @@ int cifs_verify_signature(struct kvec *iov, unsigned int nr_iov,
 }
 
 /* first calculate 24 bytes ntlm response and then 16 byte session key */
-int setup_ntlm_response(struct cifs_ses *ses)
+int setup_ntlm_response(struct cifs_ses *ses, const struct nls_table *nls_cp)
 {
 	int rc = 0;
 	unsigned int temp_len = CIFS_SESS_KEY_SIZE + CIFS_AUTH_RESP_SIZE;
@@ -221,14 +221,14 @@ int setup_ntlm_response(struct cifs_ses *ses)
 	ses->auth_key.len = temp_len;
 
 	rc = SMBNTencrypt(ses->password, ses->server->cryptkey,
-			ses->auth_key.response + CIFS_SESS_KEY_SIZE);
+			ses->auth_key.response + CIFS_SESS_KEY_SIZE, nls_cp);
 	if (rc) {
 		cFYI(1, "%s Can't generate NTLM response, error: %d",
 			__func__, rc);
 		return rc;
 	}
 
-	rc = E_md4hash(ses->password, temp_key);
+	rc = E_md4hash(ses->password, temp_key, nls_cp);
 	if (rc) {
 		cFYI(1, "%s Can't generate NT hash, error: %d", __func__, rc);
 		return rc;
@@ -404,7 +404,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	}
 
 	/* calculate md4 hash of password */
-	E_md4hash(ses->password, nt_hash);
+	E_md4hash(ses->password, nt_hash, nls_cp);
 
 	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5, nt_hash,
 				CIFS_NTHASH_SIZE);
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index c25d063..17ad887 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -392,8 +392,9 @@ extern int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *,
 extern int cifs_verify_signature(struct kvec *iov, unsigned int nr_iov,
 				 struct TCP_Server_Info *server,
 				__u32 expected_sequence_number);
-extern int SMBNTencrypt(unsigned char *, unsigned char *, unsigned char *);
-extern int setup_ntlm_response(struct cifs_ses *);
+extern int SMBNTencrypt(unsigned char *, unsigned char *, unsigned char *,
+			const struct nls_table *);
+extern int setup_ntlm_response(struct cifs_ses *, const struct nls_table *);
 extern int setup_ntlmv2_rsp(struct cifs_ses *, const struct nls_table *);
 extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
 extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
@@ -445,7 +446,8 @@ extern int CIFSCheckMFSymlink(struct cifs_fattr *fattr,
 		const unsigned char *path,
 		struct cifs_sb_info *cifs_sb, int xid);
 extern int mdfour(unsigned char *, unsigned char *, int);
-extern int E_md4hash(const unsigned char *passwd, unsigned char *p16);
+extern int E_md4hash(const unsigned char *passwd, unsigned char *p16,
+			const struct nls_table *codepage);
 extern int SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 			unsigned char *p24);
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f70d87d..4737e95 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3452,7 +3452,7 @@ CIFSTCon(unsigned int xid, struct cifs_ses *ses,
 		else
 #endif /* CIFS_WEAK_PW_HASH */
 		rc = SMBNTencrypt(tcon->password, ses->server->cryptkey,
-					bcc_ptr);
+					bcc_ptr, nls_codepage);
 
 		bcc_ptr += CIFS_AUTH_RESP_SIZE;
 		if (ses->capabilities & CAP_UNICODE) {
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index c7d80e2..4ec3ee9 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -683,7 +683,7 @@ ssetup_ntlmssp_authenticate:
 			cpu_to_le16(CIFS_AUTH_RESP_SIZE);
 
 		/* calculate ntlm response and session key */
-		rc = setup_ntlm_response(ses);
+		rc = setup_ntlm_response(ses, nls_cp);
 		if (rc) {
 			cERROR(1, "Error %d during NTLM authentication", rc);
 			goto ssetup_exit;
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index ac1221d..7cacba1 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -199,75 +199,36 @@ SMBencrypt(unsigned char *passwd, const unsigned char *c8, unsigned char *p24)
 	return rc;
 }
 
-/* Routines for Windows NT MD4 Hash functions. */
-static int
-_my_wcslen(__u16 *str)
-{
-	int len = 0;
-	while (*str++ != 0)
-		len++;
-	return len;
-}
-
-/*
- * Convert a string into an NT UNICODE string.
- * Note that regardless of processor type
- * this must be in intel (little-endian)
- * format.
- */
-
-static int
-_my_mbstowcs(__u16 *dst, const unsigned char *src, int len)
-{	/* BB not a very good conversion routine - change/fix */
-	int i;
-	__u16 val;
-
-	for (i = 0; i < len; i++) {
-		val = *src;
-		SSVAL(dst, 0, val);
-		dst++;
-		src++;
-		if (val == 0)
-			break;
-	}
-	return i;
-}
-
 /*
  * Creates the MD4 Hash of the users password in NT UNICODE.
  */
 
 int
-E_md4hash(const unsigned char *passwd, unsigned char *p16)
+E_md4hash(const unsigned char *passwd, unsigned char *p16,
+	const struct nls_table *codepage)
 {
 	int rc;
 	int len;
 	__u16 wpwd[129];
 
 	/* Password cannot be longer than 128 characters */
-	if (passwd) {
-		len = strlen((char *) passwd);
-		if (len > 128)
-			len = 128;
-
-		/* Password must be converted to NT unicode */
-		_my_mbstowcs(wpwd, passwd, len);
-	} else
+	if (passwd) /* Password must be converted to NT unicode */
+		len = cifs_strtoUCS(wpwd, passwd, 128, codepage);
+	else {
 		len = 0;
+		*wpwd = 0; /* Ensure string is null terminated */
+	}
 
-	wpwd[len] = 0;	/* Ensure string is null terminated */
-	/* Calculate length in bytes */
-	len = _my_wcslen(wpwd) * sizeof(__u16);
-
-	rc = mdfour(p16, (unsigned char *) wpwd, len);
-	memset(wpwd, 0, 129 * 2);
+	rc = mdfour(p16, (unsigned char *) wpwd, len * sizeof(__u16));
+	memset(wpwd, 0, 129 * sizeof(__u16));
 
 	return rc;
 }
 
 /* Does the NT MD4 hash then des encryption. */
 int
-SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned char *p24)
+SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned char *p24,
+		const struct nls_table *codepage)
 {
 	int rc;
 	unsigned char p16[16], p21[21];
@@ -275,7 +236,7 @@ SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned char *p24)
 	memset(p16, '\0', 16);
 	memset(p21, '\0', 21);
 
-	rc = E_md4hash(passwd, p16);
+	rc = E_md4hash(passwd, p16, codepage);
 	if (rc) {
 		cFYI(1, "%s Can't generate NT hash, error: %d", __func__, rc);
 		return rc;
-- 
1.6.0.2
