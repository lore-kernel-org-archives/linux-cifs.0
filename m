Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FBE282F3E;
	Wed, 29 Jul 2026 01:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785289420; cv=none; b=UklUIIuQyJ15euHKDJfEq4lapwvcxgl2PrJTJl/tv2uD4XoOmngMG27Xn6HfG4FfVbnRRpVC2DKDmdimZ08U4tvUHQVCZ61gbAGdZgwqneONALo6tQMcdJn4cnt/khHXWQSsnAe/HgfcwX/MVedlG85rkng+jezc/Pd5Pnx0H0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785289420; c=relaxed/simple;
	bh=6b+MAhHNko/hyC8q4FeN74Uwy8X7clpSHUBKI05PU48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tIXjzIhiN4iILFc7+fcPiHg3/p8Bc3uUIYvGfV9khEBkNOycwD3SABLb8SgM6GpN/lNj6Pnk9A1n8Q2K35Rx4LBVqzrZBCgimT8x0c4tbvHhxpcy7X04h23SAOWBcZL3R2Vo21qYnwmkuDiCINWD4hxZqnvsHOmUga4QmKbsCS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a3YZ4ghX; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a3YZ4ghX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785289418; x=1816825418;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6b+MAhHNko/hyC8q4FeN74Uwy8X7clpSHUBKI05PU48=;
  b=a3YZ4ghXw5RLtQ57vE4aSNL2lQ6e7dFh13mG5ic6FRjOIJh+6vUdAExi
   nGHWag6nRq2O8id13xCMal624ds0BF0xHdH69JzX/fCN+7nSv9+n1QURU
   Gi2lIlKk88WXpk6yOIPRaO/j+Me3lM+yi4tM3fUfTSJIHKdFynMkoqaHy
   9eZkNoKYDJDNsGTvw2BbF++xXeeet7ydbs93kZtJyfMxQEDTShYW9wxhw
   8y/7mmF/n9hj704AdagyGRxrTMlj4vI5pKCrFrO30sKLq9bYFNn+MQnP/
   W6irv+U6tCVPkNmhYXUT3W5wTO3drmmryqtLEetlUH7i37XcbgdEWJ2Mx
   A==;
X-CSE-ConnectionGUID: Rcp/H/7gTmu4z8HngtnoJA==
X-CSE-MsgGUID: aShC3NV0SnaEsGzGdI42NQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="86079772"
X-IronPort-AV: E=Sophos;i="6.25,191,1779174000"; 
   d="scan'208";a="86079772"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2026 18:43:37 -0700
X-CSE-ConnectionGUID: 5QtGGf0GTlm2UHq7xdj1yw==
X-CSE-MsgGUID: N8magdpaRvWMUH0EguDb/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,191,1779174000"; 
   d="scan'208";a="255561444"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 28 Jul 2026 18:43:33 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wotKU-00000000evn-3NJ4;
	Wed, 29 Jul 2026 01:43:30 +0000
Date: Wed, 29 Jul 2026 09:42:52 +0800
From: kernel test robot <lkp@intel.com>
To: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	samba-technical@lists.samba.org,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] smb: client: reject a tree connect response whose byte
 count is too small
Message-ID: <202607290953.sMPYxQPT-lkp@intel.com>
References: <20260728-b4-disp-6b8e68d4-v1-1-e69277237297@proton.me>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728-b4-disp-6b8e68d4-v1-1-e69277237297@proton.me>

Hi Bryam,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 4235cb24ec1e8e96843f3671ba4da2a6ccca2c7b]

url:    https://github.com/intel-lab-lkp/linux/commits/Bryam-Vargas-via-B4-Relay/smb-client-reject-a-tree-connect-response-whose-byte-count-is-too-small/20260729-024634
base:   4235cb24ec1e8e96843f3671ba4da2a6ccca2c7b
patch link:    https://lore.kernel.org/r/20260728-b4-disp-6b8e68d4-v1-1-e69277237297%40proton.me
patch subject: [PATCH] smb: client: reject a tree connect response whose byte count is too small
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260729/202607290953.sMPYxQPT-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260729/202607290953.sMPYxQPT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607290953.sMPYxQPT-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/smb/client/cifssmb.c:1791:19: warning: implicit conversion from 'int' to 'enum smb_eio_trace' changes value from 128 to -128 [-Wconstant-conversion]
    1791 |                         return smb_EIO(smb_eio_trace_write_too_far);
         |                                ~~~~~~~ ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/smb/client/cifssmb.c:1982:17: warning: implicit conversion from 'int' to 'enum smb_eio_trace' changes value from 128 to -128 [-Wconstant-conversion]
    1982 |                         rc = smb_EIO(smb_eio_trace_write_too_far);
         |                              ~~~~~~~ ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/smb/client/cifssmb.c:2074:19: warning: implicit conversion from 'int' to 'enum smb_eio_trace' changes value from 128 to -128 [-Wconstant-conversion]
    2074 |                         return smb_EIO(smb_eio_trace_write_too_far);
         |                                ~~~~~~~ ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   3 warnings generated.


vim +1791 fs/smb/client/cifssmb.c

^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1761  
ec637e3ffb6b97 fs/cifs/cifssmb.c       Steve French     2005-12-12  1762  
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1763  int
6d5786a34d98bf fs/cifs/cifssmb.c       Pavel Shilovsky  2012-06-20  1764  CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
dbbab32574c384 fs/cifs/cifssmb.c       Al Viro          2016-09-05  1765  	     unsigned int *nbytes, const char *buf)
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1766  {
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1767  	int rc = -EACCES;
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1768  	WRITE_REQ *pSMB = NULL;
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1769  	WRITE_RSP *pSMBr = NULL;
1c9551878c4629 fs/cifs/cifssmb.c       Steve French     2005-08-30  1770  	int bytes_returned, wct;
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1771  	__u32 bytes_sent;
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1772  	__u16 byte_count;
fa2989f4473413 fs/cifs/cifssmb.c       Pavel Shilovsky  2011-05-26  1773  	__u32 pid = io_parms->pid;
fa2989f4473413 fs/cifs/cifssmb.c       Pavel Shilovsky  2011-05-26  1774  	__u16 netfid = io_parms->netfid;
fa2989f4473413 fs/cifs/cifssmb.c       Pavel Shilovsky  2011-05-26  1775  	__u64 offset = io_parms->offset;
96daf2b09178d8 fs/cifs/cifssmb.c       Steve French     2011-05-27  1776  	struct cifs_tcon *tcon = io_parms->tcon;
83bfbd0bb9025f fs/smb/client/cifssmb.c David Howells    2025-09-05  1777  	unsigned int count = io_parms->length, in_len;
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1778  
a24e2d7d8f5123 fs/cifs/cifssmb.c       Steve French     2010-04-03  1779  	*nbytes = 0;
a24e2d7d8f5123 fs/cifs/cifssmb.c       Steve French     2010-04-03  1780  
f96637be081141 fs/cifs/cifssmb.c       Joe Perches      2013-05-04  1781  	/* cifs_dbg(FYI, "write at %lld %d bytes\n", offset, count);*/
1c9551878c4629 fs/cifs/cifssmb.c       Steve French     2005-08-30  1782  	if (tcon->ses == NULL)
1c9551878c4629 fs/cifs/cifssmb.c       Steve French     2005-08-30  1783  		return -ECONNABORTED;
1c9551878c4629 fs/cifs/cifssmb.c       Steve French     2005-08-30  1784  
1c9551878c4629 fs/cifs/cifssmb.c       Steve French     2005-08-30  1785  	if (tcon->ses->capabilities & CAP_LARGE_FILES)
1c9551878c4629 fs/cifs/cifssmb.c       Steve French     2005-08-30  1786  		wct = 14;
4c3130efda1ef4 fs/cifs/cifssmb.c       Steve French     2008-12-09  1787  	else {
1c9551878c4629 fs/cifs/cifssmb.c       Steve French     2005-08-30  1788  		wct = 12;
4c3130efda1ef4 fs/cifs/cifssmb.c       Steve French     2008-12-09  1789  		if ((offset >> 32) > 0) {
4c3130efda1ef4 fs/cifs/cifssmb.c       Steve French     2008-12-09  1790  			/* can not handle big offset for old srv */
f80ac7eda1cf52 fs/smb/client/cifssmb.c David Howells    2025-10-24 @1791  			return smb_EIO(smb_eio_trace_write_too_far);
4c3130efda1ef4 fs/cifs/cifssmb.c       Steve French     2008-12-09  1792  		}
4c3130efda1ef4 fs/cifs/cifssmb.c       Steve French     2008-12-09  1793  	}
1c9551878c4629 fs/cifs/cifssmb.c       Steve French     2005-08-30  1794  
1c9551878c4629 fs/cifs/cifssmb.c       Steve French     2005-08-30  1795  	rc = smb_init(SMB_COM_WRITE_ANDX, wct, tcon, (void **) &pSMB,
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1796  		      (void **) &pSMBr);
83bfbd0bb9025f fs/smb/client/cifssmb.c David Howells    2025-09-05  1797  	if (rc < 0)
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1798  		return rc;
83bfbd0bb9025f fs/smb/client/cifssmb.c David Howells    2025-09-05  1799  	in_len = rc;
fa2989f4473413 fs/cifs/cifssmb.c       Pavel Shilovsky  2011-05-26  1800  
fa2989f4473413 fs/cifs/cifssmb.c       Pavel Shilovsky  2011-05-26  1801  	pSMB->hdr.Pid = cpu_to_le16((__u16)pid);
fa2989f4473413 fs/cifs/cifssmb.c       Pavel Shilovsky  2011-05-26  1802  	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(pid >> 16));
fa2989f4473413 fs/cifs/cifssmb.c       Pavel Shilovsky  2011-05-26  1803  
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1804  	/* tcon and ses pointer are checked in smb_init */
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1805  	if (tcon->ses->server == NULL)
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1806  		return -ECONNABORTED;
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1807  
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1808  	pSMB->AndXCommand = 0xFF;	/* none */
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1809  	pSMB->Fid = netfid;
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1810  	pSMB->OffsetLow = cpu_to_le32(offset & 0xFFFFFFFF);
1c9551878c4629 fs/cifs/cifssmb.c       Steve French     2005-08-30  1811  	if (wct == 14)
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1812  		pSMB->OffsetHigh = cpu_to_le32(offset >> 32);
1c9551878c4629 fs/cifs/cifssmb.c       Steve French     2005-08-30  1813  
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1814  	pSMB->Reserved = 0xFFFFFFFF;
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1815  	pSMB->WriteMode = 0;
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1816  	pSMB->Remaining = 0;
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1817  
50c2f753887270 fs/cifs/cifssmb.c       Steve French     2007-07-13  1818  	/* Can increase buffer size if buffer is big enough in some cases ie we
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1819  	can send more if LARGE_WRITE_X capability returned by the server and if
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1820  	our buffer is big enough or if we convert to iovecs on socket writes
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1821  	and eliminate the copy to the CIFS buffer */
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1822  	if (tcon->ses->capabilities & CAP_LARGE_WRITE_X) {
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1823  		bytes_sent = min_t(const unsigned int, CIFSMaxBufSize, count);
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1824  	} else {
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1825  		bytes_sent = (tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE)
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1826  			 & ~0xFF;
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1827  	}
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1828  
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1829  	if (bytes_sent > count)
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1830  		bytes_sent = count;
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1831  	pSMB->DataOffset =
83bfbd0bb9025f fs/smb/client/cifssmb.c David Howells    2025-09-05  1832  		cpu_to_le16(offsetof(struct smb_com_write_req, Data));
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1833  	if (buf)
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1834  		memcpy(pSMB->Data, buf, bytes_sent);
dbbab32574c384 fs/cifs/cifssmb.c       Al Viro          2016-09-05  1835  	else if (count != 0) {
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1836  		/* No buffer */
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1837  		cifs_buf_release(pSMB);
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1838  		return -EINVAL;
e30dcf3a1905b4 fs/cifs/cifssmb.c       Steve French     2005-09-20  1839  	} /* else setting file size with write of zero bytes */
e30dcf3a1905b4 fs/cifs/cifssmb.c       Steve French     2005-09-20  1840  	if (wct == 14)
e30dcf3a1905b4 fs/cifs/cifssmb.c       Steve French     2005-09-20  1841  		byte_count = bytes_sent + 1; /* pad */
ad7a2926b9e53c fs/cifs/cifssmb.c       Steve French     2008-02-07  1842  	else /* wct == 12 */
e30dcf3a1905b4 fs/cifs/cifssmb.c       Steve French     2005-09-20  1843  		byte_count = bytes_sent + 5; /* bigger pad, smaller smb hdr */
ad7a2926b9e53c fs/cifs/cifssmb.c       Steve French     2008-02-07  1844  
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1845  	pSMB->DataLengthLow = cpu_to_le16(bytes_sent & 0xFFFF);
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1846  	pSMB->DataLengthHigh = cpu_to_le16(bytes_sent >> 16);
83bfbd0bb9025f fs/smb/client/cifssmb.c David Howells    2025-09-05  1847  	in_len += byte_count;
1c9551878c4629 fs/cifs/cifssmb.c       Steve French     2005-08-30  1848  
1c9551878c4629 fs/cifs/cifssmb.c       Steve French     2005-08-30  1849  	if (wct == 14)
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1850  		pSMB->ByteCount = cpu_to_le16(byte_count);
50c2f753887270 fs/cifs/cifssmb.c       Steve French     2007-07-13  1851  	else { /* old style write has byte count 4 bytes earlier
50c2f753887270 fs/cifs/cifssmb.c       Steve French     2007-07-13  1852  		  so 4 bytes pad  */
1c9551878c4629 fs/cifs/cifssmb.c       Steve French     2005-08-30  1853  		struct smb_com_writex_req *pSMBW =
1c9551878c4629 fs/cifs/cifssmb.c       Steve French     2005-08-30  1854  			(struct smb_com_writex_req *)pSMB;
1c9551878c4629 fs/cifs/cifssmb.c       Steve French     2005-08-30  1855  		pSMBW->ByteCount = cpu_to_le16(byte_count);
1c9551878c4629 fs/cifs/cifssmb.c       Steve French     2005-08-30  1856  	}
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1857  
83bfbd0bb9025f fs/smb/client/cifssmb.c David Howells    2025-09-05  1858  	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB, in_len,
dbbab32574c384 fs/cifs/cifssmb.c       Al Viro          2016-09-05  1859  			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
44c581866e2ae4 fs/cifs/cifssmb.c       Pavel Shilovsky  2012-05-28  1860  	cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1861  	if (rc) {
f96637be081141 fs/cifs/cifssmb.c       Joe Perches      2013-05-04  1862  		cifs_dbg(FYI, "Send error in write = %d\n", rc);
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1863  	} else {
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1864  		*nbytes = le16_to_cpu(pSMBr->CountHigh);
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1865  		*nbytes = (*nbytes) << 16;
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1866  		*nbytes += le16_to_cpu(pSMBr->Count);
6513a81e9325d7 fs/cifs/cifssmb.c       Suresh Jayaraman 2010-03-31  1867  
6513a81e9325d7 fs/cifs/cifssmb.c       Suresh Jayaraman 2010-03-31  1868  		/*
6513a81e9325d7 fs/cifs/cifssmb.c       Suresh Jayaraman 2010-03-31  1869  		 * Mask off high 16 bits when bytes written as returned by the
6513a81e9325d7 fs/cifs/cifssmb.c       Suresh Jayaraman 2010-03-31  1870  		 * server is greater than bytes requested by the client. Some
6513a81e9325d7 fs/cifs/cifssmb.c       Suresh Jayaraman 2010-03-31  1871  		 * OS/2 servers are known to set incorrect CountHigh values.
6513a81e9325d7 fs/cifs/cifssmb.c       Suresh Jayaraman 2010-03-31  1872  		 */
6513a81e9325d7 fs/cifs/cifssmb.c       Suresh Jayaraman 2010-03-31  1873  		if (*nbytes > count)
6513a81e9325d7 fs/cifs/cifssmb.c       Suresh Jayaraman 2010-03-31  1874  			*nbytes &= 0xFFFF;
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1875  	}
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1876  
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1877  	cifs_buf_release(pSMB);
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1878  
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1879  	/* Note: On -EAGAIN error only caller can retry on handle based calls
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1880  		since file handle passed in no longer valid */
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1881  
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1882  	return rc;
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1883  }
^1da177e4c3f41 fs/cifs/cifssmb.c       Linus Torvalds   2005-04-16  1884  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
