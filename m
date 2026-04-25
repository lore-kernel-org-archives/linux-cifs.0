Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E36B383C63
	for <linux-cifs@vger.kernel.org>; Sat, 25 Apr 2026 09:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777109918; cv=none; b=OD06jkoYhzXgdacXN5KfLn7kdj5Pi6g+7Gb4rtp4CvZnx7gwJ4fwLWFnAmuhzjcd0ZD9H1UcJnV4j4iMRPPT3WLQnMiPi3ijD4bzKZbvHQIOjv0PxmTB35Cyir66+tXJgQCpSIy0jHfvVMGk3GXJw98VZdMw7dPSyXuu9jwFq78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777109918; c=relaxed/simple;
	bh=aNXbkmBeYe7bkZ0ITtRcL7RZi7xiKD8Vu5jVT74b7mY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ETrJQrjluPb5WkQAYGGnJWdZQja7j+XxhjfCeZOlOJzrouxregWyY52ePNoghNpCXZh5+zXX48xBJyY01KNXDSOw1qFyEQUOeB2Hf1f1bMh68Ranbjezv4zqSsaQTeF6mCy+Yuk7LygA9drXSHIEdV9YVGoxkPJ/nk5HCFH+OSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n+Rpb6eW; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n+Rpb6eW"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b240d753ceso15609295ad.3
        for <linux-cifs@vger.kernel.org>; Sat, 25 Apr 2026 02:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777109915; x=1777714715; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mbVqeApfmb1SRG7yXWeR8Jma0vOyucMXXKmHaiUnCs8=;
        b=n+Rpb6eWA7oIiMaKqYi9Klmkhr+GVy2K6z0CAkncXStNozW1De3Ie7pTAPj8H1tpvt
         aFgIk3A6nbF8bnyzi4i7uPujmAeSESIWB80dW2fm7qqmy3GBdE1NxAbTk+5hFY2YYX6y
         KS4AHQwvM3iq80b01B0zjw3Cp/whCs7t2fUHGKQ//7b2mhQKYAI3qiLp5vE8JDCT27NE
         FtyiGIxmU8WZZa5wtGg/zocV82qfiVL7RTOco9rf4p/+OK2vwylSNSD65lZBzr0amsGr
         TnV6O4K3PdYnHCrRSuPpF8yJbU1lf0wB7dMAebxNTVsUxTgXnIwuxNa8BzZ+Ni2n5RYJ
         jsFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777109915; x=1777714715;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mbVqeApfmb1SRG7yXWeR8Jma0vOyucMXXKmHaiUnCs8=;
        b=rN3P//8orJw2DnVMcvbzaEqFpGOriQ/M8e9A3cCTo0V/yefq7VBq2fmq6JsSbSb56S
         XY5K3zrykIhopNHSiIMnxiDz9+JbXdrd1kWp845pFcHEHDuk3Y/1gaG9zbou++udS4dj
         By81VAJNvcLiOjVQU+Togp97eEOgxjP7E1vxMKtyOLWY25130CLvCZC8lMIpNL4hJAqX
         5Zyc0xZAqAUAyQEtqIHcEYXz8CtZGf0fz2Hk065IMdToaKuS/5rs0Gzb9qdkIx1y6+wT
         YSyJc2ObkOYW0vxSDYvVv57f0EAESBO8YSCrGytdF2XrKJLqLal0ch/pEE7qK4CGgxVw
         hJmg==
X-Forwarded-Encrypted: i=1; AFNElJ83NYbT4YUgHKkwnvYAHbsSGLp7ghstZw6Kw1J6MiesHJ2agMsclSCoF/CQAcOoVmBVwZL55wW1k8Bp@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4QYlfmksFbCAa8aJ5PlB2En5/8XgWHL9Jb7WpZxpbW1+wM3N+
	iJEr9BprdF2wAjo2yqqGKki8zRX30184VsQPru3OhOR1Lhg74gn61m7J
X-Gm-Gg: AeBDiesccYftnavPIxhXGcBbOoP6k9KDxvv61/h9r0bkKVKP9Auq3ObT0yGlHv+GTsX
	+EfdxM96IOYw66Dwq+s9044FV/Saiug5CuuA9OhO7/dbdvEqHcBYJcOSNM8oGvkCXh75TcICRqH
	ZtqAfE3XzqwTNSxVzs5c+3PYA2DrL5QfExIYS5zFKeqoyQNSJ+VN5TEzocKAgXK6aO9oi66z9/y
	ImmymIvhw1wvm+w2wN/nq6Qgq4Fn1rULh+Lgi5XH102JrXmTAKav6xGF9jFZuhbgafnfk2teG1a
	Tpeo2g8IqUkmKsabaTdbPTmpzrHxUSP57bxkB3E02Jf7MzSRoDk+UtExw5Li0KT8KM9sKVy+Pi+
	kJqTTt4DBRrnhISkv2A4r9KZcWZE74Pa1rGgdxYFL8SLVLfqULtSubd5SL93DcwGx0jRKGgaeQs
	R0uKWLdh5kT49BsInGagy2oVQ8gEf6azgtd6gZKg==
X-Received: by 2002:a17:903:1b26:b0:2b2:49b9:c063 with SMTP id d9443c01a7336-2b5f9ff619cmr194963735ad.6.1777109915446;
        Sat, 25 Apr 2026 02:38:35 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b606ce9891sm206791725ad.83.2026.04.25.02.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2026 02:38:35 -0700 (PDT)
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
Subject: [PATCH 0/2] ksmbd: fix stop_sessions() iteration and centralize ksmbd_conn release
Date: Sat, 25 Apr 2026 18:38:27 +0900
Message-ID: <20260425093829.4004785-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two independent fixes around ksmbd connection teardown.

Patch 1 ("ksmbd: rewrite stop_sessions() with restartable iteration")
fixes a stale-iterator bug in stop_sessions().  The current loop drops
conn_list_lock around transport->shutdown() and re-acquires it to
continue the same hash_for_each() walk; a concurrent ksmbd_conn_free()
in the unlocked window can make the iterator revisit or skip
connections.  The rewrite pins one connection at a time, marks it via
a new conn->stop_called flag, runs shutdown outside the lock, and
restarts from the top.  The "is the hash drained?" check is moved
into the locked walk so it no longer races hash_del() from a handler
thread.  Patch 1 carries Cc: stable@vger.kernel.org.

  Teardown wall time, ksmbd.control --shutdown + rmmod ksmbd with
  N concurrent nosharesock cifs connections (3-run mean):

      N        before        after
      10       4.93s         5.34s
      30       7.34s         7.03s
      50       7.25s         7.04s
      100      6.98s         6.78s
      200      6.77s         6.89s

  Performance is unchanged; teardown is dominated by the msleep(100)
  outer retry, not by the iteration.  The number of ->shutdown()
  calls equals the number of live connections on both paths when the
  race is not artificially widened.

Patch 2 ("ksmbd: centralize ksmbd_conn final release to plug transport
leak") routes the three bare-kfree final-put sites
(ksmbd_conn_r_count_dec, __free_opinfo, session_fd_check) through a
new ksmbd_conn_put() that defers the once-per-struct cleanup
(ida_destroy, free_transport, kfree) onto a dedicated workqueue.
Those sites previously skipped transport cleanup whenever they
happened to be the last putter, leaking struct tcp_transport and the
iov kvec (TCP) and the embedded async_ida.  The workqueue bounce is
needed because the centralized release reaches lock_sock_nested()
through tcp_close(), which sleeps; __free_opinfo() can be a final
putter from an RCU softirq callback (free_opinfo_rcu).

  A/B leak validation, QEMU/virtme guest with ksmbd server and CIFS
  client in the same guest, debug kernel (CONFIG_DEBUG_KMEMLEAK +
  CONFIG_PROVE_LOCKING + CONFIG_DEBUG_ATOMIC_SLEEP +
  CONFIG_DEBUG_OBJECTS + CONFIG_FAILSLAB):

  Reproducer per iteration: hold 8 fds open via sleep processes,
  force-close TCP with `ss -K sport = :445`, kill holders,
  lazy-umount; 10 iterations, then ksmbd shutdown + kmemleak scan.
  Pre-patch is HEAD with only patch 1 of this series applied:

      state         conn_alloc  conn_free  tcp_free  opi_rcu  kmemleak
      ----------    ----------  ---------  --------  -------  --------
      pre-patch         20          20        10       160        7
      with patch        20          20        20       160        0

  Pre-patch conn_free=20 with tcp_free=10 directly demonstrates the
  bare-kfree paths skipping transport cleanup; kmemleak reports 7
  unreferenced struct tcp_transport / t->iov objects.  With patch 2
  tcp_free matches conn_free at 20/20 and kmemleak is clean across
  two independent post-patch runs.  opi_rcu=160 confirms the RCU
  opinfo release path that motivates the fix is exercised.

Patch 2 also addresses two adjacent issues exposed by the new
debugging context:

  * __close_file_table_ids() refactor.  session_fd_check() already
    sleeps in kstrdup(GFP_KERNEL) and down_write(m_lock) before this
    patch, but the existing code calls it under write_lock(&ft->lock)
    (an rwlock_t).  Refactor so skip() runs outside ft->lock with a
    transient reference on fp; idr_remove(), fp->volatile_id clear
    and the m_fp_list unlink happen unconditionally so a deferred
    final putter (atomic_sub_and_test(2) returning false) cannot be
    left to do them via __ksmbd_remove_fd() with a stale
    volatile_id.

    Validated on an additional debug kernel built with
    CONFIG_DEBUG_LIST + CONFIG_DEBUG_OBJECTS_WORK using a
    same-session two-tcon storm: one tcon drives an open/write
    storm while the other tcon repeats 50 tree disconnects on the
    same session.  Trace counts: 52 __close_file_table_ids
    invocations, 4793 __ksmbd_close_fd, 30337 __put_fd_final, 9578
    ksmbd_conn_put, 1 __ksmbd_conn_release_work.  No
    list-corruption, work_struct ODEBUG, sleep-in-atomic, lockdep
    or kmemleak reports observed.  This stress validates the
    file-table/id/list rewrite under DEBUG_LIST/DEBUG_OBJECTS_WORK,
    not the transport leak (which the A/B above already covered).

  * fp owns a strong reference on fp->conn.  fp used to hold a
    borrowed pointer to its connection, leaving a window where the
    conn could be freed while a still-live fp held a stale
    fp->conn.  Make fp own a refcount on fp->conn from
    ksmbd_open_fd() / ksmbd_reopen_durable_fd() until __ksmbd_close_fd()
    or session_fd_check().  ksmbd_reopen_durable_fd() is also
    reordered so fp->conn / fp->tcon are set before __open_id()
    publishes fp into the session's file table, so a concurrent
    teardown cannot observe a valid volatile_id with fp->conn ==
    NULL.

The two patches are independent.  Either can be reviewed, applied,
or reverted without pulling the other.  Patch 2 references patch 1
only to explain why stop_sessions() is left on its open-coded local
cleanup and not converted to ksmbd_conn_put() in this series; if
patch 2 is applied alone, stop_sessions() retains its bare-kfree
leak that patch 1 separately addresses.

Based on ksmbd-for-next-next.

DaeMyung Kang (2):
  ksmbd: rewrite stop_sessions() with restartable iteration
  ksmbd: centralize ksmbd_conn final release to plug transport leak

 fs/smb/server/connection.c | 120 ++++++++++++++++++-----
 fs/smb/server/connection.h |   6 ++
 fs/smb/server/oplock.c     |   4 +-
 fs/smb/server/server.c     |  12 +++
 fs/smb/server/vfs_cache.c  | 189 ++++++++++++++++++++++++++++++++-----
 5 files changed, 285 insertions(+), 46 deletions(-)

--
2.43.0

