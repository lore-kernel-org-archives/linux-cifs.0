Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E9CC433E9
	for <linux-cifs@archiver.kernel.org>; Sun, 21 Feb 2021 15:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43ABC64EF2
	for <linux-cifs@archiver.kernel.org>; Sun, 21 Feb 2021 15:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhBUP1c (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 21 Feb 2021 10:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbhBUP1b (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 21 Feb 2021 10:27:31 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FB9C061574
        for <linux-cifs@vger.kernel.org>; Sun, 21 Feb 2021 07:26:49 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id p2so18713955edm.12
        for <linux-cifs@vger.kernel.org>; Sun, 21 Feb 2021 07:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=G1bc7yDplyAsVtQQ1n9sdaPIPuw+VENcUcfqw3Ts6yc=;
        b=Wn6nV9ErNSEYwb7L9Rq8VGsnYoCwJEZi2kgPqJ2ClbgWwTqGBCPlBX0i0rF5EqL+c4
         02mfv1m0/rJ0vySGIABEFws+dWpfCZMUT2iaw2DCp23OR1ZV1y+TIkyeH+bf70Fzdv9z
         48LJpEQdSisefJL9xC4apABfECw7OSoxM2Vwby7twafy1SaURC9XG3FsDrFL0F8QSbrL
         e7KjXnhjeXB1yoadRd4/9R230JexOUJD9fMFxQMsVvWEQp2pCmt8S2DCY1Ff0tzL2vmL
         6LR1Cxf2rN7VJzLb4g6dydBiQqXkjNho9EsftYbXx3/aDdYyiCNbyOXKcbRBoKHU4FQT
         2t3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=G1bc7yDplyAsVtQQ1n9sdaPIPuw+VENcUcfqw3Ts6yc=;
        b=QWpJVDqRzL4oMHlabRClXDRmOYnqp2UwjrtO0z+lgm3iL580thvxJwOc3oFVBnoQqu
         zJwHxQZiboYxn4bsDvJes4gG/NjS5Nz0anIbqNqVQTlpC7KIeIerRpwtKsv2AewDHmxW
         hI4XpIhRypVKBcWpJ8anE8av8MYfG7SHsvnZC1WiXIZT+z7l7xY3LotYF1h1kGzVVfX4
         3VRsQx3HgFuWMFGPgrCEjX6n4oEZyj1T0zxv1iL/YQsf0dItJhw1nVEf6Z6syNYWjrh9
         T/Nmlio3j4D7McLM4mXrPBAzlap4JUXemkFy5Sgz7Zc5Ltvp9VPONxiUMHz45AUl/TdY
         cXaw==
X-Gm-Message-State: AOAM533XFxpLeOPwh3tdiJ/MGOcA0ck3GUaNSx9HqDMTtFzgIQzColCM
        XdbbBS9Yzbhp60b9DsSOTdh+WgYsPPxLg+TvpFY=
X-Google-Smtp-Source: ABdhPJwPt6v4GjMpGbUd+1HU0qVROSnrH538LDJ1trWTYAb84CmZrLdePpMY5xN+OCSlKLjnJ5p/B2i/XLdkM1hRzSU=
X-Received: by 2002:aa7:c988:: with SMTP id c8mr1648172edt.218.1613921207300;
 Sun, 21 Feb 2021 07:26:47 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=r-okF50zXNU8wnqv-mUUwAcGTyZ1_6YumQb_tY94LmFw@mail.gmail.com>
 <CANT5p=rHYSaYNiv4OUi_5vj4S_XH_vJmbVPFPAyTFBxvCgwGVw@mail.gmail.com>
In-Reply-To: <CANT5p=rHYSaYNiv4OUi_5vj4S_XH_vJmbVPFPAyTFBxvCgwGVw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sun, 21 Feb 2021 07:26:36 -0800
Message-ID: <CANT5p=o80ga62V9DGZ8CN=ETfB5_Ob8vjBYK6HuT8wm26HwSOA@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: Fix unix perm bits to cifsacl conversion for
 "other" bits.
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: multipart/mixed; boundary="00000000000043504c05bbda5096"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000043504c05bbda5096
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Steve,

It looks like the first patch I sent (above) was not the latest version.
I found it when testing one other cifsacl patch today.

Attached the fix for this bug.

Also attached xfstest for verifying that it works.
@Aur=C3=A9lien Aptel could you please review the test and add it to the
buildbot for cifsacl and modefromsid? When none of those two are used,
the test will fail.

Regards,
Shyam

On Mon, Nov 9, 2020 at 9:46 AM Shyam Prasad N <nspmangalore@gmail.com> wrot=
e:
>
> Also attaching the sticky bit implementation.
> Have tested out some positive and negative test cases too. Works well,
> from what I can tell.
>
> Regards,
> Shyam
>
> On Mon, Nov 9, 2020 at 11:12 PM Shyam Prasad N <nspmangalore@gmail.com> w=
rote:
> >
> > Hi Steve,
> >
> > Here's the patch as per the discussion. I'm trying to maintain a
> > preferred order of ACEs as much as possible. I had to modify the
> > reverse conversion logic, since deny ACEs can appear in the middle of
> > the list now.
> >
> > Tested thoroughly with many permission modes, conversions and reverse
> > conversions.
> >
> > FYI, there's a sticky bit implementation which I've patched on top of
> > this fix. Will send that for review soon.
> >
> > --
> > -Shyam
>
>
>
> --
> -Shyam



--=20
Regards,
Shyam

--00000000000043504c05bbda5096
Content-Type: application/octet-stream; 
	name="0001-cifs-Fix-cifsacl-ACE-mask-for-group-and-others.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Fix-cifsacl-ACE-mask-for-group-and-others.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_klf6uujz0>
X-Attachment-Id: f_klf6uujz0

RnJvbSA5MWQ1NDc4NTBmNmFlMzA0NzE5ZjE4NDdlNzI0MDE5Y2FlNmVjODUwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBTdW4sIDIxIEZlYiAyMDIxIDA4OjIxOjI1ICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogRml4IGNpZnNhY2wgQUNFIG1hc2sgZm9yIGdyb3VwIGFuZCBvdGhlcnMuCgpBIHR3byBs
aW5lIGZpeCB3aGljaCBJIG1hZGUgd2hpbGUgdGVzdGluZyBteSBwcmV2IGZpeCB3aXRoCmNpZnNh
Y2wgbW9kZSBjb252ZXJzaW9ucyBzZWVtIHRvIGhhdmUgZ29uZSBtaXNzaW5nIGluIHRoZSBmaW5h
bCBmaXgKdGhhdCB3YXMgc3VibWl0dGVkLiBUaGlzIGlzIHRoYXQgZml4LgoKU2lnbmVkLW9mZi1i
eTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2Np
ZnNhY2wuaCB8IDQgKystLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNhY2wuaCBiL2ZzL2NpZnMvY2lmc2Fj
bC5oCmluZGV4IGZmN2ZkMDg2MmUyOC4uZDllNzA0OTc5ZDk5IDEwMDY0NAotLS0gYS9mcy9jaWZz
L2NpZnNhY2wuaAorKysgYi9mcy9jaWZzL2NpZnNhY2wuaApAQCAtMzEsOCArMzEsOCBAQAogI2Rl
ZmluZSBFWEVDX0JJVCAgICAgICAgMHgxCiAKICNkZWZpbmUgQUNMX09XTkVSX01BU0sgMDcwMAot
I2RlZmluZSBBQ0xfR1JPVVBfTUFTSyAwNzcwCi0jZGVmaW5lIEFDTF9FVkVSWU9ORV9NQVNLIDA3
NzcKKyNkZWZpbmUgQUNMX0dST1VQX01BU0sgMDA3MAorI2RlZmluZSBBQ0xfRVZFUllPTkVfTUFT
SyAwMDA3CiAKICNkZWZpbmUgVUJJVFNISUZUCTYKICNkZWZpbmUgR0JJVFNISUZUCTMKLS0gCjIu
MjUuMQoK
--00000000000043504c05bbda5096
Content-Type: application/octet-stream; name="002-modecheck.out"
Content-Disposition: attachment; filename="002-modecheck.out"
Content-Transfer-Encoding: base64
Content-ID: <f_klfb09v42>
X-Attachment-Id: f_klfb09v42

UUEgb3V0cHV0IGNyZWF0ZWQgYnkgMDAyLW1vZGVjaGVjawpjcmVhdGluZyBmaWxlcy4uLgpzbGVl
cGluZyBmb3IgMjBzLi4uCmNoZWNraW5nIG1vZGViaXRzLi4uCnN1Y2Nlc3MhCg==
--00000000000043504c05bbda5096
Content-Type: application/octet-stream; name=002-modecheck
Content-Disposition: attachment; filename=002-modecheck
Content-Transfer-Encoding: base64
Content-ID: <f_klfb09uz1>
X-Attachment-Id: f_klfb09uz1

IyEgL2Jpbi9iYXNoCiMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAKIyBDb3B5cmln
aHQgKGMpIDIwMjEgWU9VUiBOQU1FIEhFUkUuICBBbGwgUmlnaHRzIFJlc2VydmVkLgojCiMgRlMg
UUEgVGVzdCAwMDItbW9kZWNoZWNrCiMKIyB3aGF0IGFtIEkgaGVyZSBmb3I/CiMKc2VxPWBiYXNl
bmFtZSAkMGAKc2VxcmVzPSRSRVNVTFRfRElSLyRzZXEKZWNobyAiUUEgb3V0cHV0IGNyZWF0ZWQg
YnkgJHNlcSIKCmhlcmU9YHB3ZGAKdG1wPS90bXAvJCQKc3RhdHVzPTEJIyBmYWlsdXJlIGlzIHRo
ZSBkZWZhdWx0IQp0cmFwICJfY2xlYW51cDsgZXhpdCBcJHN0YXR1cyIgMCAxIDIgMyAxNQoKX2Ns
ZWFudXAoKQp7CgljZCAvCglybSAtZiAkdG1wLioKfQoKIyBnZXQgc3RhbmRhcmQgZW52aXJvbm1l
bnQsIGZpbHRlcnMgYW5kIGNoZWNrcwouIC4vY29tbW9uL3JjCi4gLi9jb21tb24vZmlsdGVyCgoj
IHJlbW92ZSBwcmV2aW91cyAkc2VxcmVzLmZ1bGwgYmVmb3JlIHRlc3QKcm0gLWYgJHNlcXJlcy5m
dWxsCgojIHJlYWwgUUEgdGVzdCBzdGFydHMgaGVyZQoKIyBNb2RpZnkgYXMgYXBwcm9wcmlhdGUu
Cl9zdXBwb3J0ZWRfZnMgZ2VuZXJpYwpfcmVxdWlyZV90ZXN0CgplY2hvICJjcmVhdGluZyBmaWxl
cy4uLiIKaT0wCm1vZGU9MAp3aGlsZSBbICRtb2RlIC1sdCAwNzc3IF07IGRvCiAgICAgICAgZmls
ZW5hbWU9JChwcmludGYgJ21vZGVjaGVjay1maWxlLTAlbycgJG1vZGUpCiAgICAgICAgdG91Y2gg
JGZpbGVuYW1lCiAgICAgICAgY2htb2QgJChwcmludGYgJzAlbycgJG1vZGUpICRmaWxlbmFtZQog
ICAgICAgICMgY2hlY2tpbmcgZm9yIGFsbCBwb3NzaWJsZSB2YWx1ZXMgaXMgdG9vIHRpbWUgY29u
c3VtaW5nCiAgICAgICAgIyBpbmNyZW1lbnRpbmcgYnkgNSBjb3ZlcnMgbW9zdCB2YWx1ZXMKICAg
ICAgICBtb2RlPSQoKG1vZGUrNSkpCiAgICAgICAgaT0kKChpKzEpKQpkb25lCnRvdGFsPSRpCgpl
Y2hvICJzbGVlcGluZyBmb3IgMjBzLi4uIgojIGFjdGltZW8gaGFzIHRvIGJlIGxlc3NlciB0aGFu
IHRoZSBzbGVlcCBiZWxvdwpzbGVlcCAyMAoKZWNobyAiY2hlY2tpbmcgbW9kZWJpdHMuLi4iCmk9
MApmb3IgZmlsZW5hbWUgaW4gJChscyBtb2RlY2hlY2stZmlsZS0qKTsgZG8KICAgICAgICBleHBf
bW9kZT0kKCgkKGVjaG8gJGZpbGVuYW1lfHNlZCAncy9tb2RlY2hlY2stZmlsZS0vLycpKSkKICAg
ICAgICBtb2RlPSQoKDgjJChzdGF0IC0tcHJpbnRmPSIlYVxuIiAkZmlsZW5hbWUpKSkKICAgICAg
ICBpZiBbICRtb2RlIC1uZSAkZXhwX21vZGUgXTsgdGhlbgogICAgICAgICAgICAgICAgZWNobyAi
VW5leHBlY3RlZCBtb2RlICRtb2RlIGZvciBmaWxlICRmaWxlbmFtZS4gRXhwZWN0ZWQ6ICRleHBf
bW9kZSIKICAgICAgICAgICAgICAgIGV4aXQKICAgICAgICBmaQogICAgICAgIGk9JCgoaSsxKSkK
ZG9uZQoKaWYgWyAkaSAtbmUgJHRvdGFsIF07IHRoZW4KICAgICAgICBlY2hvICJVbmV4cGVjdGVk
IG51bWJlciBvZiBmaWxlczogJGkuIEV4cGVjdGVkOiAkdG90YWwiCiAgICAgICAgZXhpdApmaQoK
ZWNobyAic3VjY2VzcyEiCgojIHN1Y2Nlc3MsIGFsbCBkb25lCnN0YXR1cz0wCmV4aXQKCg==
--00000000000043504c05bbda5096--
