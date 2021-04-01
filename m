Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C04FC433B4
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 18:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B922601FC
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 18:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236548AbhDAS1d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Apr 2021 14:27:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238943AbhDASPC (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 1 Apr 2021 14:15:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B31BA60201;
        Thu,  1 Apr 2021 12:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617281004;
        bh=yyNunJJ9vwsjcwxSSeO7R2Ald/KrcIYbdhHs0SKoAUk=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=H5lBHcDcEQ/UeUIXFUq8bHXhmJnBvHxi8mFODJ+iNXl0TnRJ0fE3ql4ndlyd5VtfU
         pG5mTdIe5U70gOs+GnNa5pZgv5nlsVepeX1qFyt0KJzDFx1hBVnpy5oMLai10UyZHe
         3znDisibKXJJ0u0ZJqasRrv3eXAGFFXFCvCfQBTttrI0Tm2hMkn6jH5xOsyeTKy3xa
         G3C5PUJgyaexyaKL038miwgf6lWJzFlMKH4SBd+5AQpIJXSCBKNCoKYsld8E/qlKhl
         mFPvuk/jfJH3OvHEJCCT1u5MdNZn4RmSDjxqsFnvVo6fyWu3r2Prh5GL8uc1GuAlc+
         MNUs90Gh5EIuQ==
Received: by mail-oi1-f178.google.com with SMTP id v25so1635453oic.5;
        Thu, 01 Apr 2021 05:43:24 -0700 (PDT)
X-Gm-Message-State: AOAM531JG9rXAVkjpGhfzvPha0aeAIKqTViR8TIHLKrN29U9nC33fvQk
        F8N3NAgLtjb4iyenNXx+OHFN9IdrqbIVtiy1e1Y=
X-Google-Smtp-Source: ABdhPJxlywyrnW420vopXXg00ijcwddFP7MuJght1M2waEhnEBEg1W9TknhKwiq/ATWSxcRr43Di3ijNtCjaGOkqopo=
X-Received: by 2002:a05:6808:f12:: with SMTP id m18mr5526660oiw.62.1617281004013;
 Thu, 01 Apr 2021 05:43:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:5ed4:0:0:0:0:0 with HTTP; Thu, 1 Apr 2021 05:43:23 -0700 (PDT)
In-Reply-To: <20210401115008.GS2088@kadam>
References: <20210401113933.GA2828895@LEGION> <20210401115008.GS2088@kadam>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 1 Apr 2021 21:43:23 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-ou4-jf7_8xa4jDQ_otyQ9ffKhwD7WZrmrna1P3b_W8Q@mail.gmail.com>
Message-ID: <CAKYAXd-ou4-jf7_8xa4jDQ_otyQ9ffKhwD7WZrmrna1P3b_W8Q@mail.gmail.com>
Subject: Re: [Linux-cifsd-devel] [PATCH] cifsd: use kfree to free memory
 allocated by kzalloc
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Muhammad Usama Anjum <musamaanjum@gmail.com>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifs@vger.kernel.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>,
        kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>, colin.king@canonical.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-04-01 20:50 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> On Thu, Apr 01, 2021 at 04:39:33PM +0500, Muhammad Usama Anjum wrote:
>> kfree should be used to free memory allocated by kzalloc to avoid
>> any overhead and for maintaining consistency.
>>
>> Fixes: 5dfeb6d945 ("cifsd: use kmalloc() for small allocations")
>> Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
>> ---
>> This one place was left in earlier patch. I've already received
>> responsse on that patch. I'm sending a separate patch.
>>
>>  fs/cifsd/transport_tcp.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/cifsd/transport_tcp.c b/fs/cifsd/transport_tcp.c
>> index 67163efcf472..040881893417 100644
>> --- a/fs/cifsd/transport_tcp.c
>> +++ b/fs/cifsd/transport_tcp.c
>> @@ -551,7 +551,7 @@ void ksmbd_tcp_destroy(void)
>>  	list_for_each_entry_safe(iface, tmp, &iface_list, entry) {
>>  		list_del(&iface->entry);
>>  		kfree(iface->name);
>> -		ksmbd_free(iface);
>> +		kfree(iface);
>
> We should just delete the ksmbd_free() function completely.
Yes, I have added your review comment about this to my todo-list.
I will do that.
>
> I think that cifsd is being re-written though so it might not be worth
> it.
Right.
Thanks!
>
> regards,
> dan carpenter
>
>
> _______________________________________________
> Linux-cifsd-devel mailing list
> Linux-cifsd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-cifsd-devel
>
