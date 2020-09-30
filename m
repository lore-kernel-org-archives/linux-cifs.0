Return-Path: <SRS0=H1OG=DH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 516F9C4363D
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Sep 2020 21:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11DC12071E
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Sep 2020 21:13:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tP+asR19"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725799AbgI3VNt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Sep 2020 17:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3VNt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 30 Sep 2020 17:13:49 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5C0C061755
        for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2020 14:13:49 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id j76so2371599ybg.3
        for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2020 14:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XWZh5TTaZL/JrxLQE+ezAnN/H7M7/IC6XwTfxTqFzRI=;
        b=tP+asR19jcPp5z85eNY42vq7Ac4Fp/v5ip3wzLOM/VENyffArJpvcxuLuk9MjU8uyV
         ytrpB5iLJEtGCICSfzRZJoWNAMk2E38f7D+/ubUu/Q0kVEKYgxoV73XcXREJPd7RRwFM
         mIgOOhrjC0048i5Yx+36fgRK8/NOXP+atC8rbolvpYjscxYpk0W7AGaTCQySEQvfNKsF
         +2u4Fih0xS2KOfmYJX4JUdcNtgUpsJHE8MOsSfa2AvEfD5qrjm4nvb625E1+Jw/Is56Z
         QwpwuS1ZL01r/ucaDagaRsTGqcrM7Zapl4wpsUZzzuyp4+ypyqXPCujc76+M2BfiGty9
         itUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XWZh5TTaZL/JrxLQE+ezAnN/H7M7/IC6XwTfxTqFzRI=;
        b=UfB6SrzCksx1CnuvprrErboAPr9iS4Ioh1Z+0Y1u6TxkOpBRwQv0Ii1YPCQZ9aqabR
         NAsJztWsJlGTJMTHU20fYxe/lzW3Y+bgVpDvLjxmYDHadECRjK7/pBcT8agar/F2eiwc
         G6dD6wB8aIPLD3AO+HC1AIKPUiz2HtcwreuxnKodK6SGDHFKplelEXJqebrFfgYokL2q
         3HsIOU5k9HguE3cKdbenqVK6AUu/8XaCLLADArYxz5D4WSx7ei6xEAyQlHHdyA4IkCBd
         44ufwP3nhgjTYLv15ytDAWToBqu4LpnPdhnIEHPC5ImhM853LtpXbLomm+Z187kGzckT
         sCEQ==
X-Gm-Message-State: AOAM533q48RtAuI2T+2pmXqR27AXYVmgrWzhvIaR4lhcb2Z0tujTvrym
        j5JrC/Ea3jPRJLWFSaYP/gDJjvt9+COCz6IytyA=
X-Google-Smtp-Source: ABdhPJxODx2Gttwh3UuHrM8KO9fZTyEEqXr6ujtwWxYPtyzvBgszN/1y5xPdD4DoRgG8P60XOdFutimZSe6gTo+3HTg=
X-Received: by 2002:a25:b98b:: with SMTP id r11mr6515596ybg.70.1601500428684;
 Wed, 30 Sep 2020 14:13:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200924003638.2668-1-pboris@amazon.com> <CAHhKpQ4UFhtfRhByRiAm6KPy=KAzttYzZADLfakbMwpsp5GjpA@mail.gmail.com>
 <CAH2r5mvWZSPjtg1g2FhZ+gZNpakdaFnugw=FhFV92Ed83VzAuQ@mail.gmail.com> <878scrk45e.fsf@suse.com>
In-Reply-To: <878scrk45e.fsf@suse.com>
From:   Boris Protopopov <boris.v.protopopov@gmail.com>
Date:   Wed, 30 Sep 2020 17:13:38 -0400
Message-ID: <CAHhKpQ5pVuxAW8=znu1oYReSE-KOrO=5g=BP1T-VzhQW7EZkJg@mail.gmail.com>
Subject: Re: [PATCH] Convert trailing spaces and periods in path components
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Steve French <smfrench@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I agree with testing, but also, looking at the comments:

/*
 * Convert 16 bit Unicode pathname to wire format from string in
current code
 * page. Conversion may involve remapping up the six characters that
are
 * only legal in POSIX-like OS (if they are present in the string).
Path
 * names are little endian 16 bit Unicode on the wire
 */
int
cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
                 const struct nls_table *cp, int map_chars)
{
        int i, charlen;
        int j =3D 0;
        char src_char;
        __le16 dst_char;
        wchar_t tmp;
        wchar_t *wchar_to;      /* UTF-16 */
        int ret;
        unicode_t u;

        if (map_chars =3D=3D NO_MAP_UNI_RSVD)
                return cifs_strtoUTF16(target, source, PATH_MAX, cp);

...

it would seem that as long as the correct map_chars is picked, it
should work correctly? The latter, if not automatically determined,
can be controlled with mount options, I believe.

Boris.

On Wed, Sep 30, 2020 at 5:25 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> Steve French <smfrench@gmail.com> writes:
> > tentatively merged ... running the usual functional tests
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2=
/builds/399
>
> We need to make sure it works with samba smb1&smb2 posix extensions.
> In smb1 posix extensions the paths are sent with / and \ is a valid
> component (and no restrictions on file name endings).
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
