Return-Path: <SRS0=lkMc=RF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A1BFC43381
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Mar 2019 02:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE57D2083E
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Mar 2019 02:26:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u1n8xHfJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfCBC0Q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Mar 2019 21:26:16 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39991 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbfCBC0Q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Mar 2019 21:26:16 -0500
Received: by mail-pg1-f193.google.com with SMTP id u9so12299013pgo.7
        for <linux-cifs@vger.kernel.org>; Fri, 01 Mar 2019 18:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3cCr9wT0miKTx9uvul05G4Rm9v5a4OqoyRjUsry1DnE=;
        b=u1n8xHfJ52iKhUUw/l3ShKoijfVpOt5MDJmfELkpKQIAdcCvRb5dVNEBWT+cb62ujq
         Ekbjz5anmFQVRUKRH0E0DzTq2j6dt8i29owZRMcnn6Vx6YNUEW1rGDQEjBkPFh1946Ew
         QK86Qt01QbOQer2I6HJ1n9B2ch1zc7h030WyNTDsfBTyPpXLrsC6F4qrpmXl/MIdkFeC
         U0h4bpODHJnC5U00mn7XsVuR8cAGwnXhmttaI5Bt8VwArkJnaed5CuzUxBAPtXiiE6v6
         X+pNrCRAWY/pdYzkg4Qa9wMLVbQseB11L0hMrlbxJ3FQolHQibT87vT/CVSYYtkk74/j
         MVvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3cCr9wT0miKTx9uvul05G4Rm9v5a4OqoyRjUsry1DnE=;
        b=lrl6sbbU7QDGvjrBjyIzIuv8ms6do816Ll6VHMaYJ9IR6utt7lhoZ/ZTq8BMNfGRt5
         83cW15Yi/nfid6p9Y8DV6WZ3Mj62pU0xtlGCBeYzFSagbPTR9fjRHcd7qycAPWG1DFY+
         xvHYA/6vuQScRtQjEjBayNYylHTT4lgSgp+qJjVR6YxzE4G6tSLBpHCFX8OlmqMu5s1k
         VaGRnk/LK6i9qwDALUXSYG6giEa1QAN8gqfntzWyx8Z2GlYfj2DFz/D3TCE2oPuoSPpy
         +MkEVn2O9it5+fEq5YMyMoAAzGDf7FDkm9JoHBrov41mZhnFMbawcZJfUvOIGRZu5L0V
         Nebw==
X-Gm-Message-State: APjAAAVQU/dTYl8KlaGV/0Echn94zSo8UUbZPJaU1O/ALAMpF1w2tI9c
        XWfY+zVNL0qbFvqDX3g/7lfDtTQ=
X-Google-Smtp-Source: APXvYqw735H6NT+hLKiWZ9gViY/F7Urzc45gni9hNlKj/omZOEoLFhpZtkHVePqrrZt5aLXX0zoXNA==
X-Received: by 2002:a65:620f:: with SMTP id d15mr8063085pgv.112.1551493574354;
        Fri, 01 Mar 2019 18:26:14 -0800 (PST)
Received: from ubuntu-vm.corp.microsoft.com ([2001:4898:80e8:f:a17f:4e9f:6b7c:507d])
        by smtp.gmail.com with ESMTPSA id h11sm17560049pgq.57.2019.03.01.18.26.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 01 Mar 2019 18:26:13 -0800 (PST)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, lsahlber@redhat.com
Subject: [PATCH v3] CIFS: Do not skip SMB2 message IDs on send failures
Date:   Fri,  1 Mar 2019 18:26:07 -0800
Message-Id: <1551493567-97156-1-git-send-email-pshilov@microsoft.com>
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

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/cifsglob.h      | 18 ++++++++++++++++++
 fs/cifs/smb2ops.c       | 12 ++++++++++++
 fs/cifs/smb2transport.c | 12 ++++++++++--
 fs/cifs/transport.c     |  6 +++++-
 4 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 33264f9a..fe4eed1 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -236,6 +236,8 @@ struct smb_version_operations {
 	int * (*get_credits_field)(struct TCP_Server_Info *, const int);
 	unsigned int (*get_credits)(struct mid_q_entry *);
 	__u64 (*get_next_mid)(struct TCP_Server_Info *);
+	void (*revert_current_mid)(struct TCP_Server_Info *server,
+				   const unsigned int val);
 	/* data offset from read response message */
 	unsigned int (*read_data_offset)(char *);
 	/*
@@ -771,6 +773,22 @@ get_next_mid(struct TCP_Server_Info *server)
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
index 1670494..254d602 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -219,6 +219,14 @@ smb2_get_next_mid(struct TCP_Server_Info *server)
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
@@ -3560,6 +3568,7 @@ struct smb_version_operations smb20_operations = {
 	.get_credits = smb2_get_credits,
 	.wait_mtu_credits = cifs_wait_mtu_credits,
 	.get_next_mid = smb2_get_next_mid,
+	.revert_current_mid = smb2_revert_current_mid,
 	.read_data_offset = smb2_read_data_offset,
 	.read_data_length = smb2_read_data_length,
 	.map_error = map_smb2_to_linux_error,
@@ -3655,6 +3664,7 @@ struct smb_version_operations smb21_operations = {
 	.get_credits = smb2_get_credits,
 	.wait_mtu_credits = smb2_wait_mtu_credits,
 	.get_next_mid = smb2_get_next_mid,
+	.revert_current_mid = smb2_revert_current_mid,
 	.read_data_offset = smb2_read_data_offset,
 	.read_data_length = smb2_read_data_length,
 	.map_error = map_smb2_to_linux_error,
@@ -3751,6 +3761,7 @@ struct smb_version_operations smb30_operations = {
 	.get_credits = smb2_get_credits,
 	.wait_mtu_credits = smb2_wait_mtu_credits,
 	.get_next_mid = smb2_get_next_mid,
+	.revert_current_mid = smb2_revert_current_mid,
 	.read_data_offset = smb2_read_data_offset,
 	.read_data_length = smb2_read_data_length,
 	.map_error = map_smb2_to_linux_error,
@@ -3856,6 +3867,7 @@ struct smb_version_operations smb311_operations = {
 	.get_credits = smb2_get_credits,
 	.wait_mtu_credits = smb2_wait_mtu_credits,
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
index 53532bd..d680c7b 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -647,6 +647,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	cifs_in_send_dec(server);
 
 	if (rc < 0) {
+		revert_current_mid_from_hdr(server, rqst->rq_iov[0].iov_base);
 		server->sequence_number -= 2;
 		cifs_delete_mid(mid);
 	}
@@ -868,6 +869,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	for (i = 0; i < num_rqst; i++) {
 		midQ[i] = ses->server->ops->setup_request(ses, &rqst[i]);
 		if (IS_ERR(midQ[i])) {
+			revert_current_mid(ses->server, i);
 			for (j = 0; j < i; j++)
 				cifs_delete_mid(midQ[j]);
 			mutex_unlock(&ses->server->srv_mutex);
@@ -897,8 +899,10 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
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

