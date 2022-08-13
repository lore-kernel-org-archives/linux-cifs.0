Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC40CC19F2D
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Aug 2022 20:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiHMUHd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 13 Aug 2022 16:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiHMUHd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 13 Aug 2022 16:07:33 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42140140D4
        for <linux-cifs@vger.kernel.org>; Sat, 13 Aug 2022 13:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660421252; x=1691957252;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oHsTnDT1isOuIB/jDFVSwFvrrgw9BLec2SBP07lerXk=;
  b=h86fbimzlJA1tNMNtuL3HlRH00oZZnNe9ua8904GKcxaSO60ZQYPDMTh
   SU5rfl2T7je/6n4c/Lisq4p2kToV6FAM5W4T9XOZHrfU3TD8YxJUMg6iU
   PBt6VEh+5kMGUhhAXXWmD22mPmponGe0/foIdekBT9i6GWGgAhRhlKxC1
   NhpZKn30EnBRWOi7Fa6oa/qQDJpi7jPCaPT0i9eZhQ2xC53+7AMqbOW7S
   mXFstuNISLxQXLxM6PYU3nsfpJUUKNg9SSxfEk+kIl6jzCeVmOWZ0CXaD
   u+aFakzZ7uA0jO38Md5GCLO9q0MmVBW48hbDAlW4iVu6g5YK9lDTbSDCe
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="292570396"
X-IronPort-AV: E=Sophos;i="5.93,236,1654585200"; 
   d="scan'208";a="292570396"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2022 13:07:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,236,1654585200"; 
   d="scan'208";a="709355495"
Received: from lkp-server02.sh.intel.com (HELO 8745164cafc7) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 13 Aug 2022 13:07:29 -0700
Received: from kbuild by 8745164cafc7 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oMxPt-00023b-09;
        Sat, 13 Aug 2022 20:07:29 +0000
Date:   Sun, 14 Aug 2022 04:06:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     kbuild-all@lists.01.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH v2] cifs: distribute some bloat out of cifsfs.{c,h}
Message-ID: <202208140351.GDTwWA3i-lkp@intel.com>
References: <20220802162009.5688-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802162009.5688-1-ematsumiya@suse.de>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Enzo,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on cifs/for-next]
[cannot apply to linus/master v5.19 next-20220812]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Enzo-Matsumiya/cifs-distribute-some-bloat-out-of-cifsfs-c-h/20220803-002506
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
config: i386-randconfig-a001 (https://download.01.org/0day-ci/archive/20220814/202208140351.GDTwWA3i-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/ea8b8b846e20b620293cc6b0c18da500ab45fe97
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Enzo-Matsumiya/cifs-distribute-some-bloat-out-of-cifsfs-c-h/20220803-002506
        git checkout ea8b8b846e20b620293cc6b0c18da500ab45fe97
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash fs/cifs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   fs/cifs/ioctl.c: In function 'cifs_ioctl':
>> fs/cifs/ioctl.c:326:17: warning: unused variable 'caps' [-Wunused-variable]
     326 |         __u64   caps;
         |                 ^~~~


vim +/caps +326 fs/cifs/ioctl.c

7ba3d1cdb7988c Steve French    2021-05-02  313  
f9ddcca4cf7d95 Steve French    2008-05-15  314  long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
^1da177e4c3f41 Linus Torvalds  2005-04-16  315  {
496ad9aa8ef448 Al Viro         2013-01-23  316  	struct inode *inode = file_inode(filep);
7e7db86c7e1088 Steve French    2019-09-19  317  	struct smb3_key_debug_info pkey_inf;
^1da177e4c3f41 Linus Torvalds  2005-04-16  318  	int rc = -ENOTTY; /* strange error - but the precedent */
6d5786a34d98bf Pavel Shilovsky 2012-06-20  319  	unsigned int xid;
ba00ba64cf0895 Jeff Layton     2010-09-20  320  	struct cifsFileInfo *pSMBFile = filep->private_data;
96daf2b09178d8 Steve French    2011-05-27  321  	struct cifs_tcon *tcon;
a77592a70081ed Ronnie Sahlberg 2020-07-09  322  	struct tcon_link *tlink;
d26c2ddd335696 Steve French    2020-02-06  323  	struct cifs_sb_info *cifs_sb;
f654bac2227adc Steve French    2005-04-28  324  	__u64	ExtAttrBits = 0;
ea8b8b846e20b6 Enzo Matsumiya  2022-08-02  325  #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
618763958b2291 Jeff Layton     2010-11-08 @326  	__u64   caps;

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
