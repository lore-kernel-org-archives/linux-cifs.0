Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43DB5C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  4 May 2022 16:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353147AbiEDQ3j (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 May 2022 12:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353501AbiEDQ25 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 May 2022 12:28:57 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878411EEDC;
        Wed,  4 May 2022 09:25:18 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id C24FF7FC20;
        Wed,  4 May 2022 16:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1651681515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uf4eGE5X5hRNqb7V6XorN5LCEocRZ06jz0PJinqpv1U=;
        b=ciqlHnm0OgJ/Uq6Dvd5+wYCx4KStv0UmKA0rwkDH7DhYZUAkKfVg0EyeBdTaR7uO2YI4hZ
        HRI7Q8x245lQP+6OQwJaYD5OYx/rUBTKg7pdPVELOk9vAxejZ1XpqKEAEY4MWoJCkR0qqZ
        OD6zI0fQljcNHxPij2ZhdbH8kLuZ7t5XY0AHNAfp+q2ktfxLeFsh8nItzBPqVjJnE5IY3E
        2ujkdv81Jt/FF9HIplAlmD/WzzOSc91bvyz7JgiowZIA8npq3wdTtvhABXePpQMEnkgLjG
        uMPfy+nMX2t7w7CDmRz+o7BBgTl3SF56Cf8p5Sgqwsf12cJwNS7sYEfogeJibg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Moritz Duge <duge@pre-sense.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Aurelien Aptel <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: Regression: CIFS umount fails since 14302ee33 with some servers
 (exit code 32)
In-Reply-To: <64a7de55-8f93-8e7a-4102-26f7d4dbe1dc@pre-sense.de>
References: <715d745d-5a85-092a-68c2-b9b1dd8ad53e@leemhuis.info>
 <5fc82f02-be3a-6bb4-0800-aaf19a782655@leemhuis.info>
 <64a7de55-8f93-8e7a-4102-26f7d4dbe1dc@pre-sense.de>
Date:   Wed, 04 May 2022 13:25:10 -0300
Message-ID: <87zgjx1d09.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Moritz Duge <duge@pre-sense.de> writes:

> I'm still waiting for a reply from Paul.

The bug is currently being handled at [1].  Enzo has also asked you to
send us network traces in [2] and you haven't sent any, yet.

I'm not "Paul", BTW.

[1] https://bugzilla.opensuse.org/show_bug.cgi?id=1194945
[2] https://bugzilla.opensuse.org/show_bug.cgi?id=1194945#c13
