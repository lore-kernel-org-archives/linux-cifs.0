Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B65D2FE575;
	Wed, 18 Feb 2026 21:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771450616; cv=none; b=TLUCR7pWE8DBQviNsT//f6Pa0dulOoBLETa9BdVnu5INIKXRBKYNWxxSp3zj2WnXhnwWSpAGhyb9Frz3ZrVRGx9yCmD5XkJtnxM9Lcvl/cT5mJdVQI7T+3UBrYi12gn3+w+NyntjsT7zupYtSyGHJS9Vnx+JisRqmNQaIqZja1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771450616; c=relaxed/simple;
	bh=LoZhuuxzNWOyrPmwe9ku8/14QhyJ8CKzIMFUQopSDgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAr++gPo9lZFRQ7KFvGlBheQrNNE2iHJcXWEpIagIEEpaOQQeLkgWjRERWq0x0rVnXCvaQz7cEhTbwBBheR9HD+QipfUm3D3ige9GpQuVbNY6J8ikNQ+xPrHC8C0lSpsVWiUjLowsdcfL/Xl3taXD7Lo0SZi57bTqoXs1OkNR0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c0vKBFRD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c0vKBFRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F24C19421;
	Wed, 18 Feb 2026 21:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771450616;
	bh=LoZhuuxzNWOyrPmwe9ku8/14QhyJ8CKzIMFUQopSDgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0vKBFRDl5TZsypRiZLNxLu+gyGyL/z7hDpq+OPPeKBKVI4VkdjUN6evSVA+WExM4
	 M5wEqlOBLmYXFkedkv22ojxpcmNWsKHhqYotwkXWhivyLdyWuXh6DpmlslLgzNfSFt
	 aV8XJw8qfD0RbGBKHO9BKzaNODK7LY0h6V+UNcn9Tj2d5U6gSQ5CAdSDgN7fKUG1yA
	 trftxnltQKqv2rFNPbkRjJNBq7qw4hrLp4KfWkfkachUqZ+60bmF1+6jsHlBZNnen9
	 DSHxYzddUtracdqj55ayRleE2P3sNmGU0zojugQw/semrjOQZHbAjbmF9g8ZNX4pwt
	 GpjaoIQ5XEixA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 10/15] smb: client: Make generate_key() return void
Date: Wed, 18 Feb 2026 13:34:56 -0800
Message-ID: <20260218213501.136844-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260218213501.136844-1-ebiggers@kernel.org>
References: <20260218213501.136844-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the crypto library API is now being used instead of crypto_shash,
generate_key() can no longer fail.  Make it return void and simplify the
callers accordingly.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/client/smb2transport.c | 45 +++++++++++++----------------------
 1 file changed, 16 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 716e58d1b1c9..0176185a1efc 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -249,12 +249,12 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 		memcpy(shdr->Signature, smb2_signature, SMB2_SIGNATURE_SIZE);
 
 	return rc;
 }
 
-static int generate_key(struct cifs_ses *ses, struct kvec label,
-			struct kvec context, __u8 *key, unsigned int key_size)
+static void generate_key(struct cifs_ses *ses, struct kvec label,
+			 struct kvec context, __u8 *key, unsigned int key_size)
 {
 	unsigned char zero = 0x0;
 	__u8 i[4] = {0, 0, 0, 1};
 	__u8 L128[4] = {0, 0, 0, 128};
 	__u8 L256[4] = {0, 0, 1, 0};
@@ -279,11 +279,10 @@ static int generate_key(struct cifs_ses *ses, struct kvec label,
 		hmac_sha256_update(&hmac_ctx, L128, 4);
 	}
 	hmac_sha256_final(&hmac_ctx, prfhash);
 
 	memcpy(key, prfhash, key_size);
-	return 0;
 }
 
 struct derivation {
 	struct kvec label;
 	struct kvec context;
@@ -298,11 +297,10 @@ struct derivation_triplet {
 static int
 generate_smb3signingkey(struct cifs_ses *ses,
 			struct TCP_Server_Info *server,
 			const struct derivation_triplet *ptriplet)
 {
-	int rc;
 	bool is_binding = false;
 	int chan_index = 0;
 
 	spin_lock(&ses->ses_lock);
 	spin_lock(&ses->chan_lock);
@@ -329,42 +327,31 @@ generate_smb3signingkey(struct cifs_ses *ses,
 	 * key and store it in the channel as to not overwrite the
 	 * master connection signing key stored in the session
 	 */
 
 	if (is_binding) {
-		rc = generate_key(ses, ptriplet->signing.label,
-				  ptriplet->signing.context,
-				  ses->chans[chan_index].signkey,
-				  SMB3_SIGN_KEY_SIZE);
-		if (rc)
-			return rc;
+		generate_key(ses, ptriplet->signing.label,
+			     ptriplet->signing.context,
+			     ses->chans[chan_index].signkey,
+			     SMB3_SIGN_KEY_SIZE);
 	} else {
-		rc = generate_key(ses, ptriplet->signing.label,
-				  ptriplet->signing.context,
-				  ses->smb3signingkey,
-				  SMB3_SIGN_KEY_SIZE);
-		if (rc)
-			return rc;
+		generate_key(ses, ptriplet->signing.label,
+			     ptriplet->signing.context,
+			     ses->smb3signingkey, SMB3_SIGN_KEY_SIZE);
 
 		/* safe to access primary channel, since it will never go away */
 		spin_lock(&ses->chan_lock);
 		memcpy(ses->chans[chan_index].signkey, ses->smb3signingkey,
 		       SMB3_SIGN_KEY_SIZE);
 		spin_unlock(&ses->chan_lock);
 
-		rc = generate_key(ses, ptriplet->encryption.label,
-				  ptriplet->encryption.context,
-				  ses->smb3encryptionkey,
-				  SMB3_ENC_DEC_KEY_SIZE);
-		if (rc)
-			return rc;
-		rc = generate_key(ses, ptriplet->decryption.label,
-				  ptriplet->decryption.context,
-				  ses->smb3decryptionkey,
-				  SMB3_ENC_DEC_KEY_SIZE);
-		if (rc)
-			return rc;
+		generate_key(ses, ptriplet->encryption.label,
+			     ptriplet->encryption.context,
+			     ses->smb3encryptionkey, SMB3_ENC_DEC_KEY_SIZE);
+		generate_key(ses, ptriplet->decryption.label,
+			     ptriplet->decryption.context,
+			     ses->smb3decryptionkey, SMB3_ENC_DEC_KEY_SIZE);
 	}
 
 #ifdef CONFIG_CIFS_DEBUG_DUMP_KEYS
 	cifs_dbg(VFS, "%s: dumping generated AES session keys\n", __func__);
 	/*
@@ -389,11 +376,11 @@ generate_smb3signingkey(struct cifs_ses *ses,
 				SMB3_GCM128_CRYPTKEY_SIZE, ses->smb3encryptionkey);
 		cifs_dbg(VFS, "ServerOut Key %*ph\n",
 				SMB3_GCM128_CRYPTKEY_SIZE, ses->smb3decryptionkey);
 	}
 #endif
-	return rc;
+	return 0;
 }
 
 int
 generate_smb30signingkey(struct cifs_ses *ses,
 			 struct TCP_Server_Info *server)
-- 
2.53.0

