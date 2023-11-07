Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703042E65B
	for <linux-cifs@vger.kernel.org>; Tue,  7 Nov 2023 12:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6C82132
	for <linux-cifs@vger.kernel.org>; Tue,  7 Nov 2023 04:15:09 -0800 (PST)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1cc316ccc38so45259065ad.1
        for <linux-cifs@vger.kernel.org>; Tue, 07 Nov 2023 04:15:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699359308; x=1699964108;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eHzglpxbhlPs0CKHvUlpVJtcQz9YBhJmcqXLWVibJdM=;
        b=PnFfNWyEqG12t0AR/z3L7Sizz7vAiSMzqSWTkGizMN+FCy3qB8HCRF0uFpwphNu6XX
         ZYV++Ls+9TUcDg+YL/MTnbZ+F0hRieLKaNVL9b+0Ck6RI3ZkHhh9bttHgdniusrqQeom
         NNeEswF5n6kzEZrhQK/0i52+21T4VkuXdIojW2EFFXbHpoRrlPtnugzy0LejkJN4vHJ2
         5wJ/LprzNG/hG2jGSh8S4qasNGPajB8p5OpmODTmHCYXPPU1yOWYSYyABoXcAlbQFlrr
         P7L+OfvZfSxOb8Kx0drQ4czemcdJVRi5ON2NTN7Xi+Fbq4NF1dUDROkXbgzW+Q+wd2e9
         JAjQ==
X-Gm-Message-State: AOJu0YxW0sG7GV7cF7jOcx9Zz9xxVz8ZnQ4NakRkFoINshfw99uQULrm
	r1up8Sdgl0zMaNp2eIGklU8FKy2QKuY=
X-Google-Smtp-Source: AGHT+IET8YOMhzKyMJUOKwmyJKefbBcn9ZMe+VM/9SM9yNaCpagu0fMTNz6rIeJ0yYucdprQk1Q2uA==
X-Received: by 2002:a17:902:f94f:b0:1cc:3b87:8997 with SMTP id kx15-20020a170902f94f00b001cc3b878997mr22490823plb.57.1699359307743;
        Tue, 07 Nov 2023 04:15:07 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id a11-20020a170902eccb00b001b7cbc5871csm7527264plh.53.2023.11.07.04.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 04:15:07 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	Robert Morris <rtm@csail.mit.edu>
Subject: [PATCH] ksmbd: handle malformed smb1 message
Date: Tue,  7 Nov 2023 21:14:44 +0900
Message-Id: <20231107121444.9529-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If set_smb1_rsp_status() is not implemented, It will cause NULL pointer
dereferece error when client send malformed smb1 message.
This patch add set_smb1_rsp_status() to ignore malformed smb1 message.

Reported-by: Robert Morris <rtm@csail.mit.edu>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb_common.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index e6ba1e9b8589..edc619807308 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -366,11 +366,22 @@ static int smb1_allocate_rsp_buf(struct ksmbd_work *work)
 	return 0;
 }
 
+/**
+ * set_smb1_rsp_status() - set error type in smb response header
+ * @work:	smb work containing smb response header
+ * @err:	error code to set in response
+ */
+void set_smb1_rsp_status(struct ksmbd_work *work, __le32 err)
+{
+	work->send_no_response = 1;
+}
+
 static struct smb_version_ops smb1_server_ops = {
 	.get_cmd_val = get_smb1_cmd_val,
 	.init_rsp_hdr = init_smb1_rsp_hdr,
 	.allocate_rsp_buf = smb1_allocate_rsp_buf,
 	.check_user_session = smb1_check_user_session,
+	.set_rsp_status = set_smb1_rsp_status,
 };
 
 static int smb1_negotiate(struct ksmbd_work *work)
-- 
2.25.1

