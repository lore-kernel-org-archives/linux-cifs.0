Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8ED757E0;
	Wed,  7 Aug 2024 16:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723049607; cv=none; b=BjDM1bRVBnmXMHEiNfzwqMLsoS2yCPBUltzyoFzdJsCAZb1mzpbYOkb0Ajxt5093nU3h9GpzF/gTkRtcL/qFt60XjMmHWv4oIbTIwbC8WgBjuel6NcwM3Iy1xvRQelhL0HVZy3+MzNqZ1o97BJRPFwbr6q1W2d6z0ZUvv4zLRZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723049607; c=relaxed/simple;
	bh=Otff42RR+NBKg2vO1RG9IZBt6c7fpvzSz0txiQzZYok=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ngRp9Y5MQBOJl7QbUmh57fANaM3lRPQdS3N6YPmAmCPNsxWiDmg7e4gxsGlDiPMwjgolzqS8hxVzVW7iuvwZoPT3eb/MKU+IRSK5fEP9TgXR39Wfgj8zQDLgIwOc3+Ua/zam3hVwvClpGjDRmuNntfxvfkb4f9QHQqQUtab1MuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BHmgZX7n; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BHmgZX7n"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1fc4fcbb131so893115ad.3;
        Wed, 07 Aug 2024 09:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723049605; x=1723654405; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+XkO9DgNfyCTWX2Cpwq3TYmUH7phSI2HkmfjGBOT6ZM=;
        b=BHmgZX7n90t1kbeqE+Qiu0yAI+TUWRGyEBqgLULfYB8p77BD2YJEXpRNG60+9u6qAx
         gd1Qx/TpMx7OVY91KPKaLnBK1En01E/IjRp2M14l2eC2xhByz791eZjiOzj3dTQri6qn
         aiphp9AWsLCqnTkvGi743WcgPwlkVkFUEzuub59+tw8rdvg5F4uvgvolhH5lTH31IJKQ
         T9aj8zK7orTY1VqTIIRRcMFM/jroJiHAuVeMAAotoX/lTikd9XQm8fR1245jXBy4N0KR
         rKDiNPJua+3E4TuCD7jk5DEwz70kvzfR6HQCDbft5EvGi5DBluSz444ysdCx2tIKIBFP
         tKVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723049605; x=1723654405;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+XkO9DgNfyCTWX2Cpwq3TYmUH7phSI2HkmfjGBOT6ZM=;
        b=NxsMtpVB9p1CmKLq7OZfKcPpYxM9qK5RG1PfTAWuRdL+QbXM/0NFF3POCqo/PVW3m2
         vRp4ClwAaoEawNMlpMwzp2kN6+1CtoCGy+koNY4CU2i6wHRhIfgMHmKD6edQdgRKrSR9
         vhnf9eNI2TEugRkDQy5Od5omIx5ygBsetmdmL8eGBWpBi86tkKjBiWhwMmFewmQZrAzD
         ZpCsjCrFqmR7OvOYIX7WrShaK5knZL7b6SbY6LUmVa77OiD8BDEzega2NTUu+RsNNUyG
         YXgQVyYyCnA56FAtZkvnIzbZwdLLIOR1iIYHA7OUZozPKzcf20ykZdtPUEDwnYKG1lgn
         ERpA==
X-Forwarded-Encrypted: i=1; AJvYcCXvM00e4lqP/74Nl4xTrajZZlksgqspXmankMmSPo/ip+UeOykWIqi+xDbTzWNbs82ohAqyLscbp81uXZMgk4G2A9lL5d/udMaWbORGrRzX0DhGbNAvKmcMKxavIVPTKx40aGN+m1Zw3Q==
X-Gm-Message-State: AOJu0YxfjVei7vMOMAAceb7uFGKPWJMEXuXqhFSHcn4uDtPJcZBkcM74
	FKkI7Hdl87urheFdgWqO3OvIqP4+dAHBEilDNvEPtGS/8UyNg/t1dpvauBdc2os=
X-Google-Smtp-Source: AGHT+IEiZBuR3LmuFsZbs5ja08mp/8ikRLlBGhEK89AgiO48WFpbQo0/UB9Fw/IHD21Eb30DyRfD6w==
X-Received: by 2002:a17:903:2345:b0:1fd:6d4c:24e9 with SMTP id d9443c01a7336-1ff5722df70mr248605475ad.10.1723049604812;
        Wed, 07 Aug 2024 09:53:24 -0700 (PDT)
Received: from xiaxiShen-ThinkPad.. ([50.175.126.146])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff58f21794sm108706385ad.27.2024.08.07.09.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 09:53:24 -0700 (PDT)
From: Xiaxi Shen <shenxiaxi26@gmail.com>
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com
Cc: skhan@linuxfoundation.org,
	javier.carrasco.cruz@gmail.com,
	shenxiaxi26@gmail.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Fix spelling errors in Server Message Block
Date: Wed,  7 Aug 2024 09:53:20 -0700
Message-Id: <20240807165320.56450-1-shenxiaxi26@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixed typos in various files under fs/smb/client/

Signed-off-by: Xiaxi Shen <shenxiaxi26@gmail.com>
---
 fs/smb/client/cifsglob.h  | 4 ++--
 fs/smb/client/misc.c      | 2 +-
 fs/smb/client/smbdirect.c | 8 ++++----
 fs/smb/client/transport.c | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index f6d1f075987f..66677b8fc9be 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -345,7 +345,7 @@ struct smb_version_operations {
 	/* connect to a server share */
 	int (*tree_connect)(const unsigned int, struct cifs_ses *, const char *,
 			    struct cifs_tcon *, const struct nls_table *);
-	/* close tree connecion */
+	/* close tree connection */
 	int (*tree_disconnect)(const unsigned int, struct cifs_tcon *);
 	/* get DFS referrals */
 	int (*get_dfs_refer)(const unsigned int, struct cifs_ses *,
@@ -816,7 +816,7 @@ struct TCP_Server_Info {
 	 * Protected by @refpath_lock and @srv_lock.  The @refpath_lock is
 	 * mostly used for not requiring a copy of @leaf_fullpath when getting
 	 * cached or new DFS referrals (which might also sleep during I/O).
-	 * While @srv_lock is held for making string and NULL comparions against
+	 * While @srv_lock is held for making string and NULL comparisons against
 	 * both fields as in mount(2) and cache refresh.
 	 *
 	 * format: \\HOST\SHARE[\OPTIONAL PATH]
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index b28ff62f1f15..3fe5bfc389d0 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -352,7 +352,7 @@ checkSMB(char *buf, unsigned int total_read, struct TCP_Server_Info *server)
 				 * on simple responses (wct, bcc both zero)
 				 * in particular have seen this on
 				 * ulogoffX and FindClose. This leaves
-				 * one byte of bcc potentially unitialized
+				 * one byte of bcc potentially uninitialized
 				 */
 				/* zero rest of bcc */
 				tmp[sizeof(struct smb_hdr)+1] = 0;
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index d74e829de51c..7bcc379014ca 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -406,7 +406,7 @@ static void smbd_post_send_credits(struct work_struct *work)
 			else
 				response = get_empty_queue_buffer(info);
 			if (!response) {
-				/* now switch to emtpy packet queue */
+				/* now switch to empty packet queue */
 				if (use_receive_queue) {
 					use_receive_queue = 0;
 					continue;
@@ -618,7 +618,7 @@ static struct rdma_cm_id *smbd_create_id(
 
 /*
  * Test if FRWR (Fast Registration Work Requests) is supported on the device
- * This implementation requries FRWR on RDMA read/write
+ * This implementation requires FRWR on RDMA read/write
  * return value: true if it is supported
  */
 static bool frwr_is_supported(struct ib_device_attr *attrs)
@@ -2177,7 +2177,7 @@ static int allocate_mr_list(struct smbd_connection *info)
  * MR available in the list. It may access the list while the
  * smbd_mr_recovery_work is recovering the MR list. This doesn't need a lock
  * as they never modify the same places. However, there may be several CPUs
- * issueing I/O trying to get MR at the same time, mr_list_lock is used to
+ * issuing I/O trying to get MR at the same time, mr_list_lock is used to
  * protect this situation.
  */
 static struct smbd_mr *get_mr(struct smbd_connection *info)
@@ -2311,7 +2311,7 @@ struct smbd_mr *smbd_register_mr(struct smbd_connection *info,
 	/*
 	 * There is no need for waiting for complemtion on ib_post_send
 	 * on IB_WR_REG_MR. Hardware enforces a barrier and order of execution
-	 * on the next ib_post_send when we actaully send I/O to remote peer
+	 * on the next ib_post_send when we actually send I/O to remote peer
 	 */
 	rc = ib_post_send(info->id->qp, &reg_wr->wr, NULL);
 	if (!rc)
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index adfe0d058701..6e68aaf5bd20 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1289,7 +1289,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 out:
 	/*
 	 * This will dequeue all mids. After this it is important that the
-	 * demultiplex_thread will not process any of these mids any futher.
+	 * demultiplex_thread will not process any of these mids any further.
 	 * This is prevented above by using a noop callback that will not
 	 * wake this thread except for the very last PDU.
 	 */
-- 
2.34.1

