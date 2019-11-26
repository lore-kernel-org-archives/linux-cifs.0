Return-Path: <SRS0=b7Yi=ZS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E81ECC432C0
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Nov 2019 12:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB9FA2075C
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Nov 2019 12:14:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CCod7jih"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbfKZMOy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Nov 2019 07:14:54 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41654 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727400AbfKZMOy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Nov 2019 07:14:54 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAQC99jU095806;
        Tue, 26 Nov 2019 12:13:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=EjOVBkjN4rZaIHQ5WfAoCcmKy/ByYkiMTB3fcgAM/+E=;
 b=CCod7jih8IsA5jVmKCH/QME2JE79NMjMe44p4rpNtxaaYS3+OISQpRdXtU1BmQJOlfrk
 XYkCw4F4dHpE9mIjzkUlAGXMb2QpjV3KzvEJz+Eq5wIN+Cpx03bEICGLfu4MwK5ZszwA
 ztg13IuFT8jLVa/jRmAtfIdFlUC+FSrwIhyfak5448W9NX4cyZYVrSk2ejV6uJ9Xvm85
 DkDYdKWp1eBxGHcitz/wwYkE2XX8YBmhss68AG3U0gN/ZId4l2InzR0XN00r/KmhQbYa
 F/9O3TDPfSUUWvIB0ipFhKmrsEYCKcd+UK22Y6khNU3qzMd59a6nxz7QCG9Vc+mn0/T2 RQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2wewdr6a76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Nov 2019 12:13:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAQC8XDN050176;
        Tue, 26 Nov 2019 12:11:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2wgwusgp9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Nov 2019 12:11:27 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAQCBM8P001701;
        Tue, 26 Nov 2019 12:11:22 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Nov 2019 04:11:22 -0800
Date:   Tue, 26 Nov 2019 15:11:15 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Steve French <sfrench@samba.org>, Aurelien Aptel <aaptel@suse.com>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] CIFS: fix a white space issue in cifs_get_inode_info()
Message-ID: <20191126071650.c76un267i4v6vuoz@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9452 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911260110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9452 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911260110
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We accidentally messed up the indenting on this if statement.

Fixes: 16c696a6c300 ("CIFS: refactor cifs_get_inode_info()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/cifs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 1fec2e7d796a..8a76195e8a69 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -967,7 +967,8 @@ cifs_get_inode_info(struct inode **inode,
 		}
 	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
 		rc = cifs_acl_to_fattr(cifs_sb, &fattr, *inode, false,
-				       full_path, fid);		if (rc) {
+				       full_path, fid);
+		if (rc) {
 			cifs_dbg(FYI, "%s: Getting ACL failed with error: %d\n",
 				 __func__, rc);
 			goto out;
-- 
2.11.0

