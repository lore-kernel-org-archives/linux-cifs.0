Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4616EC433ED
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 20:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1B16613C2
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 20:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347172AbhDFUTR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Apr 2021 16:19:17 -0400
Received: from mail.xes-mad.com ([162.248.234.2]:43751 "EHLO mail.xes-mad.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347165AbhDFUTQ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 6 Apr 2021 16:19:16 -0400
Received: from zimbra.xes-mad.com (zimbra.xes-mad.com [10.52.0.127])
        by mail.xes-mad.com (Postfix) with ESMTP id E5BFF2028D;
        Tue,  6 Apr 2021 15:19:07 -0500 (CDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xes-inc.com; s=mail;
        t=1617740347; bh=D9wQzNjggUvW+sg8MmmsD5Hx6NRQdkjMZX2+chrt0xU=;
        h=Date:From:To:Cc:In-Reply-To:Subject:From;
        b=G87qTLUjExtYmv+H+fhDnkic7DLx7c7GbnocwG5wdMunZoJug6yzVauW2gLxLtSb1
         QVIOdT60ejU29g4A6Q/PtnHNYV/HFgeI+WfFxLUqhx+HvhrK2GHAz3rtFTTsFyk1/V
         PFYqv+5DL1buJcHndsFRum9IgpKWtAWkD9ZTqTP4=
Date:   Tue, 6 Apr 2021 15:19:07 -0500 (CDT)
From:   Nate Collins <ncollins@xes-inc.com>
To:     =?iso-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Message-ID: <1489475591.409647.1617740347892.JavaMail.zimbra@xes-inc.com>
In-Reply-To: <87k0pf4u7g.fsf@suse.com>
Subject: Re: multiuser/cifscreds not functioning on newer Ubuntu releases
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.17.93]
X-Mailer: Zimbra 8.8.15_GA_3996 (ZimbraWebClient - GC89 (Win)/8.8.15_GA_3996)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks for the wireshark tip, I found that the domain wasn't getting
included in the NTLMSSP_AUTH packet.

cifscreds add -u user@domain.com share

allows me to access the mutiuser mount as my user. My question now is,
where should that domain be specified so that it's not needed when
running cifscreds? The mount already has domain=domain.com set, and
in the pam_cifscreds.co module's line in /etc/pam.d/common-session,
I tried replacing host=dc.domain.com with domain=domain.com, but still
the NTLMSSP_AUTH packet didn't have the domain set.

> Ubuntu 18 is from 2018 right? There have been multiple regressions and
> fixes related to signing since then. After a quick scan I see these
> fixes (from most recent to oldest):

Yeah, 18.04 is from 2018, but 20.04 (the most recent LTS release) has
the same change in functionality. Should've made that clearer in my
initial post.
