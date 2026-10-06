Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2FA2EA749
	for <linux-cifs@vger.kernel.org>; Tue,  6 Oct 2026 19:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791313755; cv=none; b=mnIaicN7q/R5fpEwgTY8n80xX9o8G54xcW/NHbdbGH8XrpnTKaPeERC5ymdzxMVFWGNuBy/mmKCsEu3ZLKwDsXxJWcGcNNw0s/cGXOcCw5k7021p7cZdWNotRyoPsQAluF23k8gpYbQyW8WGwnlMnx2CrIuQWGd3bqWhkbnJUgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791313755; c=relaxed/simple;
	bh=/UU7vpaqvBGZO4B6Y7h6qd6Dg7+OHbxNmNWlnPECSlE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=atkJ+FUXdWXsCm4WKyPQAAnsVvT+tif1LKq5CEb2foVlw3TfrioXBxtNmKjuHSem3Rgo9KRMP4gixHKYPIHp1wnzqCKICgkTACPRShHT142DgjvjRNMP5rCdztEDw1+ajASbbtuaIykYhnWdYmn3LE68f/4klnnUQ/dVbV7jZt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=uNOsiHjt; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="uNOsiHjt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Eui3efxAoFq1xcB64L3l3H8oOzM7utGrkGl1lQqiIVM=; b=uNOsiHjt4gFkvGgIpzn7hI57/X
	zVL2D9/E4krAy/uFJc9SD279YSURK3wN35zdLlksgzlHyW1pIvwpHoAQ9k9XSuvWYxwPvDf9U9V4q
	qzpaHZYEmRcA4a2r4b2mK+bfYlz+YJUNfltDozck513XGxnumsTsDSwa7H3MOj+/nTtJlIuMvjWoC
	y6ziB3iJbg9ZA/tYgRJgh0Rq4HhpJhSsz754NsLRTBpSGp0cxPuz1g9miOp6Wk7AtIJeXrhKaTJLN
	FZMPAYUyV+SieRjDbdc3Q6keTm5s6PV/HFEdgTNqmrLyVoZtRSDWk3jNC51vmeLTd4u8LSA8isj26
	wWBwRw7PPUIeFJNPBUPSOYOEC87DC+aZ5NOxADulYUI0Z8PAe6geHiEkcdOJ+bIdU143Xs5n0yrTV
	O15h0wXBU2LBVfraxoqVLPZrwT6389cNM3oxq8LposONboYkSSLjVm/40ovXumhMOlu3wSl0ID8UY
	FFGCPfF0vyoAXOf3p5I3Ndtj;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xEAXA-00000005yAL-1Qtc;
	Tue, 06 Oct 2026 19:09:04 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	Lee Seong Hyeon <ihopenre@gmail.com>
Subject: [PATCH v3 0/3] smb: smbdirect: fix listener backlog leak and teardown races
Date: Tue,  6 Oct 2026 21:08:54 +0200
Message-ID: <cover.1791311817.git.metze@samba.org>
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
    orphans such a socket and tries the next one.

I tested the reproducer and the problem is fixed
and I run various xfstests.

I think these are important and should go into 7.3
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

 fs/smb/smbdirect/accept.c     | 194 +++++++++++++++++++++++-----------
 fs/smb/smbdirect/connection.c |  12 +--
 fs/smb/smbdirect/internal.h   |   2 +
 fs/smb/smbdirect/listen.c     | 137 ++++++++++++++++++++++--
 fs/smb/smbdirect/socket.c     | 113 +++++++++++++++++---
 fs/smb/smbdirect/socket.h     |  42 ++++++++
 6 files changed, 411 insertions(+), 89 deletions(-)

-- 
2.43.0

