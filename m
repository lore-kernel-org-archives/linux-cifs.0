Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B1A2327A3
	for <linux-cifs@vger.kernel.org>; Thu, 11 Dec 2025 14:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765463629; cv=none; b=YAH0R6tqNvr97b1RFq0gRSzIRldv8Ahw/uEaY1xxh6syfGB5T55GAb55eBbybbr1FvaTB2ZIp7u+YCTPKLwINaupqMffjnz/viHWb8VaVAO/KueNmCB2qP2BVuOo/ldriUfsbkRDfMMt+GIAlFhoHhm55qvr+sDcLFgjpMKnHbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765463629; c=relaxed/simple;
	bh=V1dQNpvB8QULXgKO1a90mjb19MSMVIDA9UVK+sU17i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBjDIChsYICCEw57b6UPYFP67LBUvijbwb2RWBZAsydMT7QocVr5DwqyTcIhozrpld7pgCJKl7Nvq7JjcIlv57c1OpcZ7+D2/Z42fkZS/ADCEPsHKpTIR1CrCNxjRM/7j58edNH2hkrPPVkINLVSnKf6gaSCERq0NTf8iPrw+Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A/ohpxx4; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A/ohpxx4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765463624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3jRLKjrZkWjztC29/ONl+he+kaGJLo7VeXksJ1WZvJA=;
	b=A/ohpxx4Bwf8k3bRXSjnxYRw/jWiZDo294s7+HQDSsC83w5CK6Y7A1+hHYo4UhhFZKGHuh
	hPEquXKLv+MmkAu1NUUwzg+FBOmoH1M8Pz7+IjvbuvcvbY7vFcMgg2Cqy7K5jDbbSb3a0I
	ASdSPPPs3LPmR3eN357c+fNfgu1Jb4A=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 1/7] smb: move File Attributes definitions into common/fscc.h
Date: Thu, 11 Dec 2025 22:32:22 +0800
Message-ID: <20251211143228.172470-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251211143228.172470-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251211143228.172470-1-chenxiaosong.chenxiaosong@linux.dev>
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
  - Update FILE_ATTRIBUTE_MASK value
  - cpu_to_le32(constant) -> cpu_to_le32(MACRO DEFINITION)

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/fscc.h    | 45 +++++++++++++++++++++++++++++++++++++++++
 fs/smb/common/smb2pdu.h | 35 --------------------------------
 2 files changed, 45 insertions(+), 35 deletions(-)

diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index b8e7bb5ddfdd..0123f34db1e8 100644
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
@@ -144,6 +144,51 @@ typedef struct {
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
+#define FILE_ATTRIBUTE_MASK (FILE_ATTRIBUTE_READONLY | FILE_ATTRIBUTE_HIDDEN | \
+		FILE_ATTRIBUTE_SYSTEM | FILE_ATTRIBUTE_DIRECTORY | \
+		FILE_ATTRIBUTE_ARCHIVE | FILE_ATTRIBUTE_NORMAL | \
+		FILE_ATTRIBUTE_TEMPORARY | FILE_ATTRIBUTE_SPARSE_FILE | \
+		FILE_ATTRIBUTE_REPARSE_POINT | FILE_ATTRIBUTE_COMPRESSED | \
+		FILE_ATTRIBUTE_OFFLINE | FILE_ATTRIBUTE_NOT_CONTENT_INDEXED | \
+		FILE_ATTRIBUTE_ENCRYPTED | FILE_ATTRIBUTE_INTEGRITY_STREAM | \
+		FILE_ATTRIBUTE_NO_SCRUB_DATA)
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
index 950aadade401..5372a820118e 100644
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

