Return-Path: <SRS0=/QKu=BA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76ED3C433DF
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Jul 2020 13:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C279206E9
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Jul 2020 13:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgGUNwV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Jul 2020 09:52:21 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8347 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726109AbgGUNwU (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Jul 2020 09:52:20 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E963B25F2E5159DE8592;
        Tue, 21 Jul 2020 21:52:15 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.224) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 21 Jul 2020
 21:52:11 +0800
Subject: Re: PROBLEM: mv command fails: "File exists" on cifs mount on
 kernel>=5.7.8
To:     Patrick Fernie <patrick.fernie@gmail.com>, <sfrench@samba.org>
CC:     <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>
References: <CAD737DGhAiRUb6WZz_RQ6GwfXwH3CFB_5iOmzvnJwSPoncXdLg@mail.gmail.com>
From:   "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
Message-ID: <d8dbaf42-0f81-f25e-ea47-28b29c44fcd1@huawei.com>
Date:   Tue, 21 Jul 2020 21:52:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAD737DGhAiRUb6WZz_RQ6GwfXwH3CFB_5iOmzvnJwSPoncXdLg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.224]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks for your report.

Since commit 9ffad9263b46 ("cifs: Fix the target file was deleted
when rename failed.") want to fix the problem when rename(file1, file2)
with file2 exist, the server return -EACESS, then cifs client will
delete the file2 and rename it again, but 2nd rename on server also
return -EACESS, then the file2 was deleted.

It can be reproduce by xfstests generic/035.
When 't_rename_overwrite file1 file2':
   open(file2)
   rename(file1, file2)
   fstat(file2).st_nlink should be 0.

The solution on commit 9ffad9263b46 ("cifs: Fix the target file was
deleted when rename failed.") was wrong. we should revert it.

The root cause of the file2 deleted maybe the file2 was opened
when rename(file1, file2), I will re-debug it.

在 2020/7/21 1:09, Patrick Fernie 写道:
> # One line summary of the problem:
> 
> mv command fails: "File exists" on cifs mount on kernel>=5.7.8
> 
> # Full description of the problem/report:
> 
> Since v5.7.8 (v5.4.51 for -lts), there appears to be a regression with
> cifs mounts; mv commands fail with a "File exists" when attempting to
> overwrite a file. Similarly, rsync commands which create a temporary
> file during transfer and then attempt to move it into place after
> copying fail ("File Exists (17)"). I believe this is related to this
> commit: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/fs/cifs/inode.c?id=9ffad9263b467efd8f8dc7ae1941a0a655a2bab2
> 
> The mount in question is from a Drobo FS NAS device, and is forced to
> SMB1 (`vers=1.0` specified).
> 
> Running v5.7.7 or 5.4.50 does not exhibit this behavior, behavior was
> confirmed on 5.7.8, 5.7.9, 5.4.51 and 5.4.52.
> 
> These users appear to be experiencing the same issue:
> 1) https://serverfault.com/questions/1025734/cifs-automounts-suddenly-stopped-working
> 2) https://unix.stackexchange.com/questions/599281/cifs-mount-is-returning-errors-when-operating-on-remote-files-file-exists-inte
> 
> # Most recent kernel version which did not have the bug:
> 
> 5.7.7 / 5.4.50
> 
> # A small shell script or example program which triggers the problem
> (if possible):
> 
> [vagrant@archlinux ~]$ uname -a
> Linux archlinux 5.7.9-arch1-1 #1 SMP PREEMPT Thu, 16 Jul 2020 19:34:49
> +0000 x86_64 GNU/Linux
> # Same behavior seen on Linux archlinux 5.4.52-1-lts #1 SMP Thu, 16
> Jul 2020 19:35:06 +0000 x86_64 GNU/Linux
> [vagrant@archlinux ~]$ cd /mnt/drobo/Share/cifs-test/
> [vagrant@archlinux cifs-test]$ touch a b
> [vagrant@archlinux cifs-test]$ mv a b
> mv: cannot move 'a' to 'b': File exists
> [vagrant@archlinux cifs-test]$ mkdir -p /tmp/sync_dir
> [vagrant@archlinux cifs-test]$ touch /tmp/sync_dir/foo
> [vagrant@archlinux cifs-test]$ rsync -rap /tmp/sync_dir .
> [vagrant@archlinux cifs-test]$ touch /tmp/sync_dir/foo
> [vagrant@archlinux cifs-test]$ rsync -rap /tmp/sync_dir .
> rsync: [receiver] rename
> "/mnt/drobo/Share/cifs-test/sync_dir/.foo.FQiit5" -> "sync_dir/foo":
> File exists (17)
> rsync error: some files/attrs were not transferred (see previous
> errors) (code 23) at main.c(1287) [sender=3.2.2]
> 
> ## Behavior as expected on older kernel:
> 
> [vagrant@archlinux ~]$ uname -a
> Linux archlinux 5.7.7-arch1-1 #1 SMP PREEMPT Wed, 01 Jul 2020 14:53:16
> +0000 x86_64 GNU/Linux
> # Same behavior seen on Linux archlinux 5.4.50-1-lts #1 SMP Wed, 01
> Jul 2020 14:53:03 +0000 x86_64 GNU/Linux
> [vagrant@archlinux ~]$ cd /mnt/drobo/Share/cifs-test/
> [vagrant@archlinux cifs-test]$ touch a b
> [vagrant@archlinux cifs-test]$ mv a b
> [vagrant@archlinux cifs-test]$ mkdir -p /tmp/sync_dir
> [vagrant@archlinux cifs-test]$ touch /tmp/sync_dir/foo
> [vagrant@archlinux cifs-test]$ rsync -rap /tmp/sync_dir .
> [vagrant@archlinux cifs-test]$ touch /tmp/sync_dir/foo
> [vagrant@archlinux cifs-test]$ rsync -rap /tmp/sync_dir .
> [vagrant@archlinux cifs-test]$
> 
> # Environment:
> 
> Arch Linux
> 
> CIFS mount (vers=1.0) from Drobo FS NAS device
> 
> CIFS share mount information:
> 
> systemd-1 on /mnt/drobo/Share type autofs
> (rw,relatime,fd=44,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=12139)
> //10.76.9.11/Share on /mnt/drobo/Share type cifs
> (rw,relatime,vers=1.0,cache=strict,username=XXXXXXX,uid=0,noforceuid,gid=0,noforcegid,addr=10.76.9.11,file_mode=0775,dir_mode=0775,nocase,soft,nounix,serverino,mapposix,nobrl,noperm,rsize=61440,wsize=65536,bsize=1048576,echo_interval=60,actimeo=1,x-systemd.automount)
> 
> Regards,
> Patrick Fernie
> 
> .
> 

