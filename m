Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38906ECAAD3
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Sep 2022 03:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiIND0U (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 23:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiIND0S (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 23:26:18 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A97252BB
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 20:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=hVufObpKUK8ZxbSdyZQybl3uyH1pfOMB9NCE4/GNdlk=; b=glN8/8Q2zTdbAY0fQb4buuVc/Z
        B0+zilqEZQnD/8P6N4D8QzmcHSRFM1dal5Dsj6qgfZDUO970SypNhBdbfH+tmdY2VDgfqGNJrg/Sm
        rJ1VrbxTaA8rqgHzVeTvxLOKxhsTQhbw/jM0TlCDOvTgoFFI+/iISMbrxTHFE08I1uovYsu4bRTAY
        +t0q63fIQHTmaIqgDUG7IrYHx0WyCqiFjzP97q81KCpnvZyKBG7wtM8CCjW+iqx0l31t5yQExVSJb
        IkbOKhpbKXGpK+HWxIdwG+uwvZ1CiuD30uoDsTlOTR0ubWMdcF/WN3N9CmqQyurcOINJ4Zr9c1R7d
        8fR6uA83swpNWwAb1cXodby/T+p7cVLJad941MB4BL06WTrcvOkahaddDJl/uHP3TT29X5vSzR+gf
        EYPN1b3iDRA0qzMXLaHYQYKAtJaow46CKsPePvB27T3qbapY8R5djPpb/3RC/C7EP6k7ZsaQnLS+n
        edxJV9hg/anBStQ9KZ2BA+Qd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oYJ2U-000HzW-1s; Wed, 14 Sep 2022 03:26:14 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 0/2] cifs: don't send uninitialized memory to sock_{send,recv}msg()
Date:   Wed, 14 Sep 2022 05:25:45 +0200
Message-Id: <cover.1663125352.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Passing just half initialized struct msghdr variables down to
sock_{send,recv}msg() means we're waiting for a disater to happen...

I added the removal of passing the destination address to
tcp as a separate patch in order to explain it separately.

Stefan Metzmacher (2):
  cifs: don't send down the destination address to sendmsg for a
    SOCK_STREAM
  cifs: always initialize struct msghdr smb_msg completely

 fs/cifs/connect.c   | 11 +++--------
 fs/cifs/transport.c |  6 +-----
 2 files changed, 4 insertions(+), 13 deletions(-)

-- 
2.34.1

