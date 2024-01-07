Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C0F134A0
	for <linux-cifs@vger.kernel.org>; Sun,  7 Jan 2024 13:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1d420aaa2abso2874545ad.3
        for <linux-cifs@vger.kernel.org>; Sun, 07 Jan 2024 05:08:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704632906; x=1705237706;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZdCpcASKwIkHmmagRL+LPawJrdPIJ2zk7U+4kAwM7mY=;
        b=tM4+UW9QkEFu22qHohP3JjF3pdm/Or/ntS0rt8UNVoA26JPzx2PAyI0j5AI+huPhQm
         4clRzRW9mgs6ebGDoQh7GVSeiWhflJpBhP+/jgWPwkMm9xw/oAc3kKMa2+QoOzGsFvn9
         zDV7PZweuNmvlbCGt6v03AwTPOJT8+Z4+/+w2rwGtx+TnDWWOXMPXogcQ79AFR60tFcB
         fRNydw2T8sXAexZbUykjQKqHZThVIg/ovw1nfhPmC009dhaBxtbZjAI2+FjqbVWNwbVh
         4HQTXq/XWIJZmZoKZlKCdumJMeq6LKAaexkT07+t8HBwrlul/8xrbN/OOawirFKiPXja
         jYoQ==
X-Gm-Message-State: AOJu0YwDbTqe4UUmP0cg2j+oyX34pybLPU6pAeXeZ7LDwXVFRCRuJBFX
	OSQ2jQoMAZsFl/6dBoou2HyNhlNvMZM=
X-Google-Smtp-Source: AGHT+IH6m82p+yQPneb6YRcatlEHXBLII1wzfonUyIZaytW257mr0o4DUVbYk+iesbAqh6sLuL1m5A==
X-Received: by 2002:a17:902:9a4c:b0:1d4:c4e6:9267 with SMTP id x12-20020a1709029a4c00b001d4c4e69267mr621997plv.67.1704632905896;
        Sun, 07 Jan 2024 05:08:25 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id w14-20020a170902e88e00b001d04c097d32sm4394086plg.270.2024.01.07.05.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jan 2024 05:08:25 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/2] ksmbd: don't allow O_TRUNC open on read-only share
Date: Sun,  7 Jan 2024 22:08:13 +0900
Message-Id: <20240107130814.7247-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When file is changed using notepad on read-only share(read_only = yes in
ksmbd.conf), There is a problem where existing data is truncated.
notepad in windows try to O_TRUNC open(FILE_OVERWRITE_IF) and all data
in file is truncated. This patch don't allow  O_TRUNC open on read-only
share and add KSMBD_TREE_CONN_FLAG_WRITABLE check in smb2_set_info().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a2f729675183..2a335bfe25a4 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2972,7 +2972,7 @@ int smb2_open(struct ksmbd_work *work)
 					    &may_flags);
 
 	if (!test_tree_conn_flag(tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
-		if (open_flags & O_CREAT) {
+		if (open_flags & (O_CREAT | O_TRUNC)) {
 			ksmbd_debug(SMB,
 				    "User does not have write permission\n");
 			rc = -EACCES;
@@ -5944,12 +5944,6 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 	}
 	case FILE_RENAME_INFORMATION:
 	{
-		if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
-			ksmbd_debug(SMB,
-				    "User does not have write permission\n");
-			return -EACCES;
-		}
-
 		if (buf_len < sizeof(struct smb2_file_rename_info))
 			return -EINVAL;
 
@@ -5969,12 +5963,6 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 	}
 	case FILE_DISPOSITION_INFORMATION:
 	{
-		if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
-			ksmbd_debug(SMB,
-				    "User does not have write permission\n");
-			return -EACCES;
-		}
-
 		if (buf_len < sizeof(struct smb2_file_disposition_info))
 			return -EINVAL;
 
@@ -6036,7 +6024,7 @@ int smb2_set_info(struct ksmbd_work *work)
 {
 	struct smb2_set_info_req *req;
 	struct smb2_set_info_rsp *rsp;
-	struct ksmbd_file *fp;
+	struct ksmbd_file *fp = NULL;
 	int rc = 0;
 	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 
@@ -6056,6 +6044,13 @@ int smb2_set_info(struct ksmbd_work *work)
 		rsp = smb2_get_msg(work->response_buf);
 	}
 
+	if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
+		ksmbd_debug(SMB, "User does not have write permission\n");
+		pr_err("User does not have write permission\n");
+		rc = -EACCES;
+		goto err_out;
+	}
+
 	if (!has_file_id(id)) {
 		id = req->VolatileFileId;
 		pid = req->PersistentFileId;
-- 
2.25.1

