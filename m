Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7B034BA5A;
	Sun, 12 Oct 2025 01:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760234385; cv=none; b=jBYsLc9UotzWcr+xskd85p1tLiiYrEf2l1oNnKCzmSkn29HKuE34J5WJPAW9quAGr2WtFJ024t2qKEIYurTafEGWu5AoD3MzCqidIZpepl+YVnMFqBW2lbPAxFED6ROKTsbH1kLhYoFGy6QQn7xujgNtVQx0FDnWFAim9pRotlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760234385; c=relaxed/simple;
	bh=7ETdnR/E58SKy2yx2VynIe6Zmmu/sLIOKInJOWa8CJo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JvWSCToS/P35u9L8M+jeBvshVdxdc8fazs3i9HyJ7OTdNT30nLTgCF7O4Exiv3L+grFd//1xIQzcxEFBXwUkJJUr5kMgoyH7ixdYP9p1Hrj7apo4Df6H2duo4gRLxikbGMvUMvQpuJtVZgVSBL0eG2vVStq25cyzoVScMDV9GeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=orp7DiBz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="orp7DiBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E02C4CEF4;
	Sun, 12 Oct 2025 01:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760234384;
	bh=7ETdnR/E58SKy2yx2VynIe6Zmmu/sLIOKInJOWa8CJo=;
	h=From:To:Cc:Subject:Date:From;
	b=orp7DiBzQCjK8jfGnAiJ0OxA/6h8wVNXWZTk4oy8DDRf7hQky7iJocHPYc01dFXeI
	 oF5+q+4191MA+PSvjoLklRDPR2UcSB6EN2dkXBZOa17BC3s2zVjhH+6BrDgzBFJE2F
	 TxOclSWOhBW0K7rjr9lkVURW4jqv234wPMePHWegh8aCEh31w5qf47NSGz/m+GXJ/J
	 S7d+RjVnB4jdH1Yj1GjzvNjdn1L/q/ox7i12AgWdUcNVQPp0SVzdydHtLmt4miUh1U
	 nQgcoQKB4AOVfJfhOYVrf00tu21RsIw4Y+nQ+7N5qFXGjTDd90b9PtKgvryP+8ZPsA
	 ssYM7mG1opbHg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>
Cc: samba-technical@lists.samba.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/8] smb: client: More crypto library conversions
Date: Sat, 11 Oct 2025 18:57:30 -0700
Message-ID: <20251012015738.244315-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series converts fs/smb/client/ to access SHA-512, HMAC-SHA256, MD5,
and HMAC-MD5 using the library APIs instead of crypto_shash.

This simplifies the code significantly.  It also slightly improves
performance, as it eliminates unnecessary overhead.

Tested with Samba with all SMB versions, with mfsymlinks in the mount
options, 'server min protocol = NT1' and 'server signing = required' in
smb.conf, and doing a simple file data and symlink verification test.
That seems to cover all the modified code paths.

However, with SMB 1.0 I get "CIFS: VFS: SMB signature verification
returned error = -13", regardless of whether this series is applied or
not.  Presumably, testing that case requires some other setting I
couldn't find.

Regardless, these are straightforward conversions and all the actual
crypto is exactly the same as before, as far as I can tell.

Eric Biggers (8):
  smb: client: Use SHA-512 library for SMB3.1.1 preauth hash
  smb: client: Use HMAC-SHA256 library for key generation
  smb: client: Use HMAC-SHA256 library for SMB2 signature calculation
  smb: client: Use MD5 library for M-F symlink hashing
  smb: client: Use MD5 library for SMB1 signature calculation
  smb: client: Use HMAC-MD5 library for NTLMv2
  smb: client: Remove obsolete crypto_shash allocations
  smb: client: Consolidate cmac(aes) shash allocation

 fs/smb/client/Kconfig         |   7 +-
 fs/smb/client/cifsencrypt.c   | 201 +++++++++++++---------------------
 fs/smb/client/cifsfs.c        |   4 -
 fs/smb/client/cifsglob.h      |   3 -
 fs/smb/client/cifsproto.h     |  10 +-
 fs/smb/client/link.c          |  31 +-----
 fs/smb/client/sess.c          |   2 +-
 fs/smb/client/smb2misc.c      |  53 ++-------
 fs/smb/client/smb2proto.h     |   8 +-
 fs/smb/client/smb2transport.c | 164 +++++----------------------
 10 files changed, 131 insertions(+), 352 deletions(-)


base-commit: 67029a49db6c1f21106a1b5fcdd0ea234a6e0711
-- 
2.51.0

