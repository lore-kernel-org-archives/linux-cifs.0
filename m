Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57796C433ED
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Apr 2021 02:23:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2562C60FDB
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Apr 2021 02:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhD0CYc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Apr 2021 22:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhD0CYc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Apr 2021 22:24:32 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7060BC061574
        for <linux-cifs@vger.kernel.org>; Mon, 26 Apr 2021 19:23:49 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id z13so10333487lft.1
        for <linux-cifs@vger.kernel.org>; Mon, 26 Apr 2021 19:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZDFWAX5uWarzZd3mzJxPPEmJlbpOVlBCUXzmru5WnmU=;
        b=ehDgVABBwrnmUaoCGSDnEbzjSxC3FrPd64W3qZK180lda6nvqeXXI+/kpb6YFtIOLA
         ax65fgxh1wD3CMf+z46cQCdedk/wvLJ5w/xatfr/vNfkS+JRu7ALuuIJhYxtTaUbDtCA
         Hdx7OiYNoeXfZMVj7RGNz9FJEurOhZL67iQcaX0fvkTmAdULczUtSjK1K17/tEs4vi/B
         vlBegB1YHh0MOAV5v31+lABJoAqVDaXbQHgw5ixKFc7ZL7LYCZyHAb6xZWSoI0KV47TW
         GaU0bMdvAEYJWhrByMDWjAXpDdvvI0zzgDfs5Mg9JOPMXUGKDkVj1ylGta7fyH407H6m
         ScuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZDFWAX5uWarzZd3mzJxPPEmJlbpOVlBCUXzmru5WnmU=;
        b=QcC7Xxfl063Rc1WqAX1epBnI3ss5Zc2BpqgKHQt0WqyhJThGCMg3/Jj2vqBFRfiaEC
         okarSvPNmZalRSdtABdGIaXL+5yHL91P/h4YIsX7+XLH76gp+7W92Q2vU4DofPU6YKR9
         wCv9FDX5VBscM5bze+DrvolDYbPNkoG4x8YBebmYgfg8a55ROjFQlTPiSVLVv2vnGxiZ
         kHNl+fj7aH+JnhKPwC2oTWil1VZ1LdgtEQp6dW9D5vhgIBAyXDcHgJ1U+mwjJWwkjAAb
         J8jSDHKqqJD7pMjw7N8ID6HpTzDM2X8OVLSrlnt7UPcB4zCtJz80XyMHP5BTdB1EFLB3
         ZKXg==
X-Gm-Message-State: AOAM53001Rc+CvCiVi1DZCJI764Hp9vpk+RlFem+gbbzdYbxTLipTPh2
        WhXZIoTTJtF+x1IBMep4Vtqxd+QDQA/FjHXqfoE=
X-Google-Smtp-Source: ABdhPJz99LSibUtU4FKT52RfKdx0Q1N+9BkhckMlQGeMtPw6Xtm721jsnqkRQnPVDrZ3YsQcwdIVtriWNQK3/C/dFVc=
X-Received: by 2002:a05:6512:3ca0:: with SMTP id h32mr15486615lfv.184.1619490227856;
 Mon, 26 Apr 2021 19:23:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvfMfgGimkmC9nQxvOMt=2E7S1=dA33MJaszy5NHE2zxQ@mail.gmail.com>
 <20210425020946.GG235567@casper.infradead.org> <CAH2r5mui+DSj0RzgcGy+EVeg7VXEwd9fanAPNdBS+NSSiv9+Ug@mail.gmail.com>
 <CAH2r5msv6PtzSMVv1uVY983rKzdLvfL06T5OeTiU8eLyoMjL_A@mail.gmail.com>
 <CANT5p=qVq5mD2jfvt1Ym24hQF9M-aj1v1GT2q+_41p1OTESTKw@mail.gmail.com> <20210426115457.GJ235567@casper.infradead.org>
In-Reply-To: <20210426115457.GJ235567@casper.infradead.org>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 26 Apr 2021 21:23:36 -0500
Message-ID: <CAH2r5muEvEUAMEonGWYvBUp1Xp67eACEVNs3JtR9XKTts7vVPw@mail.gmail.com>
Subject: Re: [PATCH] smb3: add rasize mount parameter to improve performance
 of readahead
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Apr 26, 2021 at 6:55 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Mon, Apr 26, 2021 at 10:22:27AM +0530, Shyam Prasad N wrote:
> > Agree with this. Was experimenting on the similar lines on Friday.
> > Does show good improvements with sequential workload.
> > For random read/write workload, the user can use the default value.
>
> For a random access workload, Linux's readahead shouldn't kick in.
> Do you see a slowdown when using this patch with a random I/O workload?

I see few slowdowns in the 20 or so xfstests I have tried, but the
value of rasize
varies a lot by server type and network type and number of channels.  I don't
have enough data to set rasize well (I have experimented with 4MB to 12MB
but need more data).

In some experiments running 20+ typical xfstests

So far I see really good improvement in multichannel to Azure with setting
rasize to 4 times negotiated read size. But I saw less than a 1% gain though
to a slower Windows server running in a VM (without multichannel).  I
also didn't
see a gain to localhost Samba in the simple examples I tried. I saw
about an 11% gain to a typical Azure share without multichannel. See
some example perf data below. The numbers on right are perf with
rasize set to 4MB,
ie 4 times the negotiated read size, instead of results using defaults
of ra_pages = 1MB rsize (on the left).

generic/001 113s ...  117s
generic/005 35s ...  34s
generic/006 567s ...  503s
generic/010 1s ...  1s
generic/011 620s ...  594s
generic/024 10s ...  10s
generic/028 5s ...  5s
generic/029 2s ...  2s
generic/030 3s ...  2s
generic/036 11s ...  11s
generic/069 7s ...  7s
generic/070 287s ...  270s
generic/080 3s ...  2s
generic/084 6s ...  6s
generic/086 1s ...  1s
generic/095 25s ...  23s
generic/098 1s ...  1s
generic/109 469s ...  328s
generic/117 219s ...  201s
generic/124 21s ...  20s
generic/125 63s ...  62s
generic/130 27s ...  24s
generic/132 24s ...  25s


-- 
Thanks,

Steve
