Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D2A1C4338F
	for <linux-cifs@archiver.kernel.org>; Sat, 21 Aug 2021 03:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2674D611C3
	for <linux-cifs@archiver.kernel.org>; Sat, 21 Aug 2021 03:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhHUDt5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 Aug 2021 23:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhHUDt5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 20 Aug 2021 23:49:57 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA00C061575;
        Fri, 20 Aug 2021 20:49:17 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id u22so24609496lfq.13;
        Fri, 20 Aug 2021 20:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zHOVDDy6Elh+zfWbuB2hVkW/DiSiV2mlyNyWlRpko1k=;
        b=dDwcE8t7q/kyfCmqNuWd5qCbT4xcdx1l0pa96J5KWVMZ4d/FJdNXj53i4Zz0e/Ksj/
         ApUVZLoXFhXLBJge6j7CqP6X4Y0MgZ2MEjHd0LCKMzsB+LAWKLiitgiNKQPbtN3KX9L0
         DRVNkRQ77FenzaDRP8j4xfPdyE1WOQIpIDVaxu8Cj5YmdAi5EGo5o6/0w+ohtJhQmwBq
         uyEPvXuIe44GPXkmxkho++tNovgzAsuLXhbBzsGeB13wBpfiVeCLddD1Kx3jwIFDXN3H
         laxsPrnL96nMpcgDOYylmemk95dV9q9hCOSZgHIPdQWKJbBApQY3rhMIYNG+1PbJjDDj
         4/8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zHOVDDy6Elh+zfWbuB2hVkW/DiSiV2mlyNyWlRpko1k=;
        b=XPp8wofHzNZE4FMC8rDOQ4L22CT/GwpqhBy/w3btYLavExkNh5sw61NWWJNtE3R+H9
         A4FwsTmOnwEuAXD+7/b/s4mIs5fHGu8vJaNVA4l1vxgSQ+AYb+v8HPGwd8iMBFa9jY1y
         1t7eC7jLQ6fslsU2jmoZ3oGUota/tCchs2Y+uqtBNih3+biNaJjM9EZYEjjUivu2au9m
         OJCgshuAXMoGAnpZAF855ipCnYOFrQQ7uw08u+4095nvKUBZ+CrgpzrlF/hUWNpDoIUV
         liFnbmPKvgunSXwnLS9I68c4gy1PGYaeZEOK+ZIys0Lf9kWArrhJg0w8qpXsrdDA/TRF
         qa7g==
X-Gm-Message-State: AOAM531KILRomGaaYU72OLi3aVycs7DzQL0oVgRqSb4rGi6TxzwNe6CG
        +PL6bWRlkUVvmwnQk/AcrPLO3xcLV1Ce4mbUVU3nzJlJ6ms=
X-Google-Smtp-Source: ABdhPJz9Yp/cOICdPWWe7C4f0+W/y7G8ogcXIR/JW21OvDVIDHMjDp+d36/NP9TLWjzkPBR7HX1+myUjZfHpuQc0IS0=
X-Received: by 2002:a05:6512:3455:: with SMTP id j21mr12302316lfr.282.1629517755929;
 Fri, 20 Aug 2021 20:49:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvxX6BqLvgWO18QE+rQsAZoAzopvu5S3fyy45a+Y-w_MQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvxX6BqLvgWO18QE+rQsAZoAzopvu5S3fyy45a+Y-w_MQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 20 Aug 2021 22:49:04 -0500
Message-ID: <CAH2r5mvVHHgNcg1=YM25e7rK+LnXcvq0iTLW6Jf1BiP1XqoQDw@mail.gmail.com>
Subject: Re: [PATCH] oid_registry: Add OIDs for missing Spnego auth mechanisms
 to Macs
To:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Paulo Alcantara <pc@cjr.nz>
Cc:     samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000ff730805ca09aa11"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000ff730805ca09aa11
Content-Type: text/plain; charset="UTF-8"

Fixed a typo in the patch (missing ',').  Updated patch attached.


On Fri, Aug 20, 2021 at 6:18 PM Steve French <smfrench@gmail.com> wrote:
>
>  In testing mounts to Macs, noticed that the OIDS for some
>  GSSAPI/SPNEGO auth mechanisms sent by the server were not
>  recognized and were missing from the header.
>
>  Signed-off-by: Steve French <stfrench@microsoft.com>
>
> diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
> index 3d8db1f6a5db..2728842721bc 100644
> --- a/include/linux/oid_registry.h
> +++ b/include/linux/oid_registry.h
> @@ -70,6 +70,9 @@ enum OID {
>
>         OID_spnego,                     /* 1.3.6.1.5.5.2 */
>
> +       OID_IAKerb,                     /* 1.3.6.1.5.2.5 */
> +       OID_PKU2U                       /* 1.3.5.1.5.2.7 */
> +       OID_Scram,                      /* 1.3.6.1.5.5.14 */
>         OID_certAuthInfoAccess,         /* 1.3.6.1.5.5.7.1.1 */
>         OID_sha1,                       /* 1.3.14.3.2.26 */
>         OID_id_ansip384r1,              /* 1.3.132.0.34 */
> @@ -104,6 +107,10 @@ enum OID {
>         OID_authorityKeyIdentifier,     /* 2.5.29.35 */
>         OID_extKeyUsage,                /* 2.5.29.37 */
>
> +       /* Heimdal mechanisms */
> +       OID_NetlogonMechanism,          /* 1.2.752.43.14.2 */
> +       OID_appleLocalKdcSupported,     /* 1.2.752.43.14.3 */
> +
>         /* EC-RDSA */
>         OID_gostCPSignA,                /* 1.2.643.2.2.35.1 */
>         OID_gostCPSignB,                /* 1.2.643.2.2.35.2 */
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--000000000000ff730805ca09aa11
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-oid_registry-Add-OIDs-for-missing-Spnego-auth-mechan.patch"
Content-Disposition: attachment; 
	filename="0001-oid_registry-Add-OIDs-for-missing-Spnego-auth-mechan.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ksl8sgpp0>
X-Attachment-Id: f_ksl8sgpp0

RnJvbSA5ZDVhZTM0YWE5Y2ZhYTAzZDIwNWY0YTdhMjY4ZDVlZTliMzNjNTdlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjAgQXVnIDIwMjEgMTg6MTA6MzYgLTA1MDAKU3ViamVjdDogW1BBVENIXSBv
aWRfcmVnaXN0cnk6IEFkZCBPSURzIGZvciBtaXNzaW5nIFNwbmVnbyBhdXRoIG1lY2hhbmlzbXMg
dG8KIE1hY3MKCkluIHRlc3RpbmcgbW91bnRzIHRvIE1hY3MsIG5vdGljZWQgdGhhdCB0aGUgT0lE
UyBmb3Igc29tZQpHU1NBUEkvU1BORUdPIGF1dGggbWVjaGFuaXNtcyBzZW50IGJ5IHRoZSBzZXJ2
ZXIgd2VyZSBub3QKcmVjb2duaXplZCBhbmQgd2VyZSBtaXNzaW5nIGZyb20gdGhlIGhlYWRlci4K
ClJldmlld2VkLWJ5OiBQYXVsbyBBbGNhbnRhcmEgKFNVU0UpIDxwY0BjanIubno+ClNpZ25lZC1v
ZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBpbmNsdWRl
L2xpbnV4L29pZF9yZWdpc3RyeS5oIHwgNyArKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNl
cnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9vaWRfcmVnaXN0cnkuaCBiL2lu
Y2x1ZGUvbGludXgvb2lkX3JlZ2lzdHJ5LmgKaW5kZXggM2Q4ZGIxZjZhNWRiLi4wZjRhODkwMzky
MmEgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvb2lkX3JlZ2lzdHJ5LmgKKysrIGIvaW5jbHVk
ZS9saW51eC9vaWRfcmVnaXN0cnkuaApAQCAtNzAsNiArNzAsOSBAQCBlbnVtIE9JRCB7CiAKIAlP
SURfc3BuZWdvLAkJCS8qIDEuMy42LjEuNS41LjIgKi8KIAorCU9JRF9JQUtlcmIsCQkJLyogMS4z
LjYuMS41LjIuNSAqLworCU9JRF9QS1UyVSwJCQkvKiAxLjMuNS4xLjUuMi43ICovCisJT0lEX1Nj
cmFtLAkJCS8qIDEuMy42LjEuNS41LjE0ICovCiAJT0lEX2NlcnRBdXRoSW5mb0FjY2VzcywJCS8q
IDEuMy42LjEuNS41LjcuMS4xICovCiAJT0lEX3NoYTEsCQkJLyogMS4zLjE0LjMuMi4yNiAqLwog
CU9JRF9pZF9hbnNpcDM4NHIxLAkJLyogMS4zLjEzMi4wLjM0ICovCkBAIC0xMDQsNiArMTA3LDEw
IEBAIGVudW0gT0lEIHsKIAlPSURfYXV0aG9yaXR5S2V5SWRlbnRpZmllciwJLyogMi41LjI5LjM1
ICovCiAJT0lEX2V4dEtleVVzYWdlLAkJLyogMi41LjI5LjM3ICovCiAKKwkvKiBIZWltZGFsIG1l
Y2hhbmlzbXMgKi8KKwlPSURfTmV0bG9nb25NZWNoYW5pc20sCQkvKiAxLjIuNzUyLjQzLjE0LjIg
Ki8KKwlPSURfYXBwbGVMb2NhbEtkY1N1cHBvcnRlZCwJLyogMS4yLjc1Mi40My4xNC4zICovCisK
IAkvKiBFQy1SRFNBICovCiAJT0lEX2dvc3RDUFNpZ25BLAkJLyogMS4yLjY0My4yLjIuMzUuMSAq
LwogCU9JRF9nb3N0Q1BTaWduQiwJCS8qIDEuMi42NDMuMi4yLjM1LjIgKi8KLS0gCjIuMzAuMgoK
--000000000000ff730805ca09aa11--
