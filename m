Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044E73AC08
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 07:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712042361; cv=none; b=We3ZkylJ481AetG7TkIpBtVity1IAp1OIJCgUhyUHsIVkOsmaIncMfRpADhRzEjejqVXR0EvyCThVVlkf0DMNJI+WaGjxLLdUdbFU/O0rZ1ldWD/hIYvwJjO+uIpDKVa2wBWWgK5oh0Tm6N3kG97nBrGmPDdkGX/2iv60JALGVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712042361; c=relaxed/simple;
	bh=WcwUrTBiWLrZoE359VY2teXK+aHKPYdOvQm+tybsn+s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kSJ5ZhJ8AWrCjZPTWtC0L1nwmxBJw6jkVpsH1vc+erab0exGKnGGBK7FKz1L+cloCP+xeraliYx4P23kxqNdT/dO45o1UiNMGH1pfAnhnY411KcDBus0htuvrpSfBD2etPtl1SY8DgrxXZWQiXFrgmh2sW032gslqSHYrWz2TRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H0rOF9uR; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H0rOF9uR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712042360; x=1743578360;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=WcwUrTBiWLrZoE359VY2teXK+aHKPYdOvQm+tybsn+s=;
  b=H0rOF9uRlAuhM/IlQhLPhHTj2GGsYromD9BUOYZ8AfUQ+JltBF3/Bi1J
   k1ikixTaBEyoSU37MVG6p24um/NPxZf72kuDYtJgWLsbXcK5yRA0gWPiI
   UXWB3ACGIRxl6gdav9/GQo5Eta/hxQ/HHArSjKnSxZpO9SPDiAZBcI0Po
   3qbb2Fe6Y1yeC5Q+T7CGQn1/0V5Fybmzk6Dm1L3POs/LWkvpya3bOLOnI
   sc4pozSWj+eY8PEu2Tj5FNKgVssKuRDlFHDcaH0/R5QnhqBHFsGkN6erB
   sDxuHUL87SIy3Ekj86TAlnLkZN9h9DyfqTAONQHLxLHLVJAjK/jx3+vaZ
   g==;
X-CSE-ConnectionGUID: 74+Jdv1WTY2JRFcYJPq/hA==
X-CSE-MsgGUID: EXf7hJYzRvmjtaRTp1/Siw==
X-IronPort-AV: E=McAfee;i="6600,9927,11031"; a="10158141"
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="10158141"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 00:19:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="18431936"
Received: from lkp-server02.sh.intel.com (HELO 90ee3aa53dbd) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 02 Apr 2024 00:19:17 -0700
Received: from kbuild by 90ee3aa53dbd with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rrYQM-0000zp-31;
	Tue, 02 Apr 2024 07:19:14 +0000
Date: Tue, 2 Apr 2024 15:18:22 +0800
From: kernel test robot <lkp@intel.com>
To: Paulo Alcantara <pc@manguebit.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>
Subject: [cifs:for-next 3/6] fs/smb/client/connect.c:3647:37: error: invalid
 type argument of '->' (have 'struct cifs_mount_ctx')
Message-ID: <202404021527.ZlRkIxgv-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   0bc54e6a9c31ede9508fb81edbd11983494047ee
commit: 311deca30437896573ce0bf5c302095533041abb [3/6] smb: client: guarantee refcounted children from parent session
config: parisc-defconfig (https://download.01.org/0day-ci/archive/20240402/202404021527.ZlRkIxgv-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240402/202404021527.ZlRkIxgv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202404021527.ZlRkIxgv-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/bug.h:5,
                    from include/linux/thread_info.h:13,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/parisc/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:79,
                    from include/linux/spinlock.h:56,
                    from include/linux/wait.h:9,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:6,
                    from fs/smb/client/connect.c:8:
   fs/smb/client/connect.c: In function 'cifs_mount':
>> fs/smb/client/connect.c:3647:37: error: invalid type argument of '->' (have 'struct cifs_mount_ctx')
    3647 |                 if (WARN_ON(!mnt_ctx->server))
         |                                     ^~
   arch/parisc/include/asm/bug.h:86:32: note: in definition of macro 'WARN_ON'
      86 |         int __ret_warn_on = !!(x);                              \
         |                                ^
   fs/smb/client/connect.c:3649:42: error: invalid type argument of '->' (have 'struct cifs_mount_ctx')
    3649 |                 else if (WARN_ON(!mnt_ctx->ses))
         |                                          ^~
   arch/parisc/include/asm/bug.h:86:32: note: in definition of macro 'WARN_ON'
      86 |         int __ret_warn_on = !!(x);                              \
         |                                ^
   fs/smb/client/connect.c:3651:42: error: invalid type argument of '->' (have 'struct cifs_mount_ctx')
    3651 |                 else if (WARN_ON(!mnt_ctx->tcon))
         |                                          ^~
   arch/parisc/include/asm/bug.h:86:32: note: in definition of macro 'WARN_ON'
      86 |         int __ret_warn_on = !!(x);                              \
         |                                ^


vim +3647 fs/smb/client/connect.c

  3590	
  3591	#ifdef CONFIG_CIFS_DFS_UPCALL
  3592	int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
  3593	{
  3594		struct cifs_mount_ctx mnt_ctx = { .cifs_sb = cifs_sb, .fs_ctx = ctx, };
  3595		bool isdfs;
  3596		int rc;
  3597	
  3598		rc = dfs_mount_share(&mnt_ctx, &isdfs);
  3599		if (rc)
  3600			goto error;
  3601		if (!isdfs)
  3602			goto out;
  3603	
  3604		/*
  3605		 * After reconnecting to a different server, unique ids won't match anymore, so we disable
  3606		 * serverino. This prevents dentry revalidation to think the dentry are stale (ESTALE).
  3607		 */
  3608		cifs_autodisable_serverino(cifs_sb);
  3609		/*
  3610		 * Force the use of prefix path to support failover on DFS paths that resolve to targets
  3611		 * that have different prefix paths.
  3612		 */
  3613		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
  3614		kfree(cifs_sb->prepath);
  3615		cifs_sb->prepath = ctx->prepath;
  3616		ctx->prepath = NULL;
  3617	
  3618	out:
  3619		cifs_try_adding_channels(mnt_ctx.ses);
  3620		rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
  3621		if (rc)
  3622			goto error;
  3623	
  3624		free_xid(mnt_ctx.xid);
  3625		return rc;
  3626	
  3627	error:
  3628		cifs_mount_put_conns(&mnt_ctx);
  3629		return rc;
  3630	}
  3631	#else
  3632	int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
  3633	{
  3634		int rc = 0;
  3635		struct cifs_mount_ctx mnt_ctx = { .cifs_sb = cifs_sb, .fs_ctx = ctx, };
  3636	
  3637		rc = cifs_mount_get_session(&mnt_ctx);
  3638		if (rc)
  3639			goto error;
  3640	
  3641		rc = cifs_mount_get_tcon(&mnt_ctx);
  3642		if (!rc) {
  3643			/*
  3644			 * Prevent superblock from being created with any missing
  3645			 * connections.
  3646			 */
> 3647			if (WARN_ON(!mnt_ctx->server))
  3648				rc = -EHOSTDOWN;
  3649			else if (WARN_ON(!mnt_ctx->ses))
  3650				rc = -EACCES;
  3651			else if (WARN_ON(!mnt_ctx->tcon))
  3652				rc = -ENOENT;
  3653		}
  3654		if (rc)
  3655			goto error;
  3656	
  3657		rc = cifs_is_path_remote(&mnt_ctx);
  3658		if (rc == -EREMOTE)
  3659			rc = -EOPNOTSUPP;
  3660		if (rc)
  3661			goto error;
  3662	
  3663		rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
  3664		if (rc)
  3665			goto error;
  3666	
  3667		free_xid(mnt_ctx.xid);
  3668		return rc;
  3669	
  3670	error:
  3671		cifs_mount_put_conns(&mnt_ctx);
  3672		return rc;
  3673	}
  3674	#endif
  3675	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
