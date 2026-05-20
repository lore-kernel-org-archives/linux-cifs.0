Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374333A4526
	for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 15:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779291441; cv=none; b=K0t4NT9a5L+6oGC8MU+ctKdPS2xIJ1E1n77qAlsXMcxhjxuQWhUo6zG78j0r77Ynj+QcNpCFmYL9+ELveRHGKQ+hM7zmMIAi8yEe2EviDnFTWIi0IG99bs9DW6TlFExOaoUVgMqiDbIxop/e1WxnuoJkqeIsrLBmuUoUXY/oxzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779291441; c=relaxed/simple;
	bh=YwQcBoRIGqPEdNfYXBzTIfW5ffpv5+H5Wem34GfvO0M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KtpKk+0+bt2jNZOmV1FJk0zL6x0dJXQQ237zPcFmSWgHt78rJJSENdfHOPyENAaCXObQ8wlV6wzSTOdjQZnC/0YMAxtLuL04QVk2vfVXnZbu1YJU7viwhWWE6F4LIEuDvC83ciloDu9WIoe/5A35eLgM4lz+KcerCTuOr2aQOws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=I1Wl+FHx; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="I1Wl+FHx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1779291434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=M9Lz6gEe5ppYqChWsfhI7YjFC/yjaJa7wGBcYdl/1gM=;
	b=I1Wl+FHxOtmNUCB6IToEJYLF7TvKS5kF9qOXEBPleH59q1jwkYj3TlyPVSBsjAsGj08p6P
	0f6XFV8xmIfXXJZDEIX07waT7sMEKz1Ktb8WnMRs9OfMYcwGOjTKn4imUexvEPXCBfykn5
	a4P4Zz4ubXqLkXWf0VfQTsLXR94LRKHrLGg2jgSU2naZM166KCespgXsiTO6v9oOGA3UaO
	6Jx52YXISnaZq/Ai2qNwa240ZfE05FdkFxz7WLkK8U19NgaVj0KOCxfeyC5+32WCdxKhow
	EK/InYeRHtb2zmNIJ9zskqp3jWLa9Qkjgl6RzsjX6O5C3LZEdow0fnytkK9Qkg==
From: chenxiaosong@chenxiaosong.com
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
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH samba v2 0/1] smbclient: cancel pending notify on SIGINT
Date: Wed, 20 May 2026 15:36:06 +0000
Message-ID: <20260520153607.347960-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

I also created a merge request on GitLab: https://gitlab.com/samba-team/samba/-/merge_requests/4530

v1->v2: `sig_state.cancelled` is checked before `cli_notify_send()`, because `changes` needs to be freed.

v1: https://lore.kernel.org/linux-cifs/20260519095113.289692-1-chenxiaosong@chenxiaosong.com/

ChenXiaoSong (1):
  smbclient: cancel pending notify on SIGINT

 source3/client/client.c | 53 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 3 deletions(-)

-- 
2.54.0

