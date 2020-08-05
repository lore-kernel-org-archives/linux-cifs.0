Return-Path: <SRS0=uUT6=BP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBECFC433DF
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Aug 2020 09:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A86442076E
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Aug 2020 09:54:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cGr8Cb6V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgHEJyU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Aug 2020 05:54:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37084 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbgHEJxD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Aug 2020 05:53:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0759qKUc058845;
        Wed, 5 Aug 2020 09:52:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=gP37RsrMGaMF6BzssPUZ8VhQW8vT8S6L5/66gaCLThs=;
 b=cGr8Cb6VWuOPVIQ5y7FcEXR83vpJFUkHr/91b/E8gbZPo+/LvuXc6fsGM+PXPSB61fgh
 MFZJPAiJQyx/27ZdKdiVUylq+/gP+4KIbS3x/CHAFG9G3e25Bn1g7l4YbKMsm9UG8+YV
 If1FeSCNgRFRaFj7enuqwe1uJYRLZUpv8qinyaP1TchNrlWPMV25WvB4msXOX48e6F5z
 DNXLy0fdcm56vQkMUmmjPHyCKyHm9rfF4mLXR0BEqvYyuNYb6BDn/MSSZcyPEfUyOOdx
 s/AAGDIRSFMNWaDNGmpxG71e2M00cz27Rm/59DmQ1jwX4g5TXy8DISKLStQGFGqKgXYn LA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32qnd41c9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 05 Aug 2020 09:52:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0759mtDI068676;
        Wed, 5 Aug 2020 09:52:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32pdnsv8uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Aug 2020 09:52:20 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0759qFNj018545;
        Wed, 5 Aug 2020 09:52:16 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 05 Aug 2020 02:52:14 -0700
Date:   Wed, 5 Aug 2020 12:52:07 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>
Cc:     Aurelien Aptel <aaptel@suse.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] cifs: Fix an error pointer dereference in cifs_mount()
Message-ID: <20200805095207.GC483832@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050081
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 clxscore=1011 mlxscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050082
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The error handling calls kfree(full_path) so we can't let it be a NULL
pointer.  There used to be a NULL assignment here but we accidentally
deleted it.  Add it back.

Fixes: 7efd08158261 ("cifs: document and cleanup dfs mount")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/cifs/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0ad1309e88d3..a275ee399dce 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4886,6 +4886,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 		full_path = build_unc_path_to_root(vol, cifs_sb, !!count);
 		if (IS_ERR(full_path)) {
 			rc = PTR_ERR(full_path);
+			full_path = NULL;
 			break;
 		}
 		/* Chase referral */
-- 
2.27.0

