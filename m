Return-Path: <SRS0=GDvn=WE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50AB9C433FF
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Aug 2019 01:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26171217D7
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Aug 2019 01:07:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730467AbfHHBHG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Aug 2019 21:07:06 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48936 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730382AbfHHBHG (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 7 Aug 2019 21:07:06 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C2742F747B5D7417ADBB;
        Thu,  8 Aug 2019 09:07:03 +0800 (CST)
Received: from [127.0.0.1] (10.184.225.177) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 8 Aug 2019
 09:06:24 +0800
Subject: Re: [PATCH cifs-utils v2] mount.cifs.c: fix memory leaks in main func
To:     Pavel Shilovsky <piastryyy@gmail.com>
CC:     linux-cifs <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>,
        <liujiawen10@huawei.com>, Steve French <smfrench@gmail.com>,
        Pavel Shilovskiy <pshilov@microsoft.com>,
        "Ronnie Sahlberg" <lsahlber@redhat.com>,
        Kenneth Dsouza <kdsouza@redhat.com>,
        Alexander Bokovoy <ab@samba.org>,
        Paulo Alcantara <palcantara@suse.de>, <dujin1@huawei.com>,
        Mingfangsen <mingfangsen@huawei.com>,
        zhangsaisai <zhangsaisai@huawei.com>
References: <0f780b18-0b1c-e2ff-31b1-1d697becd142@huawei.com>
 <CAKywueT6C=O-1tosijf5vm5pg0YozMeEiKP56=unv370L=zzRQ@mail.gmail.com>
 <CAKywueTfnmsZm7scQmDhews_g2TwYw0NRYCstaYnSb_zE91oUA@mail.gmail.com>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <00c2da18-fe7e-5f86-000c-730a27f3b32c@huawei.com>
Date:   Thu, 8 Aug 2019 09:06:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CAKywueTfnmsZm7scQmDhews_g2TwYw0NRYCstaYnSb_zE91oUA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.184.225.177]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2019/8/8 5:44, Pavel Shilovsky wrote:
> Merged into "next" with one minor change - removed a trailing white
> space. Thanks.
> 
That is ok. Thank you very much.

> --
> Best regards,
> Pavel Shilovsky
> 
> вт, 6 авг. 2019 г. в 09:49, Pavel Shilovsky <piastryyy@gmail.com>:
> 
>>
>> пн, 5 авг. 2019 г. в 19:36, Zhiqiang Liu <liuzhiqiang26@huawei.com>:
>>>
>>> From: Jiawen Liu <liujiawen10@huawei.com>
>>>
>>> In mount.cifs module, orgoptions and mountpoint in the main func
>>> point to the memory allocated by func realpath and strndup respectively.
>>> However, they are not freed before the main func returns so that the
>>> memory leaks occurred.
>>>
>>> The memory leak problem is reported by LeakSanitizer tool.
>>> LeakSanitizer url: "https://github.com/google/sanitizers"
>>>
>>> Here I free the pointers orgoptions and mountpoint before main
>>> func returns.
>>>
>>> Fixes：7549ad5e7126 ("memory leaks: caused by func realpath and strndup")
>>> Signed-off-by: Jiawen Liu <liujiawen10@huawei.com>
>>> Reported-by: Jin Du <dujin1@huawei.com>
>>> Reviewed-by: Saisai Zhang <zhangsaisai@huawei.com>
>>> Reviewed-by: Aurélien Aptel <aaptel@suse.com>
>>> ---
>>> v1->v2:
>>> - free orgoptions in main func as suggested by Aurélien Aptel
>>> - free mountpoint in acquire_mountpoint func as suggested by Aurélien Aptel
>>>
>>>  mount.cifs.c | 12 ++++++++++--
>>>  1 file changed, 10 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mount.cifs.c b/mount.cifs.c
>>> index ae7a899..656d353 100644
>>> --- a/mount.cifs.c
>>> +++ b/mount.cifs.c
>>> @@ -1891,7 +1891,10 @@ restore_privs:
>>>                 uid_t __attribute__((unused)) uignore = setfsuid(oldfsuid);
>>>                 gid_t __attribute__((unused)) gignore = setfsgid(oldfsgid);
>>>         }
>>> -
>>> +
>>> +       if (rc) {
>>> +               free(*mountpointp);
>>> +       }
>>>         return rc;
>>>  }
>>>
>>> @@ -1994,8 +1997,10 @@ int main(int argc, char **argv)
>>>
>>>         /* chdir into mountpoint as soon as possible */
>>>         rc = acquire_mountpoint(&mountpoint);
>>> -       if (rc)
>>> +       if (rc) {
>>> +               free(orgoptions);
>>>                 return rc;
>>> +       }
>>>
>>>         /*
>>>          * mount.cifs does privilege separation. Most of the code to handle
>>> @@ -2014,6 +2019,8 @@ int main(int argc, char **argv)
>>>                 /* child */
>>>                 rc = assemble_mountinfo(parsed_info, thisprogram, mountpoint,
>>>                                         orig_dev, orgoptions);
>>> +               free(orgoptions);
>>> +               free(mountpoint);
>>>                 return rc;
>>>         } else {
>>>                 /* parent */
>>> @@ -2149,5 +2156,6 @@ mount_exit:
>>>         }
>>>         free(options);
>>>         free(orgoptions);
>>> +       free(mountpoint);
>>>         return rc;
>>>  }
>>> --
>>> 2.7.4
>>>
>>
>> Thanks for the patch! I will apply it to my github tree shortly.
>>
>> --
>> Best regards,
>> Pavel Shilovsky
> 
> .
> 

