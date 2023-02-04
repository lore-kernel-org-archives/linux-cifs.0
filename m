Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8771C636CC
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Feb 2023 19:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbjBDTK1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 4 Feb 2023 14:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjBDTK1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 4 Feb 2023 14:10:27 -0500
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00BD2798E
        for <linux-cifs@vger.kernel.org>; Sat,  4 Feb 2023 11:10:25 -0800 (PST)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-163bd802238so10636512fac.1
        for <linux-cifs@vger.kernel.org>; Sat, 04 Feb 2023 11:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zQejtNGKsURp8/VjP/TrlOduU9OqexWo7k0nc7zpciU=;
        b=Q6H43TjLJ9lFOipFfKfrmgZh2B0jKfA0KaSxOV6tO+1KGbRFm/WfsXja3luhmyPO+s
         ZuYU/8uYtNJCpf6zZRkT3VV5Jw0f3NOd4FxRdWeY7hnZQgc/U8nKw42sSaPJT9kZXAl0
         Ud+q377bvcotHQN4On8sPKg2X4Xis2WvBWr932yv2t9TXHO47MlK4TVHNEhqJu0jsGoN
         AAYwX7WX8VTWm1ICyprNW33kp5tRxIkK+6BP8xDvBVy2A2DQKRyQ8nVuTrrqYC8657mW
         Kvd9cgOhet/RrBiYAB6nneep+pABnxB20lzyHHW9A36X8+qQowKemoRbtaMRugfZSaRu
         GJOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zQejtNGKsURp8/VjP/TrlOduU9OqexWo7k0nc7zpciU=;
        b=PzQAWlszwmRASwZ0KVbTDQFbznHFbwsDeuYbdcn2iegsdvZ2En17WpNzPPoEPw7DRj
         yS1CMVOfugqHz9dx5K6wP30fPc6mAL9lJ5TX4uXS55IgibdK62YPExiXdX5xt1xBfquy
         aLM3W8geIGesRcf8Ie/TdNWw4Ay2AAz9I236iWQe/d5aXyklKOF/CROx7eNyFq0XdGEU
         RmKqSrNtfO9X964ElZp0y+KBUbw0sBqltKUyISmLqNvMs/j/rKK9gRaOPhv6g/dZY3+e
         PAqXkRG4asPTBm7HtCYdteHnUzW/9anSHhxgjToI9i3pFvPBS6mCSBH69MXGkDo4BVB8
         ESXg==
X-Gm-Message-State: AO0yUKWGsOq7Tn2EFVeYMfRRInYHqeKKQTM5lTyrwgnw9VBPGAEEjrkc
        hXxl9Brql8dNUNUAHfCavD+IVT5pN88BzRuL3Q1qEXqS8zo=
X-Google-Smtp-Source: AK7set+fGvsaDmlLGGNVcISF/BSV2H9ZlRAACegDVRbU1R7NxZAp+MQVz0mHjr6juDpY2DXLoIbjLlbLIW809VG4FP4=
X-Received: by 2002:a05:6870:c892:b0:163:a89a:c5e6 with SMTP id
 er18-20020a056870c89200b00163a89ac5e6mr955030oab.276.1675537824762; Sat, 04
 Feb 2023 11:10:24 -0800 (PST)
MIME-Version: 1.0
From:   Stan Hu <stanhu@gmail.com>
Date:   Sat, 4 Feb 2023 11:10:13 -0800
Message-ID: <CAMBWrQnRKQVPh8Vi8bY4eL_VSZhnPu_5OALv1nKZuXvoEMsLzQ@mail.gmail.com>
Subject: curious about a CIFS bug fixed in Linux 5.13
To:     linux-cifs@vger.kernel.org,
        Rohith Surabattula <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I've been investigating a strange bug that appears to return an
`-EINVAL` when our application attempts to open a newly-renamed file
on a CIFS mount. The good news is that the bug is gone in Linux 5.13
but present in versions preceding that. After doing some git
bisecting, I've validated that commit c3f207ab29f79 (cifs: Deferred
close for files) appears to have solved the problem.

Now I'm wondering: is this bug really fixed, or is this commit masking
another issue?

The `mount` output for this CIFS mount is as follows:

//10.128.0.36/share on /mnt/windows type cifs
(rw,relatime,vers=3.1.1,cache=strict,username=stan,uid=997,noforceuid,gid=997,noforcegid,addr=10.128.0.36,file_mode=0700,dir_mode=0700,soft,nounix,serverino,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=60,actimeo=1)

As far as I understand, our application works something like this:

1. Process A writes a small file to a temporary location:
`/mnt/windows/artifacts/tmp/uploads/gitlab-workhorse-upload749963764`
2. Process B calls:
`rename("/mnt/windows/artifacts/tmp/uploads/gitlab-workhorse-upload749963764",
"/mnt/windows/artifacts/tmp/work/1675526501-1286-0001-0710/.env.gz")`
3. Process B calls:
`rename("/mnt/windows/artifacts/tmp/work/1675526501-1286-0001-0710/.env.gz",
"/mnt/windows/artifacts/tmp/cache/1675526501-1286-0001-0710/.env.gz")`.
4. Process B calls: `openat(AT_FDCWD,
"/mnt/windows/artifacts/tmp/cache/1675526501-1286-0001-0710/.env.gz",
O_RDONLY|O_CLOEXEC)`.

An `strace` on our application shows the error:

1108 openat(AT_FDCWD,
"/mnt/windows/artifacts/tmp/cache/1675526501-1286-0001-0710/.env.gz",
O_RDONLY|O_CLOEXEC) = -1 EINVAL (Invalid argument)

However, I can open and read this file fine from the shell.

When I turn on CIFS debugging, I see "STATUS_INVALID_PARAMETER" in
response to cifs_open():

[ 5241.432481] fs/cifs/inode.c: CIFS VFS: leaving cifs_rmdir (xid = 703) rc = 0
[ 5241.436049] fs/cifs/file.c: CIFS VFS: in cifs_open as Xid: 704 with uid: 997
[ 5241.436052] fs/cifs/file.c: inode = 0x00000000028100cc file flags
are 0x8000 for \tmp\cache\1675526501-1286-0001-0710\.env.gz
[ 5241.436588] Status code returned 0xc000000d STATUS_INVALID_PARAMETER
[ 5241.443409] fs/cifs/file.c: CIFS VFS: leaving cifs_open (xid = 704) rc = -22
[ 5241.452108] fs/cifs/file.c: Flush inode 00000000028100cc file
0000000005911244 rc 0
[ 5241.452112] fs/cifs/file.c: closing last open instance for inode
00000000028100cc
[ 5241.452114] fs/cifs/file.c: CIFS VFS: in _cifsFileInfo_put as Xid:
705 with uid: 997

I took a Wireshark pcap of the STATUS_INVALID_PARAMETER response for
another failed run here:
https://gitlab.com/gitlab-org/gitlab/uploads/b047728a695adc098a6d3ce77df2ae7d/test.pcap

Working case: https://gitlab.com/gitlab-org/gitlab/uploads/4df1625bf3ab3775bc97d8b56546eacc/test-working.pcap

In the working case, I see "No oplock" on the "Create request" for the
temporary file in question, and the ExtraInfo flags are a little
different (https://gitlab.com/gitlab-org/gitlab/-/issues/389995#note_1265800095).

I attempted to set "cache=none,actimeo=0" in the mount options, but
that did not seem to help.
