Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC5E3EC824
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 11:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785498682; cv=none; b=EJXdtQz87T4649LemNS5ZhuzqmChL20BJNRKVcAP/dJuxbIAAdr5X/B5VvIc8ClHX9mbY0tqnpsWm4jpEhVZofpOlfiq9AVrHTFWWIci3X6KKINNA2fiDDIX3AHVcDuOcGyEK0Uh9kn90AM9tBZYcxJ1lp2k5Y6IeF5JKRjG8nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785498682; c=relaxed/simple;
	bh=pzFFa6s9ow1fkblytmN37U7jx3dbfA+yQrQ8iEpbVII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxvzgPvoK0Rnm9AvqF2EyD+S1cwLOGcslyel61WteBTwHPK1qXixmFiaQTAANtXDSRfBTFtrPEb06lu3EUG9UH1/BrdF2dWWddADhyqnGGscqfNgHoIuPZ6AgKAX+w45A3FSvY84tpjcGZ6bzrvTxzfuw3HSAtfJPuzdzMNrPuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rby0Y6fc; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rby0Y6fc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785498678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jWCw5Zd8uJa6/v1Shc0lXaJxLM+mHTESN2jeOjTRQQk=;
	b=rby0Y6fcu1JmEYggrBXAM9L/xcOlAeCieCHMKPPq63PmygPqFOuqPbCVCHKEVJoaOQ68nH
	UT030x407Wm0Io8oEY7M19zDYDa47tdVM+YZqjTVOtQqpFa964atojpKtYqjWamtUp25xT
	G8Zvg85OCIo3bbA3MIpU9OjPYyUlC3g=
From: ZhangGuoDong <zhang.guodong@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 4/6] smb/server: abort initialization when proc setup fails
Date: Fri, 31 Jul 2026 11:50:06 +0000
Message-ID: <20260731115008.111211-5-zhang.guodong@linux.dev>
In-Reply-To: <20260731115008.111211-1-zhang.guodong@linux.dev>
References: <20260731115008.111211-1-zhang.guodong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

ksmbd_server_init() calls ksmbd_proc_init() before creating the
remaining proc entries and server subsystems. ksmbd_proc_init() tears
down partial state on a procfs or percpu_counter allocation failure,
but returns void, so ksmbd_server_init() continues as if the counters
were usable.

Once userspace starts the server, server_ctrl_handle_init() calls
ksmbd_proc_reset(), which reaches percpu_counter_set() with a NULL
per-CPU counters pointer on SMP systems. The later ksmbd_proc_create()
calls also receive a NULL parent and may create entries in the /proc
root; ksmbd_proc_cleanup() cannot remove those entries because
ksmbd_proc_fs is NULL.

Fixes: b38f99c1217a ("ksmbd: add procfs interface for runtime monitoring and statistics")
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/misc.h   |  4 ++--
 fs/smb/server/proc.c   | 13 ++++++++-----
 fs/smb/server/server.c |  4 +++-
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/misc.h b/fs/smb/server/misc.h
index 680375a966c5..1faaddd0f5f7 100644
--- a/fs/smb/server/misc.h
+++ b/fs/smb/server/misc.h
@@ -43,7 +43,7 @@ struct ksmbd_const_name {
 	const char *name;
 };
 
-void ksmbd_proc_init(void);
+int ksmbd_proc_init(void);
 void ksmbd_proc_cleanup(void);
 void ksmbd_proc_reset(void);
 struct proc_dir_entry *ksmbd_proc_create(const char *name,
@@ -56,7 +56,7 @@ void ksmbd_proc_show_flag_names(struct seq_file *m,
 const char *ksmbd_proc_const_name(const struct ksmbd_const_name *table,
 				  int count, unsigned int const_value);
 #else
-static inline void ksmbd_proc_init(void) {}
+static inline int ksmbd_proc_init(void) { return 0; }
 static inline void ksmbd_proc_cleanup(void) {}
 static inline void ksmbd_proc_reset(void) {}
 #endif
diff --git a/fs/smb/server/proc.c b/fs/smb/server/proc.c
index 1bf4e00dee34..826353ed0553 100644
--- a/fs/smb/server/proc.c
+++ b/fs/smb/server/proc.c
@@ -239,14 +239,14 @@ void ksmbd_proc_reset(void)
 		percpu_counter_set(&ksmbd_counters.counters[i], 0);
 }
 
-void ksmbd_proc_init(void)
+int ksmbd_proc_init(void)
 {
 	int i;
-	int retval;
+	int retval = -ENOMEM;
 
 	ksmbd_proc_fs = proc_mkdir("fs/ksmbd", NULL);
 	if (!ksmbd_proc_fs)
-		return;
+		return retval;
 
 	if (!proc_mkdir_mode("sessions", 0400, ksmbd_proc_fs))
 		goto err_out;
@@ -257,11 +257,14 @@ void ksmbd_proc_init(void)
 			goto err_out;
 	}
 
-	if (!ksmbd_proc_create("server", proc_show_ksmbd_stats, NULL))
+	if (!ksmbd_proc_create("server", proc_show_ksmbd_stats, NULL)) {
+		retval = -ENOMEM;
 		goto err_out;
+	}
 
 	ksmbd_proc_reset();
-	return;
+	return 0;
 err_out:
 	ksmbd_proc_cleanup();
+	return retval;
 }
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 18c20a669307..19630ac53235 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -620,7 +620,9 @@ static int __init ksmbd_server_init(void)
 		return ret;
 	}
 
-	ksmbd_proc_init();
+	ret = ksmbd_proc_init();
+	if (ret)
+		goto err_unregister;
 	create_proc_sessions();
 	create_proc_shares();
 
-- 
2.54.0

