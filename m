Received: from mail-pz2-f16.google.com (mail-pz2-f16.google.com [74.125.228.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F52437F32E
	for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 05:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789882298; cv=none; b=iCZ63z6P+wiTwZNGhVHg7moIi3ho5dtmfp8OxXMsli22Qy634IjnLhZfprx8TvshSHBYurcW/ukytak2ey7PYFDqlHSiy5bp3gW7erDZK2dA7UzAhfc/M0cCVMzDTjN/AeGGwlEF7fy+pH+tcQv1lETCKqh6ELrkmYKht7UxNeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789882298; c=relaxed/simple;
	bh=ZTX+UCiB00PtoLBoj0o91CQgixDs2vyGiWWpcAKhAGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFK3/6obtDYxUZguapA0X+H9vQ6YDLbsBgjW22nDqWscvxG0lKWpNuGyMiZ1Rh9W7YjBlEyg0JTioDSNPydmbdi5rm9sWHH9QbXz1NlCM5sidMW/vz+g8s4XTBesYZ48GgK7iD6NEs6h2aAYTTBO0/08LrIw7lY2VpCydh7mg4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RHNiwfK4; arc=none smtp.client-ip=74.125.228.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RHNiwfK4"
Received: by mail-pz2-f16.google.com with SMTP id 41be03b00d2f7-cc4d2fe2056so1202149a12.2
        for <linux-cifs@vger.kernel.org>; Sat, 19 Sep 2026 22:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789882296; x=1790487096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R4MIvJEmoKf0KBD6qvnXea65VG2vB1Yia4/nWyl8LHU=;
        b=RHNiwfK414c1cnWY8Oupdmu6uobx81XaDO0+BAQ9Fse8e2jTyMoKcLIR9ONWJUGOGg
         wJNy1L0892jdv65aE0Rd8a188AbfMUlyQiUEDTp4RAxhiJBvVtS9TiI/2BLUa1TnYyWI
         ynJJzmG2eHEwGjG90EAPPPC5SpaKfD3xz6SeWP0ChB+QpYeliaUblN5m8ge0h1o1QWuG
         x0aqDl/jP6NcLbk4DOp3XKzsHEozXXevooIueZwnYOWKITrHdKa1godOhpFDzQ2UjzzB
         MI/P4RUDYEa2lTYjty2BmskTBGsFDI3/A7zsQoQHRjKUUBawT+R5upuT3pVX9hk3i1oy
         YMlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789882296; x=1790487096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R4MIvJEmoKf0KBD6qvnXea65VG2vB1Yia4/nWyl8LHU=;
        b=Iqb6FI+450PoLiq3BVynG2juarohU2nLPgXsym2wuoihu4nd+mbZM8CAf9E8lBzf2W
         AHQ+J0i/fkS4ymt73ez3u2D2wX4G6MlhIZGIKim6nemJEaJqJFQXTvMXjMsTk/9BSWrX
         naIvuTvb4RWu9/2AcltDCKhZSfiWa97z3dXzdFfQlD+QsO7zY5zAI+XY+iLOZLQKh0my
         ApHUryuakUjJ9YI7cKv+K2CJFmnCF6DJejXtgJgS/rJsU9eoQ7HpgmNIRogQ8n00feCf
         +TLBaBQHfqTO1S6RDW5YLQEEnmAnxdR+Eqwwa6zTlaQ8VBJHwURMGwZuomOjkvoP7unl
         YSEw==
X-Forwarded-Encrypted: i=1; AKwUvBwFM7NhvAlI1DHbA1ZuELIS/RETzNKotfRMBM2kjgchcD1CMPfRhqy3a/OdEFpTDoRzhEd1t5vOvznt@vger.kernel.org
X-Gm-Message-State: AFuF++l3wYQGTMDjdmOp1mmi7WoJFEsHPHEGyku6F41fcWHdxM+9egNh
	1tAv2NnPVI56L9+pIhscHv9zIGPUWGbQWyIR8cXHsOPHCPSmG2s7Eg4DUme64aN0
X-Gm-Gg: AYBFou31Da0NEdZki0oO4XI2+4QGydoFWOPsC5s2Q6TRnGxXNo6jsuBgGPPOGbNClpx
	ABCq4S+e7v0M6UO/7A/AD3MIkG7bJ+TtcHvX5kBQ6SOnv7cun3s+TG9jsCf55FSY2UstKZiPiLX
	cobM+GTO/9JDHjyvMZKnrSWf1LLSgxQ6m853V9ScmWyffbB9DrC/o34b9AdwxMAwEg71YGIF+PD
	iHcNW404y8v7bbwHZwocsCF5w19CLd3wc4GGxZTkvpSPzIUkeXafIhSHMzhgqS3kFeXRFX0Xe+Y
	DFYA1Xt8YNZmPLgFvv8Gv+Z15Df58xIrn2PDFXVkJyUmLBkhAQOgzW9t6GS+WIkSsNWSXoOmVAV
	ykeTPWlNx6Vwvq6n6Un77x3d3GdEl8MGYsx1SO8cJzURrA16gPkcsn+QNahJ2SC7kEoB4gX8Jgj
	9elg6vaFL13LAxIUJLJQZ2DOzmEfjRZPUdkPQqi/J0jbBRsmRK3YewR3NyZujV7mBlaOIJmw88d
	VTkH2c=
X-Received: by 2002:a05:6a20:258f:b0:3dd:57bf:7248 with SMTP id adf61e73a8af0-3dd8c4a01f9mr13081207637.18.1789882296269;
        Sat, 19 Sep 2026 22:31:36 -0700 (PDT)
Received: from RyzenBox.localdomain ([137.59.96.253])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144d55cef9bsm10438475c88.10.2026.09.19.22.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 22:31:35 -0700 (PDT)
From: Omkar Chandorkar <omkar0926@gmail.com>
X-Google-Original-From: Omkar Chandorkar <gotenksIN@aospa.co>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Namjae Jeon <linkinjeon@samba.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Omkar Chandorkar <gotenksIN@aospa.co>
Subject: [PATCH v2 1/2] smb: compress: relax trailing flags in chained decompression
Date: Sun, 20 Sep 2026 11:01:25 +0530
Message-ID: <20260920053126.28654-2-gotenksIN@aospa.co>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260920053126.28654-1-gotenksIN@aospa.co>
References: <20260920053126.28654-1-gotenksIN@aospa.co>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In SMB 3.1.1, clients such as Windows 11 send chained compressed
write requests containing multiple payload segments (for example,
None + Pattern_V1) when transferring zero-heavy or compressible
files.

According to MS-SMB2 section 2.2.42.2.1, the first payload header in
a chained compression transform MUST have SMB2_COMPRESSION_FLAG_CHAINED
(0x0001) set. Trailing payload headers in the chain correspond to
subsequent payloads, where the specification defines
SMB2_COMPRESSION_FLAG_NONE (0x0000).

However, Windows clients do not always explicitly zero the 16-bit
Flags field on subsequent payload headers during chunk construction
(as described in MS-SMB2 section 3.1.4.4 step 2), leaving residual
bits in the Flags field.

smb_decompress_chained() currently enforces:
    (!first && flags != cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE))
returning -EINVAL if any trailing payload has non-zero flags. When
this occurs during large file writes (such as copying VHDX files),
ksmbd breaks the connection receive loop and abruptly terminates
the TCP connection with ECONNRESET (-104), causing Windows clients to
fail with error 0x8007003B (ERROR_UNEXP_NET_ERR).

Fix this by relaxing the flags requirement on trailing payloads in
smb_decompress_chained(). Conforming chains still strictly require
SMB2_COMPRESSION_FLAG_CHAINED on the first payload header, but for
subsequent payloads, only reject headers that attempt to initiate an
invalid nested chain (SMB2_COMPRESSION_FLAG_CHAINED). All payload
lengths, decompression algorithms, and total uncompressed output sizes
continue to be strictly validated against the transform's
OriginalCompressedSegmentSize.

Assisted-by: OpenCode:gpt-6-astra
Signed-off-by: Omkar Chandorkar <gotenksIN@aospa.co>
---
 fs/smb/common/compress/compress.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/smb/common/compress/compress.c b/fs/smb/common/compress/compress.c
index a4123c8f1c0a..4e5164b6dc33 100644
--- a/fs/smb/common/compress/compress.c
+++ b/fs/smb/common/compress/compress.c
@@ -130,12 +130,18 @@ static int smb_decompress_chained(__le16 alg, bool allow_chained,
 		len = le32_to_cpu(payload->Length);
 
 		/*
-		 * CHAINED marks only the first payload. Requiring NONE on every
-		 * later payload rejects ambiguous or independently chained data.
+		 * Conforming chains must set CHAINED on the first payload.
+		 * Windows 11 clients leave uninitialized residual bits in
+		 * Flags on subsequent payload headers. Only reject trailing
+		 * payloads that attempt to initiate an invalid nested chain.
 		 */
-		if ((first && flags != cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED)) ||
-		    (!first && flags != cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE)))
-			return -EINVAL;
+		if (first) {
+			if (flags != cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED))
+				return -EINVAL;
+		} else {
+			if (flags == cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED))
+				return -EINVAL;
+		}
 
 		src += SMB2_COMPRESSION_PAYLOAD_BASE_LEN;
 		remaining -= SMB2_COMPRESSION_PAYLOAD_BASE_LEN;
-- 
2.55.0

