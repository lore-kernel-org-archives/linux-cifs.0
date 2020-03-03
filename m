Return-Path: <SRS0=S2CZ=4U=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF55C3F2C6
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Mar 2020 07:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1011215A4
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Mar 2020 07:26:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DZUTRr81"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbgCCH0B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Mar 2020 02:26:01 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:33109 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727340AbgCCH0B (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Mar 2020 02:26:01 -0500
Received: by mail-oi1-f194.google.com with SMTP id q81so2058846oig.0
        for <linux-cifs@vger.kernel.org>; Mon, 02 Mar 2020 23:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8phNjd84s4ojHhQTXUEqwkLmkijLD+34SKnwMUfVk2o=;
        b=DZUTRr81aXTmoA4koFswnopdP//ps7m7rLAxXNUoOgI00Vl0m9ID+OvzWlHKUvqtLZ
         JCLHvLCFKhFLr6liBhzCWLPyjakzZQVVJw92GAUhX+jXB4s+BV8QqyHNGS3FbgzvBmaJ
         oQwP1c6/G7wIVXX9azvYYSIjvSlrcycdDmuPjnDj5biNVGvF1n9bCB7T5OLzQVU3tx60
         8gCGYz71JrjzjrTMmTJRDjvcd7TpVXrSQQpnVHGcZywRMZGAXpz3T12EYWJ1SwaTwNUi
         3wB6Jux4UQyJ6+49gLktwZ6lX4oYAbtmkChesEzeHKqOEaFeOHIy5Tk2Avu1zHz2PEni
         +i4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8phNjd84s4ojHhQTXUEqwkLmkijLD+34SKnwMUfVk2o=;
        b=gHlOpfk9CVO3dV2xOSjv6s3AWq3lv8NGIdFckYultF2pE0ycMj6KKxVBHuvscGpCCC
         HTU6ytv12mVOz5WNo8j6k2C/bLUgJSqDcVkhXoW8eFC1286KuD/RK04ltC5lzxtZr7hF
         dj0cGuA0YGI0d6zcpFw6UpyllPnNaMDRK2SCbbuux44xQPMp6N/50R6LwBNQRwWtWuAz
         exv13CpbsUk0h0F4tmO64fAq1n6atx0+a9qsFFXW4iC7IR6G7KYXDw3nnmwwruomBS8d
         dXF58D3w+TR5MwIBLZQuvKsG6LHtLYmKx1HKG3yd+Z3+5xoUdexv53KaciGvbdi92qIu
         G9qg==
X-Gm-Message-State: ANhLgQ0Og/EmrDfh5doEGPL7os+ASBkFP53iRnr1+B1hrxTjODbOSrNq
        krtW1AQjGDFp+Z8Rd3/C6jWwV4tj76RpEXds8G0=
X-Google-Smtp-Source: ADFU+vu8MZWe9xo/olSTbuXnCJSyHk2YqvjmrJadizYAvRO+vCNQs8I7XpGeIkH1xR7A6keztvhsIhTp0hb/ebs7ygU=
X-Received: by 2002:aca:4e14:: with SMTP id c20mr1615607oib.96.1583220360132;
 Mon, 02 Mar 2020 23:26:00 -0800 (PST)
MIME-Version: 1.0
References: <CA+7wUszkCoy_o2RJ76QESUH3S7NKG6RvFyVY+5sDcQA+dC6utw@mail.gmail.com>
 <CAH2r5mtd-WbXbTG6bgT9EfZyXCC2Qr-TB8QszOy+oFRu5CrerQ@mail.gmail.com>
In-Reply-To: <CAH2r5mtd-WbXbTG6bgT9EfZyXCC2Qr-TB8QszOy+oFRu5CrerQ@mail.gmail.com>
From:   Mathieu Malaterre <mathieu.malaterre@gmail.com>
Date:   Tue, 3 Mar 2020 08:25:47 +0100
Message-ID: <CA+7wUsyWb1UTxKdF2Q=h3scqEu43aFb4tgdoWcFrXt2SOXZ6tg@mail.gmail.com>
Subject: Re: Proper mounting Windows DFS Namespace in Linux / Object is remote
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Well not on that specific system. I'll install a newer ubuntu under
virtualbox and give it a try at least for the curiosity.

On Mon, Mar 2, 2020 at 10:12 PM Steve French <smfrench@gmail.com> wrote:
>
> Can you try an experiment with Ubuntu's newer kernel:
>
> https://wiki.ubuntu.com/Kernel/MainlineBuilds
> Or
>
> https://github.com/pimlie/ubuntu-mainline-kernel.sh
>
> On Mon, Mar 2, 2020, 01:50 Mathieu Malaterre <mathieu.malaterre@gmail.com> wrote:
>>
>> I am struggling to mount a remote CIFS directory on a Ubuntu system at
>> work. The remote folder appears to be working just fine from my
>> Windows 8.1 session (also at work).
>>
>> I could not get normal mounting to work:
>>
>>     $ sudo mount -v -t cifs //1.2.3.4/network ~/z -o
>> username=malat,domain=MY,uid=$(id -u),gid=$(id -g),iocharset=utf8
>>     Password for malat@//1.2.3.4/network:  *********
>>     mount.cifs kernel mount options:
>> ip=1.2.3.4,unc=\\1.2.3.4\network,iocharset=utf8,uid=1002,gid=1002,user=mmalaterre,domain=MY,pass=********
>>     mount error(2): No such file or directory
>>     Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>>
>> But I eventually stumble upon this ref[1]:
>>
>>     $ sudo mount -v -t cifs //1.2.3.4/network ~/z -o
>> username=malat,domain=MY,uid=$(id -u),gid=$(id
>> -g),iocharset=utf8,nodfs
>>     Password for malat@//1.2.3.4/network:  *********
>>     mount.cifs kernel mount options:
>> ip=1.2.3.4,unc=\\1.2.3.4\network,iocharset=utf8,nodfs,uid=1002,gid=1002,user=malat,domain=MY,pass=********
>>
>> At least I have something working now, so AFAIK the option 'nodfs' is
>> a required option for me:
>>
>>     $ mount | grep network
>>     //1.2.3.4/network on /home/malat/z type cifs
>> (rw,relatime,vers=2.1,cache=strict,username=malat,domain=MY,uid=1002,forceuid,gid=1002,forcegid,addr=1.2.3.4,file_mode=0755,dir_mode=0755,soft,nounix,nodfs,mapposix,rsize=1048576,wsize=1048576,bsize=1048576,echo_interval=60,actimeo=1)
>>
>> However there seems to be something not working (related to 'nodfs'
>> option I guess). Here are the symptoms:
>>
>>     $ cd ~/z
>>     $ ls
>>     folder1 folder2
>>     $ ls folder1
>>     subfolder1
>>     $ ls folder2
>>     ls: cannot access 'folder2': Invalid argument
>>
>> If I add `vers=1.0` to the mount command, the symptoms are slightly different:
>>
>>     $ cd ~/z
>>     $ cd folder2
>>     $ ls
>>     subfolder2
>>     $ cd subfolder2/
>>     bash: cd: subfolder2/: Object is remote
>>
>> I can access the folder `folder2` just fine from my Windows 8.1
>> session, so this is not a permission issue.
>>
>> For instance I have a work around : use the DFS Referral list. So from
>> my windows box I navigate to the problematic "subfolder2" (symlink
>> icon), right click get the properties (third tab is named 'DFS'), then
>> go back to my Linux session, and mount using instead:
>>
>>     $ sudo mount -t cifs //xyzclus01-cifs.mydoma.acme.corp/Disk12
>> ~/disk12 -v -o username=malat,domain=MY,uid=$(id -u),gid=$(id
>> -g),iocharset=utf8,nodfs,vers=1.0
>>     Password for malat@//xyzclus01-cifs.mydoma.acme.corp/Disk12:  *********
>>     mount.cifs kernel mount options:
>> ip=5.6.7.8,unc=\\xyzclus01-cifs.mydoma.acme.corp\Disk12,iocharset=utf8,nodfs,vers=1.0,uid=1002,gid=1002,user=malat,domain=MY,pass=********
>>     $ cd folder2/subfolder2/
>>
>> I can (finally!) access the content of subfolder2. This is quite
>> cumbersome and counter-intuitive. So this qualify at best as
>> work-around and not as real solution.
>>
>> How can I access `folder2` from my Linux session ? Or at least how can
>> I find the magic value "//xyzclus01-cifs.mydoma.acme.corp/Disk12"
>> directly from my running Linux system ?
>>
>> ---
>>
>> For reference:
>>
>> Here is the tail of `dmesg`:
>>
>>     [1927958.534353] CIFS: Attempting to mount //1.2.3.4/network
>>     [1927958.534403] No dialect specified on mount. Default has
>> changed to a more secure dialect, SMB2.1 or later (e.g. SMB3), from
>> CIFS (SMB1). To use the less secure SMB1 dialect to access old servers
>> which do not support SMB3 (or SMB2.1) specify vers=1.0 on mount.
>>     [1927960.069018] CIFS VFS: DFS capability contradicts DFS flag
>>     [1927960.375111] CIFS VFS: Autodisabling the use of server inode
>> numbers on new server.
>>     [1927960.375115] CIFS VFS: The server doesn't seem to support them
>> properly or the files might be on different servers (DFS).
>>     [1927960.375117] CIFS VFS: Hardlinks will not be recognized on
>> this mount. Consider mounting with the "noserverino" option to silence
>> this message.
>>
>>     $ lsb_release -a
>>     No LSB modules are available.
>>     Distributor ID: Ubuntu
>>     Description:    Ubuntu 19.04
>>     Release:        19.04
>>     Codename:       disco
>>
>> kernel version:
>>
>>     $ uname -rvo
>>     5.0.0-38-generic #41-Ubuntu SMP Tue Dec 3 00:27:35 UTC 2019 GNU/Linux
>>
>> and
>>
>>     $ cat /etc/request-key.d/cifs.spnego.conf
>>     create  cifs.spnego    * * /usr/sbin/cifs.upcall %k
>>
>>   [1]: https://unix.stackexchange.com/questions/164037/mount-cifs-error2-no-such-file-or-directory-when-using-a-prefixpath
>>
>> --
>> Mathieu



-- 
Mathieu
