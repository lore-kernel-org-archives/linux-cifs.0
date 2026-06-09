Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F573378D76
	for <linux-cifs@vger.kernel.org>; Tue,  9 Jun 2026 10:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781000733; cv=none; b=dokgXwWjOfb2oBsA+vUPCZwbNv2QfhmjK6r1qnGn2ImJcG4KnpUo6Szja8rsGAzBmyPv7utaAVQHZC/grusdnG1us99OAm4faDfo3xhLHYw+DUlUrRPujgSNS/4ZLTC1cW5mCK9dNDAtlTD/NRNG3ZRZi8HPYWN8mPiXKVYpjJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781000733; c=relaxed/simple;
	bh=p8d9UbGqR/A7h2abz5+EFlWSCfUrtv0YJVI06le62kU=;
	h=Date:From:To:Cc:Subject:Message-ID; b=HOt9PMlbU39uXkwpYqlAnDm0jPrLLtNLp0F7BiJWlDYIotS1nOSK3+L5NkzV6IVMQ+knoZ+FE1Khq6XRAekfBtpsavla0/WTRCAsGi4v4jX31x4FiJrGfSMvYgZ2nPRKUHYm1Eres+9KcPf0KE3DPkzKu76hFveSCkGz1thbAO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U54Od1Lo; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U54Od1Lo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781000730; x=1812536730;
  h=date:from:to:cc:subject:message-id;
  bh=p8d9UbGqR/A7h2abz5+EFlWSCfUrtv0YJVI06le62kU=;
  b=U54Od1LoeKkKYP6T+ll+QByml2Kb3x2B4q8LMQ8IdQCC1M+kVzj/aQIU
   QwCj6EymABW6XUVFpuDk4lKnur09T/ODsp3iHFVUUGVwIlPNKBHk3aB+N
   M6vrnAB2JQtv558+4qAuFZro04JYKdKnJDqaBYkUzszjEs6mP+4uOb9Ko
   8wn5y6KwqWTGcSDC5oJrzs3czu/N7DUEP6M6bxcaUCtMkbIWJpFlGDRTy
   D+01Xf2QgU4aEBit4ln6T8ASz+wqH+r67Y/MyK9LoYMp0TdvWDrybMhSb
   7lIUsIVZQUaUl9sEeQphnz2/BQUnVw4rD3KUTf5TBEr+SXUCRgtmtq5rM
   g==;
X-CSE-ConnectionGUID: lnXslVqbQl6aoUFQ2uhDYg==
X-CSE-MsgGUID: HDEL9veMSp2KpAEWQioH+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="81503246"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="81503246"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 03:25:30 -0700
X-CSE-ConnectionGUID: moLCpnelRjGmuTUvQOxdXQ==
X-CSE-MsgGUID: lvPrlyOnRLOzrscBZX8fwg==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 09 Jun 2026 03:25:27 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wWte8-00000000JtG-46LT;
	Tue, 09 Jun 2026 10:25:24 +0000
Date: Tue, 09 Jun 2026 18:24:37 +0800
From: kernel test robot <lkp@intel.com>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Steve French <stfrench@microsoft.com>,
 Roland Mainz <roland.mainz@nrubsig.org>
Subject: [cifs:for-next-next 15/16] fs/smb/client/cifsfs.c:1204:22:
 error: use of undeclared identifier 'FS_XFLAG_CASEFOLD'
Message-ID: <202606091825.Fvo4zzYp-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next-next
head:   910f40bbf5dc81b5fcc5592fdd4caa29e80ffce0
commit: 4fb53948f97f5e89700fa933ba7d928ba1980f06 [15/16] cifs: Implement fileattr_get for case sensitivity
config: s390-allmodconfig (https://download.01.org/0day-ci/archive/20260609/202606091825.Fvo4zzYp-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 7917772d7d61384696c61102c08c2ea158e610fa)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260609/202606091825.Fvo4zzYp-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606091825.Fvo4zzYp-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/smb/client/cifsfs.c:1204:22: error: use of undeclared identifier 'FS_XFLAG_CASEFOLD'
    1204 |                         fa->fsx_xflags |= FS_XFLAG_CASEFOLD;
         |                                           ^~~~~~~~~~~~~~~~~
   fs/smb/client/cifsfs.c:1211:21: error: use of undeclared identifier 'FS_XFLAG_CASEFOLD'
    1211 |                 fa->fsx_xflags |= FS_XFLAG_CASEFOLD;
         |                                   ^~~~~~~~~~~~~~~~~
>> fs/smb/client/cifsfs.c:1215:21: error: use of undeclared identifier 'FS_XFLAG_CASENONPRESERVING'
    1215 |                 fa->fsx_xflags |= FS_XFLAG_CASENONPRESERVING;
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
   3 errors generated.


vim +/FS_XFLAG_CASEFOLD +1204 fs/smb/client/cifsfs.c

  1168	
  1169	int cifs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
  1170	{
  1171		struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
  1172		struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
  1173		struct inode *inode = d_inode(dentry);
  1174		u32 attrs;
  1175	
  1176		/* Preserve FS_COMPR_FL previously reported by cifs_ioctl(). */
  1177		if (CIFS_I(inode)->cifsAttrs & ATTR_COMPRESSED)
  1178			fa->flags |= FS_COMPR_FL;
  1179	
  1180		/*
  1181		 * FS_CASEFOLD_FL is defined by UAPI as a folder attribute,
  1182		 * and userspace tools (e.g., lsattr) display it only on
  1183		 * directories. Confine the case-handling bits to directories
  1184		 * to match that convention; for non-directories the share's
  1185		 * case semantics are still discoverable through the parent.
  1186		 */
  1187		if (!S_ISDIR(inode->i_mode))
  1188			return 0;
  1189	
  1190		/*
  1191		 * The server's FS_ATTRIBUTE_INFORMATION response, cached on
  1192		 * the tcon at mount, reflects the share's case-handling
  1193		 * semantics after any POSIX extensions negotiation. Prefer
  1194		 * it over the client-local nocase mount option, which only
  1195		 * governs dentry comparison on this superblock.
  1196		 *
  1197		 * QueryFSInfo is best-effort at mount; when it did not
  1198		 * populate fsAttrInfo, MaxPathNameComponentLength remains
  1199		 * zero. In that case fall back to nocase so the reporting
  1200		 * matches the comparison behavior installed on the sb.
  1201		 */
  1202		if (le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength) == 0) {
  1203			if (tcon->nocase) {
> 1204				fa->fsx_xflags |= FS_XFLAG_CASEFOLD;
  1205				fa->flags |= FS_CASEFOLD_FL;
  1206			}
  1207			return 0;
  1208		}
  1209		attrs = le32_to_cpu(tcon->fsAttrInfo.Attributes);
  1210		if (!(attrs & FILE_CASE_SENSITIVE_SEARCH)) {
  1211			fa->fsx_xflags |= FS_XFLAG_CASEFOLD;
  1212			fa->flags |= FS_CASEFOLD_FL;
  1213		}
  1214		if (!(attrs & FILE_CASE_PRESERVED_NAMES))
> 1215			fa->fsx_xflags |= FS_XFLAG_CASENONPRESERVING;
  1216		return 0;
  1217	}
  1218	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
