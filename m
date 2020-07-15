Return-Path: <SRS0=SAbX=A2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FE0C433E1
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jul 2020 01:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE78A20729
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jul 2020 01:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGOBMz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Jul 2020 21:12:55 -0400
Received: from mga07.intel.com ([134.134.136.100]:4018 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbgGOBMz (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 14 Jul 2020 21:12:55 -0400
IronPort-SDR: dqBnaYSpKzKAChd6mcmsoyumWz0xkyNtmcABpgbwbZ3SW4JUH5afdn3u5wA0enHSBbUQ3g/8d6
 BcYEJeGwokcA==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="213831945"
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="213831945"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 18:12:54 -0700
IronPort-SDR: dycBRId2Ng3BXYIQFnNRhoJfvJJ7Rcg0H2sedWdBNtQX0+7w8TGoXQAovjTL+duknX92ubMCsu
 eQgNGcVoMdSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="299722883"
Received: from lkp-server02.sh.intel.com (HELO 393d9bdf0d5c) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 14 Jul 2020 18:12:53 -0700
Received: from kbuild by 393d9bdf0d5c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1jvVyf-0000MF-92; Wed, 15 Jul 2020 01:12:53 +0000
Date:   Wed, 15 Jul 2020 09:11:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     kbuild-all@lists.01.org, Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [RFC PATCH] cifs: smb1: CIFSSMBSetPathInfoFB() can be static
Message-ID: <20200715011150.GA63636@afa5041d19c2>
References: <20200714221805.3459-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714221805.3459-1-lsahlber@redhat.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Signed-off-by: kernel test robot <lkp@intel.com>
---
 cifssmb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index eac525c1be5e9..c4420746fd3a1 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -5914,10 +5914,10 @@ CIFSSMBSetFileDisposition(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 int
-CIFSSMBSetPathInfoFB(const unsigned int xid, struct cifs_tcon *tcon,
-		     const char *fileName, const FILE_BASIC_INFO *data,
-		     const struct nls_table *nls_codepage,
-		     struct cifs_sb_info *cifs_sb)
+static CIFSSMBSetPathInfoFB(const unsigned int xid, struct cifs_tcon *tcon,
+			    const char *fileName, const FILE_BASIC_INFO *data,
+			    const struct nls_table *nls_codepage,
+			    struct cifs_sb_info *cifs_sb)
 {
 	int oplock = 0;
 	struct cifs_open_parms oparms;
