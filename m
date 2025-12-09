Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA7D18B0A;
	Tue,  9 Dec 2025 03:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765251973; cv=none; b=aaIkuvbX/QwHJIZ3143pltHTIihIVQhj41CT7GOzDgpKR9EOfnVCgaZnaGe2XKswgqmuf5fPdm6QnwGIz66Jc5iRlfDvCKaUDOg+8W+vbeZIDFwY8a0w1Ta/SCq9ugZAdW3D4WBnekg5icUDSV6aslQLQeXfp+Cwm80AKZNMsPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765251973; c=relaxed/simple;
	bh=Q0I5+eglbrHneyRdqxspYQFUaik0t9UNaPQovrD2kSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=umNUSSdihepfHh4Wpw+UgiqXTb5hCidS1Cw1fD3DJNDGQx/dWaoe5Fy5/pe7Y81lqkTSNNYaA85LzaGs33Tt3PcO4qER66+vlUMs97rVvlmxMJz2SRf5H6GHY0QzAZaHmZIUkHfSy4bBM3pERLmx5BayLil9OvQbC/7TVxBVmeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MuAZeLi+; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MuAZeLi+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765251971; x=1796787971;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Q0I5+eglbrHneyRdqxspYQFUaik0t9UNaPQovrD2kSA=;
  b=MuAZeLi+f/d6Oz11F/dqIgVbSpHE+puKe2Ga2ZsFY1Q78M/lml5qHzEq
   xQVSlKWGd2q4roCQCQbiGsObbuqRto5fXSYVuO0NaWFfYQqqZxbFw6Bce
   5I/mBi60mvEweRK6Ic7n4I82OnxAcQctXJqwEw/3WnbDiCYyRXpgYq/vV
   QetIAC3yKDXgu98kzlfIeIvMTJQJBhkLi5YwTUZmn2xswpl/qgrDElvnB
   r/ufaTyycMGutNRJFzTMnAfSNQLgffLxaI+FgLFhTHb/uboijjowC2GoR
   cN2lHt1I7q20r90RUXpTiNl6vLA3SYJY7nLYY8RCsCmJP+A46o3NGNdo3
   w==;
X-CSE-ConnectionGUID: vjz5w9nLQr61pUk2UCqeuQ==
X-CSE-MsgGUID: by8cS3+iRoexlDb1rX/f4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="66211024"
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="66211024"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 19:46:11 -0800
X-CSE-ConnectionGUID: yMDG5PiRRqygdlDPtlLQfA==
X-CSE-MsgGUID: w9soYkFmTACJ3ZOwPAt3sA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="219465116"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 08 Dec 2025 19:46:07 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vSoft-000000001Hh-36Cu;
	Tue, 09 Dec 2025 03:46:05 +0000
Date: Tue, 9 Dec 2025 11:45:31 +0800
From: kernel test robot <lkp@intel.com>
To: chenxiaosong.chenxiaosong@linux.dev, sfrench@samba.org,
	smfrench@gmail.com, linkinjeon@kernel.org, linkinjeon@samba.org
Cc: oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org, liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn, liuyun01@kylinos.cn,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v4 08/10] smb/client: introduce smb2maperror KUnit tests
Message-ID: <202512091143.FGQ64S2k-lkp@intel.com>
References: <20251206151826.2932970-9-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251206151826.2932970-9-chenxiaosong.chenxiaosong@linux.dev>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on brauner-vfs/vfs.all]
[also build test ERROR on linus/master v6.18]
[cannot apply to cifs/for-next next-20251208]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/chenxiaosong-chenxiaosong-linux-dev/smb-client-reduce-loop-count-in-map_smb2_to_linux_error-by-half/20251206-232731
base:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.all
patch link:    https://lore.kernel.org/r/20251206151826.2932970-9-chenxiaosong.chenxiaosong%40linux.dev
patch subject: [PATCH v4 08/10] smb/client: introduce smb2maperror KUnit tests
config: i386-randconfig-063-20251208 (https://download.01.org/0day-ci/archive/20251209/202512091143.FGQ64S2k-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251209/202512091143.FGQ64S2k-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512091143.FGQ64S2k-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: fs/smb/client/smb2maperror.o: in function `test_cmp_map':
>> fs/smb/client/smb2maperror_test.c:40:(.text+0x1d4): undefined reference to `kunit_binary_str_assert_format'
>> ld: fs/smb/client/smb2maperror_test.c:40:(.text+0x20c): undefined reference to `__kunit_do_failed_assertion'
>> ld: fs/smb/client/smb2maperror_test.c:39:(.text+0x245): undefined reference to `kunit_binary_assert_format'
   ld: fs/smb/client/smb2maperror_test.c:39:(.text+0x263): undefined reference to `__kunit_do_failed_assertion'
   ld: fs/smb/client/smb2maperror_test.c:38:(.text+0x274): undefined reference to `kunit_binary_assert_format'
   ld: fs/smb/client/smb2maperror_test.c:38:(.text+0x2ba): undefined reference to `__kunit_do_failed_assertion'
>> ld: fs/smb/client/smb2maperror_test.c:37:(.text+0x2da): undefined reference to `kunit_binary_ptr_assert_format'
   ld: fs/smb/client/smb2maperror_test.c:37:(.text+0x314): undefined reference to `__kunit_do_failed_assertion'
   ld: fs/smb/client/smb2maperror.o: in function `maperror_test_check_sort':
>> fs/smb/client/smb2maperror_test.c:28:(.text.unlikely+0x4b): undefined reference to `kunit_binary_assert_format'
>> ld: fs/smb/client/smb2maperror_test.c:28:(.text.unlikely+0x60): undefined reference to `__kunit_do_failed_assertion'


vim +40 fs/smb/client/smb2maperror_test.c

    12	
    13	static void maperror_test_check_sort(struct kunit *test)
    14	{
    15		bool is_sorted = true;
    16		unsigned int i;
    17	
    18		for (i = 1; i < err_map_num; i++) {
    19			if (smb2_error_map_table[i].smb2_status >=
    20			    smb2_error_map_table[i - 1].smb2_status)
    21				continue;
    22	
    23			pr_err("smb2_error_map_table array order is incorrect\n");
    24			is_sorted = false;
    25			break;
    26		}
    27	
  > 28		KUNIT_EXPECT_EQ(test, true, is_sorted);
    29	}
    30	
    31	static void
    32	test_cmp_map(struct kunit *test, struct status_to_posix_error *expect)
    33	{
    34		struct status_to_posix_error *result;
    35	
    36		result = smb2_get_err_map(expect->smb2_status);
  > 37		KUNIT_EXPECT_PTR_NE(test, NULL, result);
    38		KUNIT_EXPECT_EQ(test, expect->smb2_status, result->smb2_status);
  > 39		KUNIT_EXPECT_EQ(test, expect->posix_error, result->posix_error);
  > 40		KUNIT_EXPECT_STREQ(test, expect->status_string, result->status_string);
    41	}
    42	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
