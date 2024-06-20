Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BCD1A4F10;
	Thu, 20 Jun 2024 09:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718876297; cv=none; b=YZXt0XrMpj2wo07TWxxDsXxHaB/vMTiBPEsM7svVJF+5nq+/pYzoi9T7YcP6wDTslc91OCXsX46tdCve/WgjEUXdGE+7F42RmwHDTZlfqpL8AAHGbQNHnlLfZNDh6MMe1eN0xUnqnBh/0B/Rxc6U1TSQC4GDKA35JkOYcI/FDdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718876297; c=relaxed/simple;
	bh=nJL1SqhjYpLebdbXExj1KgXzim2ykZocWJT8nCDQj7o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZlxhDrK4rYXNwatBYwmKH0lO74AjpnYKYEJJkl9SkB8IY0GhKNkG3uJK8YzjCBqbPKp+y5P/N97IwQ95GF0qIvHZmeSqOndTDEoe2sYkGDJJkVISFGrzFm38A0N/42jLw9SHP88HxPfxpmQQNBzyFqbfVkfr7t7s47FsMxVM230=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=none smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtpsz1t1718876154t163eys
X-QQ-Originating-IP: bXkB+u3bl5/bDBD/+ypvVtgCtjv+IJgQvIuxistfPFI=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 20 Jun 2024 17:35:25 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 18176064105314108534
From: chenxiaosong@chenxiaosong.com
To: linkinjeon@kernel.org,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com
Cc: chenxiaosong@kylinos.cn,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: [PATCH 1/2] smb/client: fix typo to STATUS_MCA_OCCURRED
Date: Thu, 20 Jun 2024 09:34:35 +0000
Message-Id: <20240620093436.411889-2-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240620093436.411889-1-chenxiaosong@chenxiaosong.com>
References: <20240620093436.411889-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Preparation for moving the SMB2 Status code definitions to a common
header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
---
 fs/smb/client/smb2maperror.c | 2 +-
 fs/smb/client/smb2status.h   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index ac1895358908..3ac17d43bb7d 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -1096,7 +1096,7 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	"STATUS_MOUNT_POINT_NOT_RESOLVED"},
 	{STATUS_INVALID_DEVICE_OBJECT_PARAMETER, -EIO,
 	"STATUS_INVALID_DEVICE_OBJECT_PARAMETER"},
-	{STATUS_MCA_OCCURED, -EIO, "STATUS_MCA_OCCURED"},
+	{STATUS_MCA_OCCURRED, -EIO, "STATUS_MCA_OCCURRED"},
 	{STATUS_DRIVER_BLOCKED_CRITICAL, -EIO,
 	"STATUS_DRIVER_BLOCKED_CRITICAL"},
 	{STATUS_DRIVER_BLOCKED, -EIO, "STATUS_DRIVER_BLOCKED"},
diff --git a/fs/smb/client/smb2status.h b/fs/smb/client/smb2status.h
index 9c6d79b0bd49..15364c4328ec 100644
--- a/fs/smb/client/smb2status.h
+++ b/fs/smb/client/smb2status.h
@@ -901,7 +901,7 @@ struct ntstatus {
 #define STATUS_DEVICE_ENUMERATION_ERROR cpu_to_le32(0xC0000366)
 #define STATUS_MOUNT_POINT_NOT_RESOLVED cpu_to_le32(0xC0000368)
 #define STATUS_INVALID_DEVICE_OBJECT_PARAMETER cpu_to_le32(0xC0000369)
-#define STATUS_MCA_OCCURED cpu_to_le32(0xC000036A)
+#define STATUS_MCA_OCCURRED cpu_to_le32(0xC000036A)
 #define STATUS_DRIVER_BLOCKED_CRITICAL cpu_to_le32(0xC000036B)
 #define STATUS_DRIVER_BLOCKED cpu_to_le32(0xC000036C)
 #define STATUS_DRIVER_DATABASE_ERROR cpu_to_le32(0xC000036D)
-- 
2.34.1

