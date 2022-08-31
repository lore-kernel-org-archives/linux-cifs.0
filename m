Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56054ECAAA1
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 00:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiHaACh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 20:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiHaACg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 20:02:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D383A67450
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 17:02:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66D1A61785
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 00:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87FBC433C1
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 00:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661904153;
        bh=7E/WvdMjoko15AxtksvRPS8hjmFKuuZi4QCJMvdDgno=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=cjH9N2a0bopBrvm2qXR8GxlJ82IkNKdAhfEdsZ1lJND8BSGhbN88NUA5zh4BVnR61
         aommOtIkFW3FZgh5YZnIepyIuIJjcClKwb2iFQZfe1R6DVHUTFR2Jlo/bcVSldGwVl
         PVNwIoUgE87VnuwdRzgrzcwtmi/UDeRhayNd93Vm6Srq9q89N3kCjhm3eOsSn1jizi
         LKgPrq6wm0tKx8ueyNk2W5/IplUqnkQpoTLmgUPaq6sC5d7J8aXtJ2HArTgzQpieC7
         BujFwLCc1f9Zb8FHdw+lPDrm7Bqq0m9LuVRrxLW6EFyVAKPbp25EOVtoluQFRvZT2a
         Btfp8xLPJjjEg==
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-11f0fa892aeso12377503fac.7
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 17:02:33 -0700 (PDT)
X-Gm-Message-State: ACgBeo2S+VwtmemPyDoIx0fI18WCbvnwtOtRn6jSN1SYK6WQuKscsE/w
        Jcx2ACYte2wh9wagkjyCXZsy5MC+dv0K3TJ0WJ8=
X-Google-Smtp-Source: AA6agR67BXpHzRZ1P1/ivblqXpJQInvrSHaulWzDNcOyAOnc+zO1t+pbaeIqDFngsicX2srFWIbiNsfMWNMPcBvCrEk=
X-Received: by 2002:a54:4696:0:b0:343:46c5:9b2c with SMTP id
 k22-20020a544696000000b0034346c59b2cmr225747oic.8.1661904152971; Tue, 30 Aug
 2022 17:02:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Tue, 30 Aug 2022 17:02:32
 -0700 (PDT)
In-Reply-To: <4de37022-ec62-319c-6ee0-89c8491cd102@talpey.com>
References: <20220830141732.9982-1-linkinjeon@kernel.org> <4de37022-ec62-319c-6ee0-89c8491cd102@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 31 Aug 2022 09:02:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9JseWdJq7xavZhNo-bWqovxNdbqn6EQtSQcrJ4v6SBnA@mail.gmail.com>
Message-ID: <CAKYAXd9JseWdJq7xavZhNo-bWqovxNdbqn6EQtSQcrJ4v6SBnA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: update documentation
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, hyc.lee@gmail.com,
        senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-08-31 2:32 GMT+09:00, Tom Talpey <tom@talpey.com>:
> BTW, I expected a "2/2" message, but never saw it. Was the
> subject a typo?
Ah, Yes, 2/2 patch was sent to the list without you cc. I usually send
the patch to the list with maintainers/reviewers, but You have report
the problem about 1/2 patch, So I include you cc tag in the patch.
>
> Anyway, I have a couple of comments on the new file, which are from
> going to
> https://github.com/cifsd-team/ksmbd-tools/blob/master/smb.conf.5ksmbd.in
>
> It refers to "SMB1", but ksmbd removed that, right? And because the
> SMB2 (and SMB3!) dialects don't make it optional, does the setting
> still make sense? Either way, delete "SMB1" and don't restrict the
> discussion to "SMB2":
Okay:)
>
> \fBserver signing\fR (G)
> This controls whether the client is allowed or required to use SMB1 and
> SMB2 signing.
> With \fBserver signing = disabled\fR, SMB1 signing is not offered and
> \fBserver signing = auto\fR applies when negotiating SMB2.
> With \fBserver signing = auto\fR, SMB1 signing is offered and SMB2
> signing is required.
> With \fBserver signing = mandatory\fR, both SMB1 and SMB2 signing is
> required.
>
>
> Also, most of the settings start with the words "This controls whether".
> I find these words unnecessary, and by the third or fourth one, they
> are super-redundant. Would you consider rewording them in a more
> active way, for example:
Okay, I will do that!

Thanks for your review!
>
> \fBbind interfaces only\fR (G)
> This controls whether to only bind to interfaces specified with
> \fBinterfaces\fR.
>
> ... could be:
>
> \fBbind interfaces only\fR (G)
> Only bind to the interfaces specified in the \fBinterfaces\fR setting.
>
> Tom.
>
>
> On 8/30/2022 10:17 AM, Namjae Jeon wrote:
>> configuration.txt in ksmbd-tools moved to smb.conf(5ksmbd) manpage.
>> update it and more detailed ksmbd-tools build method.
>>
>> Cc: Tom Talpey <tom@talpey.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   Documentation/filesystems/cifs/ksmbd.rst | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/filesystems/cifs/ksmbd.rst
>> b/Documentation/filesystems/cifs/ksmbd.rst
>> index 1af600db2e70..767e12d2045a 100644
>> --- a/Documentation/filesystems/cifs/ksmbd.rst
>> +++ b/Documentation/filesystems/cifs/ksmbd.rst
>> @@ -121,20 +121,26 @@ How to run
>>   1. Download ksmbd-tools and compile them.
>>   	- https://github.com/cifsd-team/ksmbd-tools
>>
>> +        # ./autogen.sh
>> +        # ./configure --sysconfdir=/etc --with-rundir=/run
>> +        # make & sudo make install
>> +
>>   2. Create user/password for SMB share.
>>
>>   	# mkdir /etc/ksmbd/
>>   	# ksmbd.adduser -a <Enter USERNAME for SMB share access>
>>
>>   3. Create /etc/ksmbd/smb.conf file, add SMB share in smb.conf file
>> -	- Refer smb.conf.example and
>> -
>> https://github.com/cifsd-team/ksmbd-tools/blob/master/Documentation/configuration.txt
>> +	- Refer smb.conf.example, See smb.conf(5ksmbd) for details.
>> +
>> +        # man smb.conf.5ksmbd
>>
>>   4. Insert ksmbd.ko module
>>
>>   	# insmod ksmbd.ko
>>
>>   5. Start ksmbd user space daemon
>> +
>>   	# ksmbd.mountd
>>
>>   6. Access share from Windows or Linux using CIFS
>
