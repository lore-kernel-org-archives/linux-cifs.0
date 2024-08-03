Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F242613AD33
	for <linux-cifs@vger.kernel.org>; Sat,  3 Aug 2024 11:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722683407; cv=none; b=W4EYjZb5Yc6xzr/KpY1aZUU5kQwFqqD6mYpnGdJdlvIRQik3wew+Myd0ZZ9CzJhFefbMQxiD6yzwtI8fW/aoEeWSg1uzApCR8lg2JhlNC41JFrRudSZOK3nXbN6a6Fe/nzwq1453nlNUiPQH1GIG/P3OY9JzUMT4Eh8BKgzRsjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722683407; c=relaxed/simple;
	bh=uTxSclRvpWb0a0xfFWe82lQmj5dFsNhpZMhmmNqCOfo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fjvuAMmbb2H07Dd7P237ugTUu8LCufBhd8wvFIwlefEqJiwywedluuC9Q6XkZSM3dIfJahMSLeO3ObDmRLlyjUFQcL3dvcv9Aj13mUiQq8ouYsPt7t1UHJYmZFzLj+7zNRKoajIb7u2FwYxDL18gEEAi5SueBT3AORM3xGwRSFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AEVgENXZ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AEVgENXZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722683403; x=1754219403;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=uTxSclRvpWb0a0xfFWe82lQmj5dFsNhpZMhmmNqCOfo=;
  b=AEVgENXZK/qGgZ0FsyJqyKgbFb6mOKrqn7p1gyruYthxqDSlzBs4U/uM
   QEE6jm77A0cKwnRW9Rezj04DHDTjA2qVUv+/PG3EHnn9Kuch1AU1mGJZ9
   SQEiruaiyywl7IxaEUtKVnEi9JDbIIVW4grYxveCvFklJDsk8WHICAzXl
   BCvR/OK4E/STsKdnU/w6k6WzKusvepWdrEcgUDpUO7AXDEDuPCdncRW1t
   UAN6aBWgN3vcELEhuOGbY1CbCtVWvUmBr1YAoNvH/nENR6qaUUWweqUEc
   r4r8GccbI7ThMHXRhEnIhkjDmiXtLVR/j+5t4nhmd705byOBbdiwswCid
   g==;
X-CSE-ConnectionGUID: S96BRkDWSkGdhvCIWrjBwA==
X-CSE-MsgGUID: At6ZjzFzTDOMKEzfDKr2HQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11152"; a="24466425"
X-IronPort-AV: E=Sophos;i="6.09,260,1716274800"; 
   d="scan'208";a="24466425"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2024 04:10:01 -0700
X-CSE-ConnectionGUID: YhsRj73ITVioBgg759Jgjg==
X-CSE-MsgGUID: zjxPXZX/QfCC0f7trmUpdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,260,1716274800"; 
   d="scan'208";a="55626182"
Received: from unknown (HELO b6bf6c95bbab) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 03 Aug 2024 04:09:59 -0700
Received: from kbuild by b6bf6c95bbab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1saCe5-0000Om-1Z;
	Sat, 03 Aug 2024 11:09:57 +0000
Date: Sat, 3 Aug 2024 19:03:55 +0800
From: kernel test robot <lkp@intel.com>
To: Steve French <stfrench@microsoft.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [cifs:5.15-backport-8-1-24 546/600] fs/cifs/cifspdu.h:886:3: error:
 unexpected type name '__le64': expected identifier
Message-ID: <202408031811.SJuzffSt-lkp@intel.com>
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
commit: 26f5e6f0efbd340b409c826c0a242a9b01f78e7c [546/600] smb: client, common: fix fortify warnings
config: i386-randconfig-003-20240803 (https://download.01.org/0day-ci/archive/20240803/202408031811.SJuzffSt-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240803/202408031811.SJuzffSt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408031811.SJuzffSt-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from fs/cifs/cifsfs.c:32:
   fs/cifs/cifspdu.h:512:3: error: type name requires a specifier or qualifier
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                 ^
   fs/cifs/cifspdu.h:512:37: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                                                   ^
         |                                                   int
   fs/cifs/cifspdu.h:885:2: error: type name requires a specifier or qualifier
     885 |         struct_group(common_attributes,
         |         ^
>> fs/cifs/cifspdu.h:886:3: error: unexpected type name '__le64': expected identifier
     886 |                 __le64 CreationTime;
         |                 ^
>> fs/cifs/cifspdu.h:886:10: error: expected ')'
     886 |                 __le64 CreationTime;
         |                        ^
   fs/cifs/cifspdu.h:885:14: note: to match this '('
     885 |         struct_group(common_attributes,
         |                     ^
>> fs/cifs/cifspdu.h:885:15: error: a parameter list without types is only allowed in a function definition
     885 |         struct_group(common_attributes,
         |                      ^
   fs/cifs/cifspdu.h:891:2: error: type name requires a specifier or qualifier
     891 |         );
         |         ^
>> fs/cifs/cifspdu.h:891:2: error: expected member name or ';' after declaration specifiers
>> fs/cifs/cifspdu.h:890:25: error: expected ';' at end of declaration list
     890 |                 __le32 FileAttributes;
         |                                       ^
         |                                       ;
   fs/cifs/cifspdu.h:2269:2: error: type name requires a specifier or qualifier
    2269 |         struct_group(common_attributes,
         |         ^
   fs/cifs/cifspdu.h:2270:3: error: unexpected type name '__le64': expected identifier
    2270 |                 __le64 CreationTime;
         |                 ^
   fs/cifs/cifspdu.h:2270:10: error: expected ')'
    2270 |                 __le64 CreationTime;
         |                        ^
   fs/cifs/cifspdu.h:2269:14: note: to match this '('
    2269 |         struct_group(common_attributes,
         |                     ^
   fs/cifs/cifspdu.h:2269:15: error: a parameter list without types is only allowed in a function definition
    2269 |         struct_group(common_attributes,
         |                      ^
   fs/cifs/cifspdu.h:2275:2: error: type name requires a specifier or qualifier
    2275 |         );
         |         ^
   fs/cifs/cifspdu.h:2275:2: error: expected member name or ';' after declaration specifiers
   fs/cifs/cifspdu.h:2274:21: error: expected ';' at end of declaration list
    2274 |                 __le32 Attributes;
         |                                   ^
         |                                   ;
   fs/cifs/cifspdu.h:2293:3: error: type name requires a specifier or qualifier
    2293 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^
   fs/cifs/cifspdu.h:2293:28: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    2293 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                                          ^
         |                                          int
   fs/cifs/cifspdu.h:2332:2: error: type name requires a specifier or qualifier
    2332 |         DECLARE_FLEX_ARRAY(char, LinkDest);
         |         ^
   fatal error: too many errors emitted, stopping now [-ferror-limit=]
   20 errors generated.
--
   In file included from fs/cifs/cached_dir.c:9:
   In file included from fs/cifs/cifsglob.h:26:
   fs/cifs/../smbfs_common/smb2pdu.h:705:2: error: type name requires a specifier or qualifier
     705 |         struct_group(network_open_info,
         |         ^
>> fs/cifs/../smbfs_common/smb2pdu.h:706:3: error: unexpected type name '__le64': expected identifier
     706 |                 __le64 CreationTime;
         |                 ^
>> fs/cifs/../smbfs_common/smb2pdu.h:706:10: error: expected ')'
     706 |                 __le64 CreationTime;
         |                        ^
   fs/cifs/../smbfs_common/smb2pdu.h:705:14: note: to match this '('
     705 |         struct_group(network_open_info,
         |                     ^
>> fs/cifs/../smbfs_common/smb2pdu.h:705:15: error: a parameter list without types is only allowed in a function definition
     705 |         struct_group(network_open_info,
         |                      ^
   fs/cifs/../smbfs_common/smb2pdu.h:714:2: error: type name requires a specifier or qualifier
     714 |         );
         |         ^
>> fs/cifs/../smbfs_common/smb2pdu.h:714:2: error: expected member name or ';' after declaration specifiers
>> fs/cifs/../smbfs_common/smb2pdu.h:713:21: error: expected ';' at end of declaration list
     713 |                 __le32 Attributes;
         |                                   ^
         |                                   ;
   fs/cifs/../smbfs_common/smb2pdu.h:845:3: error: type name requires a specifier or qualifier
     845 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                 ^
   fs/cifs/../smbfs_common/smb2pdu.h:845:48: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
     845 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                                                              ^
         |                                                              int
   fs/cifs/../smbfs_common/smb2pdu.h:1685:3: error: type name requires a specifier or qualifier
    1685 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^
   fs/cifs/../smbfs_common/smb2pdu.h:1685:28: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
    1685 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                                          ^
         |                                          int
   In file included from fs/cifs/cached_dir.c:9:
   In file included from fs/cifs/cifsglob.h:27:
>> fs/cifs/smb2pdu.h:322:2: error: type name requires a specifier or qualifier
     322 |         struct_group(network_open_info,
         |         ^
>> fs/cifs/smb2pdu.h:323:3: error: unexpected type name '__le64': expected identifier
     323 |                 __le64 CreationTime;
         |                 ^
>> fs/cifs/smb2pdu.h:323:10: error: expected ')'
     323 |                 __le64 CreationTime;
         |                        ^
   fs/cifs/smb2pdu.h:322:14: note: to match this '('
     322 |         struct_group(network_open_info,
         |                     ^
>> fs/cifs/smb2pdu.h:322:15: error: a parameter list without types is only allowed in a function definition
     322 |         struct_group(network_open_info,
         |                      ^
   fs/cifs/smb2pdu.h:330:2: error: type name requires a specifier or qualifier
     330 |         );
         |         ^
>> fs/cifs/smb2pdu.h:330:2: error: expected member name or ';' after declaration specifiers
>> fs/cifs/smb2pdu.h:329:21: error: expected ';' at end of declaration list
     329 |                 __le32 Attributes;
         |                                   ^
         |                                   ;
   In file included from fs/cifs/cached_dir.c:9:
   In file included from fs/cifs/cifsglob.h:97:
   fs/cifs/cifspdu.h:512:3: error: type name requires a specifier or qualifier
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                 ^
   fatal error: too many errors emitted, stopping now [-ferror-limit=]
   20 errors generated.


vim +/__le64 +886 fs/cifs/cifspdu.h

^1da177e4c3f41 Linus Torvalds 2005-04-16  876  
^1da177e4c3f41 Linus Torvalds 2005-04-16  877  typedef struct smb_com_open_rsp {
^1da177e4c3f41 Linus Torvalds 2005-04-16  878  	struct smb_hdr hdr;	/* wct = 34 BB */
^1da177e4c3f41 Linus Torvalds 2005-04-16  879  	__u8 AndXCommand;
^1da177e4c3f41 Linus Torvalds 2005-04-16  880  	__u8 AndXReserved;
^1da177e4c3f41 Linus Torvalds 2005-04-16  881  	__le16 AndXOffset;
^1da177e4c3f41 Linus Torvalds 2005-04-16  882  	__u8 OplockLevel;
^1da177e4c3f41 Linus Torvalds 2005-04-16  883  	__u16 Fid;
^1da177e4c3f41 Linus Torvalds 2005-04-16  884  	__le32 CreateAction;
26f5e6f0efbd34 Steve French   2024-01-26 @885  	struct_group(common_attributes,
^1da177e4c3f41 Linus Torvalds 2005-04-16 @886  		__le64 CreationTime;
^1da177e4c3f41 Linus Torvalds 2005-04-16  887  		__le64 LastAccessTime;
^1da177e4c3f41 Linus Torvalds 2005-04-16  888  		__le64 LastWriteTime;
^1da177e4c3f41 Linus Torvalds 2005-04-16  889  		__le64 ChangeTime;
^1da177e4c3f41 Linus Torvalds 2005-04-16 @890  		__le32 FileAttributes;
26f5e6f0efbd34 Steve French   2024-01-26 @891  	);
^1da177e4c3f41 Linus Torvalds 2005-04-16  892  	__le64 AllocationSize;
^1da177e4c3f41 Linus Torvalds 2005-04-16  893  	__le64 EndOfFile;
^1da177e4c3f41 Linus Torvalds 2005-04-16  894  	__le16 FileType;
^1da177e4c3f41 Linus Torvalds 2005-04-16  895  	__le16 DeviceState;
^1da177e4c3f41 Linus Torvalds 2005-04-16  896  	__u8 DirectoryFlag;
^1da177e4c3f41 Linus Torvalds 2005-04-16  897  	__u16 ByteCount;	/* bct = 0 */
0753ca7bc2b876 Steve French   2005-10-27  898  } __attribute__((packed)) OPEN_RSP;
^1da177e4c3f41 Linus Torvalds 2005-04-16  899  

:::::: The code at line 886 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
