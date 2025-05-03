Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7766723CE;
	Sat,  3 May 2025 23:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746315651; cv=none; b=EdTILSVjgioumRKhL4vYzP704YR9FoLoyZr9s7mu2O9vbwqskgDrVH9uSw0mFiYroiQkCHVJi6Eel5bgokrilWWn5zAGtSW3gayF6F7znjmILOgTTrLGXOthv/Ovxf7We22kh693tQFgMMGInlveLrx2Vra7DCl9ga38r933evw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746315651; c=relaxed/simple;
	bh=NGkJxeT8/BoDGWJqe779VWv8CNU37R2Eh7+Nl6MWcS4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hzi7tWPKqd07y1fLJJrQbLiDwSbEPKbmDmRoGwLpbiHQclgYQ6TCl/iOMQZe9O/1vEt/E5vwJGKX14qjOLBHHniS2fc+mTC+INgkhnqV3soImzeOUSoizC1iF3azIqJ3r/9l08mXLE8U3d6zQ2eBXvBkekPwPZRtKmhxD3N/4xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=EKEyL+nb; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="EKEyL+nb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=DgNzGCUWzdOqxYBJ/tAchmI5o1dJg0i4AbRCEyoVuPo=; b=EKEyL+nb6SoQZDqr
	Ozx2vFAIaYcfGIeyUcQZcee3gUnvE3NpBuuaDjcoK8T8t7CDsHXnijeswhsv7VoYbJY6r9Dex3NJw
	BoGnUGkpmumvhzH1wpb6hXdFu3AvrPJ/tPzw9THZChasRl3baW/9GRUJmm7gRq7QazUnK7MwdeqBg
	0JGKNFvtc3vSLdwh0LOJl5cixISguzJrD5sT9t4UkYAIRdAEg0y/YSbjcdjxj8vCW+wfwZX/Kmz1/
	4oeJvahHuJlnupqzblKzWmOSu+nKkbg/2JRRAuzJdDN+5K+r/mO9z//Zlt65uFptp3B0JMXXgun/R
	bAdRx6XLaI21ZAKB3Q==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1uBMT8-001GKi-2m;
	Sat, 03 May 2025 23:40:30 +0000
From: linux@treblig.org
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] smb: client: Remove an unused function and variable
Date: Sun,  4 May 2025 00:40:30 +0100
Message-ID: <20250503234030.130605-1-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

SMB2_QFS_info() has been unused since 2018's
commit 730928c8f4be ("cifs: update smb2_queryfs() to use compounding")

sign_CIFS_PDUs has been unused since 2009's
commit 2edd6c5b0517 ("[CIFS] NTLMSSP support moving into new file, old dead
code removed")

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 fs/smb/client/cifsfs.c    |  1 -
 fs/smb/client/smb2pdu.c   | 65 ---------------------------------------
 fs/smb/client/smb2proto.h |  3 --
 3 files changed, 69 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index a08c42363ffc..d192a19bd761 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -70,7 +70,6 @@ bool require_gcm_256; /* false by default */
 bool enable_negotiate_signing; /* false by default */
 unsigned int global_secflags = CIFSSEC_DEF;
 /* unsigned int ntlmv2_support = 0; */
-unsigned int sign_CIFS_PDUs = 1;
 
 /*
  * Global transaction id (XID) information
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index c4d52bebd37d..eef971509589 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5919,71 +5919,6 @@ SMB311_posix_qfs_info(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-int
-SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
-	      u64 persistent_fid, u64 volatile_fid, struct kstatfs *fsdata)
-{
-	struct smb_rqst rqst;
-	struct smb2_query_info_rsp *rsp = NULL;
-	struct kvec iov;
-	struct kvec rsp_iov;
-	int rc = 0;
-	int resp_buftype;
-	struct cifs_ses *ses = tcon->ses;
-	struct TCP_Server_Info *server;
-	struct smb2_fs_full_size_info *info = NULL;
-	int flags = 0;
-	int retries = 0, cur_sleep = 1;
-
-replay_again:
-	/* reinitialize for possible replay */
-	flags = 0;
-	server = cifs_pick_channel(ses);
-
-	rc = build_qfs_info_req(&iov, tcon, server,
-				FS_FULL_SIZE_INFORMATION,
-				sizeof(struct smb2_fs_full_size_info),
-				persistent_fid, volatile_fid);
-	if (rc)
-		return rc;
-
-	if (smb3_encryption_required(tcon))
-		flags |= CIFS_TRANSFORM_REQ;
-
-	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = &iov;
-	rqst.rq_nvec = 1;
-
-	if (retries)
-		smb2_set_replay(server, &rqst);
-
-	rc = cifs_send_recv(xid, ses, server,
-			    &rqst, &resp_buftype, flags, &rsp_iov);
-	free_qfs_info_req(&iov);
-	if (rc) {
-		cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
-		goto qfsinf_exit;
-	}
-	rsp = (struct smb2_query_info_rsp *)rsp_iov.iov_base;
-
-	info = (struct smb2_fs_full_size_info *)(
-		le16_to_cpu(rsp->OutputBufferOffset) + (char *)rsp);
-	rc = smb2_validate_iov(le16_to_cpu(rsp->OutputBufferOffset),
-			       le32_to_cpu(rsp->OutputBufferLength), &rsp_iov,
-			       sizeof(struct smb2_fs_full_size_info));
-	if (!rc)
-		smb2_copy_fs_info_to_kstatfs(info, fsdata);
-
-qfsinf_exit:
-	free_rsp_buf(resp_buftype, rsp_iov.iov_base);
-
-	if (is_replayable_error(rc) &&
-	    smb2_should_replay(tcon, &retries, &cur_sleep))
-		goto replay_again;
-
-	return rc;
-}
-
 int
 SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	      u64 persistent_fid, u64 volatile_fid, int level)
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 4662c7e2d259..035aa1624053 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -259,9 +259,6 @@ extern int smb2_handle_cancelled_close(struct cifs_tcon *tcon,
 				       __u64 volatile_fid);
 extern int smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server);
 void smb2_cancelled_close_fid(struct work_struct *work);
-extern int SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
-			 u64 persistent_file_id, u64 volatile_file_id,
-			 struct kstatfs *FSData);
 extern int SMB311_posix_qfs_info(const unsigned int xid, struct cifs_tcon *tcon,
 			 u64 persistent_file_id, u64 volatile_file_id,
 			 struct kstatfs *FSData);
-- 
2.49.0

