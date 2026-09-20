Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD601379C34
	for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 05:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789882295; cv=none; b=hIT+4I85cXENpedbVVsV/87II07IZXIk0Xq91vbRl74QyfB0AWFPceaXon5W/j1hDGkIjATIwPlaI5om+BvOIXOo3Bw3YDyg9tEWEYe4OzG17nTVKl2de9lsdXTzwGkoUr4Eu/ViUD42IZXpNJPP1L/HpjdGUiJxAKnNEwgHNqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789882295; c=relaxed/simple;
	bh=4nYfcu2yOnB9ehXKXNgt68xjqSzcMg3/d5rGA9RWG58=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rmIPmvtrlRLk2jrAiIgxs+qMxTlVt0coZK++MEOCs49Ouf2RMIO8jNBqkOdJSqjktAbLkdKaRqW7y8/x+opmJDEI97ChMQEiTpWBVKF7oZ+zQ8LtUL2MI3QceCMcjlCKLWIKwxhBe4O3eUfId4uxbnpLxtN17Menh39qX8Lki8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UsHr1W2E; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UsHr1W2E"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-39647184c73so2556670a91.1
        for <linux-cifs@vger.kernel.org>; Sat, 19 Sep 2026 22:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789882293; x=1790487093; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HeIcUM27bIR09Yxk3XNFQ/HPswV01UPRZT+6P1SLhJk=;
        b=UsHr1W2Eavr0MAkVquwXYzWArXiLXjKxWP0QJJX7J5kddV4EHqwD0Ux7OtB/h2aoLn
         IErWdxPfe6001ueZo0GUPj0RAhSAM9f2G/qYLZwYdVv5iCFu0JRbAeqljdLKqoUh6Jpy
         xzlPjMOK5SvERsBiM/WBEr2olAffqQ/74bwoaUQA6F1AlT7ANIxImO5+NNyH1HU4gGye
         5h/Zd7HALDSXI5sPqRUad3KnGayho8PV8Fr8U69Nl9Qr7p3rTPnWTy26IvuxxqjYST4f
         a1hh5rEXGxzBZs4Vqw/iSEvMa4X1iQlvl8rBQ1gD+veeUl12kikO3Qos1s/FEJ7WF8tN
         OAdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789882293; x=1790487093;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HeIcUM27bIR09Yxk3XNFQ/HPswV01UPRZT+6P1SLhJk=;
        b=Df57p7++Y4qH/m2ExRGe6ngk+oRjAY6tGINgV+mumgQSR1p7911lF2rny5yFxwNuCx
         7yQUk55RByjxJGfq4toH4va/7QBcpCfAjXgGVjd1ro1oJOMQjZgcL/dJOF89EKGKQlqw
         J7sjqgbt7SRP7n6mvvg3vthOhoUwqFdHxokYGRkoAVTHcxd3r7cArEkh5x/dlO8U1Wtx
         YA5r1/oTtGJ3VfTsUcTB8PUaNoM4//PEDI2W1Ldx4+hAsRGeEuoJT08BZUlkIy36q6RA
         u/kEsgvmmpE49P2YRh411V2ORj5S/+l4UvwyOchmxY9bORlxOLFU0TbUCEuh0GiIV2Nf
         0ZhA==
X-Forwarded-Encrypted: i=1; AKwUvBx2bT4730RWO+FgK6iDmN9YA3cCENvOrJ7GApS1UPqGQZNcXvKsG5r+cJDE9MN9kXC+tlc5eg09fDq2@vger.kernel.org
X-Gm-Message-State: AFuF++lJIJR9+YhwYXafDNLoqgG4yHy6jdivJqNsnvU+GP2ED+whg0xI
	v2oPdqZ0TzWEYmurUdPYJUXueQc0QTKHaT9nVNJ1C/1DlizK+3lF+b3Y
X-Gm-Gg: AYBFou1jEM6KF2KtYLXzKXhoUZ1wq9SmKjGSFyD9IxhT0YEX/RXh79I6aohdvyuJgbU
	0UXqBCop5BicORbsnyN/N38CP7RvRJxDrplNZpjtUyNYzJsGKx7VsyMz/UAc9zs6tpwAvyyOXFa
	2cn2Vy+vnJVvD8ErkDYfZBK6Bzso5qaY8xzcErgPUgTGB2GTp34wUGs4XOEJ6InTIhyWEYHeJrI
	t3N/mSrQ65o1WOskZesyeS+yqhB6cHuOKBke6z6JuyAfTtAO8tkM8SkOVKdvChPi4REf1Ocz0lz
	rzOcM0esjg+QcUgdGDLx4RR1kOug2RRtyD6lMZAeQihmrEZahww+pHbiuplMgYzcI77epPA1q2I
	X3yQeZ8aRwUn7QcHpwfsWbiCfVGgpv/ZgO0Rp8uLpA+2w1Gu0f9bz5ER1BuZXtlnvYgfhoAQnGl
	aAoLQSqduW34DO9QJmutEWp2o4p6px0fXRnkFN+wivtsjmR8Z/2VsTwt5wsf4NjtlTYSTj/kgrH
	rKJEe+m
X-Received: by 2002:a17:90b:5403:b0:39f:6c3d:d4ed with SMTP id 98e67ed59e1d1-39f6c3dd7eemr3573628a91.30.1789882293114;
        Sat, 19 Sep 2026 22:31:33 -0700 (PDT)
Received: from RyzenBox.localdomain ([137.59.96.253])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144d55cef9bsm10438475c88.10.2026.09.19.22.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 22:31:32 -0700 (PDT)
From: Omkar Chandorkar <omkar0926@gmail.com>
X-Google-Original-From: Omkar Chandorkar <gotenksIN@aospa.co>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Namjae Jeon <linkinjeon@samba.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Omkar Chandorkar <gotenksIN@aospa.co>
Subject: [PATCH v2 0/2] ksmbd: Windows 11 SMB 3.1.1 interoperability fixes
Date: Sun, 20 Sep 2026 11:01:24 +0530
Message-ID: <20260920053126.28654-1-gotenksIN@aospa.co>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series resolves SMB 3.1.1 protocol interoperability defects
in ksmbd affecting Windows 11 clients, rebased on top of the latest
ksmbd-for-next tree.

Patch 1: smb: compress: relax trailing flags in chained decompression
Windows 11 leaves residual uninitialized bits in trailing compression
chunk headers during chained writes (e.g. copying .vhdx files).
smb_decompress_chained() previously rejected any trailing header whose
flags did not equal 0x0000, causing connection drops (ECONNRESET) and
Windows error 0x8007003B. Relax this check to accept non-chained trailing
payloads while preserving validation on segment lengths and bounds.

Patch 2: ksmbd: fix FSCTL_PIPE_TRANSCEIVE file lookup and response handling
When querying the share list (e.g. browsing \\server or running
'net view \\server'), Windows 11 issues NetrShareEnum over \PIPE\srvsvc
using SMB2_IOCTL with FSCTL_PIPE_TRANSCEIVE. Named pipe handles exist in
sess->rpc_handle_list rather than the regular file table. While
commit a3bcea7c819a ("ksmbd: exempt FSCTL_PIPE_TRANSCEIVE from the
generic file-id lookup") exempted FSCTL_PIPE_TRANSCEIVE from the generic
file ID lookup, the response PersistentFileId and VolatileFileId were
left unpopulated (violating MS-SMB2 section 2.2.32), and invalid RPC
handles were not rejected under rpc_lock.
Fix this by validating the RPC handle under rpc_lock and populating the
resolved response file IDs before dispatching the transceive request.

Changes in v2:
- Rebased series onto git.kernel.org linkinjeon/smb.git #ksmbd-for-next
  at commit 4bb07a7d5852 ("smb/server: rename smb2_file_alt_name_info to
  smb2_file_name_info").
- Dropped the compound CREATE + CHANGE_NOTIFY response handling patch
  from v1 because upstream already merged compound prefix response
  dispatching in commit 906a62216339 ("smb/server: send compound prefix
  before async pending response") and compound FID resolution in commit
  524efc568ea5 ("smb/server: support compound fid in notify requests").
- Refined the FSCTL_PIPE_TRANSCEIVE patch to populate response FileId
  fields per MS-SMB2 section 2.2.32 and validate RPC pipe handles under
  rpc_lock.

Tooling and AI disclosure:
AI tooling (OpenCode:gpt-6-astra) was utilized to assist in protocol
trace analysis, specification cross-referencing ([MS-SMB2], [MS-SRVS]),
and drafting. All changes were manually audited, static-checked,
compiled, and verified against live Windows 11 clients.

Omkar Chandorkar (2):
  smb: compress: relax trailing flags in chained decompression
  ksmbd: fix FSCTL_PIPE_TRANSCEIVE file lookup and response handling

 fs/smb/common/compress/compress.c | 16 +++++++++++-----
 fs/smb/server/smb2pdu.c           | 23 ++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 6 deletions(-)

-- 
2.55.0

