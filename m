Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1954236E47A
	for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 11:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787571870; cv=none; b=g+DG4C2Xx8cJMQR3OsMFb40/UfTmULBSxzA7SvhPAIMIt/rQK3z+/yLA3gn4etYAyBeg2gR+eL+bG3D+uAetZV5PxjSEZpvGCB6N2CDMNxg2+F/J+qF6wV2vNfbBHrU0GVewB5lrzJzTA8ddIXGhYKJAj9ZvwsUkgCxMMInx0IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787571870; c=relaxed/simple;
	bh=X/6xDcPr1Xrbx3DMnriRQU3BhbE5V+2GR4/ng2IxyjE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FEBAV5KfUiPwA2UzjU96fA4Y6BTwqJ+dNGN6jM+eIA01++tSo7d8e01l32xiMlrU/joDlvYJTLVm0Hjb87qECseeEs+10LcgMjBIG2hqyB1w72C9sYIMaiuFy6Je+ELtYYREdO9vINFbV8kmTXZ+89dwFunapBCbVUS5V4qWfRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PBmADvkA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PBmADvkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EA61F00A3A;
	Mon, 24 Aug 2026 11:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787571868;
	bh=4MOFgeujtsWwD9vdJGiTSzDIN2jYycfwvStjb4efY+I=;
	h=From:To:Cc:Subject:Date;
	b=PBmADvkAjI2nMnsOugvNhyck9wH/cC/7sa16g0ozG6I8ACllvOXc92BtZaCe2QQqp
	 jtk3NXabDsxTFiQQCJE6+6pmx3Exke0mTNbskIlAHugYXLZloX81KTcEgw5lsmZ7Py
	 56KcLEY5KMjzgSXCsAPRBR0BL3JSOWJowf+ld4yki6bxAgW0mchA4C+DVg6RTys0TN
	 awL5v73wrwQxG/ja2mPBh20gZfJuJLhOCoPe4jfGXTOd4EWi7erwgtOZw+xlMFN2fY
	 jVinN/7ydKamJpobHliAELP2qiEbtESlb4/gx5DDcSfOkvh6b4y/CcXrZw0HX7nV/2
	 MDXc9lwqgkFYA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/2] ksmbd: doc: update SMB3 multichannel support status
Date: Mon, 24 Aug 2026 20:44:04 +0900
Message-Id: <20260824114405.8108-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SMB3 request replay support is now available. Update the ksmbd
documentation to reflect that SMB3 multichannel is supported.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 Documentation/filesystems/smb/ksmbd.rst | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/filesystems/smb/ksmbd.rst b/Documentation/filesystems/smb/ksmbd.rst
index 672c5d3892ff..050af25d5339 100644
--- a/Documentation/filesystems/smb/ksmbd.rst
+++ b/Documentation/filesystems/smb/ksmbd.rst
@@ -82,8 +82,7 @@ Signing Update                 Supported.
 Pre-authentication integrity   Supported.
 SMB3 encryption(CCM, GCM)      Supported. (CCM/GCM128 and CCM/GCM256 supported)
 SMB direct(RDMA)               Supported.
-SMB3 Multi-channel             Partially Supported. Planned to implement
-                               replay/retry mechanisms for future.
+SMB3 Multi-channel             Supported.
 Receive Side Scaling mode      Supported.
 SMB3.1.1 POSIX extension       Supported.
 ACLs                           Partially Supported. only DACLs available, SACLs
-- 
2.25.1

