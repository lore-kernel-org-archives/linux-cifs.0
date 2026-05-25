Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFC6262FC1;
	Mon, 25 May 2026 23:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779750281; cv=none; b=rpOVdm/1GhFETDnjWuivkzdPx4ihgACa0XRJeUCUSSN1AxIS/Ta0unik4qRcDy8wxLrh/jx/shi9Txg2qxqgIeVUmbrjjyiaFDHIy/3dVV55hylltoyVUzNX2A+IpLrqLGqLatZW89DHBtOdOCBcPdRAjOQz82qkVtLFhWP3NVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779750281; c=relaxed/simple;
	bh=0jsZ5CQ+QmDnqWR4L84F8WznoP6ymdqy4/ouzJWzwhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AcJxNfyqcSjCMtgE/JLJMEd4TQQ4W3kZb5Caor/NvNumpZxLPjcZKcuhbp5vvyXcpMmGdj6tw5jEkj1WTWFfY7TJ8Ir0wks4JCTSmltuMVBw88uQDaDRC2Xkkh0Y4MGn1+MY3OAMJSeop8YCI6i6CdplAki897mqR/wQXheziHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RSRRZ0gC; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RSRRZ0gC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779750277; x=1811286277;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0jsZ5CQ+QmDnqWR4L84F8WznoP6ymdqy4/ouzJWzwhc=;
  b=RSRRZ0gC1VU9gp575ZfpbaaegwvJZ27Zct3ZIy4zX/WGyYvQqjdcyyaI
   5LgXZyf6if7o9iXictiOpVKdBhKFCOXQxvCRJN1DMOGl5GP9VdfUzu2Re
   9vsBqyekCRkn6SOIyvus+uAW/HFpHuaFPOPTejz+Hi+i0but6qMUqsVzF
   xppcZ/mxs3eqEXiNiEBcv8kc0R1eXIUrDjsYEOek05FjTwGzXehSSXr/u
   TfHuxoYTBOOVCJfifB9jXDdHAPBVoudmKx/G7UBXeuK1fkFJeOyY7GSvG
   HY1Fq+0IDzcc0KKVw9C2V6rg8Su+e0nXgmQ5Fb2/59ZPZXD4rH/6xSs/4
   A==;
X-CSE-ConnectionGUID: umPOIrFZRhufFLsE59wkfA==
X-CSE-MsgGUID: TegQXCOIT4+eXeFDe+mPbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11797"; a="91131168"
X-IronPort-AV: E=Sophos;i="6.24,168,1774335600"; 
   d="scan'208";a="91131168"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2026 16:04:36 -0700
X-CSE-ConnectionGUID: v0BzpsVUT8SDz7pvM1z3kQ==
X-CSE-MsgGUID: aN7EtUZFS3O41Zbuuwpx6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,168,1774335600"; 
   d="scan'208";a="246683821"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 25 May 2026 16:04:35 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wReLX-000000001tC-0WUH;
	Mon, 25 May 2026 23:04:31 +0000
Date: Tue, 26 May 2026 07:04:02 +0800
From: kernel test robot <lkp@intel.com>
To: "zhangjian (CG)" <zhangjian496@huawei.com>, sfrench@samba.org
Cc: oe-kbuild-all@lists.linux.dev, pc@manguebit.org,
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
	bharathsm@microsoft.com, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: cifs: remove all cifs files before kill super
Message-ID: <202605260611.gcFkHRJk-lkp@intel.com>
References: <616cbc26-d8a9-418a-91f3-11e470087aa4@huawei.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <616cbc26-d8a9-418a-91f3-11e470087aa4@huawei.com>

Hi zhangjian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on cifs/for-next]
[also build test WARNING on linus/master v7.1-rc5 next-20260525]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/zhangjian-CG/cifs-remove-all-cifs-files-before-kill-super/20260519-185913
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
patch link:    https://lore.kernel.org/r/616cbc26-d8a9-418a-91f3-11e470087aa4%40huawei.com
patch subject: cifs: remove all cifs files before kill super
config: x86_64-randconfig-161 (https://download.01.org/0day-ci/archive/20260526/202605260611.gcFkHRJk-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
smatch: v0.5.0-9185-gbcc58b9c

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605260611.gcFkHRJk-lkp@intel.com/

New smatch warnings:
fs/smb/client/connect.c:3999 cifs_umount() warn: inconsistent indenting

Old smatch warnings:
fs/smb/client/connect.c:3369 generic_ip_connect() error: we previously assumed 'server->ssocket' could be null (see line 3356)

vim +3999 fs/smb/client/connect.c

  3966	
  3967	void
  3968	cifs_umount(struct cifs_sb_info *cifs_sb)
  3969	{
  3970		struct rb_root *root = &cifs_sb->tlink_tree;
  3971		struct rb_node *node;
  3972		struct tcon_link *tlink;
  3973		struct cifs_tcon *tcon = NULL;
  3974	
  3975		cancel_delayed_work_sync(&cifs_sb->prune_tlinks);
  3976	
  3977		if (cifs_sb->master_tlink) {
  3978			tcon = cifs_sb->master_tlink->tl_tcon;
  3979			if (tcon) {
  3980				spin_lock(&tcon->sb_list_lock);
  3981				list_del_init(&cifs_sb->tcon_sb_link);
  3982				spin_unlock(&tcon->sb_list_lock);
  3983			}
  3984		}
  3985	
  3986		spin_lock(&cifs_sb->tlink_tree_lock);
  3987		while ((node = rb_first(root))) {
  3988			tlink = rb_entry(node, struct tcon_link, tl_rbnode);
  3989			cifs_get_tlink(tlink);
  3990			clear_bit(TCON_LINK_IN_TREE, &tlink->tl_flags);
  3991			rb_erase(node, root);
  3992	
  3993			spin_unlock(&cifs_sb->tlink_tree_lock);
  3994			cifs_put_tlink(tlink);
  3995			spin_lock(&cifs_sb->tlink_tree_lock);
  3996		}
  3997		spin_unlock(&cifs_sb->tlink_tree_lock);
  3998	
> 3999	    flush_workqueue(serverclose_wq);
  4000	    flush_workqueue(fileinfo_put_wq);
  4001	
  4002		kfree(cifs_sb->prepath);
  4003		call_rcu(&cifs_sb->rcu, delayed_free);
  4004	}
  4005	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
