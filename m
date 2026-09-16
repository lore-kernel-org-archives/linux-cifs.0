Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316234F646A
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 15:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789572607; cv=none; b=UqtgTQXsNNeHvZalTZ4JOxhNQUG+OpqgoFQx/Jy2j4mxrFJ9SlWcGe9Ydo87kQrf4vuhgN2mwTLrHmtmhPxY/Gb8vgu0QbhiNajLXEmWkkvDv43/VzWUK45kqN9zMVFsw3InjklykEKxckpIoO8X+S3kS2fJI9IlNOCQRTvkDTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789572607; c=relaxed/simple;
	bh=jcIKvNqbP23cv3kg+uqiQmOFJ+WW8/0Q1r+iBsUUzTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzc5qJft/LbPRq0LskKIRvPmstpnges3UO90vruQtVTrV0YvSm49aOe+YcLw/oFL6OrNeHAutq35tmgKn1nVjkgQBm8K+411aS7+KuV0OL3eI1UaSy83XRSwIp2opjUa7bde/yZCTIGKCOK7JhFv7UNjzmnPCNKofN0GM51zAG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=q5mLEeSY; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="q5mLEeSY"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccafb751so935746a91.2
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 08:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789572593; x=1790177393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S8JIFdMmUAYlnSwLEm6Zti2uOXvyYHqMe+yXR4VxiUo=;
        b=q5mLEeSYPouwgBMNga9ADEHYpq2Uy6JrfzvOnNWKan6ZnHWHlzavuix/4V8rH9xaf7
         QEiDCbofSV1muwd4MNUi22k2taZZXBgUVh7Se0TKL2y0qmQ/fc3N/5woeuFRLcwJGhKf
         NVosr+CYVCds6hCXGXgJZIswAs/CsdhPLDkjDpNpy9paCwWCqG7r5ltjKY296270o0AK
         NCB/nc1ZHjfDRFgiaYXx4GjAjMWUOZd0Ke05siOsaoT3/t7AbYKbQTJjKQDjGPhvbVJX
         6E9aNekpxB591MMUT2xATBO460bh4q5JcUlLYXW9454fmWA9zEq3s3Gx39m8UBTdDpTv
         1tXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789572593; x=1790177393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=S8JIFdMmUAYlnSwLEm6Zti2uOXvyYHqMe+yXR4VxiUo=;
        b=WucMYh6UhaNW8wqNrksM2B1AQBsyfu8Jyh47XHV9cna8Jcz5i7lLbHots1uVpM467B
         o76MneehGI93BcBozpEL9zEhI/Xx9HUwtCkD2X27NagylsHqUsZfSAL+22oKZm6DsgY/
         VceUkX48fB4Q2dd7Q5XogJXAiTaCpWmXjaNuYXTgZxk+CdcyHHzSZdKY4IUQNgVzuSJT
         0gPgb9uW68rKArtqG4Ib80k8AA80g8UKZIKWwH+uhbcmVrkdJE0wrCRfkLy/1E33kGeD
         Dk2RQmkLr079mF8CokKlis2VV+9Q7omJA5CYcQIHD759Fb/wadPWIcFbV3lBye2a4/H5
         bguw==
X-Forwarded-Encrypted: i=1; AKwUvBxll3UVNAOB6vcRxNGGw47qiCA6rwnJEVm9pkTGHjMO9o8TTSLpOslZyDjI10jAQLzhT+EsT3PT3e/1@vger.kernel.org
X-Gm-Message-State: AFuF++lTD7KgnDN1pV2MWIiccm8SRLc5d0NtBxxVNTd8hizuI48/mCC4
	GF4mgXMwMCBMJj0CSxfeZvILXOQW40Tuq5/eTTsEW7UxiIV1NsTooqaYmVt8qlkm14tdXvBiwrz
	I0zA9a6EP
X-Gm-Gg: AYBFou3LIujmUlLaPBkUv3WRVJ8OC3JESiAmXruZF/hqgHnb00KXO+KsprnYunYLz+3
	pmVlKTOU4OozSZbbK/jwoQ+rD4s5UMHISpjlc2HMo5fqc510zXbIpTssRRExv5i3L/DkEd2qXQL
	nH08BSR+QVEQ2UWSJr3KLu7rIc9P7PjOxqZ3laYmm4iKcE6V5y4yNR8oQCKJYTm3/j6FfU6w2D5
	c9ZAPqYlAoyyKIf3gaGkNx5bybNWdolp5ABzSFUsYwDn9HDv5zCRYAUcKVzlg2kKNkbf5jDOt1N
	NqNgk62VZyeBHmhxS0hcJMdNWx85j7/WNn5Z0RZrPFuAmdroZBjotDO3TEVfYujpQcL12I26naw
	GXRuwPGsZSu6tzZpRm9URfEq5h8Ihth2tt4BWqAh47NN6S38fxHVUCRtiBhA54/WcFy449Z5aA1
	l5P4faHtqdN1q+Or1vaPFjcti8YkxjFbH7BJiQ4No4u4QOcOXxHo8NcOZ26o0q8tgfd5df5kJ1r
	XbqvkHVSWWRjW2j+FxRTS95+d63AGM=
X-Received: by 2002:a17:90b:4a81:b0:39d:f773:37b5 with SMTP id 98e67ed59e1d1-39e1df6193cmr7455905a91.0.1789572593285;
        Wed, 16 Sep 2026 08:29:53 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e35dab2e9sm28214a91.1.2026.09.16.08.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 08:29:52 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: pc@manguebit.org
Cc: linkinjeon@kernel.org,
	zihanx@nebusec.ai,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH v4 3/6] smb: client: close handle after create-context parsing failure
Date: Wed, 16 Sep 2026 15:29:26 +0000
Message-ID: <ad545987358a870885424356b64b3846d2caccfd.1789478666.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1789478666.git.zihanx@nebusec.ai>
References: <cover.1789478666.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SMB2_open() accounts a successful CREATE response as a remote open before
parsing its create contexts.  If smb2_parse_contexts() rejects malformed
context data, SMB2_open() returns without closing the handle, leaving the
server-side handle open and num_remote_opens elevated.

Close the handle after a post-CREATE context parsing failure so the error
path releases the remote resource and balances the open count.

Fixes: af1689a9b770 ("smb: client: fix potential OOBs in smb2_parse_contexts()")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>

---
changes in v4:
  - Keep post-CREATE cleanup for parser failures and document the existing
    best-effort close behavior.
  - v3 Link: https://lore.kernel.org/all/cover.1788516372.git.zihanx@nebusec.ai/
changes in v3:
  - Split the POSIX handler check into a separate patch and corrected the
    parser Fixes history.
  - v2 Link: https://lore.kernel.org/all/cover.1787486936.git.zihanx@nebusec.ai/
changes in v2:
  - Add cleanup after a create-context parsing failure.
  - v1 Link: https://lore.kernel.org/all/eb1bc35611f91bd10a4772400b37fac26f660956.1782579150.git.xizh2024@lzu.edu.cn/

---
 fs/smb/client/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 1b2ca3b2c2f87..12973f2e26b16 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3414,6 +3414,9 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 
 	rc = smb2_parse_contexts(server, &rsp_iov, &oparms->fid->epoch,
 				 oparms->fid->lease_key, oplock, file_info, posix);
+	if (rc)
+		SMB2_close(xid, tcon, oparms->fid->persistent_fid,
+			   oparms->fid->volatile_fid);
 
 	trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
 			     oparms->create_options, oparms->desired_access,
-- 
2.43.0

