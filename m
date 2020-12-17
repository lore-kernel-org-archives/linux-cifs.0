Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38375C4361B
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 11:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCE022389B
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 11:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgLQLD0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Dec 2020 06:03:26 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40676 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbgLQLDY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Dec 2020 06:03:24 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BHAxrmr142184;
        Thu, 17 Dec 2020 11:02:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=L3aGYrlGeo3eT6PpjNqyTbmWD+46i7QX5RYLQI6tFXo=;
 b=Mffd3LLUfyTaTJfrCowPMeqSxUXq0stihiQJYoclk7ZqpIFTVNwf4/UYAl+5wpbnyC7u
 TV/+FeZ4X8gbGM/sXiFKuz5eNvexQNDcBXFY8xpOviKS3JwyEvXI6hsUXIkB/mabhA4E
 9v5a+Owowjo+8Q98j8SFzlcvQo4flWerwMoYZFewLA/bSBDJ4k4NW/nvrRpKOQfMxMtA
 t+c/o4bucfGl9xCTjechnOjuiBYZJu1o8XFE7GuzGAUHe7iIwCgTbqmC19i71LCiRIE1
 DgyiuGZMaQmj56PtP1h1lGr0xAudqP8ftgmpwxgImx4XSHRXvRTIZkwTSXJkli1UeEKy Fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35cntmcsw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 11:02:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BHB1D4i128891;
        Thu, 17 Dec 2020 11:02:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35e6et4ynk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 11:02:00 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BHB1u7I011570;
        Thu, 17 Dec 2020 11:01:56 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 03:01:55 -0800
Date:   Thu, 17 Dec 2020 14:01:48 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Steve French <sfrench@samba.org>
Cc:     Aurelien Aptel <aaptel@suse.com>,
        Samuel Cabrero <scabrero@suse.de>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/3] cifs: Delete a stray unlock in cifs_swn_reconnect()
Message-ID: <X9s6nGDLt4xreaYN@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170080
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The unlock is done in the caller, this is a stray which leads to a
double unlock bug.

Fixes: bf80e5d4259a ("cifs: Send witness register and unregister commands to userspace daemon")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/cifs/cifs_swn.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
index c594e588a8b5..b2ef082d6438 100644
--- a/fs/cifs/cifs_swn.c
+++ b/fs/cifs/cifs_swn.c
@@ -285,8 +285,6 @@ static struct cifs_swn_reg *cifs_find_swn_reg(struct cifs_tcon *tcon)
 			continue;
 		}
 
-		mutex_unlock(&cifs_swnreg_idr_mutex);
-
 		cifs_dbg(FYI, "Existing swn registration for %s:%s found\n", swnreg->net_name,
 				swnreg->share_name);
 
-- 
2.29.2

