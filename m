Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67512ECAAA1
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Sep 2022 23:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiIFXqs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Sep 2022 19:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIFXqr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Sep 2022 19:46:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B58C91084
        for <linux-cifs@vger.kernel.org>; Tue,  6 Sep 2022 16:46:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F00C8B81A20
        for <linux-cifs@vger.kernel.org>; Tue,  6 Sep 2022 23:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F122C433C1
        for <linux-cifs@vger.kernel.org>; Tue,  6 Sep 2022 23:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662508003;
        bh=jGMQ541/HybnPHmogV8z+1O2X9QImOH7/rhWf+u3QG4=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=MiIseyUEiWZS9dV5AX+Ph174K1Umb3TlG+WhmFm6qFvJ4AGj41toN/WOhRs4ySXKr
         rDbpDI69ywXg0uJ6Qtn2DAfgvSbvxncI1pk6sVDAvqZWOTSKhCtaK8YrNTDLJsghBn
         N9/1FGdVYjyqnkis0SqLuWRgfpdjfR7g4U0jkbHWzkKwqWHS3LFnTuuJlv1ZqVmlU7
         bbxQJg1Kx476IGCY4qsGebFETDpj9LmWTMttifbyPPRYdeR722OZIXe6mT4fGKwjjk
         Prl26qwzg/shRibYulSduvhg2YyMLxeC32zcCYdosDt1DOZopFGhKCAZVCxCetl0wa
         P8+vAmFJjqQ0g==
Received: by mail-ot1-f41.google.com with SMTP id l5-20020a05683004a500b0063707ff8244so9128186otd.12
        for <linux-cifs@vger.kernel.org>; Tue, 06 Sep 2022 16:46:43 -0700 (PDT)
X-Gm-Message-State: ACgBeo2BOqe85jsFAIxMMwPeTgeR/QRa7KkSsBMAhxqiz67I99LDfIeh
        awgPVvJONIbmPZ2RUmHI0LYAG4PQoRPJJWEJefI=
X-Google-Smtp-Source: AA6agR6I1442XVcH8xGZ78pm9Brvk8cEBtKf8PqQZTw5Cew0IutQBLuebwNa3YGoN5oWuFJ05MivKaS+QPuQzKknjRY=
X-Received: by 2002:a9d:7519:0:b0:636:d935:ee8e with SMTP id
 r25-20020a9d7519000000b00636d935ee8emr384697otk.339.1662508002746; Tue, 06
 Sep 2022 16:46:42 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Tue, 6 Sep 2022 16:46:42
 -0700 (PDT)
In-Reply-To: <356b6557-fa62-b611-8ef2-df9ca10a28c7@talpey.com>
References: <20220906015823.12390-1-linkinjeon@kernel.org> <356b6557-fa62-b611-8ef2-df9ca10a28c7@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 7 Sep 2022 08:46:42 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8bo2DS8HFpd=Gq3VFQ_P8rvBfSNAK08h6aSgKZ21cH1g@mail.gmail.com>
Message-ID: <CAKYAXd8bo2DS8HFpd=Gq3VFQ_P8rvBfSNAK08h6aSgKZ21cH1g@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: update documentation
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, hyc.lee@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-07 2:09 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/5/2022 9:58 PM, Namjae Jeon wrote:
>> configuration.txt in ksmbd-tools moved to ksmb.conf manpage.
>> update it and more detailed ksmbd-tools build method.
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   v2:
>>     - rename smb.conf to ksmbd.conf.
>>     - add how to set ksmbd module in menuconfig
>>     - remove --syscondir option for configure, instead change ksmbd
>>       directory to /usr/local/etc/ksmbd.
>>     - change the prompt to '$'.
>>
>>   Documentation/filesystems/cifs/ksmbd.rst | 32 ++++++++++++++++--------
>>   1 file changed, 22 insertions(+), 10 deletions(-)
>>
>> diff --git a/Documentation/filesystems/cifs/ksmbd.rst
>> b/Documentation/filesystems/cifs/ksmbd.rst
>> index 1af600db2e70..69d4a4c3313b 100644
>> --- a/Documentation/filesystems/cifs/ksmbd.rst
>> +++ b/Documentation/filesystems/cifs/ksmbd.rst
>> @@ -118,24 +118,36 @@ ksmbd/nfsd interoperability    Planned for future.
>> The features that ksmbd
>>   How to run
>>   ==========
>>
>> -1. Download ksmbd-tools and compile them.
>> -	- https://github.com/cifsd-team/ksmbd-tools
>> +1. Download
>> ksmbd-tools(https://github.com/cifsd-team/ksmbd-tools/releases) and
>> compile them.
>> +   - Refer
>> README(https://github.com/cifsd-team/ksmbd-tools/blob/master/README.md)
>> +     to know how to use ksmbd.<foo> utils
>
> I suggest typing out "<foo>" to include mountd, adduser and addshare.
Okay.
>
>> +
>> +     $ ./autogen.sh
>> +     $ ./configure --with-rundir=/run
>> +     $ make && sudo make install
>>
>>   2. Create user/password for SMB share.
>> +   - See ksmbd.adduser manpage.
>> +
>> +     $ man ksmbd.adduser
>> +     $ sudo ksmbd.adduser -a <Enter USERNAME for SMB share access>
>>
>> -	# mkdir /etc/ksmbd/
>> -	# ksmbd.adduser -a <Enter USERNAME for SMB share access>
>> +3. Create /usr/local/etc/ksmbd/ksmbd.conf file, add SMB share in smb.conf
>> file.
>
> Typo - "ksmbd.conf" -------------------------------------------------^
Will fix it.
>
> Wouldn't the ksmbd.addshare command be a safer way to do this?
ksmbd.addshare can't update global section now. So I thought it seems
appropriate to edit ksmbd.conf directly in the initial running. If you
still need to add, please let me know.

>
>> +   - Refer ksmbd.conf.example in ksmbd-utils, See ksmbd.conf manpage
>> +     for details to configure shares.
>
> This way is fine too, but as an alternative for power users.
Okay, I understood that there is no more update and sound fine.
>
>>
>> -3. Create /etc/ksmbd/smb.conf file, add SMB share in smb.conf file
>> -	- Refer smb.conf.example and
>> -
>> https://github.com/cifsd-team/ksmbd-tools/blob/master/Documentation/configuration.txt
>> +        $ man ksmbd.conf
>>
>> -4. Insert ksmbd.ko module
>> +4. Insert ksmbd.ko module after build your kernel.
>
> Can't ksmbd be built-in as well?
Probably add this comment for this.
  4. Insert ksmbd.ko module (no need to load module if ksmbd is built
into the kernel)

>
>> +   - Set ksmbd in menuconfig(e.g. $ make menuconfig)
>> +       [*] Network File Systems  --->
>> +           <M> SMB server support
>>
>> -	# insmod ksmbd.ko
>> +	$ sudo insmod ksmbd.ko
>>
>>   5. Start ksmbd user space daemon
>> -	# ksmbd.mountd
>> +
>> +	$ sudo ksmbd.mountd
>>
>>   6. Access share from Windows or Linux using CIFS
>
> "SMB2 or SMB3" ----------------------------------^
Okay, Will update like this.
 SMB3 client (cifs.ko or smbclient of samba)

Thanks for your review!
>
> Tom.
>
