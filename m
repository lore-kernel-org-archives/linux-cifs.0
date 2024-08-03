Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B641E51D
	for <linux-cifs@vger.kernel.org>; Sat,  3 Aug 2024 05:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722662182; cv=none; b=jG7gh1IXVWy+Uqx3D//YqGW+Il8aMdlariPAJkNh6J5aGJwvfXsrDwGoxlBUvTiZNnsmI8j1neGoK/HOK3pZyTQ/a6UxQFwqXpyfc8t6nVG3YcIWduia9fgSLFEgFkFwWgDeSbde+JgtRe+5jtSzpv+RR+7GGBc2VsBG7oYLzys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722662182; c=relaxed/simple;
	bh=gtXf5MljnWlUDdrAGpUZhmR7LLEZvldj9ThqMK9GRb4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QSSxk3V7Y2U32StREcCCUlEF9JbnRHQF/Geh+3djJGLnsfrGpVbYPrXFNiMrkJc82vCaOagqeCEb4E0FgXnG/Lb+EJTddFS8St/Cz/+EiczYyZYF3BOPIbvZMjFbmru2qgeLXk4+iUZX4jmJfziNsKwbYiBDGFNrA7qra1voeww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UzY7BaEQ; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UzY7BaEQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722662181; x=1754198181;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=gtXf5MljnWlUDdrAGpUZhmR7LLEZvldj9ThqMK9GRb4=;
  b=UzY7BaEQWMLfS/fRFzrZgrLj1Py1KZVKpBzzqa+PT6qEJ2jQqw8zS1VN
   DJt6gmKDTZ3EPjZsxjoibMKnJrymCzOf+g0MyFsJexI539zvJ4/+RueOW
   WzzYnq96jwhWTHwTiQPIKQYsJLm5JFK7MkAf25qHIBwv2NSiiL+SqpZMH
   wIQ2mtVBTeQGfgKoLCu44fk1+zdrQyvfzkqjyOG+7YkRYfLPiAU1nYm5W
   AdH7Spra2GjurGGtrh88DpksM6rx1Q5upDjrEB2YTyGx8ewTBS4B5D72M
   r8Sd5cP1yLrmVSN+65hBdGKImpICvdSNvrxuSesmh//ih6sLwApcOu8jL
   A==;
X-CSE-ConnectionGUID: 9F1QFtmTRTem1m7eCP/a2A==
X-CSE-MsgGUID: tc3rtoDDRp+HN/aww3t/Fw==
X-IronPort-AV: E=McAfee;i="6700,10204,11152"; a="20852854"
X-IronPort-AV: E=Sophos;i="6.09,259,1716274800"; 
   d="scan'208";a="20852854"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2024 22:16:20 -0700
X-CSE-ConnectionGUID: SjHjkmnfQMyey+1j1t6xxw==
X-CSE-MsgGUID: WEku4IIpTdiNskuN1fka6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,259,1716274800"; 
   d="scan'208";a="55308840"
Received: from unknown (HELO b6bf6c95bbab) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 02 Aug 2024 22:16:19 -0700
Received: from kbuild by b6bf6c95bbab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sa77f-00006W-2I;
	Sat, 03 Aug 2024 05:16:11 +0000
Date: Sat, 3 Aug 2024 13:15:48 +0800
From: kernel test robot <lkp@intel.com>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>,
	Kees Cook <keescook@chromium.org>,
	Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [cifs:5.15-backport-8-1-24 226/600] fs/cifs/cifspdu.h:512:17: error:
 expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
Message-ID: <202408031336.QdFIpntb-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Gustavo,

FYI, the error/warning still remains.

tree:   git://git.samba.org/sfrench/cifs-2.6.git 5.15-backport-8-1-24
head:   c931999946e12679e0adc129509a1e23a4a64b5d
commit: cb470770db4ecdaf46a6c4b1703889ba2d6a4b19 [226/600] cifs: Replace a couple of one-element arrays with flexible-array members
config: i386-randconfig-002-20240803 (https://download.01.org/0day-ci/archive/20240803/202408031336.QdFIpntb-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240803/202408031336.QdFIpntb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408031336.QdFIpntb-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from fs/cifs/dir.c:17:
>> fs/cifs/cifspdu.h:512:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                 ^~~~~~~~~~~~~~~~~~
--
   In file included from fs/cifs/cifsglob.h:100,
                    from fs/cifs/cached_dir.c:8:
>> fs/cifs/cifspdu.h:512:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/cached_dir.c:415:6: warning: no previous prototype for 'free_cached_dir' [-Wmissing-prototypes]
     415 | void free_cached_dir(struct cached_fid *cfid)
         |      ^~~~~~~~~~~~~~~
--
   In file included from fs/cifs/ioctl.c:16:
>> fs/cifs/cifspdu.h:512:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/ioctl.c: In function 'cifs_ioctl':
   fs/cifs/ioctl.c:324:17: warning: variable 'caps' set but not used [-Wunused-but-set-variable]
     324 |         __u64   caps;
         |                 ^~~~
--
   In file included from fs/cifs/cifssmb.c:26:
>> fs/cifs/cifspdu.h:512:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
     512 |                 DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
         |                 ^~~~~~~~~~~~~~~~~~
   fs/cifs/cifssmb.c: In function 'decode_ext_sec_blob':
>> fs/cifs/cifssmb.c:381:33: error: 'union <anonymous>' has no member named 'extended_response'
     381 |         char    *guid = pSMBr->u.extended_response.GUID;
         |                                 ^
   fs/cifs/cifssmb.c:405:33: error: 'union <anonymous>' has no member named 'extended_response'
     405 |                         pSMBr->u.extended_response.SecurityBlob, count, server);
         |                                 ^
   fs/cifs/cifssmb.c: In function 'CIFSSMBNegotiate':
>> fs/cifs/cifssmb.c:516:55: error: 'union <anonymous>' has no member named 'EncryptionKey'
     516 |                 memcpy(ses->server->cryptkey, pSMBr->u.EncryptionKey,
         |                                                       ^


vim +/DECLARE_FLEX_ARRAY +512 fs/cifs/cifspdu.h

   490	
   491	#define READ_RAW_ENABLE 1
   492	#define WRITE_RAW_ENABLE 2
   493	#define RAW_ENABLE (READ_RAW_ENABLE | WRITE_RAW_ENABLE)
   494	#define SMB1_CLIENT_GUID_SIZE (16)
   495	typedef struct negotiate_rsp {
   496		struct smb_hdr hdr;	/* wct = 17 */
   497		__le16 DialectIndex; /* 0xFFFF = no dialect acceptable */
   498		__u8 SecurityMode;
   499		__le16 MaxMpxCount;
   500		__le16 MaxNumberVcs;
   501		__le32 MaxBufferSize;
   502		__le32 MaxRawSize;
   503		__le32 SessionKey;
   504		__le32 Capabilities;	/* see below */
   505		__le32 SystemTimeLow;
   506		__le32 SystemTimeHigh;
   507		__le16 ServerTimeZone;
   508		__u8 EncryptionKeyLength;
   509		__u16 ByteCount;
   510		union {
   511			/* cap extended security off */
 > 512			DECLARE_FLEX_ARRAY(unsigned char, EncryptionKey);
   513			/* followed by Domain name - if extended security is off */
   514			/* followed by 16 bytes of server GUID */
   515			/* then security blob if cap_extended_security negotiated */
   516			struct {
   517				unsigned char GUID[SMB1_CLIENT_GUID_SIZE];
   518				unsigned char SecurityBlob[];
   519			} __attribute__((packed)) extended_response;
   520		} __attribute__((packed)) u;
   521	} __attribute__((packed)) NEGOTIATE_RSP;
   522	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
