Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343124414
	for <linux-cifs@vger.kernel.org>; Fri, 12 Apr 2024 01:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712883885; cv=none; b=dpsTjDikoGMNcVGBnDruu+mUfbT5eKA80mzXoNsmkIVRbwrApowmn2KZaO7RbsUUS6rzZWhbhAFMNN8GAI6hjr0ZvRUf3X/cfqRKu56TjRoxscySi9up0ZlGsDJdlmeGmGge0EJgaTZqFkcvdz/wMon0anv7BHNaLxY6/yBchzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712883885; c=relaxed/simple;
	bh=M3DgiqP77+Qc9TCZQBcTp2J4iW6Pr/spmScYplcw+l0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cu2mIib27l1Wok6oWjCaAwlQDtmmZt7CAVL/2Adp0Mh9pDcy1LV9jWSjdK9eLP2PrA78FmEiqQO+IKlID7bS38bMyKs0yqOjGoxh1G/FYNBJJcx/YQEDgBCT30S+2IgZ5SXFWscbFSTHosmMJPPWM3VmgRlq5Wiu7ciASNLRz9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6ecee5c08e6so458042b3a.3
        for <linux-cifs@vger.kernel.org>; Thu, 11 Apr 2024 18:04:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712883883; x=1713488683;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ps4Z7+BHCzwOciSa1BfW5EoXU4l3akJRaQNB10fqG6c=;
        b=hPg1EAU15FNxvOqpzOSL++OyaZSghneJPcm6kA5WmlHSGrwqefy8P+INMCRjfOyD4W
         epmuuBVRlNk7+QN5FXnT4YATjzo8svNaNxWnG3xd28LWEoxcy2FfU6gKes6HjqZLVVAn
         WckFujvKqy6AcKdxP5Sp0VIvvR9GCyZVv+lxUv1a4jpyro76cLoG1GijQ4hPNBm0uaJZ
         Eztk8rgmfNQG8GWZmWeqhYieTpyMBB9BCM/o110X5RrmgDbkKmfY+CBfLSOkE8XHnTB0
         lzsUkgKCMfZp08eHpdw1VNNP+IltfG99TJBuXGn3wKXPZ1Xvhevk2AYb+TZXE37Sc//i
         pfNw==
X-Gm-Message-State: AOJu0YwuPIdCmgN/IrYgwqHjincA3dePQF78LUyePls0RRqBpYve0/44
	+QScRC9nwzVfeQ82JNt8cDIAgVPkmcrnRVQDp972GzKz51Rri67jmgnlMg==
X-Google-Smtp-Source: AGHT+IF9DxSfhdwEJtQ1Lyyq4zEIm96Yn92KqYraLgi5fKvrs/5D+xL3tuKSPZaQW2Wew+8wwLKnNQ==
X-Received: by 2002:a05:6a00:124e:b0:6e6:b4f3:19dc with SMTP id u14-20020a056a00124e00b006e6b4f319dcmr1451440pfi.7.1712883883129;
        Thu, 11 Apr 2024 18:04:43 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id s9-20020a056a00178900b006e6a684a6ddsm1755330pfg.220.2024.04.11.18.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 18:04:42 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: don't grant a persistent handle if the share is not continuous availability
Date: Fri, 12 Apr 2024 10:04:04 +0900
Message-Id: <20240412010404.4096-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If capabilities of the share is not SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY,
ksmbd should not grant a persistent handle to the client.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/mgmt/tree_connect.h | 1 +
 fs/smb/server/smb2pdu.c           | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/mgmt/tree_connect.h b/fs/smb/server/mgmt/tree_connect.h
index 6377a70b811c..27de34200c83 100644
--- a/fs/smb/server/mgmt/tree_connect.h
+++ b/fs/smb/server/mgmt/tree_connect.h
@@ -34,6 +34,7 @@ struct ksmbd_tree_connect {
 	atomic_t			refcount;
 	wait_queue_head_t		refcount_q;
 	unsigned int			t_state;
+	unsigned int			t_cap;
 };
 
 struct ksmbd_tree_conn_status {
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5723bbf372d7..1f1f06c5174e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3498,7 +3498,8 @@ int smb2_open(struct ksmbd_work *work)
 	memcpy(fp->client_guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
 
 	if (dh_info.type == DURABLE_REQ_V2 || dh_info.type == DURABLE_REQ) {
-		if (dh_info.type == DURABLE_REQ_V2 && dh_info.persistent)
+		if (dh_info.type == DURABLE_REQ_V2 && dh_info.persistent &&
+		    tcon->t_cap & SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY)
 			fp->is_persistent = true;
 		else
 			fp->is_durable = true;
-- 
2.25.1

