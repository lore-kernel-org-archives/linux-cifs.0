Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793918745;
	b=H8XD3FwJyISfX08wsM2XNK4sdpAxWG0EscpSRbozKGvPC9RpQU7Shfu+DQraVFOi5gAf
	 6BU4i00qE4DrdbwBqCfhg9Hnw0LelRRj0JVIQ2Tp/SI8fY0AcFG6/rOPeMK1F+Xwed2Wu
	 Sc89TPmsbJTZ0zYADpr40EZaACgYzGF43mrZmSBtxd1yyBEtJHqTPA0VI+PlEN+OTDKDv
	 Mjmqbv/EJcWZyuzwFg3jqcNyGlYkbVu7QuGe2T/ugKOdd7jJowCBtv2Voxvhk35aqEaxx
	 V5Sg58J2E7VesyCfTz1qjS+BI7xYuUH7TNf+CnkaMjM/gaSjMRxQcwBzvr0hjF+srEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793918745;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8QJAGPKDorNl6Gk18TB1o1g7l5jVHtK9f9WT2QY+ccI=;
	b=luBftviuHEJdJ1Indll/6xlwedTumqhwXBMY6cHCOlmcrQ23rnbwPzYoVht8zTYWbob2
	 lWztTfawvHuzNLCk0Le2nJAkpnXj6eXb5IPg+7r9qdNY8pxy5ev+IeFc6rmLSLskvx5kP
	 ZbG75s3SbGwHI9S0Wp9PK9W0ZA2hMLPfkzqtDViKpkENQOiQlrpRK1bTgeRVvLK5P3BMd
	 z6ZDGneEADYg6lgV0cNYhO6xRHMqrV6Q1Le2owi0wUg3RHoQZkmE5FKbWJN8YxvTJFa16
	 Hfz+St+UXVG3pBLoE2vZtwKFUEoxEK58kjq2kKafDCO5aRWVmxhiQ3l9laE0HJk+nQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=WDSk+p+h;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8D6606D823;
	Thu,  5 Nov 2026 22:45:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B8D6606D823
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=WDSk+p+h
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=8QJAGPKDorNl6Gk18TB1o1g7l5jVHtK9f9WT2QY+ccI=; b=WDSk+p+h11qTCKLAPSYDIIXx7L
	ddSltntHh8jIV1cZLzZKDj1/QB7bcFAQ04fV74ayRLGRbyGEBUiEjnCjl5n3uN+5vsxrDx8fVk0ZE
	KCa7T9IICSrlujSm8gRnrwJJ5UK2BwqQivOwFUoXuXpci8+rkiyBOPpR5lE3y9Q+XB2lFglYbEnpD
	MUxXB1ao/ozx0ltN6e7wZk/XMJQu2k0eTyN0YW+4Zr2s/gA5uAoVlg6MNOfjVKxcf1xTJqLo5FeFK
	K52+tC1yzj2yMwIwnx4PQbqkWEtvdJJB+mmjxjqPdwIrx3ROq2rGv9F8WGkv1ZwYh40z43ehEQYtD
	57UidH6g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xP6D9-00000000yoj-0P6W;
	Thu, 05 Nov 2026 19:45:36 -0300
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
Subject: [PATCH v5 12/17] smb: client: retry writes that couldn't be issued due to a reconnect
Date: Thu,  5 Nov 2026 19:45:26 -0300
Message-ID: <20261105224531.2316211-13-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105224531.2316211-1-pc@manguebit.org>
References: <20261105224531.2316211-1-pc@manguebit.org>
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

