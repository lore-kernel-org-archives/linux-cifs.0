Received: from smtpbg154.qq.com (smtpbg154.qq.com [15.184.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEE019E836;
	Thu, 20 Jun 2024 09:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=15.184.224.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718876275; cv=none; b=W4zYNevOUOJn3jUIA0wYLIwW+tF77L3tDvshHBOpds85vfIYTIClBpnDDhvHqDNQSAmO9BHpaW9+et5UZ+zSXlRgXVbeWQy+pLWv0Leb4Bptlg8NaWUKq/tqWyd/yXbTo2zWA8FQ7LTQG3MpE1eDkgsrBAWNr3B2lq+MfvYUuQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718876275; c=relaxed/simple;
	bh=eBYaoHtkxmjZTEXX/EsYxxR1JW6S47fqMufl7ZBPPxE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oOyaLsgNPgS4SMotwcY+0mNdUvMssjpWvp9yIKYtyuDF59F9DJNbl+71TRsAj00PXbQptEjRFGJhkIxyAKODIsGIpIoVBS1UO5OIo7jSKH6dBpMqMuYbmiadTFWrBmwRiH5uIGTH8Ou9of63YSGTea2v8LTZ4agyuQYM4sPDsJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=none smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=15.184.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtpsz1t1718876123tmrikod
X-QQ-Originating-IP: UNSjr0WFDyKwAKp4j1r76ZW1VD57puniGPFGXbs27MI=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 20 Jun 2024 17:35:18 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 17883702192309828871
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
Subject: [PATCH 0/2] smb: move SMB2 Status code to common header file
Date: Thu, 20 Jun 2024 09:34:34 +0000
Message-Id: <20240620093436.411889-1-chenxiaosong@chenxiaosong.com>
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

There are only slight differences between the client and server of SMB2
Status code definitions, in order to maintain the code more easily,
move all definitions to common header file.

ChenXiaoSong (2):
  smb/client: fix typo to STATUS_MCA_OCCURRED
  smb: move SMB2 Status code to common header file

 fs/smb/client/smb2file.c               |    2 +-
 fs/smb/client/smb2inode.c              |    2 +-
 fs/smb/client/smb2maperror.c           |    4 +-
 fs/smb/client/smb2misc.c               |    2 +-
 fs/smb/client/smb2ops.c                |    2 +-
 fs/smb/client/smb2pdu.c                |    2 +-
 fs/smb/client/smb2transport.c          |    2 +-
 fs/smb/{client => common}/smb2status.h |  163 ++-
 fs/smb/server/oplock.c                 |    2 +-
 fs/smb/server/server.c                 |    2 +-
 fs/smb/server/smb2misc.c               |    2 +-
 fs/smb/server/smb2pdu.c                |    2 +-
 fs/smb/server/smb_common.c             |    2 +-
 fs/smb/server/smbstatus.h              | 1822 ------------------------
 fs/smb/server/transport_rdma.c         |    2 +-
 15 files changed, 122 insertions(+), 1891 deletions(-)
 rename fs/smb/{client => common}/smb2status.h (96%)
 delete mode 100644 fs/smb/server/smbstatus.h

-- 
2.34.1

