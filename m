Return-Path: <SRS0=vQ6B=TH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08681C004C9
	for <linux-cifs@archiver.kernel.org>; Tue,  7 May 2019 06:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6E272087F
	for <linux-cifs@archiver.kernel.org>; Tue,  7 May 2019 06:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfEGGJm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 May 2019 02:09:42 -0400
Received: from mx1.chost.de ([5.175.28.52]:33198 "EHLO mx1.chost.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbfEGGJm (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 7 May 2019 02:09:42 -0400
Received: from vm002.chost.de ([::ffff:192.168.122.102])
  by mx1.chost.de with SMTP; Tue, 07 May 2019 08:10:28 +0200
  id 000000000133ACB4.000000005CD12154.00006711
Received: by vm002.chost.de (sSMTP sendmail emulation); Tue, 07 May 2019 08:10:28 +0200
Date:   Tue, 7 May 2019 08:10:28 +0200
From:   Christoph Probst <kernel@probst.it>
To:     Steve French <smfrench@gmail.com>
Cc:     Pavel Shilovsky <pavel.shilovsky@gmail.com>,
        Jeremy Allison <jra@samba.org>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cifs: fix strcat buffer overflow in
 smb21_set_oplock_level()
Message-ID: <20190507061028.GP28577@netzpunkt.org>
References: <1557155792-2703-1-git-send-email-kernel@probst.it>
 <CAH2r5mtdpOvcE25P2UuNFpOwsNyFiBWRQELQFui+FJGVOOBV8w@mail.gmail.com>
 <20190506165658.GA168433@jra4>
 <CAH2r5msK6yNNm_QbdsFZuB5uS0iNRuqe8gSDKvVAiR0N6E3MWg@mail.gmail.com>
 <CAKywueR6DcfkzGcZUgydV4n6F4MKDEOvtCaM-gQSonX02tA9tg@mail.gmail.com>
 <CAH2r5ms+RAoe_1c=dUYL=yCs3KWAvqoB00-T4SEpyTjRKiwA6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <CAH2r5ms+RAoe_1c=dUYL=yCs3KWAvqoB00-T4SEpyTjRKiwA6A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Steve French schrieb am 06.05.2019 um 23:18 Uhr:

> On Mon, May 6, 2019 at 2:03 PM Pavel Shilovsky
> <pavel.shilovsky@gmail.com> wrote:
> >
> > The patch itself is fine but I think we have a bigger problem here:
> 
> Good point.  Perhaps make update to the same patch to include both changes

I'll update my patch to implement the change suggested by Pavel.

I'll also switch the strcat to strncat and use strncpy in the "None"-case.

Regards,
Christoph



