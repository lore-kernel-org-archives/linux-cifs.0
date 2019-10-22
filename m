Return-Path: <SRS0=KUb6=YP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BABCA9EA0
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Oct 2019 16:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1829421783
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Oct 2019 16:09:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RXHJfRhh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732201AbfJVQJ5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Oct 2019 12:09:57 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33522 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732198AbfJVQJ5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Oct 2019 12:09:57 -0400
Received: by mail-lj1-f193.google.com with SMTP id a22so17823866ljd.0
        for <linux-cifs@vger.kernel.org>; Tue, 22 Oct 2019 09:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=J3NrCXYDCPkHTw17Te3Jo+GeXeWfuDsBgzCpvDay5cs=;
        b=RXHJfRhhNydjFd3Y7d9ez32rm9M5jCHmFCxlQNc8RWYbjd/iiVtumMi4wXGhbOODLa
         08otQ0AhzetM1X6TYsmVkwEvUTHK3U/Ln5F725MdeuLokfqhTKgyhfpjDtPjXAzdExgN
         R5AlfvIwMy/+L+QiY6j8q25cwwGC0YRy8sa1en3vvX/yPn+5kkmkQMZo4C9z2niRGpXT
         rOGmgHpTY9GEZQ1kvb7N5yacsTf8QJ9SqHdsGI0dwnwkyaNby3oXM2HczF8Sdi1GmI4U
         WE7wPo3lQ363n+x5DRJ+5SyI8DkipCUIkCbC8QhYvTSAcPkhHZIVrGaT48hMoYm0VqaR
         7QCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=J3NrCXYDCPkHTw17Te3Jo+GeXeWfuDsBgzCpvDay5cs=;
        b=uma4+vMnqgkpcw7Z/5iomKGJ9JnHLiWJ2eW9AZ2+K+bdzJqHjs0ST+u1FCrUO+gHS6
         QIZVqHkrJ6qyyxhdVzfQS6IDKR8NlrP4+lXUA3W5FSI9iuc8LnsTsmKt7p5zNaIw/gqi
         vtdEcY3No2ggLPZejxJ+sK6RIWppnY78K/0j4diikAAnsJF2Sv3u9jxHEHCUdQ1TAOnt
         bejkycAJzMMbv43qsx+L554DQ3uMbFimGAsY7ptm8ut7lgDral9fwMG3aUAWPDxs73s5
         mhSCVoqi54t42/sV0NRYw7Y69aLMqnFSpi5BGk/MThgGIYkSxT2kQLZUpAtKxJmjJvET
         57AA==
X-Gm-Message-State: APjAAAVUWEDGWsqQKukNoCeGQQLEUrwGaFLVBxe8Pk9PsH5QcC/LZeuI
        Mkswcs7RoBpZZ5ptSAH6FuRcxqVIcop0+P4h8w==
X-Google-Smtp-Source: APXvYqy02pcE/ap6h/0p79SrwfBg2bd4mtRBNAgZHp6Oi1C0DPBI9fRvtMU7wDSckqbrGNTzftLMt8nQuEMx9klTbII=
X-Received: by 2002:a2e:63c7:: with SMTP id s68mr19471119lje.244.1571760595749;
 Tue, 22 Oct 2019 09:09:55 -0700 (PDT)
MIME-Version: 1.0
References: <CALF+zOmFsykoOWHy6Yt6dH6i-Cn9XWWCMsnsdPZaKuLE6jjO7w@mail.gmail.com>
 <CAKywueQRnmAuXJq+5ZER3ir6BhUgNFaaFCG6aZE7ep=qe=qbmQ@mail.gmail.com> <CALF+zO=UaXnrwn1X0MnZ9Gn4g5qOZ4_SdH=WDyQ3Uc1fpWtD_Q@mail.gmail.com>
In-Reply-To: <CALF+zO=UaXnrwn1X0MnZ9Gn4g5qOZ4_SdH=WDyQ3Uc1fpWtD_Q@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 22 Oct 2019 09:09:43 -0700
Message-ID: <CAKywueRo=uD+J2C0LxSgRG6TtvwL5XALiy-qBoxXf5ETQhdmHg@mail.gmail.com>
Subject: Re: Easily reproducible deadlock on 5.4-rc4 with cifsInodeInfo.lock_sem
 semaphore after network disruption or smb restart
To:     David Wysochanski <dwysocha@redhat.com>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 21 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 20:05, David Wysoc=
hanski <dwysocha@redhat.com>:
> > ? If yes, then we can create another work queue that will be
> > re-locking files that have been re-opened. In this case
> > cifs_reopen_file will simply submit the "re-lock" request to the queue
> > without the need to grab the lock one more time.
> >
> I think you're approach of a work queue may work but it would have to
> be on a per-pid basis, as would any solution.

Why do you think we should have a queue per pid? What are possible
problems to have a single queue per SMB connection or Share (Tree)
connection?

--
Best regards,
Pavel Shilovsky
