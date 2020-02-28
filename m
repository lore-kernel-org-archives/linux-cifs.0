Return-Path: <SRS0=7CLT=4Q=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D341C3F2D1
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Feb 2020 09:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1501A246A8
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Feb 2020 09:23:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ELt4awYN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgB1JXi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Feb 2020 04:23:38 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37160 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgB1JXi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Feb 2020 04:23:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01S9HVPT161260;
        Fri, 28 Feb 2020 09:23:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=Md77iGEJECs0uv7NwYHGnJZebiY3k62ZD2KtUhej4C4=;
 b=ELt4awYNLre8W+7v4E1Uxfn6T23ghRJzUuj/zerKe0DpoZzI14XcheQSs0GTdvj/PJJ5
 FUyDQtwAc1dALrjdqGz7XaQPZ/boD6x+szGTFZ+LrHbTjFUK/nfl+U/ggX3er+XxrxPM
 ZE01NPCB8dAAAe4NkdpmGoHVT20dTst8p1yw6/oSxqnNvtGUgoPjAEGVIcWtBIcSs2Up
 UjK+UWqdcvmKMiUUySf3tck9CEr09KIG3WBWvVIo8I8crLHO8e446+cbJRMiHWxoZPVt
 1zUPcU3PbCno4xM8WS21jJmFVjCq9sx4t/R/i0tGDJDXVwiqEoBgKRW8WzR9GL0mSqgE QQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ydcsnsn4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 09:23:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01S9MD1n038422;
        Fri, 28 Feb 2020 09:23:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ydj4q8bwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 09:23:09 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01S9N61s015008;
        Fri, 28 Feb 2020 09:23:06 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 01:23:05 -0800
Date:   Fri, 28 Feb 2020 12:22:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Steve French <sfrench@samba.org>
Cc:     Aurelien Aptel <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] cifs: potential unintitliazed error code in cifs_getattr()
Message-ID: <20200228092043.xoqau6ez7qxnpwc4@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=788 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280078
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=837 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1011 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280077
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Smatch complains that "rc" could be uninitialized.

    fs/cifs/inode.c:2206 cifs_getattr() error: uninitialized symbol 'rc'.

Changing it to "return 0;" improves readability as well.

Fixes: cc1baf98c8f6 ("cifs: do not ignore the SYNC flags in getattr")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/cifs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 6543465595f6..e6d66977a81d 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2203,7 +2203,7 @@ int cifs_getattr(const struct path *path, struct kstat *stat,
 		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID))
 			stat->gid = current_fsgid();
 	}
-	return rc;
+	return 0;
 }
 
 int cifs_fiemap(struct inode *inode, struct fiemap_extent_info *fei, u64 start,
-- 
2.11.0

