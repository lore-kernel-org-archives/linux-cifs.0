Return-Path: <SRS0=8TPy=V5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93019C19759
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 14:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52DE220838
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 14:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730502AbfHAOGh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Aug 2019 10:06:37 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55974 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727970AbfHAOGh (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 1 Aug 2019 10:06:37 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B5EEAEA3047BCB30CD54;
        Thu,  1 Aug 2019 22:06:34 +0800 (CST)
Received: from [127.0.0.1] (10.184.225.177) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 1 Aug 2019
 22:06:24 +0800
Subject: Re: [PATCH cifs-utils] mount.cifs.c: fix memory leaks in main func
To:     =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>,
        <smfrench@gmail.com>, <liujiawen10@huawei.com>,
        <pshilov@microsoft.com>, <kdsouza@redhat.com>,
        <lsahlber@redhat.com>, <ab@samba.org>, <palcantara@suse.de>,
        <linux-cifs@vger.kernel.org>
CC:     <dujin1@huawei.com>, Mingfangsen <mingfangsen@huawei.com>,
        zhangsaisai <zhangsaisai@huawei.com>
References: <d4bf65ab-42e1-606c-be35-a5cb3b7b77b0@huawei.com>
 <87h871s0ty.fsf@suse.com>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <8d637a82-5387-6dc1-caef-0fbc6554e6bc@huawei.com>
Date:   Thu, 1 Aug 2019 22:06:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <87h871s0ty.fsf@suse.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.184.225.177]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2019/8/1 17:15, Aurélien Aptel wrote:
> Hi Zhiqiang,
> 
> You are on the right list :)
> 
> Unfortunately it seems you have sent the exact same patch as before so
> I'll post my comments again:
> 
Thanks for your reply.
I have just missed your mail with comments. Sorry for that.
I will modify the patch as your suggestion, then post the v2 patch.

> Zhiqiang Liu <liuzhiqiang26@huawei.com> writes:
>> index ae7a899..029f01a 100644
>> --- a/mount.cifs.c
>> +++ b/mount.cifs.c
>> @@ -1830,6 +1830,7 @@ assemble_mountinfo(struct parsed_mount_info *parsed_info,
>>  	}
>>
>>  assemble_exit:
>> +	free(orgoptions);
>>  	return rc;
>>  }
> 
> Since orgoptions is allocated in main() you should also free it
> there. In fact it is already freed there so the return have to be
> changed to goto.
> 
>>
>> @@ -1994,8 +1995,11 @@ int main(int argc, char **argv)
>>
>>  	/* chdir into mountpoint as soon as possible */
>>  	rc = acquire_mountpoint(&mountpoint);
>> -	if (rc)
>> +	if (rc) {
>> +		free(mountpoint);
>> +		free(orgoptions);
>>  		return rc;
>> +	}
> 
> Since mountpoint is allocated in acquire_mountpoint() you should free it
> there if there's an error.
> 
>>  	/*
>>  	 * mount.cifs does privilege separation. Most of the code to handle
>> @@ -2014,6 +2018,7 @@ int main(int argc, char **argv)
>>  		/* child */
>>  		rc = assemble_mountinfo(parsed_info, thisprogram, mountpoint,
>>  					orig_dev, orgoptions);
>> +		free(mountpoint);
> 
> Since this code block is only run by the child I think it's ok to not
> use goto. Don't forget to free(orgoptions) if you remove it from
> assemble_mountinfo()
> 
>>  		return rc;
>>  	} else {
>>  		/* parent */
>> @@ -2149,5 +2154,6 @@ mount_exit:
>>  	}
>>  	free(options);
>>  	free(orgoptions);
>> +	free(mountpoint);
> 
> Cheers,
> 

