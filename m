Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BF826ED45
	for <linux-cifs@vger.kernel.org>; Tue,  9 Dec 2025 01:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765242712; cv=none; b=J0KojHzY5WrfuZy1CGDOwyrTWppi0hQFxiHdx6VQAnk+f0AV2/M1MqHtbaskeVmvPNlAgwWOIv6WWYz+arrS5jtPG+5Qhe3RBmTtEP74a5kB0j1fSlPQKrKugkTKVPfB1CpvmaKtfFD19UQ52LWRzPq88uQ6tMeK6PEGL4bhRUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765242712; c=relaxed/simple;
	bh=zqUbClEpYmVLCkf7LSfQQ4EH11MAwGyGwPNOrhw21yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caky/xu/tCwBu7IIoi0bIyo3CNouwTTIPwdpg2VwqQyMKzeOco0J8UdKXVbtiIr4xH97DJq2RePF8IkuVp/TBVw7CDC3VTptJqIyXbA5aryEMHgffTlxJ54+a0uYsbU5bRX4GjmduAAxdYqsVWcqa2MXKmrAWcqt++0waEoS1wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JxBx0zLa; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JxBx0zLa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765242709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V+0v70GJZbVxaMdU0OSc+Xgiqw3vx4uMcK6LzyG70gs=;
	b=JxBx0zLajpAfT63Jax6yqM8lTNbukkcazCN3QgarSlEJ/I7lBzSjKB0Q5nehFaUjY2mPeR
	LPXVWoE7VMxXqmOqGhjuGGtewqUqb+HqkxoE+M0IfDNvleaY/ckabsOYvXlP97IzalXgVI
	qTojtPQYcILQAIaH01VTBxMeonM3OjA=
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
Subject: [PATCH 02/13] smb: move notify completion filter flags into common/smb2pdu.h
Date: Tue,  9 Dec 2025 09:10:08 +0800
Message-ID: <20251209011020.3270989-3-chenxiaosong.chenxiaosong@linux.dev>
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

Some of these definitions are already in common/smb2pdu.h, remove the
duplicate client side definitions, and move FILE_NOTIFY_CHANGE_NAME to
common header file.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifspdu.h | 14 --------------
 fs/smb/common/smb2pdu.h |  1 +
 2 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 31c33e20b8ac..4315a06d296b 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1357,20 +1357,6 @@ typedef struct smb_com_transaction_change_notify_rsp {
 	__u16 ByteCount;
 	/* __u8 Pad[3]; */
 } __packed TRANSACT_CHANGE_NOTIFY_RSP;
-/* Completion Filter flags for Notify */
-#define FILE_NOTIFY_CHANGE_FILE_NAME    0x00000001
-#define FILE_NOTIFY_CHANGE_DIR_NAME     0x00000002
-#define FILE_NOTIFY_CHANGE_NAME         0x00000003
-#define FILE_NOTIFY_CHANGE_ATTRIBUTES   0x00000004
-#define FILE_NOTIFY_CHANGE_SIZE         0x00000008
-#define FILE_NOTIFY_CHANGE_LAST_WRITE   0x00000010
-#define FILE_NOTIFY_CHANGE_LAST_ACCESS  0x00000020
-#define FILE_NOTIFY_CHANGE_CREATION     0x00000040
-#define FILE_NOTIFY_CHANGE_EA           0x00000080
-#define FILE_NOTIFY_CHANGE_SECURITY     0x00000100
-#define FILE_NOTIFY_CHANGE_STREAM_NAME  0x00000200
-#define FILE_NOTIFY_CHANGE_STREAM_SIZE  0x00000400
-#define FILE_NOTIFY_CHANGE_STREAM_WRITE 0x00000800
 
 #define FILE_ACTION_ADDED		0x00000001
 #define FILE_ACTION_REMOVED		0x00000002
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 7b954b607165..0565385d735a 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -991,6 +991,7 @@ struct smb2_set_info_rsp {
 /* notify completion filter flags. See MS-FSCC 2.6 and MS-SMB2 2.2.35 */
 #define FILE_NOTIFY_CHANGE_FILE_NAME		0x00000001
 #define FILE_NOTIFY_CHANGE_DIR_NAME		0x00000002
+#define FILE_NOTIFY_CHANGE_NAME			0x00000003
 #define FILE_NOTIFY_CHANGE_ATTRIBUTES		0x00000004
 #define FILE_NOTIFY_CHANGE_SIZE			0x00000008
 #define FILE_NOTIFY_CHANGE_LAST_WRITE		0x00000010
-- 
2.43.0

