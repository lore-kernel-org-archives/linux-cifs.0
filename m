Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C45C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 17:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF2A46108E
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 17:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242099AbhI1RfU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Sep 2021 13:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242081AbhI1RfS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Sep 2021 13:35:18 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6D9C06161C
        for <linux-cifs@vger.kernel.org>; Tue, 28 Sep 2021 10:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=w/BEbMFodsL9MarVd4bVIJg5wllEkLMOMKdP21sOvZQ=; b=zYmC7Nv+2QbVYvjjAoYSxJLMFb
        qpxKyg2wXyBtjINSAdA8GzUI4LLQdpcx4GHpM/ZKmVfa5sVrvcvpZFDUYy+h8/mQIo7ElcgamsJFl
        dC4Y9nUpjjXf9yeQTio7+RUeJcVyy/WcMSMa7Ev1ApynwptZr3KqYRw0uYNQSjkEBau73PuWAz+B5
        FZYoA/Qv3e2WZNgVPM5NgIVCf/w851VWzmm1+UT6Uln4K/DdUKWVj0SJXQEUihXCqoeRr/G7YtqzV
        1EV9RSihgbFt+JScyRy9FvEiJy0Nd6+W3aWoAqRlel9FtPPMPtjGRZ2SpbV6ISODTqH87/y5f0R5V
        6JPmOOsBKjRnnj0FoANyRNvbq6JjA0DealkS1U4EuOADrZUyKNf807I5gEVC++2ST9grBthbD6XZe
        Mx4H0/GWkaGPq+WC+tST2cYFSPlKfqaxy/S3o7rq32v/SnRq9TJAtkrznTwAMVvXIrzThOSGqihNf
        88fvE5CK7S4p6b70LlFy3QQ1;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mVGz1-000WtU-Bs; Tue, 28 Sep 2021 17:33:35 +0000
Date:   Tue, 28 Sep 2021 10:33:31 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Ralph Boehme <slow@samba.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
Message-ID: <YVNR6w7dq0HMIcFA@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20210926135543.119127-1-linkinjeon@kernel.org>
 <a15a1d99-1a2f-0f41-773e-def5b83f2304@samba.org>
 <CAKYAXd8G5xBBLTS0vS_p1TFoULuxSf-CFjE4n98D+sQrtjpjcw@mail.gmail.com>
 <b9449e7f-5c27-c766-f8e0-1564b8848f7b@samba.org>
 <8f57cac6-1c8a-cbce-b245-bb4015575569@samba.org>
 <CAKYAXd88PNFg4oXisxw8fnUBzCQyceC=2KvPhdU7q6DUgatQbw@mail.gmail.com>
 <79ed52be-c92e-1c62-423f-ee126b3da409@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <79ed52be-c92e-1c62-423f-ee126b3da409@samba.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Sep 28, 2021 at 06:33:46PM +0200, Ralph Boehme wrote:
>Am 28.09.21 um 16:23 schrieb Namjae Jeon:
>>2021-09-28 22:43 GMT+09:00, Ralph Boehme <slow@samba.org>:
>>>Am 28.09.21 um 05:26 schrieb Ralph Boehme:
>>>>both: there are issues with the patch and I have changes on-top. :) It
>>>>just takes a bit of time due to other stuff going on currently like SDC.
>>>
>>>finally... :)
>>>
>>>Please check my branch
>>><https://github.com/slowfranklin/smb3-kernel/commits/ksmbd-for-next-pending>
>>>
>>>for added commits and two SQUASHes. Remaining commits reviewed-by: me.
>>Yep, looks good, I will update them in patches. And thanks for your review!
>
>thanks!
>
>>>Oh, and I also split out the setinfo basic infolevel changes into its
>>>own commit.
>>If you want to add clean-up patch first, we can change
>>get_file_basic_info() together in patch. I will update it also.
>>>
>>>Let me know what you think of the additional checks I've added.
>>You should submit patches to the list to be checked by other developers.
>
>everyone can fetch from that branch. And as I'm not merely doing patch 
>review, but am changing, expanding, fixing patches, an email patch 
>workflow doesn't work.

+1 on this. email-based patch workflow is fine when patches
don't go through many iterations or have many people working
on them, but when those things are true a repository-based
workflow is far better (IMHO). Everyone knows how to use
git (these days :-).

It would be good to get to the point where the list is
used as a "release management" tool where patches that
have already been completely reviewed and signed-off
are sent and archived.
