Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C538EC43334
	for <linux-cifs@archiver.kernel.org>; Sun, 24 Jul 2022 19:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiGXTzZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Jul 2022 15:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiGXTzY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Jul 2022 15:55:24 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FF6645E
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 12:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658692523; x=1690228523;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TAIXFpDOQ/CxClmge1r6AUYC/RL/gwXIxitPXhEkqEc=;
  b=jDRDKPvoXPNcaJaKSOgGWdS0fMKfKi5BlDkJzMuQKZPu4Fnx7sZ7aP4Z
   nAQmW/vBv9GYatUTOZWo99Q+M76qZUG9ifpZn/R+IZzr5yYjPIjEGnYt1
   zX7rKLoQsi79NZTsI9pfIEHKezDoGBTcVYKPN8uygPMeUaMCxB7/gzdnA
   i5IrWv/V7RdU0Rpr8cCdTWBig3QVEa2YtzfzGYmpQXeiY1np35uXsVZS9
   Q4fYLhF7euGjGtoxMNoGpn3UtfHXERJX4khS4fVWR/6OTnNOQ6mZJiiaj
   b2RdaihbhbnYZJk5tVKoQ4qto3RMlOGQMtLpZCrScmkpkUW329g2Y0TnY
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10418"; a="288326245"
X-IronPort-AV: E=Sophos;i="5.93,191,1654585200"; 
   d="scan'208";a="288326245"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2022 12:55:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,191,1654585200"; 
   d="scan'208";a="627187988"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 24 Jul 2022 12:55:21 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oFhhA-0004DB-1l;
        Sun, 24 Jul 2022 19:55:20 +0000
Date:   Mon, 25 Jul 2022 03:54:23 +0800
From:   kernel test robot <lkp@intel.com>
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, smfrench@gmail.com,
        pc@cjr.nz, ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH] cifs: split procfs from debug code
Message-ID: <202207250335.WyICKUV2-lkp@intel.com>
References: <20220724145735.5853-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220724145735.5853-1-ematsumiya@suse.de>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Enzo,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on cifs/for-next]
[also build test ERROR on next-20220722]
[cannot apply to linus/master v5.19-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Enzo-Matsumiya/cifs-split-procfs-from-debug-code/20220724-225846
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
config: hexagon-randconfig-r045-20220724 (https://download.01.org/0day-ci/archive/20220725/202207250335.WyICKUV2-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 12fbd2d377e396ad61bce56d71c98a1eb1bebfa9)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/a9bbb62b87033fb57943ff221160dbf92e84e297
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Enzo-Matsumiya/cifs-split-procfs-from-debug-code/20220724-225846
        git checkout a9bbb62b87033fb57943ff221160dbf92e84e297
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: cifs_dump_mem
   >>> referenced by cifssmb.c:418 (fs/cifs/cifssmb.c:418)
   >>> cifs/cifssmb.o:(CIFSPOSIXCreate) in archive fs/built-in.a
   >>> referenced by cifssmb.c:418 (fs/cifs/cifssmb.c:418)
   >>> cifs/cifssmb.o:(CIFSPOSIXCreate) in archive fs/built-in.a
   >>> referenced by cifssmb.c:418 (fs/cifs/cifssmb.c:418)
   >>> cifs/cifssmb.o:(CIFSSMBPosixLock) in archive fs/built-in.a
   >>> referenced 43 more times
--
>> ld.lld: error: undefined symbol: cifs_dump_detail
   >>> referenced by smb1ops.c
   >>> cifs/smb1ops.o:(smb1_operations) in archive fs/built-in.a
   pahole: .tmp_vmlinux.btf: No such file or directory
   ld.lld: error: .btf.vmlinux.bin.o: unknown file type

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
