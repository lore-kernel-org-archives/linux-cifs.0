Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5757FC7EE37
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jun 2023 23:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236671AbjFHXjB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Jun 2023 19:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237389AbjFHXjA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Jun 2023 19:39:00 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD5330FD
        for <linux-cifs@vger.kernel.org>; Thu,  8 Jun 2023 16:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686267503; x=1717803503;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nkvHn65bSJcOEwQSDwOpqWWcGk7kc2Xl1OOn28fNzyM=;
  b=DjGHysT7hZJva9pmdFIKW0wSLsQ7NKlSuSHMQdM0rwaBWbPyAmlVALd6
   hcWJYUmpMMyhZTbglM+OsWPnp3Ws/MsBwkjZiILTiDRnUTdcm4qgPeTCS
   EFMNnN2pxgKS1fPNi2uoNec8j0uoDC083PqWPRMP6AArtx3DL0js2Cjw6
   Rgoug0XAwwYJgZ3HQALbEcf54EHwBxovv2NAJaWHBJEOIK+siwtXsx0/h
   53Vu8SVaKoelsNIlehTpZtj8pePh9BaHxlLVAZP1ozoj9KNx3VqfAoEfv
   p+UtnAJpXzxYeqGsr3fv3s82xgXT+J+jh6LRah+7x0RD8oQLokf9Kfse4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="443830258"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="443830258"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:30:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="1040289580"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="1040289580"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 08 Jun 2023 16:30:48 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q7P5b-0008Lc-1G;
        Thu, 08 Jun 2023 23:30:47 +0000
Date:   Fri, 9 Jun 2023 07:30:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH] smb/client: print "Unknown" instead of bogus link speed
 value
Message-ID: <202306090720.TEZbrpR8-lkp@intel.com>
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
config: i386-randconfig-m021-20230608 (https://download.01.org/0day-ci/archive/20230609/202306090720.TEZbrpR8-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build):
        git remote add cifs git://git.samba.org/sfrench/cifs-2.6.git
        git fetch cifs for-next
        git checkout cifs/for-next
        b4 shazam https://lore.kernel.org/r/20230608201055.9716-1-ematsumiya@suse.de
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306090720.TEZbrpR8-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "phy_speed_to_str" [fs/smb/client/cifs.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
