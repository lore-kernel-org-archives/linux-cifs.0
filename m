Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CC222D4FA;
	Fri, 20 Dec 2024 17:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734714786; cv=none; b=X674fGa065nDkoKe/i4sSmhpouJdilAm7ytA/Dxh+FnN7mL9V5hAeJrZxCs0+7UxaYeNd7BxcZUtvERG8QMd4m7CJb9HoTINT9V20kJnoaKmogfIJ+ztXX7R3i5W4U+X6l6cgGy3LwFBS/o4oNLXEqnVG47hCBmPNHb1Tylvmgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734714786; c=relaxed/simple;
	bh=IUjWI+KygGxpGb6JInWYGBFlH5iR4LyIwmIQ/7Vvw4Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jkc1RvauaIJuoMZXA/+0ARp8AXrURWtKjsNLNRDf69ZNu0azUGxMpe6g++bxwCSl0P/e3pf//9QWIS6wSpx4UFWgCs1Kpw8wX/+kt6qRiUXLg2e0cH4/jhZPYqD/nlSrzTye4NJBkqktzGOSqovAIs8hhKP4BcmWR4Qym45xrns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=letlM579; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="letlM579"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97D0C4CECD;
	Fri, 20 Dec 2024 17:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734714785;
	bh=IUjWI+KygGxpGb6JInWYGBFlH5iR4LyIwmIQ/7Vvw4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=letlM579qn5VXrOLoVS0Eosf/9DbKBEmTc7TFHQwhyFhh9cRJ1PK1FYAgYeCh6YPr
	 OxkM0/+Z0TV4JH4JCbWAsfLv+OjlKNVTadbyycwQI5mGQI6kBrVXrt61s5TBdFjlOI
	 qCu9eQc7Lsrw+aPllJoUI64DEPEBwoHUbKjZWa2ihSnSII+DEVCDX8kuz4z+fWxAjH
	 i+mC6fZLphuNsKFL6p4sDO7VNoA7rNUoSY7iDLivZ80UES5IyGGeqnUm0HanBEFnA1
	 D5qhaWnEOtIMZ8Xf/nUe9sRXyU0+UELkw/Ra+u+ZydcnlYLv2vd9ssDDb6k58YZLD7
	 BIbVtJVrO5SGw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Hobin Woo <hobin.woo@samsung.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Yoonho Shin <yoonho.shin@samsung.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 10/16] ksmbd: retry iterate_dir in smb2_query_dir
Date: Fri, 20 Dec 2024 12:12:34 -0500
Message-Id: <20241220171240.511904-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241220171240.511904-1-sashal@kernel.org>
References: <20241220171240.511904-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.67
Content-Transfer-Encoding: 8bit

From: Hobin Woo <hobin.woo@samsung.com>

[ Upstream commit 2b904d61a97e8ba79e3bc216ba290fd7e1d85028 ]

Some file systems do not ensure that the single call of iterate_dir
reaches the end of the directory. For example, FUSE fetches entries from
a daemon using 4KB buffer and stops fetching if entries exceed the
buffer. And then an actor of caller, KSMBD, is used to fill the entries
from the buffer.
Thus, pattern searching on FUSE, files located after the 4KB could not
be found and STATUS_NO_SUCH_FILE was returned.

Signed-off-by: Hobin Woo <hobin.woo@samsung.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Tested-by: Yoonho Shin <yoonho.shin@samsung.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 12 +++++++++++-
 fs/smb/server/vfs.h     |  1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 12784adebe36..a3231fca351b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4225,6 +4225,7 @@ static bool __query_dir(struct dir_context *ctx, const char *name, int namlen,
 	/* dot and dotdot entries are already reserved */
 	if (!strcmp(".", name) || !strcmp("..", name))
 		return true;
+	d_info->num_scan++;
 	if (ksmbd_share_veto_filename(priv->work->tcon->share_conf, name))
 		return true;
 	if (!match_pattern(name, namlen, priv->search_pattern))
@@ -4385,8 +4386,17 @@ int smb2_query_dir(struct ksmbd_work *work)
 	query_dir_private.info_level		= req->FileInformationClass;
 	dir_fp->readdir_data.private		= &query_dir_private;
 	set_ctx_actor(&dir_fp->readdir_data.ctx, __query_dir);
-
+again:
+	d_info.num_scan = 0;
 	rc = iterate_dir(dir_fp->filp, &dir_fp->readdir_data.ctx);
+	/*
+	 * num_entry can be 0 if the directory iteration stops before reaching
+	 * the end of the directory and no file is matched with the search
+	 * pattern.
+	 */
+	if (rc >= 0 && !d_info.num_entry && d_info.num_scan &&
+	    d_info.out_buf_len > 0)
+		goto again;
 	/*
 	 * req->OutputBufferLength is too small to contain even one entry.
 	 * In this case, it immediately returns OutputBufferLength 0 to client.
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index cb76f4b5bafe..06903024a2d8 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -43,6 +43,7 @@ struct ksmbd_dir_info {
 	char		*rptr;
 	int		name_len;
 	int		out_buf_len;
+	int		num_scan;
 	int		num_entry;
 	int		data_count;
 	int		last_entry_offset;
-- 
2.39.5

