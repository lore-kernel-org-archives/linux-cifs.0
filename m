Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940A2421F1E
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 17:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770312342; cv=none; b=i+Jr6Gn0XywQS3KmWy/KXRiCI73GjNUMysTyYnsHeYd04ePzTCx6F3FnkR1LgMmbZol29TBqrK7lMgmuc9ULjnHvmVPtmQIPpjzORGJ6C21KSEyuYgs0nbrj/JOe+6drOXEFLkJVJoGROqDYdDPO7It2UjDD0J7BN3BncSihIoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770312342; c=relaxed/simple;
	bh=7SAaw6FnYFd5QzBh7HkLuCjL0BdcAENNr3TzxYycVGY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TNQH2GrJdrobnQybMBw3/t4CQFl5qXlmE3ZCW3/xdeOkSnQK0X0d3X4RjIMmIpLUok0eMocashxPBQLpYyA1x/K3gm7HRusa0xWntPrnRu8HAnjZk3DIx6Ue4IB1im5i2qL5RoO3jnz6VQ/TXphtfaMr5XHUq7uCFSUBcVn+TFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=MeLVD3bX; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="MeLVD3bX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=A1ojYow0QKRglBh2RlYXNWea0WK1BSmTe5tUrN1W3QY=; b=MeLVD3bXCUI3ubtJmyk19210im
	0dOLrQv9cfdVNkeQ2ykYGLLbzhzbhRJn006cuHR1zKdfVeJhDpNny8b17Z3vjMfBtisBx34AKjdvJ
	pPQPiuI1Zvwtr3qui/CUlqXbbHH3tjhbZxge9Xjzrj8NzqxvywbVfv89py0NoewrSi/GQXlJQWGG6
	lbNMD9DTeO3ZQUCDo0S3TTV/8ZOcKNbfJ9Rpn+bkhVrkn+/xerUxkXUp0Wvk6vdumcGZ0ItoYY0zG
	P7nfVNnEqIpJeBq1siU5tmqXlUvdqWrTJK9AinSCJTm0vaKeDelFVa2/g4RY5aFj54J2O4eWXv6sC
	er2RQhIzYg4vV+keEjjO9XfNFPhTYc8lz6EqRNuHRtHVSJoHwbfMqt+IGcB6P1sivQtCsNagQHGID
	k7QyIA5WJiir1qXYaw4O3FyjYtOUeD6Amm+z+toSj+MRYGiGQgwqFtjQC8nqObvG1yrvkmW2Eesno
	TrdJIm/0K3bxPANkPHtbbFx+;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vo36o-00000004UAw-0yPE;
	Thu, 05 Feb 2026 17:25:38 +0000
From: Stefan Metzmacher <metze@samba.org>
To: Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: metze@samba.org,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH v5 000/144] smb: smbdirect/client/server: moving to common functions and smbdirect.ko
Date: Thu,  5 Feb 2026 18:22:55 +0100
Message-ID: <cover.1770311507.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

this is the move use common functions in an smbdirect.ko.

I'm not sending all 144 patches to the list, only the
cover letter...

It can be found in my for-7.0/smbdirect-ko-20260205-v5 branch,
at commit 0af3ce20f80b1335e83e1fc65758d3654c192a57:
git fetch https://git.samba.org/metze/linux/wip.git for-7.0/smbdirect-ko-20260205-v5
https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/for-7.0/smbdirect-ko-20260205-v5

This is on top of origin/master as commit
f14faaf3a1fb3b9e4cf2e56269711fb85fba9458.

And merging in:

- sfrench-cifs-2.6/for-next at commit
  f796e492246c0b61df02a0a8b2957d48a4a47aca
  smb: common: add header guards to fs/smb/common/smb2status.h
- smfrench-smb3-kernel/ksmbd-for-next at commit
  cc6aa375487e9aca11a345b5e37dbf09678a9f4d
  smb: server: make use of rdma_restrict_node_type()
- smfrench-smb3-kernel/ksmbd-for-next-next at commit
  75980cde65ad415e73b209881ce2c4f35ed98e64
  smb: server: fix leak of active_num_conn in ksmbd_tcp_new_connection()

On top of this I have the 2 patches from:
https://lore.kernel.org/linux-cifs/cover.1764080338.git.metze@samba.org/
  smb: server: correct value for smb_direct_max_fragmented_recv_size
  smb: client: correct value for smbd_max_fragmented_recv_size

So the top 144 patches from 0af3ce20f80b1335e83e1fc65758d3654c192a57
are relevant here.

The end goal is still to go via the socket layer in order
to provide smbdirect support to userspace, so that Samba
can use if as client and server. But that will be done on
top of this patchset.

The patchset starts with the introduction of
a logging infrastructure that allows us to have
common code, but still do logging with cifs.ko
and ksmbd.ko specific functions.

Then it introduces smbdirect_all_c_files.c, which
is only temporary. It is included in the client and
server and will itself include more files with
common functions in the following patches.
This makes it possible to do the transition in
small steps. At the end this will be removed again,
while removing the file itself will be done in a later
patchset.

Then we have a series of patches introducing
common functions, most of them are copies
of the existing functions, just with a new name
and some reformatting. But the core logic is
mostly unchanged.

Then we have new functions related to async
connect and accept handling.

Followed by preparing some functions as public
and some as private, so that we have the
Kbuild logic for smbdirect.ko, which is
still disabled at that point.

Then we have small steps in the client in order
to make use of the new functions. At the end
is only uses smbdirect.ko and its exported functions.

Then we have small steps in the server in order
to make use of the new functions. At the end
is only uses smbdirect.ko and its exported functions.

Then there's the move to global workqueues in
smbdirect.ko.

The addition of smbdirect_{bind,listen,accept}()
function and the transition of the server to
use them instead of the custom rdma listener.

Finally some unused stuff is removed.

Every patch compiles on its own and passes
  grep -v 'Fixes: 0626e6641f6b ' | \
  grep -v 'Fixes: 1ead2213dd7d ' | \
    scripts/checkpatch.pl --quiet --codespell \
      --ignore=FILE_PATH_CHANGES,EXPORT_SYMBOL,COMPLEX_MACRO

I've tested the client part with these tests at the
end of the patchset with mlx5_ib and rxe on the client side
using 'rdma,sec=ntlmssp' and 'rdma,sec=ntlmsspi'
against a Windows 2025 server.

For the clientThere are known problems with the irdma
driver for iwarp and roce. And there was also
an existing problem with siw against irdma iwarp
on the Windows server.

cifs/001
generic/001
generic/002
generic/005
generic/006
generic/007
generic/008
generic/011
generic/024
generic/028
generic/029
generic/030
generic/033
generic/036
generic/069
generic/071
generic/080
generic/084
generic/086
generic/095
generic/098
generic/103
generic/124
generic/130
generic/132
generic/135
generic/141
generic/198
generic/207
generic/210
generic/212
generic/214
generic/215
generic/221
generic/228
generic/236
generic/246
generic/248
generic/249
generic/257
generic/258
generic/308
generic/309
generic/313
generic/315
generic/339
generic/340
generic/344
generic/345
generic/346
generic/354
generic/360
generic/390
generic/391
generic/393
generic/394
generic/406
generic/412

I tested ksmbd with and without
'server signing = mandatory' in order to
test the cases with and without RDMA offload.

I tested a file copy of a ~5.5GB file
in the Windows Explorer, from and to the share.

And I tested
'frametest.exe -r 4k -t 20 -n 2000 Z:\framtest\testrundir'
'frametest.exe -w 4k -t 20 -n 2000 Z:\framtest\testrundir'

I tested with with mlx5_ib, irdma (roce) and rxe.
There's still a known problem with iwarp.

So far I can't see any regression compared the
state before these 144 patches.

Namjae, can you please test in your setup?

The for-7.0/smbdirect-ko-20260205-v5+ branch has
a build fix and scripts for out of tree testing,
you need to build/load smbdirect.ko first followed
by cifs.ko and/or ksmbd.ko. (For a full kernel build
with happens automatically...)

It would be nice to get this into the 7.0 merge
windows after for-next and ksmbd-for-next are merged.

From there I'll work on the changes to introduce IPPROTO_SMBDIRECT,
but that needs a bit more work an coordination
with the netdev-next and maybw rdma and io_uring trees, the
work in progress can be found here:
https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/master-ipproto-smbdirect
The related Samba MR can be found here:
https://gitlab.com/samba-team/samba/-/merge_requests/4343
If someone wants to test it, but be warnt there are
still useless memcpy calls in the RDMA offload case,
which will need to be removed.

v5: rebase on the regression fixes in 6.18 and 6.19
    adding smbdirect_netdev_rdma_capable_node_type()
    and a lot of small fixes here and there...

v4: some functions are moved to smbdirect_socket.c
    and got smbdirect_socket_ as prefix.
    add and use smbdirect_{bind,listen,accept}()
    a lot of small fixes here and there...

v3: async connect/accept code was moved to
    workqueue functions instead of beeing
    called in interrupt context via
    IB_POLL_SOFTIRQ.
    Added some includes to smbdirect_socket.h
    I also did a few minor changes like using
    sc->ib.dev consistently.

Stefan Metzmacher (144):
  smb: smbdirect: let smbdirect.h include #include <linux/types.h>
  smb: smbdirect: introduce smbdirect_socket.logging infrastructure
  smb: smbdirect: add some logging to
    SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
  smb: smbdirect: introduce smbdirect_all_c_files.c
  smb: smbdirect: introduce smbdirect_internal.h
  smb: client: include smbdirect_all_c_files.c
  smb: server: include smbdirect_all_c_files.c
  smb: smbdirect: introduce smbdirect_socket.c to be filled
  smb: smbdirect: introduce smbdirect_socket_prepare_create()
  smb: smbdirect: introduce smbdirect_socket_set_logging()
  smb: smbdirect: introduce smbdirect_socket_wake_up_all()
  smb: smbdirect: introduce smbdirect_socket_cleanup_work()
  smb: smbdirect: introduce
    smbdirect_socket_schedule_cleanup[{_lvl,_status}]()
  smb: smbdirect: introduce smbdirect_connection.c to be filled
  smb: smbdirect: introduce smbdirect_connection_{get,put}_recv_io()
  smb: smbdirect: introduce
    smbdirect_connection_reassembly_{append,first}_recv_io()
  smb: smbdirect: introduce smbdirect_connection_idle_timer_work()
  smb: smbdirect: set SMBDIRECT_KEEPALIVE_NONE before
    disable_delayed_work(&sc->idle.timer_work);
  smb: smbdirect: introduce smbdirect_frwr_is_supported()
  smb: smbdirect: introduce smbdirect_socket.{send,recv}_io.mem.gfp_mask
  smb: smbdirect: introduce smbdirect_connection_{alloc,free}_send_io()
  smb: smbdirect: introduce smbdirect_connection_send_io_done()
  smb: smbdirect: introduce
    smbdirect_connection_{create,destroy}_mem_pools()
  smb: smbdirect: introduce smbdirect_map_sges_from_iter() and helper
    functions
  smb: smbdirect: introduce smbdirect_connection_qp_event_handler()
  smb: smbdirect: introduce
    smbdirect_connection_negotiate_rdma_resources()
  smb: smbdirect: introduce smbdirect_connection_{create,destroy}_qp()
  smb: smbdirect: introduce smbdirect_connection_post_recv_io()
  smb: smbdirect: introduce smbdirect_connection_recv_io_refill_work()
  smb: smbdirect: split out smbdirect_connection_recv_io_refill()
  smb: smbdirect: introduce smbdirect_get_buf_page_count()
  smb: smbdirect: introduce smbdirect_socket_wait_for_credits()
  smb: smbdirect: introduce smbdirect_mr.c with client mr code
  smb: smbdirect: introduce smbdirect_rw.c with server rw code
  smb: smbdirect: define SMBDIRECT_MIN_{RECEIVE,FRAGMENTED}_SIZE
  smb: smbdirect: define SMBDIRECT_RDMA_CM_[RNR_]RETRY
  smb: smbdirect: introduce smbdirect_connection_recv_io_done()
  smb: smbdirect: introduce smbdirect_socket_destroy[_sync]()
  smb: smbdirect: introduce
    smbdirect_connection_rdma_{established,event_handler}()
  smb: smbdirect: introduce smbdirect_connection_recvmsg()
  smb: smbdirect: introduce smbdirect_connection_grant_recv_credits()
  smb: smbdirect: introduce smbdirect_connection_request_keep_alive()
  smb: smbdirect: introduce smbdirect_connection_send_iter() and related
    functions
  smb: smbdirect: introduce smbdirect_connection_send_immediate_work()
  smb: smbdirect: introduce smbdirect_connection_negotiation_done()
  smb: smbdirect: introduce smbdirect_mr_io_fill_buffer_descriptor()
  smb: smbdirect: introduce
    smbdirect_connection_legacy_debug_proc_show()
  smb: smbdirect: introduce smbdirect_connection_wait_for_connected()
  smb: smbdirect: introduce smbdirect_connection_is_connected()
  smb: smbdirect: introduce smbdirect_socket_shutdown()
  smb: smbdirect: introduce smbdirect_socket_init_{new,accepting}() and
    helpers
  smb: smbdirect: let smbdirect_socket_set_initial_parameters() call
    rdma_restrict_node_type()
  smb: smbdirect: introduce smbdirect_connect[_sync]()
  smb: smbdirect: introduce smbdirect_accept_connect_request()
  smb: smbdirect: introduce smbdirect_socket_create_{kern,accepting}()
    and smbdirect_socket_release()
  smb: smbdirect: let smbdirect_socket.h include all headers for used
    structures
  smb: smbdirect: let smbdirect_internal.h define pr_fmt without
    SMBDIRECT_USE_INLINE_C_FILES
  smb: smbdirect: introduce smbdirect_public.h with prototypes
  smb: smbdirect: provide explicit prototypes for cross .c file
    functions
  smb: smbdirect: introduce smbdirect_init_send_batch_storage()
  smb: smbdirect: split out smbdirect_accept_negotiate_finish()
  smb: smbdirect: introduce smbdirect_socket_bind()
  smb: smbdirect: introduce smbdirect_socket_{listen,accept}()
  smb: smbdirect: introduce the basic smbdirect.ko
  smb: client: make use of smbdirect_socket_prepare_create()
  smb: client: make use of smbdirect_socket_set_logging()
  smb: client: make use of smbdirect_socket_wake_up_all()
  smb: client: make use of smbdirect_socket_cleanup_work()
  smb: client: make use of smbdirect_socket_schedule_cleanup()
  smb: client: make use of smbdirect_connection_{get,put}_recv_io()
  smb: client: make use of
    smbdirect_connection_reassembly_{append,first}_recv_io()
  smb: client: make use of smbdirect_connection_idle_timer_work()
  smb: client: make use of smbdirect_frwr_is_supported()
  smb: client: make use of smbdirect_connection_{alloc,free}_send_io()
  smb: client: make use of smbdirect_connection_send_io_done()
  smb: client: make use of
    smbdirect_connection_{create,destroy}_mem_pools()
  smb: client: make use of smbdirect_map_sges_from_iter()
  smb: client: make use of smbdirect_connection_qp_event_handler()
  smb: client: make use of
    smbdirect_connection_negotiate_rdma_resources()
  smb: client: make use of smbdirect_connection_{create,destroy}_qp()
  smb: client: initialize recv_io->cqe.done = recv_done just once
  smb: client: make use of smbdirect_connection_post_recv_io()
  smb: client: make use of smbdirect_connection_recv_io_refill_work()
  smb: client: make use of functions from smbdirect_mr.c
  smb: client: make use of smbdirect_socket_destroy_sync()
  smb: client: make use of smbdirect_connection_recvmsg()
  smb: client: make use of smbdirect_connection_grant_recv_credits()
  smb: client: make use of smbdirect_connection_request_keep_alive()
  smb: client: change smbd_post_send_empty() to void return
  smb: client: let smbd_post_send_iter() get remaining_length and return
    data_length
  smb: client: let smbd_post_send_full_iter() get remaining_length and
    return data_length
  smb: client: make use of
    smbdirect_connection_send_{single_iter,immediate_work}()
  smb: client: introduce and use smbd_mr_fill_buffer_descriptor()
  smb: client: introduce and use smbd_debug_proc_show()
  smb: client: make use of smbdirect_socket_init_new() and
    smbdirect_connect_sync()
  smb: client: make use of
    smbdirect_socket_create_kern()/smbdirect_socket_release()
  smb: client: only use public smbdirect functions
  smb: client: make use of smbdirect.ko
  smb: server: make use of smbdirect_socket_prepare_create()
  smb: server: make use of smbdirect_socket_set_logging()
  smb: server: make use of smbdirect_socket_wake_up_all()
  smb: server: make use of smbdirect_socket_cleanup_work()
  smb: server: make use of smbdirect_socket_schedule_cleanup()
  smb: server: make use of smbdirect_connection_{get,put}_recv_io()
  smb: server: make use of
    smbdirect_connection_reassembly_{append,first}_recv_io()
  smb: server: make use of smbdirect_connection_idle_timer_work()
  smb: server: make use of smbdirect_frwr_is_supported()
  smb: server: make use of smbdirect_connection_{alloc,free}_send_io()
  smb: server: make use of smbdirect_connection_send_io_done()
  smb: server: make use of
    smbdirect_connection_{create,destroy}_mem_pools()
  smb: server: make use of smbdirect_map_sges_from_iter()
  smb: server: make use of smbdirect_connection_qp_event_handler()
  smb: server: make use of
    smbdirect_connection_negotiate_rdma_resources()
  smb: server: make use of smbdirect_connection_{create,destroy}_qp()
  smb: server: make use of smbdirect_connection_post_recv_io()
  smb: server: make use of smbdirect_connection_recv_io_refill[_work]()
  smb: server: make use of smbdirect_get_buf_page_count()
  smb: server: make use of smbdirect_socket_wait_for_credits()
  smb: server: make use of functions from smbdirect_rw.c
  smb: server: make use of smbdirect_socket_destroy_sync()
  smb: server: make use of smbdirect_connection_recvmsg()
  smb: server: make use of smbdirect_connection_grant_recv_credits()
  smb: server: make use of smbdirect_connection_request_keep_alive()
  smb: server: move iov_iter_kvec() out of smb_direct_post_send_data()
  smb: server: inline smb_direct_create_header() into
    smb_direct_post_send_data()
  smb: server: let smbdirect_map_sges_from_iter() truncate the message
    boundary
  smb: server: split out smb_direct_send_iter() out of
    smb_direct_writev()
  smb: server: let smb_direct_post_send_data() return data_length
  smb: server: make use of smbdirect_connection_send_iter() and related
    functions
  smb: server: make use of
    smbdirect_{socket_init_accepting,connection_wait_for_connected}()
  smb: server: make use of
    smbdirect_socket_create_accepting()/smbdirect_socket_release()
  smb: server: only use public smbdirect functions
  smb: server: make use of smbdirect_socket_{listen,accept}()
  smb: server: remove unused ksmbd_transport_ops.prepare()
  smb: server: make use of smbdirect.ko
  smb: smbdirect: introduce smbdirect_netdev_rdma_capable_mode_type()
  smb: server: make use of smbdirect_netdev_rdma_capable_mode_type()
  smb: smbdirect: wrap rdma_disconnect() in rdma_[un]lock_handler()
  smb: smbdirect: remove unused
    smbdirect_connection_mr_io_recovery_work()
  smb: smbdirect: prepare use of dedicated workqueues for different
    steps
  smb: smbdirect: introduce global workqueues
  smb: client: no longer use smbdirect_socket_set_custom_workqueue()
  smb: server: no longer use smbdirect_socket_set_custom_workqueue()
  smb: smbdirect: remove unused SMBDIRECT_USE_INLINE_C_FILES logic

 fs/smb/Kconfig                                |    1 +
 fs/smb/client/Kconfig                         |    3 +-
 fs/smb/client/cifs_debug.c                    |   67 +-
 fs/smb/client/smb2pdu.c                       |    9 +-
 fs/smb/client/smbdirect.c                     | 3350 ++---------------
 fs/smb/client/smbdirect.h                     |   19 +-
 fs/smb/common/Makefile                        |    1 +
 fs/smb/common/smbdirect/Kconfig               |    9 +
 fs/smb/common/smbdirect/Makefile              |   18 +
 fs/smb/common/smbdirect/smbdirect.h           |    9 +
 fs/smb/common/smbdirect/smbdirect_accept.c    |  857 +++++
 fs/smb/common/smbdirect/smbdirect_connect.c   |  925 +++++
 .../common/smbdirect/smbdirect_connection.c   | 2175 +++++++++++
 fs/smb/common/smbdirect/smbdirect_debug.c     |   88 +
 fs/smb/common/smbdirect/smbdirect_devices.c   |  276 ++
 fs/smb/common/smbdirect/smbdirect_internal.h  |  142 +
 fs/smb/common/smbdirect/smbdirect_listen.c    |  308 ++
 fs/smb/common/smbdirect/smbdirect_main.c      |  120 +
 fs/smb/common/smbdirect/smbdirect_mr.c        |  486 +++
 fs/smb/common/smbdirect/smbdirect_pdu.h       |    4 +
 fs/smb/common/smbdirect/smbdirect_public.h    |  148 +
 fs/smb/common/smbdirect/smbdirect_rw.c        |  255 ++
 fs/smb/common/smbdirect/smbdirect_socket.c    |  723 ++++
 fs/smb/common/smbdirect/smbdirect_socket.h    |  303 +-
 fs/smb/server/Kconfig                         |    4 +-
 fs/smb/server/connection.c                    |    5 -
 fs/smb/server/connection.h                    |    1 -
 fs/smb/server/smb2pdu.c                       |    1 -
 fs/smb/server/transport_rdma.c                | 3167 ++--------------
 fs/smb/server/transport_rdma.h                |    4 +-
 30 files changed, 7451 insertions(+), 6027 deletions(-)
 create mode 100644 fs/smb/common/smbdirect/Kconfig
 create mode 100644 fs/smb/common/smbdirect/Makefile
 create mode 100644 fs/smb/common/smbdirect/smbdirect_accept.c
 create mode 100644 fs/smb/common/smbdirect/smbdirect_connect.c
 create mode 100644 fs/smb/common/smbdirect/smbdirect_connection.c
 create mode 100644 fs/smb/common/smbdirect/smbdirect_debug.c
 create mode 100644 fs/smb/common/smbdirect/smbdirect_devices.c
 create mode 100644 fs/smb/common/smbdirect/smbdirect_internal.h
 create mode 100644 fs/smb/common/smbdirect/smbdirect_listen.c
 create mode 100644 fs/smb/common/smbdirect/smbdirect_main.c
 create mode 100644 fs/smb/common/smbdirect/smbdirect_mr.c
 create mode 100644 fs/smb/common/smbdirect/smbdirect_public.h
 create mode 100644 fs/smb/common/smbdirect/smbdirect_rw.c
 create mode 100644 fs/smb/common/smbdirect/smbdirect_socket.c

-- 
2.43.0

