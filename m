Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B85CEB64DC
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Jul 2023 01:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjGRBZa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Jul 2023 21:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjGRBZ3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Jul 2023 21:25:29 -0400
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6081198
        for <linux-cifs@vger.kernel.org>; Mon, 17 Jul 2023 18:25:27 -0700 (PDT)
X-QQ-mid: bizesmtp67t1689643518tenb0be7
Received: from localhost.localdomain ( [113.57.152.160])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 18 Jul 2023 09:25:17 +0800 (CST)
X-QQ-SSF: 01400000000000F0H000000A0000000
X-QQ-FEAT: 0b1/4t+gNkLWMHDgJEWMG9m033NolsrdTf5CvFRtnua+SVduKv4zyk3oIm2oA
        unZG8CpjiYljrHPujON/MFva9Z5HmMjWpzm8f9IfmEdBKQ6yzaHastKoIdYg9SwiIIhNCzx
        pIa8hLt7pGLw/i2qAS2RdgtjU4b6wHIC0lYVus9kKP4DqtxTFJjns64hxlZEkYHW6gam06Z
        igvwjyW2uo4tOZZ1qdsu1tGH7OZunlfJpVikqoYG2DT61KXzz2lTGcdEnncL2vyvTT6OtT3
        GAmqS1ki5XOq9zB3NxLBuvXHOfD8mo0kqwitKdSuvQ90vlm6Sn0yC7vGEtPNjpsBRCEViCr
        u2Moc76b0Kb8GBS4ksIoluQRJZPE5urPiw8l2T/4iToDVUdzMM/RbOki9bV0u+jTVLBjc46
        VIVnlo9gMRY=
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10217443510862849707
From:   Winston Wen <wentao@uniontech.com>
To:     sfrench@samba.org, linux-cifs@vger.kernel.org, pc@manguebit.com,
        lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com
Cc:     Winston Wen <wentao@uniontech.com>
Subject: [PATCH v2] cifs: fix charset issue in reconnection
Date:   Tue, 18 Jul 2023 09:24:37 +0800
Message-Id: <20230718012437.1841868-1-wentao@uniontech.com>
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
Reviewed-by: Paulo Alcantara <pc@manguebit.com>
---
 fs/smb/client/cifsglob.h | 1 +
 fs/smb/client/cifssmb.c  | 3 +--
 fs/smb/client/connect.c  | 5 +++++
 fs/smb/client/misc.c     | 1 +
 fs/smb/client/smb2pdu.c  | 3 +--
 5 files changed, 9 insertions(+), 4 deletions(-)

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
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 9dee267f1893..25503f1a4fd2 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -129,7 +129,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	}
 	spin_unlock(&server->srv_lock);
 
-	nls_codepage = load_nls_default();
+	nls_codepage = ses->local_nls;
 
 	/*
 	 * need to prevent multiple threads trying to simultaneously
@@ -200,7 +200,6 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 		rc = -EAGAIN;
 	}
 
-	unload_nls(nls_codepage);
 	return rc;
 }
 
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 5dd09c6d762e..bec0e893be06 100644
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
 
@@ -2286,6 +2290,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 
 	ses->sectype = ctx->sectype;
 	ses->sign = ctx->sign;
+	ses->local_nls = load_nls(ctx->local_nls->charset);
 
 	/* add server as first channel */
 	spin_lock(&ses->chan_lock);
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 70dbfe6584f9..d7e85d9a2655 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -95,6 +95,7 @@ sesInfoFree(struct cifs_ses *buf_to_free)
 		return;
 	}
 
+	unload_nls(buf_to_free->local_nls);
 	atomic_dec(&sesInfoAllocCount);
 	kfree(buf_to_free->serverOS);
 	kfree(buf_to_free->serverDomain);
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

