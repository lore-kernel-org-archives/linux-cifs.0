Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=173.212.254.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168407;
	b=m0ffDgdpcr2sN2qs7sl/7zifAsvPiqzgSOvfr68G5Yzs57On5IrFoINKx5wmPzdbcIEc
	 zk+Zw2UkdekfonPTTyMmUMbdhZ3isQifvU834PHOMvklyK0FkEZhFl8MA38XVasQpJCjE
	 mHV90uMzb9t29x77WlUSyVeKVaf83fOyEmnF3YUvxRRei4OJ91QV0GUggahHzUuWOrkyy
	 +7RsrdiWvqhYmOjqu8UBCXxkZ0LuOmNXfcvu7BBTi3fILiR59YKDiPfSshXp2EGZ/Oa+7
	 LrS9O5+C6xD3Mf5f+2ISGSLfMcK3uT4OXwYsUiueGpy2JQxb0I0euBc1pvwkFtLug+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168407;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:In-Reply-To:
	 References:From:Subject:To:Cc:Date;
	bh=tdvwiNlqaiNgnQeeDxlcwnYpnhQBbwCpT74p9vzgZbc=;
	b=k6/t0WAU+evhLBSfx+dr/pEdxUZOeTohlmgzs8hG5709tMwDovGt1qDjzY6AeBGUhqgL
	 VCY+JWnRcabSTwYFVpNgm0zfNE7NcSEjDNfGiw9QR7pDLD7snxsC8PNvlvMkfDYIuVw6a
	 3HAXO0v4nrFwnJ0d6E/5diVhoPAIVAbhGyqh5lI5hTH8Md7OIrX7Fi7KUmpad51/zU89m
	 NHIeWgSTZEVG4LaB0uAEHUlS5xZO+ek8T0kOH7UdCa8mHPluCLkztsLgF/DrKHCrMA/0H
	 ChOc06FI5cDWTSjV8/V6u83gncoMdvSU6KGiN3cOA9te1R8BWM8Nv2gVrUaVqyWLWiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tuxist.de;
	spf=fail smtp.mailfrom=tuxist.de;
	dkim=pass header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=il40JwvL;
	arc=none smtp.remote-ip=173.212.254.19
Received: from groupware.tuxist.de (groupware.tuxist.de [173.212.254.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55002606A31A;
	Wed, 28 Oct 2026 06:20:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55002606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tuxist.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=tuxist.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=il40JwvL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tuxist.de; s=201705;
	t=1793168404; bh=daCjDusNXn5OqQ8xPF6cVaFfETCkBtcOLhTaIe0OEVY=;
	h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
	b=il40JwvLD4s6aZ//N9nUgpN/WbklgmBIJpZNqnwmo5w+lPdYvwSgHoA0/1Jmh4LRF
	 ULyHp4I7Jm2RKNNqS+AEx5B0+vpKxg3x0E6VLp5V8lSw/gU1BD/g3dP/3gB9qE1FnK
	 6BQCU3KDtpXgre3owaa13A6YeuYvrFAq7yqYyYdxCsyY4IGzI8TlmnSab6w8UhG+eS
	 myLJ8u9Fq549sigK2tIPY6xzuTfhYpiW1T9SD2a9PElh7qFSQKCm9nj1ATLbS0T3Bi
	 Yd1pNiWT1Yh0abz8k4hIH86l3uL9N+W7V0474zVZVFG1d6nxymGBhVy64AI+q3mTWd
	 QFI7ykTF/0CQA==
Received: from [10.1.1.106] (unknown [10.1.2.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by groupware.tuxist.de (Postfix) with ESMTPSA id 0C3288A0964;
	Wed, 28 Oct 2026 07:20:04 +0100 (CET)
Message-ID: <047776d02792a6fa909ada70af538aec0f359b70.1793168155.git.jan.koester@tuxist.de>
In-Reply-To: <cover.1793168155.git.jan.koester@tuxist.de>
References: <cover.1793168155.git.jan.koester@tuxist.de>
From: Jan Koester <jan.koester@tuxist.de>
Subject: [RFC PATCH 2/6] ksmbd: keep named ACL entries effective when a DACL
 sets a POSIX ACL
To: Namjae Jeon <linkinjeon@kernel.org>,
    Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
    Tom Talpey <tom@talpey.com>,
    ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
    Christian Brauner <brauner@kernel.org>,
    linux-cifs@vger.kernel.org,
    linux-fsdevel@vger.kernel.org,
    samba-technical@lists.samba.org,
    linux-kernel@vger.kernel.org
Date: Wed, 28 Oct 2026 07:19:59 +0100
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list

parse_dacl() turns ACEs for other users into named POSIX ACL entries
with an rwx mask, but leaves the group bits of fattr->cf_mode as the
owning group's ACE made them. set_info_sec() sets the ACL first and
then the mode, and on an inode with an extended ACL the mode's group
bits are the mask: a DACL without an ACE for the owning group (as
Windows writes them) left the mask at --- and every named entry
without effect.

Put the mask into the mode's group bits when there are named entries.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Jan Koester <jan.koester@tuxist.de>
---
 fs/smb/server/smbacl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index d1cf63a9fe..b3daf65798 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -680,6 +680,12 @@ static int parse_dacl(struct mnt_idmap *idmap,
 
 	if (acl_state.users->n || acl_state.groups->n) {
 		acl_state.mask.allow = 0x07;
+		/*
+		 * With named entries the mode's group bits are the ACL's mask:
+		 * the chmod after setting the ACL mustn't mask them all off.
+		 */
+		fattr->cf_mode = (fattr->cf_mode & ~0070) |
+				 (acl_state.mask.allow << 3);
 
 		if (IS_ENABLED(CONFIG_FS_POSIX_ACL)) {
 			fattr->cf_acls =
-- 
2.56.0

