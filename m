Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA6FC61DA4
	for <linux-cifs@archiver.kernel.org>; Sun, 12 Feb 2023 02:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjBLCBp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 11 Feb 2023 21:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjBLCBo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 11 Feb 2023 21:01:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D702915CAC
        for <linux-cifs@vger.kernel.org>; Sat, 11 Feb 2023 18:01:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DEA060C1F
        for <linux-cifs@vger.kernel.org>; Sun, 12 Feb 2023 02:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEEEC433EF
        for <linux-cifs@vger.kernel.org>; Sun, 12 Feb 2023 02:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676167302;
        bh=aN/qTydn+/YG/R4ZC15fH5oYC8etI85ok/XlgZhWou8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=o5bZf20eVHPMUJ6fanT5STnlMtbZTZv8ZXibQy5AhHJRQp4FplX1k+Y9k+OYvaTTt
         uABAsfWVDKZa6opuVUwMcsLM2WzEnavOK34x6K+95X/dbEbFfh2sCcsOUcLn50Oqp4
         5ew87V55vEznIw/cAHuuitj6YpZqcWDkEZ2B50b0cTtQDkgaosP+wrOiE8TWa6duyr
         kMxqakrFFh3RqfbnQCr4tRklO5gvt4X8lELAUZROfEqQG5X3eQlvYaGogU/NX0vik1
         tNzOh2iONjnkKQD/yXmWdN5Dc03SvlfOCxSsdDPQsQY195nE9ZGvkiTagNyzSG6zk8
         WUibWUT6wSDJQ==
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-16aa71c1600so11416905fac.11
        for <linux-cifs@vger.kernel.org>; Sat, 11 Feb 2023 18:01:42 -0800 (PST)
X-Gm-Message-State: AO0yUKUmf+GnaImTk9EJOXs5JNLs4QVkXUpl+BYcg65Jb3HOMtUOjx8L
        jw8OVFdbd9PBZ4skIYL9z3+bNxDjJq1GYZPElG0=
X-Google-Smtp-Source: AK7set8WUFQqJufR5wKfZvU2EIk7SQDSL6+mw4TpFbrvGKkVSru3R+E+j+RWWOQre/BAP7i5UDOpPPJCOr4rKA5pgmw=
X-Received: by 2002:a05:6870:4602:b0:16a:b198:74e9 with SMTP id
 z2-20020a056870460200b0016ab19874e9mr2253769oao.215.1676167301551; Sat, 11
 Feb 2023 18:01:41 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a8a:355:0:b0:4a5:1048:434b with HTTP; Sat, 11 Feb 2023
 18:01:41 -0800 (PST)
In-Reply-To: <CAH2r5mvGspRdByLkuC79oHfNkirKj2hEFSODDHKvXtQkV9KdEQ@mail.gmail.com>
References: <20230208094104.10766-1-linkinjeon@kernel.org> <CAH2r5mvGspRdByLkuC79oHfNkirKj2hEFSODDHKvXtQkV9KdEQ@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 12 Feb 2023 11:01:41 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_h7QyFFRn689+_jFzSOJBYLc9xJRTh-UbZ3MrR0oNpYg@mail.gmail.com>
Message-ID: <CAKYAXd_h7QyFFRn689+_jFzSOJBYLc9xJRTh-UbZ3MrR0oNpYg@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: do not allow the actual frame length to be
 smaller than the rfc10024 length
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org, senozhatsky@chromium.org,
        tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-02-12 5:53 GMT+09:00, Steve French <smfrench@gmail.com>:
> Did you see any examples other than (SMB3) tree connect where the
> Linux client padded a request beyond end of SMB/SMB3 frame?
Yes. libsmb,  but rfc1002 length is 8byte-aligned frame length. (i.e.
ALIGN(clc_len, 8) == len) but cifs don't do that about smb2 tree
connect, just frame length + 2.
And I can not understand why cifs pad smb2 tree connect to 2bytes.

note that smbclient, windows, MacOs, and Nautilus clients do not pad
smb2 tree connect request.

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
