Return-Path: <SRS0=wT+4=BO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE7AFC433DF
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Aug 2020 23:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9513320792
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Aug 2020 23:01:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="irAe9p2u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgHDXBI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Aug 2020 19:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbgHDXBG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 Aug 2020 19:01:06 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2FDC06174A
        for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2020 16:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=BjIPXPsEY1+fBfym6eKtVHOmUukMG9y+tzxk4WidEQ4=; b=irAe9p2utg2KNankSP2+sxcfIH
        Ljr9e650RAAFjo7PRA27Vk4rUhyAg2vcn4pbTZno0TcDN2f6kFv7ulAEXRoSst7ZJNuBccEwJCoEK
        B+Wg3LUyJcqNlzdeFoysfwla2QinGCO6P1PwQX7xhPPBQcI18iSjK8GeGkxP9eNcGJg8H4XjEWuCH
        Mm/WzV1Nr5qkQ4deZNI76GBWV05yAS6PplFzkefCFCHQDNRJA2wS2W0PjU77TTkHJfHQPeosMaNSI
        vE652ILCi9gsmg2tgvAeOpZrMUi0QwLTN2prJ1LURgE47+QjIXzfyBy88wcWM+51HA3lBVTMy+frC
        33SSbRH/Vjhnk/eKoxOYTyk0X6/VeDtxvmGAT7ggVGEHqDNt/XKzolCSt5bWB48wMq0P331cE8hD1
        LB5sl+CgmqNsShvpXXsuh1xfl0k1JZ4Jl8FChHusawQpUZ1HayuV+EB+Ddo8J3wXlhY+oOvjkOfvo
        5UsCeSOho0sAcMAiFhGqnNBC;
Received: from [2a01:4f8:192:486::6:0] (port=49880 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k35vX-0005j2-0K
        for cifs-qa@samba.org; Tue, 04 Aug 2020 23:00:59 +0000
Received: from [::1] (port=35840 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k35vW-008ISB-Gd
        for cifs-qa@samba.org; Tue, 04 Aug 2020 23:00:58 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13795] Race condition in fs/cifs/connect.c causing "has not
 responded in 120 seconds. Reconnecting..."
Date:   Tue, 04 Aug 2020 23:00:58 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: piastryyy@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-13795-10630-3TIbXgD7ZQ@https.bugzilla.samba.org/>
In-Reply-To: <bug-13795-10630@https.bugzilla.samba.org/>
References: <bug-13795-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13795

--- Comment #3 from Pavel Shilovsky <piastryyy@gmail.com> ---
The fix went into 5.3-rc1 (mainline) and 5.2.7, 4.19.65,  4.14.137, 4.9.224,
4.4.224 (stable) kernel versions.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
