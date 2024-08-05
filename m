Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBE81E49F
	for <linux-cifs@vger.kernel.org>; Mon,  5 Aug 2024 13:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722863417; cv=none; b=E+1KSDvpEBQc439FCfEjI889UpaBrd8K8aycwco739h02Ti4F21kfy3xDbLU8wUNONP5HAR0mVij9hI0dfn4cUIyRjvH80nHNfG9+KxbDEsc3EIOXxBtOoz8uUsCiMJsfqlSQ2QiRqlaH+yK4hjWcuRexxmvUJBrtGzHJphO2lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722863417; c=relaxed/simple;
	bh=DRClaTdYiByvrUblgQlNnzU4MbeM2NkRQSUeAB9WXkk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CA4C0f4Sv3EQlYrbKC5m7+1MFX+2aQA7tgIsIWw3bDWD+y8CxbSTyeFI16/4TKoZQjaBnCB8bQW9eqyJXZZissuN8xLtvIVGyS8qxQ/yWUs0QnlRD04owc3ul0WnZ55I1ydMf7VGO5GVkbAKbAI6CjP+8XGjBcc5AXNHwNBQ94I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-70d18112b60so4237650b3a.1
        for <linux-cifs@vger.kernel.org>; Mon, 05 Aug 2024 06:10:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722863415; x=1723468215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lcUWMtqQl8q2mBKwrfF19DQRldGR72ujoT40+y+yb6E=;
        b=mcRaGUrIT/QWrl0lXJ2QSLOVacsojoPDEUZ4OjhSZJ5qhxnoeeaiuTuZ/UM97dB82y
         RaYVhN6oYdXp/fUcadhP06q4fUYBs756Uvhx9bTsVOWxvyMFmC651A0DYm26fvafIvXp
         GoSxc4MbWnkaPJm6aESyZRdIEzbmrHH7sc5qmoFdJxRbuM3tpHYw2ZzOM30jWbnQ/lqo
         srLCnl/PehE5mAG8aQSwxmE7gX5zfdqitnocZzmI27P5HaMb09n4fAt2KDS67vMwqCYf
         gO53SbyaPkhauMCXBo/MOruS4hz89sK4216UsvhtvcxF0t09fe31tWYk0hcwK4YQEUg5
         8l5Q==
X-Gm-Message-State: AOJu0YyjMAC6oGoI/iY9zIEqurtZZ9KocLTo8ahCQirNHywLNcz+blvA
	7/OJcT4HLkoO5ujnScu1Q3ii+lFlKcYcVxsFieK+oswFfqh3MFWSCfYBGw==
X-Google-Smtp-Source: AGHT+IHosVa0Vmb5I4nXqgS2NhoZmJWzpzJy+ehVtYz4yKfPe1fyOR8WDHiQwtKvtzBcykDIaasM5A==
X-Received: by 2002:a05:6a00:9463:b0:710:4e4c:a4ba with SMTP id d2e1a72fcca58-7106da92b84mr17398546b3a.13.1722863415335;
        Mon, 05 Aug 2024 06:10:15 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7106ec01098sm5362730b3a.40.2024.08.05.06.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Aug 2024 06:10:15 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sangsoo Lee <constant.lee@samsung.com>
Subject: [PATCH 2/2] ksmbd: override fsids for smb2_query_info()
Date: Mon,  5 Aug 2024 22:08:50 +0900
Message-Id: <20240805130850.3776-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240805130850.3776-1-linkinjeon@kernel.org>
References: <20240805130850.3776-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sangsoo reported that a DAC denial error occurred when accessing
files through the ksmbd thread. This patch override fsids for
smb2_query_info().

Reported-by: Sangsoo Lee <constant.lee@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 54154d36ea2f..2df1354288e6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5596,6 +5596,11 @@ int smb2_query_info(struct ksmbd_work *work)
 
 	ksmbd_debug(SMB, "GOT query info request\n");
 
+	if (ksmbd_override_fsids(work)) {
+		rc = -ENOMEM;
+		goto err_out;
+	}
+
 	switch (req->InfoType) {
 	case SMB2_O_INFO_FILE:
 		ksmbd_debug(SMB, "GOT SMB2_O_INFO_FILE\n");
@@ -5614,6 +5619,7 @@ int smb2_query_info(struct ksmbd_work *work)
 			    req->InfoType);
 		rc = -EOPNOTSUPP;
 	}
+	ksmbd_revert_fsids(work);
 
 	if (!rc) {
 		rsp->StructureSize = cpu_to_le16(9);
@@ -5623,6 +5629,7 @@ int smb2_query_info(struct ksmbd_work *work)
 					le32_to_cpu(rsp->OutputBufferLength));
 	}
 
+err_out:
 	if (rc < 0) {
 		if (rc == -EACCES)
 			rsp->hdr.Status = STATUS_ACCESS_DENIED;
-- 
2.25.1

