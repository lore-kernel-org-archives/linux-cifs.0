Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CD4481ABC
	for <linux-cifs@vger.kernel.org>; Tue,  3 Mar 2026 15:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772550863; cv=none; b=WBCcmfkxIlMpuy9g/NT4VUSHf+cH/tkJOaOgQ31wH28CtFW9yAagEF5yhHvw0AmkT8MQPEYyDYV13wPDiE5YQWUs6zPfKsJD2KcsoH/+PtZ7hIGqZMRFWt4LWHyxftIZNvzYW9oKm3ORKHreUS6wS8lsjM9fg6uD2SeiYQSiG08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772550863; c=relaxed/simple;
	bh=guX790pxW9G9BsQ7LAhCg6a5x10OjUkASXkoyNO0BwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJUnM8u4HlaYqWlTyyttcyA1IrBRRyrvuSaweJTLaw5WV7+9pcp7AScNMoN1Grnb0k3cqgDfYOpnYkEuvMWuE1eWrx9z8LVpFf7kTne+IeGcvafb9PIAdA8wmgpsmG8ajH6AoBglozELq461ANkNT00kyfaNZJh4nR0TlJPNlqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I51Z6oD1; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I51Z6oD1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772550857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OKuLWMGz1SdCyUXqdKVKJG4Nyk/MQDSRwQZTMFZckMc=;
	b=I51Z6oD18vibBTR3OWIglked+cUEpFwfL+rN9TGkJitiYzSvw5khuxrp90ETmsJDyTXD+V
	xlSNGcl+odPnow+51gZoSSjwfoSstBwOmBDAhyiTKhNqU4Xbxgk/poxugcRpOo26UlSzYq
	CyuqYEjf1bLrSxOOiCFbZeCwPJnbo0M=
From: zhang.guodong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v5 3/7] smb/client: remove unused SMB311_posix_query_info()
Date: Tue,  3 Mar 2026 15:13:13 +0000
Message-ID: <20260303151317.136332-4-zhang.guodong@linux.dev>
In-Reply-To: <20260303151317.136332-1-zhang.guodong@linux.dev>
References: <20260303151317.136332-1-zhang.guodong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

It is currently unused, as now we are doing compounding instead
(see smb2_query_path_info()).

Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2pdu.c   | 18 ------------------
 fs/smb/client/smb2proto.h |  3 ---
 2 files changed, 21 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 8a1fcc097606..c43ca74e8704 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3989,24 +3989,6 @@ int SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 			  NULL);
 }
 
-#if 0
-/* currently unused, as now we are doing compounding instead (see smb311_posix_query_path_info) */
-int
-SMB311_posix_query_info(const unsigned int xid, struct cifs_tcon *tcon,
-			u64 persistent_fid, u64 volatile_fid,
-			struct smb311_posix_qinfo *data, u32 *plen)
-{
-	size_t output_len = sizeof(struct smb311_posix_qinfo) +
-			(sizeof(struct smb_sid) * 2) + (PATH_MAX * 2);
-	*plen = 0;
-
-	return query_info(xid, tcon, persistent_fid, volatile_fid,
-			  SMB_FIND_FILE_POSIX_INFO, SMB2_O_INFO_FILE, 0,
-			  output_len, sizeof(struct smb311_posix_qinfo), (void **)&data, plen);
-	/* Note caller must free "data" (passed in above). It may be allocated in query_info call */
-}
-#endif
-
 int
 SMB2_query_acl(const unsigned int xid, struct cifs_tcon *tcon,
 	       u64 persistent_fid, u64 volatile_fid,
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 881e42cf66ce..230bb1e9f4e1 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -167,9 +167,6 @@ int SMB2_flush_init(const unsigned int xid, struct smb_rqst *rqst,
 		    struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		    u64 persistent_fid, u64 volatile_fid);
 void SMB2_flush_free(struct smb_rqst *rqst);
-int SMB311_posix_query_info(const unsigned int xid, struct cifs_tcon *tcon,
-			    u64 persistent_fid, u64 volatile_fid,
-			    struct smb311_posix_qinfo *data, u32 *plen);
 int SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 		    u64 persistent_fid, u64 volatile_fid,
 		    struct smb2_file_all_info *data);
-- 
2.52.0

