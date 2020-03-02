Return-Path: <SRS0=r9u8=4T=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE96C3F2D1
	for <linux-cifs@archiver.kernel.org>; Mon,  2 Mar 2020 07:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91DC5246A1
	for <linux-cifs@archiver.kernel.org>; Mon,  2 Mar 2020 07:49:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BJ4D8B5f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgCBHtq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 2 Mar 2020 02:49:46 -0500
Received: from mail-ot1-f42.google.com ([209.85.210.42]:37684 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgCBHtq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 2 Mar 2020 02:49:46 -0500
Received: by mail-ot1-f42.google.com with SMTP id b3so8782173otp.4
        for <linux-cifs@vger.kernel.org>; Sun, 01 Mar 2020 23:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=nl9vmhyNQxCFKcGhZ/qeuMZZl99vmBciV92FDmHVfmk=;
        b=BJ4D8B5f8AMFlt2Kkg3YBVDJMzgZ10W2FAWm83jgIVtasQ+18iCFiW8sLLCOO7WHci
         5oyhGfw8wTHKsw8SDda1aUYeal0hCliYNXpXyqqEm+ZAvDkxT2TxZjz9sXxXnGVBN/ef
         U3RI0qIQjWP5m8tjJcgo8HIIF6PhdEvu+mAON/uNZo5n7UR2Kl37LpoOyBPrHAd/BnTr
         lJgh0k5/EnPlJH+5sSWRIj8zd2rXLI0QpHdiwhQFW10yTXUr/Jn40nEAEHnTldchCDs6
         Aldzp7932/r5nmcfGtbrFbhUhaAAv2aTdoTKDY/y2TZuvcizB+4DC/IvPsoViabO0U4a
         qTTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=nl9vmhyNQxCFKcGhZ/qeuMZZl99vmBciV92FDmHVfmk=;
        b=q8cjBd4yKdPCNwjQt+CWNG9HJVqTWKJYFa0Lady8u+B3AmMXjn/kYPHqAK998zDngq
         ca+BPmN4XjzmPz41jaPCr2TJKG8YJxRA6axNvzs7InY9J2nNqKRH84t/AoIGbSdWK713
         R3XNfo2L8s+uwXyemrMlH/fWX8FTy7YWoQXAOOW0BHuFsKGy+bbRTxK3FO8lpKPnEllY
         2feEXIicCR6BIu6bxEoUPA4ArLuLcQOakseTpLuxfvTf9z7XfdQ0pvB5yMTqDJ6aIxIl
         LZYuqeVGIxGAvUrIdgeWDgqk5k+1EJP22NQkRfBq6t1duS4+dMlz69zosgRgUeIZ2DNR
         kH5Q==
X-Gm-Message-State: APjAAAVeie0azLjPRxNM1lv02rnE2P9dzfYM/JgKaM+mvMulDQOG9X1R
        P65NMGY1ohfwJpaDtoGqsmYNBO9jOw4iI6IctqT+ITkf1mw=
X-Google-Smtp-Source: APXvYqwYf7YmPrXBeS0GF3b8/sFD4ObiLyJ9F7fwwfs7NsMD2GOnmXuNRcQFeBRH5tZ7d2zOnGIkSG2aPBn6k4qpUcE=
X-Received: by 2002:a9d:3df6:: with SMTP id l109mr12128620otc.284.1583135384766;
 Sun, 01 Mar 2020 23:49:44 -0800 (PST)
MIME-Version: 1.0
From:   Mathieu Malaterre <mathieu.malaterre@gmail.com>
Date:   Mon, 2 Mar 2020 08:49:33 +0100
Message-ID: <CA+7wUszkCoy_o2RJ76QESUH3S7NKG6RvFyVY+5sDcQA+dC6utw@mail.gmail.com>
Subject: Proper mounting Windows DFS Namespace in Linux / Object is remote
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I am struggling to mount a remote CIFS directory on a Ubuntu system at
work. The remote folder appears to be working just fine from my
Windows 8.1 session (also at work).

I could not get normal mounting to work:

    $ sudo mount -v -t cifs //1.2.3.4/network ~/z -o
username=malat,domain=MY,uid=$(id -u),gid=$(id -g),iocharset=utf8
    Password for malat@//1.2.3.4/network:  *********
    mount.cifs kernel mount options:
ip=1.2.3.4,unc=\\1.2.3.4\network,iocharset=utf8,uid=1002,gid=1002,user=mmalaterre,domain=MY,pass=********
    mount error(2): No such file or directory
    Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

But I eventually stumble upon this ref[1]:

    $ sudo mount -v -t cifs //1.2.3.4/network ~/z -o
username=malat,domain=MY,uid=$(id -u),gid=$(id
-g),iocharset=utf8,nodfs
    Password for malat@//1.2.3.4/network:  *********
    mount.cifs kernel mount options:
ip=1.2.3.4,unc=\\1.2.3.4\network,iocharset=utf8,nodfs,uid=1002,gid=1002,user=malat,domain=MY,pass=********

At least I have something working now, so AFAIK the option 'nodfs' is
a required option for me:

    $ mount | grep network
    //1.2.3.4/network on /home/malat/z type cifs
(rw,relatime,vers=2.1,cache=strict,username=malat,domain=MY,uid=1002,forceuid,gid=1002,forcegid,addr=1.2.3.4,file_mode=0755,dir_mode=0755,soft,nounix,nodfs,mapposix,rsize=1048576,wsize=1048576,bsize=1048576,echo_interval=60,actimeo=1)

However there seems to be something not working (related to 'nodfs'
option I guess). Here are the symptoms:

    $ cd ~/z
    $ ls
    folder1 folder2
    $ ls folder1
    subfolder1
    $ ls folder2
    ls: cannot access 'folder2': Invalid argument

If I add `vers=1.0` to the mount command, the symptoms are slightly different:

    $ cd ~/z
    $ cd folder2
    $ ls
    subfolder2
    $ cd subfolder2/
    bash: cd: subfolder2/: Object is remote

I can access the folder `folder2` just fine from my Windows 8.1
session, so this is not a permission issue.

For instance I have a work around : use the DFS Referral list. So from
my windows box I navigate to the problematic "subfolder2" (symlink
icon), right click get the properties (third tab is named 'DFS'), then
go back to my Linux session, and mount using instead:

    $ sudo mount -t cifs //xyzclus01-cifs.mydoma.acme.corp/Disk12
~/disk12 -v -o username=malat,domain=MY,uid=$(id -u),gid=$(id
-g),iocharset=utf8,nodfs,vers=1.0
    Password for malat@//xyzclus01-cifs.mydoma.acme.corp/Disk12:  *********
    mount.cifs kernel mount options:
ip=5.6.7.8,unc=\\xyzclus01-cifs.mydoma.acme.corp\Disk12,iocharset=utf8,nodfs,vers=1.0,uid=1002,gid=1002,user=malat,domain=MY,pass=********
    $ cd folder2/subfolder2/

I can (finally!) access the content of subfolder2. This is quite
cumbersome and counter-intuitive. So this qualify at best as
work-around and not as real solution.

How can I access `folder2` from my Linux session ? Or at least how can
I find the magic value "//xyzclus01-cifs.mydoma.acme.corp/Disk12"
directly from my running Linux system ?

---

For reference:

Here is the tail of `dmesg`:

    [1927958.534353] CIFS: Attempting to mount //1.2.3.4/network
    [1927958.534403] No dialect specified on mount. Default has
changed to a more secure dialect, SMB2.1 or later (e.g. SMB3), from
CIFS (SMB1). To use the less secure SMB1 dialect to access old servers
which do not support SMB3 (or SMB2.1) specify vers=1.0 on mount.
    [1927960.069018] CIFS VFS: DFS capability contradicts DFS flag
    [1927960.375111] CIFS VFS: Autodisabling the use of server inode
numbers on new server.
    [1927960.375115] CIFS VFS: The server doesn't seem to support them
properly or the files might be on different servers (DFS).
    [1927960.375117] CIFS VFS: Hardlinks will not be recognized on
this mount. Consider mounting with the "noserverino" option to silence
this message.

    $ lsb_release -a
    No LSB modules are available.
    Distributor ID: Ubuntu
    Description:    Ubuntu 19.04
    Release:        19.04
    Codename:       disco

kernel version:

    $ uname -rvo
    5.0.0-38-generic #41-Ubuntu SMP Tue Dec 3 00:27:35 UTC 2019 GNU/Linux

and

    $ cat /etc/request-key.d/cifs.spnego.conf
    create  cifs.spnego    * * /usr/sbin/cifs.upcall %k

  [1]: https://unix.stackexchange.com/questions/164037/mount-cifs-error2-no-such-file-or-directory-when-using-a-prefixpath

-- 
Mathieu
