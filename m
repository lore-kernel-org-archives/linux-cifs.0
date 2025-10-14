Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3451C4A17;
	Tue, 14 Oct 2025 23:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760483916; cv=none; b=SwyMnHd6XhbHx87YLkBsPRT0vybVEacLe6qiEswAoQcnYqEo3Oa13wdvR/rZQzNfSkkIurevIU70GLPipDW6JSh5ra5tO6ioXVwe/QNMP+Autt3f2l2OYT1vHtUCc7Tqx6/g/406k0wbtpKn31jUuaPG58LqWyOjkur7DuSfMkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760483916; c=relaxed/simple;
	bh=9dPd7vnTrnvE8TgGlLDYehVSEf5BmhtBRwAAceBeR6U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sfp2GAF4xIGCrbfR4SLGfOjutB6ycqWKdq+s5M/GqdPZowJTDHq8q3EoeV/RH7dXvurvG5BAUvEJMAC3yL4BbG9u6NS/Yl95xrBtb9DPe7uoIaw8b6/K5Odo2ESw9y/py8N60oZc1ToVQGeRmAdnxcZrfn+mU3WG1BI7AkT6JHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mgH56kQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mgH56kQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710EFC4CEE7;
	Tue, 14 Oct 2025 23:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760483915;
	bh=9dPd7vnTrnvE8TgGlLDYehVSEf5BmhtBRwAAceBeR6U=;
	h=From:To:Cc:Subject:Date:From;
	b=mgH56kQebX5kSBdJpOwaEEF3MHVv7bu++hujl8oFACeJJrQPd9Y2+xWV6KY5CKvw1
	 8Q7QUrL4KKW3tdSLVIFbjPmloJmN5jwuXUkKyttmOqECF/2IR+g4QTj74Clvn6c/up
	 U0xHW3BZc6Le9n4n3i0AfpQUbi7v1eLXxnzheB3fo6vVo3S9I6KB1IvgLCJU8Dx0pX
	 tEz0DXY+dkphQ6SVvOMMUBxq5mn9ELw95U4tFiMWGaDWkxGxQMP57Lk9jOGCyOv9nZ
	 v+K+HnytATuR3Wpz7kD9IZs29RZJFMSX4qIlOncc29y+yg0RiJp1flcLon+aGarp6O
	 uD2sJrL1J0uCQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-cifs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/3] ksmbd: More crypto library conversions
Date: Tue, 14 Oct 2025 16:17:56 -0700
Message-ID: <20251014231759.136630-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series converts fs/smb/server/ to access SHA-512, HMAC-SHA256, and
HMAC-MD5 using the library APIs instead of crypto_shash.

This simplifies the code significantly.  It also slightly improves
performance, as it eliminates unnecessary overhead.  I haven't done
server-specific benchmarks, but you can get an idea of what to expect by
looking at the numbers I gave for the similar client-side series:
https://lore.kernel.org/linux-cifs/20251014034230.GC2763@sol/

No change in behavior intended.  All the crypto computations should be
the same as before.  I haven't tested this series (I did test the
similar client-side series), but everything should still work.

Eric Biggers (3):
  ksmbd: Use SHA-512 library for SMB3.1.1 preauth hash
  ksmbd: Use HMAC-SHA256 library for message signing and key generation
  ksmbd: Use HMAC-MD5 library for NTLMv2

 fs/smb/server/Kconfig      |   6 +-
 fs/smb/server/auth.c       | 390 +++++++------------------------------
 fs/smb/server/auth.h       |  10 +-
 fs/smb/server/crypto_ctx.c |  24 ---
 fs/smb/server/crypto_ctx.h |  15 +-
 fs/smb/server/server.c     |   4 -
 fs/smb/server/smb2pdu.c    |  26 +--
 fs/smb/server/smb_common.h |   2 +-
 8 files changed, 87 insertions(+), 390 deletions(-)


base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
-- 
2.51.0

