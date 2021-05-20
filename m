Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67049C433B4
	for <linux-cifs@archiver.kernel.org>; Thu, 20 May 2021 15:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E4C26023E
	for <linux-cifs@archiver.kernel.org>; Thu, 20 May 2021 15:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243732AbhETPVJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 May 2021 11:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243729AbhETPVI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 May 2021 11:21:08 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9074CC061574
        for <linux-cifs@vger.kernel.org>; Thu, 20 May 2021 08:19:45 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id m190so12096350pga.2
        for <linux-cifs@vger.kernel.org>; Thu, 20 May 2021 08:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c9TbBs936dMXZ4ARWnU7oivbZzK8qr5Z7gKGUQloUiM=;
        b=kAgclMEuoZ7ljhC4R3Yg7IWj7GOQfpHI9MF3PDQ7vsF5h5oTNgME9F5PAlUSpylU8y
         r1JfgnR4+p66kaFJEJ/cFf4Ubh8drTf1b1JCpGc0cMjHL1NdjkGa+r+91QP000Y6OEEv
         oVJ5j0bO6q4KZKWfWUQYjfr8nU3sjB2KF9IDgwoxOvwm+y63f0VP8S0uK1LLMwPeEX7V
         HDJXLiqUEvtuJtnLvBCA4ZVmfHGF/T+XQQaucAtLC/M4Ct4Qmgxw7umpuCyuPlnOdi47
         565cNX7gfw98OBDYLf9vYO7RUhXWLaDlt67CCLFFHSBF/ykX/FY4K8yPvBgXStItp3n+
         y26Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c9TbBs936dMXZ4ARWnU7oivbZzK8qr5Z7gKGUQloUiM=;
        b=aXYpkNWTNQjYC0fqx3+6pzM2+kO6bXh1yOMjeJMvTxNtGM55pRFfXuSZ8mO7lkC/j1
         PBH7jb24EAc7A7g3shCsIDVtbQoPy3AjAsKCIaq/mrrte4GYPN2Dcj+5kZtHBChe/54+
         dvYoFXY1k+PDlXw+hJUURjs5wvA2LAMb8PxW0IJ6LLpv/r9Bd00N/2M9lihj9eH6VJJO
         SqJ3FG30p35HWShxonGQ2J3oCQW2LMjTGAyIn46QuqR2ii9T34CNbh86Doi5MF2/q8Dn
         fXYo3enIplskSQ3RVO0tHn4ZsYsp1Gbe/W+Wx6Sdkhedjid1xUE3LrAjsHD82HLpHBgJ
         50wg==
X-Gm-Message-State: AOAM531r1OrV/+b5AMiUFpgGsFeMUfAcowanYKk5JdbOMFwoRByQZLcw
        HofqaZMWz2eS/CGXqYpC6YDza5Sn4uNc8XkuVGg=
X-Google-Smtp-Source: ABdhPJzVgnAXO4Hw0VcpKGgG91HuZ1nCxsjjWNOX8E8F7heZSF/gtmg6bcuw5u0Pwff3eSu/n7ZBy0DGqPXbOClZU3A=
X-Received: by 2002:a63:5c5e:: with SMTP id n30mr5052992pgm.87.1621523985072;
 Thu, 20 May 2021 08:19:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAN05THS7_pmJkzoOvRsDbjQhUUn7h5M2GEG4obt4KizHs3OwRQ@mail.gmail.com>
 <CACdtm0Y4hcWbXhhSz7eQPc3OUYnpmm87u2jHmS3JQSFrytV8KQ@mail.gmail.com> <CAN05THRAbFqV8T1ZcjiqcKpMXUPGEDkG-ySwUS6huO8eM50mMQ@mail.gmail.com>
In-Reply-To: <CAN05THRAbFqV8T1ZcjiqcKpMXUPGEDkG-ySwUS6huO8eM50mMQ@mail.gmail.com>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Thu, 20 May 2021 20:49:33 +0530
Message-ID: <CACdtm0YKqt6aF2Eftbeap-gMTjKta_HEmoSfUw-MxUqX40GqNg@mail.gmail.com>
Subject: Re: KASAN use after free in deferred close
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000002062b405c2c47964"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000002062b405c2c47964
Content-Type: text/plain; charset="UTF-8"

Hi All,

Attached the patch to address the use-after-free issue.

Roonie,
Can you please review and help in validating the fix.

Regards,
Rohith

On Wed, May 19, 2021 at 11:08 AM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Wed, May 19, 2021 at 3:14 PM Rohith Surabattula
> <rohiths.msft@gmail.com> wrote:
> >
> > Hi Ronnie,
> >
> > Did you hit the issue with the latest for-next?
> > Do you have below patch in your code repo:
> > https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=e87dbd1cec70a32e670647f0bfb07e57cf974288
>
> Yes, I got it at for-next at  93a47dd8  which is one commit after that one.
> so current for-next
>
> It triggers for me a minute or two into running generic/013 against a
> win16 server.
>
>
> >
> > Regards,
> > Rohith
> >
> > On Wed, May 19, 2021 at 4:12 AM ronnie sahlberg
> > <ronniesahlberg@gmail.com> wrote:
> > >
> > > List, Rorith,
> > > I got a hit in KASAN for a use after free that looks like it is
> > > related to the recent deferred close patches. Can you please have a
> > > look?
> > >
> > > [  473.779989] run fstests generic/013 at 2021-05-19 08:27:00
> > > [  612.157429] ==================================================================
> > > [  612.158275] BUG: KASAN: use-after-free in process_one_work+0x90/0x9b0
> > > [  612.158801] Read of size 8 at addr ffff88810a31ca60 by task kworker/2:9/2382
> > >
> > > [  612.159611] CPU: 2 PID: 2382 Comm: kworker/2:9 Tainted: G
> > > OE     5.13.0-rc2+ #98
> > > [  612.159623] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> > > BIOS 1.14.0-1.fc33 04/01/2014
> > > [  612.159640] Workqueue:  0x0 (deferredclose)
> > > [  612.159669] Call Trace:
> > > [  612.159685]  dump_stack+0xbb/0x107
> > > [  612.159711]  print_address_description.constprop.0+0x18/0x140
> > > [  612.159733]  ? process_one_work+0x90/0x9b0
> > > [  612.159743]  ? process_one_work+0x90/0x9b0
> > > [  612.159754]  kasan_report.cold+0x7c/0xd8
> > > [  612.159778]  ? lock_is_held_type+0x80/0x130
> > > [  612.159789]  ? process_one_work+0x90/0x9b0
> > > [  612.159812]  kasan_check_range+0x145/0x1a0
> > > [  612.159834]  process_one_work+0x90/0x9b0
> > > [  612.159877]  ? pwq_dec_nr_in_flight+0x110/0x110
> > > [  612.159914]  ? spin_bug+0x90/0x90
> > > [  612.159967]  worker_thread+0x3b6/0x6c0
> > > [  612.160023]  ? process_one_work+0x9b0/0x9b0
> > > [  612.160038]  kthread+0x1dc/0x200
> > > [  612.160051]  ? kthread_create_worker_on_cpu+0xd0/0xd0
> > > [  612.160092]  ret_from_fork+0x1f/0x30
> > >
> > > [  612.160399] Allocated by task 2358:
> > > [  612.160757]  kasan_save_stack+0x1b/0x40
> > > [  612.160768]  __kasan_kmalloc+0x9b/0xd0
> > > [  612.160778]  cifs_new_fileinfo+0xb0/0x960 [cifs]
> > > [  612.161170]  cifs_open+0xadf/0xf20 [cifs]
> > > [  612.161421]  do_dentry_open+0x2aa/0x6b0
> > > [  612.161432]  path_openat+0xbd9/0xfa0
> > > [  612.161441]  do_filp_open+0x11d/0x230
> > > [  612.161450]  do_sys_openat2+0x115/0x240
> > > [  612.161460]  __x64_sys_openat+0xce/0x140
> > > [  612.161470]  do_syscall_64+0x3a/0x70
> > > [  612.161486]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > >
> > > [  612.161721] Freed by task 2382:
> > > [  612.162241]  kasan_save_stack+0x1b/0x40
> > > [  612.162253]  kasan_set_track+0x1c/0x30
> > > [  612.162263]  kasan_set_free_info+0x20/0x30
> > > [  612.162272]  __kasan_slab_free+0x108/0x150
> > > [  612.162282]  slab_free_freelist_hook+0xf9/0x2c0
> > > [  612.162294]  kfree+0xce/0x350
> > > [  612.162302]  _cifsFileInfo_put+0x42d/0x6a0 [cifs]
> > > [  612.162612]  process_one_work+0x4f2/0x9b0
> > > [  612.162622]  worker_thread+0x2d3/0x6c0
> > > [  612.162631]  kthread+0x1dc/0x200
> > > [  612.162639]  ret_from_fork+0x1f/0x30
> > >
> > > [  612.162989] Last potentially related work creation:
> > > [  612.163583]  kasan_save_stack+0x1b/0x40
> > > [  612.163594]  kasan_record_aux_stack+0xc1/0xd0
> > > [  612.163605]  insert_work+0x32/0x160
> > > [  612.163614]  __queue_work+0x35e/0x7e0
> > > [  612.163625]  mod_delayed_work_on+0x98/0x110
> > > [  612.163635]  cifs_close_all_deferred_files+0x8a/0xb0 [cifs]
> > > [  612.163888]  cifs_unlink+0x20c/0x780 [cifs]
> > > [  612.164149]  vfs_unlink+0x194/0x2e0
> > > [  612.164162]  do_unlinkat+0x28b/0x400
> > > [  612.164172]  do_syscall_64+0x3a/0x70
> > > [  612.164183]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > >
> > > [  612.164557] Second to last potentially related work creation:
> > > [  612.165183]  kasan_save_stack+0x1b/0x40
> > > [  612.165195]  kasan_record_aux_stack+0xc1/0xd0
> > > [  612.165205]  insert_work+0x32/0x160
> > > [  612.165215]  __queue_work+0x35e/0x7e0
> > > [  612.165225]  queue_delayed_work_on+0xa6/0xc0
> > > [  612.165235]  cifs_close+0x18d/0x270 [cifs]
> > > [  612.165486]  __fput+0x115/0x3d0
> > > [  612.165498]  task_work_run+0x85/0xc0
> > > [  612.165510]  exit_to_user_mode_prepare+0x1fd/0x200
> > > [  612.165520]  syscall_exit_to_user_mode+0x27/0x70
> > > [  612.165531]  do_syscall_64+0x47/0x70
> > > [  612.165542]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > >
> > > [  612.165921] The buggy address belongs to the object at ffff88810a31c800
> > >                 which belongs to the cache kmalloc-1k of size 1024
> > > [  612.167111] The buggy address is located 608 bytes inside of
> > >                 1024-byte region [ffff88810a31c800, ffff88810a31cc00)
> > > [  612.168215] The buggy address belongs to the page:
> > > [  612.168794] page:00000000d0b7a3cf refcount:1 mapcount:0
> > > mapping:0000000000000000 index:0x0 pfn:0x10a318
> > > [  612.168807] head:00000000d0b7a3cf order:3 compound_mapcount:0
> > > compound_pincount:0
> > > [  612.168815] memcg:ffff88810d800901
> > > [  612.168822] flags:
> > > 0x17ffe000010200(slab|head|node=0|zone=2|lastcpupid=0x3fff)
> > > [  612.168835] raw: 0017ffe000010200 dead000000000100 dead000000000122
> > > ffff888100042dc0
> > > [  612.168845] raw: 0000000000000000 0000000080100010 00000001ffffffff
> > > ffff88810d800901
> > > [  612.168852] page dumped because: kasan: bad access detected
> > >
> > > [  612.169163] Memory state around the buggy address:
> > > [  612.169605]  ffff88810a31c900: fb fb fb fb fb fb fb fb fb fb fb fb
> > > fb fb fb fb
> > > [  612.170243]  ffff88810a31c980: fb fb fb fb fb fb fb fb fb fb fb fb
> > > fb fb fb fb
> > > [  612.170930] >ffff88810a31ca00: fb fb fb fb fb fb fb fb fb fb fb fb
> > > fb fb fb fb
> > > [  612.171545]                                                        ^
> > > [  612.172068]  ffff88810a31ca80: fb fb fb fb fb fb fb fb fb fb fb fb
> > > fb fb fb fb
> > > [  612.172832]  ffff88810a31cb00: fb fb fb fb fb fb fb fb fb fb fb fb
> > > fb fb fb fb
> > > [  612.173683] ==================================================================
> > > [  612.174498] Disabling lock debugging due to kernel taint
> > >
> > >
> > > regards
> > > ronnie sahlberg

--0000000000002062b405c2c47964
Content-Type: application/octet-stream; 
	name="0001-Fix-KASAN-identified-use-after-free-issue.patch"
Content-Disposition: attachment; 
	filename="0001-Fix-KASAN-identified-use-after-free-issue.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kox1ci0m0>
X-Attachment-Id: f_kox1ci0m0

RnJvbSA1NjBmOGM1MWNlOGVkZDQ3OTQzYzlhY2E0ZjE4YjVkYmZkNWIxOWFkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0
LmNvbT4KRGF0ZTogVGh1LCAyMCBNYXkgMjAyMSAxNDozNjo1NyArMDAwMApTdWJqZWN0OiBbUEFU
Q0hdIEZpeCBLQVNBTiBpZGVudGlmaWVkIHVzZS1hZnRlci1mcmVlIGlzc3VlLgoKWyAgNjEyLjE1
NzQyOV0gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09ClsgIDYxMi4xNTgyNzVdIEJVRzogS0FTQU46IHVzZS1hZnRlci1mcmVl
IGluIHByb2Nlc3Nfb25lX3dvcmsrMHg5MC8weDliMApbICA2MTIuMTU4ODAxXSBSZWFkIG9mIHNp
emUgOCBhdCBhZGRyIGZmZmY4ODgxMGEzMWNhNjAgYnkgdGFzayBrd29ya2VyLzI6OS8yMzgyCgpb
ICA2MTIuMTU5NjExXSBDUFU6IDIgUElEOiAyMzgyIENvbW06IGt3b3JrZXIvMjo5IFRhaW50ZWQ6
IEcKT0UgICAgIDUuMTMuMC1yYzIrICM5OApbICA2MTIuMTU5NjIzXSBIYXJkd2FyZSBuYW1lOiBR
RU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwKQklPUyAxLjE0LjAtMS5mYzMz
IDA0LzAxLzIwMTQKWyAgNjEyLjE1OTY0MF0gV29ya3F1ZXVlOiAgMHgwIChkZWZlcnJlZGNsb3Nl
KQpbICA2MTIuMTU5NjY5XSBDYWxsIFRyYWNlOgpbICA2MTIuMTU5Njg1XSAgZHVtcF9zdGFjaysw
eGJiLzB4MTA3ClsgIDYxMi4xNTk3MTFdICBwcmludF9hZGRyZXNzX2Rlc2NyaXB0aW9uLmNvbnN0
cHJvcC4wKzB4MTgvMHgxNDAKWyAgNjEyLjE1OTczM10gID8gcHJvY2Vzc19vbmVfd29yaysweDkw
LzB4OWIwClsgIDYxMi4xNTk3NDNdICA/IHByb2Nlc3Nfb25lX3dvcmsrMHg5MC8weDliMApbICA2
MTIuMTU5NzU0XSAga2FzYW5fcmVwb3J0LmNvbGQrMHg3Yy8weGQ4ClsgIDYxMi4xNTk3NzhdICA/
IGxvY2tfaXNfaGVsZF90eXBlKzB4ODAvMHgxMzAKWyAgNjEyLjE1OTc4OV0gID8gcHJvY2Vzc19v
bmVfd29yaysweDkwLzB4OWIwClsgIDYxMi4xNTk4MTJdICBrYXNhbl9jaGVja19yYW5nZSsweDE0
NS8weDFhMApbICA2MTIuMTU5ODM0XSAgcHJvY2Vzc19vbmVfd29yaysweDkwLzB4OWIwClsgIDYx
Mi4xNTk4NzddICA/IHB3cV9kZWNfbnJfaW5fZmxpZ2h0KzB4MTEwLzB4MTEwClsgIDYxMi4xNTk5
MTRdICA/IHNwaW5fYnVnKzB4OTAvMHg5MApbICA2MTIuMTU5OTY3XSAgd29ya2VyX3RocmVhZCsw
eDNiNi8weDZjMApbICA2MTIuMTYwMDIzXSAgPyBwcm9jZXNzX29uZV93b3JrKzB4OWIwLzB4OWIw
ClsgIDYxMi4xNjAwMzhdICBrdGhyZWFkKzB4MWRjLzB4MjAwClsgIDYxMi4xNjAwNTFdICA/IGt0
aHJlYWRfY3JlYXRlX3dvcmtlcl9vbl9jcHUrMHhkMC8weGQwClsgIDYxMi4xNjAwOTJdICByZXRf
ZnJvbV9mb3JrKzB4MWYvMHgzMAoKWyAgNjEyLjE2MDM5OV0gQWxsb2NhdGVkIGJ5IHRhc2sgMjM1
ODoKWyAgNjEyLjE2MDc1N10gIGthc2FuX3NhdmVfc3RhY2srMHgxYi8weDQwClsgIDYxMi4xNjA3
NjhdICBfX2thc2FuX2ttYWxsb2MrMHg5Yi8weGQwClsgIDYxMi4xNjA3NzhdICBjaWZzX25ld19m
aWxlaW5mbysweGIwLzB4OTYwIFtjaWZzXQpbICA2MTIuMTYxMTcwXSAgY2lmc19vcGVuKzB4YWRm
LzB4ZjIwIFtjaWZzXQpbICA2MTIuMTYxNDIxXSAgZG9fZGVudHJ5X29wZW4rMHgyYWEvMHg2YjAK
WyAgNjEyLjE2MTQzMl0gIHBhdGhfb3BlbmF0KzB4YmQ5LzB4ZmEwClsgIDYxMi4xNjE0NDFdICBk
b19maWxwX29wZW4rMHgxMWQvMHgyMzAKWyAgNjEyLjE2MTQ1MF0gIGRvX3N5c19vcGVuYXQyKzB4
MTE1LzB4MjQwClsgIDYxMi4xNjE0NjBdICBfX3g2NF9zeXNfb3BlbmF0KzB4Y2UvMHgxNDAKCldo
ZW4gbW9kX2RlbGF5ZWRfd29yayBpcyBjYWxsZWQgdG8gbW9kaWZ5IHRoZSBkZWxheSBvZiBwZW5k
aW5nIHdvcmssCml0IG1pZ2h0IHJldHVybiBmYWxzZSBhbmQgcXVldWUgYSBuZXcgd29yayB3aGVu
IHBlbmRpbmcgd29yayBpcwphbHJlYWR5IHNjaGVkdWxlZCBvciB3aGVuIHRyeSB0byBncmFiIHBl
bmRpbmcgd29yayBmYWlsZWQuCgpTbywgSW5jcmVhc2UgdGhlIHJlZmVyZW5jZSBjb3VudCB3aGVu
IG5ldyB3b3JrIGlzIHNjaGVkdWxlZCB0bwphdm9pZCB1c2UtYWZ0ZXItZnJlZS4KClNpZ25lZC1v
ZmYtYnk6IFJvaGl0aCBTdXJhYmF0dHVsYSA8cm9oaXRoc0BtaWNyb3NvZnQuY29tPgotLS0KIGZz
L2NpZnMvZmlsZS5jIHwgMjAgKysrKysrKysrKysrKy0tLS0tLS0KIGZzL2NpZnMvbWlzYy5jIHwg
MTIgKysrKysrKysrKy0tCiAyIGZpbGVzIGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKyksIDkgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9maWxlLmMgYi9mcy9jaWZzL2ZpbGUuYwpp
bmRleCA0Y2ZhMjJjZmJjOTAuLjM2ZWUwMWNiZjNhMCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9maWxl
LmMKKysrIGIvZnMvY2lmcy9maWxlLmMKQEAgLTg3NCwxMCArODc0LDYgQEAgdm9pZCBzbWIyX2Rl
ZmVycmVkX3dvcmtfY2xvc2Uoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogCQkJc3RydWN0IGNp
ZnNGaWxlSW5mbywgZGVmZXJyZWQud29yayk7CiAKIAlzcGluX2xvY2soJkNJRlNfSShkX2lub2Rl
KGNmaWxlLT5kZW50cnkpKS0+ZGVmZXJyZWRfbG9jayk7Ci0JaWYgKCFjZmlsZS0+ZGVmZXJyZWRf
Y2xvc2Vfc2NoZWR1bGVkKSB7Ci0JCXNwaW5fdW5sb2NrKCZDSUZTX0koZF9pbm9kZShjZmlsZS0+
ZGVudHJ5KSktPmRlZmVycmVkX2xvY2spOwotCQlyZXR1cm47Ci0JfQogCWNpZnNfZGVsX2RlZmVy
cmVkX2Nsb3NlKGNmaWxlKTsKIAljZmlsZS0+ZGVmZXJyZWRfY2xvc2Vfc2NoZWR1bGVkID0gZmFs
c2U7CiAJc3Bpbl91bmxvY2soJkNJRlNfSShkX2lub2RlKGNmaWxlLT5kZW50cnkpKS0+ZGVmZXJy
ZWRfbG9jayk7CkBAIC05MDQsOCArOTAwLDEzIEBAIGludCBjaWZzX2Nsb3NlKHN0cnVjdCBpbm9k
ZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKQogCQkJY2lmc19hZGRfZGVmZXJyZWRfY2xvc2Uo
Y2ZpbGUsIGRjbG9zZSk7CiAJCQlpZiAoY2ZpbGUtPmRlZmVycmVkX2Nsb3NlX3NjaGVkdWxlZCAm
JgogCQkJICAgIGRlbGF5ZWRfd29ya19wZW5kaW5nKCZjZmlsZS0+ZGVmZXJyZWQpKSB7Ci0JCQkJ
bW9kX2RlbGF5ZWRfd29yayhkZWZlcnJlZGNsb3NlX3dxLAotCQkJCQkJJmNmaWxlLT5kZWZlcnJl
ZCwgY2lmc19zYi0+Y3R4LT5hY3JlZ21heCk7CisJCQkJLyoKKwkJCQkgKiBJZiB0aGVyZSBpcyBu
byBwZW5kaW5nIHdvcmssIG1vZF9kZWxheWVkX3dvcmsgcXVldWVzIG5ldyB3b3JrLgorCQkJCSAq
IFNvLCBJbmNyZWFzZSB0aGUgcmVmIGNvdW50IHRvIGF2b2lkIHVzZS1hZnRlci1mcmVlLgorCQkJ
CSAqLworCQkJCWlmICghbW9kX2RlbGF5ZWRfd29yayhkZWZlcnJlZGNsb3NlX3dxLAorCQkJCQkJ
JmNmaWxlLT5kZWZlcnJlZCwgY2lmc19zYi0+Y3R4LT5hY3JlZ21heCkpCisJCQkJCWNpZnNGaWxl
SW5mb19nZXQoY2ZpbGUpOwogCQkJfSBlbHNlIHsKIAkJCQkvKiBEZWZlcnJlZCBjbG9zZSBmb3Ig
ZmlsZXMgKi8KIAkJCQlxdWV1ZV9kZWxheWVkX3dvcmsoZGVmZXJyZWRjbG9zZV93cSwKQEAgLTQ4
NzksNyArNDg4MCwxMiBAQCB2b2lkIGNpZnNfb3Bsb2NrX2JyZWFrKHN0cnVjdCB3b3JrX3N0cnVj
dCAqd29yaykKIAlpZiAoaXNfZGVmZXJyZWQgJiYKIAkgICAgY2ZpbGUtPmRlZmVycmVkX2Nsb3Nl
X3NjaGVkdWxlZCAmJgogCSAgICBkZWxheWVkX3dvcmtfcGVuZGluZygmY2ZpbGUtPmRlZmVycmVk
KSkgewotCQltb2RfZGVsYXllZF93b3JrKGRlZmVycmVkY2xvc2Vfd3EsICZjZmlsZS0+ZGVmZXJy
ZWQsIDApOworCQkvKgorCQkgKiBJZiB0aGVyZSBpcyBubyBwZW5kaW5nIHdvcmssIG1vZF9kZWxh
eWVkX3dvcmsgcXVldWVzIG5ldyB3b3JrLgorCQkgKiBTbywgSW5jcmVhc2UgdGhlIHJlZiBjb3Vu
dCB0byBhdm9pZCB1c2UtYWZ0ZXItZnJlZS4KKwkJICovCisJCWlmICghbW9kX2RlbGF5ZWRfd29y
ayhkZWZlcnJlZGNsb3NlX3dxLCAmY2ZpbGUtPmRlZmVycmVkLCAwKSkKKwkJCWNpZnNGaWxlSW5m
b19nZXQoY2ZpbGUpOwogCX0KIAlzcGluX3VubG9jaygmQ0lGU19JKGlub2RlKS0+ZGVmZXJyZWRf
bG9jayk7CiAJX2NpZnNGaWxlSW5mb19wdXQoY2ZpbGUsIGZhbHNlIC8qIGRvIG5vdCB3YWl0IGZv
ciBvdXJzZWxmICovLCBmYWxzZSk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL21pc2MuYyBiL2ZzL2Np
ZnMvbWlzYy5jCmluZGV4IGNkNzA1ZjhhNGUzMS4uN2NkNmMyMTY0YzY4IDEwMDY0NAotLS0gYS9m
cy9jaWZzL21pc2MuYworKysgYi9mcy9jaWZzL21pc2MuYwpAQCAtNjc0LDYgKzY3NCw4IEBAIGNp
ZnNfYWRkX3BlbmRpbmdfb3BlbihzdHJ1Y3QgY2lmc19maWQgKmZpZCwgc3RydWN0IHRjb25fbGlu
ayAqdGxpbmssCiAKIC8qCiAgKiBDcml0aWNhbCBzZWN0aW9uIHdoaWNoIHJ1bnMgYWZ0ZXIgYWNx
dWlyaW5nIGRlZmVycmVkX2xvY2suCisgKiBBcyB0aGVyZSBpcyBubyByZWZlcmVuY2UgY291bnQg
b24gY2lmc19kZWZlcnJlZF9jbG9zZSwgcGRjbG9zZQorICogc2hvdWxkIG5vdCBiZSB1c2VkIG91
dHNpZGUgZGVmZXJyZWRfbG9jay4KICAqLwogYm9vbAogY2lmc19pc19kZWZlcnJlZF9jbG9zZShz
dHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZSwgc3RydWN0IGNpZnNfZGVmZXJyZWRfY2xvc2UgKipw
ZGNsb3NlKQpAQCAtNzU0LDggKzc1NiwxNCBAQCBjaWZzX2Nsb3NlX2FsbF9kZWZlcnJlZF9maWxl
cyhzdHJ1Y3QgY2lmc190Y29uICp0Y29uKQogCWxpc3RfZm9yX2VhY2godG1wLCAmdGNvbi0+b3Bl
bkZpbGVMaXN0KSB7CiAJCWNmaWxlID0gbGlzdF9lbnRyeSh0bXAsIHN0cnVjdCBjaWZzRmlsZUlu
Zm8sIHRsaXN0KTsKIAkJY2lub2RlID0gQ0lGU19JKGRfaW5vZGUoY2ZpbGUtPmRlbnRyeSkpOwot
CQlpZiAoZGVsYXllZF93b3JrX3BlbmRpbmcoJmNmaWxlLT5kZWZlcnJlZCkpCi0JCQltb2RfZGVs
YXllZF93b3JrKGRlZmVycmVkY2xvc2Vfd3EsICZjZmlsZS0+ZGVmZXJyZWQsIDApOworCQlpZiAo
ZGVsYXllZF93b3JrX3BlbmRpbmcoJmNmaWxlLT5kZWZlcnJlZCkpIHsKKwkJCS8qCisJCQkgKiBJ
ZiB0aGVyZSBpcyBubyBwZW5kaW5nIHdvcmssIG1vZF9kZWxheWVkX3dvcmsgcXVldWVzIG5ldyB3
b3JrLgorCQkJICogU28sIEluY3JlYXNlIHRoZSByZWYgY291bnQgdG8gYXZvaWQgdXNlLWFmdGVy
LWZyZWUuCisJCQkgKi8KKwkJCWlmICghbW9kX2RlbGF5ZWRfd29yayhkZWZlcnJlZGNsb3NlX3dx
LCAmY2ZpbGUtPmRlZmVycmVkLCAwKSkKKwkJCQljaWZzRmlsZUluZm9fZ2V0KGNmaWxlKTsKKwkJ
fQogCX0KIAlzcGluX3VubG9jaygmdGNvbi0+b3Blbl9maWxlX2xvY2spOwogfQotLSAKMi4zMC4y
Cgo=
--0000000000002062b405c2c47964--
