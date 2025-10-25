Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81618304BDD;
	Sat, 25 Oct 2025 16:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408796; cv=none; b=pA3VtbD+Nkf8EsCwKFam2XUoyMrTHFzuFVmhoUdAbuvoN9dwFeZPkh6Kwv/uGJmmWsKer8FGvICOYBvju2zhkZhTUbxzY171SkbbTcoXXn3zLZveAcUU62LVaLhdBn5EoEU8fDITlusDPKhrpkEyF4uitO9JnE2L5MAFKJX7cHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408796; c=relaxed/simple;
	bh=10OYArm44jdBF2hV8i8tYIoiUjvjLsrQPQkWq8YYgyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DoRhs/Gv8nAM1g94o0SwRrOg8+KIR7T8vharbR4VyRtSSD7oKfdrEXpD7x6RDyWzWq0YDtqfKrIG4q3zwstazoonJRdzgALRLGdh3tZ6OEp0J8ksL9Gq+w1YuuYSa367x9AW/EmYvjdQvei1yLwvSAcpZoHw2IwNBHZOcisZ33Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=io39PaVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="io39PaVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AE7C4CEFB;
	Sat, 25 Oct 2025 16:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408796;
	bh=10OYArm44jdBF2hV8i8tYIoiUjvjLsrQPQkWq8YYgyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=io39PaVq8MvAcCLJAUv3DIDw83ly0gbEmqFcDFn7YGTmnAfZ614DgqOjDTpIe0kaN
	 O/ce4meTCGZdHKAnZz1WXjJiF7EErxOWQkkHamcyuf+PzFgvj06+9NhumgPQ+WxjB1
	 GvlRJymxT7UULeYOLh0SeB9hVrQwRe+Svo0h89HOMgcAcack5bxvCKN0dbglfxRbPz
	 jiMLQHtQaD99yzMJvgVbz0VGnlChxMPWKXSPzpg0IUqK1ac5LEL8G4bVAGY6hETWVC
	 3B2yw3FpJQIK3OvYv4a/xMVFP2eTXi8zm7xiYpLl5RkutZ9LInqGuhcGS4t9H6Ejki
	 AytCVXkEJdkBg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.1] ksmbd: use sock_create_kern interface to create kernel socket
Date: Sat, 25 Oct 2025 11:55:06 -0400
Message-ID: <20251025160905.3857885-75-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 3677ca67b9791481af16d86e47c3c7d1f2442f95 ]

we should use sock_create_kern() if the socket resides in kernel space.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – ksmbd now creates its listening sockets with `sock_create_kern()`,
so the socket is marked as a kernel socket and bypasses LSM policy
checks that would otherwise block the listener.
- `fs/smb/server/transport_tcp.c:474-505` replaces both IPv6 and IPv4
  calls to `sock_create()` with
  `sock_create_kern(current->nsproxy->net_ns, …)`, ensuring
  `__sock_create()` runs with `kern=1` (`net/socket.c:1661-1682`).
- When `kern` stays 0 (old code) LSMs such as SELinux and AppArmor
  enforce their policy hooks, which often deny kernel threads from
  opening INET stream sockets (`security/selinux/hooks.c:4797-4839`,
  `security/apparmor/lsm.c:1261-1301`). That failure bubbles back to
  `create_socket()` and leaves the ksmbd interface unconfigured
  (`fs/smb/server/transport_tcp.c:474-519`), so the server never starts
  listening.
- The change aligns ksmbd with other kernel networking users (e.g., the
  SMB client already calls `sock_create_kern()` in
  `fs/smb/client/connect.c:3366-3374`) and introduces no behavioral or
  API risk beyond correctly flagging the socket as kernel-owned.

Given that this fixes a real service outage on systems with enforcing
LSM policies, is tightly scoped, and carries minimal regression risk, it
is a strong candidate for stable backporting. Suggested verification:
bring up ksmbd under SELinux/AppArmor enforcing and confirm the listener
binds successfully.

 fs/smb/server/transport_tcp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 1009cb324fd51..43401d09c9db4 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -473,12 +473,13 @@ static int create_socket(struct interface *iface)
 	struct socket *ksmbd_socket;
 	bool ipv4 = false;
 
-	ret = sock_create(PF_INET6, SOCK_STREAM, IPPROTO_TCP, &ksmbd_socket);
+	ret = sock_create_kern(current->nsproxy->net_ns, PF_INET6, SOCK_STREAM,
+			IPPROTO_TCP, &ksmbd_socket);
 	if (ret) {
 		if (ret != -EAFNOSUPPORT)
 			pr_err("Can't create socket for ipv6, fallback to ipv4: %d\n", ret);
-		ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP,
-				  &ksmbd_socket);
+		ret = sock_create_kern(current->nsproxy->net_ns, PF_INET,
+				SOCK_STREAM, IPPROTO_TCP, &ksmbd_socket);
 		if (ret) {
 			pr_err("Can't create socket for ipv4: %d\n", ret);
 			goto out_clear;
-- 
2.51.0

