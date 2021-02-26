Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC4DC433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Feb 2021 00:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C8A864F22
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Feb 2021 00:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhBZAIu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:08:50 -0500
Received: from srv.fail ([135.181.244.181]:40602 "EHLO srv.fail"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230040AbhBZAIt (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 25 Feb 2021 19:08:49 -0500
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Feb 2021 19:08:48 EST
Received: from localhost (localhost [127.0.0.1])
        by srv.fail (Postfix) with ESMTP id C7038152C449
        for <linux-cifs@vger.kernel.org>; Fri, 26 Feb 2021 01:01:58 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at srv.fail
Received: from srv.fail ([127.0.0.1])
        by localhost (srv.fail [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1o5-38QQCuym for <linux-cifs@vger.kernel.org>;
        Fri, 26 Feb 2021 01:01:57 +0100 (CET)
Received: from [IPv6:2a02:908:1086:27c0::84a] (unknown [IPv6:2a02:908:1086:27c0::84a])
        by srv.fail (Postfix) with ESMTPSA id 0A6F8152E598
        for <linux-cifs@vger.kernel.org>; Fri, 26 Feb 2021 01:01:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=totally.rip;
        s=default; t=1614297717;
        bh=z9elikXXwNmGwQ2PPTrg5UNxko/8U6ug0xb8G5sb+E0=;
        h=To:From:Subject:Date:From;
        b=mxqdU/p4o6F6j5qjvSiTf4V7g72DmWoIOKdzEdG/NhJR78yDztS/kJ1+jAdI1PkQr
         dAeIdt+AerjK/qQN8jW1yHPCbJb7mxxagQoDSwf39TEdUL9Fr3yIhNp3arGVhFmOWV
         6S20qpkhEN8nC4lss2bhl+4avw2sNQPDsxWPcrkoW1lrxFWenZdu9M7K6uxVAwunH6
         DyzzYTr2QBjq8TJxwTIky4wvm62r7/NlGS1O65tr5rWDjBjLH0OBX+g3/W8wX5MQ3h
         tqr512anM6YyW7jYEFWxcr+g2oktYJ5MupwdeOzsgCYksykGVtZn4EHw4XMd4nyH6y
         kRjqUVMu1JclA==
To:     linux-cifs@vger.kernel.org
From:   jkhsjdhjs <jkhsjdhjs@totally.rip>
Subject: Passwords containg commas are no longer working in credential files
Message-ID: <1462a108-7130-b94c-cbd9-457c2cbdd504@totally.rip>
Date:   Fri, 26 Feb 2021 01:01:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello,

I'm using a password containing commas to mount a remote cifs on my 
computer. I recently upgraded the linux kernel on my system to 5.11, 
which seems to contain a regression, making the comma a separator even 
in the credential file.

I'm using `mount /path/to/mount` to mount the filesystem with the 
following contained in `/etc/fstab`:

//domain.tld/share    /path/to/mount    cifs 
noauto,credentials=/home/jkhsjdhjs/.credentials,uid=jkhsjdhjs,gid=jkhsjdhjs,dir_mode=0755,file_mode=0644 
0 0

My credential file looks like this:

user=myusername
pass=abc,def
domain=mydomain

With Linux 5.11 or 5.11.1 the following is printed to `dmesg` when 
trying to mount the filesystem: `[ 3051.668834] cifs: Unknown parameter 
'def'`. This worked fine with 5.10.16 and below, the man page also says 
this should work:

Note that a password which contains the delimiter character (i.e. a 
comma ',') will fail to be parsed correctly on the command line. 
However, the same password defined in the PASSWD environment variable or 
via a credentials file (see below) or entered at the password prompt 
will be read correctly.

Thus it seems there has been a regression in 5.11. I tried to identifiy 
the commit that caused this regression, but wasn't able to. I also 
checked if this bug is already known by searching lkml.org and didn't 
find anything. Sorry if I missed something.

Best Regards,

Leon Möller

