Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A1BC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 15:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11D2660E9B
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 15:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242113AbhIWPz4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 11:55:56 -0400
Received: from p3plsmtpa06-02.prod.phx3.secureserver.net ([173.201.192.103]:49149
        "EHLO p3plsmtpa06-02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242068AbhIWPz4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 23 Sep 2021 11:55:56 -0400
Received: from [192.168.0.100] ([173.76.240.186])
        by :SMTPAUTH: with ESMTPSA
        id TR3Hm1zpgxUE6TR3ImVV9e; Thu, 23 Sep 2021 08:54:24 -0700
X-CMAE-Analysis: v=2.4 cv=XJz19StE c=1 sm=1 tr=0 ts=614ca330
 a=jWrLioA5F7WmVvax94MGYQ==:117 a=jWrLioA5F7WmVvax94MGYQ==:17
 a=IkcTkHD0fZMA:10 a=SEc3moZ4AAAA:8 a=pGLkceISAAAA:8 a=hGzw-44bAAAA:8
 a=VwQbUJbxAAAA:8 a=VDGbyG1OHAyS6fn1LnYA:9 a=QEXdDO2ut3YA:10
 a=5oRCH6oROnRZc2VpWJZ3:22 a=HvKuF1_PTVFglORKqfwH:22 a=AjGcO6oz07-iQ99wixmX:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH v3] ksmbd: add validation in smb2 negotiate
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Ralph_B=c3=b6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>
References: <20210923034855.612832-1-linkinjeon@kernel.org>
 <20210923034855.612832-3-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <62d23460-aba4-9978-5fe7-ce907ca49d00@talpey.com>
Date:   Thu, 23 Sep 2021 11:54:24 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210923034855.612832-3-linkinjeon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfON5dDEs19gq82eaJ6T1sw/o61vEe6xmjR6WBz6ZWeTOeeIxZN2y0tgG2VHd7kc5xjY9TfXwB0WHbykjCizmnG74/2GCFUPPsiMgC61yiHOW8/4ktAzg
 5Z3HlzokJZWKu66qQqSXLtOEsrwgIxgtsNVz8yvsqQs2Z3wcfC8VOOH82FQBn3ghLfzHebgOJAM0BRaYc4AoNUeYHjleHY4Slz+T27/63t+IExr1wwmWAGgi
 FArNqvx62lDuXEUTvNgPin1kJ2AMnirvPAHA0MbyQc24vb+KNRa2f5lDSspz831MJgQOg9J6/pARa/E/Xe1WHg==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/22/2021 11:48 PM, Namjae Jeon wrote:
> This patch add validation to check request buffer check in smb2
> negotiate.
> 
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph Böhme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   v3:
>    - fix integer(nego_ctxt_off) overflow issue.
>    - change data type of variables to unsigned.
> 
>   fs/ksmbd/smb2pdu.c    | 40 ++++++++++++++++++++++++++++++++++++++++
>   fs/ksmbd/smb_common.c | 22 ++++++++++++++++++++--
>   2 files changed, 60 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 301558a04298..2f9719a3f089 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -1080,6 +1080,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
>   	struct smb2_negotiate_req *req = work->request_buf;
>   	struct smb2_negotiate_rsp *rsp = work->response_buf;
>   	int rc = 0;
> +	unsigned int smb2_buf_len, smb2_neg_size;
>   	__le32 status;
>   
>   	ksmbd_debug(SMB, "Received negotiate request\n");
> @@ -1097,6 +1098,45 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
>   		goto err_out;
>   	}
>   
> +	smb2_buf_len = get_rfc1002_len(work->request_buf);

Where is it validated that the pdu actually contains the number
of bytes in the DirectTCP header?

Honestly I don't understand why the 4 bytes are passed around at all.
Normally I would expect these to be stripped off after validation by
the lower-layer receive processing. This would simplify the gazillion
"- 4" corrections all over the code, too.

> +	smb2_neg_size = offsetof(struct smb2_negotiate_req, Dialects) - 4;
> +	if (conn->dialect == SMB311_PROT_ID) {
> +		unsigned int nego_ctxt_off = le32_to_cpu(req->NegotiateContextOffset);
> +		unsigned int nego_ctxt_count = le16_to_cpu(req->NegotiateContextCount);
> +
> +		if (smb2_buf_len < (u64)nego_ctxt_off + nego_ctxt_count) {

This seems to be wrong. nego_ctxt_off is the base offset, but the
nego_ctxt_count is the number, not the length of the contexts!

> +			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
> +			rc = -EINVAL;
> +			goto err_out;
> +		}
> +
> +		if (smb2_neg_size > nego_ctxt_off) {

Isn't this completely redundant with the next test?

> +			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
> +			rc = -EINVAL;
> +			goto err_out;
> +		}
> +
> +		if (smb2_neg_size + le16_to_cpu(req->DialectCount) * sizeof(__le16) >
> +		    nego_ctxt_off) {

This validates that all the dialects are present, but it does not
account for the padding and negotiate contexts fields which follow
them.

> +			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
> +			rc = -EINVAL;
> +			goto err_out;
> +		}
> +	} else {
> +		if (smb2_neg_size > smb2_buf_len) {
> +			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
> +			rc = -EINVAL;
> +			goto err_out;
> +		}
> +
> +		if (smb2_neg_size + le16_to_cpu(req->DialectCount) * sizeof(__le16) >
> +		    smb2_buf_len) {

Same connects as the 3.1.1 validation above.

> +			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
> +			rc = -EINVAL;
> +			goto err_out;
> +		}
> +	}
> +
>   	conn->cli_cap = le32_to_cpu(req->Capabilities);
>   	switch (conn->dialect) {
>   	case SMB311_PROT_ID:
> diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
> index ebc835ab414c..02fe2a06dda9 100644
> --- a/fs/ksmbd/smb_common.c
> +++ b/fs/ksmbd/smb_common.c
> @@ -235,13 +235,22 @@ int ksmbd_lookup_dialect_by_id(__le16 *cli_dialects, __le16 dialects_count)
>   
>   static int ksmbd_negotiate_smb_dialect(void *buf)
>   {
> -	__le32 proto;
> +	int smb_buf_length = get_rfc1002_len(buf);

Same comments as above on length field and passed buffer size.

> +	__le32 proto = ((struct smb2_hdr *)buf)->ProtocolId;
>   
> -	proto = ((struct smb2_hdr *)buf)->ProtocolId;
>   	if (proto == SMB2_PROTO_NUMBER) {
>   		struct smb2_negotiate_req *req;
> +		int smb2_neg_size =
> +			offsetof(struct smb2_negotiate_req, Dialects) - 4;
>   
>   		req = (struct smb2_negotiate_req *)buf;
> +		if (smb2_neg_size > smb_buf_length)
> +			goto err_out;

What is this test protecting? neg_size is the length of the pdu *before*
the Dialects field.

> +
> +		if (smb2_neg_size + le16_to_cpu(req->DialectCount) * sizeof(__le16) >
> +		    smb_buf_length)
> +			goto err_out;
> +
>   		return ksmbd_lookup_dialect_by_id(req->Dialects,
>   						  req->DialectCount);
>   	}
> @@ -251,10 +260,19 @@ static int ksmbd_negotiate_smb_dialect(void *buf)
>   		struct smb_negotiate_req *req;
>   
>   		req = (struct smb_negotiate_req *)buf;
> +		if (le16_to_cpu(req->ByteCount) < 2)
> +			goto err_out;

So, this is SMB1-style negotiation, and it's very unclear if the
ByteCount is being checked for overflow. The code in mainline is
very different, and it's not clear what this patch applies to.

> +
> +		if (offsetof(struct smb_negotiate_req, DialectsArray) - 4 +
> +			le16_to_cpu(req->ByteCount) > smb_buf_length) {
> +			goto err_out;
> +		}
> +
>   		return ksmbd_lookup_dialect_by_name(req->DialectsArray,
>   						    req->ByteCount);
>   	}
>   
> +err_out:
>   	return BAD_PROT_ID;
>   }
>   
> 
