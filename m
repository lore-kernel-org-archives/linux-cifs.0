Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77244C433ED
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 21:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B5BF601FA
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 21:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbhDAVEO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Apr 2021 17:04:14 -0400
Received: from p3plsmtpa11-08.prod.phx3.secureserver.net ([68.178.252.109]:34673
        "EHLO p3plsmtpa11-08.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233981AbhDAVEO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Apr 2021 17:04:14 -0400
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id S4U2lEyTI8I0QS4U4l1juh; Thu, 01 Apr 2021 14:04:14 -0700
X-CMAE-Analysis: v=2.4 cv=SeEyytdu c=1 sm=1 tr=0 ts=6066354e
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=hGzw-44bAAAA:8 a=DWtuyDPq4Y-VP7XYPBwA:9 a=QEXdDO2ut3YA:10
 a=HvKuF1_PTVFglORKqfwH:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [Linux-cifsd-devel] [PATCH] cifsd: use kfree to free memory
 allocated by kzalloc
To:     Namjae Jeon <linkinjeon@kernel.org>, Ralph Boehme <slow@samba.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifs@vger.kernel.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>,
        kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>, colin.king@canonical.com,
        Muhammad Usama Anjum <musamaanjum@gmail.com>
References: <20210401113933.GA2828895@LEGION> <20210401115008.GS2088@kadam>
 <CAKYAXd-ou4-jf7_8xa4jDQ_otyQ9ffKhwD7WZrmrna1P3b_W8Q@mail.gmail.com>
 <ca1b9b0c-55f9-025d-558b-1b2b6c866d12@samba.org>
 <CAKYAXd-ScM9i9Ln_FL8pWyEnPO_0n8t1BLH8MJ=b4NkqEbhZ=Q@mail.gmail.com>
 <2b758812-f00b-9465-c24e-763912748809@samba.org>
 <CAKYAXd_p1MrB2G25_p52OfppfSUcEWQEVxgJbBikAe3GZrJFhw@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <46e67316-58f3-435d-458c-11968499d4ee@talpey.com>
Date:   Thu, 1 Apr 2021 17:04:07 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAKYAXd_p1MrB2G25_p52OfppfSUcEWQEVxgJbBikAe3GZrJFhw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfCTebwSLG0O7CVyJx0MSZc8RdyOjwuZI/CluYpCmzCTBYDnswFAGGwB2pTKJ74GlIi9KJC0EnCvFsKN4kKsYIpgzKsfp3ssVCbRCmPFTnQUChE5x7Grk
 8HoUqTXT9frKqAA8BFTBaji1CzdTk/oAxgjAn9ZGDSrPECP+BmxbUaWoD/p5nkIcVHhp4zYWe8lU/pnMenMRn3h4GpQuHA36qrpU22xo6N9KuU2HxXgiQG+w
 LUwvWCnYnh9lOSR2KJJMPUlxU7X1HB+MZ/vOdijkMkRwO9vpmeJ7cpqdza0x4Ou6Lvm+mYpiLQVgwJ/VW33kYq/sz59vkeV0O/E8aIS8bjTRd9Km4YyD+m50
 5Sav0aGJ5VNH3ubwid3KMjoQQ7NUn7/4s9uUPIhY7n1VE0VjDhjA3oKN4OC+LYxiFqp26/uy3BGY1+oqfyQ4AQCZtvOV7ga3Kuou6nltOYR7wrRR624SBJnM
 RatNJKN2AOAGE8k43+EeqYasuGAAHQJpuSbZqdYHpRUDIb+vem7eLgF7UGk=
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 4/1/2021 9:36 AM, Namjae Jeon wrote:
> 2021-04-01 22:14 GMT+09:00, Ralph Boehme <slow@samba.org>:
>> Am 4/1/21 um 2:59 PM schrieb Namjae Jeon:
>>> 2021-04-01 21:50 GMT+09:00, Ralph Boehme <slow@samba.org>:
>>>> fwiw, while at it what about renaming everything that still references
>>>> "cifs" to "smb" ? This is not the 90's... :)
>>> It is also used with the name "ksmbd". So function and variable prefix
>>> are used with ksmbd.
>>
>> well, I was thinking of this:
>>
>>   > +++ b/fs/cifsd/...
>>
>> We should really stop using the name cifs for modern implementation of
>> SMB{23} and the code should not be added as fs/cifsd/ to the kernel.
> As I know, currently "cifs" is being used for the subdirectory name
> for historical reasons and to avoid confusions, even though the CIFS
> (SMB1) dialect is no longer recommended.

I'm with Ralph. CIFS is history that we need to relegate to the past.

I also agree that wrappers around core memory allocators are to
be avoided.

Tom.
