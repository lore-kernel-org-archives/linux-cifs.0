Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5709F2DC34B
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 04:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764909072; cv=none; b=I/3Ff6Y/9n1Y/e5gQWX3WxAwajeQ1S49BGbx9dec3qRiTn31dHbxvXWSGl8w8M3iQwZfGeTOCZu0LIp9Otn+1AeLCS7USmw2qKW9KBUYuKpeQa7XZOSKl9S3EU7DLa9R5KnU+AOJwvOXt/cryAcoDCok9NE7H7xGGvj/yMoDwJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764909072; c=relaxed/simple;
	bh=6HJEMr5X59OEb8//cubWzNJerCMISoQtM0zHJvgTDYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGqZdEw1+PAE9yOmj4ByOeDqrd1ZnAcQkrvRbu/7trlWVrcsNpoqprSI29FNwQG/tTWb5DCMew1Nz7uwOpX04duNr8zV8udwF6pbFwibylSdThJQ6CjSZFkX7fsJ4YMIzv5sqv5aZSwdAD4Xb439EYws/iB10upHqx7paAShhK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tKbhg3X+; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tKbhg3X+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764909068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k+idk5A+mq8aU5amT3grfojWt2+XsKPXn7rdBgtsvkw=;
	b=tKbhg3X+0aIg/R79yoLq+UvKVTRk72dxBCc6JBiCWRP7aU5TO2e8SHW9IAYgCHO/rDg43L
	gmU3dINUgIV+nXmGoJKf0JVJybQRHyp25POa/FGmyY/IvTMsNeQpZ+nasmcaTv3ZCtSS0t
	kmGJN1mBNcgtBzIGMpnpimeeeIp1G4g=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 4/9] smb/client: add two elements to smb2_error_map_table array
Date: Fri,  5 Dec 2025 12:29:52 +0800
Message-ID: <20251205042958.2658496-5-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251205042958.2658496-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251205042958.2658496-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Both status codes are mapped to -EIO.

Now all status codes from common/smb2status.h are included in the
smb2_error_map_table array(except for the first two zero definitions).

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2maperror.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index 118e32cc8edc..a77467d2d81c 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -734,6 +734,7 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_FS_DRIVER_REQUIRED, -EOPNOTSUPP, "STATUS_FS_DRIVER_REQUIRED"},
 	{STATUS_IMAGE_ALREADY_LOADED_AS_DLL, -EIO,
 	"STATUS_IMAGE_ALREADY_LOADED_AS_DLL"},
+	{STATUS_INVALID_LOCK_RANGE, -EIO, "STATUS_INVALID_LOCK_RANGE"},
 	{STATUS_NETWORK_OPEN_RESTRICTION, -EIO,
 	"STATUS_NETWORK_OPEN_RESTRICTION"},
 	{STATUS_NO_USER_SESSION_KEY, -EIO, "STATUS_NO_USER_SESSION_KEY"},
@@ -2413,6 +2414,8 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_IPSEC_INTEGRITY_CHECK_FAILED, -EIO,
 	"STATUS_IPSEC_INTEGRITY_CHECK_FAILED"},
 	{STATUS_IPSEC_CLEAR_TEXT_DROP, -EIO, "STATUS_IPSEC_CLEAR_TEXT_DROP"},
+	{STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP, -EIO,
+	"STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP"},
 };
 
 int
-- 
2.43.0

