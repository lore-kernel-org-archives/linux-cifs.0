Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795323528;
	b=AKtaWrEltrvQaiLwx7qBvfgpV7SJWV+UEXumqgm2B+zZ3YuexpeYNnrFWnaJ9Mu1dkOH
	 V+2HQ8uNyhnOye6EkGDuqieQHKnh/aVH25MqhU2UIbzAElXHXL1Jpq150lD2SQH3hO6ho
	 sZGoYCEVEmJk38DPDEiwwU+BXaiJqruHX4ytPKalP3RC+StLTnWcpq+XZudTPyrGXvFPw
	 7Zwbqm8wiwvi6aNQ9q0Yp/XAePvmCq3ZT2AO8+WcjzuVOL+yAqvKfjQYOv4K5UoioWAb2
	 4Sh5BIj3NoNnoYr1VCwQxGtxL/0VLhtgxiWVo3NwFjj+iK8uurVb5FKA19SMQGvpLTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795323528;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=F3QLio3AscsLh+2pvh7N6KImPKdVE87TLT/zX5+h2pQ=;
	b=YdjmYXA5+0rixI9IeK1eD1fYsBVOS1K+tNGjDLtLWiPoTf5Oes1ExRGwlgO9YDLE/lU7
	 ChX8NisTymptAAtKUM5uodbY8gQTWsmtSRd0yWFYobb5xLIwYdm7PQSMEWmGtTMWBfxkv
	 /WQtTksGEDaJ1nLO0uWfhEnvCsoesAtOXIqCsXoczhyWcsFL2z82c9by69JGDAEOQ8aAD
	 Q1vLlTjsstLMhSh2TbIsDc0BouoDrBNujbs/57GhEUutys6DruIqZ2+6PJ9PEiAaGCVG0
	 bFK3VeBnKK3mC5uRMFi70BTNhEpZzWQot4WA4wxrig7lcOxndrBZYb4jECQYeN6ZifA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iynhWeN4;
	arc=none smtp.remote-ip=74.125.82.175
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A95A606A32C
	for <linux-cifs@vger.kernel.org>; Sun, 22 Nov 2026 04:58:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A95A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iynhWeN4
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-38587f3de36so2704343eec.0
        for <linux-cifs@vger.kernel.org>; Sat, 21 Nov 2026 20:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795323527; x=1795928327; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=F3QLio3AscsLh+2pvh7N6KImPKdVE87TLT/zX5+h2pQ=;
        b=iynhWeN4gpV9WpcFJKJKQzv0Npt/bxr3E+iEa25Y2BjgaoxbpHvQdMsIBpsXUqerDj
         hedLrg/AhtkD8omOXtvSx7eH54EXEEu12XQ176IdCTDFkwdup6Ugwtlpx8L5Ds8O8N29
         rDnXCcVlQVR/yFB5Q7X06MJj/jRhFN7wjwzhNd8Mne7eo9zwXwMaTj+Ah6I+6voLT0By
         2wy/oBR6HE+fgXhNtfQl3qPammeOevGEP9NTMhkKDpOh0pOr3uipEG+CLTOK85gQGfcb
         7lDGq5aiVc1Z5IG9fkwyPybbcCKKC35L6dgifD9POJBeyFs1l7e8TxpwHNdoSuFejvKp
         2FrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795323527; x=1795928327;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F3QLio3AscsLh+2pvh7N6KImPKdVE87TLT/zX5+h2pQ=;
        b=l5p2Yerz4GPL5zxSfF7j437FVkCffp2w1trjGtXyHfVZUVxbmGzfmLlu7nOOaeBOtH
         wQXy5MD29kHLgkdEQSsifK+m1sQu2C8iTYrzwbLG/y6AO378rj6j70Cj2teMHiyB/bMx
         NkQpFN1lHn9fqQrDRRKNTJaQQTGJ6dNzkG/mb9OW+TyJnknOI3riWGSoFoprGTD+E/fw
         Pz6RgNyrEDVQsjBbOY4PTjtnMl3vp3tkOJCHL8sfqFJsbnGXBBVB3fykJPqcJ1uU3MzQ
         oWtNFFy6I0Oyjvm0TwaCAOEk1zrh61SSAHCh9Y/EH8Mo/XnNeOdz09lYeUe17G5sfjcF
         GSMw==
X-Forwarded-Encrypted: i=1; AL+hErGDB6dHiBzROREqxnDGXAqgfkLHl2MuP8mMmNmfBJ01pAWg48YF+NwjMiuerDli+/XUZ+VkAxHOpJi/@vger.kernel.org
X-Gm-Message-State: APuU4Z/OdlyO750s5h5QWActtUzZTntHUpSWgZIGLOlbyv5f2o4i48ff
	rlSjtSIKV+uSFKrry1fjqZp0IB40unkBpAteNUsvHwFobAVvyGP1Uu3J
X-Gm-Gg: AZFdTZdtr9U11F7l8s2dvEEWuTkZlHeE2Z0HZZbTPSheKyJJxFZmmCOXg9yKSIgw0xE
	3mYIixstb+vSsdRwZuhJUlz1U6x/wv2rmVqEotlKUQyGyMLHEYBnvbdb6PjX7WNMBV4xu+/zvxa
	TiqrBSu3yENBAxbnpEEmVieay8q3AKXD97sP04p7/nPIiyBC2w1ZSHKZUeC/4+0oXrp8tVhFB4V
	Gfk/nuOQ6e/q9W8+9Bs9PlfqSVZw2UFsbxyCBnuxSwF1xJrBfAZc1Egbah6HZ1GZMRotURNRjvT
	d/NZ8mx0zSNV+7OsDevBUGeIk5NzFJY1gfp101iecutWnVOccLOhegaBtU0ywJVi6Fue0odVC7k
	chYmV4C7YnhFr5qP1Xz38DsgulvaUR5pIQhAwYcX1qNYlDSGHijvWKaycsNxv3HDJrfzY2iLibf
	8jyvEzAzFfli1JWxdGbxFZAvj8uBuXnwDd69D003GfzLfmtUfMw//gfhu6VuV989JIXHQzIsZtZ
	Y9ufgV7jUaRl/uAp6lMa4ldYPjCp/7XyAA6SGTGxl3gtyG3GhZ8WDL5rVFuK7mRF6gqXpB504rp
	ScRSGKEpbv1sANjGFD9U7XiQ9bL0jTF5RvhlW2b1qkNX4o1AwvKe
X-Received: by 2002:a05:693c:4001:b0:370:d6e4:e8aa with SMTP id 5a478bee46e88-38570b34fecmr8521946eec.41.1795323526357;
        Sat, 21 Nov 2026 20:58:46 -0800 (PST)
Received: from fred-server.tail1cd3ef.ts.net ([2600:381:4c20:1067::7ff])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385646633d0sm38865118eec.3.2026.11.21.20.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 20:58:45 -0800 (PST)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: convert DFS target node name from cache charset on mount
Date: Sun, 22 Nov 2026 04:58:40 +0000
Message-ID: <20261122045841.99012-1-fredric.cover.lkernel@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_dfs_target() converts @path_consumed to the mount charset using
dfs_consumed_to_local(), but @ref->node_name from the DFS referral cache
is still encoded in UTF-8 (cache_cp).

In dfs_parse_target_referral(), passing @ref->node_name directly to
cifs_build_devname() and smb3_parse_devname() copies UTF-8 bytes into
ctx->UNC and ctx->prepath (and mixes encodings when @prepath from
@full_path is also non-empty). On mounts using a non-UTF-8 iocharset
such as iso8859-1, subsequent path checks re-encode these strings to
UTF-16LE using local_nls, corrupting non-ASCII characters on the wire
and causing initial mount to fail with -ENOENT.

Convert @ref->node_name from cache_cp to ctx->local_nls with
dfs_cache_local_path() before building the device name so ctx->UNC and
ctx->prepath stay in the mount charset.

Tested against Samba with iocharset=iso8859-1 and iocharset=utf8 for
both DFS link referrals with a non-ASCII target subpath and mounts with
an additional non-ASCII prepath, including reconnects.

Fixes: c870a8e70e68 ("cifs: handle different charsets in dfs cache")
Cc: stable@vger.kernel.org # depends on: smb: client: convert DFS prefix from cache charset on reconnect
Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
---
Note: Applies on top of "smb: client: convert DFS prefix from cache charset on reconnect".
---
 fs/smb/client/dfs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index efef00c33321..6b212e49cf92 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -25,6 +25,7 @@ int dfs_parse_target_referral(const char *full_path, const struct dfs_info3_para
 {
 	int rc;
 	const char *prepath = NULL;
+	char *node_name = NULL;
 	char *path;
 
 	if (!full_path || !*full_path || !ref || !ctx)
@@ -40,7 +41,12 @@ int dfs_parse_target_referral(const char *full_path, const struct dfs_info3_para
 			prepath++;
 	}
 
-	path = cifs_build_devname(ref->node_name, prepath);
+	node_name = dfs_cache_local_path(ref->node_name, ctx->local_nls);
+	if (IS_ERR(node_name))
+		return PTR_ERR(node_name);
+
+	path = cifs_build_devname(node_name, prepath);
+	kfree(node_name);
 	if (IS_ERR(path))
 		return PTR_ERR(path);
 
-- 
2.53.0

