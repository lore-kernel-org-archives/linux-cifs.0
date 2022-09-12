Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDBB5C6FA82
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Sep 2022 23:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiILXyV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Sep 2022 19:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiILXyU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 12 Sep 2022 19:54:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6F751438
        for <linux-cifs@vger.kernel.org>; Mon, 12 Sep 2022 16:54:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21A0CB80E04
        for <linux-cifs@vger.kernel.org>; Mon, 12 Sep 2022 23:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BC9C433C1
        for <linux-cifs@vger.kernel.org>; Mon, 12 Sep 2022 23:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663026856;
        bh=/qOYXCR2q3ybRtqFxiaBPpBQ62P/YqlQ6X/XHnpnd5c=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=dFGYQjJzxZt3vjAI3ArjlLL6MMk2VdKRxny8ZvNxQB/xkCHKKDiWddrphEogVjyjW
         RZrU0LGwkPPFE1A6WURiQVNazYXY0qt6jgN0nHpujaaDn9KgXLETwvyguxRWpOecA2
         J4eQ2nvQGcr0IjSfOjmKo4TsQqR9ibRei5LAg4HL5PoVhdcfxayHYSr87ov5hZy949
         Z5OmJRdfL/vctC4d9jbxqua2Ijw5VofKKh1HZueyhNywHK/z/Jxw5PwxgjtMLBCo9h
         /6KQRG56uJRn2LoouQoHh1j12LkAmLqHpELBf9r6UQAQh7Z2s/Kxc1sI6wUIIROHdp
         kErEq319+YsSw==
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-127f5411b9cso27734812fac.4
        for <linux-cifs@vger.kernel.org>; Mon, 12 Sep 2022 16:54:16 -0700 (PDT)
X-Gm-Message-State: ACgBeo2i6jtqrNAqkSz+mahjyFui0tSpk3UM6uThm5xV4lF/nLnlv2GA
        ekcgiKF9w/i8y7hm+AqVJgakExR5ncWfJbblX18=
X-Google-Smtp-Source: AA6agR5ErPUkzcEj/spehq+iMAyOY3Fr8Rb8ba8TrKZ9NaUYj8s4BI8ibjTqNbYd0eahaoIx6vwvFYtKBhtJmwdU4T8=
X-Received: by 2002:a05:6870:b290:b0:127:4089:227a with SMTP id
 c16-20020a056870b29000b001274089227amr487263oao.8.1663026855722; Mon, 12 Sep
 2022 16:54:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Mon, 12 Sep 2022 16:54:14
 -0700 (PDT)
In-Reply-To: <a5f680f2-6dc3-1c0b-bfbb-51f740e09109@talpey.com>
References: <20220909092558.9498-1-linkinjeon@kernel.org> <20220909092558.9498-2-linkinjeon@kernel.org>
 <a5f680f2-6dc3-1c0b-bfbb-51f740e09109@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 13 Sep 2022 08:54:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_4gpMU_0z9ed7ktP3zQ0doUqsWi1QqiJ_1v6Y25C9MDg@mail.gmail.com>
Message-ID: <CAKYAXd_4gpMU_0z9ed7ktP3zQ0doUqsWi1QqiJ_1v6Y25C9MDg@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: update documentation
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-13 8:38 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/9/2022 5:25 AM, Namjae Jeon wrote:
>> configuration.txt in ksmbd-tools moved to ksmbd.conf manpage.
>> update it and more detailed ksmbd-tools build method.
>>
>> Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   v3:
>>     - replace CIFS with SMB3 clients.
>>     - update ksmbd built-in case.
>>     - replace smb.conf leftover with ksmbd.conf.
>>     - use full name of utils in ksmbd-tools instead of <foo>.
>>     - fix the warnings from make htlmdocs build reported by kernel test
>>       robot.
>>   v2:
>>     - rename smb.conf to ksmbd.conf.
>>     - add how to set ksmbd module in menuconfig
>>     - remove --syscondir option for configure, instead change ksmbd
>>       directory to /usr/local/etc/ksmbd.
>>     - change the prompt to '$'.
>>
>>   Documentation/filesystems/cifs/ksmbd.rst | 40 +++++++++++++++++-------
>>   1 file changed, 29 insertions(+), 11 deletions(-)
>>
>> diff --git a/Documentation/filesystems/cifs/ksmbd.rst
>> b/Documentation/filesystems/cifs/ksmbd.rst
>> index 1af600db2e70..4284341c89f3 100644
>> --- a/Documentation/filesystems/cifs/ksmbd.rst
>> +++ b/Documentation/filesystems/cifs/ksmbd.rst
>> @@ -118,26 +118,44 @@ ksmbd/nfsd interoperability    Planned for future.
>> The features that ksmbd
>>   How to run
>>   ==========
>>
>> -1. Download ksmbd-tools and compile them.
>> -	- https://github.com/cifsd-team/ksmbd-tools
>> +1. Download
>> ksmbd-tools(https://github.com/cifsd-team/ksmbd-tools/releases) and
>> +   compile them.
>> +
>> +   - Refer
>> README(https://github.com/cifsd-team/ksmbd-tools/blob/master/README.md)
>> +     to know how to use ksmbd.mountd/adduser/addshare/control utils
>> +
>> +     $ ./autogen.sh
>> +     $ ./configure --with-rundir=/run
>> +     $ make && sudo make install
>>
>>   2. Create user/password for SMB share.
>>
>> -	# mkdir /etc/ksmbd/
>> -	# ksmbd.adduser -a <Enter USERNAME for SMB share access>
>> +   - See ksmbd.adduser manpage.
>> +
>> +     $ man ksmbd.adduser
>> +     $ sudo ksmbd.adduser -a <Enter USERNAME for SMB share access>
>> +
>> +3. Create /usr/local/etc/ksmbd/ksmbd.conf file, add SMB share in
>> ksmbd.conf file.
>
> I missed this in the v2 match - are you intentionally moving the
> ksmbd.conf file to /usr/local/etc? That seems a very mysterious
> location. Nothing on my vanilla installed system places anything
> in there.
To avoid conflicts with the existing distribution package, the default
location as far as I know is /usr/local/etc. And it can be changed
with --sysconfdir. It is same with samba.
>
> Also, doesn't this file need to exist before step 2??
Ah, Yes. Will switch them.

Thanks for your review!
>
> Tom.
>
>
>> -3. Create /etc/ksmbd/smb.conf file, add SMB share in smb.conf file
>> -	- Refer smb.conf.example and
>> -
>> https://github.com/cifsd-team/ksmbd-tools/blob/master/Documentation/configuration.txt
>> +   - Refer ksmbd.conf.example in ksmbd-utils, See ksmbd.conf manpage
>> +     for details to configure shares.
>>
>> -4. Insert ksmbd.ko module
>> +        $ man ksmbd.conf
>>
>> -	# insmod ksmbd.ko
>> +4. Insert ksmbd.ko module after build your kernel. No need to load
>> module
>> +   if ksmbd is built into the kernel.
>> +
>> +   - Set ksmbd in menuconfig(e.g. $ make menuconfig)
>> +       [*] Network File Systems  --->
>> +           <M> SMB3 server support (EXPERIMENTAL)
>> +
>> +	$ sudo modprobe ksmbd.ko
>>
>>   5. Start ksmbd user space daemon
>> -	# ksmbd.mountd
>>
>> -6. Access share from Windows or Linux using CIFS
>> +	$ sudo ksmbd.mountd
>> +
>> +6. Access share from Windows or Linux SMB3 clients (cifs.ko or smbclient
>> of samba)
>>
>>   Shutdown KSMBD
>>   ==============
>
