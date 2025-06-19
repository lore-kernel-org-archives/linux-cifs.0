Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1502111
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 14:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750344445; cv=none; b=LUYZ4zHxhSlovT0TVLxEz8/0R46Kx6VGyJQPqMewW6axlsRWI7jugKdLIszyzMchtoM6FoskyQy0fqHd9qtkbasZx84tEJSVM4YOTJVWWrwfSaG3xgFY5VEz5bJpYrcFLDA35U3gehd/bCr07Fnz9lhEouaEViK4Sdp6PnxXJvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750344445; c=relaxed/simple;
	bh=tdtE7uacBIQHkC4qthVGL/neFapSNwXnV3mb08zlmWY=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=gV2AvfYBxIRJqG5JFWqR1JbpwR+/NhozT8DYW0rlM2gpF/+5yMhG73qf+wrFkDbLFyoJpq8nBqrrpEN1HRCXpoXSZEORVHN/oJYd5NOqfq2kmpm/vCTijm2ziGcQkup4uX/K0pYkJnYzcCNiG5weHcr/zJ0HZ+FIPFVZ2+E3BH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O3cZwxxW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O3cZwxxW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750344441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PR4RLj7FKG0s4cyX+tIn3hojW7WYNdrQ2Wg7KolPbE4=;
	b=O3cZwxxWEcTXmlD2Z4QI/AK6t5iWUC9LpN2mWyaFNFo9A7oa6BGaRqezwxRi0fPdEcOGYk
	JEO9Hkk7tOpgrHH1+yulVBg71Nk4finFiunAsRdq7Y8xqu4pLY6hjtJqDJjJ1rGFHVRv78
	B7R2mtSJ/dmB1lqD6VC/Wk+2hazMpTw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-466-WVlipm3GPJOwm6GRdDsWbw-1; Thu,
 19 Jun 2025 10:47:15 -0400
X-MC-Unique: WVlipm3GPJOwm6GRdDsWbw-1
X-Mimecast-MFC-AGG-ID: WVlipm3GPJOwm6GRdDsWbw_1750344434
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3EB84195608A;
	Thu, 19 Jun 2025 14:47:14 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 584E830001A1;
	Thu, 19 Jun 2025 14:47:12 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Jeremy Allison <jra@samba.org>, Steve French <sfrench@samba.org>,
    samba-technical@lists.samba.org
cc: dhowells@redhat.com, paalcant@redhat.com, linux-cifs@vger.kernel.org
Subject: Seeing lots of coredumps from samba when using upstream cifs
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <869960.1750344431.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Jun 2025 15:47:11 +0100
Message-ID: <869961.1750344431@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi Jeremy, Steve,

I've been trying to investigate all the reconnection issues cifs is seeing=
 in
the currently upstream kernel from running the generic/013 xfstest against=
 it,
and I've realised Samba is coredumping a lot (attached is one example, at
lease several others look similar).

The version of the Fedora Samba RPM I'm using is: samba-4.21.4-1.fc41.x86_=
64

In smb2_lease_key_equal (frame #10), k1 is 0x18 - which is presumably the =
root
of the SEGV.

Going up to frame #12 (delay_rename_lease_break_fn), fsp->lease is NULL.

(gdb) p *fsp
$5 =3D {next =3D 0x558d634a1520, prev =3D 0x558d6345f130, fnum =3D 5666103=
66, op =3D 0x558d63537b20, conn =3D 0x558d63414680, fh =3D 0x558d635182c0,=
 num_smb_operations =3D 0, =

  file_id =3D {devid =3D 48, inode =3D 1875968, extid =3D 0}, initial_allo=
cation_size =3D 0, file_pid =3D 52138, vuid =3D 3019447861, open_time =3D =
{tv_sec =3D 1750343292, =

    tv_usec =3D 868402}, access_mask =3D 65536, fsp_flags =3D {is_pathref =
=3D true, is_fsa =3D true, have_proc_fds =3D true, kernel_share_modes_take=
n =3D false, =

    update_write_time_triggered =3D false, update_write_time_on_close =3D =
false, write_time_forced =3D false, can_lock =3D true, can_read =3D false,=
 can_write =3D false, =

    modified =3D false, is_directory =3D false, is_dirfsp =3D false, aio_w=
rite_behind =3D false, initial_delete_on_close =3D false, delete_on_close =
=3D false, =

    is_sparse =3D true, backup_intent =3D false, use_ofd_locks =3D true, c=
losing =3D false, lock_failure_seen =3D false, encryption_required =3D fal=
se, =

    fstat_before_close =3D false}, update_write_time_event =3D 0x0, close_=
write_time =3D {tv_sec =3D 0, tv_nsec =3D 1073741822}, oplock_type =3D 0, =
leases_db_seqnum =3D 0, =

  lease_type =3D 0, lease =3D 0x0, sent_oplock_break =3D 0, oplock_timeout=
 =3D 0x0, current_lock_count =3D 0, posix_flags =3D 0, fsp_name =3D 0x558d=
63566550, =

  name_hash =3D 3474280865, mid =3D 1043, vfs_extension =3D 0x0, fake_file=
_handle =3D 0x0, notify =3D 0x0, base_fsp =3D 0x0, stream_fsp =3D 0x0, sha=
re_mode_flags_seqnum =3D 0, =

  share_mode_flags =3D 0, brlock_seqnum =3D 0, brlock_rec =3D 0x558d635182=
20, dptr =3D 0x0, print_file =3D 0x0, num_aio_requests =3D 0, aio_requests=
 =3D 0x0, =

  blocked_smb1_lock_reqs =3D 0x0, lock_failure_offset =3D 0}

David
---
#0  __pthread_kill_implementation (threadid=3D<optimized out>, signo=3Dsig=
no@entry=3D6, no_tid=3Dno_tid@entry=3D0) at pthread_kill.c:44
#1  0x00007f44435dcbc3 in __pthread_kill_internal (threadid=3D<optimized o=
ut>, signo=3D6) at pthread_kill.c:78
#2  0x00007f4443583f9e in __GI_raise (sig=3Dsig@entry=3D6) at ../sysdeps/p=
osix/raise.c:26
#3  0x00007f444356b942 in __GI_abort () at abort.c:79
#4  0x00007f4443ac26dc in dump_core () at ../../source3/lib/dumpcore.c:339
#5  0x00007f4443ac2734 in smb_panic_s3 (why=3D<optimized out>) at ../../so=
urce3/lib/util.c:716
#6  0x00007f44437c56b6 in smb_panic (why=3Dwhy@entry=3D0x7ffcde469310 "Sig=
nal 11: Segmentation fault") at ../../lib/util/fault.c:209
#7  0x00007f44437c575d in fault_report (sig=3D11) at ../../lib/util/fault.=
c:83
#8  sig_fault (sig=3D11) at ../../lib/util/fault.c:94
#9  <signal handler called>
#10 0x00007f44429acbf9 in smb2_lease_key_equal (k1=3Dk1@entry=3D0x18, k2=3D=
k2@entry=3D0x7ffcde469b98) at ../../libcli/smb/smb2_lease.c:93
#11 0x00007f44429acc47 in smb2_lease_equal (g1=3D<optimized out>, k1=3Dk1@=
entry=3D0x18, g2=3Dg2@entry=3D0x7ffcde469b84, k2=3Dk2@entry=3D0x7ffcde469b=
98)
    at ../../libcli/smb/smb2_lease.c:101
#12 0x00007f4443c61c5f in delay_rename_lease_break_fn (e=3D0x7ffcde469b60,=
 private_data=3D0x7ffcde469cb0) at ../../source3/smbd/smb2_setinfo.c:202
#13 0x00007f4443cdcb8f in share_mode_for_one_entry (fn=3D<optimized out>, =
private_data=3D<optimized out>, i=3D<synthetic pointer>, data=3D0x558d6359=
20ad "\025\262\021", =

    num_share_modes=3D<synthetic pointer>, writeback=3D<synthetic pointer>=
) at ../../source3/locking/share_mode_lock.c:2161
#14 share_mode_forall_entries (lck=3D<optimized out>, fn=3D0x7f4443ccdf40 =
<share_mode_forall_leases_fn>, private_data=3D0x7ffcde469c30)
    at ../../source3/locking/share_mode_lock.c:2265
#15 0x00007f4443cd4556 in share_mode_forall_leases (lck=3D0x558d635b2b80, =
fn=3D0x7f4443c61c20 <delay_rename_lease_break_fn>, private_data=3D0x7ffcde=
469cb0)
    at ../../source3/locking/locking.c:1349
#16 0x00007f4443c61d42 in delay_rename_for_lease_break (req=3Dreq@entry=3D=
0x558d635b2850, smb2req=3Dsmb2req@entry=3D0x558d635b10b0, ev=3Dev@entry=3D=
0x558d63425d80, =

    fsp=3Dfsp@entry=3D0x558d6357a960, lck=3Dlck@entry=3D0x558d635b2b80, da=
ta=3Ddata@entry=3D0x558d6349da00 "\001", data_size=3D116) at ../../source3=
/smbd/smb2_setinfo.c:245
#17 0x00007f4443c62721 in smbd_smb2_setinfo_send (mem_ctx=3D0x558d635b10b0=
, ev=3D0x558d63425d80, smb2req=3D0x558d635b10b0, fsp=3D0x558d6357a960, =

--Type <RET> for more, q to quit, c to continue without paging--
    in_info_type=3D<optimized out>, in_file_info_class=3D<optimized out>, =
in_input_buffer=3D..., in_additional_information=3D<optimized out>)
    at ../../source3/smbd/smb2_setinfo.c:491
#18 smbd_smb2_request_process_setinfo (req=3D0x558d635b10b0) at ../../sour=
ce3/smbd/smb2_setinfo.c:112
#19 0x00007f4443c476d4 in smbd_smb2_request_dispatch (req=3D0x558d635b10b0=
) at ../../source3/smbd/smb2_server.c:3582
#20 0x00007f4443c48f99 in smbd_smb2_request_dispatch_immediate (ctx=3Dctx@=
entry=3D0x558d63425d80, im=3D<optimized out>, im@entry=3D0x558d635b2760, =

    private_data=3Dprivate_data@entry=3D0x558d635b10b0) at ../../source3/s=
mbd/smb2_server.c:3910
#21 0x00007f4443769a50 in tevent_common_invoke_immediate_handler (im=3D0x5=
58d635b2760, removed=3Dremoved@entry=3D0x0) at ../../tevent_immediate.c:19=
0
#22 0x00007f4443769ab2 in tevent_common_loop_immediate (ev=3Dev@entry=3D0x=
558d63425d80) at ../../tevent_immediate.c:236
#23 0x00007f444376d750 in epoll_event_loop_once (ev=3D0x558d63425d80, loca=
tion=3D<optimized out>) at ../../tevent_epoll.c:905
#24 0x00007f44437648e4 in std_event_loop_once (ev=3D0x558d63425d80, locati=
on=3D0x7f4443bae1c8 "../../source3/smbd/smb2_process.c:2163")
    at ../../tevent_standard.c:110
#25 0x00007f4443766499 in _tevent_loop_once (ev=3Dev@entry=3D0x558d63425d8=
0, location=3Dlocation@entry=3D0x7f4443bae1c8 "../../source3/smbd/smb2_pro=
cess.c:2163")
    at ../../tevent.c:820
#26 0x00007f44437665cb in tevent_common_loop_wait (ev=3D0x558d63425d80, lo=
cation=3D0x7f4443bae1c8 "../../source3/smbd/smb2_process.c:2163") at ../..=
/tevent.c:949
#27 0x00007f4443764964 in std_event_loop_wait (ev=3D0x558d63425d80, locati=
on=3D0x7f4443bae1c8 "../../source3/smbd/smb2_process.c:2163")
    at ../../tevent_standard.c:141
#28 0x00007f4443c38fa3 in smbd_process (ev_ctx=3Dev_ctx@entry=3D0x558d6342=
5d80, msg_ctx=3Dmsg_ctx@entry=3D0x558d63420a50, sock_fd=3Dsock_fd@entry=3D=
35, =

    interactive=3Dinteractive@entry=3Dfalse) at ../../source3/smbd/smb2_pr=
ocess.c:2163
#29 0x0000558d47185606 in smbd_accept_connection (ev=3D0x558d63425d80, fde=
=3D<optimized out>, flags=3D<optimized out>, private_data=3D<optimized out=
>)
    at ../../source3/smbd/server.c:1033
#30 0x00007f4443769818 in tevent_common_invoke_fd_handler (fde=3D0x558d634=
39fe0, flags=3D1, removed=3Dremoved@entry=3D0x0) at ../../tevent_fd.c:174
#31 0x00007f444376da56 in epoll_event_loop (epoll_ev=3D0x558d63425fb0, tva=
lp=3D0x7ffcde46a380) at ../../tevent_epoll.c:696
#32 epoll_event_loop_once (ev=3D<optimized out>, location=3D<optimized out=
>) at ../../tevent_epoll.c:926
--Type <RET> for more, q to quit, c to continue without paging--
#33 0x00007f44437648e4 in std_event_loop_once (ev=3D0x558d63425d80, locati=
on=3D0x558d4717fbd0 "../../source3/smbd/server.c:1382") at ../../tevent_st=
andard.c:110
#34 0x00007f4443766499 in _tevent_loop_once (ev=3Dev@entry=3D0x558d63425d8=
0, location=3Dlocation@entry=3D0x558d4717fbd0 "../../source3/smbd/server.c=
:1382")
    at ../../tevent.c:820
#35 0x00007f44437665cb in tevent_common_loop_wait (ev=3D0x558d63425d80, lo=
cation=3D0x558d4717fbd0 "../../source3/smbd/server.c:1382") at ../../teven=
t.c:949
#36 0x00007f4443764964 in std_event_loop_wait (ev=3D0x558d63425d80, locati=
on=3D0x558d4717fbd0 "../../source3/smbd/server.c:1382") at ../../tevent_st=
andard.c:141
#37 0x0000558d47188acf in smbd_parent_loop (parent=3D0x558d6340e270, ev_ct=
x=3D0x558d63425d80) at ../../source3/smbd/server.c:1382
#38 main (argc=3D<optimized out>, argv=3D<optimized out>) at ../../source3=
/smbd/server.c:2354

