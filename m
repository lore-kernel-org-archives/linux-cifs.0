Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7CA7C7EE23
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Mar 2023 22:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjCAWHf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Mar 2023 17:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCAWHe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Mar 2023 17:07:34 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0C5521C6
        for <linux-cifs@vger.kernel.org>; Wed,  1 Mar 2023 14:07:29 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id ce7so8914528pfb.9
        for <linux-cifs@vger.kernel.org>; Wed, 01 Mar 2023 14:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ixsystems.com; s=google; t=1677708448;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FvSzEV5Hzq4J6WiIDMhsPCM11dCYTu5lfv/0FNsFUZs=;
        b=ZA9YPnBiO5FuQjIn5xjS/SBvUPZPkSjgpfY1UJWsJAsp7991cFV7qReygFSCy/vW4a
         FPxFKlIiv6bRcgJqOi1LGCX6PJz5BHs09Jp2V98qh38y/duwif29jwRGNEBVL1dqiXd4
         vhhvgDuBUXzYS0OQ5uJstX0+rN0tPW6QlTYBQMiLwHk/MCYn+r6hU1HwjLpIoUl/ajnc
         N3WLQeoSKA/rlMlfvvgxIW+tSpjkns18jmEKnVMB7fVaI4Rxhqx7m+4jipo0Dafd4jAG
         pprdlJiu/RiZK8DOokRSc4TPwarRzekILYEAVFok0GqvZYgCZZQi8S5ut8ocBFBB6JPa
         7tXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677708448;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FvSzEV5Hzq4J6WiIDMhsPCM11dCYTu5lfv/0FNsFUZs=;
        b=0hWAuGeKs4pj6wi+wFwPd3V1Cuh696GulplSb5AY0yFM+iaZXlVayantNWBknIIz+U
         3FZTStM26Q0HEmhJma9ZYCCW6r4mbiZ7Og+2tiQovgXxkt0QKDwXdjb2bjtfMNEeccC2
         7eB9UeV4OtKsu/occfKD8Qft0+gcFFFfJ7V4U/X0FTcJi/TrBdPn7TZIgSPXILf85U1r
         0UOX5ptX3ur1OTboKDSWne4/ki6wYlSvBurOAzaEwIMiElUU2nYLaVs2M3f1ih/I7mwZ
         gtk8BQGaS849tVK+GS7D+tJtuDHWmyFQ+dPgJ56UCeNK37lqtSdjyPsa04uSgtxBsbnW
         BZFw==
X-Gm-Message-State: AO0yUKU1rYVp4FdRtOQqeGXPSVLaJbBHqjFQ1kZZ4T++FJ1rPQleCwxT
        XnLliyVU5lc8H7osaaDJVgLvtT2nImlSQlYwoy6xr/93lHxj79isQ/Q=
X-Google-Smtp-Source: AK7set+vIMK0mnp54TFAiLwoc16hcMEIf13dP5AdZW4iIB/Ks5aH8wdNtM97d/o4Trd40VUmhvPh9wfm0lHII5v/MBI=
X-Received: by 2002:a63:b513:0:b0:4fc:a80e:e6ec with SMTP id
 y19-20020a63b513000000b004fca80ee6ecmr2658600pge.5.1677708448180; Wed, 01 Mar
 2023 14:07:28 -0800 (PST)
MIME-Version: 1.0
From:   Andrew Walker <awalker@ixsystems.com>
Date:   Wed, 1 Mar 2023 17:07:17 -0500
Message-ID: <CAB5c7xoUXH6Xy+79Wz8M4yC70E=rwUL0ZRD_ApAFWv=C7S_uxg@mail.gmail.com>
Subject: Nested NTFS volumes within Windows SMB share may result in inode
 collisions in linux client
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On my Windows server I mounted multiple NTFS volumes within the same
share and played around until I was able to create directories with
the same fileid number.

 ```
PS C:\SHARE> fsutil file queryFileID SUBDS/foo
File ID is 0x00000000000000000001000000000026
PS C:\SHARE> fsutil file queryFileID .\SUBDS3\TESTFOLDER\
File ID is 0x00000000000000000001000000000026
```
The Linux SMB client then grants these two directories the same devid
/ inode pair.

```
root@truenas[/tmpcifs]# stat SUBDS/foo
  File: SUBDS/foo
  Size: 0         Blocks: 0          IO Block: 1048576 directory
Device: 5eh/94d Inode: 281474976710694  Links: 2
Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2023-03-01 13:13:42.425159200 -0800
Modify: 2023-03-01 13:13:42.425159200 -0800
Change: 2023-03-01 13:13:42.425159200 -0800
 Birth: 2023-02-22 10:49:37.331907600 -0800

root@truenas[/tmpcifs]# stat SUBDS3/TESTFOLDER
  File: SUBDS3/TESTFOLDER
  Size: 0         Blocks: 0          IO Block: 1048576 directory
Device: 5eh/94d Inode: 281474976710694  Links: 2
Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2023-03-01 12:25:56.283589300 -0800
Modify: 2023-03-01 12:25:56.268165700 -0800
Change: 2023-03-01 12:25:56.268165700 -0800
 Birth: 2023-03-01 11:48:09.617084100 -0800
```

Windows identifies mounted volumes via reparse point:
https://learn.microsoft.com/en-us/windows/win32/fileio/determining-whether-a-directory-is-a-volume-mount-point

This is also clearly visible in packet captures.

Andrew
