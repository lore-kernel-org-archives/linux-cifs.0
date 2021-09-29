Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF2DC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 15:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F28261407
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 15:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345081AbhI2PUc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 11:20:32 -0400
Received: from p3plsmtpa12-06.prod.phx3.secureserver.net ([68.178.252.235]:55712
        "EHLO p3plsmtpa12-06.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345050AbhI2PUc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 29 Sep 2021 11:20:32 -0400
Received: from [192.168.0.100] ([173.76.240.186])
        by :SMTPAUTH: with ESMTPSA
        id VbMAmWiB8miZQVbMAmvGJp; Wed, 29 Sep 2021 08:18:51 -0700
X-CMAE-Analysis: v=2.4 cv=ZvAol/3G c=1 sm=1 tr=0 ts=615483db
 a=jWrLioA5F7WmVvax94MGYQ==:117 a=jWrLioA5F7WmVvax94MGYQ==:17
 a=IkcTkHD0fZMA:10 a=SEc3moZ4AAAA:8 a=pGLkceISAAAA:8 a=hGzw-44bAAAA:8
 a=cm27Pg_UAAAA:8 a=VwQbUJbxAAAA:8 a=twOazZl5BFnfj3kQUWMA:9 a=QEXdDO2ut3YA:10
 a=5oRCH6oROnRZc2VpWJZ3:22 a=HvKuF1_PTVFglORKqfwH:22 a=xmb-EsYY8bH0VWELuYED:22
 a=AjGcO6oz07-iQ99wixmX:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH] ksmbd: fix transform header validation
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Ralph_B=c3=b6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
References: <20210929133657.10553-1-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <11ae0ea4-a714-b9a3-f3f9-7733c45fcf5a@talpey.com>
Date:   Wed, 29 Sep 2021 11:18:50 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210929133657.10553-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfIEaBUU+NfF0Wv3omPxTr4o0eUWTqiYAqBNl8tBCK2Ohqg1BObaZZfFUjC2AQlruJ1jP8MRiLl3Ius3EzuIVcdeHDb55vH8LPfRkYchDh0XjiwwLaJ0e
 5nmtBEZwFaR1iwc+Rszj3XcdG1F1Z6v7IAi4em/paHlvCoOimBxqvEmP9WSmoBPSq/8IV6dWpq4NC+kumoHYQZb+Kao7fEan2T4BVbUDY7LPiVzelq9UY2Ln
 ZR0J6Bwekd5RcNxO4nU7yTYBhU1tfxqRQ6kegaKE5cINxC8Y7n2MQmabDUlh1T8jNw+jFEbO3BDpkaF4Ox5zqPlRU3wMvvvAIZHiU7itSEWndi1Stenf7BsM
 zovY6xoR/Vj3WjphYZlcA5won+sp3w==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/29/2021 9:36 AM, Namjae Jeon wrote:
> OriginalMessageSize and SessionId should be used after validating
> transform header in request buffer.


I suggest rewording the log for clarity:

++ Validate that the transform and smb request headers are present
++ before checking OriginalMessageSize and SessionId fields.

Is there some reason you aren't using the buf_data_size that is
already calculated, to verify these offsets? It seems like a lot
of redundant, and therefore fragile, coding.

Reviewed-By: Tom Talpey <tom@talpey.com>


> 
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph Böhme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/ksmbd/smb2pdu.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index ec05d9dc6436..b06361313889 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -8455,16 +8455,8 @@ int smb3_decrypt_req(struct ksmbd_work *work)
>   	unsigned int buf_data_size = pdu_length + 4 -
>   		sizeof(struct smb2_transform_hdr);
>   	struct smb2_transform_hdr *tr_hdr = (struct smb2_transform_hdr *)buf;
> -	unsigned int orig_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
>   	int rc = 0;
>   
> -	sess = ksmbd_session_lookup_all(conn, le64_to_cpu(tr_hdr->SessionId));
> -	if (!sess) {
> -		pr_err("invalid session id(%llx) in transform header\n",
> -		       le64_to_cpu(tr_hdr->SessionId));
> -		return -ECONNABORTED;
> -	}
> -
>   	if (pdu_length + 4 <
>   	    sizeof(struct smb2_transform_hdr) + sizeof(struct smb2_hdr)) {
>   		pr_err("Transform message is too small (%u)\n",
> @@ -8472,11 +8464,19 @@ int smb3_decrypt_req(struct ksmbd_work *work)
>   		return -ECONNABORTED;
>   	}
>   
> -	if (pdu_length + 4 < orig_len + sizeof(struct smb2_transform_hdr)) {
> +	if (pdu_length + 4 <
> +	    le32_to_cpu(tr_hdr->OriginalMessageSize) + sizeof(struct smb2_transform_hdr)) {
>   		pr_err("Transform message is broken\n");
>   		return -ECONNABORTED;
>   	}
>   
> +	sess = ksmbd_session_lookup_all(conn, le64_to_cpu(tr_hdr->SessionId));
> +	if (!sess) {
> +		pr_err("invalid session id(%llx) in transform header\n",
> +		       le64_to_cpu(tr_hdr->SessionId));
> +		return -ECONNABORTED;
> +	}
> +
>   	iov[0].iov_base = buf;
>   	iov[0].iov_len = sizeof(struct smb2_transform_hdr);
>   	iov[1].iov_base = buf + sizeof(struct smb2_transform_hdr);
> 
