Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875D2305E2D;
	Tue, 12 Aug 2025 19:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026364; cv=none; b=pytem2+FZic1JhJT2mZ81pm4CtWS8tFPsj95wO5gQAsfEqJmrWI5yHgSqLRTyAMj6O2KKYv+Q1Tl5YSzDimJYUWSYQ07PMDeRyssT9SHwktG9zA/zGjr/FR8dPvaO+TjUJZmq6mqafFO7ajCfpH6KG28lZzndwMKsZc2upug7lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026364; c=relaxed/simple;
	bh=dpA5L/9E72DSOw9P99yVLKfW0fYxzHhb1MrgrDqCsrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCTYzBMw4ESjMjdkiJSmeX85Vo94BdhAYKaGzKE8CJpk8rBA9r+crq4TkM7iNXo5XcaE9hRlrQBJsdsySIqYhOUwK6O5XJoKxqudyPDY5dtgHZQcqnkWY+7umv6HAjUhp+PMJUru0eshOOqeuRFbVPPCV7F1ryy9SU3VkESiM7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtW+34xP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtW+34xP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20C5C4CEF0;
	Tue, 12 Aug 2025 19:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026364;
	bh=dpA5L/9E72DSOw9P99yVLKfW0fYxzHhb1MrgrDqCsrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtW+34xPIio12hV2BjN1SshojsYsaAHA+layAJ2kjhkfnFnrJqJpE0haV12H30cFe
	 Vd38hdNNb82XHpbeTVN9f2I7f8bzDN8DwvfRh56ZrXrzR7JVX7Ixmxa3vdCwTcMpCc
	 ZTd+vut6rHxrxazaETd6aTIgpySzBZrNbgFvNPTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 315/480] smb: client: allow parsing zero-length AV pairs
Date: Tue, 12 Aug 2025 19:48:43 +0200
Message-ID: <20250812174410.424333540@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit be77ab6b9fbe348daf3c2d3ee40f23ca5110a339 ]

Zero-length AV pairs should be considered as valid target infos.
Don't skip the next AV pairs that follow them.

Cc: linux-cifs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Fixes: 0e8ae9b953bc ("smb: client: parse av pair type 4 in CHALLENGE_MESSAGE")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsencrypt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index 35892df7335c..6be850d2a346 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -343,7 +343,7 @@ static struct ntlmssp2_name *find_next_av(struct cifs_ses *ses,
 	len = AV_LEN(av);
 	if (AV_TYPE(av) == NTLMSSP_AV_EOL)
 		return NULL;
-	if (!len || (u8 *)av + sizeof(*av) + len > end)
+	if ((u8 *)av + sizeof(*av) + len > end)
 		return NULL;
 	return av;
 }
@@ -363,7 +363,7 @@ static int find_av_name(struct cifs_ses *ses, u16 type, char **name, u16 maxlen)
 
 	av_for_each_entry(ses, av) {
 		len = AV_LEN(av);
-		if (AV_TYPE(av) != type)
+		if (AV_TYPE(av) != type || !len)
 			continue;
 		if (!IS_ALIGNED(len, sizeof(__le16))) {
 			cifs_dbg(VFS | ONCE, "%s: bad length(%u) for type %u\n",
-- 
2.39.5



