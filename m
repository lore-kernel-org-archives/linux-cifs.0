Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053574;
	b=4lNavdXG4YL8hfYPlm5mRYPNGlPeit24/UQmNMbYnqoAQlE83lI+sqVqubeJScUL2ZYd
	 vcir+jHe+NgFGlx1ijmQxSEWas2VWKwDJMNr6+7pnh06jtaLxiWZ8EZPpZRqj8l8cCCub
	 JP2Az7yZqfcWkVVyXTONVs1HJibpz2W4iln9yWXRdb6Zjzgnliy3lODhNyycAEMTtkXkG
	 hbbeM90J9PMEf8uxjrhibPdmCNWO71O7E2P64V+FwnyQoj3HyBGDMnurvNVEMsmFMK9hE
	 kimrW+xt0F/VWJ37aIuxZd1mWzHicrG0jAc+afi2k8OOft2CF6HkxVBe9Rq2ueWuq7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053574;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=hRa68r0pq9cIISa8YB5TljrVWouR8wTE77Or8q+kXGk=;
	b=5Lmr7PGWDAqkZhkSi+ascijtR5qtL8v8HRvqV/SH91EVwawIewDDGlghpouDNzqIGhTa
	 47xnuS9Kqxpyb20TEf2z5d4TftEkdK537NWMvamURycrVUGXtZEN9azYigz64u3sQ7G9Z
	 JhufPkw9tSX4eO5qPN47e8gVmynV5FlyL59JK9NtRkYsiRdNNUlFqFM4kp5FL7Qk2pio6
	 zDGypPFFRGV6B0Bv+seJfGYG3trDsjVKCuuxo7I5A3eYTiGPq8BBDo/QNAjRCLMDFEg37
	 bGGrQXJeGdzJgkidaiEl+XW7CXC67SuC3yin3avRJHU8CG9J2qb9LXWbPYESqFOb4DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BN9zV+rg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E5F606A324;
	Mon, 26 Oct 2026 22:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BN9zV+rg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A271F031E1;
	Mon, 26 Oct 2026 22:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793053573;
	bh=hRa68r0pq9cIISa8YB5TljrVWouR8wTE77Or8q+kXGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BN9zV+rgo/pesHSx/f9hXdwHcGCzEq+aSkA8rvjzGFSRPC0mKfNgl5XKoIrLrbETz
	 MBrohZ1IGxTiJu0oYy14ORbifTKuyQl6aBo4aS5VDgoa35CI5C8q35loWrXDoO7VnZ
	 L6ws5JkbDreDIHkeXfMXOhVhZGtO205j+1Vw4i08isLkPJ1Kd6pYYUfWLDXjddG6A/
	 Efk8V5p6XnLWSu5y1tTNgSavnSwIwecV6Z7GnivgAy/HkTX5uZE+fiBJyik6hG+r7D
	 R+PG2ABgoJNss2pSZcNA25hpnMUF+IN7nHC76HU1nvmq2OeWJP/X5eU3wVMJftLj0k
	 5RPFd/Zr/DcIw==
Received: by pali.im (Postfix)
	id 603D8F4F; Mon, 26 Oct 2026 23:26:10 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7.3 5/9] cifs: Check if server supports EAs before trying to set it for WSL
Date: Mon, 26 Oct 2026 23:25:56 +0100
Message-Id: <20261026222600.17323-6-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261026222600.17323-1-pali@kernel.org>
References: <20261026222600.17323-1-pali@kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

WSL special files store information into EAs. When EAs are not supported
on the server filesystem then fast fail in mknod_wsl() function.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 577cdf49c047..86eb56dbc81a 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -693,6 +693,13 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
 	struct kvec reparse_iov, xattr_iov;
 	int rc;
 
+	/*
+	 * WSL special files store information into EAs. When EAs are not
+	 * supported on the server filesystem then fast fail.
+	 */
+	if (!(le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_EXTENDED_ATTRIBUTES))
+		return -EOPNOTSUPP;
+
 	rc = wsl_set_reparse_buf(&buf, mode, symname, cifs_sb, &reparse_iov);
 	if (rc)
 		return rc;
-- 
2.20.1

