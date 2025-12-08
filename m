Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B985154BF5;
	Mon,  8 Dec 2025 21:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765229413; cv=none; b=mxnYYeqzsOJY9h5qsE9CaGPHW/1+x1WolbqBS2ZJyKJVKw3EFDuuncOED/fS4hjx5I6snEsZU/JYcLXgMOe6ZAJeCdYizCswof00gA2AaUvDfHi/n1hWDeJxn5bO1FfGyDCUpIoiR7gMWcMZH4lxUEay9S/uOmaYYIjuMDRhRmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765229413; c=relaxed/simple;
	bh=dSjRYMAUi+Fh7KbgzZuw4JPY3nICl9XaJqm4MWGB49I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=moCxJB/vCf/ttIjMrwibp2Do7ZhQblR3HdrPbYH6zHyoaND0Ss1+ZiUZOhyR4kj8zR+a6in5wBsif8/+4nlrx3D5ZcpP4EdjyXNO6wJxP9c2mdLADTB0QoJRTvQRBujZYuHxMDWwEFTC41miA56KR1YRo5yDnpqUGMpctlyNeZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=maG8/Yby; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="maG8/Yby"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765229412; x=1796765412;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dSjRYMAUi+Fh7KbgzZuw4JPY3nICl9XaJqm4MWGB49I=;
  b=maG8/YbyXXG1hoGIfOIkwHPqpcJ9S+7kN8g9dSYeiWqL4IzY4WkVwmCp
   dwa+Dqyt1/msndHQIAAeqoLwqC8JgBfqYb3c5fdS9yysWWFbSfT5VVbb+
   o48dlKw2drg/Nkg0NS0c/l7DVJma4+38XyzRZqflKli0sA6w64bCKQATt
   uBMd8x9lyRXo7go3uJ9Xpd/Hd7Di2JCZiPERynfFgUNEwqHRdMBAhmomZ
   ofNxohyaZuM52ZY2ZgA7kDkVlC8+cgt30YjCgczGx1XT27CD3sxb7KJ7F
   OzesIkPgsQM65XwzZ0bxkyLSUrZ0V4c73UoqJfJiOQvHeTdEydd46UVUC
   g==;
X-CSE-ConnectionGUID: Dfk1I395RZ2Hj2LQa7ugaw==
X-CSE-MsgGUID: N27oqpnbTXm8LaRL+JEqvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="69771987"
X-IronPort-AV: E=Sophos;i="6.20,259,1758610800"; 
   d="scan'208";a="69771987"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 13:30:11 -0800
X-CSE-ConnectionGUID: jP1R5lP0QQON8jm1kSvOZA==
X-CSE-MsgGUID: YtrADeo/QX2B6BVobaAPzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,259,1758610800"; 
   d="scan'208";a="201163656"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 08 Dec 2025 13:30:09 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vSio1-000000000sP-2vJg;
	Mon, 08 Dec 2025 21:30:05 +0000
Date: Tue, 9 Dec 2025 05:29:25 +0800
From: kernel test robot <lkp@intel.com>
To: chenxiaosong.chenxiaosong@linux.dev, sfrench@samba.org,
	smfrench@gmail.com, linkinjeon@kernel.org, linkinjeon@samba.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
	liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v4 08/10] smb/client: introduce smb2maperror KUnit tests
Message-ID: <202512090558.gcQGSnU4-lkp@intel.com>
References: <20251206151826.2932970-9-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251206151826.2932970-9-chenxiaosong.chenxiaosong@linux.dev>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on brauner-vfs/vfs.all]
[also build test ERROR on linus/master v6.18]
[cannot apply to cifs/for-next next-20251208]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/chenxiaosong-chenxiaosong-linux-dev/smb-client-reduce-loop-count-in-map_smb2_to_linux_error-by-half/20251206-232731
base:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.all
patch link:    https://lore.kernel.org/r/20251206151826.2932970-9-chenxiaosong.chenxiaosong%40linux.dev
patch subject: [PATCH v4 08/10] smb/client: introduce smb2maperror KUnit tests
config: i386-randconfig-004-20251208 (https://download.01.org/0day-ci/archive/20251209/202512090558.gcQGSnU4-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251209/202512090558.gcQGSnU4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512090558.gcQGSnU4-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: kunit_binary_str_assert_format
   >>> referenced by smb2maperror_test.c:40 (fs/smb/client/smb2maperror_test.c:40)
   >>>               fs/smb/client/smb2maperror.o:(maperror_test_check_search) in archive vmlinux.a

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
