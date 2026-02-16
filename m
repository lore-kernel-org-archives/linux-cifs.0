Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CDB332914
	for <linux-cifs@vger.kernel.org>; Mon, 16 Feb 2026 16:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771257921; cv=none; b=rh1bXe616Bg+7VBM+hvCuHHvlgnd1NSmm4KWfgc2UJ5zNKp/hYOOh/x3yq1Z/1vfCcJsMNq4HNwqJiLXHeTSx7p0lZ2yZDh0PMwNNfw7Q6r/o7aNE3ArzNPK6KOYV9FcoaMKlok90iBf8rlJpkgL4g9JZBIuu/4GfqptMv8CXVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771257921; c=relaxed/simple;
	bh=bqHeOKM7JvvA+JD/+/f90MdkUeGx+oFO9+YA5pXFpVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xfb9P8Xz2+eiC07lnpbfKGfzvQgl46hDZLcDSl9iIVr/o72tV9yhMPdYha22HFPvOBfDw/qx9ZcyobZvDAJ9Huye83gQg+BtGOY7oYmEBcDjhzk6SixayArZfSu7vZuy00YPFzxreElBOKNlwD71QJaNTbN4SOw95DBxvjzagY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nmSdIl6B; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nmSdIl6B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771257919; x=1802793919;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bqHeOKM7JvvA+JD/+/f90MdkUeGx+oFO9+YA5pXFpVw=;
  b=nmSdIl6Bs0Dv5+8MYSxk4xeTOS+6lFuP+BmUiu23F1FgWBW2cuyLdQCR
   JrXgx55UHuvCsNgbVDPyN6vS1lC30PKPk6FaCXflfeOiRSgR0bRf3oPu6
   IWN6mXFBi7dEYIpRoyq7TsCKzU6yNFpNdzphOPo6WlkrglxfFyK+VfZxb
   yw0zJFHnbdrxE6rkOwAg0SQR0e4kcxr+wuuF7CtBnbpkCIA/x5c7aI+xE
   hNXt0Hid0jiQJl936UxwifNuI/J/D5c2j0yPwOjD0GcnP7dBkUpI7uDet
   f91a6lUIZAlyQ3vxS/SvkVJ6AwTAP6flPHwrzpe0aiyUSqtmU1Om+2xMR
   w==;
X-CSE-ConnectionGUID: aX40d+ZXRWWCsl//9KeCKA==
X-CSE-MsgGUID: /5d0a269T/W4VkuCHLU1PQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11703"; a="75959923"
X-IronPort-AV: E=Sophos;i="6.21,294,1763452800"; 
   d="scan'208";a="75959923"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2026 08:05:18 -0800
X-CSE-ConnectionGUID: 4CFoSClbQpO83Pz764U/og==
X-CSE-MsgGUID: k2B98ltUSgew6AamdOHWJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,294,1763452800"; 
   d="scan'208";a="251318403"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 16 Feb 2026 08:05:14 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vs160-00000001035-0hED;
	Mon, 16 Feb 2026 16:05:12 +0000
Date: Tue, 17 Feb 2026 00:05:09 +0800
From: kernel test robot <lkp@intel.com>
To: zhang.guodong@linux.dev, smfrench@gmail.com, linkinjeon@kernel.org,
	pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
	tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
	dhowells@redhat.com, chenxiaosong@kylinos.cn,
	chenxiaosong.chenxiaosong@linux.dev
Cc: oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH v3 1/5] smb: move smb3_fs_vol_info into common/fscc.h
Message-ID: <202602162321.pMV2aDap-lkp@intel.com>
References: <20260216082018.156695-2-zhang.guodong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216082018.156695-2-zhang.guodong@linux.dev>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on cifs/for-next]
[also build test WARNING on brauner-vfs/vfs.all linus/master v6.19 next-20260213]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/zhang-guodong-linux-dev/smb-move-smb3_fs_vol_info-into-common-fscc-h/20260216-162407
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
patch link:    https://lore.kernel.org/r/20260216082018.156695-2-zhang.guodong%40linux.dev
patch subject: [PATCH v3 1/5] smb: move smb3_fs_vol_info into common/fscc.h
config: i386-randconfig-r123-20260216 (https://download.01.org/0day-ci/archive/20260216/202602162321.pMV2aDap-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260216/202602162321.pMV2aDap-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602162321.pMV2aDap-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> fs/smb/client/smb2pdu.c:6230:41: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] vol_serial_number @@     got restricted __le32 [usertype] VolumeSerialNumber @@
   fs/smb/client/smb2pdu.c:6230:41: sparse:     expected unsigned int [usertype] vol_serial_number
   fs/smb/client/smb2pdu.c:6230:41: sparse:     got restricted __le32 [usertype] VolumeSerialNumber

vim +6230 fs/smb/client/smb2pdu.c

2d304217832ea7 fs/cifs/smb2pdu.c       Steve French    2018-06-24  6140  
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6141  int
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6142  SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
2167114c6ea6e7 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6143  	      u64 persistent_fid, u64 volatile_fid, int level)
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6144  {
40eff45b5dc7df fs/cifs/smb2pdu.c       Ronnie Sahlberg 2018-06-12  6145  	struct smb_rqst rqst;
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6146  	struct smb2_query_info_rsp *rsp = NULL;
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6147  	struct kvec iov;
da502f7df03d2d fs/cifs/smb2pdu.c       Pavel Shilovsky 2016-10-25  6148  	struct kvec rsp_iov;
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6149  	int rc = 0;
2167114c6ea6e7 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6150  	int resp_buftype, max_len, min_len;
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6151  	struct cifs_ses *ses = tcon->ses;
4f1fffa2376922 fs/smb/client/smb2pdu.c Shyam Prasad N  2024-01-21  6152  	struct TCP_Server_Info *server;
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6153  	unsigned int rsp_len, offset;
7fb8986e7449d0 fs/cifs/smb2pdu.c       Pavel Shilovsky 2016-10-31  6154  	int flags = 0;
16d480ed4990ed fs/smb/client/smb2pdu.c Shyam Prasad N  2026-01-31  6155  	int retries = 0, cur_sleep = 0;
4f1fffa2376922 fs/smb/client/smb2pdu.c Shyam Prasad N  2024-01-21  6156  
4f1fffa2376922 fs/smb/client/smb2pdu.c Shyam Prasad N  2024-01-21  6157  replay_again:
4f1fffa2376922 fs/smb/client/smb2pdu.c Shyam Prasad N  2024-01-21  6158  	/* reinitialize for possible replay */
4f1fffa2376922 fs/smb/client/smb2pdu.c Shyam Prasad N  2024-01-21  6159  	flags = 0;
4f1fffa2376922 fs/smb/client/smb2pdu.c Shyam Prasad N  2024-01-21  6160  	server = cifs_pick_channel(ses);
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6161  
2167114c6ea6e7 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6162  	if (level == FS_DEVICE_INFORMATION) {
2167114c6ea6e7 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6163  		max_len = sizeof(FILE_SYSTEM_DEVICE_INFO);
2167114c6ea6e7 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6164  		min_len = sizeof(FILE_SYSTEM_DEVICE_INFO);
2167114c6ea6e7 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6165  	} else if (level == FS_ATTRIBUTE_INFORMATION) {
c4a2a49f7df481 fs/smb/client/smb2pdu.c ChenXiaoSong    2025-11-17  6166  		max_len = sizeof(FILE_SYSTEM_ATTRIBUTE_INFO) + MAX_FS_NAME_LEN;
c4a2a49f7df481 fs/smb/client/smb2pdu.c ChenXiaoSong    2025-11-17  6167  		min_len = sizeof(FILE_SYSTEM_ATTRIBUTE_INFO);
af6a12ea8d4bb3 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6168  	} else if (level == FS_SECTOR_SIZE_INFORMATION) {
af6a12ea8d4bb3 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6169  		max_len = sizeof(struct smb3_fs_ss_info);
af6a12ea8d4bb3 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6170  		min_len = sizeof(struct smb3_fs_ss_info);
21ba3845b59c73 fs/cifs/smb2pdu.c       Steve French    2018-06-24  6171  	} else if (level == FS_VOLUME_INFORMATION) {
21ba3845b59c73 fs/cifs/smb2pdu.c       Steve French    2018-06-24  6172  		max_len = sizeof(struct smb3_fs_vol_info) + MAX_VOL_LABEL_LEN;
21ba3845b59c73 fs/cifs/smb2pdu.c       Steve French    2018-06-24  6173  		min_len = sizeof(struct smb3_fs_vol_info);
2167114c6ea6e7 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6174  	} else {
af6a12ea8d4bb3 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6175  		cifs_dbg(FYI, "Invalid qfsinfo level %d\n", level);
2167114c6ea6e7 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6176  		return -EINVAL;
2167114c6ea6e7 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6177  	}
2167114c6ea6e7 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6178  
352d96f3acc6e0 fs/cifs/smb2pdu.c       Aurelien Aptel  2020-05-31  6179  	rc = build_qfs_info_req(&iov, tcon, server,
352d96f3acc6e0 fs/cifs/smb2pdu.c       Aurelien Aptel  2020-05-31  6180  				level, max_len,
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6181  				persistent_fid, volatile_fid);
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6182  	if (rc)
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6183  		return rc;
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6184  
5a77e75fedce55 fs/cifs/smb2pdu.c       Steve French    2018-05-09  6185  	if (smb3_encryption_required(tcon))
7fb8986e7449d0 fs/cifs/smb2pdu.c       Pavel Shilovsky 2016-10-31  6186  		flags |= CIFS_TRANSFORM_REQ;
7fb8986e7449d0 fs/cifs/smb2pdu.c       Pavel Shilovsky 2016-10-31  6187  
40eff45b5dc7df fs/cifs/smb2pdu.c       Ronnie Sahlberg 2018-06-12  6188  	memset(&rqst, 0, sizeof(struct smb_rqst));
40eff45b5dc7df fs/cifs/smb2pdu.c       Ronnie Sahlberg 2018-06-12  6189  	rqst.rq_iov = &iov;
40eff45b5dc7df fs/cifs/smb2pdu.c       Ronnie Sahlberg 2018-06-12  6190  	rqst.rq_nvec = 1;
40eff45b5dc7df fs/cifs/smb2pdu.c       Ronnie Sahlberg 2018-06-12  6191  
16d480ed4990ed fs/smb/client/smb2pdu.c Shyam Prasad N  2026-01-31  6192  	if (retries) {
16d480ed4990ed fs/smb/client/smb2pdu.c Shyam Prasad N  2026-01-31  6193  		/* Back-off before retry */
16d480ed4990ed fs/smb/client/smb2pdu.c Shyam Prasad N  2026-01-31  6194  		if (cur_sleep)
16d480ed4990ed fs/smb/client/smb2pdu.c Shyam Prasad N  2026-01-31  6195  			msleep(cur_sleep);
4f1fffa2376922 fs/smb/client/smb2pdu.c Shyam Prasad N  2024-01-21  6196  		smb2_set_replay(server, &rqst);
16d480ed4990ed fs/smb/client/smb2pdu.c Shyam Prasad N  2026-01-31  6197  	}
4f1fffa2376922 fs/smb/client/smb2pdu.c Shyam Prasad N  2024-01-21  6198  
352d96f3acc6e0 fs/cifs/smb2pdu.c       Aurelien Aptel  2020-05-31  6199  	rc = cifs_send_recv(xid, ses, server,
352d96f3acc6e0 fs/cifs/smb2pdu.c       Aurelien Aptel  2020-05-31  6200  			    &rqst, &resp_buftype, flags, &rsp_iov);
33eae65c6f4977 fs/smb/client/smb2pdu.c Paulo Alcantara 2023-12-13  6201  	free_qfs_info_req(&iov);
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6202  	if (rc) {
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6203  		cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6204  		goto qfsattr_exit;
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6205  	}
da502f7df03d2d fs/cifs/smb2pdu.c       Pavel Shilovsky 2016-10-25  6206  	rsp = (struct smb2_query_info_rsp *)rsp_iov.iov_base;
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6207  
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6208  	rsp_len = le32_to_cpu(rsp->OutputBufferLength);
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6209  	offset = le16_to_cpu(rsp->OutputBufferOffset);
730928c8f4be88 fs/cifs/smb2pdu.c       Ronnie Sahlberg 2018-08-08  6210  	rc = smb2_validate_iov(offset, rsp_len, &rsp_iov, min_len);
2167114c6ea6e7 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6211  	if (rc)
2167114c6ea6e7 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6212  		goto qfsattr_exit;
2167114c6ea6e7 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6213  
2167114c6ea6e7 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6214  	if (level == FS_ATTRIBUTE_INFORMATION)
1fc6ad2f10ad6f fs/cifs/smb2pdu.c       Ronnie Sahlberg 2018-06-01  6215  		memcpy(&tcon->fsAttrInfo, offset
49f466bdbdf395 fs/cifs/smb2pdu.c       Ronnie Sahlberg 2018-06-01  6216  			+ (char *)rsp, min_t(unsigned int,
c4a2a49f7df481 fs/smb/client/smb2pdu.c ChenXiaoSong    2025-11-17  6217  			rsp_len, min_len));
2167114c6ea6e7 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6218  	else if (level == FS_DEVICE_INFORMATION)
1fc6ad2f10ad6f fs/cifs/smb2pdu.c       Ronnie Sahlberg 2018-06-01  6219  		memcpy(&tcon->fsDevInfo, offset
49f466bdbdf395 fs/cifs/smb2pdu.c       Ronnie Sahlberg 2018-06-01  6220  			+ (char *)rsp, sizeof(FILE_SYSTEM_DEVICE_INFO));
af6a12ea8d4bb3 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6221  	else if (level == FS_SECTOR_SIZE_INFORMATION) {
af6a12ea8d4bb3 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6222  		struct smb3_fs_ss_info *ss_info = (struct smb3_fs_ss_info *)
1fc6ad2f10ad6f fs/cifs/smb2pdu.c       Ronnie Sahlberg 2018-06-01  6223  			(offset + (char *)rsp);
af6a12ea8d4bb3 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6224  		tcon->ss_flags = le32_to_cpu(ss_info->Flags);
af6a12ea8d4bb3 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6225  		tcon->perf_sector_size =
af6a12ea8d4bb3 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6226  			le32_to_cpu(ss_info->PhysicalBytesPerSectorForPerf);
21ba3845b59c73 fs/cifs/smb2pdu.c       Steve French    2018-06-24  6227  	} else if (level == FS_VOLUME_INFORMATION) {
21ba3845b59c73 fs/cifs/smb2pdu.c       Steve French    2018-06-24  6228  		struct smb3_fs_vol_info *vol_info = (struct smb3_fs_vol_info *)
21ba3845b59c73 fs/cifs/smb2pdu.c       Steve French    2018-06-24  6229  			(offset + (char *)rsp);
21ba3845b59c73 fs/cifs/smb2pdu.c       Steve French    2018-06-24 @6230  		tcon->vol_serial_number = vol_info->VolumeSerialNumber;
21ba3845b59c73 fs/cifs/smb2pdu.c       Steve French    2018-06-24  6231  		tcon->vol_create_time = vol_info->VolumeCreationTime;
af6a12ea8d4bb3 fs/cifs/smb2pdu.c       Steven French   2013-10-09  6232  	}
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6233  
34f626406c09dd fs/cifs/smb2pdu.c       Steve French    2013-10-09  6234  qfsattr_exit:
da502f7df03d2d fs/cifs/smb2pdu.c       Pavel Shilovsky 2016-10-25  6235  	free_rsp_buf(resp_buftype, rsp_iov.iov_base);
4f1fffa2376922 fs/smb/client/smb2pdu.c Shyam Prasad N  2024-01-21  6236  
4f1fffa2376922 fs/smb/client/smb2pdu.c Shyam Prasad N  2024-01-21  6237  	if (is_replayable_error(rc) &&
4f1fffa2376922 fs/smb/client/smb2pdu.c Shyam Prasad N  2024-01-21  6238  	    smb2_should_replay(tcon, &retries, &cur_sleep))
4f1fffa2376922 fs/smb/client/smb2pdu.c Shyam Prasad N  2024-01-21  6239  		goto replay_again;
4f1fffa2376922 fs/smb/client/smb2pdu.c Shyam Prasad N  2024-01-21  6240  
6fc05c25ca35e6 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  6241  	return rc;
6fc05c25ca35e6 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  6242  }
f7ba7fe685bc3e fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-19  6243  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
