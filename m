Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793746827;
	b=zd0NjgPX6U4bRmSGy48dKZSNjo83X1bHVN3qgHAibEHzV5wWX7I/2hozeo7UGeSEciNv
	 dLQ64POFHm/iASWS73ceG3s1v2B3yM7BpcoTki+gTEROg9yi2Kf/nQmtcQQWgZ1u7SlOb
	 4FWaptVoqn75yO2ZRB7mf4ClDrDqR2lFWexNnqJSLuMG6qJN/3mU7cM2iNiZVxUhbkBQr
	 yHs7mAfkkrHErVLBDtbWZErNHwIAT72LLozk+l98HCVdMWO8UsbLDJSarAW1CuebafAxf
	 tZBJYtuDG5F/61qBBA8kIKhVWMThNU8zg2Bm1VoOUze5hbYcCdBOZKNJmayB9rZJusQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793746827;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wuaOf0IDj5Oxjwp4AuWdM4WIEzVYzFjgDmHoW0EEgIE=;
	b=1Y79QUCxNbU0LklkMLrdwWAUoKhXidNoQkL2M5y5W3DTp34u0vqReoMSaetRRABUWSM4
	 ZFi/V+n2jsW4Jtg5rf/40po6G2FBhOXUgGF8iEtqOFrpKz0UeKzmZjkuTfZ7wZg75n9XT
	 h4KcR8UcmHNJUDqGFFy1tTxHYwTyntb2xg69k/C96yGMrcLhCj0GrIL4UYESX5goGiX+u
	 dmXRo+XhMPEkjZHLnag8pQHajGLG5MIBN7IVSEq9aAQ3ykDftBlmyAsJbtrpiualL+NxF
	 Mi4X2vI9K5IyqTm1NhxxBUr6lZ8chUo490K5o/qsVx94r3mVD4RvK5PLW0hzXcJnYoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=8loKAlEB;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D95606A329;
	Tue,  3 Nov 2026 23:00:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36D95606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=8loKAlEB
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=wuaOf0IDj5Oxjwp4AuWdM4WIEzVYzFjgDmHoW0EEgIE=; b=8loKAlEBgSLGUlBmaI7kvq68M8
	h783FjbPa57n8GO3YBF5Y+pkCKXanoUjSkSol+NyQiVXwWb+QN4CPHYuiMD1e2mlZ0spYOsik6y1/
	qsA074/Cxw1iRhuaAJLu/FOEYq/f2fjrThHE5Jaejopo2N7AYeYQITm1YkJVh2XOzNgEekmDMSAzK
	zijP/7NPjx4rEo6g5/FwHMN2eF6skHDM7Sr6zIvqsurkYfJ9NswFYRVFQ7zWtew6JGZweaDA2UWTu
	MdihAeafneD5WJIFgILH5rEaqsXg4ATvrpxUZ6CP7QBPuXYfydfb04fnho1Bi7L0GKKzeA8uxco8M
	PtDhpTzw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xONUO-00000000kOt-29V8;
	Tue, 03 Nov 2026 20:00:25 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	David Howells <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Christian Brauner <brauner@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v3 15/16] smb: client: don't replay handle reopens inside SMB2_open()
Date: Tue,  3 Nov 2026 20:00:19 -0300
Message-ID: <20261103230020.1617748-16-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103230020.1617748-1-pc@manguebit.org>
References: <20261103230020.1617748-1-pc@manguebit.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_reopen_file_retry() reopens a read's or write's handle with backoff,
per the hard and retrans mount options, giving up on umount -f.  It calls
cifs_reopen_file() -> SMB2_open(), which replays replayable errors on its
own, also per hard and retrans.  So each reopen is retried at both
layers: up to (retrans + 1)^2 opens on a soft mount, and, on a hard
mount, forever inside SMB2_open() without ever returning to
cifs_reopen_file_retry() to notice umount -f - a worker doing writeback
then can't be stopped.

Have cifs_reopen_file_retry() tell SMB2_open() not to replay, so these
reopens are bounded and stopped only by cifs_reopen_file_retry().  Other
callers of cifs_reopen_file() keep SMB2_open()'s replay; SMB1 opens are
unchanged.

Fixes: 69c3c023af25 ("cifs: Implement netfslib hooks")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/file.c     | 13 ++++++++-----
 fs/smb/client/smb2pdu.c  |  2 +-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 3e65639c27cf..cfdb230beadc 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1408,6 +1408,7 @@ struct cifs_open_parms {
 	umode_t mode;
 	bool reconnect:1;
 	bool replay:1; /* indicates that this open is for a replay */
+	bool no_replay:1; /* don't replay this open internally */
 	struct kvec *ea_cctx;
 	__le32 lease_flags;
 };
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 958fd6f4c50e..52c306de11b8 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -37,7 +37,8 @@
 #include "cached_dir.h"
 #include <trace/events/netfs.h>
 
-static int cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush);
+static int cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush,
+			    bool no_replay);
 
 bool cifs_io_stopped(struct cifs_io_subrequest *subreq)
 {
@@ -169,7 +170,7 @@ static int cifs_reopen_file_retry(struct cifsFileInfo *cfile, bool can_flush,
 			return -EIO;
 		retrying = true;
 		reconnects = cifs_ses_reconnects(ses);
-		rc = cifs_reopen_file(cfile, can_flush);
+		rc = cifs_reopen_file(cfile, can_flush, true);
 		if (!rc || is_interrupt_error(rc) ||
 		    cifs_writeback_dying(&subreq->subreq))
 			return rc;
@@ -1532,7 +1533,7 @@ cifs_relock_file(struct cifsFileInfo *cfile)
 }
 
 static int
-cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
+cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush, bool no_replay)
 {
 	int rc = -EACCES;
 	unsigned int xid;
@@ -1633,6 +1634,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 		.path = full_path,
 		.fid = &cfile->fid,
 		.reconnect = true,
+		.no_replay = no_replay,
 	};
 
 	/*
@@ -1828,7 +1830,8 @@ cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 	spin_unlock(&tcon->open_file_lock);
 
 	list_for_each_entry_safe(open_file, tmp, &tmp_list, rlist) {
-		if (cifs_reopen_file(open_file, false /* do not flush */))
+		/* do not flush */
+		if (cifs_reopen_file(open_file, false, false))
 			tcon->need_reopen_files = true;
 		list_del_init(&open_file->rlist);
 		cifsFileInfo_put(open_file);
@@ -3063,7 +3066,7 @@ int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 			*ret_file = inv_file;
 			return 0;
 		}
-		rc = cifs_reopen_file(inv_file, false);
+		rc = cifs_reopen_file(inv_file, false, false);
 		if (!rc) {
 			*ret_file = inv_file;
 			return 0;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 33f8d0638a54..c9380aedc1fd 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3428,7 +3428,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	SMB2_open_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);
 
-	if (is_replayable_error(rc) &&
+	if (!oparms->no_replay && is_replayable_error(rc) &&
 	    smb2_should_replay(tcon, &retries, &cur_sleep))
 		goto replay_again;
 
-- 
2.56.0

