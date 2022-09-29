Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13071C07E9D
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 05:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbiI2FCq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 01:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbiI2FCl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 01:02:41 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782681257B7
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 22:02:40 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id a14so80278uat.13
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 22:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ewaDed2THPemAQTLc536e2M33C8Y8T46PSx7UEqLrlw=;
        b=RJeA2wz3gtjCfne2TfheHL2nLjB/7Gk+dAVgZHse7ZoGGcttkx+cE4fgzGCB+VmAuQ
         tZo+1G3txb59pQj8/Q6n4fn1D2qk8QrGsgsl4Uy3ZbwfQllhIglb2PZrArVgMDTNLJ+V
         bhtvq9aqGF2qwydws4b+c2Qy/bhsyVEPkBZm189VijGD3m1cv8jsD32btVDWzie+lFGG
         B3vkXbQfhewbn9Nyy0oMh5DkBWo5sQX18/n1gs65k7HMd580LESgc0G30ggeAkrs5kSp
         qILFPngMWOta7tKuVoguMhKINHdUZKgddTThEf6N9FHh/SPOHStp40LbeiPHpiFsXG2M
         /epw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ewaDed2THPemAQTLc536e2M33C8Y8T46PSx7UEqLrlw=;
        b=mTF5oBnP7uBhYG93gYuo6E4B4Hch6tMZYsrMUvWv9hziYUmrzzZKZwePFJDu1thOYU
         lNWS7WfeuZhScke4qTgcy6RzaU3NmmK+Q0D9WslVOv6SwQmlUbFaRIeJ+f11zgl99D1R
         Ylhjpbqyqn4kyL4ty1YJcsSjKHFlMBUKdmidD+zEIEn0bmq7MdyNshpxU5EWRKzwXPu6
         iFRzDQPSOO1FxR9EiW+E2qkLsyP4orO1y/2XNRqYvcHKTTgaj1C+dRgHq2UTLO8txfzp
         RrZ4sg9t8QCBR1X1pxHJJSCMjvRtWCrzLeT66eLxH/r1+/bmGA1Eei8uNbo2Fw+o99lC
         QEew==
X-Gm-Message-State: ACrzQf09XGYv6I78sY4GM/34Y3VVTefBuRRNN9YOqBLHtirRjZtkM2dY
        ItOoiJ7vpLvin5vcgFtperzBd3XhK2HlPTtz4CY=
X-Google-Smtp-Source: AMsMyM6zzRJyG6TpLaEpmknQiqvbMe6zJWZizR1Rg7T0CU7g5PWEW8IphxilsgCuMKfboAF0etETfcF73gN4CK94gT4=
X-Received: by 2002:ab0:2245:0:b0:3af:631f:6508 with SMTP id
 z5-20020ab02245000000b003af631f6508mr695931uan.84.1664427759405; Wed, 28 Sep
 2022 22:02:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1663961449.git.tom@talpey.com>
In-Reply-To: <cover.1663961449.git.tom@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 29 Sep 2022 00:02:28 -0500
Message-ID: <CAH2r5msZ85dBBU=rPyzgBOPJmMrJ2ACCG+DhrJJprvDJcr9QPg@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Reduce SMBDirect RDMA SGE counts and sizes
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, linkinjeon@kernel.org,
        senozhatsky@chromium.org, bmt@zurich.ibm.com, longli@microsoft.com,
        dhowells@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged patches 1, 3, 5, 6 of this series into cifs-2.6.git for-next
(will let Namjae test/try the server patches, 2 and 4) pending
additional testing.

Let me know if any Reviewed-by to add

On Fri, Sep 23, 2022 at 4:54 PM Tom Talpey <tom@talpey.com> wrote:
>
> Allocate fewer SGEs and standard packet sizes in both kernel SMBDirect
> implementations.
>
> The current maximum values (16 SGEs and 8192 bytes) cause failures on the
> SoftiWARP provider, and are suboptimal on others. Reduce these to 6 and
> 1364. Additionally, recode smbd_send() to work with as few as 2 SGEs,
> and for debug sanity, reformat client-side logging to more clearly show
> addresses, lengths and flags in the appropriate base.
>
> Tested over SoftiWARP and SoftRoCE with shell, Connectathon basic and general.
>
> v2: correct an uninitialized value issue found by Coverity
>
> Tom Talpey (6):
>   Decrease the number of SMB3 smbdirect client SGEs
>   Decrease the number of SMB3 smbdirect server SGEs
>   Reduce client smbdirect max receive segment size
>   Reduce server smbdirect max send/receive segment sizes
>   Handle variable number of SGEs in client smbdirect send.
>   Fix formatting of client smbdirect RDMA logging
>
>  fs/cifs/smbdirect.c       | 227 ++++++++++++++++----------------------
>  fs/cifs/smbdirect.h       |  14 ++-
>  fs/ksmbd/transport_rdma.c |   6 +-
>  3 files changed, 109 insertions(+), 138 deletions(-)
>
> --
> 2.34.1
>


-- 
Thanks,

Steve
