Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5E5C433E6
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Jan 2021 19:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8D8A238EB
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Jan 2021 19:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbhATRfo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Jan 2021 12:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389952AbhATRbs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Jan 2021 12:31:48 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5782FC061575
        for <linux-cifs@vger.kernel.org>; Wed, 20 Jan 2021 09:31:07 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id b2so26707041edm.3
        for <linux-cifs@vger.kernel.org>; Wed, 20 Jan 2021 09:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zg4raflhD/45J7XaO5ytOC6TtbZZyRh+LJ2ibRSHN/8=;
        b=kYPp6MmJhU9Us0DDFe/hx+qh/hjij/ovAi3hP8hkRacdfWHMVDsYCq9o1Xu8JrFgjT
         jXd9dc8pBbPsAjuFAr+vP3PA6M8NqzTRI48R9nus4+wP9sotHnedpWnKEMfFZyCD6dz8
         MQ+2v2tXPe6WZeIozsaIfwrcTBe/NF/Tgrvbo2gRGx9KM6W7rWVJ7twWqXQxGAzCzOZp
         hFZzj1hRvsovyjbigM2twdAgEbS1zyOPx6eTdIYaIyVflZ9wyajQ6WsOBJS6H2UHYLUo
         lSElW0FiBapUE74BorIdlk4dGZOUNleiLDvYlQAPesbx9AAxTzcsmLCDnJvs2ShUl129
         ocjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zg4raflhD/45J7XaO5ytOC6TtbZZyRh+LJ2ibRSHN/8=;
        b=VNk20l7UIwagT2YguLehq2mLzqvYGXWxcVOJypFnp9Ec5Vq4PkyEEOSNhx6dIncFa5
         IQ79rpDNBh2RzMJurP1EnZC6TctHrjQWbGhGIz0/fr+s9F++IJoG97u9r8Rb6+WN0I+7
         9+Z2bxpBuPU7uhMpwX7PBZg3Id7vuB8soMNAQECzXzNsy8tN4wQQrrmtNdbwayDLvBCH
         r29JajYBhJAF2atXJd7BWFwMAZOe3cfDDAsD0UzphiASkH2HTOy8MNlXdXzcrzcJlJAe
         FaLE2wNRBPeAyA4YIApaOzenDI90i3tcn0nlyb1Nqy5Peq9feJCyXrRk5OPJWP7VxXhb
         CQ/g==
X-Gm-Message-State: AOAM531jTpEg15/XQBtsGtEVcxCW1RXvIxZ4FL1boibxGqaRt7vB/O3v
        ID2S54OkjtEoWj27eICpq9cw9hcA6+3uJzqatg==
X-Google-Smtp-Source: ABdhPJy+6YsVjMy7QizbXRa0LDqf/37QDcMlXNl4/oMTPvuc4c910dA3Xrm5ZHI7s+k5Zd+w/ZimJY3+QGc04NwSkm4=
X-Received: by 2002:a50:fc8c:: with SMTP id f12mr8138337edq.225.1611163865970;
 Wed, 20 Jan 2021 09:31:05 -0800 (PST)
MIME-Version: 1.0
References: <20210120043209.27786-1-lsahlber@redhat.com> <CAH2r5mvmCG2SN0nO8uZftTRMOkN8jgbfYrO1E5_A=5FpK9H0bQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvmCG2SN0nO8uZftTRMOkN8jgbfYrO1E5_A=5FpK9H0bQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 20 Jan 2021 09:30:54 -0800
Message-ID: <CAKywueRWJxk9KuuZe6Ovb7MhxXsbsE-_7WJG05hAPTZ2o5m7mg@mail.gmail.com>
Subject: Re: [PATCH] cifs: do not fail __smb_send_rqst if non-fatal signals
 are pending
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 19 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 22:38, Steve Frenc=
h <smfrench@gmail.com>:
>
> The patch won't merge (also has some text corruptions in it).  This
> line of code is different due to commit 6988a619f5b79
>
> 6988a619f5b79 (Paulo Alcantara 2020-11-28 15:57:06 -0300 342)
>  cifs_dbg(FYI, "signal pending before send request\n");
> 6988a619f5b79 (Paulo Alcantara 2020-11-28 15:57:06 -0300 343)
>  return -ERESTARTSYS;
>
>         if (signal_pending(current)) {
>                 cifs_dbg(FYI, "signal pending before send request\n");
>                 return -ERESTARTSYS;
>         }
>
> See:
>
> Author: Paulo Alcantara <pc@cjr.nz>
> Date:   Sat Nov 28 15:57:06 2020 -0300
>
>     cifs: allow syscalls to be restarted in __smb_send_rqst()
>
>     A customer has reported that several files in their multi-threaded ap=
p
>     were left with size of 0 because most of the read(2) calls returned
>     -EINTR and they assumed no bytes were read.  Obviously, they could
>     have fixed it by simply retrying on -EINTR.
>
>     We noticed that most of the -EINTR on read(2) were due to real-time
>     signals sent by glibc to process wide credential changes (SIGRT_1),
>     and its signal handler had been established with SA_RESTART, in which
>     case those calls could have been automatically restarted by the
>     kernel.
>
>     Let the kernel decide to whether or not restart the syscalls when
>     there is a signal pending in __smb_send_rqst() by returning
>     -ERESTARTSYS.  If it can't, it will return -EINTR anyway.
>
>     Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>     CC: Stable <stable@vger.kernel.org>
>     Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
>     Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>
> On Tue, Jan 19, 2021 at 10:32 PM Ronnie Sahlberg <lsahlber@redhat.com> wr=
ote:
> >
> > RHBZ 1848178
> >
> > There is no need to fail this function if non-fatal signals are
> > pending when we enter it.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/transport.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index c42bda5a5008..98752f7d2cd2 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -339,7 +339,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int=
 num_rqst,
> >         if (ssocket =3D=3D NULL)
> >                 return -EAGAIN;
> >
> > -       if (signal_pending(current)) {
> > +       if (fatal_signal_pending(current)) {
> >                 cifs_dbg(FYI, "signal is pending before sending any dat=
a\n");
> >                 return -EINTR;
> >         }

I have been thinking around the same lines. The original intent of
failing the function here was to avoid interrupting packet send in the
middle of the packet and not breaking an SMB connection.
That's also why signals are blocked around smb_send_kvec() calls. I
guess most of the time a socket buffer is not full, so, those
functions immediately return success without waiting internally and
checking for pending signals. With this change the code may break SMB
packets and cause reconnections if a non-fatal signal is pending
before we block signals but this is still better than failing the
function in the very beginning.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

I think this patch should go to stable too. Steve, Ronnie, thoughts?

--
Best regards,
Pavel Shilovsky
