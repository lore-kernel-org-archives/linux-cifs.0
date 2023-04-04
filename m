Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC4EC76188
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Apr 2023 22:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbjDDW0z (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Apr 2023 18:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236182AbjDDW0y (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 Apr 2023 18:26:54 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0266A3A92
        for <linux-cifs@vger.kernel.org>; Tue,  4 Apr 2023 15:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680647212; x=1712183212;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0ax22KGbVbyXQaj8xCo9cOEoM//pO00szdw2sbA9zkg=;
  b=Rz30MnYQSAXvGtoeViVtq6tCWTaxXBMahmCe7EDxPeCrsH8pF5nlNm1/
   wBf7HZhE0HwMiZSXLl+O1RsnWLTqn0aU+F9cFqcPe98t8ETimlIGo6Uuv
   hlSLP5JpT/FTp+Qb5X/k9cR110W+STZPd7NKRusYyH45qaQbCT42ZBE5h
   Z3Et5hHbZi+KXZtUGW4BWxvtSCrkGALjMgm09xfQIHRDlVtr9uaKsnN69
   aVRAii3yZo+vJbY2eq5xFGSfX5wAJWRNambXasMxDzWVENY8Wd+tYeZG4
   MSG6iYOykEiLAX+jOfvzrkhojU9OmjhsFFy7PpPYsbtEjUKhdPEeifCAz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="428604981"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="428604981"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 15:26:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="755805994"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="755805994"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 04 Apr 2023 15:26:48 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pjp72-000Q5H-07;
        Tue, 04 Apr 2023 22:26:48 +0000
Date:   Wed, 5 Apr 2023 06:26:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Thiago Becker <tbecker@redhat.com>, sfrench@samba.org,
        linux-cifs@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, pc@cjr.nz,
        lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
        trbecker@gmail.com, samba-technical@lists.samba.org,
        Thiago Becker <tbecker@redhat.com>
Subject: Re: [PATCH] cifs: sanitize paths in cifs_update_super_prepath.
Message-ID: <202304050627.7O0sKgk8-lkp@intel.com>
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
config: x86_64-randconfig-a003-20230403 (https://download.01.org/0day-ci/archive/20230405/202304050627.7O0sKgk8-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/4d179c3f90c01aab96bf6a02f70cc111da39d61c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Thiago-Becker/cifs-sanitize-paths-in-cifs_update_super_prepath/20230405-030114
        git checkout 4d179c3f90c01aab96bf6a02f70cc111da39d61c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash fs/cifs/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304050627.7O0sKgk8-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/cifs/fs_context.c:448:7: warning: no previous prototype for function 'sanitize_path' [-Wmissing-prototypes]
   char *sanitize_path(char *path, gfp_t gfp)
         ^
   fs/cifs/fs_context.c:448:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   char *sanitize_path(char *path, gfp_t gfp)
   ^
   static 
   1 warning generated.


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
