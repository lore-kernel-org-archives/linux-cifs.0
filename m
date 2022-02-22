Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48BC2C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Feb 2022 12:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiBVMJE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Feb 2022 07:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbiBVMJD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Feb 2022 07:09:03 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4A6B4592
        for <linux-cifs@vger.kernel.org>; Tue, 22 Feb 2022 04:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645531718; x=1677067718;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mygVEmoTqwyHdg4YMpnQO3RrugIO9li9yYSMleXwVn0=;
  b=lHWgcT0PCOQLD4xuCQyndhomIXq6uxL8LmiCqZx8YKcHH7bw62Cta1jR
   YrRYzq9zUvTS9uS5J0iwUDq6zYzjtqVknq7OPBMct5qGRkF8zw8ucvL7W
   XtNQK9t8eMxzDts6yjBzyvCurCYS0DOM7impufoaAPMJYH3rQLd3eH8pK
   DeYDb2FIEMUN/TircHiR6XL8EeCMk2EhmX+5WvhvL8Rtq6Tvn82LWbaHH
   1Kn7k0x5K6yfkcsL5jRtBfsMbe6SpMhT2uxshCru5D7JdsH4aWhPusHJT
   +jZVl4Y5Ay71gswaGIifKTLUmcncFm0JhhY5UbDdysWucveVXAPsuROhQ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="250507415"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="250507415"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 04:08:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="779110326"
Received: from lkp-server01.sh.intel.com (HELO 788b1cd46f0d) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 22 Feb 2022 04:08:36 -0800
Received: from kbuild by 788b1cd46f0d with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nMTy8-0000CF-3Y; Tue, 22 Feb 2022 12:08:36 +0000
Date:   Tue, 22 Feb 2022 20:08:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     kbuild-all@lists.01.org, Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: truncate the inode and mapping when we simulate
 fcollapse
Message-ID: <202202221941.P3ofWs7j-lkp@intel.com>
References: <20220222053521.289668-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222053521.289668-1-lsahlber@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Ronnie,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on cifs/for-next]
[also build test WARNING on v5.17-rc5 next-20220217]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Ronnie-Sahlberg/cifs-truncate-the-inode-and-mapping-when-we-simulate-fcollapse/20220222-133724
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
config: i386-randconfig-s001-20220221 (https://download.01.org/0day-ci/archive/20220222/202202221941.P3ofWs7j-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/a29e6f21f30f32afbc6cf397a34ca2904038d759
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Ronnie-Sahlberg/cifs-truncate-the-inode-and-mapping-when-we-simulate-fcollapse/20220222-133724
        git checkout a29e6f21f30f32afbc6cf397a34ca2904038d759
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> fs/cifs/smb2ops.c:3920:13: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le64 [addressable] [assigned] [usertype] eof @@     got long long @@
   fs/cifs/smb2ops.c:3920:13: sparse:     expected restricted __le64 [addressable] [assigned] [usertype] eof
   fs/cifs/smb2ops.c:3920:13: sparse:     got long long
>> fs/cifs/smb2ops.c:3921:27: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned long long [usertype] server_eof @@     got restricted __le64 [addressable] [assigned] [usertype] eof @@
   fs/cifs/smb2ops.c:3921:27: sparse:     expected unsigned long long [usertype] server_eof
   fs/cifs/smb2ops.c:3921:27: sparse:     got restricted __le64 [addressable] [assigned] [usertype] eof
>> fs/cifs/smb2ops.c:3922:33: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected long long [usertype] newsize @@     got restricted __le64 [addressable] [assigned] [usertype] eof @@
   fs/cifs/smb2ops.c:3922:33: sparse:     expected long long [usertype] newsize
   fs/cifs/smb2ops.c:3922:33: sparse:     got restricted __le64 [addressable] [assigned] [usertype] eof
>> fs/cifs/smb2ops.c:3923:57: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected long long [usertype] new_size @@     got restricted __le64 [addressable] [assigned] [usertype] eof @@
   fs/cifs/smb2ops.c:3923:57: sparse:     expected long long [usertype] new_size
   fs/cifs/smb2ops.c:3923:57: sparse:     got restricted __le64 [addressable] [assigned] [usertype] eof

vim +3920 fs/cifs/smb2ops.c

  3885	
  3886	static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
  3887				    loff_t off, loff_t len)
  3888	{
  3889		int rc;
  3890		unsigned int xid;
  3891		struct inode *inode;
  3892		struct cifsFileInfo *cfile = file->private_data;
  3893		struct cifsInodeInfo *cifsi;
  3894		__le64 eof;
  3895	
  3896		xid = get_xid();
  3897	
  3898		inode = d_inode(cfile->dentry);
  3899		cifsi = CIFS_I(inode);
  3900	
  3901		if (off >= i_size_read(inode) ||
  3902		    off + len >= i_size_read(inode)) {
  3903			rc = -EINVAL;
  3904			goto out;
  3905		}
  3906	
  3907		rc = smb2_copychunk_range(xid, cfile, cfile, off + len,
  3908					  i_size_read(inode) - off - len, off);
  3909		if (rc < 0)
  3910			goto out;
  3911	
  3912		eof = cpu_to_le64(i_size_read(inode) - len);
  3913		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
  3914				  cfile->fid.volatile_fid, cfile->pid, &eof);
  3915		if (rc < 0)
  3916			goto out;
  3917	
  3918		rc = 0;
  3919	
> 3920		eof = i_size_read(inode) - len;
> 3921		cifsi->server_eof = eof;
> 3922		truncate_setsize(inode, eof);
> 3923		fscache_resize_cookie(cifs_inode_cookie(inode), eof);
  3924	 out:
  3925		free_xid(xid);
  3926		return rc;
  3927	}
  3928	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
