Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7635DC433FE
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 15:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E68F61381
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 15:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345013AbhI2PK3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 11:10:29 -0400
Received: from p3plsmtpa12-06.prod.phx3.secureserver.net ([68.178.252.235]:52301
        "EHLO p3plsmtpa12-06.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344939AbhI2PK3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 29 Sep 2021 11:10:29 -0400
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Sep 2021 11:10:29 EDT
Received: from [192.168.0.100] ([173.76.240.186])
        by :SMTPAUTH: with ESMTPSA
        id Vb5MmWdsmmiZQVb5NmvF9A; Wed, 29 Sep 2021 08:01:29 -0700
X-CMAE-Analysis: v=2.4 cv=ZvAol/3G c=1 sm=1 tr=0 ts=61547fc9
 a=jWrLioA5F7WmVvax94MGYQ==:117 a=jWrLioA5F7WmVvax94MGYQ==:17
 a=IkcTkHD0fZMA:10 a=SEc3moZ4AAAA:8 a=PUjc2dyp16Q0NGHMfpgA:9 a=QEXdDO2ut3YA:10
 a=5oRCH6oROnRZc2VpWJZ3:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH v4] ksmbd: use LOOKUP_BENEATH to prevent the out of share
 access
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Ralph Boehme <slow@samba.org>,
        Steve French <smfrench@gmail.com>
References: <20210924150616.926503-1-hyc.lee@gmail.com>
 <7f120930-27d1-831c-4697-2d41769da14d@talpey.com>
 <CAKYAXd-aC9Zfc-tsN_VSABELFdhFfE7y28gX3_B-yoTzyqCviw@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <3ea034dc-971f-4ea1-b65a-2ff06c8a1c81@talpey.com>
Date:   Wed, 29 Sep 2021 11:01:28 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAKYAXd-aC9Zfc-tsN_VSABELFdhFfE7y28gX3_B-yoTzyqCviw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfDkFIN5S1u4QmHxGApEBTId0hXYYR7Q689B/DRsrxG5LqE91LI6c2rnbnJadYv6A52dC5HQyxaRMdwdK3eV2/e0xh1DwAcmvkCUhi07BsQKSq+CfOE3J
 F5fvezqr20vfhQktMPreKCTsv5qHoYr8OOJ1Q25xpwt/4hRgGtB4H9d2z09reYz+gWTAVNEz2Il+1hk4Ie4uaDTQN1xbsB8nTyf8Pa2tSNnqKLcbvsmuDBRU
 0jDqyZXddGNqUiQD185yaYZzroME7t3LiYpOT2JjVrxrJ3WhdO9lfiTj7oKqtAhPZ+TjdxpsCJVCIWjljvNqdeEu2rkGgAePiJSUhLrph6zUK7S522E54ZmE
 kQB1CILB
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/29/2021 8:40 AM, Namjae Jeon wrote:
> 2021-09-29 0:18 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> On 9/24/2021 11:06 AM, Hyunchul Lee wrote:
>>> instead of removing '..' in a given path, call
>>> kern_path with LOOKUP_BENEATH flag to prevent
>>> the out of share access.
>>> <snip> <snip> <snip>
>>> -char *convert_to_nt_pathname(char *filename, char *sharepath)
>>> +char *convert_to_nt_pathname(char *filename)
>>>    {
>>>    	char *ab_pathname;
>>> -	int len, name_len;
>>>
>>> -	name_len = strlen(filename);
>>> -	ab_pathname = kmalloc(name_len, GFP_KERNEL);
>>> -	if (!ab_pathname)
>>> -		return NULL;
>>> -
>>> -	ab_pathname[0] = '\\';
>>> -	ab_pathname[1] = '\0';
>>> +	if (strlen(filename) == 0) {
>>> +		ab_pathname = kmalloc(2, GFP_KERNEL);
>>> +		ab_pathname[0] = '\\';
>>> +		ab_pathname[1] = '\0';
>>
>> This converts the empty filename to "\" - the volume root!?
> "\" is relative to the share. i.e. the share root.

Is that the right thing to do? Does the Samba server do this?

I believe the Windows server will fail such a path, but I can't
check right now.

Tom.
