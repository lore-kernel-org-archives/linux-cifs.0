From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: clean up unused encryption code
Date: Wed, 21 Sep 2011 14:33:31 -0500
Message-ID: <1316633611-24960-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Remove unsed  #if 0 encryption code.


0002-cifs-clean-up-unused-encryption-code.patch
---
 fs/cifs/smbencrypt.c |  121 --------------------------------------------------
 1 files changed, 0 insertions(+), 121 deletions(-)

diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 42b9fff..ac1221d 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -265,91 +265,6 @@ E_md4hash(const unsigned char *passwd, unsigned char *p16)
 	return rc;
 }
 
-#if 0 /* currently unused */
-/* Does both the NT and LM owfs of a user's password */
-static void
-nt_lm_owf_gen(char *pwd, unsigned char nt_p16[16], unsigned char p16[16])
-{
-	char passwd[514];
-
-	memset(passwd, '\0', 514);
-	if (strlen(pwd) < 513)
-		strcpy(passwd, pwd);
-	else
-		memcpy(passwd, pwd, 512);
-	/* Calculate the MD4 hash (NT compatible) of the password */
-	memset(nt_p16, '\0', 16);
-	E_md4hash(passwd, nt_p16);
-
-	/* Mangle the passwords into Lanman format */
-	passwd[14] = '\0';
-/*	strupper(passwd); */
-
-	/* Calculate the SMB (lanman) hash functions of the password */
-
-	memset(p16, '\0', 16);
-	E_P16((unsigned char *) passwd, (unsigned char *) p16);
-
-	/* clear out local copy of user's password (just being paranoid). */
-	memset(passwd, '\0', sizeof(passwd));
-}
-#endif
-
-/* Does the NTLMv2 owfs of a user's password */
-#if 0  /* function not needed yet - but will be soon */
-static void
-ntv2_owf_gen(const unsigned char owf[16], const char *user_n,
-		const char *domain_n, unsigned char kr_buf[16],
-		const struct nls_table *nls_codepage)
-{
-	wchar_t *user_u;
-	wchar_t *dom_u;
-	int user_l, domain_l;
-	struct HMACMD5Context ctx;
-
-	/* might as well do one alloc to hold both (user_u and dom_u) */
-	user_u = kmalloc(2048 * sizeof(wchar_t), GFP_KERNEL);
-	if (user_u == NULL)
-		return;
-	dom_u = user_u + 1024;
-
-	/* push_ucs2(NULL, user_u, user_n, (user_l+1)*2,
-			STR_UNICODE|STR_NOALIGN|STR_TERMINATE|STR_UPPER);
-	   push_ucs2(NULL, dom_u, domain_n, (domain_l+1)*2,
-			STR_UNICODE|STR_NOALIGN|STR_TERMINATE|STR_UPPER); */
-
-	/* BB user and domain may need to be uppercased */
-	user_l = cifs_strtoUCS(user_u, user_n, 511, nls_codepage);
-	domain_l = cifs_strtoUCS(dom_u, domain_n, 511, nls_codepage);
-
-	user_l++;		/* trailing null */
-	domain_l++;
-
-	hmac_md5_init_limK_to_64(owf, 16, &ctx);
-	hmac_md5_update((const unsigned char *) user_u, user_l * 2, &ctx);
-	hmac_md5_update((const unsigned char *) dom_u, domain_l * 2, &ctx);
-	hmac_md5_final(kr_buf, &ctx);
-
-	kfree(user_u);
-}
-#endif
-
-/* Does the des encryption from the FIRST 8 BYTES of the NT or LM MD4 hash. */
-#if 0 /* currently unused */
-static void
-NTLMSSPOWFencrypt(unsigned char passwd[8],
-		  unsigned char *ntlmchalresp, unsigned char p24[24])
-{
-	unsigned char p21[21];
-
-	memset(p21, '\0', 21);
-	memcpy(p21, passwd, 8);
-	memset(p21 + 8, 0xbd, 8);
-
-	E_P24(p21, ntlmchalresp, p24);
-}
-#endif
-
 /* Does the NT MD4 hash then des encryption. */
 int
 SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned char *p24)
@@ -369,39 +284,3 @@ SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned char *p24)
 	rc = E_P24(p21, c8, p24);
 	return rc;
 }
-
-
-/* Does the md5 encryption from the NT hash for NTLMv2. */
-/* These routines will be needed later */
-#if 0
-static void
-SMBOWFencrypt_ntv2(const unsigned char kr[16],
-		   const struct data_blob *srv_chal,
-		   const struct data_blob *cli_chal, unsigned char resp_buf[16])
-{
-	struct HMACMD5Context ctx;
-
-	hmac_md5_init_limK_to_64(kr, 16, &ctx);
-	hmac_md5_update(srv_chal->data, srv_chal->length, &ctx);
-	hmac_md5_update(cli_chal->data, cli_chal->length, &ctx);
-	hmac_md5_final(resp_buf, &ctx);
-}
-
-static void
-SMBsesskeygen_ntv2(const unsigned char kr[16],
-		   const unsigned char *nt_resp, __u8 sess_key[16])
-{
-	struct HMACMD5Context ctx;
-
-	hmac_md5_init_limK_to_64(kr, 16, &ctx);
-	hmac_md5_update(nt_resp, 16, &ctx);
-	hmac_md5_final((unsigned char *) sess_key, &ctx);
-}
-
-static void
-SMBsesskeygen_ntv1(const unsigned char kr[16],
-		   const unsigned char *nt_resp, __u8 sess_key[16])
-{
-	mdfour((unsigned char *) sess_key, (unsigned char *) kr, 16);
-}
-#endif
-- 
1.6.0.2
