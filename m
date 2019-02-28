Return-Path: <SRS0=HnFe=RD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD47EC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 05:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 836B021850
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 05:27:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OFNPrNAa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbfB1F13 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Feb 2019 00:27:29 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55808 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfB1F13 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Feb 2019 00:27:29 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1S5J6gC048672;
        Thu, 28 Feb 2019 05:27:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=B7T0e+q+R6GN1EzjCpSXn2V94F7lNsDxbMro5ukPd/E=;
 b=OFNPrNAaaEOwpaz2NYFJIV35VfPJimCtKDTbS1bjO9ZXR0OxXxMEfQAXVKyijZX+ggqB
 mECLcIa8J8MkGve4oCCgdSa9hqfkvxtheplzT6f8ntMdkoMXwMUd6rzvk3Ck/o5JD3UB
 SQc+9aGCyy74qNdl8www2PFaHYViI2ococxONYp2xL9cEh9w1gySwWhw4jSezXu12Fp9
 x/UjRco9/GUgAqpWuhWTRB0tsS4ZliB+TdRE3aiQ1hWUBB3QKz31vf9sTfJi29Ld73VE
 4UKDj35HSVOBLkgFOaWI7cjpe1wZmQmD9eLjBY5ojF/w7OnUjFAXw0XBkc+U8/nq4qHo Fw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2qtxtrxray-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Feb 2019 05:27:10 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1S5R9sb000323
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Feb 2019 05:27:10 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1S5R99O027001;
        Thu, 28 Feb 2019 05:27:09 GMT
Received: from kadam (/197.157.0.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 Feb 2019 21:27:08 -0800
Date:   Thu, 28 Feb 2019 08:26:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Steve French <sfrench@samba.org>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] cifs: Clean up an error code in cifs_root_iget()
Message-ID: <20190228052659.GA3253@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9180 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902280036
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch silences a Smatch warning:

fs/cifs/inode.c:1094 cifs_root_iget() warn: passing zero to 'ERR_PTR'

The shouldn't have a noticeable effect on runtime, it's basically
a cleanup.  The code is checking to ensure that cifs_get_inode_info_unix()
returns -EOPNOTSUPP when we have the UNIX extensions.  From the patch
description in commit b5b374eab11e ("Workaround Mac server problem")
this affects Macs.

Presumably most of the time "rc" is zero, which means we return
ERR_PTR(0) which is NULL.  This cifs_root_iget() function is only called
from cifs_read_super() and if we return NULL that causes d_make_root()
to return NULL so in the end we fail with -ENOMEM.

After this patch is applied we instead return with -EINVAL.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/cifs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 0f53ecb071ac..e40c554bb2f3 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1080,8 +1080,10 @@ struct inode *cifs_root_iget(struct super_block *sb)
 	if (tcon->unix_ext) {
 		rc = cifs_get_inode_info_unix(&inode, path, sb, xid);
 		/* some servers mistakenly claim POSIX support */
-		if (rc != -EOPNOTSUPP)
+		if (rc != -EOPNOTSUPP) {
+			rc = -EINVAL;
 			goto iget_no_retry;
+		}
 		cifs_dbg(VFS, "server does not support POSIX extensions");
 		tcon->unix_ext = false;
 	}
-- 
2.17.1

