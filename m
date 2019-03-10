Return-Path: <SRS0=aWno=RN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12947C43381
	for <linux-cifs@archiver.kernel.org>; Sun, 10 Mar 2019 02:22:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C143920657
	for <linux-cifs@archiver.kernel.org>; Sun, 10 Mar 2019 02:22:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AEO57n1c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfCJCWD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 9 Mar 2019 21:22:03 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46265 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbfCJCWD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 9 Mar 2019 21:22:03 -0500
Received: by mail-pf1-f196.google.com with SMTP id g6so1028096pfh.13
        for <linux-cifs@vger.kernel.org>; Sat, 09 Mar 2019 18:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aNNNsDHWAoWHqTG+YPE01fddfIrVVaCY+I1vio+RrVY=;
        b=AEO57n1cYzaNTPMWvdzLzPwwExLTh7zESTXNwksCA3vGb2W6LQ0Br9N1eXas1jU6y6
         UL1iiRgpqWrYCVTJBU7VJmXN3k4POYbS3bW2anOiiTVPdCfuHYfre/UJOlGK2A0nJOPD
         vEmgdzdzjoYt5Oq4hfa71SEPsX92zI/4/fDrdZoxy0n9GNhns/XNEvLkgDVWrjr24+NK
         npiRqO0ceY++ehyxzW34IObxiCK5n5zSfWfXC7LXTxNKmqX5GCnUm6FCYWwTng3VW/n9
         Kq6u9ZPxCYYOuq5jsg9PTPPvuRHsrkcAJb2ias+L7AH4c5R04YONptMHf88wqFjx/HcG
         Um9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aNNNsDHWAoWHqTG+YPE01fddfIrVVaCY+I1vio+RrVY=;
        b=Iac/HMQ5/CQTAxD5TJN8fd/DTnWn/7qHV3TEkBhIsbwTJuxHv+E2IyFIl9gt1S+SZ2
         JdiT0xeX4B5x3TRVubSycw7XdLR5n8nLurDnCBcO19Qc2a20AHLERXGlBTdokiH1Fbo+
         J5MZLk1/zkYuxo/1TtdhKRexXr7ik4YlBmMCBfyMVdb+U8mohGWkfGOABoOyP4w9avRu
         ZaUnIoSFCowQdLZArFcMZBxsuj8RbUYmRxtiesyMya5oRbXVGdgBLzgYlB3j6q4VSDmN
         vCOjNF7MjL2SsD5BPitUY42bkC9zRzvxdEo6G5g0PBtruoQocoAV4ogUdzeUPYbizoWC
         NCqA==
X-Gm-Message-State: APjAAAWI67rTvzY0KSw5j0doUci/h1NYc88pK9UFSbCcb0vidsDAZAcN
        mu/jTn4Q6A5K83nY7AmCZoIIoA9rDhN0ddT4vXw=
X-Google-Smtp-Source: APXvYqxaJBV5OxgR7+YcVzsklCCVob2VyY410FtpUSMu+plSeho2Gf9LFTtvjcBt24t8jTftYy0dtpmM4k87G/bEi6A=
X-Received: by 2002:aa7:8d42:: with SMTP id s2mr26478280pfe.116.1552184521465;
 Sat, 09 Mar 2019 18:22:01 -0800 (PST)
MIME-Version: 1.0
References: <20190308025823.24382-1-lsahlber@redhat.com> <20190308025823.24382-6-lsahlber@redhat.com>
 <CAKywueRQwi1qxmtO3q9v_sCHB+tQxVY1uba9mi468-y9=18H_w@mail.gmail.com>
In-Reply-To: <CAKywueRQwi1qxmtO3q9v_sCHB+tQxVY1uba9mi468-y9=18H_w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 9 Mar 2019 20:21:48 -0600
Message-ID: <CAH2r5mtKwfg74HXmp0TDy0TV8nkhYhUrwPXKukvnor1AAdG0YA@mail.gmail.com>
Subject: Re: [PATCH 5/6] cifs: add a timeout argument to wait_for_free_credits
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

How about this to add the trace point you requested (I will send out a
patch for it on the list)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index b3d04018195c..8731cfa66026 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -527,6 +527,8 @@ wait_for_free_credits(struct TCP_Server_Info
*server, const int num_credits,
                                has_credits(server, credits, num_credits), =
t);
                        cifs_num_waiters_dec(server);
                        if (!rc) {
+                               trace_smb3_credit_timeout(server->CurrentMi=
d,
+                                       server->hostname, num_credits);
                                cifs_dbg(VFS, "wait timed out after %d ms\n=
",
                                         timeout);
                                return -ENOTSUPP;
@@ -565,6 +567,9 @@ wait_for_free_credits(struct TCP_Server_Info
*server, const int num_credits,
                                        t);
                                cifs_num_waiters_dec(server);
                                if (!rc) {
+                                       trace_smb3_credit_timeout(
+                                               server->CurrentMid,
+                                               server->hostname, num_credi=
ts);
                                        cifs_dbg(VFS, "wait timed out
after %d ms\n",
                                                 timeout);
                                        return -ENOTSUPP;

On Fri, Mar 8, 2019 at 6:58 PM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> =D1=87=D1=82, 7 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 19:35, Ronnie Sah=
lberg <lsahlber@redhat.com>:
> >
> > A negative timeout is the same as the current behaviour, i.e. no timeou=
t.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/transport.c | 40 ++++++++++++++++++++++++++++++----------
> >  1 file changed, 30 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index f4ec9635dab2..62c58ce80123 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -478,11 +478,18 @@ smb_send(struct TCP_Server_Info *server, struct s=
mb_hdr *smb_buffer,
> >
> >  static int
> >  wait_for_free_credits(struct TCP_Server_Info *server, const int num_cr=
edits,
> > -                     const int flags, unsigned int *instance)
> > +                     const int timeout, const int flags,
> > +                     unsigned int *instance)
> >  {
> >         int rc;
> >         int *credits;
> >         int optype;
> > +       long int t;
> > +
> > +       if (timeout < 0)
> > +               t =3D MAX_JIFFY_OFFSET;
> > +       else
> > +               t =3D msecs_to_jiffies(timeout);
> >
> >         optype =3D flags & CIFS_OP_MASK;
> >
> > @@ -507,11 +514,16 @@ wait_for_free_credits(struct TCP_Server_Info *ser=
ver, const int num_credits,
> >                 if (*credits < num_credits) {
> >                         spin_unlock(&server->req_lock);
> >                         cifs_num_waiters_inc(server);
> > -                       rc =3D wait_event_killable(server->request_q,
> > -                               has_credits(server, credits, num_credit=
s));
> > +                       rc =3D wait_event_killable_timeout(server->requ=
est_q,
> > +                               has_credits(server, credits, num_credit=
s), t);
> >                         cifs_num_waiters_dec(server);
> > -                       if (rc)
> > -                               return rc;
> > +                       if (!rc) {
> > +                               cifs_dbg(VFS, "wait timed out after %d =
ms\n",
> > +                                        timeout);
> > +                               return -ENOTSUPP;
> > +                       }
> > +                       if (rc =3D=3D -ERESTARTSYS)
> > +                               return -ERESTARTSYS;
> >                         spin_lock(&server->req_lock);
> >                 } else {
> >                         if (server->tcpStatus =3D=3D CifsExiting) {
> > @@ -537,12 +549,19 @@ wait_for_free_credits(struct TCP_Server_Info *ser=
ver, const int num_credits,
> >                             *credits <=3D MAX_COMPOUND) {
> >                                 spin_unlock(&server->req_lock);
> >                                 cifs_num_waiters_inc(server);
> > -                               rc =3D wait_event_killable(server->requ=
est_q,
> > +                               rc =3D wait_event_killable_timeout(
> > +                                       server->request_q,
> >                                         has_credits(server, credits,
> > -                                                   MAX_COMPOUND + 1));
> > +                                                   MAX_COMPOUND + 1),
> > +                                       t);
> >                                 cifs_num_waiters_dec(server);
> > -                               if (rc)
> > -                                       return rc;
> > +                               if (!rc) {
> > +                                       cifs_dbg(VFS, "wait timed out a=
fter %d ms\n",
> > +                                                timeout);
> > +                                       return -ENOTSUPP;
> > +                               }
> > +                               if (rc =3D=3D -ERESTARTSYS)
> > +                                       return -ERESTARTSYS;
> >                                 spin_lock(&server->req_lock);
> >                                 continue;
> >                         }
> > @@ -569,7 +588,8 @@ static int
> >  wait_for_free_request(struct TCP_Server_Info *server, const int flags,
> >                       unsigned int *instance)
> >  {
> > -       return wait_for_free_credits(server, 1, flags, instance);
> > +       return wait_for_free_credits(server, 1, -1, flags,
> > +                                    instance);
> >  }
> >
> >  int
> > --
> > 2.13.6
> >
>
> We may consider adding trace points for cases where we timed out.
>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>
> --
> Best regards,
> Pavel Shilovsky



--=20
Thanks,

Steve
