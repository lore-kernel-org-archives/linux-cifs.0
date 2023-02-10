Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 073BBC61DA4
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Feb 2023 01:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjBJBOk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Feb 2023 20:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBJBOj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Feb 2023 20:14:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5E960E70
        for <linux-cifs@vger.kernel.org>; Thu,  9 Feb 2023 17:14:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACE6761C1A
        for <linux-cifs@vger.kernel.org>; Fri, 10 Feb 2023 01:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210F5C433D2
        for <linux-cifs@vger.kernel.org>; Fri, 10 Feb 2023 01:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675991678;
        bh=l5J7GGBTSy5DKWZqFGl5wNSzpNpxZlbjxbA0pIoWRmg=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Ow6/4LNeqNwceoXt/SlQWS1qb2CIhN3MccAvK/o6Ypa4bA2oEis2uFUsoJ9YeZQke
         AkymPHlXYKKAnjOHOsHVf8O8ozFfa4qa8rkhFOoWeSd5+zHL3GVOYKVMTfVnsxNONQ
         wMCI5Bs9T/D4TVEATu8EFPYwIdZSLZMtUOfrzsw52irtvDK3QiauquVJfPfb19kf1d
         EbAQyeDa3RZah56lv9h/WcyPHOQ50LUm7620a/GDf+6qTRvV5Gzs9bsN5DN8szThUR
         W3krj2ZWVDLG02yMxfdYJdmms48oJhGQAebnHs5N8w9d2qhPlSrkecplUVQFWsvpfG
         cLKut0e16Mf9A==
Received: by mail-ot1-f52.google.com with SMTP id 70-20020a9d084c000000b0068bccf754f1so1135134oty.7
        for <linux-cifs@vger.kernel.org>; Thu, 09 Feb 2023 17:14:38 -0800 (PST)
X-Gm-Message-State: AO0yUKVyvwJ6EOlz+GMwWY3R2tuSkQgZ9J2KAhkebXhxUjlKy5qksY57
        GtawH+wEGbaFMUeW3bXbWXpyyEGLh+ngqmn2T+E=
X-Google-Smtp-Source: AK7set+58lGdCNjzsKITP4Bh0/NRVvkWad0tNCx5XKf6W0PDOjnz0mVKDdPbj72vQmQejNnPAX50YpP047xVnguuR+M=
X-Received: by 2002:a05:6830:68c9:b0:68d:9600:8318 with SMTP id
 cw9-20020a05683068c900b0068d96008318mr1153054otb.19.1675991677234; Thu, 09
 Feb 2023 17:14:37 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a8a:355:0:b0:4a5:1048:434b with HTTP; Thu, 9 Feb 2023
 17:14:36 -0800 (PST)
In-Reply-To: <CAH2r5muCPMELUij-9RLcBqsYqbkcnOYi=F-JN8Oc3c3azUW0uw@mail.gmail.com>
References: <20230208094104.10766-1-linkinjeon@kernel.org> <CAH2r5muCPMELUij-9RLcBqsYqbkcnOYi=F-JN8Oc3c3azUW0uw@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 10 Feb 2023 10:14:36 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9fHPBm1bN-KRmsSp979Lk9j5wfEcu8M-eJ0gTUBnBHQA@mail.gmail.com>
Message-ID: <CAKYAXd9fHPBm1bN-KRmsSp979Lk9j5wfEcu8M-eJ0gTUBnBHQA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: do not allow the actual frame length to be
 smaller than the rfc10024 length
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org, senozhatsky@chromium.org,
        tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-02-10 8:48 GMT+09:00, Steve French <smfrench@gmail.com>:
> typically rounding up to 8 byte boundary would be logical to allow
okay, Will update it on v2.

Thanks!
>
> On Wed, Feb 8, 2023 at 3:41 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>>
>> ksmbd allowed the actual frame length to be smaller than the rfc1002
>> length. If allowed, it is possible to allocates a large amount of memory
>> that can be limited by credit management and can eventually cause memory
>> exhaustion problem. This patch do not allow it except SMB2 Negotiate
>> request which will be validated when message handling proceeds.
>> Also, cifs client pad smb2 tree connect to 2bytes.
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>  fs/ksmbd/smb2misc.c | 23 +++++++++++------------
>>  1 file changed, 11 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
>> index a717aa9b4af8..fc44f08b5939 100644
>> --- a/fs/ksmbd/smb2misc.c
>> +++ b/fs/ksmbd/smb2misc.c
>> @@ -408,20 +408,19 @@ int ksmbd_smb2_check_message(struct ksmbd_work
>> *work)
>>                         goto validate_credit;
>>
>>                 /*
>> -                * windows client also pad up to 8 bytes when
>> compounding.
>> -                * If pad is longer than eight bytes, log the server
>> behavior
>> -                * (once), since may indicate a problem but allow it and
>> -                * continue since the frame is parseable.
>> +                * SMB2 NEGOTIATE request will be validated when message
>> +                * handling proceeds.
>>                  */
>> -               if (clc_len < len) {
>> -                       ksmbd_debug(SMB,
>> -                                   "cli req padded more than expected.
>> Length %d not %d for cmd:%d mid:%llu\n",
>> -                                   len, clc_len, command,
>> -                                   le64_to_cpu(hdr->MessageId));
>> -                       goto validate_credit;
>> -               }
>> +               if (command == SMB2_NEGOTIATE_HE)
>> +                       goto validate_credit;
>> +
>> +               /*
>> +                * cifs client pads smb2 tree connect to 2 bytes.
>> +                */
>> +               if (clc_len + 2 == len)
>> +                       goto validate_credit;
>>
>> -               ksmbd_debug(SMB,
>> +               pr_err_ratelimited(
>>                             "cli req too short, len %d not %d. cmd:%d
>> mid:%llu\n",
>>                             len, clc_len, command,
>>                             le64_to_cpu(hdr->MessageId));
>> --
>> 2.25.1
>>
>
>
> --
> Thanks,
>
> Steve
>
