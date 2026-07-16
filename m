Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF859463
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 00:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784160762; cv=none; b=PoWnDDw65ONniMJcIpuSuHJBlP2p4fEwxJGxd8di9/PsIt2FGsG6udYKnSJm/fKXfYTV9+8szfUw75XMWePmEWRUUnJ6FuqQpTmfMb03/xK31hSMbiKMebASDjyQW6Q8JnkTVUTbT5pl7Ngqg0j/AVJAE2BTra+mgqyfd/ZCeP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784160762; c=relaxed/simple;
	bh=FoHhqdUfROap1S1cmZKOtpkTf/alXf9S9x37i1g6SP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OD2/GOIsxLF67f/WIAHPH+ogf+gkz9tG3gj9SEohPjzYWnxRxmcnqEJntBzK8Zn/tHVQG8putiTVtjHfbSTjUQSoKQm2Va6U5pEdDucXEV3/UONHjkktoWm2lkyNo/hndes98q6v3alGFmAOKD+sskL2u8YSiOMKChsYP6XY+Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=tn/DcIGS; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="tn/DcIGS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784160758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f2EQQv3cj+G55+WLgM6PTgf0a9azTC0O87f29xtcLYQ=;
	b=tn/DcIGSnW/xdS7Q7+PivCCG7eNo4WUao7+cMM1kZVxSla0/67hSDt2f2nwEH3J8fhSLze
	DuMLqM2HzzQzVjQ/9XCJo4ktOl4ELiZQWF6ooWgdiGhB7NrXePXW/TnJlvQahhlm9PMSXS
	lzzCLLaTyX5u8SepyL8M3XFYIeheS+8sv0hLViEve1E1t1ATOErwFHNAB3TWOJdYtnMdiF
	otDJ1pc04m9aMzKrqc3HQccMSnROcF1HK1qm0jPKy2WwU7h3H5lLKriQ/psXZSNyixn22p
	Ch5oh6nmqizNDTGJlJnngO+KC0rorALAYfNn2pv2GyFVnCUSSVCP9mmRp+d+jQ==
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
	gael.blivet@gmail.com,
	andriy.shevchenko@linux.intel.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 2/3] smb/server: cancel async requests when closing connection
Date: Thu, 16 Jul 2026 00:11:55 +0000
Message-ID: <20260716001156.671587-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260716001156.671587-1-chenxiaosong@chenxiaosong.com>
References: <20260716001156.671587-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

An async request may still be waiting when a connection is closed.
This can stop the connection from closing.

Cancel active async requests before waiting for them to finish.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/connection.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 2de1413ba64e..b31b72c07f83 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -291,6 +291,25 @@ void ksmbd_conn_try_dequeue_request(struct ksmbd_work *work)
 	wake_up_all(&conn->req_running_q);
 }
 
+static void ksmbd_conn_cancel_async_requests(struct ksmbd_conn *conn)
+{
+	struct ksmbd_work *work;
+
+	ksmbd_debug(CONN, "Cancel pending async requests on releasing connection\n");
+	spin_lock(&conn->request_lock);
+	list_for_each_entry(work, &conn->async_requests, async_request_entry) {
+		if (work->state != KSMBD_WORK_ACTIVE)
+			continue;
+
+		ksmbd_debug(CONN, "Cancel async request id %d\n",
+			    work->async_id);
+		work->state = KSMBD_WORK_CANCELLED;
+		if (work->cancel_fn)
+			work->cancel_fn(work->cancel_argv);
+	}
+	spin_unlock(&conn->request_lock);
+}
+
 void ksmbd_conn_lock(struct ksmbd_conn *conn)
 {
 	mutex_lock(&conn->srv_mutex);
@@ -589,6 +608,7 @@ int ksmbd_conn_handler_loop(void *p)
 	}
 
 	ksmbd_conn_set_releasing(conn);
+	ksmbd_conn_cancel_async_requests(conn);
 	/* Wait till all reference dropped to the Server object*/
 	ksmbd_debug(CONN, "Wait for all pending requests(%d)\n", atomic_read(&conn->r_count));
 	wait_event(conn->r_count_q, atomic_read(&conn->r_count) == 0);
-- 
2.54.0

