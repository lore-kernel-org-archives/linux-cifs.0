Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D5A31D37C
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 10:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760698048; cv=none; b=MjYIRT8Mb482zAVLbTSRD0sNX842e0vxvU1fpzvz8FAT/tMSEMrDfvg5tptZctP/9Vh3vK2I+ms0h3Vi90yZs1oqSZYK+b+21w58TCCyumyaSN4oIKHbdOOlUxvZwY6sD0G4yjZgVhxM3SqCjeYbPkMYDdOi85azWNtgiD3KEXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760698048; c=relaxed/simple;
	bh=nZUS6gfRCnWHR2PlTcF00h3XbFItns9vJu+Zy2lv5S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkhhDMHqpMg9dJQJcQwXFrFTc8wDIbnd2sDNtpOITSedksVTGpNPnr8ilPU0KCJTWK8b8zoalXWbYPz9w8R9HqUzjZV36yfu+WTl5ql+LFz1nhYjPQGEDxq8h3tgEKchLER4pMSOpRVempVHNhNjhSgALB3oVoLUVIp0qHYZfEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v8KMjGQh; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v8KMjGQh"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760698044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y5efMjCW0y1u13VzQpJkPhSCCtNBBW6zz612984MrWw=;
	b=v8KMjGQhoUYaY3C5qNU49rQ4Kg6dzWiOwOLv0CfqnDhrKbdAJEDeOfWp8S83740S7OW+4h
	56+Rjpbx39c7lCWMVKj4k7GVhfTtRZJ/tmf7qjxmVaOxT0Vh6B6f6PABavrnnajUDLLalB
	6/k1vXHH6R+U2LRu1qNTeDDO3GLZV/4=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 6/6] smb/server: update some misguided comment of smb2_0_server_cmds proc
Date: Fri, 17 Oct 2025 18:46:12 +0800
Message-ID: <20251017104613.3094031-7-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251017104613.3094031-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251017104613.3094031-1-chenxiaosong.chenxiaosong@linux.dev>
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
index 06e4c21ad4a8..52cb0519b974 100644
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

