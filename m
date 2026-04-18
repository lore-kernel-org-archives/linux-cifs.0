Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24FB34B67F;
	Sat, 18 Apr 2026 22:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776550418; cv=none; b=Atd44hrhOJrjqcykHWXMlAspFquxuA9T6zBKmdt+wiulpLoTeC7Ozd9Td1SVQiw/BQhZpT2J2vGrVgcxYVPD+S/oDEnJ46c0VrZkETkX+KOtukQ0tgxV+JqRUUrA7B5KfnTrGolsOWdYXXGtcs+mwEqTq0W175KHeio1an4XjV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776550418; c=relaxed/simple;
	bh=dduO/wo4ls3VYjlBoyPEBSOeyenJwQ8ce38JIdpYdm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7r4q0rYmL6CSOp1rgdAbYZVYvADxjf9g5FaXY+ubY8yyZ+VSCOfQKK20zY8QPDQTBPGOZn71VhQ5xSSpUN3yIwqUJ01y2XpcwbAe/TH+SdyiyC0u2hd7Z21sj1zYiXeouybhC3JIlEzDF1g9uNXKtJiTKkIZjCLReOm202VjGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S/V8BVDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S/V8BVDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5906CC4AF09;
	Sat, 18 Apr 2026 22:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776550418;
	bh=dduO/wo4ls3VYjlBoyPEBSOeyenJwQ8ce38JIdpYdm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/V8BVDKDwlSXU102LG/X4fwc7cAPVYBnsYdqGZNjFSnS+R69L6H7GkvDIDWnYX1L
	 AXjuCE/YDK26bAq+FhmmYrbX7n/qWspuhoM2vqOIwhDku4ygHk784POtAoIFyKQRoC
	 l6HA6+kHwEftaRsFElvNQMejsqp4nG9JL0EkIsv1g1a5SzzOtfMjgQ/N4Q4DVkIa32
	 kBkB2rtmLBuuhvlz1cfnGTTxqwwkjOTVYAiBPORRp0VL97guU0hB+TlLa1eOqswEvF
	 3AX2dljmbOB7+MFU5gGQkycJ5+FzWHrrpyWMrO8VyjYJzL0LnlhwIEUqgngZxMTVF8
	 zRO5eWiMNTr3g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>
Cc: linux-crypto@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 3/4] smb: client: Make generate_key() return void
Date: Sat, 18 Apr 2026 15:13:10 -0700
Message-ID: <20260418221311.67583-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418221311.67583-1-ebiggers@kernel.org>
References: <20260418221311.67583-1-ebiggers@kernel.org>
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

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/smb/client/smb2transport.c | 45 +++++++++++++----------------------
 1 file changed, 16 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 716e58d1b1c92..0176185a1efcb 100644
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

