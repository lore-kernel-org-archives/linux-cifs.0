Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E57A0C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 10 May 2022 00:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbiEJAFM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 May 2022 20:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbiEJAFK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 May 2022 20:05:10 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2AF2713
        for <linux-cifs@vger.kernel.org>; Mon,  9 May 2022 17:01:14 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2f7c424c66cso162821437b3.1
        for <linux-cifs@vger.kernel.org>; Mon, 09 May 2022 17:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dLNJlOE0W2Qp89NB9yhH2cj5Is9aTaH1360bCuvSh9w=;
        b=eIZFr43RBdhSRbMFA4Acan56317H4aBTrHwWLOcHU3mS4r70pUYp21MAdx4RTShUlE
         SGSSwEZPSpKrLVDroHMmn7uqV02XUfOcgdCLt+AgkKf5raIlIFTTIj8RvrxASNsH0BYy
         qJAkmtFa5ZSBzojiaMZ+nP990VSIdRhT5jaoy93DcUGkxUOEm98GvBDtGpzFW9yANB5g
         CNnKiHLa6rHZvwbQRELNjXHpxSZQ+aHN+Vep1Xx5LKRwu5l7IRYfwZ4R1AJBiOx4meZ3
         C5psFYxB7TFLsKDf3T6+q731ZkpLDGkg/Q4yGy59V7l4/Q2/c7cDuZ84Aav48uAI8MOB
         fg3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dLNJlOE0W2Qp89NB9yhH2cj5Is9aTaH1360bCuvSh9w=;
        b=221T8jszGALyyZ+VmrBRQeiWEjPhYMkt25n96xYAH9SnhSl/Cj74AhcHn/rQ+lJGGm
         Wb1zfL4rOZBSGPliJSbUjIwxLimtYieNuCFXSLMut6lca1W5dbAJaOfqwpTjP+VYDqyI
         xQ4qdZvaV2QqkBgfQIe3ApmHm2juSiJLsz3T0fOBpbSmoysw4k9lIkMlcOgS29KXmG5k
         UzK8x79vYuc4v75Wem2tjos8CVYS3XpLku//mrtfdf7SI7YRcFENIrgG9/gsB49lR85r
         4XrXgKqv6cdfOyWwAQy3ni2b8P2+xGke/Y0pr/ZxSidSka2jjEA99Z8ILV8eID7rw9ZY
         HJSg==
X-Gm-Message-State: AOAM531bCqY0asUiVo34t2R4Z540HSYHscHV0A/4cpIKrhTv0SLRD+ei
        TNC9mvIulZpEm46zfiCFaNBfeVy0zVdmD0oRBTI=
X-Google-Smtp-Source: ABdhPJzfUPZDyEtHI4dPLezCDWKDowc2rfxzRPMV96zVRhoD4TJpFCCPV8rr7gC2mUvCiVdDv1t1chigjWJCQ9+Ealo=
X-Received: by 2002:a81:791:0:b0:2fb:7c64:5582 with SMTP id
 139-20020a810791000000b002fb7c645582mr1024917ywh.127.1652140874222; Mon, 09
 May 2022 17:01:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220504014407.2301906-1-lsahlber@redhat.com> <20220504014407.2301906-2-lsahlber@redhat.com>
 <20220504165430.xptspu37vmhwwesj@cyberdelia> <CAN05THTE3ZZzUhL6tqzy_bs0RLLnLxmG9HK8Sx3uQSkg6yTJQA@mail.gmail.com>
In-Reply-To: <CAN05THTE3ZZzUhL6tqzy_bs0RLLnLxmG9HK8Sx3uQSkg6yTJQA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 10 May 2022 10:01:03 +1000
Message-ID: <CAN05THQrB57Vs5gSW3Fm6Ja6WgiCPy_QtX2TnVO_hr+e8zZ+aA@mail.gmail.com>
Subject: Re: [PATCH] cifs: cache dirent names for cached directories
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, 10 May 2022 at 09:33, ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>
> On Fri, 6 May 2022 at 16:21, Enzo Matsumiya <ematsumiya@suse.de> wrote:
> >
> > On 05/04, Ronnie Sahlberg wrote:
> > >+struct cached_dirents {
> > >+      bool is_valid:1;
> > >+      bool is_failed:1;
> >
> > Does it make sense to have both? Do you expect a situation where
> > is_valid && is_failed happens? From the patch, I don't see such case and
> > the code could be adjusted to use !is_valid where appropriate.
> > But let me know if I missed something.
>
> The reason to have both is to handle cases where we fail populating
> the cache partway through readdir.
>
> The idea is that is_valid is set once we have fully populated the
> cache successfully
> and is_failed is set on failure during the population of the cache and
> once it is set there is no point in even trying to add new entries to
> the cache.

What I mean is that we have three states and thus need two booleans:
1, successfully scanned the whole directory and cached all entries
2, in the process of scanning the directory and no failure yet
3, in the process of scanning the direcotry but we have already
encountered a failure

>
> >
> > This is just a cosmetic nitpick, but other than that,
> >
> > Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
> >
> >
> > Cheers,
> >
> > Enzo
