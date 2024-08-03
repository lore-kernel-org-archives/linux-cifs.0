Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CBE13DDB5
	for <linux-cifs@vger.kernel.org>; Sat,  3 Aug 2024 08:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722675584; cv=none; b=eF2+/QyFAxlfd5aQziW/R6UZdITV/z4x6SQGDLFfDYGzn3KMCuAZR7wQPd0iv54c0QZV9xt31hz0mpAkoKM4SMRDtpArp4u104dUWtXHY1Z9882pujQ2AnOVS4/OKU0UvpdvcZFI6FHisJA7jJbNvykfLPk/0D6kE+7i0fW6asE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722675584; c=relaxed/simple;
	bh=hTax/C+mnEO33rmLlsoBMezVMPUhAjSCLNfWoqfkddw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=n3X5XUIhE8roWUYjUf7I5NJsCKRLi4jA/eRxbp/RQx+B6dX8PpFT99KweGV3RhTAUhNiLQE2MSZqHfLuXLNblKOWs0sZallBVjOI/6qVuFrZYjZvUAUcSgzgfcpHKKWAKK4saeXHjOAxVSx01ITA3LlyzOTAOSKFxHnVh5JT0c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I26tOcFk; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I26tOcFk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722675583; x=1754211583;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=hTax/C+mnEO33rmLlsoBMezVMPUhAjSCLNfWoqfkddw=;
  b=I26tOcFkvpHlXou1hSTSOUKgYPc2HOTABPdgB4jLM+EbxaqDpryPORL4
   NrqOWlCXW48ztYCb2Kk4hXn249wZrXREKu1XpoN2wyieEkI79gWQMh9Na
   I5hzaWjo0yllCbb5JuLRaFvqdofjMF/yOaXUOK9JgSq6yMFS63SqYaRRx
   nfrGqY/7mIKt0SLNAbCe1cH0eHtAICtF+S7t/0St6JjzC5L4gPfjUo3Za
   DNcPGZ7xRPzmyffCynW51Ar0zoCJ9M8Xbd5KPPFMtug26LRmwT3aWdWBF
   4SrGovxoKHaVEHrWLy5mqXGqHBpc8g1EleOEZMCUUQNKF8sb/7xb89RN0
   Q==;
X-CSE-ConnectionGUID: Yn54rd5OSa2UJGX+o3Sa0g==
X-CSE-MsgGUID: 2HBC09WiRFCIIUpWG2ko+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11152"; a="32098501"
X-IronPort-AV: E=Sophos;i="6.09,260,1716274800"; 
   d="scan'208";a="32098501"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2024 01:59:42 -0700
X-CSE-ConnectionGUID: 4fw5ZGtWSRKYZkTNtP9XVQ==
X-CSE-MsgGUID: vYUXfYZ/QCiLzeAPBJ9USg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,260,1716274800"; 
   d="scan'208";a="60670641"
Received: from unknown (HELO b6bf6c95bbab) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 03 Aug 2024 01:59:40 -0700
Received: from kbuild by b6bf6c95bbab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1saAbx-0000LC-2p;
	Sat, 03 Aug 2024 08:59:37 +0000
Date: Sat, 3 Aug 2024 16:58:55 +0800
From: kernel test robot <lkp@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [cifs:5.15-backport-8-1-24 346/600]
 fs/cifs/../smbfs_common/smb2pdu.h:817:3: error: type name requires a
 specifier or qualifier
Message-ID: <202408031613.q4FlMl2U-lkp@intel.com>
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
commit: cd3ad386810097de48e69cdd3c483ca1bf65c7c6 [346/600] smb3: Replace smb2pdu 1-element arrays with flex-arrays
config: i386-randconfig-003-20240803 (https://download.01.org/0day-ci/archive/20240803/202408031613.q4FlMl2U-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240803/202408031613.q4FlMl2U-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408031613.q4FlMl2U-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from fs/cifs/smb2ops.c:18:
   In file included from fs/cifs/cifsglob.h:26:
>> fs/cifs/../smbfs_common/smb2pdu.h:817:3: error: type name requires a specifier or qualifier
     817 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                 ^
>> fs/cifs/../smbfs_common/smb2pdu.h:817:48: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
     817 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                                                              ^
         |                                                              int
   fs/cifs/../smbfs_common/smb2pdu.h:1578:3: error: type name requires a specifier or qualifier
    1578 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^
   fs/cifs/../smbfs_common/smb2pdu.h:1578:28: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    1578 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                                          ^
         |                                          int
   In file included from fs/cifs/smb2ops.c:18:
   In file included from fs/cifs/cifsglob.h:97:
   fs/cifs/cifspdu.h:512:3: error: type name requires a specifier or qualifier
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                 ^
   fs/cifs/cifspdu.h:512:37: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                                                   ^
         |                                                   int
   fs/cifs/cifspdu.h:2289:3: error: type name requires a specifier or qualifier
    2289 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^
   fs/cifs/cifspdu.h:2289:28: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    2289 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                                          ^
         |                                          int
   fs/cifs/cifspdu.h:2328:2: error: type name requires a specifier or qualifier
    2328 |         DECLARE_FLEX_ARRAY(char, LinkDest);
         |         ^
   fs/cifs/cifspdu.h:2328:27: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    2328 |         DECLARE_FLEX_ARRAY(char, LinkDest);
         |                                  ^
         |                                  int
   fs/cifs/cifspdu.h:2377:2: error: type name requires a specifier or qualifier
    2377 |         DECLARE_FLEX_ARRAY(__u8, alt_name);
         |         ^
   fs/cifs/cifspdu.h:2377:27: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    2377 |         DECLARE_FLEX_ARRAY(__u8, alt_name);
         |                                  ^
         |                                  int
   fs/cifs/cifspdu.h:2488:3: error: type name requires a specifier or qualifier
    2488 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^
   fs/cifs/cifspdu.h:2488:28: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    2488 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                                          ^
         |                                          int
   14 errors generated.
--
   In file included from fs/cifs/smb2file.c:15:
   fs/cifs/cifspdu.h:512:3: error: type name requires a specifier or qualifier
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                 ^
   fs/cifs/cifspdu.h:512:37: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                                                   ^
         |                                                   int
   fs/cifs/cifspdu.h:2289:3: error: type name requires a specifier or qualifier
    2289 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^
   fs/cifs/cifspdu.h:2289:28: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    2289 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                                          ^
         |                                          int
   fs/cifs/cifspdu.h:2328:2: error: type name requires a specifier or qualifier
    2328 |         DECLARE_FLEX_ARRAY(char, LinkDest);
         |         ^
   fs/cifs/cifspdu.h:2328:27: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    2328 |         DECLARE_FLEX_ARRAY(char, LinkDest);
         |                                  ^
         |                                  int
   fs/cifs/cifspdu.h:2377:2: error: type name requires a specifier or qualifier
    2377 |         DECLARE_FLEX_ARRAY(__u8, alt_name);
         |         ^
   fs/cifs/cifspdu.h:2377:27: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    2377 |         DECLARE_FLEX_ARRAY(__u8, alt_name);
         |                                  ^
         |                                  int
   fs/cifs/cifspdu.h:2488:3: error: type name requires a specifier or qualifier
    2488 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^
   fs/cifs/cifspdu.h:2488:28: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    2488 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                                          ^
         |                                          int
   In file included from fs/cifs/smb2file.c:16:
   In file included from fs/cifs/cifsglob.h:26:
>> fs/cifs/../smbfs_common/smb2pdu.h:817:3: error: type name requires a specifier or qualifier
     817 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                 ^
>> fs/cifs/../smbfs_common/smb2pdu.h:817:48: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
     817 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                                                              ^
         |                                                              int
   fs/cifs/../smbfs_common/smb2pdu.h:1578:3: error: type name requires a specifier or qualifier
    1578 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^
   fs/cifs/../smbfs_common/smb2pdu.h:1578:28: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    1578 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                                          ^
         |                                          int
   14 errors generated.
--
   In file included from fs/cifs/ioctl.c:16:
   fs/cifs/cifspdu.h:512:3: error: type name requires a specifier or qualifier
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                 ^
   fs/cifs/cifspdu.h:512:37: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                                                   ^
         |                                                   int
   fs/cifs/cifspdu.h:2289:3: error: type name requires a specifier or qualifier
    2289 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^
   fs/cifs/cifspdu.h:2289:28: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    2289 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                                          ^
         |                                          int
   fs/cifs/cifspdu.h:2328:2: error: type name requires a specifier or qualifier
    2328 |         DECLARE_FLEX_ARRAY(char, LinkDest);
         |         ^
   fs/cifs/cifspdu.h:2328:27: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    2328 |         DECLARE_FLEX_ARRAY(char, LinkDest);
         |                                  ^
         |                                  int
   fs/cifs/cifspdu.h:2377:2: error: type name requires a specifier or qualifier
    2377 |         DECLARE_FLEX_ARRAY(__u8, alt_name);
         |         ^
   fs/cifs/cifspdu.h:2377:27: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    2377 |         DECLARE_FLEX_ARRAY(__u8, alt_name);
         |                                  ^
         |                                  int
   fs/cifs/cifspdu.h:2488:3: error: type name requires a specifier or qualifier
    2488 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^
   fs/cifs/cifspdu.h:2488:28: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    2488 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                                          ^
         |                                          int
   In file included from fs/cifs/ioctl.c:17:
   In file included from fs/cifs/cifsglob.h:26:
>> fs/cifs/../smbfs_common/smb2pdu.h:817:3: error: type name requires a specifier or qualifier
     817 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                 ^
>> fs/cifs/../smbfs_common/smb2pdu.h:817:48: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
     817 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                                                              ^
         |                                                              int
   fs/cifs/../smbfs_common/smb2pdu.h:1578:3: error: type name requires a specifier or qualifier
    1578 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^
   fs/cifs/../smbfs_common/smb2pdu.h:1578:28: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    1578 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                                          ^
         |                                          int
   fs/cifs/ioctl.c:324:10: warning: variable 'caps' set but not used [-Wunused-but-set-variable]
     324 |         __u64   caps;
         |                 ^
   1 warning and 14 errors generated.
--
   In file included from fs/cifs/readdir.c:15:
   fs/cifs/cifspdu.h:512:3: error: type name requires a specifier or qualifier
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                 ^
   fs/cifs/cifspdu.h:512:37: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                                                   ^
         |                                                   int
   fs/cifs/cifspdu.h:2289:3: error: type name requires a specifier or qualifier
    2289 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^
   fs/cifs/cifspdu.h:2289:28: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    2289 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                                          ^
         |                                          int
   fs/cifs/cifspdu.h:2328:2: error: type name requires a specifier or qualifier
    2328 |         DECLARE_FLEX_ARRAY(char, LinkDest);
         |         ^
   fs/cifs/cifspdu.h:2328:27: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    2328 |         DECLARE_FLEX_ARRAY(char, LinkDest);
         |                                  ^
         |                                  int
   fs/cifs/cifspdu.h:2377:2: error: type name requires a specifier or qualifier
    2377 |         DECLARE_FLEX_ARRAY(__u8, alt_name);
         |         ^
   fs/cifs/cifspdu.h:2377:27: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    2377 |         DECLARE_FLEX_ARRAY(__u8, alt_name);
         |                                  ^
         |                                  int
   fs/cifs/cifspdu.h:2488:3: error: type name requires a specifier or qualifier
    2488 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^
   fs/cifs/cifspdu.h:2488:28: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    2488 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                                          ^
         |                                          int
   In file included from fs/cifs/readdir.c:16:
   In file included from fs/cifs/cifsglob.h:26:
>> fs/cifs/../smbfs_common/smb2pdu.h:817:3: error: type name requires a specifier or qualifier
     817 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                 ^
>> fs/cifs/../smbfs_common/smb2pdu.h:817:48: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
     817 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                                                              ^
         |                                                              int
   fs/cifs/../smbfs_common/smb2pdu.h:1578:3: error: type name requires a specifier or qualifier
    1578 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^
   fs/cifs/../smbfs_common/smb2pdu.h:1578:28: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    1578 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                                          ^
         |                                          int
   fs/cifs/readdir.c:554:20: error: no member named 'FileName' in 'FILE_UNIX_INFO'
     554 |         de->name = &info->FileName[0];
         |                     ~~~~  ^
   15 errors generated.


vim +817 fs/cifs/../smbfs_common/smb2pdu.h

   802	
   803	struct smb2_lock_req {
   804		struct smb2_hdr hdr;
   805		__le16 StructureSize; /* Must be 48 */
   806		__le16 LockCount;
   807		/*
   808		 * The least significant four bits are the index, the other 28 bits are
   809		 * the lock sequence number (0 to 64). See MS-SMB2 2.2.26
   810		 */
   811		__le32 LockSequenceNumber;
   812		__u64  PersistentFileId;
   813		__u64  VolatileFileId;
   814		/* Followed by at least one */
   815		union {
   816			struct smb2_lock_element lock;
 > 817			DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
   818		};
   819	} __packed;
   820	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
