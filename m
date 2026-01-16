Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201CB28640F
	for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 21:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768599447; cv=none; b=bkUgg+q1PCVtJgRUCo+QWzRHBDbBnLy2dWNGTVQr4P9RnymEhAtVLyULIneZ7QserPgNHbn0wIORUQBSfZvPicva6Bc1vnydxNacYBtZgoAGGwon8B5MbCxiq5w0emp4yMo+k/uqAGrjyJBYNMs6xqfUAKaaKdkezNqOAfElLd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768599447; c=relaxed/simple;
	bh=y2Km9ikx0bGX69q42CxA6vSKHrKUAglF8jf9UWTjIC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Edns4aNx52En3FzGi7YhguKUQGDlXSFIoZ9EsizLU7R8KbiNXUGDjINdMT4fvg2uvUROjSTSx+OVPhvwc2xreIJCgrUvNZX7Xt2IBKvqUkkEJbn0hiHTWhsvUIasP5WdTGsGjbpDkusVhtvgiYlMFqGE0tM5thvAb1Xp2Z9cZMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ixeOV/cA; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ixeOV/cA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768599444; x=1800135444;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=y2Km9ikx0bGX69q42CxA6vSKHrKUAglF8jf9UWTjIC8=;
  b=ixeOV/cAxlyKLHMFCyzLYYCYP5YBeNUEH4HehRNUO3ovnnyVoqny8XbI
   Mb5QMy+pkg+EfWQegAo6/lIng84TTZZlTp3QkY5GzhZgvd69HMK+mNR2c
   KtL7H1BzWTL5Ph6mEPTO5CfEa2yOpqQUMze7UoVzc+boOMiJ7i1SqGG7A
   5Ng55oqjjiqv1QJw3tscap1m0l5Z2D5diKu1o9ctoOpH9ix16eeVRulJ3
   //XI02lfHqGtnUEoG+rVQrcnhkMcy4Wag+fVHgN7oXj0L8Ly9OV/Tl5kR
   HyzXkLUnGCvb6hXG0nMLK205UMtqPXx/5qlK/s/F0iA9sWZYd6UKC5UXm
   g==;
X-CSE-ConnectionGUID: XZZFnsMYQZCVN15ucoSnyw==
X-CSE-MsgGUID: yZuAKBilSmqcdfGsNUL1NA==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="69967758"
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="69967758"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 13:37:23 -0800
X-CSE-ConnectionGUID: uA+1L0aXQgq4HXw30AIFig==
X-CSE-MsgGUID: ui5XdWVRSQOst+iwvjOO7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="204573067"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 16 Jan 2026 13:37:21 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgrVO-00000000LGS-2xqD;
	Fri, 16 Jan 2026 21:37:18 +0000
Date: Sat, 17 Jan 2026 05:37:10 +0800
From: kernel test robot <lkp@intel.com>
To: Henrique Carvalho <henrique.carvalho@suse.com>, sfrench@samba.org
Cc: oe-kbuild-all@lists.linux.dev, pc@manguebit.org,
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
	bharathsm@microsoft.com, ematsumiya@suse.de,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: introduce multichannel async work during
 mount
Message-ID: <202601170529.AH74foBz-lkp@intel.com>
References: <20260116153548.223614-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116153548.223614-1-henrique.carvalho@suse.com>

Hi Henrique,

kernel test robot noticed the following build warnings:

[auto build test WARNING on cifs/for-next]
[also build test WARNING on linus/master v6.19-rc5 next-20260116]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Henrique-Carvalho/smb-client-introduce-multichannel-async-work-during-mount/20260116-234138
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
patch link:    https://lore.kernel.org/r/20260116153548.223614-1-henrique.carvalho%40suse.com
patch subject: [PATCH] smb: client: introduce multichannel async work during mount
config: parisc-defconfig (https://download.01.org/0day-ci/archive/20260117/202601170529.AH74foBz-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260117/202601170529.AH74foBz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601170529.AH74foBz-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/smb/client/connect.c:3907:1: warning: 'mchan_mount_alloc' defined but not used [-Wunused-function]
    3907 | mchan_mount_alloc(struct smb3_fs_context *ctx)
         | ^~~~~~~~~~~~~~~~~


vim +/mchan_mount_alloc +3907 fs/smb/client/connect.c

  3905	
  3906	static struct mchan_mount *
> 3907	mchan_mount_alloc(struct smb3_fs_context *ctx)
  3908	{
  3909		int rc;
  3910		struct TCP_Server_Info *server;
  3911		struct mchan_mount *mchan_mount;
  3912	
  3913		mchan_mount = kzalloc(sizeof(*mchan_mount), GFP_KERNEL);
  3914		if (!mchan_mount)
  3915			return ERR_PTR(-ENOMEM);
  3916	
  3917		INIT_WORK(&mchan_mount->work, mchan_mount_work_fn);
  3918		kref_init(&mchan_mount->refcount);
  3919	
  3920		server = cifs_get_tcp_session(ctx, NULL);
  3921		if (IS_ERR(server)) {
  3922			rc = PTR_ERR(server);
  3923			goto error;
  3924		}
  3925	
  3926		mchan_mount->ses = cifs_get_smb_ses(server, ctx);
  3927		if (IS_ERR(mchan_mount->ses)) {
  3928			cifs_put_tcp_session(server, false);
  3929			rc = PTR_ERR(mchan_mount->ses);
  3930			goto error;
  3931		}
  3932	
  3933		return mchan_mount;
  3934	
  3935	error:
  3936		kfree(mchan_mount);
  3937	
  3938		return ERR_PTR(rc);
  3939	}
  3940	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
