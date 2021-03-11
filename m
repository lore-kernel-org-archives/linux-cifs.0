Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4035BC433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Mar 2021 20:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 038C264F8C
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Mar 2021 20:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhCKUmG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:42:06 -0500
Received: from p3plsmtpa07-10.prod.phx3.secureserver.net ([173.201.192.239]:41041
        "EHLO p3plsmtpa07-10.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230000AbhCKUmD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 11 Mar 2021 15:42:03 -0500
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id KS89l97tNukyLKS8Alc8bu; Thu, 11 Mar 2021 13:42:02 -0700
X-CMAE-Analysis: v=2.4 cv=Od9dsjfY c=1 sm=1 tr=0 ts=604a809a
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=SEc3moZ4AAAA:8 a=aZQ1mOuCFQjnfliJl3YA:9 a=QEXdDO2ut3YA:10
 a=5oRCH6oROnRZc2VpWJZ3:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH v4] flock.2: add CIFS details
To:     =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>,
        "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, mtk.manpages@gmail.com,
        linux-man@vger.kernel.org
References: <87v9a7w8q7.fsf@suse.com> <20210304095026.782-1-aaptel@suse.com>
 <45b64990-b879-02d3-28e5-b896af0502c4@gmail.com> <87sg52t2xj.fsf@suse.com>
 <139a3729-9460-7272-b1d7-c2feb5679ee9@talpey.com> <87eegltxzd.fsf@suse.com>
 <d602e3e4-721a-a1c5-3375-1c9899da4383@talpey.com> <878s6ttwhd.fsf@suse.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <23052c07-8050-4eb8-d2de-506c60dbed7d@talpey.com>
Date:   Thu, 11 Mar 2021 15:42:01 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <878s6ttwhd.fsf@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfKLGkDz/bysPE+Ob4fUuqGAQgwcF2OCEY1rdpqcTU0S0y7xfhrjWqllfUxiS2lalcN9qQjmCdsvrldDN+18YKw/HovBW1MvFFQ/CnkQF1oE0ooFtKFo8
 irpkx+UcEi/YeJz/XrVTwDCcuyhL+ClbyZMbLfMrBbTVMH/4eVPlSmZsOI12gK1SaUNniABPTCS4ndv5jNv2Q6yHEeZdXYPpVNZ0FEm1C+doN6h3TQkRJQtF
 ERddTEK2PvaTTViKMFmaWqoGYZZEyuW6Iail5zwR0AsHCGuaHbKkILAKeDHtzafmQnwJerMNe/ln3+GlFmazRrYZnGtuo9UY+a5HPRf7X+GuosFZhAUciQpW
 0DkNKOx/JYPf0HT9Kmzk7+q6DE4xRFXzlmwCdAwkU6ezXoBmc/s=
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 3/11/2021 12:45 PM, Aurélien Aptel wrote:
> Tom Talpey <tom@talpey.com> writes:
>> and simply state (perhaps)
>>
>>    "Remote and mandatory locking semantics may vary with SMB protocol,
>>     mount options and server type. See mount.cifs(8) for additional
>>     information."
> 
> This would be the complete addition to the man page? I feel like we

Only replacing the last sentence, which I quoted earlier.

> should at least say it is *likely* that:
> - locks will be mandatory
> - flock() is emulated via fnctl() and so they interact with each other
> 
> Which are the 2 aspects that really diverges from the expected behaviour
> of flock() and likely to hit people in the wild. Mentionning this will
> send people trying to debug their app in the right direction.

Ok, and agreed. SMB lock semantics are certainly important to describe.

Tom.
