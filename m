Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D46BC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 18:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E3C361186
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 18:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbhIUSUk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 14:20:40 -0400
Received: from p3plsmtpa06-07.prod.phx3.secureserver.net ([173.201.192.108]:57087
        "EHLO p3plsmtpa06-07.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232729AbhIUSUg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Sep 2021 14:20:36 -0400
Received: from [192.168.0.100] ([173.76.240.186])
        by :SMTPAUTH: with ESMTPSA
        id SkMAmqQVcC8uoSkMBmiy7g; Tue, 21 Sep 2021 11:19:03 -0700
X-CMAE-Analysis: v=2.4 cv=d6AwdTvE c=1 sm=1 tr=0 ts=614a2217
 a=jWrLioA5F7WmVvax94MGYQ==:117 a=jWrLioA5F7WmVvax94MGYQ==:17
 a=IkcTkHD0fZMA:10 a=SEc3moZ4AAAA:8 a=yIFFuQWDUWJMZJ_wuzUA:9 a=QEXdDO2ut3YA:10
 a=5oRCH6oROnRZc2VpWJZ3:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH] ksmbd: add default data stream name in
 FILE_STREAM_INFORMATION
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <20210918120239.96627-1-linkinjeon@kernel.org>
 <ac18e062-e835-b575-66af-72631df7ef7d@talpey.com>
 <CAH2r5msa4XeaLy=_HY9RrLpK0NyS9n3iMdYnvX7F4n2zNQNXgQ@mail.gmail.com>
 <2cf8a2d1-41df-eef4-dfe0-dca076e8db54@talpey.com>
 <CAKYAXd9VJ52QOEdAaNC3ZVAZk3mBAZFHo=uME_ygK0Axk=yivQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <a8f47375-9672-8761-55fe-d99add3a39b1@talpey.com>
Date:   Tue, 21 Sep 2021 14:19:02 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAKYAXd9VJ52QOEdAaNC3ZVAZk3mBAZFHo=uME_ygK0Axk=yivQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfCzMLfUDCiQXO0Px3vWUFKugP7suofvXj/tE7NoOqoLC3u3Z+sCFSAf6JuLqEXWy1K25Rdu4TpJOw3MLbit0kudklNibcABftZmJmOJhFjYiY/fWBLB0
 Z6XDHxH8Tac80lhMvzjv2EbI4xSGgTGgGm4W29ixWnTDboYWCrPAxKA38SEvs8ZrbkE7jkBxySAV3BdV8FNzlQe3R3ZHzXLMcV5Y97BGCFtCA4I0AP01rofF
 XEcJWF1dj1GmDBN3SppJaQ==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/20/2021 12:34 PM, Namjae Jeon wrote:
> 2021-09-21 1:08 GMT+09:00, Tom Talpey <tom@talpey.com>:
<snip>
>>
>> My concern here is, what's so special about directories? A special file
>> or fifo, a symlink or reparse/junction, etc. Is it appropriate to cons
>> up a ::$DATA for these? What should the size values be, if so?
> Special files in linux(ksmbd share) is showing as regular file on
> windows client.

This brings up an interesting second question. Is that a good thing?

It seems risky, and perhaps wrong, that one can open such a special file 
and read or write it over SMB3. I can see allowing read attributes, etc, 
but certainly not full access. To me, at a minimum the read or write 
should be failed by ksmbd, if not the CREATE itself. ksmbd should not be 
representing these as ordinary files.

Tom.
