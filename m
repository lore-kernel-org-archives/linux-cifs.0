Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AD932039C;
	Mon, 18 Aug 2025 13:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522581; cv=none; b=A1nlm1PRwLlgo/fWnGBxK9i1ZIMEcS3X37oQGPNwAGbAAAleXhdRlhLwIgMdiWJ5E1GncqHzSjzt9tfT098vDtj+chpJKqm64XCHEiXkuR4n0UeWXHCpo/WeDiMbC+Ya40+eUlEbCnranAsT9o6/frUN6QhQeY0+7Si3DvCEL7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522581; c=relaxed/simple;
	bh=vUeV5ABvzHkBD/rYsWo6/Rmz4WU4Crec79TkX79eEmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkIwDI5Bkmwzih2WSkh9KdJlaX0+GGWlVsI2XKSYvTivH0W5dB2elGCotO2XpmAlKcHb4yF0UA0MX5GvrFRU83LiLCxN79WpN75g/yRK9gdhJ4ydWsqENjaw6mJfHo5Ie8o3PKvWqW69RIX2TF+GKx0p2V7C51CmcbgCp38lZcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7v6E7wc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7v6E7wc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138DFC4CEEB;
	Mon, 18 Aug 2025 13:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522581;
	bh=vUeV5ABvzHkBD/rYsWo6/Rmz4WU4Crec79TkX79eEmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7v6E7wcnKx3yiDeIE8qrF6Vg2zLqudlMKak4XDZQmamb9NRxPY+ri/qp2nHlfEJM
	 AjL8hKsaBitcmQgXk7++hl3srCHnShrvBIPR5MfIE6Upx/5Bc8iukl4FSr3MvnAJ5o
	 jwRDXYNnP5nnSn/G5lmhN3Q/EHo2IO7FzUEwlASg=
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
Subject: [PATCH 6.12 357/444] smb: client: dont call init_waitqueue_head(&info->conn_wait) twice in _smbd_get_connection
Date: Mon, 18 Aug 2025 14:46:23 +0200
Message-ID: <20250818124502.300002189@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



