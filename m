Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1FEC433E0
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 21:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6056464F64
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 21:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhBBVhv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Feb 2021 16:37:51 -0500
Received: from p3plsmtpa08-04.prod.phx3.secureserver.net ([173.201.193.105]:56866
        "EHLO p3plsmtpa08-04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232714AbhBBVhq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Feb 2021 16:37:46 -0500
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id 73M3lEkf6vsua73M4lnQGi; Tue, 02 Feb 2021 14:37:00 -0700
X-CMAE-Analysis: v=2.4 cv=Utami88B c=1 sm=1 tr=0 ts=6019c5fc
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=SEc3moZ4AAAA:8 a=VwQbUJbxAAAA:8 a=yMhMjlubAAAA:8
 a=pQOXfVJmrLl1FB3vXBYA:9 a=QEXdDO2ut3YA:10 a=5oRCH6oROnRZc2VpWJZ3:22
 a=AjGcO6oz07-iQ99wixmX:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH v2] CIFS: Wait for credits if at least one request is in
 flight
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org
References: <20210202195538.243256-1-pshilov@microsoft.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <a435fcf3-2b6c-1697-5efa-78b3617729a4@talpey.com>
Date:   Tue, 2 Feb 2021 16:37:01 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20210202195538.243256-1-pshilov@microsoft.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfF8Sm8YEYbLA0aDEQ+XFvt6JWSIst/K0xgDOyAYxAPMAcMORmuOzHz+V+sF6GjCCZp74Z1t9X2/+7UHa1lUgw9ci1pap7m+y2+Gqp5ztpSsxo0XZ5MY2
 ybedDdmlNItPHVmGyqdly6ctFQD5my1f3xWQzkOizwMlnIHqwC9dzRNFnFkkdtJfz1tZWtntRAR9XYo8CdxXpKENdYrmqANU0FW/iGsfMTBmSF3OUS/wWymt
 6XkU8HWdJPaIlQPXW/g1StyySaP5eQVgiMZdZZ9VoxQtOOrA0WfmexR/UikWCWInI0r751yJ/t6kBKJ3vm35pA==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Updated comment looks good!

Reviewed-By: Tom Talpey <tom@talpey.com>

On 2/2/2021 2:55 PM, Pavel Shilovsky wrote:
> Currently we try to guess if a compound request is going to succeed
> waiting for credits or not based on the number of requests in flight.
> This approach doesn't work correctly all the time because there may
> be only one request in flight which is going to bring multiple credits
> satisfying the compound request.
> 
> Change the behavior to fail a request only if there are no requests
> in flight at all and proceed waiting for credits otherwise.
> 
> Cc: <stable@vger.kernel.org> # 5.1+
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>   fs/cifs/transport.c | 18 +++++++++++++++---
>   1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 4ffbf8f965814..eab7940bfebef 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -659,10 +659,22 @@ wait_for_compound_request(struct TCP_Server_Info *server, int num,
>   	spin_lock(&server->req_lock);
>   	if (*credits < num) {
>   		/*
> -		 * Return immediately if not too many requests in flight since
> -		 * we will likely be stuck on waiting for credits.
> +		 * If the server is tight on resources or just gives us less
> +		 * credits for other reasons (e.g. requests are coming out of
> +		 * order and the server delays granting more credits until it
> +		 * processes a missing mid) and we exhausted most available
> +		 * credits there may be situations when we try to send
> +		 * a compound request but we don't have enough credits. At this
> +		 * point the client needs to decide if it should wait for
> +		 * additional credits or fail the request. If at least one
> +		 * request is in flight there is a high probability that the
> +		 * server will return enough credits to satisfy this compound
> +		 * request.
> +		 *
> +		 * Return immediately if no requests in flight since we will be
> +		 * stuck on waiting for credits.
>   		 */
> -		if (server->in_flight < num - *credits) {
> +		if (server->in_flight == 0) {
>   			spin_unlock(&server->req_lock);
>   			return -ENOTSUPP;
>   		}
> 
