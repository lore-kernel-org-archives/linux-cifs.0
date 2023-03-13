Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F685C6FD19
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Mar 2023 05:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjCMF2q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Mar 2023 01:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjCMF2p (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 Mar 2023 01:28:45 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DB81E9F4
        for <linux-cifs@vger.kernel.org>; Sun, 12 Mar 2023 22:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678685324; x=1710221324;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sXDtzBW1jKA12fgD4+/fQMpJCkVu/aK9bRPdLsnRdF0=;
  b=UySZQGhsvHJFlwred6vHsDR/H86/24aoyuOnO0ytyn+xDd2lkKLkFG4W
   qiRwFzovqb6j33AspvGEIr2Vh/Vy0pxcw322YgcSBqT+23tvTP5rFOKeR
   5Col1P3Vqb7e3DPC4dv56gtNNybJC9MG1+ayLTX9QIKPl5tLUgapUhR74
   SKlBTUNeCuMbnXEa/l9wCHPeWC/m0lr+i2vFeHz0D/u8xr1+1wr/rs8XU
   gjzLTbO6C3z73nXOkuJb315qQL3tOpXJ0pdFwYIezGSNMydIOR8fzIPK6
   uP0wox0jEbF0HBgVhLNnAGj0vB+ZW87EzMwc3Oe0ohkmZlsjYdoDxAVKg
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="337085151"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="337085151"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 22:28:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="1007859043"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="1007859043"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 12 Mar 2023 22:28:41 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pbajh-0005HG-0Q;
        Mon, 13 Mar 2023 05:28:41 +0000
Date:   Mon, 13 Mar 2023 13:27:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>, smfrench@gmail.com,
        bharathsm.hsk@gmail.com, pc@cjr.nz, tom@talpey.com,
        linux-cifs@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev,
        Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 09/11] cifs: account for primary channel in the interface
 list
Message-ID: <202303131349.VOlTuw2U-lkp@intel.com>
References: <20230310153211.10982-9-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310153211.10982-9-sprasad@microsoft.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Shyam,

I love your patch! Perhaps something to improve:

[auto build test WARNING on cifs/for-next]
[also build test WARNING on linus/master v6.3-rc2 next-20230310]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shyam-Prasad-N/cifs-generate-signkey-for-the-channel-that-s-reconnecting/20230310-234711
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
patch link:    https://lore.kernel.org/r/20230310153211.10982-9-sprasad%40microsoft.com
patch subject: [PATCH 09/11] cifs: account for primary channel in the interface list
config: i386-randconfig-m021 (https://download.01.org/0day-ci/archive/20230313/202303131349.VOlTuw2U-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303131349.VOlTuw2U-lkp@intel.com/

New smatch warnings:
fs/cifs/sess.c:366 cifs_chan_update_iface() warn: unsigned '--old_iface->weight_fulfilled' is never less than zero.

Old smatch warnings:
fs/cifs/sess.c:377 cifs_chan_update_iface() warn: unsigned '--old_iface->weight_fulfilled' is never less than zero.

vim +366 fs/cifs/sess.c

   276	
   277	/*
   278	 * update the iface for the channel if necessary.
   279	 * will return 0 when iface is updated, 1 if removed, 2 otherwise
   280	 * Must be called with chan_lock held.
   281	 */
   282	int
   283	cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
   284	{
   285		unsigned int chan_index;
   286		size_t iface_weight = 0, iface_min_speed = 0;
   287		struct cifs_server_iface *iface = NULL;
   288		struct cifs_server_iface *old_iface = NULL;
   289		struct cifs_server_iface *last_iface = NULL;
   290		int rc = 0;
   291	
   292		spin_lock(&ses->chan_lock);
   293		chan_index = cifs_ses_get_chan_index(ses, server);
   294		if (ses->chans[chan_index].iface) {
   295			old_iface = ses->chans[chan_index].iface;
   296			if (old_iface->is_active) {
   297				spin_unlock(&ses->chan_lock);
   298				return 1;
   299			}
   300		}
   301		spin_unlock(&ses->chan_lock);
   302	
   303		spin_lock(&ses->iface_lock);
   304		if (!ses->iface_count) {
   305			spin_unlock(&ses->iface_lock);
   306			cifs_dbg(VFS, "server %s does not advertise interfaces\n", ses->server->hostname);
   307			return 0;
   308		}
   309	
   310		last_iface = list_last_entry(&ses->iface_list, struct cifs_server_iface,
   311					     iface_head);
   312		iface_min_speed = last_iface->speed;
   313	
   314		/* then look for a new one */
   315		list_for_each_entry(iface, &ses->iface_list, iface_head) {
   316			if (!chan_index) {
   317				/* if we're trying to get the updated iface for primary channel */
   318				if (!cifs_match_ipaddr((struct sockaddr *) &server->dstaddr,
   319						       (struct sockaddr *) &iface->sockaddr))
   320					continue;
   321	
   322				kref_get(&iface->refcount);
   323				break;
   324			}
   325	
   326			/* do not mix rdma and non-rdma interfaces */
   327			if (iface->rdma_capable != server->rdma)
   328				continue;
   329	
   330			if (!iface->is_active ||
   331			    (is_ses_using_iface(ses, iface) &&
   332			     !iface->rss_capable)) {
   333				continue;
   334			}
   335	
   336			/* check if we already allocated enough channels */
   337			iface_weight = iface->speed / iface_min_speed;
   338	
   339			if (iface->weight_fulfilled >= iface_weight)
   340				continue;
   341	
   342			kref_get(&iface->refcount);
   343			break;
   344		}
   345	
   346		if (list_entry_is_head(iface, &ses->iface_list, iface_head)) {
   347			rc = 1;
   348			iface = NULL;
   349			cifs_dbg(FYI, "unable to find a suitable iface\n");
   350		}
   351	
   352		if (!chan_index && !iface) {
   353			cifs_dbg(VFS, "unable to get the interface matching: %pIS\n",
   354				 &server->dstaddr);
   355			spin_unlock(&ses->iface_lock);
   356			return 0;
   357		}
   358	
   359		/* now drop the ref to the current iface */
   360		if (old_iface && iface) {
   361			cifs_dbg(FYI, "replacing iface: %pIS with %pIS\n",
   362				 &old_iface->sockaddr,
   363				 &iface->sockaddr);
   364	
   365			old_iface->num_channels--;
 > 366			if (--old_iface->weight_fulfilled < 0)
   367				old_iface->weight_fulfilled = 0;
   368			iface->num_channels++;
   369			iface->weight_fulfilled++;
   370	
   371			kref_put(&old_iface->refcount, release_iface);
   372		} else if (old_iface) {
   373			cifs_dbg(FYI, "releasing ref to iface: %pIS\n",
   374				 &old_iface->sockaddr);
   375	
   376			old_iface->num_channels--;
   377			if (--old_iface->weight_fulfilled < 0)
   378				old_iface->weight_fulfilled = 0;
   379	
   380			kref_put(&old_iface->refcount, release_iface);
   381		} else if (!chan_index) {
   382			/* special case: update interface for primary channel */
   383			cifs_dbg(FYI, "referencing primary channel iface: %pIS\n",
   384				 &iface->sockaddr);
   385			iface->num_channels++;
   386			iface->weight_fulfilled++;
   387		} else {
   388			WARN_ON(!iface);
   389			cifs_dbg(FYI, "adding new iface: %pIS\n", &iface->sockaddr);
   390		}
   391		spin_unlock(&ses->iface_lock);
   392	
   393		spin_lock(&ses->chan_lock);
   394		chan_index = cifs_ses_get_chan_index(ses, server);
   395		ses->chans[chan_index].iface = iface;
   396	
   397		/* No iface is found. if secondary chan, drop connection */
   398		if (!iface && CIFS_SERVER_IS_CHAN(server))
   399			ses->chans[chan_index].server = NULL;
   400	
   401		spin_unlock(&ses->chan_lock);
   402	
   403		if (!iface && CIFS_SERVER_IS_CHAN(server))
   404			cifs_put_tcp_session(server, false);
   405	
   406		return rc;
   407	}
   408	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
