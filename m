Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48EC8C4361A
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 17:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C48560FF3
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 17:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236945AbhDAR4H (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236997AbhDARuA (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 1 Apr 2021 13:50:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA71A611EE;
        Thu,  1 Apr 2021 12:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617281956;
        bh=3TI1EuLRPuxW83T74of5le/iuIR7ZM+AAKpIDXUTGuY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=etmUILOFF6pESIgyelf63J4doWIyp0lXP4ajOwTZGn3ySiwdu0jDMFMUgsFxpBXmm
         GLdEW2/7CQ/CqLVNDktPs2HRqo4A+A/tJNHCs2F0Bs/CV9F++uM+Zw8OtO4VPU4GLM
         LhAFtQbIO5X4aQC+WWSsVaIs7LVhMwubBd77272T7utGqgbaNBZVL6K8O3plI6FSFe
         2/utx2hrMPBI/ZbJgs5fk5pDJpXD+gJ/r5FwP/H5pXPMy/cYDNwY2QH1Ynq2AIuEp9
         pYPKb+nx8M6VWEEy3t4G/SiyYX1V8parXtUgxu1ogAcTRFBw6LCapgC0O/9s/VaX+y
         KDuD0VCyyxGDw==
Received: by mail-ot1-f46.google.com with SMTP id v24-20020a9d69d80000b02901b9aec33371so2043859oto.2;
        Thu, 01 Apr 2021 05:59:15 -0700 (PDT)
X-Gm-Message-State: AOAM530hH2umoVi6kCWLthNAttmIbf7OpmiH3XvDOmh4Om6njWV5H7MX
        cOdvv0KVGP5iCfPsKNBM0KY18HWv+1SWarZJzNk=
X-Google-Smtp-Source: ABdhPJwznrcoAV5FnaPD9IdAczoLlbDeiM99a3uS3N2n0WLAy4hk8QGAQMgtueYbLhn/uJuf1rhT+a1ewHX2ctgaM4I=
X-Received: by 2002:a9d:7854:: with SMTP id c20mr7182988otm.114.1617281955108;
 Thu, 01 Apr 2021 05:59:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:5ed4:0:0:0:0:0 with HTTP; Thu, 1 Apr 2021 05:59:14 -0700 (PDT)
In-Reply-To: <ca1b9b0c-55f9-025d-558b-1b2b6c866d12@samba.org>
References: <20210401113933.GA2828895@LEGION> <20210401115008.GS2088@kadam>
 <CAKYAXd-ou4-jf7_8xa4jDQ_otyQ9ffKhwD7WZrmrna1P3b_W8Q@mail.gmail.com> <ca1b9b0c-55f9-025d-558b-1b2b6c866d12@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 1 Apr 2021 21:59:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-ScM9i9Ln_FL8pWyEnPO_0n8t1BLH8MJ=b4NkqEbhZ=Q@mail.gmail.com>
Message-ID: <CAKYAXd-ScM9i9Ln_FL8pWyEnPO_0n8t1BLH8MJ=b4NkqEbhZ=Q@mail.gmail.com>
Subject: Re: [Linux-cifsd-devel] [PATCH] cifsd: use kfree to free memory
 allocated by kzalloc
To:     Ralph Boehme <slow@samba.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifs@vger.kernel.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>,
        kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>, colin.king@canonical.com,
        Muhammad Usama Anjum <musamaanjum@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-04-01 21:50 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Am 4/1/21 um 2:43 PM schrieb Namjae Jeon:
>> 2021-04-01 20:50 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
>>> On Thu, Apr 01, 2021 at 04:39:33PM +0500, Muhammad Usama Anjum wrote:
>>>> kfree should be used to free memory allocated by kzalloc to avoid
>>>> any overhead and for maintaining consistency.
>>>>
>>>> Fixes: 5dfeb6d945 ("cifsd: use kmalloc() for small allocations")
>>>> Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
>>>> ---
>>>> This one place was left in earlier patch. I've already received
>>>> responsse on that patch. I'm sending a separate patch.
>>>>
>>>>   fs/cifsd/transport_tcp.c | 2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/cifsd/transport_tcp.c b/fs/cifsd/transport_tcp.c
>>>> index 67163efcf472..040881893417 100644
>>>> --- a/fs/cifsd/transport_tcp.c
>>>> +++ b/fs/cifsd/transport_tcp.c
>>>> @@ -551,7 +551,7 @@ void ksmbd_tcp_destroy(void)
>>>>   	list_for_each_entry_safe(iface, tmp, &iface_list, entry) {
>>>>   		list_del(&iface->entry);
>>>>   		kfree(iface->name);
>>>> -		ksmbd_free(iface);
>>>> +		kfree(iface);
>>>
>>> We should just delete the ksmbd_free() function completely.
>> Yes, I have added your review comment about this to my todo-list.
>> I will do that.
>>>
>>> I think that cifsd is being re-written though so it might not be worth
>>> it.
>> Right.
>
> fwiw, while at it what about renaming everything that still references
> "cifs" to "smb" ? This is not the 90's... :)
It is also used with the name "ksmbd". So function and variable prefix
are used with ksmbd.

Thanks!
>
> Cheers!
> -slow
>
>
