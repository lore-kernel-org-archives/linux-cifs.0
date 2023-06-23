Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2219EEB64D7
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Jun 2023 19:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjFWTjX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Jun 2023 15:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjFWTjW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Jun 2023 15:39:22 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E803A1FC6
        for <linux-cifs@vger.kernel.org>; Fri, 23 Jun 2023 12:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687549160; x=1719085160;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=C0OCDbKtMBf0UrjLUm+vZksqXDd2f96Ac+0SmxATfmk=;
  b=GX5CbM9OYARb0IBreTftClp8wnPmfmhruCVTipwMPaNs6Nvnk/Be9iSp
   5z7xV4XdzIb84apRBtQufnThUCuG/QCFHaQIv78UlCvAZb9tZ45vbFmTL
   CRoMw75VXv2mzjhPtjOqZrlVn5fZFfjbnu4spK5zR2aITiIrpevkf3KCo
   pcB52OdqO4vfX1zCWPS3i+jxpf0SYJZ1/iCi4wQPvON+O8opdCw96qLZm
   VewBBcPNqbzRflDkye442YfYjfjneHxKvqrSJE0YXPwkzJ62Eq+ROxDDS
   maVw9RX+MK9YYRYbMxPJn9mBYCd2fGfs1UujsikN+nywUxLwciaSzxje5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10750"; a="359711400"
X-IronPort-AV: E=Sophos;i="6.01,152,1684825200"; 
   d="scan'208";a="359711400"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2023 12:39:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10750"; a="889580506"
X-IronPort-AV: E=Sophos;i="6.01,152,1684825200"; 
   d="scan'208";a="889580506"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 23 Jun 2023 12:39:18 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qCmcn-0008VT-1q;
        Fri, 23 Jun 2023 19:39:17 +0000
Date:   Sat, 24 Jun 2023 03:38:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Shyam Prasad N <sprasad@microsoft.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        Steve French <stfrench@microsoft.com>
Subject: [cifs:for-next 13/13] fs/smb/client/cifs_debug.c:167:1: error:
 expected statement
Message-ID: <202306240307.Q3coT9og-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   33bc5dec2b4fd8d00fed51183615d91badf607d6
commit: 33bc5dec2b4fd8d00fed51183615d91badf607d6 [13/13] cifs: display the endpoint IP details in DebugData
config: i386-randconfig-r001-20230622 (https://download.01.org/0day-ci/archive/20230624/202306240307.Q3coT9og-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce: (https://download.01.org/0day-ci/archive/20230624/202306240307.Q3coT9og-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306240307.Q3coT9og-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/smb/client/cifs_debug.c:167:1: error: expected statement
   }
   ^
   1 error generated.


vim +167 fs/smb/client/cifs_debug.c

33bc5dec2b4fd8 fs/smb/client/cifs_debug.c Shyam Prasad N 2023-06-09  166  
85150929a15b4e fs/cifs/cifs_debug.c       Aurelien Aptel 2019-11-20 @167  }
85150929a15b4e fs/cifs/cifs_debug.c       Aurelien Aptel 2019-11-20  168  

:::::: The code at line 167 was first introduced by commit
:::::: 85150929a15b4e0a225434d5970bba14ebdf31f1 cifs: dump channel info in DebugData

:::::: TO: Aurelien Aptel <aaptel@suse.com>
:::::: CC: Steve French <stfrench@microsoft.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
