Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47DB3430B1;
	Mon,  5 May 2025 22:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484814; cv=none; b=tG4jbPC60ERUETW1pUcdIRgctO8t2+z0Y0QtjbfBXwPhd86Dg+OLxId2tU36T8KJGpGZFKi1SMlcheY8S6Emg96TDCNwMa6MAzL9xhUGAnkCdC5qivn1AY0KpRXiF54P+deOCq062fWFV59zJMM910AN3gqji6WWjVoU2o2XuMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484814; c=relaxed/simple;
	bh=pwIXTziwCHzbUkNjvjKYbolOdJTQBSjZYXQSbpIJteE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LV+eYG6R50DldVcv+Lyzof80n2MQRASC69P1w4bQAhCdb1UvizlkOjk7LDt7fQyy9c4oyT2LIYYf+ErtAl0Qr1mrbMqhtUSI+qPs8h6sKCQ7cTXnB1nBfvdtHPHicxsM4Nxqkdvs19A0KtnTwXOMMvDjewhtP/XcZ7i4Kz9bR+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HhqdXUbi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HhqdXUbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76FBC4CEE4;
	Mon,  5 May 2025 22:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484814;
	bh=pwIXTziwCHzbUkNjvjKYbolOdJTQBSjZYXQSbpIJteE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhqdXUbi0WBexC79WaIVeSwAtnQnkNbPxx4t84EQ4vdYThEMSVFhLjmAe81StMUfS
	 lR4+z6zll9ClfQ6OI7JP+SbF59BAjRpWX3aC8nTIkv8PwQ6PwmoBl9z0U8UfccVhYK
	 Z7GppcgQjbaMEvTH8Dlp3fb3dZfsA4NA1wpzZP4wrZJJPp1abDzGiYbgDWElLc9Bqm
	 JD4omvJAyBMseKthoEIXNOKy+fX/z/sWyXRU7HilzE25V37Uoh+RWF6hrQ/MdlZqc7
	 Q3KeLftTmYTdOi7c8pbqdcMIFdG/QwqahkoJMb+AzpINb+VU57oTSJbWLxWaakdxnu
	 40/big9tj4tWg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.12 026/486] cifs: add validation check for the fields in smb_aces
Date: Mon,  5 May 2025 18:31:42 -0400
Message-Id: <20250505223922.2682012-26-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
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
index e36f0e2d7d21e..9a73478e00688 100644
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

