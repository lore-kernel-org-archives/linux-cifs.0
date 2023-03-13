Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57363C6FD19
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Mar 2023 06:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjCMGJv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Mar 2023 02:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCMGJq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 Mar 2023 02:09:46 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5BF37B7F
        for <linux-cifs@vger.kernel.org>; Sun, 12 Mar 2023 23:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678687785; x=1710223785;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UTWSxpQ2QGeZJSUsj4ujFPfig9PIr6xPySKRUXSA88Y=;
  b=gHeridx5+43fpwFCbwoesTOY7CBCsN9gHnCDBj/2tLtg0PH4LtoU2cR2
   AUj4CKJnu8CWnskxwM3KR/kQL8kUa8hv8VKJINsJlcXBCgYivM21jLoyS
   9hZiOALwqWmLLuShMfGcCV7FILWMV4+76G85FhjTDFc6CTpa51acCB9Mo
   uiXEuJO20Hmwuvwy4uGoDtOLaTZssDudMoZ1IbEuG7BM5qvq/wYb1ea/6
   6EWdGWgg81UAZnWDMPA+3akdqUzQWxgZtj0aEVF/JMjEZRh3XjqzOM1ev
   5Zrb0pw2H6eQmN5cvQYhRV+6pXtFadffs2ej+K5seAMD9lHNEFnpBkJDq
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="334545442"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="334545442"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 23:09:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="924380873"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="924380873"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 12 Mar 2023 23:09:43 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pbbNO-0005Iw-24;
        Mon, 13 Mar 2023 06:09:42 +0000
Date:   Mon, 13 Mar 2023 14:09:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>, smfrench@gmail.com,
        bharathsm.hsk@gmail.com, pc@cjr.nz, tom@talpey.com,
        linux-cifs@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev,
        Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 10/11] cifs: handle when server stops supporting
 multichannel
Message-ID: <202303131424.W2jbbLmc-lkp@intel.com>
References: <20230310153211.10982-10-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310153211.10982-10-sprasad@microsoft.com>
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
patch link:    https://lore.kernel.org/r/20230310153211.10982-10-sprasad%40microsoft.com
patch subject: [PATCH 10/11] cifs: handle when server stops supporting multichannel
config: i386-randconfig-m021 (https://download.01.org/0day-ci/archive/20230313/202303131424.W2jbbLmc-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303131424.W2jbbLmc-lkp@intel.com/

New smatch warnings:
fs/cifs/sess.c:299 cifs_disable_extra_channels() warn: unsigned '--iface->weight_fulfilled' is never less than zero.

Old smatch warnings:
fs/cifs/sess.c:401 cifs_chan_update_iface() warn: unsigned '--old_iface->weight_fulfilled' is never less than zero.
fs/cifs/sess.c:412 cifs_chan_update_iface() warn: unsigned '--old_iface->weight_fulfilled' is never less than zero.

vim +299 fs/cifs/sess.c

   276	
   277	/*
   278	 * called when multichannel is disabled by the server
   279	 */
   280	void
   281	cifs_disable_extra_channels(struct cifs_ses *ses)
   282	{
   283		int i, chan_count;
   284		struct cifs_server_iface *iface = NULL;
   285		struct TCP_Server_Info *server = NULL;
   286	
   287		spin_lock(&ses->chan_lock);
   288		chan_count = ses->chan_count;
   289		ses->chan_count = 1;
   290		for (i = 1; i < chan_count; i++) {
   291			iface = ses->chans[i].iface;
   292			server = ses->chans[i].server;
   293			spin_unlock(&ses->chan_lock);
   294	
   295			if (iface) {
   296				spin_lock(&ses->iface_lock);
   297				kref_put(&iface->refcount, release_iface);
   298				iface->num_channels--;
 > 299				if (--iface->weight_fulfilled < 0)
   300					iface->weight_fulfilled = 0;
   301				spin_unlock(&ses->iface_lock);
   302			}
   303			cifs_put_tcp_session(server, 0);
   304	
   305			spin_lock(&ses->chan_lock);
   306			ses->chans[i].iface = NULL;
   307			ses->chans[i].server = NULL;
   308		}
   309		spin_unlock(&ses->chan_lock);
   310	}
   311	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
