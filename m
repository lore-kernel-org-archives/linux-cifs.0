Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249E73C6A56
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 15:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776351842; cv=pass; b=NhJTPmyq6FxZb0ToLcanlyzyagibKH6BAUNUPkTIyP/pBDJDtIODXfXRmcObanxWUdDFAHr7kuDYeBcYaaZQ+cda9HQ7/v5WqP52Pf1CupF166t0zqpJJWKbUHFAklcyfYZ6673cDcDalIEbmneqNjlRX4NeljdS0KlunH0zV/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776351842; c=relaxed/simple;
	bh=PubiAA8ZjOpMHhFt9Bn0dGfhiZ+GazPhMZcmrDHrIuE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=camj8lBptbT/DNnQqPvjUg2Li9QFfTglukTnSr54lc1mBCKRpsS57+1ZvXQRpYIU7ElWj+pEwwwROOVnECwFIQNZjc40KVzCP1n+5T1phLNTNpcEt+u01sWLGrvBlG0G2AKvmOMBqT4q/kMYBtNCHjCDMnWIAyy+Rte05U7dsf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tIOD5e/W; arc=pass smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tIOD5e/W"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7dc3d28e2f3so4917260a34.0
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 08:04:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776351840; cv=none;
        d=google.com; s=arc-20240605;
        b=UgFVdCMgd45BOPAjfFJuuuxp4/i7+MXq+1nkVx6QdYTi3lKVi1l6CPnSt2fhu7TynQ
         S3iPzQYKHjUCozxL/Iicu7xl7aYZWw+dsWlkCr1wx6h9uXqpywEwL67kP/E7I6/5aCBd
         MqA8LWUhm9Hg+dMiKOBK+K2CNdtf9Hh8/nEVgi2NgGD4LrjBttbmuLoOzvolAoee4oBh
         1VH17UkM2bj+IBMPHTknkF5NEhAjY8dpo2Jw2EkyclWZl5HVGhkJNxVPui9AtUTJZbJK
         HOhw2y0PjOMJx14aJSQTlg7cSsMi6lVTNhBy8n8KNXSUtKwGndzxy7DOF0Mad6gNCHoy
         1kcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=yhVfvt1kx4ryc1FAF+NFKaaCYUvXN0SCbkPjYGs25W8=;
        fh=QVNwTtzljt0RY3FNIo+44AClqGKxMPbFSX3D5p6EzAE=;
        b=cnZ4N0H0oQpQtUU38aF7G4tzRWbzkUU7YkUnJ9BA8wFB50eyFkU8GIOXZoC8OoJfBS
         pndfuk+xNZmA2ppdBz+M8L4BHsFJhT8yQ9TqttGZpy2wAbaWTNSUxoM4e3A8G9K3FNKt
         7SYNb20/nHQkPzUCHtXaXYWHgA16SnN9cXNcSFctGRKGXu0dABTQoF/xid9/Xnl9YATX
         nSsWebsqlR3wMgis1R8kJB6mmVsJKkKjL/HfsfBWBBqirurssS9FwCcXcMfCHGxMOef/
         95APVkGEcm/clV1kY7NV4BNV7tHBqCKCh4iO4oJKyCDDiefFVE2VM387EtKFINtqxMm4
         YJ4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776351840; x=1776956640; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yhVfvt1kx4ryc1FAF+NFKaaCYUvXN0SCbkPjYGs25W8=;
        b=tIOD5e/WQNq6cIZU53YGkblxsUc6VSHaPOLOKuNmAIe2+9Z1RF7rKbwUYoQyrWB8uK
         A+6e3xk7eBnWC82Wih1v0v65ufNGGD1h/mSet/kUD/I0X4y/YPfc4vnn0B3YwIJQD+qK
         orxfKwj9s12yqnnsWoIN0aVAesp1NHVwaf4E7UNHucJbIeBSy0XO5XSEGRFIkdDIny6w
         mryDd5cqQEe8fPt96mwe8WT2d1JFd6iHjn2/nn6Gjc9YBMgLpXF17n1eAMzHH7U2UYTX
         vROBtwc3FmBrQF1at3vzy/v9t/DR0s2NxUhJp1w6qwrxC1o/W6SAsoW6CiHmvVBx1J6g
         cZbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776351840; x=1776956640;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yhVfvt1kx4ryc1FAF+NFKaaCYUvXN0SCbkPjYGs25W8=;
        b=pFoib0i47woXpGHiDdt1V/cc0a2fj/Swuvh6+BrgkBo0Dzs8u1c25SCCuOccI14qxV
         5ro/WLIfrhdEyJNKvQqJWjdoar8/zy4kNOZBLx7sOpdfOpXSWkDFiOstJ3mtexfDF4XO
         ggpRxaXI9j/0OhMNTy4P6PbYU+7aUfax/IlZte1An5EVr2qZEVup2PeyCa0gs0w2CW4C
         gt8I8GujTg3uaDbi5kkzWu+5esxnkM8Gh/p5HWkAjo/tic/cmXMZ7N5757jk8XimfyaQ
         vxJbmzLY99HiIm/Py/lBMcHqKZNDY9u5xK8DypxAvkGKeDZsovz7Wtj4clE4+ulrXPzV
         RFKA==
X-Forwarded-Encrypted: i=1; AFNElJ+hS3SvBdyM0m/zyBDgE/K52VMlbx/k0X4U5SIkBW/gACvjNvdxPf/uXW0MSXbBNOxAdhB/FprVFYHf@vger.kernel.org
X-Gm-Message-State: AOJu0YygeiYPTep28PzUwsT1M4Ix4YixVB3mHFHZusNKHIYLFS7N4SP2
	1A2MOmiHsIfFwFfxvlsoumab1kN5jp7BLt0RySjgfSpz3cQckz/2X6lJMDTztUJ3EphKqSGkeFw
	RYqFg6Qd02VgywVk9EXXcX3MYJQ3MsDw=
X-Gm-Gg: AeBDieuVrEmwyKOdGxs8nf37Owncf2bfEdWdaF3TgzW1igr2olMZSTH215AmxCYSfY7
	zcuSocvHqFyVpow6NLM2CzaClnOhfCicrqIMghQq0gHmR7aYV7WGi/eJ9exFZiu/kL3pM6+55ms
	Xg1COAhS/aK7ft2cB8mf7FzG3YQIRP+bKLERDWXOQhu7MVJhAQlkDGu6n12F6xtO4uH3qNnOSSn
	0KaSzHo5ukn9kxClfix4YgRjNYNdIjOJE8ZvdwNfelpSYeaWwnP6etRgJLPKnpBz/4jS505fF3f
	f4ubYecu80jgGqI9bZf0Ra/ovq6zZJB2itOyTeUOaSqRXDhWf5d4Itdxnkg8n0nAmkBH4M8LW4I
	emImy3C6sbPSgQcdXwrFBIdleotRYJUdSyhYuU5t0Xc9rdJIfOzCWNKpI5ih+XFWQb7QS7JvzpH
	5ceXrkseWYk6hun4f4urxtiK4pmSlYkblg
X-Received: by 2002:a05:6830:438a:b0:7dc:641:ecda with SMTP id
 46e09a7af769-7dc27e6a296mr15447789a34.26.1776351839805; Thu, 16 Apr 2026
 08:03:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 16 Apr 2026 10:03:47 -0500
X-Gm-Features: AQROBzDOwTYvwyLaY8gevRSQLB5Ld5OxoGSu3i_iecv-50AyAQD_JAwXqajDacQ
Message-ID: <CAH2r5mu2+PGJER79PJpPVCysoEEgCsyuzuCKCD9LzZSHQnhOSQ@mail.gmail.com>
Subject: [GIT PULL] smbdirect ksmbd and cifs changes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
048091722259b6e8d2ef3b138b0c121a2afabe61:

  Merge tag 'v7.1-rc-part1-ksmbd-srv-fixes' of
git://git.samba.org/ksmbd (2026-04-15 19:14:01 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.1-rc-part1-smbdirect-fixes

for you to fetch changes up to d09a040c186a2083b1cfa9c3c112782ce4b1f6d4:

  smb: smbdirect: let smbdirect_connection_deregister_mr_io unlock
while waiting (2026-04-15 21:58:24 -0500)

----------------------------------------------------------------
Move smbdirect server and client code to common
- temporary use of smbdirect_all_c_files.c to allow micro steps
- factor out common functions into a smbdirect.ko.
- convert cifs.ko to use smbdirect.ko
- convert ksmbd.ko to use smbdirect.ko
- let smbdirect.ko use global workqueues
- move ib_client logic from ksmbd.ko into smbdirect.ko
- remove smbdirect_all_c_files.c hack again
- some locking and teardown related fixes on top
----------------------------------------------------------------
Stefan Metzmacher (145):
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
      smb: smbdirect: introduce smbdirect_map_sges_from_iter() and
helper functions
      smb: smbdirect: introduce smbdirect_connection_qp_event_handler()
      smb: smbdirect: introduce smbdirect_connection_negotiate_rdma_resources()
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
      smb: smbdirect: introduce smbdirect_connection_send_iter() and
related functions
      smb: smbdirect: introduce smbdirect_connection_send_immediate_work()
      smb: smbdirect: introduce smbdirect_connection_negotiation_done()
      smb: smbdirect: introduce smbdirect_mr_io_fill_buffer_descriptor()
      smb: smbdirect: introduce smbdirect_connection_legacy_debug_proc_show()
      smb: smbdirect: introduce smbdirect_connection_wait_for_connected()
      smb: smbdirect: introduce smbdirect_connection_is_connected()
      smb: smbdirect: introduce smbdirect_socket_shutdown()
      smb: smbdirect: introduce
smbdirect_socket_init_{new,accepting}() and helpers
      smb: smbdirect: let smbdirect_socket_set_initial_parameters()
call rdma_restrict_node_type()
      smb: smbdirect: introduce smbdirect_connect[_sync]()
      smb: smbdirect: introduce smbdirect_accept_connect_request()
      smb: smbdirect: introduce
smbdirect_socket_create_{kern,accepting}() and
smbdirect_socket_release()
      smb: smbdirect: let smbdirect_socket.h include all headers for
used structures
      smb: smbdirect: let smbdirect_internal.h define pr_fmt without
SMBDIRECT_USE_INLINE_C_FILES
      smb: smbdirect: introduce smbdirect_public.h with prototypes
      smb: smbdirect: provide explicit prototypes for cross .c file functions
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
      smb: client: make use of smbdirect_connection_{create,destroy}_mem_pools()
      smb: client: make use of smbdirect_map_sges_from_iter()
      smb: client: make use of smbdirect_connection_qp_event_handler()
      smb: client: make use of smbdirect_connection_negotiate_rdma_resources()
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
      smb: client: let smbd_post_send_iter() get remaining_length and
return data_length
      smb: client: let smbd_post_send_full_iter() get remaining_length
and return data_length
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
      smb: server: make use of smbdirect_connection_{create,destroy}_mem_pools()
      smb: server: make use of smbdirect_map_sges_from_iter()
      smb: server: make use of smbdirect_connection_qp_event_handler()
      smb: server: make use of smbdirect_connection_negotiate_rdma_resources()
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
      smb: server: let smbdirect_map_sges_from_iter() truncate the
message boundary
      smb: server: split out smb_direct_send_iter() out of smb_direct_writev()
      smb: server: let smb_direct_post_send_data() return data_length
      smb: server: make use of smbdirect_connection_send_iter() and
related functions
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
      smb: smbdirect: remove unused smbdirect_connection_mr_io_recovery_work()
      smb: smbdirect: prepare use of dedicated workqueues for different steps
      smb: smbdirect: introduce global workqueues
      smb: client: no longer use smbdirect_socket_set_custom_workqueue()
      smb: server: no longer use smbdirect_socket_set_custom_workqueue()
      smb: smbdirect: remove unused SMBDIRECT_USE_INLINE_C_FILES logic
      smb: smbdirect: change
smbdirect_socket_parameters.{initiator_depth,responder_resources} to
__u16
      smb: smbdirect: fix copyright header of smbdirect.h
      smb: smbdirect: fix the logic in smbdirect_socket_destroy_sync()
without an error
      smb: smbdirect: let smbdirect_connection_deregister_mr_io unlock
while waiting

 fs/smb/Kconfig                                 |    1 +
 fs/smb/client/Kconfig                          |    4 +-
 fs/smb/client/cifs_debug.c                     |   67 +-
 fs/smb/client/smb2pdu.c                        |    9 +-
 fs/smb/client/smbdirect.c                      | 3356 ++----------------------
 fs/smb/client/smbdirect.h                      |   19 +-
 fs/smb/common/Makefile                         |    1 +
 fs/smb/common/smbdirect/Kconfig                |    9 +
 fs/smb/common/smbdirect/Makefile               |   18 +
 fs/smb/common/smbdirect/smbdirect.h            |   14 +-
 fs/smb/common/smbdirect/smbdirect_accept.c     |  857 ++++++
 fs/smb/common/smbdirect/smbdirect_connect.c    |  925 +++++++
 fs/smb/common/smbdirect/smbdirect_connection.c | 2181 +++++++++++++++
 fs/smb/common/smbdirect/smbdirect_debug.c      |   88 +
 fs/smb/common/smbdirect/smbdirect_devices.c    |  277 ++
 fs/smb/common/smbdirect/smbdirect_internal.h   |  141 +
 fs/smb/common/smbdirect/smbdirect_listen.c     |  308 +++
 fs/smb/common/smbdirect/smbdirect_main.c       |  121 +
 fs/smb/common/smbdirect/smbdirect_mr.c         |  493 ++++
 fs/smb/common/smbdirect/smbdirect_pdu.h        |    4 +
 fs/smb/common/smbdirect/smbdirect_public.h     |  148 ++
 fs/smb/common/smbdirect/smbdirect_rw.c         |  255 ++
 fs/smb/common/smbdirect/smbdirect_socket.c     |  743 ++++++
 fs/smb/common/smbdirect/smbdirect_socket.h     |  183 +-
 fs/smb/server/Kconfig                          |    5 +-
 fs/smb/server/connection.c                     |    5 -
 fs/smb/server/connection.h                     |    1 -
 fs/smb/server/smb2pdu.c                        |    1 -
 fs/smb/server/transport_rdma.c                 | 3172 +++-------------------
 fs/smb/server/transport_rdma.h                 |    4 +-
 30 files changed, 7353 insertions(+), 6057 deletions(-)
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
Thanks,

Steve
