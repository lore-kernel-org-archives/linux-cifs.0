Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41673C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 31 Jan 2022 05:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbiAaFJ0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 31 Jan 2022 00:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiAaFJ0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 31 Jan 2022 00:09:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222E8C061714
        for <linux-cifs@vger.kernel.org>; Sun, 30 Jan 2022 21:09:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3720B80ADD
        for <linux-cifs@vger.kernel.org>; Mon, 31 Jan 2022 05:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C805C340E8
        for <linux-cifs@vger.kernel.org>; Mon, 31 Jan 2022 05:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643605763;
        bh=EOIIg/TAEoF4L64JU0hb0rCQ93Gf1ZFRxs6WxAP70Y8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=rZBW5ZSJWB/svWu2Gg6YM/b0yf1YELaUCBis5KcHzoA/Egs/23ohZLxbi/QEm1uWK
         gxC9uGGvE2lMETWyfMovfIzehhfKf6DFWK6MA+SXT1TIh8p1vE9U3QdTBwMZBk/lud
         gu/cnByCf1d4Lhy/bzQhUqyB9Sju+wV9JkpZ9uCNmj5Hu3qXs8ZPUnZ+s6gDjbnbCZ
         KnHnghed8oFAOaQK9+5hkY2bnPP9fwiMPjOQ/sZZbXumVoX5G9G4pPpIJGPpgJCSXu
         kbcWaqsKnVkNUqUU5eqJ6zQOpl89Wfp9ef4ys0ZnUu6srX7qqi5b277MYm9MEzlxme
         9NCB5yo+LQE4Q==
Received: by mail-yb1-f171.google.com with SMTP id k31so37020981ybj.4
        for <linux-cifs@vger.kernel.org>; Sun, 30 Jan 2022 21:09:23 -0800 (PST)
X-Gm-Message-State: AOAM531Mgc/ROHSdx0piPGZE/KcP6WIibmYhDfMAqqdBK0YrwOXR8+dC
        jB9Oij3Pdxbge7pS73FhZ4mhnQDit0OVmKOhFSQ=
X-Google-Smtp-Source: ABdhPJxVHhmMSGLRR5MQa46NEyt4+4Hrfq5KhXA7tvBnqHivrT8aFowSYDCDqfKAhQjrIq31WAb1XvRb90GXI3tCWc0=
X-Received: by 2002:a25:15c7:: with SMTP id 190mr28469922ybv.507.1643605762452;
 Sun, 30 Jan 2022 21:09:22 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:b08e:b0:127:3295:9956 with HTTP; Sun, 30 Jan 2022
 21:09:22 -0800 (PST)
In-Reply-To: <b22e3dd4-51d4-31d2-ac69-7cb4510860fc@talpey.com>
References: <20220130093433.8319-1-linkinjeon@kernel.org> <9bd2b636-ca5a-df2c-49ab-db14b7b453f1@talpey.com>
 <CAKYAXd_kaQBYyj68-ijxnxt1VsZMj09Qovss1vuzDGdF3CsP2A@mail.gmail.com> <b22e3dd4-51d4-31d2-ac69-7cb4510860fc@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 31 Jan 2022 14:09:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8bKuu5H7rP=SgyyLGBkCLLyRfgWGKGtTxMk7M0TNuQtg@mail.gmail.com>
Message-ID: <CAKYAXd8bKuu5H7rP=SgyyLGBkCLLyRfgWGKGtTxMk7M0TNuQtg@mail.gmail.com>
Subject: Re: [PATCH 1/3] ksmbd: reduce smb direct max read/write size
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-01-31 12:18 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 1/30/2022 8:07 PM, Namjae Jeon wrote:
>> 2022-01-31 4:04 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>> On 1/30/2022 4:34 AM, Namjae Jeon wrote:
>>>> To support RDMA in chelsio NICs, Reduce smb direct read/write size
>>>> to about 512KB. With this change, we have checked that a single buffer
>>>> descriptor was sent from Windows client, and intel X722 was operated at
>>>> that size.
>>>
>>> I am guessing that the larger payload required a fast-register of a page
>>> count which was larger than the adapter supports? Can you provide more
>>> detail?
>> Windows client can send multiple Buffer Descriptor V1 structure
>> elements to server.
>> ksmbd server doesn't support it yet. So it can handle only single
>> element.
>
> Oh! So it's a bug in ksmbd which isn't supporting the protocol.
> Presumably this will be fixed in the future, and this patch
> would be reversed.
Right. Work to support it is in progress, Need the time to complete it.
>
> In any case, the smaller size is purely a workaround which permits
> it to interoperate with the Windows client. It's not actually a fix,
> and has nothing fundamentally to do with Chelsio or Intel NICs.
Right.
>
> The patch needs to say these. How about
>
> "ksmbd does not support more than one Buffer Descriptor V1 element in
> an smbdirect protocol request. Reducing the maximum read/write size to
> about 512KB allows interoperability with Windows over a wider variety
> of RDMA NICs, as an interim workaround."
Thanks:)  I will update patch description.
>
>> We have known that Windows sends multiple elements according to the
>> size of smb direct max read/write size. For Melanox adapters, 1MB
>> size, and Chelsea O, 512KB seems to be the threshold. I thought that
>> windows would send a single buffer descriptor element when setting the
>> adapter's max_fast_reg_page_list_len value to read/write size, but it
>> was not.
>> chelsio's max_fast_reg_page_list_len: 128
>> mellanox's max_fast_reg_page_list_len: 511
>> I don't know exactly what factor Windows client uses to send multiple
>> elements. Even in MS-SMB2, It is not described. So I am trying to set
>> the minimum read/write size until multiple elements handling is
>> supported.
>
> The protocol documents are about the protocol, and they intentionally
> avoid specifying the behavior of each implementation. You could ask
> the dochelp folks, but you may not get a clear answer, because as
> you can see, "it depends" :)
Okay.
>
> In practice, a client will probably try to pack as many pages into
> a single registration (memory handle) as possible. This will depend
> on the memory layout, the adapter capabilities, and the way the
> client was actually coded (fast-register has very different requirements
> from other memreg models). I take it the Linux smbdirect client does
> not trigger this issue?
Yes, Because linux smbdirect client send one Buffer Descriptor V1 element:)
So there is no issue between linux smbdirect client and ksmbd.
>
> Is there some reason you can't currently support multiple descriptors?
> Or is it simply deferred for now?
smbdirect codes of ksmbd are referenced from the linux cifs client's one.
and we found that windows client could send more than one element later.
It is in progress. I want that ksmbd work RDMA with Windows over a
wider variety of RDMA NICs in the meantime.

Thanks!
>
> Tom.
>
>>> Also, what exactly does "single buffer descriptor from Windows client"
>>> mean, and why is it relevant?
>> Windows can send an array of one or more Buffer Descriptor V1
>> structures, i.e. multiple elements. Currently, ksmbd can handle only
>> one Buffer Descriptor V1 structure element.
>>
>> If there's anything I've missed, please let me know.
>>>
>>> Confused,
>>> Tom.
>> Thanks!
>>>
>>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>>> ---
>>>>    fs/ksmbd/transport_rdma.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
>>>> index 3c1ec1ac0b27..ba5a22bc2e6d 100644
>>>> --- a/fs/ksmbd/transport_rdma.c
>>>> +++ b/fs/ksmbd/transport_rdma.c
>>>> @@ -80,7 +80,7 @@ static int smb_direct_max_fragmented_recv_size = 1024
>>>> *
>>>> 1024;
>>>>    /*  The maximum single-message size which can be received */
>>>>    static int smb_direct_max_receive_size = 8192;
>>>>
>>>> -static int smb_direct_max_read_write_size = 1048512;
>>>> +static int smb_direct_max_read_write_size = 524224;
>>>>
>>>>    static int smb_direct_max_outstanding_rw_ops = 8;
>>>>
>>>
>>
>
