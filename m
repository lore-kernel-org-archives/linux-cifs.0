Received: from out-171.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937A33D6498
	for <linux-cifs@vger.kernel.org>; Sun,  9 Aug 2026 16:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786292429; cv=none; b=uLPMVCaTRiHDHNetxLckaZjHDoIrylSZa9BzLIQeU+PhNDweRTuNrGxYXIIvzy211cd7iTKm9mZuk15e8eJJhgVZTnXjvejSFYtc7E+NUu2OOWmquyH7A4yAB9qg2zZyXaCqPWrddHB/iLj8xFh4ysPi+89FoQTkVnkv08VfWWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786292429; c=relaxed/simple;
	bh=vdNUawz5ipFoZdtVrbqbPcq8b0HcRKTQvnlL4bMki+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUSCNPTfLCbaBFko7E7vcjVMxGxbQNbKkvNQ0uc/eeyqB11h8ql8M2kaHZcxrME8ZOtA3nzF1WrvKbx7Y3XOFPg0hwhCz9ZcFT+7/pwDCQg9OgewdF3xankRZMIRk2UMNxpgEwuMBYBL4eGtSqgHqCOklTfP/9Psm9a7zc23phU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Z/6mjEtl; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Z/6mjEtl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1786292423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qYRxs4KU2cZalDa43Y02e5C1uD2p6XFMOFRZ+GxM27s=;
	b=Z/6mjEtlEMuhuuGPION/JQ4pXkOkKbQGoz0Aa7d/xGyEBQmfqwSDHvJ7/j1oZqzjpXhW0T
	K61zWRUWHCOPYgAV1PZ05ZfU2vPDEpkQy+OiT+ufSfpmvpZQ20vJ7rSI3KaVENKLvKblFo
	J4siH8VrWZWjfHgKqXVSzpqbTTKzjP0QoCX/DV1+gXnXzh4SaL8CJou5HyD4xb5XKOaxFJ
	zQlon+piJXRbEt481B2xxIPeD6tzm/8rV7cyRzo7Y4avnXtuZ+a4PGwaZsfBKoSDrARk2S
	V6cus04SzwWFc6TmbJVJdV7+lUhgQsTvBXdjNJ+1XCE64ObpyaWaIGi0e7Qvtg==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	slow@samba.org,
	gael.blivet@gmail.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 1/3] smb/server: support compound fid in notify requests
Date: Sun,  9 Aug 2026 16:19:14 +0000
Message-ID: <20260809161916.1071530-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260809161916.1071530-1-chenxiaosong@chenxiaosong.com>
References: <20260809161916.1071530-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

A Windows client can send a compound request containing:

  Create Request, File: <share>; Notify Request

The Notify Request uses FFFF...FFFF as the compound FID.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 40 ----------------------------------------
 1 file changed, 40 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a7bfa6dbcfd5..d26073999053 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -11142,46 +11142,6 @@ int smb2_notify(struct ksmbd_work *work)
 		return -EIO;
 	}
 
-	/*
-	 * macOS backupd sends CHANGE_NOTIFY with FileId=FFFF...FFFF (share-root
-	 * sentinel) to watch for changes on the share root without holding an
-	 * open handle. Respond STATUS_PENDING + STATUS_NOTIFY_CLEANUP immediately;
-	 * without this, backupd aborts Time Machine setup on STATUS_FILE_CLOSED.
-	 */
-	if (req->VolatileFileId == SMB2_NO_FID &&
-	    req->PersistentFileId == SMB2_NO_FID) {
-		in_work = ksmbd_alloc_work_struct();
-		if (!in_work || allocate_interim_rsp_buf(in_work)) {
-			if (in_work)
-				ksmbd_free_work_struct(in_work);
-			rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
-			smb2_set_err_rsp(work);
-			return 0;
-		}
-		if (setup_async_work(work, NULL, NULL)) {
-			ksmbd_free_work_struct(in_work);
-			rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
-			smb2_set_err_rsp(work);
-			return 0;
-		}
-		smb2_send_interim_resp(work, STATUS_PENDING);
-		in_work->conn = work->conn;
-		in_hdr = smb_get_msg(in_work->response_buf);
-		memcpy(in_hdr, ksmbd_resp_buf_next(work),
-		       __SMB2_HEADER_STRUCTURE_SIZE);
-		in_hdr->Flags |= SMB2_FLAGS_ASYNC_COMMAND;
-		in_hdr->Id.AsyncId = cpu_to_le64(work->async_id);
-		smb2_set_err_rsp(in_work);
-		in_hdr->Status = STATUS_NOTIFY_CLEANUP;
-		in_work->async_id = work->async_id;
-		work->async_id = 0;
-		release_async_work(work);
-		ksmbd_conn_write(in_work);
-		ksmbd_free_work_struct(in_work);
-		work->send_no_response = 1;
-		return 0;
-	}
-
 	/*
 	 * KSMBD does not implement a real change-notification backend.
 	 * Genuine SMB2 servers (and macOS smbfs) never complete a
-- 
2.54.0

