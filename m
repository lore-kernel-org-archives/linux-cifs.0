Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EEC2045B7;
	Tue,  5 Aug 2025 15:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754409577; cv=none; b=SzxEWQtKHJbTuXok8xencdyPExUldGTISwTvAcEgO4ziNDeKomX0EQAY6GnwtZHRdvaFn0cN2/vLisYEp+NCRZQ0RMzlgwiJosnDkWJBN2f+5f6wrqb4M2APY3RFSyO1tw+FBlf7uU3cDilYn4UQD/oUMNQ7gMST4XFRzW7FoAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754409577; c=relaxed/simple;
	bh=m0LU1qaLRSsRPSbX0ciBnhWdZnBeXv9neFXKF8f56Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jAnEoqijWvkXqzTorLDzShTRT83aMCLm5UBQ05q0ulSjej6K88exXpKuJbszneaken7zspZe2PtPpRTqt7Rzsw7MU6FpSAbjhNO5nkuBcu8gxE8wQrJrS9zbpY4hs/xotnGGzLKBNw8y0bHOE+nWj79ri9Vpvpk5HbaKRfCt4io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-32116dd55dcso724445a91.3;
        Tue, 05 Aug 2025 08:59:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754409575; x=1755014375;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V/Od2rfppNEDbprPUwulY8XJGdzkkGhVfmvmHo9N+0g=;
        b=rKBx1Qtclf86YmV+q0ZFlRzc8APG9tErKiLAzDok8RCzO5LDPYtU0gSdQG5GOJffOS
         DK53Jguh7JNvpky2R8V81j2WRWAg4pb4Xv+J4e7R2m2/bXgG/N3vwpLLeMc/1I1WgdRX
         fHQO0mx/ENnNf1ClDOfxZ5vFaDMrHnehDM7aqGg9df2hl/MoPPFmwRr7zsV0BDZNJxFM
         8x+NA/Y4YKT9q/biYIdCpBeRkJAtDWu4INbYb0a16WG0N6aNBUa9aymKszqTVV1Z4ve3
         DWRczAfFgJ+M4MBxxuhYuHjm6zW06yfUzJ37QFjJ7arImzrGjG2ZZBAvkhduMDJcqhGB
         eFDg==
X-Forwarded-Encrypted: i=1; AJvYcCUEm2vXJVuLQ3rNfuXkpg/g89amPNodnRaZW7aQ9SMSalwVSDOZogSllZ0o4zqnEDoAVc2k/SgrE40YLN6b@vger.kernel.org, AJvYcCVxSWTT0bXa88RJAoKPsK0SGsv3582erCcTdxS3J2bG6iQwBQckzErHu64FmoYPgJ28NK6rBHGYCKSp@vger.kernel.org
X-Gm-Message-State: AOJu0YwbeHIPLMUQh0GnwiiJzohO+xT/VvZbE7sRGPP8lzhKJfCDt+Ga
	msk4ffzTaZRoawVpOhA1uNSvG43BPTDD2lDBsUujtXCEaTX23QCOBSypQHhBEw==
X-Gm-Gg: ASbGnctJXfOF8O98R0JHBhrWQQD2mr+2JSyhvx7tT2PP4fWDVFgSej5tP3J/4ghpke8
	ND2thSywmoHiVSROBV2VuAk29XRUS/AuACRZYG/ebsCjIReJ8+HhIDLMIyxsaqLC2s8qcPjoD3p
	FzrvwQ5ojpD1C/GTsifXqtqLFAGB9tTlX/s4b5fJ/0NBMspSP76iT2kLsYyogukALRd9B2Wn99J
	ESxbNujApvcVZ6/CFNolxdG7P4uSQD03lwLanNYIiV0vp2Pj0qAVH5F+n8ygU9h2/2/CXHsURwP
	mL2pBHMCBTgxEoyWNfnGjZcCIrk6gn20bLQNcXuXUv+3RZT7sjMgZuyufBjzNBF7s6LWRsZZgY5
	D+qmVD2jOxHOP
X-Google-Smtp-Source: AGHT+IES1fD8irvZA4SGu2efKUtBxC9f4epdz1iAOhgYvBR/G8G/w5ox4688q4NrAUGzo/aiypeyyQ==
X-Received: by 2002:a17:90b:1b06:b0:31f:24c2:16cb with SMTP id 98e67ed59e1d1-321162cd92dmr7989190a91.6.1754409574886;
        Tue, 05 Aug 2025 08:59:34 -0700 (PDT)
Received: from localhost ([218.152.98.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63f35f90sm17375728a91.35.2025.08.05.08.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 08:59:34 -0700 (PDT)
From: Yunseong Kim <ysk@kzalloc.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	syzkaller@googlegroups.com,
	linux-kernel@vger.kernel.org,
	Yunseong Kim <ysk@kzalloc.com>,
	notselwyn@pwning.tech
Subject: [PATCH] ksmbd: add kcov remote coverage support via ksmbd_conn
Date: Tue,  5 Aug 2025 15:56:28 +0000
Message-ID: <20250805155627.1605911-2-ysk@kzalloc.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KSMBD processes SMB requests on per-connection threads and then hands
off work items to a kworker pool for actual command processing by
handle_ksmbd_work(). Because each connection may enqueue multiple
struct ksmbd_work instances, attaching the kcov handle to the work
itself is not sufficient: we need a stable, per-connection handle.

Introduce a kcov_handle field on struct ksmbd_conn (under CONFIG_KCOV)
and initialize it when the connection is set up. In both
ksmbd_conn_handler_loop() which only receives a struct ksmbd_conn*
and handle_ksmbd_work() which receives a struct ksmbd_work*, start
kcov_remote with the per-connection handle before processing and stop
it afterward. This ensures coverage collection remains active across
the entire asynchronous path of each SMB request.

The kcov context tied to the connection itself, correctly supporting
multiple outstanding work items per connection.

The related work for syzkaller support is currently being developed
in the following GitHub PR:
Link: https://github.com/google/syzkaller/pull/5524

Based on earlier work by Lau.
Link: https://pwning.tech/ksmbd-syzkaller/

Cc: linux-cifs@vger.kernel.org
Cc: notselwyn@pwning.tech
Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
---
 fs/smb/server/connection.c |  4 +++-
 fs/smb/server/connection.h | 14 ++++++++++++++
 fs/smb/server/server.c     |  4 ++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 3f04a2977ba8..6ce20aee8cc1 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -322,6 +322,8 @@ int ksmbd_conn_handler_loop(void *p)
 	if (t->ops->prepare && t->ops->prepare(t))
 		goto out;
 
+	kcov_remote_start_common(ksmbd_conn_get_kcov_handle(conn));
+
 	max_req = server_conf.max_inflight_req;
 	conn->last_active = jiffies;
 	set_freezable();
@@ -412,7 +414,7 @@ int ksmbd_conn_handler_loop(void *p)
 			break;
 		}
 	}
-
+	kcov_remote_stop();
 out:
 	ksmbd_conn_set_releasing(conn);
 	/* Wait till all reference dropped to the Server object*/
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index dd3e0e3f7bf0..07cd0d27ac77 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -15,6 +15,7 @@
 #include <linux/kthread.h>
 #include <linux/nls.h>
 #include <linux/unicode.h>
+#include <linux/kcov.h>
 
 #include "smb_common.h"
 #include "ksmbd_work.h"
@@ -109,6 +110,9 @@ struct ksmbd_conn {
 	bool				binding;
 	atomic_t			refcnt;
 	bool				is_aapl;
+#ifdef CONFIG_KCOV
+	u64				kcov_handle;
+#endif
 };
 
 struct ksmbd_conn_ops {
@@ -246,4 +250,14 @@ static inline void ksmbd_conn_set_releasing(struct ksmbd_conn *conn)
 }
 
 void ksmbd_all_conn_set_status(u64 sess_id, u32 status);
+
+static inline u64 ksmbd_conn_get_kcov_handle(struct ksmbd_conn *conn)
+{
+#ifdef CONFIG_KCOV
+	return conn->kcov_handle;
+#else
+	return 0;
+#endif
+}
+
 #endif /* __CONNECTION_H__ */
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 8c9c49c3a0a4..0757cd6ef4f7 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -264,6 +264,8 @@ static void handle_ksmbd_work(struct work_struct *wk)
 	struct ksmbd_work *work = container_of(wk, struct ksmbd_work, work);
 	struct ksmbd_conn *conn = work->conn;
 
+	kcov_remote_start_common(ksmbd_conn_get_kcov_handle(conn));
+
 	atomic64_inc(&conn->stats.request_served);
 
 	__handle_ksmbd_work(work, conn);
@@ -271,6 +273,8 @@ static void handle_ksmbd_work(struct work_struct *wk)
 	ksmbd_conn_try_dequeue_request(work);
 	ksmbd_free_work_struct(work);
 	ksmbd_conn_r_count_dec(conn);
+
+	kcov_remote_stop();
 }
 
 /**
-- 
2.50.0

