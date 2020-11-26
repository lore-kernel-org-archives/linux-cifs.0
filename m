Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03116C56201
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Nov 2020 00:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5699920770
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Nov 2020 00:37:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="mCVUMLig";
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="mCVUMLig"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgKZAhi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Nov 2020 19:37:38 -0500
Received: from papylos.uuid.uk ([209.16.157.42]:42382 "EHLO papylos.uuid.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgKZAhh (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 25 Nov 2020 19:37:37 -0500
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Nov 2020 19:37:36 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Subject:From:To:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc
        :MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:
        In-Reply-To:References; bh=eQ0MAeL84S9BcElcCytiLjMykojH3FizOgNZMtaj9/A=; b=mC
        VUMLigDpNE+xYvdtJBQKiPVWUB9eLRnhIuaq+oVQEwA8j1r2Twghce8SlOn/bUOzl9v7ijRJFcRBy
        ankZK37BFl974RHLeUnf2THBkf9AcRrJs/RI552WCL/7S8Zu/lhcPaaA7CAI/P78Es74H0AwRRavc
        liVPCQ71LBo/Xl1J8w/49S5J1mEgYWZ9QipyBu0nxBr1n0htpoblYmK/J+gd/tWaEmDqDL/afj729
        XnC0UIJ9kkXxxCaZKjpFZMuiJkfqB+nzlps2sNl6VzoYcg7NlNymvol/GLw78TXC/7j/IoYk+nh0+
        KgD1c4LCgfi42VlZyZdJO07DyZeUvrQg==;
Received: by papylos.uuid.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <simon@octiron.net>)
        id 1ki58t-00031x-4Q
        for linux-cifs@vger.kernel.org; Thu, 26 Nov 2020 00:28:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Subject:From:To:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc
        :MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:
        In-Reply-To:References; bh=eQ0MAeL84S9BcElcCytiLjMykojH3FizOgNZMtaj9/A=; b=mC
        VUMLigDpNE+xYvdtJBQKiPVWUB9eLRnhIuaq+oVQEwA8j1r2Twghce8SlOn/bUOzl9v7ijRJFcRBy
        ankZK37BFl974RHLeUnf2THBkf9AcRrJs/RI552WCL/7S8Zu/lhcPaaA7CAI/P78Es74H0AwRRavc
        liVPCQ71LBo/Xl1J8w/49S5J1mEgYWZ9QipyBu0nxBr1n0htpoblYmK/J+gd/tWaEmDqDL/afj729
        XnC0UIJ9kkXxxCaZKjpFZMuiJkfqB+nzlps2sNl6VzoYcg7NlNymvol/GLw78TXC/7j/IoYk+nh0+
        KgD1c4LCgfi42VlZyZdJO07DyZeUvrQg==;
Received: by tsort.uuid.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <simon@octiron.net>)
        id 1ki58q-0001ho-8T
        for linux-cifs@vger.kernel.org; Thu, 26 Nov 2020 00:28:08 +0000
To:     linux-cifs@vger.kernel.org
From:   Simon Arlott <simon@octiron.net>
Subject: [PATCH] Add missing position handling to mount parameters
 gid/backup_gid/snapshot
X-Face: -|Y&Xues/.'(7\@`_\lFE/)pw"7..-Ur1^@pRL`Nad5a()6r+Y)18-pi'!`GI/zGn>6a6ik
 mcW-%sg_wM:4PXDw:(;Uu,n&!8=;A<P|QG`;AMu5ypJkN-Sa<eyt,Ap3q`5Z{D0BN3G`OmX^8x^++R
 Gr9G'%+PNM/w+w1+vB*a($wYgA%*cm3Hds`a7k)CQ7'"[\C|g2k]FQ-f*DDi{pU]v%5JZm
Message-ID: <2991484d-15b9-a846-565f-e86ccb83768d@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Date:   Thu, 26 Nov 2020 00:28:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The code tries to optimise for the last parameter not needing to update
the position which means that every time a new one is added to the end
by copying and pasting, the string position is not updated.

That makes it impossible to use backup_uid=/backup_gid=/snapshot= after
gid= or snapshot= after backup_gid= because part of the string is
overwritten and contains invalid keys like "gbackup_uid".

Prepare for the next parameter to be added on the end by updating the
position for snapshot= even though it will be unused.
---
 mount.cifs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mount.cifs.c b/mount.cifs.c
index 4feb397..a169bc6 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1229,6 +1229,7 @@ nocopy:
 			out_len++;
 		}
 		snprintf(out + out_len, word_len + 5, "gid=%s", txtbuf);
+		out_len = strlen(out);
 	}
 	if (got_bkupuid) {
 		word_len = snprintf(txtbuf, sizeof(txtbuf), "%u", bkupuid);
@@ -1260,6 +1261,7 @@ nocopy:
 			out_len++;
 		}
 		snprintf(out + out_len, word_len + 11, "backupgid=%s", txtbuf);
+		out_len = strlen(out);
 	}
 	if (got_snapshot) {
 		word_len = snprintf(txtbuf, sizeof(txtbuf), "%llu", snapshot);
@@ -1275,6 +1277,7 @@ nocopy:
 			out_len++;
 		}
 		snprintf(out + out_len, word_len + 11, "snapshot=%s", txtbuf);
+		out_len = strlen(out);
 	}
 
 	return 0;
-- 
2.17.1

-- 
Simon Arlott
