Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9E4C76188
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Apr 2023 21:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235705AbjDDVew (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Apr 2023 17:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236495AbjDDVev (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 Apr 2023 17:34:51 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13A430C1
        for <linux-cifs@vger.kernel.org>; Tue,  4 Apr 2023 14:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680644090; x=1712180090;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xBfbthT2O10RSrWaI0F8gAgs3W23HLStErGIZY9eyXE=;
  b=j3KTY9dc9xTOEt6rZDjVcniT0GxsJtiDCWce/bprs4cklyKVU5qdnpD7
   FeT//E16eqRMJ8KixJUqu85/y//tEhymP3Jn8SGBrmaRlsiYzZaDqHPwl
   AmuxTwuhZnBdCUEqHiFuK9sll5IHWooEgkiAlBRBObMV8KQJ/UU4c3mEc
   CxfgYLjPazTExtB9FNhFASFNKEwuXd06wwai8OEEw9EmHvKMiTQjYC+GY
   NUe6sAOspvTR5j4YTO3QdTMq5SEFwEnvSN5qV5Om3CQMbPr8dcdvScgYU
   PdgANtEs9uXhBajYd8sS2IrMT5z3xVC6nm7WyfNri3l8lki8XXVlkziTj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="405083752"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="405083752"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 14:34:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="797662666"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="797662666"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 04 Apr 2023 14:34:47 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pjoIg-000Q3a-1x;
        Tue, 04 Apr 2023 21:34:46 +0000
Date:   Wed, 5 Apr 2023 05:34:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Thiago Becker <tbecker@redhat.com>, sfrench@samba.org,
        linux-cifs@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, trbecker@gmail.com,
        samba-technical@lists.samba.org, Thiago Becker <tbecker@redhat.com>
Subject: Re: [PATCH] cifs: sanitize paths in cifs_update_super_prepath.
Message-ID: <202304050514.TB9sze0P-lkp@intel.com>
References: <20230404185908.993738-1-tbecker@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404185908.993738-1-tbecker@redhat.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Thiago,

kernel test robot noticed the following build warnings:

[auto build test WARNING on cifs/for-next]
[also build test WARNING on linus/master v6.3-rc5 next-20230404]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Thiago-Becker/cifs-sanitize-paths-in-cifs_update_super_prepath/20230405-030114
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
patch link:    https://lore.kernel.org/r/20230404185908.993738-1-tbecker%40redhat.com
patch subject: [PATCH] cifs: sanitize paths in cifs_update_super_prepath.
config: s390-allyesconfig (https://download.01.org/0day-ci/archive/20230405/202304050514.TB9sze0P-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/4d179c3f90c01aab96bf6a02f70cc111da39d61c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Thiago-Becker/cifs-sanitize-paths-in-cifs_update_super_prepath/20230405-030114
        git checkout 4d179c3f90c01aab96bf6a02f70cc111da39d61c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash fs/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304050514.TB9sze0P-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/cifs/fs_context.c:448:7: warning: no previous prototype for 'sanitize_path' [-Wmissing-prototypes]
     448 | char *sanitize_path(char *path, gfp_t gfp)
         |       ^~~~~~~~~~~~~


vim +/sanitize_path +448 fs/cifs/fs_context.c

   438	
   439	/*
   440	 * Remove duplicate path delimiters. Windows is supposed to do that
   441	 * but there are some bugs that prevent rename from working if there are
   442	 * multiple delimiters.
   443	 *
   444	 * Returns a sanitized duplicate of @path. The caller is responsible for
   445	 * cleaning up the original.
   446	 */
   447	#define IS_DELIM(c) ((c) == '/' || (c) == '\\')
 > 448	char *sanitize_path(char *path, gfp_t gfp)
   449	{
   450		char *cursor1 = path, *cursor2 = path;
   451	
   452		/* skip all prepended delimiters */
   453		while (IS_DELIM(*cursor1))
   454			cursor1++;
   455	
   456		/* copy the first letter */
   457		*cursor2 = *cursor1;
   458	
   459		/* copy the remainder... */
   460		while (*(cursor1++)) {
   461			/* ... skipping all duplicated delimiters */
   462			if (IS_DELIM(*cursor1) && IS_DELIM(*cursor2))
   463				continue;
   464			*(++cursor2) = *cursor1;
   465		}
   466	
   467		/* if the last character is a delimiter, skip it */
   468		if (IS_DELIM(*(cursor2 - 1)))
   469			cursor2--;
   470	
   471		*(cursor2) = '\0';
   472		return kstrdup(path, gfp);
   473	}
   474	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
