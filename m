Return-Path: <SRS0=Vjzw=Y4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C300ECA9ECF
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Nov 2019 07:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94AD42190F
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Nov 2019 07:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfKDH7T (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 Nov 2019 02:59:19 -0500
Received: from mga07.intel.com ([134.134.136.100]:43228 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbfKDH7T (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 4 Nov 2019 02:59:19 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Nov 2019 23:59:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,266,1569308400"; 
   d="scan'208";a="213455770"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 03 Nov 2019 23:59:16 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iRXGe-000I1c-Fc; Mon, 04 Nov 2019 15:59:16 +0800
Date:   Mon, 4 Nov 2019 15:59:09 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Aurelien Aptel <aaptel@suse.com>
Cc:     kbuild-all@lists.01.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        Steve French <stfrench@microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: [cifs:for-next 18/20] fs/cifs/smb2transport.c:52:1: sparse: sparse:
 symbol 'smb3_crypto_shash_allocate' was not declared. Should it be static?
Message-ID: <201911041524.o7kWSYSC%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   3c652dd9928737b82a74b3ce8483c7497885eb04
commit: 4d1cc0309f7ec007b5b29f1350e3b1c105e86439 [18/20] cifs: try opening channels after mounting
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-6-g57f8611-dirty
        git checkout 4d1cc0309f7ec007b5b29f1350e3b1c105e86439
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> fs/cifs/smb2transport.c:52:1: sparse: sparse: symbol 'smb3_crypto_shash_allocate' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
