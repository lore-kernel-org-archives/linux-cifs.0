Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 427BEC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 23:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D22261368
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 23:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243161AbhI1X3R (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Sep 2021 19:29:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243145AbhI1X3R (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 28 Sep 2021 19:29:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5D1D61368
        for <linux-cifs@vger.kernel.org>; Tue, 28 Sep 2021 23:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632871656;
        bh=5sASmYa7bLMuEbBuvsUhEMUHuMv6POVXx5uco4/hqVk=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=X1yJpuQfQqTkFSQunxqfr0CdUZ97Hh2VtaWyHDXcv17j7W3y1YbdVgusmwH1REXdG
         gbi5RwpTovsNTBoz3zyKxEIXaDWhe2aWQHnWVHDRpnLeqS/u85IUDXyXsEI2wshzW9
         8BymviyRfaIfRna5ujFJBULKH4iHMoXQ0t30WbqQn27UtXhQyr75cMb3kkxA0yDnfQ
         pQgshqGkBdmfNSGcxA4rRooBNvCQ6OAUwN5OTJtUv5Bz/3oCnQWfvqwPm0kpPJ+Sxw
         uleep4SVenBTCjS1bv+NnHnKyHwkFSUHBpKf6q5RL1n/MDP4ExfwoWHL3GUKwO5Vnp
         AjAquSJsdN0Rw==
Received: by mail-oi1-f181.google.com with SMTP id 24so635199oix.0
        for <linux-cifs@vger.kernel.org>; Tue, 28 Sep 2021 16:27:36 -0700 (PDT)
X-Gm-Message-State: AOAM530o9O9xgj0L+G6SeMvQrDVvDOoN0TpVFjwqbutvtEoYsgThZMeE
        PFSL0OA31UXIF9U2Xin1DIT149VqyjwF+8rZpG8=
X-Google-Smtp-Source: ABdhPJyCd38aP84106g5IN72wrzOG3ifV3H+Qck2pH9oD4XFG/sikamE90ZPtyQElN0IJAuSCIpwN1xS7VEpk6yx4dY=
X-Received: by 2002:a05:6808:21a7:: with SMTP id be39mr5568974oib.138.1632871656297;
 Tue, 28 Sep 2021 16:27:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Tue, 28 Sep 2021 16:27:35
 -0700 (PDT)
In-Reply-To: <CAKYAXd88PNFg4oXisxw8fnUBzCQyceC=2KvPhdU7q6DUgatQbw@mail.gmail.com>
References: <20210926135543.119127-1-linkinjeon@kernel.org>
 <a15a1d99-1a2f-0f41-773e-def5b83f2304@samba.org> <CAKYAXd8G5xBBLTS0vS_p1TFoULuxSf-CFjE4n98D+sQrtjpjcw@mail.gmail.com>
 <b9449e7f-5c27-c766-f8e0-1564b8848f7b@samba.org> <8f57cac6-1c8a-cbce-b245-bb4015575569@samba.org>
 <CAKYAXd88PNFg4oXisxw8fnUBzCQyceC=2KvPhdU7q6DUgatQbw@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 29 Sep 2021 08:27:35 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8wHcrNYNvkHsePUsmb+JKb2n8UkdywaLwU7eG-JD5t2w@mail.gmail.com>
Message-ID: <CAKYAXd8wHcrNYNvkHsePUsmb+JKb2n8UkdywaLwU7eG-JD5t2w@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-28 23:23 GMT+09:00, Namjae Jeon <linkinjeon@kernel.org>:
> 2021-09-28 22:43 GMT+09:00, Ralph Boehme <slow@samba.org>:
>> Am 28.09.21 um 05:26 schrieb Ralph Boehme:
>>> both: there are issues with the patch and I have changes on-top. :) It
>>> just takes a bit of time due to other stuff going on currently like SDC.
>>
>> finally... :)
>>
>> Please check my branch
>> <https://github.com/slowfranklin/smb3-kernel/commits/ksmbd-for-next-pending>
>>
>> for added commits and two SQUASHes. Remaining commits reviewed-by: me.
> Yep, looks good, I will update them in patches. And thanks for your review!
When I take a look, I found issues in two squashes. I leave comments...
I still prefer you give review comments on patches in the list.

>>
>> Oh, and I also split out the setinfo basic infolevel changes into its
>> own commit.
> If you want to add clean-up patch first, we can change
> get_file_basic_info() together in patch. I will update it also.
>>
>> Let me know what you think of the additional checks I've added.
> You should submit patches to the list to be checked by other developers.
>
> Thanks!
>>
>> Cheers!
>> -slow
>>
>> --
>> Ralph Boehme, Samba Team                 https://samba.org/
>> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>>
>
