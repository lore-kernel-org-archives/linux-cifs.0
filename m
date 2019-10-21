Return-Path: <SRS0=SN/X=YO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E335ECA9EAF
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Oct 2019 22:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A39D02067B
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Oct 2019 22:34:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BEU7Edge"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730433AbfJUWeq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Oct 2019 18:34:46 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39572 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729620AbfJUWeo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Oct 2019 18:34:44 -0400
Received: by mail-lf1-f67.google.com with SMTP id 195so11411962lfj.6
        for <linux-cifs@vger.kernel.org>; Mon, 21 Oct 2019 15:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9FQHOqWJOlHg38JxYNsZ5k3EG0nvvScE0HstmvJFOVs=;
        b=BEU7EdgeRNFqrRG+Ja/68OY3edIlrND5TeN5vF8lYOl0+n/A3ptvCR8LEzOYsLthIY
         h4kLqRCY5PhkxjYirqf82FdLG+/j/833qpSuZTdf1JCsoYmYxgY/P77wMJUAy/FBqsiu
         fy+K8EATkntDZ066krwGzZ6BIztD+zUBRojuqAUHT9Aj1E6d9ZTIiaGdybgZ8ZMLPR/0
         coFmoZ3tGHuaiq/u7vCla6XwivZwgVDsCSB2G0OhH5DuL9ACJPRfhLbRKUZCmilpWDgO
         vRqMVr01RDVqoqw7eI4H6/ke7fja3rZO1RIeUrm5NaM0IP9hVfdB8p/ZcApycEMb51+Z
         m2wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9FQHOqWJOlHg38JxYNsZ5k3EG0nvvScE0HstmvJFOVs=;
        b=l7JbOl3NRe0f6bfG+VVhSlDFxGYfM3VM9csZqhVp2OnjKJ3xTe/LlE1PC/9FQ0meDD
         Id4F01AIkGjZv0VhQYdcSUrwab2hvsE1wwa1psLpFDrkqyp1c5FWzF6dSyi+B0yrPY4o
         UNANB8x1iN0YggeLVS8/IXdx5QZhNAcot6RZteypktxO9PXqI63TCZq0goQOoYhQFNcH
         RohrLPRRZOa8SH3vVECcUO2bc+pKpls/fX3fE5wSMesOTdQdpSdP0zdQ5LFZZI5m0GSP
         hzSgERimZuLwpb5auhR971QecVC2JEmuzgpC+U3jkcDT+s6vT16qLTNb2T/NaW/G89Pm
         spWg==
X-Gm-Message-State: APjAAAWg9v2i5/qC/e3RynNJCmNBDsIEzQPxKM21HjVwrMf2VlLCgFlT
        pEeHqcwqpukOoML7yyOKz5oaLKbq8dgkOfRNMA==
X-Google-Smtp-Source: APXvYqxMNfTALfV8hlxH/p8sI2GVd1GuJXQJi16wutlvu3S7ppWSGoB1EaPLmCWPIIpLr4586rjM3crjegWSEbG/My0=
X-Received: by 2002:ac2:52b1:: with SMTP id r17mr16340571lfm.25.1571697280504;
 Mon, 21 Oct 2019 15:34:40 -0700 (PDT)
MIME-Version: 1.0
References: <DM5PR21MB0185857761946DBE12AEB3ADB66C0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <20191019233505.14191-1-dwysocha@redhat.com>
In-Reply-To: <20191019233505.14191-1-dwysocha@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 21 Oct 2019 15:34:29 -0700
Message-ID: <CAKywueSdK1+Mg0FLea5Vu98A016NphfbSW8TEsvLEf9iHS3ZaA@mail.gmail.com>
Subject: Re: [RFC PATCH v2] cifs: Fix list_del corruption of retry_list in cifs_reconnect
To:     Dave Wysochanski <dwysocha@redhat.com>
Cc:     Pavel Shilovskiy <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Frank Sorenson <sorenson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D0=B1, 19 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 16:39, Dave Wysoch=
anski <dwysocha@redhat.com>:
>
> This is a second attempt at the fix for the list_del corruption
> issue.  This patch adds a similar refcount approach in
> clean_demultiplex_info() since that was noticed.  However, for
> some reason I now get the list_del corruption come back fairly
> quickly (after a few minutes) and eventually a softlockup.
> I have not tracked down the problem yet.
>

Please find a couple comments below. Not sure that they relate to the
crash you are observing.

>
> There's a race between the demultiplexer thread and the request
> issuing thread similar to the race described in
> commit 696e420bb2a6 ("cifs: Fix use after free of a mid_q_entry")
> where both threads may obtain and attempt to call list_del_init
> on the same mid and a list_del corruption similar to the
> following will result:
>
> [  430.454897] list_del corruption. prev->next should be ffff98d3a8f316c0=
, but was 2e885cb266355469
> [  430.464668] ------------[ cut here ]------------
> [  430.466569] kernel BUG at lib/list_debug.c:51!
> [  430.468476] invalid opcode: 0000 [#1] SMP PTI
> [  430.470286] CPU: 0 PID: 13267 Comm: cifsd Kdump: loaded Not tainted 5.=
4.0-rc3+ #19
> [  430.473472] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [  430.475872] RIP: 0010:__list_del_entry_valid.cold+0x31/0x55
> [  430.478129] Code: 5e 15 8e e8 54 a3 c5 ff 0f 0b 48 c7 c7 78 5f 15 8e e=
8 46 a3 c5 ff 0f 0b 48 89 f2 48 89 fe 48 c7 c7 38 5f 15 8e e8 32 a3 c5 ff <=
0f> 0b 48 89 fe 4c 89 c2 48 c7 c7 00 5f 15 8e e8 1e a3 c5 ff 0f 0b
> [  430.485563] RSP: 0018:ffffb4db0042fd38 EFLAGS: 00010246
> [  430.487665] RAX: 0000000000000054 RBX: ffff98d3aabb8800 RCX: 000000000=
0000000
> [  430.490513] RDX: 0000000000000000 RSI: ffff98d3b7a17908 RDI: ffff98d3b=
7a17908
> [  430.493383] RBP: ffff98d3a8f316c0 R08: ffff98d3b7a17908 R09: 000000000=
0000285
> [  430.496258] R10: ffffb4db0042fbf0 R11: ffffb4db0042fbf5 R12: ffff98d3a=
abb89c0
> [  430.499113] R13: ffffb4db0042fd48 R14: 2e885cb266355469 R15: ffff98d3b=
24c4480
> [  430.501981] FS:  0000000000000000(0000) GS:ffff98d3b7a00000(0000) knlG=
S:0000000000000000
> [  430.505232] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  430.507546] CR2: 00007f08cd17b9c0 CR3: 000000023484a000 CR4: 000000000=
00406f0
> [  430.510426] Call Trace:
> [  430.511500]  cifs_reconnect+0x25e/0x610 [cifs]
> [  430.513350]  cifs_readv_from_socket+0x220/0x250 [cifs]
> [  430.515464]  cifs_read_from_socket+0x4a/0x70 [cifs]
> [  430.517452]  ? try_to_wake_up+0x212/0x650
> [  430.519122]  ? cifs_small_buf_get+0x16/0x30 [cifs]
> [  430.521086]  ? allocate_buffers+0x66/0x120 [cifs]
> [  430.523019]  cifs_demultiplex_thread+0xdc/0xc30 [cifs]
> [  430.525116]  kthread+0xfb/0x130
> [  430.526421]  ? cifs_handle_standard+0x190/0x190 [cifs]
> [  430.528514]  ? kthread_park+0x90/0x90
> [  430.530019]  ret_from_fork+0x35/0x40
>
> To fix the above, inside cifs_reconnect unconditionally set the
> state to MID_RETRY_NEEDED, and then take a reference before we
> move any mid_q_entry on server->pending_mid_q to the temporary
> retry_list.  Then while processing retry_list make sure we check
> the state is still MID_RETRY_NEEDED while holding GlobalMid_Lock
> before calling list_del_init.  Then after mid_q_entry callback
> has been completed, drop the reference.  In the code paths for
> request issuing thread, avoid calling list_del_init if we
> notice mid->mid_state !=3D MID_RETRY_NEEDED, avoiding the
> race and duplicate call to list_del_init.  In addition to
> the above MID_RETRY_NEEDED case, handle the MID_SHUTDOWN case
> in a similar fashion to avoid the possibility of a similar
> crash.
>
> Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
> Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/connect.c   | 30 ++++++++++++++++++++++--------
>  fs/cifs/transport.c |  8 ++++++--
>  2 files changed, 28 insertions(+), 10 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index a64dfa95a925..0327bace214d 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -564,8 +564,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
>         spin_lock(&GlobalMid_Lock);
>         list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
>                 mid_entry =3D list_entry(tmp, struct mid_q_entry, qhead);
> -               if (mid_entry->mid_state =3D=3D MID_REQUEST_SUBMITTED)
> -                       mid_entry->mid_state =3D MID_RETRY_NEEDED;
> +               kref_get(&mid_entry->refcount);
> +               WARN_ON(mid_entry->mid_state !=3D MID_REQUEST_SUBMITTED);
> +               mid_entry->mid_state =3D MID_RETRY_NEEDED;
>                 list_move(&mid_entry->qhead, &retry_list);
>         }
>         spin_unlock(&GlobalMid_Lock);
> @@ -574,8 +575,12 @@ cifs_reconnect(struct TCP_Server_Info *server)
>         cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
>         list_for_each_safe(tmp, tmp2, &retry_list) {
>                 mid_entry =3D list_entry(tmp, struct mid_q_entry, qhead);
> -               list_del_init(&mid_entry->qhead);
> +               spin_lock(&GlobalMid_Lock);
> +               if (mid_entry->mid_state =3D=3D MID_RETRY_NEEDED)
> +                       list_del_init(&mid_entry->qhead);

Here you are removing the entry from the local list - it shouldn't be
conditional because the list is supposed to be empty when the function
exists.
Also once removed, we are not adding the mid back to the pending list,
so, it doesn't seem that holding a lock is required here.


> +               spin_unlock(&GlobalMid_Lock);
>                 mid_entry->callback(mid_entry);
> +               cifs_mid_q_entry_release(mid_entry);
>         }
>
>         if (cifs_rdma_enabled(server)) {
> @@ -884,10 +889,6 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
>         mid->when_received =3D jiffies;
>  #endif
>         spin_lock(&GlobalMid_Lock);
> -       if (!malformed)
> -               mid->mid_state =3D MID_RESPONSE_RECEIVED;
> -       else
> -               mid->mid_state =3D MID_RESPONSE_MALFORMED;
>         /*
>          * Trying to handle/dequeue a mid after the send_recv()
>          * function has finished processing it is a bug.
> @@ -895,8 +896,15 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
>         if (mid->mid_flags & MID_DELETED)
>                 printk_once(KERN_WARNING
>                             "trying to dequeue a deleted mid\n");
> -       else
> +       if (mid->mid_state !=3D MID_RETRY_NEEDED &&
> +           mid->mid_state !=3D MID_SHUTDOWN)
>                 list_del_init(&mid->qhead);
> +
> +       if (!malformed)
> +               mid->mid_state =3D MID_RESPONSE_RECEIVED;
> +       else
> +               mid->mid_state =3D MID_RESPONSE_MALFORMED;
> +
>         spin_unlock(&GlobalMid_Lock);
>  }
>
> @@ -966,6 +974,7 @@ static void clean_demultiplex_info(struct TCP_Server_=
Info *server)
>                 list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
>                         mid_entry =3D list_entry(tmp, struct mid_q_entry,=
 qhead);
>                         cifs_dbg(FYI, "Clearing mid 0x%llx\n", mid_entry-=
>mid);
> +                       kref_get(&mid_entry->refcount);
>                         mid_entry->mid_state =3D MID_SHUTDOWN;
>                         list_move(&mid_entry->qhead, &dispose_list);
>                 }
> @@ -975,8 +984,13 @@ static void clean_demultiplex_info(struct TCP_Server=
_Info *server)
>                 list_for_each_safe(tmp, tmp2, &dispose_list) {
>                         mid_entry =3D list_entry(tmp, struct mid_q_entry,=
 qhead);
>                         cifs_dbg(FYI, "Callback mid 0x%llx\n", mid_entry-=
>mid);
> +                       spin_lock(&GlobalMid_Lock);
> +                       if (mid_entry->mid_state =3D=3D MID_SHUTDOWN)
> +                               list_del_init(&mid_entry->qhead);
> +                       spin_unlock(&GlobalMid_Lock);
>                         list_del_init(&mid_entry->qhead)

Here list_del_init is possble called twice if mid state is SHUTDOWN.

;
>                         mid_entry->callback(mid_entry);
> +                       cifs_mid_q_entry_release(mid_entry);
>                 }
>                 /* 1/8th of sec is more than enough time for them to exit=
 */
>                 msleep(125);
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 308ad0f495e1..d1794bd664ae 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -173,7 +173,9 @@ void
>  cifs_delete_mid(struct mid_q_entry *mid)
>  {
>         spin_lock(&GlobalMid_Lock);
> -       list_del_init(&mid->qhead);
> +       if (mid->mid_state !=3D MID_RETRY_NEEDED &&
> +           mid->mid_state !=3D MID_SHUTDOWN)
> +               list_del_init(&mid->qhead);
>         mid->mid_flags |=3D MID_DELETED;
>         spin_unlock(&GlobalMid_Lock);
>
> @@ -872,7 +874,9 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct =
TCP_Server_Info *server)
>                 rc =3D -EHOSTDOWN;
>                 break;
>         default:
> -               list_del_init(&mid->qhead);
> +               if (mid->mid_state !=3D MID_RETRY_NEEDED &&
> +                   mid->mid_state !=3D MID_SHUTDOWN)
> +                       list_del_init(&mid->qhead);

No need to check for the state not being RETRY_NEEDED or MID_SHUTDOWN
because those cases are handled above in the switch.

>                 cifs_server_dbg(VFS, "%s: invalid mid state mid=3D%llu st=
ate=3D%d\n",
>                          __func__, mid->mid, mid->mid_state);
>                 rc =3D -EIO;
> --
> 2.21.0
>


--
Best regards,
Pavel Shilovsky
