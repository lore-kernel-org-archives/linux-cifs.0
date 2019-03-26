Return-Path: <SRS0=KOHi=R5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3019BC43381
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 16:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08691206DF
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 16:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731516AbfCZQZc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Mar 2019 12:25:32 -0400
Received: from isilmar-4.linta.de ([136.243.71.142]:51574 "EHLO
        isilmar-4.linta.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfCZQZc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Mar 2019 12:25:32 -0400
Received: from light.dominikbrodowski.net (isilmar.linta [10.0.0.1])
        by isilmar-4.linta.de (Postfix) with ESMTPS id 698BA2009BB;
        Tue, 26 Mar 2019 16:25:30 +0000 (UTC)
Received: by light.dominikbrodowski.net (Postfix, from userid 1000)
        id B3CA820AF5; Tue, 26 Mar 2019 16:46:54 +0100 (CET)
Date:   Tue, 26 Mar 2019 16:46:54 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     Aurelien Aptel <aaptel@suse.com>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [PATCH v1] CIFS: prevent refcount underflow
Message-ID: <20190326154654.GA2073@light.dominikbrodowski.net>
References: <20190326071819.GA10639@light.dominikbrodowski.net>
 <20190326123921.4116-1-aaptel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326123921.4116-1-aaptel@suse.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


On Tue, Mar 26, 2019 at 01:39:21PM +0100, Aurelien Aptel wrote:
> Replace kref_t by a simple refcount. We do not care about the
> atomicity of the operation as long as the mutex is held.
> 
> This fixes a false-positive memory leak warning from kref_put() where
> we close the cached fid twice and make the kref underflow.
> 
> Link: https://lore.kernel.org/linux-cifs/20190319115151.GA2092@light.dominikbrodowski.net/
> 
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>

Reported-and-tested-by: Dominik Brodowski <linux@dominikbrodowski.net>


Thanks,
	Dominik
