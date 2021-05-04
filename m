Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 163BAC433ED
	for <linux-cifs@archiver.kernel.org>; Tue,  4 May 2021 13:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6196610A0
	for <linux-cifs@archiver.kernel.org>; Tue,  4 May 2021 13:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhEDNrl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 May 2021 09:47:41 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45610 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbhEDNrj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 May 2021 09:47:39 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 144DdSbh170143;
        Tue, 4 May 2021 13:46:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qax4kFS52O+5Ogi0OjJfY41ys+uMhtGCBa/bfkovZF4=;
 b=PhJWRyf6JdXXXkAPbiO6tzH7k5sDToxDnZQC9XBGvzjMFXGoaO53vyKIuOLK+zpiXujb
 UgoTOGmc1bHSyt1+30Hq5+BCvwMhy4/eclR3GUHaMK29mZLZqCVv86jwzHMaZ5PkN/Gg
 TS7i9Xy3rLiiwZDyBhdKoxRbn6aRBJ7bO+Fpik76mHEnkuoXb6kQh/JgpD/2AI/n3ATt
 Xca3LvLl7LV/WtLcO7mhd7jVV94b7rKxQl8K+92+mKuc2K3HxU6ZsQcxtR64FhiLpLZZ
 WqGkIMQ02V6strBKSPhL74mSARl1M0z+P97bZFJQOwCJTs0rPQifSt6Ke3JwtZ07zden +w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 388vgbq3bv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 May 2021 13:46:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 144DjOMr022173;
        Tue, 4 May 2021 13:46:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 388w1e2mtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 May 2021 13:46:21 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 144DkK7C027415;
        Tue, 4 May 2021 13:46:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 388w1e2mta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 May 2021 13:46:20 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 144DkGYn024650;
        Tue, 4 May 2021 13:46:16 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 May 2021 13:46:16 +0000
Date:   Tue, 4 May 2021 16:44:45 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Khaled ROMDHANI <khaledromdhani216@gmail.com>
Cc:     sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH-next] fs/cifs: Fix resource leak
Message-ID: <20210504134244.GW1981@kadam>
References: <20210504124343.22611-1-khaledromdhani216@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504124343.22611-1-khaledromdhani216@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: IR7c1IK6ySKxeSh7-qqEaUn_7D9ONOVD
X-Proofpoint-ORIG-GUID: IR7c1IK6ySKxeSh7-qqEaUn_7D9ONOVD
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9974 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 impostorscore=0 clxscore=1011 bulkscore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040102
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, May 04, 2021 at 01:43:43PM +0100, Khaled ROMDHANI wrote:
> The -EIO error return path is leaking memory allocated
> to page. Fix this by invoking the free_dentry_path before
> the return.
> 
> Addresses-Coverity: ("Resource leak")
> Signed-off-by: Khaled ROMDHANI <khaledromdhani216@gmail.com>

Add a Fixes tag.

Fixes: 583248493f78 ("cifs: add shutdown support")

> ---
>  fs/cifs/link.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index 1cbe7ec73728..1485c6095ba1 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -686,8 +686,10 @@ cifs_symlink(struct user_namespace *mnt_userns, struct inode *inode,
>  	void *page = alloc_dentry_path();
>  	struct inode *newinode = NULL;
>  
> -	if (unlikely(cifs_forced_shutdown(cifs_sb)))
> +	if (unlikely(cifs_forced_shutdown(cifs_sb))) {
> +		free_dentry_path(page);
>  		return -EIO;
> +	}

Better to move the allocation here.  Avoid calling functions which can
fail in the declaration block.  Better to test for NULL directly instead
of hiding the test inside the build_path_from_dentry() function.

	page = alloc_dentry_path();
	if (!page)
		return -ENOMEM;

The error handling in this function is slightly unweildy...

regards,
dan carpenter

