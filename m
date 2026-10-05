Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B3D46D560
	for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2026 18:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791225375; cv=none; b=q8CnlI0TmSQTqjpfSD3FMO830441OfGRf3HQzMUdRFWZePGjQQchzacmN4xs6uCzU3y8R8hzOSfBI39lj/zgaW9YSQzmoiHKD4NGx/r4jbKDKYmNXhMHiIsK0ctOi2LAszWysBjxH+eZQgluioxSM495yxVKnZLVJLYSxLd6ziA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791225375; c=relaxed/simple;
	bh=fSjggIzthkydkYA4jKl18LJ+Gji10RMFajAWr+lc5EU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pdjjZ3huZAgwbK4cHMhxMNmdW2VPPFxUg1qGf86r4YBTWC84D4rDbC7St4qNcVS3pN5/tYyXIXDM0F5LasHja+IXWZICXO6HcjQe+oLfjSEBTVuDMB7Vx9mPOuv8PslYGwdARfDtVZW4DZiyPSrIeXQykJ2YpLU+/SsTf9nTLuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=m7HqLsOF; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="m7HqLsOF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=OAWUA66lXoe8rsZnc3F/vYliBnhwkgf9WQsyAsA1cUU=; b=m7HqLsOFRYxuoiwbMp5LCYoisg
	wPTfsUicKXuJ/w5+bMZIn2pP154eOd0+sA375dUt8hxfwM2JuEQDOlwdklMABEQ9sa/uyEXTr+fFV
	yk4cxZPP9rVkmK8FO2jva00Fca/AdZi5C4ryvouXPiSMumfGOk8I48Uh6J5QakcnMB/b2JQSuG92j
	xCwLe5qckK/eG53sVH5sbYR5G7DMduRarIkBsjgpERkJ1sHPF9lQ4GqMl+9E7gm98p4Sx3pCXpefA
	5uxdPz86wOb0fSzkK1K/OvDDrkF2ufI+gpY2i635EAImrstirRzVOn9nd1EvdH2JbqSqeT5jeVn9p
	hQpXsjetPIkd54stNEkpwqKmqI0FdWta/UZfWA3TwxY/DFA0WS8dOj/Zwi8Xwnqa4Ypnd/myU/BgQ
	Kss1YTT/1kNxX3j1ilaYHhoUE5Te4fK8HoitZpY3ZF793gWCQeopNCwDNXVlaZbGApRHVAxi+2VMg
	vgwLWGVG4iHGTUXnzcaMqGKF;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xDnXd-00000005er5-16eS;
	Mon, 05 Oct 2026 18:36:01 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	=?UTF-8?q?=EB=A0=88=EB=93=9C=ED=8C=80=ED=95=98=EA=B3=A0=EC=8B=B6=EC=96=B4=EC=9A=94?= <ihopenre@gmail.com>
Subject: [PATCH 0/3] smb: smbdirect: fix listener backlog leak and teardown races
Date: Mon,  5 Oct 2026 20:35:49 +0200
Message-ID: <cover.1791224972.git.metze@samba.org>
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

Stefan Metzmacher (3):
  smb: smbdirect: don't wait for RDMA_CM_EVENT_DISCONNECTED in
    smbdirect_socket_destroy_sync()
  smb: smbdirect: release failed pending sockets of a listener
  smb: smbdirect: don't hand out already failed sockets in
    smbdirect_socket_accept()

 fs/smb/smbdirect/accept.c     | 122 ++++++++++++++++++++++++++--------
 fs/smb/smbdirect/connection.c |  12 ++--
 fs/smb/smbdirect/internal.h   |   2 +
 fs/smb/smbdirect/listen.c     | 116 ++++++++++++++++++++++++++++++--
 fs/smb/smbdirect/socket.c     | 113 +++++++++++++++++++++++++++----
 fs/smb/smbdirect/socket.h     |  37 +++++++++++
 6 files changed, 352 insertions(+), 50 deletions(-)

-- 
2.43.0

