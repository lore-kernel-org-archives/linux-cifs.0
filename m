Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF557342538
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 10:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889682; cv=none; b=cXsYMX7vxbCDAAIbwRthQXLplORVBT7B2LodQy3dNSjGTPWPceugAkaRws7cAw7PYANdonrqNOq3eZTvYd2k7Lhh6rqCC5fZ8msfHke545ulPdOrGFDsjOOmQ/2AcKiXkO4ZbF7yw7ZgXQEaNc+6Hb9Nzu3jy/7TRuASXa0QZa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889682; c=relaxed/simple;
	bh=ce8klzpH7hxSfl0XbrtIukYk6iSpvb9FOP8sHz4vNIE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bCOBexUHX7ybjSy77OPzuJA+5D04ecqre4K6HlGJ11BeNMGYAbm4ZTbAqSqZvIkJUJxpsmPNqR9ebivg6WbDq58oy8mwAoRnxxYHtWlLxVcv0DU4nzLkTsUirapoXPpMapDBkLb68jBFN/WigcFPvrSYQpDMaobEFlewx8A1KO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 2f96ca6c874c11f1aa26b74ffac11d73-20260724
X-CTIC-Tags:
	HR_CC_AS_FROM, HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_C_CI
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:a3fe11b3-6d58-4949-8213-fef05abac14f,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:a3fe11b3-6d58-4949-8213-fef05abac14f,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:340794377dcb72f30b26cdabec03791f,BulkI
	D:260724184112CRYL704Z,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|136
	|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,Bulk
	:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,
	BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2f96ca6c874c11f1aa26b74ffac11d73-20260724
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 293169245; Fri, 24 Jul 2026 18:41:11 +0800
From: Ze Tan <tanze@kylinos.cn>
To: sfrench@samba.org,
	linkinjeon@kernel.org,
	slow@samba.org,
	pc@manguebit.org,
	jra@samba.org,
	tom@talpey.comm,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org
Cc: tanze@kylinos.cn
Subject: [PATCH 00/15] smb: add native security and trusted xattrs
Date: Fri, 24 Jul 2026 18:39:54 +0800
Message-ID: <cover.1784888897.git.tanze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CIFS client and ksmbd historically carry SMB extended attributes
through the Linux user.* namespace. The client removes "user." from an
EA name before sending it, and ksmbd adds the prefix when selecting the
backing xattr.

That mapping cannot provide native Linux semantics for
security.capability, security.xfstests, or trusted.*. For example,
security.capability stored as user.security.capability is not treated as
a file capability and is not removed by the VFS killpriv path after a
write.

These xattrs are needed by generic/093:

  - setcap and getcap use security.capability;
  - _require_attrs security uses security.xfstests;
  - setfattr and getfattr use trusted.name.

This series adds an opt-in native mapping for those names. The default
non-POSIX mapping remains unchanged. On a mount where SMB3 POSIX
extensions have been requested and negotiated, the client exposes:

  security.capability
  security.xfstests
  trusted.*

The client sends these names without a user prefix. In this mode it
rejects user.security.capability, user.security.xfstests, and
user.trusted.*. Other security.* names are not enabled.

ksmbd activates the native mapping only for a handle opened with an
SMB3 POSIX create context. The mapped fsuid must be root, or the tree
connection must have KSMBD_TREE_CONN_FLAG_ADMIN_ACCOUNT. An
unauthorized native request fails instead of falling back to user.*.

Native xattrs are returned without a prefix when EAs are listed. Their
corresponding user.* backing xattrs are hidden in native mode. The
internal XFS trusted.SGI_ACL_FILE and trusted.SGI_ACL_DEFAULT xattrs
remain unsupported.

No new SMB negotiate context or capability bit is added in this
version. The existing -o posix opt-in and per-open SMB3 POSIX create
context are reused. One question for review is whether that is
sufficient, or whether native xattrs require a dedicated protocol
capability to distinguish patched servers from other POSIX-capable
servers.

Writing a file with security.capability also exercises the VFS killpriv
path. That path can issue EA queries and removals while the original
write handle is active. A temporary EA open can otherwise break the
write handle's caching state and wait for the blocked write path.

The series is arranged as follows:

  - patches 1-2 separate ksmbd EA name conversion from request and
    response construction;
  - patches 3-6 fix exact-name lookup, empty and disappearing EAs,
    CREATE-context mount write access, and bounded debug output;
  - patches 7-10 add the authorized native mappings to ksmbd;
  - patches 11-12 prepare lease reuse and the no-lease oplock fallback;
  - patches 13-15 enable the native names in the CIFS client.

The client and server changes are kept in one RFC so the end-to-end
mapping, authorization, and protocol activation can be reviewed
together. They can be split for merging after the interface is agreed.

Testing
=======

The test and scratch shares were mounted with an SMB account mapped to
server root or an admin account. Both xfstests mount option variables
included:

  vers=3.1.1,posix,idsfromsid,uid=<fsgqa-uid>,gid=<fsgqa-gid>

generic/093 was run in all three ksmbd configurations:

  1. oplocks = yes, smb2 leases = yes
  2. oplocks = yes, smb2 leases = no
  3. oplocks = no

The test passed in all three configurations.

The following cases were also checked manually:

  - security.xfstests set and retrieved on the client, and appeared as
    security.xfstests on the server backing filesystem;
  - security.capability set through setcap and removed after a write;
  - trusted.name remained present after the same write;
  - the server backing filesystem stored trusted.name without a user
    prefix.

Changes since RFC v2
--------------------

  - Keep the default user EA mapping unchanged and require -o posix for
    native client names.
  - Require a per-open SMB3 POSIX create context and a root or admin
    server mapping.
  - Reject colliding user.* spellings instead of silently downgrading
    native requests.
  - Use tables for exact native names, native prefixes, and unsupported
    names.
  - Add the ksmbd EA correctness fixes found while reviewing the native
    mapping paths.
  - Test generic/093 with oplocks disabled, and with oplocks enabled
    both with and without SMB2 leases.


RFC v2:
https://lore.kernel.org/linux-cifs/cover.1784258165.git.tanze@kylinos.cn/

RFC v1:
https://lore.kernel.org/all/20260715074908.641940-1-tanze@kylinos.cn/


Ze Tan (15):
  ksmbd: extract SMB EA backing xattr name mapping
  ksmbd: extract SMB EA response name handling
  ksmbd: match SMB2 EA names by exact length
  ksmbd: handle empty and disappearing EAs
  ksmbd: take mount write access for CREATE EAs
  ksmbd: bound SMB2 EA name debug output
  ksmbd: query security.capability on POSIX EA handles
  ksmbd: set security.capability on POSIX EA handles
  ksmbd: support security.xfstests on POSIX EA handles
  ksmbd: support trusted xattrs on POSIX EA handles
  smb: client: prepare EA opens for inode lease reuse
  smb: client: avoid batch oplocks for reentrant POSIX EAs
  smb: client: gate security.capability EA on POSIX mounts
  smb: client: support security.xfstests on POSIX mounts
  smb: client: support trusted EAs on POSIX mounts

 fs/smb/client/cifsfs.h    |   8 ++
 fs/smb/client/cifsglob.h  |   5 +-
 fs/smb/client/cifssmb.c   |   7 +-
 fs/smb/client/inode.c     |   2 +-
 fs/smb/client/smb1ops.c   |   4 +-
 fs/smb/client/smb1proto.h |   5 +-
 fs/smb/client/smb2file.c  |  18 +++
 fs/smb/client/smb2ops.c   |  56 +++++++---
 fs/smb/client/smb2proto.h |   3 +-
 fs/smb/client/xattr.c     | 156 ++++++++++++++++++++++++--
 fs/smb/server/smb2pdu.c   | 229 ++++++++++++++++++++++++++++++--------
 11 files changed, 413 insertions(+), 80 deletions(-)


base-commit: 4a03a16a93001f5af67911b722c4d2f7b2c313f8
-- 
2.43.0

