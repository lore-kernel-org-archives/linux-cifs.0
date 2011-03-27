From: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
Subject: Re: [PATCH] allow cifs passwords with utf8 characters
Date: Sun, 27 Mar 2011 10:18:35 +0200
Message-ID: <20110327081834.GA22851@osk.mine.nu>
References: <20110327070144.GA3772@osk.mine.nu>
 <20110327075438.GA7174@osk.mine.nu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="sm4nu43k4a2Rpi4c"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110327075438.GA7174-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sunday, March 27, 2011 at 09:38, Oskar Liljeblad wrote:
> > I noticed that I could not mount cifs shares when the password contained
> > utf8-encoded latin1 characters. [..]
> [..]
> > +		len = utf8s_to_ucs2(passwd, 128, (wchar_t *) wpwd);
> 
> Looking at the code again, I wonder if not cifs_strtoUCS in cifs_unicode.c
> should've been used instead?

Here is a tested patch that uses cifs_strtoUCS rather than utf8s_to_ucs2.

Regards,

Oskar

--sm4nu43k4a2Rpi4c
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="cifs-nls-password.diff"

diff -u -p fs/cifs/cifsencrypt.c.v0 fs/cifs/cifsencrypt.c
--- fs/cifs/cifsencrypt.c.v0	2010-09-29 03:09:08.000000000 +0200
+++ fs/cifs/cifsencrypt.c	2011-03-27 09:30:46.000000000 +0200
@@ -37,7 +37,8 @@
 	sequence number before this function is called */
 
 extern void mdfour(unsigned char *out, unsigned char *in, int n);
-extern void E_md4hash(const unsigned char *passwd, unsigned char *p16);
+extern void E_md4hash(const unsigned char *passwd, unsigned char *p16,
+		      const struct nls_table *codepage);
 extern void SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 		       unsigned char *p24);
 
@@ -210,13 +211,14 @@ int cifs_verify_signature(struct smb_hdr
 
 /* We fill in key by putting in 40 byte array which was allocated by caller */
 int cifs_calculate_mac_key(struct mac_key *key, const char *rn,
-			   const char *password)
+			   const char *password,
+			   const struct nls_table *codepage)
 {
 	char temp_key[16];
 	if ((key == NULL) || (rn == NULL))
 		return -EINVAL;
 
-	E_md4hash(password, temp_key);
+	E_md4hash(password, temp_key, codepage);
 	mdfour(key->data.ntlm, temp_key, 16);
 	memcpy(key->data.ntlm+16, rn, CIFS_SESS_KEY_SIZE);
 	key->len = 40;
@@ -235,7 +237,7 @@ int CalcNTLMv2_partial_mac_key(struct ci
 	if (ses == NULL)
 		return -EINVAL;
 
-	E_md4hash(ses->password, temp_hash);
+	E_md4hash(ses->password, temp_hash, nls_info);
 
 	hmac_md5_init_limK_to_64(temp_hash, 16, &ctx);
 	user_name_len = strlen(ses->userName);
@@ -335,7 +337,7 @@ static int calc_ntlmv2_hash(struct cifsS
 		return -ENOMEM;
 
 	/* calculate md4 hash of password */
-	E_md4hash(ses->password, nt_hash);
+	E_md4hash(ses->password, nt_hash, nls_cp);
 
 	/* convert Domainname to unicode and uppercase */
 	hmac_md5_init_limK_to_64(nt_hash, 16, pctxt);
diff -u fs/cifs/cifsproto.h.v0 fs/cifs/cifsproto.h
--- fs/cifs/cifsproto.h.v0	2010-09-29 03:09:08.000000000 +0200
+++ fs/cifs/cifsproto.h	2011-03-27 09:29:40.000000000 +0200
@@ -362,7 +362,8 @@
 				 const struct mac_key *mac_key,
 				__u32 expected_sequence_number);
 extern int cifs_calculate_mac_key(struct mac_key *key, const char *rn,
-				 const char *pass);
+				 const char *pass,
+				 const struct nls_table *codepage);
 extern int CalcNTLMv2_partial_mac_key(struct cifsSesInfo *,
 			const struct nls_table *);
 extern void CalcNTLMv2_response(const struct cifsSesInfo *, char *);
diff -u -p fs/cifs/connect.c.v0 fs/cifs/connect.c
--- fs/cifs/connect.c.v0	2010-09-29 03:09:08.000000000 +0200
+++ fs/cifs/connect.c	2011-03-27 09:43:06.000000000 +0200
@@ -53,7 +53,7 @@
 #define RFC1001_PORT 139
 
 extern void SMBNTencrypt(unsigned char *passwd, unsigned char *c8,
-			 unsigned char *p24);
+			 unsigned char *p24, const struct nls_table *codepage);
 
 extern mempool_t *cifs_req_poolp;
 
@@ -2767,7 +2767,7 @@ CIFSTCon(unsigned int xid, struct cifsSe
 		else
 #endif /* CIFS_WEAK_PW_HASH */
 		SMBNTencrypt(tcon->password, ses->server->cryptKey,
-			     bcc_ptr);
+			     bcc_ptr, nls_codepage);
 
 		bcc_ptr += CIFS_SESS_KEY_SIZE;
 		if (ses->capabilities & CAP_UNICODE) {
diff -u -p fs/cifs/sess.c.v0 fs/cifs/sess.c
--- fs/cifs/sess.c.v0	2010-09-29 03:09:08.000000000 +0200
+++ fs/cifs/sess.c	2011-03-27 10:14:11.000000000 +0200
@@ -33,7 +33,8 @@
 #include "cifs_spnego.h"
 
 extern void SMBNTencrypt(unsigned char *passwd, unsigned char *c8,
-			 unsigned char *p24);
+			 unsigned char *p24,
+			 const struct nls_table *codepage);
 
 /*
  * Checks if this is the first smb session to be reconnected after
@@ -478,10 +479,12 @@ static int build_ntlmssp_auth_blob(unsig
 	sec_blob->LmChallengeResponse.MaximumLength = 0;
 
 	/* calculate session key,  BB what about adding similar ntlmv2 path? */
-	SMBNTencrypt(ses->password, ses->server->cryptKey, ntlm_session_key);
+	SMBNTencrypt(ses->password, ses->server->cryptKey, ntlm_session_key,
+		     nls_cp);
 	if (first)
 		cifs_calculate_mac_key(&ses->server->mac_signing_key,
-				       ntlm_session_key, ses->password);
+				       ntlm_session_key, ses->password,
+				       nls_cp);
 
 	memcpy(tmp, ntlm_session_key, CIFS_SESS_KEY_SIZE);
 	sec_blob->NtChallengeResponse.BufferOffset = cpu_to_le32(tmp - pbuffer);
@@ -686,12 +689,12 @@ ssetup_ntlmssp_authenticate:
 
 		/* calculate session key */
 		SMBNTencrypt(ses->password, ses->server->cryptKey,
-			     ntlm_session_key);
+			     ntlm_session_key, nls_cp);
 
 		if (first_time) /* should this be moved into common code
 				  with similar ntlmv2 path? */
 			cifs_calculate_mac_key(&ses->server->mac_signing_key,
-				ntlm_session_key, ses->password);
+				ntlm_session_key, ses->password, nls_cp);
 		/* copy session key */
 
 		memcpy(bcc_ptr, (char *)ntlm_session_key, CIFS_SESS_KEY_SIZE);
diff -u -p fs/cifs/smbencrypt.c.v0 fs/cifs/smbencrypt.c
--- fs/cifs/smbencrypt.c.v0	2010-09-29 03:09:08.000000000 +0200
+++ fs/cifs/smbencrypt.c	2011-03-27 10:13:31.000000000 +0200
@@ -52,10 +52,12 @@
 
 void SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 		unsigned char *p24);
-void E_md4hash(const unsigned char *passwd, unsigned char *p16);
+void E_md4hash(const unsigned char *passwd, unsigned char *p16,
+	       const struct nls_table *codepage);
 static void SMBOWFencrypt(unsigned char passwd[16], const unsigned char *c8,
 		   unsigned char p24[24]);
-void SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned char *p24);
+void SMBNTencrypt(unsigned char *passwd, unsigned char *c8,
+		  unsigned char *p24, const struct nls_table *codepage);
 
 /*
    This implements the X/Open SMB password encryption
@@ -80,66 +82,27 @@ SMBencrypt(unsigned char *passwd, const
 	memset(p21, 0, 21);
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
 
 void
-E_md4hash(const unsigned char *passwd, unsigned char *p16)
+E_md4hash(const unsigned char *passwd, unsigned char *p16,
+	  const struct nls_table *codepage)
 {
 	int len;
 	__u16 wpwd[129];
 
 	/* Password cannot be longer than 128 characters */
 	if (passwd) {
-		len = strlen((char *) passwd);
-		if (len > 128)
-			len = 128;
-
 		/* Password must be converted to NT unicode */
-		_my_mbstowcs(wpwd, passwd, len);
-	} else
+		len = cifs_strtoUCS(wpwd, passwd, 128, codepage);
+	} else {
 		len = 0;
+		*wpwd = 0;	/* Ensure string is null terminated */
+        }
 
-	wpwd[len] = 0;	/* Ensure string is null terminated */
-	/* Calculate length in bytes */
-	len = _my_wcslen(wpwd) * sizeof(__u16);
-
-	mdfour(p16, (unsigned char *) wpwd, len);
+	mdfour(p16, (unsigned char *) wpwd, len * sizeof(__u16));
 	memset(wpwd, 0, 129 * 2);
 }
 
@@ -157,7 +120,7 @@ nt_lm_owf_gen(char *pwd, unsigned char n
 		memcpy(passwd, pwd, 512);
 	/* Calculate the MD4 hash (NT compatible) of the password */
 	memset(nt_p16, '\0', 16);
-	E_md4hash(passwd, nt_p16);
+	E_md4hash(passwd, nt_p16, /* put codepage here */);
 
 	/* Mangle the passwords into Lanman format */
 	passwd[14] = '\0';
@@ -244,13 +207,14 @@ NTLMSSPOWFencrypt(unsigned char passwd[8
 /* Does the NT MD4 hash then des encryption. */
 
 void
-SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned char *p24)
+SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned char *p24,
+	     const struct nls_table *codepage)
 {
 	unsigned char p21[21];
 
 	memset(p21, '\0', 21);
 
-	E_md4hash(passwd, p21);
+	E_md4hash(passwd, p21, codepage);
 	SMBOWFencrypt(p21, c8, p24);
 }
 

--sm4nu43k4a2Rpi4c--
