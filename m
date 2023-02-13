Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFAC9C636D7
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Feb 2023 01:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjBMBjF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 12 Feb 2023 20:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBMBjE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 12 Feb 2023 20:39:04 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E726BDCA
        for <linux-cifs@vger.kernel.org>; Sun, 12 Feb 2023 17:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676252343; x=1707788343;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=I2MV2bkWO0gCcGDtJOnT33bjpJl8TPvrgZvVzMp6P0g=;
  b=FOE3ry59Kvf9GkGSkDJvvYw3siP6S/8AvIMgBmh8P5mMwD2LP1avdD3d
   cZLyAib06cUs94stETomCokZzfQQ5gP4YVO7bwloEyssJR40KE8Gw3MQ6
   lL6+e4V4/yxf6GaYiRt0Ke0fq28j+k7fX48ymt7CtFdj/JBIssCpVDn3h
   LOXyfNmDhCu3OEPTZZswh5hp97S7jw5PBK8tKnme+DoQ0+XQz8ylX3qUu
   7uJp+I+a3bUKDRf2Rdaqs9Z9LLFPhT3JVo1wBWqqXUMx3uFygByyurWPI
   liUYyTEwaZlU3IpK9l/cg1+50Gu0U4IYgRE6Kf6X+i+GjsmmRBTppoTx+
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="330794962"
X-IronPort-AV: E=Sophos;i="5.97,291,1669104000"; 
   d="scan'208";a="330794962"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2023 17:39:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="757389226"
X-IronPort-AV: E=Sophos;i="5.97,291,1669104000"; 
   d="scan'208";a="757389226"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Feb 2023 17:39:01 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pRNo4-0007UD-0U;
        Mon, 13 Feb 2023 01:39:00 +0000
Date:   Mon, 13 Feb 2023 09:38:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     David Howells <dhowells@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        Steve French <stfrench@microsoft.com>
Subject: [cifs:for-next 21/25] fs/netfs/iterator.c:372:19: error:
 'netfs_extract_iter_to_sg' undeclared here (not in a function); did you mean
 'netfs_extract_user_iter'?
Message-ID: <202302130931.zOOQKBPI-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   2259206443e31ea6a266adcf0d900fbea17016ec
commit: 1cbcbe544fb221a6cd24474c8af72b2a76f91d4d [21/25] netfs: Add a function to extract an iterator into a scatterlist
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20230213/202302130931.zOOQKBPI-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        git remote add cifs git://git.samba.org/sfrench/cifs-2.6.git
        git fetch --no-tags cifs for-next
        git checkout 1cbcbe544fb221a6cd24474c8af72b2a76f91d4d
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302130931.zOOQKBPI-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from fs/netfs/iterator.c:13:
   include/linux/netfs.h:302:33: error: unknown type name 'iov_iter_extraction_t'
     302 |                                 iov_iter_extraction_t extraction_flags);
         |                                 ^~~~~~~~~~~~~~~~~~~~~
   include/linux/netfs.h:306:34: error: unknown type name 'iov_iter_extraction_t'
     306 |                                  iov_iter_extraction_t extraction_flags);
         |                                  ^~~~~~~~~~~~~~~~~~~~~
   fs/netfs/iterator.c:38:33: error: unknown type name 'iov_iter_extraction_t'
      38 |                                 iov_iter_extraction_t extraction_flags)
         |                                 ^~~~~~~~~~~~~~~~~~~~~
   In file included from fs/netfs/iterator.c:8:
   fs/netfs/iterator.c:105:19: error: 'netfs_extract_user_iter' undeclared here (not in a function)
     105 | EXPORT_SYMBOL_GPL(netfs_extract_user_iter);
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
   fs/netfs/iterator.c:105:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
     105 | EXPORT_SYMBOL_GPL(netfs_extract_user_iter);
         | ^~~~~~~~~~~~~~~~~
   fs/netfs/iterator.c:115:41: error: unknown type name 'iov_iter_extraction_t'
     115 |                                         iov_iter_extraction_t extraction_flags)
         |                                         ^~~~~~~~~~~~~~~~~~~~~
   fs/netfs/iterator.c:168:41: error: unknown type name 'iov_iter_extraction_t'
     168 |                                         iov_iter_extraction_t extraction_flags)
         |                                         ^~~~~~~~~~~~~~~~~~~~~
   fs/netfs/iterator.c:214:41: error: unknown type name 'iov_iter_extraction_t'
     214 |                                         iov_iter_extraction_t extraction_flags)
         |                                         ^~~~~~~~~~~~~~~~~~~~~
   fs/netfs/iterator.c:275:43: error: unknown type name 'iov_iter_extraction_t'
     275 |                                           iov_iter_extraction_t extraction_flags)
         |                                           ^~~~~~~~~~~~~~~~~~~~~
   fs/netfs/iterator.c:346:34: error: unknown type name 'iov_iter_extraction_t'
     346 |                                  iov_iter_extraction_t extraction_flags)
         |                                  ^~~~~~~~~~~~~~~~~~~~~
   In file included from fs/netfs/iterator.c:8:
>> fs/netfs/iterator.c:372:19: error: 'netfs_extract_iter_to_sg' undeclared here (not in a function); did you mean 'netfs_extract_user_iter'?
     372 | EXPORT_SYMBOL_GPL(netfs_extract_iter_to_sg);
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:87:23: note: in definition of macro '___EXPORT_SYMBOL'
      87 |         extern typeof(sym) sym;                                                 \
         |                       ^~~
   include/linux/export.h:147:41: note: in expansion of macro '__EXPORT_SYMBOL'
     147 | #define _EXPORT_SYMBOL(sym, sec)        __EXPORT_SYMBOL(sym, sec, "")
         |                                         ^~~~~~~~~~~~~~~
   include/linux/export.h:151:41: note: in expansion of macro '_EXPORT_SYMBOL'
     151 | #define EXPORT_SYMBOL_GPL(sym)          _EXPORT_SYMBOL(sym, "_gpl")
         |                                         ^~~~~~~~~~~~~~
   fs/netfs/iterator.c:372:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
     372 | EXPORT_SYMBOL_GPL(netfs_extract_iter_to_sg);
         | ^~~~~~~~~~~~~~~~~


vim +372 fs/netfs/iterator.c

   266	
   267	/*
   268	 * Extract up to sg_max folios from an XARRAY-type iterator and add them to
   269	 * the scatterlist.  The pages are not pinned.
   270	 */
   271	static ssize_t netfs_extract_xarray_to_sg(struct iov_iter *iter,
   272						  ssize_t maxsize,
   273						  struct sg_table *sgtable,
   274						  unsigned int sg_max,
 > 275						  iov_iter_extraction_t extraction_flags)
   276	{
   277		struct scatterlist *sg = sgtable->sgl + sgtable->nents;
   278		struct xarray *xa = iter->xarray;
   279		struct folio *folio;
   280		loff_t start = iter->xarray_start + iter->iov_offset;
   281		pgoff_t index = start / PAGE_SIZE;
   282		ssize_t ret = 0;
   283		size_t offset, len;
   284		XA_STATE(xas, xa, index);
   285	
   286		rcu_read_lock();
   287	
   288		xas_for_each(&xas, folio, ULONG_MAX) {
   289			if (xas_retry(&xas, folio))
   290				continue;
   291			if (WARN_ON(xa_is_value(folio)))
   292				break;
   293			if (WARN_ON(folio_test_hugetlb(folio)))
   294				break;
   295	
   296			offset = offset_in_folio(folio, start);
   297			len = min_t(size_t, maxsize, folio_size(folio) - offset);
   298	
   299			sg_set_page(sg, folio_page(folio, 0), len, offset);
   300			sgtable->nents++;
   301			sg++;
   302			sg_max--;
   303	
   304			maxsize -= len;
   305			ret += len;
   306			if (maxsize <= 0 || sg_max == 0)
   307				break;
   308		}
   309	
   310		rcu_read_unlock();
   311		if (ret > 0)
   312			iov_iter_advance(iter, ret);
   313		return ret;
   314	}
   315	
   316	/**
   317	 * netfs_extract_iter_to_sg - Extract pages from an iterator and add ot an sglist
   318	 * @iter: The iterator to extract from
   319	 * @maxsize: The amount of iterator to copy
   320	 * @sgtable: The scatterlist table to fill in
   321	 * @sg_max: Maximum number of elements in @sgtable that may be filled
   322	 * @extraction_flags: Flags to qualify the request
   323	 *
   324	 * Extract the page fragments from the given amount of the source iterator and
   325	 * add them to a scatterlist that refers to all of those bits, to a maximum
   326	 * addition of @sg_max elements.
   327	 *
   328	 * The pages referred to by UBUF- and IOVEC-type iterators are extracted and
   329	 * pinned; BVEC-, KVEC- and XARRAY-type are extracted but aren't pinned; PIPE-
   330	 * and DISCARD-type are not supported.
   331	 *
   332	 * No end mark is placed on the scatterlist; that's left to the caller.
   333	 *
   334	 * @extraction_flags can have ITER_ALLOW_P2PDMA set to request peer-to-peer DMA
   335	 * be allowed on the pages extracted.
   336	 *
   337	 * If successul, @sgtable->nents is updated to include the number of elements
   338	 * added and the number of bytes added is returned.  @sgtable->orig_nents is
   339	 * left unaltered.
   340	 *
   341	 * The iov_iter_extract_mode() function should be used to query how cleanup
   342	 * should be performed.
   343	 */
   344	ssize_t netfs_extract_iter_to_sg(struct iov_iter *iter, size_t maxsize,
   345					 struct sg_table *sgtable, unsigned int sg_max,
   346					 iov_iter_extraction_t extraction_flags)
   347	{
   348		if (maxsize == 0)
   349			return 0;
   350	
   351		switch (iov_iter_type(iter)) {
   352		case ITER_UBUF:
   353		case ITER_IOVEC:
   354			return netfs_extract_user_to_sg(iter, maxsize, sgtable, sg_max,
   355							extraction_flags);
   356		case ITER_BVEC:
   357			return netfs_extract_bvec_to_sg(iter, maxsize, sgtable, sg_max,
   358							extraction_flags);
   359		case ITER_KVEC:
   360			return netfs_extract_kvec_to_sg(iter, maxsize, sgtable, sg_max,
   361							extraction_flags);
   362		case ITER_XARRAY:
   363			return netfs_extract_xarray_to_sg(iter, maxsize, sgtable, sg_max,
   364							  extraction_flags);
   365		default:
   366			pr_err("netfs_extract_iter_to_sg(%u) unsupported\n",
   367			       iov_iter_type(iter));
   368			WARN_ON_ONCE(1);
   369			return -EIO;
   370		}
   371	}
 > 372	EXPORT_SYMBOL_GPL(netfs_extract_iter_to_sg);

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
