Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3840933E34B
	for <linux-cifs@vger.kernel.org>; Sat,  7 Feb 2026 10:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770460362; cv=none; b=SxDxKoV73LzGDV8fmEBaVwzeNbhfIiGlzXD2rD8Jfudq1aXMKC2lPAv0ovVsz3NzBDBQvU2rnPFtbGflpWgdI2XNwdvhCtad/i3EdAO7hvUqCiObE7zv7EVlikuTZQoJjgoDKOEiDmSzn+3tND7jNGTLyXf9ZLAUUfOe3vwBAZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770460362; c=relaxed/simple;
	bh=KMeFA2mvsH52r+um7iU8epzocTyAhBXwozFJe2WsqGM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=B97qtHhq3gVGVa6bBwsmn/MdA2EDdYb/2Z63vMP4WuB38BcnpbVXQ2lJDw9/xF07nE1r/Tp/N3MrEv7rLfHKGzCQKQIoCMtVaufivjGWADvSKlarp/n9cW/Bc5Z+XSNc8Q9UW0gcKn+oVrw1Wy7EEzDwp9FAGDI2ohvJhSF+n/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nsgL5g/3; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nsgL5g/3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770460362; x=1801996362;
  h=date:from:to:cc:subject:message-id;
  bh=KMeFA2mvsH52r+um7iU8epzocTyAhBXwozFJe2WsqGM=;
  b=nsgL5g/3KiTqY4WYgjPIeuzlpAVZHCy+7Vg6Pxl6kK2jDUaXFlNGqQX0
   awnhckwpWf057QKVHY6vFy2rUsrCRjbIdhFnGGnhrYX4AnE1ahu5qDyao
   RqQq8Nl852xl9Zz7x+vsnoYUAEZsSgY9ZMW3scpOEyuUmlePgZ5igf+i4
   lptBaVHvl2Cf8frGD3C2HTjUDwnedRs8Nn5hzmNP/7RRNyUjGt7QT6gMB
   EIP0mvjzBPc+LpZ6hDsLXBjuugrpVJ73CkD/WYPU1mJ51yfngA9++XyaG
   Q/QD91eJepWcQD1wIjny+WYOYx+TfPQePwuxDwacNDr6DsMp0tcx9ky9d
   w==;
X-CSE-ConnectionGUID: NBUjxH6hRq6vSW/xAinH9w==
X-CSE-MsgGUID: tU6uFKMcR+WRzJ0FaE4OsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11693"; a="71691060"
X-IronPort-AV: E=Sophos;i="6.21,278,1763452800"; 
   d="scan'208";a="71691060"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2026 02:32:41 -0800
X-CSE-ConnectionGUID: jEZHW71eT/mSYvj1pbfBkw==
X-CSE-MsgGUID: tFc853uySEqD205qiuhQEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,278,1763452800"; 
   d="scan'208";a="210406372"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 07 Feb 2026 02:32:40 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vofcD-00000000lZm-1mcQ;
	Sat, 07 Feb 2026 10:32:37 +0000
Date: Sat, 07 Feb 2026 18:32:22 +0800
From: kernel test robot <lkp@intel.com>
To: David Howells <dhowells@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, Steve French <stfrench@microsoft.com>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [cifs:for-next 51/73] make[6]: *** No rule to make target
 'fs/smb/client/fs/smb/common/smb2status.h', needed by
 'fs/smb/client/smb2_mapping_table.c'.
Message-ID: <202602071842.fYfRGNxU-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   7533749b93e943b80d9dc4c627f1193dbac6b5f3
commit: 9fc8c17aa9cf5e4b50d35a14b65f7d5165bae966 [51/73] cifs: Autogenerate SMB2 error mapping table
config: i386-randconfig-013-20260207 (https://download.01.org/0day-ci/archive/20260207/202602071842.fYfRGNxU-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.4.0-5) 12.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260207/202602071842.fYfRGNxU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602071842.fYfRGNxU-lkp@intel.com/

All errors (new ones prefixed by >>):

>> make[6]: *** No rule to make target 'fs/smb/client/fs/smb/common/smb2status.h', needed by 'fs/smb/client/smb2_mapping_table.c'.
   make[6]: Target 'fs/smb/client/' not remade because of errors.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
