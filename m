Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E721CC433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jan 2021 18:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1EB6205CA
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jan 2021 18:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbhAMSg3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Jan 2021 13:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728356AbhAMSg3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Jan 2021 13:36:29 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79009C061575
        for <linux-cifs@vger.kernel.org>; Wed, 13 Jan 2021 10:35:48 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id jx16so4477427ejb.10
        for <linux-cifs@vger.kernel.org>; Wed, 13 Jan 2021 10:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gEkwJcHyR3ZXyJRE3E33422bzejHLFH9jF0iThOVE/0=;
        b=ZaoBjAcqy0m3+9+KUCXVCAdsv9FLzovjqAUSWTW6nhnghRPoC6UVYJdSzzGFSics+C
         mmW6bmP9siuaqGhQq14lvIX+DSGPXOBR1tam5N1h9/fvrdvYo2Hf2q67XeFzzF3Qi8Gu
         OP1KPkQsm2ZcVJIlG+3aYAke3tkYSienVXKSGmMWUQMYRXqfiRHkSptMqE/VSiRtoe2v
         BmPxzHa2fzVQqG3ngMTDYQKgReUr31oaU/EaF8W7XLzwi7akrK0betbmpvsZUQL8E8w7
         5/0/cevAs3YzpXAuNjcRt1bO9Atgblo/s0pszfVKuQgub6XKmLDiDzNNvkwDn8gFz1BU
         wo+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gEkwJcHyR3ZXyJRE3E33422bzejHLFH9jF0iThOVE/0=;
        b=fmirGgCrsEtj+mzPsNB7dztwZnWWUcV9inZzc2pY/FU2pWA6Gm94qMh/SeVIWXGVKW
         Xw7DPUxGJGJWqkKBH6GX07xJZ1RxrdN20toQGXNHZ10xjsiYbau3qhOKvFlmwy2yOzme
         yf0xdHzLQRrXERSAIg8leUoJATkt3Spy4BH+iGSY2mjDvsLFsu0a0r5OXOzEqw7Weia9
         MykqDk4UDUFAgaull8f+swT6FqTqGiWNx55Hc8eFof+tuMVZBo2KwYSYp4Ij78IvAxo2
         DmA0+uogDfvhqY3LAmO57RslqvmmnC6HmfcIu4pkn4QFlCqaPI7mH3dd1dGRmPnhGjnM
         fL9g==
X-Gm-Message-State: AOAM530YCqvQYo/SNFBnEmvLeTXZ5GSvuDYLh4V+fOya5zIpp3KUMwlx
        gEfUOOAl76uDssLmbq4kA8x7c2levAiz2b/pTw==
X-Google-Smtp-Source: ABdhPJwihl5EHtlVVC0cA1paY2e+6phk3zE9+Lnu39lbvLLw7HX1GqzlaghTP6luInp0wrMxLcUZpfx9SAlfS0doRNY=
X-Received: by 2002:a17:906:971a:: with SMTP id k26mr2634099ejx.515.1610562947234;
 Wed, 13 Jan 2021 10:35:47 -0800 (PST)
MIME-Version: 1.0
References: <CAE-Mgq2kwwZJicbU9oenD4M5SQhbErhXovGX+LKtcnRbLC4xSg@mail.gmail.com>
 <87ft35kojo.fsf@suse.com> <CAKywueQ9jmyTaKqR2x0nL-Q8A=-V1fP_1L2n=b+OdUzVhV083Q@mail.gmail.com>
 <87h7nk6art.fsf@cjr.nz> <CAH2r5msvYs4nLbje4vP+XNF_7SR=b5QehQ=t1WT4o=Ki6imPxg@mail.gmail.com>
In-Reply-To: <CAH2r5msvYs4nLbje4vP+XNF_7SR=b5QehQ=t1WT4o=Ki6imPxg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 13 Jan 2021 10:35:35 -0800
Message-ID: <CAKywueT0U3+t3RdC452ZiqVpg1n1KFi_HK=83yGmS__2gALpJg@mail.gmail.com>
Subject: Re: [bug report] Inconsistent state with CIFS mount after interrupted
 process in Linux 5.10
To:     Steve French <smfrench@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Duncan Findlay <duncf@duncf.ca>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 13 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 09:03, Steve Frenc=
h <smfrench@gmail.com>:
>
> On Wed, Jan 13, 2021 at 10:51 AM Paulo Alcantara <pc@cjr.nz> wrote:
> >
> > Pavel Shilovsky <piastryyy@gmail.com> writes:
> >
> > > Thanks for reporting the issue.
> > >
> > > The problem is with the recent fix which changes the error code from
> > > -EINTR to -ERESTARTSYS:
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/fs/cifs/transport.c?id=3D6988a619f5b79e4efadea6e19dcfe75fbcd350b5
> > >
> > > and this problem happens here:
> > >
> > > https://git.samba.org/sfrench/?p=3Dsfrench/cifs-2.6.git;a=3Dblob;f=3D=
fs/cifs/smb2pdu.c;h=3D067eb44c7baa863c1e7ccd2c2f599be0b067f320;hb=3D236237a=
b6de1cde004b0ab3e348fc530334270d5#l3251
> > >
> > > So, interrupted close commands don't get restarted by the client and
> > > the client leaks open handles on the server. The offending patch was
> > > tagged stable, so the fix seems quite urgent. The fix itself should b=
e
> > > simple: replace -EINTR with -ERESTARTSYS in the IF condition or even
> > > amend it with "||".
> >
> > Yes, makes sense.
> >
> > Maybe we should do something like below
> >
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > index 067eb44c7baa..794fc3b68b4f 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -3248,7 +3248,7 @@ __SMB2_close(const unsigned int xid, struct cifs_=
tcon *tcon,
> >         free_rsp_buf(resp_buftype, rsp);
> >
> >         /* retry close in a worker thread if this one is interrupted */
> > -       if (rc =3D=3D -EINTR) {
> > +       if (is_interrupt_error(rc)) {
> >                 int tmp_rc;
> >
> >                 tmp_rc =3D smb2_handle_cancelled_close(tcon, persistent=
_fid,
>
> Seems reasonable, the other two conditions (ERESTARTRNOHAND e.g.) are
> not explicitly set by cifs.ko but may come back from other libraries
> so could be worth checking for, and it seems a little safer to use
> is_interrupt_error.
>
> Paulo,
> If you can do a patch quickly I will run the buildbot on it and the
> other two patches currently in for-next and try to send in the next
> couple days.
>
> (I do have a fourth patch, not currently in for-next, that I am
> debugging ... the '\' handling patch ... which I can send if we can
> figure out what is missing in it).  I may also include the two trivial
> one line style patches recently submitted to list.
>
> --
> Thanks,
>
> Steve

Paulo,
Yes, is_interrupt_error() is cleaner here to eliminate other potential
issues. Thanks!

Steve,
Agree - we should send this ASAP with other non-controversial patches.

--
Best regards,
Pavel Shilovsky
