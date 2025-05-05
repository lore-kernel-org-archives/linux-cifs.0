Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB05D280CCD;
	Mon,  5 May 2025 22:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746483318; cv=none; b=G9QfNUAp45FXpYtItD4HBsI8/odEeS8cQO6UR+znWkN0NnadrAVGhI1waTosLF2BNmewvmadABkNYu7lRgOfznkYreaEYr9XdqKZ794ubwux0QkH8jDuJFyjiV+Lim2xiTWrQjS/By5WKSNqp91upHMm4eIEa8AAIyBeCdIAV7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746483318; c=relaxed/simple;
	bh=ZS8EgfsbfHjVhDfmasW+ql8bQYFdF4SSZ3iTCN+6ZVo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I9Ta2KEtAnYQ5PybOCN1fL0prPeJGYepLYkJOpOGgcjBj2+jZ9nMAFCRgG1tF0ipyp1bGSGfUXxpCo/EIB6XWlp3GCI03nnm83DO6Rtq7r0V6t/3Yu+v45pNKb10ILutfh1k724JLfSRWTntepRtxJ9V20vx4BJIdYaAPshvRB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K/emPI4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K/emPI4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5C9C4CEED;
	Mon,  5 May 2025 22:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746483316;
	bh=ZS8EgfsbfHjVhDfmasW+ql8bQYFdF4SSZ3iTCN+6ZVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/emPI4QcFhrLgdIuY+ufRJ4++ALBqUp1Zu9GXYfjg04MyG5aDx/hDbWFVS1u/yGm
	 kOfy0HgKpSWhbkSA2s7UVcof657P485ZiJx1Xhbikxze5mw+U/agaAE8gclREfsieR
	 WP5xOD7q6X92JQKrhOZVSauK/02SlldTE70tSJjENHLJ84KLYEO7bB1tbi1FsCRLs3
	 vtC3yX4E8dXk3ADykmMhTcc7Gnj4SsFEoyvbOQmVySsRm750fI76vQMYmqHtPMrhvR
	 QZ+OyUj7BWY+I1J0DXNFiVGgZNTPj/MhqaNxcdM35CwkIsCMZEgvxTLj6UuyiAotg+
	 Fk++5pNPswKJA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.14 028/642] cifs: add validation check for the fields in smb_aces
Date: Mon,  5 May 2025 18:04:04 -0400
Message-Id: <20250505221419.2672473-28-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit eeb827f2922eb07ffbf7d53569cc95b38272646f ]

cifs.ko is missing validation check when accessing smb_aces.
This patch add validation check for the fields in smb_aces.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsacl.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 64bd68f750f84..f9d577f2d59bb 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -811,7 +811,23 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 			return;
 
 		for (i = 0; i < num_aces; ++i) {
+			if (end_of_acl - acl_base < acl_size)
+				break;
+
 			ppace[i] = (struct smb_ace *) (acl_base + acl_size);
+			acl_base = (char *)ppace[i];
+			acl_size = offsetof(struct smb_ace, sid) +
+				offsetof(struct smb_sid, sub_auth);
+
+			if (end_of_acl - acl_base < acl_size ||
+			    ppace[i]->sid.num_subauth == 0 ||
+			    ppace[i]->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
+			    (end_of_acl - acl_base <
+			     acl_size + sizeof(__le32) * ppace[i]->sid.num_subauth) ||
+			    (le16_to_cpu(ppace[i]->size) <
+			     acl_size + sizeof(__le32) * ppace[i]->sid.num_subauth))
+				break;
+
 #ifdef CONFIG_CIFS_DEBUG2
 			dump_ace(ppace[i], end_of_acl);
 #endif
@@ -855,7 +871,6 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 				(void *)ppace[i],
 				sizeof(struct smb_ace)); */
 
-			acl_base = (char *)ppace[i];
 			acl_size = le16_to_cpu(ppace[i]->size);
 		}
 
-- 
2.39.5

