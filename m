Received: from mta0.migadu.com (out-225.mta0.migadu.com [91.218.175.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C4425393E
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 13:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665915; cv=none; b=p0+I+EMCVFtLtRj2mOCYUXNzSVwKyvn9po22WFLe/gDyk1GzON2wMkHIkjNW4ani+Uqey2UkGz/47JAkW2SQw3I4+GK2jTo4HutTp53hYCEwa4d0eyLTRKhyDiYPwRelXBMVN3RTCx4J2qXtR7DHrzOGdNpszJRU8ZPfIcx1/nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665915; c=relaxed/simple;
	bh=oYxei0/CCeDoZu+cT51W1UgtOJQdBTtD09246F1X+rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcdikJTfBgrbuiEKRtwg1/4+EDozHeoNtXTWgNTZ620+6zjEMv8VzKqhrjsXF/ujbyk+eDx6p8u7vfKQ4Y2xsWnsoHmmGGXmRaImQFSPAGKPNEZAH5loWTcu4B7jyJwbpMjJfmZJ9lPxwXJuXoAVcDRUuZ4OnrgcywyeeR3WKAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=h3HfbANF; arc=none smtp.client-ip=91.218.175.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="h3HfbANF"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oYxei0/CCeDoZu+cT51W1UgtOJQdBTtD09246F1X+rM=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787665908; v=1; x=1788270708;
 b=h3HfbANFIh5tykzWUWPhGjf+pnJaEnew3KT+EHoqYDw+GVnR3m/22WT+4QyPI47d35sntr/M
 DW6X3aP0X1eVXdJ+/fh/iy9az4W8gwSiXaNXgJCAMlROtt3HYME1nzMCX5DwjgxVlyKbtKAk4iL
 muFz6G+xJOwgGlZ+Ufxn/QdXqBBVGtekovuO4kgOiC7mmJ24DoYQWJLCxnUM+GgTq9kylqXWZMP
 c0TZHvTE/BIj87XOn8eeRvflfgJIXUck2eK8/O3T/UF+teN3DK6hcW1UOtzlBUh9txi1n1vUgUZ
 6fzSoWk2yN0YaRVZLNkouJj5uQ93yBr0Qek2Zr6t6RFYw==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from workspace-fedora (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 127f973a528648bc;
	Tue, 25 Aug 2026 13:51:47 +0000
X-Mizu-Trace-ID: 127f973a528648bc
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 1/3] smb/server: support compound fid in notify requests
Date: Tue, 25 Aug 2026 13:51:06 +0000
Message-ID: <20260825135108.716663-2-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825135108.716663-1-chenxiaosong@chenxiaosong.com>
References: <20260825135108.716663-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

A Windows client can send a compound request containing:

  Create Request, File: <share>; Notify Request

The Notify Request uses FFFF...FFFF as the compound FID.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 41 -----------------------------------------
 1 file changed, 41 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2fbd9010513e..86f93f81cdfd 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -11818,47 +11818,6 @@ int smb2_notify(struct ksmbd_work *work)
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
-		if (smb2_send_interim_work(in_work, work, false))
-			ksmbd_debug(SMB, "failed to send notify cleanup\n");
-		ksmbd_free_work_struct(in_work);
-		work->send_no_response = 1;
-		return 0;
-	}
-
 	/*
 	 * KSMBD does not implement a real change-notification backend.
 	 * Genuine SMB2 servers (and macOS smbfs) never complete a
-- 
2.55.0

