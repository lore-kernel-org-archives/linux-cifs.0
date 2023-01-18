Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85968C32793
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Jan 2023 16:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjARQch (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Jan 2023 11:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjARQbx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Jan 2023 11:31:53 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3AF3803B
        for <linux-cifs@vger.kernel.org>; Wed, 18 Jan 2023 08:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674059400; x=1705595400;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=lQh1NXy28ZzKIkgd9iB+h3aSHV0iueVH9nQyUd+1wlY=;
  b=ZeUo5IItv/UKPqT1W/bWvkT81qoBsQuzWPOVySYPR3tqkgHh8m47m4o1
   EPFPyiwHJ8PYr+XMxsAaMlvAGaKVjTkw2K1FoZCz58oi+wGELGKbYW8Dt
   qCJP+/QsQf9jW4aQDZr+yyPROoPxU8chOXV4iZ2V/+PKreO+X7gtkFygh
   7cdGq+DPmTTJbt4OkXC6JQGqOEosn0TJdZoFlkrn+9nhMCv7i5FKdSQQh
   Mx939kFSWQUWV8V7mH9juYgJqMGrKAkcxNZq0+wxBb3Cd34UNQjru0j/h
   gUfKPNmXtqatYHt8TVCc0kGQey9nW34iYzNPZNnV/oS0uDk2XlqkBWikw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="305399470"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="305399470"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 08:30:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="748523373"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="748523373"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Jan 2023 08:29:57 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pIBJz-0000Vb-21;
        Wed, 18 Jan 2023 16:29:55 +0000
Date:   Thu, 19 Jan 2023 00:29:06 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        Steve French <stfrench@microsoft.com>
Subject: [cifs:for-next 2/7] fs/cifs/dfs_cache.c:1070:7: warning: variable
 'rc' is used uninitialized whenever 'if' condition is true
Message-ID: <202301190004.bEHvbKG6-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   027c69ea2097550090545e7c539e01a1998f7438
commit: 9e2e1207815ca38386ab7cb40ebcebc2a3918cb0 [2/7] cifs: avoid re-lookups in dfs_cache_find()
config: s390-randconfig-r034-20230116 (https://download.01.org/0day-ci/archive/20230119/202301190004.bEHvbKG6-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 4196ca3278f78c6e19246e54ab0ecb364e37d66a)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        git remote add cifs git://git.samba.org/sfrench/cifs-2.6.git
        git fetch --no-tags cifs for-next
        git checkout 9e2e1207815ca38386ab7cb40ebcebc2a3918cb0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash drivers/net/ethernet/mellanox/mlx5/core/ fs/cifs/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from fs/cifs/dfs_cache.c:15:
   In file included from fs/cifs/cifsglob.h:14:
   In file included from include/linux/inet.h:42:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from fs/cifs/dfs_cache.c:15:
   In file included from fs/cifs/cifsglob.h:14:
   In file included from include/linux/inet.h:42:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from fs/cifs/dfs_cache.c:15:
   In file included from fs/cifs/cifsglob.h:14:
   In file included from include/linux/inet.h:42:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:692:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:700:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:708:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:717:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:726:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:735:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
>> fs/cifs/dfs_cache.c:1070:7: warning: variable 'rc' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
                   if (!strcasecmp(t->name, it->it_name)) {
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/cifs/dfs_cache.c:1082:9: note: uninitialized use occurs here
           return rc;
                  ^~
   fs/cifs/dfs_cache.c:1070:3: note: remove the 'if' if its condition is always false
                   if (!strcasecmp(t->name, it->it_name)) {
                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> fs/cifs/dfs_cache.c:1069:2: warning: variable 'rc' is used uninitialized whenever 'for' loop exits because its condition is false [-Wsometimes-uninitialized]
           list_for_each_entry(t, &ce->tlist, list) {
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/list.h:675:7: note: expanded from macro 'list_for_each_entry'
                !list_entry_is_head(pos, head, member);                    \
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/cifs/dfs_cache.c:1082:9: note: uninitialized use occurs here
           return rc;
                  ^~
   fs/cifs/dfs_cache.c:1069:2: note: remove the condition if it is always true
           list_for_each_entry(t, &ce->tlist, list) {
           ^
   include/linux/list.h:675:7: note: expanded from macro 'list_for_each_entry'
                !list_entry_is_head(pos, head, member);                    \
                ^
   fs/cifs/dfs_cache.c:1066:6: warning: variable 'rc' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (likely(!strcasecmp(it->it_name, t->name)))
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:77:20: note: expanded from macro 'likely'
   # define likely(x)      __builtin_expect(!!(x), 1)
                           ^~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/cifs/dfs_cache.c:1082:9: note: uninitialized use occurs here
           return rc;
                  ^~
   fs/cifs/dfs_cache.c:1066:2: note: remove the 'if' if its condition is always false
           if (likely(!strcasecmp(it->it_name, t->name)))
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/cifs/dfs_cache.c:1038:8: note: initialize the variable 'rc' to silence this warning
           int rc;
                 ^
                  = 0
   15 warnings generated.


vim +1070 fs/cifs/dfs_cache.c

54be1f6c1c3749 Paulo Alcantara        2018-11-14  1015  
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1016  /**
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1017   * dfs_cache_update_tgthint - update target hint of a DFS cache entry
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1018   *
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1019   * If it doesn't find the cache entry, then it will get a DFS referral for @path
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1020   * and create a new entry.
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1021   *
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1022   * In case the cache entry exists but expired, it will get a DFS referral
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1023   * for @path and then update the respective cache entry.
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1024   *
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1025   * @xid: syscall id
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1026   * @ses: smb session
c870a8e70e6827 Paulo Alcantara        2021-06-04  1027   * @cp: codepage
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1028   * @remap: type of character remapping for paths
c870a8e70e6827 Paulo Alcantara        2021-06-04  1029   * @path: path to lookup in DFS referral cache
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1030   * @it: DFS target iterator
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1031   *
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1032   * Return zero if the target hint was updated successfully, otherwise non-zero.
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1033   */
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1034  int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
c870a8e70e6827 Paulo Alcantara        2021-06-04  1035  			     const struct nls_table *cp, int remap, const char *path,
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1036  			     const struct dfs_cache_tgt_iterator *it)
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1037  {
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1038  	int rc;
9cfdb1c12bae26 Al Viro                2021-03-18  1039  	const char *npath;
185352ae6171c8 Paulo Alcantara (SUSE  2019-12-04  1040) 	struct cache_entry *ce;
185352ae6171c8 Paulo Alcantara (SUSE  2019-12-04  1041) 	struct cache_dfs_tgt *t;
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1042  
c870a8e70e6827 Paulo Alcantara        2021-06-04  1043  	npath = dfs_cache_canonical_path(path, cp, remap);
c870a8e70e6827 Paulo Alcantara        2021-06-04  1044  	if (IS_ERR(npath))
c870a8e70e6827 Paulo Alcantara        2021-06-04  1045  		return PTR_ERR(npath);
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1046  
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1047) 	cifs_dbg(FYI, "%s: update target hint - path: %s\n", __func__, npath);
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1048) 
9e2e1207815ca3 Paulo Alcantara        2023-01-17  1049  	ce = cache_refresh_path(xid, ses, npath);
9e2e1207815ca3 Paulo Alcantara        2023-01-17  1050  	if (IS_ERR(ce)) {
9e2e1207815ca3 Paulo Alcantara        2023-01-17  1051  		rc = PTR_ERR(ce);
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1052) 		goto out_free_path;
9e2e1207815ca3 Paulo Alcantara        2023-01-17  1053  	}
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1054) 
9e2e1207815ca3 Paulo Alcantara        2023-01-17  1055  	up_read(&htable_rw_lock);
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1056) 	down_write(&htable_rw_lock);
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1057  
42caeba713b12e Paulo Alcantara        2021-06-04  1058  	ce = lookup_cache_entry(npath);
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1059  	if (IS_ERR(ce)) {
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1060  		rc = PTR_ERR(ce);
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1061) 		goto out_unlock;
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1062  	}
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1063  
185352ae6171c8 Paulo Alcantara (SUSE  2019-12-04  1064) 	t = ce->tgthint;
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1065  
185352ae6171c8 Paulo Alcantara (SUSE  2019-12-04  1066) 	if (likely(!strcasecmp(it->it_name, t->name)))
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1067) 		goto out_unlock;
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1068  
185352ae6171c8 Paulo Alcantara (SUSE  2019-12-04 @1069) 	list_for_each_entry(t, &ce->tlist, list) {
185352ae6171c8 Paulo Alcantara (SUSE  2019-12-04 @1070) 		if (!strcasecmp(t->name, it->it_name)) {
185352ae6171c8 Paulo Alcantara (SUSE  2019-12-04  1071) 			ce->tgthint = t;
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1072  			cifs_dbg(FYI, "%s: new target hint: %s\n", __func__,
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1073  				 it->it_name);
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1074  			break;
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1075  		}
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1076  	}
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1077  
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1078) out_unlock:
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1079) 	up_write(&htable_rw_lock);
742d8de0186e9f Paulo Alcantara (SUSE  2019-12-04  1080) out_free_path:
c870a8e70e6827 Paulo Alcantara        2021-06-04  1081  	kfree(npath);
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1082  	return rc;
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1083  }
54be1f6c1c3749 Paulo Alcantara        2018-11-14  1084  

:::::: The code at line 1070 was first introduced by commit
:::::: 185352ae6171c845951e21017b2925a6f2795904 cifs: Clean up DFS referral cache

:::::: TO: Paulo Alcantara (SUSE) <pc@cjr.nz>
:::::: CC: Steve French <stfrench@microsoft.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
