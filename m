Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D596AC433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jun 2022 23:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbiFBXuz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Jun 2022 19:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiFBXuy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Jun 2022 19:50:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC29437A19
        for <linux-cifs@vger.kernel.org>; Thu,  2 Jun 2022 16:50:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52BC9B821AA
        for <linux-cifs@vger.kernel.org>; Thu,  2 Jun 2022 23:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022CAC3411D
        for <linux-cifs@vger.kernel.org>; Thu,  2 Jun 2022 23:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654213851;
        bh=lLNfFMNq7q0yNVFq60A4e11hnAt0Z9q1ANzHvBS7DTg=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=R5n66vu/Dd/uz/DIwpmciSy9FdWL0rKXegPmsR1gKkdNt88a47m8F0MApnAEvD7Yz
         90NyY+bFmDOLeFau60+/pokHlPhF9vQ9ypWDiIk1vzOp8ZI7nwfzXRZEZGL0Gd1TJF
         teuYMZF+27SLvJ2AVdPKKm9y0JR/Mvgm8CGwhMx27K7w5O25fBguqIqhv/unQJn9Tv
         u8HsOQBizCRmn5sKxOxMUlWqolAT49FI5vzUKavi30Qg5usaBFQrlfm9NfwCZ7uMNd
         ymNFkHQLXW+iW+ZaHoxBMNaZydCwAj+Ietl9ZWmOgaNzQdB4/Ior4AgQYth9FwDx23
         OV8olejGY09JA==
Received: by mail-wr1-f44.google.com with SMTP id h5so8390540wrb.0
        for <linux-cifs@vger.kernel.org>; Thu, 02 Jun 2022 16:50:50 -0700 (PDT)
X-Gm-Message-State: AOAM533cCGU/qssyjPkndMQUzosEctdeTjoFVaNhCJ77dLNVSlvziStZ
        DkNWKACSLXc2PBCbxeI/aIf91IeHMkVmOp2zYts=
X-Google-Smtp-Source: ABdhPJzydyN+Sgq/BGo5N0FjrO69uuEVb5ztlLW4Vrt1MyZTxnNO9qBb1OE9uAL7DVtxl87889+rq+jhc9iKO5rCq+0=
X-Received: by 2002:a5d:4e48:0:b0:210:18bb:6aa1 with SMTP id
 r8-20020a5d4e48000000b0021018bb6aa1mr5769957wrt.62.1654213849139; Thu, 02 Jun
 2022 16:50:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:ee4e:0:0:0:0:0 with HTTP; Thu, 2 Jun 2022 16:50:48 -0700 (PDT)
In-Reply-To: <928536.1654072840@warthog.procyon.org.uk>
References: <833010.1654031136@warthog.procyon.org.uk> <CAKYAXd_9jw69iKPBvuE4DxdpwcH2H90h3NQDQ7nyxzbTnEcirg@mail.gmail.com>
 <928536.1654072840@warthog.procyon.org.uk>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 3 Jun 2022 08:50:48 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9xbs5oiCeEonTDUGh01229ta+roq5fKEcn5+AeTwqddQ@mail.gmail.com>
Message-ID: <CAKYAXd9xbs5oiCeEonTDUGh01229ta+roq5fKEcn5+AeTwqddQ@mail.gmail.com>
Subject: Re: ksmbd threads eating masses of cputime
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-06-01 17:40 GMT+09:00, David Howells <dhowells@redhat.com>:
> Namjae Jeon <linkinjeon@kernel.org> wrote:
>
>> Okay, How do you reproduce this problem ? Did you run xfsftests
>> against ksmbd RDMA ?
>
> Yeah - I've been making sure my cifs filesystem changes work with RDMA.
> There've been a lot of connections that haven't been taken down cleanly,
> due
> to oopses, lockups and stuff.
>
> One thing that could be useful is, say, /proc/fs/ksmbd/
>
>> Okay, we need to add maximum retry count for that case.
>> but when I check kernel thread name in your top message, It is RDMA
>> connection.
>> So smb_direct_read() is used in ksmbd_conn_handler_loop().
>> I'd like to reproduce the problem to figure out where the problem is.
>> Can I try to reproduce it with soft-iWARP and xfstests?
>
> Note that I only noticed the issue when I switched to working on another
> filesystem and found that performance was unexpectedly down by 80%.
>
> I was using softRoCE, though it may well be causable with softIWarp also,
> since that's not really a detail visible to cifs/ksmbd, I think.
>
> I've just had a quick go at trying to reproduce this, hard-resetting the
> test
> client in the middle of performing an xfstest run, but it didn't seem to
> cause
> the single ksmbd:r5445 thread to explode.
Thanks for your check!
We also try to reproduce it but can't reproduce it yet. Let's check
whether an infinite loop can occur in smb_direct_read().

>
> David
>
>
