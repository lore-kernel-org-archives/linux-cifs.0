Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77703DEAD0
	for <linux-cifs@vger.kernel.org>; Thu,  9 Apr 2026 16:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775751368; cv=none; b=mRN64jxYion1iam+4GL3MT1EGiI0s3xeG/I2xRVT00jE4U+jCk8wppgBUT9yJ7svWb9jFNmBt1m7pvXpPd2TlDca1DWlTFfIzMPU2VxXulIh0RVW5rsiC2bU1AIDWjk0pQJtkeV0iFAPunRfG7l1r8IAaFqPq7T1fYQxFGxdeSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775751368; c=relaxed/simple;
	bh=Hu9T+FLiNPkkFUO5IdCVNWDzsGDI4Mfr231GXxbmBYs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PdGlIuYLUgb0Q5nxgfltXh34fJNGSHg/WSGiM5UfEYMVTV0hyl60vrZnKKtupCTdKi/cQL3FTEw69oJDmznY177QABE0ZNtqDPqHUCkO3ufU1BbMemHwDL9kL17LHrQXW0pgIxPe6X0+w/TTQGJzX2QiV/DFBmyibWbbBOvdcGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cGB2vIqG; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cGB2vIqG"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c70c112cb61so721152a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 09 Apr 2026 09:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775751365; x=1776356165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q79DNyAnlCXZAwn0OoLPtqbdLttcixAaHmbbuH/DNfE=;
        b=cGB2vIqGReV1GhdyrSP9WgXPxOp+qnA3Sm2zy2oGUnzpwc1/NgSkvKY9Ny2TTqQ2nK
         voyym1w4Tu1nvk3SyEE/baSLD3Z8cZuOJ9NoiMk6or0wRQ06h3WOKausvEAKjBiKEbaF
         HDIzoj3mWrws0iKljiBGWKmgh/9YtGx+XM3C0HkQhiwJo5rkNvQH0AgO2KH8E1/H7fcw
         ItRNs9tphyeT822Qlw5u47/NdypqTX61bsOj5nZ+Jl4yxj18UMYPMzVkZmeD4lit8Ocv
         HGYdaE0BB5yBMDliyE7yaLnfuxRSsKIePi+ACpmfM89mrfDSxc2APWzbXtE/YzsxkEg+
         WTfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775751365; x=1776356165;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q79DNyAnlCXZAwn0OoLPtqbdLttcixAaHmbbuH/DNfE=;
        b=YoWVuuCaHZmFULj0pF/Yd7cOy9K9rcj1BTqH8UReU97+14sLmg7bQAkCMY7ytvdsfV
         9t+SWvbe2w6CTpwj/dCJQucN8AQNDv7rDNm2HAjXNZ8Q3FgQ/L1Nufi5Lv4hy7GgJsef
         zr73MjzlrQsPBGTeRwyTCysXBTx3Fcw2ne/U9ZWV86w2Otu5zdiDHAhR2ElRLge9ceSE
         4hOAtT/jWthY9tl2IquwojQr47mPmIrd0kK8L5J0LJ89lfJXZT+HiBTwzklJZiGtwZ14
         n5hMNkYf+YX0GBntxOBYxavv0BHtIVj/ct2JSxw0+WWWsr2E6/Uyerr4gYaT6kxh9s5e
         c12g==
X-Forwarded-Encrypted: i=1; AJvYcCUyYAqoJRqzIQUCsycihCh+ZkAsJZTcwvm4NZO1SQWks+oGLdge3LEcDs7ks/t0wEHbpbCJt+Cv6tKA@vger.kernel.org
X-Gm-Message-State: AOJu0YzRmLzR6SeS8nnDjoJ8FHYKLvLXUdA3CSFPppFNbuVwxm90FHp/
	hdWh43ZMQu0eM+9DFWKSIruhrc7oMzdmTq0nWFYMhnUcv0h/C+tCdpc4
X-Gm-Gg: AeBDiesd1p4jr80K/O3Mmw/x11Pj+3cjXoETLWFABPh1upq7pjx5GgqBFvLaqxJiLD/
	27DtYQNQGK0NFDZWXj8XPc9+TYP58vfkA4/Iq9hIK6YBUH7xDNlwVz22PMM2Mh0XcsItVhiWJFm
	1qpBusM6kqgWIeQgyEaGokgjWQ+q0GsmOPMYHu8nA+nDnlkknjFjRxY7yrGysCOMvZ3+qLXwiEd
	ThPP7DSsKxywlOeMLlQxqkn2yaD0ZkLpFlWb0ytcjnQ6scv1tyhrFq0ayoJLF5wwAVFANhOE0zM
	//Dfz3QsBbn+Zv+e0EI7M19LjvFp85Xk1RQjhQ7HyDEGyS2iHauFySyItPrBH6Pv5B/0qNUSNj1
	0rY36KZNCVLkS8/QvwiLyd884QtUvdwL8ZYatjoWwuIXS+UEcsdxmULSaPkr8f6M9FHD/rNbvZn
	S3hfIRoV1Hj+/pqOjUh2Ryvu1uOi//DGhdvhHel0k=
X-Received: by 2002:a05:6a20:158c:b0:398:a1ca:7a22 with SMTP id adf61e73a8af0-39f2f11afa7mr27980929637.54.1775751364647;
        Thu, 09 Apr 2026 09:16:04 -0700 (PDT)
Received: from localhost ([49.207.153.169])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76cffd9611sm19263937a12.17.2026.04.09.09.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 09:16:04 -0700 (PDT)
From: s.piyush1024@gmail.com
To: sfrench@samba.org,
	linux-cifs@vger.kernel.org
Cc: sprasad@microsoft.com,
	bharathsm@microsoft.com,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] smb: client: use FullSessionKey for AES-256 encryption key derivation
Date: Thu,  9 Apr 2026 21:45:32 +0530
Message-ID: <20260409161538.3618-1-s.piyush1024@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Piyush Sachdeva <psachdeva@microsoft.com>

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

Add a `full_key_size` parameter to generate_key() and pass the appropriate
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
 fs/smb/client/smb2transport.c | 32 +++++++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 8 deletions(-)

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
index 81be2b226e26..57e515774b97 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -259,7 +259,8 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 }
 
 static int generate_key(struct cifs_ses *ses, struct kvec label,
-			struct kvec context, __u8 *key, unsigned int key_size)
+			struct kvec context, __u8 *key, unsigned int key_size,
+			unsigned int full_key_size)
 {
 	unsigned char zero = 0x0;
 	__u8 i[4] = {0, 0, 0, 1};
@@ -280,7 +281,7 @@ static int generate_key(struct cifs_ses *ses, struct kvec label,
 	}
 
 	hmac_sha256_init_usingrawkey(&hmac_ctx, ses->auth_key.response,
-				     SMB2_NTLMV2_SESSKEY_SIZE);
+				     full_key_size);
 	hmac_sha256_update(&hmac_ctx, i, 4);
 	hmac_sha256_update(&hmac_ctx, label.iov_base, label.iov_len);
 	hmac_sha256_update(&hmac_ctx, &zero, 1);
@@ -315,6 +316,7 @@ generate_smb3signingkey(struct cifs_ses *ses,
 			const struct derivation_triplet *ptriplet)
 {
 	int rc;
+	unsigned int full_key_size;
 	bool is_binding = false;
 	int chan_index = 0;
 
@@ -344,18 +346,32 @@ generate_smb3signingkey(struct cifs_ses *ses,
 	 * master connection signing key stored in the session
 	 */
 
+	/*
+	 * Per MS-SMB2 3.2.5.3.1, signing key always uses Session.SessionKey
+	 * (first 16 bytes). Encryption/decryption keys use
+	 * Session.FullSessionKey when dialect is 3.1.1 and cipher is
+	 * AES-256-CCM or AES-256-GCM, otherwise Session.SessionKey.
+	 */
 	if (is_binding) {
 		rc = generate_key(ses, ptriplet->signing.label,
 				  ptriplet->signing.context,
 				  ses->chans[chan_index].signkey,
-				  SMB3_SIGN_KEY_SIZE);
+				  SMB3_SIGN_KEY_SIZE,
+				  SMB2_NTLMV2_SESSKEY_SIZE);
 		if (rc)
 			return rc;
 	} else {
+		if (server->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
+		    server->cipher_type == SMB2_ENCRYPTION_AES256_GCM)
+			full_key_size = ses->auth_key.len;
+		else
+			full_key_size = SMB2_NTLMV2_SESSKEY_SIZE;
+
 		rc = generate_key(ses, ptriplet->signing.label,
 				  ptriplet->signing.context,
 				  ses->smb3signingkey,
-				  SMB3_SIGN_KEY_SIZE);
+				  SMB3_SIGN_KEY_SIZE,
+				  SMB2_NTLMV2_SESSKEY_SIZE);
 		if (rc)
 			return rc;
 
@@ -368,13 +384,15 @@ generate_smb3signingkey(struct cifs_ses *ses,
 		rc = generate_key(ses, ptriplet->encryption.label,
 				  ptriplet->encryption.context,
 				  ses->smb3encryptionkey,
-				  SMB3_ENC_DEC_KEY_SIZE);
+				  SMB3_ENC_DEC_KEY_SIZE,
+				  full_key_size);
 		if (rc)
 			return rc;
 		rc = generate_key(ses, ptriplet->decryption.label,
 				  ptriplet->decryption.context,
 				  ses->smb3decryptionkey,
-				  SMB3_ENC_DEC_KEY_SIZE);
+				  SMB3_ENC_DEC_KEY_SIZE,
+				  full_key_size);
 		if (rc)
 			return rc;
 	}
@@ -389,7 +407,7 @@ generate_smb3signingkey(struct cifs_ses *ses,
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

