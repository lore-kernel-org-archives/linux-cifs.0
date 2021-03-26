Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46BD0C433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 16:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 182B46193C
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 16:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhCZQIr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Mar 2021 12:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbhCZQIe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Mar 2021 12:08:34 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871C9C0613AA
        for <linux-cifs@vger.kernel.org>; Fri, 26 Mar 2021 09:08:33 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id q29so8401720lfb.4
        for <linux-cifs@vger.kernel.org>; Fri, 26 Mar 2021 09:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZcJBriMQ6SpXMw91Ve9k4QpmFLzO9O/3S5VRTmyJTVM=;
        b=M8z4zefpzKId6YPneo1+9sArC5XgSjpcZDP4zgpP3CGjx9sFKv1qW5s9eXwwgCVqxi
         oDou9FfaY2lfY4HGmpzk+fW1D46z6C1qcdNEtqguKINrexSsopmOIhTHUNxw5tLQtQNQ
         0QeU9Yu0fRAfuUQ5Guhq6ly9377KdwqlL+/LYzI7GmzPZSBRuMstJqS6ox8gnHZ/H/Vc
         ZswyKfKyUJxWnrs03LoLes33FMa+BxGYncMCCLF9UVQmoHFIYi2aqh+WZBVcpqolX94+
         5BH1aoZ1Rp/Ti6ZmHrIe7q12Z6saeCycECe2JayODaZVY1WemfQhmhtQPTzLRDrqyt4b
         tC1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZcJBriMQ6SpXMw91Ve9k4QpmFLzO9O/3S5VRTmyJTVM=;
        b=VJTJTlBRjtl59b9giGhNyJZXAGipLJwbG/viDPTVV4bTbg94jRkYgGmHyeTQIqYRwc
         0C4gN+SOu9BKNUwc+0GGtv1YnSg36E8Pd3dUIxmUCXMPv4Mg/Q21p83AE3IWVIEkrS7h
         B5sDqzlmT1vsuT9bdxBZjrtlSuNXbP2erNKraulvlKqYY8qkzfKxRIiPQT/VghVj+DdC
         VDR73vYsLJXEZGqwikcFINovBcTUIhaRkGUB4KIY34nx6ubEZPRPrcpq5wv961tWqzFv
         B2CdWD1hhJRKFnJ8ej+E6R0UcSJupXb1Q8URaz8dhx2/9OqOdNN82qThoErAm3jY7dsI
         lVZQ==
X-Gm-Message-State: AOAM533y7gmELRDEg8Lg0nS6VUt36zY80VFfWvdhK/XVsl1ReqKP6a3q
        yTkL8Muz/TbG1V8OSn7UJVun9xhSuCvY88dDXQo=
X-Google-Smtp-Source: ABdhPJz1smuDRFST3gbw36JQyAEn7tdYBeWvCWWOcuva6fApYonO2rZyz/tUSVZQ6BdFBRu5KGM9JDLGId3q34KVHM8=
X-Received: by 2002:a05:6512:1311:: with SMTP id x17mr8507381lfu.307.1616774911967;
 Fri, 26 Mar 2021 09:08:31 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=rr-rDZ1Jo_rzM0_63-pHOKPcRSnML0ucOVkSBVWrSc4A@mail.gmail.com>
 <87a6qprk06.fsf@suse.com> <CAH2r5mtk7_e-DOb3E6jYQywFRN97mCfYfKrqTmA_PEzGSZQpXQ@mail.gmail.com>
In-Reply-To: <CAH2r5mtk7_e-DOb3E6jYQywFRN97mCfYfKrqTmA_PEzGSZQpXQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 26 Mar 2021 11:08:20 -0500
Message-ID: <CAH2r5mtfO0qVTY8L842ZF+Y8ngHCscUyBiLTXGgwwCe0+Z9CxQ@mail.gmail.com>
Subject: Re: cifs: Fix chmod with modefromsid when an older ACE already exists.
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000004f59a905be72be51"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000004f59a905be72be51
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry that was the wrong "Fixes" - it was "Retain old ACEs when converting.=
.."

I added a Fixes tag


On Fri, Mar 26, 2021 at 10:54 AM Steve French <smfrench@gmail.com> wrote:
>
> Presumably:
>
> commit 5171317dfd9afcf729799d31fffdbb9e71e45402
> Author: Shyam Prasad N <sprasad@microsoft.com>
> Date:   Wed Mar 10 10:22:27 2021 +0000
>
>     cifs: update new ACE pointer after populate_new_aces.
>
> On Fri, Mar 26, 2021 at 10:51 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wr=
ote:
> >
> > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > Found a regression in modefromsid with my last fix in cifsacl.
> > > Tested against mode check tests for both cifsacl and modefromsid this=
 time.
> >
> > Can you put a Fixes tag?
> >
> > Cheers,
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--0000000000004f59a905be72be51
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-Fix-chmod-with-modefromsid-when-an-older-ACE-al.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Fix-chmod-with-modefromsid-when-an-older-ACE-al.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kmqi12u00>
X-Attachment-Id: f_kmqi12u00

RnJvbSA0NTU2MzdkZDJlOTc2ZWM4YThmZmYxMmY1NmE0YjkyMTE1Mjk2Njk2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBGcmksIDI2IE1hciAyMDIxIDEwOjI4OjE2ICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogRml4IGNobW9kIHdpdGggbW9kZWZyb21zaWQgd2hlbiBhbiBvbGRlciBBQ0UgYWxyZWFk
eQogZXhpc3RzLgoKTXkgcmVjZW50IGZpeGVzIHRvIGNpZnNhY2wgdG8gbWFpbnRhaW4gaW5oZXJp
dGVkIEFDRXMgaGFkCnJlZ3Jlc3NlZCBtb2RlZnJvbXNpZCB3aGVuIGFuIG9sZGVyIEFDTCBhbHJl
YWR5IGV4aXN0cy4KCkZvdW5kIHRlc3RpbmcgeGZzdGVzdCA0OTUgd2l0aCBtb2RlZnJvbXNpZCBt
b3VudCBvcHRpb24KCkZpeGVzOiBmNTA2NTUwODg5N2EgKCJjaWZzOiBSZXRhaW4gb2xkIEFDRXMg
d2hlbiBjb252ZXJ0aW5nIGJldHdlZW4gbW9kZSBiaXRzIGFuZCBBQ0wiKQoKU2lnbmVkLW9mZi1i
eTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNvbT4KU2lnbmVkLW9mZi1ieTog
U3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc2Fj
bC5jIHwgMyArLS0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMiBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNhY2wuYyBiL2ZzL2NpZnMvY2lmc2FjbC5jCmlu
ZGV4IDJiZTIyYTVjNjkwZi4uZDE3OGNmODVlOTI2IDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNh
Y2wuYworKysgYi9mcy9jaWZzL2NpZnNhY2wuYwpAQCAtMTEzMCw4ICsxMTMwLDcgQEAgc3RhdGlj
IGludCBzZXRfY2htb2RfZGFjbChzdHJ1Y3QgY2lmc19hY2wgKnBkYWNsLCBzdHJ1Y3QgY2lmc19h
Y2wgKnBuZGFjbCwKIAkJfQogCiAJCS8qIElmIGl0J3MgYW55IG9uZSBvZiB0aGUgQUNFIHdlJ3Jl
IHJlcGxhY2luZywgc2tpcCEgKi8KLQkJaWYgKCFtb2RlX2Zyb21fc2lkICYmCi0JCQkJKChjb21w
YXJlX3NpZHMoJnBudGFjZS0+c2lkLCAmc2lkX3VuaXhfTkZTX21vZGUpID09IDApIHx8CisJCWlm
ICgoKGNvbXBhcmVfc2lkcygmcG50YWNlLT5zaWQsICZzaWRfdW5peF9ORlNfbW9kZSkgPT0gMCkg
fHwKIAkJCQkoY29tcGFyZV9zaWRzKCZwbnRhY2UtPnNpZCwgcG93bmVyc2lkKSA9PSAwKSB8fAog
CQkJCShjb21wYXJlX3NpZHMoJnBudGFjZS0+c2lkLCBwZ3Jwc2lkKSA9PSAwKSB8fAogCQkJCShj
b21wYXJlX3NpZHMoJnBudGFjZS0+c2lkLCAmc2lkX2V2ZXJ5b25lKSA9PSAwKSB8fAotLSAKMi4y
Ny4wCgo=
--0000000000004f59a905be72be51--
