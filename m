Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767BE3AF664;
	Mon, 17 Aug 2026 13:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974337; cv=none; b=YGrHLUqfiiCN5vd8pK+wdnkFQsI/1EXwHqMh37Y9tESmSvWKyQj1NkYfvoZiXyjPCDXjnxL7wgK/tMQJmd0bMSyTjblwZxb4ijxsGdZ0KudAgbFWFnD7FjyVHh9qm36rRhT8gBTpV2AHE8vgAJIJNpQ09xhbFodnWW8KbaXEnJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974337; c=relaxed/simple;
	bh=wGOGJefhsJfjiypMq8J7hTs5qGMbw5XFjh0DeFXPFSY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FdO1DhZhZY5HRGqoUVBJTcwcrtewIJ3/jW+CngYSdEQl4StR3FvJ5SJ52DBmt+rdeh5LWx9KAg+ZB4ZkWqKQX8ju29c77NLKHvOzE6E79bZYqyzpYgNQGaQk5+yHYto0daY5mF4o1khJJLIrue+HgGJnXZcX35FGsf12loxrozw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dw57C2gA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dw57C2gA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7721F00A3A;
	Mon, 17 Aug 2026 13:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786974329;
	bh=wflovGVzOB2MGnsu1L4Fyb0bAyKFThrwgG/Ffqzeyx0=;
	h=From:To:Cc:Subject:Date;
	b=dw57C2gALt66zSIqCP7h8WxRZwecnkai++CEfilUQyB2C1z3ynpoiCNKUKgjgJF2Y
	 Jf9wTcxez3sYgp+PvWZNfKJiy1XD0TKxXN42JVFmJcIOe0cEo3qZVQIYgUxxY/4Aor
	 Mm02xjntzCJP60mws+oborgX2A+nrkXkenj/tLXf/0Sg1hqTps+xG132XyoGiPeqn2
	 tJp4weBvLpIlmnoREf91sKFWUZvd9VtQQY2P6+rVg8hdp+9vMRMxjyxHQFqFdEaToe
	 QZfiQtbyjIcEUgD4stJXo1xqVqwMPYptPFIYngQ/fdD7nW3jB7JqF8sSG7IiI5/jEd
	 1DFZK3T+kZrdg==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: smfrench@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] MAINTAINERS: update ksmbd repository URL
Date: Mon, 17 Aug 2026 22:45:21 +0900
Message-Id: <20260817134521.5505-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the ksmbd repository URL to the kernel.org
ksmbd-for-next branch.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8014b9f8253e..438e3a714c4c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14140,7 +14140,7 @@ R:	Sergey Senozhatsky <senozhatsky@chromium.org>
 R:	Tom Talpey <tom@talpey.com>
 L:	linux-cifs@vger.kernel.org
 S:	Maintained
-T:	git https://git.samba.org/ksmbd.git ksmbd-for-next
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git ksmbd-for-next
 F:	Documentation/filesystems/smb/ksmbd.rst
 F:	fs/smb/common/
 F:	fs/smb/server/
-- 
2.25.1

