Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795348290;
	b=r5hovLIGTINzTwHf0uWX3KU9b1gsVs8pGIkhaHrJB94LrWU1Q5kEeZJtPFbBk3DVt/J7
	 7pB0eTflwJ5JbuW+G0fJ6eqsg/txqk0wkqhkFY+0Zqmbi0WifKPvsRehD/RMYAjr5tya6
	 XNQvfW/79w5/gRvvhZxRMtjNnEpr+pT9a4LcCM0Y7qmxHO2W9/hkw6Ij08SJVvOF7g1Xy
	 H8WWJtJMJRBcn3c9FmibT8zDVwRKgcE0d+R64kFVHpi+Nz6fUO+Dhk4nxlQMuppl0XAwm
	 xCtLN5MbljwwJYTtmOTdPLD1o+qfEV8HUN3UiTQCiNHqG8Et1boRDjHw44LwcEsGm/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795348290;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=SdLr6yRqTSIXIq9q/8cXAbS05lzrBdYrcWskButSjtc=;
	b=ZkZdLz8jiHJ+t0tEA2Ejuk2Traw18SXul4LP2b6lZsHyZGlSusVAjP7f+yNJ+QvByplY
	 opJXub1w7NvFlYkhVCuMS5+owzsA5/obusbMeKH/abkatMEiRemRdsBc+MyfriMJFbUUP
	 CAYkMEj9s5v3ACfrPAhUXPId2ogHfDRqJnO0MtLaFN5DpOIgScYNkxn2mPImIq0Vm4J8/
	 t76dqX82VWfCrteHVS9Sa3jqLnTatU3qRz35Ws0vokKhyGtpJfkuG/JEdREmVDex6Lpgu
	 evK3JOWGFe/8KPHYZVVAyAHr210FhaLQfg8I5NAzsaMmMpB3KhbRvQC0JxSR5mOmz1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=STCTzFZv;
	arc=none smtp.remote-ip=192.198.163.13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952E0606A32C;
	Sun, 22 Nov 2026 11:51:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 952E0606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=STCTzFZv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795348290; x=1826884290;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=o8bfGSGMC+XTLsw+DBGSIpRTxrHzS+tPO1ZCb6rISAA=;
  b=STCTzFZvNFSXH/2jGMmlOZm4kGSwrAkgIdEcZvARGeiHWF9+1WtXYvXs
   pDaUvURXksxbJzESjSSyGIUKJ9hjNtFAvh3jmwNHjrZAe2/Q4FzXnUTUd
   M01mtpwoRKwsZpfwo0kO32nne3efL8q7Ta5IenonLoJ2qP6eFIlrbQHMi
   22ykZUHaclUT8iPw5jyH2Eobay7tDnWt4ACDRO0/fc6pRlpLs3Hqyj8PC
   fYeWgxaAkQMpx0L5iuLAvOkaaYJa4gtMF88U47Vl+7Ln47msBCpQ67RRe
   AhVd8IdPtycgmFsaCyYGk4a9LIwLEj0N+tRxFwRKMNm9idy333J759NbZ
   g==;
X-CSE-ConnectionGUID: SZV0q7kSRNCHWrO5iKMNbg==
X-CSE-MsgGUID: ZVIV1o53ROChoYIPox+7rA==
X-IronPort-AV: E=McAfee;i="6800,10657,11973"; a="4153944"
X-IronPort-AV: E=Sophos;i="6.27,226,1787036400"; 
   d="scan'208";a="4153944"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2026 03:51:29 -0800
X-CSE-ConnectionGUID: xYeKisuzT2KLsMkMzHwYOg==
X-CSE-MsgGUID: v+D3S8fRQDmlWO0gMXE05g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,226,1787036400"; 
   d="scan'208";a="11012790"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 22 Nov 2026 03:51:26 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xV66N-00000001LTS-1lxt;
	Sun, 22 Nov 2026 11:51:23 +0000
Date: Sun, 22 Nov 2026 19:50:47 +0800
From: kernel test robot <lkp@intel.com>
To: Fredric Cover <fredric.cover.lkernel@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: convert DFS target node name from cache
 charset on mount
Message-ID: <202611221905.fQpuvetd-lkp@intel.com>
References: <20261122045841.99012-1-fredric.cover.lkernel@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261122045841.99012-1-fredric.cover.lkernel@gmail.com>

Hi Fredric,

kernel test robot noticed the following build errors:

[auto build test ERROR on manguebit/cifs-next]
[also build test ERROR on manguebit/cifs-fixes linus/master v7.4-rc3 next-20261120]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Fredric-Cover/smb-client-convert-DFS-target-node-name-from-cache-charset-on-mount/20261122-045840
base:   https://git.manguebit.org/linux.git cifs-next
patch link:    https://lore.kernel.org/r/20261122045841.99012-1-fredric.cover.lkernel%40gmail.com
patch subject: [PATCH] smb: client: convert DFS target node name from cache charset on mount
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20261122/202611221905.fQpuvetd-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261122/202611221905.fQpuvetd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611221905.fQpuvetd-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/smb/client/dfs.c: In function 'dfs_parse_target_referral':
>> fs/smb/client/dfs.c:44:21: error: implicit declaration of function 'dfs_cache_local_path'; did you mean 'dfs_cache_canonical_path'? [-Wimplicit-function-declaration]
      44 |         node_name = dfs_cache_local_path(ref->node_name, ctx->local_nls);
         |                     ^~~~~~~~~~~~~~~~~~~~
         |                     dfs_cache_canonical_path
>> fs/smb/client/dfs.c:44:19: error: assignment to 'char *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
      44 |         node_name = dfs_cache_local_path(ref->node_name, ctx->local_nls);
         |                   ^


vim +44 fs/smb/client/dfs.c

    13	
    14	/**
    15	 * dfs_parse_target_referral - set fs context for dfs target referral
    16	 *
    17	 * @full_path: full path in UNC format.
    18	 * @ref: dfs referral pointer.
    19	 * @ctx: smb3 fs context pointer.
    20	 *
    21	 * Return zero if dfs referral was parsed correctly, otherwise non-zero.
    22	 */
    23	int dfs_parse_target_referral(const char *full_path, const struct dfs_info3_param *ref,
    24				      struct smb3_fs_context *ctx)
    25	{
    26		int rc;
    27		const char *prepath = NULL;
    28		char *node_name = NULL;
    29		char *path;
    30	
    31		if (!full_path || !*full_path || !ref || !ctx)
    32			return -EINVAL;
    33	
    34		if (WARN_ON_ONCE(!ref->node_name || ref->path_consumed < 0))
    35			return -EINVAL;
    36	
    37		if ((size_t)ref->path_consumed < strlen(full_path)) {
    38			prepath = full_path + ref->path_consumed;
    39			/* skip initial delimiter */
    40			if (*prepath == '/' || *prepath == '\\')
    41				prepath++;
    42		}
    43	
  > 44		node_name = dfs_cache_local_path(ref->node_name, ctx->local_nls);
    45		if (IS_ERR(node_name))
    46			return PTR_ERR(node_name);
    47	
    48		path = cifs_build_devname(node_name, prepath);
    49		kfree(node_name);
    50		if (IS_ERR(path))
    51			return PTR_ERR(path);
    52	
    53		rc = smb3_parse_devname(path, ctx);
    54		if (rc)
    55			goto out;
    56	
    57		rc = dns_resolve_unc(DFS_DOM(ctx), path,
    58				     (struct sockaddr *)&ctx->dstaddr);
    59	out:
    60		kfree(path);
    61		return rc;
    62	}
    63	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
