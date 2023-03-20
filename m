Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82DBC7618A
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Mar 2023 13:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjCTNpZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Mar 2023 09:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbjCTNo5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Mar 2023 09:44:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5954BDC9;
        Mon, 20 Mar 2023 06:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=fJeItlnrEgSrVscMNkkOVI4DUx68JFTI3xaa/+k0qtY=; b=Wa/PnoDcEEK1PijKAuoHRFq9a0
        7un3cph4HE0VEo+BApeWcPsgDMHmZl2CxFwy3RiK9b7tJ0npia4drz1TkwGkTrQxOwOmUzJnomy9m
        Fs1X8qivZJgLzCnXH/sO08Eoy3ckr8fG8/5v6WpkEpS6580Fj4km0pPqYKeq7GOTUChmQBXqHmvKS
        AXEBDniRjCCeLnpngx+iIhBmdDSTvC8IylpdN9LI7P8r2PUPgMxca//JGxA4Jt1HpX1MwMAVlDZkk
        ltsmwpD9hf3G4d/VVLQCRLTiW2HDbZ1PBeU0zNb0j+qokWUBg93ud9dwVK9IvMGo9hhlXIn37q7G3
        crqlV/pw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1peFo7-009Dvn-38;
        Mon, 20 Mar 2023 13:44:15 +0000
Date:   Mon, 20 Mar 2023 06:44:15 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Mingyi Cong <congmingyi@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linkinjeon@kernel.org,
        senozhatsky@chromium.org, sfrench@samba.org, tom@talpey.com,
        linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: Re: [PATCH v3] fs: add the tuncate check of exfat
Message-ID: <ZBhjL0zie5CZUq+z@infradead.org>
References: <20230307135740.13209-1-congmingyi@gmail.com>
 <20230316142753.6628-1-congmingyi@gmail.com>
 <ZBMr9YOmLtC6GNQ8@infradead.org>
 <CAABeQzW++EWfW1rKqqKJCDN5eTceVJ4r380SA6Dg99CRZtUKFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAABeQzW++EWfW1rKqqKJCDN5eTceVJ4r380SA6Dg99CRZtUKFw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Mar 16, 2023 at 11:15:10PM +0800, Mingyi Cong wrote:
> After my analysis, the reason is that the truncate system call of some file
> systems will be filled with 0 data. We should add some conditional
> judgments to avoid the use of some file systems for truncate. Do you have a
> better suggestion for revision?

As ѕaid we need a flag, be that per-file system or per-inode to flag
the behavior instead of guessing it from the major number.
