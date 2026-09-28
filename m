Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717C03537F7
	for <linux-cifs@vger.kernel.org>; Mon, 28 Sep 2026 05:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790572833; cv=none; b=Ybr1fuiPu66lOrKR5M6mbdIZMd2ih6niteLHENGl67RDE9x29Ab5chzUYfxwgBE8l6NFa31yg9fd3aFMhDAw13/KCjy51kv03V80Zb+YubxqihmMmO6ETeX9BTHEGbdobEoj3oYxN3qel9hgU7njQTCA99EK/Vx6ESV7EeebrC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790572833; c=relaxed/simple;
	bh=yXfelmIZplmdqRhLmJ09Qiooj8wOaNfc1KuU+AdPS5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6tDFmxCA8IP4LsQrobdvMlfkdw0q8iaPmDRYUyepsZ3ym/eXsBhzxN8qQ7VWWvGWsWuquhzDz9qXUnZgGkFIGp1CG71EF7kqSm5ZgDsi/438MZQV2FEsEUerUhj2zFPWv+Eh4/yLk1UKQM7EsrLpYfNM/ITs7J036IXcpnJLv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FaPyHycU; arc=none smtp.client-ip=74.125.227.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FaPyHycU"
Received: by mail-pj2-f41.google.com with SMTP id 98e67ed59e1d1-3a0bd71827eso1397461a91.0
        for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 22:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790572830; x=1791177630; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hIYi5H66WOaBpUXgxzS9EY2DvN/9LYiaWOqvjKwedYM=;
        b=FaPyHycUlfxC8NImrX64K5aUoOVbh+G98XvoEF/f5S3E4RwqMNCv4aKo9nf6jXVtL2
         8wHRJ8Xc9NqyyyBFoi1JkdIrwIXCsuTEdrB/iTXxkEsA6wPwrNOHRB5Jo0UF7z7T6+JI
         2hFl2/z8LaU5fgKgkug1DHGqZPE9HGWDfYPHVhGnbX48rHe2o8HiU5WWcHzO8GXyOoNZ
         r3V/NTQEVoR2seZnyUYLdKvmu1yEBQbs64u/BYcBPCt2ls4YRBeBPpcz5gfGq8FqKQeP
         wmoNXQiqvMFSa81DtvEecdZKkoXqfjXgdAmEgEhi9kfdIrmcWrdVKLqMlHEklB2erBiw
         ABPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790572830; x=1791177630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hIYi5H66WOaBpUXgxzS9EY2DvN/9LYiaWOqvjKwedYM=;
        b=KJIF1l7v59BDJv5JUPy6fPBtsRfTXaRvMgaOxcpU2tYX4qMbzTvkrBgxs66hn/FRwe
         PWYW/91WdnMyS27m2eXQCWDyQUY0c2FET6psL3BkYxk5N4Rjx8Zlti3jM0rO1VTU8byb
         0LH9rbczx2QBlLPHxC6sN8/PlNA3WnCsYoovPcm1eT60xPt96yJLA3cEsfa4rj05Lz+M
         bjEIcbzTlqm37Lu/g4zuoGqwROyloUa1E2WRl5He2ByZUOKV4vF28ymBIwyr4ZcSy1if
         TwM7bBTieejEEVdYpJrfl/KelMz7pj3anej95PCZWrKiGNQp17fOIeuQSqLoCWpP3j3H
         Ledg==
X-Gm-Message-State: AFq9FYKd9vPcu8ekcEnZamX+VYlssuzjryl9wIUkkb1NFNklXpCBQUpV
	bJFZvjzrgXN9USPlpmAfia+HvImaN/lsq4przxj5k1uefJ1iYBIcKROooOuG5eWj4gL/+g==
X-Gm-Gg: AYBFou3H/4KwfUQSzus1kTn9QDF4YbA9Qcbzz6qfK8V76eavUTf+e1lMCNaBgWFvy//
	FZN0GmM9Niewozh0uVaxR4NkHYaPUtfkxJ/DTSV1hPPstJQWJ00dyj0XoitEJS0tFnzw+SwPPRI
	sd+mLNny2yHEjm+4xbwvtDspcgJiR2yETD0XlrQ6Uycxju+nDnCEMPRuYtmQBCsvurJDtK0IaaJ
	87BKk7yT2TszyM5NqSKEPPFtG9/wJpZxJZSyB67kPtsrECm2bNPER7tLci0PjyAynbR0U9o6doZ
	ip0pbiX2wfiV3nUw7LY1lwh04LLK6nzTIT6aWnxgy+WytdVZ0mOsL8KOUbLWcDvP5L/zjcV5wgi
	Ju5zXLikJ/mL7J6ZdZUDa8+xB8vtfZgTgvGbNtTm7vtcw9FokwnVTlMfZr/sl94tX5rcE0nVNoH
	cGQx92fFTgtx6BkZ0FZMuwBlM8sT09R8iK8gajS67C7RoXEcu6b+3uEf6dVnYTcaVGtD470DcpV
	2/g
X-Received: by 2002:a17:90b:4a91:b0:3a0:bf26:f24a with SMTP id 98e67ed59e1d1-3a0bf26fc15mr6705857a91.45.1790572829745;
        Sun, 27 Sep 2026 22:20:29 -0700 (PDT)
Received: from localhost ([8.219.235.175])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0976cacbesm24621112a91.13.2026.09.27.22.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 22:20:29 -0700 (PDT)
From: Dairui Zhang <zhangdairui@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Dairui Zhang <zhangdairui@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] ksmbd: fix OOB read and cross-share confusion in ksmbd_validate_name_reconnect()
Date: Mon, 28 Sep 2026 13:20:26 +0800
Message-ID: <20260928052026.1789765-1-zhangdairui@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260927063339.1731061-1-zhangdairui@gmail.com>
References: <20260927063339.1731061-1-zhangdairui@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd_validate_name_reconnect() indexes
ab_pathname[share->path_sz + 1] without checking that the path is
longer than share->path_sz + 1 (d_path() fills the buffer from the
end). A durable fp is not bound to its original share, so a client
can preserve a file from a short-path share and reconnect it on a
long-path share, making strcmp() read past the PATH_MAX buffer -
with a long enough share path this oopses the kernel, and on a
mapped page it also gives a byte-equality oracle on adjacent heap
(the reconnect succeeds exactly when the out-of-bounds string
equals the requested name). A same-share variant with the durable
fp at the share root reads 1 byte past the buffer
(strlen(ab_pathname) == share->path_sz).

Check before comparing: the path must be longer than share->path_sz,
it must start with share->path, and the next character must be '/'.
The share root itself is accepted only for an empty name.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Reported-by: Dairui Zhang <zhangdairui@gmail.com>
Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Dairui Zhang <zhangdairui@gmail.com>
---
v1 -> v2:
- Also verify the share path prefix and component boundary before
  comparing the relative name, per Namjae's review (a same-length
  share could otherwise pass the separator check for a file from a
  different share).
- Accept the share-root case explicitly (fp is the share root,
  name is empty), per the Sashiko review note - v1 rejected it.
- v1: https://lore.kernel.org/linux-cifs/20260927063339.1731061-1-zhangdairui@gmail.com/
---
 fs/smb/server/vfs_cache.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 293dab9..1acab9a 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1714,9 +1714,21 @@ int ksmbd_validate_name_reconnect(struct ksmbd_share_config *share,
 		return -EACCES;
 	}
 
-	if (name && strcmp(&ab_pathname[share->path_sz + 1], name)) {
-		ksmbd_debug(SMB, "invalid name reconnect %s\n", name);
-		ret = -EINVAL;
+	if (name) {
+		size_t len = strlen(ab_pathname);
+
+		if (len == share->path_sz && !strncmp(ab_pathname, share->path, len)) {
+			/* the durable fp is the share root itself */
+			if (name[0])
+				ret = -EINVAL;
+		} else if (len <= share->path_sz ||
+			   strncmp(ab_pathname, share->path, share->path_sz) ||
+			   ab_pathname[share->path_sz] != '/' ||
+			   strcmp(&ab_pathname[share->path_sz + 1], name)) {
+			ret = -EINVAL;
+		}
+		if (ret)
+			ksmbd_debug(SMB, "invalid name reconnect %s\n", name);
 	}
 
 	kfree(pathname);
-- 
2.53.0

