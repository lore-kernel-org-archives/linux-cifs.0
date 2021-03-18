Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303BFC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 13:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC79964F04
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 13:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhCRNMd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Mar 2021 09:12:33 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50798 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbhCRNMS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Mar 2021 09:12:18 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12IDC9Ch038581;
        Thu, 18 Mar 2021 13:12:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=wyniDUSLWY+45jNq99b+hwvVrJ2X/uu/AumI1WBt8Sg=;
 b=ibEFpiFl/t4dW/NUKdqnD+jCpzAqZtX/4n31bfxMI6Gv6vA2JrL4SXsAsRqM3OmXYPUN
 Yg/eHdjMAXVP0WjK4qMQfuIPK9qOZHcvSmnhl+e2pcA0GHwumPSljFOHbh9fxovel44i
 DumYt4RpkF/bF0UY27OG1Zo0bMo/FVDhzMmqCJ9vskdMDh5fMPYzJVdk8vwGJjhHQDBX
 2kHSTiJJeMXGqi3wtVv+PB0BnfnEtsAchrE4nUnv/q4w71rWDDxOZgUTdHlti61wPpIs
 XI5uEUBldcwLDvX+D7g3BtXH4EhZd+hgJ27W3bObqEn2r3hf31y9DP84al2aoo7CVP+3 XA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 378jwbqgq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 13:12:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12ID5Y9P067517;
        Thu, 18 Mar 2021 13:12:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 37a4evsnmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 13:12:03 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 12IDC28U014690;
        Thu, 18 Mar 2021 13:12:02 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Mar 2021 06:12:02 -0700
Date:   Thu, 18 Mar 2021 16:11:52 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-cifs@vger.kernel.org
Subject: [PATCH RESEND] cifsd: fix a IS_ERR() vs NULL bug
Message-ID: <20210318131152.GB21246@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180097
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 adultscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180097
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The smb_direct_alloc_sendmsg() function never returns NULL, it only
returns error pointers so the check needs to be updated.

Fixes: cabcebc31de4 ("cifsd: introduce SMB3 kernel server")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
RESEND: Oops.  I forgot to CC linux-cifs on this.

 fs/cifsd/transport_rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifsd/transport_rdma.c b/fs/cifsd/transport_rdma.c
index 1698f7ed9c2f..638b551019a1 100644
--- a/fs/cifsd/transport_rdma.c
+++ b/fs/cifsd/transport_rdma.c
@@ -997,8 +997,8 @@ static int smb_direct_create_header(struct smb_direct_transport *t,
 	int ret;
 
 	sendmsg = smb_direct_alloc_sendmsg(t);
-	if (!sendmsg)
-		return -ENOMEM;
+	if (IS_ERR(sendmsg))
+		return PTR_ERR(sendmsg);
 
 	/* Fill in the packet header */
 	packet = (struct smb_direct_data_transfer *)sendmsg->packet;
-- 
2.30.2
