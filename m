Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F793CCA47F
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jun 2022 01:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237394AbiFHBrM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Jun 2022 21:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388812AbiFHBp3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Jun 2022 21:45:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B439048988F
        for <linux-cifs@vger.kernel.org>; Tue,  7 Jun 2022 15:25:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D1B060B8B
        for <linux-cifs@vger.kernel.org>; Tue,  7 Jun 2022 22:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AA8C385A2
        for <linux-cifs@vger.kernel.org>; Tue,  7 Jun 2022 22:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654640709;
        bh=dviWhJj2Mm4JPkRNfHbwKWbYKcrkxVa+86C25Iu55ag=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=NZYo2xFoyiLPhOusaTQ5zNPB9ce499KjBFgrWy02XqgcFAvUsVsKeU4u2B4umc+Ab
         Jkoux2AUA+ufC5REgBR5ZB5RvR1klokmG//qHtvHZxrHuJu93JVh3Eu1DfEa+vqYTy
         phzKK092NIMdlbL5T1ztccH0JR8SiI/m3aBtv7pzqbHc3SHCb3KQ0+IHi4EPI+On+9
         ovXtsik8mpTzslvs4HFeW1SIW8l+SfCTTONmtigR8VhKBO1LD34xCp+RewX5c430pm
         NuUAGy+pbA9nfGrbDCrp7zW7YbCP1kv0hYg3cKvfmgmO1GvuBuP/lMvTg2IMyb1r+x
         +NyoxyQUNbilQ==
Received: by mail-wr1-f54.google.com with SMTP id p10so25937642wrg.12
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jun 2022 15:25:09 -0700 (PDT)
X-Gm-Message-State: AOAM533dqgWea0Xe5tT4N/1yRcZD5cBTRx7/bQXQCMBNu0ohetzKT/CK
        wg7GuPqDpiCAkFW4tPSw+N50WZTuTArz1ED5NPY=
X-Google-Smtp-Source: ABdhPJyib9CvYxfLBJN8hnj3Cf76g3osJy59toBNcC483aYugZkcjpp47n1Ny3ZgKaGyN6ywTVUZMPekrWBAjL603fQ=
X-Received: by 2002:a5d:4a85:0:b0:215:ae89:5925 with SMTP id
 o5-20020a5d4a85000000b00215ae895925mr21156921wrq.401.1654640707954; Tue, 07
 Jun 2022 15:25:07 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:4c4a:0:0:0:0:0 with HTTP; Tue, 7 Jun 2022 15:25:06 -0700 (PDT)
In-Reply-To: <82a4f87f-202f-2032-1380-8d58c6af9761@talpey.com>
References: <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com>
 <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
 <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
 <84589.1653070372@warthog.procyon.org.uk> <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
 <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com>
 <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com> <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com>
 <307f1f2c-900b-8158-78a8-a3dd7564f2f8@talpey.com> <PH7PR21MB326344B83D7B4300683D2CEACED49@PH7PR21MB3263.namprd21.prod.outlook.com>
 <CAKYAXd861-sVicu3L-7QdctEZYfDtV5p=1t5E=gpr3e2Y3s2dQ@mail.gmail.com>
 <PH7PR21MB3263E3978006A32714AE5357CED79@PH7PR21MB3263.namprd21.prod.outlook.com>
 <CAKYAXd9SZQPkxO9TshgbHGbwzaDN1Hz6dhT-pNDYpD3icjB4HA@mail.gmail.com>
 <PH7PR21MB32638DEF77D5B541B3F0858CCEA19@PH7PR21MB3263.namprd21.prod.outlook.com>
 <82a4f87f-202f-2032-1380-8d58c6af9761@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 8 Jun 2022 07:25:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9ep83U_pjbvzA+tM75sg2bn2x7kvxNn1gXe0=_-dm5Gw@mail.gmail.com>
Message-ID: <CAKYAXd9ep83U_pjbvzA+tM75sg2bn2x7kvxNn1gXe0=_-dm5Gw@mail.gmail.com>
Subject: Re: RDMA (smbdirect) testing
To:     Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>
Cc:     David Howells <dhowells@redhat.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-06-08 2:26 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 6/2/2022 8:07 PM, Long Li wrote:
>>> Long, My Chelsio(iWARP) NIC reports this value as 4. When I set it with
>>> hw
>>> report value in cifs.ko, There is kernel oops in cifs.ko. Have you
>>> checked smb-
>>> direct of cifs.ko with Chelsio and any iWARP NICs before ? or only
>>> Mellanox
>>> NICs ?
>>>
>>> Thanks!
>>
>> Yes, I have tested on Chelsio. I didn't see kernel panic. In fact, I can
>> pass a larger value (8) and successfully create a QP on Chelsio.
>
> There are many generations of Chelsio RDMA adapters, and this number
> is very likely to be different. You both should be sure you're testing
> with multiple configurations (and don't forget all the other in-kernel
> RDMA NICs). But a constant value of "8" is still arbitrary.
>
> The kernel should definitely not throw an oops when the NIC doesn't
> support some precompiled constant value. Namjae, what oops, exactly?
Sorry for noise, This is not cifs.ko issue(with max sge 8). There
seems to be some issue in chelsio driver(cxgb4) on the latest kernel.
I have reported this issue to chelsio maintainers.
They was already aware of this problem and are trying to fix it. When
I checked again on linux-5.15, there was no problem. I am going to
send a reply about this mail after checking it with cxgb4 patch on the
latest kernel, It has not been fixed yet, still waiting for the patch
from them.

Thanks!
>
> Tom.
>
>> Can you paste your kernel panic trace?
>>
>>>>>> If the CIFS upper layer ever sends data with larger number of SGEs,
>>>>>> the send will fail.
>>>>>>
>>>>>> Long
>>>>>>
>>>>>>>
>>>>>>> Tom.
>>>>>>>
>>>>>>>> diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h index
>>>>>>>> a87fca82a796..7003722ab004 100644
>>>>>>>> --- a/fs/cifs/smbdirect.h
>>>>>>>> +++ b/fs/cifs/smbdirect.h
>>>>>>>> @@ -226,7 +226,7 @@ struct smbd_buffer_descriptor_v1 {
>>>>>>>>    } __packed;
>>>>>>>>
>>>>>>>>    /* Default maximum number of SGEs in a RDMA send/recv */
>>>>>>>> -#define SMBDIRECT_MAX_SGE      16
>>>>>>>> +#define SMBDIRECT_MAX_SGE      6
>>>>>>>>    /* The context for a SMBD request */
>>>>>>>>    struct smbd_request {
>>>>>>>>           struct smbd_connection *info; diff --git
>>>>>>>> a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c index
>>>>>>>> e646d79554b8..70662b3bd590 100644
>>>>>>>> --- a/fs/ksmbd/transport_rdma.c
>>>>>>>> +++ b/fs/ksmbd/transport_rdma.c
>>>>>>>> @@ -42,7 +42,7 @@
>>>>>>>>    /* SMB_DIRECT negotiation timeout in seconds */
>>>>>>>>    #define SMB_DIRECT_NEGOTIATE_TIMEOUT           120
>>>>>>>>
>>>>>>>> -#define SMB_DIRECT_MAX_SEND_SGES               8
>>>>>>>> +#define SMB_DIRECT_MAX_SEND_SGES               6
>>>>>>>>    #define SMB_DIRECT_MAX_RECV_SGES               1
>>>>>>>>
>>>>>>>>    /*
>>>>>>>>
>>>>>>>> Thanks!
>>>>>>>>>
>>>>>>>>> Tom.
>>>>>>>>>
>>>>>>>>
>>>>>>
>>>>
>
