Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383081EB9E3
	for <linux-cifs@vger.kernel.org>; Tue, 30 Sep 2025 19:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759259017; cv=none; b=oGyBI1JUKJQ1W0BZO7InLh6gHLhqK4qc+mliPtp2wx0X625lmlgg/bItJL1pvCMvWhoO9/18AAcxIAq4ZzHKHw28dJm4LbBqk9j569Dvh2FPEGWYYoD/Sg7x8J3QiVQw/0A1ecHTVSyk12+/j3IoAVRwwK71OfUUKABLTIeczkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759259017; c=relaxed/simple;
	bh=wQmAYpx6lf71PcUC9VhsHI+C7PjtSINTyfBM7V9OUr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dioIUOmN83+TYisvqg+TNUt8iknZI75UJjNjNqfhfwjXB0se/slPGcQfuGQmFXcCqdxL/RCO3b56N68sr7ucnrh2KlnMRy6KTZ+FeGqJsaEbGh0wC1U2XlDgLr9I7k6j8S7J0Pjte9t9+MvrM8BfXcG9Dc6cL2YeYBOJAsm0YTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bek6kRss; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bek6kRss"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759259014; x=1790795014;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wQmAYpx6lf71PcUC9VhsHI+C7PjtSINTyfBM7V9OUr0=;
  b=Bek6kRssM6LO7/4Vv2RUUKYs3cyXLtHjO/WUdsra78F/5oCNMkddyL43
   BlWlWsiV4wlB9uBNIJlnHGbzp8W7bqj8FhwpmrW3xgNE7zoA5ZXFb0S31
   G4qIM6d4qNMpjMsFFZQ9rddQo8pms+RSXGFEQ/eUmhMd6DLDph7OQhmE6
   m8LO6POCW19wQBPCK8zmfOSb7GDsXo8v6OIms6AtO716hHZ+YvgizS1YB
   aVPC1dEwIToOWGEnLZUme87XBN7ZvfnM974lUT3HX6NTssjkZzAlB0mr3
   9IBEfha3r+r8Y4p8oKRz3HGAhZpZqLejM0i9m0s6frnHOF4jYGD1Uc9kK
   A==;
X-CSE-ConnectionGUID: MGUFRm38Q++7DJPvd8i0oA==
X-CSE-MsgGUID: OXehjbQ5QgOkMOP1xthxVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="60560853"
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="60560853"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 12:03:33 -0700
X-CSE-ConnectionGUID: elPmh3J+RzWssp29oZXHAQ==
X-CSE-MsgGUID: 4mVfqtYhTKyFEGJ50dsYPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="177718351"
Received: from lkp-server01.sh.intel.com (HELO 2f2a1232a4e4) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 30 Sep 2025 12:03:30 -0700
Received: from kbuild by 2f2a1232a4e4 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v3fdH-0002Pz-2S;
	Tue, 30 Sep 2025 19:03:27 +0000
Date: Wed, 1 Oct 2025 03:02:33 +0800
From: kernel test robot <lkp@intel.com>
To: Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, smfrench@gmail.com, pc@manguebit.com,
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
	bharathsm@microsoft.com, henrique.carvalho@suse.com
Subject: Re: [PATCH 19/20] smb: client: rework cached dirs synchronization
Message-ID: <202510010208.20c25Gzw-lkp@intel.com>
References: <20250929132805.220558-20-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929132805.220558-20-ematsumiya@suse.de>

Hi Enzo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on v6.17]
[also build test WARNING on linus/master]
[cannot apply to cifs/for-next next-20250929]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Enzo-Matsumiya/smb-client-remove-cfids_invalidation_worker/20250929-213155
base:   v6.17
patch link:    https://lore.kernel.org/r/20250929132805.220558-20-ematsumiya%40suse.de
patch subject: [PATCH 19/20] smb: client: rework cached dirs synchronization
config: i386-randconfig-061-20250930 (https://download.01.org/0day-ci/archive/20251001/202510010208.20c25Gzw-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251001/202510010208.20c25Gzw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510010208.20c25Gzw-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> fs/smb/client/cached_dir.c:304:14: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct cached_fid [noderef] __rcu *[assigned] cfid @@     got struct cached_fid * @@
   fs/smb/client/cached_dir.c:304:14: sparse:     expected struct cached_fid [noderef] __rcu *[assigned] cfid
   fs/smb/client/cached_dir.c:304:14: sparse:     got struct cached_fid *
>> fs/smb/client/cached_dir.c:306:27: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct cached_fid * @@     got struct cached_fid [noderef] __rcu *[assigned] cfid @@
   fs/smb/client/cached_dir.c:306:27: sparse:     expected struct cached_fid *
   fs/smb/client/cached_dir.c:306:27: sparse:     got struct cached_fid [noderef] __rcu *[assigned] cfid
   fs/smb/client/cached_dir.c:323:14: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct cached_fid [noderef] __rcu *[assigned] cfid @@     got struct cached_fid * @@
   fs/smb/client/cached_dir.c:323:14: sparse:     expected struct cached_fid [noderef] __rcu *[assigned] cfid
   fs/smb/client/cached_dir.c:323:14: sparse:     got struct cached_fid *
>> fs/smb/client/cached_dir.c:331:14: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct cifs_fid *pfid @@     got struct cifs_fid [noderef] __rcu * @@
   fs/smb/client/cached_dir.c:331:14: sparse:     expected struct cifs_fid *pfid
   fs/smb/client/cached_dir.c:331:14: sparse:     got struct cifs_fid [noderef] __rcu *
>> fs/smb/client/cached_dir.c:359:23: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct list_head *new @@     got struct list_head [noderef] __rcu * @@
   fs/smb/client/cached_dir.c:359:23: sparse:     expected struct list_head *new
   fs/smb/client/cached_dir.c:359:23: sparse:     got struct list_head [noderef] __rcu *
>> fs/smb/client/cached_dir.c:477:35: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct cached_fid *cfid @@     got struct cached_fid [noderef] __rcu *[assigned] cfid @@
   fs/smb/client/cached_dir.c:477:35: sparse:     expected struct cached_fid *cfid
   fs/smb/client/cached_dir.c:477:35: sparse:     got struct cached_fid [noderef] __rcu *[assigned] cfid
>> fs/smb/client/cached_dir.c:480:32: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct seqlock_t [usertype] *sl @@     got struct seqlock_t [noderef] __rcu * @@
   fs/smb/client/cached_dir.c:480:32: sparse:     expected struct seqlock_t [usertype] *sl
   fs/smb/client/cached_dir.c:480:32: sparse:     got struct seqlock_t [noderef] __rcu *
   fs/smb/client/cached_dir.c:484:34: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct seqlock_t [usertype] *sl @@     got struct seqlock_t [noderef] __rcu * @@
   fs/smb/client/cached_dir.c:484:34: sparse:     expected struct seqlock_t [usertype] *sl
   fs/smb/client/cached_dir.c:484:34: sparse:     got struct seqlock_t [noderef] __rcu *
   fs/smb/client/cached_dir.c:486:27: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct cached_fid * @@     got struct cached_fid [noderef] __rcu *[assigned] cfid @@
   fs/smb/client/cached_dir.c:486:27: sparse:     expected struct cached_fid *
   fs/smb/client/cached_dir.c:486:27: sparse:     got struct cached_fid [noderef] __rcu *[assigned] cfid
>> fs/smb/client/cached_dir.c:329:9: sparse: sparse: dereference of noderef expression
   fs/smb/client/cached_dir.c:330:9: sparse: sparse: dereference of noderef expression
   fs/smb/client/cached_dir.c:455:17: sparse: sparse: dereference of noderef expression
   fs/smb/client/cached_dir.c:456:22: sparse: sparse: dereference of noderef expression
   fs/smb/client/cached_dir.c:470:20: sparse: sparse: dereference of noderef expression
   fs/smb/client/cached_dir.c:481:17: sparse: sparse: dereference of noderef expression
   fs/smb/client/cached_dir.c:482:17: sparse: sparse: dereference of noderef expression
   fs/smb/client/cached_dir.c:483:17: sparse: sparse: dereference of noderef expression

vim +304 fs/smb/client/cached_dir.c

7d24f0ff5dad1f fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  250  
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  251  /*
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  252   * Open the and cache a directory handle.
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  253   * If error then *cfid is not initialized.
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  254   */
7d24f0ff5dad1f fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  255  int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon, const char *path,
7d24f0ff5dad1f fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  256  		    struct cifs_sb_info *cifs_sb, struct cached_fid **ret_cfid)
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  257  {
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  258  	struct cifs_ses *ses;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  259  	struct TCP_Server_Info *server;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  260  	struct cifs_open_parms oparms;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  261  	struct smb2_create_rsp *o_rsp = NULL;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  262  	struct smb2_query_info_rsp *qi_rsp = NULL;
ff1e8e71b1ac5d fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  263  	struct smb2_file_all_info info;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  264  	int resp_buftype[2];
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  265  	struct smb_rqst rqst[2];
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  266  	struct kvec rsp_iov[2];
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  267  	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  268  	struct kvec qi_iov[1];
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  269  	int rc, flags = 0;
ebe98f1447bbcc fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-10-06  270  	__le16 *utf16_path = NULL;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  271  	u8 oplock = SMB2_OPLOCK_LEVEL_II;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  272  	struct cifs_fid *pfid;
7d24f0ff5dad1f fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  273  	struct dentry *dentry;
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  274  	struct cached_fid __rcu *cfid;
ebe98f1447bbcc fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-10-06  275  	struct cached_fids *cfids;
be4fde79812f02 fs/cifs/cached_dir.c       Paulo Alcantara   2023-03-24  276  	const char *npath;
4f1fffa2376922 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  277  	int retries = 0, cur_sleep = 1;
ebe98f1447bbcc fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-10-06  278  
f6e88838400d88 fs/smb/client/cached_dir.c Henrique Carvalho 2024-11-22  279  	if (cifs_sb->root == NULL)
f6e88838400d88 fs/smb/client/cached_dir.c Henrique Carvalho 2024-11-22  280  		return -ENOENT;
f6e88838400d88 fs/smb/client/cached_dir.c Henrique Carvalho 2024-11-22  281  
f6e88838400d88 fs/smb/client/cached_dir.c Henrique Carvalho 2024-11-22  282  	if (tcon == NULL)
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  283  		return -EOPNOTSUPP;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  284  
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  285  	ses = tcon->ses;
ebe98f1447bbcc fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-10-06  286  	cfids = tcon->cfids;
1d4a92c061c478 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  287  	if (!cfids)
f6e88838400d88 fs/smb/client/cached_dir.c Henrique Carvalho 2024-11-22  288  		return -EOPNOTSUPP;
e28638bb28ed69 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  289  
4f1fffa2376922 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  290  replay_again:
4f1fffa2376922 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  291  	/* reinitialize for possible replay */
4f1fffa2376922 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  292  	flags = 0;
4f1fffa2376922 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  293  	oplock = SMB2_OPLOCK_LEVEL_II;
7d24f0ff5dad1f fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  294  	dentry = NULL;
7d24f0ff5dad1f fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  295  	cfid = NULL;
7d24f0ff5dad1f fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  296  	*ret_cfid = NULL;
ff1e8e71b1ac5d fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  297  	memset(&info, 0, sizeof(info));
4f1fffa2376922 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  298  	server = cifs_pick_channel(ses);
4f1fffa2376922 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  299  
4f1fffa2376922 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  300  	if (!server->ops->new_lease_key)
4f1fffa2376922 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  301  		return -EIO;
4f1fffa2376922 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  302  
ff1e8e71b1ac5d fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  303  	/* find_cached_dir() already validates cfid if found, so no need to check here again */
7d24f0ff5dad1f fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29 @304  	cfid = find_cached_dir(cfids, path, CFID_LOOKUP_PATH);
7d24f0ff5dad1f fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  305  	if (cfid) {
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29 @306  		*ret_cfid = cfid;
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  307  		return 0;
ebe98f1447bbcc fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-10-06  308  	}
1d4a92c061c478 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  309  
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  310  	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  311  	if (!utf16_path)
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  312  		return -ENOMEM;
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  313  
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  314  	read_seqlock_excl(&cfids->entries_seqlock);
7d24f0ff5dad1f fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  315  	if (cfids->num_entries >= tcon->max_cached_dirs) {
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  316  		read_sequnlock_excl(&cfids->entries_seqlock);
7d24f0ff5dad1f fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  317  		rc = -ENOENT;
7d24f0ff5dad1f fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  318  		goto out;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  319  	}
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  320  	read_sequnlock_excl(&cfids->entries_seqlock);
1d4a92c061c478 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  321  
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  322  	/* no ned to lock cfid or entries yet */
1d4a92c061c478 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29 @323  	cfid = init_cached_dir(path);
1d4a92c061c478 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  324  	if (!cfid) {
7d24f0ff5dad1f fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  325  		rc = -ENOMEM;
7d24f0ff5dad1f fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  326  		goto out;
1d4a92c061c478 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  327  	}
1d4a92c061c478 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  328  
1d4a92c061c478 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29 @329  	cfid->cfids = cfids;
65e58ef1dafb0c fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  330  	cfid->tcon = tcon;
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29 @331  	pfid = &cfid->fid;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  332  
be4fde79812f02 fs/cifs/cached_dir.c       Paulo Alcantara   2023-03-24  333  	/*
fa6fe07d153636 fs/smb/client/cached_dir.c NeilBrown         2025-03-19  334  	 * Skip any prefix paths in @path as lookup_noperm_positive_unlocked() ends up
be4fde79812f02 fs/cifs/cached_dir.c       Paulo Alcantara   2023-03-24  335  	 * calling ->lookup() which already adds those through
be4fde79812f02 fs/cifs/cached_dir.c       Paulo Alcantara   2023-03-24  336  	 * build_path_from_dentry().  Also, do it earlier as we might reconnect
be4fde79812f02 fs/cifs/cached_dir.c       Paulo Alcantara   2023-03-24  337  	 * below when trying to send compounded request and then potentially
be4fde79812f02 fs/cifs/cached_dir.c       Paulo Alcantara   2023-03-24  338  	 * having a different prefix path (e.g. after DFS failover).
be4fde79812f02 fs/cifs/cached_dir.c       Paulo Alcantara   2023-03-24  339  	 */
be4fde79812f02 fs/cifs/cached_dir.c       Paulo Alcantara   2023-03-24  340  	npath = path_no_prefix(cifs_sb, path);
be4fde79812f02 fs/cifs/cached_dir.c       Paulo Alcantara   2023-03-24  341  	if (IS_ERR(npath)) {
be4fde79812f02 fs/cifs/cached_dir.c       Paulo Alcantara   2023-03-24  342  		rc = PTR_ERR(npath);
5c86919455c1ed fs/smb/client/cached_dir.c Paulo Alcantara   2023-10-30  343  		goto out;
be4fde79812f02 fs/cifs/cached_dir.c       Paulo Alcantara   2023-03-24  344  	}
be4fde79812f02 fs/cifs/cached_dir.c       Paulo Alcantara   2023-03-24  345  
5c86919455c1ed fs/smb/client/cached_dir.c Paulo Alcantara   2023-10-30  346  	if (!npath[0]) {
5c86919455c1ed fs/smb/client/cached_dir.c Paulo Alcantara   2023-10-30  347  		dentry = dget(cifs_sb->root);
5c86919455c1ed fs/smb/client/cached_dir.c Paulo Alcantara   2023-10-30  348  	} else {
5c86919455c1ed fs/smb/client/cached_dir.c Paulo Alcantara   2023-10-30  349  		dentry = path_to_dentry(cifs_sb, npath);
5c86919455c1ed fs/smb/client/cached_dir.c Paulo Alcantara   2023-10-30  350  		if (IS_ERR(dentry)) {
a43689b1b41ccc fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  351  			dentry = NULL;
5c86919455c1ed fs/smb/client/cached_dir.c Paulo Alcantara   2023-10-30  352  			rc = -ENOENT;
5c86919455c1ed fs/smb/client/cached_dir.c Paulo Alcantara   2023-10-30  353  			goto out;
5c86919455c1ed fs/smb/client/cached_dir.c Paulo Alcantara   2023-10-30  354  		}
5c86919455c1ed fs/smb/client/cached_dir.c Paulo Alcantara   2023-10-30  355  	}
5c86919455c1ed fs/smb/client/cached_dir.c Paulo Alcantara   2023-10-30  356  
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  357  	write_seqlock(&cfids->entries_seqlock);
65e58ef1dafb0c fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  358  	cfids->num_entries++;
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29 @359  	list_add_rcu(&cfid->entry, &cfids->entries);
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  360  	write_sequnlock(&cfids->entries_seqlock);
65e58ef1dafb0c fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  361  
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  362  	/*
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  363  	 * We do not hold the lock for the open because in case
ebe98f1447bbcc fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-10-06  364  	 * SMB2_open needs to reconnect.
ebe98f1447bbcc fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-10-06  365  	 * This is safe because no other thread will be able to get a ref
ebe98f1447bbcc fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-10-06  366  	 * to the cfid until we have finished opening the file and (possibly)
ebe98f1447bbcc fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-10-06  367  	 * acquired a lease.
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  368  	 */
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  369  	if (smb3_encryption_required(tcon))
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  370  		flags |= CIFS_TRANSFORM_REQ;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  371  
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  372  	server->ops->new_lease_key(pfid);
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  373  
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  374  	memset(rqst, 0, sizeof(rqst));
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  375  	resp_buftype[0] = resp_buftype[1] = CIFS_NO_BUFFER;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  376  	memset(rsp_iov, 0, sizeof(rsp_iov));
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  377  
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  378  	/* Open */
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  379  	memset(&open_iov, 0, sizeof(open_iov));
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  380  	rqst[0].rq_iov = open_iov;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  381  	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  382  
e28638bb28ed69 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  383  	oparms = CIFS_OPARMS(cifs_sb, tcon, path,
e28638bb28ed69 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  384  			     FILE_READ_DATA | FILE_READ_ATTRIBUTES | FILE_READ_EA, FILE_OPEN,
e28638bb28ed69 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  385  			     cifs_create_options(cifs_sb, CREATE_NOT_FILE), 0);
e28638bb28ed69 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  386  	oparms.fid = pfid;
e28638bb28ed69 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  387  	oparms.replay = !!retries;
e28638bb28ed69 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  388  
e28638bb28ed69 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  389  	rc = SMB2_open_init(tcon, server, &rqst[0], &oplock, &oparms, utf16_path);
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  390  	if (rc)
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  391  		goto oshr_free;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  392  	smb2_set_next_command(tcon, &rqst[0]);
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  393  
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  394  	memset(&qi_iov, 0, sizeof(qi_iov));
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  395  	rqst[1].rq_iov = qi_iov;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  396  	rqst[1].rq_nvec = 1;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  397  
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  398  	rc = SMB2_query_info_init(tcon, server,
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  399  				  &rqst[1], COMPOUND_FID,
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  400  				  COMPOUND_FID, FILE_ALL_INFORMATION,
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  401  				  SMB2_O_INFO_FILE, 0,
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  402  				  sizeof(struct smb2_file_all_info) +
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  403  				  PATH_MAX * 2, 0, NULL);
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  404  	if (rc)
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  405  		goto oshr_free;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  406  
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  407  	smb2_set_related(&rqst[1]);
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  408  
4f1fffa2376922 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  409  	if (retries) {
4f1fffa2376922 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  410  		smb2_set_replay(server, &rqst[0]);
4f1fffa2376922 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  411  		smb2_set_replay(server, &rqst[1]);
4f1fffa2376922 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  412  	}
4f1fffa2376922 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  413  
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  414  	rc = compound_send_recv(xid, ses, server,
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  415  				flags, 2, rqst,
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  416  				resp_buftype, rsp_iov);
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  417  	if (rc) {
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  418  		if (rc == -EREMCHG) {
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  419  			tcon->need_reconnect = true;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  420  			pr_warn_once("server share %s deleted\n",
68e14569d7e5a1 fs/cifs/cached_dir.c       Steve French      2022-09-21  421  				     tcon->tree_name);
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  422  		}
ebe98f1447bbcc fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-10-06  423  		goto oshr_free;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  424  	}
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  425  
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  426  	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  427  	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  428  	oparms.fid->volatile_fid = o_rsp->VolatileFileId;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  429  #ifdef CONFIG_CIFS_DEBUG2
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  430  	oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  431  #endif /* CIFS_DEBUG2 */
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  432  
af1689a9b7701d fs/smb/client/cached_dir.c Paulo Alcantara   2023-12-11  433  
5c86919455c1ed fs/smb/client/cached_dir.c Paulo Alcantara   2023-10-30  434  	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
af1689a9b7701d fs/smb/client/cached_dir.c Paulo Alcantara   2023-12-11  435  		rc = -EINVAL;
ebe98f1447bbcc fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-10-06  436  		goto oshr_free;
5c86919455c1ed fs/smb/client/cached_dir.c Paulo Alcantara   2023-10-30  437  	}
ebe98f1447bbcc fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-10-06  438  
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  439  	rc = smb2_parse_contexts(server, rsp_iov, &oparms.fid->epoch, oparms.fid->lease_key,
af1689a9b7701d fs/smb/client/cached_dir.c Paulo Alcantara   2023-12-11  440  				 &oplock, NULL, NULL);
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  441  	if (rc)
af1689a9b7701d fs/smb/client/cached_dir.c Paulo Alcantara   2023-12-11  442  		goto oshr_free;
af1689a9b7701d fs/smb/client/cached_dir.c Paulo Alcantara   2023-12-11  443  
af1689a9b7701d fs/smb/client/cached_dir.c Paulo Alcantara   2023-12-11  444  	rc = -EINVAL;
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  445  	if (!(oplock & SMB2_LEASE_READ_CACHING_HE))
66d45ca1350a3b fs/cifs/cached_dir.c       Ronnie Sahlberg   2023-02-17  446  		goto oshr_free;
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  447  
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  448  	qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  449  	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
ebe98f1447bbcc fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-10-06  450  		goto oshr_free;
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  451  
ff1e8e71b1ac5d fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  452  	if (!smb2_validate_and_copy_iov(le16_to_cpu(qi_rsp->OutputBufferOffset),
ff1e8e71b1ac5d fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  453  					sizeof(struct smb2_file_all_info), &rsp_iov[1],
ff1e8e71b1ac5d fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  454  					sizeof(struct smb2_file_all_info), (char *)&info)) {
ff1e8e71b1ac5d fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  455  		cfid->file_all_info = kmemdup(&info, sizeof(info), GFP_ATOMIC);
ff1e8e71b1ac5d fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  456  		if (!cfid->file_all_info) {
ff1e8e71b1ac5d fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  457  			rc = -ENOMEM;
ff1e8e71b1ac5d fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  458  			goto out;
ff1e8e71b1ac5d fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  459  		}
ff1e8e71b1ac5d fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  460  	}
e4029e072673d8 fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-10-12  461  
5c86919455c1ed fs/smb/client/cached_dir.c Paulo Alcantara   2023-10-30  462  	rc = 0;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  463  oshr_free:
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  464  	SMB2_open_free(&rqst[0]);
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  465  	SMB2_query_info_free(&rqst[1]);
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  466  	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  467  	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
a9685b409a03b7 fs/smb/client/cached_dir.c Paul Aurich       2024-11-18  468  out:
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  469  	/* cfid only becomes fully valid below, so can't use cfid_is_valid() here */
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  470  	if (!rc && cfid->ctime == CFID_INVALID_TIME)
a43689b1b41ccc fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  471  		rc = -ENOENT;
a9685b409a03b7 fs/smb/client/cached_dir.c Paul Aurich       2024-11-18  472  
a43689b1b41ccc fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  473  	if (rc) {
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  474  		dput(dentry);
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  475  
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  476  		if (cfid)
a43689b1b41ccc fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29 @477  			drop_cfid(cfid);
5c86919455c1ed fs/smb/client/cached_dir.c Paulo Alcantara   2023-10-30  478  	} else {
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  479  		/* seqlocked-write will inform concurrent lookups of opening -> open transition */
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29 @480  		write_seqlock(&cfid->seqlock);
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  481  		cfid->dentry = dentry;
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  482  		cfid->ctime = jiffies;
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  483  		cfid->atime = jiffies;
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  484  		write_sequnlock(&cfid->seqlock);
9faca5c38f7815 fs/smb/client/cached_dir.c Enzo Matsumiya    2025-09-29  485  
a63ec83c462b5b fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-11  486  		*ret_cfid = cfid;
66d45ca1350a3b fs/cifs/cached_dir.c       Ronnie Sahlberg   2023-02-17  487  		atomic_inc(&tcon->num_remote_opens);
66d45ca1350a3b fs/cifs/cached_dir.c       Ronnie Sahlberg   2023-02-17  488  	}
5c86919455c1ed fs/smb/client/cached_dir.c Paulo Alcantara   2023-10-30  489  	kfree(utf16_path);
64cc377b7628b8 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  490  
4f1fffa2376922 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  491  	if (is_replayable_error(rc) &&
4f1fffa2376922 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  492  	    smb2_should_replay(tcon, &retries, &cur_sleep))
4f1fffa2376922 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  493  		goto replay_again;
4f1fffa2376922 fs/smb/client/cached_dir.c Shyam Prasad N    2024-01-21  494  
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  495  	return rc;
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  496  }
05b98fd2da6bdf fs/cifs/cached_dir.c       Ronnie Sahlberg   2022-08-10  497  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
