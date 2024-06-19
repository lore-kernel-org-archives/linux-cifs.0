Received: from smtpbg156.qq.com (smtpbg156.qq.com [15.184.82.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C441CAA2
	for <linux-cifs@vger.kernel.org>; Wed, 19 Jun 2024 16:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=15.184.82.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718814115; cv=none; b=sLHQrVt6bbcOTlb7HxYs/HSkjiXUIo+fzC+21WlqqjNQEzbXOiodO8lvZanK2QFnBfXDFw7aNEQyoiKGc5FjtlaQObZgPiKgDjniDY2Yt4e8eTK1KOdsO89060rr37nv76tGGnwU9MXNvoiePg3VlwfOseBIEp8hifreyxaP3Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718814115; c=relaxed/simple;
	bh=7epb0F2SQvHplir4DDW9HhlOUi59yLHyvRLMgmqaHRw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=K92V4WHKKHkeFVbf2liyvR5aGEFqIuqAi7pPyUo/XFrRw0dBHH9/U52vyzJ6BymLUcrMVWfUXM+YCFWlzEXrj8YQDfpULJfvI+Z42jiI+4gxguyyxkSjYtfcpco2M54yMDSRLE7wlsV125wS1ghsXo0eEgIudSn6CCG9TzOa37M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=none smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=15.184.82.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtpsz1t1718813892t22py56
X-QQ-Originating-IP: MsyLS7BAVXz9z+Z65hrDoBs2f435XlV/1gS6fjQc/q4=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 20 Jun 2024 00:18:10 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 2856800835470210935
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
	bharathsm@microsoft.com,
	samba-technical@lists.samba.org
Cc: chenxiaosong@kylinos.cn,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: [PATCH] ksmbd: remove duplicate SMB2 Oplock levels definitions
Date: Wed, 19 Jun 2024 16:17:53 +0000
Message-Id: <20240619161753.385508-1-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.34.1
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

smb/common already have SMB2 Oplock levels definitions, remove duplicate
definitions in server.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
---
 fs/smb/server/oplock.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index e9da63f25b20..72bc88a63a40 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -11,13 +11,6 @@
 
 #define OPLOCK_WAIT_TIME	(35 * HZ)
 
-/* SMB2 Oplock levels */
-#define SMB2_OPLOCK_LEVEL_NONE          0x00
-#define SMB2_OPLOCK_LEVEL_II            0x01
-#define SMB2_OPLOCK_LEVEL_EXCLUSIVE     0x08
-#define SMB2_OPLOCK_LEVEL_BATCH         0x09
-#define SMB2_OPLOCK_LEVEL_LEASE         0xFF
-
 /* Oplock states */
 #define OPLOCK_STATE_NONE	0x00
 #define OPLOCK_ACK_WAIT		0x01
-- 
2.34.1

