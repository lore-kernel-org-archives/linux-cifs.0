Return-Path: <SRS0=C9ZR=YM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD75CA9EAC
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Oct 2019 23:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A991C21744
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Oct 2019 23:35:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ffxoCGOk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfJSXfR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Oct 2019 19:35:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24811 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726148AbfJSXfQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Oct 2019 19:35:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571528114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9oxyw+OKYGOlkN9AOInHb44f0y3dPCN4w1k0F6G2c2Q=;
        b=ffxoCGOk5HhcKVbvRwZ3UWMBlebmRbNJFgDfYpDLOLjvosAyaQUGHN3/aP+LC6jfy92Xeh
        sT8ba/f24Doya9kF2dy7RdqYmWtgR3E61K0IeJ2XgD2+Fs8XLXlWw8pSlDeF48UR0sHEoy
        vGXDeU8Y6aLEhPEYzo4qoZeuJtqXS6Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-qsJ_0-usNNiNn3ocM_R7SA-1; Sat, 19 Oct 2019 19:35:11 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AC77107AD32;
        Sat, 19 Oct 2019 23:35:08 +0000 (UTC)
Received: from f30-node1.dwysocha.net (dhcp145-42.rdu.redhat.com [10.13.145.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1B6E600CE;
        Sat, 19 Oct 2019 23:35:05 +0000 (UTC)
From:   Dave Wysochanski <dwysocha@redhat.com>
To:     Pavel Shilovskiy <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs@vger.kernel.org, Frank Sorenson <sorenson@redhat.com>
Subject: [RFC PATCH v2] cifs: Fix list_del corruption of retry_list in cifs_reconnect
Date:   Sat, 19 Oct 2019 19:35:05 -0400
Message-Id: <20191019233505.14191-1-dwysocha@redhat.com>
In-Reply-To: <DM5PR21MB0185857761946DBE12AEB3ADB66C0@DM5PR21MB0185.namprd21.prod.outlook.com>
References: <DM5PR21MB0185857761946DBE12AEB3ADB66C0@DM5PR21MB0185.namprd21.prod.outlook.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: qsJ_0-usNNiNn3ocM_R7SA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is a second attempt at the fix for the list_del corruption
issue.  This patch adds a similar refcount approach in=20
clean_demultiplex_info() since that was noticed.  However, for
some reason I now get the list_del corruption come back fairly
quickly (after a few minutes) and eventually a softlockup.
I have not tracked down the problem yet.


There's a race between the demultiplexer thread and the request
issuing thread similar to the race described in
commit 696e420bb2a6 ("cifs: Fix use after free of a mid_q_entry")
where both threads may obtain and attempt to call list_del_init
on the same mid and a list_del corruption similar to the
following will result:

[  430.454897] list_del corruption. prev->next should be ffff98d3a8f316c0, =
but was 2e885cb266355469
[  430.464668] ------------[ cut here ]------------
[  430.466569] kernel BUG at lib/list_debug.c:51!
[  430.468476] invalid opcode: 0000 [#1] SMP PTI
[  430.470286] CPU: 0 PID: 13267 Comm: cifsd Kdump: loaded Not tainted 5.4.=
0-rc3+ #19
[  430.473472] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  430.475872] RIP: 0010:__list_del_entry_valid.cold+0x31/0x55
[  430.478129] Code: 5e 15 8e e8 54 a3 c5 ff 0f 0b 48 c7 c7 78 5f 15 8e e8 =
46 a3 c5 ff 0f 0b 48 89 f2 48 89 fe 48 c7 c7 38 5f 15 8e e8 32 a3 c5 ff <0f=
> 0b 48 89 fe 4c 89 c2 48 c7 c7 00 5f 15 8e e8 1e a3 c5 ff 0f 0b
[  430.485563] RSP: 0018:ffffb4db0042fd38 EFLAGS: 00010246
[  430.487665] RAX: 0000000000000054 RBX: ffff98d3aabb8800 RCX: 00000000000=
00000
[  430.490513] RDX: 0000000000000000 RSI: ffff98d3b7a17908 RDI: ffff98d3b7a=
17908
[  430.493383] RBP: ffff98d3a8f316c0 R08: ffff98d3b7a17908 R09: 00000000000=
00285
[  430.496258] R10: ffffb4db0042fbf0 R11: ffffb4db0042fbf5 R12: ffff98d3aab=
b89c0
[  430.499113] R13: ffffb4db0042fd48 R14: 2e885cb266355469 R15: ffff98d3b24=
c4480
[  430.501981] FS:  0000000000000000(0000) GS:ffff98d3b7a00000(0000) knlGS:=
0000000000000000
[  430.505232] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  430.507546] CR2: 00007f08cd17b9c0 CR3: 000000023484a000 CR4: 00000000000=
406f0
[  430.510426] Call Trace:
[  430.511500]  cifs_reconnect+0x25e/0x610 [cifs]
[  430.513350]  cifs_readv_from_socket+0x220/0x250 [cifs]
[  430.515464]  cifs_read_from_socket+0x4a/0x70 [cifs]
[  430.517452]  ? try_to_wake_up+0x212/0x650
[  430.519122]  ? cifs_small_buf_get+0x16/0x30 [cifs]
[  430.521086]  ? allocate_buffers+0x66/0x120 [cifs]
[  430.523019]  cifs_demultiplex_thread+0xdc/0xc30 [cifs]
[  430.525116]  kthread+0xfb/0x130
[  430.526421]  ? cifs_handle_standard+0x190/0x190 [cifs]
[  430.528514]  ? kthread_park+0x90/0x90
[  430.530019]  ret_from_fork+0x35/0x40

To fix the above, inside cifs_reconnect unconditionally set the
state to MID_RETRY_NEEDED, and then take a reference before we
move any mid_q_entry on server->pending_mid_q to the temporary
retry_list.  Then while processing retry_list make sure we check
the state is still MID_RETRY_NEEDED while holding GlobalMid_Lock
before calling list_del_init.  Then after mid_q_entry callback
has been completed, drop the reference.  In the code paths for
request issuing thread, avoid calling list_del_init if we
notice mid->mid_state !=3D MID_RETRY_NEEDED, avoiding the
race and duplicate call to list_del_init.  In addition to
the above MID_RETRY_NEEDED case, handle the MID_SHUTDOWN case
in a similar fashion to avoid the possibility of a similar
crash.

Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/connect.c   | 30 ++++++++++++++++++++++--------
 fs/cifs/transport.c |  8 ++++++--
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a64dfa95a925..0327bace214d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -564,8 +564,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
 =09spin_lock(&GlobalMid_Lock);
 =09list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 =09=09mid_entry =3D list_entry(tmp, struct mid_q_entry, qhead);
-=09=09if (mid_entry->mid_state =3D=3D MID_REQUEST_SUBMITTED)
-=09=09=09mid_entry->mid_state =3D MID_RETRY_NEEDED;
+=09=09kref_get(&mid_entry->refcount);
+=09=09WARN_ON(mid_entry->mid_state !=3D MID_REQUEST_SUBMITTED);
+=09=09mid_entry->mid_state =3D MID_RETRY_NEEDED;
 =09=09list_move(&mid_entry->qhead, &retry_list);
 =09}
 =09spin_unlock(&GlobalMid_Lock);
@@ -574,8 +575,12 @@ cifs_reconnect(struct TCP_Server_Info *server)
 =09cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
 =09list_for_each_safe(tmp, tmp2, &retry_list) {
 =09=09mid_entry =3D list_entry(tmp, struct mid_q_entry, qhead);
-=09=09list_del_init(&mid_entry->qhead);
+=09=09spin_lock(&GlobalMid_Lock);
+=09=09if (mid_entry->mid_state =3D=3D MID_RETRY_NEEDED)
+=09=09=09list_del_init(&mid_entry->qhead);
+=09=09spin_unlock(&GlobalMid_Lock);
 =09=09mid_entry->callback(mid_entry);
+=09=09cifs_mid_q_entry_release(mid_entry);
 =09}
=20
 =09if (cifs_rdma_enabled(server)) {
@@ -884,10 +889,6 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
 =09mid->when_received =3D jiffies;
 #endif
 =09spin_lock(&GlobalMid_Lock);
-=09if (!malformed)
-=09=09mid->mid_state =3D MID_RESPONSE_RECEIVED;
-=09else
-=09=09mid->mid_state =3D MID_RESPONSE_MALFORMED;
 =09/*
 =09 * Trying to handle/dequeue a mid after the send_recv()
 =09 * function has finished processing it is a bug.
@@ -895,8 +896,15 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
 =09if (mid->mid_flags & MID_DELETED)
 =09=09printk_once(KERN_WARNING
 =09=09=09    "trying to dequeue a deleted mid\n");
-=09else
+=09if (mid->mid_state !=3D MID_RETRY_NEEDED &&
+=09    mid->mid_state !=3D MID_SHUTDOWN)
 =09=09list_del_init(&mid->qhead);
+
+=09if (!malformed)
+=09=09mid->mid_state =3D MID_RESPONSE_RECEIVED;
+=09else
+=09=09mid->mid_state =3D MID_RESPONSE_MALFORMED;
+
 =09spin_unlock(&GlobalMid_Lock);
 }
=20
@@ -966,6 +974,7 @@ static void clean_demultiplex_info(struct TCP_Server_In=
fo *server)
 =09=09list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 =09=09=09mid_entry =3D list_entry(tmp, struct mid_q_entry, qhead);
 =09=09=09cifs_dbg(FYI, "Clearing mid 0x%llx\n", mid_entry->mid);
+=09=09=09kref_get(&mid_entry->refcount);
 =09=09=09mid_entry->mid_state =3D MID_SHUTDOWN;
 =09=09=09list_move(&mid_entry->qhead, &dispose_list);
 =09=09}
@@ -975,8 +984,13 @@ static void clean_demultiplex_info(struct TCP_Server_I=
nfo *server)
 =09=09list_for_each_safe(tmp, tmp2, &dispose_list) {
 =09=09=09mid_entry =3D list_entry(tmp, struct mid_q_entry, qhead);
 =09=09=09cifs_dbg(FYI, "Callback mid 0x%llx\n", mid_entry->mid);
+=09=09=09spin_lock(&GlobalMid_Lock);
+=09=09=09if (mid_entry->mid_state =3D=3D MID_SHUTDOWN)
+=09=09=09=09list_del_init(&mid_entry->qhead);
+=09=09=09spin_unlock(&GlobalMid_Lock);
 =09=09=09list_del_init(&mid_entry->qhead);
 =09=09=09mid_entry->callback(mid_entry);
+=09=09=09cifs_mid_q_entry_release(mid_entry);
 =09=09}
 =09=09/* 1/8th of sec is more than enough time for them to exit */
 =09=09msleep(125);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 308ad0f495e1..d1794bd664ae 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -173,7 +173,9 @@ void
 cifs_delete_mid(struct mid_q_entry *mid)
 {
 =09spin_lock(&GlobalMid_Lock);
-=09list_del_init(&mid->qhead);
+=09if (mid->mid_state !=3D MID_RETRY_NEEDED &&
+=09    mid->mid_state !=3D MID_SHUTDOWN)
+=09=09list_del_init(&mid->qhead);
 =09mid->mid_flags |=3D MID_DELETED;
 =09spin_unlock(&GlobalMid_Lock);
=20
@@ -872,7 +874,9 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TC=
P_Server_Info *server)
 =09=09rc =3D -EHOSTDOWN;
 =09=09break;
 =09default:
-=09=09list_del_init(&mid->qhead);
+=09=09if (mid->mid_state !=3D MID_RETRY_NEEDED &&
+=09=09    mid->mid_state !=3D MID_SHUTDOWN)
+=09=09=09list_del_init(&mid->qhead);
 =09=09cifs_server_dbg(VFS, "%s: invalid mid state mid=3D%llu state=3D%d\n"=
,
 =09=09=09 __func__, mid->mid, mid->mid_state);
 =09=09rc =3D -EIO;
--=20
2.21.0

