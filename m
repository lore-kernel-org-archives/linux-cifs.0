Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320473557F3
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 08:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786093172; cv=none; b=eVXU/YmTi0MfCuwIA+wyq3fblXL4SOtzK7KmI0TMUUmy0vOKW0KM1hjaszPTRiHUchyj8fzUEmG4O6Zws+rU5HqF3IvTtfb4WLW6PfoF0Wb2v/YbnfEruKebkVfTktw5CQurqQbPLQA+n/teLpeXgxv7TVGdVSIXQXkgDx2nJKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786093172; c=relaxed/simple;
	bh=lycQUOAnHnCKlWsJzRzBVZYu/NA2LWHiqH7liyTOTA8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SHE/Be6s+39CBQD71ymnu7piF/pIthgVjD62PbKmd5b1xfKWDU5xGBbhNzwcHa9wT4fq/RpatkplDhiY0zQiuQ9B20LqGJbEAbvU3uVsjmclCDCs/vupxdlVQv6XGrQKjx0PZcGromWJOGkV3PiRE6K3SMDaz2izrUTCfs0Vp2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=hQ145nOm; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="hQ145nOm"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1786093164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XVaR+RJf5dh7IcrDRXXaodZrI4FbkVV1V+YUPJW7vtw=;
	b=hQ145nOmXMPnCdeCc9zq00NwudKOw1P4UkIVQ4ZjURqJQkmbwJpFVHSiAyCBp1J+2wQNHH
	Gqnsf5qBsIrngQW99uOQyn+fxN+zSCkdjER6uaNNNwpAbD1qxb360Sb70jRm4hJZqRVvyG
	CdRJcJP8KvIns5SMr9TaTbLAgWMte/Ut2S4Zohk2xZZ3xIaqbz5aHFl99lVHgUiUBWQE1L
	T7nsEPJc9wXTIVutDpuMlkHd0aZ6H+C9ocE+ZSmeNoFWV9bEU0qJ5qIrZV4dDlWUL/Z01B
	hOVPLW9ojyARzpQRnTwnmW8DiaCA+WO5KAo3xVc+bLvoAuECWbM+EWRlGBjKlw==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	slow@samba.org,
	mikhail@mstefan99.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH] smb/client: return EOPNOTSUPP for unsupported O_TMPFILE
Date: Fri,  7 Aug 2026 08:58:06 +0000
Message-ID: <20260807085806.725742-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Some SMB servers return STATUS_OBJECT_NAME_NOT_FOUND or
STATUS_DELETE_PENDING when creating an O_TMPFILE.
The SMB client maps them to ENOENT.

The ENOENT error is supposed to be returned when the path
(a target directory in this case) does not exist, while a
lack of support of O_TMPFILE by the target file system should
be indicated by EOPNOTSUPP.

Reported-by: Mikhail Stefantsev <mikhail@mstefan99.com>
Fixes: 3e7d63037a2b ("smb: client: add support for O_TMPFILE")
Closes: https://lore.kernel.org/linux-cifs/75fb5359-b268-492d-8d4a-504d1af60f2a@app.fastmail.com/
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 88a4a1787ff0..b0ddcaa2d815 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -1138,6 +1138,8 @@ int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
 	} while (unlikely(rc == -EEXIST) && ++retries < max_retries);
 
 	if (rc) {
+		if (rc == -ENOENT)
+			rc = -EOPNOTSUPP;
 		cifs_del_pending_open(&open);
 		goto out;
 	}
-- 
2.54.0

