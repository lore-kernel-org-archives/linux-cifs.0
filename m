Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793728987;
	b=3bs4lvjbj9ndTdEC+exy0+J8QVT1NMDKH7xXpx5xamWjZ6US84WxaIZpelUXoC7ctW8L
	 rEBZZy9SPBwDuhwPzTASDGRvjzu3PQeEcCu2KVhRmvyATtKRaB6RokAGetapXwv3mLyNk
	 ayw2eNZJOvvE9xEtyU3Qt4rBuCiV3Qo2gRJ4HyccYMzBmOcsiAmQZQLxTVmoAw3pBIpcD
	 JlEQqege3GwdM46qu73mEF16syL3Mi7Waw6fIH/fL2R6yECLIG0Jj0rPZFaxV+suIE911
	 i0nkkG1zZ3jEz3D6moXoF0nPPKWStVHoZGodtv6swmN39WaUhSJDciFHhyCU3hOBuLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793728987;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=yZOSWGj9KFWywTW2+mS1efes3sBK6jJvooBQjrtQHmc=;
	b=l/j0uRryyN8oblPsyyi4EyTJ3taVzIUkQ6zzPGX+vLnmHJmxWjUSSsJUk0+7YrjlD7i5
	 UGksBXQIuLTFaqB9BIdZglk0FXbKVUR78ZnzpP0fv2D/tqfV1rsLuht/RsXd1ZpmvQVIl
	 kvzV+SpJnmBzsjYs4jaJbmyVxVGkWb+PPmBOTrNH9IPWc9GvE/Q61y34htwFoYSLOqOhK
	 TN8wqYKj2BVdcI68LVBOFpCtOfUzOj/XIopbp+SejM95JX6dBgzcnPP1xYAtQFMMAp3L/
	 N+M9/iRmdlqhrkuvLXHMaCHTObxi1LwInQa5jE/9pZ1Ravf3TEZIeP0qSxqhQHns6gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=9GIjU4By;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1C5606A31B;
	Tue,  3 Nov 2026 18:03:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A1C5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=9GIjU4By
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=yZOSWGj9KFWywTW2+mS1efes3sBK6jJvooBQjrtQHmc=; b=9GIjU4Byab6u4r/TiZc5IDeJ+n
	76pTV0B0zXJJ8xB7w1GCGFEbfJtA34n8hF0uH8zjDguTDmAZNleVPadFOqS/dsW+uMwWH7bD7Oz8K
	J6ZHYkxJWSfxaD2dgfuF0Nr3LYjFo5kEjmDjgmZyI65vFLW8saIvTTEBYp+/+paq18tzfUtvl+pyk
	k/v2ahpnshyLHBW/g+Ey1WEc5/VE+PjTJiRYXEYzigUaJe51E96cfoUamrXcj9kVxISs9uAD4gbYn
	M2SehivVzzT+8A4dCUFC6F7dc9I3zbcyWvKsk4igdSaOGzL7LUhpQEK2/PThmkQCLtqnqONkSGe53
	MRugWDmA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xOIqW-00000000itu-2CV6;
	Tue, 03 Nov 2026 15:02:57 -0300
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
Subject: [PATCH v2 05/16] smb: client: don't give up writeback on the first replayable error
Date: Tue,  3 Nov 2026 15:02:44 -0300
Message-ID: <20261103180255.1482516-6-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103180255.1482516-1-pc@manguebit.org>
References: <20261103180255.1482516-1-pc@manguebit.org>
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

Read and write retries follow the hard and retrans mount options, and
mounts are soft with no retrans by default.  For writeback this means
that a single replayable error, e.g. a reconnect while sending, fails
the subrequest and netfs ends writeback with its folios clean: the data
is gone, possibly long after write(2) succeeded, with only fsync(2) left
to notice.  NFS soft mounts, by comparison, wait minutes for a server to
answer before failing a request.

Keep retrying writeback on replayable errors, with exponential backoff:
forever on hard mounts, and on soft mounts for max(3, retrans) echo
intervals from the first failure - 3 minutes by default, the time after
which a silent server is considered unresponsive.  The window applies to
each write sent to the server, not to the whole writeback.  umount -f or
a shutdown still stops it right away.  Direct and unbuffered writes,
whose callers get the error, keep following the mount options.

Fixes: 2c1238a7477a ("cifs: make retry logic in read/write path consistent with other paths")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsglob.h  |  1 +
 fs/smb/client/file.c      | 21 +++++++++++++++++++++
 fs/smb/client/smb2ops.c   |  9 +--------
 fs/smb/client/smb2proto.h |  9 +++++++++
 4 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index fb732c178e76..b6a993cc0245 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1499,6 +1499,7 @@ struct cifs_io_subrequest {
 	bool				replay;
 	unsigned int			retries;	/* number of retries so far */
 	unsigned int			cur_sleep;	/* time to sleep before replay */
+	unsigned long			retry_deadline;
 	struct kvec			iov[2];
 	struct TCP_Server_Info		*server;
 #ifdef CONFIG_CIFS_SMB_DIRECT
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index d746c4270219..6744b3e2b2cc 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -49,12 +49,33 @@ bool cifs_io_stopped(struct cifs_io_subrequest *subreq)
 	       subreq->req->umount_aborts;
 }
 
+static bool cifs_writeback_retry_expired(struct cifs_io_subrequest *subreq,
+					 struct cifs_tcon *tcon)
+{
+	struct TCP_Server_Info *server = tcon->ses->server;
+	unsigned long window;
+
+	if (tcon->retry)
+		return false;
+	if (!subreq->retry_deadline) {
+		window = max(3U, server->retrans) * server->echo_interval;
+		subreq->retry_deadline = (jiffies + window) | 1;
+	}
+	return time_after(jiffies, subreq->retry_deadline);
+}
+
 bool cifs_io_should_replay(struct cifs_io_subrequest *subreq)
 {
 	struct cifs_tcon *tcon = tlink_tcon(subreq->req->cfile->tlink);
 
 	if (cifs_io_stopped(subreq))
 		return false;
+	if (subreq->rreq->origin == NETFS_WRITEBACK) {
+		if (cifs_writeback_retry_expired(subreq, tcon))
+			return false;
+		smb2_replay_backoff(&subreq->cur_sleep);
+		return true;
+	}
 	return smb2_should_replay(tcon, &subreq->retries, &subreq->cur_sleep);
 }
 
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index dc55cd512616..457f18ce3245 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2934,14 +2934,7 @@ bool smb2_should_replay(struct cifs_tcon *tcon,
 		return false;
 
 	if (tcon->retry || (*pretries)++ < tcon->ses->server->retrans) {
-		/* Update sleep time for exponential backoff */
-		if (!(*pcur_sleep))
-			(*pcur_sleep) = 1;
-		else {
-			(*pcur_sleep) = ((*pcur_sleep) << 1);
-			if ((*pcur_sleep) > CIFS_MAX_SLEEP)
-				(*pcur_sleep) = CIFS_MAX_SLEEP;
-		}
+		smb2_replay_backoff(pcur_sleep);
 		return true;
 	}
 
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index c79e5cb2ce26..b2acff8938f3 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -121,6 +121,15 @@ unsigned long smb_rqst_len(struct TCP_Server_Info *server,
 void smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst);
 void smb2_set_related(struct smb_rqst *rqst);
 void smb2_set_replay(struct TCP_Server_Info *server, struct smb_rqst *rqst);
+
+static inline void smb2_replay_backoff(int *pcur_sleep)
+{
+	if (!*pcur_sleep)
+		*pcur_sleep = 1;
+	else
+		*pcur_sleep = min(*pcur_sleep << 1, CIFS_MAX_SLEEP);
+}
+
 bool smb2_should_replay(struct cifs_tcon *tcon, int *pretries,
 			int *pcur_sleep);
 
-- 
2.56.0

