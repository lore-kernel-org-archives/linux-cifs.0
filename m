Return-Path: <SRS0=jgI2=DY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41518C433E7
	for <linux-cifs@archiver.kernel.org>; Sat, 17 Oct 2020 23:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F35D920878
	for <linux-cifs@archiver.kernel.org>; Sat, 17 Oct 2020 23:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439895AbgJQXYM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:24:12 -0400
Received: from p3plsmtpa07-09.prod.phx3.secureserver.net ([173.201.192.238]:41601
        "EHLO p3plsmtpa07-09.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439894AbgJQXYL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 17 Oct 2020 19:24:11 -0400
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id TvYlkZq7VZigzTvYlkUeQd; Sat, 17 Oct 2020 16:24:24 -0700
X-CMAE-Analysis: v=2.3 cv=IOt89TnG c=1 sm=1 tr=0
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=hGzw-44bAAAA:8 a=SEc3moZ4AAAA:8 a=yMhMjlubAAAA:8
 a=wZyfw42ZlIEBJXZ0eAgA:9 a=QEXdDO2ut3YA:10 a=OIYhK5qeqOwA:10
 a=EKyiZd4GwQoA:10 a=HvKuF1_PTVFglORKqfwH:22 a=5oRCH6oROnRZc2VpWJZ3:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH][SMB3.1.1] do not fail if no encryption required when
 server doesn't support encryption
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
References: <CAH2r5mv_0rLQF=npjc4CVJBDhsc8Eu_sJtY6xUDbBXs7aYhSzA@mail.gmail.com>
 <5280e8f2-0c9a-c82c-5e5e-9b2d67888da4@talpey.com>
 <CAH2r5msmVV57GWUCZE+=Z2uSkbm5ABiga+MNxZm1Mu+OSERE_w@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <54b0c129-39a1-c237-be34-4f122c297799@talpey.com>
Date:   Sat, 17 Oct 2020 19:24:24 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5msmVV57GWUCZE+=Z2uSkbm5ABiga+MNxZm1Mu+OSERE_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfDVsV5mHceqlRFCnHurzla/xAJOC+YFq95LsZXK57s19Y4I4HQ3Re1BpBfZT0ahJsgWXvgonlLBHygOjh22Zhu+USU3XypYWBqlcmHPJcZSsFKhoTLBJ
 CY1XlI3mzs+atC9T5zEqEOBiSIKYIVCbZXlk8cQkH3XoRHrVVWxITeil59zUDsDJ01lZPfN4wrs9sAFeZs9McoKtRa7taWniDQKKZL8oz59Izk6n/GhEkGhx
 e+IHMg4FWb0L9QH6K3M9cQPD1dfVXyxHlwTbVNBgFOk=
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ah, ok consistency is good. I still suggest my first comment though.

Dumb followup question, in that case. Is "seal" a mount option?
It is not listed in the manpage (nor is "encrypt" etc).

Tom.

On 10/17/2020 3:47 PM, Steve French wrote:
> To be consistent with others including Samba we used "seal" (a long
> time ago it seems now) to be the mount option to mean "require
> encryption for this mount"
> 
> See various references to seal (to mean encrypt) in
> https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html for
> example
> 
> Not sure the etymology here of "seal" but my guess is that its use to
> mean "encrypt" came from the alternative meaning of "seal" not a large
> aquatic mammal but instead "apply a nonporous coating to make it
> impervious."
> 
> On Sat, Oct 17, 2020 at 12:08 PM Tom Talpey <tom@talpey.com> wrote:
>>
>> On 10/17/2020 5:03 AM, Steve French wrote:
>>>       There are cases where the server can return a cipher type of 0 and
>>>       it not be an error. For example, if server only supported AES256_CCM
>>>       (very unlikely) or server supported no encryption types or
>>
>> It seems me that the simpler statement is that there are
>> no ciphers supported in common between client and server.
>>
>>>       had all disabled. In those cases encryption would not be supported,
>>>       but that can be ok if the client did not require encryption on mount.
>>>
>>>       In the case in which mount requested encryption ("seal" on mount)
>>
>> I'm confused. Doesn't "seal" mean signing?
>>
>> Tom.
>>
>>>       then checks later on during tree connection will return the proper
>>>       rc, but if seal was not requested by client, since server is allowed
>>>       to return 0 to indicate no supported cipher, we should not fail mount.
>>>
>>>       Reported-by: Pavel Shilovsky <pshilov@microsoft.com>
>>>       Signed-off-by: Steve French <stfrench@microsoft.com>
>>>
>>>
> 
> 
> 
