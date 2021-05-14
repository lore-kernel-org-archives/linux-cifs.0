Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B6BC433B4
	for <linux-cifs@archiver.kernel.org>; Fri, 14 May 2021 03:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3E2261440
	for <linux-cifs@archiver.kernel.org>; Fri, 14 May 2021 03:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbhENDtX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 May 2021 23:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbhENDtX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 May 2021 23:49:23 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF71DC061574
        for <linux-cifs@vger.kernel.org>; Thu, 13 May 2021 20:48:11 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id c15so21776466ljr.7
        for <linux-cifs@vger.kernel.org>; Thu, 13 May 2021 20:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=CQKmOodFrG+/fJsp7fm6Cnhy7/dXRI0EFonlOTqTqMI=;
        b=PcWSlzDsSLgUFoPjmKNdyPgmQAIx1/QqJV0BvmbL7FJgJzJgLZHazklQqFrFM//R7N
         QOCEwqO4FpwfluYCFbKIHbohVa3UHZfaXBTVJT2GhrSfWNr0wCMCX0evaNIEliE3h47d
         tLHpWae5qpfWySyZG/UuPn4D32BCoKKY8GhiFS97GxbXqlhN0Yptlk+WLtqrHAMwpzhD
         d1GfgG6Cm2iacPTlxu17KTWVpe1u79sU6y9Jyw0ERIMqPz4QPgOmNG/zbRFplztVRWg6
         wE0rAKVmPEAIDQWDoGTmFgtTQTuhi9Xfp/vR65wSMsb0igOpx2nVDUO1Y3N5oZ6oCsnB
         OXMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=CQKmOodFrG+/fJsp7fm6Cnhy7/dXRI0EFonlOTqTqMI=;
        b=ieCKYjfWkRPgPy5wqcbf9Q93qJ8W8rz/V0k01wG5rC11ZYIIVx48rlRpxd8yQOC/2g
         cfwCToCRJg7d1hselnQPZAqzH845WosVMp6r50bIFory63sddNFSOs/kHCGZ6aQOydQ0
         HtSNO9fbnzzzcoqxy8/zelietSVw4mTlxLRE+Jd+kCIBUGXqhAuHdeXZxw6LX/h3Linv
         n7GyMEjV0bjgE4++s5klqoV1eaL5YlZxTu/TayyY6juJ/fhk0uu3Nu328gb4yRYIlJ53
         zHo4EYXaY9ba382dYZMjXNNoFUX0P5tYBgpSXUAnPpKgRKNDY9D5YLeyUJeT1EgXlUIh
         rTPw==
X-Gm-Message-State: AOAM533D1PxqzZcav8lorh2aYz9/skYdrrqLOT7bzsIgwZdy1NJ3yikT
        Dqi6iVd8zqPfuDDpLJdXxX6yMOUQ6LXeIOu/fV4X/qvwUasEog==
X-Google-Smtp-Source: ABdhPJzkII++HhZbyzAWb7E1xuwotxTStfwUGPn2o+CWGWy/onsvBS8cjVbw6R/mfI05pWZUQXxuXaPS+JQYUjGtDFA=
X-Received: by 2002:a2e:9e57:: with SMTP id g23mr12296654ljk.148.1620964090187;
 Thu, 13 May 2021 20:48:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtxZx3RG4Z_b6-9bsaLBMAHObGas-yPe3rttj1tXcFtnA@mail.gmail.com>
In-Reply-To: <CAH2r5mtxZx3RG4Z_b6-9bsaLBMAHObGas-yPe3rttj1tXcFtnA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 13 May 2021 22:47:59 -0500
Message-ID: <CAH2r5mtkjSwU4mqbkUJomdB3o0Uo84agSVS_Vn+Yz7t1uLYoCg@mail.gmail.com>
Subject: Re: Additional xfstests
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

26 more tests added (33 more if you include the ones added last week)

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/641

On Thu, May 13, 2021 at 5:49 PM Steve French <smfrench@gmail.com> wrote:
>
> Did some experiments running more xfstests today, and we continue to
> be improving - can now add significantly more (e.g. to Samba server
> running on btrfs), 25+ tests that are now working in my quick tests
> this afternoon.  That is in addition to the ones we have added over
> the past few weeks.
>
> 051, 110, 111, 115, 116, 118, 119, 121, 139, 144, 163, 164, 165, 170,
> 183, 185, 188, 189, 190, 191, 194, 195, 196, 197, 201, 245 ... and
> more
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
