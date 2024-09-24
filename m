Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43ECA1EB31
	for <linux-cifs@vger.kernel.org>; Tue, 24 Sep 2024 13:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727185739; cv=none; b=geBavT7LGh8Unn3CgvHsgpMchnCQ9K8i35NntJAx5pQCCzxFnkElMfZZffyaMnEjqnt2Jtkd6g2uB8yTgwA3kLrNeEpSo1l6vZ0bQsaYG6buu5DGbq0eL/SfBB9GpiUf6Pmf/LirTC9eoZ48Fme6q7eETIGwLQesDK41RP0Bxgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727185739; c=relaxed/simple;
	bh=2L+njEY5CBLtFYn30949P6k7SUh3wDwhQfATafiiXx4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DiRklhm2F0ye/r72KyjbaSUnoFh7w02bv0AeYX6cyeGnhiu5rNv3SyeAj44tbKpDn6OEC00+P0R+3WYfWYBsZGC2JoN3cdMq/I+kEBxdXIEb1cJ5VpZsTTqhTRyxLhj1R7DipQflSJhBxIfSgtTZIYPmHpYb7EokbLRrS/bjNKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-71781f42f75so5135430b3a.1
        for <linux-cifs@vger.kernel.org>; Tue, 24 Sep 2024 06:48:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727185737; x=1727790537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FIyjUixNRS8LcxXM6eZywTvc2L/zsZvUErcqz0RrfWU=;
        b=lX+xkJClq+jIr3VE+l3yMCPB0J7153AKEauRmlNvhPScV9nhkurZDIRHbQTxeRipqo
         b1ciU4M/xnvFR646fpW20/kF4KBGXG0Sz8amcm66jfAsBZsYMED2ck9rZI+MaWsX+OmS
         FP2TBTZL0CE3gH/EbOv68Mn92wH6fIf8Uvh1mPbjWUEPsv+0YfXYPj+t4P71ec7tk8rZ
         FxxHOte5lsYnDesreBDuXdTcF9Ut7V4HxUR4uGLpRpjgv1euaVs1IrTxRgKjpU93WKe3
         /aoE0Qk0UKA6rWDZweSz7PL8Q1wfUVdQASfMbjNK23rz0XrULEW5PjAytCOnjYConV5A
         9EuA==
X-Gm-Message-State: AOJu0Yxe0sPj992UZOUAFwoFuUcorfDz0xnLGw31BFn+dV8fUzlNQIZC
	1otuLneXqLJZOhKmkG6nn0Om6cDE/6cHceADtBl7F4FW1HqRmoEJJP03pA==
X-Google-Smtp-Source: AGHT+IEh/7LdAmjlPmdw0jkBKzuNiQDfbgP7gmYf4pWxVHA3WwTr1QKK0cCxGoFA39Z4m68B72fgQQ==
X-Received: by 2002:a05:6a20:d80a:b0:1cf:2218:1be6 with SMTP id adf61e73a8af0-1d30cb75ae6mr16842275637.50.1727185737422;
        Tue, 24 Sep 2024 06:48:57 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e058ee3cd8sm1535532a91.2.2024.09.24.06.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 06:48:57 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: fix open failure from block and char device file
Date: Tue, 24 Sep 2024 22:48:18 +0900
Message-Id: <20240924134818.15552-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240924134818.15552-1-linkinjeon@kernel.org>
References: <20240924134818.15552-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

char/block device file can't be opened with dentry_open() if device driver
is not loaded. Use O_PATH flags for fake openning file to handle it if file
is a block or char file.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 72af3ab40b5c..7460089c186f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2052,18 +2052,20 @@ int smb2_tree_connect(struct ksmbd_work *work)
  * @access:		file access flags
  * @disposition:	file disposition flags
  * @may_flags:		set with MAY_ flags
- * @is_dir:		is creating open flags for directory
+ * @coptions:		file creation options
+ * @mode:		file mode
  *
  * Return:      file open flags
  */
 static int smb2_create_open_flags(bool file_present, __le32 access,
 				  __le32 disposition,
 				  int *may_flags,
-				  bool is_dir)
+				  __le32 coptions,
+				  umode_t mode)
 {
 	int oflags = O_NONBLOCK | O_LARGEFILE;
 
-	if (is_dir) {
+	if (coptions & FILE_DIRECTORY_FILE_LE || S_ISDIR(mode)) {
 		access &= ~FILE_WRITE_DESIRE_ACCESS_LE;
 		ksmbd_debug(SMB, "Discard write access to a directory\n");
 	}
@@ -2080,7 +2082,7 @@ static int smb2_create_open_flags(bool file_present, __le32 access,
 		*may_flags = MAY_OPEN | MAY_READ;
 	}
 
-	if (access == FILE_READ_ATTRIBUTES_LE)
+	if (access == FILE_READ_ATTRIBUTES_LE || S_ISBLK(mode) || S_ISCHR(mode))
 		oflags |= O_PATH;
 
 	if (file_present) {
@@ -3175,8 +3177,8 @@ int smb2_open(struct ksmbd_work *work)
 	open_flags = smb2_create_open_flags(file_present, daccess,
 					    req->CreateDisposition,
 					    &may_flags,
-		req->CreateOptions & FILE_DIRECTORY_FILE_LE ||
-		(file_present && S_ISDIR(d_inode(path.dentry)->i_mode)));
+					    req->CreateOptions,
+					    file_present ? d_inode(path.dentry)->i_mode : 0);
 
 	if (!test_tree_conn_flag(tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
 		if (open_flags & (O_CREAT | O_TRUNC)) {
-- 
2.25.1

