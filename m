Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD06C43334
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Jun 2022 05:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243476AbiFDFBT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 4 Jun 2022 01:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiFDFBS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 4 Jun 2022 01:01:18 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA8C59970
        for <linux-cifs@vger.kernel.org>; Fri,  3 Jun 2022 22:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654318876; x=1685854876;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=rr0nprWAXUpegr/ZWzpAxrOUkhKhyXAxrf90w7RL+G4=;
  b=IddpiB/Pgc+R5B0RT1sxwg5r2d8GONOu/yZ0OfxYqfGn1XT/I06qUu+j
   T3oYW+8NY0d2ySmbV76iehLhdVuMpDqNpaMOx2C3dWcHu9VlgZwQzC91I
   +pio4ESnGYTlH4DUgIIE8t6GB0u8jEwl7KblihEdbsC0LxI1AeSDzWrCp
   +BGTPebYuJxa3vBa3LbYQ6dm6XZMwXO1ZJJjEFA5RVLhi0U+ydHTMMgg6
   o87/I0JWAp7ps2O6O+e9CGJdKYguAkFrgib/4WoxojQF7YnxUA05GohRQ
   G30/hJdZc/REwBtghI46iIBzEhT8avrSMhj8i2M9otLXUkqbTe62/Os73
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10367"; a="337074922"
X-IronPort-AV: E=Sophos;i="5.91,276,1647327600"; 
   d="scan'208";a="337074922"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2022 22:01:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,276,1647327600"; 
   d="scan'208";a="578338629"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 03 Jun 2022 22:01:14 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nxLuT-000AER-LN;
        Sat, 04 Jun 2022 05:01:13 +0000
Date:   Sat, 4 Jun 2022 13:00:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        Steve French <stfrench@microsoft.com>
Subject: [cifs:for-next 8/8] fs/cifs/dfs_cache.c:1294:2: warning: variable
 'ppath' is used uninitialized whenever 'if' condition is false
Message-ID: <202206041223.Kx81JSQt-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   ef605e86821253d16d47a02ce1f766a461614fef
commit: ef605e86821253d16d47a02ce1f766a461614fef [8/8] cifs: skip trailing separators of prefix paths
config: arm-randconfig-c002-20220603 (https://download.01.org/0day-ci/archive/20220604/202206041223.Kx81JSQt-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project b364c76683f8ef241025a9556300778c07b590c2)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        git remote add cifs git://git.samba.org/sfrench/cifs-2.6.git
        git fetch --no-tags cifs for-next
        git checkout ef605e86821253d16d47a02ce1f766a461614fef
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash fs/cifs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> fs/cifs/dfs_cache.c:1294:2: warning: variable 'ppath' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
           if (target_pplen || dfsref_pplen) {
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:56:28: note: expanded from macro 'if'
   #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:58:30: note: expanded from macro '__trace_if_var'
   #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/cifs/dfs_cache.c:1307:12: note: uninitialized use occurs here
           *prefix = ppath;
                     ^~~~~
   fs/cifs/dfs_cache.c:1294:2: note: remove the 'if' if its condition is always true
           if (target_pplen || dfsref_pplen) {
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:56:23: note: expanded from macro 'if'
   #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
                         ^
   fs/cifs/dfs_cache.c:1270:28: note: initialize the variable 'ppath' to silence this warning
           char *target_share, *ppath;
                                     ^
                                      = NULL
   1 warning generated.


vim +1294 fs/cifs/dfs_cache.c

  1255	
  1256	/**
  1257	 * dfs_cache_get_tgt_share - parse a DFS target
  1258	 *
  1259	 * @path: DFS full path
  1260	 * @it: DFS target iterator.
  1261	 * @share: tree name.
  1262	 * @prefix: prefix path.
  1263	 *
  1264	 * Return zero if target was parsed correctly, otherwise non-zero.
  1265	 */
  1266	int dfs_cache_get_tgt_share(char *path, const struct dfs_cache_tgt_iterator *it, char **share,
  1267				    char **prefix)
  1268	{
  1269		char sep;
  1270		char *target_share, *ppath;
  1271		const char *target_ppath, *dfsref_ppath;
  1272		size_t target_pplen, dfsref_pplen;
  1273		size_t len, c;
  1274	
  1275		if (!it || !path || !share || !prefix || strlen(path) < it->it_path_consumed)
  1276			return -EINVAL;
  1277	
  1278		sep = it->it_name[0];
  1279		if (sep != '\\' && sep != '/')
  1280			return -EINVAL;
  1281	
  1282		target_ppath = parse_target_share(it->it_name, &target_share);
  1283		if (IS_ERR(target_ppath))
  1284			return PTR_ERR(target_ppath);
  1285	
  1286		/* point to prefix in DFS referral path */
  1287		dfsref_ppath = path + it->it_path_consumed;
  1288		dfsref_ppath += strspn(dfsref_ppath, "/\\");
  1289	
  1290		target_pplen = strlen(target_ppath);
  1291		dfsref_pplen = strlen(dfsref_ppath);
  1292	
  1293		/* merge prefix paths from DFS referral path and target node */
> 1294		if (target_pplen || dfsref_pplen) {
  1295			len = target_pplen + dfsref_pplen + 2;
  1296			ppath = kzalloc(len, GFP_KERNEL);
  1297			if (!ppath) {
  1298				kfree(target_share);
  1299				return -ENOMEM;
  1300			}
  1301			c = strscpy(ppath, target_ppath, len);
  1302			if (c && dfsref_pplen)
  1303				ppath[c] = sep;
  1304			strlcat(ppath, dfsref_ppath, len);
  1305		}
  1306		*share = target_share;
  1307		*prefix = ppath;
  1308		return 0;
  1309	}
  1310	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
