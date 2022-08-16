Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 834ACC3F6B0
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Aug 2022 06:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiHPGmf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Aug 2022 02:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiHPGmT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Aug 2022 02:42:19 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F147E5E65C
        for <linux-cifs@vger.kernel.org>; Mon, 15 Aug 2022 18:30:07 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id j1so10910392wrw.1
        for <linux-cifs@vger.kernel.org>; Mon, 15 Aug 2022 18:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=JUbf5Eijhqu/dMNSJ2doU8MdXCLAaOcf3/H2plUztqM=;
        b=YAAm7a2Pe2lHAG6NnLWFu6Sn309IlxXAWq5KU5TSR4Bl7GvaNWCq//+uIOfmffR22I
         ikeaWUSfmHb2fo0URXKEfmWC194wsBNlTNqGaSZsid5t5+POq5PfN5C5P4vYcf0J/w4u
         RKjjSEpz0ON2Ljji8XKQPJ5Ipol3Xdzb9TjMXONHc+mIqNiiwQwLapt8DW67Tc8ym4hA
         aNlxr/XNw6U1NyDKquB5moG0NqPzATsEKPvo0USKedSx7ZNj/8iNCJ2N/NZ9B6DZXoJ+
         PuwvI3si2xk1c5m1OoXU8MIrEFj01y9wZUL8x/qFzrR7k5Mn+Z4u7OCHw0af619vWSO7
         PQuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=JUbf5Eijhqu/dMNSJ2doU8MdXCLAaOcf3/H2plUztqM=;
        b=Tj49T9j2bQFaOqVVRPndWp9H59hXVh5hyLUTrjT5f0Liv5BFKO60stFxAOauZfIJo1
         8wzZSzg9xGnQATtWgNWfdkMyVLVIzd28KTXf7R/beVFuroePcLlsdlymjsFnJ42feDNr
         ZDc3yEEGEH0HJB2Dr2+bD4V8nqsMottvyBEMThpugtfahaBPxzSZJlqH/AUeDS0qlscG
         3EGcYQikS1nrS1nDgC2cBmADlYi5K0fUTiT3bw8is4j35D/fsyFRSpd8P2WMbkZAEkHE
         F9nvI8Z2wiPHzlE9gM1RaomPkKptLc9rXBHOiVBYDUwBe4dlcaLi66ibSuSR0RRS8NSE
         O5vw==
X-Gm-Message-State: ACgBeo1aeCgOun3sTPNglFzhtkSIkfVlwLEGg61jmDzNSDDWsyEK9LMx
        UVRY4EZtKThhu+QCsfVHgq+hF6u+CUiF5MztFT8=
X-Google-Smtp-Source: AA6agR7Mw/E+4mXorSCCJmvTa22Deq/A1PftnyJq+Ui6cvmPeIeC3kutryzlgToeSzakevr9S6DdMWwjVBxkqnem7zA=
X-Received: by 2002:a5d:5266:0:b0:21f:1280:85f with SMTP id
 l6-20020a5d5266000000b0021f1280085fmr10372373wrc.412.1660613406374; Mon, 15
 Aug 2022 18:30:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msE-duSk+O2PJoBKzo2ip9y9e1TiYB1pvX3TY6R9Rq21Q@mail.gmail.com>
In-Reply-To: <CAH2r5msE-duSk+O2PJoBKzo2ip9y9e1TiYB1pvX3TY6R9Rq21Q@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Tue, 16 Aug 2022 10:29:54 +0900
Message-ID: <CANFS6basD85ssihWeGT4HqNgLX8DGvaZx++gr=N=oUBO1j03ZA@mail.gmail.com>
Subject: Re: Suspicious xfstest failures to ksmbd
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 5=EC=9B=94 29=EC=9D=BC (=EC=9D=BC) =EC=98=A4=EC=A0=84 7:38, S=
teve French <smfrench@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Noticed a few differences between ksmbd test results and other servers
> that may be server bugs:
> generic/615 22s ... - output mismatch (see
> /home/smfrench/xfstests-dev/results//generic/615.out.bad)
>     --- tests/generic/615.out   2022-01-30 15:05:53.495186894 -0600
>     +++ /home/smfrench/xfstests-dev/results//generic/615.out.bad
>  2022-05-28 16:29:12.603177975 -0500
>     @@ -1,3 +1,4 @@
>      QA output created by 615
>      Testing buffered writes
>     +error: stat(2) reported zero blocks
>      Testing direct IO writes
>     ...
>     (Run 'diff -u /home/smfrench/xfstests-dev/tests/generic/615.out
> /home/smfrench/xfstests-dev/results//generic/615.out.bad'  to see the
> entire diff)
>
> also test 208 fails:
> generic/208 201s ... [failed, exit status 1]- output mismatch (see
> /home/smfrench/xfstests-dev/results//generic/208.out.bad)
>     --- tests/generic/208.out   2020-01-24 17:11:18.720859829 -0600
>     +++ /home/smfrench/xfstests-dev/results//generic/208.out.bad
>  2022-05-27 21:43:43.204933555 -0500
>     @@ -1,2 +1,2 @@
>      QA output created by 208
>     -ran for 200 seconds without error, passing
>     +buffered write returned 12582912
>     \ No newline at end of file
>
> Tests generic/472, generic/497 and generic/554 (swapfile tests) are
> skipped to ksmbd (with "swapfile not supported") but not to Samba
>

The patch, "ksmbd: remove unnecessary generic_fillattr in smb2_open"
fixes generic/472 and generic/497. But in the kernel 5.19 or later,
These still are skipped for ksmbd and Samba. Because swap_rw, a new
address_space operation is not implemented in cifs.

>
> Also would be interesting to see why test generic/586 fails (although
> this fails to multiple servers, could be client bug):
> generic/586 11s ... - output mismatch (see
> /home/smfrench/xfstests-dev/results//generic/586.out.bad)
>     --- tests/generic/586.out   2020-06-14 15:13:59.924160846 -0500
>     +++ /home/smfrench/xfstests-dev/results//generic/586.out.bad
>  2022-05-28 16:28:54.723201574 -0500
>     @@ -1,2 +1,101 @@
>      QA output created by 586
>     +[0]: sbuf.st_size=3D1048576, expected 2097152.
>     +[1]: sbuf.st_size=3D1048576, expected 2097152.
>
>
> Test 213 should also correctly return no space on disk (could be client b=
ug)
> generic/213 0s ... - output mismatch (see
> /home/smfrench/xfstests-dev/results//generic/213.out.bad)
>     --- tests/generic/213.out   2020-01-24 17:11:18.720859829 -0600
>     +++ /home/smfrench/xfstests-dev/results//generic/213.out.bad
>  2022-05-27 18:50:38.984025733 -0500
>     @@ -1,4 +1,3 @@
>      QA output created by 213
>      We should get: fallocate: No space left on device
>      Strangely, xfs_io sometimes says "Success" when something went wrong=
, FYI
>     -fallocate: No space left on device
>
>
> -
>
> --
> Thanks,
>
> Steve



--=20
Thanks,
Hyunchul
