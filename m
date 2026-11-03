Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793728988;
	b=3wUbZruBWbyls3kNpEpjwqj6gngXUpvXF7w4PWtWwnPPGiUnT2fyNE1anlrVBGatNZ9j
	 pVw3uFln2iNchTNFmLx64gVRYxcXbA5a62aRbAFJ6faBZLzL7zh+sobkkO9Hydt+5kdDP
	 p6tkoRMxsqhln4+Dqlp5h8XfbtkIVcdjHDwIG/VIk+BW1GMYi4v2ndKtzoZJlYfbZxKy+
	 829Qzx2QqRnr4dAVWsponpRI5RlbVFbNx5ZdcAw9qIPt11uGfir9lSixgnw0GGlq8ltyA
	 6+VcQw2UClbxOsaEwfJUszuT5GRKl2tDNVJhpWBvGZdJPPOwb4pjuPe8wKXp7eCecQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793728988;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jFMf1wxTtLf60s2qp83Ze0U5b1PJQqWbw+oYggIRdk4=;
	b=vpg+6t0aAb/FuQOrAzfZN8js1glhcQosKnHQVt+OeoYvlK+caVc1DyAmlFd7gpx3AU5Q
	 9nNw7/svvI7DFENg2kRF77yURTbggKzfVyIQmNS1NQ98s01HduXaRBAXYh4cF6OFzvvFF
	 p6xcqxc8Udjy8D/0qnN0wfQiVBuhj5ylNFhdnQBpj4bs4FX1Gci8eDmSbEgdYODpAYCqW
	 RJMyOIltcX+vr+v4slwmybgL5xs8myzz/fnWdtbkbTymRzc3+bSWyEP5EzsQiKb2OibTB
	 V7wb4kajfOKFPAjtE8NV95Ts7yELaLX+EOFnoRKP/zU4ivmjmBmvXKPG43bPLYfE6bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=snKvuMiI;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CA1606A33C;
	Tue,  3 Nov 2026 18:03:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56CA1606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=snKvuMiI
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=jFMf1wxTtLf60s2qp83Ze0U5b1PJQqWbw+oYggIRdk4=; b=snKvuMiIrcOWQKjprqDVsNOLI6
	OT1QkB5TefLWTQyukQ/l6KmX9rSx6qIAGhjIqDrk7oRVBCoA28QlkWu3ZXjFCEhfOYrW2DEvCLY/G
	E3qMFy9y+jd12vF8xR3cKfliizyQl2LtlrvBJApXxep8IeplhDtE3gZjvxQrxr+R5EZBJ2ttubLlX
	deIbsgLH98lAmYrJ725qer9T4tABsGYPgc/te3jLcn5G8FgTm4NXZ5Tp7CfiVfVUavKn26HGt2+j/
	S8aJ7XEKhIsci5Tnlq9Ty8hdkOxg/AJ+Xda8TEf8xya8kJZXJkrHYrNBH2+ujf7CEfBgQmD8/9/I0
	ivdOpBfQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xOIqY-00000000ivd-3tAj;
	Tue, 03 Nov 2026 15:03:00 -0300
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
Subject: [PATCH v2 12/16] smb: client: retry writes that couldn't be issued due to a reconnect
Date: Tue,  3 Nov 2026 15:02:51 -0300
Message-ID: <20261103180255.1482516-13-pc@manguebit.org>
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
index db560d4263f7..f1d6827205f6 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -214,10 +214,12 @@ static void __cifs_issue_write(struct netfs_io_subrequest *subreq)
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

