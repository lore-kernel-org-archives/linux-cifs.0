Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F3F3009F6
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 08:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782894386; cv=none; b=CKiOCFQF16sB8IbWS6LxGy4kX/SEdbvX/nZAAr50QAU1kWrjVSzAsA+grFZfmi7dOaiZTLJA/yYfSw1GwtK09iQGTm/rwitwkQEySp3LJ24wY1rLH6gXIPrpqne5F3yL9fcGR2R0vA7AOZU7C9owx2DmZ2feOwrGjKNWSx26vH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782894386; c=relaxed/simple;
	bh=dAkE7MF/+lyuQdV7NKLB0zaWJRlwoJJ1DQjCcNfWfP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKl3w+zTcSn0YLWUAszp4SgBqjt3ViB6KhqEhVcrpF/u72fgOYa14fbKZQo1eNCavE5Oz2fbg+bLqpkTFbVuAOLCpbMDyy+lV3f30BU73ot8bkgdAQOy2dEG4xaNRRxeqYC/AF8ybHH940TbLnVSxW+vuO+nQXS7fCs+5kQLzgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=m4uM9Mbj; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="m4uM9Mbj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782894381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4ykL82/bWqU5yVogBvUxpzJh3bci+aQnu+GZUuDHBPY=;
	b=m4uM9Mbjuvo8ziV+kCJLnUrdRslvbrQU3XAjm+sxlW/qBNLvGAXPca8xERHNX6XX4uNslk
	rsYKhOtoGRo3yDYa0mM7jUzwCPkk0zgTUJGoVxJQuhbNwFbIw9oGlTGuvw80knhLQlUTPt
	OguVBPUKM/2qOy1wnF5ULs/yboCz8zmHSGn7xzJ+I+nJQvc31OvkySrZxEJVMjrSh8tWjn
	aGuTKGEaAkLyWmaK9U1FbfnpSHpXbRlx0ElpyNop9TbG+N+maZzfUZpIZRE5bBW/Vtg588
	ZAaeA9/hJuZpaU5nan/Zk11Y0Up76xx7F0WYgmsYEiNlsVvVhUQvhTsIAlGKpA==
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
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 7/9] smb/client: remember async ids from SMB2 pending responses
Date: Wed,  1 Jul 2026 08:25:05 +0000
Message-ID: <20260701082507.786487-8-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260701082507.786487-1-chenxiaosong@chenxiaosong.com>
References: <20260701082507.786487-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

SMB2 servers may turn a request into an asynchronous command by replying
with STATUS_PENDING and SMB2_FLAGS_ASYNC_COMMAND. A later SMB2_CANCEL must
target the async id from that pending response rather than only the
original message id fields.

Store that async id in the mid entry when processing STATUS_PENDING so
the cancel path can build the correct header.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsglob.h |  2 ++
 fs/smb/client/smb2ops.c  | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 1250518997fb..ea1c5eb2356a 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1713,6 +1713,7 @@ struct mid_q_entry {
 	struct list_head qhead;	/* mids waiting on reply from this server */
 	refcount_t refcount;
 	__u64 mid;		/* multiplex id */
+	__u64 async_id;		/* async id if server returned STATUS_PENDING */
 	__u16 credits;		/* number of credits consumed by this mid */
 	__u16 credits_received;	/* number of credits from the response */
 	__u32 pid;		/* process id */
@@ -1742,6 +1743,7 @@ struct mid_q_entry {
 	bool multiRsp:1;	/* multiple trans2 responses for one request  */
 	bool multiEnd:1;	/* both received */
 	bool decrypted:1;	/* decrypted entry */
+	bool async_cmd:1;	/* server returned an async id for this request */
 };
 
 struct close_cancelled_open {
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 9c2455b5fb03..40f1ae0e9735 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2684,11 +2684,23 @@ static bool
 smb2_is_status_pending(char *buf, struct TCP_Server_Info *server)
 {
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
+	struct mid_q_entry *mid;
 	int scredits, in_flight;
 
 	if (shdr->Status != STATUS_PENDING)
 		return false;
 
+	if (shdr->Flags & SMB2_FLAGS_ASYNC_COMMAND) {
+		mid = __smb2_find_mid(server, buf, false);
+		if (mid) {
+			spin_lock(&mid->mid_lock);
+			mid->async_cmd = true;
+			mid->async_id = le64_to_cpu(shdr->Id.AsyncId);
+			spin_unlock(&mid->mid_lock);
+			release_mid(server, mid);
+		}
+	}
+
 	if (shdr->CreditRequest) {
 		spin_lock(&server->req_lock);
 		server->credits += le16_to_cpu(shdr->CreditRequest);
-- 
2.54.0

