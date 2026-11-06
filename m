Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793979438;
	b=oJJpX5ZYkM6rr3mEvnpX05KGuwRLjORCBrErFAc9fa7acUxoPw4yKWNmC3wsGvFL1rFx
	 CXUi6hIVlUeFHAH6knWjseDYgFsip3TRrGztHx+rN4lPmj1ipoxiQpVlweHExJKf+JfM0
	 oRSOiMOI5dPJJ4PflIgh1BeE+ex6ReN5mU2/lJqdfINPHvqLtf885QkXLgWGI7OcpKj+Z
	 ktSl3w6FwYYLeH0POErwGWXtZhAuXLGfPl6ye05APS7eOKj5TYBC1Yz2+R2eKrHV4O/fm
	 wC9b49uPc7XTr2p8Sjh9xMcXFIrvx0D+9l85rkk3ZkkDXTC+0dgrvPc+3yJ9sgNjBUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793979438;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8QJAGPKDorNl6Gk18TB1o1g7l5jVHtK9f9WT2QY+ccI=;
	b=3F5cDZzGG22/10krDFLuYCJ0dwXcW7s85hfmvBtI7LrHXS51nNnoX49N6i43dzmxvmPJ
	 1x4azGPMBkWT0EszmH0p8BqlNyE/nSRk5KxWvC6HIKpr37XI6PwVuW7WSm1QdYqJMT1wM
	 LJT8tlLr5zahCqj49DbcTo4rlApPi5tHSkHHREj3w7Yu721vbUgdOqaPaDW245o8t41jg
	 9jFcSOwOwLzurrb1NH1X+opRcFdvfMde1Mhb9R9uOBdsEpzTcRkbrtFs+blB9Kp24kWa3
	 RbJAaMN8iM8CPipE5QL5BzHfRpis0L3sn/6diiOg+IACFlYlyZ3ghApZvok7gKzVigQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=amsctG5q;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07D4606A336;
	Fri,  6 Nov 2026 15:37:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C07D4606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=amsctG5q
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=8QJAGPKDorNl6Gk18TB1o1g7l5jVHtK9f9WT2QY+ccI=; b=amsctG5qDxTr8uQi2zZ4GlRTfg
	jNz7s15XQDvjdrPBt1O3AR5quo9Qu61jhmMY0vdO4IIHtmVwSov2/ZS6aIOe67PBJGm+rZ7UFQs69
	/+dC3kjWDTwQzFRzw0DmApbswc+3KU6hD7aSMyzpimVIVtPDn0E4odP6TqHvsnUe0SmwTST+U7u58
	YlFsm5TGqhaxA8fYhJew4p9SzuE99S+D4SOHKMBvtbl7VRWO44eV3q2Ch0XSfr0lmsgs6Md4LaXNi
	kxZeZvFA4305vvpK8+NK6D7w5Mxi4ZDkqj3xMU3bLcQbXAHWB9bVeLqwa70kyj0XFJtcwtuTsw7H5
	Et2q8H2w==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPM0A-000000012aT-3Yfw;
	Fri, 06 Nov 2026 12:37:16 -0300
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
Subject: [PATCH v6 13/18] smb: client: retry writes that couldn't be issued due to a reconnect
Date: Fri,  6 Nov 2026 12:37:05 -0300
Message-ID: <20261106153710.2498773-14-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261106153710.2498773-1-pc@manguebit.org>
References: <20261106153710.2498773-1-pc@manguebit.org>
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

