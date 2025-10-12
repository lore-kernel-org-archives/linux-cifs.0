Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB4920F08E;
	Sun, 12 Oct 2025 01:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760234389; cv=none; b=c/6uqXoYjRSrJG+YfCH65Ca64fUNwuUXFDbuuq8zLamTFjGAmAk1sKkxWxzY4E52hs67nc465umMH7Y9HwPHHc39PowzkWmm57CHVOlT9aisOhG9m3HK2GBsYtiyYrKwDoUZ99KomH6Jp3ZDaWWG1Nr0L8dO8xJEd2nG70y2l5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760234389; c=relaxed/simple;
	bh=J6mbhHXU0seemf1o87nmEu43wEPi9saI0VMIAbjq9mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUxe/0FGGv+hyrkkIDspnhxHS8g/JijqrP2Rvjm/PPpyZgEG1RX63mNvJemGY1/veJuQJsc/ShwCJHaH3KIadaSOZVx07d3Eta+cy3Lj4yCtP22ARfywiBZnT84OC0GiYl5gqsg+ghRUlkieO1bfhmHgeDUBY7JR+h1k9karD4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kIImpOmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kIImpOmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E24C4AF09;
	Sun, 12 Oct 2025 01:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760234387;
	bh=J6mbhHXU0seemf1o87nmEu43wEPi9saI0VMIAbjq9mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kIImpOmLVSuiSsv4S+rFxYlKi8EwLJnegWbA/vPc0+eTLH26dyMnyCiPsMnHya2Py
	 2+CoT/Dx8oYwvHdtGF04wPpg1xdbAfk4KCXkllb+EBfLjesFlRogsROtHfUXzhgNS+
	 2GulfyiVFUTPS8+xlwj0TJLTPhVPTTOHg62r4937ukloDVrWpK6nUuGi1d4WoSofVf
	 P3+4s2TjmSEIPwy2YrMkMOcUgFrMe5YvN9a+QrivOMMgChn+lJB0QRyTpx+fudFd2t
	 f1C3WgDM2jbkWQcIZubIwOJrYbaY2hT/13L+1HlNzizATC+Y5tOhdPb7SeBbkYpoCh
	 cyH4H+e1u9+fA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>
Cc: samba-technical@lists.samba.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6/8] smb: client: Use HMAC-MD5 library for NTLMv2
Date: Sat, 11 Oct 2025 18:57:36 -0700
Message-ID: <20251012015738.244315-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251012015738.244315-1-ebiggers@kernel.org>
References: <20251012015738.244315-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the HMAC-MD5 computations in NTLMv2, use the HMAC-MD5 library
instead of a "hmac(md5)" crypto_shash.  This is simpler and faster.
With the library there's no need to allocate memory, no need to handle
errors, and the HMAC-MD5 code is accessed directly without inefficient
indirect calls and other unnecessary API overhead.

To preserve the existing behavior of NTLMv2 support being disabled when
the kernel is booted with "fips=1", make setup_ntlmv2_rsp() check
fips_enabled itself.  Previously it relied on the error from
cifs_alloc_hash("hmac(md5)", &hmacmd5).

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/client/cifsencrypt.c | 114 +++++++-----------------------------
 1 file changed, 22 insertions(+), 92 deletions(-)

diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index 80215ba7a5744..bbcf3b05c19ab 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -423,33 +423,23 @@ static __le64 find_timestamp(struct cifs_ses *ses)
 	ktime_get_real_ts64(&ts);
 	return cpu_to_le64(cifs_UnixTimeToNT(ts));
 }
 
 static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
-			    const struct nls_table *nls_cp, struct shash_desc *hmacmd5)
+			    const struct nls_table *nls_cp)
 {
-	int rc = 0;
 	int len;
 	char nt_hash[CIFS_NTHASH_SIZE];
+	struct hmac_md5_ctx hmac_ctx;
 	__le16 *user;
 	wchar_t *domain;
 	wchar_t *server;
 
 	/* calculate md4 hash of password */
 	E_md4hash(ses->password, nt_hash, nls_cp);
 
-	rc = crypto_shash_setkey(hmacmd5->tfm, nt_hash, CIFS_NTHASH_SIZE);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not set NT hash as a key, rc=%d\n", __func__, rc);
-		return rc;
-	}
-
-	rc = crypto_shash_init(hmacmd5);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not init HMAC-MD5, rc=%d\n", __func__, rc);
-		return rc;
-	}
+	hmac_md5_init_usingrawkey(&hmac_ctx, nt_hash, CIFS_NTHASH_SIZE);
 
 	/* convert ses->user_name to unicode */
 	len = ses->user_name ? strlen(ses->user_name) : 0;
 	user = kmalloc(2 + (len * 2), GFP_KERNEL);
 	if (user == NULL)
@@ -460,16 +450,12 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 		UniStrupr(user);
 	} else {
 		*(u16 *)user = 0;
 	}
 
-	rc = crypto_shash_update(hmacmd5, (char *)user, 2 * len);
+	hmac_md5_update(&hmac_ctx, (const u8 *)user, 2 * len);
 	kfree(user);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not update with user, rc=%d\n", __func__, rc);
-		return rc;
-	}
 
 	/* convert ses->domainName to unicode and uppercase */
 	if (ses->domainName) {
 		len = strlen(ses->domainName);
 
@@ -477,81 +463,48 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 		if (domain == NULL)
 			return -ENOMEM;
 
 		len = cifs_strtoUTF16((__le16 *)domain, ses->domainName, len,
 				      nls_cp);
-		rc = crypto_shash_update(hmacmd5, (char *)domain, 2 * len);
+		hmac_md5_update(&hmac_ctx, (const u8 *)domain, 2 * len);
 		kfree(domain);
-		if (rc) {
-			cifs_dbg(VFS, "%s: Could not update with domain, rc=%d\n", __func__, rc);
-			return rc;
-		}
 	} else {
 		/* We use ses->ip_addr if no domain name available */
 		len = strlen(ses->ip_addr);
 
 		server = kmalloc(2 + (len * 2), GFP_KERNEL);
 		if (server == NULL)
 			return -ENOMEM;
 
 		len = cifs_strtoUTF16((__le16 *)server, ses->ip_addr, len, nls_cp);
-		rc = crypto_shash_update(hmacmd5, (char *)server, 2 * len);
+		hmac_md5_update(&hmac_ctx, (const u8 *)server, 2 * len);
 		kfree(server);
-		if (rc) {
-			cifs_dbg(VFS, "%s: Could not update with server, rc=%d\n", __func__, rc);
-			return rc;
-		}
 	}
 
-	rc = crypto_shash_final(hmacmd5, ntlmv2_hash);
-	if (rc)
-		cifs_dbg(VFS, "%s: Could not generate MD5 hash, rc=%d\n", __func__, rc);
-
-	return rc;
+	hmac_md5_final(&hmac_ctx, ntlmv2_hash);
+	return 0;
 }
 
-static int
-CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash, struct shash_desc *hmacmd5)
+static void CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 {
-	int rc;
 	struct ntlmv2_resp *ntlmv2 = (struct ntlmv2_resp *)
 	    (ses->auth_key.response + CIFS_SESS_KEY_SIZE);
 	unsigned int hash_len;
 
 	/* The MD5 hash starts at challenge_key.key */
 	hash_len = ses->auth_key.len - (CIFS_SESS_KEY_SIZE +
 		offsetof(struct ntlmv2_resp, challenge.key[0]));
 
-	rc = crypto_shash_setkey(hmacmd5->tfm, ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not set NTLMv2 hash as a key, rc=%d\n", __func__, rc);
-		return rc;
-	}
-
-	rc = crypto_shash_init(hmacmd5);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not init HMAC-MD5, rc=%d\n", __func__, rc);
-		return rc;
-	}
-
 	if (ses->server->negflavor == CIFS_NEGFLAVOR_EXTENDED)
 		memcpy(ntlmv2->challenge.key, ses->ntlmssp->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
 	else
 		memcpy(ntlmv2->challenge.key, ses->server->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
 
-	rc = crypto_shash_update(hmacmd5, ntlmv2->challenge.key, hash_len);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not update with response, rc=%d\n", __func__, rc);
-		return rc;
-	}
-
-	/* Note that the MD5 digest over writes anon.challenge_key.key */
-	rc = crypto_shash_final(hmacmd5, ntlmv2->ntlmv2_hash);
-	if (rc)
-		cifs_dbg(VFS, "%s: Could not generate MD5 hash, rc=%d\n", __func__, rc);
-
-	return rc;
+	/* Note that the HMAC-MD5 value overwrites ntlmv2->challenge.key */
+	hmac_md5_usingrawkey(ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE,
+			     ntlmv2->challenge.key, hash_len,
+			     ntlmv2->ntlmv2_hash);
 }
 
 /*
  * Set up NTLMv2 response blob with SPN (cifs/<hostname>) appended to the
  * existing list of AV pairs.
@@ -604,11 +557,10 @@ static int set_auth_key_response(struct cifs_ses *ses)
 }
 
 int
 setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 {
-	struct shash_desc *hmacmd5 = NULL;
 	unsigned char *tiblob = NULL; /* target info blob */
 	struct ntlmv2_resp *ntlmv2;
 	char ntlmv2_hash[16];
 	__le64 rsp_timestamp;
 	__u64 cc;
@@ -675,55 +627,33 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	ntlmv2->reserved = 0;
 	ntlmv2->time = rsp_timestamp;
 	ntlmv2->client_chal = cc;
 	ntlmv2->reserved2 = 0;
 
-	rc = cifs_alloc_hash("hmac(md5)", &hmacmd5);
-	if (rc) {
-		cifs_dbg(VFS, "Could not allocate HMAC-MD5, rc=%d\n", rc);
+	if (fips_enabled) {
+		cifs_dbg(VFS, "NTLMv2 support is disabled due to FIPS\n");
+		rc = -EOPNOTSUPP;
 		goto unlock;
 	}
 
 	/* calculate ntlmv2_hash */
-	rc = calc_ntlmv2_hash(ses, ntlmv2_hash, nls_cp, hmacmd5);
+	rc = calc_ntlmv2_hash(ses, ntlmv2_hash, nls_cp);
 	if (rc) {
 		cifs_dbg(VFS, "Could not get NTLMv2 hash, rc=%d\n", rc);
 		goto unlock;
 	}
 
 	/* calculate first part of the client response (CR1) */
-	rc = CalcNTLMv2_response(ses, ntlmv2_hash, hmacmd5);
-	if (rc) {
-		cifs_dbg(VFS, "Could not calculate CR1, rc=%d\n", rc);
-		goto unlock;
-	}
+	CalcNTLMv2_response(ses, ntlmv2_hash);
 
 	/* now calculate the session key for NTLMv2 */
-	rc = crypto_shash_setkey(hmacmd5->tfm, ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not set NTLMv2 hash as a key, rc=%d\n", __func__, rc);
-		goto unlock;
-	}
-
-	rc = crypto_shash_init(hmacmd5);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not init HMAC-MD5, rc=%d\n", __func__, rc);
-		goto unlock;
-	}
-
-	rc = crypto_shash_update(hmacmd5, ntlmv2->ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not update with response, rc=%d\n", __func__, rc);
-		goto unlock;
-	}
-
-	rc = crypto_shash_final(hmacmd5, ses->auth_key.response);
-	if (rc)
-		cifs_dbg(VFS, "%s: Could not generate MD5 hash, rc=%d\n", __func__, rc);
+	hmac_md5_usingrawkey(ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE,
+			     ntlmv2->ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE,
+			     ses->auth_key.response);
+	rc = 0;
 unlock:
 	cifs_server_unlock(ses->server);
-	cifs_free_hash(&hmacmd5);
 setup_ntlmv2_rsp_ret:
 	kfree_sensitive(tiblob);
 
 	return rc;
 }
-- 
2.51.0

