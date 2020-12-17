Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B135C4361B
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 11:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D4902389B
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 11:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgLQLEw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Dec 2020 06:04:52 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:53020 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgLQLEv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Dec 2020 06:04:51 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BHAxxui141614;
        Thu, 17 Dec 2020 11:03:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=kbJZufEf+37h3Q7xTd8U457y6fbtVdHtGav3N2x+XoM=;
 b=zYVWqJoFApz4h98yLTYLZk0w7RTBENLGrmj1Jard5MD1K0lL96rEpB1aUVuHVfywW1LH
 78Cw07DS3m1p0+ysTkUJSPXxP35pAagTcl3Ped5Ts5sH970LUngfyR7VbuTak+dKbyeu
 VSnBSXQVt39oWK2PpM/xhrC6BIf/WsSePQWci2Oatq/H/92XSJJoCU7cJ1d9PvplbjjO
 n42H7lMLjNyU9OWK1jzRqxq7enX+fH7kfrBt/nGtgXHo/Q62n4J5o35K19KJnYlUlQLl
 PMAHv0DVP9AgAUl1blDJqItNq2JVgU1m+udHf8/PC01hXMCPTi6QYz9xM4/52OVretrb cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35ckcbn0fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 11:03:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BHB1DvF128849;
        Thu, 17 Dec 2020 11:03:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35e6et51m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 11:03:43 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BHB3g70012344;
        Thu, 17 Dec 2020 11:03:42 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 03:03:41 -0800
Date:   Thu, 17 Dec 2020 14:03:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Steve French <sfrench@samba.org>, Samuel Cabrero <scabrero@suse.de>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 3/3] cifs: Re-indent cifs_swn_reconnect()
Message-ID: <X9s7By4IDIcG4D+w@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9s6nGDLt4xreaYN@mwanda>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
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

This code is slightly nicer if we flip the cifs_sockaddr_equal()
around and pull all the code in one tab.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/cifs/cifs_swn.c | 64 ++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
index 91163d3cf8b7..d35f599aa00e 100644
--- a/fs/cifs/cifs_swn.c
+++ b/fs/cifs/cifs_swn.c
@@ -484,41 +484,43 @@ static int cifs_swn_reconnect(struct cifs_tcon *tcon, struct sockaddr_storage *a
 
 	/* Store the reconnect address */
 	mutex_lock(&tcon->ses->server->srv_mutex);
-	if (!cifs_sockaddr_equal(&tcon->ses->server->dstaddr, addr)) {
-		ret = cifs_swn_store_swn_addr(addr, &tcon->ses->server->dstaddr,
-				&tcon->ses->server->swn_dstaddr);
-		if (ret < 0) {
-			cifs_dbg(VFS, "%s: failed to store address: %d\n", __func__, ret);
-			goto unlock;
-		}
-		tcon->ses->server->use_swn_dstaddr = true;
+	if (cifs_sockaddr_equal(&tcon->ses->server->dstaddr, addr))
+		goto unlock;
 
-		/*
-		 * Unregister to stop receiving notifications for the old IP address.
-		 */
-		ret = cifs_swn_unregister(tcon);
-		if (ret < 0) {
-			cifs_dbg(VFS, "%s: Failed to unregister for witness notifications: %d\n",
-					__func__, ret);
-			goto unlock;
-		}
+	ret = cifs_swn_store_swn_addr(addr, &tcon->ses->server->dstaddr,
+				      &tcon->ses->server->swn_dstaddr);
+	if (ret < 0) {
+		cifs_dbg(VFS, "%s: failed to store address: %d\n", __func__, ret);
+		goto unlock;
+	}
+	tcon->ses->server->use_swn_dstaddr = true;
 
-		/*
-		 * And register to receive notifications for the new IP address now that we have
-		 * stored the new address.
-		 */
-		ret = cifs_swn_register(tcon);
-		if (ret < 0) {
-			cifs_dbg(VFS, "%s: Failed to register for witness notifications: %d\n",
-					__func__, ret);
-			goto unlock;
-		}
+	/*
+	 * Unregister to stop receiving notifications for the old IP address.
+	 */
+	ret = cifs_swn_unregister(tcon);
+	if (ret < 0) {
+		cifs_dbg(VFS, "%s: Failed to unregister for witness notifications: %d\n",
+			 __func__, ret);
+		goto unlock;
+	}
 
-		spin_lock(&GlobalMid_Lock);
-		if (tcon->ses->server->tcpStatus != CifsExiting)
-			tcon->ses->server->tcpStatus = CifsNeedReconnect;
-		spin_unlock(&GlobalMid_Lock);
+	/*
+	 * And register to receive notifications for the new IP address now that we have
+	 * stored the new address.
+	 */
+	ret = cifs_swn_register(tcon);
+	if (ret < 0) {
+		cifs_dbg(VFS, "%s: Failed to register for witness notifications: %d\n",
+			 __func__, ret);
+		goto unlock;
 	}
+
+	spin_lock(&GlobalMid_Lock);
+	if (tcon->ses->server->tcpStatus != CifsExiting)
+		tcon->ses->server->tcpStatus = CifsNeedReconnect;
+	spin_unlock(&GlobalMid_Lock);
+
 unlock:
 	mutex_unlock(&tcon->ses->server->srv_mutex);
 
-- 
2.29.2

