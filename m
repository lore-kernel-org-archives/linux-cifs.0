Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795797643;
	b=DEFHb86MBSYOTEcHBrzQoZW69REcVI3Rf3ZGVb/L6qIIpZPRDQTqzJzrWG0Gx2Pb5HD+
	 5inLwp9fKChNr9agu1u3PMufwoErMGGvWXwiMgfrhddq+e0pgBEdB/uzpGksQbINLJpml
	 SJn636TeN4FNoZBxx4HYOzPW7D1VbHxbxh5Y339Rt8ZnlpbQ/Y/vWE3dqu/HJnyWTi7k8
	 ZVgkfKjeZdewGp14xGKE7tu3l9yRXjvd9E/UYV4HJ6ngWYOEuPNE+dPkhZS3+pceX1EgS
	 6ARoWUuO8y1FibDecXaq3QYAc2nLwgG2USMgLR0OzuVTa9mURBOU1Okd90vNGTJYW/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795797643;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=bspoc2uAgDK7oKPJbbSrF7iTD2JLGkntkGxQGP05lds=;
	b=dGVknxx8gLKZf50MTCX+mmBNDipp20kns78EnUV771HtCk11HyIO/DKMhqnDHShF7PoS
	 xNND3wJNCZDEvl4YcAxEVb3o7QnqdzTb8dFK1pEkMD+Yn8tpW48twUEb15dcR4qFueu37
	 D4LNPuOJnyyalU7+oVOSt/CC213O5Ca0QL7l4VNU4m4a7RZQWsU7PcAHqnsnDRnYPjE/z
	 LUTy+nGURB+v9gtpY18UhuutCe9tQ2xf6cWKkBBUNhMMse2tICj2DV1xMXpxzt/x/Scev
	 EoFj4c9OcFy7XfQz2sqgAINxBeN7kMz1XrXSFLOMFKx/QpJknhAk2giMs6eqJ+4MyAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=jkmxA5zm;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7E3606A69B;
	Fri, 27 Nov 2026 16:40:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED7E3606A69B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=jkmxA5zm
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=bspoc2uAgDK7oKPJbbSrF7iTD2JLGkntkGxQGP05lds=; b=jkmxA5zmPcCX2QagKDiGH4Jvc+
	jmac0VMw/7bntLq0m8B253k8z6E3S+eS5sn8xiLEx+jPxoBttgTPsjwnWo3rASeVLhzyszMAb27Ds
	hGW9hT3uiyjbkRqh9zF0X/Ps0nohWPWLz1mEtdnc1Lyw0MvVKfhFpQi3+09FosiZG6o0f4sNzlNig
	+HXLicUW6XYMsjeJEecX/1aLXYvVMMfVfX2DXCXMvtQnd2azd7rXo5puT9YrKS3/H9Nw9hkKI1RwQ
	9MP+xyHBAs29//NQUOGDA9CR+uA8mULTfuuOUSnx/kqmY0ULnlEiN6JtGXf7ogeT+gVYaJzu7pZMU
	gRDfM4qUJ5aLo34RbUsxL2h5erXs2COZ77NI6b5EtXNnCJHsQtMvacC8/j9QL3TG8Nm3oG7qeYXri
	kkQaEEqFUzH9f7mTiT4DRPumdoZ+b7Rf8gL7L0mMryEeEpdmbfSpIqIVd82ntffjwsUtqt/xaQ0/Q
	sThohZZRf9LXQZ6jpDhL5UVh;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWz02-00000001Puq-3NdN;
	Fri, 27 Nov 2026 16:40:38 +0000
From: Stefan Metzmacher <metze@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Cc: metze@samba.org,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	stable@vger.kernel.org
Subject: [PATCH v2 00/13] smb: smbdirect: urgent fixes for teardown races, sends and MR invalidation
Date: Fri, 27 Nov 2026 17:40:19 +0100
Message-ID: <cover.1795794871.git.metze@samba.org>
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

Hi Namjae, hi Paulo,

these are fixes for fs/smb/smbdirect:

  - Don't register MRs or post sends on a connection that is being
    torn down concurrently (NULL pointer dereferences of mr->mr and
    sc->ib.qp, reported by Sashiko).

  - Handle errors of smbdirect_iter_to_sgt(), an incomplete sg table
    was registered before.

  - A send credit leaked if the wait for a recv credit to grant
    failed, so all following sends waited until the connection was
    torn down.

  - After an error in the middle of a PDU, the fragments built so far
    were still posted, so the peer appended the next PDU to the
    incomplete one. Now the connection is torn down instead, also
    for smbd_send() of the client.

  - If the peer didn't invalidate a remotely invalidated MR, e.g.
    because of an error in the server, the client also skipped the
    local invalidation, so the peer kept access to the memory.
    smbdirect now tracks the remote invalidations itself.

  - The LOCAL_INV of an MR reused the cqe of the REG_MR and
    overwrote its done handler, so a not yet polled REG_MR completion
    finished the invalidation too early and the MR went back to the
    ready list while the LOCAL_INV was still outstanding. Now the
    LOCAL_INV has its own cqe.

  - INIT_[DELAYED_]WORK() in the connect and accept code reset the
    disable count of the work items, so a disable from a concurrent
    teardown was lost and e.g. the idle timer could be queued again
    after the socket was freed. Now the teardown sets first_error
    and disables the work items under a new lock and they are only
    activated under that lock while first_error is still 0.

  - SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}() warned about a status
    changed by a concurrent teardown, e.g. when the waiter of a
    connect was interrupted by a signal (reported by syzbot).

  - An IB_WR_REG_MR or IB_WR_LOCAL_INV posted after a status check
    that raced with smbdirect_socket_destroy() could miss the drain
    of the QP, its completion then used the mr after it was detached
    from the socket (reported by Sashiko).

  - The error paths of smbdirect_connection_send_single_iter() gave
    back credits without waking up the waiters and didn't give back
    the receive credits granted in the message that wasn't sent
    (reported by Sashiko).

  - The DMA address of the first page was used as iova of our MRs and
    sent to the peer as offset of the buffer descriptor, without an
    IOMMU these are physical addresses. Now only the offset within
    the first page is kept in the low 24 bits, the bits above up to
    bit 55 are random and the top byte stays 0. This also avoids irdma
    rejecting an MR ending exactly at 2^64 (IRDMA_AE_AMP_TO_WRAP),
    which happens with an IOMMU allocating the first 64-bit IOVA
    range at the very top.

Reports fixed by this series:

  - https://sashiko.dev/#/patchset/cover.1791225453.git.metze%40samba.org
      smb: smbdirect: don't register MRs on a torn-down connection
      smb: smbdirect: don't post sends on a torn-down connection

  - https://syzkaller.appspot.com/bug?extid=a989758ffc6f93223eb6
      smb: smbdirect: don't let INIT_[DELAYED_]WORK() undo a disable from the teardown
      smb: smbdirect: don't warn about a status changed by a concurrent teardown

  - https://sashiko.dev/#/bug/linux-4461fbd8-a522-43ee-81d1-651432a55de9
      smb: smbdirect: don't let MR work requests miss the QP drain

  - https://sashiko.dev/#/bug/linux-a2180487-c0d3-4f9a-92d7-208e032dd966
      smb: smbdirect: wake up the credit waiters after a failed send

  - https://sashiko.dev/#/bug/linux-27f04b17-0356-40b9-94be-b0b865fde826
      smb: smbdirect: give back granted receive credits if a send fails

The urgent client fixes and the ksmbd fixes are posted separately,
they are independent of these, the remaining smbdirect fixes follow
on top of all of them.

These patches were developed with the help of Claude (Anthropic),
which was used for code analysis, writing parts of the code and the
commit messages. I reviewed all changes and take full responsibility
for them.

Testing: v1 and again v2 on real hardware, client and server running
the urgent client, smbdirect and ksmbd series together, over RoCE with
mlx5 (ConnectX), irdma (Intel E810) and rxe:

  - xfstests (59 tests of the cifs and generic groups) and O_DIRECT
    reads/writes with data verification
  - removing the local address or setting the link down while a
    connection is established, the umount finishes in time
  - 10 ksmbd restarts per device while I/O is running and
    /proc/fs/cifs/DebugData is read in a loop, each restart reconnects
  - mounts killed by a signal while their RDMA connect is pending
    (the syzbot case), no tasks in D state and no warnings

Note I didn't test with iWarp as there are existing problems with it,
I have patches to fix iWarp, but I'll post them later, as they
also rely on some rdma-core changes.

As we are already late in the 7.4 cycle, I leave it up to you two to
decide if they should still go into 7.4 or into the next merge
window, all of them are marked for stable.

Changes in v2 (thanks to the review by Sashiko):

  - Patch 1: if smbdirect_connection_destroy_mr_list() already
    disabled the mr, only drop our reference, without setting
    mr->state to SMBDIRECT_MR_ERROR, which led to a second
    smbdirect_mr_io_disable_locked() with mr->socket == NULL.
  - Patch 3: fix the function name in the error message.
  - Patch 5: smbdirect_connection_send_wait_zero_pending() also waits
    for the posted messages if the connection is broken, so the
    device no longer reads the pages of the caller after it returned.
  - Patch 6: clear need_invalidate before mr->mr is deregistered, so
    smbdirect_connection_invalidate_rkey() never uses a deregistered
    mr->mr.
  - Patch 8: smbdirect_connection_recv_io_done() leaves disabling
    refill_work to smbdirect_socket_schedule_cleanup(), and refill_work
    and immediate_work are activated before the receives of the data
    transfer phase are posted, not in
    smbdirect_connection_negotiation_done(), as a receive completion
    may already queue them.
  - New patches 11-13 for the problems found by Sashiko in the
    unchanged code, the commit messages of patches 1, 4 and 5 point
    to them.
  - Dropped the Cc of Long Li, his address bounces.

v1: https://lore.kernel.org/linux-cifs/cover.1795781300.git.metze@samba.org/

Base: v7.4-rc4, like the other smb series. The patches also apply
cleanly (git am) on cifs-next (61c581ea62ee), on ksmbd-for-next
(3c31349456c5) and on both merged, with or without the urgent client
series, and build on both merged.


Stefan Metzmacher (13):
  smb: smbdirect: don't register MRs on a torn-down connection
  smb: smbdirect: don't post sends on a torn-down connection
  smb: smbdirect: handle errors from smbdirect_iter_to_sgt()
  smb: smbdirect: give back the send credit if waiting for a recv credit
    fails
  smb: smbdirect: don't post a partial PDU after a send error
  smb: smbdirect: introduce smbdirect_connection_invalidate_rkey() and
    its logic
  smb: smbdirect: use separate cqes for MR registration and invalidation
  smb: smbdirect: don't let INIT_[DELAYED_]WORK() undo a disable from
    the teardown
  smb: smbdirect: don't warn about a status changed by a concurrent
    teardown
  smb: smbdirect: don't expose DMA addresses as iova of our MRs
  smb: smbdirect: don't let MR work requests miss the QP drain
  smb: smbdirect: wake up the credit waiters after a failed send
  smb: smbdirect: give back granted receive credits if a send fails

 fs/smb/client/smbdirect.c     |  14 ++-
 fs/smb/smbdirect/accept.c     |  28 +++--
 fs/smb/smbdirect/connect.c    |  24 ++--
 fs/smb/smbdirect/connection.c | 191 +++++++++++++++++++++++++----
 fs/smb/smbdirect/internal.h   |   6 +
 fs/smb/smbdirect/listen.c     |  19 ++-
 fs/smb/smbdirect/mr.c         | 220 ++++++++++++++++++++++++++++++++--
 fs/smb/smbdirect/socket.c     | 120 ++++++++++++++-----
 fs/smb/smbdirect/socket.h     |  51 +++++++-
 include/linux/smbdirect.h     |   5 +-
 10 files changed, 584 insertions(+), 94 deletions(-)

-- 
2.43.0

