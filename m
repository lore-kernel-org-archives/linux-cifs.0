Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40889C43470
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 09:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE69D610D0
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Apr 2021 09:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbhDAJJX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Apr 2021 05:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233702AbhDAJI6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Apr 2021 05:08:58 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9908AC0613E6;
        Thu,  1 Apr 2021 02:08:57 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id j7so1062031wrd.1;
        Thu, 01 Apr 2021 02:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=zfLEgiVPM1EK9I/Nt42wOScERsBlthcf9kfWnVgYF2Q=;
        b=fHOJMypWJhhdilZSqgus776bitjj+6ECd25ljjjUUgd/L3W2gUzr1RaQFXaoNGZ8q/
         08ohAbHbg28YHIs7dUH+nZRVhUwicJ96HqiSCMrWaFNAcfRpxgosz4BFrxMaU9Ml7WcG
         PIPLOfMVcHONaoXT9lb8ME2dqqnJVgDjjAn4upV4/KtoDlCYG3kHrmQd/ax24n80hnId
         dq0V9qXcp38humOfzkzGVDzRvxwTNVpeUaQhOvme9OilkTwP4OahpmQ2bDqgvEANnGGV
         lZgqSYEeFbHvI7093cMKti9e87KDn/pBSPZP9u6UURbGnCu0MiHZ5B+pwQkUzSCnT4Fo
         xPCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=zfLEgiVPM1EK9I/Nt42wOScERsBlthcf9kfWnVgYF2Q=;
        b=rfVWl0j9EpOikp9H97MQ8dTmMrSZJMMOhOyuRWHYI+v8xGrDGIOztfM3dJ4MaLd/QJ
         h/om0kGjd6VUdGL96kPFm19z1f4Q5DOQXI6yjHJmdqgfh1S80nQlKpz8P5/99zx4zhuz
         sk15t2SxWUGKBa30It5HBbTdCAf7rxIw3Z5OFjiQEk7/6Ggqx8Gd+e7/RkDnrhRi5tXL
         /yicvLKyFwwRKKFKh3aEVrUJmRWfmGeA2HAstCNMnVKFtMJLRkvY0+XQxoVookzJCU1d
         FJ0v+AEb+KAB/rEKMKeH2AhrQeZil7n3sQ1AuaR/K3AgiBqCSjB55clcSMbkF+C7MawY
         BA7Q==
X-Gm-Message-State: AOAM532hPbkcgNjHnKPjVGsqH4nPd3AII7SBq8CjJBv5nKK0Thu5XXv2
        hvdlWJsrEJO0vzQVeOapSw4=
X-Google-Smtp-Source: ABdhPJy3wsTTqmFumyzlT5bNJa58quMPVPj3Zo4eKzUSD/gEAxlpRvKnIyhg5WvQqFSWW3otqvDeuw==
X-Received: by 2002:adf:b1c9:: with SMTP id r9mr8594838wra.51.1617268136402;
        Thu, 01 Apr 2021 02:08:56 -0700 (PDT)
Received: from LEGION ([39.46.7.73])
        by smtp.gmail.com with ESMTPSA id f16sm8880603wrt.21.2021.04.01.02.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 02:08:55 -0700 (PDT)
Date:   Thu, 1 Apr 2021 14:08:50 +0500
From:   Muhammad Usama Anjum <musamaanjum@gmail.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        "open list:COMMON INTERNET FILE SYSTEM SERVER (CIFSD)" 
        <linux-cifs@vger.kernel.org>,
        "open list:COMMON INTERNET FILE SYSTEM SERVER (CIFSD)" 
        <linux-cifsd-devel@lists.sourceforge.net>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, colin.king@canonical.com,
        dan.carpenter@oracle.com
Cc:     musamaanjum@gmail.com
Subject: [PATCH] cifsd: use kfree to free memory allocated by kmalloc or
 kzalloc
Message-ID: <20210401090850.GA2779473@LEGION>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

kfree should be used to free memory allocated by kmalloc or kzalloc to
avoid any overhead and for maintaining consistency.

Fixes: 5dfeb6d945 ("cifsd: use kmalloc() for small allocations")
Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
---
 fs/cifsd/buffer_pool.c       | 4 ++--
 fs/cifsd/mgmt/share_config.c | 2 +-
 fs/cifsd/mgmt/user_config.c  | 8 ++++----
 fs/cifsd/mgmt/user_session.c | 6 +++---
 fs/cifsd/smb2pdu.c           | 4 ++--
 fs/cifsd/vfs_cache.c         | 2 +-
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/cifsd/buffer_pool.c b/fs/cifsd/buffer_pool.c
index ad2a2c885a2c..a9ef3e703232 100644
--- a/fs/cifsd/buffer_pool.c
+++ b/fs/cifsd/buffer_pool.c
@@ -78,7 +78,7 @@ static int register_wm_size_class(size_t sz)
 	list_for_each_entry(l, &wm_lists, list) {
 		if (l->sz == sz) {
 			write_unlock(&wm_lists_lock);
-			kvfree(nl);
+			kfree(nl);
 			return 0;
 		}
 	}
@@ -181,7 +181,7 @@ static void wm_list_free(struct wm_list *l)
 		list_del(&wm->list);
 		kvfree(wm);
 	}
-	kvfree(l);
+	kfree(l);
 }
 
 static void wm_lists_destroy(void)
diff --git a/fs/cifsd/mgmt/share_config.c b/fs/cifsd/mgmt/share_config.c
index db780febd692..e3d459c4dbb2 100644
--- a/fs/cifsd/mgmt/share_config.c
+++ b/fs/cifsd/mgmt/share_config.c
@@ -102,7 +102,7 @@ static int parse_veto_list(struct ksmbd_share_config *share,
 
 		p->pattern = kstrdup(veto_list, GFP_KERNEL);
 		if (!p->pattern) {
-			ksmbd_free(p);
+			kfree(p);
 			return -ENOMEM;
 		}
 
diff --git a/fs/cifsd/mgmt/user_config.c b/fs/cifsd/mgmt/user_config.c
index f0c2f8994a6b..c31e2c4d2d6f 100644
--- a/fs/cifsd/mgmt/user_config.c
+++ b/fs/cifsd/mgmt/user_config.c
@@ -46,8 +46,8 @@ struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_response *resp)
 
 	if (!user->name || !user->passkey) {
 		kfree(user->name);
-		ksmbd_free(user->passkey);
-		ksmbd_free(user);
+		kfree(user->passkey);
+		kfree(user);
 		user = NULL;
 	}
 	return user;
@@ -57,8 +57,8 @@ void ksmbd_free_user(struct ksmbd_user *user)
 {
 	ksmbd_ipc_logout_request(user->name);
 	kfree(user->name);
-	ksmbd_free(user->passkey);
-	ksmbd_free(user);
+	kfree(user->passkey);
+	kfree(user);
 }
 
 int ksmbd_anonymous_user(struct ksmbd_user *user)
diff --git a/fs/cifsd/mgmt/user_session.c b/fs/cifsd/mgmt/user_session.c
index 5a2113bf18ef..fa2140d4755a 100644
--- a/fs/cifsd/mgmt/user_session.c
+++ b/fs/cifsd/mgmt/user_session.c
@@ -53,7 +53,7 @@ static void __session_rpc_close(struct ksmbd_session *sess,
 
 	ksmbd_free(resp);
 	ksmbd_rpc_id_free(entry->id);
-	ksmbd_free(entry);
+	kfree(entry);
 }
 
 static void ksmbd_session_rpc_clear_list(struct ksmbd_session *sess)
@@ -119,7 +119,7 @@ int ksmbd_session_rpc_open(struct ksmbd_session *sess, char *rpc_name)
 	return entry->id;
 error:
 	list_del(&entry->list);
-	ksmbd_free(entry);
+	kfree(entry);
 	return -EINVAL;
 }
 
@@ -174,7 +174,7 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
 	ksmbd_release_id(session_ida, sess->id);
 
 	ksmbd_ida_free(sess->tree_conn_ida);
-	ksmbd_free(sess);
+	kfree(sess);
 }
 
 static struct ksmbd_session *__session_lookup(unsigned long long id)
diff --git a/fs/cifsd/smb2pdu.c b/fs/cifsd/smb2pdu.c
index 139041768f65..a4bcf6a85f02 100644
--- a/fs/cifsd/smb2pdu.c
+++ b/fs/cifsd/smb2pdu.c
@@ -1611,7 +1611,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
 			ksmbd_conn_set_good(work);
 			sess->state = SMB2_SESSION_VALID;
-			ksmbd_free(sess->Preauth_HashValue);
+			kfree(sess->Preauth_HashValue);
 			sess->Preauth_HashValue = NULL;
 		} else if (conn->preferred_auth_mech == KSMBD_AUTH_NTLMSSP) {
 			rc = generate_preauth_hash(work);
@@ -1637,7 +1637,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 
 				ksmbd_conn_set_good(work);
 				sess->state = SMB2_SESSION_VALID;
-				ksmbd_free(sess->Preauth_HashValue);
+				kfree(sess->Preauth_HashValue);
 				sess->Preauth_HashValue = NULL;
 			}
 		} else {
diff --git a/fs/cifsd/vfs_cache.c b/fs/cifsd/vfs_cache.c
index ec631dc6f1fb..f2a863542dc7 100644
--- a/fs/cifsd/vfs_cache.c
+++ b/fs/cifsd/vfs_cache.c
@@ -829,6 +829,6 @@ void ksmbd_destroy_file_table(struct ksmbd_file_table *ft)
 
 	__close_file_table_ids(ft, NULL, session_fd_check);
 	idr_destroy(ft->idr);
-	ksmbd_free(ft->idr);
+	kfree(ft->idr);
 	ft->idr = NULL;
 }
-- 
2.25.1

