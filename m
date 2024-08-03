Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2E714C5AA
	for <linux-cifs@vger.kernel.org>; Sat,  3 Aug 2024 08:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722674973; cv=none; b=sFz1h605FwNaNy6dVzxknwztSVzuBDDWgJDQnx4J9J9kf4S6njpdEmv6z4x/ueOEHnSnl+NRtQ1uDw83Qxtm1F2vm4CSYMki2jYdrE8SxZgJPIqaN8bbUWYr/LL6BDh6HcE1fSDvOCPuGnuceMM8wJXK9dKNPbuFZWUfnzczr/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722674973; c=relaxed/simple;
	bh=N+R5Ak2CFpC88W78sZ8EE3lGg+e4QoM07zHgZ67KyX0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Z6PsBg2YneC5gaZVQkHJOZvoiqb5ALiIOB7+INO/Un2cxEu+rSWQyHP4BXgaJfEk2Ix4egl0L2o3ZpieOgBntHUoy+hlu5nfDDfLlGE9wqn0XQ2MaXPGXd4gyDFXM7uwPhv1+nBjxpatOoSfcLOfqJXtL+iiI4RizDlDMI7PRUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z2C2Ns31; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z2C2Ns31"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722674972; x=1754210972;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=N+R5Ak2CFpC88W78sZ8EE3lGg+e4QoM07zHgZ67KyX0=;
  b=Z2C2Ns31/ACViRR6QJhcQ2g3ibcTajanSRKaLqaSe55etbdgZ5+tN7bz
   jMjav6aZdy6rTKstvnfeUQvpD0m7XDlxzHnxv765X3g18ihJp1tAocdmL
   /USs/7f7B5lzXK3uxRfpyLxoG7L4wVKxemikVnwCI1J2A/ZcSI6vTMjnY
   tVqF7mkmRVwCkCi6RvX1LSeiC5P4lIulZdF47Tc9ZXRp3QTaTPL7bf7J3
   aVZacL4vGBUMxRh4/+cgQQiy06nmNJ2POfr5yyGR7eK93d5zw6E4aJQPs
   CTQ1bLO1NP2Pb8s499Zv8ZykHIuXtSZIWDkooqphCcH8xnHijUu8T6QBg
   g==;
X-CSE-ConnectionGUID: zm6wdKR0QB67hcR/e76rqg==
X-CSE-MsgGUID: Fdn70i7GTxO923bdVAOJnQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11152"; a="20643866"
X-IronPort-AV: E=Sophos;i="6.09,260,1716274800"; 
   d="scan'208";a="20643866"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2024 01:49:30 -0700
X-CSE-ConnectionGUID: nM2PgOikQTqNiZgwYV7NKQ==
X-CSE-MsgGUID: i9Pp7qiMQve7LGLLYt9Qng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,260,1716274800"; 
   d="scan'208";a="60041055"
Received: from unknown (HELO b6bf6c95bbab) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 03 Aug 2024 01:49:28 -0700
Received: from kbuild by b6bf6c95bbab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1saAS0-0000Ku-0A;
	Sat, 03 Aug 2024 08:49:22 +0000
Date: Sat, 3 Aug 2024 16:48:24 +0800
From: kernel test robot <lkp@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [cifs:5.15-backport-8-1-24 346/600]
 fs/cifs/../smbfs_common/smb2pdu.h:817:17: error: expected
 specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
Message-ID: <202408031644.BXjx5MQC-lkp@intel.com>
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
config: i386-randconfig-002-20240803 (https://download.01.org/0day-ci/archive/20240803/202408031644.BXjx5MQC-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240803/202408031644.BXjx5MQC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408031644.BXjx5MQC-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from fs/cifs/dir.c:17:
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
   In file included from fs/cifs/cifsglob.h:26,
                    from fs/cifs/dir.c:18:
>> fs/cifs/../smbfs_common/smb2pdu.h:817:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     817 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/../smbfs_common/smb2pdu.h:1578:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
    1578 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^~~~~~~~~~~~~~~~~~
--
   In file included from fs/cifs/cifsglob.h:26,
                    from fs/cifs/asn1.c:6:
>> fs/cifs/../smbfs_common/smb2pdu.h:817:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     817 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/../smbfs_common/smb2pdu.h:1578:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
    1578 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^~~~~~~~~~~~~~~~~~
   In file included from fs/cifs/cifsglob.h:97:
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
--
   In file included from fs/cifs/ioctl.c:16:
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
   In file included from fs/cifs/cifsglob.h:26,
                    from fs/cifs/ioctl.c:17:
>> fs/cifs/../smbfs_common/smb2pdu.h:817:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     817 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/../smbfs_common/smb2pdu.h:1578:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
    1578 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/ioctl.c: In function 'cifs_ioctl':
   fs/cifs/ioctl.c:324:17: warning: variable 'caps' set but not used [-Wunused-but-set-variable]
     324 |         __u64   caps;
         |                 ^~~~
--
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
   In file included from fs/cifs/cifsglob.h:26,
                    from fs/cifs/readdir.c:16:
>> fs/cifs/../smbfs_common/smb2pdu.h:817:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     817 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/../smbfs_common/smb2pdu.h:1578:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
    1578 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/readdir.c: In function 'cifs_fill_dirent_unix':
   fs/cifs/readdir.c:554:25: error: 'FILE_UNIX_INFO' has no member named 'FileName'
     554 |         de->name = &info->FileName[0];
         |                         ^~
--
   In file included from fs/cifs/cifssmb.c:26:
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
   In file included from fs/cifs/cifsglob.h:26,
                    from fs/cifs/cifssmb.c:27:
>> fs/cifs/../smbfs_common/smb2pdu.h:817:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     817 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/../smbfs_common/smb2pdu.h:1578:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
    1578 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/cifssmb.c: In function 'decode_ext_sec_blob':
   fs/cifs/cifssmb.c:381:33: error: 'union <anonymous>' has no member named 'extended_response'
     381 |         char    *guid = pSMBr->u.extended_response.GUID;
         |                                 ^
   fs/cifs/cifssmb.c:405:33: error: 'union <anonymous>' has no member named 'extended_response'
     405 |                         pSMBr->u.extended_response.SecurityBlob, count, server);
         |                                 ^
   fs/cifs/cifssmb.c: In function 'CIFSSMBNegotiate':
   fs/cifs/cifssmb.c:516:55: error: 'union <anonymous>' has no member named 'EncryptionKey'
     516 |                 memcpy(ses->server->cryptkey, pSMBr->u.EncryptionKey,
         |                                                       ^


vim +/DECLARE_FLEX_ARRAY +817 fs/cifs/../smbfs_common/smb2pdu.h

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
