Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB9FBC433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Sep 2021 15:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C83C60EE5
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Sep 2021 15:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhIZPdr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 26 Sep 2021 11:33:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231997AbhIZPdq (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 26 Sep 2021 11:33:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4237860EE5
        for <linux-cifs@vger.kernel.org>; Sun, 26 Sep 2021 15:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632670330;
        bh=TZEsg9qlLymsZcGPmdtBqziwHGrb3f6hZXSxCHokyUM=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=CKVAPMBkE7PCl0XDd7/S5OYniJbZS6OZPUg6lzR9EJP2H3fmq1FwW2TnLFTkYBNXc
         zCUSig7bAO//hPRgnteDKfNEaRNEwLXwIR1cp4YS+Oy4Lka8Z6IS12j3+eHDE6YjQF
         U7Xj/qBZ39sCORUiYx02Kau8roYifdqhzmYsrF+XGnQIoH+ZDwgzRbT1oyzWEo98hh
         N549MNsG+IE8pbLbhvVBDqyQjzaYvu40mhBgttn4Er0aSx8AQoT7s0LaN3OUQ+tQH+
         644v1to9ko7HRCFCuvdWIOjK7L4I5vVU5nWAjtUKKPI2UeASDuDyMp0RfBG7Ihdbwd
         0EVN21TSDrBwA==
Received: by mail-ot1-f47.google.com with SMTP id 5-20020a9d0685000000b0054706d7b8e5so20821801otx.3
        for <linux-cifs@vger.kernel.org>; Sun, 26 Sep 2021 08:32:10 -0700 (PDT)
X-Gm-Message-State: AOAM532KB2KVzVvGLtsL8W+30zacXtDb2AgxB43mKwjSe1MyEI4zlSrJ
        OR60CErQ6opAgzGXrz7Qot5lDAl2YL8/UW/X4sI=
X-Google-Smtp-Source: ABdhPJyhkEN2ncJh5dKxIF3FgBCt47weiHaehnS7BBXDL8PUpKeYS9gXlSfRo32n+M0LzjXClBtF0asXBHi8ibUdL2A=
X-Received: by 2002:a9d:4705:: with SMTP id a5mr13327068otf.237.1632670329640;
 Sun, 26 Sep 2021 08:32:09 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Sun, 26 Sep 2021 08:32:09
 -0700 (PDT)
In-Reply-To: <a1fc90f5-3e35-98f7-b932-7eee62200de0@samba.org>
References: <20210926135543.119127-1-linkinjeon@kernel.org> <a1fc90f5-3e35-98f7-b932-7eee62200de0@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 27 Sep 2021 00:32:09 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9b-V26ppPRWbo9z1QX=ez0XT3HsPoDJ-8Za+XtN6wLTQ@mail.gmail.com>
Message-ID: <CAKYAXd9b-V26ppPRWbo9z1QX=ez0XT3HsPoDJ-8Za+XtN6wLTQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-26 23:27 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Am 26.09.21 um 15:55 schrieb Namjae Jeon:
>> Cc: Tom Talpey <tom@talpey.com>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
>>
>> v2:
>>    - update comments of smb2_get_data_area_len().
>>    - fix wrong buffer size check in fsctl_query_iface_info_ioctl().
>>    - fix 32bit overflow in smb2_set_info.
>>
>> v3:
>>    - add buffer check for ByteCount of smb negotiate request.
>>    - Moved buffer check of to the top of loop to avoid unneeded behavior
>> when
>>      out_buf_len is smaller than network_interface_info_ioctl_rsp.
>>    - get correct out_buf_len which doesn't exceed max stream protocol
>> length.
>>    - subtract single smb2_lock_element for correct buffer size check in
>>      ksmbd_smb2_check_message().
>
> looks like you haven't pushed those to github yet? At least I don't see
> an update to ksmbd-for-next-pending.
>
> I'd prefer fetching from git to review the patches. I also have a few
> patches on top.
Done, Please check it:)

Thanks!
>
> Thanks!
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
