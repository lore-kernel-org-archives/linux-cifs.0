Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BD64570D4;
	Mon, 31 Aug 2026 13:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183825; cv=none; b=DUbCk2kqZWwo7CHW8T7uXdkqW6uV0xVRt+ZAZNVI7eghhnr2xTBlVvdj63uvUT+CBvuJDQ6m8X0NaKu/L9CUlf9llyZ1F2YIevnjfuoUB7IeZM0lKODel97+kZWzQJUbg0Wnk/IZ3umdgiNIO+bLdUvSX6KS624lTkTYiBPsiLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183825; c=relaxed/simple;
	bh=UF8jyWbIjptA/E5+ZE9rWf1gGbs/WrtMOmhe3oEErus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G88rEobny1c2ZPLUdpgUfVo6uzFr36CiFgMVtIwKtAJ+m1rkQ+Uqw62dBh31b6MWJ2QFqpzDvAMFcXL1xt1HZTb27atzmcy7PkIJJ3Y3Lu1cgB55GzsZrmolHDnOt11fUuDGxZsMA6WgXNjdP9cjg13E8t3o6WJRPTGfnq1op4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e5Zmz87Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e5Zmz87Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3E71F00ACA;
	Mon, 31 Aug 2026 13:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183823;
	bh=vDQzws7rWBs4bRCDOaD0b/qY3O/0ew2mrOeHbkSkcHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5Zmz87QyE+6WG6J5bITsdIrVvg7VWftxoU45pRGxwwszj0eF3COxRNf6kWRBvt4p
	 TkPVTsrrEH61DTKL47jwQYG9SImnB4GpDqe9DpJVNpHDv0oO2slSyYcXwq+nsr+2io
	 QXy8YU25oZbd9FI2jihT2Q0zAqnDgtBHHhVZlqNGx+2BBRe+gTthwmmtAWM4vXw4V4
	 JO20EhsKRh2a8kb5KtUNHVg/MWHOM9DqOaGdmpe5uiqyb9hgPeuXhWq8Opej1C+6h7
	 U8Ltkl2R91IcNBK9HsGcZuGG76uZYAIfflR4J6XG5dVJYgdIviFZuctEtxLW8JqvzB
	 4tm7m9222vCwQ==
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
Subject: [PATCH AUTOSEL 6.18-6.12] cifs: Fix support for creating SFU socket
Date: Mon, 31 Aug 2026 09:25:54 -0400
Message-ID: <20260831133314.4125787-326-sashal@kernel.org>
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

[ Upstream commit dde3929e8d901ae9a7c29d0577ce9ca5cb4db35d ]

SFU sockets are natively supported by Interix 3.0 subsystem and also by
later versions. It is part of Microsoft SFU (Windows Services for UNIX) and
Microsoft SUA (Subsystem for UNIX-based Applications). They can be created
and existing (stored on local disk or remote SMB share) can be recognized.

SFU sockets are recognized also by NFS server included in Windows Server.
Windows NFS server versions since Windows Server 2012 uses new reparse
point format for storing new sockets, but still can recognize this old
format (also in the latest Windows Server 2022 version).

SFU-style socket is a regular file which has system attribute set and
content of the file is one zero byte.

These SFU-style sockets are already recognized by Linux SMB client.

But Linux SMB client is currently creating new SFU socket in different
format which is not compatible with all those SFU applications. Fix this by
creating new sockets in correct SFU format which would be recognized by all
SFU, SUA, NFS and existing Linux SMB clients.

This change affects only creating new sockets when mount option -o sfu is used.

Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Those background git searches finished and mostly confirmed what the
earlier analysis already used:

- **Fix commit located:** upstream `dde3929e8d901`, stable backport
  candidate `59992f1474a3a` — neither is in current 6.18.44 HEAD.
- **Upstream merge check:** the `v7.2-rc2-smb3-client-fixes` merge
  (`8eae393cbfd79`) is also **not** in this tree.
- **Pickaxe history (`-S LnxSOCK` / `cifs_sfu_make_node`):** only
  surfaced merge commits because of the `fs/cifs` → `fs/smb/client`
  rename; not reliable for pinpointing introduction.
- **Better version scan:** `__cifs_sfu_make_node` with the buggy
  `LnxSOCK` write path is present from **v6.9 through v6.18.44**; the
  related SFU refactor landed around `c6ff459037b2e` (Apr 2024).

**Verdict unchanged: YES** for 6.18.y — small interoperability fix for
`-o sfu` socket creation, applies cleanly, maintainer-acked.

 fs/smb/client/smb2ops.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 4b7bc048854d1..f4d7eb88d3fdb 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5283,10 +5283,9 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 		data = (u8 *)symname_utf16;
 		break;
 	case S_IFSOCK:
-		type_len = 8;
-		strscpy(type, "LnxSOCK");
-		data = (u8 *)&pdev;
-		data_len = sizeof(pdev);
+		/* SFU socket is system file with one zero byte */
+		type_len = 1;
+		type[0] = '\0';
 		break;
 	case S_IFIFO:
 		type_len = 8;
-- 
2.53.0

