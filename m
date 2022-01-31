Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01036C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 31 Jan 2022 01:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357276AbiAaBHX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 30 Jan 2022 20:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiAaBHW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 30 Jan 2022 20:07:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154B9C061714
        for <linux-cifs@vger.kernel.org>; Sun, 30 Jan 2022 17:07:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95F25B8299D
        for <linux-cifs@vger.kernel.org>; Mon, 31 Jan 2022 01:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C1CC340E4
        for <linux-cifs@vger.kernel.org>; Mon, 31 Jan 2022 01:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643591239;
        bh=GHupT4IB9Yq/SPGZhW443V0OXTocGHnrynREexOiDYY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Ax3Yl1z/mfu4Pc39yWsyHiK98t0DOGTpZZxUkW0DvQYvlqKRvvb4bzCFf0oQDGWjG
         VRVqvUCqCZbddl/2pYskmsFl6AgmIt2XltV70GSOuCZki0/c0xyWSiF+tBy4Z8i9p+
         BHBWO0p8GN2hnuJxnNNabV5Up8xiVrKRMyDRZfBz1a2Dwa8O/Zg9yan2t1f9WYXPQ+
         /bV7boHyB7VH+Oe/q9S0IwfCgcI+kjjfiuMWV4PWqc2jwmQZBv0qHosTUd5QtJo7pU
         oyPdDEGiG92YnlP7UH6H3qAcu+l8V3ynZSfqZzSqOg06euXvGe27bn3VSxNpRWXSzO
         QIYs9aH9TmANw==
Received: by mail-yb1-f175.google.com with SMTP id v186so35886976ybg.1
        for <linux-cifs@vger.kernel.org>; Sun, 30 Jan 2022 17:07:19 -0800 (PST)
X-Gm-Message-State: AOAM530PlzetOW+xDrkj2dBVBPP8U5cG/U76PiwTdIZlFP6ObNM3mukz
        uNMdV2h3BwM1pHWzfQuGSDtV233EwED3gDBLs6I=
X-Google-Smtp-Source: ABdhPJxQtegSIJVPY21X2hdd7wRdqye92C2Rl3jztlJ+6Z7OuI1vUYUvqqEvTVhyJDfwDIznYvCAr/SAJmo7r+AtOno=
X-Received: by 2002:a25:8101:: with SMTP id o1mr28483166ybk.265.1643591238423;
 Sun, 30 Jan 2022 17:07:18 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:b08e:b0:127:3295:9956 with HTTP; Sun, 30 Jan 2022
 17:07:18 -0800 (PST)
In-Reply-To: <9bd2b636-ca5a-df2c-49ab-db14b7b453f1@talpey.com>
References: <20220130093433.8319-1-linkinjeon@kernel.org> <9bd2b636-ca5a-df2c-49ab-db14b7b453f1@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 31 Jan 2022 10:07:18 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_kaQBYyj68-ijxnxt1VsZMj09Qovss1vuzDGdF3CsP2A@mail.gmail.com>
Message-ID: <CAKYAXd_kaQBYyj68-ijxnxt1VsZMj09Qovss1vuzDGdF3CsP2A@mail.gmail.com>
Subject: Re: [PATCH 1/3] ksmbd: reduce smb direct max read/write size
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-01-31 4:04 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 1/30/2022 4:34 AM, Namjae Jeon wrote:
>> To support RDMA in chelsio NICs, Reduce smb direct read/write size
>> to about 512KB. With this change, we have checked that a single buffer
>> descriptor was sent from Windows client, and intel X722 was operated at
>> that size.
>
> I am guessing that the larger payload required a fast-register of a page
> count which was larger than the adapter supports? Can you provide more
> detail?
Windows client can send multiple Buffer Descriptor V1 structure
elements to server.
ksmbd server doesn't support it yet. So it can handle only single element.
We have known that Windows sends multiple elements according to the
size of smb direct max read/write size. For Melanox adapters, 1MB
size, and Chelsea O, 512KB seems to be the threshold. I thought that
windows would send a single buffer descriptor element when setting the
adapter's max_fast_reg_page_list_len value to read/write size, but it
was not.
chelsio's max_fast_reg_page_list_len: 128
mellanox's max_fast_reg_page_list_len: 511
I don't know exactly what factor Windows client uses to send multiple
elements. Even in MS-SMB2, It is not described. So I am trying to set
the minimum read/write size until multiple elements handling is
supported.
>
> Also, what exactly does "single buffer descriptor from Windows client"
> mean, and why is it relevant?
Windows can send an array of one or more Buffer Descriptor V1
structures, i.e. multiple elements. Currently, ksmbd can handle only
one Buffer Descriptor V1 structure element.

If there's anything I've missed, please let me know.
>
> Confused,
> Tom.
Thanks!
>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   fs/ksmbd/transport_rdma.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
>> index 3c1ec1ac0b27..ba5a22bc2e6d 100644
>> --- a/fs/ksmbd/transport_rdma.c
>> +++ b/fs/ksmbd/transport_rdma.c
>> @@ -80,7 +80,7 @@ static int smb_direct_max_fragmented_recv_size = 1024 *
>> 1024;
>>   /*  The maximum single-message size which can be received */
>>   static int smb_direct_max_receive_size = 8192;
>>
>> -static int smb_direct_max_read_write_size = 1048512;
>> +static int smb_direct_max_read_write_size = 524224;
>>
>>   static int smb_direct_max_outstanding_rw_ops = 8;
>>
>
