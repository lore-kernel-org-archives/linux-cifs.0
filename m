Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEFE386C0E
	for <linux-cifs@vger.kernel.org>; Wed,  1 Apr 2026 07:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775028623; cv=none; b=ZEvYnJPgqIekyUdplWya0hHamKXZ97ArG/Eu6f5aMf3/6+iDeHdhpvqjBvaSAJ9vuRdOo2FbUVewoQkXCodJJYVEzKiOTHZPWL4SKpNkPTzIOg/woLgviiyLXnDgFloXj6pDYX882MehAcbwQaMUH/AgKShwfSeuFJnfNt0xLqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775028623; c=relaxed/simple;
	bh=S3ipCPZW/WmcABDZKujz7Nfx+XSPZHCmGdTlmFXnrKM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EGNA54O6m2t6We/R17RyYrrBkDJqxdBiCivCMNRCgDQmfnVg8VzM5OcWXenQ7ThoLl6qVmD2Rp7rHsmt7wFVpUT3FxxE55TS5eh/jNSIhVKMlqZLqDiGc06OL9voIR8SUX78cHz4OcnF2IfuQZtReUYD7QnJXfpCa4uW2cgMKPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i2uubjUf; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i2uubjUf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775028619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0XDWZKI8mpFIWM0A+B1DJkCi6jG/GRRVkm68TJP90UE=;
	b=i2uubjUfEqqiFNdceollrTrZ9HHk4nEIZZ+AsbATo28FbKySLzbbSMGVT5Kl7kraVSh+hx
	PzFPmCbs+5m4PjwQxlVPzjKmPG8ltyu/kP1lM9GY0dKxZFV7P/EDvmvFXZ6xwLjBNMqIqo
	xHMY7N7J2X/2oDANO9ME/YOCNHbDwb8=
From: huiwen.he@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn,
	chenxiaosong@chenxiaosong.com,
	tangyouling@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	Huiwen He <hehuiwen@kylinos.cn>
Subject: [PATCH v2 00/12] smb: improve search speed of SMB1 maperror
Date: Wed,  1 Apr 2026 07:29:00 +0000
Message-ID: <20260401072912.355072-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

v1->v2:
  - Sort arrays at build time
  - Merge nt_errs to ntstatus_to_dos_map
  - Check if arrays are sorted in smb1_init_maperror()

v1: https://lore.kernel.org/linux-cifs/20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev/

When searching for the last element, the comparison counts are shown in the table below:

+--------------------+--------+--------+
|                    |Before  |After   |
|                    |Patchset|Patchset|
+--------------------+--------+--------+
| ntstatus_to_dos_map|   533  |    9    |
+--------------------+--------+--------+
|mapping_table_ERRDOS|    34  |    5   |
+--------------------+--------+--------+
|mapping_table_ERRSRV|    37  |    5   |
+--------------------+--------+--------+

The following patches from v1 have already been merged into the mainline:
  - a71a4aab4834 smb/client: add parentheses to NT error code definitions containing bitwise OR operator
  - a9adafd40165 smb/client: add 4 NT error code definitions
  - 98def4eb0244 smb/server: remove unused nterr.h
  - 9f99caa8950a smb/client: fix NT_STATUS_UNABLE_TO_FREE_VM value
  - b2b50fca34da smb/client: fix NT_STATUS_DEVICE_DOOR_OPEN value
  - a1237c203f17 smb/client: fix NT_STATUS_NO_DATA_DETECTED value

Huiwen He (8):
  smb/client: annotate nterr.h with DOS error codes
  smb/client: autogenerate SMB1 NT status to DOS error mapping
  smb/client: replace nt_errs with ntstatus_to_dos_map
  smb/client: refactor ntstatus_to_dos() to return mapping entry
  smb/client: use binary search for NT status to DOS mapping
  smb/client: annotate smberr.h with POSIX error codes
  smb/client: autogenerate SMB1 DOS/SRV to POSIX error mapping
  smb/client: use binary search for SMB1 DOS/SRV error mapping

Youling Tang (4):
  smb/client: check if ntstatus_to_dos_map is sorted
  smb/client: introduce KUnit test to check ntstatus_to_dos_map search
  smb/client: check if SMB1 DOS/SRV error mapping arrays are sorted
  smb/client: introduce KUnit tests to check DOS/SRV err mapping search

 fs/smb/client/.gitignore          |    3 +
 fs/smb/client/Kconfig             |   11 +
 fs/smb/client/Makefile            |   25 +-
 fs/smb/client/cifsfs.c            |    6 +
 fs/smb/client/gen_smb1_mapping    |  109 +++
 fs/smb/client/nterr.c             |  704 -------------------
 fs/smb/client/nterr.h             | 1082 +++++++++++++++--------------
 fs/smb/client/smb1maperror.c      |  873 +++++------------------
 fs/smb/client/smb1maperror_test.c |   83 +++
 fs/smb/client/smb1proto.h         |    9 +
 fs/smb/client/smberr.h            |  415 +++++++----
 11 files changed, 1232 insertions(+), 2088 deletions(-)
 create mode 100644 fs/smb/client/gen_smb1_mapping
 delete mode 100644 fs/smb/client/nterr.c
 create mode 100644 fs/smb/client/smb1maperror_test.c

-- 
2.52.0

