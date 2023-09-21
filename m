Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B3E5E7D0A6
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Sep 2023 19:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjIUTZU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Sep 2023 15:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjIUTZU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Sep 2023 15:25:20 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F51D3DFB
        for <linux-cifs@vger.kernel.org>; Thu, 21 Sep 2023 12:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=+rAaQ7NAMdmgpdy15uf/q/PmAkzYHXkxWY02y/axMmE=; b=vrLSbpuIYOqMk14QZ3b482yxu3
        1LzPRH6/+IG3geL4Lc0QVHUcCtjGtARgWs6a2JpN5cE/oACES+/dopd3TN3oA+Ei5kHZk1WgUQzKg
        6x9ARfHJ/rtdJZqi5T4ruqYlRrEw9OpUXugZIo3LRzLR+Q++eiDjEHeeNU/v9+/6dlmMyAiMM3LJz
        rs1ssTPKvIEz/czTgIeRiGn/xRfs1vmGUz2rlaM8nPCaAn5oQyJzaRZrJzRwm8TQUxS7HdGcrgAns
        mOAhpGZ/RNSKUzaZvUeiSrumNikt0D5A7cAxggEZBnuB4DOxV6VNLEnK2Ww/KtSRL2rYH3foVAKV+
        PJFBclgZSiegY4LewFwXdCCB8Gqj5E/AdeiDoy7TgakxvQpVmPOp3Mk5SmgT9NLQSR1cNZiaV/Z49
        1A/EaoclR+XAbgEgIc+JiJS3O7dUqjMW8nrJsfGeUWuOPUIAOfsax+uAIRG410je2A+ZYhnQ83ndD
        EfFQTIFwRJzSDcMQ/E7+t218;
Received: from [2a01:4f8:192:486::6:0] (port=59944 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qjE9U-00EdMY-1Q
        for cifs-qa@samba.org;
        Thu, 21 Sep 2023 07:31:08 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qjE9S-001RPK-Uz
        for cifs-qa@samba.org;
        Thu, 21 Sep 2023 07:31:07 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15480] Mounting Azure Fles Share using cifs-utils fails
Date:   Thu, 21 Sep 2023 07:31:05 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: sverrir.jonsson@thyssenkrupp-materials.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-15480-10630-OOJZbwUA20@https.bugzilla.samba.org/>
In-Reply-To: <bug-15480-10630@https.bugzilla.samba.org/>
References: <bug-15480-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D15480

--- Comment #2 from Yonz <sverrir.jonsson@thyssenkrupp-materials.com> ---
Sure. I'll give it a go later.

Ontoher thing we observed, is that when using the Storage Account Access Ke=
y,
we are able mount the Azure Share. However, when we use App Registration or=
 a
normal AADS User, it fails.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
