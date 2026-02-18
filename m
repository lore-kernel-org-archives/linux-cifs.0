Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23ED314A76;
	Wed, 18 Feb 2026 21:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771450611; cv=none; b=P/5o7hyBeHBA0As4ctVjIvNBv9pH/csJJw6ReMi3nWFBco57oXnPH9QEiZ8m+bH+S7HfcAX99CAyPYBkg0ia4LOKmF03NiESybtCUP/b9UzwdQesmmVitnNt8gvbHvjgjq40G6X67WYxJRWjjfKKN8W1VMFqaFJI+0daSnrvKsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771450611; c=relaxed/simple;
	bh=FLhIcGYigj/cYDh5+twKKz5F+F3mi/gUG7aJ/XLLfTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esQhbKfweICcKC9mY7K9t0lrpnSKw0UjvntadSkvPjA6ZeL4clyKOUtgU1b3hZmYn4o+CdsXY8j/JJyhpSO/lMHpEHB70e4AqF9SsnQZL4zLTogGIFTKWPtw2Keexjwz4t/M6QIUE8JxvFSuYglzCtTrAsZAiJRSI0XaQxofFro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ROUaJ6P8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ROUaJ6P8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3932CC2BC9E;
	Wed, 18 Feb 2026 21:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771450611;
	bh=FLhIcGYigj/cYDh5+twKKz5F+F3mi/gUG7aJ/XLLfTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROUaJ6P8UlCMN4JmpFGGTRSlivUcHoJGRc+eVoE6kP/DW5Y7YMNqs+roqftoa/gnV
	 ZwDlrMQ693KOcLjlRIMUfS1y7sKUTH1zO1nkVWuEMZY2k2/91AidpDrJw9bPtC3dmR
	 5Udw//bK+DsZUsShJM42cHcB/ciYFKBaq2P+7hNLQSW+D7AVPNldf1i7qhy3dpdD7f
	 gLSPjy1VBwRBR4kssZcgjCV6zH7OxxUqehvbY1cjcC50JWrcPh/ob9W6VyJ0qM73EB
	 cdLoS5E4mBCqNz6ShijoHyLhAfTFL7bE0hPtEeWfjDZw/Kdnkwl8XU9BjxHr6DAXvp
	 iH+hy7FYJaUYg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 03/15] crypto: arm64/aes - Fix 32-bit aes_mac_update() arg treated as 64-bit
Date: Wed, 18 Feb 2026 13:34:49 -0800
Message-ID: <20260218213501.136844-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260218213501.136844-1-ebiggers@kernel.org>
References: <20260218213501.136844-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the 'enc_after' argument to neon_aes_mac_update() and
ce_aes_mac_update() has type 'int', it needs to be accessed using the
corresponding 32-bit register, not the 64-bit register.  The upper half
of the corresponding 64-bit register may contain garbage.

Fixes: 4860620da7e5 ("crypto: arm64/aes - add NEON/Crypto Extensions CBCMAC/CMAC/XCBC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm64/crypto/aes-modes.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 0e834a2c062c..e793478f37c1 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -836,11 +836,11 @@ AES_FUNC_START(aes_mac_update)
 	encrypt_block	v0, w2, x1, x7, w8
 	eor		v0.16b, v0.16b, v3.16b
 	encrypt_block	v0, w2, x1, x7, w8
 	eor		v0.16b, v0.16b, v4.16b
 	cmp		w3, wzr
-	csinv		x5, x6, xzr, eq
+	csinv		w5, w6, wzr, eq
 	cbz		w5, .Lmacout
 	encrypt_block	v0, w2, x1, x7, w8
 	st1		{v0.16b}, [x4]			/* return dg */
 	cond_yield	.Lmacout, x7, x8
 	b		.Lmacloop4x
@@ -850,11 +850,11 @@ AES_FUNC_START(aes_mac_update)
 	cbz		w3, .Lmacout
 	ld1		{v1.16b}, [x0], #16		/* get next pt block */
 	eor		v0.16b, v0.16b, v1.16b		/* ..and xor with dg */
 
 	subs		w3, w3, #1
-	csinv		x5, x6, xzr, eq
+	csinv		w5, w6, wzr, eq
 	cbz		w5, .Lmacout
 
 .Lmacenc:
 	encrypt_block	v0, w2, x1, x7, w8
 	b		.Lmacloop
-- 
2.53.0

