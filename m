Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57168C07E9A
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Jul 2021 16:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 389EE613BF
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Jul 2021 16:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhGNQhg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Jul 2021 12:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbhGNQhg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Jul 2021 12:37:36 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E98CC06175F
        for <linux-cifs@vger.kernel.org>; Wed, 14 Jul 2021 09:34:43 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id v1so3963307edt.6
        for <linux-cifs@vger.kernel.org>; Wed, 14 Jul 2021 09:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=L+rvi4HovgibY+sqecDf0qlMTVWmSxyPiRhPcvJ+fZY=;
        b=oabXEpILiUvhjeFQwF4B0/qFGkKCE4ViOGQlmoyn+aDNPCgDq5l3qC7sn4YfcwJmIb
         5maE3fV6/nD25iYPMPwt2yhEriWPThQLBzfY8fSEm6fVPVGKOF38QlEkzBvtCRgngygH
         oyoGb3aVnpzpmvT8mb3P/PPy/7FcVpM4v7cXztWhg8TpUxqEZVR11JJQ7GOYBc4s9WZe
         b9iqYp77/Fz+YJHdxltWJG+ARilHzGuk07owEdkAjuJjV5b59mULNLS1jmDylx0fQnYC
         YXuCS6OqLn2iai8upP7y0I/EZnzP+VdaTNHbBxLde3PA8TQqmEMDGadgvbs3IBrb4j4g
         ncPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=L+rvi4HovgibY+sqecDf0qlMTVWmSxyPiRhPcvJ+fZY=;
        b=BGZx5+eeA5dVVjKIVCbVWMm0YgcHXG7ls8lNf1fe5FCU8C1PFyhIb9pWJ+Ib4PQv/1
         fFTXqYRZkVE/XtDC3ZSNLbdFPkZNCIS2qwFuluIHV/zlMTbB52cRaIMPZlgn21XXKxnm
         Zk6SOV65iaWCYI7IQzv7BEG229nMIWnOd6vHzHCBUIAEpBYMwnigy5u3m4avcd4xQniL
         P7LGgaw4ffMGkgp9E8uCAcXK2pZBxth0Czcp0W2O9PyOduqzpx9kU5r5+Q82tzrBrFUB
         OjJmZ/aWwrqt0TWX2ghT7GQSo1smrIz/5uHggIo+XfiNAUGyHNy1j++lIiHYTN4gzRz9
         a5sA==
X-Gm-Message-State: AOAM533UGrjkCobdC1BK+DLz59VCSbRw3p22SL2ukMFPmJriVpixZ8oW
        bsAjoK1VoA6zlH1kKMuf/kvXsmqed791w3/BAw==
X-Google-Smtp-Source: ABdhPJznDx+aiwfEddS4euQsAH31KIemCW9RpL3l7OgBSW4lsvdLU1Hb4Q+Jccbu/CwitJ+QY1OE7RYNVUfERnmRrXw=
X-Received: by 2002:aa7:c3d0:: with SMTP id l16mr14796341edr.225.1626280481801;
 Wed, 14 Jul 2021 09:34:41 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=pDrNBRQSHAarXzxTRNF9Lo=-q-hsnbBTHJZue=ggGzXw@mail.gmail.com>
 <CAH2r5mvxj-A3F1tPr9OH1D00bdznVYyx7FzyjLZt=Xq41TCVxw@mail.gmail.com>
 <CAKywueR3aTzrC-QM=P3tJ3RuS1AWAPsgcK-eqyX55HYtH-M_bQ@mail.gmail.com>
 <CAN05THQL3GTN0oG8rREQ3W9bxEoAV+NppbSgAuytdzPyH3cuhA@mail.gmail.com> <CANT5p=oCJ5MRSVcNHV3-+Jg2TcGc3m785GGJBzScGThkS24eMw@mail.gmail.com>
In-Reply-To: <CANT5p=oCJ5MRSVcNHV3-+Jg2TcGc3m785GGJBzScGThkS24eMw@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 14 Jul 2021 09:34:30 -0700
Message-ID: <CAKywueRVSWVtD3KRcOTCAGCsxuoL_XUgm9Ga1eTs0K53Z47HDg@mail.gmail.com>
Subject: Re: cifs.ko page management during reads
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 13 =D0=B8=D1=8E=D0=BB. 2021 =D0=B3. =D0=B2 23:51, Shyam Prasa=
d N <nspmangalore@gmail.com>:
>
> On Wed, Jul 14, 2021 at 5:45 AM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> >
> > On Wed, Jul 14, 2021 at 8:58 AM Pavel Shilovsky <piastryyy@gmail.com> w=
rote:
> > >
> > > =D0=BF=D0=BD, 12 =D0=B8=D1=8E=D0=BB. 2021 =D0=B3. =D0=B2 22:41,Steve =
French <smfrench@gmail.com>:
> > > >
> > > > And don't forget "esize" mount option to allow offload of decryptio=
n...
> > > >
> > > > On Tue, Jul 13, 2021, 00:37 Shyam Prasad N <nspmangalore@gmail.com>=
 wrote:
> > > >>
> > > >> Hi all,
> > > >>
> > > >> I'm trying to understand our read path (big picture is to integrat=
e
> > > >> the new netfs helpers into cifs.ko), and I wanted to get some
> > > >> understanding about why things are the way they are. @Pavel Shilov=
sky
> > > >> I'm guessing that you've worked on most of this code, so hoping th=
at
> > > >> you'll be able to answer some of these:
> > >
> > > Thanks for taking a look at this.
> > >
> > > >>
> > > >> 1. for cases where both encryption and signing are disabled, it lo=
oks
> > > >> like we read from the socket page-by-page directly into pages and =
map
> > > >> those to the inode address space
> > >
> > > Yes, we read directly into pre-allocated pages. For direct IO we read
> > > into pages supplied by the user and for non-direct IO (including page
> > > IO) we allocate intermediate pages.
> > >
> > > >>
> > > >> 2. for cases where encryption is enabled, we read the encrypted da=
ta
> > > >> into a set of pages first, then call crypto APIs, which decrypt th=
e
> > > >> data in-place to the same pages. We then copy out the decrypted da=
ta
> > > >> from these pages into the pages in the address space that are alre=
ady
> > > >> mapped.
> > >
> > > Correct. Regardless of whether offloading is used or not there is an =
extra copy.
> > >
> > > >>
> > > >> 3. similarly for the signing case, we read the data into a set of
> > > >> pages first, then verify signature, then copy the pages to the map=
ped
> > > >> pages in the inode address space.
> > >
> > > Yes.
> > >
> > > >>
> > > >> for case 1, can't we read from the socket directly into the mapped
> > > >> pages?
> > >
> > > Yes - assuming no signing or encryption, we should be able to read
> > > directly into the mapped pages. But I doubt many people use SMB2
> > > without signing or encryption although there may be some use cases
> > > requiring performance over safety.
> > >
> > > >> for case 2 and 3, instead of allocating temporary pages to read
> > > >> into, can't we read directly into the pages of the inode address
> > > >> space? the only risk I see is that if decryption or sign verificat=
ion
> > > >> fails, it would overwrite the data that is already present in the =
page
> > > >> cache. but I see that as acceptable, because we're reading from th=
e
> > > >> server, since the data we have in the cache is stale anyways.
> > >
> > > Theoretically we may try doing this with signing but we need to make
> > > sure that no one can modify those pages locally which may lead to
> > > signing errors. I don't think today we reconnect an SMB session on
> > > those today but we probably should.
> > >
>
> How can someone modify those pages? Don't we keep the pages locked
> when the read is in progress?
>

Agree. As I said - theoretically we can do such an optimization. I am
not sure if it is worth it given the whole signing overhead.

--
Best regards,
Pavel Shilovsky
