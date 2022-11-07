Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D6EBC433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Nov 2022 13:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbiKGNRR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Nov 2022 08:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbiKGNRR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Nov 2022 08:17:17 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287BB25DC
        for <linux-cifs@vger.kernel.org>; Mon,  7 Nov 2022 05:17:16 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1os202-000357-LZ; Mon, 07 Nov 2022 14:17:14 +0100
Message-ID: <b5badfe1-ccb8-f8b3-90b7-c05689e22776@leemhuis.info>
Date:   Mon, 7 Nov 2022 14:17:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] cifs: fix regression in very old smb1 mounts
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <smfrench@gmail.com>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        linux-cifs <linux-cifs@vger.kernel.org>
References: <20221011231207.1458541-1-lsahlber@redhat.com>
 <0fb9b48e-3bcc-5a5e-15fb-1d3e2752d80b@leemhuis.info>
In-Reply-To: <0fb9b48e-3bcc-5a5e-15fb-1d3e2752d80b@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1667827036;0abf725b;
X-HE-SMSGID: 1os202-000357-LZ
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 01.11.22 18:53, Thorsten Leemhuis wrote:
> On 12.10.22 01:12, Ronnie Sahlberg wrote:
>> BZ: 215375
>>
>> Fixes: 76a3c92ec9e0668e4cd0e9ff1782eb68f61a179c ("cifs: remove support for NTLM and weaker authentication algorithms")
>> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> 
> Ronnie, Steve, did this change create any trouble in 6.1 pre-releases so
> far? If not: could you please consider submitting this change for
> inclusion in 6.0 and 5.15, as this is a regression from the 5.15 days
> that according to the bugzilla ticket seem to annoy some people a lot.

Ronnie, Steve, if you have a minute, I would really appreciate your help
in this matter, you are the best people to judge here.

Ciao, Thorsten

>> ---
>>  fs/cifs/connect.c | 11 +++++------
>>  1 file changed, 5 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 93e59b3b36c7..c77232096c12 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -3922,12 +3922,11 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
>>  	pSMB->AndXCommand = 0xFF;
>>  	pSMB->Flags = cpu_to_le16(TCON_EXTENDED_SECINFO);
>>  	bcc_ptr = &pSMB->Password[0];
>> -	if (tcon->pipe || (ses->server->sec_mode & SECMODE_USER)) {
>> -		pSMB->PasswordLength = cpu_to_le16(1);	/* minimum */
>> -		*bcc_ptr = 0; /* password is null byte */
>> -		bcc_ptr++;              /* skip password */
>> -		/* already aligned so no need to do it below */
>> -	}
>> +
>> +	pSMB->PasswordLength = cpu_to_le16(1);	/* minimum */
>> +	*bcc_ptr = 0; /* password is null byte */
>> +	bcc_ptr++;              /* skip password */
>> +	/* already aligned so no need to do it below */
>>  
>>  	if (ses->server->sign)
>>  		smb_buffer->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
