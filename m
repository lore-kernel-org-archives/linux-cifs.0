Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF9EBC04A95
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Sep 2022 01:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiIZBNt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 25 Sep 2022 21:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiIZBNt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 25 Sep 2022 21:13:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D8127FC7
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 18:13:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1795B80D10
        for <linux-cifs@vger.kernel.org>; Mon, 26 Sep 2022 01:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F12CC4347C
        for <linux-cifs@vger.kernel.org>; Mon, 26 Sep 2022 01:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664154823;
        bh=OAm0WPmRZZYZL61wKghmkx9SSUk/y2Ar6dzy/dy7DcI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=qKZ5YyWIOE0fK9Tneszb/esIFbSiCxjxvxp6wvzqw0muKWZvzEtoPnBSAwEM3KR0A
         E6BGEFNhX6AoNLUXTN9WwuCeQhv8eQ/p+vU0VAxF3qZu16jQSiF+wn5y+fpeTqNrfX
         TgBSkHDHjuLcSF45XTwV0sP+A1H1oUJOb1GqXBRCMXZAjf9BbAbnl2nJkrzJXyVVNL
         YT2fSqXBw0FJpnKDaQVOEFE8AAj8I46lPBajrbiKiVIl9YcfY4yLHeCGFdQlB7Cem5
         Q2j7nSMULLLk14zVcLI5uUHDVBDDpejAWHn+OYeKdFAzX7cChbfzrV7aceQ0DgYu/I
         XLMjSs3nfSowg==
Received: by mail-oi1-f173.google.com with SMTP id n124so6580905oih.7
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 18:13:43 -0700 (PDT)
X-Gm-Message-State: ACrzQf2QAZrt84ega+eCGhMOgW7F61l/IDrD+tsRgllRj7Gzh9Yx1qTn
        UezsDd0EH7Lf9LWCZXbte9HUVvcWvZBMimt0CDI=
X-Google-Smtp-Source: AMsMyM5WvUsTehrDpc3Ev9URh/Lg5GFApwuqAZodbMjtMLnIq7bAIZjFV7wDMoV5LFV+rbgWPmmXQktUxvs3KAXmUKg=
X-Received: by 2002:a05:6808:211d:b0:34f:e0fc:6e6e with SMTP id
 r29-20020a056808211d00b0034fe0fc6e6emr14206015oiw.8.1664154822476; Sun, 25
 Sep 2022 18:13:42 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Sun, 25 Sep 2022 18:13:41
 -0700 (PDT)
In-Reply-To: <11e7b888-460e-efd1-0a8c-3dbf594d9429@talpey.com>
References: <cover.1663961449.git.tom@talpey.com> <f5fab678eedae83e79f25e4385bc1381ed554599.1663961449.git.tom@talpey.com>
 <CAKYAXd97ZrGVPj3astSWz3ESHKYFQ9JAxeq3z65mB6wmoiujrQ@mail.gmail.com> <11e7b888-460e-efd1-0a8c-3dbf594d9429@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 26 Sep 2022 10:13:41 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8JiF5N_Ve65=wHPyW+twRT5WOoHH=j6+u0YAAjCV-n2Q@mail.gmail.com>
Message-ID: <CAKYAXd8JiF5N_Ve65=wHPyW+twRT5WOoHH=j6+u0YAAjCV-n2Q@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] Reduce server smbdirect max send/receive segment sizes
To:     Tom Talpey <tom@talpey.com>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org,
        senozhatsky@chromium.org, bmt@zurich.ibm.com, longli@microsoft.com,
        dhowells@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-26 0:41 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/24/2022 11:40 PM, Namjae Jeon wrote:
>> 2022-09-24 6:53 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>> Reduce ksmbd smbdirect max segment send and receive size to 1364
>>> to match protocol norms. Larger buffers are unnecessary and add
>>> significant memory overhead.
>>>
>>> Signed-off-by: Tom Talpey <tom@talpey.com>
>>> ---
>>>   fs/ksmbd/transport_rdma.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
>>> index 494b8e5af4b3..0315bca3d53b 100644
>>> --- a/fs/ksmbd/transport_rdma.c
>>> +++ b/fs/ksmbd/transport_rdma.c
>>> @@ -62,13 +62,13 @@ static int smb_direct_receive_credit_max = 255;
>>>   static int smb_direct_send_credit_target = 255;
>>>
>>>   /* The maximum single message size can be sent to remote peer */
>>> -static int smb_direct_max_send_size = 8192;
>>> +static int smb_direct_max_send_size = 1364;
>>>
>>>   /*  The maximum fragmented upper-layer payload receive size supported
>>> */
>>>   static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
>>>
>>>   /*  The maximum single-message size which can be received */
>>> -static int smb_direct_max_receive_size = 8192;
>>> +static int smb_direct_max_receive_size = 1364;
>> Can I know what value windows server set to ?
>>
>> I can see the following settings for them in MS-SMBD.pdf
>> Connection.MaxSendSize is set to 1364.
>> Connection.MaxReceiveSize is set to 8192.
>
> Glad you asked, it's an interesting situation IMO.
>
> In MS-SMBD, the following are documented as behavior notes:
>
> Client-side (active connect):
>   Connection.MaxSendSize is set to 1364.
>   Connection.MaxReceiveSize is set to 8192.
>
> Server-side (passive listen):
>   Connection.MaxSendSize is set to 1364.
>   Connection.MaxReceiveSize is set to 8192.
>
> However, these are only the initial values. During SMBD
> negotiation, the two sides adjust downward to the other's
> maximum. Therefore, Windows connecting to Windows will use
> 1364 on both sides.
>
> In cifs and ksmbd, the choices were messier:
>
> Client-side smbdirect.c:
>   int smbd_max_send_size = 1364;
>   int smbd_max_receive_size = 8192;
>
> Server-side transport_rdma.c:
>   static int smb_direct_max_send_size = 8192;
>   static int smb_direct_max_receive_size = 8192;
>
> Therefore, peers connecting to ksmbd would typically end up
> negotiating 1364 for send and 8192 for receive.
>
> There is almost no good reason to use larger buffers. Because
> RDMA is highly efficient, and the smbdirect protocol trivially
> fragments longer messages, there is no significant performance
> penalty.
>
> And, because not many SMB3 messages require 8192 bytes over
> smbdirect, it's a colossal waste of virtually contiguous kernel
> memory to allocate 8192 to all receives.
>
> By setting all four to the practical reality of 1364, it's a
> consistent and efficient default, and aligns Linux smbdirect
> with Windows.
Thanks for your detailed explanation!  Agree to set both to 1364 by
default, Is there any usage to increase it? I wonder if users need any
configuration parameters to adjust them.

>
> Tom.
>
>>
>> Why does the specification describe setting it to 8192?
>>>
>>>   static int smb_direct_max_read_write_size = SMBD_DEFAULT_IOSIZE;
>>>
>>> --
>>> 2.34.1
>>>
>>>
>>
>
