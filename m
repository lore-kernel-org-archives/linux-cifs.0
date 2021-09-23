Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C20C433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 15:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD1DE6121F
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 15:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241880AbhIWPGw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 11:06:52 -0400
Received: from p3plsmtpa06-10.prod.phx3.secureserver.net ([173.201.192.111]:35885
        "EHLO p3plsmtpa06-10.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241815AbhIWPGv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 23 Sep 2021 11:06:51 -0400
Received: from [192.168.0.100] ([173.76.240.186])
        by :SMTPAUTH: with ESMTPSA
        id TQHnmF8RwPJpHTQHnmW78k; Thu, 23 Sep 2021 08:05:20 -0700
X-CMAE-Analysis: v=2.4 cv=C7QsdSD+ c=1 sm=1 tr=0 ts=614c97b0
 a=jWrLioA5F7WmVvax94MGYQ==:117 a=jWrLioA5F7WmVvax94MGYQ==:17
 a=IkcTkHD0fZMA:10 a=SEc3moZ4AAAA:8 a=pGLkceISAAAA:8 a=hGzw-44bAAAA:8
 a=VwQbUJbxAAAA:8 a=zbTXJiDWrYkmQbYy2g8A:9 a=QEXdDO2ut3YA:10
 a=5oRCH6oROnRZc2VpWJZ3:22 a=HvKuF1_PTVFglORKqfwH:22 a=AjGcO6oz07-iQ99wixmX:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH] ksmbd: add the check to vaildate if stream protocol
 length exceeds maximum value
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Ralph_B=c3=b6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
References: <20210923034855.612832-1-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <e8902c30-268b-4a4c-9959-6cf0fb67cb53@talpey.com>
Date:   Thu, 23 Sep 2021 11:05:20 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210923034855.612832-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfKETsdu3u0BeKFMg3T7qKevpRQRYuOdhceF2P7oQq82cyKvlP+Z3i5ZtjseP6WyDoq+8gj102DWbjD1tYfQBMC47qQmTbLicKk1eyvOK2HO6AMpH7uj5
 3lV1uFPAzN8R0jKluNclSPC7FGwsEZEyirpTbEEILYUR3sWobQSK4w4mafma5tK2PKiRRk0nrgig1kxVw0sNqTgiqPwNDJZdXCUgUEiADhRTINAK5xHAT4NR
 x73Nysb+Il84tbP6pwaZI6Tky6XJ9IPCN1TkiH54m4D40Ck9k5mtoPyGtNU73ulPCeFRV6ZJAuHOTGXKVK22AA==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org



On 9/22/2021 11:48 PM, Namjae Jeon wrote:
> This patch add MAX_STREAM_PROT_LEN macro and check if stream protocol
> length exceeds maximum value in ksmbd_pdu_size_has_room().
> 
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph Böhme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/ksmbd/smb_common.c | 3 ++-
>   fs/ksmbd/smb_common.h | 2 ++
>   2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
> index 5901b2884c60..ebc835ab414c 100644
> --- a/fs/ksmbd/smb_common.c
> +++ b/fs/ksmbd/smb_common.c
> @@ -274,7 +274,8 @@ int ksmbd_init_smb_server(struct ksmbd_work *work)
>   
>   bool ksmbd_pdu_size_has_room(unsigned int pdu)
>   {
> -	return (pdu >= KSMBD_MIN_SUPPORTED_HEADER_SIZE - 4);
> +	return (pdu >= KSMBD_MIN_SUPPORTED_HEADER_SIZE - 4 &&
> +		pdu <= MAX_STREAM_PROT_LEN);

Incorrect. If the pdu is already 2^24-1 bytes long, there is no "room".

I don't think  a "<" fixes this either. One byte isn't sufficient to
allow any significant addition, in all likelihood.

What, exactly, is this check protecting?

Tom.

>   }
>   
>   int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
> diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
> index 994abede27e9..10b8d7224dfa 100644
> --- a/fs/ksmbd/smb_common.h
> +++ b/fs/ksmbd/smb_common.h
> @@ -48,6 +48,8 @@
>   #define CIFS_DEFAULT_IOSIZE	(64 * 1024)
>   #define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
>   
> +#define MAX_STREAM_PROT_LEN	0x00FFFFFF
> +
>   /* Responses when opening a file. */
>   #define F_SUPERSEDED	0
>   #define F_OPENED	1
> 
