Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360F239EF01
	for <linux-cifs@vger.kernel.org>; Mon, 31 Aug 2026 10:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788172926; cv=none; b=nHNZJFwpvLr6EeLQ+Q50/Uh7DmzAHti+9v5dHn5rrO7NK8WqsAo2/0/d4N9zQu7/SItx7rRYAvRyPtiOvNsAFP+5iKdpAaCIBRCJeIeRhBVMu7hzlFQ6Un1ZazXf5wh5ILYLi+Cu+BzKw18WN9fjeRCkqTzlEMRuKQnw8+j+wqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788172926; c=relaxed/simple;
	bh=8icP9WG27EnA3guwU6Qpyr6VBak6eVNtoKGJQ5SQBkk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rlZ63xT832xs7dnqoi6igLVZ97aj/nF1SK9M9D3P3bh64CnLBNXj7i2MaheLN+A6iUeXYYHAPcA7zGdI82Y4BTQbciOAxIhVCC0BvNs3FaFdNPDk4KK42qYFJwrzpBPYQN1CmmCTrZPowcbmXkj1I2SNqmgpVCR3kJvP8O3jzAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gn7hD0i2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gn7hD0i2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CE81F000E9;
	Mon, 31 Aug 2026 10:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788172924;
	bh=bEf46ZZN9NOZUW4G/0DU/dAOKgYfdU5C/gM2UbWhL1M=;
	h=From:To:Cc:Subject:Date;
	b=Gn7hD0i2bb454caA23uxD2s5jnSEl408OydKI35+vksvST2Pj4MSNWD6ELLxzrdIt
	 SdT31Zu1OM0w1DdFV62rZRZqx6Eo++jDZNDd6FOy9VbepMaW/WEBNDYaZ89IDlHrBt
	 0VXmQN8d6f9MKSgB9oHz+WOZIjxSwZSJ/t7ystnkwX3khEc92QrUlr+BUihZyfNz78
	 KeeurmcY7KvyRWkG4oHlfdxbIv6tlJiubG7xYhklDO8p/O1+aghOAMK1Rruu1jU7qC
	 NKVaZ/4Renafse0lk0KEGfeUG25QHk45Yqr/BVw/OMMMc3AbAtQVJYpRjYiBpF4UEg
	 7GaSdri+nQVQw==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: doc: update feature status
Date: Mon, 31 Aug 2026 19:41:45 +0900
Message-Id: <20260831104145.9012-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add MSDFS, Continuous Availability (CA), and AD/DC to the ksmbd feature
status list, along with resilient handle. Mark Continuous Availability,
AD/DC, persistent handle, and SMB2 notify as under development.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 Documentation/filesystems/smb/ksmbd.rst | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/smb/ksmbd.rst b/Documentation/filesystems/smb/ksmbd.rst
index 2425f321f5b7..728cfca13205 100644
--- a/Documentation/filesystems/smb/ksmbd.rst
+++ b/Documentation/filesystems/smb/ksmbd.rst
@@ -85,6 +85,9 @@ SMB direct(RDMA)               Supported.
 SMB3 Multi-channel             Supported.
 Receive Side Scaling mode      Supported.
 SMB3.1.1 POSIX extension       Supported.
+MSDFS                          Planned for future.
+Continuous Availability (CA)   Under development.
+AD/DC                          Under development.
 ACLs                           Partially Supported. only DACLs available, SACLs
                                (auditing) is planned for the future. For
                                ownership (SIDs) ksmbd generates random subauth
@@ -97,8 +100,9 @@ ACLs                           Partially Supported. only DACLs available, SACLs
                                member.
 Kerberos                       Supported.
 Durable handle v1,v2           Supported.
-Persistent handle              Planned for future.
-SMB2 notify                    Planned for future.
+Persistent handle              Under development.
+Resilient handle               Planned for future.
+SMB2 notify                    Under development.
 Sparse file support            Supported.
 DCE/RPC support                Partially Supported. a few calls(NetShareEnumAll,
                                NetServerGetInfo, SAMR, LSARPC) that are needed
-- 
2.25.1

