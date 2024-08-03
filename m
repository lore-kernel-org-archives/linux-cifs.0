Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041A27482
	for <linux-cifs@vger.kernel.org>; Sat,  3 Aug 2024 07:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722668592; cv=none; b=BI1xJH3bC1dqh/8z3qZ6d+xzPf4DlJM0ZphBj0yX8M247A8pA+GFdHoJCusTFlmC+doAtdP3NbGhtK6RYhW9vnUtRaqKNy3yfNsvmMbotOqP1d7WqLvImd8VTUYiAdc5DrxJLQPz7DBul1TyDk7Z4wNfA2kCMrh8rlFLz5aM5SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722668592; c=relaxed/simple;
	bh=hYzi8riaGnM9XUu2vO476yvoQjVYbT9Di7Gxk/LkAS8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Cjp4+uESEHjK4a6fCbE8VjrZEoatBKy8zalRyKXULS48yHYxNy1CDitCkrFnyjIuAzpy8tPGfGWsxexv9RxdoTkibfOfPIIa0v7GTfup+d930nOpsa24HK4IqLqoT8+kEh/Z0w6mdozn7eGW7Xe3KQv2VUkQ3gloKVi0sh4A1e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gZir4/Bk; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gZir4/Bk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722668591; x=1754204591;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=hYzi8riaGnM9XUu2vO476yvoQjVYbT9Di7Gxk/LkAS8=;
  b=gZir4/BkPhDBp5MmmMLRkwEnJ8M3dWT7Y6P1fgcb1KFK+7xdnzkeUVz1
   Z81jw1jO679fyoI4yVZICDy9TZ1c9d71AzBQsbeG/iJARtG3dpouRtNIu
   wTjbsvl1pcWPPSN2VrHtMOXsmr21Xx92POLq36n2xgrGNbpcBbOL3eBZI
   lS1Uu4VN49tuHoTO8pllYJAvhTPmn4ni58R2VyAWZ/t4doSb+uXAmw4ni
   HZy6RxXJVihtWS7cW9mcpn1Mz+dOtXPQnshB4lXz3pyemZuypU5x0NQLW
   GGXSerlza1xi7sPm65+Pf0Ht8CfD0GhWeDx3iELa2PzJFlgBeD3f4VBXb
   A==;
X-CSE-ConnectionGUID: 2TygNAejS5iImXnuVuDuUQ==
X-CSE-MsgGUID: +m/Wv/0MSCi1S3kppz2Tqw==
X-IronPort-AV: E=McAfee;i="6700,10204,11152"; a="20640600"
X-IronPort-AV: E=Sophos;i="6.09,260,1716274800"; 
   d="scan'208";a="20640600"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2024 00:03:10 -0700
X-CSE-ConnectionGUID: KPfVvY4fQEmCas1hcjyiIQ==
X-CSE-MsgGUID: N2qCF2XSQMiirYoq92Z5Gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,260,1716274800"; 
   d="scan'208";a="55298360"
Received: from unknown (HELO b6bf6c95bbab) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 03 Aug 2024 00:03:08 -0700
Received: from kbuild by b6bf6c95bbab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sa8n1-0000Eo-2G;
	Sat, 03 Aug 2024 07:02:58 +0000
Date: Sat, 3 Aug 2024 15:02:41 +0800
From: kernel test robot <lkp@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>
Subject: [cifs:5.15-backport-8-1-24 340/600] fs/cifs/readdir.c:554:25: error:
 'FILE_UNIX_INFO' has no member named 'FileName'
Message-ID: <202408031410.PCGwvvpJ-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Kees,

FYI, the error/warning still remains.

tree:   git://git.samba.org/sfrench/cifs-2.6.git 5.15-backport-8-1-24
head:   c931999946e12679e0adc129509a1e23a4a64b5d
commit: 57058257ea5c99c77c015cb17a3f97d8f6a4cf9f [340/600] cifs: Replace remaining 1-element arrays
config: i386-randconfig-002-20240803 (https://download.01.org/0day-ci/archive/20240803/202408031410.PCGwvvpJ-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240803/202408031410.PCGwvvpJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408031410.PCGwvvpJ-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from fs/cifs/readdir.c:15:
   fs/cifs/cifspdu.h:512:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/cifspdu.h:2289:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
    2289 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/cifspdu.h:2328:9: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
    2328 |         DECLARE_FLEX_ARRAY(char, LinkDest);
         |         ^~~~~~~~~~~~~~~~~~
   fs/cifs/cifspdu.h:2377:9: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
    2377 |         DECLARE_FLEX_ARRAY(__u8, alt_name);
         |         ^~~~~~~~~~~~~~~~~~
   fs/cifs/cifspdu.h:2488:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
    2488 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/readdir.c: In function 'cifs_fill_dirent_unix':
>> fs/cifs/readdir.c:554:25: error: 'FILE_UNIX_INFO' has no member named 'FileName'
     554 |         de->name = &info->FileName[0];
         |                         ^~


vim +554 fs/cifs/readdir.c

3d519bd1269f1f Aurelien Aptel    2020-02-08  550  
cda0ec6a86f181 Christoph Hellwig 2011-07-16  551  static void cifs_fill_dirent_unix(struct cifs_dirent *de,
cda0ec6a86f181 Christoph Hellwig 2011-07-16  552  		const FILE_UNIX_INFO *info, bool is_unicode)
cda0ec6a86f181 Christoph Hellwig 2011-07-16  553  {
cda0ec6a86f181 Christoph Hellwig 2011-07-16 @554  	de->name = &info->FileName[0];
cda0ec6a86f181 Christoph Hellwig 2011-07-16  555  	if (is_unicode)
cda0ec6a86f181 Christoph Hellwig 2011-07-16  556  		de->namelen = cifs_unicode_bytelen(de->name);
cda0ec6a86f181 Christoph Hellwig 2011-07-16  557  	else
cda0ec6a86f181 Christoph Hellwig 2011-07-16  558  		de->namelen = strnlen(de->name, PATH_MAX);
cda0ec6a86f181 Christoph Hellwig 2011-07-16  559  	de->resume_key = info->ResumeKey;
cda0ec6a86f181 Christoph Hellwig 2011-07-16  560  	de->ino = le64_to_cpu(info->basic.UniqueId);
cda0ec6a86f181 Christoph Hellwig 2011-07-16  561  }
cda0ec6a86f181 Christoph Hellwig 2011-07-16  562  

:::::: The code at line 554 was first introduced by commit
:::::: cda0ec6a86f18127d490048a46de954c03886d5e cifs: introduce cifs_dirent

:::::: TO: Christoph Hellwig <hch@infradead.org>
:::::: CC: Steve French <sfrench@us.ibm.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
