Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B18339B1
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 07:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712041701; cv=none; b=TbKGrPBHfCcWmsoaMvD5JNKvw9GfaCq90nvsDdCS4/xGUCWcz2lBYErgBhMp2rkNVJB/nJQ0uCUORqlWpjxFuElmpwGvXOTjlsNR4BIK7rmQOHEIOF3FY4RnssCnA0j4tbktTMGXTXMQ9uNwMJdhHGoJHJcg9infAPmsb0Nfc0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712041701; c=relaxed/simple;
	bh=zd3EQ3sNcbGIsVnKPnHAKk9L+OIqs32+MFXH0Y65lBo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=m8ofajvN/N5fXCa7okvPWAsv9ulcfdkxPgK+ohzFIfYnUzu6+SXyU0cc0I1YS4LSLGbPrcFooMFxXSmnSaHpmHBw89Q8Lft7TMfI0ZvN4ZBC5fVhnkE/NjaLp6BE5btXumYrITW3RAtBxQnFUDcy0KEgCSAgiOq6d46PJaly1Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gW0MjAC8; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gW0MjAC8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712041700; x=1743577700;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=zd3EQ3sNcbGIsVnKPnHAKk9L+OIqs32+MFXH0Y65lBo=;
  b=gW0MjAC8uTlWGpyhnkAJbj787T0kahqZjRbjHpsJAFUynzvy5popP/30
   kjuFz+RVzuI2RISk9fMDG13lx2WmeN0o1Jxt2pwLAy3qUd3vB7iLiqoKV
   +/q/94XkHr+EvtA/o2qrf/an7QUqFGasiSLxuEz+tw4Rn6rdRpjwStvRm
   1mSugv/+g3TfXetV3bf9Pcj3GuSk5NGbqW2hD9OU/xGyDptNS5KzQRDbJ
   Zc7oz/v+9aj3F19UpkqCz5Bf43x92yrxMSK7AWRQAyBtYWD3xxZCaWD15
   UwLSGwHGtu1yqx6fVoeyme67MnBVbPXvGh3X9dmLfd8/eHW8SYIu/mwon
   g==;
X-CSE-ConnectionGUID: 2M+Tp9ZwQva5AH0EVPl7Hg==
X-CSE-MsgGUID: jE1Q+CQAReO+OPplyIOdMA==
X-IronPort-AV: E=McAfee;i="6600,9927,11031"; a="18643793"
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="18643793"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 00:08:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="18021167"
Received: from lkp-server02.sh.intel.com (HELO 90ee3aa53dbd) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 02 Apr 2024 00:08:16 -0700
Received: from kbuild by 90ee3aa53dbd with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rrYFi-0000zT-2B;
	Tue, 02 Apr 2024 07:08:14 +0000
Date: Tue, 2 Apr 2024 15:08:08 +0800
From: kernel test robot <lkp@intel.com>
To: Paulo Alcantara <pc@manguebit.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>
Subject: [cifs:for-next 3/6] fs/smb/client/connect.c:3647:37: error: invalid
 type argument of '->' (have 'struct cifs_mount_ctx')
Message-ID: <202404021510.UA1q5xJ1-lkp@intel.com>
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
config: parisc-defconfig (https://download.01.org/0day-ci/archive/20240402/202404021510.UA1q5xJ1-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240402/202404021510.UA1q5xJ1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202404021510.UA1q5xJ1-lkp@intel.com/

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
