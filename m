Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C523AC433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Oct 2022 08:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiJEIE4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Oct 2022 04:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiJEIEz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Oct 2022 04:04:55 -0400
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A59C1C93E
        for <linux-cifs@vger.kernel.org>; Wed,  5 Oct 2022 01:04:54 -0700 (PDT)
Received: by mail-vk1-xa2e.google.com with SMTP id b81so8188232vkf.1
        for <linux-cifs@vger.kernel.org>; Wed, 05 Oct 2022 01:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=WYr7KxHmLemkY7MA8K/8fclOMTFhYKqyJJFG3jMAEno=;
        b=gbQwKvuWOi7GpvP+RzGl898Z3XExZhZ2OcJUAF6ZcDviW3ZZQq+TVuCrhByFsknjHm
         acOE2SqNgRml//beHkMias1bJst9yokednHXZTV2auxZlNoEpKGguHIvl/WxZ2UA5MgX
         t0gu420PkkzCr+vFue6n13OrTHg2ySqeMNX1Aget6yr4OM8u1cGRXDkmjecscgmlOKN8
         dkpDKZVhw/IDXvFj+LcFFTU0q9tHssSRbHjVYKTvMkC6GY4Id//11+q8SCvgn59QejAB
         DNSzpk4LJ6++AzfyLQ2zjw1/y1nB7NPebF+u842LAtiueA07YUwt0QCPX251D0yo2Ayr
         HSoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=WYr7KxHmLemkY7MA8K/8fclOMTFhYKqyJJFG3jMAEno=;
        b=YyKAemuISG+9MqrRDHLH1mpaFYwohJnZIh56iNvf9Jnn91JGAG7EmY6MI2zXnRQOcr
         XorwgCD1bLn6f/SqE3aH5CfgrqfsUK0QXgJ9Z1anFk5yNnCZjmJbfUOVbEpcf/6ey2YJ
         w1c8To5yfAy3iBWPLTMI80vOB2L4p/C0DDtvtjq7VBoqqmbItu7jhFTb7NOaMP0QiqLC
         Fxf+R+Pj2MRa9eflzrZ1vHxwE5/gUjXK/3n5KwX660biexDY02LeckIetLZFaXxhipcB
         /XdrUFXzsvMC1iQ6B5lSLwJl21BVJVq4Vw8DEm2itPOklARMFYKP0NXvj8uQs5APBFho
         b1Qw==
X-Gm-Message-State: ACrzQf3vqjEDvXynLAIV+bUJRAMubIB4QBvsFI2tm1Utz6OQuiitnXjC
        FwVQZi/+8cx72EobYTe2ryzG/DHWV0XLmvCyim8=
X-Google-Smtp-Source: AMsMyM5OyX1KJmIrqDZpW9nKEphnBkTOCzp3nSPEFpDjBfyOIy0Jwokpp+7FZ9vwRvgXbi4XxPOaq9wvE73jQ6dXqGw=
X-Received: by 2002:a1f:d583:0:b0:3aa:9112:570f with SMTP id
 m125-20020a1fd583000000b003aa9112570fmr5313062vkg.3.1664957093308; Wed, 05
 Oct 2022 01:04:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220929203652.13178-1-ematsumiya@suse.de> <20220929203652.13178-3-ematsumiya@suse.de>
 <87v8oz4e5h.fsf@cjr.nz>
In-Reply-To: <87v8oz4e5h.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 5 Oct 2022 03:04:42 -0500
Message-ID: <CAH2r5mu8QACTu+KUis+FE8-K9E9Q1GfB9fHr6JjPexgn+xSy7A@mail.gmail.com>
Subject: Re: [PATCH v4 2/8] cifs: secmech: use shash_desc directly, remove sdesc
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com, tom@talpey.com,
        metze@samba.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

fyi - had to rebase this to work around the kfree_sensitive changes
which are now included from your earlier patch

On Tue, Oct 4, 2022 at 1:49 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Enzo Matsumiya <ematsumiya@suse.de> writes:
>
> > The struct sdesc is just a wrapper around shash_desc, with exact same
> > memory layout. Replace the hashing TFMs with shash_desc as it's what's
> > passed to the crypto API anyway.
> >
> > Also remove the crypto_shash pointers as they can be accessed via
> > shash_desc->tfm (and are actually only used in the setkey calls).
> >
> > Adapt cifs_{alloc,free}_hash functions to this change.
> >
> > Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> > ---
> >  fs/cifs/cifsencrypt.c   | 86 +++++++++++++----------------------------
> >  fs/cifs/cifsglob.h      | 26 ++++---------
> >  fs/cifs/cifsproto.h     |  5 +--
> >  fs/cifs/link.c          | 13 +++----
> >  fs/cifs/misc.c          | 49 ++++++++++++-----------
> >  fs/cifs/smb2misc.c      | 13 +++----
> >  fs/cifs/smb2transport.c | 72 +++++++++++++---------------------
> >  7 files changed, 98 insertions(+), 166 deletions(-)
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>



-- 
Thanks,

Steve
