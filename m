Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8D91A5B9E
	for <linux-cifs@vger.kernel.org>; Sun,  1 Mar 2026 02:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772332901; cv=none; b=FKMCUThx5vuFdLjPyebL+6Y5bdqpHfugv1mQUXlY3+W1NfGYUmpAM0gqmgxuu9KDGb9rTe4in7URSTZyx1TJ0Oi7JGfPePA6MEm89zA6Or5kh51Wdz2lu3co9Ht0PYLcokFQkVY8tELu6IYzXyszPzipdFqSTzjPxQs0rqLIkaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772332901; c=relaxed/simple;
	bh=anpL46cBIm6UrMAbUnBQkqKmbT5nOqCfjQPsoRvAfHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAIG0NhrQez1YjfFoXpu6rj2ZthaaVNz81Yot6AomGHTk34CpI9KulIi8WxwTqjujqL9FOyFMqWDtmzkaTKB6Cc2N7d+trMrDAIrMznA4v3z4lgRk/EnrQK7KlH5c8CPg7wlODGIS6A7tkuVrqCKEPta2Y8P76wxYwLcD2yDzho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gqux1boc; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gqux1boc"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-827270d50d4so3458262b3a.3
        for <linux-cifs@vger.kernel.org>; Sat, 28 Feb 2026 18:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772332899; x=1772937699; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rtIGa5DeHX6GKNql8ZP8pFgIuTIayoQ+uGd3ozZ2QhM=;
        b=gqux1boc96rstQk7s34oWXn0IjVf16z5kS0aUBkWyv9JgXsEHKBfS18m4wrjq+qhm7
         VpZw1H2mLpx23eLeTf5WpWTncXiy/fx9sjj/sswCHRAsQu03na/1gmc7GtJDxeoNHDeC
         JYbT6+XUfOXpkKMXqmKJ5/ZUvY08TxxpmMXDk0v2ZBBb2QJgVvgePKl8+eTN5oQ+zzfz
         XTM2EPWpHGTeM+2ndnpYYYrwxYFvfDherafe0U9ndRZ2ewhzO1D2gtVxPDXJyBctw8xo
         TK0S97XwQtgwqopFPygYGO/CRHQ5az9DlsEQSKD5/j1LVtI94v9GMxiXg0SsV3+Wk904
         Gr1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772332899; x=1772937699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rtIGa5DeHX6GKNql8ZP8pFgIuTIayoQ+uGd3ozZ2QhM=;
        b=gKo06ENtksUVZKGyNVP0sZ/kUD//yHuOm6vMMNi6tDp1QgVmM7qnTJkeSHbtWYdlTR
         ZOtQ1XI1y/dFd+hRRgxZGOURumT0YNNfmbkool/wHkeRy5vOHpwfV/K1djVpE9sjz8Iq
         8fXIGYwqM+hUThjyViqLX4nE55vRjEK8Nj6jPDvxo67GsAtPJ/a2a3dpRE7s5dCHQcbv
         57CU0r7irPsuKcSjLMu+PAOFV188x/OOB+AxMhDFyeK+azXffLpkpuhvqQ0sSSoKbO8m
         4x2sax35WVrsGb8Ri8mLB2O/PX73uYMKOdmAbPexMfiPpJeEdxazLBHW7Qxnt78Ag+5w
         8WrA==
X-Forwarded-Encrypted: i=1; AJvYcCX9NVZX6xuzpRmMuuljr73PSHBOx+XCioT2sMPQfxC408DbnlkgIJX/2r867W92RTBOOpncAwGGAC23@vger.kernel.org
X-Gm-Message-State: AOJu0YwCBEL4CEv2FAwpMmqadjw2hyoNFemIWVo0nhhnYyWJZ7Jht6as
	DUgfJEA9qw7QsD9iWNFiMncQa5sNV8hld8oK0In/njXJREFjjuFFqFTG
X-Gm-Gg: ATEYQzzTPmimz5ZRXidTBkRdPczkCEuu/gGqJs4REV+zuOoZAgCE7CkhEie61fSZ/RG
	LZSJGuqzpbF+vP+u6qDbt8B/c6WNrDbx6HwKVsZ2ajAzPW9Ec2V1UtDa/B4A7yZIkzfHMpHP9Dj
	19GoXH8tD4QmJ6EPfBgAgUZFDTgDiFUrlVq3azrFfikLqYDyCHoIqDwc62wM+ga85TXRR9bnCUS
	vngQdRC0Y+twurGp0frQy/8uIWe33kV698lFILnXeEGCUUw3JaWW9MEueJV1LNdpmw9vO0gg/Dn
	bcglqAZeWPQFakcOSWDLDvL0pbe+sN3vXtQ07wJf2lbnG3Hn4YumxfgUZzEdKBLPHGHfaJHRsxs
	TmhBtO64yJKXHVNwVCUeMoUC97uiCBvDuYzA29JRzuRwq7ZsbRq1bJpqfvpUvobCg9DI4LJsIHp
	lx6zj98uzV4PNpOxuJFUthEmhLC6bsHilHNY5LcYLDbIBqSz0sv9WMgIg=
X-Received: by 2002:a05:6a20:a127:b0:394:f9f3:588e with SMTP id adf61e73a8af0-395c3ae862bmr8668720637.43.1772332899049;
        Sat, 28 Feb 2026 18:41:39 -0800 (PST)
Received: from localhost.localdomain ([222.109.75.221])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359037af175sm11857110a91.13.2026.02.28.18.41.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 28 Feb 2026 18:41:38 -0800 (PST)
From: Yuchan Nam <entropy1110@gmail.com>
To: stable@vger.kernel.org
Cc: sashal@kernel.org,
	sprasad@microsoft.com,
	stfrench@microsoft.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Yuchan Nam <entropy1110@gmail.com>
Subject: [PATCH 6.12.y] cifs: some missing initializations on replay
Date: Sun,  1 Mar 2026 11:41:31 +0900
Message-ID: <20260301024131.79122-1-entropy1110@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260301012846.1686559-1-sashal@kernel.org>
References: <20260301012846.1686559-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 14f66f44646333d2bfd7ece36585874fd72f8286 ]

In several places in the code, we have a label to signify
the start of the code where a request can be replayed if
necessary. However, some of these places were missing the
necessary reinitializations of certain local variables
before replay.

This change makes sure that these variables get initialized
after the label.

Cc: stable@vger.kernel.org
Reported-by: Yuchan Nam <entropy1110@gmail.com>
Tested-by: Yuchan Nam <entropy1110@gmail.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Yuchan Nam <entropy1110@gmail.com>
---
 fs/smb/client/smb2ops.c | 2 ++
 fs/smb/client/smb2pdu.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 4e7e6ad..48d66a9 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1190,6 +1190,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 
 replay_again:
 	/* reinitialize for possible replay */
+	used_len = 0;
 	flags = CIFS_CP_CREATE_CLOSE_OP;
 	oplock = SMB2_OPLOCK_LEVEL_NONE;
 	server = cifs_pick_channel(ses);
@@ -1588,6 +1589,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 
 replay_again:
 	/* reinitialize for possible replay */
+	buffer = NULL;
 	flags = CIFS_CP_CREATE_CLOSE_OP;
 	oplock = SMB2_OPLOCK_LEVEL_NONE;
 	server = cifs_pick_channel(ses);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index b0ff9f7..9310dd9 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2856,6 +2856,7 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 
 replay_again:
 	/* reinitialize for possible replay */
+	pc_buf = NULL;
 	flags = 0;
 	n_iov = 2;
 	server = cifs_pick_channel(ses);
-- 
2.43.0

