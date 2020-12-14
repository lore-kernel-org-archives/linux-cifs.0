Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E3CDC4361B
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 12:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D88F7239FF
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 12:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389880AbgLNL7l (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Dec 2020 06:59:41 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:41428 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407507AbgLNL7c (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Dec 2020 06:59:32 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEBngC7194587;
        Mon, 14 Dec 2020 11:58:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=UuekPZIlBB8apOvaVN0thQDKnr9CjPtIATVlLQNcSv8=;
 b=g3P4f8Sa81Ivf45JnH6VLLhfb6lfhala6q9dpheZErdk1arZ0btf7pmKDXTTmfu1+jgX
 JabIN4Nhzuv+ZqvusF3c+jM0L5y7hGu4G9RnScG1zmjuibYSEi6cTlmU/rk71GHAG2sX
 9egICkRGUkZ1+BLAx9bQq9StZ1I+eqrR4qeCnDxpdaeQvmQQY4TU/lkr2vFodC1V+dLD
 HTpid23cq167cfDO0Dmq3gPtH/c83cluve8pebYv6X/V/W82AOZpTEnRBZGUzPdx/keY
 fNP7uiS1RJBwJWojIQS9FgmeKeCnYqagYINaUmGFu7MowrdcOMM4uEO47rVVLS5VJGBo Ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35ckcb4xab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Dec 2020 11:58:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BEBt4go191900;
        Mon, 14 Dec 2020 11:56:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 35e6jpabr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 11:56:16 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BEBuCl7012797;
        Mon, 14 Dec 2020 11:56:12 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Dec 2020 03:56:11 -0800
Date:   Mon, 14 Dec 2020 14:56:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Steve French <sfrench@samba.org>,
        Shyam Prasad N <sprasad@microsoft.com>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] cifs: Fix uninitialized variable in set_chmod_dacl()
Message-ID: <X9dS1EllbQhuX7/C@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140085
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9834 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140084
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Initialize the "nmode" variable earlier to prevent an uninitialized
variable bug when we do "size += setup_special_mode_ACE(pntace, nmode);"

Fixes: 253374f7557e ("cifs: Fix unix perm bits to cifsacl conversion for "other" bits.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/cifs/cifsacl.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index d7a6d0f533bf..8410db328e5e 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -920,6 +920,13 @@ static int set_chmod_dacl(struct cifs_acl *pndacl, struct cifs_sid *pownersid,
 	__u64 deny_group_mode = 0;
 	bool sticky_set = false;
 
+	/*
+	 * We'll try to keep the mode as requested by the user.
+	 * But in cases where we cannot meaningfully convert that
+	 * into ACL, return back the updated mode, so that it is
+	 * updated in the inode.
+	 */
+	nmode = *pnmode;
 	pnndacl = (struct cifs_acl *)((char *)pndacl + sizeof(struct cifs_acl));
 
 	if (modefromsid) {
@@ -931,14 +938,6 @@ static int set_chmod_dacl(struct cifs_acl *pndacl, struct cifs_sid *pownersid,
 		goto set_size;
 	}
 
-	/*
-	 * We'll try to keep the mode as requested by the user.
-	 * But in cases where we cannot meaningfully convert that
-	 * into ACL, return back the updated mode, so that it is
-	 * updated in the inode.
-	 */
-	nmode = *pnmode;
-
 	if (!memcmp(pownersid, pgrpsid, sizeof(struct cifs_sid))) {
 		/*
 		 * Case when owner and group SIDs are the same.
-- 
2.29.2

