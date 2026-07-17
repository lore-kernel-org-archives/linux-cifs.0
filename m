Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE52334C2E;
	Fri, 17 Jul 2026 03:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784259619; cv=none; b=Ek8h1sLdxRHhEZ/wKguAEOw9eqFlWR/8A3EsHeAH4VbqP2IlylRP7NrkQVGK3s643S5LIbTQqc4V3UnTStPVtDSrZQsI6s1Z08DY1y42qI0aHIsOEZQZfI1Q4BnErcxx9tR8aWfzvVfW7qMHwIzYsLw9Z326yEd5/HFvZrDqOUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784259619; c=relaxed/simple;
	bh=0mvRohl4L7i0V4rblS6Wm4dwSD0JtzaW/cLUhgyQzt4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dcxjeXl8VAle4lAxxETrDz9MolfNm96rG/QOfSKQpWi6GBH3WTqLxAvYRtpAxeM6r06fTCSP0LGyanw6EYpmDOidoXhu8nuxTtzJ/mTuwF6M9Zy/Jp5HE5tz5Gn/vkcjQP591VsOcV3J0qivXn07MFtZJhcnYaKFOzSynLp2zGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 35e41ac0819111f1aa26b74ffac11d73-20260717
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_UNTRUSTED
	SN_LOWREP, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:34e07e5a-96d4-4a86-913f-74cbb282a296,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:34e07e5a-96d4-4a86-913f-74cbb282a296,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:35a0e98418da0d6fd706d08939447f7a,BulkI
	D:2607171140116RUJT3C4,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|136
	|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,Bulk
	:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,
	BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 35e41ac0819111f1aa26b74ffac11d73-20260717
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 686136851; Fri, 17 Jul 2026 11:40:09 +0800
From: Ze Tan <tanze@kylinos.cn>
To: sfrench@samba.org,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	sprasad@microsoft.com,
	tom@talpey.comm,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	tanze@kylinos.cn
Subject: [RFC PATCH v2 0/9] smb: support security and trusted xattrs over EAs
Date: Fri, 17 Jul 2026 11:39:18 +0800
Message-ID: <cover.1784258165.git.tanze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CIFS client and ksmbd currently expose SMB extended attributes
mainly through the Linux user.* namespace. This causes security and
trusted xattr names carried through SMB EAs to be stored with an
additional user. prefix on the server.

For example, security.xfstests can be stored as
user.security.xfstests instead of security.xfstests. This also prevents
security.capability from being handled as a file capability.

generic/093 exercises these namespaces through several commands:

  - setcap and getcap use security.capability;
  - _require_attrs security uses security.xfstests;
  - setfattr and getfattr use trusted.name.

This RFC adds end-to-end handling for the xattrs required by those
operations. The client passes security.capability,
security.xfstests and trusted.* names through SMB EAs without adding
the user. prefix. When SMB3 POSIX extensions are available, ksmbd maps
the same names to their native backing filesystem xattr namespaces for
set, get and list operations.

The security namespace is deliberately restricted to
security.capability and security.xfstests. Other security.* xattrs are
not exposed by this series. trusted.* names are supported while
internal POSIX ACL xattrs remain filtered.

The series also avoids an oplock self-deadlock found while running
generic/093. An EA or metadata-only reopen from the same SMB session
can otherwise break an oplock held by that session and wait for the
same client. Oplock breaks from other sessions and opens with share
conflicts continue to use the normal break path.

Patches 1-3 add the CIFS client support. Patches 4-5 refactor the ksmbd
EA name conversion paths without changing behavior. Patches 6-8 add
the corresponding ksmbd mappings. Patch 9 handles the same-session
oplock case.

The series touches both the CIFS client and ksmbd. It is sent as one
RFC so that the end-to-end name mapping and protocol behavior can be
reviewed together. It can be split into client and server patchsets
for merging after the approach is agreed.

Testing:

generic/093 was run with the CIFS test mount mapped to the fsgqa uid
and gid. Both xfstests mount option variables were configured as
follows:

  export CIFS_OPTS="-o username=fsgqa,password=<password>"
  export CIFS_OPTS="${CIFS_OPTS},uid=1001,gid=1001"
  export TEST_FS_MOUNT_OPTS="${CIFS_OPTS}"
  export MOUNT_OPTIONS="${CIFS_OPTS}"
  cd ~/xfstests/
  ./check -d generic/093

generic/093 passed.

Changelog
---------------

rfc v2: Rebase the patch series onto the for-next branch and resubmit it to avoid "Failed to apply" errors.

rfc: https://lore.kernel.org/all/20260715074908.641940-1-tanze@kylinos.cn/

Ze Tan (9):
  smb: client: support security.capability over EAs
  smb: client: support security.xfstests over EAs
  smb: client: support trusted xattrs over EAs
  ksmbd: extract SMB EA backing xattr name mapping
  ksmbd: extract SMB EA response name handling
  ksmbd: support security.capability EAs
  ksmbd: support security.xfstests EAs
  ksmbd: support trusted EAs
  ksmbd: avoid self oplock breaks for EA opens

 fs/smb/client/smb2ops.c |  34 ++++++++-
 fs/smb/client/xattr.c   | 109 ++++++++++++++++++++++++--
 fs/smb/server/oplock.c  |  49 ++++++++++++
 fs/smb/server/smb2pdu.c | 165 +++++++++++++++++++++++++++++++---------
 4 files changed, 311 insertions(+), 46 deletions(-)


base-commit: fce2dfa773ced15f27dd27cd0b482a7473cdcf2a
-- 
2.43.0

