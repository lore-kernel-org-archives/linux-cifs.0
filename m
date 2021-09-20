Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88729C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 16:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 679986115B
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 16:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhITQgG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 12:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230099AbhITQgG (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 20 Sep 2021 12:36:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 819F361177
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 16:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632155679;
        bh=pxF29AaQATzGhRHb4RnXU6CyjQbrv7GsTPhZECcrj18=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=WxNWHBxAl7/VZAWhvJwxQ7uOZZgNr4XqNDvUQWCs7FmyXBRaUuyuJkE1zt9vqo6sg
         5rAIIuN4TKkELQKV0yeD8dGnOFFV5CbcaesGuUkPXbcKY1jQf0+52dfqhSuZch7zME
         e7/ncA3UkwdHhhlDjr84eHgYqX4Q4ZY8yKg7ZclqsnyFmiyvJZHsJHP/NO8tP6lAkI
         sF+Kzj1Rs+ialHF7aCpH5zkDDgNPkVdLSQDWXTNFJsvjrhAsN0pre8qU4VlqotLwmx
         RyBkPXgjPI+OEbLMoZy84W1vAV4vzrlrmajbuptYPvxbEKy3/S+H0cRoIDMqJ/dMr9
         Ksd2drw3y1B8w==
Received: by mail-oi1-f172.google.com with SMTP id 6so25518745oiy.8
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 09:34:39 -0700 (PDT)
X-Gm-Message-State: AOAM530hM51TFhEiqs4rm61/+V02ySzQQFY1iGh/e+9AV2Rmxa0jmKgX
        EpGnBB7400FcpsyupjO0oTTYWk4y4Sdmopwgu7U=
X-Google-Smtp-Source: ABdhPJydz7U9HSk+kDpZ3tERLRy99sFuERbDqpHoVb/fNUp6TKAULbqAA9YTHA2k2lCI4bPj1FFTk0CDrbmiH5bqD3Y=
X-Received: by 2002:aca:1b19:: with SMTP id b25mr22848495oib.138.1632155678927;
 Mon, 20 Sep 2021 09:34:38 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Mon, 20 Sep 2021 09:34:38
 -0700 (PDT)
In-Reply-To: <2cf8a2d1-41df-eef4-dfe0-dca076e8db54@talpey.com>
References: <20210918120239.96627-1-linkinjeon@kernel.org> <ac18e062-e835-b575-66af-72631df7ef7d@talpey.com>
 <CAH2r5msa4XeaLy=_HY9RrLpK0NyS9n3iMdYnvX7F4n2zNQNXgQ@mail.gmail.com> <2cf8a2d1-41df-eef4-dfe0-dca076e8db54@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 21 Sep 2021 01:34:38 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9VJ52QOEdAaNC3ZVAZk3mBAZFHo=uME_ygK0Axk=yivQ@mail.gmail.com>
Message-ID: <CAKYAXd9VJ52QOEdAaNC3ZVAZk3mBAZFHo=uME_ygK0Axk=yivQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: add default data stream name in FILE_STREAM_INFORMATION
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-21 1:08 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/20/2021 12:47 AM, Steve French wrote:
>> On Sat, Sep 18, 2021 at 9:06 PM Tom Talpey <tom@talpey.com> wrote:
>>>
>>> This doesn't appear to be what's documented in MS-FSA section
>>> 2.1.5.11.29.
>>> There, it appears to call for returning an empty stream list,
>>> and STATUS_SUCCESS, when no streams are present.
>>
>> I tried a quick test to Windows and it does appear to return $DATA
>> stream by default:
>>
>> # ./smbinfo filestreaminfo /mnt/junk
>> Name: ::$DATA
>> Size: 179765 bytes
>> Allocation size: 196608 bytes
>
> Ok, so the implication is that the default stream is indeed always
> present, if the filesystem supports streams. The language in MS-FSA
> would therefore be correct, but a bit vague. I agree that returning
> a ::$DATA for ordinary files is appropriate.
>
>> when I tried the same thing to a directory on a share mounted to Windows
>> 10
>> (NTFS), I get no streams returned.
>>
>> So it does look like default stream ($DATA) is only returned for files
>
>
> My concern here is, what's so special about directories? A special file
> or fifo, a symlink or reparse/junction, etc. Is it appropriate to cons
> up a ::$DATA for these? What should the size values be, if so?
Special files in linux(ksmbd share) is showing as regular file on
windows client.
>
> Tom.
>
>
>>> Also, why does the code special-case directories? The conditionals
>>> on StreamSize and StreamAllocation size are entirely redundant,
>>> after the top-level if (!S_ISDIR...), btw.
>>>
>>> I'd suggest asking Microsoft dochelp for clarification before
>>> implementing this.
>>>
>>> Tom.
>>>
>>> On 9/18/2021 8:02 AM, Namjae Jeon wrote:
>>>> Windows client expect to get default stream name(::DATA) in
>>>> FILE_STREAM_INFORMATION response even if there is no stream data in
>>>> file.
>>>> This patch fix update failure when writing ppt or doc files.
>>
>>
>>
>>
>
