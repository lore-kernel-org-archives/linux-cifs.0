Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65CA8C05027
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Feb 2023 17:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjBTRhi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Feb 2023 12:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjBTRhh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Feb 2023 12:37:37 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A351F5C5
        for <linux-cifs@vger.kernel.org>; Mon, 20 Feb 2023 09:37:36 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id bx43so1737870ljb.12
        for <linux-cifs@vger.kernel.org>; Mon, 20 Feb 2023 09:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=a6i/Fa3V15COArboDY64tUFJKNuvSrVEy9eBrXHDHoE=;
        b=pDQ7ctsKC0ACUOcMudzMHO66iLbkmG4gURkvErY/Y3940OslzVSKm1GdGlvudo4hPA
         Rf97pLJAsdBbXQL1TjjmNi1pnGnNk9tBoYjmie/y93LFg7igSzO0UgWRD9/G43XWr1rS
         9NaQ9yNXAFMgxnNhU81UcDDOsWk/8fphFg5hju5aak8W4usc6ePBaAxebBxjLiGZX10h
         gKMtpMh74+XEgmEE6rSLCRQ9DLYAg6UIWM3DX3Owjq2TsP7o9UBs9/P8y3C/rNAGP/hV
         zRQousAWPE0LHdPoaZLRB+4fDyOCr4GbEdW/jCgNIHBiGEyvgXGIlex62cagrXLaj0pd
         h5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a6i/Fa3V15COArboDY64tUFJKNuvSrVEy9eBrXHDHoE=;
        b=pIJxkILtm7f0zgIW1PfhKvRI3EXdLLsyG3dk43WMUY0y7+UF3WdXSFT3xHfN8LzxyZ
         TdlV7gQ8JWRxZSbfiKNkoWiB3ITBsSioC6gHM7PS5Ej/54KjCdLEOtKKDGpGlck5rKsP
         BKlJW8gpjSORaEStJZ0chbC1PPsyGsZwb8mkgXBTgPn+CysOWVM8cw2GdQ/gOd2zYpHE
         HjAeGikmjWu8li2HEWYAtHkF0OSrPB6+kxBmkSC4ZllH7Cz1BL1+brZRs1nn4TCrBWc4
         S/SauoiZARhltZo14omQZWXdNRS1Se2YChXVIEYC50jH0KEXt+9sd3OM2wXOAqvJo3ho
         K/Vg==
X-Gm-Message-State: AO0yUKXGTTLCbo/dyqgbd4UwIdR5EfDKyZ3KoMHlmB65UOiN45MWR2za
        WI4YuI11B25ySwHurjVI4ad7RO84YCxPkfULKMU=
X-Google-Smtp-Source: AK7set9Y8PFZOlYc1hYVz14KcS+IjvsBrfiAzU1txklVqVZfBPyUWFDWltJsf6IBXm67lBt3tABSeLSxtiHu2ILhX+8=
X-Received: by 2002:a2e:a269:0:b0:293:535f:2d4c with SMTP id
 k9-20020a2ea269000000b00293535f2d4cmr881649ljm.7.1676914654508; Mon, 20 Feb
 2023 09:37:34 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=pOGn4Gc3T1FOQCmhFxM=-Wn_0GcV9owty8NELjQ1r0vA@mail.gmail.com>
In-Reply-To: <CANT5p=pOGn4Gc3T1FOQCmhFxM=-Wn_0GcV9owty8NELjQ1r0vA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 20 Feb 2023 11:37:23 -0600
Message-ID: <CAH2r5msUo2QqxHmyNd69U==XvTG49tRb7A2=2mWWd=mrPiojCQ@mail.gmail.com>
Subject: Re: Fixes to multichannel reconnects
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Bharath S M <bharathsm@microsoft.com>,
        Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

What happened to these two patches? I couldn't find them

ea8c07e0e326 cifs: reuse cifs_match_ipaddr for comparison of dstaddr too
2cb516a29314 cifs: match even the scope id for ipv6 addresses

On Mon, Feb 20, 2023 at 7:31 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Stress testing of multichannel reconnect in Microsoft uncovered a few
> bugs in multichannel reconnect codepath (particularly when reconnects
> happen in parallel).
>
> I have fixed those in the following commits:
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/a87bb308b7d126b522d4390dbf37f63e743133ac.patch
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/0a95e989840d2617940ad4670c52b43646b491ad.patch
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/5640b4cd537b70a690e3c1a6aa22afced71c8c87.patch
>
> Also fixed a couple of regressions:
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/30a563a20e00f99899b703f32feb30793b04bfcb.patch
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/0c1c85c0720ef8fa3bac3819315e8d9311926915.patch
>
> All the above are critical fixes that we should probably CC stable.
>
> And a minor fix:
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/be94b055601c48f4156e48da7b282d51970bad07.patch
>
> I've tried to break up the changes into separate patches. Please review.
>
> --
> Regards,
> Shyam



-- 
Thanks,

Steve
