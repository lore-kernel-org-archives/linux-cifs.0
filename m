Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632537;
	b=icz1ItZrCWCs5VD4IIxA71jN9YWnMDEmh7b59GIUg6VFP9Ak2DgDIjah+F6ch6KGRy8f
	 GRkFLxprrewUnQ2RFpfZr6OtzTMd5GLDLlb8xE0dPcaiNQKt3LwunR1tesldSnAxhIHy5
	 9a8uZuQlzSBVZdAL8jpELskzAwMO+pj/y29/L8l90EAbIZLPO75/XPD9POG56D08pdzl7
	 iEIokTo8nkC3VkBfxu264GxTlxw7b+ZydenmKlBes6zb0T8CZNIQFh7VGB9WDn3fu5wrT
	 +Ap6i/JBOOf+tQZoFVDqU55ihNfOZk5N5cSvsu40tHpRo3WL2p9Uj5/c2lBD4nr6c1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632537;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aMx0Z8GCTkXepQt8f+/SrgeREk0K50a3eahj+mkRby8=;
	b=5aBL3AihI0PICuyYc0p4b+nIsr3Hlw1bSu9ESSJ7t+QsytFC/x627rcJYcscNCDVs77g
	 HsLdlMwDYHx7VeKKzRiuNVTepIPzMq0x+5KIUVkVI8GogJgoxU6BS9DBJxa0HL1jII0Yw
	 O6GRCwlg4OXi30sbKVBoN7rsRb3Sl99SD0monmwWzoj2zACD3Nqwoz8VJaiUjEtXOsnsQ
	 CxvswpNQxO+jbe/DPBXCHxK+ax0qbnGpzzvxBh9V0cEwrdUIEhy5ileOJ+9Kjh5f75z4o
	 FMA7qTjEypSDAoxg3ItMGaV2yST7fgqMivqHcCKXMY+WL4Rr3101OsVziYacYkimxZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=tYFqrblV;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499E2607B401;
	Mon,  2 Nov 2026 15:15:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 499E2607B401
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=tYFqrblV
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=aMx0Z8GCTkXepQt8f+/SrgeREk0K50a3eahj+mkRby8=; b=tYFqrblVwCJdwfI7cNs4PsfISS
	t61rwJFsPCWLubdPrWoz9Pod+YMgchcrNOvdQ+vR3mbCjFi2YUWUNpFqtQJNdChVgaYjY1qfJufkw
	9Z+7EJjldJ/Uqv1hskSM0Iz5/PSfmGy7KYS06IY6JhtXNNKkMlfw/Pyni1sY+UzGE6FZr2iew8MrH
	Ti/GqSOc9VznngBOI0HCVovHmBS24inQ7flsG2VsjDhWRDMgNurSxkVXcMz9sqPTJcCf6DMglmn5G
	+1pMm2jIYSHx/BrjSd5UIlPIqAkhmuLYiUb9/pAqK2w057M6w4tk101cVdbbd6EpbejN2/clyDxYN
	vmIh8nQQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xNtkv-00000000aT0-0qsa;
	Mon, 02 Nov 2026 12:15:30 -0300
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
Subject: [PATCH 13/15] smb: client: retry writes that couldn't be issued due to a reconnect
Date: Mon,  2 Nov 2026 12:15:23 -0300
Message-ID: <20261102151525.925058-14-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102151525.925058-1-pc@manguebit.org>
References: <20261102151525.925058-1-pc@manguebit.org>
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
index f5deedb5902d..0340933dec82 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -212,10 +212,12 @@ static void __cifs_issue_write(struct netfs_io_subrequest *subreq)
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

