Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.163
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792566196;
	b=35/u4bvAtnpGdXwUL95U7BGWKWGBo8lHIo+x6NIUoeB7Gm60YrqYNI9oAUOlvWdwX01F
	 fgeHm26u8MXnAySEr23p3E6agbwuq3ExFPEItDPE56VLk4r5RtogaRJxvE3vnft4+INcE
	 SDxLuYbhafhfbPqjXeRD0UDoKPB+m67Q6W7FsmvwiDvcX3oDVCGMoKeSG+E/W0qWaDvv5
	 2wghyHJQQbPdbJBA4+gmgJZ9vSvq2maXzkQKYhuZlME2BWW8H3plCxsfjuNrp6OvaF+0F
	 ywOKwAtkLzTWcboqkiXAdFpaMcQn4joFLie7XXIzSA2pHmRDO/oawsOwqV1WD/gTINg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792566196;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=UeW96EGt9NT4L/FZOox0ScwqiduRGN9r9eR3bqA6I80=;
	b=UvxyGpKB3zU5ba+U7fr6Lu4nWLTUpbJj83/CT7L+aUCDy80mHPTJbCVUcS3EV2G1hEep
	 bGPkvX5ghn2vI2UwHTwzuxS6zDBjHf/iAs78ij3yXBtf4diKI3WM0Kr88r670p8cVYhV3
	 pWjSEEn22shfnN4mqJkbg2ymkWau4ZZH/DRQ5YlwwqZ2Mq8BpZ0cDQYC/Slg7V8Z/oaJQ
	 RlKlYlZ9/kmpd44ro3C041+OOU9+wwgLp0b60bQOTB1b1yVAVvsmQgmeBl5QCX9818uej
	 WcYlKU6QIFEZtBsz3or1JcskLGBog5yk0KSPds7tko27mnZzvcWjtf7//6mRcSckF1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BYjH5SQH;
	arc=none smtp.remote-ip=95.215.58.163
Received: from mta1.migadu.com (out-163.mta1.migadu.com [95.215.58.163])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9EC606A31A
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 07:03:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F9EC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BYjH5SQH
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Op9DszS3tzdciPj60cuwuNy7LEkCMGdmtqeFFvXIhK0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792566192; v=1; x=1793170992;
 b=BYjH5SQHFnl/Icgt+tsyVBZY8MsBFWq6Gl6pw98NIs0ZQNTJ8OuHpau+ULrYk/msJOvt5lgh
 HjpzFNZt3J4Le9dNbV1Xe04zcnKWXOnVxf2z8ftLnM3H7PV7R+84bu4ilU6PEkqNJsiCRIYyfdK
 rjgQtrpeg+y2OgXB6nm2HKBA=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id aebe76f51d6c00ad;
	Wed, 21 Oct 2026 07:03:12 +0000
X-Mizu-Trace-ID: aebe76f51d6c00ad
X-Migadu-Flow: FLOW_OUT
From: ZhangGuoDong <zhang.guodong@linux.dev>
To: linkinjeon@kernel.org,
	pc@manguebit.org
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH] smb/server: replace deprecated system workqueues
Date: Wed, 21 Oct 2026 15:02:57 +0800
Message-ID: <20261021070257.127209-1-zhang.guodong@linux.dev>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ZhangGuoDong <zhangguodong@kylinos.cn>

Queueing the lease break timer on system_wq triggers the following warning:

  workqueue: work func lease_break_timer [ksmbd] enqueued on deprecated workqueue. Use system_{percpu|dfl}_wq instead.

The oplock break timer and TCP transmit work also use deprecated system
queues.

Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/oplock.c        | 4 ++--
 fs/smb/server/transport_tcp.c | 6 +++---
 fs/smb/server/vfs_cache.c     | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index e76dfc904fb9..d479508c06c5 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -178,7 +178,7 @@ static void lease_break_timer(struct work_struct *work)
 	lease_break_timer_pending = pending;
 	if (pending) {
 		lease_break_timer_next = next;
-		mod_delayed_work(system_wq, &lease_break_timer_work,
+		mod_delayed_work(system_percpu_wq, &lease_break_timer_work,
 				 time_after_eq(jiffies, next) ? 0 : next - jiffies);
 	}
 	mutex_unlock(&lease_break_timer_lock);
@@ -191,7 +191,7 @@ static void schedule_lease_break_timer(unsigned long timeout)
 	    time_before(timeout, lease_break_timer_next)) {
 		lease_break_timer_pending = true;
 		lease_break_timer_next = timeout;
-		mod_delayed_work(system_wq, &lease_break_timer_work,
+		mod_delayed_work(system_percpu_wq, &lease_break_timer_work,
 				 time_after_eq(jiffies, timeout) ? 0 : timeout - jiffies);
 	}
 	mutex_unlock(&lease_break_timer_lock);
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 9c6ca878d30f..937d321fa364 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -573,7 +573,7 @@ static void ksmbd_tcp_tx_work(struct work_struct *work)
 	if (READ_ONCE(t->tx_stopped))
 		ksmbd_tcp_purge_tx(t);
 	else if (!list_empty(&t->tx_queue))
-		queue_delayed_work(system_unbound_wq, &t->tx_work, delay);
+		queue_delayed_work(system_dfl_wq, &t->tx_work, delay);
 	mutex_unlock(&t->tx_lock);
 	wake_up_all(&t->transport.conn->req_running_q);
 
@@ -590,7 +590,7 @@ static void ksmbd_tcp_write_space(struct sock *sk)
 	if (t) {
 		t->write_space(sk);
 		if (!READ_ONCE(t->tx_stopped) && sk_stream_is_writeable(sk))
-			mod_delayed_work(system_unbound_wq, &t->tx_work, 0);
+			mod_delayed_work(system_dfl_wq, &t->tx_work, 0);
 	}
 	read_unlock_bh(&sk->sk_callback_lock);
 }
@@ -687,7 +687,7 @@ static int ksmbd_tcp_writev(struct ksmbd_transport *t,
 	msg->deadline = deadline;
 	list_add_tail(&msg->list, &tt->tx_queue);
 	WRITE_ONCE(tt->tx_queued, tt->tx_queued + msg->len);
-	queue_delayed_work(system_unbound_wq, &tt->tx_work, 0);
+	queue_delayed_work(system_dfl_wq, &tt->tx_work, 0);
 
 accepted:
 	tt->tx_end += tx->size;
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index bfa28ef197f6..452ce05d1494 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -87,7 +87,7 @@ static void ksmbd_oplock_break_timer(struct work_struct *work)
 	oplock_break_timer_pending = pending;
 	if (pending) {
 		oplock_break_timer_next = next;
-		mod_delayed_work(system_wq, &oplock_break_timer_work,
+		mod_delayed_work(system_percpu_wq, &oplock_break_timer_work,
 				 time_after_eq(jiffies, next) ? 0 : next - jiffies);
 	}
 	mutex_unlock(&oplock_break_timer_lock);
@@ -100,7 +100,7 @@ void ksmbd_schedule_oplock_break_timer(unsigned long timeout)
 	    time_before(timeout, oplock_break_timer_next)) {
 		oplock_break_timer_pending = true;
 		oplock_break_timer_next = timeout;
-		mod_delayed_work(system_wq, &oplock_break_timer_work,
+		mod_delayed_work(system_percpu_wq, &oplock_break_timer_work,
 				 time_after_eq(jiffies, timeout) ? 0 : timeout - jiffies);
 	}
 	mutex_unlock(&oplock_break_timer_lock);
-- 
2.55.0

