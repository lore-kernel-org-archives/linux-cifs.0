Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC8937A83B
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 04:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784779948; cv=none; b=jkk57sM+7NSdUcc/MjBuITYUp3wCM8qIB57bBpLm4ZdTmg9j5rUdRyf1mw9YnsKciBg9ML0aUwJJOqToGFamSsQpbNmmeXmILCpgxIxExObNSHPJ52tgKym931ugZeDjEdo4FB9RM4Y7U36QlOPJ3eegzRDie1L7Vqt4QjTDJM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784779948; c=relaxed/simple;
	bh=R/eeSxJC4prY8KxLGzFSqEYMx+hcmp9KsTES0h2WqyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehyvjLnU4meIpwXWl3gTKYUB476g0G9/UYwR+mV09vBm/A8XD+s4DGvzG63nyeoTeB+jGlniAgFpFJlLbz5+ySdFkjMudpX2uSJo5u69hQvhKig3WPrLhz2RfKi5WI3qIqa3nq0DqDeDszU1ZAgYegUcg/YdeeQxm0/k+bP1OsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=sUorAHHw; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="sUorAHHw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784779924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pOGY0OpGVEiM6+YUmaWCGMBZWbxaewU2CSvHU0ojL5s=;
	b=sUorAHHw8rkFb5JPzjSU1o8MTgNiCCWJzmUFhs6JjfxYLycVjpA9BQhzqK1TC4Hk4zrP0a
	TaF8blzIGtr6vpmMu6gAmh4N6KeZ0/064kyxdzsjNU1GAsZsTqdcQ9iI31TZpKI6rkmjQO
	W8swDv8pAv8npKA4+xpwrFhGOQb+NWPC6zk2XXMCEjD0Kqe7x3KtatLXeANQT+FLvPf34W
	QemSsVou1R9ASi/1XnUpx9OEx3ZHu14nnzijQpMGaPYu9Uc5r1QOIE5sTjB5bZ4UJMJtsz
	eZn3nqK1/L5EfFchDLqau4sVykGfAIsM+38JmBknUUUUBzx4OgdVfxh+a4d4Cw==
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
	gael.blivet@gmail.com,
	andriy.shevchenko@linux.intel.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 2/3] smb/server: cancel async requests when closing connection
Date: Thu, 23 Jul 2026 04:11:30 +0000
Message-ID: <20260723041131.313321-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260723041131.313321-1-chenxiaosong@chenxiaosong.com>
References: <20260723041131.313321-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

An async request may still be waiting when a connection is closed.
This can stop the connection from closing.

Cancel active async requests before waiting for them to finish.

Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/connection.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 26e312fb6da8..13d9fa610fff 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -371,6 +371,26 @@ void ksmbd_conn_try_dequeue_request(struct ksmbd_work *work)
 	wake_up_all(&conn->req_running_q);
 }
 
+static void ksmbd_conn_cancel_async_requests(struct ksmbd_conn *conn)
+{
+	struct ksmbd_work *work, *tmp;
+
+	ksmbd_debug(CONN, "Cancel pending async requests on releasing connection\n");
+	spin_lock(&conn->request_lock);
+	list_for_each_entry_safe(work, tmp, &conn->async_requests,
+				 async_request_entry) {
+		if (work->state != KSMBD_WORK_ACTIVE)
+			continue;
+
+		ksmbd_debug(CONN, "Cancel async request id %d\n",
+			    work->async_id);
+		work->state = KSMBD_WORK_CANCELLED;
+		if (work->cancel_fn)
+			work->cancel_fn(work->cancel_argv);
+	}
+	spin_unlock(&conn->request_lock);
+}
+
 void ksmbd_conn_lock(struct ksmbd_conn *conn)
 {
 	mutex_lock(&conn->srv_mutex);
@@ -669,6 +689,7 @@ int ksmbd_conn_handler_loop(void *p)
 	}
 
 	ksmbd_conn_set_releasing(conn);
+	ksmbd_conn_cancel_async_requests(conn);
 	/* Wait till all reference dropped to the Server object*/
 	ksmbd_debug(CONN, "Wait for all pending requests(%d)\n", atomic_read(&conn->r_count));
 	wait_event(conn->r_count_q, atomic_read(&conn->r_count) == 0);
-- 
2.54.0

