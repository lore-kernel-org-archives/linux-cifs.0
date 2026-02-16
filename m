Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07EE2C11FE
	for <linux-cifs@vger.kernel.org>; Mon, 16 Feb 2026 18:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771266208; cv=none; b=QcE2IpV0G/zxGil5/QwvrnMfDqUQg4k2tUE43awh1CO7+G2hKeZ4znXIvX2uqtGXH3hiPyTI2c1DDldXWK5o+eLS6u5WxBO+2pYOACcOFNIYNSBsgML7iJwSR6VtaEvyvgOt5aieFAcGyjrc0TesReqoYQXKOORcKLuAiTLU9ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771266208; c=relaxed/simple;
	bh=LhjLd0WhZQky2XlqN+UaMNporXoWjkKHqiKAAlXwrh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H03VZ+XCEojO9kJBuUOf8mfXSaAReZSJZh+u6DR68MbSaOHZZPoLkx4IR//sU7h+DU9Y8KYSIyWPQAh1TU2d1m1l/gAF9KGguvpq/tZbYXiX+GUbBxKqH1gEj5b1aur4FJtMExfDdPYwTEtMPYacTzQkNW/kF0aQgVH7Qx4IrK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XYiox29d; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XYiox29d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771266207; x=1802802207;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LhjLd0WhZQky2XlqN+UaMNporXoWjkKHqiKAAlXwrh0=;
  b=XYiox29dPOI3HnrYmDlmfOPlOLU1zrDR2ZAWSqYuN2Mp1lpXpTOM6wCq
   Sq5Jlux5R24VbMf1sVQ+ilbZFXGcKLaKNZdPolRdi8vooa0FR8FYIuzMG
   aN75ANfXawZnGj1BSxO2mxeZ6N84fax1+KnxfsEOFVHOPZAprovJR4UDl
   Z7ZQsljoRMiJBWVSQC73IamGlI0Z5cR27mfbXQB9Yv1SF4Scp0nRgylpp
   ie+C9APHI8ZfYXyp6AvLHjYylT4U56UBe6ziL1c1s6vRq96h14MA4QghZ
   x0dubX4LbKcGKO6lXlQDP6E7Bm6VR3H+znxp70Vnkctq+Gn0dtMTiOnh0
   w==;
X-CSE-ConnectionGUID: GKG9S95+TKG0d434xKestA==
X-CSE-MsgGUID: c/SflEp+QL2s9RqGsMyBvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11703"; a="72256121"
X-IronPort-AV: E=Sophos;i="6.21,294,1763452800"; 
   d="scan'208";a="72256121"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2026 10:23:26 -0800
X-CSE-ConnectionGUID: /TyR+pFyQYSxM6U5cG3S5Q==
X-CSE-MsgGUID: ofQnyYwPTKeQZfJEZ//lXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,294,1763452800"; 
   d="scan'208";a="218661230"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 16 Feb 2026 10:23:22 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vs3Fg-000000010A8-1IiX;
	Mon, 16 Feb 2026 18:23:20 +0000
Date: Tue, 17 Feb 2026 02:22:42 +0800
From: kernel test robot <lkp@intel.com>
To: zhang.guodong@linux.dev, smfrench@gmail.com, linkinjeon@kernel.org,
	pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
	tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
	dhowells@redhat.com, chenxiaosong@kylinos.cn,
	chenxiaosong.chenxiaosong@linux.dev
Cc: oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>
Subject: Re: [PATCH v3 4/5] smb: introduce struct create_posix_ctxt_rsp
Message-ID: <202602170244.C33LgPOh-lkp@intel.com>
References: <20260216082018.156695-5-zhang.guodong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216082018.156695-5-zhang.guodong@linux.dev>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on cifs/for-next]
[also build test WARNING on brauner-vfs/vfs.all linus/master next-20260216]
[cannot apply to v6.19]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/zhang-guodong-linux-dev/smb-move-smb3_fs_vol_info-into-common-fscc-h/20260216-162407
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
patch link:    https://lore.kernel.org/r/20260216082018.156695-5-zhang.guodong%40linux.dev
patch subject: [PATCH v3 4/5] smb: introduce struct create_posix_ctxt_rsp
config: i386-randconfig-r123-20260216 (https://download.01.org/0day-ci/archive/20260217/202602170244.C33LgPOh-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260217/202602170244.C33LgPOh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602170244.C33LgPOh-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> fs/smb/client/smb2pdu.c:2365:31: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [usertype] nlink @@     got unsigned int [usertype] @@
   fs/smb/client/smb2pdu.c:2365:31: sparse:     expected restricted __le32 [usertype] nlink
   fs/smb/client/smb2pdu.c:2365:31: sparse:     got unsigned int [usertype]
>> fs/smb/client/smb2pdu.c:2366:37: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [usertype] reparse_tag @@     got unsigned int [usertype] @@
   fs/smb/client/smb2pdu.c:2366:37: sparse:     expected restricted __le32 [usertype] reparse_tag
   fs/smb/client/smb2pdu.c:2366:37: sparse:     got unsigned int [usertype]
>> fs/smb/client/smb2pdu.c:2367:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [usertype] mode @@     got unsigned int [usertype] @@
   fs/smb/client/smb2pdu.c:2367:30: sparse:     expected restricted __le32 [usertype] mode
   fs/smb/client/smb2pdu.c:2367:30: sparse:     got unsigned int [usertype]
   fs/smb/client/smb2pdu.c:6231:41: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] vol_serial_number @@     got restricted __le32 [usertype] VolumeSerialNumber @@
   fs/smb/client/smb2pdu.c:6231:41: sparse:     expected unsigned int [usertype] vol_serial_number
   fs/smb/client/smb2pdu.c:6231:41: sparse:     got restricted __le32 [usertype] VolumeSerialNumber

vim +2365 fs/smb/client/smb2pdu.c

  2353	
  2354	static void
  2355	parse_posix_ctxt(struct create_context *cc, struct smb2_file_all_info *info,
  2356			 struct create_posix_rsp *posix)
  2357	{
  2358		int sid_len;
  2359		u8 *beg = (u8 *)cc + le16_to_cpu(cc->DataOffset);
  2360		u8 *end = beg + le32_to_cpu(cc->DataLength);
  2361		u8 *sid;
  2362	
  2363		memset(posix, 0, sizeof(*posix));
  2364	
> 2365		posix->ctxt_rsp.nlink = le32_to_cpu(*(__le32 *)(beg + 0));
> 2366		posix->ctxt_rsp.reparse_tag = le32_to_cpu(*(__le32 *)(beg + 4));
> 2367		posix->ctxt_rsp.mode = le32_to_cpu(*(__le32 *)(beg + 8));
  2368	
  2369		sid = beg + 12;
  2370		sid_len = posix_info_sid_size(sid, end);
  2371		if (sid_len < 0) {
  2372			cifs_dbg(VFS, "bad owner sid in posix create response\n");
  2373			return;
  2374		}
  2375		memcpy(&posix->owner, sid, sid_len);
  2376	
  2377		sid = sid + sid_len;
  2378		sid_len = posix_info_sid_size(sid, end);
  2379		if (sid_len < 0) {
  2380			cifs_dbg(VFS, "bad group sid in posix create response\n");
  2381			return;
  2382		}
  2383		memcpy(&posix->group, sid, sid_len);
  2384	
  2385		cifs_dbg(FYI, "nlink=%d mode=%o reparse_tag=%x\n",
  2386			 posix->ctxt_rsp.nlink, posix->ctxt_rsp.mode,
  2387			 posix->ctxt_rsp.reparse_tag);
  2388	}
  2389	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
