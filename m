Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF85EB64DD
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Jul 2023 02:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbjGQCXD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 16 Jul 2023 22:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjGQCXC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 16 Jul 2023 22:23:02 -0400
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0701AA
        for <linux-cifs@vger.kernel.org>; Sun, 16 Jul 2023 19:22:58 -0700 (PDT)
X-QQ-mid: bizesmtp74t1689560565tbnpxpew
Received: from localhost.localdomain ( [113.57.152.160])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 17 Jul 2023 10:22:44 +0800 (CST)
X-QQ-SSF: 01400000000000F0H000000A0000000
X-QQ-FEAT: Jzzl+CAVsir23r8vXfjkTZBehyE8g7BfUyo9ErxhTG94I9/kkOvBk6UsZKWSn
        auy3u5SWTQoYNlI+CxMFdfT/kV6u5YJQSrAFgQsUmWuAYk4bY4Gphcw6kq4C1/yR8aG7dJk
        uLp/18mnInOcd13YXdyR/wZqkYOeemvR7tM0XrkdaVprPgj8lDRoMEdJeIVWLWlR1lqyKgx
        zxPVkzoai7+3gD1KBURr77J2xvxaaa2k11LScpCN0+4KK0Sc5u7Ngu9WoB+vPhq+C441Nnm
        e+GNX4pqXNwsrptizgLBoyN26lleKzGVjer5xB799Nvr581QWd3IlyDsySuvsjbxn6VzxGv
        eKKKTrsgKXRHZo8tNALgi8gBFTqIrlialYqyJxNFcgdpA8Qv9joaasO1JmIpD2qXnlyvoNH
        mCuxvuPU+B9k3x6/5LkBpg==
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4418698414132723179
From:   Winston Wen <wentao@uniontech.com>
To:     sfrench@samba.org, linux-cifs@vger.kernel.org,
        sprasad@microsoft.com
Cc:     Winston Wen <wentao@uniontech.com>
Subject: [PATCH] cifs: fix charset issue in reconnection
Date:   Mon, 17 Jul 2023 10:22:27 +0800
Message-Id: <20230717022227.1736113-1-wentao@uniontech.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6a-1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We need to specify charset, like "iocharset=utf-8", in mount options for
Chinese path if the nls_default don't support it, such as iso8859-1, the
default value for CONFIG_NLS_DEFAULT.

But now in reconnection the nls_default is used, instead of the one we
specified and used in mount, and this can lead to mount failure.

Signed-off-by: Winston Wen <wentao@uniontech.com>
---
 fs/smb/client/cifsglob.h | 1 +
 fs/smb/client/connect.c  | 6 ++++++
 fs/smb/client/smb2pdu.c  | 3 +--
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index c9a87d0123ce..31cadf9b2a98 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1062,6 +1062,7 @@ struct cifs_ses {
 	unsigned long chans_need_reconnect;
 	/* ========= end: protected by chan_lock ======== */
 	struct cifs_ses *dfs_root_ses;
+	struct nls_table *local_nls;
 };
 
 static inline bool
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 5dd09c6d762e..abb69a6d4fce 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1842,6 +1842,10 @@ static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 			    CIFS_MAX_PASSWORD_LEN))
 			return 0;
 	}
+
+	if (strcmp(ctx->local_nls->charset, ses->local_nls->charset))
+		return 0;
+
 	return 1;
 }
 
@@ -2027,6 +2031,7 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
 		}
 	}
 
+	unload_nls(ses->local_nls);
 	sesInfoFree(ses);
 	cifs_put_tcp_session(server, 0);
 }
@@ -2286,6 +2291,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 
 	ses->sectype = ctx->sectype;
 	ses->sign = ctx->sign;
+	ses->local_nls = load_nls(ctx->local_nls->charset);
 
 	/* add server as first channel */
 	spin_lock(&ses->chan_lock);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index e04766fe6f80..a457f07f820d 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -242,7 +242,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	}
 	spin_unlock(&server->srv_lock);
 
-	nls_codepage = load_nls_default();
+	nls_codepage = ses->local_nls;
 
 	/*
 	 * need to prevent multiple threads trying to simultaneously
@@ -324,7 +324,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		rc = -EAGAIN;
 	}
 failed:
-	unload_nls(nls_codepage);
 	return rc;
 }
 
-- 
2.40.1

