Return-Path: <SRS0=8vOf=5E=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 904DCC4332B
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Mar 2020 02:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E39A20768
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Mar 2020 02:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgCSCud (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Mar 2020 22:50:33 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12095 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726623AbgCSCud (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 18 Mar 2020 22:50:33 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 16C7F1CEF2A32EFF00FD;
        Thu, 19 Mar 2020 10:50:27 +0800 (CST)
Received: from [127.0.0.1] (10.173.223.48) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 19 Mar 2020
 10:50:17 +0800
Subject: Re: [PATCH] CIFS: Fix bug which the return value by asynchronous read
 is error
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
CC:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, <alex.chen@huawei.com>
References: <ef49e240-fc8f-9eb4-af98-26bfd39104aa@huawei.com>
 <CAN05THQYxPcsgiHTqMcsTgB6ZDYaBMamu-sOe428H7EwSRU2HQ@mail.gmail.com>
From:   Yilu Lin <linyilu@huawei.com>
Message-ID: <90d04a37-2d4b-dcac-4b48-c6bb4200db20@huawei.com>
Date:   Thu, 19 Mar 2020 10:50:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAN05THQYxPcsgiHTqMcsTgB6ZDYaBMamu-sOe428H7EwSRU2HQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.223.48]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,
The bug is trigerred by the following test program.
First, run the command to create one file on the share directory。COMMAND：dd if=/dev/zero of=/home/temp/cifs/sys.zero bs=512 count=1000 oflag=direct
And then run the c program by the command: ./pread /home/temp/cifs/sys.zero
The program will return "pread -22 bytes".However, the expected result is "pread -1 bytes".

C program code is showed below:

    #include<stdio.h>
    #include<stdlib.h>
    #include<unistd.h>
    #include <sys/types.h>
    #include <sys/stat.h>
    #define __USE_GNU 1
    #include <fcntl.h>
    int main(int argc, char *argv[])
    {
            int fd;
            ssize_t len;
            int ret;
            int size = 512;
            char *file=argv[1];

            unsigned char *buf2;
            ret = posix_memalign((void **)&buf2, 512, size);
            if (ret) {
                    printf("malloc err!\n");
                    return 0;
            }

            fd = open(file, O_RDWR | O_DIRECT);
            if(fd == -1) {
                    printf("open error!\n");
                    free(buf2);
                    return 0;
            }

            len = pread(fd, buf2, 504, 511992);
            printf("pread %d bytes\n", len);
            free(buf2);
            close(fd);
            return 0;
    }

regards
Yilu Lin

在 2020/3/18 12:47, ronnie sahlberg 写道:
> Hi Yilu,
> 
> I think your reasoning makes sense.
> Do you have a small reproducer for this? A small C program that triggers this?
> 
> I am asking because if you do we would like to add it to our buildbot
> to make  sure we don't get regressions.
> 
> 
> regards
> ronnie sahlberg
> 
> On Wed, Mar 18, 2020 at 1:59 PM Yilu Lin <linyilu@huawei.com> wrote:
>>
>> This patch is used to fix the bug in collect_uncached_read_data()
>> that rc is automatically converted from a signed number to an
>> unsigned number when the CIFS asynchronous read fails.
>> It will cause ctx->rc is error.
>>
>> Example:
>> Share a directory and create a file on the Windows OS.
>> Mount the directory to the Linux OS using CIFS.
>> On the CIFS client of the Linux OS, invoke the pread interface to
>> deliver the read request.
>>
>> The size of the read length plus offset of the read request is greater
>> than the maximum file size.
>>
>> In this case, the CIFS server on the Windows OS returns a failure
>> message (for example, the return value of
>> smb2.nt_status is STATUS_INVALID_PARAMETER).
>>
>> After receiving the response message, the CIFS client parses
>> smb2.nt_status to STATUS_INVALID_PARAMETER
>> and converts it to the Linux error code (rdata->result=-22).
>>
>> Then the CIFS client invokes the collect_uncached_read_data function to
>> assign the value of rdata->result to rc, that is, rc=rdata->result=-22.
>>
>> The type of the ctx->total_len variable is unsigned integer,
>> the type of the rc variable is integer, and the type of
>> the ctx->rc variable is ssize_t.
>>
>> Therefore, during the ternary operation, the value of rc is
>> automatically converted to an unsigned number. The final result is
>> ctx->rc=4294967274. However, the expected result is ctx->rc=-22.
>>
>> Signed-off-by: Yilu Lin <linyilu@huawei.com>
>> ---
>>  fs/cifs/file.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 022029a5d..ff4ac244c 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -3323,7 +3323,7 @@ again:
>>         if (rc == -ENODATA)
>>                 rc = 0;
>>
>> -       ctx->rc = (rc == 0) ? ctx->total_len : rc;
>> +       ctx->rc = (rc == 0) ? (ssize_t)ctx->total_len : rc;
>>
>>         mutex_unlock(&ctx->aio_mutex);
>>
>> --
>> 2.19.1
>>
>>
> 
> .
> 

