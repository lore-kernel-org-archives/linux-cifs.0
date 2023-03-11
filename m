Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DAAAC61DA4
	for <linux-cifs@archiver.kernel.org>; Sat, 11 Mar 2023 04:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCKEvq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Mar 2023 23:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCKEvo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Mar 2023 23:51:44 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC5712CBA9
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 20:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678510303; x=1710046303;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1HEGvN9dy9dJdIxtmk3mLrI0hIFRcV7HoFa2Ta4fcFk=;
  b=Xh+oH17fbFYMtmYLlKpqLINGUnVqRVofQfA5OL4ASD16rKj2CgRLKgT8
   nV/QaJqsO37UURnX/8sykvrkAQWyUK9P1MZr+RI3Gg0rjx4R1A9xewkfm
   Hpl/4AbCTeY6fGVSncp6pb8308sxnAVmZc/P5dyQ9GpF+swzc3C/FvgY+
   kDatHk3Ysem4UgSPYIGN7WotQ2tBTUwWjTlgsb0VcCc1cUh24KyJd9pnk
   2BfYS9q6DWgyw/jbSBu3lw/6LDwH3b5X70uYR2ol3FaqQw3MOVzZJNlQN
   D/nwxyiuwVocmhQdBLBAYqudX8fJo7ATEEK8dt/5O/bMdf30Qn6zAphFJ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="336899866"
X-IronPort-AV: E=Sophos;i="5.98,251,1673942400"; 
   d="scan'208";a="336899866"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 20:51:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="746980280"
X-IronPort-AV: E=Sophos;i="5.98,251,1673942400"; 
   d="scan'208";a="746980280"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 10 Mar 2023 20:51:40 -0800
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1parCm-0004LJ-0R;
        Sat, 11 Mar 2023 04:51:40 +0000
Date:   Sat, 11 Mar 2023 12:51:05 +0800
From:   kernel test robot <lkp@intel.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>, smfrench@gmail.com,
        bharathsm.hsk@gmail.com, pc@cjr.nz, tom@talpey.com,
        linux-cifs@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 06/11] cifs: fix sockaddr comparison in iface_cmp
Message-ID: <202303111213.VsaCo9Ff-lkp@intel.com>
References: <20230310153211.10982-6-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310153211.10982-6-sprasad@microsoft.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Shyam,

I love your patch! Yet something to improve:

[auto build test ERROR on cifs/for-next]
[also build test ERROR on linus/master v6.3-rc1 next-20230310]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shyam-Prasad-N/cifs-generate-signkey-for-the-channel-that-s-reconnecting/20230310-234711
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
patch link:    https://lore.kernel.org/r/20230310153211.10982-6-sprasad%40microsoft.com
patch subject: [PATCH 06/11] cifs: fix sockaddr comparison in iface_cmp
config: x86_64-randconfig-a001 (https://download.01.org/0day-ci/archive/20230311/202303111213.VsaCo9Ff-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/799e15f02b7da48acdde0b568eef1deb23aa32ed
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Shyam-Prasad-N/cifs-generate-signkey-for-the-channel-that-s-reconnecting/20230310-234711
        git checkout 799e15f02b7da48acdde0b568eef1deb23aa32ed
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash fs/cifs/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303111213.VsaCo9Ff-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

>> fs/cifs/connect.c:1311:4: error: expected expression
                           struct sockaddr_in *saddr4 = (struct sockaddr_in *)srcaddr;
                           ^
>> fs/cifs/connect.c:1313:19: error: use of undeclared identifier 'saddr4'; did you mean 'vaddr4'?
                           return memcmp(&saddr4->sin_addr.s_addr,
                                          ^~~~~~
                                          vaddr4
   fs/cifs/connect.c:1312:24: note: 'vaddr4' declared here
                           struct sockaddr_in *vaddr4 = (struct sockaddr_in *)rhs;
                                               ^
>> fs/cifs/connect.c:1312:24: warning: mixing declarations and code is incompatible with standards before C99 [-Wdeclaration-after-statement]
                           struct sockaddr_in *vaddr4 = (struct sockaddr_in *)rhs;
                                               ^
   fs/cifs/connect.c:1328:4: error: expected expression
                           struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
                           ^
>> fs/cifs/connect.c:1330:19: error: use of undeclared identifier 'saddr6'; did you mean 'vaddr6'?
                           return memcmp(&saddr6->sin6_addr,
                                          ^~~~~~
                                          vaddr6
   fs/cifs/connect.c:1329:25: note: 'vaddr6' declared here
                           struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)rhs;
                                                ^
   fs/cifs/connect.c:1329:25: warning: mixing declarations and code is incompatible with standards before C99 [-Wdeclaration-after-statement]
                           struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)rhs;
                                                ^
   2 warnings and 4 errors generated.


vim +1311 fs/cifs/connect.c

  1291	
  1292	int
  1293	cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs)
  1294	{
  1295		switch (srcaddr->sa_family) {
  1296		case AF_UNSPEC:
  1297			switch (rhs->sa_family) {
  1298			case AF_UNSPEC:
  1299				return 0;
  1300			case AF_INET:
  1301			case AF_INET6:
  1302				return 1;
  1303			default:
  1304				return -1;
  1305			}
  1306		case AF_INET: {
  1307			switch (rhs->sa_family) {
  1308			case AF_UNSPEC:
  1309				return -1;
  1310			case AF_INET:
> 1311				struct sockaddr_in *saddr4 = (struct sockaddr_in *)srcaddr;
> 1312				struct sockaddr_in *vaddr4 = (struct sockaddr_in *)rhs;
> 1313				return memcmp(&saddr4->sin_addr.s_addr,
  1314				       &vaddr4->sin_addr.s_addr,
  1315				       sizeof(struct sockaddr_in));
  1316			case AF_INET6:
  1317				return 1;
  1318			default:
  1319				return -1;
  1320			}
  1321		}
  1322		case AF_INET6: {
  1323			switch (rhs->sa_family) {
  1324			case AF_UNSPEC:
  1325			case AF_INET:
  1326				return -1;
  1327			case AF_INET6:
  1328				struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
  1329				struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)rhs;
> 1330				return memcmp(&saddr6->sin6_addr,
  1331					      &vaddr6->sin6_addr,
  1332					      sizeof(struct sockaddr_in6));
  1333			default:
  1334				return -1;
  1335			}
  1336		}
  1337		default:
  1338			return -1; /* don't expect to be here */
  1339		}
  1340	}
  1341	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
