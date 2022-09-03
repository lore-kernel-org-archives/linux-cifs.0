Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38ABAECAAD4
	for <linux-cifs@archiver.kernel.org>; Sat,  3 Sep 2022 14:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiICORr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 3 Sep 2022 10:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiICORq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 3 Sep 2022 10:17:46 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497EA120BC
        for <linux-cifs@vger.kernel.org>; Sat,  3 Sep 2022 07:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=moh9C90Cusd6MvyttpxZ/LjKb4VKc1fulaLZ9RgQYRw=; b=w9iDqAc2KF/EcYiJo7mYii6Ub8
        /CatBgmP6Bu3AQmDymCHTDukvemoPKB80c4LPUaX5ChZz9tRkmKleN5eBgFo8nQUMgOShqPrnMt6X
        /KhQ6Tco+ECevA0qywq2rG7rvwsgJuOm/RrSDfp8H0hpjfF8IcZuVcb2Qj7XlDQl0OXPTefnD9qfh
        AaEXt4qT+BC3Rz46AjdCkfpIECuI3da53ZHAspgfSLOUxcWypIibxxSCA9T/DefoqE8YvIZwpYwsw
        DGbMuY/vDvKEMw0b9hr3XxdcEK4VK6wjc+oatllnQK8rZI8PLLNHcVYmm3XeeaxRHB3cvY6vX5AfW
        GJKy6yCX8WhnUMYPqkV9zb8LgCy5TUbcrpNMHmHu4Q0s1LN8OfeQk8fBbIhRW26DxTQhUpCRKiyjK
        G+uvNXgDlLMDoveeou1HHv/bp7qU47aJRs/mY7bg2YXTs75faakzz9KvoN3BGGtWeEElVDOmYUMQ+
        z4GCe+sOXguRSLL/BasQFdTn;
Received: from [2a01:4f8:192:486::6:0] (port=36186 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oUTxu-002vS0-Lq
        for cifs-qa@samba.org; Sat, 03 Sep 2022 14:17:42 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.93)
        (envelope-from <www-data@samba.org>)
        id 1oUTxm-000AXz-BT
        for cifs-qa@samba.org; Sat, 03 Sep 2022 14:17:34 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 13570] CIFS Mount Used Size descrepancy
Date:   Sat, 03 Sep 2022 14:17:34 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: Samba 4.1 and newer
X-Bugzilla-Component: File services
X-Bugzilla-Version: 4.15.9
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kato223@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-13570-10630-lhRe5SYow0@https.bugzilla.samba.org/>
In-Reply-To: <bug-13570-10630@https.bugzilla.samba.org/>
References: <bug-13570-10630@https.bugzilla.samba.org/>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D13570

--- Comment #5 from Terrance <kato223@gmail.com> ---
Hi Enzo!

What command output are you looking for?  I don't think I am familiar with
doing a network trace of the timeframe for df.  Can you please tell me a
command that I can run so that I can get you that output?

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
