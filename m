Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795782565;
	b=uoakkpdR6+9WtGtriEXqqUAh9e55qBJiyuFNNzB2mE5WsJPzCwhCb5ZlSBC9zwS/DgT5
	 yTQLw1deUiAs3MTHye3uOnK4UyvgTH8YCk7ihIrc9Dwn7U6ATLm6bEaD4T83P/zW2ialk
	 4CN6w91t/pgKPpHSIyozJFrrQ0vUfdK+aDeAoxytKzEXZe6vRv6olOl3qNbnMq7dlqZMP
	 kMrHYU4epHAWgHxpvjnOQ4hSSj+OuDxw51/FatX1lBm57nuLKvQRr2tjJwtYtZ48vtPa2
	 EIY9CY0e8izrMXUho/PvTVpwooMyyJQWotXZlg1W3VZ3bH11TiSIcunb3BEDbWR7xqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795782565;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=XQv/Wcxl9zbJPscLOdJ+KGmWKq237rOhIM+Uy6t0xuU=;
	b=LLusj3sJtzSCDigLdZUpaAcJIyW/QWCj0Kf0Z83e9SA0F3ivPF/BHeoV+rBY7S5Xj2k6
	 KtsGDDfiAvmD7qnV1krdgLQF88iITT2h6W+P8QHJ++n39mLkvUagmahU8XIvVI1tGOv+P
	 O4aU7swTtP+ZR+IwtGNlSfTIZaVCsofBEcmXbdd9sjsbnFoA29QF2Eg657Z+XSWe2iJZA
	 5HSkdVE7AwkoEQNBmdQwRWhJwl541rFFDYJ8+pYIpaZNnTyJXGt9KCFsQ1Qi7KsG9UC0M
	 ymhJZDPffafLA7OdN58nhpaI2impXhQLrDjaBXzbQmkofDqz6xoFy3utCLdvK57FucA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=yF7EjKeF;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C08606A31C;
	Fri, 27 Nov 2026 12:29:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9C08606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key, unprotected) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=yF7EjKeF
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=XQv/Wcxl9zbJPscLOdJ+KGmWKq237rOhIM+Uy6t0xuU=; b=yF7EjKeFu044/ZRkTGDnKaVUQo
	VyelBF4qgcjhakL+ke3LtCnxxKZ31FlM6Fz2B2IWJypMeZWddA5gqXAmQ1j5+YGZ9G7A6O0s0s9Jy
	o9t77oNcmpTUhy3JYEAfV1lRUpezgGWrfmXr9HsXClGZj1ZtbXrKVEv9y+p8cUB65gK2Md8v/Kv7N
	fJ7kVUgghKXE77X/nn6GDUfEJmd8SKQH9SCBrXqtQ93otP/AYa6ky1nq9Yn56H5Fyr+cMhKODbfdE
	sPeU2+/PA+Wq5rG+a6ZOp33+Z1jQpk9k7rzTxa3+EZMPnovOXu/U7tSmejELrz1q+tfsFrAaIAK9u
	oFmMcH3Jh9+f80Lz5Iw6GwGjKUQn/HLUCaxkDgetpQN5sbVhy4uWU2q8ZhKJYNedm5TAzI4Hvt+an
	FFpmJGUqy2QirFGxUEUi4dYwk2AZZ9xWDZsWqpegaNaqR4rZFCTpeU/5a5Qe/HaiL6/e9pvuSn+9L
	+cWQ5Hp21VMr0LFNJg+1IdeH;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWv4r-00000001LZP-0Y43;
	Fri, 27 Nov 2026 12:29:21 +0000
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
Subject: [PATCH 0/10] smb: smbdirect: urgent fixes for teardown races, sends and MR invalidation
Date: Fri, 27 Nov 2026 13:28:57 +0100
Message-ID: <cover.1795781300.git.metze@samba.org>
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

The urgent client fixes and the ksmbd fixes are posted separately,
they are independent of these, the remaining smbdirect fixes follow
on top of all of them.

These patches were developed with the help of Claude (Anthropic),
which was used for code analysis, writing parts of the code and the
commit messages. I reviewed all changes and take full responsibility
for them.

Testing: on real hardware, client and server running the urgent
client and smbdirect series together, over RoCE with mlx5 (ConnectX),
irdma (Intel E810) and rxe:

  - xfstests (59 tests of the cifs and generic groups) and O_DIRECT
    reads/writes with data verification
  - removing the local address or setting the link down while a
    connection is established, the umount finishes in time
  - 2x10 ksmbd restarts while I/O is running and
    /proc/fs/cifs/DebugData is read in a loop, each restart reconnects
  - mounts killed by a signal while their RDMA connect is pending
    (the syzbot case), no tasks in D state and no warnings

Note I didn't test with iWarp as there are existing problems with it,
I have patches to fix iWarp, but I'll post them later, as they
also rely on some rdma-core changes.

As we are already late in the 7.4 cycle, I leave it up to you two to
decide if they should still go into 7.4 or into the next merge
window, all of them are marked for stable.

Base: v7.4-rc4, like the other smb series. The patches also apply
cleanly (git am) on cifs-next (61c581ea62ee), on ksmbd-for-next
(3c31349456c5) and on both merged, with or without the urgent client
series, and build on both merged.

Stefan Metzmacher (10):
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

 fs/smb/client/smbdirect.c     |  14 ++-
 fs/smb/smbdirect/accept.c     |  26 +++--
 fs/smb/smbdirect/connect.c    |  22 +++--
 fs/smb/smbdirect/connection.c | 139 +++++++++++++++++++++++---
 fs/smb/smbdirect/internal.h   |   2 +
 fs/smb/smbdirect/listen.c     |  19 +++-
 fs/smb/smbdirect/mr.c         | 178 +++++++++++++++++++++++++++++++---
 fs/smb/smbdirect/socket.c     | 118 ++++++++++++++++------
 fs/smb/smbdirect/socket.h     |  51 ++++++++--
 include/linux/smbdirect.h     |   5 +-
 10 files changed, 495 insertions(+), 79 deletions(-)

-- 
2.43.0

