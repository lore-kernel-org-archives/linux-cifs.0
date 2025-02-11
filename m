Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6F01FAC5D;
	Tue, 11 Feb 2025 01:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739237519; cv=none; b=fYrNpIHuOZPd65HO2FIgQ5GhT3XHh5I/WUmfv0Bau4SQzNhMIo8//znUt4EBe2edanjOZJOeQALkuJVNu5S/RxlmP3P4mSd8ruIObhtssMJzNuiSylcYPky6XWvPUPK1ZHxPsYaR5m/Gg1s21KizJeZvMFwydbCLwdha/qLme/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739237519; c=relaxed/simple;
	bh=BgDpwLWq32mFdpzZrEti+vs+keRXv1yB+qke5D5Khjc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ULR15xATvYLwyQVx0xw7+gEpPb0cO64cQ5vJjrKAmVwhyU3GIf66oG9KP8qEqsAclya8VPwHY9NfDrwEU5cEuXNs7qiloOnQufaLgdaKXQKKqLW9P2MRf4ZGik9+enNe2pOTBllONQpc3Q+kZEgCw5TGcPatInO2EKo8PZKuXzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ij/+5j6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ij/+5j6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5782C4CEE5;
	Tue, 11 Feb 2025 01:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739237519;
	bh=BgDpwLWq32mFdpzZrEti+vs+keRXv1yB+qke5D5Khjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ij/+5j6tklcDffZ4kE1HNRpap+slQmyFKEYnx+4NaONLOwxCfasFN2yVM+HvtgKR0
	 lcrZPclVPUNohN5uiTxjqIY9AYBQu9v3OrXnLQeAKocU6Vh1atrqAmcw58d5WIvdGz
	 tzQA6elKpiNNkBokR4mbEyJylOFhkxO1kb35qWfeas0J3s3ookZfnGO4cTDYqSdBAO
	 aPG7kWaAkualrAM+YtuR+xEda0hiV5rSrfv5HMQ5XTMS3vetk5wgBPbwzppBdzV6Vl
	 x7j8U1iPVcpwSF/c/iZeWongmbBsdm6PSNtAXF7ceHOVvueHOiFNkz5CnbI5rYQYRh
	 QZIwYTVm/k6Pw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.6 13/15] smb: client: fix noisy when tree connecting to DFS interlink targets
Date: Mon, 10 Feb 2025 20:31:33 -0500
Message-Id: <20250211013136.4098219-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250211013136.4098219-1-sashal@kernel.org>
References: <20250211013136.4098219-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.76
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
index c012fbc2638ed..a7b01c8bd9af1 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2162,7 +2162,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 
 tcon_error_exit:
 	if (rsp && rsp->hdr.Status == STATUS_BAD_NETWORK_NAME)
-		cifs_tcon_dbg(VFS, "BAD_NETWORK_NAME: %s\n", tree);
+		cifs_dbg(VFS | ONCE, "BAD_NETWORK_NAME: %s\n", tree);
 	goto tcon_exit;
 }
 
-- 
2.39.5

