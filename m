Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795344926;
	b=MyfAO8AAJ3z20DE9AzhMJI5/pOWiqWdSnTdcqmE2NkdcoyThuW+JhOO5GczvP3P1Gniq
	 aGdW2q9JY9Hb+mXdkbREehPn4KSJfbxp1sLeGi06TCI+s5qZuI991sEWcOgRZeBcZIgtb
	 dmt5Zh8Iyn0tymNrVet+iwdGDhgkDyDBxPvoQUr5rDY420sYNFafODaXhVGZ/BmmoeLIC
	 PD3zy6l8l8ZhlB6cudA9POEfS1SW3hf7Eq7gpnL4n3uRBi/tDNGESLDC8FVCG3uchN+NJ
	 MQRxzM26QMCXNmb6HM1+iN9e0AgKtTsYnxfTQyF20NW7gzBdfQCEX5tDcD9oF2TCKBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795344926;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=htlF7oEfA9CRHLcQDE/3KmaHb2HDiaLlK6R0vwijegk=;
	b=3c+PTp+mBgACxYKP3s3RZR7FJuIMb1Mt8bFoSi8oxRoLUwIlEWFGKMzaHSEm46N4TfVQ
	 U9gC6UwxHjPj9Ugw7gLTBopf0oISn7wi7gcqyTJm54GsP5ShFH3g+S4911lfL5yDKhnMn
	 0USW0QnDalipzpeSKKlq+rsx6CzBf1eYaWzPhvQKKH3yjYBu+v3VqM2CiNrKLWa117Cty
	 0NQmYwgx8a/TydzgHw83inN4jwApak15GLlDmIyILTi6PLx5i1w62yKO9K4MJTggMYutM
	 YugpJAfg6pxG0yCOL4Y6Yp/aLgj8RNisiYHM5X8Yln+xTwqccVbVv/vTNMAjQJEW3dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="LTUoQoV/";
	arc=none smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B3D606A32A;
	Sun, 22 Nov 2026 10:55:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81B3D606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=LTUoQoV/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795344926; x=1826880926;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qOh3V320T7Lr+wqFp+bxyvJuZr+uXw9iFnWVu0o0WVU=;
  b=LTUoQoV/XqRzqNur2lFaVtJNZEppou7bcw3WLC2r4WhESqOQ24QVYwrV
   RXGRs0yridDSZm5rMn9zejZ2QROLRnX87u+CfYzLUpniK7b0oqdKVQbQ0
   3SoZ8rIqarTkIdJMld2R28HwTtNS3KY1OZhdKxxHBFHHfgTGHMNqKNWNF
   m5nhnWJDlb/QL4go0fn7D2GZ3uzSXKpmFgCYcQ5foTX+JoMn1lZNJ+z9L
   wn3HynkSxkUDrFu2DIUwcXLQtpNfmGgx0PB6L13+QgwXXloFYSO0pFdn0
   rmWkrDCV7IOIipJLRmF1h2NXKRIRxQv+KYWdTQQFbkwcBOBrt9Fn4Qc5X
   A==;
X-CSE-ConnectionGUID: dLpWQncXRWWHjcirvBCuww==
X-CSE-MsgGUID: livIUt5eTuWBH+M+aoZboA==
X-IronPort-AV: E=McAfee;i="6800,10657,11973"; a="4176362"
X-IronPort-AV: E=Sophos;i="6.27,226,1787036400"; 
   d="scan'208";a="4176362"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2026 02:55:25 -0800
X-CSE-ConnectionGUID: 2zpbDEdLSnuxhKe+aV/kbA==
X-CSE-MsgGUID: UOKUGlJpR3CgkcuknrzOPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,226,1787036400"; 
   d="scan'208";a="10943927"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 22 Nov 2026 02:55:22 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xV5E7-00000001LN4-1jX6;
	Sun, 22 Nov 2026 10:55:19 +0000
Date: Sun, 22 Nov 2026 18:54:55 +0800
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
Message-ID: <202611221813.BN4gUWsn-lkp@intel.com>
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

kernel test robot noticed the following build warnings:

[auto build test WARNING on manguebit/cifs-next]
[also build test WARNING on manguebit/cifs-fixes linus/master v7.4-rc3 next-20261120]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Fredric-Cover/smb-client-convert-DFS-target-node-name-from-cache-charset-on-mount/20261122-045840
base:   https://git.manguebit.org/linux.git cifs-next
patch link:    https://lore.kernel.org/r/20261122045841.99012-1-fredric.cover.lkernel%40gmail.com
patch subject: [PATCH] smb: client: convert DFS target node name from cache charset on mount
config: xtensa-randconfig-1000-20261122 (https://download.01.org/0day-ci/archive/20261122/202611221813.BN4gUWsn-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261122/202611221813.BN4gUWsn-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611221813.BN4gUWsn-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/smb/client/dfs.c: In function 'dfs_parse_target_referral':
   fs/smb/client/dfs.c:44:14: error: implicit declaration of function 'dfs_cache_local_path'; did you mean 'dfs_cache_canonical_path'? [-Werror=implicit-function-declaration]
     node_name = dfs_cache_local_path(ref->node_name, ctx->local_nls);
                 ^~~~~~~~~~~~~~~~~~~~
                 dfs_cache_canonical_path
>> fs/smb/client/dfs.c:44:12: warning: assignment to 'char *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     node_name = dfs_cache_local_path(ref->node_name, ctx->local_nls);
               ^
   cc1: some warnings being treated as errors


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
