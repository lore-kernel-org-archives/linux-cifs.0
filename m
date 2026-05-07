Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB9445107D
	for <linux-cifs@vger.kernel.org>; Thu,  7 May 2026 16:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778172751; cv=none; b=MJa31x/g8VxxfVU9e+o6xF5PH+51BQr67z34CwkWvarD2cKmZjoFBoSlDmyKRXTyiFmoyedN7+UlUzIcsP5sNCtlePuATqDXBdWoEdm9UZH4gVHBVFF94OUncd9QXsZdQh/8Xs3c+nCA9L8yuLYDFLaWoaZyUNMRt/PKlVKNNF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778172751; c=relaxed/simple;
	bh=aHoBqTbdr56DO71Zlzzaandq5SHQ8sCJYyYln2KmSW0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kBza/eFvWzCHmzRas/uuNOsTqyCR6JMBM/515hwuTfVu6BtZ3PVvVGKu6I2b6jPmmZ+HMRrFw+uicL2GNrttrpNZ0KlTSS7vfP60oVdeIvpCgw3VFRyID21vMSGQpFDMUjfPvOgkT4AHdSx8UFQRIZ+HjK7Ff33JGEtntqyCyas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hLOKaJ2P; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hLOKaJ2P"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2b9ea536877so8108735ad.1
        for <linux-cifs@vger.kernel.org>; Thu, 07 May 2026 09:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778172749; x=1778777549; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yv2fHWPI4GY7ycdmc2I4lTP92YQsllQ8O6sfU4iOItg=;
        b=hLOKaJ2PpTO1yTKqpMknJRZzPhXHNq7xaXp8V5BnrxFTCvd0QcDK0DZAgm9VzK5bTT
         Bux/AzMC2D7MJSLwhzTFDYnZc/PcFfAPrt8RjuB79Xlff9UFigczDKCeflfeCkGTz2G7
         HABg0Kz931SdXv4whao41c0gDBwe/KKq6Y93up4S8hhGD6St0cVinpDlhAcwwesiCqFs
         Z31FaqJ6koWowukjj/sUlfYD1qGPef56yjJbpvWTC/ZDLJf7Or6GBkk1inCS5dXXNvHH
         TEnPVgXz9V6ixzjwa7SYJTbCt+ZIiVAH4LzRzP2VOMF76lXLsF0xCUxlnpIInpu0Rg1C
         y0zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778172749; x=1778777549;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yv2fHWPI4GY7ycdmc2I4lTP92YQsllQ8O6sfU4iOItg=;
        b=egeyOouhCSAlAosQ1ENvkbkhFbfgvqh14rJJ20lOvLQciLMUm0+/EwbPMoR3L2tn3f
         iu0GI+pHSn0ecqHl6Co/2KMH6H28EibsK7DTXLhCL3rkg7kOsoEnT9TaZFk7aRCero5j
         lDn848QdVlxBjJqEwUi/NkqydO8Jpc2TvtP8a/qd7nJyaSdsT5Jt3wPbSlLr4Q930vAF
         0KURvOLQU/5sekmtcGEElzg+PX0E9rgpXhNpkPlQWUwJDLdoNsi7GlK0ElZE29uVVIHc
         oyv9W8IGNbVQtWj0g9Q5fu2+9EYsonin0hjXAPcaw9xs39UjHGIHkGJaRIXmu7HFTH4t
         Ac8A==
X-Forwarded-Encrypted: i=1; AFNElJ8ZExb3cs20TTOZAJG9+3zbNIRl7Bn4qN9Nhoqmowy3GkzLMivkJqFdCFO1CQ2DO8/9FstgVEGeujU4@vger.kernel.org
X-Gm-Message-State: AOJu0YyWGuBqGKdjAMw1Cux/TqI4xDLVNpb1PLdp7Fga1I0We9BzBv0N
	ONVe6DsK+J25vIIIifU04nlBmGHjKPQCJO/ltxCoHZZ84RchBabHFETV
X-Gm-Gg: Acq92OEPCN9Zoig8lPXd67rMNV7QVPuklAPrpl102XhBG9sKmxB1s35S6HTfPlkhggS
	nil10RMZt6RyAWIFA5lXJtSjhsP2yFubHKZzXLG8aqKmlEvmDx7sUZkNm75sVKMu9L6Mw79/LMX
	e+CfESNqG42spzPNYdDVrWLfwyAQc95NU5X088w8y3GCzUjlAOb8fGnblsEUfhS1I0g2WskKA1r
	m4eXgRljpdE3Y80OBxEeqxB9iqYsL0g18VVfAXqiU+ukfHpEenyke9QKUqM0ZH8cwMlMcbvJtqp
	9PIfpWdu/CiiHd6JUXkT+nJTeQSGvHqH5ldWLPT/18yL24xr1P1HcJDSiAePJMmXNHb8BpoWggJ
	cKPL9Nn2GoOp0gTcm9XwYk36P6MR/NV22qF1YZBcaD0JVuoWSL3W0DVev5qM59sHJJ6dqzXnV+j
	DdbW0veb5K7eKZXl2/ou0DQshvBxrjcHXSNWoTZvs=
X-Received: by 2002:a17:903:4b03:b0:2ba:21c2:d6cb with SMTP id d9443c01a7336-2babd4bdb6dmr31502595ad.16.1778172749225;
        Thu, 07 May 2026 09:52:29 -0700 (PDT)
Received: from localhost ([49.207.150.30])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bae783dc50sm2551575ad.43.2026.05.07.09.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 09:52:28 -0700 (PDT)
From: Piyush Sachdeva <s.piyush1024@gmail.com>
X-Google-Original-From: Piyush Sachdeva <psachdeva@microsoft.com>
Date: Thu, 07 May 2026 22:22:14 +0530
Subject: [PATCH v3 2/2] smb: client: Zero-pad short GSS session keys per
 MS-SMB2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-kerbmi-v3-2-397ebbb53eff@microsoft.com>
References: <20260507-kerbmi-v3-0-397ebbb53eff@microsoft.com>
In-Reply-To: <20260507-kerbmi-v3-0-397ebbb53eff@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
 Shyam Prasad N <sprasad@microsoft.com>, 
 Bharath SM <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.org>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Tom Talpey <tom@talpey.com>
Cc: samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, vaibsharma@microsoft.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3414;
 i=psachdeva@microsoft.com; h=from:subject:message-id;
 bh=aHoBqTbdr56DO71Zlzzaandq5SHQ8sCJYyYln2KmSW0=;
 b=owGbwMvMwCV29FJ3ncRHDT/G02pJDJl/Djv5n01fPnF6wi83E+7DM3gmtQm4HoiepBY1uZTl8
 JPUFofrHRNZGMS4GCzFFFk2nLgjyxu/S3LepydGMHNYmUCGSIs0MAABCwNfbmJeqZGOkZ6ptqGe
 oZGOgY4xAxenAEz1rmhGhl3Z+fqduVN3PKrUWPizViSXMyR50q3G2+V9rS87JQqKuRkZDv53CLH
 Zq7rpwDS+S/4HPjx+HeCpof6Laa5EUNHBg5X5TAA=
X-Developer-Key: i=psachdeva@microsoft.com; a=openpgp;
 fpr=80350F71F916134953C3EB979E19C6F9839C3CFC

Per MS-SMB2 section 3.2.5.3, Session.SessionKey is the first 16 bytes
of the GSS cryptographic key, right-padded with zero bytes if the key
is shorter than 16 bytes.

SMB2_auth_kerberos() copies the GSS session key from the cifs.upcall
response using kmemdup(msg->data, msg->sesskey_len, ...) and stores
the GSS-reported length verbatim in ses->auth_key.len. generate_key()
reads SMB2_NTLMV2_SESSKEY_SIZE bytes from this buffer when feeding the
HMAC-SHA256 KDF for signing key derivation. If a GSS mechanism returns
a session key shorter than 16 bytes (e.g. a deprecated single-DES
Kerberos enctype with an 8-byte session key), the KDF call performs an
out-of-bounds slab read and derives keys that do not match the server,
which pads per the spec.

Modern KDCs disable short-key enctypes by default, so this is latent
rather than reachable in production, but it is still a kernel heap
over-read.

Allocate auth_key.response with kzalloc() at a length of
max(msg->sesskey_len, SMB2_NTLMV2_SESSKEY_SIZE), copy the GSS key in,
and rely on kzalloc()'s zero initialization for the spec-mandated
padding. Set ses->auth_key.len to the padded length. Larger GSS keys
(e.g. the 32-byte aes256-cts-hmac-sha1-96 session key) continue to be
stored at their natural length, preserving the FullSessionKey path.

Emit a cifs_dbg(VFS, ...) message when a short key is encountered to
surface deprecated-enctype usage.

NTLMv2 and NTLMSSP code paths produce a 16-byte session key by
construction and are unaffected.

Signed-off-by: Piyush Sachdeva <psachdeva@microsoft.com>
Signed-off-by: Piyush Sachdeva <s.piyush1024@gmail.com>
---
 fs/smb/client/smb2pdu.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index cb61051f9af3..995fcdd30681 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1713,17 +1713,30 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 	is_binding = (ses->ses_status == SES_GOOD);
 	spin_unlock(&ses->ses_lock);
 
+	/*
+	 * Per MS-SMB2 3.2.5.3, Session.SessionKey is the first 16 bytes of the
+	 * GSS cryptographic key, right-padded with zero bytes if shorter.
+	 * Allocate at least SMB2_NTLMV2_SESSKEY_SIZE bytes (zeroed) so the KDF
+	 * input buffer is always valid for HMAC-SHA256 even with deprecated
+	 * Kerberos enctypes that return a short session key.
+	 */
+	if (unlikely(msg->sesskey_len < SMB2_NTLMV2_SESSKEY_SIZE))
+		cifs_dbg(VFS,
+			 "short GSS session key (%u bytes); zero-padding per MS-SMB2 3.2.5.3\n",
+			 msg->sesskey_len);
+
 	kfree_sensitive(ses->auth_key.response);
-	ses->auth_key.response = kmemdup(msg->data,
-					 msg->sesskey_len,
-					 GFP_KERNEL);
+	ses->auth_key.len = max_t(unsigned int, msg->sesskey_len,
+				  SMB2_NTLMV2_SESSKEY_SIZE);
+	ses->auth_key.response = kzalloc(ses->auth_key.len, GFP_KERNEL);
 	if (!ses->auth_key.response) {
 		cifs_dbg(VFS, "%s: can't allocate (%u bytes) memory\n",
-			 __func__, msg->sesskey_len);
+			 __func__, ses->auth_key.len);
+		ses->auth_key.len = 0;
 		rc = -ENOMEM;
 		goto out_put_spnego_key;
 	}
-	ses->auth_key.len = msg->sesskey_len;
+	memcpy(ses->auth_key.response, msg->data, msg->sesskey_len);
 
 	sess_data->iov[1].iov_base = msg->data + msg->sesskey_len;
 	sess_data->iov[1].iov_len = msg->secblob_len;

-- 
2.53.0

