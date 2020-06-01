Return-Path: <SRS0=0eH6=7O=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 154C1C433DF
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Jun 2020 19:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D252C2073B
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Jun 2020 19:58:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QxUB1GbJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgFAT6l (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Jun 2020 15:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgFAT6l (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Jun 2020 15:58:41 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1073C061A0E;
        Mon,  1 Jun 2020 12:58:40 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id c3so1012881wru.12;
        Mon, 01 Jun 2020 12:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=HmLxgKHhSqoffCsMGJp7UW0iC0JJMz702xF6zdCQDcc=;
        b=QxUB1GbJmPHvTixVnQgpr2TEllEb0ZpwdL3xdDJWmFPAVnmU65UtgQOxdhVZgyGnoY
         +eC515mbZ1zaHvn92iDWleU1XDwB3H5FJRYX/bzhCC/7MV0IV4gA6lssweR9I6zydLsR
         rQ1gB3z/1gNI+LWV6VflHyYdPJvpncXFqXu+Y0MLY47MfBegurwRL0I/Syj9P+B13FUn
         fLQ/U3kcrj2Sdg+8vFITl8OGuv5VkAgwGzZntN7kycD9PfH66QmeBWIw6pHGrxKt2IHn
         n9zZ/2RlDltaLjVBuqGTT3NMW2b3DSjCyoHmH1otEhEL/uRSzh1rcUzPcPNWkgtj0CJA
         zZ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=HmLxgKHhSqoffCsMGJp7UW0iC0JJMz702xF6zdCQDcc=;
        b=ZIAMWj+8DYYJpm2TEM7jATbWv7whSuSUhcNy1SYydki34h8EWh6s/2u8FLEenBAKoh
         Lgpe+oT0AozlJOVbxwOI2rTOFbu+qCFz/zqee7IEEirSqTdyoOkuNhOrSga/utPSktz5
         BgBg1zRJrRvZFnH1FOR2xzT98HXtonihxR3vTyMPD0DEDrjYriFvnDgO/mN0cZRfBco4
         q+8XGur51uAvI/UXlxL3aoQvsPYUPtNLuEQTAQnpioNLYXDijFd9xDPiiQK2wo8D4DTJ
         RvgRuDLw9BjvBIQAu4XPcZGjXXh/4EiMIBoppyNF1f2K46MHfrhYNy4OACXDeLXLV1Kf
         P18A==
X-Gm-Message-State: AOAM5318zpV9iibr6gqtmaHVSH9x3UBH5+wgYAVVriLhFVhwL76CYucX
        xb9sqgekeICbzIKgbOHiRa5zeA2Kjho=
X-Google-Smtp-Source: ABdhPJyoE0Aterrm4HfyaaO6dxJ9wb2inrnHPBDInpsG7mdp9Ndi95qf4sICUeIUmTpZUklWFSBpfA==
X-Received: by 2002:adf:a51c:: with SMTP id i28mr22871392wrb.78.1591041519035;
        Mon, 01 Jun 2020 12:58:39 -0700 (PDT)
Received: from 2a02-8388-1684-3280-30c7-7e1b-0096-f726.cable.dynamic.v6.surfer.at (2a02-8388-1684-3280-30c7-7e1b-0096-f726.cable.dynamic.v6.surfer.at. [2a02:8388:1684:3280:30c7:7e1b:96:f726])
        by smtp.gmail.com with ESMTPSA id u74sm559837wmu.13.2020.06.01.12.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 12:58:38 -0700 (PDT)
Message-ID: <2d735cb666872099b2c4c574e35aaeac2f7356ad.camel@gmail.com>
Subject: cifs vs Go: EINTR and ENOENT errors from getdents64
From:   Jakob Unterwurzacher <jakobunt@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Mon, 01 Jun 2020 21:58:36 +0200
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi, author of gocryptfs here, an encrypted overlay
filesystem written in Go.

A gocryptfs user reported [1] hitting EINTR errors
when gocryptfs is used on a cifs mount.

I wrote a minimal reproducer, getdents.go [2], that runs
getdents64 in a loop and I can reproduce the issue easily.
I additionally see ENOENT errors.

The errors can also be seen via the high-level Readdirnames()
function that the Go stdlib provides [6].

I am running kernel 5.6.13 and Samba 4.12.2 for this test.
I have a cifs share mounted as shown in [3], populated
with 1001 empty files using

    touch $(seq 1000 2000)

. When running getdents.go [2] against this mount, good cases look
like this (output from getdents.go):

    --- example 0 ---

    unix.Getdents: n=4176; n=4176; n=4176; n=4176; n=4176; n=3192; n=0; err=<nil>; total 24072 bytes
    unix.Getdents: n=4176; n=4176; n=4176; n=4176; n=24; n=4152; n=3192; n=0; err=<nil>; total 24072 bytes


INTR errors look like this (getdents.go output and corresponding
kernel debug messages that were enabled acc. to [4]):

    --- example 1 ---

    unix.Getdents: n=-1; err=interrupted system call; total 0 bytes

    [168340.499471] fs/cifs/file.c: CIFS VFS: leaving cifs_closedir (xid = 24238) rc = 0
    [168340.599686] fs/cifs/readdir.c: Full path:  start at: 0
    [168340.599696] fs/cifs/transport.c: signal is pending before sending any data
    [168340.599698] smb2_add_credits: 310 callbacks suppressed
    [168340.599699] fs/cifs/smb2ops.c: add 1 credits total=8192
    [168340.599701] fs/cifs/smb2ops.c: query_dir_first: open failed rc=-4
    [168340.599702] fs/cifs/readdir.c: initiate cifs search rc -4
    [168340.599979] fs/cifs/file.c: Closedir inode = 0x0000000067f9a79c
    [168340.599981] fs/cifs/file.c: CIFS VFS: in cifs_closedir as Xid: 24240 with uid: 1026
    [168340.599982] fs/cifs/file.c: Freeing private data in close dir
    [168340.599983] fs/cifs/file.c: CIFS VFS: leaving cifs_closedir (xid = 24240) rc = 0

    --- example 2 ---

    unix.Getdents: n=-1; err=interrupted system call; total 0 bytes

    [168453.792894] Status code returned 0x80000006 STATUS_NO_MORE_FILES
    [168453.893360] fs/cifs/transport.c: signal is pending before sending any data
    [168453.893363] fs/cifs/smb2ops.c: query_dir_first: open failed rc=-4


ENOENT errors look like this:

    --- example 3 ---

    unix.Getdents: n=4176; n=4176; n=4176; n=4176; n=4176; n=-1; err=no such file or directory; total 20880 bytes

    [168517.187072] Status code returned 0x80000006 STATUS_NO_MORE_FILES
    [168517.300252] fs/cifs/transport.c: signal is pending before sending any data
    [168517.300255] fs/cifs/readdir.c: fce error -2

    --- example 4 ---

    unix.Getdents: n=4176; n=4176; n=4176; n=1440; n=2736; n=-1; err=no such file or directory; total 16704 bytes

    [168650.603145] Status code returned 0x80000006 STATUS_NO_MORE_FILES
    [168650.713831] fs/cifs/transport.c: signal is pending before sending any data
    [168650.713835] fs/cifs/readdir.c: fce error -2


I have the same thing written in C does not show
any problems [5].

The Go runtime uses signals heavily, could this be a
reason for the behavoir I am seeing? I can trigger
the problem more quickly when I resize the terminal
window (causing SIGWINCH). Note that the Go runtime
sets SA_RESTART on all signal handlers.

I can handle the EINTR errors by retrying, no problem.
Should I also retry when I get ENOENT?

Thanks,
Jakob


[1] https://github.com/rfjakob/gocryptfs/issues/483
[2] https://github.com/rfjakob/gocryptfs/blob/master/contrib/getdents-debug/getdents/getdents.go
[3] //127.0.0.1/samba-test on /mnt/samba-test type cifs
(rw,relatime,vers=3.1.1,cache=strict,username=jakob,uid=1026,forceuid,gid=1026,forcegid,addr=127.0.0.1,file_mode=0755,dir_mode=0755,soft,nounix,serverino,mappos
ix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=60,actimeo=1,user=jakob)
[4] https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Enabling_Debugging
[5] https://github.com/rfjakob/gocryptfs/blob/master/contrib/getdents-debug/getdents_c/getdents.c
[6] https://github.com/golang/go/issues/39237

