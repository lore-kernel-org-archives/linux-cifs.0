Return-Path: <SRS0=yfkL=4J=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 032E1C35656
	for <linux-cifs@archiver.kernel.org>; Fri, 21 Feb 2020 13:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD1F5208C4
	for <linux-cifs@archiver.kernel.org>; Fri, 21 Feb 2020 13:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgBUN5X (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 Feb 2020 08:57:23 -0500
Received: from smtprelay0077.hostedemail.com ([216.40.44.77]:60343 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728672AbgBUN5X (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 21 Feb 2020 08:57:23 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id CDB7018224D78;
        Fri, 21 Feb 2020 13:57:21 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: noise65_4028b1475993c
X-Filterd-Recvd-Size: 1339
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf04.hostedemail.com (Postfix) with ESMTPA;
        Fri, 21 Feb 2020 13:57:20 +0000 (UTC)
Message-ID: <0f2c5adb37454dacbd57d65ba8743bb6092876ff.camel@perches.com>
Subject: Re: [trivial PATCH] cifs: Use #define in cifs_dbg
From:   Joe Perches <joe@perches.com>
To:     =?ISO-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>,
        Steve French <sfrench@samba.org>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 21 Feb 2020 05:55:56 -0800
In-Reply-To: <87eeuo5a2y.fsf@suse.com>
References: <862518f826b35cd010a2e46f64f6f4cfa0d44582.camel@perches.com>
         <87eeuo5a2y.fsf@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, 2020-02-21 at 14:44 +0100, Aurélien Aptel wrote:
> Joe Perches <joe@perches.com> writes:
> > +			cifs_dbg(VFS, "bogus file nlink value %u\n",
> > +				 fattr->cf_nlink);
> 
> Good catch :)
> I realize that 1 is VFS but this should probably be FYI.

change it as you please.

fyi:

Perhaps commit f2f176b41 ("CIFS: add ONCE flag for cifs_dbg type")
may have increased object size quite a bit as it now tests
an external variable.


