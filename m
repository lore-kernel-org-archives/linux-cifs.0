Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9030624BFBD;
	Wed, 11 Dec 2024 18:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733943207; cv=none; b=CZFzwPsYaT+cpzcuEWsks8gitiTZIo97xL1ijr+4A+3YGXomW3Z6eqN/4B2ZCT4XTTP1HPpqKTRZTWvpyqdATWtSoU5uN5HGo3sCL6w+WClgHlvEX1tyIl74fw1wn+IZAfUkwwk5WfDQqAdlvkMsBQ5BjRdzVTn4AHNW7m8Z83k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733943207; c=relaxed/simple;
	bh=gtfK1xE7XlmwD1ug30T5tBRF9vPEHtlcID7wOpXqfZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDyDGJEXtxTT07Q7jMBoJYbrXK41AxVJqEGd1/ETUK/6S9BhA51CKfMyUsuFJV4KKlcndHHIuTG47AYg9aHDQjMhvfwTMykd+ex9ATTvp9NjoGDNMzsLyYnqP3pFiQCCnGfUu6t/uY3Yie6J+avIq3fx9gleQfnRkHHdMMHAfFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cBO3nAW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cBO3nAW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F548C4CEDE;
	Wed, 11 Dec 2024 18:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733943207;
	bh=gtfK1xE7XlmwD1ug30T5tBRF9vPEHtlcID7wOpXqfZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBO3nAW+2yFi68xKOylYHGSvBTqVT94bXfSDQAFTLUjLYFua4PjOKbY50RcznFN0S
	 WMG5YjPHBvgJ5Xnyqz+Nn31B4IlwJrIilA18pBYcbFOdorWhGz2HDs1uPeNi9lDPfx
	 eqdWKsMDilIy+W1gphlJ/wJF/iQHPgB2q189rMDNPh/bSUVs7e42Jkb9rKjJOLqRko
	 VNr64FEGnoe43m9+v2kgVZc7QqiPdcXRrQtLP9NiU2VxOsk+3QQCVQ8vJ016J4jKWB
	 g/OtIE4qV4jY31kHRfoj8hY5iP9cCRtX6v2i5FcNGNGy9MN5xKTaDs02i1S14/qN1S
	 Fj7JO4C1whT/w==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Brahmajit Das <brahmajit.xyz@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 05/15] smb: server: Fix building with GCC 15
Date: Wed, 11 Dec 2024 13:52:57 -0500
Message-ID: <20241211185316.3842543-5-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241211185316.3842543-1-sashal@kernel.org>
References: <20241211185316.3842543-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.119
Content-Transfer-Encoding: 8bit

From: Brahmajit Das <brahmajit.xyz@gmail.com>

[ Upstream commit e18655cf35a5958fbf4ae9ca3ebf28871a3a1801 ]

GCC 15 introduces -Werror=unterminated-string-initialization by default,
this results in the following build error

fs/smb/server/smb_common.c:21:35: error: initializer-string for array of 'char' is too long [-Werror=unterminated-string-ini
tialization]
   21 | static const char basechars[43] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

To this we are replacing char basechars[43] with a character pointer
and then using strlen to get the length.

Signed-off-by: Brahmajit Das <brahmajit.xyz@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index bdcdc0fc9cad5..7134abeeb53ec 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -18,8 +18,8 @@
 #include "mgmt/share_config.h"
 
 /*for shortname implementation */
-static const char basechars[43] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
-#define MANGLE_BASE (sizeof(basechars) / sizeof(char) - 1)
+static const char *basechars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
+#define MANGLE_BASE (strlen(basechars) - 1)
 #define MAGIC_CHAR '~'
 #define PERIOD '.'
 #define mangle(V) ((char)(basechars[(V) % MANGLE_BASE]))
-- 
2.43.0

