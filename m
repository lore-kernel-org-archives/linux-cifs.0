Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826AEC433FE
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C90861A85
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 12:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354282AbhJAMHb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Oct 2021 08:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354129AbhJAMHb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Oct 2021 08:07:31 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486F1C061775
        for <linux-cifs@vger.kernel.org>; Fri,  1 Oct 2021 05:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=9p916dGRHvcVFrWbf/6Uja9PW/SMPiUk2YKBh1Jq/LU=; b=SPs5BPSyDngYjYJZy3J13BTxit
        ZXY+Ao0AlDhA40WBRo7nLSZ/mpjExDz7xZ87Cdmy2DFjkt06XeLYoi+mOj9ljRilS2IDDIhBRgnfW
        L3vU9N8XsRW3ddgR3E16HErfaNdMnxQlPhr/PO9eAaN7oco7IxHGAyV4wFLhOUT7RPMJtUd0MeEOm
        I+qi8RWkqb1gSAZYh32DGF9NHnPl61xvwvzJQUhDx8HPdXVnVWsRep9tnjCN0n/z+xubX4O6jbsMK
        MoKDVS+wqMl84EsKOOqujqHJF/xd9MXkz5sUvp60sjH9RZuW7KFsx0f4IjfI/hr1PGY7FhtKi6Wm9
        2evXJltQekFtx034k9xpdQSeTUq6M7S+iKpkP4OGjrh6C8k7KCyYIVnr5IE7DKdAKDc23nNPLdPbt
        6NiuWteuQMAocVha8A49ZQPuDxMKfblacg8+nTemzW41x53nrQg/fkZbkO4tFUpY5qiptaeBcmoja
        w9koMWWgky2N8yjbjxo4Hq4X;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWHIP-0013Z3-99; Fri, 01 Oct 2021 12:05:45 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v5 08/20] ksmbd: remove the leftover of smb2.0 dialect support
Date:   Fri,  1 Oct 2021 14:04:09 +0200
Message-Id: <20211001120421.327245-9-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001120421.327245-1-slow@samba.org>
References: <20211001120421.327245-1-slow@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

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
 fs/ksmbd/smb2pdu.c    | 34 +++++++++-------------------------
 fs/ksmbd/smb2pdu.h    |  1 -
 fs/ksmbd/smb_common.c |  6 +++---
 4 files changed, 12 insertions(+), 34 deletions(-)

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
index e40bcc86f3b3..ec05d9dc6436 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -236,9 +236,6 @@ int init_smb2_neg_rsp(struct ksmbd_work *work)
 
 	if (conn->need_neg == false)
 		return -EINVAL;
-	if (!(conn->dialect >= SMB20_PROT_ID &&
-	      conn->dialect <= SMB311_PROT_ID))
-		return -EINVAL;
 
 	rsp_hdr = work->response_buf;
 
@@ -1166,13 +1163,6 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
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
@@ -1191,11 +1181,9 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 	rsp->MaxReadSize = cpu_to_le32(conn->vals->max_read_size);
 	rsp->MaxWriteSize = cpu_to_le32(conn->vals->max_write_size);
 
-	if (conn->dialect > SMB20_PROT_ID) {
-		memcpy(conn->ClientGUID, req->ClientGUID,
-		       SMB2_CLIENT_GUID_SIZE);
-		conn->cli_sec_mode = le16_to_cpu(req->SecurityMode);
-	}
+	memcpy(conn->ClientGUID, req->ClientGUID,
+			SMB2_CLIENT_GUID_SIZE);
+	conn->cli_sec_mode = le16_to_cpu(req->SecurityMode);
 
 	rsp->StructureSize = cpu_to_le16(65);
 	rsp->DialectRevision = cpu_to_le16(conn->dialect);
@@ -1537,11 +1525,9 @@ static int ntlm_authenticate(struct ksmbd_work *work)
 		}
 	}
 
-	if (conn->dialect > SMB20_PROT_ID) {
-		if (!ksmbd_conn_lookup_dialect(conn)) {
-			pr_err("fail to verify the dialect\n");
-			return -ENOENT;
-		}
+	if (!ksmbd_conn_lookup_dialect(conn)) {
+		pr_err("fail to verify the dialect\n");
+		return -ENOENT;
 	}
 	return 0;
 }
@@ -1623,11 +1609,9 @@ static int krb5_authenticate(struct ksmbd_work *work)
 		}
 	}
 
-	if (conn->dialect > SMB20_PROT_ID) {
-		if (!ksmbd_conn_lookup_dialect(conn)) {
-			pr_err("fail to verify the dialect\n");
-			return -ENOENT;
-		}
+	if (!ksmbd_conn_lookup_dialect(conn)) {
+		pr_err("fail to verify the dialect\n");
+		return -ENOENT;
 	}
 	return 0;
 }
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
index b6c4c7e960fa..707490ab1f4c 100644
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
 
@@ -457,7 +457,7 @@ int ksmbd_smb_negotiate_common(struct ksmbd_work *work, unsigned int command)
 		}
 	}
 
-	if (command == SMB2_NEGOTIATE_HE) {
+	if (command == SMB2_NEGOTIATE_HE && __smb2_negotiate(conn)) {
 		ret = smb2_handle_negotiate(work);
 		init_smb2_neg_rsp(work);
 		return ret;
-- 
2.31.1

