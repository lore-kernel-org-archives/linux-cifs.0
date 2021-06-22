Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60701C2B9F4
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 11:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49103613AE
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 11:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhFVLCv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 07:02:51 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:51604 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229769AbhFVLCu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 22 Jun 2021 07:02:50 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15MArN7T006540;
        Tue, 22 Jun 2021 11:00:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=jF1rOE1ka1kjLVoEdkzZOcOYF8W6bwDXtgL5Olaot4A=;
 b=CUJBlrdEOpr0QUI5FpUmcryvghlsP/FDWSNPhKBvmAQiPkCz6WLr0jzTxZ+LkiKkOmtq
 4q8w+KHYsiy12T/CKezt7O0eKFwINRcvG1kcQBQQcNBxxKwDRVj1lNFf5XQT8xR5MpII
 4xhjRk/U6uEERIrWRr43kAE16kF+XSJHsg/DrkhZ9ItYBtsRlNGWs6+pHggy4dOwHBpR
 fDhxRQgRLHDBk3uqTwOex3JzS6xkClFMsl6ei1BrtDWkjeOzsK3Qgwd6XsAiblXm+WDs
 N+WBjzGlE7Bn2qQn4mPYlns+butVyf8JZsychjIMzow66AKIdr1D9IAbXB/sQInQzXu6 qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39as86tjv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 11:00:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15MAxqpD128765;
        Tue, 22 Jun 2021 11:00:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 399tbsddus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 11:00:09 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15MB071i130710;
        Tue, 22 Jun 2021 11:00:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 399tbsddrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 11:00:07 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.14.4) with ESMTP id 15MB03Ze028573;
        Tue, 22 Jun 2021 11:00:03 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Jun 2021 04:00:02 -0700
Date:   Tue, 22 Jun 2021 13:59:55 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Steve French <sfrench@samba.org>
Cc:     Baokun Li <libaokun1@huawei.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] cifs: fix NULL dereference in smb2_check_message()
Message-ID: <YNHCq6N9bAODxvnp@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-ORIG-GUID: BUXnIuDvwyeI93WAyjRGSm8xWtyvsCAH
X-Proofpoint-GUID: BUXnIuDvwyeI93WAyjRGSm8xWtyvsCAH
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This code sets "ses" to NULL which will lead to a NULL dereference on
the second iteration through the loop.

Fixes: 85346c17e425 ("cifs: convert list_for_each to entry variant in smb2misc.c")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/cifs/smb2misc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index c6bb2ea1983b..668f77108831 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -158,11 +158,10 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *srvr)
 		list_for_each_entry(ses, &srvr->smb_ses_list, smb_ses_list) {
 			if (ses->Suid == thdr->SessionId)
 				break;
-
-			ses = NULL;
 		}
 		spin_unlock(&cifs_tcp_ses_lock);
-		if (ses == NULL) {
+		if (list_entry_is_head(ses, &srvr->smb_ses_list,
+				       smb_ses_list)) {
 			cifs_dbg(VFS, "no decryption - session id not found\n");
 			return 1;
 		}
-- 
2.30.2

