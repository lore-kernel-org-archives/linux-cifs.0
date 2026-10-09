Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C713549BD83
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 10:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791540152; cv=none; b=eJdvizupf3d4Af6Z/hW+2gVNR51l+TmN7LdECTVGgKFXNEDmLuqKLVzUuXWp46Ws2et+oDy0aXFPexI9XU878rn2RUZA2Z6bnYR/rKfXkyHm5hceJH5wruzDzZpBEMKBz1YZzEdpztKMWOpZVICpCTE2yFLKYxuVgkxpkt1ASkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791540152; c=relaxed/simple;
	bh=tKgCG7BKDFGvpJcEN04zxwBNnThUsfb61bCfDsLunlI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kWN9ncGgStMxP7g1AwWxYtcM0J9sMuBU9fPSfPkrbWBO6yIKUfUFEExGHPZTYWF1wrnsiMcu3M7EIc/l12CJeUkcEqBwfTN+quEh0r9p/ZDXNtSgRsuZXB4SeyE3qEU/3m3NVmgPsL+gZHCgYbHD8/85IjOH6ES9w9IePW3vRQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=IccjteVK; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="IccjteVK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=JbFZiWOa63seevLM6JkYbtzs5wABNW9ppJcqel9FJcQ=; b=IccjteVKiRHPZL/3kVOohlRgpm
	J2V4ihm6Gl7gAg9Xn4Bvj3toLA8u41HkkXxkrR8RdEc3jZpuxdt45imdndxNo2kUpxZL27/CPwQDj
	bnMdoGVkf3GgQF5pvnVDapR6gUa7LGkVr/S/yApc/kQuY2Xeo4t+DD/XS0458K78z07mdHf/WF3A8
	aqGeth0igd/Wfwu6/4kShbPmLvThW+39pPHrkBDX2E3EV/WbuPbb2GCBRl6XDFU8tA6jJ6kUqob1n
	wYgaB5FgDwmpkkbM5BbBNXNQs+HGHy2xF9JCp4GnSUozqVvF8doE0eLUwQVrGUebCvUF80Al0lRRo
	b2I5IUQwnHa7hhLk0gmiWcTrlW6KuQDpe/e0+GeiuHZyzoOJckVdR9i5oGPefPrVZI0m99Wrvl7te
	ayBKZD3YvMxE1pFjOjBE+Y1Omtjt5NhG3xNCV2beTBR/0bOhsgmal5XWv+0VxiK9xa6rrR3S4fZDI
	QKT5Kap5dWCDr5vdVAmYg6be;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xF7Qj-00000000Sjh-2tXx;
	Fri, 09 Oct 2026 10:02:21 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	Lee Seong Hyeon <ihopenre@gmail.com>
Subject: [PATCH v4 0/3] smb: smbdirect: fix listener backlog leak and teardown races
Date: Fri,  9 Oct 2026 12:02:10 +0200
Message-ID: <cover.1791540051.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Namjae,

These fix a set of problems in the shared smbdirect module
(fs/smb/smbdirect/), reached through the listener/accept path, which in
practice is driven by ksmbd for incoming SMB Direct connections.

The main one is a pre-authentication remote denial of service: the
listener keeps every accepted connection on a fixed-size backlog
(listen.pending, limit 10 for ksmbd). A connection is only removed from
that backlog on the success path (promotion to listen.ready after a
completed negotiate, or dequeue by accept()). A connection that is
accepted at the RDMA level but then fails before it is accepted by the
upper layer - negotiate timeout, peer disconnect, or an invalid
negotiate request - is never removed, so its backlog slot is leaked.
After about ten such events the listener rejects every new connection
with -EBUSY and SMB Direct stays unusable until the service is
restarted. An unauthenticated peer can trigger this with ~10 aborted
connections.

This was reported by Lee Seong Hyeon <ihopenre@gmail.com>:

  https://lore.kernel.org/linux-cifs/CANTrAmxL5sWU8Sn29JAGZvSq5PBB2OA+VKA0MHsZJMesagtfzA@mail.gmail.com/

The series:

  - smbdirect_socket_destroy_sync() no longer waits for
    RDMA_CM_EVENT_DISCONNECTED after rdma_disconnect(). That wait could
    take very long (until the rdma cm gives up, e.g. a peer that just
    vanished) or never complete if the event already happened and the
    status was overwritten. rdma_destroy_id() in
    smbdirect_socket_destroy() is enough to stop further events; the
    rest of the disconnect protocol is handled by the rdma core
    asynchronously. This also makes releasing orphaned sockets
    (next patch) non-blocking.

  - A failed, not-yet-accepted child of a listener now moves itself to a
    new listen.orphaned list at the end of its cleanup work and queues
    listen.purge_orphaned_work, which releases it, so it no longer leaks
    its backlog slot (nor its struct sock / RDMA resources) for the
    lifetime of the listener. sc->accept.listener is only changed under
    listener->listen.lock, and whoever clears it owns the release;
    the listener is freed via kfree_rcu() so a child can dereference it
    under rcu_read_lock(). This is the DoS fix.

  - smbdirect_socket_accept() no longer hands out a socket that failed
    after it was put on the ready list (e.g. the peer disconnected in
    the meantime); it checks first_error / the status under listen.lock,
    orphans such a socket and tries the next one. And it also
    no longer returns -EAGAIN if a non zero timeout was passed.

I tested the reproducer and the problem is fixed
and I run various xfstests.

I think these are important and should go into 7.3

Changes since v3:
(https://lore.kernel.org/r/cover.1791311817.git.metze@samba.org/)

- "smb: smbdirect: release failed pending sockets of a listener":
  install the real event handler and the expected event at the very
  start of smbdirect_accept_connect_request(), before anything that can
  fail. On an early error the caller only schedules nsc's deferred
  cleanup and returns 0, so the rdma_cm core keeps the cm_id - it must
  then already carry smbdirect_accept_rdma_event_handler(), which turns
  any unexpected event (e.g. RDMA_CM_EVENT_DEVICE_REMOVAL) into a clean
  smbdirect_socket_schedule_cleanup(). Previously the placeholder
  smbdirect_socket_rdma_event_handler() left by
  smbdirect_socket_init_accepting() stayed installed on that path and
  returned -ESTALE, making the rdma_cm core destroy the cm_id behind the
  back of the pending teardown.

- smbdirect_socket_accept always goes back to smbdirect_socket_wait_for_accept
  when no valid new socket was found, so that we don't return -EAGAIN
  unless a zero timeout was given.

Changes since v2:
(https://lore.kernel.org/r/cover.1791229120.git.metze@samba.org/)

- "smb: smbdirect: release failed pending sockets of a listener":
  reworked the connect-request error handling after more Sashiko
  review. smbdirect_accept_connect_request() no longer tears down any
  RDMA state or clears the cm_id on failure; it only returns a
  not-yet-posted recv_io to the pool and returns the error.
  smbdirect_listen_connect_request() now sets nsc->accept.listener and
  publishes nsc on the pending list *before* it calls
  smbdirect_accept_connect_request(), and on a non-zero return it
  schedules nsc's teardown with smbdirect_socket_schedule_cleanup() and
  always returns 0, so the rdma_cm core keeps the connection id and nsc
  owns it (and destroys it in its own deferred teardown). The teardown
  must be deferred because nsc's id_priv->handler_mutex is held by the
  rdma_cm core across the CONNECT_REQUEST handler; that same lock (and
  the listener's) also guarantees nsc can't go away under us. This
  closes the race Sashiko reported, where a connection that established
  between rdma_accept() and setting the listener could be left stranded
  on the pending list.

Changes since v1:
(https://lore.kernel.org/r/cover.1791224972.git.metze@samba.org)

- "smb: smbdirect: release failed pending sockets of a listener":
  fix a use-after-free and a missed-orphan race in
  smbdirect_listen_connect_request(), spotted by Sashiko. The
  nsc->first_error check and the orphaning are now done under
  listen.lock, together with setting nsc->accept.listener, so a
  concurrent smbdirect_socket_cleanup_work()/purge_orphaned_work()
  can neither free nsc while we still look at it, nor miss the
  orphaning and leak it on the pending list.

- "smb: smbdirect: don't hand out already failed sockets in
  smbdirect_socket_accept()": bound the accept() wait across the
  "skip a failed socket and try the next one" retries, also spotted
  by Sashiko. smbdirect_socket_wait_for_accept() now returns the
  remaining timeout and smbdirect_socket_accept() carries it over, so
  a stream of failed connections can no longer reset the caller's
  timeout. ksmbd passes MAX_SCHEDULE_TIMEOUT, so it is unaffected in
  practice.

- Added Reported-by:/Closes: for the Sashiko reviews.

Stefan Metzmacher (3):
  smb: smbdirect: don't wait for RDMA_CM_EVENT_DISCONNECTED in
    smbdirect_socket_destroy_sync()
  smb: smbdirect: release failed pending sockets of a listener
  smb: smbdirect: don't hand out already failed sockets in
    smbdirect_socket_accept()

 fs/smb/smbdirect/accept.c     | 225 ++++++++++++++++++++++++----------
 fs/smb/smbdirect/connection.c |  12 +-
 fs/smb/smbdirect/internal.h   |   2 +
 fs/smb/smbdirect/listen.c     | 137 +++++++++++++++++++--
 fs/smb/smbdirect/socket.c     | 113 +++++++++++++++--
 fs/smb/smbdirect/socket.h     |  42 +++++++
 6 files changed, 438 insertions(+), 93 deletions(-)

-- 
2.43.0

