Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE2E235068
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 15:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750347381; cv=none; b=WYs/KtDiXReqv/b9bo7fS0e5OG/bxsGHL9R6AmvjqLxge8S9RCSgrACuXwRdVxOXfWuKfy9Tc+gCaG67+vKmyQSsqyjKFMg+eBMStWyG6kDUVbO4pU4+UVpgVgaAwXhvc60jDTdanOP2DDyzjqa1avryeoJ2skZemSmMgfzL3VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750347381; c=relaxed/simple;
	bh=4jGXIyPjkg8R0tsconEF69sCOFeZNfQHS6Dlb5LRl18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lw/AeBOytayW8p740M2a1KqqFCj9KzvfOUvvkj2RxAa5NcXtZSx6kAZaCByAEVOTpxgTKOZNpE07bL+6tdtPqWqFF38wPQiyxUKzDDcUOOnrdKCwcPC80an6vV8HHZayKXiQRPspY5ejeE/flp/26+E1csYLe1opPSdou7OuG8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H93A3LpJ; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H93A3LpJ"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-742c7a52e97so656270b3a.3
        for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 08:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750347379; x=1750952179; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HnWzn4lVsIaFipkE6k+Ni+EeBDmhzG0WT6qFnRiS3dk=;
        b=H93A3LpJo2paq8mb9bKmY2KuOJTuQUPqanPNulCF4JRWy1YCq05CTmLrts2GDd1Dqm
         UCZcWBy89f10gE0zhLFext/xy2/jMMAsRUKk8C9KvftGY9y8n0KIQOn/1FXRNy7DMkD1
         qK2CNw3iQRqSYsO2CSrPhujDXg/ogu6PPfZ73SsYk614VumQqJlikXIZhUKU1Iuu9N8C
         aIPIbD60zqkQsqgTmA4BmUFCwwfIpiiREmTi20Q0LtRFssiNfgYjo6VuVJiWDVcLVoqv
         MPXUPdGFesZ3Ab+Kes3DRb3y/EpeApBpfqVHKgECg1EYX3uqYXHVyqTns5NfhCpWe4UB
         JzgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750347379; x=1750952179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HnWzn4lVsIaFipkE6k+Ni+EeBDmhzG0WT6qFnRiS3dk=;
        b=WLh1mXLaikGBIbFtrxUC2Ym4+KiSLFGz05RxB6/GlF64vaGCcbj25RjO/OzkCNDcgk
         CejBgHPLnXlkxBaqI90hMM+ov5JMDxf4Jz+7rqiWonnM45HnbEQyyW11Ie5nbdWL12cN
         qmTjenV+EK5eUa2a1wdWGvnnWeznbmHk5N17WgtCnusjQRrmT+fD/0PQMvVHcRTe25YS
         GHPaWvO07OSl1la0khUIkXwBvmS/rRX4WYVz/xIpxQZa58pJ/uOSUVASfemLXum48Ivt
         L/2NicY17jF7LxXZZVl4qhiBBxpUrxWMBHzSJT1YS2iB6/enBBB6gMAEXmeEeo2zA/Cc
         H2wA==
X-Gm-Message-State: AOJu0Yzi+cd125iPWMFJsq7hsGhPEY5LQNk0svj/itsnhFvmgpqUfq9n
	44DqymZ1xdpQvoUmPUjflZnMGgNFHyZ40oz/WcpJ/MLPmzbiMVtrErFniuXC+a8E
X-Gm-Gg: ASbGnctTpNgt+aoiFncN4qseP7QH0/EGbkrQoXlOmyBJwYKQUX20BWearlzzXcreV+Q
	VrFi6FVuVkXCsEFqmJ/n2kuwGeci5+KQ++cVSbjz32pV3DJsYcecPBkqyP4cGgxjBHS3SD85ohD
	rCIdpH6Fsx+cwPMMd95KEvaGlVDTj0CObzKbMu28QBYusnWh3V4sst7UuoGuZhpq4bZ6tL4uGeW
	4DC8T0YZXCJqBeKUD+nUWiY6WZ6fw4ardlI1AcQ8O3rhgDfGeGs/P2ZfAVRHkiT8nigl5homa0G
	Imdp47jlevth9Mlg7Hpkja1MN5sNcCL0661SXwlczrNLZARln//J6Mco4FbRnvxZzNaf0R9a/yd
	ECN2BHiBamEpdtdtGAX7XVMg=
X-Google-Smtp-Source: AGHT+IGwnsHGoTEF36DNx0bi9pP5C3qLTJN8aWKybY8GjA5dzUGvhydp49hCKJAV3bbgCbTLgP8UfA==
X-Received: by 2002:a05:6a21:3514:b0:21f:54e0:b09a with SMTP id adf61e73a8af0-21fbd524f49mr34825970637.15.1750347379081;
        Thu, 19 Jun 2025 08:36:19 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([131.107.1.253])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7490a46b574sm162838b3a.15.2025.06.19.08.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 08:36:18 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 5/7] cifs: minor cleanup to remove unused permission bit macros
Date: Thu, 19 Jun 2025 21:05:36 +0530
Message-ID: <20250619153538.1600500-5-bharathsm@microsoft.com>
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

Dropped READ_BIT, WRITE_BIT, EXEC_BIT, UBITSHIFT,
and GBITSHIFT from cifsacl.h as they are unused

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/cifsacl.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/smb/client/cifsacl.h b/fs/smb/client/cifsacl.h
index 31b51a8fc256..3d828f655e97 100644
--- a/fs/smb/client/cifsacl.h
+++ b/fs/smb/client/cifsacl.h
@@ -11,17 +11,10 @@
 
 #include "../common/smbacl.h"
 
-#define READ_BIT        0x4
-#define WRITE_BIT       0x2
-#define EXEC_BIT        0x1
-
 #define ACL_OWNER_MASK 0700
 #define ACL_GROUP_MASK 0070
 #define ACL_EVERYONE_MASK 0007
 
-#define UBITSHIFT	6
-#define GBITSHIFT	3
-
 /*
  * Security Descriptor length containing DACL with 3 ACEs (one each for
  * owner, group and world).
-- 
2.43.0

