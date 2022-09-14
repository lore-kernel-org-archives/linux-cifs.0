Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D37C6ECAAD8
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Sep 2022 10:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiINKg1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Sep 2022 06:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiINKgZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Sep 2022 06:36:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637BF5E323
        for <linux-cifs@vger.kernel.org>; Wed, 14 Sep 2022 03:36:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00B0D61BAF
        for <linux-cifs@vger.kernel.org>; Wed, 14 Sep 2022 10:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CABFC43141
        for <linux-cifs@vger.kernel.org>; Wed, 14 Sep 2022 10:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663151783;
        bh=Q6zWFhRGmZgYZ/uLGqZV+3FvMFVwxumRgcCNEC2XVWg=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=QhZ5MniHZsznvj3bYgvo+ugb3dXxQbdiJT2LJCQTztZZI5Z/F5EXGCtDAISbxQuY2
         dB1Q0U545PsjAelC6bDTpFzcLGl2dVItRdeuWF7kF1CT8tXiRImDq0dV/IBjIvdCQ1
         l6LTf91TtpyDCXSgRo8ZparBr1+fQGeTw07A/9ergy/6/Qox1VE+1D7gEkNRNE+1uh
         HKr6AxmLGflUl59WyUZDwo4FM7hddvCUKifxxR6bLlrCViPVwGdMbpxwkjX3nxUAk/
         LUkTKW/cjYMRX3dSWMM3rLorXhvypHBGRt88WYAV3DnDc75+cbe8dsfdotgjv9fYUC
         ZArF+/Y2iS8Ng==
Received: by mail-ot1-f41.google.com with SMTP id q39-20020a056830442700b0063889adc0ddso10037824otv.1
        for <linux-cifs@vger.kernel.org>; Wed, 14 Sep 2022 03:36:23 -0700 (PDT)
X-Gm-Message-State: ACgBeo2sTJeToplThXi0xOBQDaWa0876bDfM62oE3m7WFKFeUKKSTL3i
        qhitV6vL9T5cNeX953PulG5YwlEfULn0TmsAyII=
X-Google-Smtp-Source: AA6agR7WsubN2bzkUtyPmMwWItyLdQAV9PSnFY8SIVoX8FCS/Qnp5QZmz8CY8TX/ork2nMch1bL2vh0jKPPtHEO+fcE=
X-Received: by 2002:a05:6830:418a:b0:639:683b:82c7 with SMTP id
 r10-20020a056830418a00b00639683b82c7mr14586432otu.187.1663151782479; Wed, 14
 Sep 2022 03:36:22 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Wed, 14 Sep 2022 03:36:21
 -0700 (PDT)
In-Reply-To: <388d1257-419e-f0c8-348f-587f5c0a51ee@talpey.com>
References: <20220909092558.9498-1-linkinjeon@kernel.org> <20220909092558.9498-2-linkinjeon@kernel.org>
 <a5f680f2-6dc3-1c0b-bfbb-51f740e09109@talpey.com> <CAKYAXd_4gpMU_0z9ed7ktP3zQ0doUqsWi1QqiJ_1v6Y25C9MDg@mail.gmail.com>
 <388d1257-419e-f0c8-348f-587f5c0a51ee@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 14 Sep 2022 19:36:21 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-g1fwnsmUYEiQ1_r-ZXacu69UC3vqZRxGWEe__D4G4Rw@mail.gmail.com>
Message-ID: <CAKYAXd-g1fwnsmUYEiQ1_r-ZXacu69UC3vqZRxGWEe__D4G4Rw@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: update documentation
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-14 4:02 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/12/2022 4:54 PM, Namjae Jeon wrote:
>> 2022-09-13 8:38 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>> On 9/9/2022 5:25 AM, Namjae Jeon wrote:
>>>> configuration.txt in ksmbd-tools moved to ksmbd.conf manpage.
>>>> update it and more detailed ksmbd-tools build method.
>>>>
>>>> Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
>>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>>> ---
>>>>    v3:
>>>>      - replace CIFS with SMB3 clients.
>>>>      - update ksmbd built-in case.
>>>>      - replace smb.conf leftover with ksmbd.conf.
>>>>      - use full name of utils in ksmbd-tools instead of <foo>.
>>>>      - fix the warnings from make htlmdocs build reported by kernel
>>>> test
>>>>        robot.
>>>>    v2:
>>>>      - rename smb.conf to ksmbd.conf.
>>>>      - add how to set ksmbd module in menuconfig
>>>>      - remove --syscondir option for configure, instead change ksmbd
>>>>        directory to /usr/local/etc/ksmbd.
>>>>      - change the prompt to '$'.
>>>>
>>>>    Documentation/filesystems/cifs/ksmbd.rst | 40
>>>> +++++++++++++++++-------
>>>>    1 file changed, 29 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/Documentation/filesystems/cifs/ksmbd.rst
>>>> b/Documentation/filesystems/cifs/ksmbd.rst
>>>> index 1af600db2e70..4284341c89f3 100644
>>>> --- a/Documentation/filesystems/cifs/ksmbd.rst
>>>> +++ b/Documentation/filesystems/cifs/ksmbd.rst
>>>> @@ -118,26 +118,44 @@ ksmbd/nfsd interoperability    Planned for
>>>> future.
>>>> The features that ksmbd
>>>>    How to run
>>>>    ==========
>>>>
>>>> -1. Download ksmbd-tools and compile them.
>>>> -	- https://github.com/cifsd-team/ksmbd-tools
>>>> +1. Download
>>>> ksmbd-tools(https://github.com/cifsd-team/ksmbd-tools/releases) and
>>>> +   compile them.
>>>> +
>>>> +   - Refer
>>>> README(https://github.com/cifsd-team/ksmbd-tools/blob/master/README.md)
>>>> +     to know how to use ksmbd.mountd/adduser/addshare/control utils
>>>> +
>>>> +     $ ./autogen.sh
>>>> +     $ ./configure --with-rundir=/run
>>>> +     $ make && sudo make install
>>>>
>>>>    2. Create user/password for SMB share.
>>>>
>>>> -	# mkdir /etc/ksmbd/
>>>> -	# ksmbd.adduser -a <Enter USERNAME for SMB share access>
>>>> +   - See ksmbd.adduser manpage.
>>>> +
>>>> +     $ man ksmbd.adduser
>>>> +     $ sudo ksmbd.adduser -a <Enter USERNAME for SMB share access>
>>>> +
>>>> +3. Create /usr/local/etc/ksmbd/ksmbd.conf file, add SMB share in
>>>> ksmbd.conf file.
>>>
>>> I missed this in the v2 match - are you intentionally moving the
>>> ksmbd.conf file to /usr/local/etc? That seems a very mysterious
>>> location. Nothing on my vanilla installed system places anything
>>> in there.
>> To avoid conflicts with the existing distribution package, the default
>> location as far as I know is /usr/local/etc. And it can be changed
>> with --sysconfdir. It is same with samba.
>
> I totally disagree with this. The kernel server is part of, well,
> the kernel, and loading the kernel should not depend on a path like
> /usr/local/etc.
You should consider ksmbd-tools included ksmbd.mountd also.
To start running ksmbd server, ksmbd.mountd should be launched.
> Also, nothing I know, including Samba, is deployed
> with such a directory in my experience. I find smb.conf in /etc/samba.
If you build samba by default, it is installed into /usr/local.
/etc/samba/ location you are saying is installed by package manager.

>
> Where are the ksmbd.<foo> helpers installed by default? /usr/local/sbin?
> On my standard Ubuntu install (and presumably Debian?) they are in
> /sbin.
I think that you are confusing binary of ksmbd-tools which installed
by package manager.
make & make install in ksmbd-tools directory and can see them in
/usr/local/sbin/ .

>
> Tom.
>
>>> Also, doesn't this file need to exist before step 2??
>> Ah, Yes. Will switch them.
>>
>> Thanks for your review!
>>>
>>> Tom.
>>>
>>>
>>>> -3. Create /etc/ksmbd/smb.conf file, add SMB share in smb.conf file
>>>> -	- Refer smb.conf.example and
>>>> -
>>>> https://github.com/cifsd-team/ksmbd-tools/blob/master/Documentation/configuration.txt
>>>> +   - Refer ksmbd.conf.example in ksmbd-utils, See ksmbd.conf manpage
>>>> +     for details to configure shares.
>>>>
>>>> -4. Insert ksmbd.ko module
>>>> +        $ man ksmbd.conf
>>>>
>>>> -	# insmod ksmbd.ko
>>>> +4. Insert ksmbd.ko module after build your kernel. No need to load
>>>> module
>>>> +   if ksmbd is built into the kernel.
>>>> +
>>>> +   - Set ksmbd in menuconfig(e.g. $ make menuconfig)
>>>> +       [*] Network File Systems  --->
>>>> +           <M> SMB3 server support (EXPERIMENTAL)
>>>> +
>>>> +	$ sudo modprobe ksmbd.ko
>>>>
>>>>    5. Start ksmbd user space daemon
>>>> -	# ksmbd.mountd
>>>>
>>>> -6. Access share from Windows or Linux using CIFS
>>>> +	$ sudo ksmbd.mountd
>>>> +
>>>> +6. Access share from Windows or Linux SMB3 clients (cifs.ko or
>>>> smbclient
>>>> of samba)
>>>>
>>>>    Shutdown KSMBD
>>>>    ==============
>>>
>>
>
