Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7FE26ACC
	for <linux-cifs@vger.kernel.org>; Sun, 28 Dec 2025 15:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766934502; cv=none; b=VkhK42KBsYIJFBS1xuKh9lRF8EEvHUG3VhcQAD1YVEqT9JMtzI+HW0CNqq8pnPRjVkpvKOeM5C5cCEbVb1mbHpdMjW6AzYJmgfs+Im1PBCGoKXPZHloJtwunZK0xkCS2sr3KsH1oJpfvFwTANUJRk/ae9O4FTh0F4r2oOPGq3fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766934502; c=relaxed/simple;
	bh=UccsLxp34lxy44D1EHXH3w5GJ2VQk9dZrIFqiClY1VI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sDi4GHUBF6gqg3Rb2i7PPoH7vuhETj3AqrTnRT403gx37K8xrwsvJvLioP48f8o8rewZDBtJ2A4Ihaz9xL3iurrE38c5uSKLIQaKMvC3cPHLui+XYAfepNfufMgCuW3pnNEN5hkVDyN5Dt9NU44HP+Wee5VLhB+2Etrz/STQbhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nlH8ZcsR; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nlH8ZcsR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766934500; x=1798470500;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UccsLxp34lxy44D1EHXH3w5GJ2VQk9dZrIFqiClY1VI=;
  b=nlH8ZcsRB1MugpT7VGGqi6DuxObM117BOJ8zAjFoadErmUENIGQUJg3T
   W1kNBNITJ3gicdkWu9cA72Ui5B6OUzno6JKK35+2topnOn2strL1rcZlr
   ITK33GGBRemmhqB0GRjL+d6EqWlteZOVSKndusa5FwIOvAxrX7KeRrOhW
   cnKJHVe0w0WAZGG7Hcr+50wY6nftHv5voD8E/9I5XZ92+O+dbJB1EN+7k
   wg/6W4LRrR55+/L5TCVcbUtE8DeR1KVdSdifm21bqQHFKxkBaBmw06m7t
   D1bpwyDJPgXL5UX4iL5urZ7MuJpZinGWKoZXk3nYZMwUUfmJAQX8CaYUE
   g==;
X-CSE-ConnectionGUID: GFuj5hOETZirh76pP8JoZg==
X-CSE-MsgGUID: DsPw5turS12XF6OrKCtlig==
X-IronPort-AV: E=McAfee;i="6800,10657,11655"; a="79943290"
X-IronPort-AV: E=Sophos;i="6.21,183,1763452800"; 
   d="scan'208";a="79943290"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2025 07:08:20 -0800
X-CSE-ConnectionGUID: +LI/1qTlSpexDDhEoNlX4Q==
X-CSE-MsgGUID: orEvOTVFTMOPIqLpvZwvog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,183,1763452800"; 
   d="scan'208";a="205774325"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 28 Dec 2025 07:08:16 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vZsNP-000000006X3-2ykq;
	Sun, 28 Dec 2025 15:08:12 +0000
Date: Sun, 28 Dec 2025 23:07:41 +0800
From: kernel test robot <lkp@intel.com>
To: chenxiaosong.chenxiaosong@linux.dev, smfrench@gmail.com,
	linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
	senozhatsky@chromium.org, dhowells@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v6 5/5] smb/client: introduce KUnit test to check search
 result of smb2_error_map_table
Message-ID: <202512282232.rXoA9DcV-lkp@intel.com>
References: <20251225021035.656639-6-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251225021035.656639-6-chenxiaosong.chenxiaosong@linux.dev>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on cifs/for-next]
[also build test ERROR on brauner-vfs/vfs.all linus/master v6.19-rc2 next-20251219]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/chenxiaosong-chenxiaosong-linux-dev/cifs-Label-SMB2-statuses-with-errors/20251225-101505
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
patch link:    https://lore.kernel.org/r/20251225021035.656639-6-chenxiaosong.chenxiaosong%40linux.dev
patch subject: [PATCH v6 5/5] smb/client: introduce KUnit test to check search result of smb2_error_map_table
config: x86_64-buildonly-randconfig-001-20251228 (https://download.01.org/0day-ci/archive/20251228/202512282232.rXoA9DcV-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251228/202512282232.rXoA9DcV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512282232.rXoA9DcV-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: fs/smb/client/smb2maperror.o: in function `test_cmp_map':
>> smb2maperror.c:(.text+0xd1): undefined reference to `kunit_binary_ptr_assert_format'
>> ld: smb2maperror.c:(.text+0xe9): undefined reference to `__kunit_do_failed_assertion'
>> ld: smb2maperror.c:(.text+0x135): undefined reference to `kunit_binary_assert_format'
   ld: smb2maperror.c:(.text+0x14d): undefined reference to `__kunit_do_failed_assertion'
   ld: smb2maperror.c:(.text+0x18b): undefined reference to `kunit_binary_assert_format'
   ld: smb2maperror.c:(.text+0x1ac): undefined reference to `__kunit_do_failed_assertion'
>> ld: smb2maperror.c:(.text+0x1ea): undefined reference to `kunit_binary_str_assert_format'
   ld: smb2maperror.c:(.text+0x20b): undefined reference to `__kunit_do_failed_assertion'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
