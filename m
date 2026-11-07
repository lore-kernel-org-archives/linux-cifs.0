Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794024587;
	b=RBhEs/NOGj1VBJVVc0aydfNu2PgklAJO4RE4ye5iBVM2+oG3JVqh8vFzewTN0lie0AzV
	 Kb/gl83HRuDdpi7pr2vKJ2eMj08itHLAchINA0TW0Ie3vuu2GxXlwIV35cK5cDyXWxTqV
	 ktcsojRhbmeRy7b5JOtkrs+OjF1UZx46Z5huslsH+seiRSlbo4+H8xDBjz2w2a2jqTt24
	 5Jqv0aErHvAesQjFfqkV7zsTusYqXdK2ZDqWHeYkcCX0Y47K8XI431BzBYwcmyOLIegXo
	 ol5LsQ1X1MN3F4HOXCQAZQ91HA4EXlmKhBTl+w1r5gp2jQkJSP1AFCT8YDjKxPAmTnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794024587;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8QJAGPKDorNl6Gk18TB1o1g7l5jVHtK9f9WT2QY+ccI=;
	b=ZH/vFFvWaJGZmWdeaW9VdkC+Fde94jYUMBCu6526rYounoJGIGFruP07Vg8Q2Tlxsqho
	 ER0oYROpV/JmDXcnPXAqtBSLP/dhJwmWuUZ8VE2/N8WZrvDlSfnQ5N/8Q2+yuAaAGmb3v
	 PYVgwzcoI5vfCfu3c6YdtppxFRkz0JFWztP0HYWVTvg3A0d1O6QBNd1xQGSxqFLIrlw6m
	 f57YjldDs+Hxr13P96O3N6aNL1soS7HWlrj6xVB6qnpkg5LB5h710dAQJIBuuB1/BjpX2
	 oA0kC8hEe4vJdEArpJ5JlkYNMgFnzxEXW0Dvb4AakyEKjgRWu51+XK1BGvj1O9rFyjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=bAtBiaGZ;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2C2606D810;
	Sat,  7 Nov 2026 04:09:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E2C2606D810
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=bAtBiaGZ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=8QJAGPKDorNl6Gk18TB1o1g7l5jVHtK9f9WT2QY+ccI=; b=bAtBiaGZ1F5dgNYr56juc+jAjP
	IRmIzpKqB30u4zuj3cZY2GOx4OIF4kMflKePYVZBvsVR44HjlaGTFuV2bd2YazU5A+3Ya88EgthLe
	DO6ilC/LjxN0nUMzHCNW763K7Ixisc0Bl63QPofs+n4lRxCejrkvWNKdY9TwtTLtcfNje6rbillj9
	1zvNt0yBlYl5kkCwVai+fJOGs/pGGboMKPecOm85U2rFan9PcrliByAH7ihxAdvAcdCCc3/KQr1d9
	W8ShFianDFP7aHLaw/BRzLMt1uNJ7o2W6Ty66qFyVerTdvbXNwfgbQvVtgA7Ba0FHqKKBK+kEXkXo
	R0a5qORw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPXkO-000000015Nx-3cHE;
	Sat, 07 Nov 2026 01:09:46 -0300
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
Subject: [PATCH v8 14/19] smb: client: retry writes that couldn't be issued due to a reconnect
Date: Sat,  7 Nov 2026 01:09:35 -0300
Message-ID: <20261107040940.2692656-15-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107040940.2692656-1-pc@manguebit.org>
References: <20261107040940.2692656-1-pc@manguebit.org>
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

