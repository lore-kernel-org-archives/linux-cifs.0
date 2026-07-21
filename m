Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95AB401A21;
	Tue, 21 Jul 2026 17:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653653; cv=none; b=oWHQP4/XPYSdZIzzgREpniaLUYl1833OxSeu6WOWAGx4ndGLOwR7dtmqG17gLuOxiTkQZeh32gdmIvROndp2PwIVu7i6ReA7TMdJGtKSxd5TF4XQ134ubGxz88UYjwm+2pdRvh+YcF5d7DDgeUGRUW53U323hIGEzk2yTQBZqlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653653; c=relaxed/simple;
	bh=eUaQy1A4kLD/ZBMzXw1WBJgxeUz4AxYBvCAUJNiUz/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwjLRkZXfYKCKzdpAHxVZSKKHR7cfliEiigW+JZ2r7DhAPZwQ79dBKGfuJy2oZiaMkCOS7tTU1Q2Jn0phbbtsNIQlH8if/194S+AThvp2zw2ve8OwN0fiyxuPm3PN2DMzr3N/60VrPsm40PgLlDGuVeGQLA4OGDOrwxPjSYWOVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2NnIXKq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2NnIXKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CB21F000E9;
	Tue, 21 Jul 2026 17:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653652;
	bh=V2j5vBMDdoK2PmU807+C8WyWDwicIDkYparZUF6f/1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2NnIXKqzuCgU0U18KnSta58DEzvXsX7oBFRL6hEvV3MOgqj5cVSxgQMMF/ybRfpa
	 HgZT2EEH5g7byWtcfVrJTI/x9bfuptrw97H6LShQN8rt/3I94WqFoJAi4b33gJpSNM
	 K+YaAO23Do0sD1FXX/M86cVeDYYW40HSX5jZzQas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1408/2077] cifs: Fix missing credit release on failure in cifs_issue_read()
Date: Tue, 21 Jul 2026 17:18:01 +0200
Message-ID: <20260721152626.016389328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit c16b8c4cfb4fe2244cc33e469a93c1ab8684146b ]

Fix missing release of credits in the failure path in cifs_issue_read()
lest retrying the subreq just overwrites the credits value.

Fixes: 69c3c023af25 ("cifs: Implement netfslib hooks")
Link: https://sashiko.dev/#/patchset/20260608145432.681865-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index e536e424b9b750..b5a61a4a43b85b 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -241,6 +241,7 @@ static void cifs_issue_read(struct netfs_io_subrequest *subreq)
 	return;
 
 failed:
+	add_credits_and_wake_if(rdata->server, &rdata->credits, 0);
 	subreq->error = rc;
 	netfs_read_subreq_terminated(subreq);
 }
-- 
2.53.0



