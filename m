Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827702;
	b=UD2mkdQpJKQWaApZPtlSULFm54oIt00sbUF3NVR9lBXWY75Dwb+Cslf+PnKqCmUSdmfy
	 1O9tLr+4sAFlmHFqE97a+Hb1Z9R2o0T2KUCMs1PSOKsjCYVwkCepePYh4LvyBH0Ms7JN9
	 2GxNv/aZ6m8f2KV5ThK01pJ/JgxRg7aVkeHA0ktJ0DJFxiczVRfbEHT+0gMqnQydeRXAf
	 P4x08mlYecVFx74LWpbJWzGcehrynH7MOWMABA6nUHWvheWLoS+2+dan6gsufLeHxQmOK
	 NkJeuOrF2L36anTA8OCWYb3hN4+JyZTkEuEKGfbx4F8y57cVcOeSK2S1g32EPv57Iog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827702;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=11eF9d51Td569VOB/2+cC+i9AZXOtItOca3k910dhKo=;
	b=D+rMcvhBQQJ44/JU1BcSUycQuM92yAZo93VxfJnLrwUCRnFT/+1RVz2gNSObw0qwFsvF
	 2aoPYTRgpfWjNfeAH0UDx4GQ6vuTW0ZXgJGFVzJdnI1CG8s2vIRD+pa2ieXczg0561NiM
	 pSkZjSKmF9/iJPlNjyfKlQKMT8NETsB3vDU2V7qTXPRhzutHP5zacHT+JL5Cv8xoCtWKR
	 z0ZiZYsZuQnTeqJdJuvsF/CyrbTFR2JIeC5dyMkJ6BHx3iwU4c0G1CFtIAuaQ5Ti/pwPD
	 he9bE9bEh2PfTzEtWSseA62/k99QLlgkpKq3upBb2tlPJ0gPDYhIQ+Qyk/c8NCX2O4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=7HdGpydN;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E795606CA34;
	Wed,  4 Nov 2026 21:28:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E795606CA34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=7HdGpydN
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=11eF9d51Td569VOB/2+cC+i9AZXOtItOca3k910dhKo=; b=7HdGpydNoJw9fAD3Wpjiw1BCZT
	Jp6BkjQL6CKbwg47MJU11dNzyU514ev5HI9+fytK9m6uus7rxO6JQrv2RUNarpW6DR3OkXboLrN62
	rcGm/Wi+PBE7UQoNVXHl7m1Z0ceZ6lhvjjlwSqUxEtu6g/QFV48glftT1LKBmsjVzvi2WeevumM1m
	odciMkkZmU83RfY9Eqj16bbYV3Y+figpBKlz32WFmrUDkd0q5SVXzdKx2TUKBXCk6gNg3dX7xsmfx
	y92oPz56kV6blRp460ohJVG9Hp5w/KqnW/FJz1p4dQbe64hDj6UVdJTJ+OoMRG6JKNkAPqD3AcAl0
	9hhPHANw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xOiWj-00000000rHz-3ewA;
	Wed, 04 Nov 2026 18:28:15 -0300
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
Subject: [PATCH v4 12/17] smb: client: retry writes that couldn't be issued due to a reconnect
Date: Wed,  4 Nov 2026 18:28:05 -0300
Message-ID: <20261104212810.1935575-13-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104212810.1935575-1-pc@manguebit.org>
References: <20261104212810.1935575-1-pc@manguebit.org>
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
index 5d8b3f25ccf9..0a9b241dce40 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -216,10 +216,12 @@ static void __cifs_issue_write(struct netfs_io_subrequest *subreq)
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

