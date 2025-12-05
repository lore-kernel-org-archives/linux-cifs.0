Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBE927B335
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 04:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764909070; cv=none; b=iSNG0q12ry3XYD8XuIW77sCPkkBGXAmRqx38t0cxvDkEVWOdXXM4hTRu8Oanic58Ck2IXt8laMkyz+2CDB6RMSF2/nu2ICSu2f35RLYik16QCK1Zzcg82oXklLvtlYuv7+iEuulR4HA35zcy7/SpcYAo4NcM9i+RDgcdk4KrXvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764909070; c=relaxed/simple;
	bh=9qweotHnHCqXr6B5FbkDpCCgqr4Ej5y0p7n73+Avv5w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jJOJhUpimHMqFukxmlRf3GAnC0PgKN5tpMcxbquQpr84pKh+zsRlaqDr1OuTr32O50v9H4dD1vUhwp/0xCIgc49qhbhCLM65X1KJ9N36VYFzpUUrc56GQG/Vs/dqn8KL9OxQpFbF9vYPoYKkqA1CNc+hMHoHYbKqcJ9TE9gn5HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VD3JL6sc; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VD3JL6sc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764909057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9ZsF1Q52WGDa87lo/31FfL4olWay6cy16yqqEesXTxE=;
	b=VD3JL6scMbOuLr35CB/78kZaQcbWrt2nigf3oRR8WjdsRcPai2HOADMX+WKyIAl9C7h3+i
	M95jfL51+iHZNZWMPv1phgRICNrGD9Be8JM4dwtu5j2za+OS4LEMYyYZNS+MFfK1kCrTYB
	jmyg/WEF/7V3Np+39lbLgxP5B6EN/Kc=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 0/9] smb: improve search speed of SMB2 maperror
Date: Fri,  5 Dec 2025 12:29:48 +0800
Message-ID: <20251205042958.2658496-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Before applying this patchset, when searching for the last element of
smb2_error_map_table array and calling smb2_print_status(),
3486 comparisons are needed.

After applying this patchset, only 10 comparisons are required.

v1: https://lore.kernel.org/linux-cifs/20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev/
v1->v2:
  - Patch #0001: update commit message: array has 1743 elements
  - Split into two patches: #0003 #0004
  - Patch #0009: update commit message
  - Do not move smb2maperror.c to common/

ChenXiaoSong (9):
  smb/client: reduce loop count in map_smb2_to_linux_error() by half
  smb/client: remove unused elements from smb2_error_map_table array
  smb: rename to STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP
  smb/client: add two elements to smb2_error_map_table array
  smb/client: sort smb2_error_map_table array
  smb/client: use bsearch() to find target status code
  smb/client: introduce smb2_get_err_map()
  smb/client: introduce smb2maperror KUnit tests
  smb/server: rename include guard in smb_common.h

 fs/smb/Kconfig               |  13 +++
 fs/smb/client/cifsfs.c       |   2 +
 fs/smb/client/smb2maperror.c | 159 ++++++++++++++++++++++++++++-------
 fs/smb/client/smb2proto.h    |   1 +
 fs/smb/common/smb2status.h   |   5 +-
 fs/smb/server/smb2pdu.c      |   2 +-
 fs/smb/server/smb_common.h   |   6 +-
 7 files changed, 150 insertions(+), 38 deletions(-)

-- 
2.43.0

