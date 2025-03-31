Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CED8472;
	Mon, 31 Mar 2025 13:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743428364; cv=none; b=qEIzY6qxGbh007fKOQQmlXd/LQ6A716QuQvoFDUqaeCxd8kQxSvGjsfaeD/sK0H8klt496FiksbqjOSWPu75QCbikCsP5GU3tmrZKxCM8KsIXSVGzuL/BZgjmFzT2N3lJRP2aVnOQPJPl7VYspChec02NiEReeBWJZvvrNIXWQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743428364; c=relaxed/simple;
	bh=NmmoYX2n2+ctopcsNgGDDbztCi1Hd/v13+789tHWlPs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gFL1JVLfzbTU3Raz5HGug6O3lQn2raGPFZCY46kg4DYJaHFz4fYLQX3HwyYFxMO81Lqzmyes8sO4ViQcefurdJ++bhDa7J3Lh4uqEc8czBkwFGivyG9+p+D+kzEby6JanAVOM2pxnVM3ETE6XzXzFXKO/q30IsUZChFEM2suZpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4ZRC185Wmkz27hRL;
	Mon, 31 Mar 2025 21:39:56 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 0C1E11A016C;
	Mon, 31 Mar 2025 21:39:18 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemg500010.china.huawei.com
 (7.202.181.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 31 Mar
 2025 21:39:17 +0800
From: Wang Zhaolong <wangzhaolong1@huawei.com>
To: <sfrench@samba.org>, <linkinjeon@kernel.org>
CC: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, <chengzhihao1@huawei.com>,
	<wangzhaolong1@huawei.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH next 0/3] smb: client: Improve IO parameter resilience after reconnection
Date: Mon, 31 Mar 2025 21:33:12 +0800
Message-ID: <20250331133315.117666-1-wangzhaolong1@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemg500010.china.huawei.com (7.202.181.71)

## Background

When a SMB client connection experiences a network disruption and reconnects
to the server, several critical parameters are renegotiated with the server.
However, in current code, the negotiated IO sizes (rsize/wsize) for existing
mount points are not updated to reflect the server's potentially changed
capabilities. This can lead to suboptimal performance or even failures.

## Problem Discovery

I encountered a critical issue in the Linux 5.10 kernel where CIFS would crash
due to rsize becoming zero, which led to a null pointer dereference in the
file read path. This could happen when either:

1. The server returned a MaxReadSize of 0 in a negotiation response, or
2. During reconnection when server->max_read might be reset to 0

While investigating, I noted that the MS-SMB2 specification (section 3.2.5.2
"Receiving an SMB2 NEGOTIATE Response") states:

  "The client SHOULD<175> disconnect the connection if the size, in bytes,
   received in MaxTransactSize, MaxReadSize, or MaxWriteSize is less than 65536."

However, current CIFS client implementations do not strictly enforce this
recommended minimum and may even operate with smaller values. Nevertheless,
it is evident that these values should not be set to zero.

While subsequent kernel versions have addressed the null pointer dereference
itself, the underlying issue of potentially zero or outdated IO sizes after
reconnection remains. After reviewing the code, I discovered that the
reconnection flow includes negotiation with the server but does not update
the IO parameters for existing mounted filesystems.

## Solution Approach

This patch series implements a comprehensive solution by:

1. Creating a bidirectional relationship between tree connections and
   superblocks to locate all mounts using a specific connection
2. Preserving original user-specified IO parameters separately from
   negotiated values
3. Adding safeguards against zero IO sizes
4. Implementing automatic renegotiation of IO parameters after reconnection

## Patch Breakdown

- Patch 1: Adds bidirectional mapping between tcon and superblocks, enabling
  efficient discovery of all filesystems using a specific tree connection
- Patch 2: Stores original user-specified IO parameters and adds protection
  against zero IO sizes by enforcing the MS-SMB2 specification minimum
- Patch 3: Implements automatic renegotiation of IO parameters after
  successful reconnection

These changes make the CIFS client more resilient to network disruptions
by ensuring all mounted filesystems maintain optimal and safe IO parameters
that reflect current server capabilities.

Wang Zhaolong (3):
  smb:client: smb: client: Add reverse mapping from tcon to superblocks
  smb: client: Store original IO parameters and prevent zero IO sizes
  smb: client: Update IO sizes after reconnection

 fs/smb/client/cifs_fs_sb.h |  1 +
 fs/smb/client/cifsglob.h   |  3 ++-
 fs/smb/client/connect.c    | 15 +++++++++++++++
 fs/smb/client/fs_context.c |  2 ++
 fs/smb/client/fs_context.h |  3 +++
 fs/smb/client/misc.c       |  2 ++
 fs/smb/client/smb1ops.c    |  6 +++---
 fs/smb/client/smb2ops.c    | 27 +++++++++++++++++++--------
 fs/smb/client/smb2pdu.c    | 24 ++++++++++++++++++++++--
 fs/smb/common/smb2pdu.h    |  3 +++
 10 files changed, 72 insertions(+), 14 deletions(-)

-- 
2.39.2

