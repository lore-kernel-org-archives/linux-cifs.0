Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BCB3909A9;
	Tue, 21 Jul 2026 18:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658241; cv=none; b=hCQxThhEby+DgkKj0tKbAomNN7ZpcHQPurC8mOo+Sn4eknOgLFnbmH361u+0GrlX+gBcirUCpNbfq7bl8zNSU7i6sxpVWv0rLdaJK207Ax92mwpWg77QY7HGh/Vt6eyad6BWmIzTi9etDBr1ja9D8gyrwb0YlW70vGS3i6RX+J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658241; c=relaxed/simple;
	bh=rUc29A9PjNAf+JHDTKFoMagmrJ+s0uHJQQ4kyxrYoqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cB6kaJErgIeUXV1JfwZ9sPAzNcp0wIpg+4ZJ+g2cSERWgK+5LXaqv11qT/XQq7Rr7rdMcaq4I9lPMfM+KdGvqhSfAI14PsJ8TAxZjBOFIIa9zQpi3vzOnHk5Zy0MXdqUjCr7iHOlYIedFSb+P+0vTRYEGrKfd49pcDafpDTRmAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQRfr4fX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQRfr4fX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065D91F000E9;
	Tue, 21 Jul 2026 18:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658240;
	bh=pWVEjzgg0DiNhboVL7JArRDYBs0nNS7/M0p0/QvlRoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQRfr4fXgt5QXt3kCBWeZVEwaEreqUw5QL9WvsRlq0qhCe6UIsfJmxe70dem75fap
	 hDy2K54/a1Nx+rVBsFTaKGvJd3BHSvMf0ZlOtfd6no9D95I94wq6UoKv0JN4cY+giB
	 am2MZyqb/ntEMnYu9qVdPSgxEjC5JeRXNCXd/nuk=
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
Subject: [PATCH 6.18 1026/1611] cifs: Fix missing credit release on failure in cifs_issue_read()
Date: Tue, 21 Jul 2026 17:19:02 +0200
Message-ID: <20260721152538.468844515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b0dc071a9de4f2..a34457d5143e1e 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -242,6 +242,7 @@ static void cifs_issue_read(struct netfs_io_subrequest *subreq)
 	return;
 
 failed:
+	add_credits_and_wake_if(rdata->server, &rdata->credits, 0);
 	subreq->error = rc;
 	netfs_read_subreq_terminated(subreq);
 }
-- 
2.53.0



