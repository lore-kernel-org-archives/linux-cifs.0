Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF9C3277AA
	for <linux-cifs@vger.kernel.org>; Mon, 17 Nov 2025 11:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763378994; cv=none; b=gjLeU4PTkzAD+D5Y7Hpq7x+FEM2Gq00a7BBJS/FoC0sKe2ad3tk9ZmWlqpiaj1j+QjZEDRKLORDRP7UU9LrHB4JGH53dJwJmVqo3T2whvnsKG1nuYXPATe1vzWgy0uz9A8SaaS/JRuAPXuFKSThTeOLEOyh0PTKFsz2QFT1XHpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763378994; c=relaxed/simple;
	bh=ep+lLZIMWxXsAk6NTTFgn7sM6nojwB74fEpz07zSsSU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jMtFqAUl03jRF7MWNM1z4VhX7xZhM1osWxRBOHWeHxSVsTY9AK9irx0zTAojidyoc8yR9IEwdhsH/XsYMO0XHFpPQryuc09fumEc3nc14tewKKoMkk/TMDgVJRzcUUc0aQdmq9c1JqsP0yJShOZAenhMR3nPlXKRGMEjz1XjRdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LDOcD+5d; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LDOcD+5d"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763378989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gKSB7WZ/Rem1rfCC4nAPSfG72QwB194JYJHtNbWRcF0=;
	b=LDOcD+5dYppRSB/LwNbCKaO4a8rvy4zkmDI68kqjIxpvlR9yOLlp/lKOKhs848y22v2yx8
	/ug6Ufa7lYVpX28/vEm/Rpm00LZYLM0Au7LmGnChyJBzPN+z4OnA6tdeYgB/cXeVElywUQ
	hx5opZQkc47lNV2n/DWEoOEHuWWSeAE=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v9 0/1] smb: move duplicate definitions to common header file
Date: Mon, 17 Nov 2025 19:28:37 +0800
Message-ID: <20251117112838.473051-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

I have tested the relevant code related to FILE_SYSTEM_ATTRIBUTE_INFO: https://chenxiaosong.com/en/FILE_SYSTEM_ATTRIBUTE_INFO.html

I have tested all patches using xfstests and smbtorture, and no additional
test failures were observed in the results. The detailed test results can
be found in https://chenxiaosong.com/en/smb-test-20251117.html

v3: https://lore.kernel.org/all/20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev/
The following patches from v3 have already been merged into the mainline:
  - d877470b5991 smb: move some duplicate definitions to common/cifsglob.h
  - 379510a815cb smb/server: fix possible refcount leak in smb2_sess_setup()
  - 6fced056d2cc smb/server: fix possible memory leak in smb2_read()

v4: https://lore.kernel.org/all/20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev/
v5: https://lore.kernel.org/all/20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev/
v7: https://lore.kernel.org/all/20251113133252.145867-1-chenxiaosong.chenxiaosong@linux.dev/
The following patches from v4 v5 v7 have been applied to the ksmbd-for-next-next branch: https://git.samba.org/?p=ksmbd.git;a=shortlog;h=refs/heads/ksmbd-for-next-next
  - smb: move create_durable_reconn to common/smb2pdu.h
  - smb: fix some warnings reported by scripts/checkpatch.pl
  - smb: do some cleanups
  - smb: move FILE_SYSTEM_SIZE_INFO to common/fscc.h
  - smb: move some duplicate struct definitions to common/fscc.h
  - smb: move list of FileSystemAttributes to common/fscc.h
  - smb: move SMB_NEGOTIATE_REQ to common/smb2pdu.h
  - smb: move some duplicate definitions to common/smb2pdu.h
  - smb: move create_durable_rsp_v2 to common/smb2pdu.h
  - smb: move create_durable_handle_reconnect_v2 to common/smb2pdu.h
  - smb: move create_durable_req_v2 to common/smb2pdu.h
  - smb: move MAX_CIFS_SMALL_BUFFER_SIZE to common/smbglob.h
  - smb/client: fix CAP_BULK_TRANSFER value
  - smb: move resume_key_ioctl_rsp to common/smb2pdu.h
  - smb: move copychunk definitions to common/smb2pdu.h
  - smb: move smb_sockaddr_in and smb_sockaddr_in6 to common/smb2pdu.h
  - smb: move SMB1_PROTO_NUMBER to common/smbglob.h
  - smb: move get_rfc1002_len() to common/smbglob.h
  - smb: move smb_version_values to common/smbglob.h
  - smb: rename common/cifsglob.h to common/smbglob.h

v8: https://lore.kernel.org/all/20251116065213.282598-1-chenxiaosong.chenxiaosong@linux.dev/
v8->v9:
  - SMB2_QFS_attr(): memcpy(..., min_len)
  - Fix typo: FS-FSCC -> MS-FSCC

ChenXiaoSong (1):
  smb: move FILE_SYSTEM_ATTRIBUTE_INFO to common/fscc.h

 fs/smb/client/cifspdu.h    | 10 ----------
 fs/smb/client/smb2pdu.c    |  6 +++---
 fs/smb/common/fscc.h       |  9 +++++++++
 fs/smb/server/smb2pdu.c    |  6 +++---
 fs/smb/server/smb_common.h |  7 -------
 5 files changed, 15 insertions(+), 23 deletions(-)

-- 
2.43.0

