Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A13C433C1
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 15:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CAA661931
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 15:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhCSP2H (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Mar 2021 11:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhCSP1p (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Mar 2021 11:27:45 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEDEC06174A
        for <linux-cifs@vger.kernel.org>; Fri, 19 Mar 2021 08:27:45 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id g8so3478796lfv.12
        for <linux-cifs@vger.kernel.org>; Fri, 19 Mar 2021 08:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q4/TCbeybfhJS0Ts6nzIqid0r+guDAoJ8akz8CIECmc=;
        b=ExrSQXosdp+EeewUTG1vM7acOFmNM4wGSMWSu2w5vFiPbOWzFSbalv5Jdxy5gOccew
         BdlzqLB7cBCHkQtc4ClhQypwssKMVnXRUttbCdHsJjK9vzBcIw2CQlWXfsz168q2zaH0
         lNIosPJHEmyBlajotNDkEz2zFXFxd1TVz+FSmyu7wTutSxuECd0s0v3sy0eUF0eikQyx
         jAnLkRrqRuJi/Iv/Dx17Tumu1/FV6UtO5BmbABaEY+Y+CWb/I1w00r7osrZhgTdjU9EC
         2Sg5YDfgaUYvkOh18S5ytIsBIn79A+/eooXj9I1sgyh/xTyhf0OQCTlObj90mpv4mz8H
         PdIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q4/TCbeybfhJS0Ts6nzIqid0r+guDAoJ8akz8CIECmc=;
        b=XaiOXGbRwJG+DW+GtWW4Y2WdgD/VcYKqcDoOT+WBofB7u0mx8RfX9tIdSbsGVmp19o
         4Bw4VGYnVqly2YSHAcCcJRBLhiCNUJUW/KlgFQlF2Ik8jrW4/KTmO3cNVRgW+wcKzMbL
         cxSPE9fX2jrpVw5VtZtmyKsJJCCBXh4uxJHBZVRcitkpWdCfMw2sebMmdQ91dxQ7Itvz
         ABYi6lPuNTbNs7aw8ciPbCIP1DLDezmdeAQSORwD8lwd4qtZ3EIkQWjnZWc0tS953t9j
         6D29FOAcySwbPeywq/j8tIkijw83RHBfLrpU63WiPTNQHx50Xxqhzi5OvSX3riGfjiSm
         YeAA==
X-Gm-Message-State: AOAM532RXCky3gWetRl25qYNC9gAK0FQgDcbti1y7un6lVHLkZ1TTEZL
        4OYDCk2gcCLNCOIcG9I0IwaEf62SlM/vKBNtoFP5K5Im2YU=
X-Google-Smtp-Source: ABdhPJzsJNDZf9FcoZWIkpwzEoldwkYXeqCwsDHCNmXd1a6SLoE4kHVw3TIvo4s7uj59A65sGSWz2AbW1H1zeNapEDI=
X-Received: by 2002:a19:8c0a:: with SMTP id o10mr1191522lfd.175.1616167661247;
 Fri, 19 Mar 2021 08:27:41 -0700 (PDT)
MIME-Version: 1.0
References: <YFNRsYSWw77UMxw1@mwanda> <20210319131232.GA1057389@infradead.org>
 <CAH2r5muai5cA7C+Afku-PjgHCm9Zh+SkEiU1jvybL4xi-bre8g@mail.gmail.com> <20210319152110.GA1100251@infradead.org>
In-Reply-To: <20210319152110.GA1100251@infradead.org>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 19 Mar 2021 10:27:30 -0500
Message-ID: <CAH2r5mtpvzvFxebwbbpQ1d2hU0Zz0k67+=M-k+YPeqKneQZ6Lw@mail.gmail.com>
Subject: Re: [bug report] cifsd: introduce SMB3 kernel server
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Mar 19, 2021 at 10:21 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> Code that goes into linux-next needs to be posted to the relevant
> lists, which in this case includes linux-fsdevel and linux-kernel.  No
> backstory of conference and internal trees replaces that in any way.

Yes - agree.

When I last talked with Namjae (and looks like he asked others for
opinions as well
how to restructure the patch series to be easier to review on
linux-fsdevel), the
plan was to send the patches to fsdevel as the smaller set (same as just
went in linux-next) ASAP, but he just finished an important piece of the
description (the updated protocol feature implementation summary) last
night which
he asked me (and probably others) to review before sending it out.

-- 
Thanks,

Steve
