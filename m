Return-Path: <SRS0=LLm2=ZN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65484C432C0
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 00:10:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3122D20878
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 00:10:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SsEegCAr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfKUAKL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Nov 2019 19:10:11 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:37699 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUAKL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Nov 2019 19:10:11 -0500
Received: by mail-io1-f66.google.com with SMTP id 1so1326024iou.4
        for <linux-cifs@vger.kernel.org>; Wed, 20 Nov 2019 16:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3xZu9Jrgfy4AzDWNnNBNFcZebRV9sr8gPtRLXx3vqvc=;
        b=SsEegCArzs6T+8oVNsaQo6v1VpEQCAOdXEpSHRm89QLoRPFWj7OE4Ta077EtwtOx0O
         RcQHq19iROmc2pTvA6tC24NqNexOfvJpK6hT/h3H5qkn/ERNTMfyUHJgJuZejkpJv0bp
         0nb4no3yKArZ5y74uxZH3BN5+JG6bpnqNw7ypEG3cYQ8bH1zawP0dbQObAF4IqEEFdOW
         EQcbgJUpB9I5jkgwrFDa6TMwK1Sl8qTJmbEk6VFUj5RiOA/8oRddRmUI6pamICM/dKgI
         +uRftpSQ5rbOptHajBsDZIE04uRuXaLY8+dG067xPE0hP6Hsz+cX7huppITDV73Ee8u7
         rf6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3xZu9Jrgfy4AzDWNnNBNFcZebRV9sr8gPtRLXx3vqvc=;
        b=PbENVdn8znFG8xqFAv7Xv+jHWQxDROrjFGS2Y+ZpLkgJguWIhE8CnNAr2Bmdp1d/Z6
         MrioQWiAYDPPfR76q8p5jIsh/nF7iQCEFUUNH1gJ57B1E+fx+it6ix9pbGHiqM8jUR8h
         +Yt63X7hNkN444Q/snNF+bAI1wNUMe4EeymkLaHGxioeJQbguTGMM21sr2HAH4q1yi23
         lgHMnx4172K8ccTTNabHTilSisiK7uxnCGaUqFe0F1Heoeamls+xHGnSauO0QnV6+c3P
         issXuoD57cb3PqlSEpVXYZJqSnvGIDBdMox3JKobjIXVNIGm80ETSfeAI+CIV5c/MgN2
         TipA==
X-Gm-Message-State: APjAAAWzYL8LdaZbpVkyYG7PbREGqk/zd8KVoSKBnO/v02Z8RXTe6Vrv
        1o7Tym/dWKEYkxQW+17a+Zhi7TfL0Kzjx2IHOm4=
X-Google-Smtp-Source: APXvYqwvuoGlsAos8eoGkQbqVjVbZln24uCyOmhDLOMtuaXk2v7frUyQXSDn/Aa4zHXlGJNCseUflRtNLDJ/1gwsBpo=
X-Received: by 2002:a02:a995:: with SMTP id q21mr6123954jam.27.1574295010189;
 Wed, 20 Nov 2019 16:10:10 -0800 (PST)
MIME-Version: 1.0
References: <20191114061646.22122-1-lsahlber@redhat.com> <20191114061646.22122-2-lsahlber@redhat.com>
 <CAKywueRUUfLcRMze1P5pgF8KPcizYdhFH_TBbBAZGr0fZa1ikw@mail.gmail.com> <CAKywueT_4h+UmdmKcs4w7Guvu4j4YOxcsKakViuGqzWq6JQK5g@mail.gmail.com>
In-Reply-To: <CAKywueT_4h+UmdmKcs4w7Guvu4j4YOxcsKakViuGqzWq6JQK5g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 20 Nov 2019 18:09:59 -0600
Message-ID: <CAH2r5mt7ot=W+PLsMYXdNNS3LbHTwd6=qV+agQ53-yBPLhuR4A@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix race between compound_send_recv() and the
 demultiplex thread
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

temporarily removed this patch from cifs-2.6.git for-next to give time
to respin the patch

On Wed, Nov 20, 2019 at 5:57 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D0=BF=D1=82, 15 =D0=BD=D0=BE=D1=8F=D0=B1. 2019 =D0=B3. =D0=B2 10:07, Pav=
el Shilovsky <piastryyy@gmail.com>:
> >
> > =D1=81=D1=80, 13 =D0=BD=D0=BE=D1=8F=D0=B1. 2019 =D0=B3. =D0=B2 22:17, R=
onnie Sahlberg <lsahlber@redhat.com>:
> > >
> > > There is a race where the open() may be interrupted between when we r=
eceive the reply
> > > but before we have invoked the callback in which case we never end up=
 calling
> > > handle_cancelled_mid() and thus leak an open handle on the server.
> > >
> > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > ---
> > >  fs/cifs/connect.c   | 1 -
> > >  fs/cifs/transport.c | 2 +-
> > >  2 files changed, 1 insertion(+), 2 deletions(-)
> > >
> > > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > > index ccaa8bad336f..802604a7e692 100644
> > > --- a/fs/cifs/connect.c
> > > +++ b/fs/cifs/connect.c
> > > @@ -1223,7 +1223,6 @@ cifs_demultiplex_thread(void *p)
> > >                         if (mids[i] !=3D NULL) {
> > >                                 mids[i]->resp_buf_size =3D server->pd=
u_size;
> > >                                 if ((mids[i]->mid_flags & MID_WAIT_CA=
NCELLED) &&
> > > -                                   mids[i]->mid_state =3D=3D MID_RES=
PONSE_RECEIVED &&
> > >                                     server->ops->handle_cancelled_mid=
)
> > >                                         server->ops->handle_cancelled=
_mid(
> > >                                                         mids[i]->resp=
_buf,
> > > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > > index ca3de62688d6..0f219f7653f3 100644
> > > --- a/fs/cifs/transport.c
> > > +++ b/fs/cifs/transport.c
> > > @@ -1119,7 +1119,7 @@ compound_send_recv(const unsigned int xid, stru=
ct cifs_ses *ses,
> > >                                  midQ[i]->mid, le16_to_cpu(midQ[i]->c=
ommand));
> > >                         send_cancel(server, &rqst[i], midQ[i]);
> > >                         spin_lock(&GlobalMid_Lock);
> > > -                       if (midQ[i]->mid_state =3D=3D MID_REQUEST_SUB=
MITTED) {
> > > +                       if (is_interrupt_error(rc)) {
> > >                                 midQ[i]->mid_flags |=3D MID_WAIT_CANC=
ELLED;
> > >                                 midQ[i]->callback =3D cifs_cancelled_=
callback;
> > >                                 cancelled_mid[i] =3D true;
> > > --
> > > 2.13.6
> > >
> >
> > It doesn't seem that RC may be anything other than -ERESTARTSYS but
> > is_interrupt_error() should work.
> >
> > Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> >
> > --
> > Best regards,
> > Pavel Shilovsky
>
> Tested it out. The following part of this change
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index ca3de62688d6..0f219f7653f3 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -1119,7 +1119,7 @@ compound_send_recv(const unsigned int xid,
> struct cifs_ses *ses,
>                                  midQ[i]->mid, le16_to_cpu(midQ[i]->comma=
nd));
>                         send_cancel(server, &rqst[i], midQ[i]);
>                         spin_lock(&GlobalMid_Lock);
> -                       if (midQ[i]->mid_state =3D=3D MID_REQUEST_SUBMITT=
ED) {
> +                       if (is_interrupt_error(rc)) {
>                                 midQ[i]->mid_flags |=3D MID_WAIT_CANCELLE=
D;
>                                 midQ[i]->callback =3D cifs_cancelled_call=
back;
>                                 cancelled_mid[i] =3D true;
>
> is causing NULL-pointer dereference on my system:
>
> [681000.970523] BUG: kernel NULL pointer dereference, address: 0000000000=
00000e
> [681000.970526] #PF: supervisor read access in kernel mode
> [681000.970527] #PF: error_code(0x0000) - not-present page
> [681000.970528] PGD 0 P4D 0
> [681000.970531] Oops: 0000 [#1] SMP PTI
> [681000.970533] CPU: 3 PID: 15946 Comm: cifsd Tainted: G           OE
>    5.3.7-050307-generic #201910180652
> [681000.970534] Hardware name: Microsoft Corporation Virtual
> Machine/Virtual Machine, BIOS 090008  12/07/2018
> [681000.970554] RIP: 0010:smb2_get_credits+0x1f/0x30 [cifs]
> [681000.970556] Code: 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
> 8b 57 6c 55 48 89 e5 83 fa 04 74 09 31 c0 83 fa 10 74 02 5d c3 48 8b
> 47 60 5d <0f> b7 40 0e c3 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44
> 00 00
> [681000.970558] RSP: 0018:ffffa9d680433df0 EFLAGS: 00010246
> [681000.970559] RAX: 0000000000000000 RBX: ffff9a0ef1775000 RCX:
> 0000000000000000
> [681000.970560] RDX: 0000000000000004 RSI: 0000000000000000 RDI:
> ffff9a0ef15c0780
> [681000.970561] RBP: ffffa9d680433e18 R08: 0000000000000218 R09:
> 00000000001bfc3a
> [681000.970562] R10: 00000000000dfe1d R11: ffff9a0ef1b7cae0 R12:
> ffff9a0ef15c0780
> [681000.970563] R13: ffffa9d680433e80 R14: ffffa9d680433ea8 R15:
> 0000000000000001
> [681000.970565] FS:  0000000000000000(0000) GS:ffff9a0ef7b80000(0000)
> knlGS:0000000000000000
> [681000.970566] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [681000.970566] CR2: 000000000000000e CR3: 00000000e7e0a001 CR4:
> 00000000003606e0
> [681000.970569] Call Trace:
> [681000.970585]  ? cifs_compound_callback+0x33/0x80 [cifs]
> [681000.970599]  cifs_compound_last_callback+0x12/0x20 [cifs]
> [681000.970611]  cifs_demultiplex_thread+0x6d4/0xc40 [cifs]
> [681000.970615]  kthread+0x104/0x140
> [681000.970627]  ? cifs_handle_standard+0x190/0x190 [cifs]
> [681000.970629]  ? kthread_park+0x80/0x80
> [681000.970631]  ret_from_fork+0x35/0x40
>
> Still haven't figured out why this is happening. Looking.
>
> --
> Best regards,
> Pavel Shilovsky



--=20
Thanks,

Steve
