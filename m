Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF0C2EB64DC
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Jun 2023 01:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjF1B4D (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Jun 2023 21:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjF1B4D (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Jun 2023 21:56:03 -0400
Received: from mx.treblig.org (unknown [IPv6:2a00:1098:5b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0512111
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jun 2023 18:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
        ; s=bytemarkmx; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:
        Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/t+hzQ8Pm+b2ZR3QQ9D2F2A8v6xsZAM4Ss0JjxqOWl4=; b=EONVGkOAu/sT8l37mD9oCtWGV9
        WfOelj9ECgO5UHOdQ8RrQqzPbpRxfQVVYsbCJqMrzn0r2QyfM0HVZ+pwtLftwaJOTEsDcioJAk+Te
        BVuEoxPdUR6ZgALVkw+yuKCHbiuBqyb1FzALS/44k1kMomHmUnjlOPZBavSVDwaFg3Cn1VPfk5sBO
        XzrHEBcEVqiIFu2HFvnrAvnAWDbEXqIf2yemnjlw3t8QFFlu5FxxslYbrnPJSAxUAs04NLiqFdmY5
        V45qL/Fyh7uDkypEmScJf84URp/B3YitxCYOINuXlQYkb4DPdq8TaufTR/xuokrdyJsqkg2v300jK
        2eV/ysfQ==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
        by mx.treblig.org with esmtp (Exim 4.94.2)
        (envelope-from <linux@treblig.org>)
        id 1qEJlx-00GNA7-2t; Wed, 28 Jun 2023 01:15:03 +0000
From:   linux@treblig.org
To:     sfrench@samba.org, linkinjeon@kernel.org,
        linux-cifs@vger.kernel.org
Cc:     jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 0/3] dedupe smb unicode files
Date:   Wed, 28 Jun 2023 02:14:36 +0100
Message-ID: <20230628011439.159678-1-linux@treblig.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: "Dr. David Alan Gilbert" <linux@treblig.org>

The smb client and server code have (mostly) duplicated code
for unicode manipulation, in particular upper case handling.

Flatten this lot into shared code.

There's some code that's slightly different between the two, and
I've not attempted to share that - this should be strictly a no
behaviour change set.

I'd love to also boil out the same code from fs/jfs/ - but that's
a thought for another time (and harder since there's no good test
for it).

Lightly tested with a module and a monolithic build, and just mounting
itself.

This dupe was found using PMD:
  https://pmd.github.io/pmd/pmd_userdocs_cpd.html

Dave

Dr. David Alan Gilbert (3):
  fs/smb: Remove unicode 'lower' tables
  fs/smb: Swing unicode common code from server->common
  fs/smb/client: Use common code in client

 fs/smb/client/cifs_unicode.c                  |   1 -
 fs/smb/client/cifs_unicode.h                  | 313 +-----------------
 fs/smb/client/cifs_uniupr.h                   | 239 -------------
 fs/smb/common/Makefile                        |   1 +
 .../uniupr.h => common/cifs_unicode_common.c} | 156 +--------
 fs/smb/common/cifs_unicode_common.h           | 279 ++++++++++++++++
 fs/smb/server/unicode.c                       |   1 -
 fs/smb/server/unicode.h                       | 301 +----------------
 8 files changed, 298 insertions(+), 993 deletions(-)
 delete mode 100644 fs/smb/client/cifs_uniupr.h
 rename fs/smb/{server/uniupr.h => common/cifs_unicode_common.c} (50%)
 create mode 100644 fs/smb/common/cifs_unicode_common.h

-- 
2.41.0

