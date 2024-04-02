Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513133D38D
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 07:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712043626; cv=none; b=jDgoF9kSFFU6jQRCvOjksDZDcbJ3pV1zrZxsJoCkXTpN7nuj8KfSls5geYjYtiLoDAKMeGBaDqJ0uD3dZTIS/U3bGYlDLm4RhB61PCbq/h77aXqNyNP7ZV3Vm2ARp5pXYyt9MT8MIFIopsozEm0uIO01OifGOhcdrIKCUg95Hjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712043626; c=relaxed/simple;
	bh=ef1U0IbHPsMOFu7G0b64A00ItdP6LEWvBXLDK+BYpxU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PU+lz1Xe+sFnbJcC/UmZu4Ora8LAYicQSO1c3gLMqIbRpHv1GC94lIXZT3c2XzyvXFxq15RbdZNI1kooaq1fEVXLKmMAlMxx5FSI+b0QxAN+BcX4Y6omXPdtHYjSCvic3mBvCW0bBOUUTMWCXXZPHTZbju3ghmx2TPYjen/y+lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iU5BYMbA; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iU5BYMbA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712043623; x=1743579623;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=ef1U0IbHPsMOFu7G0b64A00ItdP6LEWvBXLDK+BYpxU=;
  b=iU5BYMbAkX4HNWdFS8sGUKG5SDMKqh3TY4TtvfK2g1D2OU1mHrDbyorJ
   YKBXZ3HLFxFdsULqjUBsnYmr9pzIwUS5ZAHcmqq850lUHSEW05Qt1hEp1
   /ejOgXTbjk2E1D/4X4YPTKwHzBc8yBOgtO+9af3WyO98JtU+LmdN0HSVY
   5ksJsxeCb1TEUbbDlszVGHqEJP051ZND5OPY/UHQ1sbaV5+LgkJTdv8Rl
   ui27b9aVR3TapHcDuVT7Tg5AQchysyS+8vDStVVVGekkpYIJteYinJDup
   GTR7rIO+fOpQmg/0y6KpovgdVKDtgky1AY1RzORTgt3/jRmIR4OO4kG17
   Q==;
X-CSE-ConnectionGUID: htDBPKXERRG/ihqiFuFUzg==
X-CSE-MsgGUID: VYm8pK+yRT+FfS4zTS5cVQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11031"; a="10982615"
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="10982615"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 00:40:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="55425157"
Received: from lkp-server02.sh.intel.com (HELO 90ee3aa53dbd) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 02 Apr 2024 00:40:20 -0700
Received: from kbuild by 90ee3aa53dbd with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rrYkh-00010z-1e;
	Tue, 02 Apr 2024 07:40:15 +0000
Date: Tue, 2 Apr 2024 15:39:56 +0800
From: kernel test robot <lkp@intel.com>
To: Paulo Alcantara <pc@manguebit.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>
Subject: [cifs:for-next 5/6] fs/smb/client/connect.c:4045:35: error: implicit
 declaration of function 'dfs_get_path'
Message-ID: <202404021518.3Xu2VU4s-lkp@intel.com>
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
commit: 8e09ce8ffd4bdf6f780a54f89301c646526e9d97 [5/6] smb: client: handle DFS tcons in cifs_construct_tcon()
config: parisc-defconfig (https://download.01.org/0day-ci/archive/20240402/202404021518.3Xu2VU4s-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240402/202404021518.3Xu2VU4s-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202404021518.3Xu2VU4s-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

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
   fs/smb/client/connect.c:3647:37: error: invalid type argument of '->' (have 'struct cifs_mount_ctx')
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
   fs/smb/client/connect.c: In function 'cifs_construct_tcon':
>> fs/smb/client/connect.c:4045:35: error: implicit declaration of function 'dfs_get_path' [-Werror=implicit-function-declaration]
    4045 |                 origin_fullpath = dfs_get_path(cifs_sb, cifs_sb->ctx->source);
         |                                   ^~~~~~~~~~~~
>> fs/smb/client/connect.c:4045:33: warning: assignment to 'char *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
    4045 |                 origin_fullpath = dfs_get_path(cifs_sb, cifs_sb->ctx->source);
         |                                 ^
>> fs/smb/client/connect.c:4067:36: error: 'dfscache_wq' undeclared (first use in this function); did you mean 'fscache_write'?
    4067 |                 queue_delayed_work(dfscache_wq, &tcon->dfs_cache_work,
         |                                    ^~~~~~~~~~~
         |                                    fscache_write
   fs/smb/client/connect.c:4067:36: note: each undeclared identifier is reported only once for each function it appears in
>> fs/smb/client/connect.c:4067:54: error: 'struct cifs_tcon' has no member named 'dfs_cache_work'
    4067 |                 queue_delayed_work(dfscache_wq, &tcon->dfs_cache_work,
         |                                                      ^~
>> fs/smb/client/connect.c:4068:36: error: implicit declaration of function 'dfs_cache_get_ttl'; did you mean 'fscache_get_aux'? [-Werror=implicit-function-declaration]
    4068 |                                    dfs_cache_get_ttl() * HZ);
         |                                    ^~~~~~~~~~~~~~~~~
         |                                    fscache_get_aux
   cc1: some warnings being treated as errors


vim +/dfs_get_path +4045 fs/smb/client/connect.c

  3989	
  3990	static struct cifs_tcon *
  3991	cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
  3992	{
  3993		int rc;
  3994		struct cifs_tcon *master_tcon = cifs_sb_master_tcon(cifs_sb);
  3995		struct cifs_ses *ses;
  3996		struct cifs_tcon *tcon = NULL;
  3997		struct smb3_fs_context *ctx;
  3998		char *origin_fullpath = NULL;
  3999	
  4000		ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
  4001		if (ctx == NULL)
  4002			return ERR_PTR(-ENOMEM);
  4003	
  4004		ctx->local_nls = cifs_sb->local_nls;
  4005		ctx->linux_uid = fsuid;
  4006		ctx->cred_uid = fsuid;
  4007		ctx->UNC = master_tcon->tree_name;
  4008		ctx->retry = master_tcon->retry;
  4009		ctx->nocase = master_tcon->nocase;
  4010		ctx->nohandlecache = master_tcon->nohandlecache;
  4011		ctx->local_lease = master_tcon->local_lease;
  4012		ctx->no_lease = master_tcon->no_lease;
  4013		ctx->resilient = master_tcon->use_resilient;
  4014		ctx->persistent = master_tcon->use_persistent;
  4015		ctx->handle_timeout = master_tcon->handle_timeout;
  4016		ctx->no_linux_ext = !master_tcon->unix_ext;
  4017		ctx->linux_ext = master_tcon->posix_extensions;
  4018		ctx->sectype = master_tcon->ses->sectype;
  4019		ctx->sign = master_tcon->ses->sign;
  4020		ctx->seal = master_tcon->seal;
  4021		ctx->witness = master_tcon->use_witness;
  4022		ctx->dfs_root_ses = master_tcon->ses->dfs_root_ses;
  4023	
  4024		rc = cifs_set_vol_auth(ctx, master_tcon->ses);
  4025		if (rc) {
  4026			tcon = ERR_PTR(rc);
  4027			goto out;
  4028		}
  4029	
  4030		/* get a reference for the same TCP session */
  4031		spin_lock(&cifs_tcp_ses_lock);
  4032		++master_tcon->ses->server->srv_count;
  4033		spin_unlock(&cifs_tcp_ses_lock);
  4034	
  4035		ses = cifs_get_smb_ses(master_tcon->ses->server, ctx);
  4036		if (IS_ERR(ses)) {
  4037			tcon = (struct cifs_tcon *)ses;
  4038			cifs_put_tcp_session(master_tcon->ses->server, 0);
  4039			goto out;
  4040		}
  4041	
  4042		spin_lock(&master_tcon->tc_lock);
  4043		if (master_tcon->origin_fullpath) {
  4044			spin_unlock(&master_tcon->tc_lock);
> 4045			origin_fullpath = dfs_get_path(cifs_sb, cifs_sb->ctx->source);
  4046			if (IS_ERR(origin_fullpath)) {
  4047				tcon = ERR_CAST(origin_fullpath);
  4048				origin_fullpath = NULL;
  4049				cifs_put_smb_ses(ses);
  4050				goto out;
  4051			}
  4052		} else {
  4053			spin_unlock(&master_tcon->tc_lock);
  4054		}
  4055	
  4056		tcon = cifs_get_tcon(ses, ctx);
  4057		if (IS_ERR(tcon)) {
  4058			cifs_put_smb_ses(ses);
  4059			goto out;
  4060		}
  4061	
  4062		if (origin_fullpath) {
  4063			spin_lock(&tcon->tc_lock);
  4064			tcon->origin_fullpath = origin_fullpath;
  4065			spin_unlock(&tcon->tc_lock);
  4066			origin_fullpath = NULL;
> 4067			queue_delayed_work(dfscache_wq, &tcon->dfs_cache_work,
> 4068					   dfs_cache_get_ttl() * HZ);
  4069		}
  4070	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
