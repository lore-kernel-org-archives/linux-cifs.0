Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7834477E3F
	for <linux-cifs@vger.kernel.org>; Thu, 30 Apr 2026 17:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777571328; cv=none; b=DSiLVBw8j13pbOBwumPIFLePL2s1TBc220m9wZXPj88FOyfR9Jxkzx4xvw/GcM7WEZ+w1GiRJRyDnRJ3xlWgRKFEOU2Txvm3HCME4PEk9amaZRT7mPggpC+LetIDJ6m2a4Ql4OTnkG6tYUEMsJ2YDLU/i4QGXxf9U9R0H5ZYz9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777571328; c=relaxed/simple;
	bh=aHoBqTbdr56DO71Zlzzaandq5SHQ8sCJYyYln2KmSW0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XpKy9VHW2RJw+IaoC8nVhxdfkgbef6Ywe13YPTn5Z5sT9dztJu6QESmnh44fo5hQwGOU/oHXW72/gX2vT3QXIywEmOfXNITz7Ld8+YcmqftK2xSRxD6v77Nix7LtStn1SUxFNVn0kDPGe/UBJwRS+7+QkmrQ75iRYccXUkVyqpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ajX4S1oZ; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ajX4S1oZ"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c648bc907ebso766833a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 30 Apr 2026 10:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777571327; x=1778176127; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yv2fHWPI4GY7ycdmc2I4lTP92YQsllQ8O6sfU4iOItg=;
        b=ajX4S1oZV31iH1kiV4kkA4B8RGAnF0rE6h+o3ciGBmAmWHhXiALgOGjPIfoVvsb7KJ
         B4e1dTmZTG49CTBcC9tMZRSQo5mrLHP0HHg5dIKK51U/El0WNCOlen2W7kcyrGwpnWsf
         33X/IY/A7G+/SRAs94fF2TxkEaN0BoIaXS6kFLvqlEeNR5MyxWCI8DBgYTqpZyNGT/Rj
         bMHgwqrk0xN5sjG40YdopSfGl/oiAarzBqa7pvQQkU9DoIFFyeTwsDQ5UfNu66fD+4Gq
         ynhuV/xDESNNqF0O30319g/RTobqFtkPh7/oMoUvGmDdBz3IM5ZaAAYdSNivaQNH8NDT
         +8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777571327; x=1778176127;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yv2fHWPI4GY7ycdmc2I4lTP92YQsllQ8O6sfU4iOItg=;
        b=rZeiDib+YgFBnL6Of1HEe6ZzFs1N8VSprDBKlzoyBvhHCFq3Rlh9KIOwjSEl0wPksp
         mu6ptE+HdsjYAUy4yODiZy7zrwYu6hvk4AKbsUNTy1nQXAV5GssO69n3ThjqvsaSPxpS
         mHSUwvvs0rA4/0aYsZ30Y4mu9etu7Yf+ZjE7yva1jtyt6sCR5p25KgpKnMFGubRfEPmB
         pLDyWarwpUXwEyunKXJWQ28CIEVH/nQ7rv7bByO2TJLtRdb58RvgGe2uGS0qrJvbjy1c
         THAUD07ARzOZChUq7tvqNMFP1bD0ne4L7x5H6VSH8Bc56bXtKbp1elJj8H58MkuVb9xC
         Bbxg==
X-Forwarded-Encrypted: i=1; AFNElJ9WhhVtROL4T7BI62vcKL7+RGHxr/lz4UIt4hQLK1xpV3BOa/CTIlycGw+1SI3eDOtbLQNe4Ulr9lpF@vger.kernel.org
X-Gm-Message-State: AOJu0YxuDj291EM8lUQ6r866MpWKfWtpKbehTQ+QLMf7r86n76t7TgD4
	1lBkbupUWakUdLu+tyogL65D5dgSmigYBlt62elYPQUpceGdxgEibeMA
X-Gm-Gg: AeBDieuTiQGh1GErH9zpsUqk54Q8/VU7p21S5XTvri+7rrNvpBID5aNeYTP///Em9uT
	eBoD+qPH/NO0bomN53EXoxWLec/FHeCV7La4NxJgalJGxIC2nAMuIT/88TWTiG5SA2My9ubCp9G
	23cKTEpK0brbEBnZISKlF7JWn1klxfCjCd/GWtkJJX4CfIlzKXduBZXj0maYj4iRD4Ayc5Lzjln
	oN981q223FmZiF32fEDRudAS66de+a1OHptkuVnxeR6pIbjwk9PrhgPdVEXKO2CIefpZr5NG8RQ
	UhXk7mCensNtpMPILxw1oTNgqJsECWw5ET4uaxuDvqP+OCzLZSHFgKOsOcoq2pMeJs3DXQyBFHV
	mp/1zDHcXthLY5iKErBzFrbDEoLLQ2M+7wH30Kl/zLAJGxIV5z9S3ZSLHyMezxCQi78IJNKH9wR
	3lregcxYuFamb2uNlB0lr2E4dLPYeVQ7pfMCp0j9bkg1Gy8iIXMMFAUDbRr5Zh
X-Received: by 2002:a05:6a00:909d:b0:81f:5037:a317 with SMTP id d2e1a72fcca58-834fdb1345emr4334423b3a.11.1777571326639;
        Thu, 30 Apr 2026 10:48:46 -0700 (PDT)
Received: from localhost ([49.207.150.30])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351582e185sm278771b3a.3.2026.04.30.10.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 10:48:46 -0700 (PDT)
From: Piyush Sachdeva <s.piyush1024@gmail.com>
X-Google-Original-From: Piyush Sachdeva <psachdeva@microsoft.com>
Date: Thu, 30 Apr 2026 23:18:24 +0530
Subject: [PATCH v2 2/2] smb: client: Zero-pad short GSS session keys per
 MS-SMB2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260430-kerbmi-v2-2-0b98fe250425@microsoft.com>
References: <20260430-kerbmi-v2-0-0b98fe250425@microsoft.com>
In-Reply-To: <20260430-kerbmi-v2-0-0b98fe250425@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
 Shyam Prasad N <sprasad@microsoft.com>, 
 Bharath SM <bharathsm@microsoft.com>
Cc: samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
 vaibsharma@microsoft.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3414;
 i=psachdeva@microsoft.com; h=from:subject:message-id;
 bh=aHoBqTbdr56DO71Zlzzaandq5SHQ8sCJYyYln2KmSW0=;
 b=owGbwMvMwCV29FJ3ncRHDT/G02pJDJmfp36Y1SsyOXPuWc+60JDNV/zit7Tq/pv3nulpyY+Li
 Y/fX9es7JjIwiDGxWAppsiy4cQdWd74XZLzPj0xgpnDygQyRFqkgQEIWBj4chPzSo10jPRMtQ31
 DI10DHSMGbg4BWCqk70YGS7MWcO/smkdz+xDRxMlFA+wFglfelvZMl18p1FeW8XMRm5Ghs9LPzf
 KHc2z6mDWbLqhnLiEwzTQV+9R897QyJ1aWy8z8AMA
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

