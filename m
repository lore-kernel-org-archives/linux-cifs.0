Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38B213D503
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jul 2024 21:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721770316; cv=none; b=Buoy/qaGkLkJELMJU5h/nyex/rPqp+HG1159AD/AM1+F5T5qpcNCEwlnClnLltfAHvANO0yGIBSYqcjvrxyg/ycPFgG2IMdaEWPaaBo3FJO6NwlNAWWSW6g4dNbuEQsS0RWY2NjwOcJIyYCMq++L0xLyvD6QDk2hWFE6/cuZMjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721770316; c=relaxed/simple;
	bh=1u7oyjvLqoXnpGnM2m1Ehn3fmSRIIBJftp2xw3xMKtI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cXsEyfnLORrocZr92K2D3eV0HswBNAOQqL13J2OEmUqq6ozdGhGIHfM6CFnzkxeJO6UjEEr0MCWybHtpsz2Czk67oaJS6XAgrsa9v9uAo1wQvFwhZ+nUI/SS9RkvubvU4azDh28bSFwxSLDsWYrhDuDRKYHfPAvTt5l/SRMxdDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jiRzXMuK; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jiRzXMuK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721770315; x=1753306315;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=1u7oyjvLqoXnpGnM2m1Ehn3fmSRIIBJftp2xw3xMKtI=;
  b=jiRzXMuKxPUcRvuczoc5Dm+7dyZQ1r7nVqLCXR6Ourq4u3AKJjMIJgXg
   Tx5vE5SLpNZk+opE5IhYtHe8mIAW5f9RjwJZPQSaF6E3r+/E3HSZ0FOJw
   ukZXZCGC7K100NtWLfPgAGiq3K/eJ7qRSU6CeOSP2JqkjkdhDw+7gAEj1
   6xs5Ig84pOyIuyS5hftv3Kt5Bj/mzs8LnkGHJyvDWYVjdhSP6OfY+GJXr
   n67zEdXUQebncmtgM/sXVXFpXIQuNdO8qMbVHBQPE+CnzAx4FSUk3Mds8
   VxmQNYf5LycddYk2LEMhuUKKWVECNansjtzviww/FU9pWLv5GKy0xCUiS
   w==;
X-CSE-ConnectionGUID: WoHhSc6UR5m9qo2vOo5cvw==
X-CSE-MsgGUID: bDwMDEyQRva+ttHGFzSb2A==
X-IronPort-AV: E=McAfee;i="6700,10204,11142"; a="19034984"
X-IronPort-AV: E=Sophos;i="6.09,231,1716274800"; 
   d="scan'208";a="19034984"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2024 14:31:54 -0700
X-CSE-ConnectionGUID: 1cERApckT7K2c3FB77+a5Q==
X-CSE-MsgGUID: nL7iex5iRiqRf9eXhcVRUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,231,1716274800"; 
   d="scan'208";a="57191758"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 23 Jul 2024 14:31:53 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sWN6s-000mN2-1T;
	Tue, 23 Jul 2024 21:31:50 +0000
Date: Wed, 24 Jul 2024 05:31:31 +0800
From: kernel test robot <lkp@intel.com>
To: Steve French <stfrench@microsoft.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [cifs:for-next 2/3] fs/smb/client/connect.c:3822:undefined reference
 to `reset_cifs_unix_caps'
Message-ID: <202407240524.z6cV5wBx-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   dde12e91303b6d38322ed69801ce3129aba82ad5
commit: 2a9b3eb1b0838cc99aafdc50e37138538d4593bb [2/3] cifs: fix reconnect with SMB1 UNIX Extensions
config: x86_64-randconfig-072-20240723 (https://download.01.org/0day-ci/archive/20240724/202407240524.z6cV5wBx-lkp@intel.com/config)
compiler: gcc-13 (Ubuntu 13.2.0-4ubuntu3) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240724/202407240524.z6cV5wBx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202407240524.z6cV5wBx-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: vmlinux.o: in function `CIFSTCon':
>> fs/smb/client/connect.c:3822:(.text+0xb9aa7e): undefined reference to `reset_cifs_unix_caps'


vim +3822 fs/smb/client/connect.c

  3688	
  3689	/*
  3690	 * Issue a TREE_CONNECT request.
  3691	 */
  3692	int
  3693	CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
  3694		 const char *tree, struct cifs_tcon *tcon,
  3695		 const struct nls_table *nls_codepage)
  3696	{
  3697		struct smb_hdr *smb_buffer;
  3698		struct smb_hdr *smb_buffer_response;
  3699		TCONX_REQ *pSMB;
  3700		TCONX_RSP *pSMBr;
  3701		unsigned char *bcc_ptr;
  3702		int rc = 0;
  3703		int length;
  3704		__u16 bytes_left, count;
  3705	
  3706		if (ses == NULL)
  3707			return -EIO;
  3708	
  3709		smb_buffer = cifs_buf_get();
  3710		if (smb_buffer == NULL)
  3711			return -ENOMEM;
  3712	
  3713		smb_buffer_response = smb_buffer;
  3714	
  3715		header_assemble(smb_buffer, SMB_COM_TREE_CONNECT_ANDX,
  3716				NULL /*no tid */, 4 /*wct */);
  3717	
  3718		smb_buffer->Mid = get_next_mid(ses->server);
  3719		smb_buffer->Uid = ses->Suid;
  3720		pSMB = (TCONX_REQ *) smb_buffer;
  3721		pSMBr = (TCONX_RSP *) smb_buffer_response;
  3722	
  3723		pSMB->AndXCommand = 0xFF;
  3724		pSMB->Flags = cpu_to_le16(TCON_EXTENDED_SECINFO);
  3725		bcc_ptr = &pSMB->Password[0];
  3726	
  3727		pSMB->PasswordLength = cpu_to_le16(1);	/* minimum */
  3728		*bcc_ptr = 0; /* password is null byte */
  3729		bcc_ptr++;              /* skip password */
  3730		/* already aligned so no need to do it below */
  3731	
  3732		if (ses->server->sign)
  3733			smb_buffer->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
  3734	
  3735		if (ses->capabilities & CAP_STATUS32)
  3736			smb_buffer->Flags2 |= SMBFLG2_ERR_STATUS;
  3737	
  3738		if (ses->capabilities & CAP_DFS)
  3739			smb_buffer->Flags2 |= SMBFLG2_DFS;
  3740	
  3741		if (ses->capabilities & CAP_UNICODE) {
  3742			smb_buffer->Flags2 |= SMBFLG2_UNICODE;
  3743			length =
  3744			    cifs_strtoUTF16((__le16 *) bcc_ptr, tree,
  3745				6 /* max utf8 char length in bytes */ *
  3746				(/* server len*/ + 256 /* share len */), nls_codepage);
  3747			bcc_ptr += 2 * length;	/* convert num 16 bit words to bytes */
  3748			bcc_ptr += 2;	/* skip trailing null */
  3749		} else {		/* ASCII */
  3750			strcpy(bcc_ptr, tree);
  3751			bcc_ptr += strlen(tree) + 1;
  3752		}
  3753		strcpy(bcc_ptr, "?????");
  3754		bcc_ptr += strlen("?????");
  3755		bcc_ptr += 1;
  3756		count = bcc_ptr - &pSMB->Password[0];
  3757		be32_add_cpu(&pSMB->hdr.smb_buf_length, count);
  3758		pSMB->ByteCount = cpu_to_le16(count);
  3759	
  3760		rc = SendReceive(xid, ses, smb_buffer, smb_buffer_response, &length,
  3761				 0);
  3762	
  3763		/* above now done in SendReceive */
  3764		if (rc == 0) {
  3765			bool is_unicode;
  3766	
  3767			tcon->tid = smb_buffer_response->Tid;
  3768			bcc_ptr = pByteArea(smb_buffer_response);
  3769			bytes_left = get_bcc(smb_buffer_response);
  3770			length = strnlen(bcc_ptr, bytes_left - 2);
  3771			if (smb_buffer->Flags2 & SMBFLG2_UNICODE)
  3772				is_unicode = true;
  3773			else
  3774				is_unicode = false;
  3775	
  3776	
  3777			/* skip service field (NB: this field is always ASCII) */
  3778			if (length == 3) {
  3779				if ((bcc_ptr[0] == 'I') && (bcc_ptr[1] == 'P') &&
  3780				    (bcc_ptr[2] == 'C')) {
  3781					cifs_dbg(FYI, "IPC connection\n");
  3782					tcon->ipc = true;
  3783					tcon->pipe = true;
  3784				}
  3785			} else if (length == 2) {
  3786				if ((bcc_ptr[0] == 'A') && (bcc_ptr[1] == ':')) {
  3787					/* the most common case */
  3788					cifs_dbg(FYI, "disk share connection\n");
  3789				}
  3790			}
  3791			bcc_ptr += length + 1;
  3792			bytes_left -= (length + 1);
  3793			strscpy(tcon->tree_name, tree, sizeof(tcon->tree_name));
  3794	
  3795			/* mostly informational -- no need to fail on error here */
  3796			kfree(tcon->nativeFileSystem);
  3797			tcon->nativeFileSystem = cifs_strndup_from_utf16(bcc_ptr,
  3798							      bytes_left, is_unicode,
  3799							      nls_codepage);
  3800	
  3801			cifs_dbg(FYI, "nativeFileSystem=%s\n", tcon->nativeFileSystem);
  3802	
  3803			if ((smb_buffer_response->WordCount == 3) ||
  3804				 (smb_buffer_response->WordCount == 7))
  3805				/* field is in same location */
  3806				tcon->Flags = le16_to_cpu(pSMBr->OptionalSupport);
  3807			else
  3808				tcon->Flags = 0;
  3809			cifs_dbg(FYI, "Tcon flags: 0x%x\n", tcon->Flags);
  3810	
  3811			/*
  3812			 * reset_cifs_unix_caps calls QFSInfo which requires
  3813			 * need_reconnect to be false, but we would not need to call
  3814			 * reset_caps if this were not a reconnect case so must check
  3815			 * need_reconnect flag here.  The caller will also clear
  3816			 * need_reconnect when tcon was successful but needed to be
  3817			 * cleared earlier in the case of unix extensions reconnect
  3818			 */
  3819			if (tcon->need_reconnect && tcon->unix_ext) {
  3820				cifs_dbg(FYI, "resetting caps for %s\n", tcon->tree_name);
  3821				tcon->need_reconnect = false;
> 3822				reset_cifs_unix_caps(xid, tcon, NULL, NULL);
  3823			}
  3824		}
  3825		cifs_buf_release(smb_buffer);
  3826		return rc;
  3827	}
  3828	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
