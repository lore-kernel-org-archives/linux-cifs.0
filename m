Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C801A386435;
	Tue, 23 Jun 2026 02:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782180934; cv=none; b=Byg6j6rV9oC93qI5UlP1jA4tB3Y9TOkB6ESxwPGEEL77knBkJhRZgo8HRRlK0uucya0nNZphDYS348BPKUPXp59nZ+zFaYestvVg0RX75f25kxUGtBEky1x1d6tqwXDlJrPnMLB5zq3feKqxMYzzYPnZteXAJoTGzvaTICezzyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782180934; c=relaxed/simple;
	bh=AVxhpRr5AlufyL2yvnK59j/qyOC3vot32OO9c3GS5X8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ps1XUJNQdrj5OAF41FSIsztOA7ksj4ZTkNV2QUd0jz9wPcZz/4FbgRD4LmcYTddwJY/ExnuhpApZ0YzZdA4w0mp4eR9KUE/TuSRgMLXbOLKeVgHwtO9/8vQ9gJ6BwL9gHjDARAdmOrIltNzAGpKUeT+tQW+/jJrcWQ6zLTuGATA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=EIy+CWHx; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="EIy+CWHx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=4f
	6Jfo+mG/T9E4QJhQsu20qN2x2nr+Fb8wecUKTHNOE=; b=EIy+CWHxZ/xu4aUuRc
	hm1pzqv6V93qlDql36gr9znbHQuH5GKXDHWCzLGk4GLtk6jzhj4DK0+gf0gIRbd6
	3y9pbc7HlXlzTeUMffsK3X+TRkxdqkQUZZgQO5Zdjg3yi1BUha2CXzbjUuhv+zdD
	BG8DaYhT6i/HWuhyXxQaBg6O8=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wBHoRic6zlqtQaHEg--.49611S2;
	Tue, 23 Jun 2026 10:12:48 +0800 (CST)
From: liuqiangneo@163.com
To: linkinjeon@kernel.org,
	smfrench@gmail.com,
	chenxiaosong@kylinos.cn,
	senozhatsky@chromium.org,
	tom@talpey.com
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuqiangneo@163.com,
	Qiang Liu <liuqiang@kylinos.cn>
Subject: [PATCH 0/3] ksmbd: fix some memory leaks in ksmbd_vfs_* functions
Date: Tue, 23 Jun 2026 10:12:35 +0800
Message-ID: <20260623021240.34722-1-liuqiangneo@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBHoRic6zlqtQaHEg--.49611S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4Ra-erDUUUU
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/xtbC4AAMbWo566C10wAA3-

From: Qiang Liu <liuqiang@kylinos.cn>

This series fixes several memory leaks in ksmbd_vfs_* functions,
where dynamically allocated buffers were not freed on error paths.

Qiang Liu (3):
  ksmbd: fix sd_ndr.data memory leak in ksmbd_vfs_set_sd_xattr
  ksmbd: fix acl.sd_buf memory leak in ksmbd_vfs_get_sd_xattr
  ksmbd: fix n.data memory leak in ksmbd_vfs_set_dos_attrib_xattr

 fs/smb/server/vfs.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

-- 
2.43.0

