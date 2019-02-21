Return-Path: <SRS0=RVJ6=Q4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2AF4C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 20:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8154020836
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 20:02:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iEgmnM6X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfBUUC4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Feb 2019 15:02:56 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46859 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfBUUC4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Feb 2019 15:02:56 -0500
Received: by mail-pl1-f195.google.com with SMTP id o6so14680681pls.13
        for <linux-cifs@vger.kernel.org>; Thu, 21 Feb 2019 12:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=DoMcJr+VyLMMY95yzkLAuHASV16tCBOrYRKegmAnMWo=;
        b=iEgmnM6Xe6mePi37LktWu4hn6q0z/i1VILeZ1pHiLq6pDLSJ6xHENBCB2cI64hCX1r
         Ni37dxpQUSPZMXB5SqXiagseFRi8QOtYSgqJrN3NFs+FtqFInSMS5bHmUZxEFrxSl4O/
         yzlaU3DFsM7tSdLfLEwshT7V+sbghuP6U2jIS90jsdAOuz/1D7gVpGKQPLeXAlyXImDW
         esPS/upzy8yWYM9mQ5J1Zx97rxI8cYVctdpXr05gPyoz8GXczmXfSf5Z22e5GMRjgluP
         mdIhdu0nbtD2qVD9vYF4XBqx/qCvcNX0WVdJTIjkGqz7Gu3YNn8aOFUt89sA3n1C7Qmm
         xg0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=DoMcJr+VyLMMY95yzkLAuHASV16tCBOrYRKegmAnMWo=;
        b=NdBdwHr+CY5EMSJVPclVIP33epWByla4sy8aGwinQaNDLBndkCoBHQUjH6DZNIcWUH
         e9n0a2lMXsU2XCpolVQu8ylDiXBBvLwdXbYIet2iY2bVDjOfLttlsethm7Wx7wc0eAKw
         GY7rlAxW65fhitoVeTrHfDKPJnNvOkWTB1THj2Ceh7P0SnFcQABXSMLmxleQ1x7c8lRA
         r6dV6vf/o4/LKWeyAmZNhR/M/zFL4Ilmnf4+gEsH3IjfN+QK4m/oBBeqqtTmB4CXeEKo
         BDiBPwWMW5gRwr7LFcsDudEJnrwKTvtmZWMNv6vOyQZ+Ut/jjp8V2uY/JoXbLRNLudCC
         H+FQ==
X-Gm-Message-State: AHQUAuayYvhhAYnJjV1HjjC0mAsieS3IQ4qJ70LuNJaE65xkbWIzCkdE
        CjkinZDbdzm7PUnBICN+Xyaamqg=
X-Google-Smtp-Source: AHgI3IZmOfocecnvgfn+YBiSjjtGhWjAF/AhB324snzQAOpH48ESKs00YCE/i8R8EIgOK2zz5ebxow==
X-Received: by 2002:a17:902:7e4c:: with SMTP id a12mr279996pln.340.1550779374527;
        Thu, 21 Feb 2019 12:02:54 -0800 (PST)
Received: from ubuntu-vm.corp.microsoft.com ([2001:4898:80e8:a:a184:4e9f:6b7c:507d])
        by smtp.gmail.com with ESMTPSA id e63sm29952297pfb.25.2019.02.21.12.02.53
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 21 Feb 2019 12:02:53 -0800 (PST)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     linux-cifs@vger.kernel.org
Subject: [PATCH v2] CIFS: Do not skip SMB2 message IDs on send failures
Date:   Thu, 21 Feb 2019 12:02:46 -0800
Message-Id: <1550779366-38445-1-git-send-email-pshilov@microsoft.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When we hit failures during constructing MIDs or sending PDUs
through the network, we end up not using message IDs assigned
to the packet. The next SMB packet will skip those message IDs
and continue with the next one. This behavior may lead to a server
not granting us credits until we use the skipped IDs. Fix this by
reverting the current ID to the original value if any errors occur
before we push the packet through the network stack.

This patch fixes the generic/310 test from the xfs-tests.

Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/cifsglob.h      | 18 ++++++++++++++++++
 fs/cifs/smb2ops.c       | 12 ++++++++++++
 fs/cifs/smb2transport.c | 12 ++++++++++--
 fs/cifs/transport.c     |  6 +++++-
 4 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 5bf463c..31c63e7 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -238,6 +238,8 @@ struct smb_version_operations {
 	int * (*get_credits_field)(struct TCP_Server_Info *, const int);
 	unsigned int (*get_credits)(struct mid_q_entry *);
 	__u64 (*get_next_mid)(struct TCP_Server_Info *);
+	void (*revert_current_mid)(struct TCP_Server_Info *server,
+				   const unsigned int val);
 	/* data offset from read response message */
 	unsigned int (*read_data_offset)(char *);
 	/*
@@ -789,6 +791,22 @@ get_next_mid(struct TCP_Server_Info *server)
 	return cpu_to_le16(mid);
 }
 
+static inline void
+revert_current_mid(struct TCP_Server_Info *server, const unsigned int val)
+{
+	if (server->ops->revert_current_mid)
+		server->ops->revert_current_mid(server, val);
+}
+
+static inline void
+revert_current_mid_from_hdr(struct TCP_Server_Info *server,
+			    const struct smb2_sync_hdr *shdr)
+{
+	unsigned int num = le16_to_cpu(shdr->CreditCharge);
+
+	return revert_current_mid(server, num > 0 ? num : 1);
+}
+
 static inline __u16
 get_mid(const struct smb_hdr *smb)
 {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 080929a..1243407 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -265,6 +265,14 @@ smb2_get_next_mid(struct TCP_Server_Info *server)
 	return mid;
 }
 
+static void
+smb2_revert_current_mid(struct TCP_Server_Info *server, const unsigned int val)
+{
+	spin_lock(&GlobalMid_Lock);
+	server->CurrentMid -= val;
+	spin_unlock(&GlobalMid_Lock);
+}
+
 static struct mid_q_entry *
 smb2_find_mid(struct TCP_Server_Info *server, char *buf)
 {
@@ -3606,6 +3614,7 @@ struct smb_version_operations smb20_operations = {
 	.get_credits = smb2_get_credits,
 	.wait_mtu_credits = cifs_wait_mtu_credits,
 	.get_next_mid = smb2_get_next_mid,
+	.revert_current_mid = smb2_revert_current_mid,
 	.read_data_offset = smb2_read_data_offset,
 	.read_data_length = smb2_read_data_length,
 	.map_error = map_smb2_to_linux_error,
@@ -3702,6 +3711,7 @@ struct smb_version_operations smb21_operations = {
 	.wait_mtu_credits = smb2_wait_mtu_credits,
 	.adjust_credits = smb2_adjust_credits,
 	.get_next_mid = smb2_get_next_mid,
+	.revert_current_mid = smb2_revert_current_mid,
 	.read_data_offset = smb2_read_data_offset,
 	.read_data_length = smb2_read_data_length,
 	.map_error = map_smb2_to_linux_error,
@@ -3799,6 +3809,7 @@ struct smb_version_operations smb30_operations = {
 	.wait_mtu_credits = smb2_wait_mtu_credits,
 	.adjust_credits = smb2_adjust_credits,
 	.get_next_mid = smb2_get_next_mid,
+	.revert_current_mid = smb2_revert_current_mid,
 	.read_data_offset = smb2_read_data_offset,
 	.read_data_length = smb2_read_data_length,
 	.map_error = map_smb2_to_linux_error,
@@ -3905,6 +3916,7 @@ struct smb_version_operations smb311_operations = {
 	.wait_mtu_credits = smb2_wait_mtu_credits,
 	.adjust_credits = smb2_adjust_credits,
 	.get_next_mid = smb2_get_next_mid,
+	.revert_current_mid = smb2_revert_current_mid,
 	.read_data_offset = smb2_read_data_offset,
 	.read_data_length = smb2_read_data_length,
 	.map_error = map_smb2_to_linux_error,
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 7b351c6..5609c0b 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -674,13 +674,18 @@ smb2_setup_request(struct cifs_ses *ses, struct smb_rqst *rqst)
 	smb2_seq_num_into_buf(ses->server, shdr);
 
 	rc = smb2_get_mid_entry(ses, shdr, &mid);
-	if (rc)
+	if (rc) {
+		revert_current_mid_from_hdr(ses->server, shdr);
 		return ERR_PTR(rc);
+	}
+
 	rc = smb2_sign_rqst(rqst, ses->server);
 	if (rc) {
+		revert_current_mid_from_hdr(ses->server, shdr);
 		cifs_delete_mid(mid);
 		return ERR_PTR(rc);
 	}
+
 	return mid;
 }
 
@@ -695,11 +700,14 @@ smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	smb2_seq_num_into_buf(server, shdr);
 
 	mid = smb2_mid_entry_alloc(shdr, server);
-	if (mid == NULL)
+	if (mid == NULL) {
+		revert_current_mid_from_hdr(server, shdr);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	rc = smb2_sign_rqst(rqst, server);
 	if (rc) {
+		revert_current_mid_from_hdr(server, shdr);
 		DeleteMidQEntry(mid);
 		return ERR_PTR(rc);
 	}
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index d4f1224f..849a45d 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -695,6 +695,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	cifs_in_send_dec(server);
 
 	if (rc < 0) {
+		revert_current_mid(server, credits.value);
 		server->sequence_number -= 2;
 		cifs_delete_mid(mid);
 	}
@@ -988,6 +989,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	for (i = 0; i < num_rqst; i++) {
 		midQ[i] = ses->server->ops->setup_request(ses, &rqst[i]);
 		if (IS_ERR(midQ[i])) {
+			revert_current_mid(ses->server, i);
 			for (j = 0; j < i; j++)
 				cifs_delete_mid(midQ[j]);
 			mutex_unlock(&ses->server->srv_mutex);
@@ -1017,8 +1019,10 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	for (i = 0; i < num_rqst; i++)
 		cifs_save_when_sent(midQ[i]);
 
-	if (rc < 0)
+	if (rc < 0) {
+		revert_current_mid(ses->server, num_rqst);
 		ses->server->sequence_number -= 2;
+	}
 
 	mutex_unlock(&ses->server->srv_mutex);
 
-- 
2.7.4

