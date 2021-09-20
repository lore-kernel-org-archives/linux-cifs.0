Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC381C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 16:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ED3B60F70
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 16:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbhITQWk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 12:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbhITQWk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 12:22:40 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522E7C061574
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 09:21:13 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id x27so69976459lfu.5
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 09:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BhCI2cIhzJ8kct2CUgtFgQETNiilvR37UST17NS4nRo=;
        b=lOVSj4VD4vu74BAeKGoPV/lJwZbIT4XZXRfGniKrBFIO+2aS/fPK7R7OtPvNlnj99p
         H2vSLBNidvOEK1GwaN8gRZytIaZ25UXt4ubPHXjzvIzcrwvuk/df5d2fT5LVE9LboJJp
         wsMLwU8xRuaNK4WqDcTw2VNlcIdkvzfoXpzT9uhX23nG2H5vLJoIsCEXyVJkgdxDzdiz
         pF2WJpK6luV8kKdMB4zKu/rnaAIh2kkk/zkCFiX4EwyA5lVNgIN/Hp6vsos6UXhh1i+F
         1MERJ7ZJfd+NagnfN1VX8upR2KtYOVgWSm4ONx5+55zRjg10FVkgUPxas4f741p/AV4G
         SEQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BhCI2cIhzJ8kct2CUgtFgQETNiilvR37UST17NS4nRo=;
        b=on5nOKaAs+0A0iQRkEVM3DeurCrSk7CnptabuA+YwePMMHgt/gIA6OvkNWph4ltPMh
         CSOj6jn6EsRl+C50Iulbtw3s97aMNlzXPIW17VRpQsvp4+HhDHL7s3cj3PscCzx1MXsb
         WT5n7lQ30Lv2ZPTtOOdFtlCp4dGNSPOI5uuXuCXjjp7v3P6+iF84xCW8uhLefK8/0nvx
         2GyHY5ox5EwS2tgeEru/aIHYcmUY9bwOT725JYkxuPw4azZIWVn6Px8EaPYCFh33zaW6
         uoH56E5bWe79WrHT9uYajMtMHgzahSoHiFbhv9n/pWXMqza4L5XZUFJntlCP30j4Yg/4
         lwgA==
X-Gm-Message-State: AOAM532/y9/4VDC4228f6ZegIbJfca+GPrdQyp7E70CJ9pSF4NTJ/fQS
        zpcLX8vBJlwonFFgXBP1FkgHHIKALdGpuCZINTg=
X-Google-Smtp-Source: ABdhPJyeDlTRDrGJuPH0LkTqcNPxuAoyo2DAdJia7nm5grSXYVWSVECQF9aRb65Yi1EkHVYCUxa2F86ITTAr1aaAbCo=
X-Received: by 2002:ac2:44b6:: with SMTP id c22mr5724597lfm.601.1632154836160;
 Mon, 20 Sep 2021 09:20:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210919021315.642856-1-linkinjeon@kernel.org>
 <85871805-c9fb-6df9-be6d-ff57074426a3@samba.org> <27cdc659-cf4d-cc9e-e5c5-6a3d23987e72@samba.org>
 <CAH2r5mt8gxSS56kDvmtRTOi7Dm0fXwD6zL45WAP2hw2_TxDPow@mail.gmail.com> <97166b9e-b0e2-2cc2-5d53-c0f8687faf80@samba.org>
In-Reply-To: <97166b9e-b0e2-2cc2-5d53-c0f8687faf80@samba.org>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 20 Sep 2021 11:20:24 -0500
Message-ID: <CAH2r5mtHCpy9n6LXDU+V2uJAEQqh4J80gRzinxbpiVs7HTh81g@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] ksmbd: add request buffer validation in smb2_set_info
To:     Ralph Boehme <slow@samba.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Sep 20, 2021 at 11:11 AM Ralph Boehme <slow@samba.org> wrote:
>
> Am 20.09.21 um 17:10 schrieb Steve French:
> > On Mon, Sep 20, 2021 at 10:03 AM Ralph Boehme <slow@samba.org> wrote:
> >>
> >> Am 20.09.21 um 16:45 schrieb Ralph Boehme:
> >>> Am 19.09.21 um 04:13 schrieb Namjae Jeon:
> >>>> Use  LOOKUP_NO_SYMLINKS flags for default lookup to prohibit the
> >>>> middle of symlink component lookup.
> >>>
> >>> maybe this patch should be squashed with the "ksmbd: remove follow
> >>> symlinks support" patch?
> >>
> >> also, I noticed that the patches are already included in ksmbd-for-next.
> >> Did I miss Steve's ack on the ML?
> >>
> >> I wonder why the patches are already included in ksmbd-for-next without
> >> a proper review, I just started to look at the patches and wanted to
> >> raise several issues.
> >
> > I included them at Namjae's request in for-next to allow the automated
> > tests to run on them (e.g. the Intel test robot etc.) - those
> > automated bots can be useful ... but I had done some review of all of
> > them, and detailed review of most, and had run the automated tests
> > (buildbot) on them (which passed, even after adding more subtests),
> > and the smbtorture tests were also automatically run (it is triggered
> > in Namjae's github setup).
> >
> > Of the 8 patches in for-next, these 3 are the remaining ones that I am
> > looking at in more detail now:
> >
> > 24f0f4fc5f76 ksmbd: use LOOKUP_NO_SYMLINKS flags for default lookup
> > 1ec1e6928354 ksmbd: add buffer validation for SMB2_CREATE_CONTEXT
> > e2cd5c814442 ksmbd: add validation in smb2_ioctl
>
> ok, thanks for explaining.
>
> To be honest, I'm still trying to make sense of the patch workflow.
> Hopefully I get there eventually.
>
> How can I detect if a patch is already reviewed and queued for upstrea
> merge, so it's "too late" for me to do a review?

It is not too late to do review of any of these 8.  Given the
importance of security, the more reviews the better.  Earliest we
would send them (the larger set of 8) upstream would be in a few days.
  I typically like to have them sit in for-next for 48 hours (although
in some cases make exceptions, e.g.  for important bug fixes I will
shorten this if later in the week so they make it in time for the next
rc)

-- 
Thanks,

Steve
