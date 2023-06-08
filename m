Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4535FC7EE23
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jun 2023 23:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjFHXRv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Jun 2023 19:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjFHXRu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Jun 2023 19:17:50 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9124A30C3
        for <linux-cifs@vger.kernel.org>; Thu,  8 Jun 2023 16:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686266269; x=1717802269;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+zIRFqQZGYUpqmuXRiKr+ofMBa2fPoHGSvJ5Kt4nl1s=;
  b=kUEZNLoTuZBD12s+MxwFY5jDEpTNxrbrqmuiO/WYWReXPvu/dCPyEack
   qwfNhA+AdpLXQK++hZKNyXFAZtGECECKsgxId/2kgkF7v5Qs92rt3PvRg
   XF0fz1E4rugt0tEuNZclYoZz1XFdiX3kDIOlX7zJ/VajzbXx7PmGXqhm2
   qK9ZuTlXgGvisy0h2ix+3QC9tGcazvkx8YilOS3Vjrf90RJ71rbkEVaT1
   S2IATxuo82pnM+sOiwiwU/QtFiDwM6XP+1UMrAdzKNQPXzxAtw+tvE8ex
   2/WNkXozytxkyz05x9NP5EETyI2mglTJ2RV6smVuJJwnquCF6QH7+gKuc
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="337816534"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="337816534"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:17:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="956921312"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="956921312"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 08 Jun 2023 16:17:47 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q7Ot0-0008LD-2b;
        Thu, 08 Jun 2023 23:17:46 +0000
Date:   Fri, 9 Jun 2023 07:17:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: Re: [PATCH] smb/client: print "Unknown" instead of bogus link speed
 value
Message-ID: <202306090727.gIPzxR6M-lkp@intel.com>
References: <20230608201055.9716-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608201055.9716-1-ematsumiya@suse.de>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Enzo,

kernel test robot noticed the following build errors:

[auto build test ERROR on cifs/for-next]
[also build test ERROR on linus/master v6.4-rc5 next-20230608]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Enzo-Matsumiya/smb-client-print-Unknown-instead-of-bogus-link-speed-value/20230609-041241
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
patch link:    https://lore.kernel.org/r/20230608201055.9716-1-ematsumiya%40suse.de
patch subject: [PATCH] smb/client: print "Unknown" instead of bogus link speed value
config: x86_64-randconfig-x062-20230608 (https://download.01.org/0day-ci/archive/20230609/202306090727.gIPzxR6M-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git remote add cifs git://git.samba.org/sfrench/cifs-2.6.git
        git fetch cifs for-next
        git checkout cifs/for-next
        b4 shazam https://lore.kernel.org/r/20230608201055.9716-1-ematsumiya@suse.de
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306090727.gIPzxR6M-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "phy_speed_to_str" [fs/smb/client/cifs.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
