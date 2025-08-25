Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C75288CBF
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154535; cv=none; b=KpKInf7ksNX4ZNp26wQ1s3Z+/5qZ0bhRCFxQ45892siArDLfPLt2KpqWlS0YiKQ704DBMA1vP64mgOv0Kua9h8YMbWV8upRdq2UEwUQUha6pJkG01hg7JgqebIIxMOFRkRATuvEmkcNvOEhkCiDRptaug+awVdeufqDqrpAFOVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154535; c=relaxed/simple;
	bh=fgCRYpIS3+97kN8dljNk9iBKNb/qWVjjELcHLFFSb3A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MinXA2ZmUObdWhUBxpKwSmdLfeQVaj7DyfMNnjRHehJcP2AD9zKrv7TvTJDENaxVvehAGVqH7+ot6U/9agYgsrX5rDQoPccYHn/HydQdrvbGwH/e0WeOMwh4GwQdepWRT5sxfN+TIBm4roin15A8ikbge7KDh1pgn5fio3yInPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=hem+ykzX; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="hem+ykzX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=I4+NpdNENDuh009mGyZEN4lO2aPdxnXizIms4TbJ9RE=; b=hem+ykzXgRab0bzLqzyl9BRRMk
	ybL1QPQ2DaNhIlIxukr59QNkWhuts/KNnSPA0M7PQtZf0PLskfhOMQr89GjjSrlN/ynHrmxWLoBVk
	u4QMc7p31dqEPNE73XURIMC4n486qSBZXJx6xl6JVEGJg/QV1Zn1d7rMS4NXuGQjYogkuA2ucLHVd
	OSQLx6jFFcVDGY0TCfrZR8eFdvo6Jqe6GSb7/cN3RCsFL6zK2XDM16ORrpLzRWBzF+f0EkAkOkiIT
	EDFZ759zrikpM0CUZfLPaIbn7LpmjxMM6chc+8PPvh+ag0jVJFWP3esxpz2TsIPMLP+eGPPONHeEl
	Q9sv2BFKRML7ntmgWOlVmSOPnZWm6xEg8vImnWwwmlCADvLeP2w2NgE2x87BFITMZXCh19OWWDspp
	oCrdX9hbd5JIq4N4NY7jwFtascT7mWkBetSXJM6CcPyQdQB2DPExgyruHGVhWXQ9njHtkiGAETLru
	OqGULDgHJpgYwHlc/Qrpx0Pm;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe0y-000jIt-1Y;
	Mon, 25 Aug 2025 20:42:04 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 000/142] smb: smbdirect/client/server: make use of common structures
Date: Mon, 25 Aug 2025 22:39:21 +0200
Message-ID: <cover.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

this is the next step towards a common smbdirect layer
between cifs.ko and ksmbd.ko, with the aim to provide
a socket layer for userspace usage at the end of the road.

Note the patchset is based on v6.17-rc3 plus the following
patches from sfrench-cifs-2.6/for-next:
21d14611210d0bdf6b0c6db45c2361e96e6673d4
smb3 client: fix return code mapping of remap_file_range
a21e20edf966db8d3e0e0748a9201fbd62fd961a
smb: client: Fix mount deadlock by avoiding super block iteration in DFS reconnect
plus the client and server fixes for the IRD/ORD negotiation:
https://lore.kernel.org/linux-cifs/20250821093113.36212-1-metze@samba.org/
https://lore.kernel.org/linux-cifs/20250821092751.35815-1-metze@samba.org/
But only the IRD/ORD patches are really required in order to
apply the patchset. It can also be found as branch for-6.18/fs-smb-20250825-v4
in https://git.samba.org/metze/linux/wip.git, see
https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/for-6.18/fs-smb-20250825-v4

This patchset introduces more common structures and elements
to struct smbdirect_socket[_parameters]. (Patches 001-018)

The client side is modified in tiny steps in order
to use the new common structures. At the end
struct smbd_connection is only a simple container
arround struct smbdirect_socket. For now I left
it that way in order to avoid changing the smb layer
to use struct smbdirect_socket. In the end I'd like to
expose only an anonymous structure to the smb layer
and struct smbdirect_socket will become a private structure.
(Patches 019-075). In between there are some fixes for
the keepalive and timeout handling.

Note that 047 smb: client: make use of smbdirect_socket.statistics
generates the following warnings from scripts/checkpatch.pl --quiet
 WARNING: quoted string split across lines
 #40: FILE: fs/smb/client/cifs_debug.c:464:
 +               seq_printf(m, "\nDebug count_get_receive_buffer: %llx "
 +                       "count_put_receive_buffer: %llx count_send_empty: %llx",
 
 WARNING: quoted string split across lines
 #47: FILE: fs/smb/client/cifs_debug.c:469:
                 seq_printf(m, "\nRead Queue "
 +                       "count_enqueue_reassembly_queue: %llx "
 
 WARNING: quoted string split across lines
 #48: FILE: fs/smb/client/cifs_debug.c:470:
 +                       "count_enqueue_reassembly_queue: %llx "
 +                       "count_dequeue_reassembly_queue: %llx "

 total: 0 errors, 3 warnings, 83 lines checked
 scripts/checkpatch.pl: FAILED

But I left them in in order to keep the strange style like
the other code before and after...

The server is also changed in tiny steps in order to
make use of the common structures only. Patches 076-142.
We only have this left at the end of the patchset:

   struct smb_direct_transport {
        struct ksmbd_transport  transport;

        struct smbdirect_socket socket;
   };

The server also got patches to implement keepalive and timeout
handling in order to match the client code.

The client patches and server patches are independent
from each other, but both need their own IRD/ORD negotiation
fix plus the common smbdirect patches.

From here I'll start to split out common functions.
In the first step as static __maybe_unused functions in a
common smbdirect_connection.c file that will be included
in client/smbdirect.c and server/transport_rdma.c.
This is strange, but it will allow me to continue in tiny
steps until only common code it used.
If it's too strange I can use a smbdirect_connection.h
and rename it later from .h to .c

At that point I'll introduce an smbdirect.ko and export some
public functions which will replace the include of the .c.
Then I can finally start to add the struct socket/sock glue
in order to provide smbdirect support to userspace.

I used the following xfstests as regression tests:
cifs/001 generic/001 generic/002 generic/005 generic/006 generic/007 generic/010 generic/011

Between cifs.ko against ksmbd.ko via siw.ko and also
the client via siw.ko against Windows 2025 using
a Chelsio T520-BT card. I tested the modules once
before and after the applied patches and also the
combination.

V4:
rebased on v6.17-rc3 and current sfrench-cifs-2.6/for-next
A lot of additional patches are added in order to
use struct smbdirect_socket almost everywhere.

V3:
smbd_disconnect_rdma_work() needed to handle more
than SMBDIRECT_SOCKET_CONNECTED in order to call
rdma_disconnect.

V2:
init_waitqueue_head(&info->status_wait); was moved
to the beginning so that it is correctly initialized
in smbd_create_id().

Stefan Metzmacher (142):
  smb: smbdirect: introduce smbdirect_socket.status_wait
  smb: smbdirect: introduce smbdirect_socket_init()
  smb: smbdirect: introduce smbdirect_socket.disconnect_work
  smb: smbdirect: introduce
    smbdirect_socket.send_io.pending.{count,wait_queue}
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
  smb: client/smbdirect: replace SMBDIRECT_SOCKET_CONNECTING with more
    detailed states
  smb: client: use status_wait and SMBDIRECT_SOCKET_NEGOTIATE_RUNNING
    for completion
  smb: client: use status_wait and
    SMBDIRECT_SOCKET_RESOLVE_{ADDR,ROUTE}_RUNNING for completion
  smb: client: make use of smbdirect_socket.status_wait
  smb: client: make only use of wake_up[_all]() in smbdirect.c
  smb: client: make use of smbdirect_socket_init()
  smb: client: make use of smbdirect_socket.disconnect_work
  smb: client: make use of
    smbdirect_socket.send_io.pending.{count,wait_queue}
  smb: client: make use of
    smbdirect_socket.send_io.credits.{count,wait_queue}
  smb: client: make sure smbd_disconnect_rdma_work() doesn't run after
    smbd_destroy() took over
  smb: client: use disable[_delayed]_work_sync in smbdirect.c
  smb: client: let smbd_destroy() call
    disable_work_sync(&info->post_send_credits_work)
  smb: client: queue post_recv_credits_work also if the peer raises the
    credit target
  smb: client: make use of ib_wc_status_msg() and skip
    IB_WC_WR_FLUSH_ERR logging
  smb: client: remove info->wait_receive_queues handling in
    smbd_destroy()
  smb: client: limit the range of info->receive_credit_target
  smb: client: count the number of posted recv_io messages in order to
    calculated credits
  smb: client: make use of smbdirect_socket.recv_io.{posted,credits}
  smb: client: remove useless smbd_connection.send_immediate
  smb: client: fill smbdirect_socket_parameters at the beginning and use
    the values from there
  smb: client: make use of
    smbdirect_socket_parameters.{resolve_{addr,route},rdma_connect,negotiate}_timeout_msec
  smb: client: make use of
    smbdirect_socket_parameters.{initiator_depth,responder_resources}
  smb: client: make use of smbdirect_socket.rdma.legacy_iwarp
  smb: client: send empty packets via send_immediate_work
  smb: client: fix smbdirect keep alive handling to match the
    documentation
  smb: client: make use of
    smbdirect_socket.idle.{keepalive,immediate_work,timer_work}
  smb: client: remove unused smbd_connection->protocol
  smb: client: remove unused smbd_connection.count_reassembly_queue
  smb: client: make use of smbdirect_socket.statistics
  smb: client: don't check sc->send_io.pending.count is below
    sp->send_credit_target
  smb: client: move rdma_readwrite_threshold from smbd_connection to
    TCP_Server_Info
  smb: client: make use of smbdirect_socket.workqueue
  smb: client: add and use smbd_get_parameters()
  smb: client: make use of struct smbdirect_mr_io
  smb: client: make use of smbdirect_socket_parameters.max_frmr_depth
  smb: client: make use of smbdirect_socket.mr_io
  smb: client: pass struct smbdirect_socket to
    {get,put}_receive_buffer()
  smb: client: pass struct smbdirect_socket to
    {allocate,destroy}_receive_buffers()
  smb: client: pass struct smbdirect_socket to
    {allocate,destroy}_caches_and_workqueue()
  smb: client: pass struct smbdirect_socket to
    {enqueue,_get_first}_reassembly()
  smb: client: pass struct smbdirect_socket to
    {allocate,destroy}_mr_list()
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
  smb: client: pass struct smbdirect_socket to
    smbd_post_send_full_iter()
  smb: client: pass struct smbdirect_socket to smbd_conn_upcall()
  smb: client: pass struct smbdirect_socket to
    smbd_qp_async_error_upcall()
  smb: client: pass struct smbdirect_socket to smbd_create_id()
  smb: client: pass struct smbdirect_socket to smbd_ia_open()
  smb: client: pass struct smbdirect_socket to
    smbd_post_send_negotiate_req()
  smb: client: pass struct smbdirect_socket to smbd_negotiate()
  smb: client: pass struct smbdirect_socket to get_mr()
  smb: client: remove unused struct smbdirect_socket argument of
    smbd_iter_to_mr()
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
  smb: server: make use of
    smbdirect_socket.{send,recv}_io.mem.{cache,pool}
  smb: server: make only use of wake_up[_all]() in transport_rdma.c
  smb: server: add a pr_info() when the server starts running
  smb: server: don't use delayed_work for post_recv_credits_work
  smb: server: queue post_recv_credits_work in put_recvmsg() and avoid
    count_avail_recvmsg
  smb: server: make use of smbdirect_socket.status_wait
  smb: server: only turn into SMBDIRECT_SOCKET_CONNECTED when
    negotiation is done
  smb: server: use disable_work_sync in transport_rdma.c
  smb: server: move smb_direct_disconnect_rdma_work() into
    free_transport()
  smb: server: don't wait for info->send_pending == 0 on error
  smb: server: make use of smbdirect_socket_init()
  smb: server: make use of smbdirect_socket.disconnect_work
  smb: server: make use of
    smbdirect_socket.send_io.pending.{count,wait_queue}
  smb: server: make use of
    smbdirect_socket.send_io.credits.{count,wait_queue}
  smb: server: make use of struct smbdirect_send_batch
  smb: server: make use smbdirect_socket.rw_io.credits
  smb: server: make use of struct smbdirect_rw_io
  smb: server: take the recv_credit_target from the negotiate req and
    always limit the range
  smb: server: manage recv credits by counting posted recv_io and
    granted credits
  smb: server: make use of smbdirect_socket.recv_io.{posted,credits}
  smb: server: replace smb_trans_direct_transfort() with SMBD_TRANS()
  smb: server: remove useless casts from KSMBD_TRANS/SMBD_TRANS
  smb: server: pass ksmbd_transport to get_smbd_max_read_write_size()
  smb: server: fill smbdirect_socket_parameters at the beginning and use
    the values from there
  smb: server: make use of
    smbdirect_socket_parameters.negotiate_timeout_msec and change to 5s
  smb: server: make use of
    smbdirect_socket_parameters.{initiator_depth,responder_resources}
  smb: server: make use of smbdirect_socket.rdma.legacy_iwarp
  smb: server: make use of smbdirect_socket.idle.immediate_work
  smb: server: implement correct keepalive and timeout handling for
    smbdirect
  smb: server: make use of smbdirect_socket.workqueue
  smb: server: pass struct smbdirect_socket to {get_free,put}_recvmsg()
  smb: server: pass struct smbdirect_socket to
    smb_direct_{create,destroy}_pools()
  smb: server: pass struct smbdirect_socket to
    smb_direct_get_max_fr_pages()
  smb: server: pass struct smbdirect_socket to smb_direct_init_params()
  smb: server: pass struct smbdirect_socket to
    smb_direct_disconnect_rdma_connection()
  smb: server: pass struct smbdirect_socket to smb_direct_cm_handler()
  smb: server: pass struct smbdirect_socket to
    smb_direct_qpair_handler()
  smb: server: pass struct smbdirect_socket to smb_direct_create_qpair()
  smb: server: pass struct smbdirect_socket to smb_direct_post_recv()
  smb: server: pass struct smbdirect_socket to
    smb_direct_accept_client()
  smb: server: pass struct smbdirect_socket to
    smb_direct_prepare_negotiation()
  smb: server: pass struct smbdirect_socket to smb_direct_connect()
  smb: server: pass struct smbdirect_socket to
    smb_direct_{alloc,free}_sendmsg()
  smb: server: remove unused struct struct smb_direct_transport argument
    from smb_direct_send_ctx_init()
  smb: server: pass struct smbdirect_socket to smb_direct_post_send()
  smb: server: pass struct smbdirect_socket to
    smb_direct_flush_send_list()
  smb: server: pass struct smbdirect_socket to wait_for_credits()
  smb: server: pass struct smbdirect_socket to wait_for_send_credits()
  smb: server: pass struct smbdirect_socket to wait_for_rw_credits()
  smb: server: pass struct smbdirect_socket to calc_rw_credits()
  smb: server: pass struct smbdirect_socket to
    manage_credits_prior_sending()
  smb: server: pass struct smbdirect_socket to
    manage_keep_alive_before_sending()
  smb: server: pass struct smbdirect_socket to
    smb_direct_create_header()
  smb: server: pass struct smbdirect_socket to post_sendmsg()
  smb: server: pass struct smbdirect_socket to
    smb_direct_post_send_data()
  smb: server: pass struct smbdirect_socket to
    {enqueue,get_first}_reassembly()
  smb: server: pass struct smbdirect_socket to
    smb_direct_send_negotiate_response()

 fs/smb/client/cifs_debug.c                 |   48 +-
 fs/smb/client/cifsglob.h                   |    9 +-
 fs/smb/client/file.c                       |   16 +-
 fs/smb/client/smb2ops.c                    |    8 +-
 fs/smb/client/smb2pdu.c                    |    2 +-
 fs/smb/client/smbdirect.c                  |  943 +++++++------
 fs/smb/client/smbdirect.h                  |  104 +-
 fs/smb/common/smbdirect/smbdirect.h        |    7 +
 fs/smb/common/smbdirect/smbdirect_socket.h |  242 +++-
 fs/smb/server/connection.c                 |    4 +-
 fs/smb/server/connection.h                 |   10 +-
 fs/smb/server/server.c                     |    1 +
 fs/smb/server/smb2pdu.c                    |   23 +-
 fs/smb/server/smb2pdu.h                    |    6 -
 fs/smb/server/transport_rdma.c             | 1434 ++++++++++----------
 fs/smb/server/transport_rdma.h             |   45 +-
 16 files changed, 1565 insertions(+), 1337 deletions(-)

-- 
2.43.0

