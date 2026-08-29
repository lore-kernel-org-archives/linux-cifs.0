Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7271210F1
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 10:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787998945; cv=none; b=BpidxlZi6Y8CoYOi8SS1+pmff2nHNX2H4whI/yOnZpwpHhNZNOT3RWhWKn3+WIi6IU7Fd25Z4faGUEnb2Wu97+6/i/1GLg15ELKLWfvQOBlh9qjOfBWZDmn3iLsJuOzd9GmOFbflE8DTOxbb6ppK64IPigd7e2fVtH3IUmbM55g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787998945; c=relaxed/simple;
	bh=QDd/YcISIdEGuP9v3Lj8p4iGjBxS+sXC7KIhD63rsWo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m4sGllGkSELWwkAjxk9B8+ybR5YiTqGMSpqzyCDidf5CrCHqy8iQ2/RxjYHCQdadMU2TJCTAQrZkr1hySr7YSV9BTCUxc/4/0aa9HYFaL+jJXb1R9nFTJ0ijhjRjgQYeJIBxL75lrIQYMalUUOz+WdwWIG2ShDzE40R2P90TwIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M0ljJVoW; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M0ljJVoW"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-482e1bfcc63so1341192f8f.1
        for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 03:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787998942; x=1788603742; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/1oznCz3bO2LwfhEA6TvD+xD8i3/CIT/q9ZHOfcxwlU=;
        b=M0ljJVoWqNyS4t+H8uQpoSd/ZVpwGw30f5+lMbDXvC4G3mRGelOtLLvxO4kTrq5TAU
         evt4ewLuahWGiAreKlPRXeVY8MsqUmNQ31ee/YUeYOx+ezI4jOOOq61tjGZmbzrTQ7Io
         9SahB+tTGwEGiN6mNiZyCgq769neONpm4NEJNLAef8r/70Ur/DhT8xr9KSIvhyZRYxOG
         5EMBUZWMLlIB3OB9avfQIn95tqX+mCgJ244aOBKVx+5ZV0SjV9tbPyRO1YreC3xCkv0h
         F6Zci37z/rsPgs77RqTi2d88OgkwxCkDyay5ldqutsURi5rBP1XX2c1uHCAa4Hatiplk
         niEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787998942; x=1788603742;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/1oznCz3bO2LwfhEA6TvD+xD8i3/CIT/q9ZHOfcxwlU=;
        b=AcAaPD4xZvEso/duXAQOaNytgluRzFbrJx/qW5QjDFw1sy+Cvcr+oHpA0scFlnuOw3
         luefu/cc9DgNSoc4cibxfHYwBXtCmJiij3OYuhL4164n0qZNTnSd8x9uoM+BZm/9O/rZ
         klsvIbGqneWJvVTzHjst1nBB8L/gjRFg4kScFAkkXJPieTExtVTpg26qfelIyRMZnySJ
         HSjeKt48u+VoczKfEBeY1hzBAZ/eJliXrILvtJWMb8zmL5EoFs/aNs3rDc9vDgeu+5L3
         N/mJt8nWV10uvYQGGgGim/qzZeHCSGbOl4Ww8UZg7pD4L7RwwFErhRunfscE0VS/YAya
         8K6g==
X-Gm-Message-State: AFuF++mcRWEvWZ6qY5Wp66xfB0h2A0NH98+eeTXjylOpgd1VZ9lv1JPp
	zuF6qXROLPsjI6NyJK/rIcW8B8p35TuJaWb3D8jWZ8pTfawQtggJqvjCKeoczLcR
X-Gm-Gg: AYBFou2mkVKGxP/VntghZQlpXU4xSGnmcH96wDzdVg9NCyRQwqSRwRue8qt98a8q5Lp
	VkR6Ow2oDtt6Xils1sz2bz9iA8sRx03keCLwKHvHrFQ0wtHwmhvR2LRYDRB76cQ2TxkpMMFisDJ
	JQKJGbQnHpqbfMX1ledHwX3oht5t01/sTLXeXxqISP4bYuges5LlwQHjrN8JoEFhunbPRKk/32z
	/DOtDg5Sym8tQJVHjwZ5+3hYSZiTMp2z/+YwApaaSEg/l7uPEvjR2W2effOnEhoTiK2MrTebS/K
	I3Pkumf3MKs8O4OIg6kdBlEmQzIA5/9nHNS9h2weoqGYzyRY4c31N+HEjCBeijk1W04JUPBv29E
	y2ongOktNCuSjButHEJBp612vN2rVy1ei6jPq5mOHmpWAhnQXIzFo7MosG6JYDAnjFKqQp6n2qy
	/hwD1M7l9PJ8p4pAU8OzzTBnLqJN/1h3VN4bc0X7rRtJeLLGYK7/N4iW+4IePdufVOBzK4
X-Received: by 2002:a5d:5e8b:0:b0:482:e66d:aad2 with SMTP id ffacd0b85a97d-482eababe33mr25156010f8f.13.1787998941548;
        Sat, 29 Aug 2026 03:22:21 -0700 (PDT)
Received: from SurHub.localdomain ([196.188.112.230])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482fbac8e61sm9287629f8f.13.2026.08.29.03.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 03:22:21 -0700 (PDT)
From: Abdifatah Suruur <suruurism@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com
Subject: [PATCH] ksmbd: fix use-after-free in oplock break notification
Date: Sat, 29 Aug 2026 13:22:17 +0300
Message-ID: <20260829102217.6201-1-suruurism@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_oplock_break_noti() reads opinfo->conn without any lock and
dereferences it after two allocations which may sleep.  When the
durable handle owning the oplock is disconnected, session_fd_check()
clears opinfo->conn and drops its conn reference under ci->m_lock, and
the last ksmbd_conn_put() frees the connection.  A break triggered by
another connection that races with the teardown can then resurrect the
freed connection: ksmbd_conn_get() is a plain atomic_inc, and the
queued break work later dereferences the stale conn via
ksmbd_conn_write(), a use-after-free reachable by any authenticated
client holding a durable batch oplock.

Select and pin the connection under ci->m_lock before the allocations,
the same lock session_fd_check() uses to clear opinfo->conn, so a
concurrent teardown either loses the race to the clear or keeps the
connection alive until the notification work releases it.  Transfer the
reference to the work item and release it on allocation failures.

Fixes: b003086d7696 ("ksmbd: fix NULL-deref of opinfo->conn in oplock/lease break notifiers")
Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>

---
 fs/smb/server/oplock.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
@@ -924,6 +924,32 @@
 	ksmbd_conn_put(conn);
 }
 
+/*
+ * Select and pin the connection used for an oplock break before doing any
+ * allocations which may sleep. opinfo->conn is cleared under ci->m_lock by
+ * session_fd_check() when the durable handle owning the oplock is
+ * disconnected, and the last ksmbd_conn_put() frees the connection.
+ */
+static struct ksmbd_conn *smb2_oplock_break_conn_get(struct oplock_info *opinfo)
+{
+	struct ksmbd_inode *ci;
+	struct ksmbd_conn *conn;
+
+	if (!opinfo->o_fp)
+		return NULL;
+	ci = opinfo->o_fp->f_ci;
+
+	down_read(&ci->m_lock);
+	conn = READ_ONCE(opinfo->conn);
+	if (conn && !ksmbd_conn_releasing(conn))
+		conn = ksmbd_conn_get(conn);
+	else
+		conn = NULL;
+	up_read(&ci->m_lock);
+
+	return conn;
+}
+
 /**
  * smb2_oplock_break_noti() - send smb2 exclusive/batch to level2 oplock
  *		break command from server to client
@@ -938,17 +964,20 @@
 	int ret = 0;
 	struct ksmbd_work *work;
 
-	conn = READ_ONCE(opinfo->conn);
+	conn = smb2_oplock_break_conn_get(opinfo);
 	if (!conn)
 		return ksmbd_invalidate_durable_fd(opinfo->fid);
 
 	work = ksmbd_alloc_work_struct();
-	if (!work)
+	if (!work) {
+		ksmbd_conn_put(conn);
 		return -ENOMEM;
+	}
 
 	br_info = kmalloc_obj(struct oplock_break_info, KSMBD_DEFAULT_GFP);
 	if (!br_info) {
 		ksmbd_free_work_struct(work);
+		ksmbd_conn_put(conn);
 		return -ENOMEM;
 	}
 
@@ -957,7 +986,8 @@
 	br_info->open_trunc = opinfo->open_trunc;
 
 	work->request_buf = (char *)br_info;
-	work->conn = ksmbd_conn_get(conn);
+	/* Transfer the reference acquired by smb2_oplock_break_conn_get(). */
+	work->conn = conn;
 	work->sess = opinfo->sess;
 
 	ksmbd_conn_r_count_inc(conn);
