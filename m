Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD313402430;
	Thu, 30 Apr 2026 12:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777551150; cv=none; b=MQ+Qk6ZUzt1ve4bFmK85MLWxAb2ghnFcdvIn5R/cEZz3SBKdvSRiyJMMWitSIbjYv5aiJPr7RIEkMlX25c/d5TT+dTRoOqOgQFdadk2Qgzt3ABkXOmcQFa+WfoHDx2sqgM+ix1MqL/wsQLUEDVDWjizXWr7//8QpwDXqrF9vND8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777551150; c=relaxed/simple;
	bh=4YV9b18f8f4b5MeLSUeaxJ5IPV69qM3nQn3s4UPwTy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R7SXikhc2CmUoyUi6J3yhUbc7kUEwnlcaX7DE9ctPsRS5fPq18RfzvP3ycSsuQsjMoIi1ox33mm2fzgZJE4Ke9ygBmkgVXwuF967/zv2fi6n+mmRoqepLKr52As25AO2pGJsEAggDb4Bt1NsNM49kHZpq3mAj8xp2KH2mox+cfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C37fcfCF; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C37fcfCF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777551149; x=1809087149;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4YV9b18f8f4b5MeLSUeaxJ5IPV69qM3nQn3s4UPwTy8=;
  b=C37fcfCFczQ0FIMuLjycdVCdwBpgCFaQ2nocKAtY047KgCZIDW15shwg
   MZS44UBgXgYHUhCaarDgYTDi5njJ1dPZKTFbI3rf9jWgy8o0isjAuHr4U
   S8it2iJDasJuLE4Ebk0aaFMIb/1CDoFKKyt7orZZGeal2MQ9IL2tzOYLR
   e/r4SX+unc0FJVOyGVb1V8ux6LYzPvh78LtKpWUjHPzec954eo5WTHpDP
   Ikf4e/hhZmTud18keft8j7EHbc+7gzpZY/Puo5ckgZrLDMT0I/TVuuL1b
   87RL0EOFg2+N3ICRd7TJftkMhptZ83t4d2mW0divhyz6lsMkiscZbJGaQ
   A==;
X-CSE-ConnectionGUID: Sj4x6LNAQcatnThk76/CwQ==
X-CSE-MsgGUID: whBKYgmiRh+brJ4IRsDgwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="77664034"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="77664034"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 05:12:28 -0700
X-CSE-ConnectionGUID: Dq6Uoh7LT6yvJqZLcghOxg==
X-CSE-MsgGUID: 1AxaonX6S+WHSxvpsffp5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="258143804"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 30 Apr 2026 05:12:24 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIQFh-00000000CNa-211v;
	Thu, 30 Apr 2026 12:12:21 +0000
Date: Thu, 30 Apr 2026 20:11:20 +0800
From: kernel test robot <lkp@intel.com>
To: Arnd Bergmann <arnd@kernel.org>, Steve French <sfrench@samba.org>,
	Enzo Matsumiya <ematsumiya@suse.de>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smb: client: hide unused cifs_debug_dirs_proc_ops
Message-ID: <202604302014.zKNhMog5-lkp@intel.com>
References: <20260423065042.1898971-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423065042.1898971-1-arnd@kernel.org>

Hi Arnd,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20260424]
[also build test ERROR on linus/master v7.1-rc1]
[cannot apply to v7.0 v7.0-rc7 v7.0-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Arnd-Bergmann/smb-client-hide-unused-cifs_debug_dirs_proc_ops/20260426-163431
base:   next-20260424
patch link:    https://lore.kernel.org/r/20260423065042.1898971-1-arnd%40kernel.org
patch subject: [PATCH] smb: client: hide unused cifs_debug_dirs_proc_ops
config: i386-randconfig-017-20260430 (https://download.01.org/0day-ci/archive/20260430/202604302014.zKNhMog5-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260430/202604302014.zKNhMog5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604302014.zKNhMog5-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/smb/client/cifs_debug.c:937:48: error: use of undeclared identifier 'cifs_debug_dirs_proc_ops'; did you mean 'cifs_debug_dirs_proc_show'?
     937 |         proc_create("open_dirs", 0600, proc_fs_cifs, &cifs_debug_dirs_proc_ops);
         |                                                       ^~~~~~~~~~~~~~~~~~~~~~~~
         |                                                       cifs_debug_dirs_proc_show
   fs/smb/client/cifs_debug.c:298:12: note: 'cifs_debug_dirs_proc_show' declared here
     298 | static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
         |            ^
   1 error generated.

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for MFD_STMFX
   Depends on [n]: HAS_IOMEM [=y] && I2C [=y] && OF [=n]
   Selected by [y]:
   - PINCTRL_STMFX [=y] && PINCTRL [=y] && I2C [=y] && HAS_IOMEM [=y]


vim +937 fs/smb/client/cifs_debug.c

^1da177e4c3f41 fs/cifs/cifs_debug.c       Linus Torvalds    2005-04-16  922  
^1da177e4c3f41 fs/cifs/cifs_debug.c       Linus Torvalds    2005-04-16  923  void
^1da177e4c3f41 fs/cifs/cifs_debug.c       Linus Torvalds    2005-04-16  924  cifs_proc_init(void)
^1da177e4c3f41 fs/cifs/cifs_debug.c       Linus Torvalds    2005-04-16  925  {
36a5aeb8787fbf fs/cifs/cifs_debug.c       Alexey Dobriyan   2008-04-29  926  	proc_fs_cifs = proc_mkdir("fs/cifs", NULL);
^1da177e4c3f41 fs/cifs/cifs_debug.c       Linus Torvalds    2005-04-16  927  	if (proc_fs_cifs == NULL)
^1da177e4c3f41 fs/cifs/cifs_debug.c       Linus Torvalds    2005-04-16  928  		return;
^1da177e4c3f41 fs/cifs/cifs_debug.c       Linus Torvalds    2005-04-16  929  
3f3942aca6da35 fs/cifs/cifs_debug.c       Christoph Hellwig 2018-05-15  930  	proc_create_single("DebugData", 0, proc_fs_cifs,
3f3942aca6da35 fs/cifs/cifs_debug.c       Christoph Hellwig 2018-05-15  931  			cifs_debug_data_proc_show);
^1da177e4c3f41 fs/cifs/cifs_debug.c       Linus Torvalds    2005-04-16  932  
dfe33f9abc0899 fs/cifs/cifs_debug.c       Steve French      2018-10-30  933  	proc_create_single("open_files", 0400, proc_fs_cifs,
dfe33f9abc0899 fs/cifs/cifs_debug.c       Steve French      2018-10-30  934  			cifs_debug_files_proc_show);
dfe33f9abc0899 fs/cifs/cifs_debug.c       Steve French      2018-10-30  935  
17d912d54f2305 fs/smb/client/cifs_debug.c Enzo Matsumiya    2026-04-22  936  #ifdef CONFIG_CIFS_DEBUG
17d912d54f2305 fs/smb/client/cifs_debug.c Enzo Matsumiya    2026-04-22 @937  	proc_create("open_dirs", 0600, proc_fs_cifs, &cifs_debug_dirs_proc_ops);
17d912d54f2305 fs/smb/client/cifs_debug.c Enzo Matsumiya    2026-04-22  938  #else /* CONFIG_CIFS_DEBUG */
17d912d54f2305 fs/smb/client/cifs_debug.c Enzo Matsumiya    2026-04-22  939  	proc_create_single("open_dirs", 0400, proc_fs_cifs, cifs_debug_dirs_proc_show);
17d912d54f2305 fs/smb/client/cifs_debug.c Enzo Matsumiya    2026-04-22  940  #endif /* !CONFIG_CIFS_DEBUG */
97a32539b9568b fs/cifs/cifs_debug.c       Alexey Dobriyan   2020-02-03  941  	proc_create("Stats", 0644, proc_fs_cifs, &cifs_stats_proc_ops);
97a32539b9568b fs/cifs/cifs_debug.c       Alexey Dobriyan   2020-02-03  942  	proc_create("cifsFYI", 0644, proc_fs_cifs, &cifsFYI_proc_ops);
97a32539b9568b fs/cifs/cifs_debug.c       Alexey Dobriyan   2020-02-03  943  	proc_create("traceSMB", 0644, proc_fs_cifs, &traceSMB_proc_ops);
6539e7f3727ab9 fs/cifs/cifs_debug.c       Ronnie Sahlberg   2018-05-24  944  	proc_create("LinuxExtensionsEnabled", 0644, proc_fs_cifs,
97a32539b9568b fs/cifs/cifs_debug.c       Alexey Dobriyan   2020-02-03  945  		    &cifs_linux_ext_proc_ops);
6539e7f3727ab9 fs/cifs/cifs_debug.c       Ronnie Sahlberg   2018-05-24  946  	proc_create("SecurityFlags", 0644, proc_fs_cifs,
97a32539b9568b fs/cifs/cifs_debug.c       Alexey Dobriyan   2020-02-03  947  		    &cifs_security_flags_proc_ops);
6539e7f3727ab9 fs/cifs/cifs_debug.c       Ronnie Sahlberg   2018-05-24  948  	proc_create("LookupCacheEnabled", 0644, proc_fs_cifs,
97a32539b9568b fs/cifs/cifs_debug.c       Alexey Dobriyan   2020-02-03  949  		    &cifs_lookup_cache_proc_ops);
54be1f6c1c3749 fs/cifs/cifs_debug.c       Paulo Alcantara   2018-11-14  950  
94b0595a8e018c fs/cifs/cifs_debug.c       Aurelien Aptel    2021-03-18  951  	proc_create("mount_params", 0444, proc_fs_cifs, &cifs_mount_params_proc_ops);
94b0595a8e018c fs/cifs/cifs_debug.c       Aurelien Aptel    2021-03-18  952  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
