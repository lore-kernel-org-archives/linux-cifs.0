Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.8
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795345708;
	b=DNeIo/hLX5safwrKfRJxwoahbha/cwcaE54hcOmoEuUgedbPdU77RqQsgnmTlkZ6hKZg
	 ogfUEGES560v3hTQMRX1m6ul4+t7galGC53p5mYVWwSiNtCukAv5Zupn4vVqlG/XPRjGq
	 hL/2tL9zfP2xt51s1Q0X8UiQawexeOQ/QX+Y0c/TyKZBUT+F12Hsbrqn8KeDZvlH8+xot
	 d2Te2xHlwySL8Hmz6hstL4tiNFbLy3yYQ7KjLHnqvnQYxV0s05o0AFVvQv+ERHPq/W91V
	 T6F9YKYVs0OKEJWP+rVp6aJNatYIkvlocTvK0CP6tciB5tw0PGlEjse+ujRxpxbESOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795345708;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=zaMyK3qppSY/fYqpLRU3S6YqAc+ypnqc7LNjt8K0pyk=;
	b=lUWIB5bcEtKItm3vQFbKKc3MlBhOLzWQoqF6p/bwlnHUZm/3a/gS2SD2+KPZIceRhXKW
	 x2U+q4eeGdcGIZtKBU7o1LIwCpPNK66cXaiZrJCSf1MXDhsQx3SeySQmKYlCh50R3v45j
	 TYExiIknxJqpB0OrBFfOzMof1nZHg7DPy7OZ6CpbRZb0m2pZw+b5OOA0tadQ/uve5b35v
	 DLFvSpwSg6YwN5LLBT6rTzlR5QQM1eFGoE6mnUSsKVTBlF6uP637ajc1Nu6SzeK0tOjJ1
	 A+Ywgy2oUwcnfWxCKwhUwdplpFIwxP4w+AXYw0hyVpJkoGHCkrlBkRhOrlXUmbrM0ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=DdqpONjr;
	arc=none smtp.remote-ip=192.198.163.8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594BA606A320;
	Sun, 22 Nov 2026 11:08:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 594BA606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=DdqpONjr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795345708; x=1826881708;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Bf24Esh6j16RVoOyDaMU6QwUfXI0Sy2eWmYeEUuCKT8=;
  b=DdqpONjrBeQzp4qOpcWXXuU7pEh4QGRQ86slKl+ZcIcSa2NjaYPA2a/J
   fmXhKIiFWCvSptFPl5QMlC51O1bgNj+UN3OFC42+q87mzJeruQgNU3jLI
   43dTuxBa+J6PtnzpUdENxmdMWmuljewYqdh+18j/C37CSGehx7N2FU1pu
   huvLrhmOkaJ7/McqAyW20BTDU0DaM2a7QCyKsEoX11lVwt+7SNUJdgIdq
   RJUmj0F1ihe8CvxZuYF/Pwyc+E4X294cs2gLR8/WqWzCqIis1FxENha7q
   eJGAqvtRt+gvgyf8h5eNFbGNbTX3EeJJf2kw6Q7gBxl6QPIS3S1LNzmTm
   A==;
X-CSE-ConnectionGUID: ePdLpqhvQV+NGHI0gfyVPg==
X-CSE-MsgGUID: L9GvYsWkSD+mkD/SN2B6hQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11973"; a="4065301"
X-IronPort-AV: E=Sophos;i="6.27,226,1787036400"; 
   d="scan'208";a="4065301"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2026 03:08:26 -0800
X-CSE-ConnectionGUID: bRqpfSEvQ6mEe6tla/Mf4g==
X-CSE-MsgGUID: VU6m7KpyTvCYNul/RJ2zaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,226,1787036400"; 
   d="scan'208";a="12773304"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa012.fm.intel.com with ESMTP; 22 Nov 2026 03:08:23 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xV5Qi-00000001LOM-2WME;
	Sun, 22 Nov 2026 11:08:20 +0000
Date: Sun, 22 Nov 2026 19:07:30 +0800
From: kernel test robot <lkp@intel.com>
To: Fredric Cover <fredric.cover.lkernel@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
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
Message-ID: <202611221916.9Z8PeSdO-lkp@intel.com>
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
config: s390-defconfig (https://download.01.org/0day-ci/archive/20261122/202611221916.9Z8PeSdO-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261122/202611221916.9Z8PeSdO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611221916.9Z8PeSdO-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/smb/client/dfs.c:44:14: error: call to undeclared function 'dfs_cache_local_path'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
      44 |         node_name = dfs_cache_local_path(ref->node_name, ctx->local_nls);
         |                     ^
   fs/smb/client/dfs.c:44:14: note: did you mean 'dfs_cache_canonical_path'?
   fs/smb/client/dfs_cache.h:54:7: note: 'dfs_cache_canonical_path' declared here
      54 | char *dfs_cache_canonical_path(const char *path, const struct nls_table *cp,
         |       ^
>> fs/smb/client/dfs.c:44:12: error: incompatible integer to pointer conversion assigning to 'char *' from 'int' [-Wint-conversion]
      44 |         node_name = dfs_cache_local_path(ref->node_name, ctx->local_nls);
         |                   ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   2 errors generated.


vim +/dfs_cache_local_path +44 fs/smb/client/dfs.c

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
