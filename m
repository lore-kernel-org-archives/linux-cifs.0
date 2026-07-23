Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE392253EE
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 03:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784776670; cv=none; b=H/w3qdimFH1L/fg+eKVJucwOY887nXPZoLBldEhkbPjQU8N9i+8Mny6kTqlq3IaedNOYmwvdd+9XLahy6slsal24GcfCwrNYnfPbxXKKAgjht1g8s/3j5f0m0vNvroPMlCEkUw/HP6tNQKX0P6aWRhnasnuS0iY/i+8bXkLJSj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784776670; c=relaxed/simple;
	bh=rbvzQnxpmN/QFE4tidLlRS+m8/GS/PqG+BLryZUmn+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsmnSzniM7LoNoO5dSPIBcjE9AmyS/139UVU7+XT3KdwniIgCEYcN/kxvIVquBba2xfJ9R9lCO6Zb4DiHsswsPgLQ5bs3ZxFnCdWnmnc8njE/FIgM5HZrsRJ9Kl45pe6NMxOf8zmyj0HNe3yxToNWh1XjK8IIO28XxCysjlHggo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Ee+OPUkv; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Ee+OPUkv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784776663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YMMt4TNQMs9zQldxdkmzehTcr8Nu4P2nXpcVRQOCucE=;
	b=Ee+OPUkvdEFjyx8an4/V1sI7m+Dc3TZewLKfJgCz5cdtanrJCQeTntzPnIzKuMBY+XNEb4
	whSt2rMUlDpdBRiM+FBXaIijBA/p9ZxN9u34aiTCNyuHkTl6fxEAPC3/brTKKb2DG8I57y
	l/ZMHvj9HI/Retq73bG8Pl/FXXCdlKLOAB68WmqS2MeiWrwHVRLYciZSJDpQyiQjGEOjAd
	Y/lSsI4R2TA0GQPxSb85UKh09LMrkMVkeMu/9SBTAdhNn5fDK9l3CFJQoD9zN3TDD9XFhg
	U+DDua4FLQ4KQArjHlFMhWIw5np+xXT5RORjJSOLMUSDxNvkCuC7Txqqsne6ag==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	gael.blivet@gmail.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [RFC PATCH 01/11] smb/server: add debug type for change notify
Date: Thu, 23 Jul 2026 03:16:29 +0000
Message-ID: <20260723031644.312866-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260723031644.312866-1-chenxiaosong@chenxiaosong.com>
References: <20260723031644.312866-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Add KSMBD_DEBUG_NOTIFY and expose it as "notify" to print logs
for the change notify feature.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/glob.h   | 3 ++-
 fs/smb/server/server.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/glob.h b/fs/smb/server/glob.h
index 344b069cfbbd..87cbc88275fe 100644
--- a/fs/smb/server/glob.h
+++ b/fs/smb/server/glob.h
@@ -22,10 +22,11 @@ extern int ksmbd_debug_types;
 #define KSMBD_DEBUG_IPC         BIT(4)
 #define KSMBD_DEBUG_CONN        BIT(5)
 #define KSMBD_DEBUG_RDMA        BIT(6)
+#define KSMBD_DEBUG_NOTIFY      BIT(7)
 #define KSMBD_DEBUG_ALL         (KSMBD_DEBUG_SMB | KSMBD_DEBUG_AUTH |	\
 				KSMBD_DEBUG_VFS | KSMBD_DEBUG_OPLOCK |	\
 				KSMBD_DEBUG_IPC | KSMBD_DEBUG_CONN |	\
-				KSMBD_DEBUG_RDMA)
+				KSMBD_DEBUG_RDMA | KSMBD_DEBUG_NOTIFY)
 
 #ifdef pr_fmt
 #undef pr_fmt
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 5b38406129b5..4bea3ac8011b 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -522,7 +522,7 @@ static ssize_t kill_server_store(const struct class *class,
 
 static const char * const debug_type_strings[] = {"smb", "auth", "vfs",
 						  "oplock", "ipc", "conn",
-						  "rdma"};
+						  "rdma", "notify"};
 
 static ssize_t debug_show(const struct class *class, const struct class_attribute *attr,
 			  char *buf)
-- 
2.54.0

