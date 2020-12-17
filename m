Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57390C4361B
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 11:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 029FF2389B
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 11:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgLQLFl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Dec 2020 06:05:41 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:53654 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgLQLFk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Dec 2020 06:05:40 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BHAxjR4141451;
        Thu, 17 Dec 2020 11:04:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=xRC4jVpHdxLQkf9px8Ti9VtraTS7I2ccryuXWmBV4hI=;
 b=Q7KZBjLSWNaOJ/eIA8D/iEn0ds94UUcc0rK0QW2ZDl1fdVl6lQ39lZ22pDu6V8sxwRwW
 yJVKARUBnaF+kEMtSyvoqWll6N0xvRmdZHrqsHApcEYycvqnXM047cLro3FbZKpC8P4W
 XNANQ47uHXrpKXEE9/xWSafsOJhZdAL4Zht0TdGACPP+6t3Xq40Dww+wj3Qpt5uP5uln
 8UO/Xu4dI8aV+eTN8rI19p22AMCzIlAFBxcQLhJkyVdSDGuYor5VIgJHQOFMw/ppHZMp
 EX5fLdfdQGg80MoW1/uBtq3mcOX/XNAdvPNsHrzRNDfbZlQ2bW2qDMmE8vAOussd89Ix 4w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35ckcbn0jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 11:04:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BHB1Flo096292;
        Thu, 17 Dec 2020 11:02:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35g3redt8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 11:02:36 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BHB2ZE4011866;
        Thu, 17 Dec 2020 11:02:35 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 03:02:35 -0800
Date:   Thu, 17 Dec 2020 14:02:29 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Steve French <sfrench@samba.org>, Samuel Cabrero <scabrero@suse.de>
Cc:     Aurelien Aptel <aaptel@suse.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] cifs: Unlock on errors in cifs_swn_reconnect()
Message-ID: <X9s6xZZISL/SRoZm@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9s6nGDLt4xreaYN@mwanda>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170080
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There are three error paths which need to unlock before returning.

Fixes: 121d947d4fe1 ("cifs: Handle witness client move notification")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/cifs/cifs_swn.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
index b2ef082d6438..91163d3cf8b7 100644
--- a/fs/cifs/cifs_swn.c
+++ b/fs/cifs/cifs_swn.c
@@ -480,16 +480,16 @@ static int cifs_swn_store_swn_addr(const struct sockaddr_storage *new,
 
 static int cifs_swn_reconnect(struct cifs_tcon *tcon, struct sockaddr_storage *addr)
 {
+	int ret = 0;
+
 	/* Store the reconnect address */
 	mutex_lock(&tcon->ses->server->srv_mutex);
 	if (!cifs_sockaddr_equal(&tcon->ses->server->dstaddr, addr)) {
-		int ret;
-
 		ret = cifs_swn_store_swn_addr(addr, &tcon->ses->server->dstaddr,
 				&tcon->ses->server->swn_dstaddr);
 		if (ret < 0) {
 			cifs_dbg(VFS, "%s: failed to store address: %d\n", __func__, ret);
-			return ret;
+			goto unlock;
 		}
 		tcon->ses->server->use_swn_dstaddr = true;
 
@@ -500,7 +500,7 @@ static int cifs_swn_reconnect(struct cifs_tcon *tcon, struct sockaddr_storage *a
 		if (ret < 0) {
 			cifs_dbg(VFS, "%s: Failed to unregister for witness notifications: %d\n",
 					__func__, ret);
-			return ret;
+			goto unlock;
 		}
 
 		/*
@@ -511,7 +511,7 @@ static int cifs_swn_reconnect(struct cifs_tcon *tcon, struct sockaddr_storage *a
 		if (ret < 0) {
 			cifs_dbg(VFS, "%s: Failed to register for witness notifications: %d\n",
 					__func__, ret);
-			return ret;
+			goto unlock;
 		}
 
 		spin_lock(&GlobalMid_Lock);
@@ -519,9 +519,10 @@ static int cifs_swn_reconnect(struct cifs_tcon *tcon, struct sockaddr_storage *a
 			tcon->ses->server->tcpStatus = CifsNeedReconnect;
 		spin_unlock(&GlobalMid_Lock);
 	}
+unlock:
 	mutex_unlock(&tcon->ses->server->srv_mutex);
 
-	return 0;
+	return ret;
 }
 
 static int cifs_swn_client_move(struct cifs_swn_reg *swnreg, struct sockaddr_storage *addr)
-- 
2.29.2

