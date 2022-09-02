Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D06ECAAD2
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Sep 2022 02:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiIBCLg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 22:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiIBCLf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 22:11:35 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F74EA0261
        for <linux-cifs@vger.kernel.org>; Thu,  1 Sep 2022 19:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=cYfzX9LH+4u8VePx2YmIAyPHrXngMcybQBy8QM+0nCs=; b=JGBDe9NZHk7ElKTBaXZ2uDBCtG
        WOFjxE8eRP5D+1yiw8dP1FtLa5oW3zNE03RfCt0Z3INm5C1G+/liwTHXjY5QQP82o1P+VZAY9TE2L
        Hayi/3ajN8FnAQXmdoyI0/ZddrCKlNVxHcDxUR+RmR+wc8y4+ZeysAFXVZCB0DgMwesHQ6/7TEvEX
        aat6RXxvrgTW+ykqCE8E+HoQ5LpNMBN8EOnN9Lsr0/egFnA+GingHAawqADAY5Y6j8pxVLmdsjkvD
        /vYMUvVRVzMNfuTukP3Doe9FCnOUYNEDMBXr5nDbNs9yV/F7OubelPi5cF5Vcr6acNaiy16n8/wkh
        rtr6E++No8wcbFYH0mEnCdvXbTesvFDNzomF2cF5QlkQFdVJCB2KKCsMUsOpnAaPptQMxgrLWN6dQ
        piWTtG1vd4GaqG33LKDgM62cxRolYKh3iZ2z9ntJLpJ/z/jbEG7I7ClHSGiBhgGyUr/RJtwk75z2x
        nI+iBC7z5SHlyq+etuyF/ruR;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oTw9a-002ike-8U; Fri, 02 Sep 2022 02:11:30 +0000
Date:   Thu, 1 Sep 2022 19:11:24 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        atheik <atteh.mailbox@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>
Subject: Re: [PATCH 1/2] ksmbd: update documentation
Message-ID: <YxFmTIpsYTcCHSwn@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <YxDaZxljVqC/4Riu@jeremy-acer>
 <20220901174108.24621-1-atteh.mailbox@gmail.com>
 <YxD6SEN9/3rEWaNR@jeremy-acer>
 <CAN05THRgWMEejOMTozrf0F4sENxJEQYu2i-9CKWO+Qh0kvjveg@mail.gmail.com>
 <CAH2r5mvUzbp8RcM7+XFbJsoiba964vpKQiMRmGeQovGabe+j=Q@mail.gmail.com>
 <YxEot6I5d4PWtrz9@jeremy-acer>
 <CAKYAXd8SSQ+GpL=Na0OSFxOGSy-r7TW8Q+X-ZLaH-uLZQ1XauQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKYAXd8SSQ+GpL=Na0OSFxOGSy-r7TW8Q+X-ZLaH-uLZQ1XauQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Sep 02, 2022 at 09:56:57AM +0900, Namjae Jeon wrote:
>2022-09-02 6:48 GMT+09:00, Jeremy Allison <jra@samba.org>:
>> On Thu, Sep 01, 2022 at 04:37:21PM -0500, Steve French wrote:
>>>
>>>I do like that Namjae et al made the format of the .conf file very similar
>>>to the format of Samba's smb.conf file though.   I realize there some
>>>users complain that there are too many smb.conf parameters for Samba,
>>>but he seemed to pick a reasonably subset of them for ksmbd.
>>>Samba is a much larger project with many more smb.conf parameters
>>>but it does reduce confusion making the parameter names similar
>>>where possible e.g. "workgroup", "guest account", (share) path, read only,
>>> etc.
>>>and fortunately the default directories for the two smb.conf files are
>>>different so at least the daemons don't use the same file.
>>
>> Sure, I think the formats and parameter names being as close
>> as possible is a great idea to allow users to move between
>> servers as they wish. But making the files the same name
>> is not a good idea.
>This is the first time I've heard that it is problem that ksmbd's
>config filename is same with samba's one. Reading the mail threads, I
>don't understand exactly what the real problem is... I thought that
>using same smb.conf name make users aware that it was forked from
>samba's one. I'm a little surprised, I thought that you will say that
>we should use the same name. This seems to contradict your previous
>opinion that ksmbd's dos attribute and stream xattr format should be
>the same with samba's one. It's not difficult to change config
>filename of ksmbd if you agree with it. If we think about adding the
>ksmbd integration feature in samba recently, I think it would be
>better to use the same name for future.

Well as Tom said, it gets very confusing to have the
same name config file.

The file system attributes etc. certainly should be
the same, to allow a user to swap between the two
servers based on need and not lose any meta-data.

But as the features diverge, trying to keep a common
config will get harder and harder.

Better to take the pain now, rather than try and
postpone for later. It'll hurt *worse* later :-).
