Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743F1359A89;
	Wed, 29 Apr 2026 23:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777504031; cv=none; b=MveCaYX/uhnS1OdmI61gLHzJhNuVVTuuYCF7Zq7oXfaDU2ndijhF3nnJPDw9vo6zrs4G9AwOCkanxGZAg4HoaFsqlIhpt8F4+ChMmNBFaa9HB+Yb9m03JWOzrG5xqifoNQzUZzNHyz1Abw5h10ZGbVqk9zyiVlXp6hZXfDI7M/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777504031; c=relaxed/simple;
	bh=JTlhJ9osmBzwut4VSM8c5XR2dSqQSlr9sygStqPGqhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bPaPw05Aquq+tcuZ+XYuIAYRuL2JD7BFcBkB8EPRPBLkwwf44F4yT34PdpmZPzrhevyQX+N/VwuCOftvQ1lnhUrMi3lQTDOwvIcnVqUVa0IPblCOU8vT0LTGFHbPGGUtIHo2zHdBKk/2cYy3aIhi9ppySPv4hq/dOjBal8FYiUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IBvy7tOO; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IBvy7tOO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777504030; x=1809040030;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JTlhJ9osmBzwut4VSM8c5XR2dSqQSlr9sygStqPGqhw=;
  b=IBvy7tOO63Wo0QGneM7w5lKpEDE4NMNhYoWWvin8D+eQUmbjVMnhfuer
   8zkxrL6OgkN1Q9AfO1JbyWjQDevGlDb60sGy58km4zR8dZ+fGLU/R3jww
   jCE8V02QXBq2oiX1YbRcob7ycCch1du8Dsd7n5MXwQsCh9efmt3uNcRfm
   MQ+SgWhk3IZ4TFUb2A9FtoWdArvGcgH+WQml8vgMMH+tTikxl7CTQQSBr
   zSz5j5+U47n9C1S8Lm94WWhJzyXNMgX95vif7il0piFFuKROUbIcYE0rS
   uFyz5wMEyrqM9Zeny0yOr02u6SbcWv3s0CqPl1Z+51XVpIRjz987ATsQt
   Q==;
X-CSE-ConnectionGUID: 7wmx5FXxSD2mKW51Un0HRQ==
X-CSE-MsgGUID: VB2RWoEXRrmlMYdg1LooUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="77611433"
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="77611433"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 16:07:09 -0700
X-CSE-ConnectionGUID: VC1tCHacRSWbNay9m+nl0g==
X-CSE-MsgGUID: toe1Wfn8RzKFGVtaYgts5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="234676554"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 29 Apr 2026 16:07:06 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIDzi-00000000Bd8-1zWM;
	Wed, 29 Apr 2026 23:07:02 +0000
Date: Thu, 30 Apr 2026 07:06:18 +0800
From: kernel test robot <lkp@intel.com>
To: Arnd Bergmann <arnd@kernel.org>, Steve French <sfrench@samba.org>,
	Enzo Matsumiya <ematsumiya@suse.de>
Cc: oe-kbuild-all@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smb: client: hide unused cifs_debug_dirs_proc_ops
Message-ID: <202604300622.95X1Ab1U-lkp@intel.com>
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
config: microblaze-defconfig (https://download.01.org/0day-ci/archive/20260430/202604300622.95X1Ab1U-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260430/202604300622.95X1Ab1U-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604300622.95X1Ab1U-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/smb/client/cifs_debug.c: In function 'cifs_proc_init':
>> fs/smb/client/cifs_debug.c:937:55: error: 'cifs_debug_dirs_proc_ops' undeclared (first use in this function); did you mean 'cifs_debug_dirs_proc_show'?
     937 |         proc_create("open_dirs", 0600, proc_fs_cifs, &cifs_debug_dirs_proc_ops);
         |                                                       ^~~~~~~~~~~~~~~~~~~~~~~~
         |                                                       cifs_debug_dirs_proc_show
   fs/smb/client/cifs_debug.c:937:55: note: each undeclared identifier is reported only once for each function it appears in
   fs/smb/client/cifs_debug.c: At top level:
   fs/smb/client/cifs_debug.c:298:12: warning: 'cifs_debug_dirs_proc_show' defined but not used [-Wunused-function]
     298 | static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~


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
