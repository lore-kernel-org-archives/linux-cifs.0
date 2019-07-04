Return-Path: <SRS0=KBsq=VB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E5ABC06517
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Jul 2019 11:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 009E3218A3
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Jul 2019 11:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfGDLW1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Jul 2019 07:22:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:38886 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727436AbfGDLW1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 4 Jul 2019 07:22:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 55C47ADEA;
        Thu,  4 Jul 2019 11:22:25 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>,
        linux-cifs@vger.kernel.org
Subject: Re: Many processes end up in uninterruptible sleep accessing cifs mounts
In-Reply-To: <1fc4f6d0-6cdc-69a5-4359-23484d6bdfc9@prodrive-technologies.com>
References: <684ed01c-cbca-2716-bc28-b0a59a0f8521@prodrive-technologies.com> <875zojx70t.fsf@suse.com> <1fc4f6d0-6cdc-69a5-4359-23484d6bdfc9@prodrive-technologies.com>
Date:   Thu, 04 Jul 2019 13:22:21 +0200
Message-ID: <8736jmxcwi.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com> writes:
>> Are there any kernel oops/panic with stack traces and register dumps in
>> the log?
>> 
>> You can inspect the kernel stack trace of the hung processes (to see where
>> they are stuck) by printing the file /proc/<pid>/stack.
>
> These are the stacks of all processes that are D, most of them being df.
> I also attached the cifs Stats output below.

Ok thanks. What about Oops or BUG or panic in dmesg logs, did you see
any?

The individual stack dumps are pretty useful. Here is my theory:

> pid: 9505
> syscall: 4 0x56550a2ec470 0x7ffede42e9a0 0x7ffede42e9a0 0x83a 0x3 0x20 
> 0x7ffede42e8f8 0x7f7f8928f295
> [<0>] open_shroot+0x43/0x200 [cifs]
> [<0>] smb2_query_path_info+0x93/0x220 [cifs]

Almost all of the processes have the same stack trace. They are stuck at
open_shroot()+0x43 which is probably

    mutex_lock(&tcon->crfid.fid_mutex); 

Then there are only 2 other processes stuck somewhere in the same code path
(open_shroot) but deeper, meaning they have the locks that the other
processes are waiting for:


> pid: 22858
> syscall: 4 0x564b46285d10 0x7ffcea3f9a80 0x7ffcea3f9a80 0x83a 0x3 0x20 
> 0x7ffcea3f99d8 0x7f6cc78c7295
> [<0>] cifs_mark_open_files_invalid+0x54/0xa0 [cifs]
> [<0>] smb2_reconnect+0x2d6/0x4b0 [cifs]
> [<0>] smb2_plain_req_init+0x30/0x240 [cifs]
> [<0>] SMB2_open_init+0x6d/0x7c0 [cifs]
> [<0>] SMB2_open+0x150/0x520 [cifs]
> [<0>] open_shroot+0x12f/0x200 [cifs]
> [<0>] smb2_query_path_info+0x93/0x220 [cifs]
> [<0>] cifs_get_inode_info+0x580/0xb10 [cifs]
> [<0>] cifs_revalidate_dentry_attr+0xdc/0x3e0 [cifs]
> [<0>] cifs_getattr+0x5b/0x1b0 [cifs]
> [<0>] vfs_statx+0x89/0xe0
> [<0>] __do_sys_newstat+0x39/0x70
> [<0>] do_syscall_64+0x55/0x100
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [<0>] 0xffffffffffffffff


> pid: 20027
> syscall: 4 0x55a3c7d767d0 0x7ffe51432ab0 0x7ffe51432ab0 0x83a 
> 0x55a3c7d75c40 0x20 0x7ffe51432a08 0x7f5f7c4e7295
> [<0>] cifs_mark_open_files_invalid+0x54/0xa0 [cifs]
> [<0>] smb2_reconnect+0x2d6/0x4b0 [cifs]
> [<0>] smb2_plain_req_init+0x30/0x240 [cifs]
> [<0>] SMB2_open_init+0x6d/0x7c0 [cifs]
> [<0>] SMB2_open+0x150/0x520 [cifs]
> [<0>] open_shroot+0x12f/0x200 [cifs]
> [<0>] smb2_query_path_info+0x93/0x220 [cifs]
> [<0>] cifs_get_inode_info+0x580/0xb10 [cifs]
> [<0>] cifs_revalidate_dentry_attr+0xdc/0x3e0 [cifs]
> [<0>] cifs_getattr+0x5b/0x1b0 [cifs]
> [<0>] vfs_statx+0x89/0xe0
> [<0>] __do_sys_newstat+0x39/0x70
> [<0>] do_syscall_64+0x55/0x100
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [<0>] 0xffffffffffffffff

Due to timeouts maybe the Open request needs
to reconnect the server/ses/tcon and to do this it calls
cifs_mark_open_files_invalid() and gets stuck somewhere there.

        spin_lock(&tcon->open_file_lock);
        list_for_each_safe(tmp, tmp1, &tcon->openFileList) {
                open_file = list_entry(tmp, struct cifsFileInfo, tlist);
                open_file->invalidHandle = true;
                open_file->oplock_break_cancelled = true;
        }
        spin_unlock(&tcon->open_file_lock);

        mutex_lock(&tcon->crfid.fid_mutex); <=== most likely here
        tcon->crfid.is_valid = false;
        memset(tcon->crfid.fid, 0, sizeof(struct cifs_fid));
        mutex_unlock(&tcon->crfid.fid_mutex);

I think these processes are trying to lock the same lock twice: one in
open_shroot() and since Open ends up having to reconnect, once again in
mark_open_files_invalid(). I think it's the same lock because I don't
see why the tcon pointers would be different in those 2 spots. Kernel
mutexes are not reentrant so this is a deadlock.

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 21284 (AG Nürnberg)
