Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C81B38947C
	for <linux-cifs@vger.kernel.org>; Sat, 25 Apr 2026 09:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777109927; cv=none; b=R7V3FGxZZJNocaqa5ZmU3siDs5Hl72utIEECdRA5F1X+zEeG4BG+0QAt8nxO5HHndv9QbXFQcnYd1jvakxVVJ1N001PmU+GJ1jHOpGc5RaFC1FoBiUqWul6yYF4BpWhbH6UJaZmWf3kU7oWkt1P4GX4MerEH3z26NynX2/H/csc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777109927; c=relaxed/simple;
	bh=REzEfWkN6tjWJaQ0H+RiUYIwoU83Xx0WygSxTrhFKbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oeu9ScPdXEjlnrrLx+w9Ml7ux9ocHBvOkVo4pNB58JystEtuufO14yk0xUPYdmYuFdV92tuVGiwV/EmZV//3MpXMeWZ8BARmwcnHLh1SHdptBIADlMxTmRhFhH02pOxUMtLw1+Nt1kxlUfMTHnmOLSiwpfSF1SWFS78ZIXwIl48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lPGIoVrG; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lPGIoVrG"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b25c84360fso4978225ad.0
        for <linux-cifs@vger.kernel.org>; Sat, 25 Apr 2026 02:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777109925; x=1777714725; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YB7okcDXB2f9QxPT6JpL0fC68gABv+vXaX5leb6ndF8=;
        b=lPGIoVrGN7TI1crvVpUmhZ40Qr/CNtZl+2iSetodNgtvJxnDfePjs5n/tqDLq0c9Bc
         KbRKOOhPUW+mfC/+LhfE1XjYFT1LQK0RVepG6ensH5hMZ+0jSYzKyr1OEpMAEx90lasi
         L5esQPmMYVDoczahnk5cxX1VEYdDRiqqm3smjPpWxBxQpWb/4RNv6dZzNu8MXF9+q2TZ
         ++bpqzN44WWwtmLD/VhXrDbmw3uAL2t9I0vYBLL4VDuAf+PAw76RQsmMDUtCXC4SUuEm
         TK8giTMLD+Cv9Q+NzJkRh/sWz9BeaPAAw8A2mpnTQSdigaksheUq7SgUisaW0IYydyAV
         PzAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777109925; x=1777714725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YB7okcDXB2f9QxPT6JpL0fC68gABv+vXaX5leb6ndF8=;
        b=YsKd8kjGrdXm8fl6MpTe6mVD4cuzCY1e2tIk8vtewcV2jmf3KrZN3YhXjyakdimYIU
         UlXFda+UXIqDxH9sEzXdrDNyRL47O8o3YcZgaAwiN9s9FGbNoCI0LU9HXtPw2HSiwKh8
         yLDn0wVNT5AAFr/tubQOp9J/9DMprOawtjv7EqyZIWYdNs++7GEwQiyh0Ukd7p8lszeZ
         BcUw69dJdtlPJ5PHhnRvJmntMXRGUldsu2V7D29IWFSbs2ycOznIZgS/5gbT+h+ixY3N
         5stWv36qqqD/nzoAoi7l7cYDsGhNgdGQhgiXahgs88lr7gBvrZo3IE6gjrwjgGS2Q3h6
         dM7g==
X-Forwarded-Encrypted: i=1; AFNElJ+uzdDF6es31RZMz/xeaTT++U839iaAXDkcmin50f1egd0kr3S8O4784ikt3LnM0usj/7iShTvw8hTt@vger.kernel.org
X-Gm-Message-State: AOJu0YxF97UeEg/73PSLd7PiKXUtKhBJkCutUjrkiR12rI+aCG+YzfRE
	KK22d/9OvK4mjcmu38n4TBtw4TxCSMQRM9de+LQS8hA0LBwW90vTuqKf
X-Gm-Gg: AeBDiesFF2QVbITU+ufyPe0nR4xEF9N3yXhBEvPtvL2ndXa7RLCOXgp9km/Aif56Lfk
	xeVKfRv8ADWP5QJUqQznthpKlPXvRSZsNIEPkObSB72RCEDIG14bCk8aEpZek4YxKz+IYFeZYrj
	y2UmRmXIxLUoQHLcGwll7PHSUnva9YXWTIVYrrUIOke3aLd4ReQe23eR0yl8tQT3AbrM7YRi8xn
	MohFtiqfNv7JNIMRdIuDyPz09hjESdthJzCVYgQ9SUoz0y8ack2EVonVkiXedPFzzy2XBKo+mgJ
	TQQpXwjgQg3SB8GBLsWIW6I4xYb50vIUpTy6Ag5qArxE+ugrhlyR4b0pPpiJbI6GjyAbP+5eM0B
	Zm0PfcIYI1ILMzFhgH4YHooYfphD3tHte1Qj8I2kBpKmPbn+GNe7oRU+BMPDEJt32OloegheNLz
	rjPzQIp3TeRe9ffd6o0FnK34FXcT8=
X-Received: by 2002:a17:903:3b88:b0:2b2:ac6f:104b with SMTP id d9443c01a7336-2b5f9e79f5bmr187610395ad.1.1777109925297;
        Sat, 25 Apr 2026 02:38:45 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b606ce9891sm206791725ad.83.2026.04.25.02.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2026 02:38:44 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH 1/2] ksmbd: rewrite stop_sessions() with restartable iteration
Date: Sat, 25 Apr 2026 18:38:28 +0900
Message-ID: <20260425093829.4004785-2-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260425093829.4004785-1-charsyam@gmail.com>
References: <20260425093829.4004785-1-charsyam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

stop_sessions() walks conn_list with hash_for_each() and, for every
entry, drops conn_list_lock across the transport ->shutdown() call
before re-acquiring the read lock to continue the loop.  The hash
walk relies on cross-iteration state (the current bucket and the
hlist position), which is not preserved across unlock/relock: if
another thread performs a list mutation during the unlocked window,
the ongoing iteration becomes unreliable and can re-visit
connections that have already been handled or skip connections that
have not.  The outer `if (!hash_empty(conn_list)) goto again;` retry
masks the symptom in the common case but does not address the
unsafe iteration itself.

Reframe the loop so it never relies on iterator state across
unlock/relock.  Under conn_list_lock held for read, pick the first
connection whose ->shutdown() has not yet been issued by this path,
pin it by taking an extra reference, record that fact on the
connection and mark it EXITING while still inside the locked walk,
then drop the lock.  Then call ->shutdown() outside the lock, drop
the pin (freeing the connection if the handler already released its
reference), and restart from the top.

Use a new per-connection flag, conn->stop_called, as the "shutdown
issued from stop_sessions()" marker rather than reusing the status
state.  ksmbd_conn_set_exiting() is also invoked by
ksmbd_sessions_deregister() on sibling channels of a multichannel
session without issuing a transport shutdown, so treating
KSMBD_SESS_EXITING as "already handled here" would skip connections
that still need shutdown() to wake their handler out of recv(),
leaving the outer retry waiting indefinitely for the hash to drain.
stop_sessions() is serialised by init_lock in
ksmbd_conn_transport_destroy(), so writing stop_called under the
read lock has no other writer.

Set EXITING inside the locked walk so the selection, the stop_called
marker, and the status transition all happen together, and guard
against regressing a connection that has already advanced to
KSMBD_SESS_RELEASING on its own (for example, if the handler exited
its receive loop for an unrelated reason between teardown steps).

When the pin drop is the last put, release the transport and pair
ida_destroy(&target->async_ida) with the ida_init() done in
ksmbd_conn_alloc(), so stop_sessions() retiring a connection on its
own does not leak the xarray backing of the embedded async_ida.

The outer retry with msleep() is kept to wait for handler threads to
reach ksmbd_conn_free() and drain the hash.

Observed with an instrumented build that logs one line per visit and
widens the unlocked window before ->shutdown() by 200 ms, under
five concurrent cifs mounts (nosharesock, one connection each):

  * Current code: the same connection address is revisited many
    times during a single stop_sessions() call and ->shutdown() is
    invoked well beyond the number of live connections before the
    hash finally drains.

  * Rewritten code: each live connection produces exactly one
    ->shutdown() call; the function returns as soon as the hash is
    empty.

Functional teardown via `ksmbd.control --shutdown` with the same
five mounts completes cleanly on the rewritten path.

Performance is observably unchanged.  Tearing down N concurrent
nosharesock cifs connections with `ksmbd.control --shutdown` +
`rmmod ksmbd` takes essentially the same wall time before and after
the rewrite:

    N        before        after
    10       4.93s         5.34s
    30       7.34s         7.03s
    50       7.31s         7.01s     (3-run avg: 7.04s vs 7.25s)
   100       6.98s         6.78s
   200       6.77s         6.89s

and the number of ->shutdown() calls equals the number of live
connections on both paths when the race is not widened.  The
teardown is dominated by the msleep(100)-based outer retry waiting
for handler threads to run ksmbd_conn_free(), not by the iteration
itself; the restartable loop's worst-case O(N^2) visit cost is in
the microseconds even at N=200 and sits far below the msleep(100)
granularity.

Applied alone on top of ksmbd-for-next-next, this patch does not
introduce a new leak site.  Under the same reproducer (10x
concurrent-holders + ss -K + ksmbd.control --shutdown + rmmod), the
tree still shows the pre-existing per-connection transport leak
count that arises when the last refcount drop lands in one of
ksmbd_conn_r_count_dec(), __free_opinfo() or session_fd_check() -
all of which end with a bare kfree() today.  kmemleak backtraces
for the unreferenced objects point into the TCP accept path
(sk_clone -> inet_csk_clone_lock, sock_alloc_inode) and none
involve stop_sessions().  Plugging those bare-kfree sites is the
responsibility of the follow-up patch.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 fs/smb/server/connection.c | 46 +++++++++++++++++++++++++++++++-------
 fs/smb/server/connection.h |  1 +
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index fbbc0529743f..c5aac4946cbe 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -540,24 +540,54 @@ int ksmbd_conn_transport_init(void)
 
 static void stop_sessions(void)
 {
-	struct ksmbd_conn *conn;
+	struct ksmbd_conn *conn, *target;
 	struct ksmbd_transport *t;
+	bool any;
 	int bkt;
 
+	/*
+	 * Serialised via init_lock; no concurrent stop_sessions() can
+	 * touch conn->stop_called, so writing it under the read lock is
+	 * safe.
+	 */
 again:
+	target = NULL;
+	any = false;
 	down_read(&conn_list_lock);
 	hash_for_each(conn_list, bkt, conn, hlist) {
-		t = conn->transport;
-		ksmbd_conn_set_exiting(conn);
-		if (t->ops->shutdown) {
-			up_read(&conn_list_lock);
+		any = true;
+		if (conn->stop_called)
+			continue;
+		atomic_inc(&conn->refcnt);
+		conn->stop_called = true;
+		/*
+		 * Mark the connection EXITING while still holding the
+		 * read lock so the selection and the status transition
+		 * happen together.  Do not regress a connection that has
+		 * already advanced to RELEASING on its own (e.g. the
+		 * handler exited its receive loop for an unrelated
+		 * reason).
+		 */
+		if (READ_ONCE(conn->status) != KSMBD_SESS_RELEASING)
+			ksmbd_conn_set_exiting(conn);
+		target = conn;
+		break;
+	}
+	up_read(&conn_list_lock);
+
+	if (target) {
+		t = target->transport;
+		if (t->ops->shutdown)
 			t->ops->shutdown(t);
-			down_read(&conn_list_lock);
+		if (atomic_dec_and_test(&target->refcnt)) {
+			ida_destroy(&target->async_ida);
+			t->ops->free_transport(t);
+			kfree(target);
 		}
+		goto again;
 	}
-	up_read(&conn_list_lock);
 
-	if (!hash_empty(conn_list)) {
+	if (any) {
 		msleep(100);
 		goto again;
 	}
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index ae21a1bd4c70..de2d46941c93 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -49,6 +49,7 @@ struct ksmbd_conn {
 	struct mutex			srv_mutex;
 	int				status;
 	unsigned int			cli_cap;
+	bool				stop_called;
 	union {
 		__be32			inet_addr;
 #if IS_ENABLED(CONFIG_IPV6)
-- 
2.43.0

