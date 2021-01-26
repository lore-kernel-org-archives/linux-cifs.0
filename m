Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 687DCC10F12
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 00:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F354206A1
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 00:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390067AbhA0Ae5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Jan 2021 19:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389564AbhA0AF4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Jan 2021 19:05:56 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87101C061A32
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jan 2021 15:34:26 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id gx5so89898ejb.7
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jan 2021 15:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xV6WfnooMqc7Ryn1POcl+trXoAz4X4aXFx+pIsfuDsc=;
        b=G8XFNqQA8zErOsNtFJAPRxG8czzpm4M2MnK+Qi4Vq4Fygb0ZsaZ8bimTdIBHYP1DUs
         tQK2Iz22qDcx6RC29UVnADMlcYG0hZHsrbBw6JuhMXd/2KpKbFstJz8Q3t+Cj5hI0ity
         FiB5J0mzZrT574xX6u/pLA/71CwiuWxwozsbXR6igYWj5thHgm30nTq559C64++RrFKr
         tDzIdJcT72YGnK6eQREFlJ7nB7iQhv2i277YT9rRRsDD2Mo/U4OwptyG51pBhSj9w88V
         GXf2G+b1BMwYUSXjdFXJRqDp6vakM+eRf/tpnirzjjMMbAcA3uNSu/wEjY/kgD+F+oh5
         1kGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xV6WfnooMqc7Ryn1POcl+trXoAz4X4aXFx+pIsfuDsc=;
        b=VI8IuB8dunbu96PIl5oOKjr/YklA6Hhoq+NXcSjLjH54+4W3U/D74tcJG+W1s91x3h
         7NlYi7aaxxpF2AQWuooNlgonYauw00YXYs/8OXkIcx5NSUFE0tlRpiN6R1sTKsxjWuJT
         6ECYoc34OXRxXZNjIejvbBDwlT8QTWnL/NPyj4o3GEec72QgpFBf0VZDFCcjv63m4Al7
         6YX2+vwUVt3Sq/Orl4V3POZftBQONq7X0rh9zThpXxa5oTFaDHSFZA65y1dF+fgT7OWX
         MbC6ugybYzCv03o4fl+6N1NO2hcFq+/yHfUPCXB4rPiUrzq69cGshLhhN/90IiRqtxUR
         rOVA==
X-Gm-Message-State: AOAM5319VTvWXKGIq7QxwPAtTAUd1X5jiyuFbP6lXds/soKAEn3lVsYc
        2KyX68FN48W3s1dmgGp+wY3UjxYeNY/AodSj1w==
X-Google-Smtp-Source: ABdhPJymOpEKy3ipD1fNJfuIwIz3x4ggWsTUFLBkX/RNK9TTNG+NI+VyDuEXNEU1Jeb81tmxvSG3lqDzkYf63OdEwxo=
X-Received: by 2002:a17:907:9483:: with SMTP id dm3mr4849610ejc.120.1611704065334;
 Tue, 26 Jan 2021 15:34:25 -0800 (PST)
MIME-Version: 1.0
References: <20210120043209.27786-1-lsahlber@redhat.com> <CAH2r5mvmCG2SN0nO8uZftTRMOkN8jgbfYrO1E5_A=5FpK9H0bQ@mail.gmail.com>
 <CAKywueRWJxk9KuuZe6Ovb7MhxXsbsE-_7WJG05hAPTZ2o5m7mg@mail.gmail.com>
 <87y2gmk3ap.fsf@suse.com> <877do6zdqp.fsf@cjr.nz> <CAN05THQjj04sQpcjvLqs+fmbdeu=jftM+GdeJnQMg33OEq6xEg@mail.gmail.com>
 <CAKywueSTX9hq5Vun3V6foQeLJ8Fngye0__U-gj73evKDwNLEKg@mail.gmail.com>
 <CAN05THQGBvLy6c+DK1eOuj2VKXTXONZkk8Je+iLM2DZFmHsPBA@mail.gmail.com>
 <CAH2r5mttuSULg0UvKuNRydtkNAP1QRZVXQuNaaHGFLRrvfSnfQ@mail.gmail.com>
 <CANT5p=o5pjCLUzLv2=i+T+7XE=0Wxcg3p_TSbAeARAWNzmmgEw@mail.gmail.com> <CANT5p=qrRVaN4yrqHz5fS2fC6_K1XqAiR4Bv9rTX6oxgg3j8gg@mail.gmail.com>
In-Reply-To: <CANT5p=qrRVaN4yrqHz5fS2fC6_K1XqAiR4Bv9rTX6oxgg3j8gg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 26 Jan 2021 15:34:14 -0800
Message-ID: <CAKywueTPG-Qc2J5QOugTD4Agt1A_p8ek4wpBVqn-qtLooLH+Pw@mail.gmail.com>
Subject: Re: [PATCH] cifs: do not fail __smb_send_rqst if non-fatal signals
 are pending
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 25 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 09:07, Shyam Prasa=
d N <nspmangalore@gmail.com>:
>
> From my readings so far, -ERESTARTSYS assumes that the syscall is idempot=
ent.
> Can we safely make such assumptions for all VFS file operations? For
> example, what happens if a close gets restarted, and we already
> scheduled a delayed close because the original close failed with
> ERESTARTSYS?

I don't think we can assume all system calls to be idempotent. We
should probably examine them one-by-one and return -ERESTARTSYS for
some and -EINTR for the others.

>
> Also, I ran a quick grep for EINTR, and it looks like __cifs_readv and
> __cifs_writev return EINTR too. Should those be replaced by
> ERESTARTSYS too?
>

They return -EINTR after receiving a kill signal (see
wait_for_completion_killable around those lines). It doesn't seem
there is any point in returning -ERESTARTSYS after a kill signal
anyway, so, I think the code is correct there.

--
Best regards,
Pavel Shilovsky
