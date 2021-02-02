Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14075C43331
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 19:46:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1CED64F58
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 19:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240045AbhBBTqe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240035AbhBBTpz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Feb 2021 14:45:55 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158D3C061573
        for <linux-cifs@vger.kernel.org>; Tue,  2 Feb 2021 11:45:15 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id p20so12493615ejb.6
        for <linux-cifs@vger.kernel.org>; Tue, 02 Feb 2021 11:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KydiczM3wRgz4bQ2I8R10Q8cY56upPIvRtzn7labxw8=;
        b=cSTAecpC8ZlGPVzSmpSwZh++l0pITUmrMi6T2Lk8N//fVbfJ4oTnx+XQKCnhrljFsR
         f/KkCeUbW7MAhMnHoJRGTU65Xjo+mABA55QMSnlBsc2nybXIH1L2PXJkgVrpX57AdpJk
         s9a6QeehPPGcuCt3G7GZUUfsoLJeq5B1kyWhX1x+JcnEbeXl1+lWZBLFwlhdIF4JHdXK
         xa0OyHKYtO93jHjQmY+3LaTF3Mk3Brh+VBdR+GfJrUbOpWhgh6idPecScvCnKzrzF/bn
         EwVigwZr0Vz5GIv3stZEPVMrBEf3qLEbHedN08CHA5dGpozhY0dO/hYFDPNjVn+Li+vV
         J/Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KydiczM3wRgz4bQ2I8R10Q8cY56upPIvRtzn7labxw8=;
        b=HTn6zOImVRLenE+nhZVNOF7hrJxZZbMHRV7DVDNKkH2d2q/uyzcEGgkyB1HDmPR4NA
         bNXv0PDEsbjrwJ7ei+1btc/SjCfltnLOtOR/iHGpbuLt09B5R7d1hIxlg0MGHqWiN4hK
         rxrL+JEX0o0xkk3q3a6COK+2cBgQ+vuAngStqPG4zZQX5uGYZMvp14khGjJZqpZkfjId
         lLKFab68D9dPvFIvhG5C+sUKHr2eCRQhGmpJOgpuigKuNJB7FTpHxxkXpYx3dglfUOOL
         sONOz01ArZsnEU6reAFMWjr7W7IZ6xmm+WEwKz4Lb1IEvQ68jAA3aXAH1wgfXqmPh8h4
         f2XA==
X-Gm-Message-State: AOAM532B/38Ipqr30PXRv3fHQwr+r3DlHudGQ0gQXe7UhJsao0PI/605
        huVz2bEkIEK/8osYe7/uySuI7WotCgFZ/fIVRQ==
X-Google-Smtp-Source: ABdhPJyYbAvNSkA06p6bClX/x0egClHfnV0LY9jZA2/R6nflow7BPoDS8rfNMWuVZWAciwrxNRh/jwdZrg6VVeHRa1E=
X-Received: by 2002:a17:907:9483:: with SMTP id dm3mr23524445ejc.120.1612295113804;
 Tue, 02 Feb 2021 11:45:13 -0800 (PST)
MIME-Version: 1.0
References: <20210202010105.236700-1-pshilov@microsoft.com>
 <40f473ff-bdd5-059c-36f1-d181eaa71200@talpey.com> <CAKywueRkvEjaZ+u4QhG+aVKFKUf-smWRqLmeeRC-2=4xU=zmDA@mail.gmail.com>
 <578dfbe3-18cd-3193-828f-54ddfdb9ffea@talpey.com>
In-Reply-To: <578dfbe3-18cd-3193-828f-54ddfdb9ffea@talpey.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 2 Feb 2021 11:45:02 -0800
Message-ID: <CAKywueQrWN27LbUdU8D=B8yMei4f5WN1CZ0+=sayr-QNwDvmuA@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Wait for credits if at least one request is in flight
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 2 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 11:05, Tom Ta=
lpey <tom@talpey.com>:
>
> > Yes. If the server is tight on resources or just gives us less credits
> > for other reasons (e.g. requests are coming out of order and the
> > server delays granting more credits until it receives a missing mid)
> > and we exhausted most available credits there may be situations when
> > we try to send a compound request but we don't have enough credits. At
> > this point the client needs to decide if it should wait for credits or
> > fail a request. If at least one request is in flight there is a high
> > probability that the server returns enough credits to satisfy the
> > compound request (which are usually 3-4 credits long). So, we don't
> > want to fail the request in this case.
>
> Ah, yes it's true that with no requests in flight, the wait would be
> unbounded, and uncertain to gain credits even then. I think that is
> well worth capturing in a code comment where the failure is returned.

Make sense. Will add a comment and re-send the patch.

>
> It's still a concern that large requests may fall victim to being
> locked out by small ones, in the low-credit case. A "scheduler", or
> at least a credit reservation, would seem important in future. Or,
> as mentioned, modifying the requests to consume fewer credits each.
>
> It's easy to envision a situation where a low-credit server can be
> up, but a credit-greedy client might refuse to send it any requests
> at all.
>

Agree. Falling back to sequentially sending compound components is
needed to resolve such a situation.

--
Best regards,
Pavel Shilovsky
