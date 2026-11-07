Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794017030;
	b=bxYjaNy/Sbm2UtyxNPMy/wv7fnp0WC0Zas26q7Yc2/LWMJHhrCNkIqltoRtzzdqBwwjC
	 BJaESlhtIT5qHJ2wVMqBH9exkuQFH/QSHQVzpvVyoAPIFGJ/IWCK6YAfqeG+8KPYqhER8
	 Dj8j8tX+oq5Q0raIlzh9kNb75tys6e/DEgmWj7qymu8VfN7oze0mkdkVi7fjeZmoXVy4Z
	 h4TWQZpyDBOxK2ab5viZvrBSZb8duE/D3KHmIGhsBYZVggOBuGugIh6+mSG/Un82r+3Sn
	 71NACSr6kuq1WO5+895Cjhr6rS3bPFeP637vbZe9Ye4EgX12tLpsdnMaiVH/BMoNd+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794017030;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Wl5HFRGIt4QfvxOhtBp8qjx8hgNbCpOv123HzhwwjRI=;
	b=DehV9Ywss9mAFaAxIwMGyeQrHozaJj/bOha78ovRERGkavQa1ijzYWInzcU47q9762xq
	 W3de8aOawVmdqbqIo12BVzM8Gx7DrsBJEr+6wo7PMsmVkFag1VLF1vmqkvfipxV/RGlkr
	 SojomxDzFeXRGIkO0ObR3RMapPaf+c6VAdi8X8QNk7RqrG9fgaLkXctT9LnJjazyLStuc
	 lL1dRuDHphLKs6H1iY/fJTzXrS4Wz41Re8ab6bSk/WVJYRiSkL2746swRY2TWqkuSruWO
	 oyourJ0E6UfV8L4mBXplHM8QMzcjVJOlWxJyWSK8TdVNxuBcCcWd/XoLlw2g2xXNc8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QwKGjIsE;
	arc=none smtp.remote-ip=74.125.82.176
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967BC606A335
	for <linux-cifs@vger.kernel.org>; Sat,  7 Nov 2026 02:03:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 967BC606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QwKGjIsE
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-3700ed8dbe3so1935476eec.0
        for <linux-cifs@vger.kernel.org>; Fri, 06 Nov 2026 18:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794017030; x=1794621830; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Wl5HFRGIt4QfvxOhtBp8qjx8hgNbCpOv123HzhwwjRI=;
        b=QwKGjIsEZsvCf3chMphuHlcWrPKd9Me9ZWecGJ2rjorVykZAB18sSfoYmTl9qpwEtU
         XlmPoxYtKBhKBtTJn/FKYRu+ZtDOTVcIh6rxpPrpFGvsSvrbLnV3t2XLosIK7KIxQkUP
         DEaAStirCPauipCsdHD27k0CT/lG5FjazTOSxr95giaWodxeIqRUv6hm/cVpx40RekHv
         AE2is/Ezu6wh4LcESv8QWnGQC7VtyL+3u5DDjJvq6Q5duvPGg2byl5qk41MNL49MPzac
         Gg9heD+YCOQfdX2KhZd1dEszniZDUP/rEP+Ad7eb0/TStC5OFyZy9mmMoQjcEg9RBi9r
         Xn2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794017030; x=1794621830;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wl5HFRGIt4QfvxOhtBp8qjx8hgNbCpOv123HzhwwjRI=;
        b=Sml4RBOjOvXnISI1RuHHlSG+brcZpSwM81LC6XCsEINdx3netRql09fXHbh95YsY9G
         V6z283J9uqImbb3Vn4XycvvryNQAWR+QoJZ2Pedz+bdRo/P8PHwm4JreGd71dVSMNu1v
         oOI/lAYjjoG1r24XWB3GVrSD8Z0uJfoiqScYvvPsRHxB38Yv/kghPxpkQfwizGLm96Fh
         5cQwXujFcy7dfEfhpRLklznmiXYXxqm6P4vxC6AIiLAL/xE4o+qOP+PagBgZyjtdFLj6
         rPNmB8X6TdVKZQyyrF5grTW4eruyHs3x4yBI4Te5g0Nz2KYtZwtt8Mc20qURBqI8FwTY
         4l+g==
X-Forwarded-Encrypted: i=1; AL+hErEOGVkWFFeTjn/MlP3tzLNHcA8Z+B17gfSVblv/ZGC/hy5bX2MrWQ5r7dyBR31xNglaGTEfDNoy4TDT@vger.kernel.org
X-Gm-Message-State: APuU4Z8n1MSH6ETZqSJGwcTbjfrraixjxwfnMDQqCyCvRpsmBayKy/za
	RDGFGdjRfkrUxn4cDEaJrv1qvilrX2gBKCGWXAtjINEBsfb/1Nr+97vv
X-Gm-Gg: AYBFou1koPF/3Amk2WghVSyQIN9ojrOQXL0h4zu2mUSig/TDumd/XuOc9zfQuNUnRbN
	ROqojwhhSseXNJBOaj+OxguoNE0IYERSa20J9iRUQwXuPq57I3iAcKTnt9VFE55pbnHxv59SgdN
	Uan8suQxovrSlhehBs9Hl0YVwK1fWgXXeVlLU3YPd5sVJDLIB4YgG2VK3CxprfRvU3Gc0VFKDX7
	6zHe6aV/I8xWZOkExChnNUoKj/gUC6G/xOW1MtcuwmGoFuscexa2IXfg3UKAWWDwKQfIJfBHvTN
	YfkXm1NcSSqO2GlYXiM/e7AVVidrM9ymfkkrkYsJGb5Lm90RjvanG9+gW/2l6I6b+qt3LgjnbNo
	J7myubUee2Cavf/Y8iMCHOOMbqHwtPfIuIJHnz6wyUPxQ2YF8LF8+nVzZikFQ0gn+AjT6ZjFMVF
	p+eUVnZplrQ29nwK/abopjbwQ1K03At04joi+BhBzD82N/pHy873824xurqD9MvCarc3RoIJDi7
	6o9X/k7d5113dQT/gHKONpebsOx7hZmaUHqf0lOCKW+T+YeoLv/ZCRINY9lqFn65N3WNXtsd9hj
	4UkL+bNPfcdda/4fpSGfGnBcbVnLY5ZfRZU6t0pTa1dczDRxqM9WlAqNLay0nDAf4fA=
X-Received: by 2002:a05:693c:8809:10b0:36e:5789:7b1d with SMTP id 5a478bee46e88-36f77bea830mr5764517eec.38.1794017029383;
        Fri, 06 Nov 2026 18:03:49 -0800 (PST)
Received: from fred-server.tail1cd3ef.ts.net ([166.199.5.81])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa922b205sm10524395eec.11.2026.11.06.18.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 18:03:49 -0800 (PST)
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
	Fredric Cover <fredric.cover.lkernel@gmail.com>
Subject: [PATCH 1/2] smb: client: fix out-of-bounds read in dfs_parse_target_referral()
Date: Sat,  7 Nov 2026 02:02:56 +0000
Message-ID: <20261107020257.363811-2-fredric.cover.lkernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261107020257.363811-1-fredric.cover.lkernel@gmail.com>
References: <20261107020257.363811-1-fredric.cover.lkernel@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

dfs_parse_target_referral() decides whether a prefix path remains after
the consumed part of full_path with:

	if (strlen(full_path) - ref->path_consumed)

strlen() returns size_t, so if path_consumed is larger than the length
of full_path, the subtraction wraps around to a huge non-zero value.
The branch is then taken, prepath is set to a pointer past the
terminating NUL of full_path, and *prepath reads out of bounds.

path_consumed can exceed strlen(full_path) when the mount charset is
not utf8.  The referral code derives path_consumed from the canonical
path, which is in the DFS cache charset (utf8), but it is applied here
to full_path, which is in the mount charset.  Each non-ASCII character
in the consumed part of the path that is longer in utf8 than in the
mount charset makes the count too large by the difference.

This was reproduced with iocharset=iso8859-1 against a Samba DFS root
containing a link named "café", mounting with the single Latin-1 byte
0xe9 in the path.  On an unmodified tree such a mount fails earlier
with -ENOENT because the path is converted to utf8 twice in
setup_dfs_ref(); with that fixed ("smb: client: fix double conversion
of DFS path in setup_dfs_ref()"), the mount reaches this code.
full_path was 29 bytes while path_consumed was 30:

  BUG: KASAN: slab-out-of-bounds in dfs_parse_target_referral+0x26a/0x270
  Read of size 1 at addr ffff88810db89d5f by task mount/1743
  ...
  The buggy address is located 0 bytes to the right of
   allocated 31-byte region [ffff88810db89d40, ffff88810db89d5f)

Compare path_consumed against the string length instead of subtracting,
so that no prefix path is used when the consumed count covers the whole
string.  With the bounds check in place the same mount succeeds and no
KASAN report is produced.

This only prevents the out-of-bounds access.  path_consumed is still in
the wrong units, so a non-ASCII link followed by a path component can
still produce a wrong prefix path.  That needs a separate fix.

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
---
 fs/smb/client/dfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index f65a8a90ba27..e6dcaf9b8682 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -33,7 +33,7 @@ int dfs_parse_target_referral(const char *full_path, const struct dfs_info3_para
 	if (WARN_ON_ONCE(!ref->node_name || ref->path_consumed < 0))
 		return -EINVAL;
 
-	if (strlen(full_path) - ref->path_consumed) {
+	if ((size_t)ref->path_consumed < strlen(full_path)) {
 		prepath = full_path + ref->path_consumed;
 		/* skip initial delimiter */
 		if (*prepath == '/' || *prepath == '\\')
-- 
2.53.0

