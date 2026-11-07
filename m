Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794071592;
	b=yUDIMke/L9YvhqTp3gIimIjvpZcCEiKRE3n0zCKqnCoRuBIyUiCVyfb+O8k1RuzBuQR6
	 CZR4rtYanEmqWws93Y2RruhwL7D9pQDWCK+L63dfmk6S2Qbd7PQT8BXXvzACVbqDbLrdw
	 0Fd2nmhuT/1h5Sc1bFgdIA7YIA+83iTAwr27HAnYPekhS3sqz3+2OS5w9rxBpS+k0bqSY
	 EOPDM4qmZ7+VJkHYTovuhhRyAi5FULJhafdmCfXVqE6O+bbdcOKqMG7fLuK/Mds0tQcRY
	 Y7gYJVvBQjw4F7ux4Yl4t3t11CrN2fs0OE+IdaEmo+fxK96t+k6iP/H/WbhE++7LjMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794071592;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8QJAGPKDorNl6Gk18TB1o1g7l5jVHtK9f9WT2QY+ccI=;
	b=SPGTstYlgS6kjgTGN+uW8o+vzw3veif0kwIiVB6TFx/zT5kme/9kFOAAp2ZV7SpdRRdp
	 tbhbZUOgrsQ3ZrOnl0IHeUuJrNSI81V7NjteV2gT1OL7SmxMjMwiW6U3RKM90+9AGspnx
	 lWPhflkqbw5rpnl7bmezYFRO3Wud7bJSYIpfyDA7VUehVQkI1vxRCjbKTxgumHmUQQ/Ed
	 RacY+R6n9po5ptAKlUqSlYBcvZBm8g0V75hSr8d/aQjvIJDlcnle8XG7MfVufYtmt4wrL
	 gL/0nkFN8IvyJA7KVrVoZYDat/1CvstSIy0mokc0d9bm+YvNW+HvH6e6CSJxTP7dOmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=sHz482ZU;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08AE606A336;
	Sat,  7 Nov 2026 17:13:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D08AE606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=sHz482ZU
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=8QJAGPKDorNl6Gk18TB1o1g7l5jVHtK9f9WT2QY+ccI=; b=sHz482ZUanf/M08pBPs5DO01vw
	tZ0kQLTDKIhMMAEIgSXDRC45BGydzF/PsZeE2KxMYjrGxWdV0fqwWHH+H9O8N1iTCQL+9OHTkhDuD
	vYIsmbKFp/6Z7MkWqjIqQNznYzJ8uBBF0RwJbfanvNDSsLRVGIuEciTZ2fkdWD+Qxr5fVqciaTuNV
	sJ7uwahtoPnU35xiqdYCOq3fhvO1PM8PPd5E52qMUTa2DFGbka1lslNFVoxnTJCH+RBV6OhHbK/ca
	h4K9nzI27eV32vR2UXJVgr8GF3wKtBOOa7BtxOpLQqj4XgXAIclEE3DSUCe48tDxxpguOahNav+bX
	BY3upi7A==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPjyX-000000017hZ-17Oa;
	Sat, 07 Nov 2026 14:13:10 -0300
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
Subject: [PATCH v9 14/19] smb: client: retry writes that couldn't be issued due to a reconnect
Date: Sat,  7 Nov 2026 14:13:00 -0300
Message-ID: <20261107171305.2847361-15-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107171305.2847361-1-pc@manguebit.org>
References: <20261107171305.2847361-1-pc@manguebit.org>
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

__cifs_issue_write() fails a subrequest with -EAGAIN when its handle got
invalidated or its credits belong to a session from before a reconnect,
both before sending anything.  netfs used to retry any -EAGAIN by itself,
but now only retries subrequests marked for it, so these writes fail and
their folios end writeback clean, losing the data.

Mark them for retry instead.  The retry gets the handle reopened and
fresh credits in cifs_prepare_write().

Fixes: 82e8885bd763 ("netfs: when subreq is marked for retry, do not check if it faced an error")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/file.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 0fc1f74b55b6..7e1e886dfedc 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -220,10 +220,12 @@ static void __cifs_issue_write(struct netfs_io_subrequest *subreq)
 	return;
 
 fail:
-	if (rc == -EAGAIN)
+	if (rc == -EAGAIN) {
 		trace_netfs_sreq(subreq, netfs_sreq_trace_retry);
-	else
+		__set_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
+	} else {
 		trace_netfs_sreq(subreq, netfs_sreq_trace_fail);
+	}
 	add_credits_and_wake_if(wdata->server, &wdata->credits, 0);
 	cifs_write_subrequest_terminated(wdata, rc);
 	goto out;
-- 
2.56.0

