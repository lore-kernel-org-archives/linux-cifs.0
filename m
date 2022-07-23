Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE320C43334
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Jul 2022 22:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238920AbiGWWwC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 23 Jul 2022 18:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236550AbiGWWwB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 23 Jul 2022 18:52:01 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F49DEBF
        for <linux-cifs@vger.kernel.org>; Sat, 23 Jul 2022 15:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658616718; x=1690152718;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Sq8VSrpH8mADgVhehoXwXzgZctNWhJaAT58teun3Jl0=;
  b=hJR5DsiJWtf1N3fr9RofFZzfCZlNjSSIl1+QM/cfyJgNj7/Mu41Rr9Lp
   Rlco0/GDS2blVycb04c2ViSTXOB8uqQfpLT3hMieeOy107JPmm1xAOpOP
   tP+ZNraMt8pNfX1CKTRTjvCpEsV+T/42/GkPTGQHZWswCMoXpiiDXtwgF
   LoAYDulmGWlnNosVkUErXp8S2HKK1kjqZLvx03y4M+tBga399cT1wCFhc
   6+dnsR1oKSGPDgJwbHTgumxFk3L6SN9dN52vY4LrdJ0sFqs5DeMkmPjN3
   mK7B/NfLWUARIMK7hM8dzUMC1QiG8N63kcoLufMHtAZO5xhYAlaoKuNi4
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10417"; a="288256341"
X-IronPort-AV: E=Sophos;i="5.93,189,1654585200"; 
   d="scan'208";a="288256341"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2022 15:51:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,189,1654585200"; 
   d="scan'208";a="775570420"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 23 Jul 2022 15:51:55 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oFNyU-0003C7-2J;
        Sat, 23 Jul 2022 22:51:54 +0000
Date:   Sun, 24 Jul 2022 06:51:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, smfrench@gmail.com,
        pc@cjr.nz, ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH] cifs: remove some more dead code
Message-ID: <202207240645.7IYWNiqd-lkp@intel.com>
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
config: i386-randconfig-a006 (https://download.01.org/0day-ci/archive/20220724/202207240645.7IYWNiqd-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 12fbd2d377e396ad61bce56d71c98a1eb1bebfa9)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/6e3f3b9d1abb0ac9a6b161af9ac835d32eed006f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Enzo-Matsumiya/cifs-remove-some-more-dead-code/20220724-050054
        git checkout 6e3f3b9d1abb0ac9a6b161af9ac835d32eed006f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash fs/cifs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> fs/cifs/connect.c:2739:24: warning: variable 'saddr4' set but not used [-Wunused-but-set-variable]
                           struct sockaddr_in *saddr4;
                                               ^
   1 warning generated.
--
>> fs/cifs/misc.c:366:9: warning: unused variable 'mid' [-Wunused-variable]
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
>> fs/cifs/sess.c:364:22: warning: unused variable 'ipv4' [-Wunused-variable]
           struct sockaddr_in *ipv4 = (struct sockaddr_in *)&iface->sockaddr;
                               ^
>> fs/cifs/sess.c:365:23: warning: unused variable 'ipv6' [-Wunused-variable]
           struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)&iface->sockaddr;
                                ^
   2 warnings generated.
--
>> fs/cifs/smb2misc.c:512:6: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
           int rc = 0;
               ^
>> fs/cifs/smb2misc.c:812:27: warning: variable 'server' set but not used [-Wunused-but-set-variable]
                   struct TCP_Server_Info *server = NULL;
                                           ^
   2 warnings generated.
--
>> fs/cifs/cifs_swn.c:261:7: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
                   int ret;
                       ^
   fs/cifs/cifs_swn.c:271:7: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
                   int ret;
                       ^
>> fs/cifs/cifs_swn.c:511:22: warning: unused variable 'ipv4' [-Wunused-variable]
           struct sockaddr_in *ipv4 = (struct sockaddr_in *)addr;
                               ^
>> fs/cifs/cifs_swn.c:512:23: warning: unused variable 'ipv6' [-Wunused-variable]
           struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)addr;
                                ^
   4 warnings generated.
--
>> fs/cifs/sess.c:365:23: warning: unused variable 'ipv6' [-Wunused-variable]
           struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)&iface->sockaddr;
                                ^
>> fs/cifs/sess.c:364:22: warning: unused variable 'ipv4' [-Wunused-variable]
           struct sockaddr_in *ipv4 = (struct sockaddr_in *)&iface->sockaddr;
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
