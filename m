Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9608AECAAD2
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Sep 2022 00:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbiIBA5K (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 20:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234930AbiIBA5G (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 20:57:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A95A4069
        for <linux-cifs@vger.kernel.org>; Thu,  1 Sep 2022 17:57:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 213FCB82966
        for <linux-cifs@vger.kernel.org>; Fri,  2 Sep 2022 00:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB814C433B5
        for <linux-cifs@vger.kernel.org>; Fri,  2 Sep 2022 00:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662080218;
        bh=iuto8mLG0kFMJVZHczUD1ADQgFGzSaJTYF8vQOTC/Gs=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=VQkNMI8SX59Rd0imQvPwrUwUZplulRDyZ0v1Gpi87SsrChTp7YGdD8Sk+qYVXoB4F
         uFmdy7vDEhyhhPLRf0Td99Wf+/uDruFeTF1fRiWysBy1K7v9p7Y5dgUl9F98+zoWK9
         hKwmYn8qdNgI0ixCQpzpkrJGSnMqAHMDwmmjuz0+fbk5rGVXMJrf7rEuOoOwVenbcv
         UrJG1QZv4vr3mtyfYVqP8BV+bkA02g12zbi9idsSgQBbTZC7X1zu3gonfNf9uwkDP/
         mseaMarHhvrNnwWhDSFytEP7+CiyvvJi0rhfB1OFnip2s5wzNgff4KCn5uNW4sHgzz
         A6Mg0A6DWU2Ng==
Received: by mail-oo1-f44.google.com with SMTP id q6-20020a4aa886000000b0044b06d0c453so134616oom.11
        for <linux-cifs@vger.kernel.org>; Thu, 01 Sep 2022 17:56:58 -0700 (PDT)
X-Gm-Message-State: ACgBeo0l1UPbcG3KO/6OHdEdwNOhsszDBFEjNaccfjvWmieBohNgwM7Q
        ZWH+2M/gqAZoWl8o5utOt/txyu+Awk3bR1852vk=
X-Google-Smtp-Source: AA6agR59RojMz500FY9wMkc+ZDTd6G4C7RpllKwE2pRYLUP/yeaNuBVMfPUG2iwbv/PAERq8xADzGEEGtpXeocXysuk=
X-Received: by 2002:a4a:2243:0:b0:44a:e5cf:81e5 with SMTP id
 z3-20020a4a2243000000b0044ae5cf81e5mr11797640ooe.44.1662080218037; Thu, 01
 Sep 2022 17:56:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Thu, 1 Sep 2022 17:56:57
 -0700 (PDT)
In-Reply-To: <YxEot6I5d4PWtrz9@jeremy-acer>
References: <YxDaZxljVqC/4Riu@jeremy-acer> <20220901174108.24621-1-atteh.mailbox@gmail.com>
 <YxD6SEN9/3rEWaNR@jeremy-acer> <CAN05THRgWMEejOMTozrf0F4sENxJEQYu2i-9CKWO+Qh0kvjveg@mail.gmail.com>
 <CAH2r5mvUzbp8RcM7+XFbJsoiba964vpKQiMRmGeQovGabe+j=Q@mail.gmail.com> <YxEot6I5d4PWtrz9@jeremy-acer>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 2 Sep 2022 09:56:57 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8SSQ+GpL=Na0OSFxOGSy-r7TW8Q+X-ZLaH-uLZQ1XauQ@mail.gmail.com>
Message-ID: <CAKYAXd8SSQ+GpL=Na0OSFxOGSy-r7TW8Q+X-ZLaH-uLZQ1XauQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: update documentation
To:     Jeremy Allison <jra@samba.org>
Cc:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        atheik <atteh.mailbox@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-02 6:48 GMT+09:00, Jeremy Allison <jra@samba.org>:
> On Thu, Sep 01, 2022 at 04:37:21PM -0500, Steve French wrote:
>>
>>I do like that Namjae et al made the format of the .conf file very similar
>>to the format of Samba's smb.conf file though.   I realize there some
>>users complain that there are too many smb.conf parameters for Samba,
>>but he seemed to pick a reasonably subset of them for ksmbd.
>>Samba is a much larger project with many more smb.conf parameters
>>but it does reduce confusion making the parameter names similar
>>where possible e.g. "workgroup", "guest account", (share) path, read only,
>> etc.
>>and fortunately the default directories for the two smb.conf files are
>>different so at least the daemons don't use the same file.
>
> Sure, I think the formats and parameter names being as close
> as possible is a great idea to allow users to move between
> servers as they wish. But making the files the same name
> is not a good idea.
This is the first time I've heard that it is problem that ksmbd's
config filename is same with samba's one. Reading the mail threads, I
don't understand exactly what the real problem is... I thought that
using same smb.conf name make users aware that it was forked from
samba's one. I'm a little surprised, I thought that you will say that
we should use the same name. This seems to contradict your previous
opinion that ksmbd's dos attribute and stream xattr format should be
the same with samba's one. It's not difficult to change config
filename of ksmbd if you agree with it. If we think about adding the
ksmbd integration feature in samba recently, I think it would be
better to use the same name for future.
