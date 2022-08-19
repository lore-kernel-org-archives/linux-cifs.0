Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3456EC00140
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Aug 2022 01:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238882AbiHSBYh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Aug 2022 21:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiHSBYg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Aug 2022 21:24:36 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0079816AD
        for <linux-cifs@vger.kernel.org>; Thu, 18 Aug 2022 18:24:33 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4M83sY1mp0zGpdp;
        Fri, 19 Aug 2022 09:22:57 +0800 (CST)
Received: from [10.174.176.83] (10.174.176.83) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 19 Aug 2022 09:24:31 +0800
Subject: Re: [PATCH] cifs: Fix memory leak on the deferred close
To:     Steve French <smfrench@gmail.com>
CC:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>, <rohiths@microsoft.com>
References: <20220818135044.2251342-1-zhangxiaoxu5@huawei.com>
 <CAH2r5muzC3oSXKBO=p8b5e_MFTvLhitZrcMeqocyBZfidRd+fQ@mail.gmail.com>
From:   "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
Message-ID: <489b6c7f-0290-9eb7-621e-45e785b3f5b9@huawei.com>
Date:   Fri, 19 Aug 2022 09:24:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5muzC3oSXKBO=p8b5e_MFTvLhitZrcMeqocyBZfidRd+fQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.83]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

running generic/029 and scan kmemleak on backend report this issue.

在 2022/8/19 0:28, Steve French 写道:
> looks promising - am reviewing this now.  Which xfstest did you see
> this when runnign?
> 
> On Thu, Aug 18, 2022 at 8:01 AM Zhang Xiaoxu <zhangxiaoxu5@huawei.com> wrote:
>>
>> xfstests on smb21 report kmemleak as below:
>>
>>    unreferenced object 0xffff8881767d6200 (size 64):
>>      comm "xfs_io", pid 1284, jiffies 4294777434 (age 20.789s)
>>      hex dump (first 32 bytes):
>>        80 5a d0 11 81 88 ff ff 78 8a aa 63 81 88 ff ff  .Z......x..c....
>>        00 71 99 76 81 88 ff ff 00 00 00 00 00 00 00 00  .q.v............
>>      backtrace:
>>        [<00000000ad04e6ea>] cifs_close+0x92/0x2c0
>>        [<0000000028b93c82>] __fput+0xff/0x3f0
>>        [<00000000d8116851>] task_work_run+0x85/0xc0
>>        [<0000000027e14f9e>] do_exit+0x5e5/0x1240
>>        [<00000000fb492b95>] do_group_exit+0x58/0xe0
>>        [<00000000129a32d9>] __x64_sys_exit_group+0x28/0x30
>>        [<00000000e3f7d8e9>] do_syscall_64+0x35/0x80
>>        [<00000000102e8a0b>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>
>> When cancel the deferred close work, we should also cleanup the struct
>> cifs_deferred_close.
>>
>> Fixes: 9e992755be8f2 ("cifs: Call close synchronously during unlink/rename/lease break.")
>> Fixes: e3fc065682ebb ("cifs: Deferred close performance improvements")
>> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>> ---
>>   fs/cifs/misc.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
>> index 1f2628ffe9d7..87f60f736731 100644
>> --- a/fs/cifs/misc.c
>> +++ b/fs/cifs/misc.c
>> @@ -737,6 +737,8 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
>>          list_for_each_entry(cfile, &cifs_inode->openFileList, flist) {
>>                  if (delayed_work_pending(&cfile->deferred)) {
>>                          if (cancel_delayed_work(&cfile->deferred)) {
>> +                               cifs_del_deferred_close(cfile);
>> +
>>                                  tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
>>                                  if (tmp_list == NULL)
>>                                          break;
>> @@ -766,6 +768,8 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
>>          list_for_each_entry(cfile, &tcon->openFileList, tlist) {
>>                  if (delayed_work_pending(&cfile->deferred)) {
>>                          if (cancel_delayed_work(&cfile->deferred)) {
>> +                               cifs_del_deferred_close(cfile);
>> +
>>                                  tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
>>                                  if (tmp_list == NULL)
>>                                          break;
>> @@ -799,6 +803,8 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
>>                  if (strstr(full_path, path)) {
>>                          if (delayed_work_pending(&cfile->deferred)) {
>>                                  if (cancel_delayed_work(&cfile->deferred)) {
>> +                                       cifs_del_deferred_close(cfile);
>> +
>>                                          tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
>>                                          if (tmp_list == NULL)
>>                                                  break;
>> --
>> 2.31.1
>>
> 
> 
