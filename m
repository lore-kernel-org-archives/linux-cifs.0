Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263C0C433DB
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 03:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBA3464DDB
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 03:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhBBDtQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Feb 2021 22:49:16 -0500
Received: from p3plsmtpa08-06.prod.phx3.secureserver.net ([173.201.193.107]:39287
        "EHLO p3plsmtpa08-06.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229677AbhBBDtP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Feb 2021 22:49:15 -0500
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Feb 2021 22:49:15 EST
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id 6mXQlaHCvyy0q6mXRlLQC6; Mon, 01 Feb 2021 20:39:37 -0700
X-CMAE-Analysis: v=2.4 cv=AskrYMxP c=1 sm=1 tr=0 ts=6018c979
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=yMhMjlubAAAA:8 a=7Jr-j7xVvhaDlciuaIMA:9
 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH] CIFS: Wait for credits if at least one request is in
 flight
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org
References: <20210202010105.236700-1-pshilov@microsoft.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <40f473ff-bdd5-059c-36f1-d181eaa71200@talpey.com>
Date:   Mon, 1 Feb 2021 22:39:37 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20210202010105.236700-1-pshilov@microsoft.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfDzuO96CXOErBaJegBjpBb7jt7DBUleZ04W0hZYyEbDYS5tGs17H4I13tNfPMsoQgNZSzagtIWAVb2tQl6HHD84HYzFUTrmXjetm9tip8IqvuW59gGtW
 cKhb0LMsA8d1dJjo4xapXWmg9+/oT3G+XFA/vyXnr/3/H2HZu5T+zPvopsDXzBuQGHCmsnuNMxfqAhQkm+6tXuWfGMFbPgEiBQVq29q+bHbzyyX9gsZOpqUP
 qW3TUQGd0L2HY6+G8aA8RMmIzUTNvWOX5USdYDv2dAs2t/fyde1CJp0JeRnWP+o69SdBjt9O/aFXBmZdR2rCPw==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It's reasonable to fail a request that can never have sufficient
credits to send, but EOPNOTSUPP is a really strange error to return.
The operation might work if the payload were smaller, right? So,
would a resource error such as EDEADLK be more meaningful, and allow
the caller to recover, even?

Also, can you elaborate on why this is only triggered when no
requests at all are in flight? Or is this some kind of corner
case for requests that need every credit the server currently
is offering?

Tom.

On 2/1/2021 8:01 PM, Pavel Shilovsky wrote:
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
>   fs/cifs/transport.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 4ffbf8f965814..84f33fdd1f4e0 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -659,10 +659,10 @@ wait_for_compound_request(struct TCP_Server_Info *server, int num,
>   	spin_lock(&server->req_lock);
>   	if (*credits < num) {
>   		/*
> -		 * Return immediately if not too many requests in flight since
> -		 * we will likely be stuck on waiting for credits.
> +		 * Return immediately if no requests in flight since
> +		 * we will be stuck on waiting for credits.
>   		 */
> -		if (server->in_flight < num - *credits) {
> +		if (server->in_flight == 0) {
>   			spin_unlock(&server->req_lock);
>   			return -ENOTSUPP;
>   		}
> 
