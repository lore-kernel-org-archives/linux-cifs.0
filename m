Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23D82F3C19
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 11:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785498662; cv=none; b=SJAf8zOD2ow91dyrcOpBV4EaDoHMj7FyeyXE3B3R1wRDEZzPEJ1UJcvOtVXCGyOv6xHvJKMh4eHb2YGAS0AqTtHsjEFNJXMUpBMEZjQIYyBs4AhFnS+WWJPAKrQQNzMTZDzmfoGQiKytNKJSomB6xPaH5jbZNEJmmRMA1DiXSio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785498662; c=relaxed/simple;
	bh=303MWsOwZTOfr/I6lepY3TOxI2WPzGih3pGeRIZtzQc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YiEU2Vfy3IgKB8ztUiZ0BaNhUmRstBq8xcRFNF0+N0Pl13VLrmC2vbW8vQPqSREzl1Cr8jPW6hf/v8qxHwKIX9a/1tloLkGrJAtQzUfHImD/z3Is+ex1QQtiDFVfbdZJZWik5ZxjTOH2IomC8uclOiA6ghm/9U2h3+MX46bCyOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TJbRO3ha; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TJbRO3ha"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785498655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8SC2GEEqP/elNoRqL7on9zUmyRahh+EaYh7NXSkG3Ww=;
	b=TJbRO3haCtqGBEO0phlY7TBrs83zGxIYK9wr9OhuUPKXSbsN8Fr3RBIJxeNa9xP2k2Cj9Q
	BKCQmZlNSSQ++3Bjtawdm0sJk1jTo3LuTHETpl5Z6+swoB55hAZGNEMIotBPb3gMhfa9HC
	lm1jH3SPsXgxq0jFMZbqG4yGd78RYm4=
From: ZhangGuoDong <zhang.guodong@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>
Subject: [PATCH 0/6] ksmbd: fix some bugs
Date: Fri, 31 Jul 2026 11:50:02 +0000
Message-ID: <20260731115008.111211-1-zhang.guodong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

ZhangGuoDong (6):
  smb/server: fix null-ptr-deref in ksmbd_ipc_tree_connect_request()
  smb/server: fix memory leak in ksmbd_vfs_set_durable_owner()
  smb/server: fix invalid pointer dereference in
    ksmbd_stop_durable_scavenger()
  smb/server: abort initialization when proc setup fails
  smb/server: call ksmbd_proc_cleanup() on module init failure
  smb/server: preserve error status in smb2_handle_negotiate()

 fs/smb/server/mgmt/share_config.c |  7 ++++++-
 fs/smb/server/misc.h              |  4 ++--
 fs/smb/server/proc.c              | 13 ++++++++-----
 fs/smb/server/server.c            | 10 +++++++---
 fs/smb/server/smb2pdu.c           |  4 ++--
 fs/smb/server/vfs_cache.c         |  9 +++++++--
 6 files changed, 32 insertions(+), 15 deletions(-)

-- 
2.54.0

