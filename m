Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B27E31E115;
	Mon, 18 Aug 2025 14:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526087; cv=none; b=SHmNuZwheWx2LE67WWZO801fJii1euRqX6QjR30y83rfoWkghjNO5/jfFQaGs9U9S74B+qZ+J2f1cXDp5sS0jXAXomYGEQrmES8ict3zzoJ8NyrfCqPXmzP/e8IWfDCcT8uEzgva0Z8ozgEIYLfI1Uw+eSp36xFgGVhzPd2Aj9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526087; c=relaxed/simple;
	bh=XUO/HOu64xn0aV2mRSED/5w0tMBAeOVHWd1oI0YB+NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hH1TBe6H7+Lmqf4BnFNBD2UCRt4PdVyZnvjAEBvt4B4xxhkmFFUZfT0eJFYfH0cgAVlHumVM81JCszmJotpGOIFGCXWmJCvE54H3HCzW9+aXxrQ3KC6lnTjXD3i2oEhShMoLC7j+0qGiI21Nd8golMhXjJyF6kMBpYo4DD+vZY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvGYF/jR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvGYF/jR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2960FC4CEEB;
	Mon, 18 Aug 2025 14:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526086;
	bh=XUO/HOu64xn0aV2mRSED/5w0tMBAeOVHWd1oI0YB+NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvGYF/jR2llRZR6fslrWXvKQawkAN2U8qhofFxG6w5ra6RGg83y+zIuJ21gOeNVbd
	 xTUWuaeAnA/DvAOOp9YqL2esjymYgZp+MBjKSqREee0/UfsghNF216iy6e0mW2cpuR
	 JI9o1s4k2wsutYN2CtmOVjMwW24msaW6zEJbIvn4=
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
Subject: [PATCH 6.16 455/570] smb: client: dont call init_waitqueue_head(&info->conn_wait) twice in _smbd_get_connection
Date: Mon, 18 Aug 2025 14:47:22 +0200
Message-ID: <20250818124523.348923151@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



