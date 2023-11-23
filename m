Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296DFD4F
	for <linux-cifs@vger.kernel.org>; Thu, 23 Nov 2023 00:46:00 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1cf678043fdso5232645ad.2
        for <linux-cifs@vger.kernel.org>; Thu, 23 Nov 2023 00:46:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700729159; x=1701333959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MSn04Pvm66akm/LaEQHSNsLd/1J8GZULhZPLHhsS/+Q=;
        b=fhirjYxiEsTefDGF1RWy94DbvQRfclDgQU9BBOOlD/tpKkq3x2JGxtG/8CgjBXCYED
         ipHMKBPlsHCpXf3qCguOJyyfvgBfj2LU2FvTEfchxvFRT+x7j6099InU4AiO8wvkI1qg
         n239lgQdrYu5qon7ZBFUhFidU051IpGQlV5aTvEjey4/QFLqwQnqIK0WQonLPltlxe4s
         M4zn+g96R3vFFMdmOD4HGRYu0hojdIdDsLcWSDNrvDo1lzaaWo35CAaVSg4iexRoa6o9
         oa6TIaHdCo+B44OpWEKpqJLt3emLHC9b7P/5PHETn9p8O4VE/AA3xDxKwgaxGXszcFc6
         Usqg==
X-Gm-Message-State: AOJu0Yzq/6m/P4Cz6sovvwoqtvFgimeUj3EiLxqNNHSJ/S3GBcg84LLB
	V2X0fRhcj31WDrmitn7udAC30PKMz8A=
X-Google-Smtp-Source: AGHT+IGBx56qZ8Qpe4pUWDMcP5EK3Jm9OYhlTdkD+k9TkGoGFwa+AW6xNdPijHw3+0nyqaBR4Os/ow==
X-Received: by 2002:a17:902:ec8e:b0:1cf:82de:4dfe with SMTP id x14-20020a170902ec8e00b001cf82de4dfemr2927697plg.21.1700729159194;
        Thu, 23 Nov 2023 00:45:59 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id n14-20020a170902e54e00b001bc675068e2sm810208plf.111.2023.11.23.00.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Nov 2023 00:45:58 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5/6] ksmbd: move setting SMB2_FLAGS_ASYNC_COMMAND and AsyncId
Date: Thu, 23 Nov 2023 17:45:06 +0900
Message-Id: <20231123084507.35584-5-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231123084507.35584-1-linkinjeon@kernel.org>
References: <20231123084507.35584-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Directly set SMB2_FLAGS_ASYNC_COMMAND flags and AsyncId in smb2 header of
interim response instead of current response header.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8cc01c3a763b..427dd2295f16 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -657,13 +657,9 @@ smb2_get_name(const char *src, const int maxlen, struct nls_table *local_nls)
 
 int setup_async_work(struct ksmbd_work *work, void (*fn)(void **), void **arg)
 {
-	struct smb2_hdr *rsp_hdr;
 	struct ksmbd_conn *conn = work->conn;
 	int id;
 
-	rsp_hdr = ksmbd_resp_buf_next(work);
-	rsp_hdr->Flags |= SMB2_FLAGS_ASYNC_COMMAND;
-
 	id = ksmbd_acquire_async_msg_id(&conn->async_ida);
 	if (id < 0) {
 		pr_err("Failed to alloc async message id\n");
@@ -671,7 +667,6 @@ int setup_async_work(struct ksmbd_work *work, void (*fn)(void **), void **arg)
 	}
 	work->asynchronous = true;
 	work->async_id = id;
-	rsp_hdr->Id.AsyncId = cpu_to_le64(id);
 
 	ksmbd_debug(SMB,
 		    "Send interim Response to inform async request id : %d\n",
@@ -723,6 +718,8 @@ void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 	       __SMB2_HEADER_STRUCTURE_SIZE);
 
 	rsp_hdr = smb2_get_msg(in_work->response_buf);
+	rsp_hdr->Flags |= SMB2_FLAGS_ASYNC_COMMAND;
+	rsp_hdr->Id.AsyncId = cpu_to_le64(work->async_id);
 	smb2_set_err_rsp(in_work);
 	rsp_hdr->Status = status;
 
-- 
2.25.1

