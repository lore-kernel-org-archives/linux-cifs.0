Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D745C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 24 May 2022 00:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbiEXA7d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 May 2022 20:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiEXA7c (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 May 2022 20:59:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F19B95A3F
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 17:59:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8677B811A6
        for <linux-cifs@vger.kernel.org>; Tue, 24 May 2022 00:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0B3C36AE5
        for <linux-cifs@vger.kernel.org>; Tue, 24 May 2022 00:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653353968;
        bh=CUyyTvQk6lFCACaIqWtxRVRi5AgJ4HeaWPISrEu/fgE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=GTZjWtxrjOJr+RQHEFn1P5yJSkDVl67NZ8iDhwF+AakcDJe450Qd6YwXcuURlh9dY
         rvbgWPv3M9DoGGl8RPrWNfdG9GCo7gpsf16v61usJFSvqB65b4hlAeWISSGD1Ejdnp
         fiZVYlAihoJHkP1QVGfadRPQM3PV5cZUm4nfN+s7+7+408Vdn/5u+b9P63qz80AODI
         4vX/9Fp/LUR3o2obY/y+Ywq5emwgiIX9qlV/1IPBnXvNioBTmF8UPt9Vv5cdXxvOAv
         WGW9R1owLH0ZD+/F2L3N3rjt1eM7D08U94L3ucywTlg/iRMu4X1VzQuG8auOmXdB+W
         mAxEUduCia0aA==
Received: by mail-wr1-f51.google.com with SMTP id t13so4376746wrg.9
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 17:59:28 -0700 (PDT)
X-Gm-Message-State: AOAM530kzBcqpHQR8R0gfjpQKU+Kc6psmgOcIUkOfZ+EA4dOddVQbM0w
        3oOXJ9pC2th6CO1Gsx40IrBvHCY5ZehPyugCvuU=
X-Google-Smtp-Source: ABdhPJzwXUIKUOg+5qwWwXzMkPsyBmRSzawjFdxnO7ysJqreFP4er2/VNZbN/5ZllwKAWyfpufarUDPY9Va+g4u78rw=
X-Received: by 2002:adf:f012:0:b0:20d:80e:1170 with SMTP id
 j18-20020adff012000000b0020d080e1170mr20070595wro.401.1653353966924; Mon, 23
 May 2022 17:59:26 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:f344:0:0:0:0:0 with HTTP; Mon, 23 May 2022 17:59:26
 -0700 (PDT)
In-Reply-To: <307f1f2c-900b-8158-78a8-a3dd7564f2f8@talpey.com>
References: <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com>
 <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
 <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
 <84589.1653070372@warthog.procyon.org.uk> <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
 <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com>
 <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com> <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com>
 <307f1f2c-900b-8158-78a8-a3dd7564f2f8@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 24 May 2022 09:59:26 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_vR869sdLsEEJ_GQ0t22GSMBLt21m6Y=Rk4xDSHsiVkQ@mail.gmail.com>
Message-ID: <CAKYAXd_vR869sdLsEEJ_GQ0t22GSMBLt21m6Y=Rk4xDSHsiVkQ@mail.gmail.com>
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

2022-05-24 1:05 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 5/23/2022 11:05 AM, Namjae Jeon wrote:
>> 2022-05-23 22:45 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>> On 5/22/2022 7:06 PM, Namjae Jeon wrote:
>>>> 2022-05-21 20:54 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>>>> ...
>>>>> Why does the code require
>>>>> 16 sge's, regardless of other size limits? Normally, if the lower
>>>>> layer
>>>>> supports fewer, the upper layer will simply reduce its operation
>>>>> sizes.
>>>> This should be answered by Long Li. It seems that he set the optimized
>>>> value for the NICs he used to implement RDMA in cifs.
>>>
>>> "Optimized" is a funny choice of words. If the provider doesn't support
>>> the value, it's not much of an optimization to insist on 16. :)
>> Ah, It's obvious that cifs haven't been tested with soft-iWARP. And
>> the same with ksmbd...
>>>
>>> Personally, I'd try building a kernel with smbdirect.h changed to have
>>> SMBDIRECT_MAX_SGE set to 6, and see what happens. You might have to
>>> reduce the r/w sizes in mount, depending on any other issues this may
>>> reveal.
>> Agreed, and ksmbd should also be changed as well as cifs for test. We
>> are preparing the patches to improve this in ksmbd, rather than
>> changing/building this hardcoding every time.
>
> So, the patch is just for this test, right?
Yes.
> Because I don't think any
> kernel-based storage upper layer should ever need more than 2 or 3.
> How many memory regions are you doing per operation? I would
> expect one for the SMB3 headers, and another, if needed, for data.
> These would all be lmr-type and would not require actual new memreg's.
Maximum 4. (smb transform header , smb3 header+ response, data,
smb-direct header)
>
> And for bulk data, I would hope you're using fast-register, which
> takes a different path and doesn't use the same sge's.
For bulk data, ksmbd already using it.
>
> Getting this right, and keeping things efficient both in SGE bookkeeping
> as well as memory registration efficiency, is the rocket science behind
> RDMA performance and correctness. Slapping "16" or "6" or whatever isn't
> the long-term fix.
Okay.
>
> Tom.
>
>> diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
>> index a87fca82a796..7003722ab004 100644
>> --- a/fs/cifs/smbdirect.h
>> +++ b/fs/cifs/smbdirect.h
>> @@ -226,7 +226,7 @@ struct smbd_buffer_descriptor_v1 {
>>   } __packed;
>>
>>   /* Default maximum number of SGEs in a RDMA send/recv */
>> -#define SMBDIRECT_MAX_SGE      16
>> +#define SMBDIRECT_MAX_SGE      6
>>   /* The context for a SMBD request */
>>   struct smbd_request {
>>          struct smbd_connection *info;
>> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
>> index e646d79554b8..70662b3bd590 100644
>> --- a/fs/ksmbd/transport_rdma.c
>> +++ b/fs/ksmbd/transport_rdma.c
>> @@ -42,7 +42,7 @@
>>   /* SMB_DIRECT negotiation timeout in seconds */
>>   #define SMB_DIRECT_NEGOTIATE_TIMEOUT           120
>>
>> -#define SMB_DIRECT_MAX_SEND_SGES               8
>> +#define SMB_DIRECT_MAX_SEND_SGES               6
>>   #define SMB_DIRECT_MAX_RECV_SGES               1
>>
>>   /*
>>
>> Thanks!
>>>
>>> Tom.
>>>
>>
>
