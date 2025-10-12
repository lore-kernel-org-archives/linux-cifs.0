Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DB72ECEAC;
	Sun, 12 Oct 2025 16:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760286078; cv=none; b=mtEw9JeA3j0eCSF7gR7GpkzIFG7OeChmoR5znjpVnspJRjptfvwrsTQgXvLnhvQczKyTfmfGe3/8XQ/CitphY40LWM9PfNkSO/lC/IxV2aWjXXNOv9mHBvFCOerBUfdgkZXrIOcbKaA7pHMPGJHoB86SU0Pb6+Wsk3CRs70UUG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760286078; c=relaxed/simple;
	bh=KmGhgnmR0m6tPFO5dxwalQMc+FUg7axJAvjjwY79eSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAK89ujpMH2aByhndcPYO1TBg7D5wQjcn3F47Pe1t03mzUDrgNeDkVyiBnYwsplzRqAPgFgpWqprMaqY3FavtP2KIh0rM0rTLRpRE6fJJHGo0WBc/ky8QByPl8AdMF5WjgN2IZE38QLczMlP7Zy1SQMjLnAzmqySwCLDL0dE2DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: esmtpgz15t1760285929t289b3b83
X-QQ-Originating-IP: F0VIxI/Nc5rXr6OmviA91EoO8clNh19NouB5LYSCKMY=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 13 Oct 2025 00:18:48 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 14640092560663702799
From: chenxiaosong@chenxiaosong.com
To: stfrench@microsoft.com,
	metze@samba.org,
	pali@kernel.org,
	linkinjeon@kernel.org,
	smfrench@gmail.com,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	zhangguodong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 17/22] smb: move FILE_SYSTEM_INFO to common/cifspdu.h
Date: Mon, 13 Oct 2025 00:17:44 +0800
Message-ID: <98825614B51DB683+20251012161749.2994033-18-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
References: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: ONMinSPvVgZRaoZ5hBjc23AJsw3c7QzYyipsJSxRE+24kCWqDn1vhHuv
	WAP97j3YbYBob1Jw2z6AXyfmWDIeI/yzF0cwoUCGCHdBzIXOlaf6bBOcvNBzF3aK+1e85tV
	BM1lnvBItQGYMi5YzHkL6NuhpdhVukU+VSj5vpyAGyBIs75ggdTA+1svY5o6TtnE7QcGEfz
	bfe1jRII+dyZxsaxoV8DDOYjIanPtqKR7sWRA+NOWKXsD7AFq3SSb6Ql+MBtzLh64erEMJ8
	3hKwGhRUPSLwAokK+oYOdEgSRPcl3PDL3tBdo43T3mfTTAcTIFx92I3z1G5Q6NVsfPJsmSk
	FUOkhm4luO1rbt3UurEFuzQ1tCGku+YzXte2mmBofba2wQ2kJmAd+GeGfYSI7TJP2etfyEV
	7LIJZadXez74IbAAFFA42areGSu60PrTMWTrE494UlKuLMJHh34z1pn0oCVTA6oAL5sEvMA
	A5V+OZT9oKBTz/gP2zoL3s9dzZpCkFU6zSNxX84w6OCV4uD2fhR1xWxTQWmuswIeHvHtDY8
	Wu7YWT0EtOhvUvI/M39TJLIBsDLXecE7cyTeGz+D6sB1Gz4mBx4AALvvuEQ6lZlCrwxtpKa
	xtG8G7CNMwCEb6hX+siAAKAsfsJVFrl6yYxOY9XGpqm6bsgTMJlaMNfKdKdvW2d3juTeMUq
	jXMVPZTU/rXbc/k55KfCQlpJNsZl/1tFB7oZ6o+Y8dW95yUtOuG0Ps1ogjybfwqxDPyC655
	JEsAItbeBI8F1R3xz4BtSsYOtu10ThihjzecWC375G+4U5PLfZRZLIMGBx8GzbKJCloNw6j
	1F5HmcGDmwEE6LmRHmHfnIHhI1h8cUWtKWzFGE4xtU6XQQ+FaAAjG1g6pDkANoSV9G7PNdx
	KXI3aOkxtHto21eO4tZfW+kuUhtEUIRq3SmM1/t/UrZPVch5trvvtqXAftMACaOMnMuD9t4
	qeFcL579hUq6yBmQJJd+A1zPIza7BbMXnitHNCPbf5akyznmR2E0voTQSLMwaGufjaVPp8V
	IRoXcVohQqOhfsowAna9oEN/qyUX4tgmb2KBnImZr8I9d82jEVeIRXIcDKVVk0Nivk3GmeW
	QF5eyCWOWBK
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
X-QQ-RECHKSPAM: 0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Rename "struct filesystem_info" to "FILE_SYSTEM_INFO",
then move duplicate definitions to common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h    | 7 -------
 fs/smb/common/cifspdu.h    | 8 ++++++++
 fs/smb/server/smb2pdu.c    | 4 ++--
 fs/smb/server/smb_common.h | 7 -------
 4 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 17255d7a4615..889be409146c 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1819,13 +1819,6 @@ struct aliasInfo92 {
 	int shareNameOffset;
 } __attribute__((packed));
 
-typedef struct {
-	__le64 TotalAllocationUnits;
-	__le64 FreeAllocationUnits;
-	__le32 SectorsPerAllocationUnit;
-	__le32 BytesPerSector;
-} __attribute__((packed)) FILE_SYSTEM_INFO;	/* size info, level 0x103 */
-
 typedef struct {
 	__le32 fsid;
 	__le32 SectorsPerAllocationUnit;
diff --git a/fs/smb/common/cifspdu.h b/fs/smb/common/cifspdu.h
index 055c6577b4e9..548d621ec233 100644
--- a/fs/smb/common/cifspdu.h
+++ b/fs/smb/common/cifspdu.h
@@ -321,6 +321,14 @@ typedef struct server_negotiate_rsp {
 	__le16 ByteCount;
 } __attribute__((packed)) SERVER_NEGOTIATE_RSP;
 
+/* See MS-CIFS 2.2.8.2.4 */
+typedef struct {
+	__le64 TotalAllocationUnits;
+	__le64 FreeAllocationUnits;
+	__le32 SectorsPerAllocationUnit;
+	__le32 BytesPerSector;
+} __attribute__((packed)) FILE_SYSTEM_INFO;	/* size info, level 0x103 */
+
 /* See MS-CIFS 2.2.8.2.5 */
 typedef struct {
 	__le32 DeviceType;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 41167e7cca77..2ad46a11e7ef 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5539,9 +5539,9 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	}
 	case FS_SIZE_INFORMATION:
 	{
-		struct filesystem_info *info;
+		FILE_SYSTEM_INFO *info;
 
-		info = (struct filesystem_info *)(rsp->Buffer);
+		info = (FILE_SYSTEM_INFO *)(rsp->Buffer);
 		info->TotalAllocationUnits = cpu_to_le64(stfs.f_blocks);
 		info->FreeAllocationUnits = cpu_to_le64(stfs.f_bfree);
 		info->SectorsPerAllocationUnit = cpu_to_le32(1);
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 86d18a8badff..d6351b0ee62a 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -64,13 +64,6 @@ struct filesystem_vol_info {
 	__le16 VolumeLabel[];
 } __packed;
 
-struct filesystem_info {
-	__le64 TotalAllocationUnits;
-	__le64 FreeAllocationUnits;
-	__le32 SectorsPerAllocationUnit;
-	__le32 BytesPerSector;
-} __packed;     /* size info, level 0x103 */
-
 #define EXTENDED_INFO_MAGIC 0x43667364	/* Cfsd */
 #define STRING_LENGTH 28
 
-- 
2.43.0

