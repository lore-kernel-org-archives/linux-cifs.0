Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E249B1F09A5
	for <linux-cifs@vger.kernel.org>; Sun, 21 Sep 2025 21:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758491134; cv=none; b=j/JsYLII6L8F8z2ItrGl9wHGCFA/6NEhInLpuUL0pWwV39qHmH3xJMzUbWfa0Lr2cr69yMj247MozaKjQ/QPrTmznRoowv3jfsVQDKHyEmMJhV7f8XvI+ZkTYRcn+vewCjaDvJxSxa/cU2yuekmGe74Lgj/L1Oiqy10he06Bl+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758491134; c=relaxed/simple;
	bh=9vI2FOTD0S/7GTz0gSqR/mUrukue87w04FAcxKg4DMc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qZwZ04WI+ab7ps5mLwNttzx5af0FO92t24ymZAqzA5HE+NIuwaGmtixRDJ7bMOezx0y5c+uLBPn5UMamRnLrbSr0BMfw+bg8jPJzBFnj6sb8RAvBBDTgRo1MsAeMnji3aolkamf5FXZBfhrDrDMJdHIEDDZvneur3ubhmh6C3RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ebYcaTkH; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ebYcaTkH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=rz1x2p+kZcks6PcfkDJEI4VuC2ZiaeIdhVgUw0SbpIs=; b=ebYcaTkHtIGJxit7ELdsPFMTMD
	E/EfFXmfZBNAIDwkcCIuawdqz+l6KtWhw4cYT+b7D6QWH+wCGY5rY3vcwpUlOpRWWlzhsZHz4WstE
	RM6SJrzGeCFUniyEK/hEQobmwxM2GUmFlmcuXLx11Vu6cnKTIqkptp5Py6HMgyFLzQYFs+lDE8C+X
	boGjmtIQTC9hCuquBOS26ijA0tiN9o4D/lp5Xn5RACRx5aNoJhUCkrLVJRTZGkGyCaFM6Jc4WuJgZ
	jxf6Eyarv4ZQqYKlXjXUtKcO5Z3NNdnpDhyKUsl2CJ4RKFkh1I/j34js9M77LZN/6faFxSbyTI2gv
	swomwpIcBlSuJPjYgHhX7y2MHWQSblBkFAAf5F+VO9/cneCsAFPeU7PmBbbbjTbkBrBG4ZEMU+CiO
	0cP5tGNUtnBZPhNcnLltpuQoVZzyoKR8tjhDFHDESuN60F1RjZShfUDBtNlzTyF/OVAoVtEwkx99/
	Z/o9oJEgvtKgzsOI5zeb0S1c;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v0Rs3-005GM3-0U;
	Sun, 21 Sep 2025 21:45:23 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 00/18] smbdirect/client/server: improved error handling and other small improvements
Date: Sun, 21 Sep 2025 23:44:47 +0200
Message-ID: <cover.1758489988.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

here are some patches basically on top of the other
smbdirect patches, which let us use common structures, see:
https://lore.kernel.org/linux-cifs/cover.1756139607.git.metze@samba.org/

They improve the error handling in all kind of situations,
we now consistently reset SMBDIRECT_SOCKET_CONNECTED on
the first error and wake up all waiters to notice
the state change.

We also disable all work consistently on error.

We consistently use spin_lock_irq{save,restore}() now.

There are also some improvements in order to make
further refactoring easier:
 - E.g. move ib_alloc_pd() and ib_dma_map_single() on the client.
 - On the server use ib_alloc_cq_any()
 - let smb_direct_flush_send_list() invalidate a remote key in
   the first message

Some of these are already in Steve's for-next-next branch.
I'll soon provide a branch that can replace for-next-next,
as some of these patches should be moved before some existing
patches, while dropping some of the patches from for-next-next.
So that we only have patches for 6.18 included, the rest will
be deferred to 6.19.

Stefan Metzmacher (18):
  smb: smbdirect/client: introduce SMBDIRECT_SOCKET_ERROR
  smb: smbdirect: let smbdirect_socket_init() initialize all
    [delayed_]work_structs as disabled
  smb: smbdirect: introduce smbdirect_socket.first_error
  smb: client: let smbd_disconnect_rdma_connection() set
    SMBDIRECT_SOCKET_ERROR...
  smb: client: fill in smbdirect_socket.first_error on error
  smb: client: let smbd_disconnect_rdma_connection() disable all work
    but disconnect_work
  smb: client: let smbd_{destroy,disconnect_rdma_{work,connection}}()
    wake up all wait queues
  smb: client: make consitent use of spin_lock_irq{save,restore}() in
    smbdirect.c
  smb: client: allocate smbdirect workqueue at the beginning of
    _smbd_get_connection()
  smb: client: defer calling ib_alloc_pd() after we are connected
  smb: client: let smbd_post_send_iter() call ib_dma_map_single() for
    the header first
  smb: server: let smb_direct_disconnect_rdma_connection() set
    SMBDIRECT_SOCKET_ERROR...
  smb: server: fill in smbdirect_socket.first_error on error
  smb: server: let smb_direct_disconnect_rdma_connection() disable all
    work but disconnect_work
  smb: server: let
    {free_transport,smb_direct_disconnect_rdma_{work,connection}}() wake
    up all wait queues
  smb: server: make consitent use of spin_lock_irq{save,restore}() in
    transport_rdma.c
  smb: server: make use of ib_alloc_cq_any() instead of ib_alloc_cq()
  smb: server: let smb_direct_flush_send_list() invalidate a remote key
    first

 fs/smb/client/smbdirect.c                  | 224 +++++++++++++++------
 fs/smb/common/smbdirect/smbdirect_socket.h |  24 +++
 fs/smb/server/transport_rdma.c             | 157 ++++++++++++---
 3 files changed, 309 insertions(+), 96 deletions(-)

-- 
2.43.0

