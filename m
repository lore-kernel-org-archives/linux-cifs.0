Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 677EAC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 24 May 2022 01:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiEXBCH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 May 2022 21:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiEXBCH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 May 2022 21:02:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9719986F4
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 18:02:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2FADB811A6
        for <linux-cifs@vger.kernel.org>; Tue, 24 May 2022 01:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43C9C34116
        for <linux-cifs@vger.kernel.org>; Tue, 24 May 2022 01:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653354120;
        bh=1kPOUIT/H71tTd1aDxosQihBIEsW0eGZ5QWv72yhBEg=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=pF/BTYrZKhT3qsYn+sPdFMbEedCH1pCBMjW5nFfGWWk+bnQJciA1y3yo6yVwULaSJ
         eQ3GAgzSlAEJCZP2DN8fhLrjy1a2ocE21RCTmowgbd+BvWu1D98uE5PlaVhSeFblyM
         1kymrIfmXrhWgkAd4UsTOdeRlMq6bXIT2sBc+zKUW1dY3FlP8xZdWTSwW5+wZTifAm
         CKY/7DoJbMhAdkMXvouIYT63XMFVjZefhCIgWkW083rc9NfzUbyv57KUiGg06IB0te
         wYXEZ8Xa9xREK6xcyH4rq5hG7d3BwR9pfBIPOxn3xWorQyNIDK9t7WVQhnARCN8Zuz
         aWGfQj568ihHQ==
Received: by mail-wm1-f49.google.com with SMTP id n124-20020a1c2782000000b003972dfca96cso512657wmn.4
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 18:02:00 -0700 (PDT)
X-Gm-Message-State: AOAM532HYVsWbCVarl+A7h5ntmfTbC0g13MTUE+sDX+QMx5YZwaLAI3H
        Z9x9Rug0Ck8eiM+IMv6StuFZGRZNMAY3TPFdwGg=
X-Google-Smtp-Source: ABdhPJyjkBeYbE6kiTt4tktWTkHXYzYl4awg944bn4NN9pL2XtVGzX6An7Hbo8h4rdZp/N8gtynOfAG8kmuiRBzp/5U=
X-Received: by 2002:a05:600c:3512:b0:394:7c3b:53c0 with SMTP id
 h18-20020a05600c351200b003947c3b53c0mr1392357wmq.170.1653354118977; Mon, 23
 May 2022 18:01:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:f344:0:0:0:0:0 with HTTP; Mon, 23 May 2022 18:01:58
 -0700 (PDT)
In-Reply-To: <PH7PR21MB326344B83D7B4300683D2CEACED49@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com>
 <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
 <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
 <84589.1653070372@warthog.procyon.org.uk> <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
 <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com>
 <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com> <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com>
 <307f1f2c-900b-8158-78a8-a3dd7564f2f8@talpey.com> <PH7PR21MB326344B83D7B4300683D2CEACED49@PH7PR21MB3263.namprd21.prod.outlook.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 24 May 2022 10:01:58 +0900
X-Gmail-Original-Message-ID: <CAKYAXd861-sVicu3L-7QdctEZYfDtV5p=1t5E=gpr3e2Y3s2dQ@mail.gmail.com>
Message-ID: <CAKYAXd861-sVicu3L-7QdctEZYfDtV5p=1t5E=gpr3e2Y3s2dQ@mail.gmail.com>
Subject: Re: RDMA (smbdirect) testing
To:     Long Li <longli@microsoft.com>
Cc:     tom <tom@talpey.com>, David Howells <dhowells@redhat.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-05-24 4:17 GMT+09:00, Long Li <longli@microsoft.com>:
>> Subject: Re: RDMA (smbdirect) testing
>>
>> On 5/23/2022 11:05 AM, Namjae Jeon wrote:
>> > 2022-05-23 22:45 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> >> On 5/22/2022 7:06 PM, Namjae Jeon wrote:
>> >>> 2022-05-21 20:54 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> >>>> ...
>> >>>> Why does the code require
>> >>>> 16 sge's, regardless of other size limits? Normally, if the lower
>> >>>> layer supports fewer, the upper layer will simply reduce its
>> >>>> operation sizes.
>> >>> This should be answered by Long Li. It seems that he set the
>> >>> optimized value for the NICs he used to implement RDMA in cifs.
>> >>
>> >> "Optimized" is a funny choice of words. If the provider doesn't
>> >> support the value, it's not much of an optimization to insist on 16.
>> >> :)
>> > Ah, It's obvious that cifs haven't been tested with soft-iWARP. And
>> > the same with ksmbd...
>> >>
>> >> Personally, I'd try building a kernel with smbdirect.h changed to
>> >> have SMBDIRECT_MAX_SGE set to 6, and see what happens. You might have
>> >> to reduce the r/w sizes in mount, depending on any other issues this
>> >> may reveal.
>> > Agreed, and ksmbd should also be changed as well as cifs for test. We
>> > are preparing the patches to improve this in ksmbd, rather than
>> > changing/building this hardcoding every time.
>>
>> So, the patch is just for this test, right? Because I don't think any
>> kernel-based
>> storage upper layer should ever need more than 2 or 3.
>> How many memory regions are you doing per operation? I would expect one
>> for
>> the SMB3 headers, and another, if needed, for data.
>> These would all be lmr-type and would not require actual new memreg's.
>>
>> And for bulk data, I would hope you're using fast-register, which takes a
>> different path and doesn't use the same sge's.
>>
>> Getting this right, and keeping things efficient both in SGE bookkeeping
>> as well
>> as memory registration efficiency, is the rocket science behind RDMA
>> performance and correctness. Slapping "16" or "6" or whatever isn't the
>> long-
>> term fix.
>
Hi Long,
> I found max_sge is extremely large on Mellanox hardware, but smaller on
> other iWARP hardware.
>
> Hardcoding it to 16 is certainly not a good choice. I think we should set it
> to the smaller value of 1) a predefined value (e.g. 8), and the 2) the
> max_sge the hardware reports.
Okay, Could you please send the patch for cifs.ko ?

Thanks.
>
> If the CIFS upper layer ever sends data with larger number of SGEs, the send
> will fail.
>
> Long
>
>>
>> Tom.
>>
>> > diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h index
>> > a87fca82a796..7003722ab004 100644
>> > --- a/fs/cifs/smbdirect.h
>> > +++ b/fs/cifs/smbdirect.h
>> > @@ -226,7 +226,7 @@ struct smbd_buffer_descriptor_v1 {
>> >   } __packed;
>> >
>> >   /* Default maximum number of SGEs in a RDMA send/recv */
>> > -#define SMBDIRECT_MAX_SGE      16
>> > +#define SMBDIRECT_MAX_SGE      6
>> >   /* The context for a SMBD request */
>> >   struct smbd_request {
>> >          struct smbd_connection *info; diff --git
>> > a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c index
>> > e646d79554b8..70662b3bd590 100644
>> > --- a/fs/ksmbd/transport_rdma.c
>> > +++ b/fs/ksmbd/transport_rdma.c
>> > @@ -42,7 +42,7 @@
>> >   /* SMB_DIRECT negotiation timeout in seconds */
>> >   #define SMB_DIRECT_NEGOTIATE_TIMEOUT           120
>> >
>> > -#define SMB_DIRECT_MAX_SEND_SGES               8
>> > +#define SMB_DIRECT_MAX_SEND_SGES               6
>> >   #define SMB_DIRECT_MAX_RECV_SGES               1
>> >
>> >   /*
>> >
>> > Thanks!
>> >>
>> >> Tom.
>> >>
>> >
>
