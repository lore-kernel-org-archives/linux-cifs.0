Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053123093CF
	for <linux-cifs@vger.kernel.org>; Fri,  3 Jul 2026 12:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783081293; cv=none; b=ZRAnHRtQXQ5hJ0SZP1EJUYsmFhXOfeheIra8LVU3UlZMJFPC4Z5CaL++Gs4bjsXodW/KA1/xE/sKtPjfPZ+y/pD41ruHVSKp+m7zK2A4PgMw898czI/oqX71dlrfzl+DmW2m90rXbwn5EUEQOcn2BlRm5ctInuDx2Pf/fPapLP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783081293; c=relaxed/simple;
	bh=NM0qdi/U1SW17ipI8zJAG47GqlYWil/CAlavCXQuq84=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kCjHYjDOFqdO20xrR+5hzVTwbI416ZArFfFb7MQ+B+ysLnkCD2C0V6io0B45Z8lihyTLvsnwv/rqm0tZypsCwtd/oW1s8wA1y+duZR9/z66N/kmm96j2uin9ILHUgQxkr4WKOO/koH6QfJ4iqpSKz/UD0lCLYaVqHShTahnnMwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NCuXOgT1; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NCuXOgT1"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-380cda7f00cso470054a91.0
        for <linux-cifs@vger.kernel.org>; Fri, 03 Jul 2026 05:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783081291; x=1783686091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=37rS3S15ZKgHXdlCeYBDdqpX9m5LHn58JhbTp1kkqUw=;
        b=NCuXOgT10lDmaeirjVzb2kCkJowz2ERgNPdHuPS6/ENPWxxd6bdil0QWspUtm6R5//
         t5u1Z1wWg+01dmW1YHpxRA8ayKoO7MHfnw8lVrwowosblCs0JcApqLLRetwvGhS72ptu
         SbXHsc83JQ7SPrzkWn07wikv4sxf92fj4FnoXQa8DxkWoYv1v98oIO9OPkUlTDAwOUG5
         Bb6IIQsZpyWaGkVcppS76tCD0RUB6m/G3gefzvyJYf6Rm4sZGdgT71e6iNO7YlxRprE7
         9DC0L4ZYFbITod6m+JSjCC/6cPdQffAmfEdeWQ2WbLuyowo/ilErNJG/kKVfh2s8u7UR
         uzLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081291; x=1783686091;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=37rS3S15ZKgHXdlCeYBDdqpX9m5LHn58JhbTp1kkqUw=;
        b=hNCAqOSiB2UBVdi6LFBO1uLcN78MDgo1Gg4/rTl3dpOhPBlDX68uhHzuXvQXQiqsyt
         +4XMISmTPb3hhPB7YqqRRO5+L1kW+VnC32+F1MFuVS7Zt8ZijKS1HALO9tW3c/9uXcgq
         SbLmQz6JJQae1yWoOUt5gfvKm09oej36H1m1SW9GOtZ7pVaUEIQJ7jQeFFIpLY/hUdjr
         +XR5yCH2UCl2DwChvSqSp4XPc6PMmgD7j1PFh76sm7b5lISDP190os3xEng0dlu1s2Hg
         vWCXIdhcTslmbokCjCExyjeOyTCg3Y5ejlcPKVjiBFKmwdB6AU8E5gyWTNoxgp49t3ae
         hqsA==
X-Gm-Message-State: AOJu0YyfKQeE15Emp40a74D7NKZLJxoAbq/0xeBb0ooCsmhjA2gxEpdO
	APXQs2RYdcj+8y7N8Df3ILU51YIhhnbGTVGxeJEaiDJ9LcFXxPUV1Sb5
X-Gm-Gg: AfdE7cmmLUHzMOaQi1h7mPnFvNkzyEZEnK4uGPMJ97c7fVL3MCkqVEHMvaNBSxKqKAK
	kFG9i8N9NVU2T7uTRLghAAYQon6V1AA6g4tS0s42yn33SM6Mo1CmMXTE4O+LpO1i6iG6E6LUHqy
	N9ygdrWCAr03VN6NkCr5VKaAkGkC0RU+neE6bAFDHO3RJzCc6s5gOmgkrVhbj/8LQ4+XLwIC/AK
	GML2+zY8Win7VQxe9GC6/VMxpSbc5C5IsTNzJdbf3wV438gS9NTLDZCdRtWfAG7EiQI0xWfyrll
	pg98U+SDAyc4ZLMwUYkqLUt2ReKkIo5a6ELJgHe8f0y/XF/KuCneO3v7Wmob6VUkFnXh5wTBK8z
	8iYl3UtADLdxtc7x+ebLEgoXPZxRDxBmkq0B5xy8MorMFFGhOepdH/WJVLRqCSjl7RWahlmoQGh
	N9ppO5LNEGSw4=
X-Received: by 2002:a17:90b:5547:b0:37f:fd1f:d30f with SMTP id 98e67ed59e1d1-380ba8d00eamr9530789a91.12.1783081291046;
        Fri, 03 Jul 2026 05:21:31 -0700 (PDT)
Received: from ubuntu.. ([2405:201:8026:213e:185d:def2:c823:8e8c])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0b816a42sm34656381eec.9.2026.07.03.05.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2026 05:21:30 -0700 (PDT)
From: mdshahid03@gmail.com
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Mohammad Shahid <mdshahid03@gmail.com>
Subject: [PATCH] smb: client: remove redundant NULL check before kfree()
Date: Fri,  3 Jul 2026 17:51:04 +0530
Message-ID: <20260703122104.69788-1-mdshahid03@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mohammad Shahid <mdshahid03@gmail.com>

kfree() safely handles NULL pointers, so the explicit NULL check
before calling kfree() is unnecessary.

This issue was reported by ifnullfree.cocci.

Signed-off-by: Mohammad Shahid <mdshahid03@gmail.com>
---
 fs/smb/client/ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index 9fa743be3652..2f152d76be7d 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -133,8 +133,7 @@ static int cifs_set_compression_by_path(unsigned int xid, struct file *filep,
 
 close:
 	server->ops->close(xid, tcon, &fid);
-	if (tmp_cfile)
-		kfree(tmp_cfile);
+	kfree(tmp_cfile);
 	cifs_free_open_info(&data);
 out:
 	free_dentry_path(page);
-- 
2.43.0

