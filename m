Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F6A16F271;
	Thu, 22 Aug 2024 08:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724315121; cv=none; b=hV92Wa5eYlwEj8emUCYdmLL+mrhjYIuqzjGw7tK1ydQqYBuF4o5NI3l6+N7FpD5YkKxI6Yvo91tQqOk521h+5s+2EOIZBs19M8iteXl+0yrPSTi0Ivc1gOV28jpT4+QJNj+opvsmmIzeXFqomQ6xi3k9mMrvVLsIa/BYjNeLeww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724315121; c=relaxed/simple;
	bh=UqMz90SMB+B/iWHCTMwCu01DOmAehuGURx5l95yYUo4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rVMa8San8YFX7N3XJ1rS3tFrw4fgbbJw3RB5/H73utKjbvGN8yx3Pn8lkqGhivKpbWrN3Gxj0BO8sOkyrv9IntHP6ZUUt1kyBLOFfpwyc5vGmz9ApkrRd9UZSEUj+3HkSw8OYIBAe4pj/hVm0lkGnXgqzcylITpljY0TATMHQhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=none smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtp78t1724314980tzmk46zg
X-QQ-Originating-IP: uO/tLQ9Ai+GDR5RkfhLgv7YYOlIYwHwfnj6CfOu8s1U=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 22 Aug 2024 16:22:57 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 9458377168774231472
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
	chenxiaosong@chenxiaosong.com
Subject: [PATCH v2 12/12] smb: add comment to STATUS_MCA_OCCURED
Date: Thu, 22 Aug 2024 08:21:01 +0000
Message-Id: <20240822082101.391272-13-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com>
References: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Explained why the typo was not corrected.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/common/smb2status.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/common/smb2status.h b/fs/smb/common/smb2status.h
index 841d4c688411..14b4a5f04564 100644
--- a/fs/smb/common/smb2status.h
+++ b/fs/smb/common/smb2status.h
@@ -901,6 +901,10 @@ struct ntstatus {
 #define STATUS_DEVICE_ENUMERATION_ERROR cpu_to_le32(0xC0000366)
 #define STATUS_MOUNT_POINT_NOT_RESOLVED cpu_to_le32(0xC0000368)
 #define STATUS_INVALID_DEVICE_OBJECT_PARAMETER cpu_to_le32(0xC0000369)
+/*
+ * 'OCCURED' is typo in MS-ERREF, it should be 'OCCURRED',
+ * but we'll keep it consistent with MS-ERREF.
+ */
 #define STATUS_MCA_OCCURED cpu_to_le32(0xC000036A)
 #define STATUS_DRIVER_BLOCKED_CRITICAL cpu_to_le32(0xC000036B)
 #define STATUS_DRIVER_BLOCKED cpu_to_le32(0xC000036C)
-- 
2.34.1

