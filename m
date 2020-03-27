Return-Path: <SRS0=a8IY=5M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A3FC43331
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Mar 2020 20:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08B3020714
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Mar 2020 20:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgC0UTr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 Mar 2020 16:19:47 -0400
Received: from goliath.siemens.de ([192.35.17.28]:40533 "EHLO
        goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbgC0UTr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 Mar 2020 16:19:47 -0400
X-Greylist: delayed 1452 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Mar 2020 16:19:47 EDT
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by goliath.siemens.de (8.15.2/8.15.2) with ESMTPS id 02RJfmjL019488
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 20:41:48 +0100
Received: from md1za8fc.ad001.siemens.net ([139.22.33.101])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 02RJfmVR014998;
        Fri, 27 Mar 2020 20:41:48 +0100
Date:   Fri, 27 Mar 2020 20:41:45 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] smb3: use SMB2_SIGNATURE_SIZE define
Message-ID: <20200327204145.59c7c1b6@md1za8fc.ad001.siemens.net>
In-Reply-To: <CAH2r5muYwx1TvdmJo5H2aXfzDXc2VP4u-=UeFA53cwiO3ZB+EQ@mail.gmail.com>
References: <CAH2r5muYwx1TvdmJo5H2aXfzDXc2VP4u-=UeFA53cwiO3ZB+EQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

maybe sizeofs for the memc(mp|py)s would be a good addition

Henning
