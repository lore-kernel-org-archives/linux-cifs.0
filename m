Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7AC224891;
	Fri,  5 Dec 2025 02:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764902216; cv=none; b=qOkW0gIjCa0fgsP6MFRZlQxzG6QBPp5OtHUXU+o5GVFWflmM6t5r7l/DXN/4dSdpbO1kXA1nlwQkgcw7Y9CTIrXt1IQuJjqUg1zkSTGphiIKNMXmcbpxc5FvsXtmu1JZJBUQXKwLPQlulpLjHstULLeDMBiY27RdOg2KEVVxe/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764902216; c=relaxed/simple;
	bh=TJw26I1TDQ2HwfpPYV01mmqi31HyIzZpvW01ZcONxdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YW8bYdXpwvuxJSbQ4Azz6xjLygDJXDxodbZeyN0x9gOcdgQBfRNhbqG74MlbT3S4MfTlF0ZVjO9ufwz+gPU7R03QIKSm0Z5sz7fruIjGqxUt9/C/zJeAmGv/Z8wAWbJI8Y3sXG7Fik2SaDyuVUpoBk3YU+aDgZPhFxGAqPRWFww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CPsUzEbA; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CPsUzEbA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764902214; x=1796438214;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TJw26I1TDQ2HwfpPYV01mmqi31HyIzZpvW01ZcONxdU=;
  b=CPsUzEbA+5Fwhyvb4vpTD4O4cwOUgXuU93NhZ5OWL+xtBiWGi0yrJ/2r
   xROHpxLtCNOrU0ItuwL3rFm04jn+2p/wvtnmecFJ7MnvbyoywQbdMPpcc
   yArAmgaeJxKA5O7Yt7DAB2y6gPSHEmNg5/XMZD+Q2Nm6GOvRuEjY33oIZ
   Syg6I3yZnfx/iR9RKtZa0LSsvDK3tC4w7OQ9NL+FeO797YKyKizNTYSdV
   oGvugL0ETXRpt1aFthuXLlpi79gIxej1Y122ds3fdZ/QmEgD4nsGsveFw
   rlg8AKiiGkgonA2HSfiygjMCApaBsm/ZA+Nj85CkAc50qKwlgQNkBBigw
   Q==;
X-CSE-ConnectionGUID: rAJqVcLeT/mqVRZj8cVmAw==
X-CSE-MsgGUID: KyTwsdTGSsKJv+I+A4q6xA==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="67010122"
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="67010122"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 18:36:54 -0800
X-CSE-ConnectionGUID: thqaZtd8TDSbBtPsk2hRFg==
X-CSE-MsgGUID: MAe4tz/yS96VvArJMXkEUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="194968442"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 04 Dec 2025 18:36:51 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vRLge-00000000EUj-2l8Q;
	Fri, 05 Dec 2025 02:36:48 +0000
Date: Fri, 5 Dec 2025 10:35:52 +0800
From: kernel test robot <lkp@intel.com>
To: chenxiaosong.chenxiaosong@linux.dev, sfrench@samba.org,
	smfrench@gmail.com, linkinjeon@kernel.org, linkinjeon@samba.org
Cc: oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org, chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH 10/10] smb: move client/smb2maperror.c to common/
Message-ID: <202512051006.j5kB1bVW-lkp@intel.com>
References: <20251204045818.2590727-11-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204045818.2590727-11-chenxiaosong.chenxiaosong@linux.dev>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[cannot apply to cifs/for-next brauner-vfs/vfs.all v6.18 v6.18-rc7 v6.18-rc6 next-20251203 v6.18 next-20251204]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/chenxiaosong-chenxiaosong-linux-dev/smb-client-reduce-loop-count-in-map_smb2_to_linux_error-by-half/20251204-130530
base:   linus/master
patch link:    https://lore.kernel.org/r/20251204045818.2590727-11-chenxiaosong.chenxiaosong%40linux.dev
patch subject: [PATCH 10/10] smb: move client/smb2maperror.c to common/
config: i386-randconfig-063-20251205 (https://download.01.org/0day-ci/archive/20251205/202512051006.j5kB1bVW-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251205/202512051006.j5kB1bVW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512051006.j5kB1bVW-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> fs/smb/common/smb2maperror.c:2419:14: sparse: sparse: restricted __le32 degrades to integer
   fs/smb/common/smb2maperror.c:2419:31: sparse: sparse: restricted __le32 degrades to integer
   fs/smb/common/smb2maperror.c:2421:14: sparse: sparse: restricted __le32 degrades to integer
   fs/smb/common/smb2maperror.c:2421:31: sparse: sparse: restricted __le32 degrades to integer

vim +2419 fs/smb/common/smb2maperror.c

ddfbefbd393fb1 fs/cifs/smb2maperror.c       Steve French 2011-03-15  2411  
99d0698b9bf5cf fs/smb/client/smb2maperror.c ChenXiaoSong 2025-12-04  2412  static unsigned int err_map_num = sizeof(smb2_error_map_table) /
99d0698b9bf5cf fs/smb/client/smb2maperror.c ChenXiaoSong 2025-12-04  2413  				     sizeof(struct status_to_posix_error);
99d0698b9bf5cf fs/smb/client/smb2maperror.c ChenXiaoSong 2025-12-04  2414  
99d0698b9bf5cf fs/smb/client/smb2maperror.c ChenXiaoSong 2025-12-04  2415  static int cmp_smb2_status(const void *_a, const void *_b)
99d0698b9bf5cf fs/smb/client/smb2maperror.c ChenXiaoSong 2025-12-04  2416  {
99d0698b9bf5cf fs/smb/client/smb2maperror.c ChenXiaoSong 2025-12-04  2417  	const struct status_to_posix_error *a = _a, *b = _b;
99d0698b9bf5cf fs/smb/client/smb2maperror.c ChenXiaoSong 2025-12-04  2418  
99d0698b9bf5cf fs/smb/client/smb2maperror.c ChenXiaoSong 2025-12-04 @2419  	if (a->smb2_status < b->smb2_status)
99d0698b9bf5cf fs/smb/client/smb2maperror.c ChenXiaoSong 2025-12-04  2420  		return -1;
99d0698b9bf5cf fs/smb/client/smb2maperror.c ChenXiaoSong 2025-12-04  2421  	if (a->smb2_status > b->smb2_status)
99d0698b9bf5cf fs/smb/client/smb2maperror.c ChenXiaoSong 2025-12-04  2422  		return 1;
99d0698b9bf5cf fs/smb/client/smb2maperror.c ChenXiaoSong 2025-12-04  2423  	return 0;
99d0698b9bf5cf fs/smb/client/smb2maperror.c ChenXiaoSong 2025-12-04  2424  }
99d0698b9bf5cf fs/smb/client/smb2maperror.c ChenXiaoSong 2025-12-04  2425  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
