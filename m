Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041661DF977
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jan 2025 08:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736239438; cv=none; b=hQ64/muh0eGuKfh99ti1N+Tr9HzWbKi3mg7cA2n1r+Ror3Vd6iIAah6xvC8XyPWQ2A3RcPtr0Vy87YO1BiTcpT+u50wUAMtbeXJHNJ6qXgFdXbXx9kW86rWit4RqRsfPVdQTbVWyyLUWrvD649UFaiwU3i5HW219sk6hQeooMMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736239438; c=relaxed/simple;
	bh=IYwdwibadM7VlHwqfr/Uk6NgPr2bsk59YVbRCRaxfm0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uQXEWl5rStV+4kEqf+NFUx3CGNSsPFjKHGd6P5OFYycvr8Y2N5DEUTsDD3gEkjSb6GXfs0r4pfbrt2KO3oo3aoJKoOtEt8wTYh/28pl3kqCZ4o4em5tKfawHr0dI5EYokiKG9pMAyzkXh4oX378aD+NggGSjufwq+HxnFoT5yiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2163dc5155fso218938525ad.0
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jan 2025 00:43:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736239435; x=1736844235;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wo1aR7rA15bz/O2u46fOmObDL0sJFBvb/qAqPhG4bE4=;
        b=OcQVeyTpERGoZsr7m4DzAz72VKKmEOBITANC9GzkoYNdkfU79AHKubhvCg+3nFCN9S
         fEtUwGRwmf/ksxWlKpBSKPRkyAb8UtNSCM2ryzt/5HKfeUtp5zzwEQbPPpYKtRCADTKj
         RFH+V4r0VavDWcomCcqTYCdYUz9H/QWboGy87KPYqTc88iMXdbfTt9rNy2oO3M9b9/f9
         eXr33luuRBNn8gvkMKPc02P4du+2p7uLPywbyD6AMR2Y+Go68xc61rzIxTXSLLinEY5a
         I87+NAliUbsVQL5Lb/k89+0zhpammn2LVCZM9rp/bQ8pKT4pchwQnSIbjyTzgecR1Yzm
         FGAQ==
X-Gm-Message-State: AOJu0YypB/XwZ6bDKbFfX9/OVXboSXSk3/JYLXgWGeodIUa229mf8mdb
	+6hdfn3jFuO4hCB2uFTGB2hToGFkWtlgL732BfD/CgQkO6dfF/FGj6aMsA==
X-Gm-Gg: ASbGncsUHPdrq5XGLDK6QnR5uIW450oA4ckqAvzrmj7H4iYNnvybWSDX9dwWAUuNns5
	mlPb2y4amjPdHpUw7IOMBBT3YSrYkgCjGnhFL0kc4iU2L6bDw/qV0tVw84P9sWAOP9XLrLmFgSj
	+dVKciM7snusJZIU7L+KCwEDdEgNlzG4jm38vP/xPjn+4O7vjF7XJsVfed6yquwur51/we+Wlwt
	mEBXqsthyABkbYnmGU1Zjt129EpsgNYdOzwDx76Th3yxJ29T+CUyB8ehCYqFnk6EB3J8Ps=
X-Google-Smtp-Source: AGHT+IHSGV/k7+ylEOZI3tDZ9pYRubvOKGuXSKLmsNkFe8sUh06yC+KgbWi2m+YlcVX9jsI1lwTETA==
X-Received: by 2002:a17:902:ef09:b0:215:a028:4ed with SMTP id d9443c01a7336-219e6ea26d4mr850745025ad.20.1736239434853;
        Tue, 07 Jan 2025 00:43:54 -0800 (PST)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dca04f46sm305449565ad.263.2025.01.07.00.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 00:43:54 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: Implement new SMB3 POSIX type
Date: Tue,  7 Jan 2025 17:43:35 +0900
Message-Id: <20250107084335.6733-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As SMB3 posix extension specification, Give posix file type to posix
mode.

https://www.samba.org/~slow/SMB3_POSIX/fscc_posix_extensions.html#posix-file-type-definition
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 40 ++++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smb2pdu.h | 10 ++++++++++
 2 files changed, 50 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 433e33c04039..772deec5b90f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3994,6 +3994,26 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 		posix_info->DeviceId = cpu_to_le32(ksmbd_kstat->kstat->rdev);
 		posix_info->HardLinks = cpu_to_le32(ksmbd_kstat->kstat->nlink);
 		posix_info->Mode = cpu_to_le32(ksmbd_kstat->kstat->mode & 0777);
+		switch (ksmbd_kstat->kstat->mode & S_IFMT) {
+		case S_IFDIR:
+			posix_info->Mode |= cpu_to_le32(POSIX_TYPE_DIR << POSIX_FILETYPE_SHIFT);
+			break;
+		case S_IFLNK:
+			posix_info->Mode |= cpu_to_le32(POSIX_TYPE_SYMLINK << POSIX_FILETYPE_SHIFT);
+			break;
+		case S_IFCHR:
+			posix_info->Mode |= cpu_to_le32(POSIX_TYPE_CHARDEV << POSIX_FILETYPE_SHIFT);
+			break;
+		case S_IFBLK:
+			posix_info->Mode |= cpu_to_le32(POSIX_TYPE_BLKDEV << POSIX_FILETYPE_SHIFT);
+			break;
+		case S_IFIFO:
+			posix_info->Mode |= cpu_to_le32(POSIX_TYPE_FIFO << POSIX_FILETYPE_SHIFT);
+			break;
+		case S_IFSOCK:
+			posix_info->Mode |= cpu_to_le32(POSIX_TYPE_SOCKET << POSIX_FILETYPE_SHIFT);
+		}
+
 		posix_info->Inode = cpu_to_le64(ksmbd_kstat->kstat->ino);
 		posix_info->DosAttributes =
 			S_ISDIR(ksmbd_kstat->kstat->mode) ?
@@ -5184,6 +5204,26 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 	file_info->AllocationSize = cpu_to_le64(stat.blocks << 9);
 	file_info->HardLinks = cpu_to_le32(stat.nlink);
 	file_info->Mode = cpu_to_le32(stat.mode & 0777);
+	switch (stat.mode & S_IFMT) {
+	case S_IFDIR:
+		file_info->Mode |= cpu_to_le32(POSIX_TYPE_DIR << POSIX_FILETYPE_SHIFT);
+		break;
+	case S_IFLNK:
+		file_info->Mode |= cpu_to_le32(POSIX_TYPE_SYMLINK << POSIX_FILETYPE_SHIFT);
+		break;
+	case S_IFCHR:
+		file_info->Mode |= cpu_to_le32(POSIX_TYPE_CHARDEV << POSIX_FILETYPE_SHIFT);
+		break;
+	case S_IFBLK:
+		file_info->Mode |= cpu_to_le32(POSIX_TYPE_BLKDEV << POSIX_FILETYPE_SHIFT);
+		break;
+	case S_IFIFO:
+		file_info->Mode |= cpu_to_le32(POSIX_TYPE_FIFO << POSIX_FILETYPE_SHIFT);
+		break;
+	case S_IFSOCK:
+		file_info->Mode |= cpu_to_le32(POSIX_TYPE_SOCKET << POSIX_FILETYPE_SHIFT);
+	}
+
 	file_info->DeviceId = cpu_to_le32(stat.rdev);
 
 	/*
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 649dacf7e8c4..17a0b18a8406 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -502,4 +502,14 @@ static inline void *smb2_get_msg(void *buf)
 	return buf + 4;
 }
 
+#define POSIX_TYPE_FILE		0
+#define POSIX_TYPE_DIR		1
+#define POSIX_TYPE_SYMLINK	2
+#define POSIX_TYPE_CHARDEV	3
+#define POSIX_TYPE_BLKDEV	4
+#define POSIX_TYPE_FIFO		5
+#define POSIX_TYPE_SOCKET	6
+
+#define POSIX_FILETYPE_SHIFT	12
+
 #endif	/* _SMB2PDU_H */
-- 
2.25.1

