Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92896C43334
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Jul 2022 22:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238916AbiGWWwA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 23 Jul 2022 18:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236550AbiGWWv7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 23 Jul 2022 18:51:59 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65085E0AF
        for <linux-cifs@vger.kernel.org>; Sat, 23 Jul 2022 15:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658616718; x=1690152718;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jZMMBSO6XzRENTPVXqmNrupg0vbWMzz6op6MGiXOTNU=;
  b=Z/vjmjQAanHTS3aZSjdoFBAGawr/EIHUOumloN2nerP3WxM68GNmp8B/
   sK4SQSNQGWEC70mT7z7vwm/+g3mPozI740bkVHooVG29Q2IwrFTXXUlu9
   pT6cEj9Fh+cefxyDECdp8XAgzg7CvG7yPyuTVq889leD1rNI3lqzRVUfr
   x1gi1nKLO5PlIsRbyiWLrK7HCVCV7+M5vVKuZdQaVH2GOBVkjvfsOc67f
   DTlMiM6Gqsbf0U3w1vZptxiEMy67yH3NYpPydzAH96zXUdUHFX4Ixdt8n
   HDpgBrg8P2wxIw0BSPKr9nszcfr/S2/+CVEiTkWfB0X02N3pZ0mwUjYzn
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10417"; a="349196290"
X-IronPort-AV: E=Sophos;i="5.93,189,1654585200"; 
   d="scan'208";a="349196290"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2022 15:51:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,189,1654585200"; 
   d="scan'208";a="603001687"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 23 Jul 2022 15:51:55 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oFNyU-0003C9-2N;
        Sat, 23 Jul 2022 22:51:54 +0000
Date:   Sun, 24 Jul 2022 06:51:01 +0800
From:   kernel test robot <lkp@intel.com>
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, smfrench@gmail.com,
        pc@cjr.nz, ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH] cifs: remove some more dead code
Message-ID: <202207240608.0JmhVpYu-lkp@intel.com>
References: <20220723205901.16678-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723205901.16678-1-ematsumiya@suse.de>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Enzo,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on cifs/for-next]
[also build test WARNING on linus/master v5.19-rc7 next-20220722]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Enzo-Matsumiya/cifs-remove-some-more-dead-code/20220724-050054
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
config: arm-randconfig-r013-20220724 (https://download.01.org/0day-ci/archive/20220724/202207240608.0JmhVpYu-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 12fbd2d377e396ad61bce56d71c98a1eb1bebfa9)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/intel-lab-lkp/linux/commit/6e3f3b9d1abb0ac9a6b161af9ac835d32eed006f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Enzo-Matsumiya/cifs-remove-some-more-dead-code/20220724-050054
        git checkout 6e3f3b9d1abb0ac9a6b161af9ac835d32eed006f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash fs/cifs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> fs/cifs/connect.c:2739:24: warning: variable 'saddr4' set but not used [-Wunused-but-set-variable]
                           struct sockaddr_in *saddr4;
                                               ^
   1 warning generated.
--
   fs/cifs/misc.c:366:9: warning: unused variable 'mid' [-Wunused-variable]
                   __u16 mid = get_mid(smb);
                         ^
>> fs/cifs/misc.c:413:35: warning: variable 'pnotify' set but not used [-Wunused-but-set-variable]
                   struct file_notify_information *pnotify;
                                                   ^
>> fs/cifs/misc.c:520:21: warning: variable 'tcon' set but not used [-Wunused-but-set-variable]
                   struct cifs_tcon *tcon = NULL;
                                     ^
   3 warnings generated.
--
>> fs/cifs/smb2misc.c:512:6: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
           int rc = 0;
               ^
>> fs/cifs/smb2misc.c:812:27: warning: variable 'server' set but not used [-Wunused-but-set-variable]
                   struct TCP_Server_Info *server = NULL;
                                           ^
   2 warnings generated.


vim +/saddr4 +2739 fs/cifs/connect.c

^1da177e4c3f41 Linus Torvalds  2005-04-16  2727  
3eb9a8893a76cf Ben Greear      2010-09-01  2728  static int
3eb9a8893a76cf Ben Greear      2010-09-01  2729  bind_socket(struct TCP_Server_Info *server)
3eb9a8893a76cf Ben Greear      2010-09-01  2730  {
3eb9a8893a76cf Ben Greear      2010-09-01  2731  	int rc = 0;
3eb9a8893a76cf Ben Greear      2010-09-01  2732  	if (server->srcaddr.ss_family != AF_UNSPEC) {
3eb9a8893a76cf Ben Greear      2010-09-01  2733  		/* Bind to the specified local IP address */
3eb9a8893a76cf Ben Greear      2010-09-01  2734  		struct socket *socket = server->ssocket;
3eb9a8893a76cf Ben Greear      2010-09-01  2735  		rc = socket->ops->bind(socket,
3eb9a8893a76cf Ben Greear      2010-09-01  2736  				       (struct sockaddr *) &server->srcaddr,
3eb9a8893a76cf Ben Greear      2010-09-01  2737  				       sizeof(server->srcaddr));
3eb9a8893a76cf Ben Greear      2010-09-01  2738  		if (rc < 0) {
3eb9a8893a76cf Ben Greear      2010-09-01 @2739  			struct sockaddr_in *saddr4;
3eb9a8893a76cf Ben Greear      2010-09-01  2740  			struct sockaddr_in6 *saddr6;
3eb9a8893a76cf Ben Greear      2010-09-01  2741  			saddr4 = (struct sockaddr_in *)&server->srcaddr;
3eb9a8893a76cf Ben Greear      2010-09-01  2742  			saddr6 = (struct sockaddr_in6 *)&server->srcaddr;
3eb9a8893a76cf Ben Greear      2010-09-01  2743  			if (saddr6->sin6_family == AF_INET6)
afe6f65353b644 Ronnie Sahlberg 2019-08-28  2744  				cifs_server_dbg(VFS, "Failed to bind to: %pI6c, error: %d\n",
3eb9a8893a76cf Ben Greear      2010-09-01  2745  					 &saddr6->sin6_addr, rc);
3eb9a8893a76cf Ben Greear      2010-09-01  2746  			else
afe6f65353b644 Ronnie Sahlberg 2019-08-28  2747  				cifs_server_dbg(VFS, "Failed to bind to: %pI4, error: %d\n",
3eb9a8893a76cf Ben Greear      2010-09-01  2748  					 &saddr4->sin_addr.s_addr, rc);
3eb9a8893a76cf Ben Greear      2010-09-01  2749  		}
3eb9a8893a76cf Ben Greear      2010-09-01  2750  	}
3eb9a8893a76cf Ben Greear      2010-09-01  2751  	return rc;
3eb9a8893a76cf Ben Greear      2010-09-01  2752  }
^1da177e4c3f41 Linus Torvalds  2005-04-16  2753  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
