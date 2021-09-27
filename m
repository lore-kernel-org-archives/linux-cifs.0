Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37E45C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Sep 2021 12:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEE6D61058
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Sep 2021 12:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbhI0Mtf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 27 Sep 2021 08:49:35 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:56116 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234331AbhI0Mtf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 27 Sep 2021 08:49:35 -0400
Received: by mail-pj1-f41.google.com with SMTP id t9so3648733pju.5
        for <linux-cifs@vger.kernel.org>; Mon, 27 Sep 2021 05:47:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xZuk1z4HhVj+zjX1VgIBDdjYjnNK4dQbKW8a+9QrlnM=;
        b=0cM0wDr/x8Pa2x5t+mORslUeXRGS3HZ/0Y7XDxyfWF8baiR/dWAEzIB5NNEdvCuH9A
         GcrqLrYSJiIuf83+13holMxrBX4fQFNoS/J7Bh8ANd5UmnFiLrqe5Q4/7VPBfdEzID8C
         4VYQwZhgjQxRFS1svRYf7c43r1tsscMoHHeva//8e2Bjdcz/OotsfXlf6GvjQoEy3jUw
         utsHNQwea3/wx8UidpwH8ColWsjUpwHMvi1hofYV6avqLO9If/hpy9TW+1xhFsa0Xu16
         myx4RxmtPp1rpmDr7m4H5LoKv5T4fnpmvHHnSXFMTjcPS9zRTBLiC/qTMD7P1QucK027
         iAqA==
X-Gm-Message-State: AOAM532JldtYo3Qo9uEs1Sy2R3yy0aCQq17JpGX544M2/q+KFETzdiIi
        hLkxgf1AZSFpYQizpo3kZV09m4C0bQBvWw==
X-Google-Smtp-Source: ABdhPJyxQQnmC2HyFqKrNqzxSlr/dxPYKkm6fNH5yNjfoKdbTalMd2rqYb3AgbYPFl7th759Hzf6cg==
X-Received: by 2002:a17:90a:4306:: with SMTP id q6mr19908909pjg.17.1632746877441;
        Mon, 27 Sep 2021 05:47:57 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id k14sm18566615pgn.85.2021.09.27.05.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 05:47:57 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH 1/2] ksmbd: remove the leftover of smb2.0 dialect support
Date:   Mon, 27 Sep 2021 21:47:47 +0900
Message-Id: <20210927124748.5614-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Although ksmbd doesn't send SMB2.0 support in supported dialect list of smb
negotiate response, There is the leftover of smb2.0 dialect.
This patch remove it not to support SMB2.0 in ksmbd.

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2ops.c    |  5 -----
 fs/ksmbd/smb2pdu.c    | 15 ++++-----------
 fs/ksmbd/smb2pdu.h    |  1 -
 fs/ksmbd/smb_common.c |  4 ++--
 4 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/fs/ksmbd/smb2ops.c b/fs/ksmbd/smb2ops.c
index 197473871aa4..b06456eb587b 100644
--- a/fs/ksmbd/smb2ops.c
+++ b/fs/ksmbd/smb2ops.c
@@ -187,11 +187,6 @@ static struct smb_version_cmds smb2_0_server_cmds[NUMBER_OF_SMB2_COMMANDS] = {
 	[SMB2_CHANGE_NOTIFY_HE]	=	{ .proc = smb2_notify},
 };
 
-int init_smb2_0_server(struct ksmbd_conn *conn)
-{
-	return -EOPNOTSUPP;
-}
-
 /**
  * init_smb2_1_server() - initialize a smb server connection with smb2.1
  *			command dispatcher
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 88e94a8e4a15..b7d0406d1a14 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -236,7 +236,7 @@ int init_smb2_neg_rsp(struct ksmbd_work *work)
 
 	if (conn->need_neg == false)
 		return -EINVAL;
-	if (!(conn->dialect >= SMB20_PROT_ID &&
+	if (!(conn->dialect >= SMB21_PROT_ID &&
 	      conn->dialect <= SMB311_PROT_ID))
 		return -EINVAL;
 
@@ -1166,13 +1166,6 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 	case SMB21_PROT_ID:
 		init_smb2_1_server(conn);
 		break;
-	case SMB20_PROT_ID:
-		rc = init_smb2_0_server(conn);
-		if (rc) {
-			rsp->hdr.Status = STATUS_NOT_SUPPORTED;
-			goto err_out;
-		}
-		break;
 	case SMB2X_PROT_ID:
 	case BAD_PROT_ID:
 	default:
@@ -1191,7 +1184,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 	rsp->MaxReadSize = cpu_to_le32(conn->vals->max_read_size);
 	rsp->MaxWriteSize = cpu_to_le32(conn->vals->max_write_size);
 
-	if (conn->dialect > SMB20_PROT_ID) {
+	if (conn->dialect >= SMB21_PROT_ID) {
 		memcpy(conn->ClientGUID, req->ClientGUID,
 		       SMB2_CLIENT_GUID_SIZE);
 		conn->cli_sec_mode = le16_to_cpu(req->SecurityMode);
@@ -1537,7 +1530,7 @@ static int ntlm_authenticate(struct ksmbd_work *work)
 		}
 	}
 
-	if (conn->dialect > SMB20_PROT_ID) {
+	if (conn->dialect >= SMB21_PROT_ID) {
 		if (!ksmbd_conn_lookup_dialect(conn)) {
 			pr_err("fail to verify the dialect\n");
 			return -ENOENT;
@@ -1623,7 +1616,7 @@ static int krb5_authenticate(struct ksmbd_work *work)
 		}
 	}
 
-	if (conn->dialect > SMB20_PROT_ID) {
+	if (conn->dialect >= SMB21_PROT_ID) {
 		if (!ksmbd_conn_lookup_dialect(conn)) {
 			pr_err("fail to verify the dialect\n");
 			return -ENOENT;
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index 261825d06391..a6dec5ec6a54 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -1637,7 +1637,6 @@ struct smb2_posix_info {
 } __packed;
 
 /* functions */
-int init_smb2_0_server(struct ksmbd_conn *conn);
 void init_smb2_1_server(struct ksmbd_conn *conn);
 void init_smb3_0_server(struct ksmbd_conn *conn);
 void init_smb3_02_server(struct ksmbd_conn *conn);
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index b6c4c7e960fa..435ca8df590b 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -88,7 +88,7 @@ unsigned int ksmbd_server_side_copy_max_total_size(void)
 
 inline int ksmbd_min_protocol(void)
 {
-	return SMB2_PROT;
+	return SMB21_PROT;
 }
 
 inline int ksmbd_max_protocol(void)
@@ -427,7 +427,7 @@ int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
 
 static int __smb2_negotiate(struct ksmbd_conn *conn)
 {
-	return (conn->dialect >= SMB20_PROT_ID &&
+	return (conn->dialect >= SMB21_PROT_ID &&
 		conn->dialect <= SMB311_PROT_ID);
 }
 
-- 
2.25.1

