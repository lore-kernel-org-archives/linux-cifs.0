Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8677112FB26
	for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2024 14:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718028884; cv=none; b=kQXaU3DDE/GK8DQrMVi+1rxwRr0tBz/4buMybnyKOIkNVsGflC9iRKdQc2osqAlWRUZBFkdduzOey7R6BLJQ8Cy3D26Qxgr77jcGoxQbIGnKUwRtpT4ZC+Kb+JYL/qNe4/29upyPALcvindJh8jm23YwVoGs56NVvhq7NyOao14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718028884; c=relaxed/simple;
	bh=WOU8WAm1paImrxA+njZBmaVygDbovL8xVAnrTBYPctU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pnOjD537qZVF9BsG2AoecnP1SREyCow1VdeFf6uxEHTKOyk8S3PMJOs2h6IOrPwyA+UzTow28rB9SDsHYrmnmLUHBNvRaGgjBSQBXvKfjI7Jkyb5od3PyxWkNfEbMnHNiMIieiQhXaBFwKQ6AF1UIRjPs7iccgcubHKua8xkr90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7042ee09f04so1505765b3a.0
        for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2024 07:14:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718028883; x=1718633683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MikZfazFeCcUP/5PxxOGyn3aBhWL3zvNJMnzoA45MvU=;
        b=c2WyOGyydbfHreV/uuN1ssirRM2mLXV6rM9jl20sg5Y0PyYnVAFD9o/q25W8Bvbktn
         zQuQm8u7/3lLnRDfh8+WR9QfPsovNsFUVoX5hv05/z4N8PVFQD+OFjcEjSIpkmo44ZmC
         we80IqSmLVt8zahTqevRGMJtW1ZXUho/u6LtJAW061O97Ht4YQHxX+bJ8tMdPgpap2ro
         WDso5PxUyzbhcFk4Al5vh5P8KV0jhVaIHVG8uLe2ag/h6B7Ov+ROy9+gwcFOpff60Ifk
         jOOu0uFOV/3PyYrMdZTmv8r6/G3pcJZxYqRJrGAiqtV8TEciP4LAdAdIAS0qtW4gHpso
         tENg==
X-Gm-Message-State: AOJu0Yw3PRwyuka27dS7oxgTk/ob+km8lnT8Ih2ezR08UybqBC+eqmQH
	gYB20RNjvSPRJoQD/QOa13qFk7hO78uh9B9ZHSmAcdys8MsnLmFsL10wSw==
X-Google-Smtp-Source: AGHT+IFfxAcJDYtw0h0wsct6zTaffllrN99MCdKJfBSfUXSY+c2wjVyWCvP7OR/BETMtRRg5J5JcIA==
X-Received: by 2002:a05:6a20:9190:b0:1b7:d72e:9e5e with SMTP id adf61e73a8af0-1b7d72ea074mr1895680637.37.1718028882656;
        Mon, 10 Jun 2024 07:14:42 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70419a36c16sm5144392b3a.175.2024.06.10.07.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jun 2024 07:14:42 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 3/3] ksmbd: move leading slash check to smb2_get_name()
Date: Mon, 10 Jun 2024 23:14:15 +0900
Message-Id: <20240610141416.8039-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240610141416.8039-1-linkinjeon@kernel.org>
References: <20240610141416.8039-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If the directory name in the root of the share starts with
character like 镜(0x955c) or Ṝ(0x1e5c), it (and anything inside)
cannot be accessed. The leading slash check must be checked after
converting unicode to nls string.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 4fb5070d3dc5..8bcede718c21 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -630,6 +630,12 @@ smb2_get_name(const char *src, const int maxlen, struct nls_table *local_nls)
 		return name;
 	}
 
+	if (*name == '\\') {
+		pr_err("not allow directory name included leading slash\n");
+		kfree(name);
+		return ERR_PTR(-EINVAL);
+	}
+
 	ksmbd_conv_path_to_unix(name);
 	ksmbd_strip_last_slash(name);
 	return name;
@@ -2842,20 +2848,11 @@ int smb2_open(struct ksmbd_work *work)
 	}
 
 	if (req->NameLength) {
-		if ((req->CreateOptions & FILE_DIRECTORY_FILE_LE) &&
-		    *(char *)req->Buffer == '\\') {
-			pr_err("not allow directory name included leading slash\n");
-			rc = -EINVAL;
-			goto err_out2;
-		}
-
 		name = smb2_get_name((char *)req + le16_to_cpu(req->NameOffset),
 				     le16_to_cpu(req->NameLength),
 				     work->conn->local_nls);
 		if (IS_ERR(name)) {
 			rc = PTR_ERR(name);
-			if (rc != -ENOMEM)
-				rc = -ENOENT;
 			name = NULL;
 			goto err_out2;
 		}
-- 
2.25.1

