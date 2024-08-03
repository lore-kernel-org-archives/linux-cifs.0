Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D50136E09
	for <linux-cifs@vger.kernel.org>; Sat,  3 Aug 2024 13:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722693244; cv=none; b=QJt8ffcNmhGV/0OcUTc2tHNUUYTYC3G9tMfxJEzEJKYpH9XHBNXZmi8rcBzjTzxqRrPca3ox7ONK8pfcHpTfqrTUBWmsDDgrDSQIM+2Ptlj3iJC33p4Lnsv057ljckztF+0Y2x/NSPbKGQy1cFitiVHouxbWajgZjb15/182UT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722693244; c=relaxed/simple;
	bh=3du39j/J1e+/JJKFwhAKzAbBTW0THJJs6mQxY+AibJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ON8H2JUGNfUckUVkL/+kGlwyufbkstwcScRNnQiI5ZAo/f/prWD/jLDR3hRNW9P0pRml1AlULWSsx2z4nhdkdFqn+T8q/7Q8D3vkKKcLHSTQd8Q9jTqN8JaHuMz9OpBumU8bwU9CqDpAAW5teqWfsaBi5dEPkvE+Gxr2QY8iGOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jXrqbspj; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jXrqbspj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722693242; x=1754229242;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=3du39j/J1e+/JJKFwhAKzAbBTW0THJJs6mQxY+AibJQ=;
  b=jXrqbspjR4nBoeD4hFPrrYrYyQSmMsL/RFuOSGtzLAjsMcqXwWp3YflG
   VMDn4xVxZmjP6zfZLXTPSLewQbZuvJl1NP41Rzj/EXS6huZ7r9kF/uhca
   rvHLGG2ErKp6BMN9aG5iaAf/OKvJFM79sjC5IOE2nnTjiIXvgsJkuFRRN
   pC70VLArLQqgW/fw0HYNT4QyAuX9p6NAbiIcXHZ/4mGwUM4bc4++diqq1
   3bSqX14GbDTLCfQ+WD5B0S8IrW0c/f8YSDxI1T5YCn16HQNsggLUVmdSt
   1QXaXWW+6yqpq7MBftcW1uz90NsGDy5iwcRhWIrYGJ0AUkhvHwnoytPZz
   w==;
X-CSE-ConnectionGUID: 5kTQA0pYQA6TNsOQ87HsWQ==
X-CSE-MsgGUID: zwIReV5ZQwGFJFTi/6TjUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11153"; a="20838505"
X-IronPort-AV: E=Sophos;i="6.09,260,1716274800"; 
   d="scan'208";a="20838505"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2024 06:54:02 -0700
X-CSE-ConnectionGUID: V+dnqm8uS9mFA8abtNTq1w==
X-CSE-MsgGUID: nHfDbQKETkGZRRx8vpke7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,260,1716274800"; 
   d="scan'208";a="60720450"
Received: from unknown (HELO b6bf6c95bbab) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 03 Aug 2024 06:54:00 -0700
Received: from kbuild by b6bf6c95bbab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1saFCj-0000Us-38;
	Sat, 03 Aug 2024 13:53:55 +0000
Date: Sat, 3 Aug 2024 21:52:54 +0800
From: kernel test robot <lkp@intel.com>
To: Steve French <stfrench@microsoft.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>
Subject: [cifs:5.15-backport-8-1-24 579/600] fs/cifs/readdir.c:68:35: error:
 implicit declaration of function 'inode_get_ctime'; did you mean
 'inode_get_bytes'?
Message-ID: <202408032149.nYY75Z7B-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://git.samba.org/sfrench/cifs-2.6.git 5.15-backport-8-1-24
head:   c931999946e12679e0adc129509a1e23a4a64b5d
commit: dcb1e6f4a287802e0f9e1db6a81ea280481b2d4b [579/600] smb: client: stop revalidating reparse points unnecessarily
config: i386-randconfig-002-20240803 (https://download.01.org/0day-ci/archive/20240803/202408032149.nYY75Z7B-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240803/202408032149.nYY75Z7B-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408032149.nYY75Z7B-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from fs/cifs/readdir.c:15:
   fs/cifs/cifspdu.h:512:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/cifspdu.h:885:9: error: expected specifier-qualifier-list before 'struct_group'
     885 |         struct_group(common_attributes,
         |         ^~~~~~~~~~~~
   fs/cifs/cifspdu.h:2269:9: error: expected specifier-qualifier-list before 'struct_group'
    2269 |         struct_group(common_attributes,
         |         ^~~~~~~~~~~~
   fs/cifs/cifspdu.h:2332:9: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
    2332 |         DECLARE_FLEX_ARRAY(char, LinkDest);
         |         ^~~~~~~~~~~~~~~~~~
   fs/cifs/cifspdu.h:2381:9: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
    2381 |         DECLARE_FLEX_ARRAY(__u8, alt_name);
         |         ^~~~~~~~~~~~~~~~~~
   fs/cifs/cifspdu.h:2492:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
    2492 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^~~~~~~~~~~~~~~~~~
   In file included from fs/cifs/cifsglob.h:26,
                    from fs/cifs/readdir.c:16:
   fs/cifs/../smbfs_common/smb2pdu.h:705:9: error: expected specifier-qualifier-list before 'struct_group'
     705 |         struct_group(network_open_info,
         |         ^~~~~~~~~~~~
   fs/cifs/../smbfs_common/smb2pdu.h:845:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     845 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/../smbfs_common/smb2pdu.h:1686:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
    1686 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^~~~~~~~~~~~~~~~~~
   In file included from fs/cifs/cifsglob.h:27:
   fs/cifs/smb2pdu.h:322:9: error: expected specifier-qualifier-list before 'struct_group'
     322 |         struct_group(network_open_info,
         |         ^~~~~~~~~~~~
   fs/cifs/cifsglob.h: In function 'move_cifs_info_to_smb2':
   fs/cifs/cifsglob.h:2182:45: error: 'FILE_ALL_INFO' has no member named 'AccessFlags'
    2182 |         memcpy(dst, src, (size_t)((u8 *)&src->AccessFlags - (u8 *)src));
         |                                             ^~
   fs/cifs/cifsglob.h:2183:31: error: 'FILE_ALL_INFO' has no member named 'AccessFlags'
    2183 |         dst->AccessFlags = src->AccessFlags;
         |                               ^~
   fs/cifs/cifsglob.h:2184:37: error: 'FILE_ALL_INFO' has no member named 'CurrentByteOffset'
    2184 |         dst->CurrentByteOffset = src->CurrentByteOffset;
         |                                     ^~
   fs/cifs/cifsglob.h:2185:24: error: 'FILE_ALL_INFO' has no member named 'Mode'
    2185 |         dst->Mode = src->Mode;
         |                        ^~
   fs/cifs/cifsglob.h:2186:40: error: 'FILE_ALL_INFO' has no member named 'AlignmentRequirement'
    2186 |         dst->AlignmentRequirement = src->AlignmentRequirement;
         |                                        ^~
   fs/cifs/cifsglob.h:2187:34: error: 'FILE_ALL_INFO' has no member named 'FileNameLength'
    2187 |         dst->FileNameLength = src->FileNameLength;
         |                                  ^~
   fs/cifs/readdir.c: In function 'reparse_inode_match':
>> fs/cifs/readdir.c:68:35: error: implicit declaration of function 'inode_get_ctime'; did you mean 'inode_get_bytes'? [-Werror=implicit-function-declaration]
      68 |         struct timespec64 ctime = inode_get_ctime(inode);
         |                                   ^~~~~~~~~~~~~~~
         |                                   inode_get_bytes
>> fs/cifs/readdir.c:68:35: error: invalid initializer
   fs/cifs/readdir.c: In function 'cifs_fill_dirent_unix':
   fs/cifs/readdir.c:522:25: error: 'FILE_UNIX_INFO' has no member named 'FileName'
     522 |         de->name = &info->FileName[0];
         |                         ^~
   cc1: some warnings being treated as errors


vim +68 fs/cifs/readdir.c

    57	
    58	/*
    59	 * Match a reparse point inode if reparse tag and ctime haven't changed.
    60	 *
    61	 * Windows Server updates ctime of reparse points when their data have changed.
    62	 * The server doesn't allow changing reparse tags from existing reparse points,
    63	 * though it's worth checking.
    64	 */
    65	static inline bool reparse_inode_match(struct inode *inode,
    66					       struct cifs_fattr *fattr)
    67	{
  > 68		struct timespec64 ctime = inode_get_ctime(inode);
    69	
    70		return (CIFS_I(inode)->cifsAttrs & ATTR_REPARSE) &&
    71			CIFS_I(inode)->reparse_tag == fattr->cf_cifstag &&
    72			timespec64_equal(&ctime, &fattr->cf_ctime);
    73	}
    74	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
