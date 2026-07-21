Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C4146D08C;
	Tue, 21 Jul 2026 19:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663243; cv=none; b=Ahxo6ssea9rZgHJ9P8f+YcXWJ7yy2HBnNscVsLzrUGDEUc+IQxnU2nbEXc10msdr+Xwq0DIgDH1XFJ23iwrMxqOMyXxb4ljD/wV0VcrqVmu7pw1nZtw96/QCA4XSSxYH4o93V6Ms85QY5TH0L8ZMzGpG3vn9GQ1brHnZpYu3myI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663243; c=relaxed/simple;
	bh=0EfDpBpxvsxJxFcrgUvTON3ATzWej9DjUoJpoZMb8Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMqyO+fmfYucKKc/oXK28aiZaPSSjWJks/HIAfcKPpS5ZF4pDKG+D+LnVlJiRlYWmZ9kdIIbScHnfAbabi50aY7xEx4y6AbXALffNvOHpEeizzMnAS5habWDAAmiyaClDgRKtJCOIKUNCYclAfnDBktoWg4BQ4tEr8rOtXvm9t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dagh4fwF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dagh4fwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88D41F00A3A;
	Tue, 21 Jul 2026 19:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663242;
	bh=UK0szY9KxVdwUltD8YUMU0IpUl6qJIWu0V1z0HD3oXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dagh4fwF+GJ9q2jkUPEBbwnyxAz1gAWzLWRolJMmYVarhZNajldG+EFYrTS7wanB5
	 upwmjfVeBCiaXYhTR2o/TZd5uDnRV+iNKasf15PVrB4i/q+tFqoJEpb9cWt9GTN1/W
	 zNvMUFInD51QTjJPj9H5vsJyIpjUxvnwkk1qHATk=
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
Subject: [PATCH 6.12 0750/1276] cifs: Fix missing credit release on failure in cifs_issue_read()
Date: Tue, 21 Jul 2026 17:19:53 +0200
Message-ID: <20260721152502.862801399@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 898fb7e293ddc7..70b64df9fb2ebf 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -229,6 +229,7 @@ static void cifs_issue_read(struct netfs_io_subrequest *subreq)
 	return;
 
 failed:
+	add_credits_and_wake_if(rdata->server, &rdata->credits, 0);
 	subreq->error = rc;
 	netfs_read_subreq_terminated(subreq, false);
 }
-- 
2.53.0



