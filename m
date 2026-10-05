Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED342F691D
	for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2026 19:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791229267; cv=none; b=YcljDAlk2SDBbc6sbs+4dKG7VKGzcaCavY9rzY8aTo+QlZ0dynbD9oPdrg5QZyi/B7mXjZ20zNv0xtSbsEm4/acZCY4BuGbiEKZS50Ka+eBV0x3sqqctNfkz4xJRkV1FNomCkUBVisEY9ZwoXQlgeiyS4AnI9TaQspFjaBMm4lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791229267; c=relaxed/simple;
	bh=Qwc/qoOSrB9xtNeslSLUJxOcYTZzocsOcXwtPCEHosg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WandbWf3yEQsoqbOkw8rJle4kGXBOjtSeXjRGb2ev6VrSf5VdRQtm575MMGCH2QiYiz3gOvWSvds178gm2gyGdHhAwZcCb91UfEMEhbZlwUZHFNd++W8irtT+zLeKY/vwCDo5v2hvEMaaVyrG6BrQjByN+MOm28aTQQmXGTPqO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=nQ7Fjpg8; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="nQ7Fjpg8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=CvZumz+U8+C2gatBj+0xZ6G7mhjCQ+rbGVTdSw9MubA=; b=nQ7Fjpg8snAdswvTTawV23Zp05
	qqNx+TTLAp7Bf6aDpDeevZUYrWre4PxeMLnplYtVwJSLEqKgtxP0B5QhhYxKljsDqLm0RMZmghKuN
	x2CWNF+YyP7L3PrxFXmPM2qh7LH6bKh8Qgf3hsWmlK1rgn6dmOpZMHnmyWpk96Y6xB5NCCGbKGCQK
	fMxwzP0GZ6hSwOrlspF1RhnTXiqMVaSb9wNAWlbqBMqR2QCl1ntPy3GW2l80o/rh6mIaWDBbw0iuQ
	OmEYN2LGkkuMhhdwRlt2+huJ/NXM9wD9xPcZ9vjd3FHqpyIi//iiBbPkd0o6IXSWnmzHo1XOaDZhG
	3aa0rtc8ijBv7NaUfhvAaT2cYm52uDCvjODOV+/MOnyhQ5wJ7CRxIlm7m+hOFfJG8E0jxGB1b5PF9
	F3646+5LmgXssT8soxcgPZkmW+0o2bwpD0h/EeVgCAd0hkseB0SOhJ4OeodnUy1sSEEYNQhYw0D9Z
	oKmPzsewm7C8B6DCMmTWMGBd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xDoYY-00000005g1r-3dny;
	Mon, 05 Oct 2026 19:41:02 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	=?UTF-8?q?=EB=A0=88=EB=93=9C=ED=8C=80=ED=95=98=EA=B3=A0=EC=8B=B6=EC=96=B4=EC=9A=94?= <ihopenre@gmail.com>
Subject: [PATCH v2 0/3] smb: smbdirect: fix listener backlog leak and teardown races
Date: Mon,  5 Oct 2026 21:40:45 +0200
Message-ID: <cover.1791229120.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

This was reported by 레드팀하고싶어요 <ihopenre@gmail.com>:

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

 fs/smb/smbdirect/accept.c     | 138 ++++++++++++++++++++++++++--------
 fs/smb/smbdirect/connection.c |  12 +--
 fs/smb/smbdirect/internal.h   |   2 +
 fs/smb/smbdirect/listen.c     | 124 ++++++++++++++++++++++++++++--
 fs/smb/smbdirect/socket.c     | 113 +++++++++++++++++++++++++---
 fs/smb/smbdirect/socket.h     |  37 +++++++++
 6 files changed, 373 insertions(+), 53 deletions(-)

-- 
2.43.0

