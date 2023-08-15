Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17592C001B0
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Aug 2023 18:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239159AbjHOSg2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Aug 2023 14:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239156AbjHOSgB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Aug 2023 14:36:01 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2A610C8
        for <linux-cifs@vger.kernel.org>; Tue, 15 Aug 2023 11:35:59 -0700 (PDT)
Message-ID: <36aa44ddae1161de7494a6886952a3fa.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692124557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7YE2tVAmoC8/z3tO4vfmTFuCUgYK/PHYw+4reD+nu9E=;
        b=WEQMPMioFOV4Zxm4pp4iIRbOGsZixtTIERxDNKZumlei6WljXlpa5L7YJm3DVItCVBZe5v
        8SH8K0q2XWOcVsCooM/xg8a7neBinymKa9pJsuKslzhACZaj0tZM7g1KthEQIGV3SDZkYN
        DgRin09BkLo9lcvCg8OokfzBkWa7giTTv4lI3IpID2hBHg5x3im/WBRXcwRfJOK+kTztWT
        YfnkjxV6QQyT7qdjsBnW2BF0HSAMRQrqS7z9/7r9StYEEmtamqGEuTVe3S+C5oUyNzufrE
        yDmQXit6WPOqz0YwHcPYWcdrz/PD+DWb5li2sxwKndsbU8IVOjb4EkhERSq/Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692124557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7YE2tVAmoC8/z3tO4vfmTFuCUgYK/PHYw+4reD+nu9E=;
        b=PSZN8thhmz8BI/zOmGzQDM3SS3aC0fxdXpEXv+6nISv3XcMdmvJu0GZrL6t8fzFfB63wxH
        +0Hls4rybc6kWMR+M16Gdu8eQU3/JAlsNIRjmDcYRUAGN6qPuhcTUa5/NHHWis1WU4WzZ1
        tCvf8oV6tdNo7HVSKMhiiUjNr19bUU1r3Q8N07tKsgtcCgSKW4ap38CZ1i4Gebxvfn0eQx
        NpPhxCDzO8dWuVw37x+VNCDPvlrN2gYyb7F1fk9WkwFGoBIVPG3lhXkWGBBsK5eq4+xzFx
        Qte260Bhek+z+/z0TgQEsIObs9qRXXndjkiPACsX3qICzM+yNJosMJXS7Bua9w==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1692124557; a=rsa-sha256;
        cv=none;
        b=nnOqZl686wyn+lprGlwLPloJrEU8xKmzm7CDgVHoCNWTldw84Nx0mJrG3QFPkEZTu1gNCx
        xkcllvqddCkFjBhOCPHA5N7S5GvkzAktAIELwDF9WnN0Tc8npztJZ1aYSEJR9Ep//s3pR4
        uYSFz8MIBREVFqoV4HKGJmcvgeiSKHFtU2uWtq8sKY8NY/5Uzk7hJi8Io9SZY/3SK7W9yX
        OS2dLkJvrJ3H33cTND7BycKMAA7wjptw2td+q0fetZ4BmGtEOTtzcWPb4k0fsXQHgp5D/L
        MOaG6OPotWZCkDnPVpAqnEJthIP22SQDMU9X+Qr4nPBWUrsHRW5ZXVTjJvqQcw==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Jeff Layton <jlayton@kernel.org>, Steve French <smfrench@gmail.com>
Cc:     =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Jay Shin <jaeshin@redhat.com>,
        Roberto Bergantinos Corpas <rbergant@redhat.com>
Subject: Re: [PATCH] cifs: missing null pointer check in cifs_mount
In-Reply-To: <0d52da2fbc5cc6704d23aca657d85ae32b18cfaa.camel@kernel.org>
References: <CAH2r5mvxp8OZthKPQGCv82xEkNW+z7SN_QhdRUMnHJ2Fm4pJqA@mail.gmail.com>
 <875yy4red3.fsf@suse.com> <B3F6DE12-CA6D-47BD-9383-B4BD2F73FCBC@cjr.nz>
 <CAH2r5mspWoea04K3Veuy9b-4k_TOLvuA13Xxnc8o0c=8g8zJrg@mail.gmail.com>
 <84c22724edac345b01e1e4b5527426e00b0be3e7.camel@kernel.org>
 <169d12e72d7d732d32051d22f255c5df.pc@manguebit.com>
 <7f1c7940764425cbcf6f6585d138ef38e6618581.camel@kernel.org>
 <cca8280bb933aa149de1bb9115d2fb3a.pc@manguebit.com>
 <a3a8f7a3e90541f20ef93e7f02f0a877661d8999.camel@kernel.org>
 <0d52da2fbc5cc6704d23aca657d85ae32b18cfaa.camel@kernel.org>
Date:   Tue, 15 Aug 2023 15:35:53 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> FWIW, I took a look at v5.15.125 and I don't see the same bug there. It
> probably got fixed inadvertently with some other backporting. Looks like
> this is only a problem for older, non-stable-series kernels.

Thanks for looking into that!  Really appreciate it.

> The patch I created for RHEL8 is attached though, if you're
> interested.

LGTM.
