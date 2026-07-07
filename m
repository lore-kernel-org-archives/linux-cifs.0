Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D2B3D9DCD
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2026 10:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783418483; cv=none; b=QOVB+y/M/0Mmg/VI1REm35pnqga8a+4O9WRjIUntlEis+KH+xPcNUuiyQAMidHyFgxBgKn1loJIkVp77a/qp8fGP4x7Q9s9vXoq/ZnzTU6Y+7qykeb36vGxO/HnmaEs516Kn/JBfs7J92iNhlTum7Pcr3uELTHtt85Xg34G4V7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783418483; c=relaxed/simple;
	bh=ucCyWyla5jTUxTuzQITBGV+yWLyiZ/uttThIMc24Fdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCPIoRgJDJqcT1fJAp85g3zlvgqOoovO6UCQ4htVaqi7hNZX8hTAwAXkrcepVdB66fANJA6Sql+zCrP1DVyTBg3SBrMTVmpSjU6VU0J+c6NQGppfImz2FVnAMZTf5iWKlP8lClwjZxLmAupHqLR3UTmcQIRxTD1mC/m3KKmkMf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V65z2LZB; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V65z2LZB"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4703bc0a99aso2191674f8f.3
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 03:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783418480; x=1784023280; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ILzTEGpo2ht7KKHhllqj3hCcwvlr0qj3it5MAqhgdA4=;
        b=V65z2LZBcuOK8gF8EKeSVyPoOMe3oar9noQPceLiTFop2dehO64cpI3q6E6d3moTOq
         v5NrHbupcFxyafEIk2fyn+1WZ3Xxpja9dLnzKLXAg07C3EV6WiihQq9K9WfuU3lL+jUO
         fQMaDAZ53cjlN4SXZyj0LuO4b7/CBKKdiIRYuPUO+CsKcHbAw/S40oI+HTGTUljkPZa+
         2o4Lo9UGLNUZXHemrP7G8jyOwI7YWrRTf6PRPnX8O1PjKYQh2R0vk83Qr1OjZYaVnGbT
         lEIAYgWhvzurwEYG+w+zRqa6fKBtJbNFWUGa4Cj4AWG/UKzJLhLy8JddGXQMGySze3PQ
         ivbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783418480; x=1784023280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ILzTEGpo2ht7KKHhllqj3hCcwvlr0qj3it5MAqhgdA4=;
        b=RZfi0wd0+6hMn5MZ2yjNZD5oY5LGro2BABzvpdUB3lgVNYkoXYqMSMyjr2Y7/ApxAJ
         kjznOtYMWyPWwo3YSBVAhGqo7UXeezVkrxaZKjGW72fM6Yy59X0TahokiFcARwIizlZD
         avY2ple7olNdR6rpormWnbKaSugwA8t7yO8qp3kji1oLhI2TAwJ9FG2g+c/4dpt4ifPk
         wEjIzEnGm8NXQwIBLfN3aHpLF9R8AG3dKopZc4/ydIt+L5wTorJIYk1HO+jj469R/sEV
         txrcFB962Ol+iAJtFwpEOplXj7iN6Txhr6ta6YaKkbe4O2CaT64cldy9gMLHpd9LsbSf
         3J7g==
X-Forwarded-Encrypted: i=1; AHgh+Rr4KcUwK+qOJKfDurwqRLEfZ+9ZYsQEA7Ja3p025vELY8aEf+XMAeaUgt8x7MAIGU66tqHGX8tZ5HGC@vger.kernel.org
X-Gm-Message-State: AOJu0YwwB7JslH8zHhTFWt3HCgT4IHxZ0BD6H0SXuKzX00cdktbdfGvp
	tzfxCppXhkSoJ3Q+dhAqLip+JRLfrD4XWb/RjJnqkfOwKDxnbax/y+f+
X-Gm-Gg: AfdE7ck1sBQQeG1orhFOwS5oS5JLThpEgDW9xfXMN6jSZFG31jxY/yeZ5JhILY8doOF
	DtUfmn+tiSvU74QTIirajdfNCCiMbDl/zixpm3AUYgS1j4srY62482PWOJ3nzC2zPNexVOCca2L
	rFcFS0B8SC1AP4CWyEl2w1nUqqZcBj9RPVOfRS6/OKa2EQgBL4wSOf5JTBZbyIrujjd0fS5xMtv
	KIxI659KAJu5Ge4JlmTBkODZAstbDEijYFnk3QBNyCOpZZHiXgT1oDMwiUPg6feGIUuRZ60/SSl
	8EOxm8irFz0B4NaMZifeVWWLH2qGwMClwon7f6cgtOl8517YNLMaRhzPnXFm8k0S28rUUkj8FKD
	prfW+ChOPxatsw8x0REQRjC+VQH15hXSeCiXUyxzlL9ASovV/a3Xr5q6LU0Tc1Cem69DeDhYY8g
	DTQnODQtLnaUItJkzjMYZ7ZeYAq5FQSYkX3Cs=
X-Received: by 2002:adf:e34d:0:b0:472:c426:2ce9 with SMTP id ffacd0b85a97d-47de666b0d0mr4059215f8f.12.1783418480333;
        Tue, 07 Jul 2026 03:01:20 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0960634sm33908295f8f.26.2026.07.07.03.01.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Jul 2026 03:01:19 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 6/7] ksmbd: fix stale sparse-file attribute after share reconfiguration
Date: Tue,  7 Jul 2026 11:55:06 +0200
Message-ID: <20260707100033.47512-7-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260707100033.47512-1-g.blivet@me.com>
References: <20260707100033.47512-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

smb2_update_xattrs() copies the DOS SPARSE attribute bit verbatim from
the stored xattr into the in-memory file attributes, without checking
whether the share is currently advertising FILE_SUPPORTS_SPARSE_FILES.
A file whose xattr has a stale SPARSE bit (set by a previous client,
or from before the share was reconfigured) would keep reporting as
sparse even after sparse-file support is turned off for the share.
This matters for Time Machine: sparsebundle band files rely on
accurate sparse-file status being reported, since macOS decides
whether to issue FSCTL_SET_SPARSE based on it. Mask the bit out when
the share doesn't currently advertise sparse-file support.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/smb2pdu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index af957d013..d5d88d023 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2940,6 +2940,16 @@ static void smb2_update_xattrs(struct ksmbd_tree_connect *tcon,
 	rc = ksmbd_vfs_get_dos_attrib_xattr(mnt_idmap(path->mnt),
 					    path->dentry, &da);
 	if (rc > 0) {
+		/*
+		 * Don't report a stale SPARSE bit (e.g. left over from a
+		 * previous client, or from before the share was reconfigured)
+		 * when the share isn't currently advertising sparse-file
+		 * support. Time Machine sparsebundle band files rely on
+		 * sparse status being accurate, since macOS decides whether
+		 * to use FSCTL_SET_SPARSE based on it.
+		 */
+		if (!(server_conf.share_fake_fscaps & FILE_SUPPORTS_SPARSE_FILES))
+			da.attr &= ~FILE_ATTRIBUTE_SPARSE_FILE;
 		fp->f_ci->m_fattr = cpu_to_le32(da.attr);
 		fp->create_time = da.create_time;
 		fp->itime = da.itime;
-- 
2.43.0

