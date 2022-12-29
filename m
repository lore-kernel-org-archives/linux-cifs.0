Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B0B4C3DA7D
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Dec 2022 09:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiL2Jmv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Dec 2022 04:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbiL2Jkm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Dec 2022 04:40:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCDB13EAA
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 01:40:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5220B81990
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 09:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57094C433F1
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 09:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672306838;
        bh=Dnj+2U+uCOIFE5f1f7/i29T39RqgbsSo7Fx/qkGOqZ8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=jzESyr5I9A/PW/onwuK0IglsU180ZJnfDGiG5hRiYp0lj/wnTfBZYZmcdDAF38w2m
         D7pQeHdn6MlXGc1HnrM7Ade7AhmqJpkQX6I3IIeN/e0UB02gPYRdCKZohVBB6XRDQ/
         DOg5a0O11zOgaGFasLBKaUs22LDkYkxXoeCZApH74FzF1pMlEqm3uDwlJ/PGtOu/CP
         dkBSor+wY0L44kEKm6E0WGS64UrTwVws8ns5ey7Lg+OzlNf/fN6AyplI84KIhD0JZc
         4AuhsvqIvL+7czL6qJnQpayBie4X/B+1TN0Pkxtd4APnNWBzDMVls3Z1rAdi3k0pxr
         pHjUvek1LJb4A==
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-1441d7d40c6so21170649fac.8
        for <linux-cifs@vger.kernel.org>; Thu, 29 Dec 2022 01:40:38 -0800 (PST)
X-Gm-Message-State: AFqh2kp91SCbtMIO1gsI5p6aNp1v46Hd64jMYMLHuRGQ/AuvDRNJfv6J
        dNvD2hs/ab5QkZJFiuK+7gK3qJE62dqmEel0Z5I=
X-Google-Smtp-Source: AMrXdXvci9w+vc58oCHxzA9Leru5HtHOSYNxUGKr3Y+rrt85Ll9T68kv1RPM151Vcn5HVbSL9SHcx1yXtRkHFRUIDEs=
X-Received: by 2002:a05:6870:d0d4:b0:13d:5167:43e3 with SMTP id
 k20-20020a056870d0d400b0013d516743e3mr2462075oaa.257.1672306837434; Thu, 29
 Dec 2022 01:40:37 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6838:2d06:0:0:0:0 with HTTP; Thu, 29 Dec 2022 01:40:36
 -0800 (PST)
In-Reply-To: <Y6z7cjj+OkkVYFYR@google.com>
References: <20221227145954.9663-1-linkinjeon@kernel.org> <Y6z7cjj+OkkVYFYR@google.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 29 Dec 2022 18:40:36 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8FJRO017i1BmguOEPcunyEv_LCu5AvyxW=4iWQh_1vrg@mail.gmail.com>
Message-ID: <CAKYAXd8FJRO017i1BmguOEPcunyEv_LCu5AvyxW=4iWQh_1vrg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: add max connections parameter
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com,
        atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-12-29 11:29 GMT+09:00, Sergey Senozhatsky <senozhatsky@chromium.org>:
> On (22/12/27 23:59), Namjae Jeon wrote:
> [..]
>>  	csin = KSMBD_TCP_PEER_SOCKADDR(KSMBD_TRANS(t)->conn);
>>  	if (kernel_getpeername(client_sk, csin) < 0) {
>> @@ -239,6 +243,17 @@ static int ksmbd_kthread_fn(void *p)
>>  			continue;
>>  		}
>>
>> +		if (server_conf.max_connections) {
>> +			if (atomic_read(&active_num_conn) >= server_conf.max_connections) {
>> +				pr_info("Limit the maximum number of connections(%u)\n",
>> +						atomic_read(&active_num_conn));
>> +				sock_release(client_sk);
>> +				continue;
>> +			}
>> +
>> +			atomic_inc(&active_num_conn);
>> +		}
>
> This has to be one atomic op:
>
> 	if (atomic_inc_return() >= max_connections) {
> 		atomic_dec
> 		sock_release
> 		continue
> 	}
>
> Otherwise it's racy and it's possible to have more active
> connections than the limit.
Ok.
>
> I'd also note that pr_info() is risky there, it would be safer
> to use rate-limited printk().
Ok. FIXED. I have sent v2 patch.
Thanks for your review!
>
