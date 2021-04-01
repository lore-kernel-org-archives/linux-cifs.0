Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB5AC4363C
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 17:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 466E361285
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 17:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236612AbhDARqE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:46:04 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46362 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235015AbhDARmJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Apr 2021 13:42:09 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 131BnR05111985;
        Thu, 1 Apr 2021 11:50:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=cF1glGQAY37JEb/i1rLUVX1W7btzuvMI2ZFlYpOrYOU=;
 b=ZYxrhaQLgTSnvNkTqxoFyKhOWP4IgyecQMr63xHvgLxTEkPx0NeGX1GR+t2YQqyhjjqj
 briOkpdtYqbTjzmS45sOslVkmSoTOW+R0mn7lRMNTFQ+OUlebYgFoHTBSXriC9IqGYyg
 k/dGsb4Ig9tBg5atSfEH1Qk77jGRLdL24xuh8LfYd469MsaF0r/ypx7mwC8U73ItcmqD
 OLWzPRYIsL/HFkEJZaTQcngq/Q4SIsrri8MbzRs22tq4lLzpmXmxs7Xfg+OU/6Ja2WzU
 HUsS+HqzMYQ+732EBlEGuNpH9fUfftBavIpGvIo+Mpmr8Kv9C6ztZULSSfaJJGPanZTb BQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37n33dsdw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Apr 2021 11:50:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 131BitOK107759;
        Thu, 1 Apr 2021 11:50:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 37n2ab4h2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Apr 2021 11:50:21 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 131BoHNu012195;
        Thu, 1 Apr 2021 11:50:17 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Apr 2021 04:50:17 -0700
Date:   Thu, 1 Apr 2021 14:50:08 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Muhammad Usama Anjum <musamaanjum@gmail.com>
Cc:     Namjae Jeon <namjae.jeon@samsung.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, open list:
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifs@vger.kernel.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, colin.king@canonical.com, ;
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     ;
                        ^-missing semicolon to end mail group, extraneous tokens in mailbox, missing end of mailbox
Subject: Re: [PATCH] cifsd: use kfree to free memory allocated by kzalloc
Message-ID: <20210401115008.GS2088@kadam>
References: <20210401113933.GA2828895@LEGION>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401113933.GA2828895@LEGION>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9940 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104010083
X-Proofpoint-GUID: zZZ-IdvhmWio9h472enDEIQJoXKdk78y
X-Proofpoint-ORIG-GUID: zZZ-IdvhmWio9h472enDEIQJoXKdk78y
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9940 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104010084
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Apr 01, 2021 at 04:39:33PM +0500, Muhammad Usama Anjum wrote:
> kfree should be used to free memory allocated by kzalloc to avoid
> any overhead and for maintaining consistency.
> 
> Fixes: 5dfeb6d945 ("cifsd: use kmalloc() for small allocations")
> Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
> ---
> This one place was left in earlier patch. I've already received
> responsse on that patch. I'm sending a separate patch.
> 
>  fs/cifsd/transport_tcp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifsd/transport_tcp.c b/fs/cifsd/transport_tcp.c
> index 67163efcf472..040881893417 100644
> --- a/fs/cifsd/transport_tcp.c
> +++ b/fs/cifsd/transport_tcp.c
> @@ -551,7 +551,7 @@ void ksmbd_tcp_destroy(void)
>  	list_for_each_entry_safe(iface, tmp, &iface_list, entry) {
>  		list_del(&iface->entry);
>  		kfree(iface->name);
> -		ksmbd_free(iface);
> +		kfree(iface);

We should just delete the ksmbd_free() function completely.

I think that cifsd is being re-written though so it might not be worth
it.

regards,
dan carpenter
