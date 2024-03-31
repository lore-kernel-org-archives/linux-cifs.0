Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8E0286AC
	for <linux-cifs@vger.kernel.org>; Sun, 31 Mar 2024 13:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711890959; cv=none; b=SsvO+m0yrWF2ZBb591i2RmOyY1bEQY0k6gzMnsJdPGDowkzi+R6oUvKh6LjiKcpMR+T9x9NKibqd5HEEUhqqRTFX/KaK+qV8Jwyq6Xv0UqD9DS7Fqcd8ttK9VVo+0fyZJXj4azLdM5HXYOZoI6U/dyQjGc+vrseoN3JekN0m2CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711890959; c=relaxed/simple;
	bh=L7Vi+vmkHsVjFZafkNNAMR+3kGCT2NYbNKE8+JARxO4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pG2r+u1A6NrHFQoEugEWJtb35hhTOXdkMWxs5s48Rvt7G6y/KUSbJRta4p8NDeW5gugIDthXdKzpl+DKW0A7t8Wnn/xKbyFQBQG1O3IrfNtHo0dOOQyNERLi+YmJziTC+mU96Y62QeRJG/QQnPJ3lXQ1004MPfLoAm4549DRf00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6eaf1005fcaso828459b3a.3
        for <linux-cifs@vger.kernel.org>; Sun, 31 Mar 2024 06:15:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711890957; x=1712495757;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8ZeJ7nzf10aNJzIrt1wR2zBdwW9hfoCqnnSg7ncILNQ=;
        b=LI6iYxVZz/+U4t6/NDsLyckI/r5ZEDU7wdqGiTYFC/uxIPDtSGm6LRdGRZ91qqbYGz
         2pMNTBNkftnmsVa2AMy88eP+qaajx3DdHyMt/3BZmfanYqLdKBsEzfNpbyaJiD+IPyZD
         6S0mv/Nd8w0E8GbQn1Ql8/l6A0tztcJ5fkNYaul3k+f9zxtzEGKf5esfwGTw3WDg7GIg
         LBJVzwob7blTQJf3CyrQBa7pxmtDjBQQcfn0PQmOmFZPfpcs0WSeTYEP0A+T0pabX2Q4
         9jRO8+vwiRV54AhjIrAF5kXa5K5OH9+oVCfV9oHiTeeryF0fsUzTxhVnBLbO7P3bj5OX
         OYvA==
X-Gm-Message-State: AOJu0YyIKbIXSeT7hNqS5GfMEMeUruHfezYg6YenSlPHk/ot10P/yLRS
	u/5x6IMlyoTj0MbeQW/ty52Ruh0OZoFjeuxeuN6wSPyuysBxK6Z7OLbeadiM
X-Google-Smtp-Source: AGHT+IFQHe8J+wSWtxGPpS68IXx9VkdlUJw1VRO7jW9z6PnDoFn0Z0d35kmAzlBJouqkLWyMwcLdaw==
X-Received: by 2002:a05:6a00:27a2:b0:6e6:9f47:c18c with SMTP id bd34-20020a056a0027a200b006e69f47c18cmr7330755pfb.33.1711890957469;
        Sun, 31 Mar 2024 06:15:57 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id w25-20020aa78599000000b006e6b7124b33sm6008163pfn.209.2024.03.31.06.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 06:15:57 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: don't send oplock break if rename fails
Date: Sun, 31 Mar 2024 22:15:07 +0900
Message-Id: <20240331131507.3790-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't send oplock break if rename fails. This patch fix
smb2.oplock.batch20 test.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d478fa0c57ab..5723bbf372d7 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5857,8 +5857,9 @@ static int smb2_rename(struct ksmbd_work *work,
 	if (!file_info->ReplaceIfExists)
 		flags = RENAME_NOREPLACE;
 
-	smb_break_all_levII_oplock(work, fp, 0);
 	rc = ksmbd_vfs_rename(work, &fp->filp->f_path, new_name, flags);
+	if (!rc)
+		smb_break_all_levII_oplock(work, fp, 0);
 out:
 	kfree(new_name);
 	return rc;
-- 
2.25.1

