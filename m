Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23401D5CF9;
	Tue, 11 Feb 2025 01:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739237436; cv=none; b=tWPQV6HFOefLWK628dfl0yUKaPbB7kgmxSC5Iyrh+RnLviIFZH+nHsnwWX9TGz0B0Ex2nNLUMTXs91tJd2+rEsudYVv003+SfTh12juSgcT0FFWHVvdApnubxh9isiqfKA93EZfdW958Mkw5JYWRxh9F8fK9TVHrmFFqG96g/AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739237436; c=relaxed/simple;
	bh=eXYxIYhQnRxdnBruJ4nG+gZNBYKmvqFallQwM3QYjb0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UAFQ0lk46ZvlAponkxdc+Kk2Fsv8qnz2bdFAzEIcfy3jo4K1e9DNUiSRVLDPjLO/hRJUOjigvYxY36hnmaQstf8ikczNwqVRzaX6Zuwhlcr+JMzfcjuhFEc+wxoZ3HchQHQ8rR6R+GzVoSW3LJb7Kgbw79nAbSZEFfRfhfzLlC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OAO1dE52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OAO1dE52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537FCC4CEDF;
	Tue, 11 Feb 2025 01:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739237436;
	bh=eXYxIYhQnRxdnBruJ4nG+gZNBYKmvqFallQwM3QYjb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OAO1dE52TXrSTom/YWnSBgf9q7Z0zMbq6JA27Y+jW+di4qWmRx+Npw4UKInf+0JB8
	 unqXoIL2bWHQnwk91stcfE4smb8zqOv1K6q5JqU6n3zcU2DwyVXeYXQaLh6mair9jb
	 vMqJnUUpDPaLvK/cJMhngyc9E6lxS+ipe4y4lyQO+yGU5n+4hZ/1jpxNXwWi0dZ1Pg
	 RGlL++0YCmRB0EYEyjIIDqvD/g3H/hfeIwL//t8Gnkag+vuPBKW1AtjX+LJhClCFsk
	 LYiXRMxaNKAGyjug6Z84d+BNBEI5C1AA0nl20v3aqQ9LF/gpQRTAI9PV8FwoGrvbrR
	 SRFf72DQHDMdA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.13 18/21] smb: client: fix noisy when tree connecting to DFS interlink targets
Date: Mon, 10 Feb 2025 20:29:51 -0500
Message-Id: <20250211012954.4096433-18-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250211012954.4096433-1-sashal@kernel.org>
References: <20250211012954.4096433-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.13.2
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 773dc23ff81838b6f74d7fabba5a441cc6a93982 ]

When the client attempts to tree connect to a domain-based DFS
namespace from a DFS interlink target, the server will return
STATUS_BAD_NETWORK_NAME and the following will appear on dmesg:

	CIFS: VFS:  BAD_NETWORK_NAME: \\dom\dfs

Since a DFS share might contain several DFS interlinks and they expire
after 10 minutes, the above message might end up being flooded on
dmesg when mounting or accessing them.

Print this only once per share.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 0577556f0a411..87bc8164c966c 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2169,7 +2169,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 
 tcon_error_exit:
 	if (rsp && rsp->hdr.Status == STATUS_BAD_NETWORK_NAME)
-		cifs_tcon_dbg(VFS, "BAD_NETWORK_NAME: %s\n", tree);
+		cifs_dbg(VFS | ONCE, "BAD_NETWORK_NAME: %s\n", tree);
 	goto tcon_exit;
 }
 
-- 
2.39.5

