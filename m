Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77E84ECAAD5
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Sep 2022 14:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238836AbiIBOGY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Sep 2022 10:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235591AbiIBOFz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 2 Sep 2022 10:05:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DF811EB58
        for <linux-cifs@vger.kernel.org>; Fri,  2 Sep 2022 06:33:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99BF2B82A96
        for <linux-cifs@vger.kernel.org>; Fri,  2 Sep 2022 13:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59EDCC43470
        for <linux-cifs@vger.kernel.org>; Fri,  2 Sep 2022 13:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662125636;
        bh=zCnt8YeBq7lq2RkZLiKh8Q4v8MgI2CsgTUTCkGfqT50=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Wy1FFrAVHIzw1NnI6k4eD6YmqT0Iwm9as4kwrMyb6dD7JQG9Z8VuacpPj6rtnB4a7
         TTHJIHdWZw489yhx89WjQ+G3eHVlMsoSJ3Ne/S+jsCqtnEJ0pYstVmvy478s2XkqGK
         RLKCunZpmQt3/800WKorSUI66sErlTS3lKEUi9xt7dJUSbibHJ4ABVZqP0wJ9qcJLv
         c1uuTU67/ZzLGql35PSwsqTfqds6Lw+VwMsPGSYHPP4yPMfVc8CLcGMeDmi4faptfQ
         bcXid+u4BRby1U6OtazQQW0A8gXkvpWyHJKieiG/aJ9SxFYTqtlCEbuFIwng1mkRLc
         Rasc9cj6GuLYQ==
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-11f11d932a8so4752680fac.3
        for <linux-cifs@vger.kernel.org>; Fri, 02 Sep 2022 06:33:56 -0700 (PDT)
X-Gm-Message-State: ACgBeo1GcXxW44WPTCliXXEzKHvnu7neQNJ/+Yew2rDmQj/pp8Gepqtn
        X2rE6gOpNDexATLU7fEwdvDloRZVs/wwnPIRctE=
X-Google-Smtp-Source: AA6agR7jJIJck8hPjOQS0vVoxr+RRsZpKDNGN3w3B0syauWWNznG9z/Z8hSh1Sdq1+0+1vvbNFJznvV+ijjig0SCjJc=
X-Received: by 2002:a05:6870:f69d:b0:10d:81ea:3540 with SMTP id
 el29-20020a056870f69d00b0010d81ea3540mr2268215oab.257.1662125635452; Fri, 02
 Sep 2022 06:33:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Fri, 2 Sep 2022 06:33:54
 -0700 (PDT)
In-Reply-To: <f681c94e-b402-6e44-c6d0-f853d773e341@talpey.com>
References: <YxDaZxljVqC/4Riu@jeremy-acer> <20220901174108.24621-1-atteh.mailbox@gmail.com>
 <YxD6SEN9/3rEWaNR@jeremy-acer> <CAN05THRgWMEejOMTozrf0F4sENxJEQYu2i-9CKWO+Qh0kvjveg@mail.gmail.com>
 <CAH2r5mvUzbp8RcM7+XFbJsoiba964vpKQiMRmGeQovGabe+j=Q@mail.gmail.com>
 <YxEot6I5d4PWtrz9@jeremy-acer> <CAKYAXd8SSQ+GpL=Na0OSFxOGSy-r7TW8Q+X-ZLaH-uLZQ1XauQ@mail.gmail.com>
 <YxFmTIpsYTcCHSwn@jeremy-acer> <f681c94e-b402-6e44-c6d0-f853d773e341@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 2 Sep 2022 22:33:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8gKyCv4Ezoiw0LYPhPpQ+reHhdgkP6kX8YOfLgENeEuA@mail.gmail.com>
Message-ID: <CAKYAXd8gKyCv4Ezoiw0LYPhPpQ+reHhdgkP6kX8YOfLgENeEuA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: update documentation
To:     Tom Talpey <tom@talpey.com>
Cc:     Jeremy Allison <jra@samba.org>, Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        atheik <atteh.mailbox@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-02 21:35 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/1/2022 10:11 PM, Jeremy Allison wrote:
>> On Fri, Sep 02, 2022 at 09:56:57AM +0900, Namjae Jeon wrote:
>>> 2022-09-02 6:48 GMT+09:00, Jeremy Allison <jra@samba.org>:
>>>> On Thu, Sep 01, 2022 at 04:37:21PM -0500, Steve French wrote:
>>>>>
>>>>> I do like that Namjae et al made the format of the .conf file very
>>>>> similar
>>>>> to the format of Samba's smb.conf file though.   I realize there some
>>>>> users complain that there are too many smb.conf parameters for Samba,
>>>>> but he seemed to pick a reasonably subset of them for ksmbd.
>>>>> Samba is a much larger project with many more smb.conf parameters
>>>>> but it does reduce confusion making the parameter names similar
>>>>> where possible e.g. "workgroup", "guest account", (share) path, read
>>>>> only,
>>>>> etc.
>>>>> and fortunately the default directories for the two smb.conf files are
>>>>> different so at least the daemons don't use the same file.
>>>>
>>>> Sure, I think the formats and parameter names being as close
>>>> as possible is a great idea to allow users to move between
>>>> servers as they wish. But making the files the same name
>>>> is not a good idea.
>>> This is the first time I've heard that it is problem that ksmbd's
>>> config filename is same with samba's one. Reading the mail threads, I
>>> don't understand exactly what the real problem is... I thought that
>>> using same smb.conf name make users aware that it was forked from
>>> samba's one. I'm a little surprised, I thought that you will say that
>>> we should use the same name. This seems to contradict your previous
>>> opinion that ksmbd's dos attribute and stream xattr format should be
>>> the same with samba's one. It's not difficult to change config
>>> filename of ksmbd if you agree with it. If we think about adding the
>>> ksmbd integration feature in samba recently, I think it would be
>>> better to use the same name for future.
>>
>> Well as Tom said, it gets very confusing to have the
>> same name config file.
>>
>> The file system attributes etc. certainly should be
>> the same, to allow a user to swap between the two
>> servers based on need and not lose any meta-data.
>>
>> But as the features diverge, trying to keep a common
>> config will get harder and harder.
>>
>> Better to take the pain now, rather than try and
>> postpone for later. It'll hurt *worse* later :-).
>
> The name collision was always a minor thing for me, but when it
> goes front and center in the manpage namespace, potentially
> coming up for a user when they expected Samba's, it is working
> cross-purposes. Ksmbd should forge its own identity, for clarity
> and for the future.
Okay, I'm talking to Atte to do that. after changing ksmbd-tools with him,
I will update ksmbd documentation in kernel.
>
> Namjae, you should be excited that this kind of issue comes up.
> As interest in ksmbd rises, more eyes will be on it, and more
> feedback will come. Remember it's experimental, it is not yet
> frozen in stone by being adopted by large numbers of users.
> Now is the time to work out the usability.
Okay. Thank you so much for your good feedbacks as well as
the patch review. Please keep giving feedback like it is now:)
Thanks JRA also.
> Tom.
> Let's also pop up a level
Yup!
>
