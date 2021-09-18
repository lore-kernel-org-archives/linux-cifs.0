Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7DE3C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 12:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA3FE61288
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 12:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235998AbhIRMlT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 18 Sep 2021 08:41:19 -0400
Received: from p3plsmtpa07-03.prod.phx3.secureserver.net ([173.201.192.232]:41877
        "EHLO p3plsmtpa07-03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235986AbhIRMlS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 18 Sep 2021 08:41:18 -0400
Received: from [192.168.0.100] ([173.76.240.186])
        by :SMTPAUTH: with ESMTPSA
        id RZdJmRXge7gHlRZdJmUwfi; Sat, 18 Sep 2021 05:39:53 -0700
X-CMAE-Analysis: v=2.4 cv=GPrNrsBK c=1 sm=1 tr=0 ts=6145de19
 a=jWrLioA5F7WmVvax94MGYQ==:117 a=jWrLioA5F7WmVvax94MGYQ==:17
 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=Pp1xdhkxTR8jcLTIQWcA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH] ksmbd: add default data stream name in
 FILE_STREAM_INFORMATION
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
References: <20210918120239.96627-1-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <ac18e062-e835-b575-66af-72631df7ef7d@talpey.com>
Date:   Sat, 18 Sep 2021 08:39:53 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210918120239.96627-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfPl9hmyzceSgOq0wg+2ESjB8zL+PrJ9UWGg5/DY5HyRqCFali8Bir92vObwL5V6puvQGdSA0X96Eldk9zhMzAKB93d5ijeupXk6KEj3U6qxsFCx2qOj4
 fMhcMP/kXaouDpH9ykfItqgBUwT0WJdQdALAiU7SClZEHNC3GXzEKfZNuf2hn4/kHDKlc6IjL/h8b+bO3FoXkws9SL3r+yMcBu6O78ulWajIj1Y6vroHhJ/s
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This doesn't appear to be what's documented in MS-FSA section 2.1.5.11.29.
There, it appears to call for returning an empty stream list,
and STATUS_SUCCESS, when no streams are present.

Also, why does the code special-case directories? The conditionals
on StreamSize and StreamAllocation size are entirely redundant,
after the top-level if (!S_ISDIR...), btw.

I'd suggest asking Microsoft dochelp for clarification before
implementing this.

Tom.

On 9/18/2021 8:02 AM, Namjae Jeon wrote:
> Windows client expect to get default stream name(::DATA) in
> FILE_STREAM_INFORMATION response even if there is no stream data in file.
> This patch fix update failure when writing ppt or doc files.
> 
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/ksmbd/smb2pdu.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 49a1ca75f427..301605e0cbf7 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -4465,17 +4465,15 @@ static void get_file_stream_info(struct ksmbd_work *work,
>   		file_info->NextEntryOffset = cpu_to_le32(next);
>   	}
>   
> -	if (nbytes) {
> +	if (!S_ISDIR(stat.mode)) {
>   		file_info = (struct smb2_file_stream_info *)
>   			&rsp->Buffer[nbytes];
>   		streamlen = smbConvertToUTF16((__le16 *)file_info->StreamName,
>   					      "::$DATA", 7, conn->local_nls, 0);
>   		streamlen *= 2;
>   		file_info->StreamNameLength = cpu_to_le32(streamlen);
> -		file_info->StreamSize = S_ISDIR(stat.mode) ? 0 :
> -			cpu_to_le64(stat.size);
> -		file_info->StreamAllocationSize = S_ISDIR(stat.mode) ? 0 :
> -			cpu_to_le64(stat.size);
> +		file_info->StreamSize = 0;
> +		file_info->StreamAllocationSize = 0;
>   		nbytes += sizeof(struct smb2_file_stream_info) + streamlen;
>   	}
>   
> 
