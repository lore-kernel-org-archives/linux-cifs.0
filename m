Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 319F1C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Jan 2022 17:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348438AbiALRTO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 12 Jan 2022 12:19:14 -0500
Received: from mail.astralinux.ru ([217.74.38.119]:37060 "EHLO
        mail.astralinux.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348434AbiALRTO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 12 Jan 2022 12:19:14 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id B1C2C304B38C
        for <linux-cifs@vger.kernel.org>; Wed, 12 Jan 2022 20:19:11 +0300 (MSK)
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id XvJNoCl4_nuI for <linux-cifs@vger.kernel.org>;
        Wed, 12 Jan 2022 20:19:11 +0300 (MSK)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 4E20C304B38D
        for <linux-cifs@vger.kernel.org>; Wed, 12 Jan 2022 20:19:11 +0300 (MSK)
X-Virus-Scanned: amavisd-new at astralinux.ru
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id J3F3oV_H6lsH for <linux-cifs@vger.kernel.org>;
        Wed, 12 Jan 2022 20:19:11 +0300 (MSK)
Received: from debian-BULLSEYE-live-builder-AMD64 (unknown [46.148.196.130])
        by mail.astralinux.ru (Postfix) with ESMTPSA id 1C5B3304B38C
        for <linux-cifs@vger.kernel.org>; Wed, 12 Jan 2022 20:19:11 +0300 (MSK)
Date:   Wed, 12 Jan 2022 20:19:09 +0300
From:   Eugene Korenevsky <ekorenevsky@astralinux.ru>
To:     linux-cifs@vger.kernel.org
Subject: Re: bug: DFS namespaces with non-ASCII symbols cannot be mounted
Message-ID: <Yd8NjeEzRRmi9/A8@debian-BULLSEYE-live-builder-AMD64>
References: <YczT8K47eA6JqEIB@himera.home>
 <YczVz6tiutXEGmLk@himera.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YczVz6tiutXEGmLk@himera.home>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Dec 30, 2021 at 12:40:31AM +0300, Eugene Korenevsky wrote:


> Please pay attention to the bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=215440

SMB 1.0 ('vers=1.0' mount option) is not affected by this bug.

