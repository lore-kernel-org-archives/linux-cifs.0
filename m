Return-Path: <SRS0=UR+C=S4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E52C43219
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Apr 2019 16:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E179208CA
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Apr 2019 16:35:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ncIG4Mm7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfDZQfk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:35:40 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41596 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbfDZQfk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Apr 2019 12:35:40 -0400
Received: by mail-lf1-f68.google.com with SMTP id t30so2814569lfd.8
        for <linux-cifs@vger.kernel.org>; Fri, 26 Apr 2019 09:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pse0Maw6QACKXBrQQstgs3nrleIyMmtyHxrcB0bXQ3U=;
        b=ncIG4Mm7I1GbUQbMMDa13gCkE1zIIChEg2yEJrOTm4lLUqp/Lw3zEpfLBbzIBj1AXY
         Q/ff46O/slS0WtPeh3FOOVSz+IqVdN6F7jivYhFnSjAAky15GAdtluE6dNdYR9doHbqz
         awHvyF5Iz3AkE+NJVMDlOFfS+9XUgex5b5w6agXn4LtKmY407jD8hAzex63iRVLyb0IC
         uFEv1IU6JezwqrdMwqn7TH6MLVsiH43XaMQltMsUUNrZdfDhQJWo3TZzZMSF8/SvJu2x
         s3+kfR3ZGxP8uM9agnJdm0vQAlLMLUPuF0xLb6nC3/lysbrtw65clqt7v8hAIo9LOcjC
         bmsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pse0Maw6QACKXBrQQstgs3nrleIyMmtyHxrcB0bXQ3U=;
        b=WcnH0TMb66Rg5JGYMOkS2qPAOHMhHVGdGFTns7Ad3Ejn2/LT2iR53pjxM9oRvx9LNg
         jzHk+AmRKwbP6RW/2Kq8CdpvRCm1ktJmG0zhxq2qSWO8xabx0mDJ4WuBk7HhrKhoLMQz
         iTmV5Zti2szGP7DNh0NlcZn62cNWqODbqCsJ4IiZdCr+OVSQ7v32dD0RXoQCf4PXG+L+
         R6XLeksr5rOd5v8iQH3r1KEJRC5JAgQ7h2IRwjh1k9roTAOJ4QnMwBjvGVDflPxWOi2X
         H4yO04OivEhFUY4IDk/APzYlKwBDkexsIVWLiR11/QF8yDUAxI97W5AkV1TrwI5kLGvz
         qLrQ==
X-Gm-Message-State: APjAAAXnWhxPJYxF4X9r+E8R/82wqzFcd2j4hxB50+7gfcjp5eMVMxOX
        vEy9rgwM/qml5NRxgImDadRiTTorRpMu8fOorA==
X-Google-Smtp-Source: APXvYqwybmZfWlEHkGkyJUp1XgDeH2DnMYXW/mzBJhyXzA9J2u0kVZuV2D5EwIxVrcnYHJWxteiGIyE3ez5T1duietE=
X-Received: by 2002:a19:c113:: with SMTP id r19mr25071070lff.64.1556296538106;
 Fri, 26 Apr 2019 09:35:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190426003223.4763-1-lsahlber@redhat.com>
In-Reply-To: <20190426003223.4763-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 26 Apr 2019 09:35:25 -0700
Message-ID: <CAKywueRwXZv_bfWe0tjZxYvuyWRJabQ0GNXHGH0Fxt=NHeseyg@mail.gmail.com>
Subject: Re: [PATCH 0/1] cifs: fix credits leak for SMB1 oplock breaks
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 25 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 18:42, Ronnie Sahl=
berg <lsahlber@redhat.com>:
>
> Pavel, List
>
> Here is an update after the email discussions.
> This is minimal patch that adds a new flag to specifically indicate
> that there will not be a response to this PDU and thus we can immediately
> add the credits back after sending in compound_send_recv()
> This flag is only set for SMB1 oplock breaks so this will not affect anyt=
hing
> else.
>
> Additionally, we no longer need to check the CIFS_ASYNC_OP flag in
> compound_send_recv() so we can remove that conditional.
>
> This is the smallest patch which fixes the actual smb1 oplock bug thus we=
 should
> be able to get it into an rc, and stable.
> But we need more but that should wait until the next merge window.
>
>
> The next steps we should do is:
> Remove CIFSSMBNotify() completely and with that also the check for
> CIFS_ASYNC_OP in SendReceive()
>
> When that is done, the only thing that CIFS_ASYNC_OP does is make sure
> we do not block in wait_for_credits().
> Which means we could rename this flag to CIFS_NON_BLOCKING.
>
> We should also rename CIFS_NO_RSP to CIFS_NO_RSP_BUF to make it more clea=
r that
> there will be a response status code but there won't be any or we don't c=
are about any response buffer.
>
>
> Thus the semantics will become:
> * cifs_call_async() : if you want async handling of responses
> * CIFS_NO_SRV_RSP: There won't be a response so do not wait for a reply. =
(only used by SMB1 oplocks)
> * CIFS_ASYNC_OP/CIFS_NON_BLOCKING: do not block waiting for available cre=
dits.
>

Agree, sounds like a good plan. Thanks for summarizing!

--
Best regards,
Pavel Shilovsky
