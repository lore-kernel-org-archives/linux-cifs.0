Received: from mta0.migadu.com (out-27.mta0.migadu.com [91.218.175.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C714D5A1
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 06:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789454838; cv=none; b=UvstmlE7Q5M7z9roCKp8PZOT2cicS3peXBRtvIRRQRVSUpQB4p9A8M7VxmWx5y2AxQwdYgk8urOeA2DM+C2wzG+Vul6gpWzx9bTQK8ZqtcMhusyuZgXhSSTywD3UlhkLN3tNWviF8I99JlGZQuVr5U9O805gvW/7tufogIOVMvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789454838; c=relaxed/simple;
	bh=OvBGFSEND5fzgC8AakKx5B3ThgDIF7XAs/rqMYhJ3GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDfXurO7Nckcm2JyfJWWQN564P+hLhuV8ZWvpRaCzhlv6fx8xPXfTT7DfHx9XlS94z4JbyLnwEjKAHuOV9zHSa84wLYsDBQU0FquCdtfVSRyULesSkcO3EWiXKp76jBay6+K40QlLL3GBlkDoIFMQlBEElsyuWzP4IlbzxcnbSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Zr6Mo0zV; arc=none smtp.client-ip=91.218.175.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Zr6Mo0zV"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OvBGFSEND5fzgC8AakKx5B3ThgDIF7XAs/rqMYhJ3GU=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789454831; v=1; x=1790059631;
 b=Zr6Mo0zVEXhsKK83vt1EIfzQ/udCTLFO9/ovXZU0yPSv+Zoku5EopsW/24OZz5NLGNgzBe7O
 DWSFPxFIKKrFbaXXRTOZ+CjU355E/R0WFo5hY/P8x/m+WiHIY7MocZIjKA+FNkrM4XhArfX8l8w
 MTaVmBHAJEPUjS/RmkHngZHsdnSJYv7P1awZisctaNcNb2ExWBwpoURfiQ/3Zi3ymKi+HXl3K0j
 nD5LQ2hXwZ2UE43PNr/RzOdInoFCOdlFNGGmRXFOwIHUQLIT56fam21NYss3o1/o9njA8wOnI1X
 OzVzv/6WfQr3SuSDkcyShwgcn+bLsjEtZ/k8z1eP+/r1Q==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f41e7fb8b6913313;
	Tue, 15 Sep 2026 06:47:10 +0000
X-Mizu-Trace-ID: f41e7fb8b6913313
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 1/3] smb/server: fix trailing period in generated short names
Date: Tue, 15 Sep 2026 06:46:55 +0000
Message-ID: <20260915064657.110687-2-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260915064657.110687-1-chenxiaosong@chenxiaosong.com>
References: <20260915064657.110687-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Reproducer:

  1. touch /mnt/file
  2. smbinfo filealternatenameinfo /mnt/file
     Alternate Name: FILE~9!.

See MS-FSCC 2.1.5.2.1. The base filename MUST be 1-8 characters in length
and MUST NOT contain a "." period character.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb_common.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 4c2da65510bc..086a1b85e5f4 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -523,8 +523,6 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
  * @shortname:	destination short filename
  *
  * Return:	shortname length or 0 when source long name is '.' or '..'
- * TODO: Though this function conforms the restriction of 8.3 Filename spec,
- * but the result is different with Windows 7's one. need to check.
  */
 int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
 			    char *shortname)
@@ -588,7 +586,7 @@ int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
 	if (dot_present)
 		memcpy(out + baselen + 4, extension, 4);
 	else
-		out[baselen + 4] = '\0';
+		out[baselen + 3] = '\0';
 	smbConvertToUTF16((__le16 *)shortname, out, PATH_MAX,
 			  conn->local_nls, 0);
 	len = strlen(out) * 2;
-- 
2.55.0

