Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E54470E99
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 03:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784776680; cv=none; b=fvptAZ502jscmWXAUCe4NlwOMTIcJ78z8rvPMTeRgM2STk8V7lzMSQK3vnZS97QUOC18tx6sJD/7r/2v+zUH9YP+L1cGaYoEhIhsqWN8OCdoz3g1ppcFpbIFYwi3U1+7O2haBaAJwUFR2dznoYSLamXFcASVCd04Qt9FciDDFos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784776680; c=relaxed/simple;
	bh=7mgDXSBDxT57/vRXB8nCRqEsuEVxsf9AoWwWSYgPYp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fp2F4tkyLC3F2PNLSlbZqLmncCdIOPT3AVlBBRt3SNfgUcBzyHGdajTfeK40LtHd4pwDvpc0/iOMIU0x4Je9ejp4t40MkkE4y2W+JYlGEukufjiBcxt0kv+B0zlFKx2hJ4hAabjuNC4uTAcncxj6DqJVExFlpb5beyEm7OYUQbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=mO+SVlMX; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="mO+SVlMX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784776674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UbpbpXjThWJN7vsgyPq48ySFSG/oVW64qA0zkIufdAQ=;
	b=mO+SVlMXBLump6VsO8Rr0NQkh3BV+U5J+blK2wtXrL4yc5t/XzwTqvNSdPjyG0mb1D8DrM
	hl9ca8fPl/Gn3G+zu5nEp2a4NtotsgH9Ek7FRysmajVkElJJQ05hZ6LqQ3lNRIoBwORwgV
	6UJJf7cdUyRYDvngT9Iw7DuW6vjdq2aFYSCxLs5l7lj4dCyoDACJnJoRgxaegln8nytr95
	vb+CHkQ2H/CLI1kmlFA3dGkFhIU8BFFwLn9AkkO/RGvjebILN9g3pAlWM9uNMb7B+k9uGS
	51hzxAVWfFMv2u8MfXiVi57KK0/evlroA+tzT1BOcUGXdTnz7/ZrdouSaTo4og==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	gael.blivet@gmail.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [RFC PATCH 03/11] smb/server: support canceling notify requests
Date: Thu, 23 Jul 2026 03:16:31 +0000
Message-ID: <20260723031644.312866-4-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260723031644.312866-1-chenxiaosong@chenxiaosong.com>
References: <20260723031644.312866-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Register CHANGE_NOTIFY requests as asynchronous work so SMB2 CANCEL
requests can wake and complete them with STATUS_CANCELLED.

Example:

  1. smbinfo notify /mnt
  2. Then press `Ctrl+C` to exit `smbinfo notify` command.
  3. The following packets can be captured using tcpdump:
     - Notify Request, File: <share>
     - Notify Response, Error: STATUS_PENDING
     - Cancel Request
     - Notify Response, Error: STATUS_CANCELLED

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/notify.c | 103 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 99 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/notify.c b/fs/smb/server/notify.c
index ad812fde5879..d1b971a75037 100644
--- a/fs/smb/server/notify.c
+++ b/fs/smb/server/notify.c
@@ -8,6 +8,9 @@
  *
  */
 
+#include <linux/slab.h>
+#include <linux/wait.h>
+
 #include "glob.h"
 #include "../common/smb2status.h"
 #include "connection.h"
@@ -17,6 +20,18 @@
 #include "smb2pdu.h"
 #include "vfs_cache.h"
 
+struct ksmbd_notify_req {
+	wait_queue_head_t wait;
+};
+
+static void smb2_notify_cancel(void **argv)
+{
+	struct ksmbd_notify_req *notify_req = argv[0];
+
+	ksmbd_debug(NOTIFY, "Wake pending notify request\n");
+	wake_up(&notify_req->wait);
+}
+
 static struct ksmbd_file *
 ksmbd_notify_validate_req(struct ksmbd_work *work,
 			  struct smb2_change_notify_req *req,
@@ -73,6 +88,36 @@ ksmbd_notify_validate_req(struct ksmbd_work *work,
 	return ERR_PTR(err);
 }
 
+static int ksmbd_notify_wait(struct ksmbd_work *work,
+			     struct ksmbd_file *fp,
+			     struct ksmbd_notify_req *notify_req)
+{
+	int err;
+
+	spin_lock(&fp->f_lock);
+	list_add_tail(&work->fp_entry, &fp->blocked_works);
+	spin_unlock(&fp->f_lock);
+
+	ksmbd_debug(NOTIFY, "Notify request pending, async id %d\n",
+		    work->async_id);
+	smb2_send_interim_resp(work, STATUS_PENDING);
+
+	err = wait_event_interruptible(notify_req->wait,
+				       READ_ONCE(work->state) !=
+					       KSMBD_WORK_ACTIVE);
+	if (err && READ_ONCE(work->state) == KSMBD_WORK_ACTIVE) {
+		pr_err("Notify wait interrupted, async id %d: %d\n",
+		       work->async_id, err);
+		WRITE_ONCE(work->state, KSMBD_WORK_CANCELLED);
+	}
+
+	spin_lock(&fp->f_lock);
+	list_del_init(&work->fp_entry);
+	spin_unlock(&fp->f_lock);
+
+	return err;
+}
+
 /**
  * ksmbd_handle_notify() - handle an SMB2 change notify request
  * @work: smb work containing notify command buffer
@@ -85,24 +130,74 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
 			struct smb2_change_notify_req *req,
 			struct smb2_change_notify_rsp *rsp)
 {
+	struct ksmbd_notify_req *notify_req = NULL;
 	struct ksmbd_file *fp = NULL;
+	void **argv = NULL;
+	bool async_work = false;
 	int err = 0;
 
 	fp = ksmbd_notify_validate_req(work, req, rsp);
 	if (IS_ERR(fp)) {
 		err = PTR_ERR(fp);
+		fp = NULL;
 		goto out;
 	}
 
-	ksmbd_fd_put(work, fp);
-	rsp->hdr.Status = STATUS_NOT_IMPLEMENTED;
-	err = -EOPNOTSUPP;
+	notify_req = kzalloc_obj(*notify_req, KSMBD_DEFAULT_GFP);
+	if (!notify_req) {
+		pr_err("Failed to allocate notify request\n");
+		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+		err = -ENOMEM;
+		goto out;
+	}
+
+	argv = kmalloc_obj(*argv, KSMBD_DEFAULT_GFP);
+	if (!argv) {
+		pr_err("Failed to allocate notify cancel arguments\n");
+		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+		err = -ENOMEM;
+		goto out;
+	}
+
+	init_waitqueue_head(&notify_req->wait);
+	argv[0] = notify_req;
+	err = setup_async_work(work, smb2_notify_cancel, argv);
+	if (err) {
+		pr_err("Failed to set up asynchronous notify work: %d\n", err);
+		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+		goto out;
+	}
+	async_work = true;
+
+	err = ksmbd_notify_wait(work, fp, notify_req);
+
+	if (work->state == KSMBD_WORK_CANCELLED) {
+		ksmbd_debug(NOTIFY, "Notify request cancelled, async id %d\n",
+			    work->async_id);
+		rsp->hdr.Status = STATUS_CANCELLED;
+		smb2_send_interim_resp(work, STATUS_CANCELLED);
+		work->send_no_response = 1;
+	} else if (work->state == KSMBD_WORK_CLOSED) {
+		ksmbd_debug(NOTIFY, "Notify handle closed, async id %d\n",
+			    work->async_id);
+		rsp->hdr.Status = STATUS_NOTIFY_CLEANUP;
+		smb2_send_interim_resp(work, STATUS_NOTIFY_CLEANUP);
+		work->send_no_response = 1;
+	}
 
 out:
 	if (err)
 		pr_err("Failed to handle notify request: %d, status: 0x%x\n",
 		       err, le32_to_cpu(rsp->hdr.Status));
-	if (rsp->hdr.Status != STATUS_SUCCESS)
+	if (rsp->hdr.Status != STATUS_SUCCESS && !work->send_no_response)
 		smb2_set_err_rsp(work);
+	if (async_work)
+		release_async_work(work);
+	else
+		kfree(argv);
+	if (notify_req)
+		kfree(notify_req);
+	if (fp)
+		ksmbd_fd_put(work, fp);
 	return err;
 }
-- 
2.54.0

