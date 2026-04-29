Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B9E39E6C9;
	Wed, 29 Apr 2026 20:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777495076; cv=none; b=SNjBzl96TYJMa7HR0dQgr6St5yTcSlK/mCsgnAqQimwmGO+hcMM5HCGPZ1wHHzFbR60UzVzkbiL4yOsx/EE4zbXkERiQeto1aSgP4z8HlmWGM2SmaYOEOlvnMPGLkPZLJzV71+BUiI7txvHtCG4xcWK/71V78GBHcFJcti6fIOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777495076; c=relaxed/simple;
	bh=8voSFhsIqpJgJv2rsK+vEfMA+7ngN84+iPwcq1+9Ebg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ip2TBCrH5SSflNGBUKsdnPhwQgJjhz9JJYtGBAb+wlsmUlhPh0eT924Dp4kIwwC/Kug+upkdCUYVYztrHJ2K6H4WxXU30am3hsFMQ4mRb/vYvxWBTjCBQ7QmcKenOYULmV/x6Ygc+27s7QxJoxcJlGkxlmMzNrZUS3WrLYjsSxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KFX5pHvi; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KFX5pHvi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777495075; x=1809031075;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8voSFhsIqpJgJv2rsK+vEfMA+7ngN84+iPwcq1+9Ebg=;
  b=KFX5pHviOn9mJi4OH/7rmPWyGNWX/w3sgNXl1pf4IxS7tmhCUI7KzMk1
   3dyeivqvFyJ+8wKzIeL8eCFGfFUgbtyzq5L2OGsZ1qjVHkz0rzrL8l8kI
   iAuiJrQ67ZVYk1zDBoIHGN3GOz6WL0cQqQXpkCpmyEePp1r+gMg3uWYhm
   7/lSvraduS5G618MUeqmkPPk58kufZ/jAEQQd3Qsg4IPtuiiCXlhQb1lQ
   j5/iEb54ov/y19M84ck2WDKO82V0J3irAEXJfEK0IG5aXAYjuRoq5svaI
   KbjSpnjvoUd7rIfrBL6Nu2eS4P6z81z6XHMyhV7oD5NioUWJG4V1AKX/Y
   g==;
X-CSE-ConnectionGUID: 1ym0WklhT/CKoBcCxlu0Yg==
X-CSE-MsgGUID: 2aFvXDkNTiWypD7lS4kzHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="78424038"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="78424038"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 13:37:54 -0700
X-CSE-ConnectionGUID: 49EM4J4FQ16wcpd/k8Rhgg==
X-CSE-MsgGUID: Fp5Oy9TcSyueZpA5tAh9Nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="257697621"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 29 Apr 2026 13:37:50 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIBfH-00000000BWC-3JVm;
	Wed, 29 Apr 2026 20:37:47 +0000
Date: Thu, 30 Apr 2026 04:37:37 +0800
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
Message-ID: <202604300441.heF8QVnl-lkp@intel.com>
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

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20260424]
[also build test WARNING on linus/master v7.1-rc1]
[cannot apply to v7.0 v7.0-rc7 v7.0-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Arnd-Bergmann/smb-client-hide-unused-cifs_debug_dirs_proc_ops/20260426-163431
base:   next-20260424
patch link:    https://lore.kernel.org/r/20260423065042.1898971-1-arnd%40kernel.org
patch subject: [PATCH] smb: client: hide unused cifs_debug_dirs_proc_ops
config: microblaze-defconfig (https://download.01.org/0day-ci/archive/20260430/202604300441.heF8QVnl-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260430/202604300441.heF8QVnl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604300441.heF8QVnl-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/smb/client/cifs_debug.c: In function 'cifs_proc_init':
   fs/smb/client/cifs_debug.c:937:55: error: 'cifs_debug_dirs_proc_ops' undeclared (first use in this function); did you mean 'cifs_debug_dirs_proc_show'?
     937 |         proc_create("open_dirs", 0600, proc_fs_cifs, &cifs_debug_dirs_proc_ops);
         |                                                       ^~~~~~~~~~~~~~~~~~~~~~~~
         |                                                       cifs_debug_dirs_proc_show
   fs/smb/client/cifs_debug.c:937:55: note: each undeclared identifier is reported only once for each function it appears in
   fs/smb/client/cifs_debug.c: At top level:
>> fs/smb/client/cifs_debug.c:298:12: warning: 'cifs_debug_dirs_proc_show' defined but not used [-Wunused-function]
     298 | static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~


vim +/cifs_debug_dirs_proc_show +298 fs/smb/client/cifs_debug.c

dfe33f9abc08997 fs/cifs/cifs_debug.c       Steve French   2018-10-30  297  
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28 @298  static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  299  {
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  300  	struct list_head *stmp, *tmp, *tmp1;
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  301  	struct TCP_Server_Info *server;
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  302  	struct cifs_ses *ses;
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  303  	struct cifs_tcon *tcon;
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  304  	struct cached_fids *cfids;
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  305  	struct cached_fid *cfid;
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  306  	LIST_HEAD(entry);
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  307  
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  308  	seq_puts(m, "# Version:1\n");
d492a4e7d4d64fc fs/smb/client/cifs_debug.c Arnd Bergmann  2026-04-23  309  #ifdef CONFIG_CIFS_DEBUG2
17d912d54f23058 fs/smb/client/cifs_debug.c Enzo Matsumiya 2026-04-22  310  	seq_puts(m, "# Write 0 to this file to drop all cached directory entries\n");
17d912d54f23058 fs/smb/client/cifs_debug.c Enzo Matsumiya 2026-04-22  311  #endif /* CONFIG_CIFS_DEBUG */
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  312  	seq_puts(m, "# Format:\n");
f78b83dce273ff2 fs/smb/client/cifs_debug.c Bharath SM     2025-10-30  313  	seq_puts(m, "# <tree id> <sess id> <persistent fid> <lease-key> <path>\n");
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  314  
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  315  	spin_lock(&cifs_tcp_ses_lock);
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  316  	list_for_each(stmp, &cifs_tcp_ses_list) {
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  317  		server = list_entry(stmp, struct TCP_Server_Info,
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  318  				    tcp_ses_list);
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  319  		list_for_each(tmp, &server->smb_ses_list) {
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  320  			ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  321  			list_for_each(tmp1, &ses->tcon_list) {
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  322  				tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  323  				cfids = tcon->cfids;
6976c7a69dafbb3 fs/smb/client/cifs_debug.c Wang Zhaolong  2025-08-29  324  				if (!cfids)
6976c7a69dafbb3 fs/smb/client/cifs_debug.c Wang Zhaolong  2025-08-29  325  					continue;
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  326  				spin_lock(&cfids->cfid_list_lock); /* check lock ordering */
63eb8bd6c81d84a fs/smb/client/cifs_debug.c Bharath SM     2025-09-29  327  				seq_printf(m, "Num entries: %d, cached_dirents: %lu entries, %llu bytes\n",
63eb8bd6c81d84a fs/smb/client/cifs_debug.c Bharath SM     2025-09-29  328  						cfids->num_entries,
63eb8bd6c81d84a fs/smb/client/cifs_debug.c Bharath SM     2025-09-29  329  						(unsigned long)atomic_long_read(&cfids->total_dirents_entries),
63eb8bd6c81d84a fs/smb/client/cifs_debug.c Bharath SM     2025-09-29  330  						(unsigned long long)atomic64_read(&cfids->total_dirents_bytes));
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  331  				list_for_each_entry(cfid, &cfids->entries, entry) {
f78b83dce273ff2 fs/smb/client/cifs_debug.c Bharath SM     2025-10-30  332  					seq_printf(m, "0x%x 0x%llx 0x%llx ",
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  333  						tcon->tid,
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  334  						ses->Suid,
f78b83dce273ff2 fs/smb/client/cifs_debug.c Bharath SM     2025-10-30  335  						cfid->fid.persistent_fid);
f78b83dce273ff2 fs/smb/client/cifs_debug.c Bharath SM     2025-10-30  336  					if (cfid->has_lease)
f78b83dce273ff2 fs/smb/client/cifs_debug.c Bharath SM     2025-10-30  337  						seq_printf(m, "%pUl ", cfid->fid.lease_key);
f78b83dce273ff2 fs/smb/client/cifs_debug.c Bharath SM     2025-10-30  338  					else
f78b83dce273ff2 fs/smb/client/cifs_debug.c Bharath SM     2025-10-30  339  						seq_puts(m, "- ");
f78b83dce273ff2 fs/smb/client/cifs_debug.c Bharath SM     2025-10-30  340  					seq_printf(m, "%s", cfid->path);
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  341  					if (cfid->file_all_info_is_valid)
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  342  						seq_printf(m, "\tvalid file info");
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  343  					if (cfid->dirents.is_valid)
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  344  						seq_printf(m, ", valid dirents");
63eb8bd6c81d84a fs/smb/client/cifs_debug.c Bharath SM     2025-09-29  345  					if (!list_empty(&cfid->dirents.entries))
63eb8bd6c81d84a fs/smb/client/cifs_debug.c Bharath SM     2025-09-29  346  						seq_printf(m, ", dirents: %lu entries, %lu bytes",
63eb8bd6c81d84a fs/smb/client/cifs_debug.c Bharath SM     2025-09-29  347  						cfid->dirents.entries_count, cfid->dirents.bytes_used);
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  348  					seq_printf(m, "\n");
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  349  				}
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  350  				spin_unlock(&cfids->cfid_list_lock);
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  351  			}
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  352  		}
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  353  	}
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  354  	spin_unlock(&cifs_tcp_ses_lock);
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  355  	seq_putc(m, '\n');
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  356  	return 0;
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  357  }
844e5c0eb1767d5 fs/smb/client/cifs_debug.c Steve French   2025-07-28  358  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
