Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41FD0C433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 00:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11EF7206B2
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 00:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391237AbhA0AfE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Jan 2021 19:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389836AbhA0AKH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Jan 2021 19:10:07 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D91C0698CA
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jan 2021 15:57:49 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id e7so87877ili.2
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jan 2021 15:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kA8HkogeUyPU6EiJMdYbIhKNQplNA/8tzMXXNR/35gI=;
        b=BK0IVakEQ05hz8+X76bs8/9Ae5VGGQ0v/2wvV7VT+bR8VQypKTe/OhboKJorWtfeN8
         eTmgVydX0a3HneUy9XIg4YYgh8ccfXM8x75+aYGieUyTSfc0VgukCodMz3YV45OsRuDU
         ESRPnN+qeVgbFIaiLUrcD+WMasm6iyPChvxVX+1w34hRxINNtvru+uz2AFKQ2dZx3TUU
         +LXEgFvPioMVPtKs3Y9VRLGQm6Fz+5S4UEfNYoBHan3SnKzYv6Cr7TEjOC4kRWNq4/fs
         wDDDbVLHb3+N9KydmuLc41BogV72GXCe84yb7g4iv9T6vOa+eFPPSYk6sr/zy4M8ysEx
         LQqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kA8HkogeUyPU6EiJMdYbIhKNQplNA/8tzMXXNR/35gI=;
        b=H6+zHH2tNAhWOCLJk4WzS68ROLy3/QhK3q/Z+4efFxpUx/vz/drKkZbm2vnjTScapT
         7E+KCWyvRTBRBFzKBmkCN18+9HHOKWGInDYxZzticd/cHCEokbYesh0f57egQVHnxHC/
         /QjKG56M45qmQUdS7EK4fmfTqGeeR84wkjCkIJXK5Fo8gA3RMz0xXdmjztxCZRmYgVw9
         28zOoKrrUyAIZBbwxrcU1GYoBfi18an62LBa7HzE8dCTrIWjN7LYW8R50ZLRDZuRp99T
         RXaoWlfY/Ds6Qp5dqMjL7jaWLuEbEWALW3XkyRQ9SvQO54azFsDZID+rcb8o2SUGG7aM
         nrqw==
X-Gm-Message-State: AOAM532zncecM2XTuDNIzKWj92pbBYY6ewJ6XwUlgURHXgWrSCCeLMNA
        I+O6ArsLzPSiceD1NTqA+XwVaNWX7Xq7wmx+Sx4=
X-Google-Smtp-Source: ABdhPJy1UPwmNoDkCqCEigk9B537dPg01+vgsL3XA1xO/XIKQwGL0fN0Exbspn2JVIGkzgzmvauPhD2o5OWPWuV/m90=
X-Received: by 2002:a92:3f12:: with SMTP id m18mr6725773ila.109.1611705469155;
 Tue, 26 Jan 2021 15:57:49 -0800 (PST)
MIME-Version: 1.0
References: <20210120043209.27786-1-lsahlber@redhat.com> <CAH2r5mvmCG2SN0nO8uZftTRMOkN8jgbfYrO1E5_A=5FpK9H0bQ@mail.gmail.com>
 <CAKywueRWJxk9KuuZe6Ovb7MhxXsbsE-_7WJG05hAPTZ2o5m7mg@mail.gmail.com>
 <87y2gmk3ap.fsf@suse.com> <877do6zdqp.fsf@cjr.nz> <CAN05THQjj04sQpcjvLqs+fmbdeu=jftM+GdeJnQMg33OEq6xEg@mail.gmail.com>
 <CAKywueSTX9hq5Vun3V6foQeLJ8Fngye0__U-gj73evKDwNLEKg@mail.gmail.com>
 <CAN05THQGBvLy6c+DK1eOuj2VKXTXONZkk8Je+iLM2DZFmHsPBA@mail.gmail.com>
 <CAH2r5mttuSULg0UvKuNRydtkNAP1QRZVXQuNaaHGFLRrvfSnfQ@mail.gmail.com>
 <CANT5p=o5pjCLUzLv2=i+T+7XE=0Wxcg3p_TSbAeARAWNzmmgEw@mail.gmail.com>
 <CANT5p=qrRVaN4yrqHz5fS2fC6_K1XqAiR4Bv9rTX6oxgg3j8gg@mail.gmail.com> <CAKywueTPG-Qc2J5QOugTD4Agt1A_p8ek4wpBVqn-qtLooLH+Pw@mail.gmail.com>
In-Reply-To: <CAKywueTPG-Qc2J5QOugTD4Agt1A_p8ek4wpBVqn-qtLooLH+Pw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 27 Jan 2021 09:57:37 +1000
Message-ID: <CAN05THSb_ooX9TiJC7Y5HT1WrpUnm0chGqYaRyoXPJUmbayf0w@mail.gmail.com>
Subject: Re: [PATCH] cifs: do not fail __smb_send_rqst if non-fatal signals
 are pending
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jan 27, 2021 at 9:34 AM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D0=BF=D0=BD, 25 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 09:07, Shyam Pra=
sad N <nspmangalore@gmail.com>:
> >
> > From my readings so far, -ERESTARTSYS assumes that the syscall is idemp=
otent.
> > Can we safely make such assumptions for all VFS file operations? For
> > example, what happens if a close gets restarted, and we already
> > scheduled a delayed close because the original close failed with
> > ERESTARTSYS?
>
> I don't think we can assume all system calls to be idempotent. We
> should probably examine them one-by-one and return -ERESTARTSYS for
> some and -EINTR for the others.
>
> >
> > Also, I ran a quick grep for EINTR, and it looks like __cifs_readv and
> > __cifs_writev return EINTR too. Should those be replaced by
> > ERESTARTSYS too?
> >
>
> They return -EINTR after receiving a kill signal (see
> wait_for_completion_killable around those lines). It doesn't seem
> there is any point in returning -ERESTARTSYS after a kill signal
> anyway, so, I think the code is correct there.

We have to be careful with -ERESTARTSYS especially in the context of
doing it when signals are pending.
I was just thinking about how signals are cleared and how this might
matter for -EINTR versus -ERESTARTSYS

As far as I know signals will only become "un"-pending once we hit the
signal handler down in userspace.
So, if we do -ERESTARTSYS because signals are pending, then the kernel
just retries without bouncing down into userspace first
and thus we never hit the signal handler so when we get back to the
if (signal_penging) return -ERESTARTSYS
the signal will still be pending and we risk looping?


>
> --
> Best regards,
> Pavel Shilovsky
