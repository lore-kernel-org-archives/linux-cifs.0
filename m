Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D75C4361B
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 21:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE38620793
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Dec 2020 21:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgLIV1B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Dec 2020 16:27:01 -0500
Received: from p3plsmtpa09-06.prod.phx3.secureserver.net ([173.201.193.235]:48310
        "EHLO p3plsmtpa09-06.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388140AbgLIV1B (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Dec 2020 16:27:01 -0500
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id n6yTk10fok95Hn6yTk57z6; Wed, 09 Dec 2020 14:26:14 -0700
X-CMAE-Analysis: v=2.4 cv=YMFadTKx c=1 sm=1 tr=0 ts=5fd140f6
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=yMhMjlubAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=75wEK7pLCa57f_mAP2QA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH][SMB3.1.1] remove confusing mount warning when no SPNEGO
 info on negprot rsp
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mvr6JebH9cr9dO-XbiXdsfBjs=C4WhqkqXUwDCmOY20zA@mail.gmail.com>
 <CAKywueRMTMy7shp_qT3Cu6E1EZ0AwdSvjsWF=MU4KQWkw+YL-A@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <c885d7a2-4f41-d2c0-51ae-43e8ef9cc2d6@talpey.com>
Date:   Wed, 9 Dec 2020 16:26:13 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAKywueRMTMy7shp_qT3Cu6E1EZ0AwdSvjsWF=MU4KQWkw+YL-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfEDmNCkMocyg/1PlhYul4yBZ3S1wpJJnQ4TWBaQDKusdCnW4Vl3fWlb7PCy9nhzfW8lxxzJMKQCYPloUJrcYUTJwobKSHir4pF+9/jvjY0rjt39tz3X7
 wULQ3GpQ+pVNbYSLniwUrGXdGJG3GBdwy/Q+D/onrOJW6M6hd+UmgKBvWVencq/p8KjocJ4hVeFX3HAppgBu6FScURq3tnljsfVfsa7eFevZm+j9WYxVY/oP
 w9CQcwCQiV88ce+xXSVMeA==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The protocol allows omitting the SPNEGO blob altogether, btw. That
leads to the client deciding how to authenticate, although the Windows
server doesn't offer that.

So I'd suggest removing the comment, too:

 >> /* Make sure that negotiate contexts start after gss security blob */


On 12/9/2020 12:39 PM, Pavel Shilovsky wrote:
> Looks good.
> 
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> 
> --
> Best regards,
> Pavel Shilovsky
> 
> вт, 8 дек. 2020 г. в 23:23, Steve French <smfrench@gmail.com>:
>>
>> Azure does not send an SPNEGO blob in the negotiate protocol response,
>> so we shouldn't assume that it is there when validating the location
>> of the first negotiate context.  This avoids the potential confusing
>> mount warning:
>>
>>     CIFS: Invalid negotiate context offset
>>
>> CC: Stable <stable@vger.kernel.org>
>> Signed-off-by: Steve French <stfrench@microsoft.com>
>> ---
>>   fs/cifs/smb2misc.c | 11 +++++++----
>>   1 file changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
>> index d88e2683626e..513507e4c4ad 100644
>> --- a/fs/cifs/smb2misc.c
>> +++ b/fs/cifs/smb2misc.c
>> @@ -109,11 +109,14 @@ static __u32 get_neg_ctxt_len(struct
>> smb2_sync_hdr *hdr, __u32 len,
>>
>>    /* Make sure that negotiate contexts start after gss security blob */
>>    nc_offset = le32_to_cpu(pneg_rsp->NegotiateContextOffset);
>> - if (nc_offset < non_ctxlen) {
>> - pr_warn_once("Invalid negotiate context offset\n");
>> + if (nc_offset + 1 < non_ctxlen) {
>> + pr_warn_once("Invalid negotiate context offset %d\n", nc_offset);
>>    return 0;
>> - }
>> - size_of_pad_before_neg_ctxts = nc_offset - non_ctxlen;
>> + } else if (nc_offset + 1 == non_ctxlen) {
>> + cifs_dbg(FYI, "no SPNEGO security blob in negprot rsp\n");
>> + size_of_pad_before_neg_ctxts = 0;
>> + } else
>> + size_of_pad_before_neg_ctxts = nc_offset - non_ctxlen;
>>
>>    /* Verify that at least minimal negotiate contexts fit within frame */
>>    if (len < nc_offset + (neg_count * sizeof(struct smb2_neg_context))) {
>>
>> --
>> Thanks,
>>
>> Steve
> 
