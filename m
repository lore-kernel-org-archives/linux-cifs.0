Return-Path: <SRS0=LLm2=ZN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD26C432C0
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 19:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 778DD2068F
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 19:34:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KFXUIOaL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfKUTej (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Nov 2019 14:34:39 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43531 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKUTei (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Nov 2019 14:34:38 -0500
Received: by mail-lj1-f193.google.com with SMTP id y23so4538123ljh.10
        for <linux-cifs@vger.kernel.org>; Thu, 21 Nov 2019 11:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N/cdbIknx/GGpg2fL/8i9dG0GduotRBH4jg7hTidhzU=;
        b=KFXUIOaLDvUJtA6vyc+zk9Rbv04f3/uEkpmYqGUjK8NeSdd4onNnmLBllkR3PGtPyJ
         kYDeu5r2G9o61xy5RS5to3PPei57hlRKQc6vgocjCeUIFF8f7hYag9lyvkhDT2LqrqU5
         Jm43Sm6KoEkfLBfrE4m5P88QAzR2v5GrlDA+49aCTlhDStZzgWZKl6yYbUGL2aeLpu0D
         SYzm81NYC/gaUKzDPM2LJ8EwRdL9/W/h5jfybXTqVuPBAHffaNcGL05aMglz/ooUDxUS
         KwO0rOmeI68X52YpVLHeUOKh292/VkeDHwt28GkgeJS8/b2WsqZkgqfeufUZxza9p8iA
         1g6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N/cdbIknx/GGpg2fL/8i9dG0GduotRBH4jg7hTidhzU=;
        b=sIbjm6+Iaf2rQnu/SHbeJ5xUKYwsyHBc5xqtBjDlss1pFlAjjZYuBkHiiPqKwflJuC
         yeCxaQwTMFcZ6u7xdd6NaPfEmOO4EMixQQx/yvLccTrtfv0WDpPBpmUu7Lt5k79JN1qF
         n3BU1LKoQ8D+G3vzUH9N0IsP2xwgykzYNl4OaxS8etwbAqh3/04fvuU5t0U+6mnPD7JY
         Uo/GaxgsKDQQQaQVtBYqHpGl+mjTY9tAjt1c6Fjw22jTq2ZPkMwxopEPwD0cX/47/TKI
         sOkuhJogfeSPw3r5SNKhqE8hbaFDbcp44PXTKa8RT50hbIz7KUcfcF7kos845PkZ0t5y
         BXRA==
X-Gm-Message-State: APjAAAVTTc0LbrB+H7qocfsFMrhh/mxGYh+T54sqUJQyAHtNVb3BpmJe
        6sOafX/mOR8rShB4kk2NIdwSCsz1l047bsHDpA==
X-Google-Smtp-Source: APXvYqwD3o2Ip05UGNAwtlrV39izk4vh8mZhUB6HvuzSW9j/+i9ihTapd+/DWekIk2MicKj1ZBacfvf025cgc7Ow8pU=
X-Received: by 2002:a05:651c:111a:: with SMTP id d26mr9102798ljo.168.1574364875954;
 Thu, 21 Nov 2019 11:34:35 -0800 (PST)
MIME-Version: 1.0
References: <20191114061646.22122-1-lsahlber@redhat.com> <20191114061646.22122-2-lsahlber@redhat.com>
 <CAKywueRUUfLcRMze1P5pgF8KPcizYdhFH_TBbBAZGr0fZa1ikw@mail.gmail.com>
 <CAKywueT_4h+UmdmKcs4w7Guvu4j4YOxcsKakViuGqzWq6JQK5g@mail.gmail.com> <CAH2r5mt7ot=W+PLsMYXdNNS3LbHTwd6=qV+agQ53-yBPLhuR4A@mail.gmail.com>
In-Reply-To: <CAH2r5mt7ot=W+PLsMYXdNNS3LbHTwd6=qV+agQ53-yBPLhuR4A@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 21 Nov 2019 11:34:24 -0800
Message-ID: <CAKywueSaWxCf4-EOGG72ZrLFH2+a5DCa-yVMCzUHX2zdgKPhiA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix race between compound_send_recv() and the
 demultiplex thread
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I figured out the problem: there is another race between the
demultiplex thread and a system call thread which leads to
mid->resp_buf being NULL when it is being accessed to get credits.
This is unrelated to this patch but it probably just increases
probability of this to happen.

Diving deeply into the code, I think this patch doesn't solve the
problem completely - there is still a possibility that the demultiplex
thread finished processing of the mid by the time the mid is set as
cancelled. Also we can't set cancelled callback in the case when a
response has been already processed because the cancelled callback
won't be called and the mid will be leaked.

I created a patch to fix the race another way: by moving handling of
cancelled mids into the mid destructor. By that time there should be
only one thread referencing the mid, so, a race should occur there. I
will post the patch to the list together with other patches.

--
Best regards,
Pavel Shilovsky

=D1=81=D1=80, 20 =D0=BD=D0=BE=D1=8F=D0=B1. 2019 =D0=B3. =D0=B2 16:10, Steve=
 French <smfrench@gmail.com>:
>
> temporarily removed this patch from cifs-2.6.git for-next to give time
> to respin the patch
>
> On Wed, Nov 20, 2019 at 5:57 PM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > =D0=BF=D1=82, 15 =D0=BD=D0=BE=D1=8F=D0=B1. 2019 =D0=B3. =D0=B2 10:07, P=
avel Shilovsky <piastryyy@gmail.com>:
> > >
> > > =D1=81=D1=80, 13 =D0=BD=D0=BE=D1=8F=D0=B1. 2019 =D0=B3. =D0=B2 22:17,=
 Ronnie Sahlberg <lsahlber@redhat.com>:
> > > >
> > > > There is a race where the open() may be interrupted between when we=
 receive the reply
> > > > but before we have invoked the callback in which case we never end =
up calling
> > > > handle_cancelled_mid() and thus leak an open handle on the server.
> > > >
> > > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > > ---
> > > >  fs/cifs/connect.c   | 1 -
> > > >  fs/cifs/transport.c | 2 +-
> > > >  2 files changed, 1 insertion(+), 2 deletions(-)
> > > >
> > > > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > > > index ccaa8bad336f..802604a7e692 100644
> > > > --- a/fs/cifs/connect.c
> > > > +++ b/fs/cifs/connect.c
> > > > @@ -1223,7 +1223,6 @@ cifs_demultiplex_thread(void *p)
> > > >                         if (mids[i] !=3D NULL) {
> > > >                                 mids[i]->resp_buf_size =3D server->=
pdu_size;
> > > >                                 if ((mids[i]->mid_flags & MID_WAIT_=
CANCELLED) &&
> > > > -                                   mids[i]->mid_state =3D=3D MID_R=
ESPONSE_RECEIVED &&
> > > >                                     server->ops->handle_cancelled_m=
id)
> > > >                                         server->ops->handle_cancell=
ed_mid(
> > > >                                                         mids[i]->re=
sp_buf,
> > > > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > > > index ca3de62688d6..0f219f7653f3 100644
> > > > --- a/fs/cifs/transport.c
> > > > +++ b/fs/cifs/transport.c
> > > > @@ -1119,7 +1119,7 @@ compound_send_recv(const unsigned int xid, st=
ruct cifs_ses *ses,
> > > >                                  midQ[i]->mid, le16_to_cpu(midQ[i]-=
>command));
> > > >                         send_cancel(server, &rqst[i], midQ[i]);
> > > >                         spin_lock(&GlobalMid_Lock);
> > > > -                       if (midQ[i]->mid_state =3D=3D MID_REQUEST_S=
UBMITTED) {
> > > > +                       if (is_interrupt_error(rc)) {
> > > >                                 midQ[i]->mid_flags |=3D MID_WAIT_CA=
NCELLED;
> > > >                                 midQ[i]->callback =3D cifs_cancelle=
d_callback;
> > > >                                 cancelled_mid[i] =3D true;
> > > > --
> > > > 2.13.6
> > > >
> > >
> > > It doesn't seem that RC may be anything other than -ERESTARTSYS but
> > > is_interrupt_error() should work.
> > >
> > > Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> > >
> > > --
> > > Best regards,
> > > Pavel Shilovsky
> >
> > Tested it out. The following part of this change
> >
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index ca3de62688d6..0f219f7653f3 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -1119,7 +1119,7 @@ compound_send_recv(const unsigned int xid,
> > struct cifs_ses *ses,
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
> >
> > is causing NULL-pointer dereference on my system:
> >
> > [681000.970523] BUG: kernel NULL pointer dereference, address: 00000000=
0000000e
> > [681000.970526] #PF: supervisor read access in kernel mode
> > [681000.970527] #PF: error_code(0x0000) - not-present page
> > [681000.970528] PGD 0 P4D 0
> > [681000.970531] Oops: 0000 [#1] SMP PTI
> > [681000.970533] CPU: 3 PID: 15946 Comm: cifsd Tainted: G           OE
> >    5.3.7-050307-generic #201910180652
> > [681000.970534] Hardware name: Microsoft Corporation Virtual
> > Machine/Virtual Machine, BIOS 090008  12/07/2018
> > [681000.970554] RIP: 0010:smb2_get_credits+0x1f/0x30 [cifs]
> > [681000.970556] Code: 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
> > 8b 57 6c 55 48 89 e5 83 fa 04 74 09 31 c0 83 fa 10 74 02 5d c3 48 8b
> > 47 60 5d <0f> b7 40 0e c3 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44
> > 00 00
> > [681000.970558] RSP: 0018:ffffa9d680433df0 EFLAGS: 00010246
> > [681000.970559] RAX: 0000000000000000 RBX: ffff9a0ef1775000 RCX:
> > 0000000000000000
> > [681000.970560] RDX: 0000000000000004 RSI: 0000000000000000 RDI:
> > ffff9a0ef15c0780
> > [681000.970561] RBP: ffffa9d680433e18 R08: 0000000000000218 R09:
> > 00000000001bfc3a
> > [681000.970562] R10: 00000000000dfe1d R11: ffff9a0ef1b7cae0 R12:
> > ffff9a0ef15c0780
> > [681000.970563] R13: ffffa9d680433e80 R14: ffffa9d680433ea8 R15:
> > 0000000000000001
> > [681000.970565] FS:  0000000000000000(0000) GS:ffff9a0ef7b80000(0000)
> > knlGS:0000000000000000
> > [681000.970566] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [681000.970566] CR2: 000000000000000e CR3: 00000000e7e0a001 CR4:
> > 00000000003606e0
> > [681000.970569] Call Trace:
> > [681000.970585]  ? cifs_compound_callback+0x33/0x80 [cifs]
> > [681000.970599]  cifs_compound_last_callback+0x12/0x20 [cifs]
> > [681000.970611]  cifs_demultiplex_thread+0x6d4/0xc40 [cifs]
> > [681000.970615]  kthread+0x104/0x140
> > [681000.970627]  ? cifs_handle_standard+0x190/0x190 [cifs]
> > [681000.970629]  ? kthread_park+0x80/0x80
> > [681000.970631]  ret_from_fork+0x35/0x40
> >
> > Still haven't figured out why this is happening. Looking.
> >
> > --
> > Best regards,
> > Pavel Shilovsky
>
>
>
> --
> Thanks,
>
> Steve
