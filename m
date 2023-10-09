Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96181E95A91
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Oct 2023 15:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376412AbjJIPM3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Oct 2023 11:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376438AbjJIPM2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Oct 2023 11:12:28 -0400
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18F9DA
        for <linux-cifs@vger.kernel.org>; Mon,  9 Oct 2023 08:12:22 -0700 (PDT)
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-58d261807e8so969619a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 09 Oct 2023 08:12:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696864342; x=1697469142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7wKQEsfuaUwEjy905nKuj/4SxmvwufkLX4YvzHqkqLQ=;
        b=XJNcF/w0MagdfovZiRx8AmAdIxH25Lyy4jdQfKS5ifQX2lgTGpC+69xCLIJj7zDjcA
         pV01BqdfhHpS1QgS3TdzMQilUhlfEUiJflpD+hUhb26B5Cno1lrYaOTXspdofcL3etrU
         5A0qy82L8CWJfezyT+J5QKevWlaUmCPbNchCsdmSMai+OghNv4JJ7ZOhA39VG5CDbZt/
         2+FCSMDgtpLHkzM+sHr2a+aK91wg8GUXoZeDCCL3nGj6udUt7lCfdk8bfj+aprzE1D9G
         6LVZRGFp8xIrnMq0Hx/vBTJy52Ifn4Ue/BIjFGiecbLBng45arnTnILQk1vuupQZxBF8
         HMhQ==
X-Gm-Message-State: AOJu0Yxmt1lJwvjgmkCkFCywKNYEp7lh5WbDdxvtYmlAlpULWwYh8m86
        hB4IlP/nJeUoa+rwQkF/9t6hF6HV2J8=
X-Google-Smtp-Source: AGHT+IGTfcMhVHnQjL+HltrL+BdbcIxYm4n0uIHmbbfO+iSMVf4nkGvFTWkV3MPXk4NK/OKi7MBN7A==
X-Received: by 2002:a17:90a:fa89:b0:273:ef1b:5a2 with SMTP id cu9-20020a17090afa8900b00273ef1b05a2mr12640520pjb.47.1696864341739;
        Mon, 09 Oct 2023 08:12:21 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id mp3-20020a17090b190300b00267d9f4d340sm10529284pjb.44.2023.10.09.08.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Oct 2023 08:12:21 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        hyc.lee@gmail.com, atteh.mailbox@gmail.com,
        Namjae Jeon <linkinjeon@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] ksmbd: fix kernel-doc comment of ksmbd_vfs_setxattr()
Date:   Tue, 10 Oct 2023 00:11:53 +0900
Message-Id: <20231009151153.7360-4-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231009151153.7360-1-linkinjeon@kernel.org>
References: <20231009151153.7360-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix argument list that the kdoc format and script verified in
ksmbd_vfs_setxattr().

fs/smb/server/vfs.c:929: warning: Function parameter or member 'path'
not described in 'ksmbd_vfs_setxattr'

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index b5a5e50fc9ca..2e37939a8ba0 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -919,7 +919,7 @@ ssize_t ksmbd_vfs_getxattr(struct mnt_idmap *idmap,
 /**
  * ksmbd_vfs_setxattr() - vfs helper for smb set extended attributes value
  * @idmap:	idmap of the relevant mount
- * @dentry:	dentry to set XATTR at
+ * @path:	path of dentry to set XATTR at
  * @attr_name:	xattr name for setxattr
  * @attr_value:	xattr value to set
  * @attr_size:	size of xattr value
-- 
2.25.1

