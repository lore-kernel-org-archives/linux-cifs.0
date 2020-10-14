Return-Path: <SRS0=foj0=DW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C8CC433E7
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 02:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CBC020691
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 02:24:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HnkTh9Wo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729901AbgJOCYp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Oct 2020 22:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730065AbgJOCYj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Oct 2020 22:24:39 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1488EC05BD2D
        for <linux-cifs@vger.kernel.org>; Wed, 14 Oct 2020 15:48:04 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id md26so789946ejb.10
        for <linux-cifs@vger.kernel.org>; Wed, 14 Oct 2020 15:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rSCBCC4ERcxnWKtCTSn+nsQTCKxVVc+NeWAgSkbVY8A=;
        b=HnkTh9WoVXL5bcyhT1fZuOK+w+/n4+qCH3fL3fbF9oMeghpfd2slD6QHFOBvkWQ8wC
         KLEjfGp3LqGj/MLowM8eCMgzRQ1HrET+VNs8weKHkfWnkUDsBOlRIeiTljvNaalAnRCR
         rX/lkIJOs7TGFVC2kjfyfQyDIBRQ+95lRYy/elqjkCPG0ew+ZZT54Dxx28EmFEu18TYC
         AKe48bVjv3NTgwC/ORmO2djeXMLJLXA3CCM8mbTK1rcax0VUtJ3nhjAZAlZMxTicgHhx
         J21Ugr993g+ZQ75QBwBCScqWqyetXFp/k8cm8/zrN23NvUl1o9gPubFewJ/W0yDZ3Etp
         JtYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rSCBCC4ERcxnWKtCTSn+nsQTCKxVVc+NeWAgSkbVY8A=;
        b=ufL7GEWsvoMmQlDUPIXY3+jPeOU7qLmlVwIPZZMl400RNnSJHpJxQ3bbcLE3jxztor
         pk5a15IjTxwWrX9Z/rg/Jbf0srt4VcMtv6lkB5arFtTW/mEkdAHjX7+v3TCLXk270ZDo
         hcqgi2s+U7kcSBnqx3QchPaDIgZTZUnzYppHZRxEI/yGbm9E/sz7LNFd3E+HM3ZWgINS
         qVl9Y/XJbHg37sFtRkaN1iUzbBg9EPu94zbDJQqE7STyQmThWSNXfdKBm7pG5zhLfHgB
         nMbVAuYw0UrIM084td21iZiyZjLorL1Z6edIPNf+eNr/809ISLzqBB8EDBjMXFFn8fIF
         sWoQ==
X-Gm-Message-State: AOAM533XlCumwUZD34kfZ9rJy/O5NNwUAvbN2zBXwQ96RZNDAckhUo4+
        vXBYig2wHJE5xbPi2JK5IHP7LbOY2tP+JMSxnQ==
X-Google-Smtp-Source: ABdhPJzI3yO9ndw3TCh7DFlaMhcQV0GelHKizKjGgt7Z0W1JMxDJ54ket1rLlQgGAEZmWmqXKJDv+2AG2lhftnM2070=
X-Received: by 2002:a17:907:20e7:: with SMTP id rh7mr1408398ejb.515.1602715682778;
 Wed, 14 Oct 2020 15:48:02 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0YWG1Ni5JnOpnH4OVnF7RpiE_E_WXYrTBEP=K+SL=Yuog@mail.gmail.com>
 <CAH2r5msodNEQPFO7fwY1wpy=qUNPTH+8iPDxZSvMrjg+SkJHEg@mail.gmail.com>
In-Reply-To: <CAH2r5msodNEQPFO7fwY1wpy=qUNPTH+8iPDxZSvMrjg+SkJHEg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 14 Oct 2020 15:47:51 -0700
Message-ID: <CAKywueR8u8DHUF7s9WXiowN5s2e_jmT5CqRBNS3qfewmmBcJhw@mail.gmail.com>
Subject: Re: [PATCH] Resolve data corruption of TCP server info fields
To:     Steve French <smfrench@gmail.com>
Cc:     Rohith Surabattula <rohiths.msft@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        sribhat.msa@outlook.com, linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Rohith,

Thanks for catching the problem and proposing the patch!

I think there is a problem with just removing server->total_read
updates inside decrypt_raw_data():

The same function is used in receive_encrypted_standard() which then
calls cifs_handle_standard(). The latter uses server->total_read in at
least two places: in server->ops->check_message and cifs_dump_mem().

There may be other places in the code that assume server->total_read
to be correct. I would avoid simply removing this in all code paths
and would rather make a more specific fix for the offloaded reads.

--
Best regards,
Pavel Shilovsky

=D1=87=D1=82, 8 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 13:36, Steve French=
 <smfrench@gmail.com>:
>
> Fixed up 2 small checkpatch warnings and merged into cifs-2.6.git for-nex=
t
>
> On Thu, Oct 8, 2020 at 9:40 AM Rohith Surabattula
> <rohiths.msft@gmail.com> wrote:
> >
> > Hi All,
> >
> > With the "esize" mount option, I observed data corruption and cifs
> > reconnects during performance tests.
> >
> > TCP server info field server->total_read is modified parallely by
> > demultiplex thread and decrypt offload worker thread. server->total_rea=
d
> > is used in calculation to discard the remaining data of PDU which is
> > not read into memory.
> >
> > Because of parallel modification, =E2=80=9Cserver->total_read=E2=80=9D =
value got
> > corrupted and instead of discarding the remaining data, it discarded
> > some valid data from the next PDU.
> >
> > server->total_read field is already updated properly during read from
> > socket. So, no need to update the same field again after decryption.
> >
> > Regards,
> > Rohith
>
>
>
> --
> Thanks,
>
> Steve
