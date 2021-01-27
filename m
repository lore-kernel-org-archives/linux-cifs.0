Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA07C433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 19:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 358B260C40
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 19:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhA0Tx0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Jan 2021 14:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbhA0Tw1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Jan 2021 14:52:27 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958AEC061573
        for <linux-cifs@vger.kernel.org>; Wed, 27 Jan 2021 11:51:45 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id s11so3933614edd.5
        for <linux-cifs@vger.kernel.org>; Wed, 27 Jan 2021 11:51:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oq81aT7iX2vPujhapLNSlLyAeQG7pWc9brlrjAlT8Uw=;
        b=RiawcGEWFXvqAyYMTfqGb5oZ5HcipN0usjMgKxKcjBJffa64LnTg0DnJT8yaeGlgRF
         vgWe6XuH7KHvAbRDFRgzsXzBPfpaDnIHUmuGy6MOx3hYCZk1Nz34prIUi4/AspNiaS0A
         nLbt9s4+gKgJKVuiXKSr1OxXR+JPoFSGrzJOmlHjwCfvqyGFEGU3KiLgolujHXz8ekCO
         or2vjvcq/KE9ZQSXxoc7F+7sjsP59rnuEAApK1AQD4LH/UAfCd5OBZqG/CJV3DykODeQ
         3FgvJBZ0Yp/nwQFD5RCCXdsgdOpZhGYav2QQ6NLCtErzr50FPEvyZLsIchlTwWv91VjO
         F85w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oq81aT7iX2vPujhapLNSlLyAeQG7pWc9brlrjAlT8Uw=;
        b=K0HuYsDSb6gsZBwpeI1SMaaQps2uNU2Xbf9tgRJ3jFPu9IiivCUMtW5sasJ4whdWej
         vk/P3Z31xiWDCGexOy5djM/dy+979qNPHHfzyTlv9cQfyKPsgqFx2CJsU5MF9H4BgLal
         qJVmVMxFqofnAn0gZGibFkNg8fJfReaEF0EuiE2sKz9XQIjXt78TnDyT5r0rB35bZsrP
         WEloWcMDCDCq06KhKd2VjOaDHg0ssRdsdkYcYHFZPZxOVJHJUhyZVApMqVyXXje2R41W
         yxIOx1supJqbj6Qq6NOyjTh8rtLL4/kx965h5Dtn2m5qQW44bGiguGdOSNpUmRJwWnGs
         Gizw==
X-Gm-Message-State: AOAM532MrwMihMZsmtS8xC+cZhGT5ogDdtjzrPBYigYnJ5C6w752Uw7H
        n+X3K8bUl1zpT2SVxSGTIK3K3yf5fAUksxfd+A==
X-Google-Smtp-Source: ABdhPJzYUXN4fLEKfx7+I4aob5ngNPx3oyxz1+9zVfq2166KkDi+Cc+BvnDphpgCodgQs4kcLx8Ee3qzGqgJIPG/+rw=
X-Received: by 2002:a05:6402:5112:: with SMTP id m18mr10698906edd.129.1611777104357;
 Wed, 27 Jan 2021 11:51:44 -0800 (PST)
MIME-Version: 1.0
References: <20210120043209.27786-1-lsahlber@redhat.com> <CAH2r5mvmCG2SN0nO8uZftTRMOkN8jgbfYrO1E5_A=5FpK9H0bQ@mail.gmail.com>
 <CAKywueRWJxk9KuuZe6Ovb7MhxXsbsE-_7WJG05hAPTZ2o5m7mg@mail.gmail.com>
 <87y2gmk3ap.fsf@suse.com> <877do6zdqp.fsf@cjr.nz> <CAN05THQjj04sQpcjvLqs+fmbdeu=jftM+GdeJnQMg33OEq6xEg@mail.gmail.com>
 <CAKywueSTX9hq5Vun3V6foQeLJ8Fngye0__U-gj73evKDwNLEKg@mail.gmail.com>
 <CAN05THQGBvLy6c+DK1eOuj2VKXTXONZkk8Je+iLM2DZFmHsPBA@mail.gmail.com>
 <CAH2r5mttuSULg0UvKuNRydtkNAP1QRZVXQuNaaHGFLRrvfSnfQ@mail.gmail.com>
 <CANT5p=o5pjCLUzLv2=i+T+7XE=0Wxcg3p_TSbAeARAWNzmmgEw@mail.gmail.com>
 <CANT5p=qrRVaN4yrqHz5fS2fC6_K1XqAiR4Bv9rTX6oxgg3j8gg@mail.gmail.com>
 <CAKywueTPG-Qc2J5QOugTD4Agt1A_p8ek4wpBVqn-qtLooLH+Pw@mail.gmail.com> <CAN05THSb_ooX9TiJC7Y5HT1WrpUnm0chGqYaRyoXPJUmbayf0w@mail.gmail.com>
In-Reply-To: <CAN05THSb_ooX9TiJC7Y5HT1WrpUnm0chGqYaRyoXPJUmbayf0w@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 27 Jan 2021 11:51:33 -0800
Message-ID: <CAKywueRfU4a8ohvU-PhLz7RCXrLzGrsWfpjs4RSdBO+Ra_gobQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: do not fail __smb_send_rqst if non-fatal signals
 are pending
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
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

=D0=B2=D1=82, 26 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 15:57, ronnie sahl=
berg <ronniesahlberg@gmail.com>:
>
> On Wed, Jan 27, 2021 at 9:34 AM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > =D0=BF=D0=BD, 25 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 09:07, Shyam P=
rasad N <nspmangalore@gmail.com>:
> > >
> > > From my readings so far, -ERESTARTSYS assumes that the syscall is ide=
mpotent.
> > > Can we safely make such assumptions for all VFS file operations? For
> > > example, what happens if a close gets restarted, and we already
> > > scheduled a delayed close because the original close failed with
> > > ERESTARTSYS?
> >
> > I don't think we can assume all system calls to be idempotent. We
> > should probably examine them one-by-one and return -ERESTARTSYS for
> > some and -EINTR for the others.
> >
> > >
> > > Also, I ran a quick grep for EINTR, and it looks like __cifs_readv an=
d
> > > __cifs_writev return EINTR too. Should those be replaced by
> > > ERESTARTSYS too?
> > >
> >
> > They return -EINTR after receiving a kill signal (see
> > wait_for_completion_killable around those lines). It doesn't seem
> > there is any point in returning -ERESTARTSYS after a kill signal
> > anyway, so, I think the code is correct there.
>
> We have to be careful with -ERESTARTSYS especially in the context of
> doing it when signals are pending.
> I was just thinking about how signals are cleared and how this might
> matter for -EINTR versus -ERESTARTSYS
>
> As far as I know signals will only become "un"-pending once we hit the
> signal handler down in userspace.
> So, if we do -ERESTARTSYS because signals are pending, then the kernel
> just retries without bouncing down into userspace first
> and thus we never hit the signal handler so when we get back to the
> if (signal_penging) return -ERESTARTSYS
> the signal will still be pending and we risk looping?

Signals are handled before restarting a system call. See details here:

https://lwn.net/Articles/528935/

So, if signal_pending is true again in a restarted system call then
this is another signal that needs to be handled.

--
Best regards,
Pavel Shilovsky
