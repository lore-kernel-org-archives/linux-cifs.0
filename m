Return-Path: <SRS0=KOHi=R5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5C15C43381
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 16:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A4722070D
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 16:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbfCZQyr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Mar 2019 12:54:47 -0400
Received: from isilmar-4.linta.de ([136.243.71.142]:52430 "EHLO
        isilmar-4.linta.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfCZQyr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Mar 2019 12:54:47 -0400
Received: from light.dominikbrodowski.net (isilmar.linta [10.0.0.1])
        by isilmar-4.linta.de (Postfix) with ESMTPS id 1A7022008B3;
        Tue, 26 Mar 2019 16:54:46 +0000 (UTC)
Received: by light.dominikbrodowski.net (Postfix, from userid 1000)
        id 73A6320AF5; Tue, 26 Mar 2019 17:53:58 +0100 (CET)
Date:   Tue, 26 Mar 2019 17:53:58 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     =?iso-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [PATCH v1] CIFS: prevent refcount underflow
Message-ID: <20190326165358.GA5080@light.dominikbrodowski.net>
References: <20190326071819.GA10639@light.dominikbrodowski.net>
 <20190326123921.4116-1-aaptel@suse.com>
 <20190326154654.GA2073@light.dominikbrodowski.net>
 <87h8bpy3us.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h8bpy3us.fsf@suse.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Mar 26, 2019 at 05:53:15PM +0100, Aurélien Aptel wrote:
> 
> Dominik Brodowski <linux@dominikbrodowski.net> writes:
> > Reported-and-tested-by: Dominik Brodowski <linux@dominikbrodowski.net>
> 
> Great, thanks Dominik.
> 
> I chose to keep a refcount_t instead of a simple int because it still checks
> for overflows.

Yes, that sounds to be the better option.

Thanks,
	Dominik
