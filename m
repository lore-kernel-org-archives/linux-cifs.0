Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6529EB64DC
	for <linux-cifs@archiver.kernel.org>; Wed, 19 Jul 2023 00:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjGSAvF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Jul 2023 20:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjGSAup (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Jul 2023 20:50:45 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D091FDD
        for <linux-cifs@vger.kernel.org>; Tue, 18 Jul 2023 17:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689727825; x=1721263825;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NLYp821Xog/YiOvkjYk0MI/9pRUxQRtsFPmT4GhhPqM=;
  b=Pj4VhqRFUUW8BCQ70ghEWyRpmmMH4IrhINKKz6hE6iAxMk8pq9QBAL2C
   rKXOSuqPkKC/MSLy/zH4/pMzsmcEENx3oAa62azbg0guqniN8dBdIhzux
   OJcp7jXFmYWJKhg66DuUasg4DBYfL0lKs9W6UHMp95tl1rhsZmsmfrJlv
   KLq3wMrVLvD6zMH8gi5xIik8lornBRvxvLJHyroQBARjZY43IfMCn9fAm
   yQR0eWbA2aXWPn7osYNHt/L/CI0SglpxJIbuLVTKD96MPEKzX1ofPjhyp
   n0LKxVMd8TTYxWJXWdpot1EECtr1/YFj4qaGp1tZEGBF47/K8RGYKWy/c
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="365226441"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="365226441"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 17:50:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="847881331"
X-IronPort-AV: E=Sophos;i="6.01,215,1684825200"; 
   d="scan'208";a="847881331"
Received: from lkp-server02.sh.intel.com (HELO 36946fcf73d7) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 18 Jul 2023 17:50:21 -0700
Received: from kbuild by 36946fcf73d7 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qLvOB-0003zr-2g;
        Wed, 19 Jul 2023 00:50:05 +0000
Date:   Wed, 19 Jul 2023 08:48:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Winston Wen <wentao@uniontech.com>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, pc@manguebit.com, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Winston Wen <wentao@uniontech.com>
Subject: Re: [PATCH v2] cifs: fix charset issue in reconnection
Message-ID: <202307190835.WUgCXW8a-lkp@intel.com>
References: <20230718012437.1841868-1-wentao@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230718012437.1841868-1-wentao@uniontech.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Winston,

kernel test robot noticed the following build errors:

[auto build test ERROR on cifs/for-next]
[also build test ERROR on linus/master v6.5-rc2 next-20230718]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Winston-Wen/cifs-fix-charset-issue-in-reconnection/20230718-195832
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
patch link:    https://lore.kernel.org/r/20230718012437.1841868-1-wentao%40uniontech.com
patch subject: [PATCH v2] cifs: fix charset issue in reconnection
config: i386-randconfig-i011-20230718 (https://download.01.org/0day-ci/archive/20230719/202307190835.WUgCXW8a-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce: (https://download.01.org/0day-ci/archive/20230719/202307190835.WUgCXW8a-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202307190835.WUgCXW8a-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/smb/client/connect.c:2293:28: error: passing 'const char *' to parameter of type 'char *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
           ses->local_nls = load_nls(ctx->local_nls->charset);
                                     ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/nls.h:50:41: note: passing argument to parameter here
   extern struct nls_table *load_nls(char *);
                                           ^
   1 error generated.


vim +2293 fs/smb/client/connect.c

  2190	
  2191	/**
  2192	 * cifs_get_smb_ses - get a session matching @ctx data from @server
  2193	 * @server: server to setup the session to
  2194	 * @ctx: superblock configuration context to use to setup the session
  2195	 *
  2196	 * This function assumes it is being called from cifs_mount() where we
  2197	 * already got a server reference (server refcount +1). See
  2198	 * cifs_get_tcon() for refcount explanations.
  2199	 */
  2200	struct cifs_ses *
  2201	cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
  2202	{
  2203		int rc = 0;
  2204		unsigned int xid;
  2205		struct cifs_ses *ses;
  2206		struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
  2207		struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&server->dstaddr;
  2208	
  2209		xid = get_xid();
  2210	
  2211		ses = cifs_find_smb_ses(server, ctx);
  2212		if (ses) {
  2213			cifs_dbg(FYI, "Existing smb sess found (status=%d)\n",
  2214				 ses->ses_status);
  2215	
  2216			spin_lock(&ses->chan_lock);
  2217			if (cifs_chan_needs_reconnect(ses, server)) {
  2218				spin_unlock(&ses->chan_lock);
  2219				cifs_dbg(FYI, "Session needs reconnect\n");
  2220	
  2221				mutex_lock(&ses->session_mutex);
  2222				rc = cifs_negotiate_protocol(xid, ses, server);
  2223				if (rc) {
  2224					mutex_unlock(&ses->session_mutex);
  2225					/* problem -- put our ses reference */
  2226					cifs_put_smb_ses(ses);
  2227					free_xid(xid);
  2228					return ERR_PTR(rc);
  2229				}
  2230	
  2231				rc = cifs_setup_session(xid, ses, server,
  2232							ctx->local_nls);
  2233				if (rc) {
  2234					mutex_unlock(&ses->session_mutex);
  2235					/* problem -- put our reference */
  2236					cifs_put_smb_ses(ses);
  2237					free_xid(xid);
  2238					return ERR_PTR(rc);
  2239				}
  2240				mutex_unlock(&ses->session_mutex);
  2241	
  2242				spin_lock(&ses->chan_lock);
  2243			}
  2244			spin_unlock(&ses->chan_lock);
  2245	
  2246			/* existing SMB ses has a server reference already */
  2247			cifs_put_tcp_session(server, 0);
  2248			free_xid(xid);
  2249			return ses;
  2250		}
  2251	
  2252		rc = -ENOMEM;
  2253	
  2254		cifs_dbg(FYI, "Existing smb sess not found\n");
  2255		ses = sesInfoAlloc();
  2256		if (ses == NULL)
  2257			goto get_ses_fail;
  2258	
  2259		/* new SMB session uses our server ref */
  2260		ses->server = server;
  2261		if (server->dstaddr.ss_family == AF_INET6)
  2262			sprintf(ses->ip_addr, "%pI6", &addr6->sin6_addr);
  2263		else
  2264			sprintf(ses->ip_addr, "%pI4", &addr->sin_addr);
  2265	
  2266		if (ctx->username) {
  2267			ses->user_name = kstrdup(ctx->username, GFP_KERNEL);
  2268			if (!ses->user_name)
  2269				goto get_ses_fail;
  2270		}
  2271	
  2272		/* ctx->password freed at unmount */
  2273		if (ctx->password) {
  2274			ses->password = kstrdup(ctx->password, GFP_KERNEL);
  2275			if (!ses->password)
  2276				goto get_ses_fail;
  2277		}
  2278		if (ctx->domainname) {
  2279			ses->domainName = kstrdup(ctx->domainname, GFP_KERNEL);
  2280			if (!ses->domainName)
  2281				goto get_ses_fail;
  2282		}
  2283	
  2284		strscpy(ses->workstation_name, ctx->workstation_name, sizeof(ses->workstation_name));
  2285	
  2286		if (ctx->domainauto)
  2287			ses->domainAuto = ctx->domainauto;
  2288		ses->cred_uid = ctx->cred_uid;
  2289		ses->linux_uid = ctx->linux_uid;
  2290	
  2291		ses->sectype = ctx->sectype;
  2292		ses->sign = ctx->sign;
> 2293		ses->local_nls = load_nls(ctx->local_nls->charset);
  2294	
  2295		/* add server as first channel */
  2296		spin_lock(&ses->chan_lock);
  2297		ses->chans[0].server = server;
  2298		ses->chan_count = 1;
  2299		ses->chan_max = ctx->multichannel ? ctx->max_channels:1;
  2300		ses->chans_need_reconnect = 1;
  2301		spin_unlock(&ses->chan_lock);
  2302	
  2303		mutex_lock(&ses->session_mutex);
  2304		rc = cifs_negotiate_protocol(xid, ses, server);
  2305		if (!rc)
  2306			rc = cifs_setup_session(xid, ses, server, ctx->local_nls);
  2307		mutex_unlock(&ses->session_mutex);
  2308	
  2309		/* each channel uses a different signing key */
  2310		spin_lock(&ses->chan_lock);
  2311		memcpy(ses->chans[0].signkey, ses->smb3signingkey,
  2312		       sizeof(ses->smb3signingkey));
  2313		spin_unlock(&ses->chan_lock);
  2314	
  2315		if (rc)
  2316			goto get_ses_fail;
  2317	
  2318		/*
  2319		 * success, put it on the list and add it as first channel
  2320		 * note: the session becomes active soon after this. So you'll
  2321		 * need to lock before changing something in the session.
  2322		 */
  2323		spin_lock(&cifs_tcp_ses_lock);
  2324		ses->dfs_root_ses = ctx->dfs_root_ses;
  2325		if (ses->dfs_root_ses)
  2326			ses->dfs_root_ses->ses_count++;
  2327		list_add(&ses->smb_ses_list, &server->smb_ses_list);
  2328		spin_unlock(&cifs_tcp_ses_lock);
  2329	
  2330		cifs_setup_ipc(ses, ctx);
  2331	
  2332		free_xid(xid);
  2333	
  2334		return ses;
  2335	
  2336	get_ses_fail:
  2337		sesInfoFree(ses);
  2338		free_xid(xid);
  2339		return ERR_PTR(rc);
  2340	}
  2341	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
