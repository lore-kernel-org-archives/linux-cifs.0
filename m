Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42DF2C433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 13:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0733364EED
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 13:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhCRNNg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Mar 2021 09:13:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49180 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbhCRNNM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Mar 2021 09:13:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12IDC9v3153476;
        Thu, 18 Mar 2021 13:13:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=+tUwRkRkP6+qKsssbeUlFdzu5XVDSTuMZvkAUVRnHI0=;
 b=Sra8zmzealkZeIUYDv8UCSXaCiMxSDv1fAcuBczmkXOiH2OTitMOgwTehdo0Ahk+II9K
 /WTX3HEfmame0j64Dswni9rzh3rniYSPs09L5zY3VYNf1xLNnCp0ODDu1A89j8a3Sp7O
 5N3pH0g2oQeHOYW84DIkVULGlFkCxR/MkoIsNctVU3OMK9ozbIiFFidRhr9n6PRPZdKD
 DBfQWAWKeNv6ANUbI7ssfAqgUmcIUFqL1+i7vQJIEl/NyCnMMdSBBh9v2anaUxYvxlkc
 z61vHo/VVfPlStQTPTRyiWj+ezeUIuKvzcIMkWaIUHAClgZGxGsL74UfCdDH+4rb2/G1 Qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 378p1nyd91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 13:13:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12ID5xbI103145;
        Thu, 18 Mar 2021 13:13:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3797a3xjwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 13:13:03 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 12IDD2td022650;
        Thu, 18 Mar 2021 13:13:02 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Mar 2021 06:13:02 -0700
Date:   Thu, 18 Mar 2021 16:12:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] cifsd: Fix a use after free on error path
Message-ID: <YFNR1sVU2mIgxNma@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180097
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=976 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180097
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The ksmbd_free_work_struct() frees "work" so we need to swap the order
of these two function calls to avoid a use after free.

Fixes: cabcebc31de4 ("cifsd: introduce SMB3 kernel server")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/cifsd/oplock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifsd/oplock.c b/fs/cifsd/oplock.c
index 6c3dbc71134e..f694c14be0df 100644
--- a/fs/cifsd/oplock.c
+++ b/fs/cifsd/oplock.c
@@ -638,8 +638,8 @@ static void __smb2_oplock_break_noti(struct work_struct *wk)
 	if (allocate_oplock_break_buf(work)) {
 		ksmbd_err("smb2_allocate_rsp_buf failed! ");
 		atomic_dec(&conn->r_count);
-		ksmbd_free_work_struct(work);
 		ksmbd_fd_put(work, fp);
+		ksmbd_free_work_struct(work);
 		return;
 	}
 
-- 
2.30.2

