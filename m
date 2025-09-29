Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B742AD31
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 14:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759154601; cv=none; b=EYvITF6weve/6sjnCdugRCMwCQiH12qFDT4UcxptGUi6pR0b/Qnw+aD9S5lIZc0cvWg2rAVXhiYlzay18M2gXwzeEISWULhRm4p8hYVkCWOuwe5ib99+Epofy8HL5+v6kwsjF7i3yaxjYzCXS7v/q5D6WguYbx/jRrdTMm3QOnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759154601; c=relaxed/simple;
	bh=nkESez0Y5Iuz65gdRHrjg3zrM4jjK/dKO0uTwJy0xxQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=nNp2tu7AGj3UeE4cFquNgDwRN9EZi15NaWGE6nvHEpUS1aVZLmcDbJBsJ1K2GsGW0G+xb7wWdrSdC5cIZib89xfnbpDRu7W9bo4zPeqi82Tbo6mhV5GlGoKc7AajvohjYRVSMIxXCWXfLugrK9eP0xujKQU4+pyGuw+vdzdB1GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XUsS8Enm; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XUsS8Enm"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4da894db6e9so42156631cf.0
        for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 07:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759154597; x=1759759397; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gvCV0E38kKLcIlUod4X3VegCwhroPma+mna7d+ExGI8=;
        b=XUsS8EnmvEs3mnQjDel2C/cvlBgh0B8ZrTCyjIKD45SklgNn/hj5YDvxB/NcV68gaV
         h6kRC1MPjty/HEAUcgXEvdZE9nSXSaIeFZmJGBdBzT19kH7XdkadzDMkcdHk2mH5nVdp
         UKxxgqSxs7x2yfwWuR3vux0BQfwJGiL1EhiBazfPjSI4Oyf1NNKt8fPNNrJ/l3el4vJe
         EnVvBTc/EgdxvNLLCUEj6chta++7vwUoxz7PARCkqFnYJB/kNZayWnEtBNqOzAXz4TC+
         dEBa/gAoONYCmRAEhdG/PSffhrgUV3f3tU4oPPsRPiMJTexCEskHbAZavX7/V0Co6S6g
         02CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759154597; x=1759759397;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gvCV0E38kKLcIlUod4X3VegCwhroPma+mna7d+ExGI8=;
        b=LNV5Cjpxr8Y3mbkBk/yIp6NvQxwF4lfHdHVDALq3JjNoGRkEGG13Zl7mVyCMoUR/74
         RjHcEy3nwLFj0j8V3Ezh9gRcvtULAw/zgB1NYjVsLZV4EWS0ixD1jP5hMKR+yKH1I3oY
         GnXGLjZXib8WM2M0wyBhY5oPcuIqITucHJeYNrv4qtW7sSfcMoUW3/lN3Goh0XmewspQ
         +XROSKPQPBQFAI5UOnr0ALPWBFxMGKqsak2AfxqlsSCEIryb81eTfdhNBUixCf+WCcED
         BLc784K/IGJmn/f4HN1fuK3S+vtApxLHUTihahjhgG3LvH39I2ctgxRdbvxmrLzVnLvB
         31nQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzydJbZst8YUYNBzSiA6rRT2JkFNRBjMos+dPEtSbCq/J8OOObNRj/le5OJeh3e/r7F/R2CfNeUe1m@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6UtiNFyZBj9qtJrwc0di250QgD74AkZNjnL/qjj8Tbybza7Yy
	wl0/JqvOii/WDeFlsenTyv9pzsv63H5QsBASQ8Lz4bebb6apyQraIL4pEJdWMlQcCX2ulPImp2d
	PngoaCItqmxF8LYJ/+ZZdhcIE0jSFRcw=
X-Gm-Gg: ASbGncsX+BjVFmpueWEu409cQEKNM3kLm5O52lAxBm9S3LL36M1qN8PtcFj1wp3IyYe
	sBhwukZ2UMCXCbo4tQhLy31wzGmtQBIGSO8GRrrgtiFZ6AE9w3TWzsfuJJUqKVER9d2YcZhU/nM
	hAjaGNGEiOCTb8Fcq8zm2C3L16tfpDxOs8wAQPHE9PrWsxwvOc/ioDAB+L7qONUEO9f9UUskt8f
	dQtr4vR2KO50KMa63O2aZxaggl/GNRwd1fw7nXKguRKxtpa57T8G3z+6cBYm0VO29Bnj6Z5iZBw
	uGtsi7v1PV/AlQN+qucx35L/qehuce3GhAmHnxmF1j8C0gv1McC/Pl2Q2NeGdSdu
X-Google-Smtp-Source: AGHT+IHcBVwUFJza9JurNQShbGtxj1fXwGfGqch5D9Dhka+la7JRmwXDdcox/NcXnWKsqJMSy2xFXHjTHwFRhl0OMdg=
X-Received: by 2002:ad4:5745:0:b0:809:aa63:1c34 with SMTP id
 6a1803df08f44-809aa631f52mr230470906d6.32.1759154596458; Mon, 29 Sep 2025
 07:03:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 29 Sep 2025 09:03:05 -0500
X-Gm-Features: AS18NWB4G_YY0MPY_eh4Ragl8VOOliK4bmVqSFTTuMqSFnWLAhs_HTJG5aF5OTQ
Message-ID: <CAH2r5muAWS2AtzLOL_zWeWP+Xp03puRKMjs58vrT88FJXU_j+Q@mail.gmail.com>
Subject: [GIT PULL] smb3 client and server restructuring of smbdirect handling
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Stefan (metze) Metzmacher" <metze@samba.org>, Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>, 
	CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
e5f0a698b34ed76002dc5cff3804a61c80233a7a:

  Linux 6.17 (2025-09-28 14:39:22 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.18-rc-part1-smb3-common

for you to fetch changes up to 1b53426334c3c942db47e0959a2527a4f815af50:

  smb: server: let smb_direct_flush_send_list() invalidate a remote
key first (2025-09-28 18:29:54 -0500)

----------------------------------------------------------------
Large set of small restructuring smbdirect related patches for cifs.ko
and ksmbd.ko.
This is the next step  in order to use common structures for smbdirect
handling across both modules. And also includes improved handling of
broken connections, as well as fixed negotiation as rdma resources.
Moving to common functions is planned for 6.19, as well as also
providing smbdirect via sockets to userspace (e.g. for samba to also
be able to use smbdirect for userspace server and userspace client
tools).  This was heavily reviewed and tested at the recent SMB3.1.1
test event at SDC.
----------------------------------------------------------------
Stefan Metzmacher (159):
      smb: smbdirect: introduce smbdirect_socket_status_string()
      smb: smbdirect: introduce smbdirect_socket.status_wait
      smb: smbdirect: introduce smbdirect_socket_init()
      smb: smbdirect: introduce smbdirect_socket.disconnect_work
      smb: smbdirect: introduce
smbdirect_socket.send_io.pending.{count,{dec,zero}_wait_queue}
      smb: smbdirect: introduce
smbdirect_socket.send_io.credits.{count,wait_queue}
      smb: smbdirect: introduce struct smbdirect_send_batch
      smb: smbdirect: introduce smbdirect_socket.rw_io.credits
      smb: smbdirect: introduce struct smbdirect_rw_io
      smb: smbdirect: introduce smbdirect_socket.recv_io.{posted,credits}
      smb: smbdirect: introduce
smbdirect_socket_parameters.{resolve_{addr,route},rdma_connect,negotiate}_timeout_msec
      smb: smbdirect: introduce
smbdirect_socket_parameters.{initiator_depth,responder_resources}
      smb: smbdirect: introduce smbdirect_socket.rdma.legacy_iwarp
      smb: smbdirect: introduce
smbdirect_socket.idle.{keepalive,immediate_work,timer_work}
      smb: smbdirect: introduce smbdirect_socket.statistics
      smb: smbdirect: introduce smbdirect_socket.workqueue
      smb: smbdirect: introduce struct smbdirect_mr_io
      smb: smbdirect: introduce smbdirect_socket_parameters.max_frmr_depth
      smb: smbdirect: introduce smbdirect_socket.mr_io.*
      smb: smbdirect: let smbdirect_socket_init() initialize all
[delayed_]work_structs as disabled
      smb: client: fix sending the iwrap custom IRD/ORD negotiation messages
      smb: client/smbdirect: replace SMBDIRECT_SOCKET_CONNECTING with
more detailed states
      smb: client/smbdirect: introduce SMBDIRECT_SOCKET_ERROR
      smb: smbdirect: introduce smbdirect_socket.first_error
      smb: client: adjust smbdirect related output of
cifs_debug_data_proc_show()
      smb: client: use status_wait and
SMBDIRECT_SOCKET_NEGOTIATE_RUNNING for completion
      smb: client: use status_wait and
SMBDIRECT_SOCKET_RESOLVE_{ADDR,ROUTE}_RUNNING for completion
      smb: client: make use of smbdirect_socket.status_wait
      smb: client: make only use of wake_up[_all]() in smbdirect.c
      smb: client: make use of smbdirect_socket_init()
      smb: client: make use of smbdirect_socket.disconnect_work
      smb: client: make use of
smbdirect_socket.send_io.pending.{count,{dec,zero}_wait_queue}
      smb: client: make use of
smbdirect_socket.send_io.credits.{count,wait_queue}
      smb: client: make sure smbd_disconnect_rdma_work() doesn't run
after smbd_destroy() took over
      smb: client: queue post_recv_credits_work also if the peer
raises the credit target
      smb: client: make use of ib_wc_status_msg() and skip
IB_WC_WR_FLUSH_ERR logging
      smb: client: remove info->wait_receive_queues handling in smbd_destroy()
      smb: client: limit the range of info->receive_credit_target
      smb: client: count the number of posted recv_io messages in
order to calculated credits
      smb: client: make use of smbdirect_socket.recv_io.{posted,credits}
      smb: client: remove useless smbd_connection.send_immediate
      smb: client: fill smbdirect_socket_parameters at the beginning
and use the values from there
      smb: client: make use of
smbdirect_socket_parameters.{resolve_{addr,route},rdma_connect,negotiate}_timeout_msec
      smb: client: make use of
smbdirect_socket_parameters.{initiator_depth,responder_resources}
      smb: client: make use of smbdirect_socket.rdma.legacy_iwarp
      smb: client: send empty packets via send_immediate_work
      smb: client: fix smbdirect keep alive handling to match the documentation
      smb: client: make use of
smbdirect_socket.idle.{keepalive,immediate_work,timer_work}
      smb: client: remove unused smbd_connection->protocol
      smb: client: remove unused smbd_connection.count_reassembly_queue
      smb: client: make use of smbdirect_socket.statistics
      smb: client: move rdma_readwrite_threshold from smbd_connection
to TCP_Server_Info
      smb: client: make use of smbdirect_socket.workqueue
      smb: client: add and use smbd_get_parameters()
      smb: client: make use of struct smbdirect_mr_io
      smb: client: make use of smbdirect_socket_parameters.max_frmr_depth
      smb: client: make use of smbdirect_socket.mr_io
      smb: client: pass struct smbdirect_socket to {get,put}_receive_buffer()
      smb: client: pass struct smbdirect_socket to
{allocate,destroy}_receive_buffers()
      smb: client: pass struct smbdirect_socket to
{allocate,destroy}_caches_and_workqueue()
      smb: client: pass struct smbdirect_socket to
{enqueue,_get_first}_reassembly()
      smb: client: pass struct smbdirect_socket to {allocate,destroy}_mr_list()
      smb: client: pass struct smbdirect_socket to
smbd_disconnect_rdma_connection()
      smb: client: pass struct smbdirect_socket to smbd_post_recv()
      smb: client: pass struct smbdirect_socket to
manage_credits_prior_sending()
      smb: client: pass struct smbdirect_socket to smbd_post_send()
      smb: client: pass struct smbdirect_socket to
manage_keep_alive_before_sending()
      smb: client: pass struct smbdirect_socket to smbd_post_send_iter()
      smb: client: pass struct smbdirect_socket to smbd_post_send_empty()
      smb: client: pass struct smbdirect_socket to smbd_post_send_full_iter()
      smb: client: pass struct smbdirect_socket to smbd_conn_upcall()
      smb: client: pass struct smbdirect_socket to smbd_qp_async_error_upcall()
      smb: client: pass struct smbdirect_socket to smbd_create_id()
      smb: client: pass struct smbdirect_socket to smbd_ia_open()
      smb: client: pass struct smbdirect_socket to
smbd_post_send_negotiate_req()
      smb: client: pass struct smbdirect_socket to smbd_negotiate()
      smb: client: pass struct smbdirect_socket to get_mr()
      smb: client: remove unused struct smbdirect_socket argument of
smbd_iter_to_mr()
      smb: client: let smbd_disconnect_rdma_connection() set
SMBDIRECT_SOCKET_ERROR...
      smb: client: fill in smbdirect_socket.first_error on error
      smb: client: let smbd_disconnect_rdma_connection() disable all
work but disconnect_work
      smb: client: let
smbd_{destroy,disconnect_rdma_{work,connection}}() wake up all wait
queues
      smb: client: make consitent use of spin_lock_irq{save,restore}()
in smbdirect.c
      smb: client: allocate smbdirect workqueue at the beginning of
_smbd_get_connection()
      smb: client: defer calling ib_alloc_pd() after we are connected
      smb: client: let smbd_post_send_iter() call ib_dma_map_single()
for the header first
      smb: server: fix IRD/ORD negotiation with the client
      smb: server: make use of common smbdirect_pdu.h
      smb: server: make use of common smbdirect.h
      smb: server: make use of common smbdirect_socket
      smb: server: make use of common smbdirect_socket_parameters
      smb: server: make use of smbdirect_socket->recv_io.expected
      smb: server: make use of struct smbdirect_recv_io
      smb: server: make use of smbdirect_socket.recv_io.free.{list,lock}
      smb: server: make use of smbdirect_socket.recv_io.reassembly.*
      smb: server: make use of SMBDIRECT_RECV_IO_MAX_SGE
      smb: server: make use of struct smbdirect_send_io
      smb: server: make use of smbdirect_socket.{send,recv}_io.mem.{cache,pool}
      smb: server: make only use of wake_up[_all]() in transport_rdma.c
      smb: server: add a pr_info() when the server starts running
      smb: server: queue post_recv_credits_work in put_recvmsg() and
avoid count_avail_recvmsg
      smb: server: make use of smbdirect_socket.status_wait
      smb: server: only turn into SMBDIRECT_SOCKET_CONNECTED when
negotiation is done
      smb: server: move smb_direct_disconnect_rdma_work() into free_transport()
      smb: server: don't wait for info->send_pending == 0 on error
      smb: server: make use of smbdirect_socket_init()
      smb: server: make use of smbdirect_socket.disconnect_work
      smb: server: make use of
smbdirect_socket.send_io.pending.{count,zero_wait_queue}
      smb: server: make use of
smbdirect_socket.send_io.credits.{count,wait_queue}
      smb: server: make use of struct smbdirect_send_batch
      smb: server: make use smbdirect_socket.rw_io.credits
      smb: server: make use of struct smbdirect_rw_io
      smb: server: take the recv_credit_target from the negotiate req
and always limit the range
      smb: server: manage recv credits by counting posted recv_io and
granted credits
      smb: server: make use of smbdirect_socket.recv_io.{posted,credits}
      smb: server: replace smb_trans_direct_transfort() with SMBD_TRANS()
      smb: server: remove useless casts from KSMBD_TRANS/SMBD_TRANS
      smb: server: pass ksmbd_transport to get_smbd_max_read_write_size()
      smb: server: fill smbdirect_socket_parameters at the beginning
and use the values from there
      smb: server: make use of
smbdirect_socket_parameters.negotiate_timeout_msec and change to 5s
      smb: server: make use of
smbdirect_socket_parameters.{initiator_depth,responder_resources}
      smb: server: make use of smbdirect_socket.rdma.legacy_iwarp
      smb: server: make use of smbdirect_socket.idle.immediate_work
      smb: server: implement correct keepalive and timeout handling
for smbdirect
      smb: server: make use of smbdirect_socket.workqueue
      smb: server: pass struct smbdirect_socket to {get_free,put}_recvmsg()
      smb: server: pass struct smbdirect_socket to
smb_direct_{create,destroy}_pools()
      smb: server: pass struct smbdirect_socket to smb_direct_get_max_fr_pages()
      smb: server: pass struct smbdirect_socket to smb_direct_init_params()
      smb: server: pass struct smbdirect_socket to
smb_direct_disconnect_rdma_connection()
      smb: server: pass struct smbdirect_socket to smb_direct_cm_handler()
      smb: server: pass struct smbdirect_socket to smb_direct_qpair_handler()
      smb: server: pass struct smbdirect_socket to smb_direct_create_qpair()
      smb: server: pass struct smbdirect_socket to smb_direct_post_recv()
      smb: server: pass struct smbdirect_socket to smb_direct_accept_client()
      smb: server: pass struct smbdirect_socket to
smb_direct_prepare_negotiation()
      smb: server: pass struct smbdirect_socket to smb_direct_connect()
      smb: server: pass struct smbdirect_socket to
smb_direct_{alloc,free}_sendmsg()
      smb: server: remove unused struct struct smb_direct_transport
argument from smb_direct_send_ctx_init()
      smb: server: pass struct smbdirect_socket to smb_direct_post_send()
      smb: server: pass struct smbdirect_socket to smb_direct_flush_send_list()
      smb: server: pass struct smbdirect_socket to wait_for_credits()
      smb: server: pass struct smbdirect_socket to wait_for_send_credits()
      smb: server: pass struct smbdirect_socket to wait_for_rw_credits()
      smb: server: pass struct smbdirect_socket to calc_rw_credits()
      smb: server: pass struct smbdirect_socket to
manage_credits_prior_sending()
      smb: server: pass struct smbdirect_socket to
manage_keep_alive_before_sending()
      smb: server: pass struct smbdirect_socket to smb_direct_create_header()
      smb: server: pass struct smbdirect_socket to post_sendmsg()
      smb: server: pass struct smbdirect_socket to smb_direct_post_send_data()
      smb: server: pass struct smbdirect_socket to
{enqueue,get_first}_reassembly()
      smb: server: pass struct smbdirect_socket to
smb_direct_send_negotiate_response()
      smb: server: let smb_direct_disconnect_rdma_connection() set
SMBDIRECT_SOCKET_ERROR...
      smb: server: fill in smbdirect_socket.first_error on error
      smb: server: let smb_direct_disconnect_rdma_connection() disable
all work but disconnect_work
      smb: server: let
{free_transport,smb_direct_disconnect_rdma_{work,connection}}() wake
up all wait queues
      smb: server: make consitent use of spin_lock_irq{save,restore}()
in transport_rdma.c
      smb: server: make use of ib_alloc_cq_any() instead of ib_alloc_cq()
      smb: server: let smb_direct_flush_send_list() invalidate a
remote key first

 fs/smb/client/cifs_debug.c                 |   81 +-
 fs/smb/client/cifsglob.h                   |    9 +-
 fs/smb/client/file.c                       |   16 +-
 fs/smb/client/smb2ops.c                    |    8 +-
 fs/smb/client/smb2pdu.c                    |    2 +-
 fs/smb/client/smbdirect.c                  | 1199 +++++++++++++--------
 fs/smb/client/smbdirect.h                  |  102 +-
 fs/smb/common/smbdirect/smbdirect.h        |    7 +
 fs/smb/common/smbdirect/smbdirect_socket.h |  319 +++++-
 fs/smb/server/connection.c                 |    4 +-
 fs/smb/server/connection.h                 |   10 +-
 fs/smb/server/server.c                     |    1 +
 fs/smb/server/smb2pdu.c                    |   23 +-
 fs/smb/server/smb2pdu.h                    |    6 -
 fs/smb/server/transport_rdma.c             | 1615 ++++++++++++++++------------
 fs/smb/server/transport_rdma.h             |   45 +-
 16 files changed, 2061 insertions(+), 1386 deletions(-)



-- 
Thanks,

Steve
