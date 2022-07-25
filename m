Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC80FC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 05:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiGYFbW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Jul 2022 01:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiGYFbU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Jul 2022 01:31:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CEEAE6E
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 22:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kaq3RkKqeofivsRU8zdg7o3zFy5JEZ/0g97cqutbVuo=; b=1e+71lFnqZwukTWD0tUEN/NpaG
        kPKXhWkqoKv1UcW0PwiKdOg+jVnm6z6ejfWLg1YjDau9Bic64EO3E+jzAauHBmshA9DXQIqrD7Jlv
        drBekxa5LwsGZPlNxlySl5PO5TKWtMGyLEEOnHeImnr3LajpWavh4xYXh9jdbz6ktStq/glkQ7jDm
        fpArr0IEnBYz84+aapkZ5O53aAuY5usZw3DixgfRdTOM7DqnWswPIHXkrzJBt0ah8+QCvPyRkBE3h
        VLs1layehoDJ8jMrZYusPBU8x5UT8T2ryVZHzkISD0ZvI50Z5xCToD2ZPbG3dFbuZbAF4S5PFnBbR
        h7WwuMUQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oFqgX-004WDP-Eu; Mon, 25 Jul 2022 05:31:17 +0000
Date:   Sun, 24 Jul 2022 22:31:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [RFC PATCH 07/14] cifs: typedef server status enum
Message-ID: <Yt4qpfUYmmkiHRKl@infradead.org>
References: <20220724151137.7538-1-ematsumiya@suse.de>
 <20220724151137.7538-8-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220724151137.7538-8-ematsumiya@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Jul 24, 2022 at 12:11:30PM -0300, Enzo Matsumiya wrote:
> typedef "enum statusEnum" to "cifs_server_status_t".
> Rename the status values from CamelCase to snake_case.

Please don't use pointless typedefs for enum.  They add no value
at all.
