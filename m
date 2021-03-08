Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60459C433DB
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 15:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34501650CB
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 15:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCHPBe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:01:34 -0500
Received: from mx.cjr.nz ([51.158.111.142]:40580 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231311AbhCHPBQ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 8 Mar 2021 10:01:16 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 540AF7FF6B;
        Mon,  8 Mar 2021 15:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1615215675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gyEVA9D0C7y+60GNpuGulUP1XyL92FTaSNuODqVrp0g=;
        b=XuO8/YELZNbLPIIK9NEs+7PeBaYLBuHpVnlILQU3JAnJmND4xInPlKq3Y+PjhJdMf0sF1b
        Q+C8xDNmWPJUhQywoNB1ZltqKjdUQEMXeLNWclFNR/OrzsgrtbvgPJGymWlINe7nC0giDK
        LOEN5jDtVvDjX5MOQmPTWmWt0QVANu8YvrJX/3zBkA608WGUXCJLcUrg7HUSISxE2Crg7f
        iwUFFLbS6UJfl54smNCefJovi8FIkq/z95JHyuPX/N0U/0RSSXB7/FntV9MWqNdQZs2Cq+
        tXMPyn28CImRXFw+hQz0RntD3N/7yIHddbeKQpAApiKETX/419iTTGV3m+fktQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 4/4] cifs: do not send close in compound create+close requests
Date:   Mon,  8 Mar 2021 12:00:50 -0300
Message-Id: <20210308150050.19902-4-pc@cjr.nz>
In-Reply-To: <20210308150050.19902-1-pc@cjr.nz>
References: <20210308150050.19902-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In case of interrupted syscalls, prevent sending CLOSE commands for
compound CREATE+CLOSE requests by introducing an
CIFS_CP_CREATE_CLOSE_OP flag to indicate lower layers that it should
not send a CLOSE command to the MIDs corresponding the compound
CREATE+CLOSE request.

A simple reproducer:

    #!/bin/bash

    mount //server/share /mnt -o username=foo,password=***
    tc qdisc add dev eth0 root netem delay 450ms
    stat -f /mnt &>/dev/null & pid=$!
    sleep 0.01
    kill $pid
    tc qdisc del dev eth0 root
    umount /mnt

Before patch:

    ...
    6 0.256893470 192.168.122.2 → 192.168.122.15 SMB2 402 Create Request File: ;GetInfo Request FS_INFO/FileFsFullSizeInformation;Close Request
    7 0.257144491 192.168.122.15 → 192.168.122.2 SMB2 498 Create Response File: ;GetInfo Response;Close Response
    9 0.260798209 192.168.122.2 → 192.168.122.15 SMB2 146 Close Request File:
   10 0.260841089 192.168.122.15 → 192.168.122.2 SMB2 130 Close Response, Error: STATUS_FILE_CLOSED

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/cifsglob.h  | 19 ++++++++++---------
 fs/cifs/smb2inode.c |  1 +
 fs/cifs/smb2misc.c  |  8 ++++----
 fs/cifs/smb2ops.c   | 10 +++++-----
 fs/cifs/smb2proto.h |  3 +--
 fs/cifs/transport.c |  2 +-
 6 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3de3c5908a72..31fc8695abd6 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -257,7 +257,7 @@ struct smb_version_operations {
 	/* verify the message */
 	int (*check_message)(char *, unsigned int, struct TCP_Server_Info *);
 	bool (*is_oplock_break)(char *, struct TCP_Server_Info *);
-	int (*handle_cancelled_mid)(char *, struct TCP_Server_Info *);
+	int (*handle_cancelled_mid)(struct mid_q_entry *, struct TCP_Server_Info *);
 	void (*downgrade_oplock)(struct TCP_Server_Info *server,
 				 struct cifsInodeInfo *cinode, __u32 oplock,
 				 unsigned int epoch, bool *purge_cache);
@@ -1705,16 +1705,17 @@ static inline bool is_retryable_error(int error)
 #define   CIFS_NO_RSP_BUF   0x040    /* no response buffer required */
 
 /* Type of request operation */
-#define   CIFS_ECHO_OP      0x080    /* echo request */
-#define   CIFS_OBREAK_OP   0x0100    /* oplock break request */
-#define   CIFS_NEG_OP      0x0200    /* negotiate request */
+#define   CIFS_ECHO_OP            0x080  /* echo request */
+#define   CIFS_OBREAK_OP          0x0100 /* oplock break request */
+#define   CIFS_NEG_OP             0x0200 /* negotiate request */
+#define   CIFS_CP_CREATE_CLOSE_OP 0x0400 /* compound create+close request */
 /* Lower bitmask values are reserved by others below. */
-#define   CIFS_SESS_OP     0x2000    /* session setup request */
-#define   CIFS_OP_MASK     0x2380    /* mask request type */
+#define   CIFS_SESS_OP            0x2000 /* session setup request */
+#define   CIFS_OP_MASK            0x2780 /* mask request type */
 
-#define   CIFS_HAS_CREDITS 0x0400    /* already has credits */
-#define   CIFS_TRANSFORM_REQ 0x0800    /* transform request before sending */
-#define   CIFS_NO_SRV_RSP    0x1000    /* there is no server response */
+#define   CIFS_HAS_CREDITS        0x0400 /* already has credits */
+#define   CIFS_TRANSFORM_REQ      0x0800 /* transform request before sending */
+#define   CIFS_NO_SRV_RSP         0x1000 /* there is no server response */
 
 /* Security Flags: indicate type of session setup needed */
 #define   CIFSSEC_MAY_SIGN	0x00001
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 1f900b81c34a..a718dc77e604 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -358,6 +358,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	if (cfile)
 		goto after_close;
 	/* Close */
+	flags |= CIFS_CP_CREATE_CLOSE_OP;
 	rqst[num_rqst].rq_iov = &vars->close_iov[0];
 	rqst[num_rqst].rq_nvec = 1;
 	rc = SMB2_close_init(tcon, server,
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 0a55a77d94de..c99966121757 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -844,14 +844,14 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 }
 
 int
-smb2_handle_cancelled_mid(char *buffer, struct TCP_Server_Info *server)
+smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 {
-	struct smb2_sync_hdr *sync_hdr = (struct smb2_sync_hdr *)buffer;
-	struct smb2_create_rsp *rsp = (struct smb2_create_rsp *)buffer;
+	struct smb2_sync_hdr *sync_hdr = mid->resp_buf;
+	struct smb2_create_rsp *rsp = mid->resp_buf;
 	struct cifs_tcon *tcon;
 	int rc;
 
-	if (sync_hdr->Command != SMB2_CREATE ||
+	if ((mid->optype & CIFS_CP_CREATE_CLOSE_OP) || sync_hdr->Command != SMB2_CREATE ||
 	    sync_hdr->Status != STATUS_SUCCESS)
 		return 0;
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f5087295424c..9bae7e8deb09 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1195,7 +1195,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	struct TCP_Server_Info *server = cifs_pick_channel(ses);
 	__le16 *utf16_path = NULL;
 	int ea_name_len = strlen(ea_name);
-	int flags = 0;
+	int flags = CIFS_CP_CREATE_CLOSE_OP;
 	int len;
 	struct smb_rqst rqst[3];
 	int resp_buftype[3];
@@ -1573,7 +1573,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 	struct smb_query_info qi;
 	struct smb_query_info __user *pqi;
 	int rc = 0;
-	int flags = 0;
+	int flags = CIFS_CP_CREATE_CLOSE_OP;
 	struct smb2_query_info_rsp *qi_rsp = NULL;
 	struct smb2_ioctl_rsp *io_rsp = NULL;
 	void *buffer = NULL;
@@ -2577,7 +2577,7 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	struct cifs_ses *ses = tcon->ses;
 	struct TCP_Server_Info *server = cifs_pick_channel(ses);
-	int flags = 0;
+	int flags = CIFS_CP_CREATE_CLOSE_OP;
 	struct smb_rqst rqst[3];
 	int resp_buftype[3];
 	struct kvec rsp_iov[3];
@@ -2975,7 +2975,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	unsigned int sub_offset;
 	unsigned int print_len;
 	unsigned int print_offset;
-	int flags = 0;
+	int flags = CIFS_CP_CREATE_CLOSE_OP;
 	struct smb_rqst rqst[3];
 	int resp_buftype[3];
 	struct kvec rsp_iov[3];
@@ -3157,7 +3157,7 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
 	struct TCP_Server_Info *server = cifs_pick_channel(tcon->ses);
-	int flags = 0;
+	int flags = CIFS_CP_CREATE_CLOSE_OP;
 	struct smb_rqst rqst[3];
 	int resp_buftype[3];
 	struct kvec rsp_iov[3];
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 9565e27681a5..a2eb34a8d9c9 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -246,8 +246,7 @@ extern int SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 extern int smb2_handle_cancelled_close(struct cifs_tcon *tcon,
 				       __u64 persistent_fid,
 				       __u64 volatile_fid);
-extern int smb2_handle_cancelled_mid(char *buffer,
-					struct TCP_Server_Info *server);
+extern int smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server);
 void smb2_cancelled_close_fid(struct work_struct *work);
 extern int SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 			 u64 persistent_file_id, u64 volatile_file_id,
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index f62f512e2cb1..9438a0c35473 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -109,7 +109,7 @@ static void _cifs_mid_q_entry_release(struct kref *refcount)
 	if (midEntry->resp_buf && (midEntry->mid_flags & MID_WAIT_CANCELLED) &&
 	    midEntry->mid_state == MID_RESPONSE_RECEIVED &&
 	    server->ops->handle_cancelled_mid)
-		server->ops->handle_cancelled_mid(midEntry->resp_buf, server);
+		server->ops->handle_cancelled_mid(midEntry, server);
 
 	midEntry->mid_state = MID_FREE;
 	atomic_dec(&midCount);
-- 
2.30.1

