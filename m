Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4D5C636D7
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Feb 2023 01:08:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjBMBIE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 12 Feb 2023 20:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjBMBID (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 12 Feb 2023 20:08:03 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F629977C
        for <linux-cifs@vger.kernel.org>; Sun, 12 Feb 2023 17:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676250482; x=1707786482;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=+jq+vAEfNU8iZ17uXb+IjGoaq2LFy7ickfOwdXjYhw0=;
  b=cg3WlE+nHAAaji/VJKFO61AQj3x3jsk5BPC4luaZKsyR3IZ+yBukXN9L
   wmnoElzTnTmpicpvJmrh7LiGqcnmVe3p1L7kN82hpQO6IdXIHidwIluqV
   5TNVwQyCgAlvhLsMAlErh68EQK4HyDwzJUWanOq3WUEPp+asFWJSSFZMK
   2JXKl7s4WhTG02JSYXBu/exhmxrVkJIcrCkOQi2ShOGiB8PK0J2nccQZm
   xl4QE7I0gN3acBI95ycbeiPNh26bygoFpZgqfaEpL7YOjfCmA+1z/6cJC
   P9fgNEdiQi8dC8m7aMniy+pNwc8fFTHiTqVoNpB1LLvVOamNn7siVOiSE
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="329408391"
X-IronPort-AV: E=Sophos;i="5.97,291,1669104000"; 
   d="scan'208";a="329408391"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2023 17:08:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="811418913"
X-IronPort-AV: E=Sophos;i="5.97,291,1669104000"; 
   d="scan'208";a="811418913"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 12 Feb 2023 17:08:00 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pRNK3-0007Td-1w;
        Mon, 13 Feb 2023 01:07:59 +0000
Date:   Mon, 13 Feb 2023 09:07:38 +0800
From:   kernel test robot <lkp@intel.com>
To:     David Howells <dhowells@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        Steve French <stfrench@microsoft.com>
Subject: [cifs:for-next 20/25] fs/netfs/iterator.c:36:33: error: unknown type
 name 'iov_iter_extraction_t'
Message-ID: <202302130948.NfSnmBaU-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   2259206443e31ea6a266adcf0d900fbea17016ec
commit: d1df0021a8275ef2e0d455b384e78e18e57cf9f2 [20/25] netfs: Add a function to extract a UBUF or IOVEC into a BVEC iterator
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20230213/202302130948.NfSnmBaU-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        git remote add cifs git://git.samba.org/sfrench/cifs-2.6.git
        git fetch --no-tags cifs for-next
        git checkout d1df0021a8275ef2e0d455b384e78e18e57cf9f2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302130948.NfSnmBaU-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from fs/netfs/iterator.c:11:
   include/linux/netfs.h:302:33: error: unknown type name 'iov_iter_extraction_t'
     302 |                                 iov_iter_extraction_t extraction_flags);
         |                                 ^~~~~~~~~~~~~~~~~~~~~
>> fs/netfs/iterator.c:36:33: error: unknown type name 'iov_iter_extraction_t'
      36 |                                 iov_iter_extraction_t extraction_flags)
         |                                 ^~~~~~~~~~~~~~~~~~~~~
   In file included from fs/netfs/iterator.c:8:
>> fs/netfs/iterator.c:103:19: error: 'netfs_extract_user_iter' undeclared here (not in a function)
     103 | EXPORT_SYMBOL_GPL(netfs_extract_user_iter);
         |                   ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:87:23: note: in definition of macro '___EXPORT_SYMBOL'
      87 |         extern typeof(sym) sym;                                                 \
         |                       ^~~
   include/linux/export.h:147:41: note: in expansion of macro '__EXPORT_SYMBOL'
     147 | #define _EXPORT_SYMBOL(sym, sec)        __EXPORT_SYMBOL(sym, sec, "")
         |                                         ^~~~~~~~~~~~~~~
   include/linux/export.h:151:41: note: in expansion of macro '_EXPORT_SYMBOL'
     151 | #define EXPORT_SYMBOL_GPL(sym)          _EXPORT_SYMBOL(sym, "_gpl")
         |                                         ^~~~~~~~~~~~~~
   fs/netfs/iterator.c:103:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
     103 | EXPORT_SYMBOL_GPL(netfs_extract_user_iter);
         | ^~~~~~~~~~~~~~~~~


vim +/iov_iter_extraction_t +36 fs/netfs/iterator.c

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
  > 36					iov_iter_extraction_t extraction_flags)
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
    65			ret = iov_iter_extract_pages(orig, &pages, count,
    66						     max_pages - npages, extraction_flags,
    67						     &offset);
    68			if (ret < 0) {
    69				pr_err("Couldn't get user pages (rc=%zd)\n", ret);
    70				break;
    71			}
    72	
    73			if (ret > count) {
    74				pr_err("get_pages rc=%zd more than %zu\n", ret, count);
    75				break;
    76			}
    77	
    78			count -= ret;
    79			ret += offset;
    80			cur_npages = DIV_ROUND_UP(ret, PAGE_SIZE);
    81	
    82			if (npages + cur_npages > max_pages) {
    83				pr_err("Out of bvec array capacity (%u vs %u)\n",
    84				       npages + cur_npages, max_pages);
    85				break;
    86			}
    87	
    88			for (i = 0; i < cur_npages; i++) {
    89				len = ret > PAGE_SIZE ? PAGE_SIZE : ret;
    90				bv[npages + i].bv_page	 = *pages++;
    91				bv[npages + i].bv_offset = offset;
    92				bv[npages + i].bv_len	 = len - offset;
    93				ret -= len;
    94				offset = 0;
    95			}
    96	
    97			npages += cur_npages;
    98		}
    99	
   100		iov_iter_bvec(new, orig->data_source, bv, npages, orig_len - count);
   101		return npages;
   102	}
 > 103	EXPORT_SYMBOL_GPL(netfs_extract_user_iter);

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
