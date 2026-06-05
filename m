Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF1C472780
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jun 2026 07:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780643716; cv=none; b=QIpohXroOoOxfgh7ctjxQ0HyftkhDJaU0wl2JuzM+1MW0VW2B6pbUequ4//ZwjYh5RHXABNSyBxecM2SIIwBjT3RCsjT7OldJeTBKR0JNjhxL7X40RWD6nBaxzMe+keucdAFf0q13RX6tl7q6mBuayi4BhhhmCA1FDwTkEZstZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780643716; c=relaxed/simple;
	bh=TQjAt6d5whsbDKBDTInnjC7pW6Uz9KQqGj+QpsMQgzo=;
	h=Date:From:To:Cc:Subject:Message-ID; b=Ud62LIWY2eL9JgngmGnzdXAcKRKwwX/qUHc0rVGjZeqpRmbhOBw0Pl5ipedSRTmsBkb7O/JnJ95Zp1XGVeyFGR4Pr+DnfdIXzVJXhIaPqO1Quz1X/f1TH3MrZes7V2Az7/ZyabFFYtXVk2PNeH0oHctp2jfSS8YycyZGOdO8lGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sb3541+G; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sb3541+G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780643715; x=1812179715;
  h=date:from:to:cc:subject:message-id;
  bh=TQjAt6d5whsbDKBDTInnjC7pW6Uz9KQqGj+QpsMQgzo=;
  b=Sb3541+GGBj9U+KPZ5ZpRpCkIgU471c1evVi77qu9v14MZbEUlfjWCCH
   7whMiBblJP1k3I47+cQK7dAApKkz0b8hjnGgwayoiXnuXfgWJlLO5SKAa
   VN0zQi+8Aqn2AXnV0ZQDnUyx46hrh2MTgQAMDRi/cEtDPAkTiL7IwKPfY
   qD5RKcEpUjBoiN367sFPM0ZbOUiyFQIOtjvgEqxbEftG5t0FpekV35DTJ
   4YrURbgoVpDHw6lEQ5SofMCDsVdbOHdZPshtuWp7LqofVMk32mOHbhz1f
   EpD19M4mvMI4p8sKX03bUZGxE5qKTFakICdiAqPFr4CNqJsPYQ6cDFX17
   A==;
X-CSE-ConnectionGUID: UdKT+kVATlqThPRLd4qp6A==
X-CSE-MsgGUID: zwdhvAJxR+6eHQhpw4jlMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11807"; a="85328565"
X-IronPort-AV: E=Sophos;i="6.24,188,1774335600"; 
   d="scan'208";a="85328565"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2026 00:15:13 -0700
X-CSE-ConnectionGUID: rz/H//itS0Ck7gTZSpitkQ==
X-CSE-MsgGUID: rgFxZC1/S8W4liUAPwo/bA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,188,1774335600"; 
   d="scan'208";a="249108133"
Received: from igk-lkp-server01.igk.intel.com (HELO 892db79562d4) ([10.211.93.152])
  by orviesa004.jf.intel.com with ESMTP; 05 Jun 2026 00:15:11 -0700
Received: from kbuild by 892db79562d4 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wVOlo-000000002VF-2HhB;
	Fri, 05 Jun 2026 07:15:08 +0000
Date: Fri, 05 Jun 2026 09:15:04 +0200
From: kernel test robot <lkp@intel.com>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Steve French <stfrench@microsoft.com>,
 Roland Mainz <roland.mainz@nrubsig.org>
Subject: [cifs:for-next-next 15/16] fs/smb/client/cifsfs.c:1204:22:
 error: use of undeclared identifier 'FS_XFLAG_CASEFOLD'
Message-ID: <202606050943.QQwHMsZH-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next-next
head:   910f40bbf5dc81b5fcc5592fdd4caa29e80ffce0
commit: 4fb53948f97f5e89700fa933ba7d928ba1980f06 [15/16] cifs: Implement fileattr_get for case sensitivity
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260605/202606050943.QQwHMsZH-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project f43d6834093b19baf79beda8c0337ab020ac5f17)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260605/202606050943.QQwHMsZH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606050943.QQwHMsZH-lkp@intel.com/

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
