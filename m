Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1412CD4938
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Sep 2023 01:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjIUBqu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Sep 2023 21:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjIUBqu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Sep 2023 21:46:50 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522BFA9
        for <linux-cifs@vger.kernel.org>; Wed, 20 Sep 2023 18:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Date:To:From:CC;
        bh=GblEck3VPkoui7EtaxhBZ5oi99akhOZH5WDogaGs1WM=; b=vazGjDNcQbqfNZ7p8excxHJy2A
        lHGgcSHr8jgGxKKYK4HpuBmXy6aPd1CdvpF7fuEAP0kGKPmRpFXX1DzDbfG5Ge78KU4veYDkhR3Fq
        LVAe3AVukKsY6cUUbon8VJmnd5tB+Ir5Ad34VwHyqm1HTyr2sx8WycKKJv1ojs657OVUegXxMH7wt
        RGJOCFK6WCTBPgYAFJaU+J3gDLCErMbDKRfV2ihCnSrTQE+mENjWJHnNDQETXdZiF0q8k2OjUPYuh
        KMSsk9+xKAGIaeYVvXgAulMFkL3yzAoasljoM8D6j67e2QQB+MzRtp8JrcwP7ql4a6b+InWIehTL+
        LLiYckXV5c6u7HJ7PZ9fZ6b+YGYYW4Cq6+D2ER5sOdI9T9gcC/K+KK7hI3/sDcVwi1AJf9zIEarai
        SZvET9dY3Eprn0eXKny/5pIFDIzgK6HIrK0xbTl1xrsfIupac6vX2O4Iqt6Yu9EtqU1u0cQ21KSvj
        xcloIxZnT/txzwb/ZAUSZpng;
Received: from [2a01:4f8:192:486::6:0] (port=51612 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qj8m9-00EaFO-34
        for cifs-qa@samba.org;
        Thu, 21 Sep 2023 01:46:42 +0000
Received: from www-data by hr6.samba.org with local (Exim 4.95)
        (envelope-from <www-data@samba.org>)
        id 1qj8m9-001Qpz-By
        for cifs-qa@samba.org;
        Thu, 21 Sep 2023 01:46:41 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 15480] Mounting Azure Fles Share using cifs-utils fails
Date:   Thu, 21 Sep 2023 01:46:41 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: palcantara@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-15480-10630-Mc81EQDARn@https.bugzilla.samba.org/>
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

--- Comment #1 from Paulo Alcantara <palcantara@samba.org> ---
cifs-utils version should be irrelevant as it seems a kernel bug.

What kernel version is it?

Can you reproduce it with latest stable kernel version (v6.5.4) from
kernel.org?

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
