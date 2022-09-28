Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC0BC04A95
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Sep 2022 23:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbiI1XoU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 19:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234284AbiI1XoT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 19:44:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6761FF50A2
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 16:44:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED09060C24
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 23:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58080C433B5
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 23:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664408657;
        bh=UeJfM3Motox7A2hWzWqiFoe25tjwdbcDphjMAWC5hJs=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=gQyFZJBM17ZjBU7+Pay6vqJUI+HKIMNFsdnh+PsQi4ySeLhS+ejGGjidHLq1ybVjx
         +/cTIc66YkaeqSCFi2fzt2ccA5vLeODLzzWcf0sYZ4i9i/kYBFAkOvT04SJ4RXDaq8
         PKIIqiyO665zxlwbt+18074Iz9FAJy9nABuzLJWiEZw1edlNMF71sKaYBsk8Bq3wTC
         r6npe9caNEAt+164BBrrSHBYEagLVDN9MiKDo6RuWto7rW8LUPVavarO8a92fVAXu+
         mVlpQTch1nrKpQarqirAdycsTODZ0mstdUpyyF0ciomvfbcai4D4MCI8S4gitCelsP
         CqnUri0EgtMHw==
Received: by mail-oi1-f175.google.com with SMTP id c81so17143812oif.3
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 16:44:17 -0700 (PDT)
X-Gm-Message-State: ACrzQf0IFTyfe4mElbcx+5cPAA+kz1yoxdfEAhx1ZqXbgc6o69zZRUL0
        7VrTMh7LdKvLVY0EGuJf/kg7tl1dJfonF0wW8tk=
X-Google-Smtp-Source: AMsMyM4sTr1A7odO7Hz8DVT5mm66oDMHZtZp5Be9utRA37rHh2XcCbTeXWfJ/46FWy4JY/Xo1dsWoecB/ZS+CgMxno4=
X-Received: by 2002:a05:6808:23d5:b0:350:4f5c:143f with SMTP id
 bq21-20020a05680823d500b003504f5c143fmr252442oib.257.1664408656407; Wed, 28
 Sep 2022 16:44:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Wed, 28 Sep 2022 16:44:15
 -0700 (PDT)
In-Reply-To: <60322098-648f-2610-bcf2-1cec581d4f86@talpey.com>
References: <20220927215151.6931-1-linkinjeon@kernel.org> <60322098-648f-2610-bcf2-1cec581d4f86@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 29 Sep 2022 08:44:15 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-=nt_-X_YhZt+esNR8j9xF-UpSDApe+qb3t8T-NxP-8A@mail.gmail.com>
Message-ID: <CAKYAXd-=nt_-X_YhZt+esNR8j9xF-UpSDApe+qb3t8T-NxP-8A@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: hide socket error message when ipv6 config is disable
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-29 0:25 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/27/2022 5:51 PM, Namjae Jeon wrote:
>> When ipv6 config is disable(CONFIG_IPV6 is not set), ksmbd fallback to
>> create ipv4 socket. User reported that this error message lead to
>> misunderstood some issue. Users have requested not to print this error
>> message that occurs even though there is no problem.
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   fs/ksmbd/transport_tcp.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
>> index 143bba4e4db8..9b35afcdcf0d 100644
>> --- a/fs/ksmbd/transport_tcp.c
>> +++ b/fs/ksmbd/transport_tcp.c
>> @@ -399,7 +399,8 @@ static int create_socket(struct interface *iface)
>>
>>   	ret = sock_create(PF_INET6, SOCK_STREAM, IPPROTO_TCP, &ksmbd_socket);
>>   	if (ret) {
>> -		pr_err("Can't create socket for ipv6, try ipv4: %d\n", ret);
>> +		if (ret != -EAFNOSUPPORT)
>> +			pr_err("Can't create socket for ipv6, try ipv4: %d\n", ret);
>
> Why not just eliminate the splat? The only real error seems to be
> that IPv6 is not configured, which is undoubtedly intentional, and
No, It can return other errors.
> in any case there's nothing to do about it. Suggesting to "try ipv4"
> is kind of pointless, isn't it?
No, It is not bad to give info to users. users can check ksmbd
connection status using netstats.
>
>>   		ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP,
>>   				  &ksmbd_socket);
>>   		if (ret) {
>
> The same question applies to IPv4 - socket creation is not something
> that fails in general, and spraying the kernel log isn't particularly
> useful toward fixing it.
I don't understand what you are saying. Since it's not common, it print an error
and give the information to users.
> In any case, the error propagates back up
> to the caller, right? Why wouldn't ksmbd.mountd do the reporting?
Why does ksmbd.mountd appear here?
>
> Tom.
>
