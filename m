Return-Path: <SRS0=KUb6=YP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A15FCA9EA0
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Oct 2019 22:35:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CE0920684
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Oct 2019 22:35:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KSlK/Nwm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfJVWfr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Oct 2019 18:35:47 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43624 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbfJVWfr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Oct 2019 18:35:47 -0400
Received: by mail-pg1-f195.google.com with SMTP id l24so5898699pgh.10
        for <linux-cifs@vger.kernel.org>; Tue, 22 Oct 2019 15:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0hz6JZ1A/tllfY5VVU3fDOAzMU/4M/IB2bA7mLCUzrI=;
        b=KSlK/NwmjLA8g+wpQgP9ixAftinYgVWlS5AqhEfrWQdS28ENqNwUvNw95ACiJTE3cA
         5yUvoqY2hbBKzORaZmzTgFBs9cH0ew5cFpLySlT2QsqUlEADC7XsNAHg1zm+z4ojsg0s
         SWrpXfJJp12pvdYvw1YOggLnB0kbwR1Zmqm4OcnF+ugGhaCLTu9Lmd0Dt4CCO4Q6Gn//
         JuGb3gyggKc+SK6bQfzxfbjSvp8OQgrDeWZ1lPYgJVekcoiuxq+RsuNHRUmEDVMRv/Kv
         4kXrsVMeNbTTUyaLeCFqqhGt+ZN52BfF5MaxWmMb7QvRlrM7WtT+ggZZ6iX6PoRVYB+T
         7uYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0hz6JZ1A/tllfY5VVU3fDOAzMU/4M/IB2bA7mLCUzrI=;
        b=OA3hSrO+EPoGeh41wD7tsQuVCS7yXXj9yMjPoxPoj3V28tk+/V1LJtJaldeHGa8Ad1
         mrDBZDg4n0cZAGiudrAwqlrk9R+X1D2dI+jTIMQGszGqNMiG5j8ohg7e2VhAO3Ps37yC
         Bj9lwhajkdhAfAqtMEXtb5fJGm/C5AwrZV2cRdFPpRYCr5mSZfmAJfetksAboyMT1hou
         +4hGGi4OxEqYRf9z6fMwijrss0tEU45eRmZY1o+OgNrn0A9XILXBj5BDxdnm8oPVJqM8
         tWpsUvsvXBpwx4dLsXg0FVih9m6o3QepXZRwOB7AX7ctn956GNWsovBgSfbbrRbsj34T
         MI1g==
X-Gm-Message-State: APjAAAWDW8INie12tSKV16Z4cshgMYwrtQAf0FpmspOSq281uFNf7Nf5
        MHEjuclWyNeThBeKBKH5hQ==
X-Google-Smtp-Source: APXvYqxGPsMkafMYlWJ3XTn9VkuyiOILvTguy2nC6p8JMkNPznLTp0sOKt06EfkrRTBynyqAJFoeVA==
X-Received: by 2002:a63:e509:: with SMTP id r9mr6322271pgh.431.1571783744929;
        Tue, 22 Oct 2019 15:35:44 -0700 (PDT)
Received: from ubuntu-vm.mshome.net ([167.220.2.234])
        by smtp.gmail.com with ESMTPSA id j63sm4347999pfb.162.2019.10.22.15.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 15:35:44 -0700 (PDT)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        David Wysochanski <dwysocha@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Pavel Shilovskiy <pshilov@microsoft.com>
Subject: [PATCH] CIFS: Fix retry mid list corruption on reconnects
Date:   Tue, 22 Oct 2019 15:35:34 -0700
Message-Id: <20191022223534.21711-1-pshilov@microsoft.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When the client hits reconnect it iterates over the mid
pending queue marking entries for retry and moving them
to a temporary list to issue callbacks later without holding
GlobalMid_Lock. In the same time there is no guarantee that
mids can't be removed from the temporary list or even
freed completely by another thread. It may cause a temporary
list corruption:

[  430.454897] list_del corruption. prev->next should be ffff98d3a8f316c0, but was 2e885cb266355469
[  430.464668] ------------[ cut here ]------------
[  430.466569] kernel BUG at lib/list_debug.c:51!
[  430.468476] invalid opcode: 0000 [#1] SMP PTI
[  430.470286] CPU: 0 PID: 13267 Comm: cifsd Kdump: loaded Not tainted 5.4.0-rc3+ #19
[  430.473472] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  430.475872] RIP: 0010:__list_del_entry_valid.cold+0x31/0x55
...
[  430.510426] Call Trace:
[  430.511500]  cifs_reconnect+0x25e/0x610 [cifs]
[  430.513350]  cifs_readv_from_socket+0x220/0x250 [cifs]
[  430.515464]  cifs_read_from_socket+0x4a/0x70 [cifs]
[  430.517452]  ? try_to_wake_up+0x212/0x650
[  430.519122]  ? cifs_small_buf_get+0x16/0x30 [cifs]
[  430.521086]  ? allocate_buffers+0x66/0x120 [cifs]
[  430.523019]  cifs_demultiplex_thread+0xdc/0xc30 [cifs]
[  430.525116]  kthread+0xfb/0x130
[  430.526421]  ? cifs_handle_standard+0x190/0x190 [cifs]
[  430.528514]  ? kthread_park+0x90/0x90
[  430.530019]  ret_from_fork+0x35/0x40

Fix this by obtaining extra references for mids being retried
and marking them as MID_DELETED which indicates that such a mid
has been dequeued from the pending list.

Also move mid cleanup logic from DeleteMidQEntry to
_cifs_mid_q_entry_release which is called when the last reference
to a particular mid is put. This allows to avoid any use-after-free
of response buffers.

The patch needs to be backported to stable kernels. A stable tag
is not mentioned below because the patch doesn't apply cleanly
to any actively maintained stable kernel.

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-and-tested-by: David Wysochanski <dwysocha@redhat.com>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/connect.c   | 10 +++++++++-
 fs/cifs/transport.c | 42 +++++++++++++++++++++++-------------------
 2 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b724227b853c..ac43c79ebdf5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -564,9 +564,11 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	spin_lock(&GlobalMid_Lock);
 	list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
+		kref_get(&mid_entry->refcount);
 		if (mid_entry->mid_state == MID_REQUEST_SUBMITTED)
 			mid_entry->mid_state = MID_RETRY_NEEDED;
 		list_move(&mid_entry->qhead, &retry_list);
+		mid_entry->mid_flags |= MID_DELETED;
 	}
 	spin_unlock(&GlobalMid_Lock);
 	mutex_unlock(&server->srv_mutex);
@@ -576,6 +578,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 		list_del_init(&mid_entry->qhead);
 		mid_entry->callback(mid_entry);
+		cifs_mid_q_entry_release(mid_entry);
 	}
 
 	if (cifs_rdma_enabled(server)) {
@@ -895,8 +898,10 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
 	if (mid->mid_flags & MID_DELETED)
 		printk_once(KERN_WARNING
 			    "trying to dequeue a deleted mid\n");
-	else
+	else {
 		list_del_init(&mid->qhead);
+		mid->mid_flags |= MID_DELETED;
+	}
 	spin_unlock(&GlobalMid_Lock);
 }
 
@@ -966,8 +971,10 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 			cifs_dbg(FYI, "Clearing mid 0x%llx\n", mid_entry->mid);
+			kref_get(&mid_entry->refcount);
 			mid_entry->mid_state = MID_SHUTDOWN;
 			list_move(&mid_entry->qhead, &dispose_list);
+			mid_entry->mid_flags |= MID_DELETED;
 		}
 		spin_unlock(&GlobalMid_Lock);
 
@@ -977,6 +984,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 			cifs_dbg(FYI, "Callback mid 0x%llx\n", mid_entry->mid);
 			list_del_init(&mid_entry->qhead);
 			mid_entry->callback(mid_entry);
+			cifs_mid_q_entry_release(mid_entry);
 		}
 		/* 1/8th of sec is more than enough time for them to exit */
 		msleep(125);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 308ad0f495e1..ca3de62688d6 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -86,22 +86,8 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 
 static void _cifs_mid_q_entry_release(struct kref *refcount)
 {
-	struct mid_q_entry *mid = container_of(refcount, struct mid_q_entry,
-					       refcount);
-
-	mempool_free(mid, cifs_mid_poolp);
-}
-
-void cifs_mid_q_entry_release(struct mid_q_entry *midEntry)
-{
-	spin_lock(&GlobalMid_Lock);
-	kref_put(&midEntry->refcount, _cifs_mid_q_entry_release);
-	spin_unlock(&GlobalMid_Lock);
-}
-
-void
-DeleteMidQEntry(struct mid_q_entry *midEntry)
-{
+	struct mid_q_entry *midEntry =
+			container_of(refcount, struct mid_q_entry, refcount);
 #ifdef CONFIG_CIFS_STATS2
 	__le16 command = midEntry->server->vals->lock_cmd;
 	__u16 smb_cmd = le16_to_cpu(midEntry->command);
@@ -166,6 +152,19 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
 		}
 	}
 #endif
+
+	mempool_free(midEntry, cifs_mid_poolp);
+}
+
+void cifs_mid_q_entry_release(struct mid_q_entry *midEntry)
+{
+	spin_lock(&GlobalMid_Lock);
+	kref_put(&midEntry->refcount, _cifs_mid_q_entry_release);
+	spin_unlock(&GlobalMid_Lock);
+}
+
+void DeleteMidQEntry(struct mid_q_entry *midEntry)
+{
 	cifs_mid_q_entry_release(midEntry);
 }
 
@@ -173,8 +172,10 @@ void
 cifs_delete_mid(struct mid_q_entry *mid)
 {
 	spin_lock(&GlobalMid_Lock);
-	list_del_init(&mid->qhead);
-	mid->mid_flags |= MID_DELETED;
+	if (!(mid->mid_flags & MID_DELETED)) {
+		list_del_init(&mid->qhead);
+		mid->mid_flags |= MID_DELETED;
+	}
 	spin_unlock(&GlobalMid_Lock);
 
 	DeleteMidQEntry(mid);
@@ -872,7 +873,10 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 		rc = -EHOSTDOWN;
 		break;
 	default:
-		list_del_init(&mid->qhead);
+		if (!(mid->mid_flags & MID_DELETED)) {
+			list_del_init(&mid->qhead);
+			mid->mid_flags |= MID_DELETED;
+		}
 		cifs_server_dbg(VFS, "%s: invalid mid state mid=%llu state=%d\n",
 			 __func__, mid->mid, mid->mid_state);
 		rc = -EIO;
-- 
2.17.1

