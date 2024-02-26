Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EF5605A6
	for <linux-cifs@vger.kernel.org>; Mon, 26 Feb 2024 13:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708954972; cv=none; b=Nq92/+H1Q8X/ocZjpYlk9Kw65UeyBZEqyLIVmT38Kw3wiXDGhsr+3sJSluFYrVmOTTG0Unx5JcmNASpMYRxXWp6NIFMnQ1dhsuYPvMxb0b9/ZRTNbFq6lVjLZPZy7pa50judW0+akDLpguMd42uu0FP74hUGPHrfwpcM7E+Q/+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708954972; c=relaxed/simple;
	bh=5VzFVl3ewLk1iaSOZQ+38ykbStvrzYHePQDBDpwVxvo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=BchovacWAy4a1P8b3V90/So1QrGq70i+91vOrNyScUgDbu/Bpx8a9T+FLskvTHEaFCWSMIkj3i5QdzIUc4Lt81m0u19VhSny353rzut0LG/l8ihVY8wtdl9r8MRL9m4ErZkzmxQTy5OpJBcz13IPypYXzlGjmxap/fShLdWFhOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RBJzfTPl; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RBJzfTPl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708954971; x=1740490971;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=5VzFVl3ewLk1iaSOZQ+38ykbStvrzYHePQDBDpwVxvo=;
  b=RBJzfTPlsM9c8R96UgOBtJTZx24L8aP0HVucYgXiE8/WKILwV70e6V7h
   mXNFq9ORhsrCrXtguLdvvlf77zfR4x4XNlAuu5SbwqW8GXWDzvuHwTwTF
   yfWoyRqFLGRg5yFN6jL+QxPL7E+0xPP/sAdCfuDONebjUAKAKcQsAoBjZ
   Crh+iyw1yyy/jYVRwyMTSivSC/tfvCeh2/oU6ymEiV348DyQioQO5mlrc
   mT8n+xhzE1mX9tnP6TU97UFxFasl6vaOTihs9lWALPpz3c7WE3qIMt/wb
   VDmkMQ8B9eYKMVLv6p4nbSKPrlNjVH1LooO/UfbR9vp+JxavyOr17oWgh
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3355309"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3355309"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 05:42:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="29849301"
Received: from lkp-server02.sh.intel.com (HELO 3c78fa4d504c) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 26 Feb 2024 05:42:48 -0800
Received: from kbuild by 3c78fa4d504c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rebFl-000AKY-1V;
	Mon, 26 Feb 2024 13:42:45 +0000
Date: Mon, 26 Feb 2024 21:42:38 +0800
From: kernel test robot <lkp@intel.com>
To: Paulo Alcantara <pc@manguebit.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>
Subject: [cifs:for-next 17/19] fs/smb/client/cifsglob.h:162:26: warning:
 'cifs_reparse_type_str' defined but not used
Message-ID: <202402262152.YZOwDlCM-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   5fae8cba6fedfdec784c69b803120ac074d48145
commit: d0adfca80208fa7ffbdd76eb701807de55c0e14b [17/19] smb: client: return reparse type in /proc/mounts
config: i386-randconfig-002-20240226 (https://download.01.org/0day-ci/archive/20240226/202402262152.YZOwDlCM-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240226/202402262152.YZOwDlCM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202402262152.YZOwDlCM-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from fs/smb/client/namespace.c:19:
>> fs/smb/client/cifsglob.h:162:26: warning: 'cifs_reparse_type_str' defined but not used [-Wunused-const-variable=]
     162 | static const char *const cifs_reparse_type_str[] = { "nfs", "wsl", };
         |                          ^~~~~~~~~~~~~~~~~~~~~


vim +/cifs_reparse_type_str +162 fs/smb/client/cifsglob.h

   161	
 > 162	static const char *const cifs_reparse_type_str[] = { "nfs", "wsl", };
   163	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
