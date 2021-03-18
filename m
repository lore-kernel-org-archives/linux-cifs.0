Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CFA5C433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 13:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFED764EED
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 13:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhCRNK5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Mar 2021 09:10:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38202 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbhCRNKl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Mar 2021 09:10:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12ID4fWk066024;
        Thu, 18 Mar 2021 13:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=5/uZvzbxmqehge0T8yaELmVoLsV8KJrdXcFlaUfC5/g=;
 b=aVxWSNr1/SCKOeIrN9/h2e3szbzo5zDGDPU46FmVO/hLmXVHIIYmutwnCt0rWLOFNOU0
 GMqbgwy8krp56DnKMzCONXReCaVfCA91Lmfg50YGp6kExGDjaoa7so1/T5pzVp9C7lxZ
 walXfXyAEEFZ65/myzSDHd0VesPtZaJHs7cUgobXKF/Pru05Up7ImKUERGk4vnTuscqM
 N8weFqgrch7l3ZacMx5dobsJ55NvXmwzn2eQzrsAVH44KXIhBYsLpt87D5dtG1uQIJKo
 KPEv5Fen51QmJiFIWcyNcuI+4pb6aO/b0ok+juB834L5M6O9qh5afMfBYai2EqXxR+h4 nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37a4ekvbwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 13:10:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12ID4mmW032780;
        Thu, 18 Mar 2021 13:10:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3796yw67uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 13:10:31 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 12IDAUAm032130;
        Thu, 18 Mar 2021 13:10:30 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Mar 2021 06:10:29 -0700
Date:   Thu, 18 Mar 2021 16:10:21 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] cifsd: fix a precedence bug in parse_dacl()
Message-ID: <YFNRPcVUXZ3EiEXN@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180097
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180097
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The shift has higher precedence than mask so this doesn't work as
intended.

Fixes: ef24dca82789 ("cifsd: add support for ACLs")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/cifsd/smbacl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifsd/smbacl.c b/fs/cifsd/smbacl.c
index 8d8360ca4751..294c5a8fe9af 100644
--- a/fs/cifsd/smbacl.c
+++ b/fs/cifsd/smbacl.c
@@ -520,7 +520,7 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 			fattr->cf_gid;
 		acl_state.groups->aces[acl_state.groups->n++].perms.allow =
 			(mode & 0070) >> 3;
-		default_acl_state.group.allow = mode & 0070 >> 3;
+		default_acl_state.group.allow = (mode & 0070) >> 3;
 		default_acl_state.groups->aces[default_acl_state.groups->n].gid =
 			fattr->cf_gid;
 		default_acl_state.groups->aces[default_acl_state.groups->n++].perms.allow =
-- 
2.30.2

