Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E15926E165
	for <linux-cifs@vger.kernel.org>; Tue,  9 Dec 2025 01:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765242720; cv=none; b=hTdQrwsDKS28I6LdF5TQ3arnEWsYJr1yV0uEw8sf7JfX6xU8H0kiL4Aa3vAIltnH/A8yNI6b6x0A7uGsee+WFkebUz/mdD5cn0WlGU/2e5JIvqs2E0eqLEUrTPdG2q+lJlLEV7UiDzA5h2WkhBcoXgVgT/qw9FCLJAJRQGzTDRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765242720; c=relaxed/simple;
	bh=q+3A6UcMYwiG1oU5JG3Bny1Y2ZhwFXsi8GqMUnhJh7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9en6FdaZYZBKbSril9X7Iz6ewA3wbHiwEMllcH84j6kK7ztSIPpYDpnQczZu3SibSwyBINvVjwiHl38EXISA2W7B9MjU/h3U1K+9/KvYfwCSxOzkJVPpKpYlFMWB/rHNsXiSwqnVS8N9qk9Bq9KC+Fu52eb0sexG2qTdTVfWXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Pdjeoycy; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Pdjeoycy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765242716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L30H4KQFksRe1Z6wNqKA0RhWV6mhXfzg5BAblqU0YV0=;
	b=PdjeoycytavoXO00Hwtf4gvY2oAlL/ZCIL/tq0OrtOXbd7b3yj9+z0ERIUFUu7vyVnMtFM
	kbQLLXVqW9qSfWZhbETjsmOWBMESjUIyEE1V+bLh0evsXi1ZKof+gx0gLPZPSYMJ134iKF
	18UeCyz7jAa09X6mn1PTmXYrX0oPHHQ=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 05/13] smb: move File Attributes definitions into common/fscc.h
Date: Tue,  9 Dec 2025 09:10:11 +0800
Message-ID: <20251209011020.3270989-6-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

These definitions are specified in MS-FSCC 2.6, so move them into fscc.h.

Modify the following places:

  - FILE_ATTRIBUTE__MASK -> FILE_ATTRIBUTE_MASK
  - cpu_to_le32(constant) -> cpu_to_le32(MACRO DEFINITION)

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/common/fscc.h    | 38 ++++++++++++++++++++++++++++++++++++++
 fs/smb/common/smb2pdu.h | 35 -----------------------------------
 2 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index b8e7bb5ddfdd..5bf6c82e27f7 100644
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
@@ -144,6 +144,44 @@ typedef struct {
 	__le32 DeviceCharacteristics;
 } __packed FILE_SYSTEM_DEVICE_INFO; /* device info level 0x104 */
 
+/*
+ * File Attributes
+ * See MS-FSCC 2.6
+ */
+#define FILE_ATTRIBUTE_READONLY			0x00000001
+#define FILE_ATTRIBUTE_HIDDEN			0x00000002
+#define FILE_ATTRIBUTE_SYSTEM			0x00000004
+#define FILE_ATTRIBUTE_DIRECTORY		0x00000010
+#define FILE_ATTRIBUTE_ARCHIVE			0x00000020
+#define FILE_ATTRIBUTE_NORMAL			0x00000080
+#define FILE_ATTRIBUTE_TEMPORARY		0x00000100
+#define FILE_ATTRIBUTE_SPARSE_FILE		0x00000200
+#define FILE_ATTRIBUTE_REPARSE_POINT		0x00000400
+#define FILE_ATTRIBUTE_COMPRESSED		0x00000800
+#define FILE_ATTRIBUTE_OFFLINE			0x00001000
+#define FILE_ATTRIBUTE_NOT_CONTENT_INDEXED	0x00002000
+#define FILE_ATTRIBUTE_ENCRYPTED		0x00004000
+#define FILE_ATTRIBUTE_INTEGRITY_STREAM		0x00008000
+#define FILE_ATTRIBUTE_NO_SCRUB_DATA		0x00020000
+#define FILE_ATTRIBUTE_MASK			0x00007FB7
+
+#define FILE_ATTRIBUTE_READONLY_LE		cpu_to_le32(FILE_ATTRIBUTE_READONLY)
+#define FILE_ATTRIBUTE_HIDDEN_LE		cpu_to_le32(FILE_ATTRIBUTE_HIDDEN)
+#define FILE_ATTRIBUTE_SYSTEM_LE		cpu_to_le32(FILE_ATTRIBUTE_SYSTEM)
+#define FILE_ATTRIBUTE_DIRECTORY_LE		cpu_to_le32(FILE_ATTRIBUTE_DIRECTORY)
+#define FILE_ATTRIBUTE_ARCHIVE_LE		cpu_to_le32(FILE_ATTRIBUTE_ARCHIVE)
+#define FILE_ATTRIBUTE_NORMAL_LE		cpu_to_le32(FILE_ATTRIBUTE_NORMAL)
+#define FILE_ATTRIBUTE_TEMPORARY_LE		cpu_to_le32(FILE_ATTRIBUTE_TEMPORARY)
+#define FILE_ATTRIBUTE_SPARSE_FILE_LE		cpu_to_le32(FILE_ATTRIBUTE_SPARSE_FILE)
+#define FILE_ATTRIBUTE_REPARSE_POINT_LE		cpu_to_le32(FILE_ATTRIBUTE_REPARSE_POINT)
+#define FILE_ATTRIBUTE_COMPRESSED_LE		cpu_to_le32(FILE_ATTRIBUTE_COMPRESSED)
+#define FILE_ATTRIBUTE_OFFLINE_LE		cpu_to_le32(FILE_ATTRIBUTE_OFFLINE)
+#define FILE_ATTRIBUTE_NOT_CONTENT_INDEXED_LE	cpu_to_le32(FILE_ATTRIBUTE_NOT_CONTENT_INDEXED)
+#define FILE_ATTRIBUTE_ENCRYPTED_LE		cpu_to_le32(FILE_ATTRIBUTE_ENCRYPTED)
+#define FILE_ATTRIBUTE_INTEGRITY_STREAM_LE	cpu_to_le32(FILE_ATTRIBUTE_INTEGRITY_STREAM)
+#define FILE_ATTRIBUTE_NO_SCRUB_DATA_LE		cpu_to_le32(FILE_ATTRIBUTE_NO_SCRUB_DATA)
+#define FILE_ATTRIBUTE_MASK_LE			cpu_to_le32(FILE_ATTRIBUTE_MASK)
+
 /*
  * Response contains array of the following structures
  * See MS-FSCC 2.7.1
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index ddb0609bc186..87a92cd00282 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1072,41 +1072,6 @@ struct smb2_server_client_notification {
 #define IL_IMPERSONATION	cpu_to_le32(0x00000002)
 #define IL_DELEGATE		cpu_to_le32(0x00000003)
 
-/* File Attributes */
-#define FILE_ATTRIBUTE_READONLY			0x00000001
-#define FILE_ATTRIBUTE_HIDDEN			0x00000002
-#define FILE_ATTRIBUTE_SYSTEM			0x00000004
-#define FILE_ATTRIBUTE_DIRECTORY		0x00000010
-#define FILE_ATTRIBUTE_ARCHIVE			0x00000020
-#define FILE_ATTRIBUTE_NORMAL			0x00000080
-#define FILE_ATTRIBUTE_TEMPORARY		0x00000100
-#define FILE_ATTRIBUTE_SPARSE_FILE		0x00000200
-#define FILE_ATTRIBUTE_REPARSE_POINT		0x00000400
-#define FILE_ATTRIBUTE_COMPRESSED		0x00000800
-#define FILE_ATTRIBUTE_OFFLINE			0x00001000
-#define FILE_ATTRIBUTE_NOT_CONTENT_INDEXED	0x00002000
-#define FILE_ATTRIBUTE_ENCRYPTED		0x00004000
-#define FILE_ATTRIBUTE_INTEGRITY_STREAM		0x00008000
-#define FILE_ATTRIBUTE_NO_SCRUB_DATA		0x00020000
-#define FILE_ATTRIBUTE__MASK			0x00007FB7
-
-#define FILE_ATTRIBUTE_READONLY_LE              cpu_to_le32(0x00000001)
-#define FILE_ATTRIBUTE_HIDDEN_LE		cpu_to_le32(0x00000002)
-#define FILE_ATTRIBUTE_SYSTEM_LE		cpu_to_le32(0x00000004)
-#define FILE_ATTRIBUTE_DIRECTORY_LE		cpu_to_le32(0x00000010)
-#define FILE_ATTRIBUTE_ARCHIVE_LE		cpu_to_le32(0x00000020)
-#define FILE_ATTRIBUTE_NORMAL_LE		cpu_to_le32(0x00000080)
-#define FILE_ATTRIBUTE_TEMPORARY_LE		cpu_to_le32(0x00000100)
-#define FILE_ATTRIBUTE_SPARSE_FILE_LE		cpu_to_le32(0x00000200)
-#define FILE_ATTRIBUTE_REPARSE_POINT_LE		cpu_to_le32(0x00000400)
-#define FILE_ATTRIBUTE_COMPRESSED_LE		cpu_to_le32(0x00000800)
-#define FILE_ATTRIBUTE_OFFLINE_LE		cpu_to_le32(0x00001000)
-#define FILE_ATTRIBUTE_NOT_CONTENT_INDEXED_LE	cpu_to_le32(0x00002000)
-#define FILE_ATTRIBUTE_ENCRYPTED_LE		cpu_to_le32(0x00004000)
-#define FILE_ATTRIBUTE_INTEGRITY_STREAM_LE	cpu_to_le32(0x00008000)
-#define FILE_ATTRIBUTE_NO_SCRUB_DATA_LE		cpu_to_le32(0x00020000)
-#define FILE_ATTRIBUTE_MASK_LE			cpu_to_le32(0x00007FB7)
-
 /* Desired Access Flags */
 #define FILE_READ_DATA_LE		cpu_to_le32(0x00000001)
 #define FILE_LIST_DIRECTORY_LE		cpu_to_le32(0x00000001)
-- 
2.43.0

