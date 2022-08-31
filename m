Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6CE8ECAAA1
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 01:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiHaBhE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 21:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiHaBhD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 21:37:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173A8FC
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 18:37:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB2C3618CF
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 01:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164C1C433D6
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 01:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661909821;
        bh=tOovBkgiPYBjR2vWj/I8zucODmJYrvlTjlDNwDBNwCg=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=paijKlUsLERUKlCjlkOg+uPVyVTY/yby63mi6m59JsWpjWc/C3WCuTca0sZ7ap0oZ
         0nRcU8h8AqBpO381zcw/RMT+FC6CXL53Xd88b0sHvTc3tYL70AvVI9c0LvfC9/8XUp
         2ImlSTNpIyKHoI0uoI9/jZGj1/ZFBj0T3+NDbOlVPeaMokmiFr93F/Aw+GaXeEhNCc
         G1XohFehNUv+CBrtCmBR8lb7fB7reUgDXjMD0ApnaK5ZMOP7qkHEhPw/B8PIPa9hQ+
         fwvcdXWJp+GQkoWx8kPzMGv+nQ/FTC6yztwtEhDpV6aGTNaPfKGrk63Dy3rwirS/CF
         CnWQQILwTJwLg==
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-11c4d7d4683so21003260fac.8
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 18:37:01 -0700 (PDT)
X-Gm-Message-State: ACgBeo2ulAsiSuWtpMT5TQSJYwIYz/bU/yyMsZ6Tfth4QW/Rm44pGps5
        NPukmgc8X/Xw2mpw32mGch+MrDzqpQ5f7EaQTYk=
X-Google-Smtp-Source: AA6agR6C3HgvGvjgcNosdB22RVBL6uX5uxrE+uo0Ag7qr3jWowhLummFckllWsk3aSC8BkSEWRbD46/L7UmN1/0h1iE=
X-Received: by 2002:a54:4696:0:b0:343:46c5:9b2c with SMTP id
 k22-20020a544696000000b0034346c59b2cmr346176oic.8.1661909820190; Tue, 30 Aug
 2022 18:37:00 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Tue, 30 Aug 2022 18:36:59
 -0700 (PDT)
In-Reply-To: <47dbb75a-b299-066c-61cc-2b21ca96173f@talpey.com>
References: <20220830141732.9982-1-linkinjeon@kernel.org> <47dbb75a-b299-066c-61cc-2b21ca96173f@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 31 Aug 2022 10:36:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd94kt+SY+Qs6ohXwWYEpXYd26WNFEOEft0bs6zuEEp6aQ@mail.gmail.com>
Message-ID: <CAKYAXd94kt+SY+Qs6ohXwWYEpXYd26WNFEOEft0bs6zuEEp6aQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: update documentation
To:     Tom Talpey <tom@talpey.com>, atteh.mailbox@gmail.com
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, hyc.lee@gmail.com,
        senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-08-31 1:13 GMT+09:00, Tom Talpey <tom@talpey.com>:
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
>
> I believe you mean "make && sudo make install"? The single & will
> kick off two make's in parallel.
Will fix it.
>
>>   2. Create user/password for SMB share.
>>
>>   	# mkdir /etc/ksmbd/
>>   	# ksmbd.adduser -a <Enter USERNAME for SMB share access>
>
> It may be worth mentioning that it's not just single-user access, and
> that additional users can be configured.
Ah, Okay. Let me think more..
>
>>   3. Create /etc/ksmbd/smb.conf file, add SMB share in smb.conf file
>> -	- Refer smb.conf.example and
>> -
>> https://github.com/cifsd-team/ksmbd-tools/blob/master/Documentation/configuration.txt
>> +	- Refer smb.conf.example, See smb.conf(5ksmbd) for details.
>> +
>> +        # man smb.conf.5ksmbd
>
> I like the new manpage, but that's a strange path. Are you sure
> the various maintainers will deploy it that way?
I was sure there won't be any strong comments, as We've used the MIT
Kerberos (krb5-doc) case as an example. If samba is not installed, man
smb.conf show ksmbd's one.
>
> Also, it has always bothered me that the name "smb.conf" is the
> same as the Samba server's configuration file, just in a different
> directory. If someone enters "man smb.conf", there may be confusion.
> I really wish the file was called "ksmbd.conf".
The initial idea was to make the configuration compatible with samba.
Users copy it to ksmbd directory and reuse the smb.conf file they used
in samba as it is. And I have no strong opinion to renaming it to
ksmbd.conf(i.e. man ksmb.conf).  Atte, Any thought about this ?

>
> Why not putting this under a simpler manpage title "man ksmbd"?
> To me, that's much more logical and it avoids both the confusion
> and having to somehow know that weird manpath.
Is it possible to add it to manpage even though a utility or
configuration file named ksmbd doesn't exist? That is, as if there is
no "man nfs".
>
>>   4. Insert ksmbd.ko module
>>
>>   	# insmod ksmbd.ko
>
> Well, it's worth mentioning that a properly configured and built
> kernel is a prerequisite here...
Okay.
>
> Also, sudo.
>
>>   5. Start ksmbd user space daemon
>> +
>>   	# ksmbd.mountd
>
> FYI, Ubuntu Jammy pre-configures ksmbd as a service, and there it's
> as simple as "sudo service ksmbd start".
Is this command available on all distributions?

>
> Do you not want to mention the other ksmbd.<foo> helpers here?
Other ksmbd utils are described in README of ksmbd-tools github, so I
did not list them here.
>
>>   6. Access share from Windows or Linux using CIFS
>
> Pointer to cifs.ko how-to page?
Do you know of a page link for cifs.ko?
>
> Basically, I'm encouraging these pages to be (much) more user
> friendly! They're fine for developers, but way too fiddly IMO
> for naive users, or even for admins. It has taken me days to get
> this all going on my fresh machines.
okay..
>
> Either way, thanks for the cleanup so far!!
Thanks!
>
> Tom.
>
