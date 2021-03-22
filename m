Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2461C433C1
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 14:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50A296197F
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 14:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhCVOv3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Mar 2021 10:51:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53714 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbhCVOu4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Mar 2021 10:50:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MEdSp4008512;
        Mon, 22 Mar 2021 14:50:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=BphrJzlt3qRSdUhRnJzfY4j/0pk3zpIfS3ewWk7W9z0=;
 b=aT2sBQ1fE1xHacFJoa169R+0TWmWFb/Lxv6Y9+d33mKiRlNWN5q/4L6zcskJFbNOyMe/
 XxuQ/nl/40KWFBjK7SQJ4U2ruRpqMvU8IeKhtqKsmxeXypAmBxnHXstDWW3o31oAoCd/
 G8coKZiZz6fTOZz6yxMLJxRG//XCet6Sh+ib3u2WeztZ7AkQCmXF75QYifUZZIPZdoBm
 AU17wSBhyXez4JmRHHrlx08U8eiNzTFt8UxdlhN0sVVG5QgfIrKZUQIxtptWob8/aNMA
 FH9NyBZ3+O1Xw0a0bkphp4NfadWTmQtBMwJ4IiEHT4DKb8nCYoXQGfY1IQUaQzD5anNL Aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37d90mbqsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 14:50:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MEf51C145746;
        Mon, 22 Mar 2021 14:50:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 37dtmna0cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 14:50:22 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 12MEoIx4014232;
        Mon, 22 Mar 2021 14:50:19 GMT
Received: from mwanda (/10.175.191.120)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 22 Mar 2021 07:50:18 -0700
Date:   Mon, 22 Mar 2021 17:50:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org,
        linux-cifsd-devel@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] cifsd: Fix an error code in smb2_read()
Message-ID: <YFiuo53u7GHg7cU5@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=975 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220108
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=949 suspectscore=0 clxscore=1011 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220108
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This code is assigning the wrong variable to "err" so it returns
zero/success instead of -ENOMEM.

Fixes: 788b6f45c1d2 ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/cifsd/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifsd/smb2pdu.c b/fs/cifsd/smb2pdu.c
index 32816baa8a99..6770ebedc24a 100644
--- a/fs/cifsd/smb2pdu.c
+++ b/fs/cifsd/smb2pdu.c
@@ -6200,7 +6200,7 @@ int smb2_read(struct ksmbd_work *work)
 		work->aux_payload_buf = ksmbd_alloc_response(length);
 	}
 	if (!work->aux_payload_buf) {
-		err = nbytes;
+		err = -ENOMEM;
 		goto out;
 	}
 
-- 
2.30.2

