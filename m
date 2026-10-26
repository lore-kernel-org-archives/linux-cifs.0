Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053574;
	b=0tJLP/EjVFoxuIpQEauyps8RTOLHC/WDe3axQPiivtpJxlb14DJB66v9YH9QT9sP2Zne
	 RZd16fkqlMSIHANfkzcV74xpQp67ElCAZwczZ2n76ZZDabi8JFotCJKuTilMPXQeWa7jU
	 2pnEZCCA9to8sXBiIJBj0HxU7rrNwhfAf8427tonmZOiNSSVar6JZm02pXIOp1olqUb+4
	 LclFo0UCm7bksOwm8uFmJO64Tvr+kec6wJq9jLm7RIKYPbhZMHGSI70/swkLGSivzmtKn
	 Ygo8T6OftbbLMlgHnPSFiq7lyn62AputE04ng6hSI7D/wSgw47weYzSRehqjJVARt3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053574;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=M1v832G2cUYljA4PzdNFQO/+x89tzJMdRaBAycOns94=;
	b=AXgzaQYzCdyHKBhab+Ge7rv/QQ4NekS63fIOqFHdBNOZsKg0HihMs750vp0eZP+QIYV0
	 d5pXa1XpqkKiPNfCoYBPxuztLPBQ/a6ffQeSGLY20NmLcs7EgNAxxzEHCuBFtf0jF1j13
	 bxtFSCVwdTRflxOSTSZetFeBKY4cNmguE7wmoQtHZ4+FG8kPIrZUvn3IhY6P6jefeoYr8
	 eoFrkQhs+roPv7NVGA9iNZ1A68IM4K6pGJIPcuGRQsmQcLRhiHOkVXMo5j3ND8HGw9J+X
	 D8CerKYhOsw5iB9OW9J5Acb/ggdJ+bM80dWAZvC7ymoUMaDT1Iy9gZceJLvxBPCagGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BBdLk391;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DB5606A323;
	Mon, 26 Oct 2026 22:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BBdLk391
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B487A1F031E2;
	Mon, 26 Oct 2026 22:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793053573;
	bh=M1v832G2cUYljA4PzdNFQO/+x89tzJMdRaBAycOns94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BBdLk391fWn8H/SULkim5TtvAqvC5TkatjB6Xjq19HBZ/CVNAB8eajFFJP8mCGrAM
	 iZVbfXLPQE4WbORHiEu9nifl4CDi1HHah3WAnuZhzQIBhGQvTf5DHiNpXEK3DiWpzv
	 gu+MXVx4GHB9gmeYqQTe3xJRtZsyExaUT+JyL3CJ22euA4IcOPxA9Ie4zMGgwmYCiM
	 6Un/++8P3OjxKuz4O99u9tBGCzA2R1X05drRDbI29OtjColCgsl8JGaU56vA4XGzBU
	 1B5ffU+7dP5f7ar3Rj3OQncRvCHuWd9M0iLxl9UcVFsdS9pLvw6tPNW+TCYCuJL4QQ
	 7QEwQKtm4aEQQ==
Received: by pali.im (Postfix)
	id 15204BB6; Mon, 26 Oct 2026 23:26:10 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7.3 3/9] cifs: Fix validation of EAs for WSL reparse points
Date: Mon, 26 Oct 2026 23:25:54 +0100
Message-Id: <20261026222600.17323-4-pali@kernel.org>
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

When wsl_to_fattr() is called from readdir() then we should skip validation
of WSL EAs because readdir FIND_FIRST/NEXT results do not provide EA values
at all. For readdir() reply in this case return DT_UNKNOWN type instead of
DT_REG (which is the result of failed WSL EAs validation).

When validation is skipped and some required EAs are missing then returns
true from wsl_to_fattr() function but do not set fattr->cf_mode. This makes
readdir() to return DT_UNKNOWN type in the same way as it is doing NFS
reparse point function.

This change fixes readdir() result that for some WSL reparse points returns
DT_REG due to missing EAs. After this change it returns DT_UNKNOWN, which
is better than returning wrong type.

Fixes: ef201e8759d2 ("cifs: Validate EAs for WSL reparse points")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 3a27773186ae..e547510ca3c5 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1152,6 +1152,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 	kuid_t uid = cifs_sb->ctx->linux_uid;
 	kgid_t gid = cifs_sb->ctx->linux_gid;
 	struct smb2_file_full_ea_info *ea;
+	bool ignore_missing_eas = false;
 	bool have_xattr_dev = false;
 	dev_t rdev = 0;
 	umode_t mode;
@@ -1174,8 +1175,18 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 	case IO_REPARSE_TAG_LX_BLK:
 		mode |= S_IFBLK;
 		break;
+	default:
+		return false;
 	}
 
+	/*
+	 * When reparse buffer is not available then this is from readdir() call
+	 * which does not provide EAs. readdir() can return DT_UNKNOWN type,
+	 * which is signaled by no filling the fattr->cf_mode and returning true.
+	 */
+	if (!data->reparse.buf && !data->wsl.eas_len)
+		ignore_missing_eas = true;
+
 	if (!data->wsl.eas_len)
 		goto out;
 
@@ -1213,7 +1224,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 out:
 	/* Major and minor numbers for char and block devices are mandatory. */
 	if (!have_xattr_dev && (tag == IO_REPARSE_TAG_LX_CHR || tag == IO_REPARSE_TAG_LX_BLK))
-		return false;
+		return ignore_missing_eas;
 
 	fattr->cf_uid = uid;
 	fattr->cf_gid = gid;
-- 
2.20.1

