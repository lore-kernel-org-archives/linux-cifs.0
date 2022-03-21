Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 579B9C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 02:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344141AbiCUCPE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 20 Mar 2022 22:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbiCUCPD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 20 Mar 2022 22:15:03 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC9E3AA6F
        for <linux-cifs@vger.kernel.org>; Sun, 20 Mar 2022 19:13:38 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2d07ae0b1c0so141230397b3.2
        for <linux-cifs@vger.kernel.org>; Sun, 20 Mar 2022 19:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GztCmjK4G/jhboDimIaB1Z/Qpz0vQ5PHDEjorvQQYKk=;
        b=GZWug1q4HhT0OnysCmlBnFvDv77Q91D9aMupHyAt5ha84xjoZl+cGEgXt9/N8/bPsa
         MD5Xf8BHf2UvwNgCiDZxdeDW7nTZovXwCMDApO1QsYZTP6bw8xjg/HlPZwFRw4Lk3MkT
         HE9M1qXwi4InhIMoEgX+/c7LYQb1b4lJHTvfAVONlcePrrpoWkEW0SVoCVF33HQBRzEg
         O1fzGm5+gQniS2C6dazvdEJWoa8Lv3tFHHoIdy6PW7k9WGWcgZml9JSpjiSNVKnbM5uO
         NApoWZNy72toexnS6XQkkYLZLXjK2xV9MT3sH5AZ8FXLTkeO6jIESpdrCvWuj1HCoDF/
         Cgjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GztCmjK4G/jhboDimIaB1Z/Qpz0vQ5PHDEjorvQQYKk=;
        b=W1y07KR2ltzlLSBxeff9QuQFZVsvizrk56klRsCvig7Dn8B/IghPrJGZjQbMy0tfKa
         Xn+8++yaraCzGJPvlOTsGMlVdwZNLNiDRAmCvgyUgP/wUyyWHU0Pp/ZUkDX/0WW91V62
         TUYi9PnJmPDtAXBueZy4/nrI7079pi0coGdaecepXktuM0209Z09hODuMUN2lGafdOHR
         Ec6E1+10yZAi72h5nsf230kVv+zIlVJ3GyyXkIb7Jc5A14QDNUDLapdBlooDl3eLAz8f
         jlL5UlCcN7UWaDggaK1Lc/3hFDSHFZDMxCrM+jo34DrcpbVYFF2UFwUczFtAZ9BGrlhe
         yMbA==
X-Gm-Message-State: AOAM532nv4q6fQ6pHelXy28FEiCm2HlkEG+BNWombUrx5oScoEcvUNRe
        r4BY1ZZbar3YL6izdIk2n8c3G5Ue0ljEhIOU6V5vSh29
X-Google-Smtp-Source: ABdhPJwqrezffPs1oBorRiRyS4VJm6mtJCkrv8Y3OM1x5O5kBCT6bBSClBXKUdsA2jh+O+VkBE3iNP9dRb0yDtQDrqw=
X-Received: by 2002:a81:3ad3:0:b0:2db:49b2:5795 with SMTP id
 h202-20020a813ad3000000b002db49b25795mr21758082ywa.424.1647828818031; Sun, 20
 Mar 2022 19:13:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvG6jmUKVi4zqRouFgYSjYxJjTExjmPtH64PAjFahE8dQ@mail.gmail.com>
 <570f1f21-ecd2-6f88-e78f-7c57a22ba7e9@talpey.com> <283E0E80-BDAA-45B4-B627-C7BF44C0D126@cjr.nz>
 <CAH2r5mv2E=zQ+nVjMuLGvz3CGMLxM2Cq4aUEnLd3ieRCQTOM8Q@mail.gmail.com>
In-Reply-To: <CAH2r5mv2E=zQ+nVjMuLGvz3CGMLxM2Cq4aUEnLd3ieRCQTOM8Q@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Mon, 21 Mar 2022 12:13:26 +1000
Message-ID: <CAN05THQTnerXYrN8bCuXU2zf3pQjRiC+TVpBW+u4F5n2U+-M2A@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix bad fids sent over wire
To:     Steve French <smfrench@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Mar 20, 2022 at 7:24 PM Steve French <smfrench@gmail.com> wrote:
>
> They probably should be always 'u64' everywhere (not le64) and change
> the code back in fs/smbfs_common/smb2pdu.h (was this due to ksmbd
> using the file and converting these fields in fs/smbfs_common) rather
> than the ones you changed

I agree, they should not be le64 as that implies there is a byteorder
for this field, so u64 seems better.

(Technically, it should probably not even be an integer and instead be
unsigned char[8]
but that seems like overkill.)


>
>
> On Sat, Mar 19, 2022 at 11:01 AM Paulo Alcantara <pc@cjr.nz> wrote:
> >
> > Yes, I agreed. Why not simply store them as le64 and avoid the byteswapping altogether?
> >
> > On 19 March 2022 09:06:55 GMT-03:00, Tom Talpey <tom@talpey.com> wrote:
> >>
> >>
> >> On 3/19/2022 12:23 AM, Steve French wrote:
> >>>
> >>> Any comments on Paulo's patch? It fixes an endian conversion problem
> >>> that can affect file ids used on big endian archs.  I will add cc:
> >>> stable
> >>>
> >>> https://git.cjr.nz/linux.git/commit/?h=cifs-bad-fid-fixes&id=a857bb6b15646a7946fafb281878ddf498107dc3
> >>
> >>
> >> It seems a bad idea to be storing opaque fields in le64 integers, then
> >> byteswapping them when they go back on the wire. Wouldn't it be better
> >> to make them u8[8] arrays and just use memcpy/memcmp?
> >>
> >> Tom.
>
>
>
> --
> Thanks,
>
> Steve
