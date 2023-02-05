Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A8CAC636CC
	for <linux-cifs@archiver.kernel.org>; Sun,  5 Feb 2023 15:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjBEPNM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 5 Feb 2023 10:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjBEPNL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 5 Feb 2023 10:13:11 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A377166FC
        for <linux-cifs@vger.kernel.org>; Sun,  5 Feb 2023 07:13:10 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id bf19so9775995ljb.6
        for <linux-cifs@vger.kernel.org>; Sun, 05 Feb 2023 07:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CcDfr2hSRc+XTlj8xnpgAR6lmOZsvDiB1/pZzGkcbkY=;
        b=UQ1GMYNqK2ZBgjktaVb7YWOtBDaOTfyCH3FEyyBkdvxKtu8rWd0Amtac779TPeKrm6
         3Mm7MKkYkHWPbtM8i7x8cMjmi8aVX6RvqQLqhd4g9XRK1TWLs0p1oqprkXEROx5N/OYR
         Vg4skJ9JIWUqEFIHqacklSneKIWnpoE+b1p7kXzTaNfa1tHg3yLuITVGAZIQd01+4+vf
         I/7LzB1tTzaMerD6H/E6WFhlp22a+kZENG+0rqgLh7pAdt+c4p8w6NmzQF576XSCWG2x
         oe5RL6Ov/jx98TC8s71gkIrDKVBFQwv4v2czuNAVf9DMcZHSRynDRLLyujgmTdPMpcZ7
         nUVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CcDfr2hSRc+XTlj8xnpgAR6lmOZsvDiB1/pZzGkcbkY=;
        b=Tf5pfzhwdYcZxBD48N06p4//WRW1lbihncrETRUaaJZqlH7OTfS0mGpI1H5CjrvFeN
         gARJFwpSaiisgYMrVw3/UYnQQfmBGLlO0aPUFJZKHj/zhC/4UGi6+i+6W02/xE2FTiTA
         HIy1x5NaDUpg7/ZYDfeYxhS+zcnVX00Wsw9vkBaoYfVGJMHxrgjoXtWvIDJ+N8kfaXtq
         4c2+SwElZJXba48xD6cUFRbQkSTIx7Mz8IZmY2F+iF/R2dO61jtGED60AzqFyqpHMeUr
         44hb/o+kk5bFPiQli5QtI1ixHZNB150T+k6cM2JPdyTgAdM3oND14K4JejIuRfxFSCXJ
         vaTg==
X-Gm-Message-State: AO0yUKU/XJlfYayS0RG3o1usDuovMrMz0kj9LivmeDZk74gp3YgFURSn
        U7xoJYTjtXo2I+85RaqrksoyqxliAuenyJX5UFNq8OTE
X-Google-Smtp-Source: AK7set8X7GFz+OybKCnBpNh0azoB5eYZ2SldfAJwdquAcb8W6NCRqlV0omlxMVx/RAkPvUArK/OSrlhJhpIErgqTMO4=
X-Received: by 2002:a2e:9e18:0:b0:28e:bba7:22dc with SMTP id
 e24-20020a2e9e18000000b0028ebba722dcmr2594601ljk.56.1675609988191; Sun, 05
 Feb 2023 07:13:08 -0800 (PST)
MIME-Version: 1.0
References: <CAMBWrQnRKQVPh8Vi8bY4eL_VSZhnPu_5OALv1nKZuXvoEMsLzQ@mail.gmail.com>
In-Reply-To: <CAMBWrQnRKQVPh8Vi8bY4eL_VSZhnPu_5OALv1nKZuXvoEMsLzQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 5 Feb 2023 09:12:55 -0600
Message-ID: <CAH2r5muwLzMk5q=9xOTm0SA-hpB46do7fUy9=BwwdRPM_QGJKA@mail.gmail.com>
Subject: Re: curious about a CIFS bug fixed in Linux 5.13
To:     Stan Hu <stanhu@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Rohith Surabattula <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Can you also verify that this works (on previous releases) with
"nolease" mount option (so we are more sure that this relates to
leases) and second can you (on recent kernels where "closetimeo" mount
option is supported) try it on a recent kernel with "closetimeo=0"
(which disables deferred close)

On Sat, Feb 4, 2023 at 1:23 PM Stan Hu <stanhu@gmail.com> wrote:
>
> I've been investigating a strange bug that appears to return an
> `-EINVAL` when our application attempts to open a newly-renamed file
> on a CIFS mount. The good news is that the bug is gone in Linux 5.13
> but present in versions preceding that. After doing some git
> bisecting, I've validated that commit c3f207ab29f79 (cifs: Deferred
> close for files) appears to have solved the problem.
>
> Now I'm wondering: is this bug really fixed, or is this commit masking
> another issue?
>
> The `mount` output for this CIFS mount is as follows:
>
> //10.128.0.36/share on /mnt/windows type cifs
> (rw,relatime,vers=3.1.1,cache=strict,username=stan,uid=997,noforceuid,gid=997,noforcegid,addr=10.128.0.36,file_mode=0700,dir_mode=0700,soft,nounix,serverino,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=60,actimeo=1)
>
> As far as I understand, our application works something like this:
>
> 1. Process A writes a small file to a temporary location:
> `/mnt/windows/artifacts/tmp/uploads/gitlab-workhorse-upload749963764`
> 2. Process B calls:
> `rename("/mnt/windows/artifacts/tmp/uploads/gitlab-workhorse-upload749963764",
> "/mnt/windows/artifacts/tmp/work/1675526501-1286-0001-0710/.env.gz")`
> 3. Process B calls:
> `rename("/mnt/windows/artifacts/tmp/work/1675526501-1286-0001-0710/.env.gz",
> "/mnt/windows/artifacts/tmp/cache/1675526501-1286-0001-0710/.env.gz")`.
> 4. Process B calls: `openat(AT_FDCWD,
> "/mnt/windows/artifacts/tmp/cache/1675526501-1286-0001-0710/.env.gz",
> O_RDONLY|O_CLOEXEC)`.
>
> An `strace` on our application shows the error:
>
> 1108 openat(AT_FDCWD,
> "/mnt/windows/artifacts/tmp/cache/1675526501-1286-0001-0710/.env.gz",
> O_RDONLY|O_CLOEXEC) = -1 EINVAL (Invalid argument)
>
> However, I can open and read this file fine from the shell.
>
> When I turn on CIFS debugging, I see "STATUS_INVALID_PARAMETER" in
> response to cifs_open():
>
> [ 5241.432481] fs/cifs/inode.c: CIFS VFS: leaving cifs_rmdir (xid = 703) rc = 0
> [ 5241.436049] fs/cifs/file.c: CIFS VFS: in cifs_open as Xid: 704 with uid: 997
> [ 5241.436052] fs/cifs/file.c: inode = 0x00000000028100cc file flags
> are 0x8000 for \tmp\cache\1675526501-1286-0001-0710\.env.gz
> [ 5241.436588] Status code returned 0xc000000d STATUS_INVALID_PARAMETER
> [ 5241.443409] fs/cifs/file.c: CIFS VFS: leaving cifs_open (xid = 704) rc = -22
> [ 5241.452108] fs/cifs/file.c: Flush inode 00000000028100cc file
> 0000000005911244 rc 0
> [ 5241.452112] fs/cifs/file.c: closing last open instance for inode
> 00000000028100cc
> [ 5241.452114] fs/cifs/file.c: CIFS VFS: in _cifsFileInfo_put as Xid:
> 705 with uid: 997
>
> I took a Wireshark pcap of the STATUS_INVALID_PARAMETER response for
> another failed run here:
> https://gitlab.com/gitlab-org/gitlab/uploads/b047728a695adc098a6d3ce77df2ae7d/test.pcap
>
> Working case: https://gitlab.com/gitlab-org/gitlab/uploads/4df1625bf3ab3775bc97d8b56546eacc/test-working.pcap
>
> In the working case, I see "No oplock" on the "Create request" for the
> temporary file in question, and the ExtraInfo flags are a little
> different (https://gitlab.com/gitlab-org/gitlab/-/issues/389995#note_1265800095).
>
> I attempted to set "cache=none,actimeo=0" in the mount options, but
> that did not seem to help.



-- 
Thanks,

Steve
