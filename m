Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6DCBC49361
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Jun 2021 09:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94D75613DF
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Jun 2021 09:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhFQJ32 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Jun 2021 05:29:28 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:8872 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231252AbhFQJ30 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 17 Jun 2021 05:29:26 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15H9GckB025155;
        Thu, 17 Jun 2021 09:26:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qujzn587D0Q2bLjdZk/oxp+PqRdUi4X2qEhbIM5kU3E=;
 b=aD8L4a/vErGhdvq7FkmTwbf+487fmYxLeIyUMP3xFHmHj3ryNdUY347cWLWm9hUK9rJb
 b1H8WEnL4QxmF+DwAhZeoVUDD4p1rRvDRFJIIKndClAYVrqL2zIfbqMx1MVo/OMTLoJP
 ttCkk745Vj0+HRL3pRJJ/PTNOkqFNAXe2jIpV/bVPJLfTp4dNQkRxEXb3cPrzAUmVi2p
 qrCA542bwS85T0L9YYJ0m3wz6LQEXhe9gGeB5NfdL6yRkV0bgc90BXBTaVRP1darszNt
 aZ+Le0WW+DIKbdrS6FoS/FoWdt+Elc2zR8wkSbpmDA0vTxAeK/rwFZt5PhXR0gg9g8nb XA== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 396tr0v3wk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Jun 2021 09:26:52 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15H9QpJR039994;
        Thu, 17 Jun 2021 09:26:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 396wav5w84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Jun 2021 09:26:51 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15H9KxOA019039;
        Thu, 17 Jun 2021 09:26:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 396wav5w77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Jun 2021 09:26:50 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 15H9Qlvr010759;
        Thu, 17 Jun 2021 09:26:47 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Jun 2021 02:26:47 -0700
Date:   Thu, 17 Jun 2021 12:26:39 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     Namjae Jeon <namjae.jeon@samsung.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-cifsd-devel@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH -next] cifsd: fix WARNING: convert list_for_each to entry
 variant in smb2pdu.c
Message-ID: <20210617092639.GD1861@kadam>
References: <20210617064653.3193618-1-libaokun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617064653.3193618-1-libaokun1@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: AzCRVm5ZkCMFjj1jO_ZDIpZLa_EdIOWt
X-Proofpoint-ORIG-GUID: AzCRVm5ZkCMFjj1jO_ZDIpZLa_EdIOWt
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Jun 17, 2021 at 02:46:53PM +0800, Baokun Li wrote:
> convert list_for_each() to list_for_each_entry() where
> applicable.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
>  fs/cifsd/smb2pdu.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/cifsd/smb2pdu.c b/fs/cifsd/smb2pdu.c
> index ac15a9287310..22ef1d9eed1b 100644
> --- a/fs/cifsd/smb2pdu.c
> +++ b/fs/cifsd/smb2pdu.c
> @@ -74,10 +74,7 @@ static inline int check_session_id(struct ksmbd_conn *conn, u64 id)
>  struct channel *lookup_chann_list(struct ksmbd_session *sess)
>  {
>  	struct channel *chann;
> -	struct list_head *t;
> -
> -	list_for_each(t, &sess->ksmbd_chann_list) {
> -		chann = list_entry(t, struct channel, chann_list);
> +	list_for_each_entry(chann, &sess->ksmbd_chann_list, chann_list) {
>  		if (chann && chann->conn == sess->conn)

"chan" is the list iterator and it can't be NULL.

>  			return chann;
>  	}

regards,
dan carpenter

