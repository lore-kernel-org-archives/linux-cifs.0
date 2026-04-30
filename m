Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F8F478846
	for <linux-cifs@vger.kernel.org>; Thu, 30 Apr 2026 17:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777571324; cv=none; b=osBhKX4FoypZp4G8KR2YwVrS51y539IHfNwox3yGHKjbubYmBjIY1GwKz0ScQrxN+8bCGL6qipmcmv3q0Zpm8cXCWi2oidAjMLSuYcqXsLvdiO/1EupItlbS+PuNz2JjoQVdFyGr1/phC/9VbDHRvD5VX8tBnhG7IlXOVAu0Wyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777571324; c=relaxed/simple;
	bh=0dIn3pRB9mFvWh8+m3Q/ynj13bsM4JgCV1C0hx+Z2lY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hFeRdaqo48FYHJhUcmiwWj0eInl6WUlu9OORclnbh1efveGMu+yb9Tz8p+03TWeyXh6mw8UY+xidtm+6Hc3cOOkt3tvEsgU2Bbsk71ahvLkTi7gqHUWFYAnc0RPAW525oCowwl8DEeUj/6io4Unfe22F8qSlvN052tdqzLx+vlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qheco9xl; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qheco9xl"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a871daa98fso7110585ad.1
        for <linux-cifs@vger.kernel.org>; Thu, 30 Apr 2026 10:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777571322; x=1778176122; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7951eQ/78Es31REawF8+h8DYhmlO7R1alAiqr8CzZJU=;
        b=Qheco9xlqOi6a06wOQTTS2+8a15KwXLDl7LtUdbGnOVwMxP6+6uU6SCj5D8pQoUCiS
         0Z8mZXynnJXNGUXPcMcx+BHOd9Chc/XQuy1Dc41rlTHd7BKvTqCIJrnAm1UctmuNWWGH
         +bKp1SIV8FB2Z/xIKJzWr2kv8dsE7jdO2T98Kiy0WuupNg0LCfLFD+aY7JI3XleeEV44
         p/C4FpsG5WCfjU9Os4flczfzlnggQTCGGSgeuAIn/lT29E6Jl02IpXWAYxhkUkiXtKEc
         +ZTTNaZioGKzw3Hdze8k+FFkDXyKDU4QXlCZ2t4wsyEKIXeTsfNU10o7t43lxhk51T4B
         QRiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777571322; x=1778176122;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7951eQ/78Es31REawF8+h8DYhmlO7R1alAiqr8CzZJU=;
        b=K6LhstxfxBiQRPIm+Vn1vhoqe2BPiUBE5xsQC95w4b1yQebzYsI8FeloxzAY2uUCna
         kfHo0bo3MnjTZOKCfRiJr/EEko4mlFf6eJYJ9sgCRGXnQUmy3LOGSV0BhBKWfpMO9km/
         jDbng6Uc/HWKzPnzsS2d+/tMvwVOwKEl7dIyqjxMo6uzApQAQ7uPaLMf8fZXKe0QTtxU
         gNKtFLGyaBMQJAhKhG/wjhAz3ByWHq3GhcvRWWCErIjx2VqC/8X6mmuXULtPX/v86okM
         EX8/+jJLQXkGdDLbEOsqYliNGUxy1uGnYf16rpEjL3tXKntyQxR+VWFHY1pe1dBFBpk+
         +KKQ==
X-Forwarded-Encrypted: i=1; AFNElJ+nwz0OrXHmn5Gn45Pg22oTx90CxIegE90lscwI8pPKJRknqPtXmSRzB5g7MVv82atYsvMRGk5N8l1p@vger.kernel.org
X-Gm-Message-State: AOJu0YzhgyNbabtVbah/22ap6Zr175v5koxRmJ3nSG1z8at/wnwqd+rI
	YW4BNPDoUclL9+zcutDzfRa63gUsW+3TmzmdrWd7wkSUCbkjd77VQErY
X-Gm-Gg: AeBDievcFf+pR/i7MswYjE9nbgS1rszODN0JRkNk/UaZ00ORgE9ML5mMs/F+kHtVyj0
	W8Vz7yLUy4EPHlY5jLwlJI/BDf2nJXqJvLxL2l2noi4AUFAhcnqhPi6YeEt5rA4iq0Q4OXH6BwC
	YHlFmmceKtjw9zfRWkxkjhWciqNyhATUNN/pU0LZjHH+E1HnQfxbeRntHWGgJy0owyx8u91OMjW
	dUUhjARZUuYn99gvHL61BZx0vcxPu66N3WSECcjMXDWDKZvuR9cvoZHvEMX3y0bXrZ2x1ltxxxr
	kosy2fp8eS+itnCr3eblwle5WfKnsIjTr8vZ7iNbzdOs8t93niwDtgoxBeyoWLUpFk7T06Qta9I
	OO34vcn6e146Ef5+M5eBuZuDJV0bBhSCIrcK9rPzHIsqRo7ov4XIeEsVP6v5+ev1GhOA3gD5Rfd
	cV2taJLxxPARmpGq+zv+uiAgKg2ZhEIDt4voWWOELRz7DfuxT+8g==
X-Received: by 2002:a17:903:24e:b0:2b4:5f69:715d with SMTP id d9443c01a7336-2b9a24b3372mr41032065ad.25.1777571322440;
        Thu, 30 Apr 2026 10:48:42 -0700 (PDT)
Received: from localhost ([49.207.150.30])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caaaec82sm2285365ad.24.2026.04.30.10.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 10:48:42 -0700 (PDT)
From: Piyush Sachdeva <s.piyush1024@gmail.com>
X-Google-Original-From: Piyush Sachdeva <psachdeva@microsoft.com>
Date: Thu, 30 Apr 2026 23:18:23 +0530
Subject: [PATCH v2 1/2] smb: client: Use FullSessionKey for AES-256
 encryption key derivation
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260430-kerbmi-v2-1-0b98fe250425@microsoft.com>
References: <20260430-kerbmi-v2-0-0b98fe250425@microsoft.com>
In-Reply-To: <20260430-kerbmi-v2-0-0b98fe250425@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
 Shyam Prasad N <sprasad@microsoft.com>, 
 Bharath SM <bharathsm@microsoft.com>
Cc: samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
 vaibsharma@microsoft.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5862;
 i=psachdeva@microsoft.com; h=from:subject:message-id;
 bh=0dIn3pRB9mFvWh8+m3Q/ynj13bsM4JgCV1C0hx+Z2lY=;
 b=owGbwMvMwCV29FJ3ncRHDT/G02pJDJmfp75XTU96ckhn35m+L9G/yne8d9hW9S/K9dxZL02ve
 p1Hh+YIdExkYRDjYrAUU2TZcOKOLG/8Lsl5n54YwcxhZQIZIi3SwAAELAx8uYl5pUY6Rnqm2oZ6
 hkY6BjrGDFycAjDVDyQZGfr+nDiu8t3cNfBnsfEM4SqJ5d76Gttj6rWz9jz9wnio8TAjww+1nX8
 4pD6ombV+Un8k8EeD4yfvbRaVVY4/P2/X7LpdzQgA
X-Developer-Key: i=psachdeva@microsoft.com; a=openpgp;
 fpr=80350F71F916134953C3EB979E19C6F9839C3CFC

When Kerberos authentication is used with AES-256 encryption (AES-256-CCM
or AES-256-GCM), the SMB3 encryption and decryption keys must be derived
using the full session key (Session.FullSessionKey) rather than just the
first 16 bytes (Session.SessionKey).

Per MS-SMB2 section 3.2.5.3.1, when Connection.Dialect is "3.1.1" and
Connection.CipherId is AES-256-CCM or AES-256-GCM, Session.FullSessionKey
must be set to the full cryptographic key from the GSS authentication
context. The encryption and decryption key derivation (SMBC2SCipherKey,
SMBS2CCipherKey) must use this FullSessionKey as the KDF input. The
signing key derivation continues to use Session.SessionKey (first 16
bytes) in all cases.

Previously, generate_key() hardcoded SMB2_NTLMV2_SESSKEY_SIZE (16) as the
HMAC-SHA256 key input length for all derivations. When Kerberos with
AES-256 provides a 32-byte session key, the KDF for encryption/decryption
was using only the first 16 bytes, producing keys that did not match the
server's, causing mount failures with sec=krb5 and require_gcm_256=1.

Add a full_key_size parameter to generate_key() and pass the appropriate
size from generate_smb3signingkey():
 - Signing: always SMB2_NTLMV2_SESSKEY_SIZE (16 bytes)
 - Encryption/Decryption: ses->auth_key.len when AES-256, otherwise 16

Also fix cifs_dump_full_key() to report the actual session key length for
AES-256 instead of hardcoded CIFS_SESS_KEY_SIZE, so that userspace tools
like Wireshark receive the correct key for decryption.

Signed-off-by: Piyush Sachdeva <psachdeva@microsoft.com>
Signed-off-by: Piyush Sachdeva <s.piyush1024@gmail.com>
---
 fs/smb/client/ioctl.c         |  2 +-
 fs/smb/client/smb2transport.c | 35 ++++++++++++++++++++++++++---------
 2 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index 9afab3237e54..17408bb8ab65 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -296,7 +296,7 @@ static int cifs_dump_full_key(struct cifs_tcon *tcon, struct smb3_full_key_debug
 		break;
 	case SMB2_ENCRYPTION_AES256_CCM:
 	case SMB2_ENCRYPTION_AES256_GCM:
-		out.session_key_length = CIFS_SESS_KEY_SIZE;
+		out.session_key_length = ses->auth_key.len;
 		out.server_in_key_length = out.server_out_key_length = SMB3_GCM256_CRYPTKEY_SIZE;
 		break;
 	default:
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 41009039b4cb..be421b852246 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -251,7 +251,8 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 }
 
 static void generate_key(struct cifs_ses *ses, struct kvec label,
-			 struct kvec context, __u8 *key, unsigned int key_size)
+			 struct kvec context, __u8 *key, unsigned int key_size,
+			 unsigned int full_key_size)
 {
 	unsigned char zero = 0x0;
 	__u8 i[4] = {0, 0, 0, 1};
@@ -265,7 +266,7 @@ static void generate_key(struct cifs_ses *ses, struct kvec label,
 	memset(key, 0x0, key_size);
 
 	hmac_sha256_init_usingrawkey(&hmac_ctx, ses->auth_key.response,
-				     SMB2_NTLMV2_SESSKEY_SIZE);
+				     full_key_size);
 	hmac_sha256_update(&hmac_ctx, i, 4);
 	hmac_sha256_update(&hmac_ctx, label.iov_base, label.iov_len);
 	hmac_sha256_update(&hmac_ctx, &zero, 1);
@@ -298,6 +299,7 @@ generate_smb3signingkey(struct cifs_ses *ses,
 			struct TCP_Server_Info *server,
 			const struct derivation_triplet *ptriplet)
 {
+	unsigned int full_key_size = SMB2_NTLMV2_SESSKEY_SIZE;
 	bool is_binding = false;
 	int chan_index = 0;
 
@@ -330,12 +332,24 @@ generate_smb3signingkey(struct cifs_ses *ses,
 	if (is_binding) {
 		generate_key(ses, ptriplet->signing.label,
 			     ptriplet->signing.context,
-			     ses->chans[chan_index].signkey,
-			     SMB3_SIGN_KEY_SIZE);
+			     ses->chans[chan_index].signkey, SMB3_SIGN_KEY_SIZE,
+			     SMB2_NTLMV2_SESSKEY_SIZE);
 	} else {
 		generate_key(ses, ptriplet->signing.label,
-			     ptriplet->signing.context,
-			     ses->smb3signingkey, SMB3_SIGN_KEY_SIZE);
+			     ptriplet->signing.context, ses->smb3signingkey,
+			     SMB3_SIGN_KEY_SIZE, SMB2_NTLMV2_SESSKEY_SIZE);
+
+		/*
+		 * Per MS-SMB2 3.2.5.3.1, signing key always uses Session.SessionKey
+		 * (first 16 bytes). Encryption/decryption keys use
+		 * Session.FullSessionKey when dialect is 3.1.1 and cipher is
+		 * AES-256-CCM or AES-256-GCM, otherwise Session.SessionKey.
+		 */
+
+		if (server->dialect == SMB311_PROT_ID &&
+		    (server->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
+		     server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
+			full_key_size = ses->auth_key.len;
 
 		/* safe to access primary channel, since it will never go away */
 		spin_lock(&ses->chan_lock);
@@ -345,10 +359,13 @@ generate_smb3signingkey(struct cifs_ses *ses,
 
 		generate_key(ses, ptriplet->encryption.label,
 			     ptriplet->encryption.context,
-			     ses->smb3encryptionkey, SMB3_ENC_DEC_KEY_SIZE);
+			     ses->smb3encryptionkey, SMB3_ENC_DEC_KEY_SIZE,
+			     full_key_size);
+
 		generate_key(ses, ptriplet->decryption.label,
 			     ptriplet->decryption.context,
-			     ses->smb3decryptionkey, SMB3_ENC_DEC_KEY_SIZE);
+			     ses->smb3decryptionkey, SMB3_ENC_DEC_KEY_SIZE,
+			     full_key_size);
 	}
 
 #ifdef CONFIG_CIFS_DEBUG_DUMP_KEYS
@@ -361,7 +378,7 @@ generate_smb3signingkey(struct cifs_ses *ses,
 			&ses->Suid);
 	cifs_dbg(VFS, "Cipher type   %d\n", server->cipher_type);
 	cifs_dbg(VFS, "Session Key   %*ph\n",
-		 SMB2_NTLMV2_SESSKEY_SIZE, ses->auth_key.response);
+		 ses->auth_key.len, ses->auth_key.response);
 	cifs_dbg(VFS, "Signing Key   %*ph\n",
 		 SMB3_SIGN_KEY_SIZE, ses->smb3signingkey);
 	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||

-- 
2.53.0

