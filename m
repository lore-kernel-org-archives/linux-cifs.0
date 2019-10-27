Return-Path: <SRS0=GKCu=YU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	LOTS_OF_MONEY,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A17ACA9EAF
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Oct 2019 23:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BF2C20873
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Oct 2019 23:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfJ0Xwj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 27 Oct 2019 19:52:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45784 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726909AbfJ0Xwj (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 27 Oct 2019 19:52:39 -0400
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com [209.85.219.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 71AC8C057E9A
        for <linux-cifs@vger.kernel.org>; Sun, 27 Oct 2019 23:52:38 +0000 (UTC)
Received: by mail-yb1-f197.google.com with SMTP id m18so6964619ybf.20
        for <linux-cifs@vger.kernel.org>; Sun, 27 Oct 2019 16:52:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QJ1IDOZgBklgfrFOP7QcuUlQyOUS0ltHldvgQRuPMkU=;
        b=Kflqc0rX7GGqHnnZt7dzi4qSniC7NtAEFW3mGRNahReMPFEq73mavxfp6ydHVVCFWd
         fBvqRa1l9U8Bewpb3WgEwI0dhBDGzmjC8S07I8mvgYUF8SpzH08C/vlY5nWkWX2ILqLu
         N2Baaui/G7Q+rIlgYxSXcRj3E87sZszRj9fFR4bg1G6xz6gU7oMT93YmM3TJYbqkaHNq
         rkHN+qPACqtHN8x/XgoTgFJnVr0ypNa/EhSepVL70MX+wV3JS2WYeKwb7YfF5vs13jud
         sybOUrh0UheT7Mj8wlm317Shcb6TARy9mT5jfyistojf458T1iYYR67NnTvPl2cKDZ1Y
         1MZA==
X-Gm-Message-State: APjAAAV9GtyufACL1xtH3URCPPv8hBBKeawe4fz8Bu9eg1eQi59jEuqG
        VzRJx5w0JHjH+VI4ZNeFN6vWgdZRAUnq3zMeqG6o89LjP1cxl/WoljRJczsfDTx/unBBJjlTYAD
        /69WzdZsbExN/zWkmbDHc2Q==
X-Received: by 2002:a81:a301:: with SMTP id a1mr10635633ywh.256.1572220357084;
        Sun, 27 Oct 2019 16:52:37 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxfPdU6Q1dUnbr3kjPCWbkrzk2yJqERXYGLER/H+6Ma4ive3Xk3St4LoitIiL6mNnBOb8Sdcw==
X-Received: by 2002:a81:a301:: with SMTP id a1mr10635614ywh.256.1572220356668;
        Sun, 27 Oct 2019 16:52:36 -0700 (PDT)
Received: from hut.sorensonfamily.com (198-0-247-150-static.hfc.comcastbusiness.net. [198.0.247.150])
        by smtp.gmail.com with ESMTPSA id e191sm5891037ywe.26.2019.10.27.16.52.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Oct 2019 16:52:35 -0700 (PDT)
Subject: Re: [PATCH 0/1] cifs: move cifsFileInfo_put logic into a work-queue
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
References: <20191026210419.7575-1-lsahlber@redhat.com>
From:   Frank Sorenson <sorenson@redhat.com>
Message-ID: <ca15c743-11f0-ff36-6c66-23ad795cf293@redhat.com>
Date:   Sun, 27 Oct 2019 18:52:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191026210419.7575-1-lsahlber@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/26/19 4:04 PM, Ronnie Sahlberg wrote:
> Steve, Pavel, Frank
> 
> This patch moves the logic in cifsFileInfo_put() into a work-queue so that
> it will be processed in a different thread which, importantly, does not hold
> any other locks.
> 
> This should address the deadlock that Frank reported in the thread:
> Yet another hang after network disruption or smb restart -- multiple file writers

Pavel,

Thanks for understanding my report and translating it into what it meant.

Ronnie,
Thanks for the patch.  I'm happy to say that my attempt at the same
looks like it would have been similar, had I known what I was doing to
begin with :)


Unfortunately, I think the patch really only moves the problem from one
place to another.  I'm guessing that means we have a second underlying
deadlock.  (this reproducer appears to be quite effective)


On the plus side, only the one file involved is jammed in the deadlock
now, as opposed to the parent directory as well, so it is at least progress.


#!/bin/bash

testfile=testfile
openloop() {
        while true ; do
                exec 10<>$testfile
                <&10 >/dev/null
                echo "testing $$" >&10
                exec 10>&-
        done
}
for i in {1..50} ; do
        openloop &
done
wait


and on the server (once):
# systemctl restart smb.service
(or anything else which forces a reconnect)


After doing the above with 20 child processes, all are now blocked, as
are 3 cifsfileinfoput kworkers, a cifsiod kworker, and a flush-cifs kworker:


# ps x | awk '{if (substr($3, 1, 1) == "D"){print $3,$NF}}' | sort  |
uniq -c | sort -rn
     20 D /var/tmp/openloop.sh
      1 D [kworker/u16:9+cifsfileinfoput]
      1 D [kworker/u16:8+cifsfileinfoput]
      1 D [kworker/u16:25+flush-cifs-1]
      1 D [kworker/u16:19+cifsfileinfoput]
      1 D [kworker/4:3+cifsiod]


12 of the openloop.sh processes:
	#0 __schedule at ffffffffab4f1a45
	#1 schedule at ffffffffab4f1ea0
	#2 rwsem_down_write_slowpath at ffffffffaad29a47
	#3 cifs_strict_writev at ffffffffc08010e2
	#4 new_sync_write at ffffffffaaeeff6d
	#5 vfs_write at ffffffffaaef2ac5
	#6 ksys_write at ffffffffaaef2d69
	#7 do_syscall_64 at ffffffffaac04345
in cifs_strict_writev:
        inode_lock(inode);


3 openloop.sh:
	#0 __schedule at ffffffffab4f1a45
	#1 schedule at ffffffffab4f1ea0
	#2 schedule_timeout at ffffffffab4f5949
	#3 msleep at ffffffffaad58d89
	#4 cifs_down_write at ffffffffc07fa2b5
	#5 cifs_new_fileinfo at ffffffffc07fa392
	#6 cifs_open at ffffffffc07fae1f
	#7 do_dentry_open at ffffffffaaeed90a
	#8 path_openat at ffffffffaaf0204a
	#9 do_filp_open at ffffffffaaf04753
	#10 do_sys_open at ffffffffaaeef066
	#11 do_syscall_64 at ffffffffaac04345



3 openloop.sh
	#0 __schedule at ffffffffab4f1a45
	#1 schedule at ffffffffab4f1ea0
	#2 io_schedule at ffffffffab4f22a2
	#3 wait_on_page_bit at ffffffffaae3fbc6
	#4 __filemap_fdatawait_range at ffffffffaae3e158
	#5 filemap_write_and_wait at ffffffffaae432c5
	#6 cifs_flush at ffffffffc0800fe3
	#7 filp_close at ffffffffaaeed181
	#8 do_dup2 at ffffffffaaf12c0b
	#9 __x64_sys_dup2 at ffffffffaaf1306a
	#10 do_syscall_64 at ffffffffaac04345

in __filemap_fdatawait_range:
	wait_on_page_writeback(page);



1 openloop.sh
	#0 __schedule at ffffffffab4f1a45
	#1 schedule at ffffffffab4f1ea0
	#2 io_schedule at ffffffffab4f22a2
	#3 wait_on_page_bit at ffffffffaae3fbc6
	#4 cifs_writepages at ffffffffc07ffc73
	#5 do_writepages at ffffffffaae4ba71
	#6 __filemap_fdatawrite_range at ffffffffaae4321b
	#7 filemap_write_and_wait at ffffffffaae432aa
	#8 cifs_flush at ffffffffc0800fe3
	#9 filp_close at ffffffffaaeed181
	#10 do_dup2 at ffffffffaaf12c0b
	#11 __x64_sys_dup2 at ffffffffaaf1306a
	#12 do_syscall_64 at ffffffffaac04345

in cifs_writepages, we're really in wdata_prepare_pages
                if (wbc->sync_mode != WB_SYNC_NONE)
                        wait_on_page_writeback(page);

1 openloop.sh
	#0 __schedule at ffffffffab4f1a45
	#1 schedule at ffffffffab4f1ea0
	#2 io_schedule at ffffffffab4f22a2
	#3 __lock_page at ffffffffaae3f66f
	#4 pagecache_get_page at ffffffffaae40ddf
	#5 grab_cache_page_write_begin at ffffffffaae420ac
	#6 cifs_write_begin at ffffffffc07f9ea9
	#7 generic_perform_write at ffffffffaae3eca4
	#8 __generic_file_write_iter at ffffffffaae4376a
	#9 cifs_strict_writev at ffffffffc08011cf
	#10 new_sync_write at ffffffffaaeeff6d
	#11 vfs_write at ffffffffaaef2ac5
	#12 ksys_write at ffffffffaaef2d69
	#13 do_syscall_64 at ffffffffaac04345



kworker/u16:8+cifsfileinfoput
kworker/u16:19+cifsfileinfoput
kworker/u16:9+cifsfileinfoput
	#0 __schedule at ffffffffab4f1a45
	#1 schedule at ffffffffab4f1ea0
	#2 schedule_timeout at ffffffffab4f5949
	#3 msleep at ffffffffaad58d89
	#4 cifs_down_write at ffffffffc07fa2b5
	#5 _cifsFileInfo_put_work at ffffffffc07fb687
	#6 cifsFileInfo_put_work at ffffffffc07fd816
	#7 process_one_work at ffffffffaacecc11
	#8 worker_thread at ffffffffaaced0f0
	#9 kthread at ffffffffaacf2ac2
	#10 ret_from_fork at ffffffffab600215

kworker/4:3+cifsiod
	#0 __schedule at ffffffffab4f1a45
	#1 schedule at ffffffffab4f1ea0
	#2 io_schedule at ffffffffab4f22a2
	#3 __lock_page at ffffffffaae3f66f
	#4 cifs_writev_complete at ffffffffc07df762
	#5 process_one_work at ffffffffaacecc11
	#6 worker_thread at ffffffffaaced0f0
	#7 kthread at ffffffffaacf2ac2
	#8 ret_from_fork at ffffffffab600215

kworker/u16:25+flush-cifs-1
	#0 __schedule at ffffffffab4f1a45
	#1 schedule at ffffffffab4f1ea0
	#2 io_schedule at ffffffffab4f22a2
	#3 __lock_page at ffffffffaae3f66f
	#4 cifs_writepages at ffffffffc07ffcbe
	#5 do_writepages at ffffffffaae4ba71
	#6 __writeback_single_inode at ffffffffaaf25bdd
	#7 writeback_sb_inodes at ffffffffaaf26315
	#8 __writeback_inodes_wb at ffffffffaaf2660d
	#9 wb_writeback at ffffffffaaf2698f
	#10 wb_workfn at ffffffffaaf279cf
	#11 process_one_work at ffffffffaacecc11
	#12 worker_thread at ffffffffaaced0f0
	#13 kthread at ffffffffaacf2ac2
	#14 ret_from_fork at ffffffffab600215


the page which processes are either trying to lock or are waiting on
writeback:
FLAGS: fffffc000809d
  PAGE-FLAG       BIT  VALUE
  PG_locked         0  0000001
  PG_uptodate       2  0000004
  PG_dirty          3  0000008
  PG_lru            4  0000010
  PG_waiters        7  0000080
  PG_writeback     15  0008000
  PG_savepinned     3  0000008





Frank
--
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer
Global Support Services - filesystems
Red Hat
