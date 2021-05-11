Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 332C6C433B4
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 07:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F18B061925
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 07:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhEKHKG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 May 2021 03:10:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36976 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbhEKHKF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 May 2021 03:10:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B6uLlF141468;
        Tue, 11 May 2021 07:08:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=iS7UC9rHTtYFFwLnJPcCRGDCgSrpedWEk2ODRZZVD2U=;
 b=vfH1LhgTRFAJflf+YNT0nC7PdIpI7A65V4+J2AgjDJSvei/IIcxTW6ntcJLckEVp3ajd
 7ngi1bh2F1lC4qz3lC9TroghMMUQ7gL9RUcGs4acymtpz1VaDFKKecY13Cm0nagqEAqo
 ZVrCZa5yl4UCUQvrAE2eWcQJd9ICn4xQtaOYAlohBgJCJCgcCbsgp1jXL/Q/7a6b5q/L
 s942jvPkhdss3xUHnI2dvQ9fNratZjaiWkextlZOu/kM9luOxVzqpq4/6SQIwi8O+wdS
 mXojuChV8UebyPAbrOld9YD4VVLMXvrWidj+JDVTnNTRI7W0/BfmsKA7XtYSFE+onC9z RQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38djkmdmec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 07:08:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B6u0Dx190316;
        Tue, 11 May 2021 07:08:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 38fh3w8hby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 07:08:20 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14B76DrC032618;
        Tue, 11 May 2021 07:08:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 38fh3w8hb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 07:08:19 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 14B78G9Y007702;
        Tue, 11 May 2021 07:08:16 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 May 2021 07:08:16 +0000
Date:   Tue, 11 May 2021 10:08:09 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>,
        Marios Makassikis <mmakassikis@freebox.fr>
Cc:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-cifsd-devel@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] cifsd: fix an uninitialized variable in smb2_write()
Message-ID: <YJotWR/qMDIoJAcV@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: s4c_sXp0XkLh7EW1lRXzfNRS0SJ591hz
X-Proofpoint-ORIG-GUID: s4c_sXp0XkLh7EW1lRXzfNRS0SJ591hz
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 suspectscore=0 clxscore=1011 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110053
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If there is a permissions problem then the "fp" variable is used in the
"goto out;" without being initialized.  The correct fix is to initialize
"fp" to NULL which turns the ksmbd_fd_put(work, fp); call into a no-op.

Fixes: bb03a3d512bf ("cifsd: Call smb2_set_err_rsp() in smb2_read/smb2_write error path")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/cifsd/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifsd/smb2pdu.c b/fs/cifsd/smb2pdu.c
index d07d7c45f899..18de8a763209 100644
--- a/fs/cifsd/smb2pdu.c
+++ b/fs/cifsd/smb2pdu.c
@@ -6078,7 +6078,7 @@ int smb2_write(struct ksmbd_work *work)
 {
 	struct smb2_write_req *req;
 	struct smb2_write_rsp *rsp, *rsp_org;
-	struct ksmbd_file *fp;
+	struct ksmbd_file *fp = NULL;
 	loff_t offset;
 	size_t length;
 	ssize_t nbytes;
-- 
2.30.2

