Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B112F31691F
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 10:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760698035; cv=none; b=FPD8MsDDcvT1ZXkuIHjTWvlKCxefibaaT54loza5BC4rX66kNdb2dG3DEYp60e9Gxiua3L9IOJgpnhUkPHwNrQebMLkqBgdxgpjkQkol+dI/a9VLyQ6hBVFt3PnXN8IgkNsiJpL8h5aOiNJJtFDnFT9xAE6lv45YjzG5qCbjHJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760698035; c=relaxed/simple;
	bh=eN2u31X6J5x8NVJntOJHFD0HBb59Mnua9RH247iNidU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UAEh689g+igt6d82TpF2ue7voRJHiIt7G4aTVfxSym1TZheL+snQ/Z1I+2h4fxEjL7P6pyOaQ+uWu0ZnLv1giJgbKuPcXQ1G+c39hqlmOL4wT/ZkowW+zQ0ByCRh5TZCjJa++QT2mWnoIAS6VBLJzsff4IC2Fc3jhxJs4jibTOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rDBOnWwq; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rDBOnWwq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760698031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=knUWhl/rCiuaCj5yd2AoF5o8+aWC64WgMW1HajB4WgE=;
	b=rDBOnWwq5db3qkKX6EGlGM0VxDI4swOJVT/D4MhkmYZuS7nuPXyDW+OVvzWWTkuqd9xMn/
	voAKgP2AvPu2OdBoPwE5SYTP7yOVwizUaqmLrimvf7CCzFNHcVrYFEHG3uXwfkYnYT64/p
	Zw/nHh6uyT3j4/9hTl0xophXzXO9gv8=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 0/6] smb/server: fix return values of smb2_0_server_cmds proc
Date: Fri, 17 Oct 2025 18:46:06 +0800
Message-ID: <20251017104613.3094031-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

These functions should return error code when an error occurs,
then __process_request() will print the error messages.

v1->v2: Update patch #01 #02 due to typos.

v1: https://lore.kernel.org/all/20251017084610.3085644-1-chenxiaosong.chenxiaosong@linux.dev/

ChenXiaoSong (6):
  smb/server: fix return value of smb2_read()
  smb/server: fix return value of smb2_notify()
  smb/server: fix return value of smb2_query_dir()
  smb/server: fix return value of smb2_ioctl()
  smb/server: fix return value of smb2_oplock_break()
  smb/server: update some misguided comment of smb2_0_server_cmds proc

 fs/smb/server/smb2pdu.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

-- 
2.43.0

