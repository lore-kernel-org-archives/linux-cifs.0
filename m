Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F2B1C433E1
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Mar 2021 13:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AC5B619BF
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Mar 2021 13:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhCWN2W (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Mar 2021 09:28:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41568 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbhCWN1w (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Mar 2021 09:27:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NDKCfh056190;
        Tue, 23 Mar 2021 13:27:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=MVqQ7s2WzKyNtpCuABtLdT6Z2dI4JW+Zqkq8SQ4aBn4=;
 b=UDBguXtNg73Q5KnKkZyvpPSRVRwVG+/N6jIoeGlYovfhgqyHpnY07csmQ5j2KRb3g8uY
 4IZVmjZVUwKfAI41PBsfoINE68ZXqvjySBb4rT+NszRTb+L3MIeyjaf3A45+cMCEAe39
 xFumwdkDCe7S2CxWWS86uwTRD/eo6TF0Q0qUzBos4YHraMVNli9Ai/tn8Sz2lbp2FJrv
 h3IAQD3FYZpl2zk38J7pJ8/7zJYjP0UyOsd6PY+I4mWMrJGAf7fPBlCgTRPgo1wmccmg
 yCkPTayQf0SqXu6dqaoiJqlndebOandF7rek8l8n1T1c0/06qEbaYywuX3VyPdNRSnmv fw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37d9pmxwxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 13:27:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NDQiXp179991;
        Tue, 23 Mar 2021 13:27:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 37dtyxecmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 13:27:17 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 12NDRC2D005969;
        Tue, 23 Mar 2021 13:27:12 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Mar 2021 06:27:11 -0700
Date:   Tue, 23 Mar 2021 16:27:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org,
        linux-cifsd-devel@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v2] cifsd: fix error handling in ksmbd_server_init()
Message-ID: <YFnsqPphqvItA3z2@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230099
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230098
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The error handling in ksmbd_server_init() uses "one function to free
everything style" which is impossible to audit and leads to several
canonical bugs.  When we free something that wasn't allocated it may be
uninitialized, an error pointer, freed in a different function or we
try freeing "foo->bar" when "foo" is a NULL pointer.  And since the
code is impossible to audit then it leads to memory leaks.

In the ksmbd_server_init() function, every goto will lead to a crash
because we have not allocated the work queue but we call
ksmbd_workqueue_destroy() which tries to flush a NULL work queue.
Another bug is if ksmbd_init_buffer_pools() fails then it leads to a
double free because we free "work_cache" twice.  A third type of bug is
that we forgot to call ksmbd_release_inode_hash() so that is a resource
leak.

A better way to write error handling is for every function to clean up
after itself and never leave things partially allocated.  Then we can
use "free the last successfully allocated resource" style.  That way
when someone is reading the code they can just track the last resource
in their head and verify that the goto matches what they expect.

In this patch I modified ksmbd_ipc_init() to clean up after itself and
then I converted ksmbd_server_init() to use gotos to clean up.

Fixes: cabcebc31de4 ("cifsd: introduce SMB3 kernel server")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: remove __exit annotation from ksmbd_release_inode_hash() as detected
by the kbuild-bot

 fs/cifsd/server.c        | 33 +++++++++++++++++++++++----------
 fs/cifsd/transport_ipc.c | 14 +++++++++++---
 fs/cifsd/vfs_cache.c     |  2 +-
 fs/cifsd/vfs_cache.h     |  2 +-
 4 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/fs/cifsd/server.c b/fs/cifsd/server.c
index 85862c3ea7c0..31e454cb3ce2 100644
--- a/fs/cifsd/server.c
+++ b/fs/cifsd/server.c
@@ -567,39 +567,52 @@ static int __init ksmbd_server_init(void)
 
 	ret = server_conf_init();
 	if (ret)
-		return ret;
+		goto err_unregister;
 
 	ret = ksmbd_init_buffer_pools();
 	if (ret)
-		return ret;
+		goto err_unregister;
 
 	ret = ksmbd_init_session_table();
 	if (ret)
-		goto error;
+		goto err_destroy_pools;
 
 	ret = ksmbd_ipc_init();
 	if (ret)
-		goto error;
+		goto err_free_session_table;
 
 	ret = ksmbd_init_global_file_table();
 	if (ret)
-		goto error;
+		goto err_ipc_release;
 
 	ret = ksmbd_inode_hash_init();
 	if (ret)
-		goto error;
+		goto err_destroy_file_table;
 
 	ret = ksmbd_crypto_create();
 	if (ret)
-		goto error;
+		goto err_release_inode_hash;
 
 	ret = ksmbd_workqueue_init();
 	if (ret)
-		goto error;
+		goto err_crypto_destroy;
 	return 0;
 
-error:
-	ksmbd_server_shutdown();
+err_crypto_destroy:
+	ksmbd_crypto_destroy();
+err_release_inode_hash:
+	ksmbd_release_inode_hash();
+err_destroy_file_table:
+	ksmbd_free_global_file_table();
+err_ipc_release:
+	ksmbd_ipc_release();
+err_free_session_table:
+	ksmbd_free_session_table();
+err_destroy_pools:
+	ksmbd_destroy_buffer_pools();
+err_unregister:
+	class_unregister(&ksmbd_control_class);
+
 	return ret;
 }
 
diff --git a/fs/cifsd/transport_ipc.c b/fs/cifsd/transport_ipc.c
index c49e46fda9b1..e5f4d97b2924 100644
--- a/fs/cifsd/transport_ipc.c
+++ b/fs/cifsd/transport_ipc.c
@@ -887,11 +887,19 @@ int ksmbd_ipc_init(void)
 	if (ret) {
 		ksmbd_err("Failed to register KSMBD netlink interface %d\n",
 				ret);
-		return ret;
+		goto cancel_work;
 	}
 
 	ida = ksmbd_ida_alloc();
-	if (!ida)
-		return -ENOMEM;
+	if (!ida) {
+		ret = -ENOMEM;
+		goto unregister;
+	}
 	return 0;
+
+unregister:
+	genl_unregister_family(&ksmbd_genl_family);
+cancel_work:
+	cancel_delayed_work_sync(&ipc_timer_work);
+	return ret;
 }
diff --git a/fs/cifsd/vfs_cache.c b/fs/cifsd/vfs_cache.c
index af92fab5b7ae..34e045f27230 100644
--- a/fs/cifsd/vfs_cache.c
+++ b/fs/cifsd/vfs_cache.c
@@ -236,7 +236,7 @@ int __init ksmbd_inode_hash_init(void)
 	return 0;
 }
 
-void __exit ksmbd_release_inode_hash(void)
+void ksmbd_release_inode_hash(void)
 {
 	vfree(inode_hashtable);
 }
diff --git a/fs/cifsd/vfs_cache.h b/fs/cifsd/vfs_cache.h
index 7d23657c86c6..04ab5967a9ae 100644
--- a/fs/cifsd/vfs_cache.h
+++ b/fs/cifsd/vfs_cache.h
@@ -194,7 +194,7 @@ void ksmbd_set_fd_limit(unsigned long limit);
  */
 
 int __init ksmbd_inode_hash_init(void);
-void __exit ksmbd_release_inode_hash(void);
+void ksmbd_release_inode_hash(void);
 
 enum KSMBD_INODE_STATUS {
 	KSMBD_INODE_STATUS_OK,
-- 
2.30.2


