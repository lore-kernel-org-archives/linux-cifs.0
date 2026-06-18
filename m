Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893B02F1FC7
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 14:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781792294; cv=none; b=qevWxUBIM8hm06dvt0S7iRs0CIxs3xWAzVO8fPtLmefdRtw3ml3FFE16wbd3SHAWrODQpuX/vDV0W8U3wqvDljrlZPPBgleGunXhj5BBRuIkqY0r74jK1xmfQdtfYjk8hcBNh9YXwgFuKTm4aTT8dm6MhStvLDXI4JPXEY866+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781792294; c=relaxed/simple;
	bh=pDlfnQkuYOphkHpXmcI1wQvWjnpRiz6l12P/mZKP+SU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Rf60gPoDWVWXrRN3ymDHZiiniyyTTp2TXadtLWU1ov87QbDcPcURzu4xxMTKE68Iectuca8t5Yft+l8pA6ReyO94OyX7un4dduwlbHAUxop5xbCsOzsR8VKQIlkWCpBgR/QL3SLD18hjGAxM3WS7Q0YSqRvG9jWhnH8Xnf5372U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cwXp86p9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cwXp86p9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276171F00A3D;
	Thu, 18 Jun 2026 14:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781792293;
	bh=A+vByUjnegAMv7Gmt16DHxFOF5SVDxH5mhPPpCweo68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cwXp86p9N6IfnZAeUeG4FKngXxmL2I+F9g0PT7jj/UB6PB7MWdbGdUzmWIs2iIDkK
	 7VhDpvEB9HhJs1SrSays45oJgsNyMjK34vtXZFfnlyCC77f0iJhmXtLWLE5+jspnjV
	 Jv1SS5XV3OkU6JwGFNxpPTcdW+Rji+XapuGZT5wqO8ryL2V9bt9nuaF8/e6NcBCz5l
	 xpRfjdLhlPn14DsI9Bgs/gA/O/9AoJxr3ULZmtEYJdaKB1uZCWz//bwN6/jgvUg53d
	 r4WDb0dRdgWsMhFoJkRmgEuqaBxUQ0BCS/uKZGEguUli934B/BQvgowoUN+RtkC0wh
	 KIyqO82n1qL5A==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 13/14] ksmbd: route v2 lease breaks on the client lease channel
Date: Thu, 18 Jun 2026 23:17:38 +0900
Message-Id: <20260618141739.9029-13-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260618141739.9029-1-linkinjeon@kernel.org>
References: <20260618141739.9029-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2 leases are scoped by ClientGuid.  When the same client uses multiple
connections, smbtorture expects lease break notifications to be sent on
the connection associated with the client lease table, not necessarily
on the connection that owns the individual open being broken.

Keep a referenced connection in the lease table and use it for v2 lease
break notifications while it is still active.  Fall back to the open's
connection if the table connection is being released.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 17 +++++++++++++++--
 fs/smb/server/oplock.h |  1 +
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 9efc66fef2e6..400a3f2f8489 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -141,11 +141,21 @@ static struct lease_table *alloc_lease_table(struct oplock_info *opinfo)
 
 	memcpy(lb->client_guid, opinfo->conn->ClientGUID,
 	       SMB2_CLIENT_GUID_SIZE);
+	lb->conn = ksmbd_conn_get(opinfo->conn);
 	INIT_LIST_HEAD(&lb->lease_list);
 	spin_lock_init(&lb->lb_lock);
 	return lb;
 }
 
+static void free_lease_table(struct lease_table *lb)
+{
+	if (!lb)
+		return;
+
+	ksmbd_conn_put(lb->conn);
+	kfree(lb);
+}
+
 static struct lease *alloc_lease(struct lease_ctx_info *lctx,
 				 struct ksmbd_inode *ci)
 {
@@ -942,6 +952,9 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo, bool wait_ack,
 	struct lease *lease = opinfo->o_lease;
 
 	conn = READ_ONCE(opinfo->conn);
+	if (lease->version == 2 && lease->l_lb && lease->l_lb->conn &&
+	    !ksmbd_conn_releasing(lease->l_lb->conn))
+		conn = lease->l_lb->conn;
 	if (!conn)
 		return 0;
 
@@ -1134,7 +1147,7 @@ void destroy_lease_table(struct ksmbd_conn *conn)
 		list_for_each_entry_safe(lease, ltmp, &lb->lease_list, l_entry)
 			lease_del_table(lease);
 		list_del(&lb->l_entry);
-		kfree(lb);
+		free_lease_table(lb);
 	}
 	write_unlock(&lease_list_lock);
 }
@@ -1193,7 +1206,7 @@ static void add_lease_global_list(struct lease *lease, struct ksmbd_conn *conn,
 			    SMB2_CLIENT_GUID_SIZE)) {
 			lease_add_table(lease, lb);
 			write_unlock(&lease_list_lock);
-			kfree(new_lb);
+			free_lease_table(new_lb);
 			return;
 		}
 	}
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index 1dd52b44557f..8d1943586246 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -34,6 +34,7 @@ struct lease_ctx_info {
 
 struct lease_table {
 	char			client_guid[SMB2_CLIENT_GUID_SIZE];
+	struct ksmbd_conn	*conn;
 	struct list_head	lease_list;
 	struct list_head	l_entry;
 	spinlock_t		lb_lock;
-- 
2.25.1

