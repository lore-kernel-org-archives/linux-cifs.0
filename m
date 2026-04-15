Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06B9347FD0
	for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 10:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776248671; cv=none; b=kmZjwraCap1NV9w9Ir8808i5BZXiJizoYoE1ixQHO6thlie3OKOgRh0pr5VpXGPZdW8bsvgG1JordTt2AXV/Uc4Ozpn9+2zMa8v6+gb5vbWxoSyONILuhD72JO+IpwEoaoGrWC6lV8ImqJoXb3FiZv1HWZdlCAsPD4z2GY8Xi1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776248671; c=relaxed/simple;
	bh=jH3b89mCokoUYUcVzMlEhhYbB68wNmb556Lzxqa10t4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=u/vh6y8jh5UvYGtlZJaU0dn3TEWc8PSNHDFkaQ8REiin/aCHbjzDiJnwpckrQNCJttfcrPwCl4XiDhJLBJC3R3kFgSkPmSbto4tVWfxGAfKhvl2BX7qjuUtE4bP8v1oQ69IcvSvOyt4QT6tAZwjM0X+6xH/P/0c3Fr/jCyGMUro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CIsaO4x4; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CIsaO4x4"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35d9c7bf9a1so5859693a91.3
        for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 03:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776248669; x=1776853469; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nTKvDguA58XG3+7VXpkLC36Tot2TubEN1Y93bDE5iL8=;
        b=CIsaO4x4bh0QQuhGYU9WlgTz634bdEO+mbRmT761rs0+QJWVmTU+CKyuIWEQ0Yf76V
         yUNtRqfIWzCpbjtLJQ87Hv9eEaA7JLmFSxT28VtNlXiErLRKCnVp4i6whFwLyy1sSjSl
         2+nng1WbJiGC+8eUKKxu2CMcf1QY/6I3qIEzhHSkF+xGhjXKEzUDOf2j9PPE9lScFwN9
         2s3DpXx+ZwcYF2+mt6lRFRQUX7i8/QokyChWHv/64VJjenvj4PM5ZPptxm6pmXkxYmb/
         VgtwkNBRk+9ekQTEJYwCfSQ40sunPuQdvq3YNqu0hVPbPf8HZT0sh8UYmNOFLMmoWdMk
         POyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776248669; x=1776853469;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nTKvDguA58XG3+7VXpkLC36Tot2TubEN1Y93bDE5iL8=;
        b=cl4/B8p0Oum/+T2I7IJgavePLF+fpXCer9h5qGqiYYmLQafMZZto3QUCsg5RYazfGx
         BefwgZbPGc7ICG3Nz8cd9ICzqgL38LOEu3JGmTjh0hWMd+6O1fRCHXEeWb5oldtetJcG
         vw5GQ7huUUjY6p3wcbljO9eGxq+UZgRqqG4bQ8AY7FGSnIZLLlqRaWWJKutzNpMW8K5F
         ZAe6hTdTf1sCOphR8YDvpVcp+8Aqfi3lRgSp4ORd2jC7fWb5tn+GArBIMBZxNk9oTVF6
         5HWTbe5ScgbtmPr5cXYbSoOHNEtzA9opLBmhFX9/F5WHOtXJnJr3ZKqTAhm+/daBcvbV
         oNtw==
X-Gm-Message-State: AOJu0YwOiDf9iDQwJB7YFNGXwbA7GNmrpEZ85oEmuXwb1GdqqXOXIHDN
	s3DBYCCISOH7cJwh2Nlv2UdUXHbaHiOxb4RDD1QloG9GJQdhbjHmKpBOP+Xs3A==
X-Gm-Gg: AeBDieuddP4MVkbbKE2wZEIpECq7qvoN1mLUUgRTc8vy2uLfETaXw4b/tmoCRyiK5x4
	jD0u9hToPdQQNStufbGpO3/Ez37KF2tdmGVgt4Ynlxj0AilMS/WMhhJQsR7uQjl6xTsMdxBZeO1
	hxKCQOWYTyTIEXq7yN3NhqrLKXH4OecI+evybDyANAc4Y0GULAWUWLiq4sKQ1skD3whn+wv0yEm
	ZUcknGnKnIM/GjGnhGC/OkkARICZhj9O/4uGeCqcX8w4mDxqNtQ2nvguITJE2eKtXgInGsdZxCn
	MDs9xFavxxVNy7v4qVdGi6n0I0fixR2gD1nh3DwSZNVlKOW8ExqmGN2/P5Zs9Cmei0yyrAaKmJ2
	M28egcxRESlMyCtVyZ+E8EFCOyhRWdZAOWYZvK7Q09w46CuRrNOhpJ6lXRinZ8Cs1Wx7sXxFDB4
	dRTu65CG0R8sgNT/cLkDEHsKvRlEk+KcvThsf5QslffuREKESsO3ZeOeQjG1FvbXsh3b06c5O7Y
	/Veru6OqvbH/e0qjWY=
X-Received: by 2002:a17:90b:3e4e:b0:35f:b870:9c9f with SMTP id 98e67ed59e1d1-35fb870a006mr11349389a91.12.1776248669204;
        Wed, 15 Apr 2026 03:24:29 -0700 (PDT)
Received: from localhost.localdomain (69-172-89-235.static.imsbiz.com. [69.172.89.235])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35fd308cf98sm1589444a91.7.2026.04.15.03.24.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Apr 2026 03:24:28 -0700 (PDT)
From: Dudu Lu <phx0fer@gmail.com>
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Dudu Lu <phx0fer@gmail.com>
Subject: [PATCH v2] smb: client: fix integer underflow in receive_encrypted_read()
Date: Wed, 15 Apr 2026 18:24:24 +0800
Message-Id: <20260415102424.65161-1-phx0fer@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In receive_encrypted_read(), the length of data to read from the socket
is computed as:

  len = le32_to_cpu(tr_hdr->OriginalMessageSize) -
        server->vals->read_rsp_size;

OriginalMessageSize comes from the server's transform header and is
untrusted. If a malicious server sends a value smaller than
read_rsp_size, the unsigned subtraction wraps to a very large value
(~4GB). This value is then passed to netfs_alloc_folioq_buffer() and
cifs_read_iter_from_socket(), causing either a massive allocation
attempt that fails with -ENOMEM (DoS), or under extreme memory
pressure, potential heap corruption.

Fix by adding a check that OriginalMessageSize is at least
read_rsp_size before the subtraction. On failure, jump to
discard_data to drain the remaining PDU from the socket, preventing
desync of subsequent reads on the connection.

Signed-off-by: Dudu Lu <phx0fer@gmail.com>
---
 fs/smb/client/smb2ops.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 509fcea28a42..a2105f4b54db 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4943,6 +4943,14 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 		goto free_dw;
 	server->total_read += rc;
 
+	if (le32_to_cpu(tr_hdr->OriginalMessageSize) <
+	    server->vals->read_rsp_size) {
+		cifs_server_dbg(VFS, "OriginalMessageSize %u too small for read response (%zu)\n",
+			le32_to_cpu(tr_hdr->OriginalMessageSize),
+			server->vals->read_rsp_size);
+		rc = -EINVAL;
+		goto discard_data;
+	}
 	len = le32_to_cpu(tr_hdr->OriginalMessageSize) -
 		server->vals->read_rsp_size;
 	dw->len = len;
-- 
2.39.3 (Apple Git-145)

