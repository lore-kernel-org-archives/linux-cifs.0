Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793746826;
	b=49sJBUfMI8LnUIqxmUacBklrsJPeT5KLbu3F7/+w7Hhr+ImZ9lTXtG4lT/s4E6ArXlzW
	 FYih1CeoavfrJbjaTYFcVWtlOcWbENWZdwVqe+yQTlPGkmyzWJsFbijINaxdjCAH8/7Il
	 WO7qtrcfjIrBQVuwVs5hUajhIGIXgseMyuaSL/BilkUVF+09RWCBylUCezuPiEkPHIciN
	 TIs+fAT1lRQbptWGdrdTB+qoI70AW7E4MFkIc8drhImDdW5L8ezgZA881BGsdKxCw+0PF
	 b1Ifv14ZDr7fxmC28ib2C2CxID3PK0979Vf0+lPD7BzLQbyWLe1xVFXXb6wt9eDF/6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793746826;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=11eF9d51Td569VOB/2+cC+i9AZXOtItOca3k910dhKo=;
	b=xvHir8vE5+fYthRrWdf1jEFShDlTBzJ5wvWBJus9z6s2dWZ1QVe7lnnaLGWyZg95L6UQ
	 2lpT4OhTUI1UUV7wCTaSzYVZlnEtHGSZzgjVtTsmjdavTsTJjqNfsi5MAP4Ir1xCsJ1kv
	 efw3dPSWwXoi+dZf7J1EXSV8tXhzMj24M60d3cwFJQyd/A3X04x6cw+82aAr97kFktXKw
	 Jsi0eVAxUn3WcLOXLg1OuWK27VjVqVo3Oe4q9D3KZKF8S7xOIgGkGFlcng14CPMLAcLuN
	 UO1S0Ev01FOcnsoJ9tQflKOnxe1nvYiVc9RTiq+hg8nzdHHo7xRHLh9YZsTbkEUYB3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=cuE78+jK;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B2B606A333;
	Tue,  3 Nov 2026 23:00:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36B2B606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=cuE78+jK
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=11eF9d51Td569VOB/2+cC+i9AZXOtItOca3k910dhKo=; b=cuE78+jKDLhw4GT1Kc3kLL+/jD
	ej2CBR80apJgSxi/cRchOdB6rdrqAUdlxYfqlIekuTCq9JODzlymTv4z8QydQHFss+qt9y4pWmzFo
	sYZPfoeWge7kZHU2VbZPNgK2IMW6EY1eGkKo+4AK3PqeId6S8dn8YAkxtRh01poswUDWbkpLqQZJk
	i1iYBu5zyVk/WmfT1APNs1r5ZYUIx3h3vlguaQwOk61obwHUS5p9kR35XIfQhSvXuD976JDv1t7TL
	QUc2PyBLNvCnt+k1Vqj1RYBP1v+4BtCEKTjsgZwzF4tXFN7uJLLigCPtGGQghgLICeZxlxPRqc1uM
	Q/llMDfA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xONUN-00000000kOK-22ge;
	Tue, 03 Nov 2026 20:00:24 -0300
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
Subject: [PATCH v3 12/16] smb: client: retry writes that couldn't be issued due to a reconnect
Date: Tue,  3 Nov 2026 20:00:16 -0300
Message-ID: <20261103230020.1617748-13-pc@manguebit.org>
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

