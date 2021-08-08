Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A51F9C4338F
	for <linux-cifs@archiver.kernel.org>; Sun,  8 Aug 2021 06:13:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7401860FD8
	for <linux-cifs@archiver.kernel.org>; Sun,  8 Aug 2021 06:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbhHHGNm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 8 Aug 2021 02:13:42 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:28221 "EHLO smtp3-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhHHGNl (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 8 Aug 2021 02:13:41 -0400
Received: from [IPv6:fde6:7a:7d20:612::1095] (unknown [IPv6:2a00:1678:1337:7a21:1467:3dd8:95d9:eced])
        (Authenticated sender: landrlatz@free.fr)
        by smtp3-g21.free.fr (Postfix) with ESMTPA id 1483D13F7F0
        for <linux-cifs@vger.kernel.org>; Sun,  8 Aug 2021 08:13:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1628403202;
        bh=KUO1xKKS0/hkIMzyWW+YFd9NMQgqgseitpJf01X2yCQ=;
        h=To:From:Subject:Date:From;
        b=NaSFx9Lcw8zEoWRCMBlvRnNUEauswvJYXkpply+FCv5fnbX7jKjF09ooLzXh8zenP
         rzzvRsADYZpxpeNmPjr38CYXIPhAIzLrXwS0XsEhvr07OTlrFVdc6W7hREKQDd8ZwG
         Kc0bWAcqfJcYEDB4igScFiSy/fOeELqqPOtRsGLtu7Kh/d+niEkXw8hqp4FuZpcA9l
         jXCmPissjntjZaflzJkGxL2jD9ut+kpd1y5AG8tSiaREArJvHnuuawN0Tvpve0Yq3T
         nrgbTRwTiJVcGeMbqxdYQUmYYj1hmYGVIptVN3+X92Gvo4Q3+Mwl6gpDBSLQHmOv3/
         Y6CqabyM3qYpw==
To:     linux-cifs@vger.kernel.org
From:   Gene Poole <landrlatz@free.fr>
Subject: CIFS share becomes inaccessible but can be reached by smbclient
Message-ID: <b625b223-16d9-10ad-a9ea-3289ee4c478f@free.fr>
Date:   Sun, 8 Aug 2021 08:13:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello. I need to state right away that I am not an IT person and only 
began learning Linux so I could create a small home music-and-backup server.

The little server in question is a Wandboard running Arch Linux ARM. It 
comprises two HDDS which mirror each other. it serves a Windows PC and a 
Logitech Squeezebox music appliance. It has no HIDs and I administrate 
it from the Windows (Ultimate 7) PC using PuTTY.

The shares on the Wandboard have no problem being read from and written 
to by the Windows PC and the Squeezebox. But shares on the Windows PC 
mounted on the Wandbord at boot become inaccessible after a certain 
period of time (sometimes as short as 20 minutes). An ls command to list 
the mount directory of the share shows "Host is down. " Chmod shows the 
mount directory (/mnt/Work)  with ??? ??? ??. An attempt to remount 
after unmounting shows "No such file or directory." Network traces show 
no SMB2 calls being mde to the Windows PC.

Setting up the Windows share to automount with systemd and auto-unmount 
after 1 minute without activity has helped in that the share remains 
accessible (so far for up to 12 hours and counting). *But if* I cd into 
the actual mount directory (which seems to cause the auto-unmount to 
stop functioning), the same symptoms appear. There is only one slight 
difference: Instead of "Host is down" the error is "cannot access 
'/mnt/Work': No such device."

I have been to several different forums (including Arch Linux Questions 
and Server Fault, etc.) with this question and no one has been able to 
or found the time to help. I can't find a specific cifs forum. I am in 
the process of reading the LinuxCIFS utils documentation, but it is slow 
going for me. I would appreciate any tips anyone can give and/or the 
name of an appropriate forum or mailing list. I can supply any 
information, but may need help with gathering it.

Thanks for reading.

      - Arch Linux ARM version 5.7.2-1-ARCH
        - samba v 4.12.3
        - cifs-utils v 2.26
        - mount.cifs v 6.10
      - host: Windows 7 Ultimate with SMB1 disabled and SMB2 enabled, 
all permissions and policies verfied

