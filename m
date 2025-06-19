Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB15823535E
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 15:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750347386; cv=none; b=ut74Q2mKU4aMmBzUYZwDJ4HiL8O3ukxCGhI0x+elBhkY/xzXTJ8HQMcStCP4Y3jZAHedsUeiQANTs6nA3nNxM5wXI/oOuSPAaFeZgC2Y14zbW7NYxJDo5tzqZhGPRxUOr7umP+GZZN7L7H0MVzf/te7wVmuCD4de6QFr/VHQBvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750347386; c=relaxed/simple;
	bh=eRg8yWcSOB10BQUhMP6qpoz3ieRx9eFvq112afoH+oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYr4JJGEc+Si9tPI70VaLXtzVYUaorcGINMLU5b+yn23tV+9D5yy9C5RwhnYuAjQ3DX9A9fxaAd/cUkXkd3G37Prw6SaCQElbqNqFUB1vg9fC8nfbKRwuMwazfDFmogR7AoiPJoJh3QyTWdU12z1Kmzbfu9Q2LsVRhjshflTbNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A81jXhyn; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A81jXhyn"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-747ef5996edso681862b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 08:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750347384; x=1750952184; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U2twxSZ5hBORl6YWt57p2bhVYfwkadsuc5ITfdBN7+Q=;
        b=A81jXhyn1svCD+BVSxKMsICPosktWueVrgs+Ppo6/N6sOCevEp5qSL5uPmPjzjxbkq
         nIYZcoDzCNlaDMT7LGYqJSmx1AO0dh+nx0sKSWpjKvvSZ74oxu4ceDF9O0LbdKs2v0VY
         zAUM2thNJ7RQg5u+SejtI99MyBsn3/9jGke629HqkpwlUc7POamWgoiqvDjPKppxcSCH
         VMTLCq+zVv+0Tq1fVuw1UqPP6xJPfLQucNtatLXhLqQtj1s/a+9hPrjP7ojzoW29D3qD
         QNgf+ejZQjhZe0NAYfBypgzF+Vg7qAdKYG2xZLhddTWV87i1tPpgotLrXO0v5GhzSg1H
         aunQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750347384; x=1750952184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U2twxSZ5hBORl6YWt57p2bhVYfwkadsuc5ITfdBN7+Q=;
        b=fN9bBoN5yW9ig/W5Tkn9sL3dOAG8fmi6x1S05KSpxR2A166WTL8jDpk0cXqWkm7eF7
         RHp2S9PMLd/exm5pGRuhOsyRQDetVdPJS0n/oLwRh5iAvYFenRVd6Hn1tfxXWEbKP7k8
         AGm6v6xA18hJ/RIQA/5RcnwUNQL7r1qHtYZDHLX+mhuduDo6mBWuRmsMKLD8sk26UvLa
         DMpBCQKRtlgCBrYj6yqw50Y72sRgZ9NwI7UU1JWx6+HC0t4AznFBRu2QqTfF9Rec7nz1
         QonJyOnZyq6PkEzmpX4MWHkaiGbdzihKockes0YiOBtRRMnC3YfaJhQe33UkbWVuonB+
         RP7w==
X-Gm-Message-State: AOJu0YzRdPnF0Uvfpr+UhPNfGLZZhRHJGrObQJzL7ybuTwbPRlSow3wv
	QdNKWYVICuQgAZFGOTss0Xy5TRN2FKfV+4GqJN2TYMJCVmwBH6993RjPB91rcc8w
X-Gm-Gg: ASbGncuJVFZ7HFIBwZ5kKCx07bvPAEFwKIK+giuksUWebARjBjXLAH3JPnVIUFYLEDR
	lY8I//qIcUd2A9Wfum6S9aoQ7aUTtnJN0y9+tR3tCTsRnLPRaSBNyhqZNiTOxJaVGSHrDc6XJ3H
	kZ4NyeJTo1PwJFLrN9TrbK6cR799ijZkGShJImmJPCULvtnz6+JoXgbLma1GcRgXKwkGkFZEpiQ
	lJWoGqhLP81wHVKB9o/hQxMmcJTc6PDus/ioZNopWbNNZglUoVbZTm8FzsInn2wESoWKloS5qSO
	iBfjVKU3i8/jk/Xo79XzVLfG78IIm4zUExHGUvFbkFNTedLdEKOerAHQkjzIWN5FBGoVP35mkU+
	EkA+CLrIctx5G
X-Google-Smtp-Source: AGHT+IEVePuFsqsWz2GosnSWxWd8Nw10m8WSej25VdqjyZ32Zgi0YwiwKINW+eNBM5ndVYCH/P3Tbg==
X-Received: by 2002:a05:6a21:329e:b0:215:f656:6632 with SMTP id adf61e73a8af0-21fbd588616mr37678024637.29.1750347383566;
        Thu, 19 Jun 2025 08:36:23 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([131.107.1.253])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7490a46b574sm162838b3a.15.2025.06.19.08.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 08:36:23 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 7/7] smb: Fix memory allocation and ACL handling in cifs_xattr_set
Date: Thu, 19 Jun 2025 21:05:38 +0530
Message-ID: <20250619153538.1600500-7-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250619153538.1600500-1-bharathsm@microsoft.com>
References: <20250619153538.1600500-1-bharathsm@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If set_acl is NULL, then there is a chance that memory allocated
for pacl memory doesn't get freed. Ensure proper memory deallocation
for pacl in `cifs_xattr_set` to avoid leaks.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/xattr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index b88fa04f5792..4d2b70020776 100644
--- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -174,6 +174,7 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 		pacl = kmalloc(size, GFP_KERNEL);
 		if (!pacl) {
 			rc = -ENOMEM;
+			goto out;
 		} else {
 			memcpy(pacl, value, size);
 			if (pTcon->ses->server->ops->set_acl) {
@@ -211,8 +212,8 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 			}
 			if (rc == 0) /* force revalidate of the inode */
 				CIFS_I(inode)->time = 0;
-			kfree(pacl);
 		}
+		kfree(pacl);
 		break;
 	}
 	}
-- 
2.43.0

