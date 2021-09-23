Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A71A4C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 15:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D1D061029
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 15:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241951AbhIWPP3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 11:15:29 -0400
Received: from p3plsmtpa06-04.prod.phx3.secureserver.net ([173.201.192.105]:40594
        "EHLO p3plsmtpa06-04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241885AbhIWPP2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 23 Sep 2021 11:15:28 -0400
Received: from [192.168.0.100] ([173.76.240.186])
        by :SMTPAUTH: with ESMTPSA
        id TQQ7mBiQP6W5qTQQ8mi6qp; Thu, 23 Sep 2021 08:13:57 -0700
X-CMAE-Analysis: v=2.4 cv=DLRKXwBb c=1 sm=1 tr=0 ts=614c99b5
 a=jWrLioA5F7WmVvax94MGYQ==:117 a=jWrLioA5F7WmVvax94MGYQ==:17
 a=IkcTkHD0fZMA:10 a=SEc3moZ4AAAA:8 a=pGLkceISAAAA:8 a=hGzw-44bAAAA:8
 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=NlN4swWLh48WlBNCmK8A:9 a=QEXdDO2ut3YA:10
 a=5oRCH6oROnRZc2VpWJZ3:22 a=HvKuF1_PTVFglORKqfwH:22 a=AjGcO6oz07-iQ99wixmX:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH v4] ksmbd: fix invalid request buffer access in compound
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Ralph_B=c3=b6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
References: <20210923034855.612832-1-linkinjeon@kernel.org>
 <20210923034855.612832-2-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <e8c75bd8-a8ef-a040-843a-a05bb8c3746e@talpey.com>
Date:   Thu, 23 Sep 2021 11:13:56 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210923034855.612832-2-linkinjeon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfHNwBLM+cIbdtwpZtGqL5IRunefWIeNkS5n6lO7PbkuhFOyYeMq0jt1CiA4a6vb9o8Mr7Gdu3gHe44OWIoeNV0YP4VAPGa/clT/w1Ck4ygci+BlyI8Gk
 gm4TsZnhKavKCTPMF7ayF65XpsVGVdvmo9vSee3W7OLztTLRWOQOWpq+5C4iZgVHRf7Q5+58n6aep/yrBuDLnPDMLEc5pPrQmMC4VRHASrq03xYiIfLYJZ9E
 5fCzDQnCzw6F20toGu9scRu+ivk1puNlQaSmvBi6KL+r4R6zUlpwx9LIVjOWoNAPnTG9V0uFyV/nwi5blVp4veoXMOmoWWAqP04V9iX6uqyXQQfOixJe0F4k
 RHU1nEsI
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/22/2021 11:48 PM, Namjae Jeon wrote:
> Ronnie reported invalid request buffer access in chained command when
> inserting garbage value to NextCommand of compound request.
> This patch add validation check to avoid this issue.
> 
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph Böhme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>    v2:
>     - fix integer overflow from work->next_smb2_rcv_hdr_off.
>    v3:
>     - check next command offset and at least header size of next pdu at
>       the same time.
>    v4:
>     - add next_cmd variable not to avoid repeat conversion.
> 
>   fs/ksmbd/smb2pdu.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 90f867b9d560..301558a04298 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -459,13 +459,21 @@ static void init_chained_smb2_rsp(struct ksmbd_work *work)
>   bool is_chained_smb2_message(struct ksmbd_work *work)
>   {
>   	struct smb2_hdr *hdr = work->request_buf;
> -	unsigned int len;
> +	unsigned int len, next_cmd;
>   
>   	if (hdr->ProtocolId != SMB2_PROTO_NUMBER)
>   		return false;
>   
>   	hdr = ksmbd_req_buf_next(work);
> -	if (le32_to_cpu(hdr->NextCommand) > 0) {
> +	next_cmd = le32_to_cpu(hdr->NextCommand);
> +	if (next_cmd > 0) {
> +		if ((u64)work->next_smb2_rcv_hdr_off + next_cmd + 64 >

The "64" is somewhat arbitrary and mysterious. Is this the size
of the next command smb2_hdr? Why not code that, at least with
a #define?

> +		    get_rfc1002_len(work->request_buf)) {
> +			pr_err("next command(%u) offset exceeds smb msg size\n",
> +			       next_cmd);
> +			return false;
> +		}

Hmm, well the header fits in the reminder of the message. What
about the rest of the nextcommand smb2 request? It seems very
odd, and more than a little risky, to be validating only one
aspect of the nextcommand here.

> +
>   		ksmbd_debug(SMB, "got SMB2 chained command\n");

This, to me, is entirely needless debug splat.

Tom.

>   		init_chained_smb2_rsp(work);
>   		return true;
> 
