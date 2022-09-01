Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB934ECAAD1
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Sep 2022 05:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbiIAFTk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 01:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiIAFTj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 01:19:39 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1433F109099
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 22:19:38 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id z29so14233982lfb.13
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 22:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=DCb01U6kIjeylNv+sy4RavZradIJuK915tXONJY07yA=;
        b=nWlJS3oujHKzsX3hnWsKh1h8XK64SZpcfWtXM3SYwOKP7A8fFeLMtwqA2UVtjmgQ1O
         BR4iLJyBAdGtHbHnuJ7ILO1zWhaF5/C1vU2q6+ThfgsqECeYtl0U0wP0k1aS30K/tkyp
         CA/i6+JOGvktShkQgA/uO+Ksm46LpmxuSfY1463ytIHEmWBjuJVafnfrxc93R/H2vFSw
         zY/ysATWVTgMkijH5+eoKgyhApaXkS26WqS6D6xZxxgbiDDMJ67GHP+uFfssVyowf7Km
         QNDHsYDm5PjNbPwdcD3Zj5CuEvOjZkzJwVEZUi19zOrbKJztBey+cPZn47csIHiZoCVo
         fIdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=DCb01U6kIjeylNv+sy4RavZradIJuK915tXONJY07yA=;
        b=H4KN72xbpUt7Ar7PjPCjQcqDMesWuUYR8xx+DyF04j7niyNIDWWwXjrp+/L0YBN2sU
         QKqpyNxCcwHIdtf0rewXwm3U5iZYTby1OabTUO0iL7jtSIUNASlrGYpAWZliS6IVY8yu
         zRA5EC+hT/8loFbn7/ua8/DoTr7tZCMoK3GYw2YM5cq2G7kZfmtYiJNelJFcWSKoAlMO
         GpkfftlC7JsMCepQwl5namb66WfILJSIHZmOLYql+g6dxXrFVeehsTomwZC33cybsXaT
         JLLFP8x6UXYn0wAiDvxw3AYTGuBDkQhxHwFGWHhdMbWQ5qC0nRoUEaK7F9gx5onIFvNZ
         CTVA==
X-Gm-Message-State: ACgBeo0yEtCYLAFIa9X3XoPjODaiXGc2vydyv6/czTZ7G+aEbgGzNqvf
        bmSaB71DuEdSG7zggSeNS/s=
X-Google-Smtp-Source: AA6agR4PWPknOzkypL1BMc8YCzTZEAgiR2kF7VdOlSymxOJNO2QROWCgBCjRqWIl+5vXDHRUAo8IRg==
X-Received: by 2002:ac2:4c88:0:b0:494:96d0:334 with SMTP id d8-20020ac24c88000000b0049496d00334mr1260274lfl.146.1662009576369;
        Wed, 31 Aug 2022 22:19:36 -0700 (PDT)
Received: from pohjola.lan (mobile-user-2e84bf-218.dhcp.inet.fi. [46.132.191.218])
        by smtp.gmail.com with ESMTPSA id v10-20020ac258ea000000b00494714e266fsm1129316lfo.67.2022.08.31.22.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 22:19:35 -0700 (PDT)
From:   atheik <atteh.mailbox@gmail.com>
To:     tom@talpey.com
Cc:     hyc.lee@gmail.com, linkinjeon@kernel.org,
        linux-cifs@vger.kernel.org, senozhatsky@chromium.org,
        smfrench@gmail.com
Subject: Re: [PATCH 1/2] ksmbd: update documentation
Date:   Thu,  1 Sep 2022 08:19:29 +0300
Message-Id: <20220901051929.14421-1-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <47dbb75a-b299-066c-61cc-2b21ca96173f@talpey.com>
References: <47dbb75a-b299-066c-61cc-2b21ca96173f@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/30/2022 12:33 PM, Tom Talpey wrote:
>On 8/30/2022 10:17 AM, Namjae Jeon wrote:
>> configuration.txt in ksmbd-tools moved to smb.conf(5ksmbd) manpage.
>> update it and more detailed ksmbd-tools build method.
>> 
>> Cc: Tom Talpey <tom@talpey.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   Documentation/filesystems/cifs/ksmbd.rst | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>> 
>> diff --git a/Documentation/filesystems/cifs/ksmbd.rst b/Documentation/filesystems/cifs/ksmbd.rst
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
>I believe you mean "make && sudo make install"? The single & will
>kick off two make's in parallel.

Also, Jeon, since `#' indicates root prompt, there shouldn't be `sudo'.
If you want to use `sudo' in the instructions, then use `$' prompt.
With that `./configure' invocation, the utilities end up in
`/usr/local/sbin'. Since `sysconfdir=/etc' is associated with the
`/usr' prefix, it might be better to put the utilities in there also.
Meaning that `--prefix=/usr' should be given to `./configure', so
`sbindir' becomes `/usr/sbin'. Alternatively, `sysconfdir=/etc'
should be removed so that `/usr/local/etc' is used. This way the
user-built ksmbd-tools doesn't conflict with ksmbd-tools installed
using the package manager.

>
>>   2. Create user/password for SMB share.
>>   
>>   	# mkdir /etc/ksmbd/

Jeon, the install target already creates `/etc/ksmbd'.

>>   	# ksmbd.adduser -a <Enter USERNAME for SMB share access>
>
>It may be worth mentioning that it's not just single-user access, and
>that additional users can be configured.
>
>>   3. Create /etc/ksmbd/smb.conf file, add SMB share in smb.conf file
>> -	- Refer smb.conf.example and
>> -          https://github.com/cifsd-team/ksmbd-tools/blob/master/Documentation/configuration.txt
>> +	- Refer smb.conf.example, See smb.conf(5ksmbd) for details.
>> +
>> +        # man smb.conf.5ksmbd
>
>I like the new manpage, but that's a strange path. Are you sure
>the various maintainers will deploy it that way?

Jeon, it should be `man 5ksmbd smb.conf'. `5' is the section number and
`ksmbd' further differentiates it from Samba's `smb.conf'. Currently,
just `5k' is enough to do so.

>
>Also, it has always bothered me that the name "smb.conf" is the
>same as the Samba server's configuration file, just in a different
>directory. If someone enters "man smb.conf", there may be confusion.
>I really wish the file was called "ksmbd.conf".

Talpey, in what way is it strange? If both Samba and ksmbd-tools are
installed, `man 5 smb.conf' is the Samba page. Then
`man 5ksmbd smb.conf' (or just `man 5k smb.conf') is the ksmbd-tools
page. If only ksmbd-tools is installed, `man 5 smb.conf' is the
ksmbd-tools page. The same applies for just `man smb.conf' since there
is only a page with that name in section 5. This makes sense since
Samba's `smb.conf' is authoritative and ksmbd-tools tries to be
compatible.

>
>Why not putting this under a simpler manpage title "man ksmbd"?
>To me, that's much more logical and it avoids both the confusion
>and having to somehow know that weird manpath.
>
>>   4. Insert ksmbd.ko module
>>   
>>   	# insmod ksmbd.ko
>
>Well, it's worth mentioning that a properly configured and built
>kernel is a prerequisite here...
>
>Also, sudo.
>
>>   5. Start ksmbd user space daemon
>> +
>>   	# ksmbd.mountd
>
>FYI, Ubuntu Jammy pre-configures ksmbd as a service, and there it's
>as simple as "sudo service ksmbd start".
>
>Do you not want to mention the other ksmbd.<foo> helpers here?
>
>>   6. Access share from Windows or Linux using CIFS
>
>Pointer to cifs.ko how-to page?
>
>Basically, I'm encouraging these pages to be (much) more user
>friendly! They're fine for developers, but way too fiddly IMO
>for naive users, or even for admins. It has taken me days to get
>this all going on my fresh machines.
>
>Either way, thanks for the cleanup so far!!
>
>Tom.
>

Atte Heikkilä
