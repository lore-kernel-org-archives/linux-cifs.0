Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635872C21E3;
	Tue, 12 Aug 2025 18:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024632; cv=none; b=NCYbeAB2YSfePETwDPuZwjOTqr32ycsrs/6NwddKNXSvpo4Cu5DzDtbd6l2xFpkPMPlH9YhzwazgygQsuNpkoO51S0R4AntitwWYONTHqNzdLXNhMpcD0g/lUS3MmyvMPUKN2ZDGqpIsX+2PFDTyDWGIsr9dmg0FqGyNmcDnb5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024632; c=relaxed/simple;
	bh=u/z+8FXBVK6/HeElSy+ZrQdGbl8uuEsnaLtLj+RO410=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQX4RsnHYgjUWdXsRXx7pxrpQHCGVa++UoNgF7gcJmFAfyD8h5buN1NTehriP3jnUwLH/h6uMT/FMCWLYYa6N20SPjeCbQjc0CDvchoItnzXgPj0+U8sWZ9quyNMDyJcxhvMqPtkXMPexow5jOE+v7C1kKxgYjYOJwl8aM6Pc8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sp+5BfGS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sp+5BfGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B45C4CEF0;
	Tue, 12 Aug 2025 18:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024632;
	bh=u/z+8FXBVK6/HeElSy+ZrQdGbl8uuEsnaLtLj+RO410=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sp+5BfGSrYOkKBjZRTj21HkVL5LIIrwGcrQ7aph7Fsv1aIiNgR/VpahHvyN3I4R2+
	 XUMc2AXKizwemSF3ydF0N1P3TWeWjsPIPHGHMRlVF1XYjduueWE23/ArAJA1SdOiFi
	 uyqes0MMYsKAOo9yjPgtfs08cbIhIBKvdHZfwZl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 431/627] smb: client: allow parsing zero-length AV pairs
Date: Tue, 12 Aug 2025 19:32:06 +0200
Message-ID: <20250812173435.674780125@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



