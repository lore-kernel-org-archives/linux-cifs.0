Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDDB28980F
	for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 19:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776798391; cv=none; b=K3K01A5SDf4fCJjd/njVrepNTxw4jBPLmSeK2w8/2xhooVvuC5ol7LPEPi+cetRmAtUOMuan/qpt4pH7bKVqJqKEACmX51MlJY0IJf1Tp27Ihm3pc2pGuZqDqbQzN858te57Reznp2EhMYWEqooK0ip79ClS4971wXqpkonYQhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776798391; c=relaxed/simple;
	bh=VvTm4cAHZbuncy6sm/7K/bscL5eZ8MCtsCeeBZunYnE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=agQAuSCIgJ1QgSN7Am2PTO5/Fj03+ERROR1teNVV8zyCDi4e13jmei7Q9o1Vwjt6sb2OMoRYtdVaPDvmeHlE34crbnWvbqJy6+KdZ04LKMbwl8VSvCvvtgYLfErcSmveLYFW7C0zE1RH9zele9TZf6Pzt3SoUq+Pid5k2e2fYXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr; spf=pass smtp.mailfrom=freebox.fr; dkim=pass (2048-bit key) header.d=freebox-fr.20251104.gappssmtp.com header.i=@freebox-fr.20251104.gappssmtp.com header.b=Vn+e0FCp; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebox.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebox-fr.20251104.gappssmtp.com header.i=@freebox-fr.20251104.gappssmtp.com header.b="Vn+e0FCp"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so62259055e9.2
        for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 12:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20251104.gappssmtp.com; s=20251104; t=1776798387; x=1777403187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O0jF6nh/pkH+f9VD7h6qIt/vH27AY04GwziRDF2Gm8Q=;
        b=Vn+e0FCpFZBANCD6IcAQarWQ+9J0ZTP/RGrDUH/9mLphwz7mLd/9vAo0UQwqrhWtBB
         hOOPN9mzLTsAXmVOSM6X6Pk/Glb2Dc4j74rqoHAGFv1tv9KkuHHXRDEnfZPmonOng2Z8
         EdBiQDj8caPtR/oTfw41nh5GuAtYMdh1PypVD73J38evcvl58+J5BlwqmV8zEszldCyn
         GffXVG6JRD0rQEKWMFB0iQkuy132Z4OaCHlnhEp+zmSqAjFCxZCFgn/46pctkKR0U6cK
         H+N1WeEFNIDm9MvG3WJRalOJ4qK35i+5Fq0UpJaJm6bWslv9qZtz4YdFAGpU7RHTbDsK
         802Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776798387; x=1777403187;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O0jF6nh/pkH+f9VD7h6qIt/vH27AY04GwziRDF2Gm8Q=;
        b=juoU+OU3UWxt2mTPclFN/SR92bhTHMsuubTy6rUpsQkZ/A/D5fEtqt1Xq2c8IVk6nI
         UBgulQmRpqRA29H/uenbCEy1enSpTELb49ujhmDuDeav92td/bIQjL+Ru6Dmsy0WojrN
         Bo9u/cXtlcjN5nppg0GS1qbFIbiIz5n5G57YWvgobMz4wMtxccWb9+AR8GfMsEqLZ0q5
         kImSChXbrhpDRwougl32TqViQT7pwivZhnc8UVC6BNiQjL0dx+4XEmFgZiKwyW1pXrwB
         oYNg5jXDD6cgNAiEvkDsEbCBRvUDGAuz8hW391DZj5OabFm3X/Cs/i5tV5L/t//x/Sb/
         YQQg==
X-Gm-Message-State: AOJu0YwGjZmy/zIXSF3NNAMAfrdgfi3HMZTy7Tpl8d3QhSG/7F6k9Mte
	7x9jIyKWDvqsBW7Ef2ZqWlgE2RsMto9az+2RgDdl1dPMR6KDdqa6hxdPVWO/LlrkcOMywwPL5lj
	ZT2RV
X-Gm-Gg: AeBDies9f5dzg7mGiNqOSe5cA+EZbZ8BMEpwVUwK3KHxpMCogOCeD6eTlkzwvRtDigT
	5LtfXWf6z60M6Sy6LLfPdQ2qvbII5wVQlmD+zelxuUSiaQ2/VujICeka8kli212C3YC0Up7f00R
	xKcVPhGrUku3ATeDWlxfUkWpbUWTvttW0+Ng20Y7/asyjtlhUPQzm3bM6Okq1qcmxeSrohR9HSe
	AyvodWYDGw3Kms5DhHEIC/n0paWwOMEQPnWx47hX4O5KC+QneAIzEnPFYZQmkBaVZQv4lxSPxF6
	FcfCpP3e5yhPoB8FfyFYnXoRKWbnmLTvoSVjTBaMX8TchaN/4NoqvG+Ezt0WEUhFzb1vmNbr4DA
	xZYY9Wi3dn3t3KxM3bl0fVyqWaVX3CD09x+viStFuGXar8g3lBiMlLqywVgcSkI/FsfT8ZkRxgR
	aRl3pIdpqMOW//yZDEUCr16JVw6T6Os+v7Pu/hDL0gMSsBX25nxb8iiCH6xWjx6Gtf5gIauujp4
	kXy500t65Uk5PqMbtyZLQDgz2dDAjS5c45JwSIgv2zBWWAOIuJYZAM=
X-Received: by 2002:a05:600c:6297:b0:486:d76c:fa57 with SMTP id 5b1f17b1804b1-488fb77155dmr262140515e9.17.1776798386621;
        Tue, 21 Apr 2026 12:06:26 -0700 (PDT)
Received: from odysseia.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4899dc95920sm43485325e9.6.2026.04.21.12.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 12:06:26 -0700 (PDT)
From: Marios Makassikis <mmakassikis@freebox.fr>
To: linux-cifs@vger.kernel.org,
	linkinjeon@kernel.org
Cc: smfrench@gmail.com,
	tom@talpey.com,
	senozhatsky@chromium.org,
	Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH] fs: smb: server: stop sending fake security descriptors
Date: Tue, 21 Apr 2026 21:06:19 +0200
Message-ID: <20260421190619.1396589-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

in smb2_get_info_sec, a dummy security descriptor (SD) is returned if
the requested information is not supported.

the code is currently wrong, as DACL_PROTECTED is set in the type field,
but there is no DACL is present.

instead of faking a security, report a STATUS_NOT_SUPPORTED error.

this seems to fix a "Error 0x80090006: Invalid Signature" on file
transfers with Windows 11 clients (25H2, build 26200.8246).

capturing traffic shows that the client is sending a GET_INFO/SEC_INFO
request, with the additional_info field set to 0x20
(ATTRIBUTE_SECURITY_INFORMATION). Returning an empty SD
(with only SELF_RELATIVE set) does not fix the error.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 fs/smb/server/smb2pdu.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ee32e61b6d3c..6622efdd55e3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5745,20 +5745,8 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 		ksmbd_debug(SMB, "Unsupported addition info: 0x%x)\n",
 		       addition_info);
 
-		pntsd = kzalloc(ALIGN(sizeof(struct smb_ntsd), 8),
-				KSMBD_DEFAULT_GFP);
-		if (!pntsd)
-			return -ENOMEM;
-
-		pntsd->revision = cpu_to_le16(1);
-		pntsd->type = cpu_to_le16(SELF_RELATIVE | DACL_PROTECTED);
-		pntsd->osidoffset = 0;
-		pntsd->gsidoffset = 0;
-		pntsd->sacloffset = 0;
-		pntsd->dacloffset = 0;
-
-		secdesclen = sizeof(struct smb_ntsd);
-		goto iov_pin;
+		rsp->hdr.Status = STATUS_NOT_SUPPORTED;
+		return -EINVAL;
 	}
 
 	if (work->next_smb2_rcv_hdr_off) {
-- 
2.51.1

