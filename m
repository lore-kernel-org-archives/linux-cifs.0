Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6236E2494F8
	for <linux-cifs@vger.kernel.org>; Thu,  5 Jun 2025 13:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749130885; cv=none; b=iRODzeNsPKsh7tJtJU+Hul6BKbkBZjk7QPqJMVM0ZuJCJLRqqEXIHJ8v19KG8yvCYgyi5Ru5a4aQ6SQBbUo3qqKKQDbbyFMTBzm7HYl+/J004e99MMlWYq7kw5qRLqSKCDWX7TtrCtbl1FSbNvZMFyVJ4T5ijUJ9BjO8DLo6+zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749130885; c=relaxed/simple;
	bh=P5yzBiQ+4hI4siYXXGuj2tz+MFC1SDb07H796+3+IUw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XIKO3MpXLrbcyDZ4tQUoeXh/LyAvKQCU4uiNjaMJC5sdIOLFmguLxySrTLPW+PHn/SBrIG28OStBmhQ/ztbr1FvR1Ij6WFOX9F19qlbtgLCOdSacV9PuIUSHfTWyWQV49iv6OTD/V4aTaUQobMPP/AB+QRU+/LuubnMU0HN9OfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Di9FqTwu; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Di9FqTwu"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-742c9907967so953833b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 05 Jun 2025 06:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749130883; x=1749735683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VkZ6TqCNZ13NFq697O2SD6r7qwbelGEP+fGXlArQKj8=;
        b=Di9FqTwu479GKiAQ6YG+v8KcJ8ga2TmXuefxS9UB1vI0kicF7tGMnREf6qVshEWc1f
         xzW5nJKpaWnOgLW8Eebi2a0OkY5DSqdgWJNeb6sJHbhqM/1yNQBAvu43XuB+9uF5ay0u
         /ODox9Ly7NHMMNI83/gCp7Ma5Z3ZwcbMb6iCROreHSsHrvSAWPgTRSQA8QAKgfwAOWcx
         qzG3t62AZ/YekIr2lulCzt52SrU5AFeHbO2GbCT2/xMY3ixKDFQsAdhgg1yqeZU045CI
         DkH9NtoEMQTp2Wafa8Dz85UpVt2Hj6kUWS4hZbzuqZQ4E67Wk2N8Xmo9Ru1bWLrnLbWj
         AKeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749130883; x=1749735683;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VkZ6TqCNZ13NFq697O2SD6r7qwbelGEP+fGXlArQKj8=;
        b=OvfRxZ6fmJuSCiSD2MyF5Nvt/O4dNUSgGbu/QufqzzP853t4h7n7LjTIDt+kr5XJDv
         QTGBBtqZwxEUAR9030lsp41x4uvJebcwPXx+QkYckPj6JsOQXadOkrJgMuslG9ARtuYk
         nJAWQEAKa+C83WqAWi6QsjCxrxoTBrk+4l1DSu4C5zd3JGZ/QTJqNImIIAQcNckUolyf
         U/5GPkTzeXBms9SbT5nIDEBAUYjAqo/A2HL/D3ZTn2i1FxUN3e2nNqpokEdV4gjZvD7X
         1Tpf7l0pBzs9Ia6zmvtdvSBCS6oJzrTdmtSfXL+yLdpaEmCCQRptjthq/S4Rnt2dX4Cz
         RPNQ==
X-Gm-Message-State: AOJu0Yw2FjawSrnvHW8PR0v/EAOAtbjxDXV1gPFQ+mplTL+bI2kVi5EB
	JEnHcJKjpseXdCNq6D8cyzuZu2I708Qx+qwa59s/pRUR7jIWYUUk1Q9j7irJ/w==
X-Gm-Gg: ASbGncvCKsbQJc9Vai7Q4qBQfotPfauau2+zFojxCpjDdq4pQwh0hjIQAvATfzCykWZ
	c+IndPCVDMaHLvlEbBTv99dF5ltfqQwG81K0MbshyxFPrBxnK3kK918qoG9DKE3VKRdqwqUQsyS
	dQcygeIcwOBug3649mutlZCpwLUvdRiqwS6nK93rVOe/4HDvW+WRElDfJnd/04hr37XeJpPdtWK
	c0OSbzHtf3saN2NJFr5iG91heQiptRVeDlDK2jb3e97f4V8e4sDBPn+ZptYhwg7Bm2fxGwOv5mn
	8/EiOr+BprTizte4kTiNemIFxLoJM34ArVjqdm9SE2VAIR6HQH+ZuN1Ce/yHqgydryxB7ZDKNog
	h8Q==
X-Google-Smtp-Source: AGHT+IEjM8d9YGkIMDaQKJQycbjWeplANZT0QM1w/0J0H5uET33zOz8RyK17ATlbxHhn73muHGky/g==
X-Received: by 2002:a05:6a00:2e9d:b0:736:35d4:f03f with SMTP id d2e1a72fcca58-7480b23038amr9674445b3a.6.1749130883052;
        Thu, 05 Jun 2025 06:41:23 -0700 (PDT)
Received: from met-Virtual-Machine.. ([167.220.110.137])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-747affafbedsm13285677b3a.102.2025.06.05.06.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 06:41:22 -0700 (PDT)
From: meetakshisetiyaoss@gmail.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	nspmangalore@gmail.com,
	bharathsm.hsk@gmail.com,
	pc@manguebit.com,
	lsahlber@redhat.com,
	tom@talpey.com,
	sfrench@samba.org,
	linkinjeon@kernel.org,
	metze@samba.org
Cc: Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH] cifs: add smbdirect.rst to toctree
Date: Thu,  5 Jun 2025 09:41:15 -0400
Message-ID: <20250605134118.31162-1-meetakshisetiyaoss@gmail.com>
X-Mailer: git-send-email 2.46.0.46.g406f326d27
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Meetakshi Setiya <msetiya@microsoft.com>

This patch fixes the warning thrown on building htmldocs by
including the new document added in Commit b94d1b9e07ba ("cifs:
add documentation for smbdirect setup") to the toctree.

Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 Documentation/filesystems/smb/index.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/filesystems/smb/index.rst b/Documentation/filesystems/smb/index.rst
index 1c8597a679ab..6df23b0e45c8 100644
--- a/Documentation/filesystems/smb/index.rst
+++ b/Documentation/filesystems/smb/index.rst
@@ -8,3 +8,4 @@ CIFS
 
    ksmbd
    cifsroot
+   smbdirect
-- 
2.46.0.46.g406f326d27

