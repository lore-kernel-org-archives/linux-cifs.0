Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26A2C433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 22 May 2022 23:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242683AbiEVXG4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 22 May 2022 19:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiEVXGz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 22 May 2022 19:06:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DFD220F7
        for <linux-cifs@vger.kernel.org>; Sun, 22 May 2022 16:06:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 289E760F40
        for <linux-cifs@vger.kernel.org>; Sun, 22 May 2022 23:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850AEC36AE5
        for <linux-cifs@vger.kernel.org>; Sun, 22 May 2022 23:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653260813;
        bh=WfzbAzVM4yhmfa8AkBRKaXK6LOOF4lRrak11382+y2E=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=pnGhY//tPKNhutBPJMCd2sKk7c3iwzWhY+DtBb/DeGCdH0PIXqCJzJUCcgPQG67m9
         vP6YRfChik/AcdgwEPLhwbaNS+1suFGsp9ioTdNgsKsk5JaSZsroEch3R4A4/5h32V
         OZJZweAnsejjiqbjUpmW3lYIL5HJYNf9mOCFirqvnGllXiw7Y5vndQsnWELWC7AImq
         qV/r4cZWHz8d/HAVu8VUwH/kPuVMEoHceqRl0DsvLvPZyFnF7EzvcQ47V6LF9NzlUq
         HaGpLP390wP+blat1UwlRLMY93hZEw8Mg1/Url8zFB951wOIm9JZ544IyxBofGbJgp
         sqH4ekreGhK/g==
Received: by mail-wr1-f46.google.com with SMTP id k30so18921778wrd.5
        for <linux-cifs@vger.kernel.org>; Sun, 22 May 2022 16:06:53 -0700 (PDT)
X-Gm-Message-State: AOAM530eEaGsiiIVSHwMv6MXeFpYpDemIekJzs1eJct4MTl0MiXEzbbw
        hy7nfC8N0j457atj81OPmFb0vtWjbcdlkwBqb8o=
X-Google-Smtp-Source: ABdhPJwj56Jnp26j8iWtNCIEc5qG16Bp2hj5u2rAbjTIwc6TC2T4hAKWUe2Nt5GdIEOYrvciHk5XlqVGX8uDyW/lECg=
X-Received: by 2002:adf:ee52:0:b0:20f:de1d:9fda with SMTP id
 w18-20020adfee52000000b0020fde1d9fdamr2000669wro.62.1653260811710; Sun, 22
 May 2022 16:06:51 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:f344:0:0:0:0:0 with HTTP; Sun, 22 May 2022 16:06:50
 -0700 (PDT)
In-Reply-To: <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
References: <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com>
 <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
 <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
 <84589.1653070372@warthog.procyon.org.uk> <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 23 May 2022 08:06:50 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com>
Message-ID: <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com>
Subject: Re: RDMA (smbdirect) testing
To:     Tom Talpey <tom@talpey.com>
Cc:     David Howells <dhowells@redhat.com>,
        Long Li <longli@microsoft.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-05-21 20:54 GMT+09:00, Tom Talpey <tom@talpey.com>:
>
> On 5/20/2022 2:12 PM, David Howells wrote:
>> Tom Talpey <tom@talpey.com> wrote:
>>
>>> SoftROCE is a bit of a hot mess in upstream right now. It's
>>> getting a lot of attention, but it's still pretty shaky.
>>> If you're testing, I'd STRONGLY recommend SoftiWARP.
>>
>> I'm having problems getting that working.  I'm setting the client up
>> with:
>>
>> rdma link add siw0 type siw netdev enp6s0
>> mount //192.168.6.1/scratch /xfstest.scratch -o rdma,user=shares,pass=...
>>
>> and then see:
>>
>> CIFS: Attempting to mount \\192.168.6.1\scratch
>> CIFS: VFS: _smbd_get_connection:1513 warning: device max_send_sge = 6 too
>> small
>> CIFS: VFS: _smbd_get_connection:1516 Queue Pair creation may fail
>> CIFS: VFS: _smbd_get_connection:1519 warning: device max_recv_sge = 6 too
>> small
>> CIFS: VFS: _smbd_get_connection:1522 Queue Pair creation may fail
>> CIFS: VFS: _smbd_get_connection:1559 rdma_create_qp failed -22
>> CIFS: VFS: _smbd_get_connection:1513 warning: device max_send_sge = 6 too
>> small
>> CIFS: VFS: _smbd_get_connection:1516 Queue Pair creation may fail
>> CIFS: VFS: _smbd_get_connection:1519 warning: device max_recv_sge = 6 too
>> small
>> CIFS: VFS: _smbd_get_connection:1522 Queue Pair creation may fail
>> CIFS: VFS: _smbd_get_connection:1559 rdma_create_qp failed -22
>> CIFS: VFS: cifs_mount failed w/return code = -2
>>
>> in dmesg.
>>
>> Problem is, I don't know what to do about it:-/
>
> It looks like the client is hardcoding 16 sge's, and has no option to
> configure a smaller value, or reduce its requested number. That's bad,
> because providers all have their own limits - and SIW_MAX_SGE is 6. I
> thought I'd seen this working (metze?), but either the code changed or
> someone built a custom version.
I also fully agree that we should provide users with the path to
configure this value.
>
> Namjae/Long, have you used siw successfully?
No. I was able to reproduce the same problem that David reported. I
and Hyunchul will take a look. I also confirmed that RDMA work well
without any problems with soft-ROCE. Until this problem is fixed, I'd
like to say David to use soft-ROCE.

> Why does the code require
> 16 sge's, regardless of other size limits? Normally, if the lower layer
> supports fewer, the upper layer will simply reduce its operation sizes.
This should be answered by Long Li. It seems that he set the optimized
value for the NICs he used to implement RDMA in cifs.
>
> Tom.
>
