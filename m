Return-Path: <SRS0=c5gJ=RL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5031C43381
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Mar 2019 02:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74E5E2081B
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Mar 2019 02:39:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ldiJ3Is2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfCHCjx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Mar 2019 21:39:53 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33968 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfCHCjw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Mar 2019 21:39:52 -0500
Received: by mail-qk1-f196.google.com with SMTP id a15so10397626qkc.1
        for <linux-cifs@vger.kernel.org>; Thu, 07 Mar 2019 18:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zK2pOlYQ/r3uT6j6SLCPrADqWMXDq3rxZdgCuQ6dJQE=;
        b=ldiJ3Is2H2iqPIZVdldRJnNSwxCF1HCubyH5KpP97SM00Wn291I2yYFLiBd0WT/rK8
         cCHmwSVAUHLfl3nciJmPBBjwad/vuu589tGTLmBKNJEUFVrOMUznoAJftHE6elEdogRZ
         sO537cfZV11Lz+k8FsTt/81dh/jtTy/ekr84v4PQHMfwLcgaLQkaLi520FhnKYZBo+GH
         Tkzb/tA6K8rShj8TjUzN/zRp59e+BdKVVgl97ODVILxCMrHoRL7CeiijsE83FfIt6xg6
         a9CgtA3nm1SuCfxUZID0E+3kN7dN5uNwc/yibdULyovHl9hrs5pjr0qbL6BSDvZz0Hzv
         upcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zK2pOlYQ/r3uT6j6SLCPrADqWMXDq3rxZdgCuQ6dJQE=;
        b=J3q9P7z46t9x76KLXG/TUg8PAtF/21LIwgivIXvWDMurfMqmnRiCp+jsamzZ6/pXy7
         rpg2WSLHjhG6jqhk0/CH39DgFJ3jg7J3bpslzt1RFoJfmxxVorl5BxyiT8ANutdQpyXj
         cOv6HFIbq+iIMLuhazw2HB89zA1bJgl3XUEE5DJueFH5jY/AiUOumT02+J/Saw+IFZKj
         1hOu2k/j4QZsRsL7qz0CUp50vLoOwNOVbgKIJF4VKyN6FFzWOP9CdRzMZXeLuPwhxy4R
         l39II5LTywmFsUvGQlK0RnsYWbVkj4FaJLY17Z7pVgBw4xX7DSQCo2jOsa7rNUmE1ogd
         DrvQ==
X-Gm-Message-State: APjAAAUNWzP5cXOyN+8BBC20pQOkGUlgpJp2eUaNnKT8W1XRkAgi26Iw
        MfAR0cGCdvi1hmILmMYMqPhGnbdJM+Q7O7UziRE=
X-Google-Smtp-Source: APXvYqza+JmkpxcI1UPRHoMoEooalA505aDhpnRyH81mC/8AYDqsaQUiXIVHNKhamFX/yW/Y5gyFdQvwjsX5MwKpjfg=
X-Received: by 2002:a05:620a:1348:: with SMTP id c8mr12602478qkl.246.1552012791266;
 Thu, 07 Mar 2019 18:39:51 -0800 (PST)
MIME-Version: 1.0
References: <20190306041546.10419-1-lsahlber@redhat.com> <20190306041546.10419-6-lsahlber@redhat.com>
 <CAKywueRFjXs160fV2m-jsNPtLnBvqaHWJmJZ+SN5+yhjbtVmtA@mail.gmail.com>
In-Reply-To: <CAKywueRFjXs160fV2m-jsNPtLnBvqaHWJmJZ+SN5+yhjbtVmtA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 8 Mar 2019 12:39:40 +1000
Message-ID: <CAN05THR89uDK36mLCBwWAsm2piK2q3kkBJL_vDnnKdp+kXWEuQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] cifs: add a timeout argument to wait_for_free_credits
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Mar 7, 2019 at 4:33 AM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> =D0=B2=D1=82, 5 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 21:45, Ronnie Sah=
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
> > index f4ec9635dab2..3263e8b3a57d 100644
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
> > +                               return -EAGAIN;
>
> It would be hard to distinguish different EAGAIN reasons in the upper
> layers. As of now we use EAGAIN as retryable error indicating the
> upper layer to retry. This case is different because the retry most
> likely won't help and the sequential fallback is needed. In
> compound_send_recv() we return -ENOTSUPP if there is not enough
> credits to satisfy compounding and the number of requests in flight
> doesn't promise to get new credits in future.
>
> I suggest to return the same error code here (-ENOTSUPP). Probably
> this particular error code isn't ideal choice and suggestions to
> change it are welcome.

I will do that change.  ENOTSUPP might not be ideal but should be fine for =
now.
If/when we need to take special action and start serializing these
requests we can
pick a better errno.


>
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
> > +                                       return -EAGAIN;
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
> --
> Best regards,
> Pavel Shilovsky
