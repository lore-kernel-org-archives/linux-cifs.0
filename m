Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224BCC8EB;
	Wed,  6 Aug 2025 13:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754488411; cv=none; b=WpuTS15fCPNPwjJmzcFgr5zN01pwbTs6o/3rnfaMWRwTEyoCpx6bP/Z5Ea1fghdihlkCucyTyV5PLsyE/DQtSt+vWQtmalnRY6rHHfOHmqJbO/vaQPp0ls87GVkTRun5QjamzFG6x2eb/RryGqbzLaEcirvzlRJrp889LyalHA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754488411; c=relaxed/simple;
	bh=4tk6NnU3d3nHsMbrPT3szZG4xcdNqUYkmbWKu9AP8N0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=USBdQkSlycQLlTuI7Gvet8Gee0Sw57XBg41VGOSTtxMra1B6MnrM1kmhlwS/8hZwkcYXIz1Igz95D5pWG4XagCDKn1ybg0Lc4vRHdZCffjx3j7tFre7fVVqyVecDYyAgD+WNkPUYK/lz/pw1R4DGhyMoeaKNwnEsduk3PwdWUfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-73de140046eso547897b3a.1;
        Wed, 06 Aug 2025 06:53:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754488409; x=1755093209;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eXVVW+/eUuU4SVgr/LVm9ictIC2YN1aVDlWxGhihbS0=;
        b=Z2RAEL70yh6uQccVb54JRDdoJv+699z53qlOAas7B2YH2ekpB0CJav2amATrD4y7Wt
         AwjQ0arUlkGNtz3SIXi+rQQOAAt2NDaIloZFmvIJ45ahQSRMxsi67SKW4m/a2LEAFJtH
         z0adt8hjlpj2rbglc51t7qIhVVDR/UWhOQDhSu4jnBZ+Fx7k72aa55i6WCTD54S2JyvE
         7l+2f7PfRpWF4xvQBlILe2HSh2EJxsMDMGBB3ogycPWVaDHt3avwPKXpbYfjB8pIjT8B
         thNSYQ19X5dZFn0khfZqRIbZpxmESpEKjsa7iZ/zLULgKPH/P7r7wGksHWhghQW36LBx
         eU6g==
X-Forwarded-Encrypted: i=1; AJvYcCUM0dAKlh3hPRo+Cp2R7p3u5jQNHUDjLqUfQKPIsv81bYKy4RfxJokMuQMbmTb/L6ygsWHpzNTBar3B@vger.kernel.org, AJvYcCXRgsfcTZjMXSrPzXglKCb9rFjAT/M6ylgsD8qEIKm65VOYISmc9sD4ftN0/q66ZNdTMEjapYb8j10hzdD8@vger.kernel.org
X-Gm-Message-State: AOJu0Yznazh7MS/XDy2Gkd3P3XMPqOheelwDTzMifLjZMAWiZN/VXu4T
	1/pTvRPMk3T9OM696u0h2D9rqi1aZSqEPXew9UK/uQizvl0LLsjp5E6U
X-Gm-Gg: ASbGncvF5YLXmj5edjspYndXlgolhPy/QjSY6yUPD6hEY2JPQ0ORS+tb4kWs262oR9e
	74l+ToTAqFqVURInd1O6pOIp9WMd19whUU69dONfjbW1qjPayn5ylIymkjbpmi5eYJvVfEFYPhG
	NCS4iZf3xreEvOdnOBkXbuB9AmLwhT5lt9XSCXco85uJa5gLyNG9XnNrhYhM4V2Ibxy7mI23i40
	3VJSt/4GukJ9aKPbMIpmTjhkvk7lyXXAdEXaPwizl/hUNQ7U6nMgWE4wSG4cJejmdYqwF/AyzA8
	SHV75C0Kb5sB3oPwicM5ofwRHfYp2n3jJ9vv5rk1o5uACYZ1sdRaBd9A8WzkUKe5ELBuIXN0Bvp
	m6xPElwPMgk9D
X-Google-Smtp-Source: AGHT+IGDjFRv/TdNKCeuh9p8W9Kqj4kzRHGaV40cP01GTluWlo8FIEiwxVxGKtEIcffl56f6Tq+VrQ==
X-Received: by 2002:a05:6a21:6d96:b0:222:d794:62fb with SMTP id adf61e73a8af0-2403145b4f0mr2050935637.3.1754488409253;
        Wed, 06 Aug 2025 06:53:29 -0700 (PDT)
Received: from localhost ([218.152.98.97])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b422bafcce2sm13534289a12.52.2025.08.06.06.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 06:53:28 -0700 (PDT)
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
Subject: [PATCH v2] ksmbd: add kcov remote coverage support via ksmbd_conn
Date: Wed,  6 Aug 2025 13:52:25 +0000
Message-ID: <20250806135224.116724-2-ysk@kzalloc.com>
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

In patch v2, I added the initialization of kcov_handle, which was
missing in the previous version.

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
index dd3e0e3f7bf0..1071b3e68bc9 100644
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
+	conn->kcov_handle = kcov_common_handle();
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

