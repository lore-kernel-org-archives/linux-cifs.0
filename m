Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A8F27EFE9
	for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 23:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761349884; cv=none; b=LnKkxRJ2ZCipK2vVG+o2pxa6MyD9elOKMvsip6JL8qD2jM4derXHjKdDHXqUaIvq8u00Y6pNH78++e9HClnPo55a2qpJfoh9BTJnSKhAzZQ5I/iVntFUjbX04W80EyzAxFFooU05U/b1Tx2pHR3TNEKBuq6CW9M1FSrYP1leq7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761349884; c=relaxed/simple;
	bh=kg/sFbQ5ZF67NU7RVAArHvgGi0lNHjwpD8KFw0mm0RU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OQbdIWYjCGyanVaYbiL4negwWTh5edepNLzwTsbnY0TqdH/nDGoI21lPB6FLAVsOxDMARPvGg3Tg2Qq9xo3EFI9LeP7xkiRmGeNFIXgULPq1ULsSHrNwWXw61RcOx5/ZwHCZzSw4zue1VUp+77fDlUP2uIQse7q0j9dJNJQtrfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lOMn2P9i; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lOMn2P9i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761349883; x=1792885883;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kg/sFbQ5ZF67NU7RVAArHvgGi0lNHjwpD8KFw0mm0RU=;
  b=lOMn2P9iF2hG6R83rVfDZDVo5hC33aOU+k5APag9tYgPWpJxM1xiq9l1
   6Ye9E0pFAxUxlt791m0hDWU36h2QlSoTihq02o4OVUfvBL97/Zd0LCIew
   q6BR+ROWgT17NHzYJw+u8EoBOL6hHgTOpqyLie6fO6iJxECP/Deql2RbU
   kzO+9LJ1AkKnjkySgNW1KaubPnbyhDqJgRuuUCP/Aqd3YoSHLMfywXd0Z
   WIBi/Y8wIXTMqzIm2POCcI0fGUFK1JOV+w8Cd08eVkpFgM9pgVQse0qnc
   hllP+yQXrmgQFkG04p5p29Pyu+6Sb3MtedGWHf0lsoB0H2xn5mEoNRiPo
   A==;
X-CSE-ConnectionGUID: TTe/HJGjSHmtsbXrR46BjA==
X-CSE-MsgGUID: YXJzOJWJTySPZn8YvCqahA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63424861"
X-IronPort-AV: E=Sophos;i="6.19,253,1754982000"; 
   d="scan'208";a="63424861"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 16:51:22 -0700
X-CSE-ConnectionGUID: IpdDWz9vQoak8a9Ju28AVg==
X-CSE-MsgGUID: pAzEXL66Q82wPrDoVjD/Zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,253,1754982000"; 
   d="scan'208";a="185310520"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 24 Oct 2025 16:51:20 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vCRZ0-000Eyn-0R;
	Fri, 24 Oct 2025 23:51:18 +0000
Date: Sat, 25 Oct 2025 07:50:07 +0800
From: kernel test robot <lkp@intel.com>
To: Paulo Alcantara <pc@manguebit.org>, smfrench@gmail.com
Cc: oe-kbuild-all@lists.linux.dev, Jay Shin <jaeshin@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: handle lack of IPC in dfs_cache_refresh()
Message-ID: <202510250702.8oAy2KCd-lkp@intel.com>
References: <20251024024909.474285-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024024909.474285-1-pc@manguebit.org>

Hi Paulo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on cifs/for-next]
[also build test WARNING on linus/master v6.18-rc2 next-20251024]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Paulo-Alcantara/smb-client-handle-lack-of-IPC-in-dfs_cache_refresh/20251024-104948
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
patch link:    https://lore.kernel.org/r/20251024024909.474285-1-pc%40manguebit.org
patch subject: [PATCH] smb: client: handle lack of IPC in dfs_cache_refresh()
config: i386-randconfig-001-20251025 (https://download.01.org/0day-ci/archive/20251025/202510250702.8oAy2KCd-lkp@intel.com/config)
compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251025/202510250702.8oAy2KCd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510250702.8oAy2KCd-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: fs/smb/client/connect.c:2024 function parameter 'seal' not described in 'cifs_setup_ipc'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
