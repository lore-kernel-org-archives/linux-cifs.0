Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F97D3EBF14
	for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 00:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770856331; cv=pass; b=IXLWtYhDJ6JBR7TyD3Fb0kEAVgN71i4VSR4nahQwuxlAAHoleO86kU3UWccxFwBreUfarKkDnz4ePUFcPkqCVw29uj1gnTVRphSSank6FrHRzAQeUNM2/sIx7BoY1Y4dcrs1rMRerTcrlplUNdADnLsZc2JdFRzEznEZFCIsBg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770856331; c=relaxed/simple;
	bh=vKNpn8GtpL/nhtIMbSOe64hHz7EkbugkBIhJsonLbzU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=aWdKmrzgAuxRxsvww7lqY2f7d1YrMlNXfKkBAhg2fN79A9IQ8/TVvUBmWyGaZEC3ffaojRYPiUalsZIFaTQQhT5iQCCMQTxUHJwliZkJ8kFRS59Kn6X2/5y9zphUnO7nw/Jy1//18J7GeITFwd7ZfusIkgiSFGIKFT0T6fzyFOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ju1DSoCh; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ju1DSoCh"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-896fa834290so20567916d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 11 Feb 2026 16:32:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770856329; cv=none;
        d=google.com; s=arc-20240605;
        b=a/kCIQX5YRkB0YFtuAIjEMT+pDfC9MOFBzff71Qd+DHNH677iJbrQoB2vFLHoxgEbc
         w+2HwNidk4E2KUCdWIBf3D26pTHJEMLbSRZ0HIC7w7uh42sWC6ozFXkeX2hbtf+/zAll
         zs9oSKU/KcxP39ozcyTur4XcxGVJYukulCGyzBY+e6dB57mZqEfE0ckygKDI9Vtab6mF
         GJAcXMZdCYsTocleyLp9hML4GKc65e9zOfR7oOCI3MFaVVs5uvc5ECd/Oh9LRLRP26/+
         fvZ0A0xjAzkFTo0hwgpR6E/G2AfQnAwsdSx9fhsvHfLfX2ksWSwoI1AIleAu3x7ef0Bz
         2QGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=El0pFvkU5/13MaF9hcPBAChDOMBsux3PNwLGjQhFLns=;
        fh=Ao8QO2NRkVNpg50aDtEfGzYBRajfYESqBtUu7FU2hQM=;
        b=C8G9SSZ/0RJ4R1OSCj04T8Je5mMim8DxULvssjGNByU6UuKfhDgRbNzBcxjkMtD4zG
         sryqvD8/LArPmRBsIqN0lUqeuVJT0foS2xbYN5JO/xTfp7eUzZvZY2rng3hGvUqgy+dI
         Rv+hEqHg8ceAevXG50SitfJhD7SygDFI25Xa5mn9a+hG9h4IHL0tdH4gkqkiKbO4tN6+
         TH82JCDbkz8WomaZSjfupuLuIoVpdrlqebFGx9x/2NQvFUcutPkQFR9KpkICb3Cop1Gb
         dC+3sseBAqqwJKLrEXjYbzHWytWT2nSiXI1GzG7/OTvk6PtNa5vQdWpLE7TVM3mEf7bg
         +6ug==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770856329; x=1771461129; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=El0pFvkU5/13MaF9hcPBAChDOMBsux3PNwLGjQhFLns=;
        b=Ju1DSoChs0lvsNKDheQcMKUT8xY8Rnq1nBD6TTsMo92yJ6H1GCwJBNiWxujHrGvbTU
         mLiEeQ0SuS41H9MfFr6nQ6qRnrygG8YSct7PsO1rEgUb2iTWVIUjPLcEDzz48opN1qK/
         v0ZzrV5QsBOPj3v+JuAhvi+59E+UONqsKl5MY2wz3Sni8M+X0LlFwu0czq5suEaq7BGd
         yI51XCvQRnk4fW6ZHOwee3rymegKV3ba5qYKiowEmLnkeQ7Atmf7YCp3RSrrl4SV4IwW
         9TamfvvhtCmtF7tPBxeXaIyc4AehDfG1RHz9l4OSUeRV8LDy7bT0aKM+dQl5Ul7zixqO
         PZxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770856329; x=1771461129;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=El0pFvkU5/13MaF9hcPBAChDOMBsux3PNwLGjQhFLns=;
        b=fN7Sv0XKLDGjdOpVLXOD7mqSNdts4coukZdZhgB7dFCl+L07eChlk57kzcBJ6Zzw/c
         jRhO0ovHM/Pyu6AAw/X8kV02WW+zNVP4BfRay72una4B92p9+dS3B/HN7QprY2BEv3YU
         bnJzv9rMfvgcSKXiCir5NSdX7Sj5pq7g8bf4n6Tbwf+Ku00OcM5qkOcyxcDl1dUJZg0T
         WKLIFXTV8wDEND02tAppi5f9l57X/7tjyRb9htL6ZAWu6Qw6cafLa4PhwBPUpviBswZW
         PiQpxNPbMfArPT2C17MHEXlAk3oF443CN2o6yxQL6sVUN3LCmQda1dl3ltMZKNxoLN3T
         Onjw==
X-Forwarded-Encrypted: i=1; AJvYcCUtvjh40FeLbjgcncKtf/ttR29GrIdsH7jOL+Ak/m1ot4wC4bh86g2V9jERLzTwJ4SZehcd4l4x7+Vt@vger.kernel.org
X-Gm-Message-State: AOJu0YwDZEahJTQJCLrHF5Hpk3upDwvpj96RY54DBuhvgiGhrPpc0qza
	emNaC2EhyYhG3UQWC/7tG7T7rccTLGj48CJrTwhcn8vfZcCXpCfNxnw+NsaO+oi+wp+jXHz9foT
	2AjZqpDe0tKryUd6MLCADusFuTjE2qhQq+eCH
X-Gm-Gg: AZuq6aKJv2lGbal0HoVKjagblZakvlTDJBNRYeuDcWoFpaTQW80ZrKJNAxmG+WFf5Wp
	dGjkVz4zROHAkjL2DXV4YQwtuLJQKR3frh7Z3Ewegcv0edKU/pKz6wlejTLVOwcxjx84E1SuupF
	H9hKv4PWYwwtaii7qXgbmebS9VC/qCah0geLXS7yXJqg6O4bKAYyPVHTkPyMGyClTJpIqQ14cW7
	kil+hoVD7mHpT6F8J98Zt7G+5cn2IZop1QqPnoD96GhGWLl/eiIBramyJ+pzgIezQQu7pQPCZys
	TYfuJXVWkZZUn9tG5OxJDBimwFl5wn005EUTUGYalta9eu/blw3tx1igPIolY8ElOPAK0EvpJEw
	whEaUs6NAsfq0QyeZQYedltzpf/sc8UbhspHkEmwF9yZMOWbQrbNSNB22HFXVWNc=
X-Received: by 2002:a05:6214:ac7:b0:896:f79d:ae52 with SMTP id
 6a1803df08f44-89728ef8ce4mr13191506d6.28.1770856329238; Wed, 11 Feb 2026
 16:32:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 11 Feb 2026 18:31:56 -0600
X-Gm-Features: AZwV_QiX7D1Et9F9x9iJr5k7wk9Sx5Fdkz15xed_au8GnjetBsrPG9Pd5tun-ug
Message-ID: <CAH2r5mspbOKxugfaCoZB1qgO3Bt0Qw3wNPLfNQYf8ZGaYLPXTg@mail.gmail.com>
Subject: [GIT PULL] ksmbd server and smbdirect fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
05f7e89ab9731565d8a62e3b5d1ec206485eeb0b:

  Linux 6.19 (2026-02-08 13:03:27 -0800)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.0-rc-part1-ksmbd-and-smbdirect-fixes

for you to fetch changes up to 8f7df60fe063b6b8f039af1042a4b99214347dd1:

  ksmbd: fix non-IPv6 build (2026-02-10 12:58:10 -0600)

----------------------------------------------------------------
32 ksmbd and smbdirect (RDMA) fixes
 - Fix tcp connection leak
 - Fix potential use after free when freeing multichannel
 - Fix locking problem in showing channel list
 - Locking improvement for tree connection
 - Fix infinite loop when signing errors
 - Add /proc interface for monitoring server state
 - Fixes to avoid mixing iWarp and InfiniBand/RoCEv1/RoCEv2 port
ranges used for smbdirect
 - Fixes for smbdirect credit handling problems,
these make the connections more reliable
----------------------------------------------------------------
Arnd Bergmann (1):
      ksmbd: fix non-IPv6 build

Bahubali B Gumaji (1):
      ksmbd: add procfs interface for runtime monitoring and statistics

Henrique Carvalho (1):
      smb: server: fix leak of active_num_conn in ksmbd_tcp_new_connection()

Namjae Jeon (4):
      ksmbd: fix infinite loop caused by next_smb2_rcv_hdr_off reset
in error paths
      ksmbd: add chann_lock to protect ksmbd_chann_list xarray
      ksmbd: fix missing chann_lock while iterating session channel list
      ksmbd: convert tree_conns_lock to rw_semaphore

Stefan Metzmacher (25):
      smb: smbdirect: introduce smbdirect_socket.recv_io.credits.available
      smb: smbdirect: introduce smbdirect_socket.send_io.bcredits.*
      smb: server: make use of smbdirect_socket.recv_io.credits.available
      smb: server: let recv_done() queue a refill when the peer is low
on credits
      smb: server: make use of smbdirect_socket.send_io.bcredits
      smb: server: fix last send credit problem causing disconnects
      smb: server: let send_done handle a completion without IB_SEND_SIGNALED
      smb: client: make use of smbdirect_socket.recv_io.credits.available
      smb: client: let recv_done() queue a refill when the peer is low
on credits
      smb: client: let smbd_post_send() make use of request->wr
      smb: client: remove pointless sc->recv_io.credits.count rollback
      smb: client: remove pointless sc->send_io.pending handling in
smbd_post_send_it
er()
      smb: client: port and use the wait_for_credits logic used by server
      smb: client: split out smbd_ib_post_send()
      smb: client: introduce and use smbd_{alloc, free}_send_io()
      smb: client: use smbdirect_send_batch processing
      smb: client: make use of smbdirect_socket.send_io.bcredits
      smb: client: fix last send credit problem causing disconnects
      smb: client: let smbd_post_send_negotiate_req() use smbd_post_send()
      smb: client: let send_done handle a completion without IB_SEND_SIGNALED
      RDMA/core: introduce rdma_restrict_node_type()
      smb: client: make use of rdma_restrict_node_type()
      smb: server: make use of rdma_restrict_node_type()
      smb: client: correct value for smbd_max_fragmented_recv_size
      smb: server: correct value for smb_direct_max_fragmented_recv_size

 drivers/infiniband/core/cma.c              |  30 ++
 drivers/infiniband/core/cma_priv.h         |   1 +
 fs/smb/client/smbdirect.c                  | 568 ++++++++++++++++++++++-------
 fs/smb/common/smbdirect/smbdirect_socket.h |  18 +
 fs/smb/server/Makefile                     |   1 +
 fs/smb/server/connection.c                 |  59 +++
 fs/smb/server/connection.h                 |   5 +-
 fs/smb/server/mgmt/tree_connect.c          |  36 +-
 fs/smb/server/mgmt/user_config.c           |   6 +-
 fs/smb/server/mgmt/user_config.h           |   2 +-
 fs/smb/server/mgmt/user_session.c          | 231 +++++++++++-
 fs/smb/server/mgmt/user_session.h          |   8 +-
 fs/smb/server/misc.h                       |  30 ++
 fs/smb/server/proc.c                       | 134 +++++++
 fs/smb/server/server.c                     |  15 +-
 fs/smb/server/smb2ops.c                    |   4 +
 fs/smb/server/smb2pdu.c                    |  23 +-
 fs/smb/server/smb_common.c                 |  24 ++
 fs/smb/server/smb_common.h                 |   2 +
 fs/smb/server/stats.h                      |  73 ++++
 fs/smb/server/transport_rdma.c             | 297 ++++++++++++---
 fs/smb/server/transport_tcp.c              |   3 +-
 fs/smb/server/vfs.c                        |   3 +
 fs/smb/server/vfs_cache.c                  |  94 +++++
 include/rdma/rdma_cm.h                     |  17 +
 25 files changed, 1483 insertions(+), 201 deletions(-)
 create mode 100644 fs/smb/server/proc.c
 create mode 100644 fs/smb/server/stats.h


-- 
Thanks,

Steve
