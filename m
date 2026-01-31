Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855663382F0;
	Sat, 31 Jan 2026 15:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769874880; cv=none; b=Kma/vTm1Km4OffWuqTkCr3ZuBVFMLQ1TbuOeTKqzNJIlEYIYocQEB8r2BNS9onq/BsQfA8OqT0UdyoVpl1kSQlyH2hmX5Y2Zpv8ihKlAPg2GwR8h0KeqZZmIVs1m7h9rafpZ2X7uPxuPpqnsBLltCHp9+tRRVvMc1DQinWFaxiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769874880; c=relaxed/simple;
	bh=yP/+lWu8w6TVpcU/sK04du+syKfA7fdOXqbErdv8SGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OX/e6bAr9LzpVAYmpWDr9Y8WX23aaqBzg4PbX+BlWUX9hlwyGu/ThPF12Fw3kt9euM8alhbF0J9q8SUXEXuhr38QOFExlRWrsRhEJuDRAj9b3tOdVyd6Mz4BNYd/KcERuywFIT+Kr40v7bolu4nrT5jU/7Ol66O0tIx5YO9s5fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f37NOcNy; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f37NOcNy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769874878; x=1801410878;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yP/+lWu8w6TVpcU/sK04du+syKfA7fdOXqbErdv8SGk=;
  b=f37NOcNyYVKnSTwbctSd3O7TVzwn+GF3zQeo7lLNnGfVkx+ipP8pXdtQ
   Y8ee44Hxqr3eGHvHIsQJ/z54AMTpftq5v+SYKbawL70IWJ6J5TfldzTHT
   9pLzzN3rcKdJTlS9ha1YRlFrqHDB4x7ZSwCFmVXP1IEBy99BpmaoIVqdq
   Jo7u6PGANeg42bkZ+4whbDE79j33fARD5Jt0AB1xsj65pYNn8s2/geXlA
   cif4rFQxZRF7SRvsDwYyvtL+nqOIYIVIIruA8Blcbub1yPRfHwOK5ZUjq
   hLt8yaxmSfORHWxWFK8wotuDp6Fw2QLzPhMequke3RxanYQUDZORtH176
   w==;
X-CSE-ConnectionGUID: 4YvMylxZTTuK3wJZZXlwcQ==
X-CSE-MsgGUID: +hk1m2nSS9i9ox5RZgmG+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11687"; a="70118250"
X-IronPort-AV: E=Sophos;i="6.21,265,1763452800"; 
   d="scan'208";a="70118250"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2026 07:54:38 -0800
X-CSE-ConnectionGUID: mNM1mRCKRvO2CXNfpAHMEg==
X-CSE-MsgGUID: HLs4j+UdQ/C/xg8xorcjOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,265,1763452800"; 
   d="scan'208";a="208350889"
Received: from igk-lkp-server01.igk.intel.com (HELO afc5bfd7f602) ([10.211.93.152])
  by orviesa010.jf.intel.com with ESMTP; 31 Jan 2026 07:54:16 -0800
Received: from kbuild by afc5bfd7f602 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vmDIc-000000002iX-0fps;
	Sat, 31 Jan 2026 15:54:14 +0000
Date: Sat, 31 Jan 2026 16:54:04 +0100
From: kernel test robot <lkp@intel.com>
To: nspmangalore@gmail.com, linux-cifs@vger.kernel.org, smfrench@gmail.com,
	pc@manguebit.org, bharathsm@microsoft.com
Cc: oe-kbuild-all@lists.linux.dev, Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/2] cifs: Fix locking usage for tcon fields
Message-ID: <202601311634.9WVpg186-lkp@intel.com>
References: <20260131080239.943483-2-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260131080239.943483-2-sprasad@microsoft.com>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on cifs/for-next]
[also build test ERROR on linus/master v6.19-rc7 next-20260130]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/nspmangalore-gmail-com/cifs-Fix-locking-usage-for-tcon-fields/20260131-160419
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
patch link:    https://lore.kernel.org/r/20260131080239.943483-2-sprasad%40microsoft.com
patch subject: [PATCH 2/2] cifs: Fix locking usage for tcon fields
config: s390-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260131/202601311634.9WVpg186-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260131/202601311634.9WVpg186-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601311634.9WVpg186-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/smb/client/smb2ops.c: In function 'smb2_get_dfs_refer':
>> fs/smb/client/smb2ops.c:3178:17: error: too few arguments to function 'cifs_put_tcon'; expected 2, have 1
    3178 |                 cifs_put_tcon(tcon);
         |                 ^~~~~~~~~~~~~
   In file included from fs/smb/client/smb2ops.c:20:
   fs/smb/client/cifsproto.h:273:6: note: declared here
     273 | void cifs_put_tcon(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace);
         |      ^~~~~~~~~~~~~


vim +/cifs_put_tcon +3178 fs/smb/client/smb2ops.c

  3078	
  3079	static int
  3080	smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
  3081			   const char *search_name,
  3082			   struct dfs_info3_param **target_nodes,
  3083			   unsigned int *num_of_nodes,
  3084			   const struct nls_table *nls_codepage, int remap)
  3085	{
  3086		int rc;
  3087		__le16 *utf16_path = NULL;
  3088		int utf16_path_len = 0;
  3089		struct cifs_tcon *tcon;
  3090		struct fsctl_get_dfs_referral_req *dfs_req = NULL;
  3091		struct get_dfs_referral_rsp *dfs_rsp = NULL;
  3092		u32 dfs_req_size = 0, dfs_rsp_size = 0;
  3093		int retry_once = 0;
  3094	
  3095		cifs_dbg(FYI, "%s: path: %s\n", __func__, search_name);
  3096	
  3097		/*
  3098		 * Try to use the IPC tcon, otherwise just use any
  3099		 */
  3100		tcon = ses->tcon_ipc;
  3101		if (tcon == NULL) {
  3102			spin_lock(&cifs_tcp_ses_lock);
  3103			tcon = list_first_entry_or_null(&ses->tcon_list,
  3104							struct cifs_tcon,
  3105							tcon_list);
  3106			if (tcon) {
  3107				spin_lock(&tcon->tc_lock);
  3108				tcon->tc_count++;
  3109				spin_unlock(&tcon->tc_lock);
  3110				trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
  3111						    netfs_trace_tcon_ref_get_dfs_refer);
  3112			}
  3113			spin_unlock(&cifs_tcp_ses_lock);
  3114		}
  3115	
  3116		if (tcon == NULL) {
  3117			cifs_dbg(VFS, "session %p has no tcon available for a dfs referral request\n",
  3118				 ses);
  3119			rc = -ENOTCONN;
  3120			goto out;
  3121		}
  3122	
  3123		utf16_path = cifs_strndup_to_utf16(search_name, PATH_MAX,
  3124						   &utf16_path_len,
  3125						   nls_codepage, remap);
  3126		if (!utf16_path) {
  3127			rc = -ENOMEM;
  3128			goto out;
  3129		}
  3130	
  3131		dfs_req_size = sizeof(*dfs_req) + utf16_path_len;
  3132		dfs_req = kzalloc(dfs_req_size, GFP_KERNEL);
  3133		if (!dfs_req) {
  3134			rc = -ENOMEM;
  3135			goto out;
  3136		}
  3137	
  3138		/* Highest DFS referral version understood */
  3139		dfs_req->MaxReferralLevel = DFS_VERSION;
  3140	
  3141		/* Path to resolve in an UTF-16 null-terminated string */
  3142		memcpy(dfs_req->RequestFileName, utf16_path, utf16_path_len);
  3143	
  3144		for (;;) {
  3145			rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
  3146					FSCTL_DFS_GET_REFERRALS,
  3147					(char *)dfs_req, dfs_req_size, CIFSMaxBufSize,
  3148					(char **)&dfs_rsp, &dfs_rsp_size);
  3149			if (fatal_signal_pending(current)) {
  3150				rc = -EINTR;
  3151				break;
  3152			}
  3153			if (!is_retryable_error(rc) || retry_once++)
  3154				break;
  3155			usleep_range(512, 2048);
  3156		}
  3157	
  3158		if (!rc && !dfs_rsp)
  3159			rc = smb_EIO(smb_eio_trace_dfsref_no_rsp);
  3160		if (rc) {
  3161			if (!is_retryable_error(rc) && rc != -ENOENT && rc != -EOPNOTSUPP)
  3162				cifs_tcon_dbg(FYI, "%s: ioctl error: rc=%d\n", __func__, rc);
  3163			goto out;
  3164		}
  3165	
  3166		rc = parse_dfs_referrals(dfs_rsp, dfs_rsp_size,
  3167					 num_of_nodes, target_nodes,
  3168					 nls_codepage, remap, search_name,
  3169					 true /* is_unicode */);
  3170		if (rc && rc != -ENOENT) {
  3171			cifs_tcon_dbg(VFS, "%s: failed to parse DFS referral %s: %d\n",
  3172				      __func__, search_name, rc);
  3173		}
  3174	
  3175	 out:
  3176		if (tcon && !tcon->ipc) {
  3177			/* ipc tcons are not refcounted */
> 3178			cifs_put_tcon(tcon);
  3179			trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
  3180					    netfs_trace_tcon_ref_dec_dfs_refer);
  3181		}
  3182		kfree(utf16_path);
  3183		kfree(dfs_req);
  3184		kfree(dfs_rsp);
  3185		return rc;
  3186	}
  3187	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
