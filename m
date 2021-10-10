Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98323C4332F
	for <linux-cifs@archiver.kernel.org>; Sun, 10 Oct 2021 01:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 733A260F57
	for <linux-cifs@archiver.kernel.org>; Sun, 10 Oct 2021 01:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhJJBOm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 9 Oct 2021 21:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229636AbhJJBOm (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 9 Oct 2021 21:14:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55FD660F4B
        for <linux-cifs@vger.kernel.org>; Sun, 10 Oct 2021 01:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633828364;
        bh=byZDhs1iVL7et711REfITfHTs2PyO3xr4vBNHY+SowQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=mdypyVOT8NzorjdEGd8abXYRHm9ijw7/11aoH7vrpfZJQDUN3kXIsmzXQCGlk+0cj
         vdMIkT+1GpbQtf1j41o0sakEKe/EX1nScOT6scZ5T1Rdr9dLvN9WZtLABcOtf3WDY2
         qkUbkW1k9GIFrTI3HTT4y6YmA/Wrypw8lb5W/9Hh/1u43Bs9ASN0yxQyb7Bf8Q3Mc4
         V+WUALjqBeWExRKbyeFr3zc1DG0AGELxkQAjeSMdkYwneTRbeW9ud+eHQsHg0WF4Ln
         nKEHDFn9+jpKvEnl4nKpuUD+eWTrZltj/JMV7SQgjMT5YOBx485++KbU20mta0QJxN
         3i+pBT/QomRNg==
Received: by mail-oi1-f175.google.com with SMTP id z11so19135606oih.1
        for <linux-cifs@vger.kernel.org>; Sat, 09 Oct 2021 18:12:44 -0700 (PDT)
X-Gm-Message-State: AOAM531bN/KYenveTeQRDFwbZd0lVqIrPl5jgqCXGhx3u1WlcAwP8DIi
        VGauD3Q51iQXwcl+xPTjLvkVbYpIZnKm8o0eznc=
X-Google-Smtp-Source: ABdhPJw5bt3dkubaXSg8lc2vHWBr1OIj9fepXRIvfBMcgZXVdKfQpHdK2ltRSowWdsDbhNAS0BR2ykBNxpi5OUr0SVw=
X-Received: by 2002:aca:b5c3:: with SMTP id e186mr22428378oif.51.1633828363629;
 Sat, 09 Oct 2021 18:12:43 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Sat, 9 Oct 2021 18:12:43 -0700 (PDT)
In-Reply-To: <CAH2r5mtcGY1Aomh1LHDs=gwL68TEEmD9Qzf17+4C34MpqHhuqw@mail.gmail.com>
References: <20211009054903.9788-1-linkinjeon@kernel.org> <CAH2r5mtcGY1Aomh1LHDs=gwL68TEEmD9Qzf17+4C34MpqHhuqw@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 10 Oct 2021 10:12:43 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9NKo3kX6e-=uMFwuXkYcYvhKgA=9wRA1KTzLf5oxObjQ@mail.gmail.com>
Message-ID: <CAKYAXd9NKo3kX6e-=uMFwuXkYcYvhKgA=9wRA1KTzLf5oxObjQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd-tools: set a minimum character limit for password
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-10 0:12 GMT+09:00, Steve French <smfrench@gmail.com>:
> Maybe make it configurable but default to 8 as minimum!
Okay. I will check it.

Thanks!
>
> On Sat, Oct 9, 2021, 00:49 Namjae Jeon <linkinjeon@kernel.org> wrote:
>
>> Set minimum password length with 8 characters by default to protect
>> passwords vulnerable.
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>  adduser/user_admin.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/adduser/user_admin.c b/adduser/user_admin.c
>> index 4e85915..36b9ad2 100644
>> --- a/adduser/user_admin.c
>> +++ b/adduser/user_admin.c
>> @@ -119,6 +119,11 @@ again:
>>                 goto again;
>>         }
>>
>> +       if (len <= 7) {
>> +               pr_err("Minimum password length is 8 characters\n");
>> +               goto again;
>> +       }
>> +
>>         *sz = len;
>>         free(pswd2);
>>         return pswd1;
>> --
>> 2.25.1
>>
>>
>
