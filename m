Return-Path: <SRS0=f6oI=BQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9CB9C433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Aug 2020 21:47:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D7F72173E
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Aug 2020 21:47:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="aYbt6io5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgHFVrK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Aug 2020 17:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgHFVrJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Aug 2020 17:47:09 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051DCC061574
        for <linux-cifs@vger.kernel.org>; Thu,  6 Aug 2020 14:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=xraF0eb9AhOp4J8oZWNneh4RwFwPxxMMFR0FGCHNDJQ=; b=aYbt6io5Vg539lT6JbMB2KbKB3
        lwzE/ahxNO+6GqssyW0mCfE53G7MQq3m3Enq1jZ1zPR7GwcviYKiY+rt4JVBI1a39JhahQw85Zwk5
        /+DdPHCADK5QtFhBHPppUd4enaFWM54Yt/7WbzvbDTmVTTm5gvBnY85HsxExVPu+RJvmiTkSiNm/T
        ORNgF7MLa8HoEFUNw9AYLHmUcUuZLuFoGDLEi2vOTMUNE3zu20Xh2IL53asdnPPfNroWkPEYcb3UL
        WvGsYr762i6Xj1ibYw7lTG0bbnFjZgch9HJj5Ggs0K4Omcdl0SV4L6X/AR6p0DCMZkw33eFHnWK1U
        OZ86luGyxDrNqHf2aW449wK8rN0PYDmYWoBG5RArdCEAckKUDqTOwORxZjUWqCa8wWZOvWuP5bHAs
        kXM5dtQkMMLskFDB0FbZR+W2yAIHZ2eVc1xXfqQpabHxF0z6hsyPKoYi1Mn49y1N3jWhdJAyXNdSW
        J+/5l9tAqqK8McpAfm8qov+5;
Received: from [2a01:4f8:192:486::6:0] (port=50938 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1k3nj6-0004Tr-3r
        for cifs-qa@samba.org; Thu, 06 Aug 2020 21:47:04 +0000
Received: from [::1] (port=36890 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1k3nj5-008TU4-IU
        for cifs-qa@samba.org; Thu, 06 Aug 2020 21:47:03 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13795] Race condition in fs/cifs/connect.c causing "has not
 responded in 120 seconds. Reconnecting..."
Date:   Thu, 06 Aug 2020 21:47:02 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 3.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: piastryyy@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: FIXED
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: resolution bug_status
Message-ID: <bug-13795-10630-VdjZ1FKL0s@https.bugzilla.samba.org/>
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

Pavel Shilovsky <piastryyy@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Resolution|---                         |FIXED
             Status|NEW                         |RESOLVED

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
