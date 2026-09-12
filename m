Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026B9344DBD;
	Sat, 12 Sep 2026 17:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789233913; cv=none; b=gldHX5SmKVzXyLsdiyUicCyTw2Nam5gmnwvLy8B8pbbkCngfkIfBA4AYE4x7tpEKIOcjbTPiSOTrciaC+HxDNeyM+qT7cQRtG7nY2M5HlfrxkQ71atG7r/iiW+kcRMElkGMZmJ2D7ANdxvgnT20RSjJc6zLSl72C0Uh8jApT65g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789233913; c=relaxed/simple;
	bh=QXDRw9pV0IRdDDA/BtqZMyVyh7hevMPQ0dSLNvpv1LU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qlN0lOoDcbwpFC6jXnRb9mOOHnkxH5UWX0Y/63R2V8yzwWHG2CWTbbkagygI1w4jTYs50/BmhxbS+P1uoE3Os7VFjtmbIJZ+HCbEqKWGHIUOx4VQoJGGpO6/xKYctEo0q2lE3mYDaX7RGJewO4fbkJ3NuNTpVsMS6ms8qrYc2kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=jvqNcw2Y; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="jvqNcw2Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=rIGHI5YgO7yAfuFproSRnoA9xeddrN6au8mFY0weL5c=; b=jvqNcw2Yy3zfbJRX2GKMhNVe0m
	j1/Lg0wZGePv77A13iy/kwef3UcATUx/kvcteQ8Dpf5QsrgnplswNDPdK4805PuA7/drFLUI/A13j
	/xBSA/8sQm59ODIpHbQo8F4H9AEzHyZleSDTqOtCGZ2OIIjwWThqMPOK9Fqv9N7h+iExXUHT+3oIt
	0ouSx32IGzfsNI1vdk4Ns47KB+vbSLbp/Wyonm5Z3vuk/5IbX88NLbttGAfj7iwZgP1y4A/jJhVsd
	5xuB1QoGImXqqAvhqALBEIHqDD2/pN1xmhEXINox3PlbSF4JYEZ9hd3ckifumHmvXqDLKRtlPuFD0
	5BLWSeGA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x5RTR-00000001Hxi-1WPv;
	Sat, 12 Sep 2026 14:25:09 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Tom Talpey <tom@talpey.com>,
	Stefan Metzmacher <metze@samba.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: fix smbd_connection leak on cifs_get_tcp_session() error
Date: Sat, 12 Sep 2026 14:25:09 -0300
Message-ID: <20260912172509.542168-1-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an RDMA connection is successfully established via
smbd_get_connection() but cifs_get_tcp_session() later fails (e.g.
kthread_create() returns an error), the error path frees tcp_ses
without first destroying the smbd_connection.

Fix this by calling smbd_destroy() in the out_err cleanup path before
kfree(tcp_ses).  smbd_destroy() safely handles the case where
smbd_conn is NULL, so it can be called unconditionally.

Closes: https://sashiko.dev/#/patchset/20260912165503.521597-1-pc%40manguebit.org
Fixes: 2f8946464b11 ("CIFS: SMBD: Upper layer connects to SMBDirect session")
Cc: Tom Talpey <tom@talpey.com>
Cc: Stefan Metzmacher <metze@samba.org>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
---
 fs/smb/client/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 4bd9f9fb93bb..28e1ddeb6182 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1934,6 +1934,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 		kfree(tcp_ses->leaf_fullpath);
 		if (tcp_ses->ssocket)
 			sock_release(tcp_ses->ssocket);
+		smbd_destroy(tcp_ses);
 		kfree(tcp_ses);
 	}
 	return ERR_PTR(rc);
-- 
2.55.0

