Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FD7194AD5;
	Tue, 20 Aug 2024 14:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724164591; cv=none; b=SJfjlwt2eFcrxTOJeTDHitF5KSgOmfF0Yjh+WRg/oC33X+VqfiZGWifr0QcXGca+vIEzSd/NR7TP8wZQPXB33gBPAQh/ZWbI3sGfg/B5eDTkcvA/uRg+CO/5zzKNesnzI7IshOgZKDmc4rdKMvW86vFYN9ntb+ULVIlaq2kDpVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724164591; c=relaxed/simple;
	bh=0GHqippeiQamqms57FKfMw79Fiop1ckSR5PqkLi4Obk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MODTIy8qifJ7RBZ0pgAesd/LTFtm+kw9CtBVPapXtewXdzCRJpU24UkaUsm1GkGBAoA7Ob5NkYlhzBRdvfGX7mpIzfo6E3ZxsWCStfkBzcGDje5rIoNmAfnTThvGaCdM5IfTXjQSQB8uPwtbBChttf86QN4SLkIa6VmZuCs6cc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtpsz13t1724164420todr5a
X-QQ-Originating-IP: 7Zwh8UpWNzORHh/2En8EIPPPOEnang4BltazsvZWHoc=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 20 Aug 2024 22:33:38 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 18163658882374804807
From: chenxiaosong@chenxiaosong.com
To: linkinjeon@kernel.org,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com
Cc: chenxiaosong@kylinos.cn,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn
Subject: [PATCH 0/8] smb: fix some bugs, move duplicate definitions to common header file, and some small cleanups
Date: Tue, 20 Aug 2024 14:33:11 +0000
Message-Id: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Fix some bugs in smb2_open() of smb server.

In order to maintain the code more easily, move some duplicate
definitions to common header file.

By the way, add some small cleanups to the patchset.

ChenXiaoSong (8):
  smb/server: fix return value of smb2_open()
  smb/server: fix potential null-ptr-deref of lease_ctx_info in
    smb2_open()
  smb/server: remove useless variable assignment in smb2_open()
  smb/client: fix typo: GlobalMid_Sem -> GlobalMid_Lock
  smb/server: update misguided comment of smb2_allocate_rsp_buf()
  smb: move some duplicate definitions to common/smbacl.h
  smb/client: fix typo: STATUS_MCA_OCCURED -> STATUS_MCA_OCCURRED
  smb: move SMB2 Status code to common header file

 fs/smb/client/cifsacl.h                |   58 +-
 fs/smb/client/cifsfs.c                 |    6 +-
 fs/smb/client/cifsglob.h               |    6 +-
 fs/smb/client/smb2file.c               |    2 +-
 fs/smb/client/smb2inode.c              |    2 +-
 fs/smb/client/smb2maperror.c           |    4 +-
 fs/smb/client/smb2misc.c               |    2 +-
 fs/smb/client/smb2ops.c                |    2 +-
 fs/smb/client/smb2pdu.c                |    2 +-
 fs/smb/client/smb2transport.c          |    2 +-
 fs/smb/{client => common}/smb2status.h |    4 +-
 fs/smb/common/smbacl.h                 |   88 ++
 fs/smb/server/oplock.c                 |   13 +-
 fs/smb/server/server.c                 |    2 +-
 fs/smb/server/smb2misc.c               |    2 +-
 fs/smb/server/smb2pdu.c                |   24 +-
 fs/smb/server/smb_common.c             |    2 +-
 fs/smb/server/smbacl.h                 |   80 +-
 fs/smb/server/smbstatus.h              | 1822 ------------------------
 fs/smb/server/transport_rdma.c         |    2 +-
 20 files changed, 135 insertions(+), 1990 deletions(-)
 rename fs/smb/{client => common}/smb2status.h (99%)
 create mode 100644 fs/smb/common/smbacl.h
 delete mode 100644 fs/smb/server/smbstatus.h

-- 
2.34.1

