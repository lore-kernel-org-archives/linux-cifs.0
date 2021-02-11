Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA39DC433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Feb 2021 19:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9489564DAD
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Feb 2021 19:42:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhBKTmj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Feb 2021 14:42:39 -0500
Received: from p3plsmtpa08-07.prod.phx3.secureserver.net ([173.201.193.108]:60317
        "EHLO p3plsmtpa08-07.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229965AbhBKTmh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 11 Feb 2021 14:42:37 -0500
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id AHqWlkLRo2xvDAHqYlrrXW; Thu, 11 Feb 2021 12:41:51 -0700
X-CMAE-Analysis: v=2.4 cv=HqCzp2fS c=1 sm=1 tr=0 ts=6025887f
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=iox4zFpeAAAA:8 a=pGLkceISAAAA:8 a=tAOjvO-xAm6PYSth-vMA:9
 a=QEXdDO2ut3YA:10 a=WzC6qhA0u3u7Ye7llzcV:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH 4/4] cifs: Reformat DebugData and index connections by
 conn_id.
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
References: <CANT5p=o9Tw9E+o3PWytsNh5eDKxswJ+YPLZLWac7QwR_u-UJaw@mail.gmail.com>
 <87h7msnnme.fsf@suse.com>
 <CANT5p=qGTC4E4Rf_-t9xXOo4yf3W=xtk97J1jg-WRLhwf0juBA@mail.gmail.com>
 <87a6sjopsc.fsf@suse.com>
 <CANT5p=qQJwvF11MJpiuV7S1GpH9=HZ-g=hmfOV-a07N9xkYqnA@mail.gmail.com>
 <CAH2r5mv0TzWpYi38HtuVG2gtYvW60-RDOri3a1FUUtprn19Dzw@mail.gmail.com>
 <87lfbyn647.fsf@suse.com>
 <CANT5p=qJjeVk1HDhvaiAQSYH3mj-rNBNA-j2TAUnoqQVTOQ_Ww@mail.gmail.com>
 <875z2yn0lx.fsf@suse.com>
 <CAKywueRoFL17DiMzmorZcd=OJvDY_8+P8WxGqKDx-tdnJrr_HQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <6aad7fc3-3c3f-848c-4d65-e5c7f1dd8107@talpey.com>
Date:   Thu, 11 Feb 2021 14:41:48 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAKywueRoFL17DiMzmorZcd=OJvDY_8+P8WxGqKDx-tdnJrr_HQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfMfsbUcTS0LswLwTo/7JuNS2yLTh++qaX8G9kO5tPZNHjkMGuQ6MrQ5DeVhCoiP6TVwg27Hi/AabQ9E1Agoqh9YVqaxHDFRs512FWd5Q98+MxmGsC6oY
 00WGYT/oiaELt1+n3HDnfFm7o0K6ORF3njdv8e4U5ftJyxqAFebtlFbNzzb1cEyzyjlS3OkhEGACxzKKniId1gGnEKQXSbB5Ibsmn4b13v0/u3fboQ6d8hlE
 Jwbv4MUzbJLrKmSrrMGXXlLbadp8hBcMYNGtQSH84tW33sRPjcf9+yJoDcJyvRpZOoPln1vLGxwykqwfjmaN+PeXv2JtcA3E1crez1il3fElh44a/GT4YkWT
 qh+/Rcp2
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2/11/2021 12:12 PM, Pavel Shilovsky wrote:
> Hi Shyam,
> 
> The output looks very informative! I have one comment:
> 
> Servers:
> 1) ConnectionId: 0x1
> Number of credits: 326 Dialect 0x311
> TCP status: 1 Instance: 1
> Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0
> In Send: 0 In MaxReq Wait: 0
> 
> Sessions:
> 1) Name: 10.229.158.38 Uses: 1 Capability: 0x300077 Session Status: 1
>                       ^^^^
> Isn't this name (or hostname) a property of the connection? I would
> expect an IP or a hostname to be printed in the connection settings
> above.

The servername is a property of the session, in this case since the
mount specified a dotted quad, it would correctly appear as the
servername at this level.

However, I definitely agree that an IP address is important in the
per-connection (channel) stanzas. Multichannel, multihoming, witness
redirects, and any number of things can vary among them. It would
be useful indeed to display them.

Including the transport type (TCP, RDMA...) and multichannel attributes
(link speed, RSS count, ...) would be useful too.

Tom.

> 
> --
> Best regards,
> Pavel Shilovsky
> 
> чт, 11 февр. 2021 г. в 06:24, Aurélien Aptel <aaptel@suse.com>:
>>
>> Shyam Prasad N <nspmangalore@gmail.com> writes:
>>> I noticed that the output looks rather odd when used with multichannel.
>>> Attaching a revised patch with the changes.
>>>
>>> Also attached a sample of new output.
>>
>> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>>
>> --
>> Aurélien Aptel / SUSE Labs Samba Team
>> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
>> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
>> GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
>>
> 
