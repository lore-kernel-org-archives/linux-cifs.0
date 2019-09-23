Return-Path: <SRS0=Y4Lp=XS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 186AAC3A5A6
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Sep 2019 06:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA8E02087C
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Sep 2019 06:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbfIWGry (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Sep 2019 02:47:54 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:59494 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729354AbfIWGry (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 23 Sep 2019 02:47:54 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 64FAA9EBD3EA4E99FF47
        for <linux-cifs@vger.kernel.org>; Mon, 23 Sep 2019 14:47:52 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Mon, 23 Sep 2019
 14:47:44 +0800
Subject: Re: [PATCH] fs/cifs/smb2transport.c: Make some functions static
To:     Steve French <smfrench@gmail.com>
CC:     "zhangyi (F)" <yi.zhang@huawei.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <1569046966-118677-1-git-send-email-zhengbin13@huawei.com>
 <CAH2r5mu+ytpDOcq4Au2AZe7M00p3XJnBVD2wO949G7Ud5bp=dQ@mail.gmail.com>
 <65f0ed75-045d-6b07-609c-a23d747d99f3@huawei.com>
 <CAH2r5mtfEnA-E0xLi+C1PvaFOFbByT_UHjRO_CS4MbKpZipnkA@mail.gmail.com>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Message-ID: <6de8d563-b6eb-7ee3-291a-2b98ab1aaf14@huawei.com>
Date:   Mon, 23 Sep 2019 14:47:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <CAH2r5mtfEnA-E0xLi+C1PvaFOFbByT_UHjRO_CS4MbKpZipnkA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


On 2019/9/23 14:33, Steve French wrote:
> The code to call SMB2_change_notify (from an ioctl) should make it in
> pretty soon (let's hope we can finish testing it this  week).   The
> fix to inotify to allow inotify to call into a network file system
> will be helpful in the long run, but in the short term at least a GUI
> should be able to call into a cifs.ko specific ioctl soon for it.
Thus SMB2_notify_init should be static? I send a patch later?
>
> On Mon, Sep 23, 2019 at 1:08 AM zhengbin (A) <zhengbin13@huawei.com> wrote:
>>
>> On 2019/9/23 13:07, Steve French wrote:
>>> Thanks - merged into cifs-2.6.git for-next
>>>
>>> Aurélien -
>>> FYI - it makes minor update to code you changed to remove the warning.
>> We have a similar warning in fs/cifs/smb2pdu.c
>>
>> fs/cifs/smb2pdu.c:3184:1: warning: symbol 'SMB2_notify_init' was not declared. Should it be static?
>> fs/cifs/smb2pdu.c:3213:1: warning: symbol 'SMB2_change_notify' was not declared. Should it be static?
>>
>>
>> while these two functions are introduced by commit af8d46ab49b8
>>
>> ("smb3: add missing worker function for SMB3 change notify"). SMB2_notify_init is called by SMB2_change_notify
>>
>> No one calls  SMB2_change_notify? Or we will call SMB2_change_notify in the future?
>>
>>>
>>> On Sun, Sep 22, 2019 at 2:13 PM zhengbin <zhengbin13@huawei.com> wrote:
>>>> Fix sparse warnings:
>>>>
>>>> fs/cifs/smb2transport.c:52:1: warning: symbol 'smb3_crypto_shash_allocate' was not declared. Should it be static?
>>>> fs/cifs/smb2transport.c:101:4: warning: symbol 'smb2_find_chan_signkey' was not declared. Should it be static?
>>>> fs/cifs/smb2transport.c:121:17: warning: symbol 'smb2_find_global_smb_ses' was not declared. Should it be static?
>>>>
>>>> Reported-by: Hulk Robot <hulkci@huawei.com>
>>>> Signed-off-by: zhengbin <zhengbin13@huawei.com>
>>>> ---
>>>>  fs/cifs/smb2transport.c | 7 ++++---
>>>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
>>>> index 12988df..7cc8641 100644
>>>> --- a/fs/cifs/smb2transport.c
>>>> +++ b/fs/cifs/smb2transport.c
>>>> @@ -48,7 +48,7 @@ smb2_crypto_shash_allocate(struct TCP_Server_Info *server)
>>>>                                &server->secmech.sdeschmacsha256);
>>>>  }
>>>>
>>>> -int
>>>> +static int
>>>>  smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
>>>>  {
>>>>         struct cifs_secmech *p = &server->secmech;
>>>> @@ -98,7 +98,8 @@ smb311_crypto_shash_allocate(struct TCP_Server_Info *server)
>>>>         return rc;
>>>>  }
>>>>
>>>> -u8 *smb2_find_chan_signkey(struct cifs_ses *ses, struct TCP_Server_Info *server)
>>>> +static u8 *
>>>> +smb2_find_chan_signkey(struct cifs_ses *ses, struct TCP_Server_Info *server)
>>>>  {
>>>>         int i;
>>>>         struct cifs_chan *chan;
>>>> @@ -118,7 +119,7 @@ u8 *smb2_find_chan_signkey(struct cifs_ses *ses, struct TCP_Server_Info *server)
>>>>         return NULL;
>>>>  }
>>>>
>>>> -struct cifs_ses *
>>>> +static struct cifs_ses *
>>>>  smb2_find_global_smb_ses(__u64 ses_id)
>>>>  {
>>>>         struct TCP_Server_Info *server;
>>>> --
>>>> 2.7.4
>>>>
>

