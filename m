Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795782617;
	b=bB6VSQiuGh0a9hjN9Uhi1WRhrs0L6QscQuujaWS6WeN5Gts0zd29FnH+30DbGKfzRfwp
	 8K6WCaU6/WHO54NWuQc8pFgaJbZITGHE5uRjVZa7qnA7YKBk7rFZmiQTTcTryhvuz9wpH
	 q2BdTNMtm5lr3Jx02Zgu4FTv4P14y0jvndaD7KrHq9mHtl6sevS1disDl9api0U2nJZia
	 4ujccdppDqOHhipudRXsp/4LgizYmgZ4Vn84a+J5QMd9dVeoEXZQERvkESqr8QkKxwMLL
	 permViyEtTsig/zajC/cDEvy+t1blZSwE7S2nghxOJbeXkwvwlzx/m51yPlOqxKCtRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795782617;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=x0Q0dRSqfMzWGtSK9URXOZRZ8OP8cDt+2JeTIfTadMk=;
	b=QX6XmDKjPQ6m9h1RUhtOiJZ1y5LJhYbkwNN1BEZLD2cSBridmaeHtzjcxOe1OZ3ovJMt
	 0BaoUvlXd2IHa2y9FOaieH565uJIK39wfX8tHjesTYkNiNhpXifHZkVFiriu791tj8x0f
	 on/FzWrAjL4xDHAobqS8C9lrMG2F/eL4LO7bOFH5Z8WeZYqb+DcEx0jULemxGMq9td3Et
	 N/GoTI2ec7aGuIHfrl3YPBSrBdDN8fSwtt2QSGA6hxCPxrSupStz4PU+jnXt+l7Hk5l2T
	 JuV/uVB+0rzbGvEu+dDqVoaz0iAQrHYQo+yHW8DeoBYo5XgKOOCtApC4THAEXe2NcTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=fWoPqhKK;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF865606A31E;
	Fri, 27 Nov 2026 12:30:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF865606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=fWoPqhKK
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=x0Q0dRSqfMzWGtSK9URXOZRZ8OP8cDt+2JeTIfTadMk=; b=fWoPqhKKNKsx0SrHxDhyd9pRiR
	MW6mnpZse5fGQ3EsfjND15g5Uwv9O3nIwQSPkllfqULoR3y9xpOE7NK3KyMiMhejWM/YG7cUvdHeg
	kx0UAlyR8geMI9mVIkO3Qrkh7nsRE7DDFIKpQz9KObbkYmt4cz3h6gkRR8xn/LYT6fI5WUc78sFt1
	7MTIbe6wRa2o+oC1iYWnOcOgr/7ExMbbdbllFXYsvEX4WkohavdFObR5pCJ1gMy5+fQDH2Cg5Baln
	uDbsOuA7YCihNW6LCNB6CvzLmNtz1qgwNuaCiigkex/IPnYf8KeCacFr1Ao+Ex1dIwXqW4KWY0Okf
	AOTKG8mzi/R/r3UhHSouNp6DKrnAFu+MFp5PdY0S8Xh8rKHRCMCj0JWKihn9xRUdlimRjwvlJ5KNT
	08uZX+UeVgEhtcX0zIDmj511TF6ehtt4bN4U6XlsH+kItQcqcEod2Eu2MBPRXiyg0exUYC20Mll8e
	J8B4loaWFW/QtMLRxXYzhdls;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWv5g-00000001LgR-3cGb;
	Fri, 27 Nov 2026 12:30:13 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	syzbot+a989758ffc6f93223eb6@syzkaller.appspotmail.com
Subject: [PATCH 09/10] smb: smbdirect: don't warn about a status changed by a concurrent teardown
Date: Fri, 27 Nov 2026 13:29:06 +0100
Message-ID: <e4f6b50e9fa9f44eff82308ac5b5845ab793247e.1795781300.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795781300.git.metze@samba.org>
References: <cover.1795781300.git.metze@samba.org>
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

syzbot reported this warning:

  expected[RESOLVE_ADDR_RUNNING] != DISCONNECTED first_error=-ERESTARTSYS local=127.0.0.1:51036 remote=127.0.0.1:445
  WARNING: fs/smb/smbdirect/connect.c:307 at smbdirect_connect_rdma_event_handler+0x1e02/0x2820 fs/smb/smbdirect/connect.c:307, CPU#1: kworker/u8:7/198
  Workqueue: rdma_cm cma_work_handler
  Call Trace:
   cma_cm_event_handler+0xac/0x2c0 drivers/infiniband/core/cma.c:2181
   cma_work_handler+0x265/0x520 drivers/infiniband/core/cma.c:3040

The waiter in smbdirect_connection_wait_for_connected() was interrupted
by a signal, so it called smbdirect_socket_schedule_cleanup(), which
sets first_error and changes the status, without the handler lock of
the rdma cm id, while smbdirect_connect_rdma_event_handler() was
running.

SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}() check first_error before
the status, but there was nothing that made sure the first_error
written before the status is also seen before it, the compiler could
even reuse the value of the first_error check at the start of the
event handler. So the handler saw first_error == 0 and the status
changed by the teardown, which is not unexpected.

Now __smbdirect_socket_schedule_cleanup() and, if it sets first_error
itself, smbdirect_socket_cleanup_work() write first_error with
WRITE_ONCE() and order it before the status changes with smp_wmb() and
__SMBDIRECT_CHECK_STATUS_FAILED() reads both with READ_ONCE() and
checks first_error again, after smp_rmb(), if the status is not the
expected one, so such a status change is handled like an error
without a warning.

Fixes: 1adb2dab9727 ("smb: smbdirect: introduce SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()")
Fixes: d1f187656797 ("smb: smbdirect: introduce smbdirect_connect[_sync]()")
Cc: stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Reported-by: syzbot+a989758ffc6f93223eb6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a989758ffc6f93223eb6
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/socket.c | 21 ++++++++++++++++++---
 fs/smb/smbdirect/socket.h | 18 +++++++++++++++---
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/fs/smb/smbdirect/socket.c b/fs/smb/smbdirect/socket.c
index cb090c558321..53be81077adb 100644
--- a/fs/smb/smbdirect/socket.c
+++ b/fs/smb/smbdirect/socket.c
@@ -280,9 +280,9 @@ void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
 	spin_lock_irqsave(&sc->cleanup_lock, flags);
 	if (!sc->first_error) {
 		if (error)
-			sc->first_error = error;
+			WRITE_ONCE(sc->first_error, error);
 		else
-			sc->first_error = -ECONNABORTED;
+			WRITE_ONCE(sc->first_error, -ECONNABORTED);
 		was_first = true;
 
 		/*
@@ -298,6 +298,14 @@ void __smbdirect_socket_schedule_cleanup(struct smbdirect_socket *sc,
 	}
 	spin_unlock_irqrestore(&sc->cleanup_lock, flags);
 
+	/*
+	 * Callers of SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
+	 * may run concurrently without our locks, they need
+	 * to see first_error before the status changes below,
+	 * see __SMBDIRECT_CHECK_STATUS_FAILED().
+	 */
+	smp_wmb();
+
 	if (was_first)
 		___smbdirect_log_generic(sc, func, line,
 			lvl,
@@ -428,7 +436,7 @@ static void smbdirect_socket_cleanup_work(struct work_struct *work)
 	 */
 	spin_lock_irqsave(&sc->cleanup_lock, flags);
 	if (!sc->first_error) {
-		sc->first_error = -ECONNABORTED;
+		WRITE_ONCE(sc->first_error, -ECONNABORTED);
 		was_first = true;
 
 		disable_work(&sc->connect.work);
@@ -439,6 +447,13 @@ static void smbdirect_socket_cleanup_work(struct work_struct *work)
 	}
 	spin_unlock_irqrestore(&sc->cleanup_lock, flags);
 
+	/*
+	 * Like in __smbdirect_socket_schedule_cleanup(),
+	 * first_error needs to be seen before the status
+	 * changes below.
+	 */
+	smp_wmb();
+
 	if (was_first)
 		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
 			"%s called with first_error==0\n",
diff --git a/fs/smb/smbdirect/socket.h b/fs/smb/smbdirect/socket.h
index 1520b6e48e7d..c669778fac4b 100644
--- a/fs/smb/smbdirect/socket.h
+++ b/fs/smb/smbdirect/socket.h
@@ -692,14 +692,26 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	sc->logging.vaprintf = __smbdirect_log_vaprintf;
 }
 
+/*
+ * A concurrent __smbdirect_socket_schedule_cleanup() or
+ * smbdirect_socket_cleanup_work() sets first_error before it changes
+ * the status, so if the status is not the expected one, it may only
+ * have changed because of that, which is not unexpected. That's why
+ * first_error is checked again after smp_rmb().
+ */
 #define __SMBDIRECT_CHECK_STATUS_FAILED(__sc, __expected_status, __error_cmd, __unexpected_cmd) ({ \
 	bool __failed = false; \
-	if (unlikely((__sc)->first_error)) { \
+	if (unlikely(READ_ONCE((__sc)->first_error))) { \
 		__failed = true; \
 		__error_cmd \
-	} else if (unlikely((__sc)->status != (__expected_status))) { \
+	} else if (unlikely(READ_ONCE((__sc)->status) != (__expected_status))) { \
 		__failed = true; \
-		__unexpected_cmd \
+		smp_rmb(); /* pairs with smp_wmb() in the cleanup functions */ \
+		if (READ_ONCE((__sc)->first_error)) { \
+			__error_cmd \
+		} else { \
+			__unexpected_cmd \
+		} \
 	} \
 	__failed; \
 })
-- 
2.43.0

