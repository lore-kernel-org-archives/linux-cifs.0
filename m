Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E9A256D
	for <linux-cifs@vger.kernel.org>; Mon, 16 Sep 2024 00:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726447309; cv=none; b=rUFs9IOHASPLQ4xKC9xVt5CdIBwCaglwOl9/Eq8SerrTjSQxeIH3AKXoq9Ds/gwCxs0EEIuxHUTUmGmuSKFckFivdLEragnJdZ7trWbM7JesyWQnhJmVWaHFMYFjm4m4Dv69da2Vve1VO3LG289hu/oxkCA7im9V82fe8r0JFNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726447309; c=relaxed/simple;
	bh=vpdjjGURmUcB3JcEVcqa2oefX11IXxymEkbmxRAUgqg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cWKsvkeEtghyZ6F9XbY8SIVSOirja4Uii18LZFxQpfwQH99lCPWu86qUlsYiAJShv6nmA3Z+8W6eT9rYPgnOg2gKcQqdgeoevlpvtnB2PHjgK/JnLFMVznDS1ht96LwczQOHxhxlSs9lisdKegsWR2Wqu5nHL2iOURI6eFm2tmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PagKTiPR; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PagKTiPR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726447307; x=1757983307;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=vpdjjGURmUcB3JcEVcqa2oefX11IXxymEkbmxRAUgqg=;
  b=PagKTiPRKgm3GZfW4MbtWGOhHRz2ZQFq7dduAJ5u4E63BD3jA1yp5F/v
   YT+NsZq6YfhTHxZvVuOeOeBCRTolaut9Eyr1zbN6fs8ZXPoHPNCm5CGlB
   8kIT5yBMC7mbCMFUf4ezWwIEEAAnd/K0ekJMBzeNdOXHbTJSTyhAIB23S
   zJjtCb2kE0Jl2KYuxxo+dkUQbewMideHUsc4PKr2Cn+E2VW6PfNGPpbZ8
   /oR6u9banyTHRpjB3KoYaxJhan4RZuwW00dYHX2ra+enXt834sRZXtIur
   LE86G3idOLChrfIQhyee04gS3dbtvBx++5TWtIUWtsttL3F3X2Ag/UEjF
   w==;
X-CSE-ConnectionGUID: 0rwY1u4yRpatEzdfsJ0n4Q==
X-CSE-MsgGUID: 5iM+P9VHT5SrpxD4HwHB+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11196"; a="13537123"
X-IronPort-AV: E=Sophos;i="6.10,232,1719903600"; 
   d="scan'208";a="13537123"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2024 17:41:46 -0700
X-CSE-ConnectionGUID: 5ueF3FvkTFq+jG6u1ZKKZw==
X-CSE-MsgGUID: H6X7peciTS2Op9zWNBJxKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,232,1719903600"; 
   d="scan'208";a="92002935"
Received: from lkp-server01.sh.intel.com (HELO 53e96f405c61) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 15 Sep 2024 17:41:45 -0700
Received: from kbuild by 53e96f405c61 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1spzoE-0009A5-2d;
	Mon, 16 Sep 2024 00:41:42 +0000
Date: Mon, 16 Sep 2024 08:40:58 +0800
From: kernel test robot <lkp@intel.com>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>
Subject: [cifs:for-next 12/25] fs/smb/client/transport.c:437:24: error:
 implicit declaration of function 'smb_compress'; did you mean
 'cra_compress'?
Message-ID: <202409160825.dssj4HmQ-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   2716e3ac61b56a9da0072911d96144578c39e750
commit: f046d71e84e1e94cf23335129a27f5cfe3e8b75f [12/25] smb: client: insert compression check/call on write requests
config: x86_64-rhel-8.3-bpf (https://download.01.org/0day-ci/archive/20240916/202409160825.dssj4HmQ-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240916/202409160825.dssj4HmQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409160825.dssj4HmQ-lkp@intel.com/

Note: the cifs/for-next HEAD 2716e3ac61b56a9da0072911d96144578c39e750 builds fine.
      It only hurts bisectability.

All errors (new ones prefixed by >>):

   fs/smb/client/transport.c: In function 'smb_send_rqst':
>> fs/smb/client/transport.c:437:24: error: implicit declaration of function 'smb_compress'; did you mean 'cra_compress'? [-Werror=implicit-function-declaration]
     437 |                 return smb_compress(server, &rqst[0], __smb_send_rqst);
         |                        ^~~~~~~~~~~~
         |                        cra_compress
   cc1: some warnings being treated as errors
--
   fs/smb/client/smb2pdu.c: In function 'smb2_async_writev':
>> fs/smb/client/smb2pdu.c:5025:69: error: implicit declaration of function 'should_compress' [-Werror=implicit-function-declaration]
    5025 |         if (((flags & CIFS_TRANSFORM_REQ) != CIFS_TRANSFORM_REQ) && should_compress(tcon, &rqst))
         |                                                                     ^~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +437 fs/smb/client/transport.c

   426	
   427	static int
   428	smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
   429		      struct smb_rqst *rqst, int flags)
   430	{
   431		struct send_req_vars *vars;
   432		struct smb_rqst *cur_rqst;
   433		struct kvec *iov;
   434		int rc;
   435	
   436		if (flags & CIFS_COMPRESS_REQ)
 > 437			return smb_compress(server, &rqst[0], __smb_send_rqst);
   438	
   439		if (!(flags & CIFS_TRANSFORM_REQ))
   440			return __smb_send_rqst(server, num_rqst, rqst);
   441	
   442		if (WARN_ON_ONCE(num_rqst > MAX_COMPOUND - 1))
   443			return -EIO;
   444	
   445		if (!server->ops->init_transform_rq) {
   446			cifs_server_dbg(VFS, "Encryption requested but transform callback is missing\n");
   447			return -EIO;
   448		}
   449	
   450		vars = kzalloc(sizeof(*vars), GFP_NOFS);
   451		if (!vars)
   452			return -ENOMEM;
   453		cur_rqst = vars->rqst;
   454		iov = &vars->iov;
   455	
   456		iov->iov_base = &vars->tr_hdr;
   457		iov->iov_len = sizeof(vars->tr_hdr);
   458		cur_rqst[0].rq_iov = iov;
   459		cur_rqst[0].rq_nvec = 1;
   460	
   461		rc = server->ops->init_transform_rq(server, num_rqst + 1,
   462						    &cur_rqst[0], rqst);
   463		if (rc)
   464			goto out;
   465	
   466		rc = __smb_send_rqst(server, num_rqst + 1, &cur_rqst[0]);
   467		smb3_free_compound_rqst(num_rqst, &cur_rqst[1]);
   468	out:
   469		kfree(vars);
   470		return rc;
   471	}
   472	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
