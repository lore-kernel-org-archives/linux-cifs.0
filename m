Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7598534DCE0
	for <linux-cifs@vger.kernel.org>; Sat,  8 Aug 2026 06:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786171383; cv=none; b=ZqzHQgyPYc1/h27+DO7uGhpnw5vWeaIvGmuVxJNhy5VGmF3kCEshnpI3/HJvwA5WI6rvjhRZy2WbQMkFXVApcAwCr4lFViuaEFNxZIht4ZPw1W+lvCfVhGN/MvejJUh/r4cIqU9RW3BjCJHHezzaVhaQGvNw9c/RziBGwL2CSzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786171383; c=relaxed/simple;
	bh=NTOzHjQ/OVL+evDY8R3KMEXRwokrfs4mTq0rDnjPaaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tB11eToDmkn4ycxqSlMSQ0VmLEg8Y4woBBYI63GD8FnVGNYyqrnw+l5+lTMQbs01GRZ/rW5ScAczKVTWU/YpOthbjpD7PRqy/u73THvwDgpvTamH626uvgoHKoiBYu+JbMkgsO3FLZNx1aSyJuBdIYzpBfJXEnhkBWRHqgnHZTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=vCx7d0yG; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="vCx7d0yG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1786171377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ey32Ppna0zi/3URABAC6BQvMAxwCtR+SPsyLNhJoeOA=;
	b=vCx7d0yGQmfwyQUOvNvka/S0i6L+OYiZbhpc7y+DrB3P12ANOeXEF2hMZI7q/Vn0m2+d5d
	A+/4yjWwfiZIKASwBKOUJp8fBILfxu1KotbKowyxtZGuf+1Vy3tczo3aa13jT1nnSqMKL3
	yCl39BcuZpqgfc4w188epqBoe0r9gWVil+QzNhKvX9biGyYwDHIBlPv8QpJZE7GKgMMhH2
	ekH+iOMtcnyrSaRk8HpjoDOg7boAOoQTnWs0YPZ/Imfp8+iiyZhm/R0gtmvP9zVqQQiQPh
	Ln0RqMdtdI7acmOp813tbgzGD1xV6IALslsR1per2xruMpe5IqyOe54DQhRaoQ==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	slow@samba.org,
	gael.blivet@gmail.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 1/3] smb/server: support compound fid in notify requests
Date: Sat,  8 Aug 2026 06:41:38 +0000
Message-ID: <20260808064145.1002261-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260808064145.1002261-1-chenxiaosong@chenxiaosong.com>
References: <20260808064145.1002261-1-chenxiaosong@chenxiaosong.com>
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
index 80f5791c687b..f729ee102a5b 100644
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

