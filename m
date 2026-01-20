Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5152F38B7B4
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 11:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768908789; cv=none; b=d/lHv9lfkV9PzQGyBZS2fBkuK6vbtssibfHoT/eL7K6SQdrQNZZzfj+5UtcC9JxJ2TOGi3RSBxbbpSmzJEMYJSjOaaz5ZVfx1PbY6I1lBMkevnSgGncZ47mvNiO/fAGmGA/OKcfILqXd+B2iCIpf+l6bmSFLZ6j06SaNmm3gyw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768908789; c=relaxed/simple;
	bh=1t0flhMkQ7ouMrlgzADG2WhwfzbbPSEV0i5TZKSzfVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eMlOBykfwCrpqbiyvUHg7CD58x1ILdJRz6lDoH1BO3n5+NWZc6ttP6DfzMYz6pD9MfoLYxdIM2+q8bS898Qhe3bZEXXxjIen9WfzN7JLUexfzrSOfhYQ9Jp42XCtW1pjli70DWwwmn/0tMf3G8DPA23CmvZZITcN1Ywe6aRPtZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EoGrKcrk; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EoGrKcrk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768908787; x=1800444787;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1t0flhMkQ7ouMrlgzADG2WhwfzbbPSEV0i5TZKSzfVk=;
  b=EoGrKcrkIv97vGv2GjF7iwoW64suL2DPgGxnoctOKEfB1mJr2RNpq98k
   wEV24H58yn0pPx9NRW+Z/7DvUTdTJHj248qHzn7gkswrHbsqQFsH1s1se
   zglZzPGQJ2VqvAumVB35ffc51OC8rAzOT4Dm0cnRefRIrGxwBt/OJt4zy
   dl/076FS26bLzhCg5j2Ak0ofJCQS6MslPdabYdQbUTSjvE3VammAN6HSt
   rnl6aVvF6GhmO6L2O/99O20eOaAnAySftnrHxUMWZTvgziAvy6kwsXHiy
   BE1PIIAz0dVtfjRdkFT0i6fJPzcvaOdzvbQ36QYsIeIryLVCZ11ETVUav
   A==;
X-CSE-ConnectionGUID: cRDpCAygTJGSjsadhw956Q==
X-CSE-MsgGUID: n08+T7f8R2+BNXw6hsf4bw==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="73982610"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="73982610"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 03:33:01 -0800
X-CSE-ConnectionGUID: yPg0rU1mRWuud/xWQSfarg==
X-CSE-MsgGUID: hEpvpjQ5TKSupTyb4bvKgQ==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 20 Jan 2026 03:32:58 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vi9yi-00000000OtP-20gr;
	Tue, 20 Jan 2026 11:32:56 +0000
Date: Tue, 20 Jan 2026 19:32:18 +0800
From: kernel test robot <lkp@intel.com>
To: nspmangalore@gmail.com, linux-cifs@vger.kernel.org, smfrench@gmail.com,
	pc@manguebit.com, bharathsm@microsoft.com, dhowells@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 4/4] cifs: make retry logic in read/write path consistent
 with other paths
Message-ID: <202601201945.Kjfrc2gQ-lkp@intel.com>
References: <20260120062152.628822-4-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120062152.628822-4-sprasad@microsoft.com>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on cifs/for-next]
[also build test WARNING on brauner-vfs/vfs.all linus/master v6.19-rc6 next-20260119]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/nspmangalore-gmail-com/netfs-avoid-double-increment-of-retry_count-in-subreq/20260120-142802
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
patch link:    https://lore.kernel.org/r/20260120062152.628822-4-sprasad%40microsoft.com
patch subject: [PATCH 4/4] cifs: make retry logic in read/write path consistent with other paths
config: parisc-defconfig (https://download.01.org/0day-ci/archive/20260120/202601201945.Kjfrc2gQ-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260120/202601201945.Kjfrc2gQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601201945.Kjfrc2gQ-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/smb/client/smb2pdu.c: In function 'smb2_readv_callback':
>> fs/smb/client/smb2pdu.c:4599:25: warning: variable 'rqst' set but not used [-Wunused-but-set-variable]
    4599 |         struct smb_rqst rqst = { .rq_iov = &rdata->iov[0], .rq_nvec = 1 };
         |                         ^~~~


vim +/rqst +4599 fs/smb/client/smb2pdu.c

09a4707e763824 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  4585  
09a4707e763824 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  4586  static void
87fba18abbb843 fs/smb/client/smb2pdu.c David Howells   2025-10-03  4587  smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
09a4707e763824 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  4588  {
753b67eb630db3 fs/smb/client/smb2pdu.c David Howells   2022-03-09  4589  	struct cifs_io_subrequest *rdata = mid->callback_data;
1da29f2c39b67b fs/smb/client/smb2pdu.c David Howells   2024-08-22  4590  	struct netfs_inode *ictx = netfs_inode(rdata->rreq->inode);
3ee1a1fc398199 fs/smb/client/smb2pdu.c David Howells   2023-10-06  4591  	struct cifs_tcon *tcon = tlink_tcon(rdata->req->cfile->tlink);
87fba18abbb843 fs/smb/client/smb2pdu.c David Howells   2025-10-03  4592  	struct smb2_hdr *shdr = (struct smb2_hdr *)rdata->iov[0].iov_base;
519be989717c5b fs/smb/client/smb2pdu.c David Howells   2024-05-23  4593  	struct cifs_credits credits = {
519be989717c5b fs/smb/client/smb2pdu.c David Howells   2024-05-23  4594  		.value = 0,
519be989717c5b fs/smb/client/smb2pdu.c David Howells   2024-05-23  4595  		.instance = 0,
519be989717c5b fs/smb/client/smb2pdu.c David Howells   2024-05-23  4596  		.rreq_debug_id = rdata->rreq->debug_id,
519be989717c5b fs/smb/client/smb2pdu.c David Howells   2024-05-23  4597  		.rreq_debug_index = rdata->subreq.debug_index,
519be989717c5b fs/smb/client/smb2pdu.c David Howells   2024-05-23  4598  	};
83bfbd0bb9025f fs/smb/client/smb2pdu.c David Howells   2025-09-05 @4599  	struct smb_rqst rqst = { .rq_iov = &rdata->iov[0], .rq_nvec = 1 };
519be989717c5b fs/smb/client/smb2pdu.c David Howells   2024-05-23  4600  	unsigned int rreq_debug_id = rdata->rreq->debug_id;
519be989717c5b fs/smb/client/smb2pdu.c David Howells   2024-05-23  4601  	unsigned int subreq_debug_index = rdata->subreq.debug_index;
023fc150a39ffe fs/cifs/smb2pdu.c       David Howells   2023-04-18  4602  
023fc150a39ffe fs/cifs/smb2pdu.c       David Howells   2023-04-18  4603  	if (rdata->got_bytes) {
ab58fbdeebc7f9 fs/smb/client/smb2pdu.c David Howells   2023-10-06  4604  		rqst.rq_iter	  = rdata->subreq.io_iter;
9ee04875ae7341 fs/cifs/smb2pdu.c       Yang Li         2023-05-05  4605  	}
09a4707e763824 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  4606  
87fba18abbb843 fs/smb/client/smb2pdu.c David Howells   2025-10-03  4607  	WARN_ONCE(rdata->server != server,
352d96f3acc6e0 fs/cifs/smb2pdu.c       Aurelien Aptel  2020-05-31  4608  		  "rdata server %p != mid server %p",
87fba18abbb843 fs/smb/client/smb2pdu.c David Howells   2025-10-03  4609  		  rdata->server, server);
352d96f3acc6e0 fs/cifs/smb2pdu.c       Aurelien Aptel  2020-05-31  4610  
6a5dcd487791e0 fs/smb/client/smb2pdu.c David Howells   2024-08-22  4611  	cifs_dbg(FYI, "%s: mid=%llu state=%d result=%d bytes=%zu/%zu\n",
f96637be081141 fs/cifs/smb2pdu.c       Joe Perches     2013-05-04  4612  		 __func__, mid->mid, mid->mid_state, rdata->result,
ee4cdf7ba857a8 fs/smb/client/smb2pdu.c David Howells   2024-07-02  4613  		 rdata->got_bytes, rdata->subreq.len - rdata->subreq.transferred);
09a4707e763824 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  4614  
09a4707e763824 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  4615  	switch (mid->mid_state) {
09a4707e763824 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  4616  	case MID_RESPONSE_RECEIVED:
34f4deb7c56c6f fs/cifs/smb2pdu.c       Pavel Shilovsky 2019-01-16  4617  		credits.value = le16_to_cpu(shdr->CreditRequest);
34f4deb7c56c6f fs/cifs/smb2pdu.c       Pavel Shilovsky 2019-01-16  4618  		credits.instance = server->reconnect_instance;
b5649b5d382022 fs/smb/client/smb2pdu.c Shyam Prasad N  2026-01-20  4619  		rdata->result = smb2_check_receive(mid, server, 0);
b5649b5d382022 fs/smb/client/smb2pdu.c Shyam Prasad N  2026-01-20  4620  		if (rdata->result != 0) {
b5649b5d382022 fs/smb/client/smb2pdu.c Shyam Prasad N  2026-01-20  4621  			rdata->subreq.error = rdata->result;
b5649b5d382022 fs/smb/client/smb2pdu.c Shyam Prasad N  2026-01-20  4622  			if (is_replayable_error(rdata->result)) {
b5649b5d382022 fs/smb/client/smb2pdu.c Shyam Prasad N  2026-01-20  4623  				trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_req_submitted);
b5649b5d382022 fs/smb/client/smb2pdu.c Shyam Prasad N  2026-01-20  4624  				__set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);
b5649b5d382022 fs/smb/client/smb2pdu.c Shyam Prasad N  2026-01-20  4625  			} else {
b5649b5d382022 fs/smb/client/smb2pdu.c Shyam Prasad N  2026-01-20  4626  				trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_bad);
3c1bf7e48e9e46 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  4627  			}
b5649b5d382022 fs/smb/client/smb2pdu.c Shyam Prasad N  2026-01-20  4628  			break;
b5649b5d382022 fs/smb/client/smb2pdu.c Shyam Prasad N  2026-01-20  4629  		} else
b5649b5d382022 fs/smb/client/smb2pdu.c Shyam Prasad N  2026-01-20  4630  			trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_progress);
b5649b5d382022 fs/smb/client/smb2pdu.c Shyam Prasad N  2026-01-20  4631  
34a54d617785e5 fs/cifs/smb2pdu.c       Pavel Shilovsky 2014-07-10  4632  		task_io_account_read(rdata->got_bytes);
34a54d617785e5 fs/cifs/smb2pdu.c       Pavel Shilovsky 2014-07-10  4633  		cifs_stats_bytes_read(tcon, rdata->got_bytes);
09a4707e763824 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  4634  		break;
09a4707e763824 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  4635  	case MID_REQUEST_SUBMITTED:
90b3ccf514578c fs/smb/client/smb2pdu.c David Howells   2025-07-01  4636  		trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_req_submitted);
90b3ccf514578c fs/smb/client/smb2pdu.c David Howells   2025-07-01  4637  		goto do_retry;
09a4707e763824 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  4638  	case MID_RETRY_NEEDED:
90b3ccf514578c fs/smb/client/smb2pdu.c David Howells   2025-07-01  4639  		trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_retry_needed);
90b3ccf514578c fs/smb/client/smb2pdu.c David Howells   2025-07-01  4640  do_retry:
ee4cdf7ba857a8 fs/smb/client/smb2pdu.c David Howells   2024-07-02  4641  		__set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);
09a4707e763824 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  4642  		rdata->result = -EAGAIN;
d913ed17f0a7d7 fs/cifs/smb2pdu.c       Pavel Shilovsky 2014-07-10  4643  		if (server->sign && rdata->got_bytes)
d913ed17f0a7d7 fs/cifs/smb2pdu.c       Pavel Shilovsky 2014-07-10  4644  			/* reset bytes number since we can not check a sign */
d913ed17f0a7d7 fs/cifs/smb2pdu.c       Pavel Shilovsky 2014-07-10  4645  			rdata->got_bytes = 0;
d913ed17f0a7d7 fs/cifs/smb2pdu.c       Pavel Shilovsky 2014-07-10  4646  		/* FIXME: should this be counted toward the initiating task? */
d913ed17f0a7d7 fs/cifs/smb2pdu.c       Pavel Shilovsky 2014-07-10  4647  		task_io_account_read(rdata->got_bytes);
d913ed17f0a7d7 fs/cifs/smb2pdu.c       Pavel Shilovsky 2014-07-10  4648  		cifs_stats_bytes_read(tcon, rdata->got_bytes);
09a4707e763824 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  4649  		break;
0fd1d37b0501ef fs/cifs/smb2pdu.c       Pavel Shilovsky 2019-01-15  4650  	case MID_RESPONSE_MALFORMED:
90b3ccf514578c fs/smb/client/smb2pdu.c David Howells   2025-07-01  4651  		trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_malformed);
34f4deb7c56c6f fs/cifs/smb2pdu.c       Pavel Shilovsky 2019-01-16  4652  		credits.value = le16_to_cpu(shdr->CreditRequest);
34f4deb7c56c6f fs/cifs/smb2pdu.c       Pavel Shilovsky 2019-01-16  4653  		credits.instance = server->reconnect_instance;
f80ac7eda1cf52 fs/smb/client/smb2pdu.c David Howells   2025-10-24  4654  		rdata->result = smb_EIO(smb_eio_trace_read_rsp_malformed);
90b3ccf514578c fs/smb/client/smb2pdu.c David Howells   2025-07-01  4655  		break;
09a4707e763824 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  4656  	default:
90b3ccf514578c fs/smb/client/smb2pdu.c David Howells   2025-07-01  4657  		trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_unknown);
f80ac7eda1cf52 fs/smb/client/smb2pdu.c David Howells   2025-10-24  4658  		rdata->result = smb_EIO1(smb_eio_trace_read_mid_state_unknown,
f80ac7eda1cf52 fs/smb/client/smb2pdu.c David Howells   2025-10-24  4659  					 mid->mid_state);
90b3ccf514578c fs/smb/client/smb2pdu.c David Howells   2025-07-01  4660  		break;
09a4707e763824 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  4661  	}
bd3dcc6a22a918 fs/cifs/smb2pdu.c       Long Li         2017-11-22  4662  #ifdef CONFIG_CIFS_SMB_DIRECT
bd3dcc6a22a918 fs/cifs/smb2pdu.c       Long Li         2017-11-22  4663  	/*
e9f49feefb4b13 fs/smb/client/smb2pdu.c Shen Lichuan    2024-09-25  4664  	 * If this rdata has a memory registered, the MR can be freed
bd3dcc6a22a918 fs/cifs/smb2pdu.c       Long Li         2017-11-22  4665  	 * MR needs to be freed as soon as I/O finishes to prevent deadlock
bd3dcc6a22a918 fs/cifs/smb2pdu.c       Long Li         2017-11-22  4666  	 * because they have limited number and are used for future I/Os
bd3dcc6a22a918 fs/cifs/smb2pdu.c       Long Li         2017-11-22  4667  	 */
bd3dcc6a22a918 fs/cifs/smb2pdu.c       Long Li         2017-11-22  4668  	if (rdata->mr) {
bd3dcc6a22a918 fs/cifs/smb2pdu.c       Long Li         2017-11-22  4669  		smbd_deregister_mr(rdata->mr);
bd3dcc6a22a918 fs/cifs/smb2pdu.c       Long Li         2017-11-22  4670  		rdata->mr = NULL;
bd3dcc6a22a918 fs/cifs/smb2pdu.c       Long Li         2017-11-22  4671  	}
bd3dcc6a22a918 fs/cifs/smb2pdu.c       Long Li         2017-11-22  4672  #endif
082aaa8700415f fs/cifs/smb2pdu.c       Pavel Shilovsky 2019-01-18  4673  	if (rdata->result && rdata->result != -ENODATA) {
09a4707e763824 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  4674  		cifs_stats_fail_inc(tcon, SMB2_READ_HE);
3ee1a1fc398199 fs/smb/client/smb2pdu.c David Howells   2023-10-06  4675  		trace_smb3_read_err(rdata->rreq->debug_id,
3ee1a1fc398199 fs/smb/client/smb2pdu.c David Howells   2023-10-06  4676  				    rdata->subreq.debug_index,
3ee1a1fc398199 fs/smb/client/smb2pdu.c David Howells   2023-10-06  4677  				    rdata->xid,
3ee1a1fc398199 fs/smb/client/smb2pdu.c David Howells   2023-10-06  4678  				    rdata->req->cfile->fid.persistent_fid,
6a5dcd487791e0 fs/smb/client/smb2pdu.c David Howells   2024-08-22  4679  				    tcon->tid, tcon->ses->Suid,
6a5dcd487791e0 fs/smb/client/smb2pdu.c David Howells   2024-08-22  4680  				    rdata->subreq.start + rdata->subreq.transferred,
ee4cdf7ba857a8 fs/smb/client/smb2pdu.c David Howells   2024-07-02  4681  				    rdata->subreq.len   - rdata->subreq.transferred,
6a5dcd487791e0 fs/smb/client/smb2pdu.c David Howells   2024-08-22  4682  				    rdata->result);
7d42e72fe8ee5a fs/cifs/smb2pdu.c       Pavel Shilovsky 2019-01-25  4683  	} else
3ee1a1fc398199 fs/smb/client/smb2pdu.c David Howells   2023-10-06  4684  		trace_smb3_read_done(rdata->rreq->debug_id,
3ee1a1fc398199 fs/smb/client/smb2pdu.c David Howells   2023-10-06  4685  				     rdata->subreq.debug_index,
3ee1a1fc398199 fs/smb/client/smb2pdu.c David Howells   2023-10-06  4686  				     rdata->xid,
3ee1a1fc398199 fs/smb/client/smb2pdu.c David Howells   2023-10-06  4687  				     rdata->req->cfile->fid.persistent_fid,
7d42e72fe8ee5a fs/cifs/smb2pdu.c       Pavel Shilovsky 2019-01-25  4688  				     tcon->tid, tcon->ses->Suid,
6a5dcd487791e0 fs/smb/client/smb2pdu.c David Howells   2024-08-22  4689  				     rdata->subreq.start + rdata->subreq.transferred,
6a5dcd487791e0 fs/smb/client/smb2pdu.c David Howells   2024-08-22  4690  				     rdata->got_bytes);
09a4707e763824 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  4691  
3ee1a1fc398199 fs/smb/client/smb2pdu.c David Howells   2023-10-06  4692  	if (rdata->result == -ENODATA) {
1da29f2c39b67b fs/smb/client/smb2pdu.c David Howells   2024-08-22  4693  		__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
1da29f2c39b67b fs/smb/client/smb2pdu.c David Howells   2024-08-22  4694  		rdata->result = 0;
1da29f2c39b67b fs/smb/client/smb2pdu.c David Howells   2024-08-22  4695  	} else {
ee4cdf7ba857a8 fs/smb/client/smb2pdu.c David Howells   2024-07-02  4696  		size_t trans = rdata->subreq.transferred + rdata->got_bytes;
ee4cdf7ba857a8 fs/smb/client/smb2pdu.c David Howells   2024-07-02  4697  		if (trans < rdata->subreq.len &&
4ae4dde6f34a41 fs/smb/client/smb2pdu.c David Howells   2025-12-03  4698  		    rdata->subreq.start + trans >= ictx->remote_i_size) {
1da29f2c39b67b fs/smb/client/smb2pdu.c David Howells   2024-08-22  4699  			__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
3ee1a1fc398199 fs/smb/client/smb2pdu.c David Howells   2023-10-06  4700  			rdata->result = 0;
3ee1a1fc398199 fs/smb/client/smb2pdu.c David Howells   2023-10-06  4701  		}
e2d46f2ec33253 fs/smb/client/smb2pdu.c David Howells   2024-12-16  4702  		if (rdata->got_bytes)
4acb665cf4f3e5 fs/smb/client/smb2pdu.c David Howells   2024-12-13  4703  			__set_bit(NETFS_SREQ_MADE_PROGRESS, &rdata->subreq.flags);
1da29f2c39b67b fs/smb/client/smb2pdu.c David Howells   2024-08-22  4704  	}
519be989717c5b fs/smb/client/smb2pdu.c David Howells   2024-05-23  4705  	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, rdata->credits.value,
519be989717c5b fs/smb/client/smb2pdu.c David Howells   2024-05-23  4706  			      server->credits, server->in_flight,
519be989717c5b fs/smb/client/smb2pdu.c David Howells   2024-05-23  4707  			      0, cifs_trace_rw_credits_read_response_clear);
3ee1a1fc398199 fs/smb/client/smb2pdu.c David Howells   2023-10-06  4708  	rdata->credits.value = 0;
360157829ee3db fs/smb/client/smb2pdu.c David Howells   2024-12-16  4709  	rdata->subreq.error = rdata->result;
ee4cdf7ba857a8 fs/smb/client/smb2pdu.c David Howells   2024-07-02  4710  	rdata->subreq.transferred += rdata->got_bytes;
ee4cdf7ba857a8 fs/smb/client/smb2pdu.c David Howells   2024-07-02  4711  	trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_progress);
e2d46f2ec33253 fs/smb/client/smb2pdu.c David Howells   2024-12-16  4712  	netfs_read_subreq_terminated(&rdata->subreq);
87fba18abbb843 fs/smb/client/smb2pdu.c David Howells   2025-10-03  4713  	release_mid(server, mid);
519be989717c5b fs/smb/client/smb2pdu.c David Howells   2024-05-23  4714  	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, 0,
519be989717c5b fs/smb/client/smb2pdu.c David Howells   2024-05-23  4715  			      server->credits, server->in_flight,
519be989717c5b fs/smb/client/smb2pdu.c David Howells   2024-05-23  4716  			      credits.value, cifs_trace_rw_credits_read_response_add);
34f4deb7c56c6f fs/cifs/smb2pdu.c       Pavel Shilovsky 2019-01-16  4717  	add_credits(server, &credits, 0);
09a4707e763824 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  4718  }
09a4707e763824 fs/cifs/smb2pdu.c       Pavel Shilovsky 2012-09-18  4719  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
