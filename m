Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417B32D9973;
	Mon,  5 May 2025 22:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485838; cv=none; b=C1OZQ1KVvMUC8UW+H4r/0nS1Of7p8CEG7lfDA6kbOjK+KkLyRwSJx1ezFR6hCfP7GA78MnVnQFCNM5wOHkA95tvQTJMNQW+JCO+Au7gkyjVkWSZDKNptjWGewFv0xdUWI0O5Do26hzUwE01xq0Lly+VGXkcLF7I79+yVTjOALnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485838; c=relaxed/simple;
	bh=cVrfxA+o2F1hom7mTW9Fdsnx8mc0URfmqqgfSnowBhI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rUtBGpPiGvDNndZ9xabQj40Vr1rK0WnCtqw117i2ZDQp8q2KScrgr/kxraNiJkl/L52r+RJYmBIO9CMaK1qH5Iio4N5F6P3H7fg8qvyB7G+gVFPQzlvcZb/Lo/KieErU89fcGEKyZSkpGS/9kmm94MzoxUYoQOmOX5osBfB0IE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rGj8H8r3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rGj8H8r3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B6FC4CEED;
	Mon,  5 May 2025 22:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485837;
	bh=cVrfxA+o2F1hom7mTW9Fdsnx8mc0URfmqqgfSnowBhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rGj8H8r33qs/4JC4Q+SGXB8N2av3+/w2mJ9Ltz5mIl/B0zaMyTSpwanUADEHyEGbp
	 axYZZKpcDdDK65wBXU8wPpKUEHwImbRIjC9+/vHX4Cy+Gi8U2yG3VeyIb86KvUPc1c
	 aBHAXb3m80eXQytIFX1MHNRiHVSD3guxtgsdgSmRb+1LT4VrISIve/RroKjzIqPOqY
	 9QM4+IoSOjGjrUZCvdH9XqOgtTluvb1EfvAoHdGHGPK+Sha8STODwsqNsOXk6eiPxr
	 XzlCZKy65OyndRXO4wAmLrX5MTxskaNePh8/cHG8mV52omhcOaTRDeDxA/7TwGoEzW
	 7pYHOrTNrzpxQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.6 020/294] cifs: add validation check for the fields in smb_aces
Date: Mon,  5 May 2025 18:52:00 -0400
Message-Id: <20250505225634.2688578-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505225634.2688578-1-sashal@kernel.org>
References: <20250505225634.2688578-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
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
index db9076da2182a..bf32bc22ebd69 100644
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

