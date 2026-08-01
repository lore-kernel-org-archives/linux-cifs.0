Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1A3311973
	for <linux-cifs@vger.kernel.org>; Sat,  1 Aug 2026 05:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785561610; cv=none; b=l/xduCGG8yu+7WwlHQ9+HOcIs3B8Yo2zJ1zcDSwWg3jkx6EJ1qboBwKVFDgWoaU2Cmzz54WzLabtoTXJJCWpejcf2WCmwGmaJuJKyO4LqSmH8y2V/SV1jbTjMRQ6gwucVfkyw98NXx1v/da6JPgKKTkcGxsML+Qvli4TuUnIMa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785561610; c=relaxed/simple;
	bh=YsWY+Ku9Y/MrV2dewwHBchDIkoBjK7qqis7jChxN+5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toMMT1zyTVbarmjCnids11JnBwqJUfsJLncZ/XXiex4SzTPcqx8S3Kaq1auH+HwrK/Ii8aZZA99uACWNP2tp2PsMVMwCzsjg8mjTKiMg+zV+dmiatP0/fWfy7PFDyvGLeRDkEPzTqPzmwslJkPgmzC3UBl7aJm2t8J8OlDqepxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nioa1AF1; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nioa1AF1"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c160420289bso255536066b.0
        for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 22:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785561607; x=1786166407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zPNkWrFW93Gq+T8SC54rUw4s7sklfcabklgyZft0CxQ=;
        b=nioa1AF1ov4A1G+xXFUljne32AOOUL+4tx71a/AqOznC+Oc1gCOP7LSkM64l3GaG3x
         +gY1gj6EKp4XwVP3Fdw8haC2QhebcyS3veyVLvVW0NCAGDppKSP/qkSLK6/QBj6wMVTk
         wx5zs9j8ycilB2xCY3oTGxAF5f8ACY7z9N/auvu9dAfRtqklt8XYvhR0FDYn1DLa19t7
         uLW6O0A7stJ5yEZFyCZkpDGQBo/QxmAnbn1ZFDh1T6FgerU3vRmSSarhG1gBvE6+v+9T
         hCMjMqwOVHWdL1bfBKTdevlBrVLqAmlth2xK+lRQgMK+uySIu3bnLzuqPwGfDaUDFhTd
         xAZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785561607; x=1786166407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zPNkWrFW93Gq+T8SC54rUw4s7sklfcabklgyZft0CxQ=;
        b=msEWD3EZvXsEdsxpiTPOEVtGSDTdC3oqifizI1ffYhqmG1b4bFCH2o+cJMGPRbp6Lx
         uA0KvKDwR85TU7p/LZvY6lu93kvwsGTzwiLvbhuQx7JXDRB0LvpzHJ42+ui9qASerdo2
         fzc+STcxcHyd/JX9m+h37fm453p6GO4UUZy+sMlZqDVO/n8+QYmigEd/H2sxII+2e6up
         dyZ5lPT2oUdnBqYxPsr79SgfH2nIGNHVqdfZebCiosUeqAqc8Pemb4mQ/MLssMr3E0Io
         rNhrROjH7ERkR9IiLUCaRY0T8a2ufFCrjhW1HSI2SInlTL7a1VGODkNSQ1Ar8pjZNR4g
         LjNw==
X-Gm-Message-State: AOJu0YxLjQXsyUNx6eDQkJxBS25U88Jyq5lYvEmfBuZa0vS5OLoZTpqD
	j5EJ4bK9AY8C6xrAwPzfHipKvINsI9dJ7ZLnoKVeW9O/qbvxM8jhM6ug
X-Gm-Gg: AR+sD13BhN53c+UhMQ8uYNSL2tcoeoO/mupXtwNqG41iEefLZqH5B3mwB3TaasS9CYs
	DCzpyZnyhS5ZdXqu+e0O9vDkuKvXaBBHGZxjir8wnNvN13vx+AdIcfjgH5lQt/zWc1wvwXYMpNm
	gVdKkRgDXLPVs8tIKnTb1Mrn5/Pw938NmVcHK95C2LuWQ5MXVJSJxX3P2mOgbAsfha5ageq8Y5W
	K/1qRWkjvMlP16uGQyx23gk+W2wgRatyw3PeklFZJuPLL8881D6gaAIneB8+yTH6TzRGFbNqyor
	JKeallYTLuWLprW6aDOx5u3QqLeDguVNQa0F/82bV3XdTl7F/JhiyCW5YRHrliE7nmZunOSS5Af
	Ff9uPRdGzqOCXZOawKEgnpPvb8fma38Ki3TH6OLA5rFEx7H6YWR8wuSSd8yzMffJLpRv8EufBSR
	tBp0FrkwfDoW4wYuXHFy9QLe3aTqGuh4Bg/6ddLv1lxMc9NXbbq3wA0UAhDF20uxpVv5voB0dRI
	yIfD+mo8X8nnA==
X-Received: by 2002:a17:907:b052:20b0:c15:f45d:d98b with SMTP id a640c23a62f3a-c1fe7eec06bmr90035166b.10.1785561607156;
        Fri, 31 Jul 2026 22:20:07 -0700 (PDT)
Received: from SHUANAT ([95.47.122.240])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd3c5b608sm287393766b.8.2026.07.31.22.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 22:20:05 -0700 (PDT)
From: Anatolii Shumak <anatoliy.shumak@gmail.com>
To: linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org,
	Anatolii Shumak <anatoliy.shumak@gmail.com>
Subject: [PATCH 2/2] ksmbd: validate compression Flags before kvmalloc
Date: Sat,  1 Aug 2026 08:19:53 +0300
Message-ID: <20260801051953.74245-3-anatoliy.shumak@gmail.com>
X-Mailer: git-send-email 2.51.0.windows.2
In-Reply-To: <20260801051953.74245-1-anatoliy.shumak@gmail.com>
References: <20260801051953.74245-1-anatoliy.shumak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd_decompress_request() allocated the decompressed request buffer
before smb_compression_decompress() rejected unknown transform Flags or
chained mode when it was not negotiated. A remote peer could force a
transient multi-megabyte allocation that was immediately freed on
-EINVAL.

Validate CHAINED/NONE Flags and compress_chained before kvmalloc.

Link: https://github.com/namjaejeon/ksmbd/issues/529
Signed-off-by: Anatolii Shumak <anatoliy.shumak@gmail.com>
---
 fs/smb/server/compress.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/compress.c b/fs/smb/server/compress.c
index 821299888ad3..7e13cae705e2 100644
--- a/fs/smb/server/compress.c
+++ b/fs/smb/server/compress.c
@@ -46,13 +46,22 @@ int ksmbd_decompress_request(struct ksmbd_conn *conn)
 		return -EINVAL;
 
 	orig_size = le32_to_cpu(hdr->OriginalCompressedSegmentSize);
+	/*
+	 * For chained transforms the top-level header is only eight bytes; the
+	 * Flags field overlays the first payload header. Reject unknown Flags
+	 * and unnegotiated chained mode before allocating the output buffer.
+	 */
 	if (hdr->Flags == cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED)) {
+		if (!conn->compress_chained)
+			return -EINVAL;
 		out_size = orig_size;
-	} else {
+	} else if (hdr->Flags == cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE)) {
 		offset = le32_to_cpu(hdr->Offset);
 		if (offset > pdu_size - sizeof(*hdr) ||
 		    check_add_overflow(orig_size, offset, &out_size))
 			return -EINVAL;
+	} else {
+		return -EINVAL;
 	}
 
 	max_allowed_pdu_size = SMB3_MAX_MSGSIZE + conn->vals->max_write_size;
-- 
2.51.0.windows.2

