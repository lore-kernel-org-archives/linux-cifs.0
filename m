Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BDEEC77B78
	for <linux-cifs@archiver.kernel.org>; Thu,  4 May 2023 05:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjEDFOz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 May 2023 01:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjEDFOy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 May 2023 01:14:54 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7428D10D1;
        Wed,  3 May 2023 22:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683177292; x=1714713292;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=U0Mvm2Qigu/1mTyodDCfTROC/3TRZNheY7qiLXnriVk=;
  b=IhGEh8+Z9O5sJL6bRVNSjOJSQb5dy9aGqCnauSQK+JR76zoEj4ljPz3d
   LpXIfvQUaCK8p+aRsxMQo4Nb6nBzrO2IpiLYK6iNEkB/iR+wCK0MdV3Y/
   zj4egz+zh33EcvNYLcIythFMTtBankrBKi9DedJZKgqoUyMTcbDXlU9gc
   RmQoFQCi+pogGFCf+F+umzzjJjoSNeITB+iGDlIO8qsXdv7IpcAB+C5bf
   26ST8/x13PTddJMyYCd2PyQc+qNwYnM2VjvNs9DGKjL+BfPxP33w5pYe+
   qQxHPzTOJudILTKOO6MizB91ouufsUGzwu4V5aIO/Vzjno3i9AQI1o9ce
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="350922770"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="350922770"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 22:14:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="871219323"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="871219323"
Received: from lkp-server01.sh.intel.com (HELO e3434d64424d) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 03 May 2023 22:14:50 -0700
Received: from kbuild by e3434d64424d with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1puRIn-0002ay-1L;
        Thu, 04 May 2023 05:14:49 +0000
Date:   Thu, 4 May 2023 13:14:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paulo Alcantara <pc@manguebit.com>, smfrench@gmail.com
Cc:     oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
        Paulo Alcantara <pc@manguebit.com>, stable@vger.kernel.org
Subject: Re: [PATCH 7/7] cifs: fix sharing of DFS connections
Message-ID: <202305041040.j7W2xQSy-lkp@intel.com>
References: <20230503222117.7609-8-pc@manguebit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503222117.7609-8-pc@manguebit.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Paulo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on v6.3]
[also build test WARNING on linus/master next-20230428]
[cannot apply to cifs/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Paulo-Alcantara/cifs-fix-potential-race-when-tree-connecting-ipc/20230504-062335
base:   457391b0380335d5e9a5babdec90ac53928b23b4
patch link:    https://lore.kernel.org/r/20230503222117.7609-8-pc%40manguebit.com
patch subject: [PATCH 7/7] cifs: fix sharing of DFS connections
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20230504/202305041040.j7W2xQSy-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/5a2a7b1846bb61ee5669afdfe2238eaa80c339c2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Paulo-Alcantara/cifs-fix-potential-race-when-tree-connecting-ipc/20230504-062335
        git checkout 5a2a7b1846bb61ee5669afdfe2238eaa80c339c2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash fs/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305041040.j7W2xQSy-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/cifs/connect.c: In function 'cifs_put_tcon':
>> fs/cifs/connect.c:2310:33: warning: variable 'server' set but not used [-Wunused-but-set-variable]
    2310 |         struct TCP_Server_Info *server;
         |                                 ^~~~~~


vim +/server +2310 fs/cifs/connect.c

  2306	
  2307	void
  2308	cifs_put_tcon(struct cifs_tcon *tcon)
  2309	{
> 2310		struct TCP_Server_Info *server;
  2311		struct cifs_ses *ses;
  2312		unsigned int xid;
  2313	
  2314		/*
  2315		 * IPC tcon share the lifetime of their session and are
  2316		 * destroyed in the session put function
  2317		 */
  2318		if (tcon == NULL || tcon->ipc)
  2319			return;
  2320	
  2321		ses = tcon->ses;
  2322		server = ses->server;
  2323		cifs_dbg(FYI, "%s: tc_count=%d\n", __func__, tcon->tc_count);
  2324		spin_lock(&cifs_tcp_ses_lock);
  2325		spin_lock(&tcon->tc_lock);
  2326		if (--tcon->tc_count > 0) {
  2327			spin_unlock(&tcon->tc_lock);
  2328			spin_unlock(&cifs_tcp_ses_lock);
  2329			return;
  2330		}
  2331	
  2332		/* tc_count can never go negative */
  2333		WARN_ON(tcon->tc_count < 0);
  2334	
  2335		list_del_init(&tcon->tcon_list);
  2336		tcon->status = TID_EXITING;
  2337		spin_unlock(&tcon->tc_lock);
  2338		spin_unlock(&cifs_tcp_ses_lock);
  2339	
  2340		/* cancel polling of interfaces */
  2341		cancel_delayed_work_sync(&tcon->query_interfaces);
  2342	#ifdef CONFIG_CIFS_DFS_UPCALL
  2343		cancel_delayed_work_sync(&tcon->dfs_cache_work);
  2344	#endif
  2345	
  2346		if (tcon->use_witness) {
  2347			int rc;
  2348	
  2349			rc = cifs_swn_unregister(tcon);
  2350			if (rc < 0) {
  2351				cifs_dbg(VFS, "%s: Failed to unregister for witness notifications: %d\n",
  2352						__func__, rc);
  2353			}
  2354		}
  2355	
  2356		xid = get_xid();
  2357		if (ses->server->ops->tree_disconnect)
  2358			ses->server->ops->tree_disconnect(xid, tcon);
  2359		_free_xid(xid);
  2360	
  2361		cifs_fscache_release_super_cookie(tcon);
  2362		tconInfoFree(tcon);
  2363		cifs_put_smb_ses(ses);
  2364	}
  2365	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
