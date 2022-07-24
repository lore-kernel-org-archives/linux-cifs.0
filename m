Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6024C43334
	for <linux-cifs@archiver.kernel.org>; Sun, 24 Jul 2022 18:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiGXSCQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Jul 2022 14:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGXSCP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Jul 2022 14:02:15 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E4EBE02
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 11:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658685734; x=1690221734;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wlDYF/mA+Dyob8XRa12X+xUPsrRmatzJ8fbOfCTqDPo=;
  b=ijNY9/GKeNY+EqRRev6KRuByyMQfdIkLLmIw5+mNggDRidPBn7VVXtCL
   GQDu79Miuvj6YiNoRrEBEm2F9aPSfFPMZzCBIBkaOScIWJ5JUIJ4vHcP+
   8AWlIIDtVHWJTvclYND9Ovgoq9A0V2qhHzmrvi39TyotMt+7Z91szRLQV
   wFQllawcyspDmWyBXDR/Yeyi25eLjSlfSXtcs3sZR6k2ICDIScCIJCDgV
   T0L1q3a9Wvr3gsH9AaDqH0T2yx3o6UIQfkRsks/6Xh8vfsOtLJQMcgbcA
   cMaO5QxJPZOpmIjeqC6tz4mgG6GaWtOvvaIFXk8JUkYR1Ba8Qku1PAhy1
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10418"; a="267335396"
X-IronPort-AV: E=Sophos;i="5.93,190,1654585200"; 
   d="scan'208";a="267335396"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2022 11:02:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,190,1654585200"; 
   d="scan'208";a="741595649"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 24 Jul 2022 11:02:12 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oFfvf-000457-29;
        Sun, 24 Jul 2022 18:02:11 +0000
Date:   Mon, 25 Jul 2022 02:01:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, smfrench@gmail.com,
        pc@cjr.nz, ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH] cifs: split procfs from debug code
Message-ID: <202207250111.xRaRSq5I-lkp@intel.com>
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
config: i386-randconfig-a006 (https://download.01.org/0day-ci/archive/20220725/202207250111.xRaRSq5I-lkp@intel.com/config)
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
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "cifs_dump_mem" [fs/cifs/cifs.ko] undefined!
>> ERROR: modpost: "cifs_dump_detail" [fs/cifs/cifs.ko] undefined!
--
In file included from fs/cifs/cifssmb.c:31:
>> fs/cifs/debug.h:14:20: warning: function 'cifs_dump_mem' has internal linkage but is not defined [-Wundefined-internal]
static inline void cifs_dump_mem(char *label, void *data, int length);
^
fs/cifs/cifssmb.c:418:2: note: used here
cifs_dump_mem("Invalid transact2 SMB: ", (char *)pSMB,
^
1 warning generated.
--
In file included from fs/cifs/smb1ops.c:13:
>> fs/cifs/debug.h:15:20: warning: function 'cifs_dump_detail' has internal linkage but is not defined [-Wundefined-internal]
static inline void cifs_dump_detail(void *buf, struct TCP_Server_Info *ptcp_info);
^
fs/cifs/smb1ops.c:1172:17: note: used here
.dump_detail = cifs_dump_detail,
^
1 warning generated.
--
fs/cifs/connect.c:2739:24: warning: variable 'saddr4' set but not used [-Wunused-but-set-variable]
struct sockaddr_in *saddr4;
^
In file included from fs/cifs/connect.c:39:
>> fs/cifs/debug.h:14:20: warning: function 'cifs_dump_mem' has internal linkage but is not defined [-Wundefined-internal]
static inline void cifs_dump_mem(char *label, void *data, int length);
^
fs/cifs/connect.c:1054:3: note: used here
cifs_dump_mem("Bad SMB: ", buf,
^
2 warnings generated.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
