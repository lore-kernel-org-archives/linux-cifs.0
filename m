Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE4C7C636D7
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Feb 2023 00:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjBMA6E (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 12 Feb 2023 19:58:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjBMA6D (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 12 Feb 2023 19:58:03 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1C04C17
        for <linux-cifs@vger.kernel.org>; Sun, 12 Feb 2023 16:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676249882; x=1707785882;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=CURrrhcMF9Es3tTPm7Xob2bMUXQmeCWTB6KzxHKsK9c=;
  b=jnQu6e2ylVuQXNQg4Rmb8AA130dEo4m9edMknl6+FoVSRGDrC7W8t5xY
   xfX72pMkzkUoUrgkMXw25CrGsYmMtOAbyHkEqAEzjJ5zBDscMsaWZVhlb
   J4rnqG1T+Had+ejhM0QE9W9k03yThSydYOK7WCGkdjfGE9U/98k3DluV5
   yk/gyqthszfaUz+kLcfQ/Gq9BASc9RyUdD9Bhm0KH304GtanP1TOt479u
   7yb4mYSmFcGotspeikmLyabkamkXmj5IW9Ir5v0BPo26QZ/9mDaRHrx1n
   7RUm6ndnq/9TmNp3B6y6d+BOim0UAOPNiqGufkCYNsyTTGBrY0riX0eYq
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="358190414"
X-IronPort-AV: E=Sophos;i="5.97,291,1669104000"; 
   d="scan'208";a="358190414"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2023 16:58:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="842597401"
X-IronPort-AV: E=Sophos;i="5.97,291,1669104000"; 
   d="scan'208";a="842597401"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 12 Feb 2023 16:58:00 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pRNAN-0007T9-1C;
        Mon, 13 Feb 2023 00:57:59 +0000
Date:   Mon, 13 Feb 2023 08:57:13 +0800
From:   kernel test robot <lkp@intel.com>
To:     David Howells <dhowells@redhat.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        Steve French <stfrench@microsoft.com>
Subject: [cifs:for-next 20/25] fs/netfs/iterator.c:65:9: error: call to
 undeclared function 'iov_iter_extract_pages'; ISO C99 and later do not
 support implicit function declarations
Message-ID: <202302130853.kU76MQRK-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   2259206443e31ea6a266adcf0d900fbea17016ec
commit: d1df0021a8275ef2e0d455b384e78e18e57cf9f2 [20/25] netfs: Add a function to extract a UBUF or IOVEC into a BVEC iterator
config: arm-buildonly-randconfig-r005-20230213 (https://download.01.org/0day-ci/archive/20230213/202302130853.kU76MQRK-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project db0e6591612b53910a1b366863348bdb9d7d2fb1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        git remote add cifs git://git.samba.org/sfrench/cifs-2.6.git
        git fetch --no-tags cifs for-next
        git checkout d1df0021a8275ef2e0d455b384e78e18e57cf9f2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash fs/netfs/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302130853.kU76MQRK-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from fs/netfs/iterator.c:11:
   include/linux/netfs.h:302:5: error: unknown type name 'iov_iter_extraction_t'
                                   iov_iter_extraction_t extraction_flags);
                                   ^
   fs/netfs/iterator.c:36:5: error: unknown type name 'iov_iter_extraction_t'
                                   iov_iter_extraction_t extraction_flags)
                                   ^
>> fs/netfs/iterator.c:65:9: error: call to undeclared function 'iov_iter_extract_pages'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                   ret = iov_iter_extract_pages(orig, &pages, count,
                         ^
   fs/netfs/iterator.c:65:9: note: did you mean 'iov_iter_get_pages'?
   include/linux/uio.h:253:9: note: 'iov_iter_get_pages' declared here
   ssize_t iov_iter_get_pages(struct iov_iter *i, struct page **pages,
           ^
   3 errors generated.


vim +/iov_iter_extract_pages +65 fs/netfs/iterator.c

    13	
    14	/**
    15	 * netfs_extract_user_iter - Extract the pages from a user iterator into a bvec
    16	 * @orig: The original iterator
    17	 * @orig_len: The amount of iterator to copy
    18	 * @new: The iterator to be set up
    19	 * @extraction_flags: Flags to qualify the request
    20	 *
    21	 * Extract the page fragments from the given amount of the source iterator and
    22	 * build up a second iterator that refers to all of those bits.  This allows
    23	 * the original iterator to disposed of.
    24	 *
    25	 * @extraction_flags can have ITER_ALLOW_P2PDMA set to request peer-to-peer DMA be
    26	 * allowed on the pages extracted.
    27	 *
    28	 * On success, the number of elements in the bvec is returned, the original
    29	 * iterator will have been advanced by the amount extracted.
    30	 *
    31	 * The iov_iter_extract_mode() function should be used to query how cleanup
    32	 * should be performed.
    33	 */
    34	ssize_t netfs_extract_user_iter(struct iov_iter *orig, size_t orig_len,
    35					struct iov_iter *new,
    36					iov_iter_extraction_t extraction_flags)
    37	{
    38		struct bio_vec *bv = NULL;
    39		struct page **pages;
    40		unsigned int cur_npages;
    41		unsigned int max_pages;
    42		unsigned int npages = 0;
    43		unsigned int i;
    44		ssize_t ret;
    45		size_t count = orig_len, offset, len;
    46		size_t bv_size, pg_size;
    47	
    48		if (WARN_ON_ONCE(!iter_is_ubuf(orig) && !iter_is_iovec(orig)))
    49			return -EIO;
    50	
    51		max_pages = iov_iter_npages(orig, INT_MAX);
    52		bv_size = array_size(max_pages, sizeof(*bv));
    53		bv = kvmalloc(bv_size, GFP_KERNEL);
    54		if (!bv)
    55			return -ENOMEM;
    56	
    57		/* Put the page list at the end of the bvec list storage.  bvec
    58		 * elements are larger than page pointers, so as long as we work
    59		 * 0->last, we should be fine.
    60		 */
    61		pg_size = array_size(max_pages, sizeof(*pages));
    62		pages = (void *)bv + bv_size - pg_size;
    63	
    64		while (count && npages < max_pages) {
  > 65			ret = iov_iter_extract_pages(orig, &pages, count,

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
