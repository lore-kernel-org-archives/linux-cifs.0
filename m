Return-Path: <SRS0=vRfO=RH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6575C43381
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Mar 2019 22:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7E73206DD
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Mar 2019 22:02:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h0SJvjCo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfCDWC6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 Mar 2019 17:02:58 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37483 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfCDWC6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 4 Mar 2019 17:02:58 -0500
Received: by mail-pf1-f196.google.com with SMTP id s22so3998086pfh.4
        for <linux-cifs@vger.kernel.org>; Mon, 04 Mar 2019 14:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qf12NOH/efU9L7beU9Tr1OmnKH+yJYj0cLbt4EjpANQ=;
        b=h0SJvjCoLID2ZjMQzXkle2EjhfopVrUXbEp7FA1DrpuiItdQTahFicjYS0kyiQlYdo
         VT7yWvp06glCLdgbF4YsnE6on9JklK1d3mnaztx/pwjcFh9DuLwwpftxk4Ficl1Y4lJm
         6LgyAxAoMnqBJfRUdAgXowbxOWEqUX2erFFKx3fpILByLo00N3mPUB9Be7QJl9s7Yd0R
         vGvvPUsKWDXBqmbF1MNKzR28Cwe/MRox3kil2+KTlHWDGL8Pnl2PFUOQ6i+0Ys5lfLsG
         GH/XXfL7lnas55YLzVhSwOXUsGORBt4piq4+8twQATQyNy1pQe6eW0eeudz9q+sjzAd3
         Ak3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qf12NOH/efU9L7beU9Tr1OmnKH+yJYj0cLbt4EjpANQ=;
        b=tmegd94m/w30MA+pyMjrkWKTHUeQqHZw32miQTp0JQJTTODVzCkrn9gQ86IIk+BNJp
         KOj075USAGTcPbn+291pctXCyt37go3vM8TaDZvu3IA0jujznTq8z5XPUJBLBT/kegbx
         ObixIKYVz1Xc79q//qzFGkmn4EMWhf/HVCVc8e6t1tE0quO3BS5omnpv8ZpdznL++szr
         z6+uOZ1msKBS7c9hmRGEdETV4/gxWUGTYwHqFCC6FERW3GBXSsCx4GWazEH8y7D4ISLK
         Y3pDFwI3JHV1QoKniZlcDusDmHUSYwrhONt8QAEf5KLxKEwX9R1JHsATWygiOBkm4xyA
         mccw==
X-Gm-Message-State: APjAAAVx4qmEBpYZkQ6B1fV4Uiph5mkIN7YItFT0Y9R3MaSgrgnBxpm+
        wkLMxeT3AIah9sCsnq2O2E5Xr1k=
X-Google-Smtp-Source: APXvYqyE4kSCVP7I1kHKVx2xvslhi0FUZaM23YAlH5i+Nn8Vdxc6ecIbE7nkYpbvHT3qkYzsZ6DzPw==
X-Received: by 2002:a63:cc44:: with SMTP id q4mr11049382pgi.183.1551736976510;
        Mon, 04 Mar 2019 14:02:56 -0800 (PST)
Received: from ubuntu-vm.corp.microsoft.com ([2001:4898:80e8:0:a18e:4e9f:6b7c:507d])
        by smtp.gmail.com with ESMTPSA id e5sm9218595pfd.73.2019.03.04.14.02.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Mar 2019 14:02:55 -0800 (PST)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, lsahlber@redhat.com
Subject: [PATCH V4] CIFS: Do not skip SMB2 message IDs on send failures
Date:   Mon,  4 Mar 2019 14:02:50 -0800
Message-Id: <1551736970-124288-1-git-send-email-pshilov@microsoft.com>
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

Cc: <stable@vger.kernel.org> # 4.19.x
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/cifsglob.h      | 19 +++++++++++++++++++
 fs/cifs/smb2ops.c       | 13 +++++++++++++
 fs/cifs/smb2transport.c | 14 ++++++++++++--
 fs/cifs/transport.c     |  6 +++++-
 4 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 33264f9a..1b25e6e9 100644
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
@@ -1423,6 +1441,7 @@ struct mid_q_entry {
 	struct kref refcount;
 	struct TCP_Server_Info *server;	/* server corresponding to this mid */
 	__u64 mid;		/* multiplex id */
+	__u16 credits;		/* number of credits consumed by this mid */
 	__u32 pid;		/* process id */
 	__u32 sequence_number;  /* for CIFS signing */
 	unsigned long when_alloc;  /* when mid was created */
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 1670494..ea56b1c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -219,6 +219,15 @@ smb2_get_next_mid(struct TCP_Server_Info *server)
 	return mid;
 }
 
+static void
+smb2_revert_current_mid(struct TCP_Server_Info *server, const unsigned int val)
+{
+	spin_lock(&GlobalMid_Lock);
+	if (server->CurrentMid >= val)
+		server->CurrentMid -= val;
+	spin_unlock(&GlobalMid_Lock);
+}
+
 static struct mid_q_entry *
 smb2_find_mid(struct TCP_Server_Info *server, char *buf)
 {
@@ -3560,6 +3569,7 @@ struct smb_version_operations smb20_operations = {
 	.get_credits = smb2_get_credits,
 	.wait_mtu_credits = cifs_wait_mtu_credits,
 	.get_next_mid = smb2_get_next_mid,
+	.revert_current_mid = smb2_revert_current_mid,
 	.read_data_offset = smb2_read_data_offset,
 	.read_data_length = smb2_read_data_length,
 	.map_error = map_smb2_to_linux_error,
@@ -3655,6 +3665,7 @@ struct smb_version_operations smb21_operations = {
 	.get_credits = smb2_get_credits,
 	.wait_mtu_credits = smb2_wait_mtu_credits,
 	.get_next_mid = smb2_get_next_mid,
+	.revert_current_mid = smb2_revert_current_mid,
 	.read_data_offset = smb2_read_data_offset,
 	.read_data_length = smb2_read_data_length,
 	.map_error = map_smb2_to_linux_error,
@@ -3751,6 +3762,7 @@ struct smb_version_operations smb30_operations = {
 	.get_credits = smb2_get_credits,
 	.wait_mtu_credits = smb2_wait_mtu_credits,
 	.get_next_mid = smb2_get_next_mid,
+	.revert_current_mid = smb2_revert_current_mid,
 	.read_data_offset = smb2_read_data_offset,
 	.read_data_length = smb2_read_data_length,
 	.map_error = map_smb2_to_linux_error,
@@ -3856,6 +3868,7 @@ struct smb_version_operations smb311_operations = {
 	.get_credits = smb2_get_credits,
 	.wait_mtu_credits = smb2_wait_mtu_credits,
 	.get_next_mid = smb2_get_next_mid,
+	.revert_current_mid = smb2_revert_current_mid,
 	.read_data_offset = smb2_read_data_offset,
 	.read_data_length = smb2_read_data_length,
 	.map_error = map_smb2_to_linux_error,
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 7b351c6..63264db 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -576,6 +576,7 @@ smb2_mid_entry_alloc(const struct smb2_sync_hdr *shdr,
 		     struct TCP_Server_Info *server)
 {
 	struct mid_q_entry *temp;
+	unsigned int credits = le16_to_cpu(shdr->CreditCharge);
 
 	if (server == NULL) {
 		cifs_dbg(VFS, "Null TCP session in smb2_mid_entry_alloc\n");
@@ -586,6 +587,7 @@ smb2_mid_entry_alloc(const struct smb2_sync_hdr *shdr,
 	memset(temp, 0, sizeof(struct mid_q_entry));
 	kref_init(&temp->refcount);
 	temp->mid = le64_to_cpu(shdr->MessageId);
+	temp->credits = credits > 0 ? credits : 1;
 	temp->pid = current->pid;
 	temp->command = shdr->Command; /* Always LE */
 	temp->when_alloc = jiffies;
@@ -674,13 +676,18 @@ smb2_setup_request(struct cifs_ses *ses, struct smb_rqst *rqst)
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
 
@@ -695,11 +702,14 @@ smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
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
index 53532bd..9544eb9 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -647,6 +647,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	cifs_in_send_dec(server);
 
 	if (rc < 0) {
+		revert_current_mid(server, mid->credits);
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

