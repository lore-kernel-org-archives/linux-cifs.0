Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96279C433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 20 Mar 2022 02:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239284AbiCTCKq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Mar 2022 22:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234519AbiCTCKq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Mar 2022 22:10:46 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B3D33E2D
        for <linux-cifs@vger.kernel.org>; Sat, 19 Mar 2022 19:09:24 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id q14so2560839ljc.12
        for <linux-cifs@vger.kernel.org>; Sat, 19 Mar 2022 19:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=riZUb6tgrDfyScB1d7gIEZwjaGMhKhYKI2OrwP3yN3A=;
        b=Xeh4FelRGO1+VTl5FgXMZJgF/aAp0i/TbrxsBLSiM8Lky2zOj1C3yEDmK6LaL6kxdl
         sQDZJY1e4Wvbh956OhKYeFTfay2IDylH9LhyqDKiJTl9ySfiYF8Wo/nF7Vtx1U1He/do
         ckxEOXJYtjbdZF6eRwqJ62uWk1rhpx+yrO+O22sTeZsyxre3Fibj8aqWDqcPYr2IhmSg
         T4iq5T4ZYQel+jtyu5c+MBiKIB5aeMmtby5W0t2Eor4H/6ZlojaAzCL/8z6zEj9e+SfC
         WCrIPp0JK/toltJiThLEF4HujVAExehbFDOl4Yf5hJ4QMnDL6Qy4ZONRrEKm1bkPmACr
         GI0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=riZUb6tgrDfyScB1d7gIEZwjaGMhKhYKI2OrwP3yN3A=;
        b=0PfaAhizdt48M8VaPSJanLlIewm0tWbmOVLU+uei69cb/1gXM+pOBT4EugT+cbqrST
         jLbK1grNg88ftJq4YTSxy8BSy7dMk1/Y0R37asfPiIwcv5A3s+9+uhYzd3Vh+gzAEVms
         GaYyBc/20ZyF6cdYuTsHjZV1uYJv36jf0azAp8uFgRFpCQdi0ODcYNFWFnzMtg+C3p37
         ebNp7o0EBJksAQJLbUpRAI2zcbg601OLytLiUeTrd5bWLeKY2Iv7zsIg2kuiTSHOgc2w
         GR6Gja9qC9lHx5RcWMFYt1oYCDemhLmdAotSD3UW0lwVpuY322oHOGclli5SJGtXy55x
         L9GA==
X-Gm-Message-State: AOAM53240RV+5Lp9OlUgilOBv27IS1b1S0LLmRquBuI77UgVQXaOpjzj
        wR1qvGS+dUkOs4s8DlJCQmFpVP6Xz2XTwMhgNgNAVcdS
X-Google-Smtp-Source: ABdhPJxMuHt9H4OWW3oKsSRsIdw/7XccSFLVCBzQ1eGiiEJxS8n8y3sS+glWE5EogyxHTclmuGenjMV9zkE5HJYPFFA=
X-Received: by 2002:a2e:98d6:0:b0:247:ea32:a24d with SMTP id
 s22-20020a2e98d6000000b00247ea32a24dmr10964226ljj.314.1647742162496; Sat, 19
 Mar 2022 19:09:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvG6jmUKVi4zqRouFgYSjYxJjTExjmPtH64PAjFahE8dQ@mail.gmail.com>
 <570f1f21-ecd2-6f88-e78f-7c57a22ba7e9@talpey.com> <283E0E80-BDAA-45B4-B627-C7BF44C0D126@cjr.nz>
 <CAH2r5mv2E=zQ+nVjMuLGvz3CGMLxM2Cq4aUEnLd3ieRCQTOM8Q@mail.gmail.com>
 <CAKYAXd_dUnBLmAutFVWpOczRH-3U21vR51nHsNTjAVfUk1KEig@mail.gmail.com> <1ab1e73c-566c-7f1f-6cbf-5502b99611e8@talpey.com>
In-Reply-To: <1ab1e73c-566c-7f1f-6cbf-5502b99611e8@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 19 Mar 2022 21:09:11 -0500
Message-ID: <CAH2r5mssCz+Gj3dQjZsdk9zBqU0u1Nr3MdNox990vW79XhOaNQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix bad fids sent over wire
To:     Tom Talpey <tom@talpey.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Mar 19, 2022 at 8:45 PM Tom Talpey <tom@talpey.com> wrote:
>
> On 3/19/2022 9:22 PM, Namjae Jeon wrote:
> > 2022-03-20 3:34 GMT+09:00, Steve French <smfrench@gmail.com>:
> >> They probably should be always 'u64' everywhere (not le64) and change
> >> the code back in fs/smbfs_common/smb2pdu.h (was this due to ksmbd
> >> using the file and converting these fields in fs/smbfs_common) rather
> >> than the ones you changed
> > I don't understand why only FileId fields should be declared as u64 not le64.
>
> Because they're opaque to the client.
>
> > It means that FileID doesn't need byteswap in client?
>
> Correct. They are tested only for equality, or are placed in a packet
> verbatim and sent back to the server.
>
> > samba seems to
> > stores them in little-endian byte order.
>
> Again, unnecessary and dangerous, IMO.

Agree - safer to have opaque fields to be host endian, and a tiny bit faster.


-- 
Thanks,

Steve
