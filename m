Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE357CF39
	for <linux-cifs@vger.kernel.org>; Tue, 21 May 2024 13:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716299904; cv=none; b=sLyYmiDNo0H4JP/EsYq2fiFQQUG/Ynt2l1+G49zCJ9l2t3Hu+NxTxbpR4k3XIr1bLtCJicrQQcn92aepGvODf0qITRXHvp3CZ9B3GPPPj0vZKQAFlTHKE/bzD5uU1FF3y0vS2vSKbP1D+PnBAWYRhb/4+V+xvMHDbtZ4xChMwho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716299904; c=relaxed/simple;
	bh=sxypidAh07N80PAqjVcFf6bncu8VEjW2XRAKIPR58Jg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Rt+i6ikfoDaguCDlhKCyj99LhlZv5SeLNhuQL+2pYBmhuVsxssegYO+ViJxSY40MpOd5aPgfr0HAugK77lpDVOvnU466FosMnnSO7FidhLWPL9MCR4+vaNf9i0XyuHuJ1++IKcaAIgKi8itiwbaabRrQ4Os66UyZWfBXMJpLVfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1f082d92864so104778605ad.1
        for <linux-cifs@vger.kernel.org>; Tue, 21 May 2024 06:58:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716299902; x=1716904702;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tMmlNgQ03r50DOf/E/bzZooE0MwVPRkltwV2KX9dfpI=;
        b=OZrJJvsyttJ1mVhI1KMsEk/DxCzuA6QR7NjdtqCJgco5WkSVlv1kHUZ8zipZL9Rqn0
         STeHTcjbLzeyuReYuBhTz7X7s7T/iZwiyJZ/i+wwANoS8rBZgrA8F3dT9FBoTYVnxB23
         gCoINdmF7TIMvbjyqknsEBDdF5ZTqILSnB3utypyXW/LAiT/1zh3aagYUXY7vg1Nsgdm
         zPlxgjr9VaVOUNjySnrvqzZwmfxwArhcg/p3q6T2OF/joK5adk8/0r6eMxWBlnpAgFFC
         9XEP7QlOKekcCK/FI52cUSBu8PMY+9TW5YrbmOLGWp/bD7Up8aD0BKyfp+5G0H7OjyxU
         1zTw==
X-Gm-Message-State: AOJu0Ywq5/9JTYss6wm+GhOzsKb61uq9g/cY8JhPmCaVvTFFSYxmiBJo
	TR5QTZc5PXA+ndT83CNEbyvzwFlJ2DSbK4ZXKGiNr3EnwYJmpZjePTpbTg==
X-Google-Smtp-Source: AGHT+IF/gw/Ay/oUemCGKH3yjSZxpy0u0Om1aswwQdwl8nulBbnTRkAHNghiuMVaUEBEuqi+F6FSkA==
X-Received: by 2002:a17:902:ce8f:b0:1f2:fb21:a6b4 with SMTP id d9443c01a7336-1f2fb21a775mr76571945ad.9.1716299901837;
        Tue, 21 May 2024 06:58:21 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f30358e6d2sm34204015ad.93.2024.05.21.06.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 May 2024 06:58:21 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/2] ksmbd: avoid reclaiming expired durable opens by the client
Date: Tue, 21 May 2024 22:57:52 +0900
Message-Id: <20240521135753.5108-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The expired durable opens should not be reclaimed by client.
This patch add ->durable_scavenger_timeout to fp and check it in
ksmbd_lookup_durable_fd().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/vfs_cache.c | 9 ++++++++-
 fs/smb/server/vfs_cache.h | 1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 6cb599cd287e..a6804545db28 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -476,7 +476,10 @@ struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id)
 	struct ksmbd_file *fp;
 
 	fp = __ksmbd_lookup_fd(&global_ft, id);
-	if (fp && fp->conn) {
+	if (fp && (fp->conn ||
+		   (fp->durable_scavenger_timeout &&
+		    (fp->durable_scavenger_timeout <
+		     jiffies_to_msecs(jiffies))))) {
 		ksmbd_put_durable_fd(fp);
 		fp = NULL;
 	}
@@ -717,6 +720,10 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 	fp->tcon = NULL;
 	fp->volatile_id = KSMBD_NO_FID;
 
+	if (fp->durable_timeout)
+		fp->durable_scavenger_timeout =
+			jiffies_to_msecs(jiffies) + fp->durable_timeout;
+
 	return true;
 }
 
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 5a225e7055f1..f2ab1514e81a 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -101,6 +101,7 @@ struct ksmbd_file {
 	struct list_head		lock_list;
 
 	int				durable_timeout;
+	int				durable_scavenger_timeout;
 
 	/* if ls is happening on directory, below is valid*/
 	struct ksmbd_readdir_data	readdir_data;
-- 
2.25.1

