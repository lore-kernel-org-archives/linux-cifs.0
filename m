Return-Path: <SRS0=c2dJ=YS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D89B5CA9EA0
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Oct 2019 18:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F1DC2070B
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Oct 2019 18:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfJYShs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 25 Oct 2019 14:37:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38168 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbfJYShs (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 25 Oct 2019 14:37:48 -0400
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com [209.85.219.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 22F634E8AC
        for <linux-cifs@vger.kernel.org>; Fri, 25 Oct 2019 18:37:47 +0000 (UTC)
Received: by mail-yb1-f199.google.com with SMTP id o141so2649731yba.15
        for <linux-cifs@vger.kernel.org>; Fri, 25 Oct 2019 11:37:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ZsPAeQtU2CmOfJ6wS2NouFj4HTp248e+uhtwZUn87AM=;
        b=ReMsJh3WX4H1Vhagx5XbvCySD/oJkF227dtORqUspzYJLRXO4qIC5yzAP/IuABYrq8
         V3lHH5PL6ebnst7NqAghXp1bA5pPiSq0D18hL0rpRrtEEwizTzgZkpoXloVQjFg5iMoj
         LLtZfE8PMl7bkmq3/Bdroj2+X0LLx+hd9ObMnTJPcVn02o78svQS6plWOD7DciyZ40+Q
         tg+KIYEbMPaG8kvODonhVqkRGO0m8PfrPf8yZDpMkpNMuMFbSm1Zcdvsp8wuOQnZOcZk
         ctFXj2Q27RQrYBLPOh0HnEvTE7eaqZGgHYGo/l/B5qPUIyVhgrAssKo33CI0LMFHwplW
         fViQ==
X-Gm-Message-State: APjAAAXk9tMHLZXWc6zUAiyFq+uP8LjECG7huzTxvzHK5ID5kD+6O/2M
        LRegXe6Sk6CF7x0XSNuZOkLCMK3KxP35YkYQPKDE4i5pe5Ejbfc0wUI5FG4icf8lgjgupnPXgQR
        zRoEQdjLPLoa7+tXxA0USmg==
X-Received: by 2002:a25:b7c1:: with SMTP id u1mr4374558ybj.107.1572028665616;
        Fri, 25 Oct 2019 11:37:45 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzSuLIYbpB2pBhu1dfxPT8sOI8rIlAfheFMyByZ/t80LDu+sHhD/TxgUuFcCnOV38E8q1aOHw==
X-Received: by 2002:a25:b7c1:: with SMTP id u1mr4374518ybj.107.1572028664963;
        Fri, 25 Oct 2019 11:37:44 -0700 (PDT)
Received: from hut.sorensonfamily.com (198-0-247-150-static.hfc.comcastbusiness.net. [198.0.247.150])
        by smtp.gmail.com with ESMTPSA id x139sm1224963ywg.13.2019.10.25.11.37.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Oct 2019 11:37:43 -0700 (PDT)
To:     linux-cifs@vger.kernel.org, David Wysochanski <dwysocha@redhat.com>
From:   Frank Sorenson <sorenson@redhat.com>
Subject: Yet another hang after network disruption or smb restart -- multiple
 file writers
Message-ID: <7fbbbfae-b34e-27eb-d9a5-523826fb3181@redhat.com>
Date:   Fri, 25 Oct 2019 13:37:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

fI'm testing out multiple processes simultaneously doing an
open/read/write/close of the same file + smb restart test (next step
after the open/read/close + smb restart), and I'm hitting a different hang.

It's a bit more complex, so I haven't been able to unravel it like the
other hangs.

I'm using upstream 531e93d11470 with additional patches to fix the
recent crashes and deadlocks that the multiple-process open/read/close +
smb restart test hits:

Author: Pavel Shilovsky <piastryyy@gmail.com>
Date:   2019-10-23 15:55:40 -0700

    CIFS: Fix use after free of file info structures

Author: Pavel Shilovsky <piastryyy@xxxxxxxxx>
Date:   2019-10-22 15:35:34 -0700

    CIFS: Fix retry mid list corruption on reconnects

Author: Dave Wysochanski <dwysocha@xxxxxxxxxx>
Date:   2019-10-23 22:08:22 -0400

    cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs


(I've hit this hang both with and without the 'lock_sem deadlock' patch,
so at least the patch does not make things worse)


on the client, I'm running 50 processes:
  fd = open(testfile_path, O_RDWR|O_CREAT, 0644)
  read(fd, buf, 32768);
  write(fd, testfile_path, strlen(testfile_path);
  close(fd);

on smb server (once):
  systemctl restart smb.service



there are 6 processes looping to while trying to down_write
cinode->lock_sem, 5 of them from _cifsFileInfo_put, and one from
cifs_new_fileinfo

and there are 5 other processes which are blocked, several of them
waiting on either PG_writeback or PG_locked (which are both set), all
for the same page of the file

2 inode_lock() (inode->i_rwsem) for the file
1 wait_on_page_writeback() for the page
1 down_read(inode->i_rwsem) for the inode of the directory
1 inode_lock()(inode->i_rwsem) for the inode of the directory
1 __lock_page


so processes are blocked waiting on:
  page flags PG_locked and PG_writeback for one specific page
  inode->i_rwsem for the directory
  inode->i_rwsem for the file
  cifsInodeInfo->lock_sem



here are the more gory details (let me know if I need to provide
anything more/better):

[0 00:48:22.765] [UN]  PID: 8863   TASK: ffff8c691547c5c0  CPU: 3
COMMAND: "reopen_file"
 #0 [ffff9965007e3ba8] __schedule at ffffffff9b6e6095
 #1 [ffff9965007e3c38] schedule at ffffffff9b6e64df
 #2 [ffff9965007e3c48] rwsem_down_write_slowpath at ffffffff9af283d7
 #3 [ffff9965007e3cb8] legitimize_path at ffffffff9b0f975d
 #4 [ffff9965007e3d08] path_openat at ffffffff9b0fe55d
 #5 [ffff9965007e3dd8] do_filp_open at ffffffff9b100a33
 #6 [ffff9965007e3ee0] do_sys_open at ffffffff9b0eb2d6
 #7 [ffff9965007e3f38] do_syscall_64 at ffffffff9ae04315
* (I think legitimize_path is bogus)

in path_openat
        } else {
                const char *s = path_init(nd, flags);
                while (!(error = link_path_walk(s, nd)) &&
                        (error = do_last(nd, file, op)) > 0) {  <<<<

do_last:
        if (open_flag & O_CREAT)
                inode_lock(dir->d_inode);  <<<<
        else
so it's trying to take inode->i_rwsem for the directory

     DENTRY           INODE           SUPERBLK     TYPE PATH
ffff8c68bb8e79c0 ffff8c691158ef20 ffff8c6915bf9000 DIR  /mnt/vm1_smb/
inode.i_rwsem is ffff8c691158efc0

<struct rw_semaphore 0xffff8c691158efc0>:
        owner: <struct task_struct 0xffff8c6914275d00> (UN -   8856 -
reopen_file), counter: 0x0000000000000003
        waitlist: 2
        0xffff9965007e3c90     8863   reopen_file      UN 0  1:29:22.926
  RWSEM_WAITING_FOR_WRITE
        0xffff996500393e00     9802   ls               UN 0  1:17:26.700
  RWSEM_WAITING_FOR_READ


the owner of the inode.i_rwsem of the directory is:

[0 00:00:00.109] [UN]  PID: 8856   TASK: ffff8c6914275d00  CPU: 3
COMMAND: "reopen_file"
 #0 [ffff99650065b828] __schedule at ffffffff9b6e6095
 #1 [ffff99650065b8b8] schedule at ffffffff9b6e64df
 #2 [ffff99650065b8c8] schedule_timeout at ffffffff9b6e9f89
 #3 [ffff99650065b940] msleep at ffffffff9af573a9
 #4 [ffff99650065b948] _cifsFileInfo_put.cold.63 at ffffffffc0a42dd6 [cifs]
 #5 [ffff99650065ba38] cifs_writepage_locked at ffffffffc0a0b8f3 [cifs]
 #6 [ffff99650065bab0] cifs_launder_page at ffffffffc0a0bb72 [cifs]
 #7 [ffff99650065bb30] invalidate_inode_pages2_range at ffffffff9b04d4bd
 #8 [ffff99650065bcb8] cifs_invalidate_mapping at ffffffffc0a11339 [cifs]
 #9 [ffff99650065bcd0] cifs_revalidate_mapping at ffffffffc0a1139a [cifs]
#10 [ffff99650065bcf0] cifs_d_revalidate at ffffffffc0a014f6 [cifs]
#11 [ffff99650065bd08] path_openat at ffffffff9b0fe7f7
#12 [ffff99650065bdd8] do_filp_open at ffffffff9b100a33
#13 [ffff99650065bee0] do_sys_open at ffffffff9b0eb2d6
#14 [ffff99650065bf38] do_syscall_64 at ffffffff9ae04315

cifs_launder_page is for page 0xffffd1e2c07d2480

crash> page.index,mapping,flags 0xffffd1e2c07d2480
      index = 0x8
      mapping = 0xffff8c68f3cd0db0
  flags = 0xfffffc0008095

  PAGE-FLAG       BIT  VALUE
  PG_locked         0  0000001
  PG_uptodate       2  0000004
  PG_lru            4  0000010
  PG_waiters        7  0000080
  PG_writeback     15  0008000


inode is ffff8c68f3cd0c40
inode.i_rwsem is ffff8c68f3cd0ce0
     DENTRY           INODE           SUPERBLK     TYPE PATH
ffff8c68a1f1b480 ffff8c68f3cd0c40 ffff8c6915bf9000 REG
/mnt/vm1_smb/testfile.8853


this process holds the inode->i_rwsem for the parent directory, is
laundering a page attached to the inode of the file it's opening, and in
_cifsFileInfo_put is trying to down_write the cifsInodeInfo->lock_sem
for the file itself.


<struct rw_semaphore 0xffff8c68f3cd0ce0>:
        owner: <struct task_struct 0xffff8c6914272e80> (UN -   8854 -
reopen_file), counter: 0x0000000000000003
        waitlist: 1
        0xffff9965005dfd80     8855   reopen_file      UN 0  1:29:22.912
  RWSEM_WAITING_FOR_WRITE

this is the inode.i_rwsem for the file

the owner:

[0 00:48:22.739] [UN]  PID: 8854   TASK: ffff8c6914272e80  CPU: 2
COMMAND: "reopen_file"
 #0 [ffff99650054fb38] __schedule at ffffffff9b6e6095
 #1 [ffff99650054fbc8] schedule at ffffffff9b6e64df
 #2 [ffff99650054fbd8] io_schedule at ffffffff9b6e68e2
 #3 [ffff99650054fbe8] __lock_page at ffffffff9b03c56f
 #4 [ffff99650054fc80] pagecache_get_page at ffffffff9b03dcdf
 #5 [ffff99650054fcc0] grab_cache_page_write_begin at ffffffff9b03ef4c
 #6 [ffff99650054fcd0] cifs_write_begin at ffffffffc0a064ec [cifs]
 #7 [ffff99650054fd30] generic_perform_write at ffffffff9b03bba4
 #8 [ffff99650054fda8] __generic_file_write_iter at ffffffff9b04060a
 #9 [ffff99650054fdf0] cifs_strict_writev.cold.70 at ffffffffc0a4469b [cifs]
#10 [ffff99650054fe48] new_sync_write at ffffffff9b0ec1dd
#11 [ffff99650054fed0] vfs_write at ffffffff9b0eed35
#12 [ffff99650054ff00] ksys_write at ffffffff9b0eefd9
#13 [ffff99650054ff38] do_syscall_64 at ffffffff9ae04315

the process holds the inode->i_rwsem for the file to which it's writing,
and is trying to __lock_page for the same page as in the other processes


the other tasks:
[0 00:00:00.028] [UN]  PID: 8859   TASK: ffff8c6915479740  CPU: 2
COMMAND: "reopen_file"
 #0 [ffff9965007b39d8] __schedule at ffffffff9b6e6095
 #1 [ffff9965007b3a68] schedule at ffffffff9b6e64df
 #2 [ffff9965007b3a78] schedule_timeout at ffffffff9b6e9f89
 #3 [ffff9965007b3af0] msleep at ffffffff9af573a9
 #4 [ffff9965007b3af8] cifs_new_fileinfo.cold.61 at ffffffffc0a42a07 [cifs]
 #5 [ffff9965007b3b78] cifs_open at ffffffffc0a0709d [cifs]
 #6 [ffff9965007b3cd8] do_dentry_open at ffffffff9b0e9b7a
 #7 [ffff9965007b3d08] path_openat at ffffffff9b0fe34f
 #8 [ffff9965007b3dd8] do_filp_open at ffffffff9b100a33
 #9 [ffff9965007b3ee0] do_sys_open at ffffffff9b0eb2d6
#10 [ffff9965007b3f38] do_syscall_64 at ffffffff9ae04315

this is opening the file, and is trying to down_write cinode->lock_sem


[0 00:00:00.041] [UN]  PID: 8860   TASK: ffff8c691547ae80  CPU: 2
COMMAND: "reopen_file"
[0 00:00:00.057] [UN]  PID: 8861   TASK: ffff8c6915478000  CPU: 3
COMMAND: "reopen_file"
[0 00:00:00.059] [UN]  PID: 8858   TASK: ffff8c6914271740  CPU: 2
COMMAND: "reopen_file"
[0 00:00:00.109] [UN]  PID: 8862   TASK: ffff8c691547dd00  CPU: 6
COMMAND: "reopen_file"
 #0 [ffff9965007c3c78] __schedule at ffffffff9b6e6095
 #1 [ffff9965007c3d08] schedule at ffffffff9b6e64df
 #2 [ffff9965007c3d18] schedule_timeout at ffffffff9b6e9f89
 #3 [ffff9965007c3d90] msleep at ffffffff9af573a9
 #4 [ffff9965007c3d98] _cifsFileInfo_put.cold.63 at ffffffffc0a42dd6 [cifs]
 #5 [ffff9965007c3e88] cifs_close at ffffffffc0a07aaf [cifs]
 #6 [ffff9965007c3ea0] __fput at ffffffff9b0efa6e
 #7 [ffff9965007c3ee8] task_work_run at ffffffff9aef1614
 #8 [ffff9965007c3f20] exit_to_usermode_loop at ffffffff9ae03d6f
 #9 [ffff9965007c3f38] do_syscall_64 at ffffffff9ae0444c

closing the file, and trying to down_write cifsi->lock_sem


[0 00:48:22.839] [UN]  PID: 8857   TASK: ffff8c6914270000  CPU: 7
COMMAND: "reopen_file"
 #0 [ffff9965006a7cc8] __schedule at ffffffff9b6e6095
 #1 [ffff9965006a7d58] schedule at ffffffff9b6e64df
 #2 [ffff9965006a7d68] io_schedule at ffffffff9b6e68e2
 #3 [ffff9965006a7d78] wait_on_page_bit at ffffffff9b03cac6
 #4 [ffff9965006a7e10] __filemap_fdatawait_range at ffffffff9b03b028
 #5 [ffff9965006a7ed8] filemap_write_and_wait at ffffffff9b040165
 #6 [ffff9965006a7ef0] cifs_flush at ffffffffc0a0c2fa [cifs]
 #7 [ffff9965006a7f10] filp_close at ffffffff9b0e93f1
 #8 [ffff9965006a7f30] __x64_sys_close at ffffffff9b0e9a0e
 #9 [ffff9965006a7f38] do_syscall_64 at ffffffff9ae04315

in __filemap_fdatawait_range
                        wait_on_page_writeback(page);
for the same page of the file



[0 00:48:22.718] [UN]  PID: 8855   TASK: ffff8c69142745c0  CPU: 7
COMMAND: "reopen_file"
 #0 [ffff9965005dfc98] __schedule at ffffffff9b6e6095
 #1 [ffff9965005dfd28] schedule at ffffffff9b6e64df
 #2 [ffff9965005dfd38] rwsem_down_write_slowpath at ffffffff9af283d7
 #3 [ffff9965005dfdf0] cifs_strict_writev at ffffffffc0a0c40a [cifs]
 #4 [ffff9965005dfe48] new_sync_write at ffffffff9b0ec1dd
 #5 [ffff9965005dfed0] vfs_write at ffffffff9b0eed35
 #6 [ffff9965005dff00] ksys_write at ffffffff9b0eefd9
 #7 [ffff9965005dff38] do_syscall_64 at ffffffff9ae04315

        inode_lock(inode);


and one 'ls' later on, to see whether the rest of the mount is available
(the test file is in the root, so we get blocked up on the directory
->i_rwsem), so the entire mount is unavailable

[0 00:36:26.473] [UN]  PID: 9802   TASK: ffff8c691436ae80  CPU: 4
COMMAND: "ls"
 #0 [ffff996500393d28] __schedule at ffffffff9b6e6095
 #1 [ffff996500393db8] schedule at ffffffff9b6e64df
 #2 [ffff996500393dc8] rwsem_down_read_slowpath at ffffffff9b6e9421
 #3 [ffff996500393e78] down_read_killable at ffffffff9b6e95e2
 #4 [ffff996500393e88] iterate_dir at ffffffff9b103c56
 #5 [ffff996500393ec8] ksys_getdents64 at ffffffff9b104b0c
 #6 [ffff996500393f30] __x64_sys_getdents64 at ffffffff9b104bb6
 #7 [ffff996500393f38] do_syscall_64 at ffffffff9ae04315

in iterate_dir:
        if (shared)
                res = down_read_killable(&inode->i_rwsem);  <<<<
        else
                res = down_write_killable(&inode->i_rwsem);



mount looks like:
271 97 0:51 / /mnt/vm1_smb rw,relatime shared:143 - cifs //vm1/cifs
rw,vers=2.1,sec=ntlmssp,cache=strict,username=user1,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.122.73,file_mode=0755,dir_mode=0755,hard,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,bsize=1048576,echo_interval=60,actimeo=1



# cat /proc/fs/cifs/DebugData
Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 2.23
Features:
DFS,STATS2,DEBUG,ALLOW_INSECURE_LEGACY,WEAK_PW_HASH,CIFS_POSIX,UPCALL(SPNEGO),XATTR,ACL
CIFSMaxBufSize: 16384
Active VFS Requests: 2
Servers:
Number of credits: 241 Dialect 0x210
1) Name: 192.168.122.73 Uses: 1 Capability: 0x300007	Session Status: 1
TCP status: 1 Instance: 3
	Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 In Send: 0 In
MaxReq Wait: 0 SessionId: 0xd90a3306
	Shares:
	0) IPC: \\vm1\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
	PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0

	1) \\vm1\cifs Mounts: 1 DevInfo: 0x20 Attributes: 0x1006f
	PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0x0

	MIDs:


Frank
--
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer
Global Support Services - filesystems
Red Hat
