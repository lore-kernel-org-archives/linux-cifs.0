Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EF2335BCF;
	Mon, 18 Aug 2025 13:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524273; cv=none; b=m4FLH2zQ0fbV68o5Hd7WByOc7wS4hvEUB/Oy8pXKzMJEr+gNsh4EHxpf6/sr2leo5TUbG2rNi5S0qpDksTbQjWoF3YUkAv6nskNPnoC1KJtgWRS2rp6fzsM8ouUktUaGzg5dwR+4kYZHhPLNws5h16OiGmBV1IbqliKoPGOMi8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524273; c=relaxed/simple;
	bh=WJr2J+jJPccVCJzrWVPVlwU/UiG7mm7jQgA6jMBcqRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZS7YWBYa1GCP9jk0OsQoY63pnSzqZ5wPhhiCxfppoaAO3AEQjDht60bcw9gN+nlYxoFu8yVJ6maRIFIEacQP9wnI+UlN92dCFYX6fATB0aedFoEeSVjCPQeAPTdE22Rxzjfn/gHLHkshRyBohxLItV7//j6U7aI9yLQv1srMla0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpEgD2OM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpEgD2OM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D559AC116D0;
	Mon, 18 Aug 2025 13:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524273;
	bh=WJr2J+jJPccVCJzrWVPVlwU/UiG7mm7jQgA6jMBcqRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpEgD2OM6O2n777b0lr4rq657C9hz2+OZT+79CrKSPllBIQL+Xfsm14+PnKcN3o5M
	 4zQGRYLb63ue8/sLqBxlDkG+te0IF4CHryIYM0gemhlCm3a4O5xy+IoqxEGLeO4t2E
	 QSvUiN4swUXZDf92nB//m+kBVxvfQTE6Hmrg+UGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 421/515] smb: client: dont call init_waitqueue_head(&info->conn_wait) twice in _smbd_get_connection
Date: Mon, 18 Aug 2025 14:46:47 +0200
Message-ID: <20250818124514.634209165@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 550a194c5998e4e77affc6235e80d3766dc2d27e ]

It is already called long before we may hit this cleanup code path.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smbdirect.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index cd4c61932cb2..b9bb531717a6 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1689,7 +1689,6 @@ static struct smbd_connection *_smbd_get_connection(
 	cancel_delayed_work_sync(&info->idle_timer_work);
 	destroy_caches_and_workqueue(info);
 	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
-	init_waitqueue_head(&info->conn_wait);
 	rdma_disconnect(sc->rdma.cm_id);
 	wait_event(info->conn_wait,
 		sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
-- 
2.39.5



