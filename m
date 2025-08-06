Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957E228C5BF;
	Wed,  6 Aug 2025 14:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754491263; cv=none; b=baDMbQ/j3vd3WfJaXFVCnN2gpyEe4QnXDRVuE+gXa8YutADcjL/3Alg4v0teyRUdVu06WvrjT8FOESQMBNB+f8BKZbRNEnjKQ0CcqPOcDWKjz0uS0yl32oxIvzZHkKsGOmsHpahfobcUGPJcTegP31bLjO+xnOLXi+KHtO4IXQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754491263; c=relaxed/simple;
	bh=DUrtWE8w60cUrEBMPI4sXJxMrkOvHiZk/N1yViMIaRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bm/k4+Eorf3rYhOhHD/a3GYboJwfalyesop2hr4vDWe/6kMiaWcPMRYVB+AQ/l6ANYOA09/JyxNyDTEOzjf/t4yfdWMZWBelWuYSuNI+0JrGYXh3yNW56kb66gHva2h5fx7K4iPwzisuWPkUWDxI8eUCAyh1PYyz7q6++Zek+98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-31ec291f442so1783a91.1;
        Wed, 06 Aug 2025 07:41:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754491261; x=1755096061;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F08hZsevekdSZCocnoE12EBoNB3pI1zChMqieF5ghrY=;
        b=qImesxpjaINqGNTOEXip4cFnz8+RMi+Qd9bKN8+0l0CocMbAYh2ZGqS0HYgFhIxYuP
         w1n97/jF3UcFNYh2B++DxeQlz62xUTaw2c5525ael8hEte2P5CzsqDbOafo6E22vzP/c
         sb9kdikX33y5t7XFAugI4ooz1NFu8Pk22rez3ysE1wKNzX5lIb0DLOwjbfqxguokSsvs
         4CuWCXgWDGrJDxT3bzA2jzKu7qRtOmgYJB+OoIszfHtttnl9mP1mW1OGWTaFmJr7DPxf
         aBawnQx0T9V2LmQyb0C6QpemHp869yYy/dFqv7uNg6NP/vWwfAgaY3HvWQNp8MT4ukT8
         ThIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUleB1YOb08Mza8yUOnS0Am+RisyGjWbpc5SxRb/UiwOU3lBPNwWadJx/aYy3dK/Pv5E713Zohk82wa@vger.kernel.org, AJvYcCWrpOkmrrs+kf9/kuBCogmoMgcUBS5EXJHfNoRbuaSz0wrZPtq4YrYEA5Ym4Vr2OQpdmaQONV/eHoppuU3x@vger.kernel.org
X-Gm-Message-State: AOJu0YyGQxpNQbEBoK8vz8KyFaxvEkfpPMeqru3YTBOL4odmifBPcFpN
	0CAh2L1tdQVRZhQ8TOT7fCuCuSOasOYDtGPGtavEovWJ1BXileKcpnt9
X-Gm-Gg: ASbGnctCVERudfZ2qnUtNPIzFCsexdYPZTfmRP67FbYV8aw5FVAZfkyCmd4sLYn0uzm
	2wfqbWmH5tKjWCd1hDP/eh6RdFOy+gdJnm2R10xWEEoGqWtr34AvTAAhJef7pHuMv0lypxcXzTn
	miRxcGHDisezxIqITtHVr/MkWE85+i0bRQuKxXDYX3yaYE0/YZiJyIfgZNH0b9n3oVpTIjPg4U1
	lXLsbPMlXNkXeCBMqW5tpNC6JlNgC77wyBePINy2wUI0avwb3VL4k9Ms/nIQ2lfyx1HMSiXh1iG
	hHfrGUKH4TD3yUfiRD7YCdtOM6VAv6wAvzXoX3J0wCxepPIBAdZFPcSn4d8ywJPaTenviah2Due
	5IWJizdwHpT7n
X-Google-Smtp-Source: AGHT+IFmn5Bk81y6ZMDAcgo+VIHfOH12f8k0LVa12jVhmpe0TppCkQyp0W/7neMNg32Rmj5yWh4qoQ==
X-Received: by 2002:a17:90b:1c0d:b0:312:e9d:4001 with SMTP id 98e67ed59e1d1-32166d1ed4amr1870004a91.8.1754491260892;
        Wed, 06 Aug 2025 07:41:00 -0700 (PDT)
Received: from localhost ([218.152.98.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63ee4f42sm20025929a91.23.2025.08.06.07.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 07:41:00 -0700 (PDT)
From: Yunseong Kim <ysk@kzalloc.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Stefan Metzmacher <metze@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	syzkaller@googlegroups.com,
	linux-kernel@vger.kernel.org,
	Yunseong Kim <ysk@kzalloc.com>,
	notselwyn@pwning.tech
Subject: [PATCH v3] ksmbd: add kcov remote coverage support via ksmbd_conn
Date: Wed,  6 Aug 2025 14:39:56 +0000
Message-ID: <20250806143955.122816-2-ysk@kzalloc.com>
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

In patch v2, I added the missing initialization of kcov_handle. In v3,
I fixed an kcov_hanlde argument was previously unused on
ksmbd_conn_set_kcov_handle().

The related work for syzkaller support is currently being developed
in the following GitHub PR:
Link: https://github.com/google/syzkaller/pull/5524

Based on earlier work by Lau.
Link: https://pwning.tech/ksmbd-syzkaller/

Cc: linux-cifs@vger.kernel.org
Cc: notselwyn@pwning.tech
Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
---
 fs/smb/server/connection.c |  7 ++++++-
 fs/smb/server/connection.h | 22 ++++++++++++++++++++++
 fs/smb/server/server.c     |  4 ++++
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 3f04a2977ba8..21352f37384f 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -93,6 +93,9 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 	down_write(&conn_list_lock);
 	list_add(&conn->conns_list, &conn_list);
 	up_write(&conn_list_lock);
+
+	ksmbd_conn_set_kcov_handle(conn, kcov_common_handle());
+
 	return conn;
 }
 
@@ -322,6 +325,8 @@ int ksmbd_conn_handler_loop(void *p)
 	if (t->ops->prepare && t->ops->prepare(t))
 		goto out;
 
+	kcov_remote_start_common(ksmbd_conn_get_kcov_handle(conn));
+
 	max_req = server_conf.max_inflight_req;
 	conn->last_active = jiffies;
 	set_freezable();
@@ -412,7 +417,7 @@ int ksmbd_conn_handler_loop(void *p)
 			break;
 		}
 	}
-
+	kcov_remote_stop();
 out:
 	ksmbd_conn_set_releasing(conn);
 	/* Wait till all reference dropped to the Server object*/
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index dd3e0e3f7bf0..a90bd1b3e1df 100644
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
@@ -246,4 +250,22 @@ static inline void ksmbd_conn_set_releasing(struct ksmbd_conn *conn)
 }
 
 void ksmbd_all_conn_set_status(u64 sess_id, u32 status);
+
+static inline void ksmbd_conn_set_kcov_handle(struct ksmbd_conn *conn,
+				       const u64 kcov_handle)
+{
+#ifdef CONFIG_KCOV
+	conn->kcov_handle = kcov_handle;
+#endif
+}
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

