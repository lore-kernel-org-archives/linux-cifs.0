Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A448C1BC5C
	for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 06:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761547903; cv=none; b=DMOFl15uArlPbIaGEky++zvE5HnOHcxHPHEV7PDaYg5y+6jXT7aQyiAhpfHVhwWwketjhmghXCq2iFgnRNKc8/uj25TMg4I6IvZjevy4o1+CWOZilf96wwTYLelTRz0mpVRnPxicULGRlnVW2Obr6CYO+JHrSdHYx8Htnsbt47w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761547903; c=relaxed/simple;
	bh=7oHXmx/jOoET6sxfWPTGvP+yQJMuexbkaQxLYDygM/k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TmhU7hCRAlWvagDJQV69TjlJWBs9UZn8suMgzH6JHoov+Z3dpkfZ34OC3AcFNyUvtVSg9WXmHbpq/skhorpizf6Cds8z7aT4us2U+TOLiDdJW0HHaQSmrRq3MbUY8YlhnEyflxXNivlthaMeuizYDB/P8mkuD0gjO3nke4dsJys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2907948c1d2so44814395ad.3
        for <linux-cifs@vger.kernel.org>; Sun, 26 Oct 2025 23:51:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761547901; x=1762152701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pxomt948ypiNZD9UvyCtfKmMNXAlTIi49kx53gToDoI=;
        b=W/dwyVRf6QivcJXj+JX5x1kpKGTHE3QA+/Ifp3eIiCbdarDBcmS8H8kg+m1OVLQvfx
         GbvP1qzeGcqzaD4GPl8EFAbUe1pTJ5U2tmU4iwLQJQr28mcpKveJmyqJUainuk8pElI0
         mSswCDD+qY6OUOG19H9WP0q1FMAYVotrDTcbTPPf5/JV7/SgQ3amCd3klmQEk6gmACji
         zYaVRMwCGThiO50F6WPdWb28+vBU5jdiDh0APxG612PEpbbf3YQ7Xz8w4JPTS6Ux0Chn
         3JNIu1oRffic0cQmPIBgD51lyq/A4LjnyUSGHiypFEFPto0jSrGCf8LV1Tfrag9vyB6s
         B34Q==
X-Gm-Message-State: AOJu0YzVqVFY3ETR3+zH2UMET/GPgrF/O8iSpkN9VSZnFvn4FATYpG8j
	QAhdG67VRffbrZrKeW/GlOzqCLEsltKvMO3qBxOzL2OPwLjf4bdUT/8IJr368w==
X-Gm-Gg: ASbGncvWOqZfaqn8k4GqLgqoTQiepDP77LDI7staMbxmSQ1oV9T9tQjJn9oFuYnsTow
	Tn8Y6h56csxJwYBPP/BxSWUIJgVwa7hlB5UxKXP1kIXEr+SinMNwrIcsYnUnMmU0PJ7Ba/SsyNl
	9tFP/d3hJF1pk1mmKdzLjEm4VosZ8V0wvrTrbFC6X8hixRB6PINEYoD2ybgYTKKSdrm81V5R86v
	jwDEALVkjH2fUEoQNkgw+vAxKMB3CiuJ6/zDeMTjjpZooGYoeuo5hvyKRgZ0HAFzqZBXPFn2jUU
	Q2WD5aoIC/uzWN+p8tlrAF+rESpWAgYq9SmCk6ddfetLenKKcfYRopIg8RAaLzslO8GjGADTtIj
	ptKOvPmcqdVW/4DGS8Nxy5knimk6D5xLADMuFgNjGUQZSgkUJReaLwCArscrWeoeiq9vjy1Hzly
	b6wcwf/L8akvSSQpuvjY0j78LxuQ==
X-Google-Smtp-Source: AGHT+IEtsf3mByC4AAIlCz8IwYvxSm9gWnBeIk21H589D82E8BCULSOyFQUktyHIKk470x/t0QJtTQ==
X-Received: by 2002:a17:902:c402:b0:290:52aa:7291 with SMTP id d9443c01a7336-2946e26e98emr176517505ad.53.1761547901426;
        Sun, 26 Oct 2025 23:51:41 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d47ffesm71362095ad.87.2025.10.26.23.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Oct 2025 23:51:40 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 2/2] ksmbd: detect RDMA capable netdevs include IPoIB
Date: Mon, 27 Oct 2025 15:50:53 +0900
Message-Id: <20251027065102.12104-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251027065102.12104-1-linkinjeon@kernel.org>
References: <20251027065102.12104-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current ksmbd_rdma_capable_netdev fails to mark certain RDMA-capable
inerfaces such as IPoIB as RDMA capable after reverting GUID matching code
due to layer violation.
This patch check the ARPHRD_INFINIBAND type safely identifies an IPoIB
interface without introducing a layer violation, ensuring RDMA
functionality is correctly enabled for these interfaces.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 4a8aeb1df0cc..5d3b48e77012 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -2663,6 +2663,10 @@ bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
 			if (ksmbd_find_rdma_capable_netdev(lower_dev))
 				return true;
 
+	/* check if netdev is IPoIB safely without layer violation */
+	if (netdev->type == ARPHRD_INFINIBAND)
+		return true;
+
 	return false;
 }
 
-- 
2.25.1

