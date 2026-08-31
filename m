Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935FE44C66C;
	Mon, 31 Aug 2026 13:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183260; cv=none; b=LZ0GJm1AfWLSHCdrsAYHhrIBrJtc4VMLL2ylwPbQc/IGjSaxRrRTLiwCm1L/Da7IAJB9/K+BTG25IMR8ztZssEo4APJTry9hQ97mjYg8ts35q083A+5Cz1RblhnHNLOd7SjEnydqXD/V+S6mQNCGqNJC6gbcSkFEYwNF8M1SCHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183260; c=relaxed/simple;
	bh=bvhCu+0lL88POuUbQF2ovbeJxLX1IR53bQz3+5LQnb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H7B6W3p028cT95EK82HkYXyPW4QuE5HukwCPK4qnE5PepPBSnqcTQBA61T6Hb4gCP0oC1TQn2X+TwsctjAcTiuipIA45RUjPJeYHKChTH0s/L++I7zvvmRlPK3bRkwX/y6AMpiV8+RxSg+oFBPGGxLY6y12Hskc2MeTVoyHIUfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GYuXoDx5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GYuXoDx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5771F00A3F;
	Mon, 31 Aug 2026 13:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183258;
	bh=o/ru+O4FJgApCnIxOB8UVxf/zhPT2VupazBepdYvhKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GYuXoDx5Y5xtfn7b22h4lUER4lTWppDCCA8++EYRr/xQxESm7kH/Sk8JVxxF9xg+7
	 DyBp007IdFDz4VRHIWb7Q1sMk5qw2qtbNjYpwzoUA7yHdYyUJvuOHMSc+QJernt62M
	 siEfc6XQact2pqsAqOx8C/T58EzxtNqQmUNjyCCur3g5G6+EIhHbIQW7LJbztx6X5P
	 ZTfEuJHvm6l/DTyiIHVIgd5Knd1YvDWXl1NinDyG+vs3d8LlT/+C4bw8TeEDMHeJZD
	 6CDJJmXvf/Hxu50nNyfUQuEdzPy970ALRe4U5RZAFidlIb25O/ZNoDDWBL9MGWkQV0
	 JpLGcPcMhy2Qw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	linkinjeon@kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] cifs: Fix support for creating SFU fifo
Date: Mon, 31 Aug 2026 09:21:09 -0400
Message-ID: <20260831133314.4125787-41-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 608362facd2d0f2667f68b7f42207707d59a0071 ]

SFU fifos are natively supported (created and recognized) at least by:
- Microsoft POSIX subsystem
- OpenNT/Interix subsystem
- Microsoft SFU (Windows Services for UNIX)
- Microsoft SUA (Subsystem for UNIX-based Applications)
- Windows NFS server (up to the Windows Server 2008 R2)

Windows NFS server since Windows Server 2012 uses new reparse point format
for storing new fifos, but still can recognize this old format (also in the
latest Windows Server 2022 version).

SFU-style fifo is empty regular file which has system attribute set.

These SFU-style fifos are already recognized by Linux SMB client.

But Linux SMB client is currently creating new SFU fifos in different
format which is not compatible with all those SFU-style consumers. Fix this
by creating new fifos in correct SFU format which would be recognized by
all those applications and also by existing Linux SMB clients.

This change affects only creating new fifos when mount option -o sfu is used.

Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The buggy commit `72bc63f5e23a` ("smb3: fix creating FIFOs when mounting
with sfu mount option") is in the repo and present on several
development branches (`all-next`, `cluster-next`, etc.). The `LnxFIFO`
creation code it introduced is still in the current `v6.18.44` tree at
`smb2ops.c:5290–5294`.

The fix commit `63e4ae114ea69` is **not** in `HEAD` — it only shows up
on the `autosel` branch. That confirms the fix hasn't landed in
`6.18.44` yet and remains a valid backport candidate; the prior **YES**
stands.

 fs/smb/client/smb2ops.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 43eaad8fd0ad4..618e36f4d838e 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5288,10 +5288,8 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 		type[0] = '\0';
 		break;
 	case S_IFIFO:
-		type_len = 8;
-		strscpy(type, "LnxFIFO");
-		data = (u8 *)&pdev;
-		data_len = sizeof(pdev);
+		/* SFU fifo is system file which is empty */
+		type_len = 0;
 		break;
 	default:
 		rc = -EPERM;
-- 
2.53.0

