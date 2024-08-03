Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFBD1292CE
	for <linux-cifs@vger.kernel.org>; Sat,  3 Aug 2024 10:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722681801; cv=none; b=hVUbK32np6L0zR22XWSf6ef1VR+WNp4gqjiulMf33OqHQQvo6UDQfSK+ZUuVEoeiNoy5YmqEkbgKFBX7Bz30UdEALMLCKIdSpS42tYswTtI3vKJteNxNaIeQqOwT2BEAL9OqFLwlqeZEUx6FgNDCPT8rmCKLKhaxT8XXEEfDCzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722681801; c=relaxed/simple;
	bh=2VkQEPcA/U+CUxZ+CRCPYlTvVwF/ZbqrFwDy5+F7148=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=O3oYh+alUzm+O7ZjWoyEEMLBTwkteO+qV2ddhuXgl5g8ZzMgXaNOWdXS5SRYPEdABxxyn9TXr88zfUg3ZxzXBhcfRO6sXGF7mUWoDUiaGlm7Uql7ToUjonDxOA6+D6hHtgjhq98Q/h6RXeXWQETsHZrz7MSzxH//Aqpf8XXyvmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aJAVZB+O; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aJAVZB+O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722681799; x=1754217799;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=2VkQEPcA/U+CUxZ+CRCPYlTvVwF/ZbqrFwDy5+F7148=;
  b=aJAVZB+Oei0S5otD9kVhqiAsmKuAH7lBoEoy2zjNENERK/Q1ewuqYLdq
   PmqPMqVMzHkcj+xVToBa5CuT35ZDOd9u9ljBXuJDL8V7H8rD56agFtaiy
   20HiZXNS9dP/SKlHgIRteromtVF0eG13Ya9m8vHjPfQCc4DqHRCogBuoR
   CHflKkxh9EYh6Ad2OeHxghi9YtpWMKxbbgoefhcgzrIZV1Fc71rL+fmr1
   eT8lIzXt8/f3pwE3EhxrcmORWYqA16ejKWmpfUwvTo12BYzVY40/GSBLW
   o6azE7ai45WFliOF7vrOcepu0hM1uYCm5YAi9Z/6mLTdNYA+4UWqJ9Ydy
   Q==;
X-CSE-ConnectionGUID: 6CRrHFUyQdCggU6JFICvcQ==
X-CSE-MsgGUID: kr4tcBIyQrqHFoyeh4cCRw==
X-IronPort-AV: E=McAfee;i="6700,10204,11152"; a="32100621"
X-IronPort-AV: E=Sophos;i="6.09,260,1716274800"; 
   d="scan'208";a="32100621"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2024 03:43:19 -0700
X-CSE-ConnectionGUID: azA2TWdjQ1OoF8nOJyoapg==
X-CSE-MsgGUID: XB0/b+Z2S2+xiW698a06yQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,260,1716274800"; 
   d="scan'208";a="93217828"
Received: from unknown (HELO b6bf6c95bbab) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 03 Aug 2024 03:43:16 -0700
Received: from kbuild by b6bf6c95bbab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1saCED-0000Nc-1U;
	Sat, 03 Aug 2024 10:43:13 +0000
Date: Sat, 3 Aug 2024 18:42:30 +0800
From: kernel test robot <lkp@intel.com>
To: Steve French <stfrench@microsoft.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [cifs:5.15-backport-8-1-24 546/600] fs/cifs/cifspdu.h:885:9: error:
 expected specifier-qualifier-list before 'struct_group'
Message-ID: <202408031820.DixjpZTt-lkp@intel.com>
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
config: i386-randconfig-002-20240803 (https://download.01.org/0day-ci/archive/20240803/202408031820.DixjpZTt-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240803/202408031820.DixjpZTt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408031820.DixjpZTt-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from fs/cifs/file.c:26:
   fs/cifs/cifspdu.h:512:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                 ^~~~~~~~~~~~~~~~~~
>> fs/cifs/cifspdu.h:885:9: error: expected specifier-qualifier-list before 'struct_group'
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
                    from fs/cifs/file.c:27:
>> fs/cifs/../smbfs_common/smb2pdu.h:705:9: error: expected specifier-qualifier-list before 'struct_group'
     705 |         struct_group(network_open_info,
         |         ^~~~~~~~~~~~
   fs/cifs/../smbfs_common/smb2pdu.h:845:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     845 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/../smbfs_common/smb2pdu.h:1685:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
    1685 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^~~~~~~~~~~~~~~~~~
   In file included from fs/cifs/cifsglob.h:27:
>> fs/cifs/smb2pdu.h:322:9: error: expected specifier-qualifier-list before 'struct_group'
     322 |         struct_group(network_open_info,
         |         ^~~~~~~~~~~~
   fs/cifs/cifsglob.h: In function 'move_cifs_info_to_smb2':
>> fs/cifs/cifsglob.h:2161:45: error: 'FILE_ALL_INFO' has no member named 'AccessFlags'
    2161 |         memcpy(dst, src, (size_t)((u8 *)&src->AccessFlags - (u8 *)src));
         |                                             ^~
   fs/cifs/cifsglob.h:2162:31: error: 'FILE_ALL_INFO' has no member named 'AccessFlags'
    2162 |         dst->AccessFlags = src->AccessFlags;
         |                               ^~
>> fs/cifs/cifsglob.h:2163:37: error: 'FILE_ALL_INFO' has no member named 'CurrentByteOffset'
    2163 |         dst->CurrentByteOffset = src->CurrentByteOffset;
         |                                     ^~
>> fs/cifs/cifsglob.h:2164:24: error: 'FILE_ALL_INFO' has no member named 'Mode'
    2164 |         dst->Mode = src->Mode;
         |                        ^~
>> fs/cifs/cifsglob.h:2165:40: error: 'FILE_ALL_INFO' has no member named 'AlignmentRequirement'
    2165 |         dst->AlignmentRequirement = src->AlignmentRequirement;
         |                                        ^~
>> fs/cifs/cifsglob.h:2166:34: error: 'FILE_ALL_INFO' has no member named 'FileNameLength'
    2166 |         dst->FileNameLength = src->FileNameLength;
         |                                  ^~
--
   In file included from fs/cifs/cifsglob.h:26,
                    from fs/cifs/asn1.c:6:
>> fs/cifs/../smbfs_common/smb2pdu.h:705:9: error: expected specifier-qualifier-list before 'struct_group'
     705 |         struct_group(network_open_info,
         |         ^~~~~~~~~~~~
   fs/cifs/../smbfs_common/smb2pdu.h:845:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     845 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/../smbfs_common/smb2pdu.h:1685:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
    1685 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^~~~~~~~~~~~~~~~~~
   In file included from fs/cifs/cifsglob.h:27:
>> fs/cifs/smb2pdu.h:322:9: error: expected specifier-qualifier-list before 'struct_group'
     322 |         struct_group(network_open_info,
         |         ^~~~~~~~~~~~
   In file included from fs/cifs/cifsglob.h:97:
   fs/cifs/cifspdu.h:512:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                 ^~~~~~~~~~~~~~~~~~
>> fs/cifs/cifspdu.h:885:9: error: expected specifier-qualifier-list before 'struct_group'
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
   fs/cifs/cifsglob.h: In function 'move_cifs_info_to_smb2':
>> fs/cifs/cifsglob.h:2161:45: error: 'FILE_ALL_INFO' has no member named 'AccessFlags'
    2161 |         memcpy(dst, src, (size_t)((u8 *)&src->AccessFlags - (u8 *)src));
         |                                             ^~
   fs/cifs/cifsglob.h:2162:31: error: 'FILE_ALL_INFO' has no member named 'AccessFlags'
    2162 |         dst->AccessFlags = src->AccessFlags;
         |                               ^~
>> fs/cifs/cifsglob.h:2163:37: error: 'FILE_ALL_INFO' has no member named 'CurrentByteOffset'
    2163 |         dst->CurrentByteOffset = src->CurrentByteOffset;
         |                                     ^~
>> fs/cifs/cifsglob.h:2164:24: error: 'FILE_ALL_INFO' has no member named 'Mode'
    2164 |         dst->Mode = src->Mode;
         |                        ^~
>> fs/cifs/cifsglob.h:2165:40: error: 'FILE_ALL_INFO' has no member named 'AlignmentRequirement'
    2165 |         dst->AlignmentRequirement = src->AlignmentRequirement;
         |                                        ^~
>> fs/cifs/cifsglob.h:2166:34: error: 'FILE_ALL_INFO' has no member named 'FileNameLength'
    2166 |         dst->FileNameLength = src->FileNameLength;
         |                                  ^~
--
   In file included from fs/cifs/connect.c:35:
   fs/cifs/cifspdu.h:512:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                 ^~~~~~~~~~~~~~~~~~
>> fs/cifs/cifspdu.h:885:9: error: expected specifier-qualifier-list before 'struct_group'
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
                    from fs/cifs/connect.c:36:
>> fs/cifs/../smbfs_common/smb2pdu.h:705:9: error: expected specifier-qualifier-list before 'struct_group'
     705 |         struct_group(network_open_info,
         |         ^~~~~~~~~~~~
   fs/cifs/../smbfs_common/smb2pdu.h:845:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     845 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/../smbfs_common/smb2pdu.h:1685:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
    1685 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^~~~~~~~~~~~~~~~~~
   In file included from fs/cifs/cifsglob.h:27:
>> fs/cifs/smb2pdu.h:322:9: error: expected specifier-qualifier-list before 'struct_group'
     322 |         struct_group(network_open_info,
         |         ^~~~~~~~~~~~
   fs/cifs/cifsglob.h: In function 'move_cifs_info_to_smb2':
>> fs/cifs/cifsglob.h:2161:45: error: 'FILE_ALL_INFO' has no member named 'AccessFlags'
    2161 |         memcpy(dst, src, (size_t)((u8 *)&src->AccessFlags - (u8 *)src));
         |                                             ^~
   fs/cifs/cifsglob.h:2162:31: error: 'FILE_ALL_INFO' has no member named 'AccessFlags'
    2162 |         dst->AccessFlags = src->AccessFlags;
         |                               ^~
>> fs/cifs/cifsglob.h:2163:37: error: 'FILE_ALL_INFO' has no member named 'CurrentByteOffset'
    2163 |         dst->CurrentByteOffset = src->CurrentByteOffset;
         |                                     ^~
>> fs/cifs/cifsglob.h:2164:24: error: 'FILE_ALL_INFO' has no member named 'Mode'
    2164 |         dst->Mode = src->Mode;
         |                        ^~
>> fs/cifs/cifsglob.h:2165:40: error: 'FILE_ALL_INFO' has no member named 'AlignmentRequirement'
    2165 |         dst->AlignmentRequirement = src->AlignmentRequirement;
         |                                        ^~
>> fs/cifs/cifsglob.h:2166:34: error: 'FILE_ALL_INFO' has no member named 'FileNameLength'
    2166 |         dst->FileNameLength = src->FileNameLength;
         |                                  ^~
   fs/cifs/connect.c: In function 'cifs_get_smb_ses':
   fs/cifs/connect.c:2344:49: warning: passing argument 1 of 'load_nls' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
    2344 |         ses->local_nls = load_nls(ctx->local_nls->charset);
         |                                   ~~~~~~~~~~~~~~^~~~~~~~~
   In file included from fs/cifs/cifsproto.h:10,
                    from fs/cifs/connect.c:37:
   include/linux/nls.h:50:35: note: expected 'char *' but argument is of type 'const char *'
      50 | extern struct nls_table *load_nls(char *);
         |                                   ^~~~~~
--
   In file included from fs/cifs/cifsglob.h:26,
                    from fs/cifs/smb1ops.c:11:
>> fs/cifs/../smbfs_common/smb2pdu.h:705:9: error: expected specifier-qualifier-list before 'struct_group'
     705 |         struct_group(network_open_info,
         |         ^~~~~~~~~~~~
   fs/cifs/../smbfs_common/smb2pdu.h:845:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     845 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/../smbfs_common/smb2pdu.h:1685:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
    1685 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^~~~~~~~~~~~~~~~~~
   In file included from fs/cifs/cifsglob.h:27:
>> fs/cifs/smb2pdu.h:322:9: error: expected specifier-qualifier-list before 'struct_group'
     322 |         struct_group(network_open_info,
         |         ^~~~~~~~~~~~
   In file included from fs/cifs/cifsglob.h:97:
   fs/cifs/cifspdu.h:512:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                 ^~~~~~~~~~~~~~~~~~
>> fs/cifs/cifspdu.h:885:9: error: expected specifier-qualifier-list before 'struct_group'
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
   fs/cifs/cifsglob.h: In function 'move_cifs_info_to_smb2':
>> fs/cifs/cifsglob.h:2161:45: error: 'FILE_ALL_INFO' has no member named 'AccessFlags'
    2161 |         memcpy(dst, src, (size_t)((u8 *)&src->AccessFlags - (u8 *)src));
         |                                             ^~
   fs/cifs/cifsglob.h:2162:31: error: 'FILE_ALL_INFO' has no member named 'AccessFlags'
    2162 |         dst->AccessFlags = src->AccessFlags;
         |                               ^~
>> fs/cifs/cifsglob.h:2163:37: error: 'FILE_ALL_INFO' has no member named 'CurrentByteOffset'
    2163 |         dst->CurrentByteOffset = src->CurrentByteOffset;
         |                                     ^~
>> fs/cifs/cifsglob.h:2164:24: error: 'FILE_ALL_INFO' has no member named 'Mode'
    2164 |         dst->Mode = src->Mode;
         |                        ^~
>> fs/cifs/cifsglob.h:2165:40: error: 'FILE_ALL_INFO' has no member named 'AlignmentRequirement'
    2165 |         dst->AlignmentRequirement = src->AlignmentRequirement;
         |                                        ^~
>> fs/cifs/cifsglob.h:2166:34: error: 'FILE_ALL_INFO' has no member named 'FileNameLength'
    2166 |         dst->FileNameLength = src->FileNameLength;
         |                                  ^~
   In file included from include/linux/byteorder/little_endian.h:5,
                    from arch/x86/include/uapi/asm/byteorder.h:5,
                    from include/asm-generic/qrwlock_types.h:6,
                    from arch/x86/include/asm/spinlock_types.h:7,
                    from include/linux/spinlock_types_raw.h:7,
                    from include/linux/spinlock_types.h:12,
                    from include/linux/ratelimit_types.h:7,
                    from include/linux/printk.h:10,
                    from include/asm-generic/bug.h:22,
                    from arch/x86/include/asm/bug.h:84,
                    from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from include/linux/mm.h:9,
                    from include/linux/pagemap.h:8,
                    from fs/cifs/smb1ops.c:8:
   fs/cifs/smb1ops.c: In function 'cifs_query_path_info':
>> fs/cifs/smb1ops.c:579:37: error: 'FILE_ALL_INFO' has no member named 'Attributes'
     579 |                 if (!(le32_to_cpu(fi.Attributes) & ATTR_REPARSE))
         |                                     ^
   include/uapi/linux/byteorder/little_endian.h:34:51: note: in definition of macro '__le32_to_cpu'
      34 | #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
         |                                                   ^
   fs/cifs/smb1ops.c:579:23: note: in expansion of macro 'le32_to_cpu'
     579 |                 if (!(le32_to_cpu(fi.Attributes) & ATTR_REPARSE))
         |                       ^~~~~~~~~~~
--
   In file included from fs/cifs/readdir.c:15:
   fs/cifs/cifspdu.h:512:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                 ^~~~~~~~~~~~~~~~~~
>> fs/cifs/cifspdu.h:885:9: error: expected specifier-qualifier-list before 'struct_group'
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
>> fs/cifs/../smbfs_common/smb2pdu.h:705:9: error: expected specifier-qualifier-list before 'struct_group'
     705 |         struct_group(network_open_info,
         |         ^~~~~~~~~~~~
   fs/cifs/../smbfs_common/smb2pdu.h:845:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     845 |                 DECLARE_FLEX_ARRAY(struct smb2_lock_element, locks);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/../smbfs_common/smb2pdu.h:1685:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
    1685 |                 DECLARE_FLEX_ARRAY(char, FileName);
         |                 ^~~~~~~~~~~~~~~~~~
   In file included from fs/cifs/cifsglob.h:27:
>> fs/cifs/smb2pdu.h:322:9: error: expected specifier-qualifier-list before 'struct_group'
     322 |         struct_group(network_open_info,
         |         ^~~~~~~~~~~~
   fs/cifs/cifsglob.h: In function 'move_cifs_info_to_smb2':
>> fs/cifs/cifsglob.h:2161:45: error: 'FILE_ALL_INFO' has no member named 'AccessFlags'
    2161 |         memcpy(dst, src, (size_t)((u8 *)&src->AccessFlags - (u8 *)src));
         |                                             ^~
   fs/cifs/cifsglob.h:2162:31: error: 'FILE_ALL_INFO' has no member named 'AccessFlags'
    2162 |         dst->AccessFlags = src->AccessFlags;
         |                               ^~
>> fs/cifs/cifsglob.h:2163:37: error: 'FILE_ALL_INFO' has no member named 'CurrentByteOffset'
    2163 |         dst->CurrentByteOffset = src->CurrentByteOffset;
         |                                     ^~
>> fs/cifs/cifsglob.h:2164:24: error: 'FILE_ALL_INFO' has no member named 'Mode'
    2164 |         dst->Mode = src->Mode;
         |                        ^~
>> fs/cifs/cifsglob.h:2165:40: error: 'FILE_ALL_INFO' has no member named 'AlignmentRequirement'
    2165 |         dst->AlignmentRequirement = src->AlignmentRequirement;
         |                                        ^~
>> fs/cifs/cifsglob.h:2166:34: error: 'FILE_ALL_INFO' has no member named 'FileNameLength'
    2166 |         dst->FileNameLength = src->FileNameLength;
         |                                  ^~
   fs/cifs/readdir.c: In function 'cifs_fill_dirent_unix':
   fs/cifs/readdir.c:549:25: error: 'FILE_UNIX_INFO' has no member named 'FileName'
     549 |         de->name = &info->FileName[0];
         |                         ^~
..


vim +/struct_group +885 fs/cifs/cifspdu.h

   876	
   877	typedef struct smb_com_open_rsp {
   878		struct smb_hdr hdr;	/* wct = 34 BB */
   879		__u8 AndXCommand;
   880		__u8 AndXReserved;
   881		__le16 AndXOffset;
   882		__u8 OplockLevel;
   883		__u16 Fid;
   884		__le32 CreateAction;
 > 885		struct_group(common_attributes,
   886			__le64 CreationTime;
   887			__le64 LastAccessTime;
   888			__le64 LastWriteTime;
   889			__le64 ChangeTime;
   890			__le32 FileAttributes;
   891		);
   892		__le64 AllocationSize;
   893		__le64 EndOfFile;
   894		__le16 FileType;
   895		__le16 DeviceState;
   896		__u8 DirectoryFlag;
   897		__u16 ByteCount;	/* bct = 0 */
   898	} __attribute__((packed)) OPEN_RSP;
   899	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
