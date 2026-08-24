Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B43C3F20E3
	for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 11:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787571873; cv=none; b=F/MRbr+9/sXkMIkCvCRbWJCZKp8GLwLoWgKaugQhkTt1gmIm87sBYjsoun3GG0iWhULfZpVjSc8nRCqkKXGfmMQ7AVjNIRumZgXUc3tNOfuoUart+vQxU9FU1USRgegbX+KKt9S1cUKauZY4TBwa1QD0ShIKYzFnvD6XEx1s9r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787571873; c=relaxed/simple;
	bh=SpIjj+fVSRH4jL4dGTGKHzATm3UevBUVzUc7+hO6Vrg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tswP47J1JzXkE2K0O0NhDIchgrdwGLr+vNTD58rV4MWBvpcuPO99omvdbYQSiq5vjqk3j8n+yn9dYEs1phuLFxf8FS3u32aKd+bqGjg7D2X8Nitnr6oTPagJgqJ++6/WThjs/pvvU9SqlPMcNWZsI/okrHqfcpCD2WIoPyJobzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bfw0ryst; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bfw0ryst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7531F00A3D;
	Mon, 24 Aug 2026 11:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787571871;
	bh=a7pniBc0r28M/Hqe7ZPsiSYj9OCpRZykOoAKlvgJ7Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bfw0rysttFlsKXhhWGQrw0T3Vjx1pIyMNdAymlqlKZW5zqgs/vWrwQorQYEUJmv7z
	 6S7twTsX6iDVaHdbbaYtfCGtuLJ5ooT+wdALA1NTOJICGFz2NvV+nvBv5Rzrru3AC7
	 Z1+cqKrl3j6nL9/gG7neJQ/j3R8F3mAzUQwfoqAEEjRyBwgpzyoO+8GdzHME4Lek3g
	 imMkpDkDgqrR7RvG6BqGH03nUYmIsIUCBanF2F9CuLYTQPlcI9CXFIkcGjpNohArn6
	 5+O+K8c731vZxPlBw8OqrS3WLGXkN9eVwcP92/jbOonhr89YoyOMhg0VxDXZs2j58S
	 B3ZonIzwR4Mpw==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/2] ksmbd: doc: update RDMA feature support status
Date: Mon, 24 Aug 2026 20:44:05 +0900
Message-Id: <20260824114405.8108-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260824114405.8108-1-linkinjeon@kernel.org>
References: <20260824114405.8108-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd supports SMB3 encryption over RDMA, while signing over RDMA is
still under development. Update the feature status table accordingly.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 Documentation/filesystems/smb/ksmbd.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/smb/ksmbd.rst b/Documentation/filesystems/smb/ksmbd.rst
index 050af25d5339..2425f321f5b7 100644
--- a/Documentation/filesystems/smb/ksmbd.rst
+++ b/Documentation/filesystems/smb/ksmbd.rst
@@ -112,7 +112,8 @@ ksmbd/nfsd interoperability    Planned for future. The features that ksmbd
                                support are Leases, Notify, ACLs and Share modes.
 SMB3.1.1 Compression           Supported.
 SMB3.1.1 over QUIC             Planned for future.
-Signing/Encryption over RDMA   Planned for future.
+Signing over RDMA              Under development.
+Encryption over RDMA           Supported.
 SMB3.1.1 GMAC signing support  Planned for future.
 ============================== =================================================
 
-- 
2.25.1

