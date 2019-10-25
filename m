Return-Path: <SRS0=c2dJ=YS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F61FCA9EA0
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Oct 2019 10:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1844D2084C
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Oct 2019 10:37:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lCeKnecv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392675AbfJYKhi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 25 Oct 2019 06:37:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40712 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730471AbfJYKhi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 25 Oct 2019 06:37:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9PAYLxk021001;
        Fri, 25 Oct 2019 10:37:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=FayfNeGT6j1qewSZjEARp6f6zMucP3LRZwb6M/yZNWY=;
 b=lCeKnecvtXMgWSsSjLGU5qcZkOPvHLsrgQcG3S5kgwR4kONac5I3iHCzSctU+RaHr0UU
 2VpHqUIIay1AdSpUzDD5yZPQPJ13tZiJSo1VpVOkWXlMC6YqFGTbv1ByR7cVIColIZTj
 i0BpIDFEuU7a5Dse6T+XfFYlXskmKfgx64mKGa8FVPhmxQWL9/Y1f7WAK4kaQpjeVl0V
 TT+7UbayQgeUEhU9BlJNvvTF/bnWWn31bzeATRgZpNTZyNaM4jP5CsE+Xp+q2reK3LYO
 JBKoQHADqBU4W78z56GGm8pbNvtuktUP3gqJCyYiq74crgChaxUokVce+kVXw5XifbpO /g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vqswu28du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 10:37:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9PAY3qk133334;
        Fri, 25 Oct 2019 10:35:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vuun0ucym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 10:35:18 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9PAZFt2032481;
        Fri, 25 Oct 2019 10:35:15 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Oct 2019 03:35:15 -0700
Date:   Fri, 25 Oct 2019 13:35:08 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Steve French <sfrench@samba.org>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] cifs: rename a variable in SendReceive()
Message-ID: <20191025103508.GA11916@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250100
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250100
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Smatch gets confused because we sometimes refer to "server->srv_mutex" and
sometimes to "sess->server->srv_mutex".  They refer to the same lock so
let's just make this consistent.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/cifs/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 308ad0f495e1..7c3697fe7905 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1283,7 +1283,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = allocate_mid(ses, in_buf, &midQ);
 	if (rc) {
-		mutex_unlock(&ses->server->srv_mutex);
+		mutex_unlock(&server->srv_mutex);
 		/* Update # of requests on wire to server */
 		add_credits(server, &credits, 0);
 		return rc;
-- 
2.20.1

