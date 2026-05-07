Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5837450902
	for <linux-cifs@vger.kernel.org>; Thu,  7 May 2026 16:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778172748; cv=none; b=JAdE3FURJWyLO5XCm/8Qef4mQEsr6quOrTOd71/DpQsX+ikMsDen52hQqF8BHPGHMJCddk2QFvpyk74resuIi917Ttqp08ZsG7Ec+w1P/L5dfq8Vy80zGUzULdrGLPve5mm/Lfr1k1XbiNtzuVZFifjl9J7HegVjuPOkqkdL0vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778172748; c=relaxed/simple;
	bh=DdOVwLG2B9Yti8eNvYwLrdHQJdkwU6BVOBbX5pMKj0A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uX4R6B3Whk8YnGywrO6C0Vta462AxH0xpr6VFQVUbaxmpeF7UneDmoFzNhAgyMZT4IyZgzTPB5/9UqPCsq6vXHJHmAUp3llKGCqzDY5XykvV0pBKalN1ORVdpCoPD24qIEedZe0DaL/aFO8SESGlwUQ+0F5Ss46YJVvgd6abZF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C/yqvwly; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C/yqvwly"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c8016d642b2so1019272a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 07 May 2026 09:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778172746; x=1778777546; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PnAzLRshVO8669/2ZpelErGyYsskkVJKiCCMm0uTTjI=;
        b=C/yqvwly8knSKxhx72eYT2NFAJHrgy/rjQ3aYgm2VMcbeU8uhkt1GBbdM+C7Eov5Cz
         h81vaLu2zpqJymv43IJFW/ZySfjBGdaGApVmow+ZUyCo6O2XRbn1CRPKqQj4+MtxClcy
         0Zh2o+w30TJ24/jJLRlZ8+ttKJANLiAAhB9N4qe/ogqchy4M28UUzH+QbeTzIAUqdXxR
         kifbiVCfxy+gMgGrdK5Fn9KUeKtCiCPvSCtuaDV5vXUtPfMpvrwqm/u9cX6qqUFXAqKN
         EZdsEPJxg8Iq+hJY5Lk/Fmr0IHWCZe/qEyw7VnKjAsm/X6rDipGQn7no8jruLsnsP9p/
         /txg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778172746; x=1778777546;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PnAzLRshVO8669/2ZpelErGyYsskkVJKiCCMm0uTTjI=;
        b=XLwIPM+rmCGV7BVH7mNXQFy6Zgl0KoFMBYx8ZFAVf55EdFVg/7y2gz5zFmiyoHcPJ4
         Wec+ZDgZUmKXaBWrflcqQaqxmThbfxvQKFS4cuauII7QNHVOqvSm2MHV32/45A2XGZvR
         PR4KZmWy6QCdLd2iP+EIPLZQXpY1VdCvdLfrEobKFHuSUVIDqKO5iiy/MY406SV6tJ1+
         IxgN7+5+JF/GpPyIPNle16i6U05lgN2ZAts/+syjJKtiu0AElumNQW+lczq084LJ9Qaf
         e7+yzTGmZRR/XNRB2RtpEcK0AshC3k1BJItTVEKy08o3LQQvRtj9yrwTNkHyTN2yxf6X
         gwGw==
X-Forwarded-Encrypted: i=1; AFNElJ/uQQ/TeuoowY25PeCNKXUXgv3WZS59his/l/uSPRQFCHXe+7p722qhE04T7HTSgvMstDwm4KEWqulV@vger.kernel.org
X-Gm-Message-State: AOJu0YynKTxeqRUR7Eyncfz3zEdCGIChj6PdXXfk8Nz/03SKghHjN5xW
	l2NnXwwuNvkjZaOF41A2ZlOdMGSAlSvp/RdErJSS104pY/lrbUrxVKaA
X-Gm-Gg: AeBDietiXQqpdStSCs8aSMeKTXTmFU4zfJ8fNdwP385NnuWPtJVh5L6ThLa7GOvNzQ3
	0plR+Foj77n9E0IYyC+DFqAVkgOYRCYjn33KKYBBLPpuHZFIEkS0Et7grkY96ygofcHPJWsYQmr
	7JtHG4PWJSdXlsb8z2t7F1nNd8Rvebw788O5lSyTuyl661h2ECNgMxbdCIsN9x8McBZnbOvMSe4
	lDC4++o+l1dFYx8EnfRaprboA2WOd4JIxlgokBJ193QrAm8PSXEPrPo4jzT1eJ9PYMtlyWwoybW
	nYMQjrM790cJ7ewTwLLtMN3+vndD9Siu5+kBvOoIKy8RqCxbXc/eudYgQtVkEUhguxhrY4swWFx
	W/+VWzXPKzPHHAAnVfhLYRf6XnFGWKfcTk7eDKSv2m+5cjmFg8gv5UWbvVX5P89mh9xoiwCsZdi
	XLI3Hop+nq8lNkhH6h36uUY6hPdvU6nTyU5/Fgh7s=
X-Received: by 2002:a05:6a20:3c8d:b0:39c:4e62:b843 with SMTP id adf61e73a8af0-3aa8beb3559mr3589422637.10.1778172745848;
        Thu, 07 May 2026 09:52:25 -0700 (PDT)
Received: from localhost ([49.207.150.30])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82640aeeaesm104310a12.18.2026.05.07.09.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 09:52:25 -0700 (PDT)
From: Piyush Sachdeva <s.piyush1024@gmail.com>
X-Google-Original-From: Piyush Sachdeva <psachdeva@microsoft.com>
Date: Thu, 07 May 2026 22:22:13 +0530
Subject: [PATCH v3 1/2] smb: client: Use FullSessionKey for AES-256
 encryption key derivation
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-kerbmi-v3-1-397ebbb53eff@microsoft.com>
References: <20260507-kerbmi-v3-0-397ebbb53eff@microsoft.com>
In-Reply-To: <20260507-kerbmi-v3-0-397ebbb53eff@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
 Shyam Prasad N <sprasad@microsoft.com>, 
 Bharath SM <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.org>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Tom Talpey <tom@talpey.com>
Cc: samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, vaibsharma@microsoft.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5867;
 i=psachdeva@microsoft.com; h=from:subject:message-id;
 bh=DdOVwLG2B9Yti8eNvYwLrdHQJdkwU6BVOBbX5pMKj0A=;
 b=owGbwMvMwCV29FJ3ncRHDT/G02pJDJl/DjvW+i8WV/y35ffMvOw98x7ZVYXOeqxzQPfJ/OuN1
 /y/T+sL7ZjIwiDGxWAppsiy4cQdWd74XZLzPj0xgpnDygQyRFqkgQEIWBj4chPzSo10jPRMtQ31
 DI10DHSMGbg4BWCq1ZMY/ulXszpHKOYa/NrL2sGc8LCQ70B1S/rqbEHbMhnBszKxxxj+Cqzb4xg
 W+aR4wYEFLpfSXaW9p8/IjTxaysyzRLz0b6sOEwA=
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
index 41009039b4cb..e8eeff9e50d6 100644
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
+		 (int)ses->auth_key.len, ses->auth_key.response);
 	cifs_dbg(VFS, "Signing Key   %*ph\n",
 		 SMB3_SIGN_KEY_SIZE, ses->smb3signingkey);
 	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||

-- 
2.53.0

