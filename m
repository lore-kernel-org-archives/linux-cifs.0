Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF35C07545
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Oct 2023 10:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbjJXKDL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Oct 2023 06:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbjJXKDJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 Oct 2023 06:03:09 -0400
Received: from mail.astralinux.ru (mail.astralinux.ru [217.74.38.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CC5DA;
        Tue, 24 Oct 2023 03:03:06 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 0C6C7186892A;
        Tue, 24 Oct 2023 13:03:02 +0300 (MSK)
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id C3tx3pmHCTSt; Tue, 24 Oct 2023 13:03:01 +0300 (MSK)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 5C7B2186864D;
        Tue, 24 Oct 2023 13:03:01 +0300 (MSK)
X-Virus-Scanned: amavisd-new at astralinux.ru
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id x4kXF6zs_dmk; Tue, 24 Oct 2023 13:03:01 +0300 (MSK)
Received: from rbta-msk-lt-106062.astralinux.ru (unknown [10.177.20.58])
        by mail.astralinux.ru (Postfix) with ESMTPSA id 2BB1C1867B6E;
        Tue, 24 Oct 2023 13:03:00 +0300 (MSK)
From:   Anastasia Belova <abelova@astralinux.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Anastasia Belova <abelova@astralinux.ru>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: [PATCH 5.10 0/1] smbdirect: missing rc checks while waiting for rdma events
Date:   Tue, 24 Oct 2023 13:02:25 +0300
Message-Id: <20231024100226.25860-1-abelova@astralinux.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Check for return value of wait_for_completion_interruptible_timeout
should be added in v5.10. The following patch contains necessary
changes and can be cleanly applied.

Found by Linux Verification Center (linuxtesting.org) with Svace.
