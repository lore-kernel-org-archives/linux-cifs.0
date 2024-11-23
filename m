Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95FC2F5A
	for <linux-cifs@vger.kernel.org>; Sat, 23 Nov 2024 04:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732335446; cv=none; b=sCQVYYJPsdgOtXJfMIpRFdIX0AMu91oRQ71Klegkd4g1yM+Jw/IHx5lt7rJoxQk7UntyaRrgceBYHanR/bzEsT9o5//E1oBARofgDbDuhctoYygAZvAq6WSbjp1o5LnRImEA/hFe8zaDDv2BGWfhsTiWd3JnbAnUyZWx+UYFvAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732335446; c=relaxed/simple;
	bh=OVGa41fGC0RZtW/fUXZ9eBmZ0e5m2vXqqjXUJ4oxsEk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r+bFtW60j6/ifMXOdk11EMCSmxVnJWkWu4AECvXe2o+yCLOmrBZite2yzUkngZAY6b20y9R0fCMy2XRqJc09F9GahLNeVAKBi5jk5VZ0xBUXSyPxyG363QgIgPD1rU4im2HYA5J8oSiVfBf8U6UN4zj/fCcwOUc8SZMax/GE97w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-724e1742d0dso1182186b3a.0
        for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 20:17:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732335444; x=1732940244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NziKJ2J4D43hAPGo5p0SxCr0jjWsG8QFtHi747tQkck=;
        b=hCXhRHLfyEFv3EsV1YU0+zRPeryAHxyS0Zx19PuRThrFz0KyNLXDMDwqY/VJNZKGpa
         yre9H+l6ldMk0HPA4l9wQ/mXvwsCEIlJrugqtd9W4vjPjEvH3W6caYwmP/xISQIiwo30
         T7hdY4U6BhPRJyB9uZd/2zVWySEIiJ410rymF/fKbYu3lcMg2bIuTgd3UA9mc7mYYYFN
         0argO+HE2RE9l9t8vGDfGv+99QoI+ZK/P1rqA1TvbbvDrcPcW5aCqN6yCGMafJH8L/c/
         Ti/CLBPqTbor+/JQnmpXCxTl6xe5Z3FOGXQsXtNC98GPFdjMfRtb1l2ZFDtLzHUvCDsz
         UExw==
X-Gm-Message-State: AOJu0YyP7XnC3m18nDN0iL1F20uhz9BtiTCBYKi7zhMDyYRH7zlMU/l0
	H6rnhZ7Bjd5eJm2fanRPJ9JGkGA+B/a+1bL8XYx7YHvSZjELaqSg2v9OAw==
X-Gm-Gg: ASbGncu9Lo9+TAXB91rZavUqjDUuRI3sj91egW7LgOgpOAaMuXaf1VldlYpMRxiwmDm
	V9+RQHFdSymYDfP+4zgIOTfPcflKOvd3egjgb0/yNJlzwm/+MbjoJRNpW5dBFw9Ak6smy/D0f1Z
	+jxj9yWuygFPHv3W6t//eZOoBT8Ov24pkikR6gPXnozuORyeVlZP3r2yC2EuIuw/i3eIlb3+5dk
	i4gxx/owg7uIbIK/DwCuf5Zw0tYZnu34Rh0Zxa2Kv/NPXLuo4SmxNcfU8sfjo2g
X-Google-Smtp-Source: AGHT+IGAdPLnByu5PqgS9aouWk29qKXkLc00aX/egJ0IA66VBFvtg4AoeALDXyaLIbsj+WqFuqEPQA==
X-Received: by 2002:a17:903:40c6:b0:202:13ca:d73e with SMTP id d9443c01a7336-2129f2484ccmr68949585ad.28.1732335443985;
        Fri, 22 Nov 2024 20:17:23 -0800 (PST)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2129dba20e2sm24437805ad.94.2024.11.22.20.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 20:17:23 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/6] ksmbd: add debug print for rdma capable
Date: Sat, 23 Nov 2024 13:17:02 +0900
Message-Id: <20241123041706.4943-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241123041706.4943-1-linkinjeon@kernel.org>
References: <20241123041706.4943-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add debug print to know if netdevice is RDMA-capable network adapter.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/transport_rdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 7c5a0d712873..0ef3c9f0bfeb 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -2289,6 +2289,9 @@ bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
 		}
 	}
 
+	ksmbd_debug(RDMA, "netdev(%s) rdma capable : %s\n",
+		    netdev->name, rdma_capable ? "true" : "false");
+
 	return rdma_capable;
 }
 
-- 
2.25.1

