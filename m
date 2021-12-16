Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFFFC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Dec 2021 13:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbhLPNp7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Dec 2021 08:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbhLPNp6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Dec 2021 08:45:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C30C061574
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 05:45:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C2B4B8245C
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 13:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9A8C36AE6
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 13:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639662355;
        bh=fDbSIVDzIupOP5Bi+dd5eTxumgji0IRA9JeEf6sV3Ow=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=uj4MJVcKD4A5ghIPWJu86Vcv2BgcHXJ9lB7kn1v26cFVZx2tF3b6BTcjcJchqy4Nl
         Sws6lULBtmXAShC4NW1VrczC0dNVkPCFpBBM3XY6w5XXygyR4bjLaPqZnHnGOP6qxJ
         fHyo5un9vY/C3cP3MR4m6Jn5WZDF4pscNVJgBvmCjy1y/HNP5mIv25NbDQsOkk1XGk
         xRdRjaZ/FN+54f2pKRLuCNnfvfywxxLlnRlO/nRta+4qmIm+G7dzCDnYoLmycu5PZn
         eBoz8OqI53s8AGin65PQ381KdDJkdqy0THtaB7PpMk0IgTm+DzVkF+y/OJFpcrFpFj
         a/TiTcfZ80HrA==
Received: by mail-oo1-f53.google.com with SMTP id g11-20020a4a754b000000b002c679a02b18so6924362oof.3
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 05:45:55 -0800 (PST)
X-Gm-Message-State: AOAM530CA0C6bdgfoUofGXKQeKu+Jq89hdhbjvNNdlWgnQBZvozd1M0t
        qW+UPEf4wZDH9DpxnUrFDCyx/LhqGxyOvpC1X5E=
X-Google-Smtp-Source: ABdhPJwLN9PACFK160Z/KX6tnwHbejv/E32XNUQqVf6cWRRYZf2I9wKaDu+LmKgLj2TAKPyFvHvgIBPP+Ctsm2XwdUM=
X-Received: by 2002:a4a:4ec4:: with SMTP id r187mr11110593ooa.88.1639662354925;
 Thu, 16 Dec 2021 05:45:54 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:428a:0:0:0:0:0 with HTTP; Thu, 16 Dec 2021 05:45:54
 -0800 (PST)
In-Reply-To: <CAKYAXd-DX+1P5hxYoPkDkGow9GuNY-m5bErqUbXz8OUDQxNZMQ@mail.gmail.com>
References: <20211130184710.r7dzzfhak4w3eoi6@cyberdelia> <CAKYAXd9b0Pji2+Ek9ZcRjN0SfZd4jzyNtDLKwzySh4WCjmSYkQ@mail.gmail.com>
 <20211215150008.u26snbaml5amlaep@cyberdelia> <CA+_sPao7zLjEpwsM7i96Mrohe8Uqpd=qzAq+ykw=K0NWjtLxYA@mail.gmail.com>
 <CAKYAXd-DX+1P5hxYoPkDkGow9GuNY-m5bErqUbXz8OUDQxNZMQ@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 16 Dec 2021 22:45:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8V30tWhmFQSn2m+0TS1+gUxKBgJ3zP0cm9dzc0ziaviQ@mail.gmail.com>
Message-ID: <CAKYAXd8V30tWhmFQSn2m+0TS1+gUxKBgJ3zP0cm9dzc0ziaviQ@mail.gmail.com>
Subject: Re: [RFC] Unify all programs into a single 'ksmbdctl' binary
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-12-16 11:07 GMT+09:00, Namjae Jeon <linkinjeon@kernel.org>:
> 2021-12-16 10:38 GMT+09:00, Sergey Senozhatsky <senozhatsky@chromium.org>:
>> Hi,
>>
>> On Thu, Dec 16, 2021 at 12:00 AM Enzo Matsumiya <ematsumiya@suse.de>
>> wrote:
>>>
>>> Any feedback on this proposal? Should I focus on polishing + splitting
>>> into meaningful commits?
This work looks really good. Could you please split one mega patch
into small ones for review ?

Thanks!
>>
>> I haven't gotten a chance to look at it yet, but in general I have no
>> objections to the "git-way" implementation.
> Thanks for your point out and opinion:)
> Enzo, I will check your work at detail today. I will reply soon.
> Thanks!
>>
>
