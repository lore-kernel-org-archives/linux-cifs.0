Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A4BC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 14:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7932A60F41
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 14:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241382AbhI1OsW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Sep 2021 10:48:22 -0400
Received: from p3plsmtpa07-02.prod.phx3.secureserver.net ([173.201.192.231]:48419
        "EHLO p3plsmtpa07-02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241400AbhI1OsV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 28 Sep 2021 10:48:21 -0400
Received: from [192.168.0.100] ([173.76.240.186])
        by :SMTPAUTH: with ESMTPSA
        id VENSmNx9zOD9vVENSmYcYg; Tue, 28 Sep 2021 07:46:39 -0700
X-CMAE-Analysis: v=2.4 cv=Z6wpoFdA c=1 sm=1 tr=0 ts=61532acf
 a=jWrLioA5F7WmVvax94MGYQ==:117 a=jWrLioA5F7WmVvax94MGYQ==:17
 a=IkcTkHD0fZMA:10 a=SEc3moZ4AAAA:8 a=pGLkceISAAAA:8 a=hGzw-44bAAAA:8
 a=cm27Pg_UAAAA:8 a=VwQbUJbxAAAA:8 a=8oo-nSGmwJAqEEkyaUAA:9 a=QEXdDO2ut3YA:10
 a=5oRCH6oROnRZc2VpWJZ3:22 a=HvKuF1_PTVFglORKqfwH:22 a=xmb-EsYY8bH0VWELuYED:22
 a=AjGcO6oz07-iQ99wixmX:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH 1/2] ksmbd: remove the leftover of smb2.0 dialect support
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Ralph_B=c3=b6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
References: <20210927124748.5614-1-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <18b746cc-e790-19ad-c0e5-a2338c7c6359@talpey.com>
Date:   Tue, 28 Sep 2021 10:46:38 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210927124748.5614-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfCClqT+Ppek0mGRnNnFIrUwx7OS2ZXxeuHC+QFeDgYyrWnxHQUckh/FxOpcpAnrFpTSqvIFRweBlGQlZVvEachAXCn7qvvxmEubKPtTlJ7jdn76U5zva
 ziGPPlWoEHu3Sz98S9yBEcTGyIJ8QKGAr6inU92ihrFk3R5OCn5mEaZ6JUN8Fbcx4dnMQtYd/ksB9My6WZ9HoD9FmvHaIMRvsKzG5w3tYWl4j2SbK8RN04Oi
 Sne0wl6t8AKymk/CoyPwzD9oNgrfvsZu0G8JzwomJwNNC2c/BaPZoc/qhiAF6xJv+Vu0zKzQGIunb04KJl/a4AA3uEjik/Pdl+LYLMQnjL6JP+pq3YNwT2mW
 HOAoMbRqsrYV2nt71qQIt4SsCWMxYg==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/27/2021 8:47 AM, Namjae Jeon wrote:
> Although ksmbd doesn't send SMB2.0 support in supported dialect list of smb
> negotiate response, There is the leftover of smb2.0 dialect.
> This patch remove it not to support SMB2.0 in ksmbd.
> 
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph Böhme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/ksmbd/smb2ops.c    |  5 -----
>   fs/ksmbd/smb2pdu.c    | 15 ++++-----------
>   fs/ksmbd/smb2pdu.h    |  1 -
>   fs/ksmbd/smb_common.c |  4 ++--
>   4 files changed, 6 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/ksmbd/smb2ops.c b/fs/ksmbd/smb2ops.c
> index 197473871aa4..b06456eb587b 100644
> --- a/fs/ksmbd/smb2ops.c
> +++ b/fs/ksmbd/smb2ops.c
> @@ -187,11 +187,6 @@ static struct smb_version_cmds smb2_0_server_cmds[NUMBER_OF_SMB2_COMMANDS] = {
>   	[SMB2_CHANGE_NOTIFY_HE]	=	{ .proc = smb2_notify},
>   };
>   
> -int init_smb2_0_server(struct ksmbd_conn *conn)
> -{
> -	return -EOPNOTSUPP;
> -}
> -
>   /**
>    * init_smb2_1_server() - initialize a smb server connection with smb2.1
>    *			command dispatcher
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 88e94a8e4a15..b7d0406d1a14 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -236,7 +236,7 @@ int init_smb2_neg_rsp(struct ksmbd_work *work)
>   
>   	if (conn->need_neg == false)
>   		return -EINVAL;
> -	if (!(conn->dialect >= SMB20_PROT_ID &&
> +	if (!(conn->dialect >= SMB21_PROT_ID &&
>   	      conn->dialect <= SMB311_PROT_ID))
>   		return -EINVAL;

This would accept any in-between value! That, um, would be bad.

This needs to be a much stronger check, especially since significant
state is being built in the lines that follow this segment.


> @@ -1166,13 +1166,6 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
>   	case SMB21_PROT_ID:
>   		init_smb2_1_server(conn);
>   		break;
> -	case SMB20_PROT_ID:
> -		rc = init_smb2_0_server(conn);
> -		if (rc) {
> -			rsp->hdr.Status = STATUS_NOT_SUPPORTED;
> -			goto err_out;
> -		}
> -		break;
>   	case SMB2X_PROT_ID:
>   	case BAD_PROT_ID:
>   	default:
> @@ -1191,7 +1184,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
>   	rsp->MaxReadSize = cpu_to_le32(conn->vals->max_read_size);
>   	rsp->MaxWriteSize = cpu_to_le32(conn->vals->max_write_size);
>   
> -	if (conn->dialect > SMB20_PROT_ID) {
> +	if (conn->dialect >= SMB21_PROT_ID) {
>   		memcpy(conn->ClientGUID, req->ClientGUID,
>   		       SMB2_CLIENT_GUID_SIZE);

If SMB2.1 is now the minimum supported dialect, why is this GUID
insertion made conditional?

>   		conn->cli_sec_mode = le16_to_cpu(req->SecurityMode);
> @@ -1537,7 +1530,7 @@ static int ntlm_authenticate(struct ksmbd_work *work)
>   		}
>   	}
>   
> -	if (conn->dialect > SMB20_PROT_ID) {
> +	if (conn->dialect >= SMB21_PROT_ID) {
>   		if (!ksmbd_conn_lookup_dialect(conn)) {
>   			pr_err("fail to verify the dialect\n");
>   			return -ENOENT;

Why is verifying the dialect *ever* conditional on the dialect value???

> @@ -1623,7 +1616,7 @@ static int krb5_authenticate(struct ksmbd_work *work)
>   		}
>   	}
>   
> -	if (conn->dialect > SMB20_PROT_ID) {
> +	if (conn->dialect >= SMB21_PROT_ID) {
>   		if (!ksmbd_conn_lookup_dialect(conn)) {
>   			pr_err("fail to verify the dialect\n");
>   			return -ENOENT;

Ditto previous comment.

> diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
> index 261825d06391..a6dec5ec6a54 100644
> --- a/fs/ksmbd/smb2pdu.h
> +++ b/fs/ksmbd/smb2pdu.h
> @@ -1637,7 +1637,6 @@ struct smb2_posix_info {
>   } __packed;
>   
>   /* functions */
> -int init_smb2_0_server(struct ksmbd_conn *conn);
>   void init_smb2_1_server(struct ksmbd_conn *conn);
>   void init_smb3_0_server(struct ksmbd_conn *conn);
>   void init_smb3_02_server(struct ksmbd_conn *conn);
> diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
> index b6c4c7e960fa..435ca8df590b 100644
> --- a/fs/ksmbd/smb_common.c
> +++ b/fs/ksmbd/smb_common.c
> @@ -88,7 +88,7 @@ unsigned int ksmbd_server_side_copy_max_total_size(void)
>   
>   inline int ksmbd_min_protocol(void)
>   {
> -	return SMB2_PROT;
> +	return SMB21_PROT;
>   }
>   
>   inline int ksmbd_max_protocol(void)
> @@ -427,7 +427,7 @@ int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
>   
>   static int __smb2_negotiate(struct ksmbd_conn *conn)
>   {
> -	return (conn->dialect >= SMB20_PROT_ID &&
> +	return (conn->dialect >= SMB21_PROT_ID &&
>   		conn->dialect <= SMB311_PROT_ID);
>   }

Ditto previous comment. And after fixing it, why is this helper not used
everywhere?

Tom.
