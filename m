Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F9CC43217
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Nov 2022 13:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbiKPNTI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Nov 2022 08:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbiKPNTH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Nov 2022 08:19:07 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22174233BC
        for <linux-cifs@vger.kernel.org>; Wed, 16 Nov 2022 05:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=1MnlpWnU0WbPMkZ4M/PGxrQ9Qi9VRRATW0Pm2CRwbi4=; b=bTbwdPvb/w2IeYTbsJjpsqRdIH
        GAsX/3lkmv/tQUI3tlzF5oN2Ska69vRP6XMOqzBGhwa7ZaHUGVQuDSwXH6QRmoS4GysAYnxrigiVS
        JJ0xvqS0b3q5YuWKGw6akUO7n/XF2jnCa76lwS9j3W6N4WUI+ei08i97YMMqOCymfQ7xF0JhyoBKQ
        e2oPwkHHWSxJi9cWekCVjw1ehObeKDNtSvdK2AoHYEJxcP/1kdRAulJI+7nd9G/cgiqWre7Ip8ppF
        56Cv0zF5U3VaSVJg1fAd1XwrELcc9xzIMiiRlGf60Lw8PTQPzmP8C0v1TXkTf3A8xcDK8Zx72jpFD
        Gs/UJ3ng==;
Received: from [2001:4bb8:191:2606:427:bb47:a3d:e0b8] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ovIJK-003ndC-3e; Wed, 16 Nov 2022 13:18:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Steve French <sfrench@samba.org>
Cc:     Paulo Alcantara <pc@cjr.nz>, Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: RFC: remove cifs_writepage
Date:   Wed, 16 Nov 2022 14:18:32 +0100
Message-Id: <20221116131835.2192188-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

this series tries to remove the ->writepage method from cifs, as there
is no good reason for the method to exist anymore and we're trying to
remove it entirely.

The series is entirely untested as I don't have a CIFS setup at the
moment, and patch 2 is a bit crude and there might be much better
ways to handle the small wsize case.
