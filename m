Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB329C388F9
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Nov 2020 21:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6185420825
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Nov 2020 21:39:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JjVirHVq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgKKVj0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Nov 2020 16:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgKKVjZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Nov 2020 16:39:25 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7822BC0613D1
        for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2020 13:39:25 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id v144so5213539lfa.13
        for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2020 13:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JD/6RIDWszapLupngD31qX+0LOdMilCh5M3HEteGA/c=;
        b=JjVirHVqAtBsxDtXH1iu7dIjOSrzpsQoUhdsKH36BSjrZ1JCFBkIakTMFITtuSPs0o
         O2ZRD3BbrHi4woJixniNeJjGQaJYrp+uyGJ19tyAe3tLBN4HqIr/vJlxSBzT8BFsKGL8
         90KIEWIRg8CQeprwbUuZm43khcodeSO0Iz917CSfz0LIFG1mJcPZCiWE6DmxsSoS7/d3
         Njf7b8rqhTSOjQwXVSl2hyWrmGQ5pbU7xrhQi0e/LWSZCpx/cFyBKs0ooXZu5EI4XeCJ
         bg8JuLXC0b2tNS+xyHcdcMSi3OnE6WJ8FMXfj0DOAZm3ll8LJyv/0Qcp+lNR60E9uhIE
         VL8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JD/6RIDWszapLupngD31qX+0LOdMilCh5M3HEteGA/c=;
        b=S43G0xa3j46QcTZqxNXTPyC/n1Jj+v5iBI//EuFsSq5wMZT+VHd297HEsf4y+OCtA8
         iuzmM4F6Iv+D1xMVTm8KumQtEFE6tOvS4Zv6e5suBP3iazi+EEmmZCfViCplGqGX0M+I
         k0+w9iQtilmvGITa70vYiRHidjYIno2q3ibj5sfsib4BSGNKTmnNNdfkWyD76v1oQkjt
         n4BTg9TnO1ItPeKZYfFwOax0eCWORiMbLZNOCohCamv55wjR9wpsoy6Q80YjKQX/m4cC
         rBgQloVg+4xZC6xLzYKAktIhezfrbumzPgV8mwnyzd76D408prq2HXI0rG52goCU79/D
         RjUQ==
X-Gm-Message-State: AOAM5326kgAg55iLjK2TMmRWk0pQ80ZKQ3qwDIOfgCf5XTBZuEVc+m2z
        aN7pNgmfNYw0FOSRvWIxEaLv3QFflLhuggL5aL3/+Z1McBE=
X-Google-Smtp-Source: ABdhPJzwmXkvGK9iT+pBlommbtvBhl6qQJEmW5eUxFQ54sWyAlbpGJgOHebiCQuWVbQzokn9QrtSe1YCr0k+bOcNeIo=
X-Received: by 2002:ac2:5cc8:: with SMTP id f8mr8295888lfq.334.1605130763739;
 Wed, 11 Nov 2020 13:39:23 -0800 (PST)
MIME-Version: 1.0
References: <CACdtm0YUmSx27NFh7KRwafY+agdTgubZ22QGrx=k8ZmyZit_Ww@mail.gmail.com>
In-Reply-To: <CACdtm0YUmSx27NFh7KRwafY+agdTgubZ22QGrx=k8ZmyZit_Ww@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 11 Nov 2020 15:39:12 -0600
Message-ID: <CAH2r5msm0Xbosxk6siMO8EVB_KeLq8skbt-Ngcu5a0qhcP25cQ@mail.gmail.com>
Subject: Re: Handling race conditions during read offload path
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        sribhat.msa@outlook.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Updated patch descriptions with a little more info about the problem
fixed.  Added cc:stable 5.4+ and merged into cifs-2.6.git for-next
(pending a little more testing - buildbot etc. - but looks good)

On Tue, Nov 10, 2020 at 2:35 AM Rohith Surabattula
<rohiths.msft@gmail.com> wrote:
>
> Hi All,
>
> 1) During cifs reconnect, there is possibility of MID pending list
> corruption when both offload and demultiplex thread tries to dequeue
> MID from the list.
> 2) Mid callback needs to be called only when valid data is read from socket.
>
> So, I have addressed the above issues and attached the patches.
>
> Regards,
> Rohith



-- 
Thanks,

Steve
