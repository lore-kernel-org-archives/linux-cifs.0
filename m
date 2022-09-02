Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04693C6FA8F
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Sep 2022 15:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbiIBPPw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Sep 2022 11:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236409AbiIBPPc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 2 Sep 2022 11:15:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390764333D
        for <linux-cifs@vger.kernel.org>; Fri,  2 Sep 2022 07:47:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 355C861732
        for <linux-cifs@vger.kernel.org>; Fri,  2 Sep 2022 14:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C61BC433C1
        for <linux-cifs@vger.kernel.org>; Fri,  2 Sep 2022 14:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662130033;
        bh=dQpkKtUxp10l09+3SexlkrIxFZH+TQLFA8wV2Iw+hTM=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=vBJuASqJqcKuBKfgFLTLo9d78AMxLoznPoUuEvawOfMWiXs10GID7CAVXhEnR6ogu
         Gofc3HSNXI8Lgtmf9ChqHLQJyLcp+U/U01qKk/YwXBYs+CxAfgk6kmrG0esRV5gV2R
         ZxyU1z/bmQFdqimEE4/N+/a5aWkifaxB7wW1IAhXXN7JOQUOaqCVY/eSVhxu4uh7hC
         0saI2zlLaPTPAMeU7n4Ewp5NIkkSbtuxU1EefxPG7R1fG1BrBQ6K6Vdlu/ucucMrC+
         GYM1msKOHQs7QEHG5BvSuNFZOrD2H3/9aw9KHA2ACUgBx5sSmH0PeS6MVTcwdZX6uW
         HpRcDLYgwTFoQ==
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-11e9a7135easo5228358fac.6
        for <linux-cifs@vger.kernel.org>; Fri, 02 Sep 2022 07:47:13 -0700 (PDT)
X-Gm-Message-State: ACgBeo3b+t69sehYeL0izg8NGLg5Cre/G1fQymejtqnbOCFJJ3CffVN+
        4tHFZsO86M6TRyS3zWCP0qatkF9fHGJvEgcA+fQ=
X-Google-Smtp-Source: AA6agR6vBDX/R+UZGFhiQKf8A+COjg73boAaVbHdXQdiasQLQS2tggz5Ldbd1ZGo2NAb+6rWGrj7ctcBPv5IH/FwjHc=
X-Received: by 2002:a05:6870:f69d:b0:10d:81ea:3540 with SMTP id
 el29-20020a056870f69d00b0010d81ea3540mr2461092oab.257.1662130032782; Fri, 02
 Sep 2022 07:47:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Fri, 2 Sep 2022 07:47:12
 -0700 (PDT)
In-Reply-To: <6cf00762-f446-490c-5e88-79382962e985@talpey.com>
References: <20220901142413.3351804-1-zhangxiaoxu5@huawei.com>
 <20220901142413.3351804-3-zhangxiaoxu5@huawei.com> <6cf00762-f446-490c-5e88-79382962e985@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 2 Sep 2022 23:47:12 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_FioX1ivG_cv=QTehaTw0ecAQA_-H0Y13Aqbaq=hB=Zg@mail.gmail.com>
Message-ID: <CAKYAXd_FioX1ivG_cv=QTehaTw0ecAQA_-H0Y13Aqbaq=hB=Zg@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] ksmbd: Remove the wrong message length check of FSCTL_VALIDATE_NEGOTIATE_INFO
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com,
        hyc.lee@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-02 22:28 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/1/2022 10:24 AM, Zhang Xiaoxu wrote:
>> The struct validate_negotiate_info_req change from variable-length array
>> to reguler array, but the message length check is unchanged.
>>
>> The fsctl_validate_negotiate_info() already check the message length, so
>> remove it from smb2_ioctl().
>>
>> Fixes: c7803b05f74b ("smb3: fix ksmbd bigendian bug in oplock break, and
I think the fixes tag is wrong. Isn't the below correct?
Fixes: f7db8fd03a4bc ("ksmbd: add validation in smb2_ioctl")

>> move its struct to smbfs_common")
>> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>> Cc: <stable@vger.kernel.org>
>> ---
>>   fs/ksmbd/smb2pdu.c | 3 ---
>>   1 file changed, 3 deletions(-)
>>
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index c49f65146ab3..c9f400bbb814 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -7640,9 +7640,6 @@ int smb2_ioctl(struct ksmbd_work *work)
>>   			goto out;
>>   		}
>>
>> -		if (in_buf_len < sizeof(struct validate_negotiate_info_req))
>> -			return -EINVAL;
>> -
>
> This actually fixes a different bug, which the comment needs to mention.
> The structure size includes 4 dialect slots, but the protocol does not
> require the client to send all 4. So this allows the negotiation to not
> fail. Which is good.
>
> But there are two other issues now.
>
> 1) The code no longer checks that a complete validate negotiate header
> is present before dereferencing neg_req->DialectCount. This code will
> fetch the DialectCount potentially beyond the end of an invalid short
> packet:
>
>    fsctl_validate_negotiate_info():
>
>          if (in_buf_len < offsetof(struct validate_negotiate_info_req,
> Dialects) +
>                          le16_to_cpu(neg_req->DialectCount) *
> sizeof(__le16))
>                  return -EINVAL;
>
>          dialect = ksmbd_lookup_dialect_by_id(neg_req->Dialects,
>                                               neg_req->DialectCount);
>
> 2) The DialectCount is an le16, which can be negative. A small invalid
> negative value may pass this test and proceed to process the array,
> which would be bad. This is an existing issue, but should be fixed
> since you now need to correct the test anyway.
>
> Tom.
>
>
>>   		if (out_buf_len < sizeof(struct validate_negotiate_info_rsp))
>>   			return -EINVAL; >
>
