Return-Path: <SRS0=JRKv=ZM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB187C432C0
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Nov 2019 23:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 775992075A
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Nov 2019 23:57:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sQJGzjDj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfKTX5t (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Nov 2019 18:57:49 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:32811 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfKTX5s (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Nov 2019 18:57:48 -0500
Received: by mail-lf1-f65.google.com with SMTP id d6so1052935lfc.0
        for <linux-cifs@vger.kernel.org>; Wed, 20 Nov 2019 15:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=08wGNd7Tj8cBug433AUvpoSoAGYiVe22byqHrqAvom4=;
        b=sQJGzjDjAeE+FJWRy1Gutz4Lm2qwVNuVWRzoT04h4mgyRIJYsyJC0WWyGDZusPL4J2
         nXybHBvOweG9ocRcuxd/g8eyvTS3R44xrXSGcNkBpWz3qhNMnSriW/twzH+Ic2IDCl1o
         7+vzC8AM4WOECS6T9NtY+rfsve3cdB7e9HnkS45IuyRsn/tmA/fgDmSh9Q69UBSRWMOC
         7596WQXPBQaMBDaJE4a+4sFT4lzK22/Q5iYIoly0iNGSqp3rjziImR9btyfNpsYM+bFz
         I+RRaDlG/DPy9+OcnvBd4EHhc94nVj1m/fiJDpxLuEFa2+2JY6EXGzoZIihQ1aCRQw89
         XQpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=08wGNd7Tj8cBug433AUvpoSoAGYiVe22byqHrqAvom4=;
        b=BmbUr2291KLoR21Usk8LGtpebeqPFGdMsmzXyg7ex/Gb2xVvPWpsWX4E9r3K5SL1wi
         UMirPDCSGcokZaNvi6dfy5ksdLY/s/WoAA1GMz+Se9QM1Arx/8pbrzJrTcPiVXQWdohn
         kh2sMayJFmd+KpyWkfhJUGm/xVb0NqMghLEuaCfll76Z11cYnrxD3ivGzgYc7gUHWmTO
         eWRVboiY5bPteXggr2lVpHKLBEew+cl+Jb53tKXdEAdxjpzYwTb65EFS1dJY7dYLeitz
         Ij1bxY0WUwFEyF2zyDGLAqcI3quk1H4vJAZR5bofsj1me0//v2Qqty+UvBUdfizL27Ku
         iluQ==
X-Gm-Message-State: APjAAAWIe34J0FlysRtc/lv7JOCWAmCNz/VWX+z6nT12zngehEYK7rq5
        Q0gEI1iZaaonTvXMfhY+2Q86bpGWVYlQyCjJ4Q==
X-Google-Smtp-Source: APXvYqxobgAkhHOqm6vg29GLMkoqTFYEhOGDUdLsVZ7DMkFH+7u6zWrCegxUo3VxPvpgqn28OzTOrpFpXyfCjAfPbOE=
X-Received: by 2002:a19:c697:: with SMTP id w145mr1203324lff.54.1574294266206;
 Wed, 20 Nov 2019 15:57:46 -0800 (PST)
MIME-Version: 1.0
References: <20191114061646.22122-1-lsahlber@redhat.com> <20191114061646.22122-2-lsahlber@redhat.com>
 <CAKywueRUUfLcRMze1P5pgF8KPcizYdhFH_TBbBAZGr0fZa1ikw@mail.gmail.com>
In-Reply-To: <CAKywueRUUfLcRMze1P5pgF8KPcizYdhFH_TBbBAZGr0fZa1ikw@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 20 Nov 2019 15:57:34 -0800
Message-ID: <CAKywueT_4h+UmdmKcs4w7Guvu4j4YOxcsKakViuGqzWq6JQK5g@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix race between compound_send_recv() and the
 demultiplex thread
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 15 =D0=BD=D0=BE=D1=8F=D0=B1. 2019 =D0=B3. =D0=B2 10:07, Pavel=
 Shilovsky <piastryyy@gmail.com>:
>
> =D1=81=D1=80, 13 =D0=BD=D0=BE=D1=8F=D0=B1. 2019 =D0=B3. =D0=B2 22:17, Ron=
nie Sahlberg <lsahlber@redhat.com>:
> >
> > There is a race where the open() may be interrupted between when we rec=
eive the reply
> > but before we have invoked the callback in which case we never end up c=
alling
> > handle_cancelled_mid() and thus leak an open handle on the server.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/connect.c   | 1 -
> >  fs/cifs/transport.c | 2 +-
> >  2 files changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index ccaa8bad336f..802604a7e692 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -1223,7 +1223,6 @@ cifs_demultiplex_thread(void *p)
> >                         if (mids[i] !=3D NULL) {
> >                                 mids[i]->resp_buf_size =3D server->pdu_=
size;
> >                                 if ((mids[i]->mid_flags & MID_WAIT_CANC=
ELLED) &&
> > -                                   mids[i]->mid_state =3D=3D MID_RESPO=
NSE_RECEIVED &&
> >                                     server->ops->handle_cancelled_mid)
> >                                         server->ops->handle_cancelled_m=
id(
> >                                                         mids[i]->resp_b=
uf,
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index ca3de62688d6..0f219f7653f3 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -1119,7 +1119,7 @@ compound_send_recv(const unsigned int xid, struct=
 cifs_ses *ses,
> >                                  midQ[i]->mid, le16_to_cpu(midQ[i]->com=
mand));
> >                         send_cancel(server, &rqst[i], midQ[i]);
> >                         spin_lock(&GlobalMid_Lock);
> > -                       if (midQ[i]->mid_state =3D=3D MID_REQUEST_SUBMI=
TTED) {
> > +                       if (is_interrupt_error(rc)) {
> >                                 midQ[i]->mid_flags |=3D MID_WAIT_CANCEL=
LED;
> >                                 midQ[i]->callback =3D cifs_cancelled_ca=
llback;
> >                                 cancelled_mid[i] =3D true;
> > --
> > 2.13.6
> >
>
> It doesn't seem that RC may be anything other than -ERESTARTSYS but
> is_interrupt_error() should work.
>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>
> --
> Best regards,
> Pavel Shilovsky

Tested it out. The following part of this change

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index ca3de62688d6..0f219f7653f3 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1119,7 +1119,7 @@ compound_send_recv(const unsigned int xid,
struct cifs_ses *ses,
                                 midQ[i]->mid, le16_to_cpu(midQ[i]->command=
));
                        send_cancel(server, &rqst[i], midQ[i]);
                        spin_lock(&GlobalMid_Lock);
-                       if (midQ[i]->mid_state =3D=3D MID_REQUEST_SUBMITTED=
) {
+                       if (is_interrupt_error(rc)) {
                                midQ[i]->mid_flags |=3D MID_WAIT_CANCELLED;
                                midQ[i]->callback =3D cifs_cancelled_callba=
ck;
                                cancelled_mid[i] =3D true;

is causing NULL-pointer dereference on my system:

[681000.970523] BUG: kernel NULL pointer dereference, address: 000000000000=
000e
[681000.970526] #PF: supervisor read access in kernel mode
[681000.970527] #PF: error_code(0x0000) - not-present page
[681000.970528] PGD 0 P4D 0
[681000.970531] Oops: 0000 [#1] SMP PTI
[681000.970533] CPU: 3 PID: 15946 Comm: cifsd Tainted: G           OE
   5.3.7-050307-generic #201910180652
[681000.970534] Hardware name: Microsoft Corporation Virtual
Machine/Virtual Machine, BIOS 090008  12/07/2018
[681000.970554] RIP: 0010:smb2_get_credits+0x1f/0x30 [cifs]
[681000.970556] Code: 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
8b 57 6c 55 48 89 e5 83 fa 04 74 09 31 c0 83 fa 10 74 02 5d c3 48 8b
47 60 5d <0f> b7 40 0e c3 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44
00 00
[681000.970558] RSP: 0018:ffffa9d680433df0 EFLAGS: 00010246
[681000.970559] RAX: 0000000000000000 RBX: ffff9a0ef1775000 RCX:
0000000000000000
[681000.970560] RDX: 0000000000000004 RSI: 0000000000000000 RDI:
ffff9a0ef15c0780
[681000.970561] RBP: ffffa9d680433e18 R08: 0000000000000218 R09:
00000000001bfc3a
[681000.970562] R10: 00000000000dfe1d R11: ffff9a0ef1b7cae0 R12:
ffff9a0ef15c0780
[681000.970563] R13: ffffa9d680433e80 R14: ffffa9d680433ea8 R15:
0000000000000001
[681000.970565] FS:  0000000000000000(0000) GS:ffff9a0ef7b80000(0000)
knlGS:0000000000000000
[681000.970566] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[681000.970566] CR2: 000000000000000e CR3: 00000000e7e0a001 CR4:
00000000003606e0
[681000.970569] Call Trace:
[681000.970585]  ? cifs_compound_callback+0x33/0x80 [cifs]
[681000.970599]  cifs_compound_last_callback+0x12/0x20 [cifs]
[681000.970611]  cifs_demultiplex_thread+0x6d4/0xc40 [cifs]
[681000.970615]  kthread+0x104/0x140
[681000.970627]  ? cifs_handle_standard+0x190/0x190 [cifs]
[681000.970629]  ? kthread_park+0x80/0x80
[681000.970631]  ret_from_fork+0x35/0x40

Still haven't figured out why this is happening. Looking.

--
Best regards,
Pavel Shilovsky
