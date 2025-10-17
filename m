Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CB62D7394
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 08:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760690875; cv=none; b=W7vLYjLAB7ooP2gZ+EeDYqyFORqGSjPcIyWIVVUfqAtL9ad11jfb/tcWTtf4rYtnm0+3IVcZhxWODQkRRTITgwEyZlACqqIJ4TD5K1zU4vjtgd0s8NhCl6xW8nNOAuJw9dOns6u2kg7E/B0wo/gIfpO5F1m7gBF5eZ+5iodnJXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760690875; c=relaxed/simple;
	bh=Smwkl3d6C9d5R43QKpDslC7vUv+Zi3b+/WBFLL5/d4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5oLJiX0NVLOEf7QRuBaXioEZuC4RmRUL3uPAwNQCGIys4RLgXDSaUUq79B+2q8Kbo8Um9+agcz/obV02YuGz5AIehnsPXbz7ZqndGtdjXn7kqR04YPNzoLp8QMsVP9AGUiQrNwAqDcWi9E3YJ3niT9zBYrnxFs+Lc+qONuBcFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=koLMRnxk; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="koLMRnxk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760690871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eQckkc68Kr1WClPbN+XkVmK2MPKAUeYvLWYVQK2kNuU=;
	b=koLMRnxkrMt6jAOBgk/S4xdtIwWvyLCBjslANTg11vVCTqT9sDApGmnDDltqD7JexGfDhU
	sNKVKjlaLyfJGLILWBqy5pNU4QrcwH5Zu6393y1cgdiVjoIoeLC5MhZ4j7VgOFeXxacnke
	2u8NtiiKFNK5Y/MruFlNmJmFUtifwL8=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 6/6] smb/server: update some misguided comment of smb2_0_server_cmds proc
Date: Fri, 17 Oct 2025 16:46:10 +0800
Message-ID: <20251017084610.3085644-7-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251017084610.3085644-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251017084610.3085644-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

These functions return error code rather than always returning 0.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 0fb517838325..9ddfc2dbe07c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2168,7 +2168,7 @@ static int smb2_create_open_flags(bool file_present, __le32 access,
  * smb2_tree_disconnect() - handler for smb tree connect request
  * @work:	smb work containing request buffer
  *
- * Return:      0
+ * Return:      0 on success, otherwise error
  */
 int smb2_tree_disconnect(struct ksmbd_work *work)
 {
@@ -2232,7 +2232,7 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
  * smb2_session_logoff() - handler for session log off request
  * @work:	smb work containing request buffer
  *
- * Return:      0
+ * Return:      0 on success, otherwise error
  */
 int smb2_session_logoff(struct ksmbd_work *work)
 {
@@ -5844,7 +5844,7 @@ static noinline int smb2_close_pipe(struct ksmbd_work *work)
  * smb2_close() - handler for smb2 close file command
  * @work:	smb work containing close request buffer
  *
- * Return:	0
+ * Return:	0 on success, otherwise error
  */
 int smb2_close(struct ksmbd_work *work)
 {
@@ -5969,7 +5969,7 @@ int smb2_close(struct ksmbd_work *work)
  * smb2_echo() - handler for smb2 echo(ping) command
  * @work:	smb work containing echo request buffer
  *
- * Return:	0
+ * Return:	0 on success, otherwise error
  */
 int smb2_echo(struct ksmbd_work *work)
 {
-- 
2.43.0

