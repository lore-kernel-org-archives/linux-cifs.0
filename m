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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F6CC2B9F4
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 19:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 215C76128E
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 19:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhFVTT0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 15:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhFVTT0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Jun 2021 15:19:26 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E15C061574
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 12:17:09 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id f30so37777510lfj.1
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 12:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8J5/P9cTwig75FOsKoH/Noe2qm2nduVydfnYZ7xkS74=;
        b=E68qCkPCV5WhJsZoXiv7clHmx201aMn7l7d3cc1095qVrZKZGVCKRTY+VhxcTlODwy
         0avCb73q1l3ixDbzjAeaDprK7vqWI69n4fkafeAccESKdICQdxRUddhFJb4ttmifDi7m
         KWDCEJYNUl0DuxLXrS6p5pqSKFDjNGkjhmeyspaf0SJXBA96YQ+h4aP02buQHS/RqFWJ
         mfWFSc/1d4mmktD6xcfVCPNUsGvWW6vpxPj4C0826p0ya00oAIwk1JbdCF0VQptOkVlg
         2DNeZVUXa+y/ItzeOQWkyBDbpKGg7RTIy+v8yHFG/kgIsAQZey3/794PJ/R4m8CSEkuy
         4veQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8J5/P9cTwig75FOsKoH/Noe2qm2nduVydfnYZ7xkS74=;
        b=dWLgEniSh4hFwROYdZKpgO1H+WyX5FcLfdbu1PTJGCo3w5zPKAuzrU/mAza3A/3qML
         GwqhYcuGcY9Nz0GHPiEnfH4uS35h7LO4PQablwiHO53JpOz3kGw0aRivH0pTAwj9rf7B
         wECUpMF28Y3hqjH+JWdiwx6gtfS7B/Z95EP95f/XkMXwtHAMoIQxz1jBjiO3l8h05Gfz
         BPLCHS7DDTr7v/KVX5OeWa51UsZZaSUdQZWZKM3QaDFeR1UJgOBj/VPoOlPdZBM7oJU4
         lAbF/nOlFPRICirrhjxP87f8UDxHfvbVXOL9xIWz36270cihB4Wl5svzjc1mIz6Y7otC
         Mbeg==
X-Gm-Message-State: AOAM533Ta7cgBYezDPGjZ+ZNV2xlFFeygBBmlfbNEks4tXYlFjT3PBx+
        ZiloBXZUsycHhVvqnO2UF4ePaw1ttUYLKeERlHU=
X-Google-Smtp-Source: ABdhPJwpDZzNOkNO3RWESMXPtMQ47ecDeUnOLBxzRvNBIiZ8GFJM4syJb4tAwtUPWvDNPvN15JLSA5ONMwt7CTaQqgA=
X-Received: by 2002:a19:6a19:: with SMTP id u25mr4160977lfu.313.1624389427370;
 Tue, 22 Jun 2021 12:17:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mu4uEOP4r-KnF+bZGqPjdRwkaZanD1sE_JHuoK=jB_nnA@mail.gmail.com>
 <87r1guqk2d.fsf@suse.com> <CAH2r5muhe-2GNe0MgVvKy=X+wCxN5E2_tXT8wN8AKXCjanwqgg@mail.gmail.com>
In-Reply-To: <CAH2r5muhe-2GNe0MgVvKy=X+wCxN5E2_tXT8wN8AKXCjanwqgg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 22 Jun 2021 14:16:56 -0500
Message-ID: <CAH2r5msuTbaxKVXzM1Uq3cCyymATHhZ=jgqUMWLUS1aq3ktv8A@mail.gmail.com>
Subject: Re: 2 error cases in sid_to_id are ignored
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000cbb4b005c55fa246"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000cbb4b005c55fa246
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

OK - removed the two places where rc is set uselessly.

Patch attached

On Tue, Jun 22, 2021 at 2:05 PM Steve French <smfrench@gmail.com> wrote:
>
> Should we make the error noisier?
>
> Perhaps we could add a dynamic trace point for failed id mappings so
> we could debug these if problems with the upcall, malformed ids/SIDs
> etc?
>
> On Tue, Jun 22, 2021 at 5:18 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wro=
te:
> >
> > Steve French <smfrench@gmail.com> writes:
> > > Any thoughts on whether it would be better to return the errors, or
> > > continue the current strategy of simply using the default uid/gid for
> > > the mount and returning 0 (and removing the two places above where we
> > > set rc to non zero values, since rc will be overwritten with 0)?
> >
> > My opinion: I think best-effort would be better, so returning things as
> > default uid/gid (or possibly root).
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

--000000000000cbb4b005c55fa246
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-remove-two-cases-where-rc-is-set-unnecessarily-.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-remove-two-cases-where-rc-is-set-unnecessarily-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kq8filcq0>
X-Attachment-Id: f_kq8filcq0

RnJvbSA3YzNjYmY3ZGJjNWQ2N2JhNGIzZGY0YTUwMmZiYzI0NDFhZWRkMzZhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjIgSnVuIDIwMjEgMTQ6MDc6MzYgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiByZW1vdmUgdHdvIGNhc2VzIHdoZXJlIHJjIGlzIHNldCB1bm5lY2Vzc2FyaWx5IGluCiBz
aWRfdG9faWQKCkluIGJvdGggdGhlc2UgY2FzZXMgc2lkX3RvX2lkIHVuY29uZGl0aW9uYWxseSBy
ZXR1cm5lZCBzdWNjZXNzLCBhbmQKdXNlZCB0aGUgZGVmYXVsdCB1aWQvZ2lkIGZvciB0aGUgbW91
bnQsIHNvIHNldHRpbmcgcmMgaXMgY29uZnVzaW5nCmFuZCBzaW1wbHkgZ2V0cyBvdmVyd3JpdHRl
biAoc2V0IHRvIDApIGxhdGVyIGluIHRoZSBmdW5jdGlvbi4KCkFkZHJlc3Nlcy1Db3Zlcml0eTog
MTQ5MTY3MiAoIlVudXNlZCB2YWx1ZSIpClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3Rm
cmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNhY2wuYyB8IDIgLS0KIDEgZmls
ZSBjaGFuZ2VkLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2FjbC5j
IGIvZnMvY2lmcy9jaWZzYWNsLmMKaW5kZXggMzg5OGE5ZTZkM2M2Li41ZWM1ZDlkMjQwMzIgMTAw
NjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2FjbC5jCisrKyBiL2ZzL2NpZnMvY2lmc2FjbC5jCkBAIC0z
OTcsNyArMzk3LDYgQEAgc2lkX3RvX2lkKHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsIHN0
cnVjdCBjaWZzX3NpZCAqcHNpZCwKIAlzYXZlZF9jcmVkID0gb3ZlcnJpZGVfY3JlZHMocm9vdF9j
cmVkKTsKIAlzaWRrZXkgPSByZXF1ZXN0X2tleSgmY2lmc19pZG1hcF9rZXlfdHlwZSwgc2lkc3Ry
LCAiIik7CiAJaWYgKElTX0VSUihzaWRrZXkpKSB7Ci0JCXJjID0gLUVJTlZBTDsKIAkJY2lmc19k
YmcoRllJLCAiJXM6IENhbid0IG1hcCBTSUQgJXMgdG8gYSAlY2lkXG4iLAogCQkJIF9fZnVuY19f
LCBzaWRzdHIsIHNpZHR5cGUgPT0gU0lET1dORVIgPyAndScgOiAnZycpOwogCQlnb3RvIG91dF9y
ZXZlcnRfY3JlZHM7CkBAIC00MTAsNyArNDA5LDYgQEAgc2lkX3RvX2lkKHN0cnVjdCBjaWZzX3Ni
X2luZm8gKmNpZnNfc2IsIHN0cnVjdCBjaWZzX3NpZCAqcHNpZCwKIAkgKi8KIAlCVUlMRF9CVUdf
T04oc2l6ZW9mKHVpZF90KSAhPSBzaXplb2YoZ2lkX3QpKTsKIAlpZiAoc2lka2V5LT5kYXRhbGVu
ICE9IHNpemVvZih1aWRfdCkpIHsKLQkJcmMgPSAtRUlPOwogCQljaWZzX2RiZyhGWUksICIlczog
RG93bmNhbGwgY29udGFpbmVkIG1hbGZvcm1lZCBrZXkgKGRhdGFsZW49JWh1KVxuIiwKIAkJCSBf
X2Z1bmNfXywgc2lka2V5LT5kYXRhbGVuKTsKIAkJa2V5X2ludmFsaWRhdGUoc2lka2V5KTsKLS0g
CjIuMzAuMgoK
--000000000000cbb4b005c55fa246--
