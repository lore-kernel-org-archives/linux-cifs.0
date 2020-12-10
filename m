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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C72EC4361B
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Dec 2020 03:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AABA8238EB
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Dec 2020 03:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbgLJDcD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Dec 2020 22:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729363AbgLJDcD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Dec 2020 22:32:03 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C856C0613CF
        for <linux-cifs@vger.kernel.org>; Wed,  9 Dec 2020 19:31:23 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id m19so6191924lfb.1
        for <linux-cifs@vger.kernel.org>; Wed, 09 Dec 2020 19:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m5nRi7wPQfDBR+aWho+WiJK1JJzdCE8Z4uiw0cji+0Y=;
        b=RMDue8TWrfWID+aB0y54Vkcyhk+DSmr627fk3n4oBheG4xOFsLpHtflkDohgB+yZxA
         NvGKC/wduv/2dVVA9y0FQrJSfM+0kDkfYP3vXS2uPcQFG5UJFqguw4S7vAA5RI2fJYFq
         c8ZqCr7hKr5BEu67ugBxegSuVnylU3/aNrANb1nwU2c15vGVU6Mza9SQQkUggtatpols
         uS2WobKxsPpNVAlVC6IdjmKNZZPpwiZ/LsPSzUoqzN2DAjsuFLuZy5/Oc3k/9pjlrtBt
         0/2smedJSuUU5X4KBiIV3UKVZSUrBlP4MKyQzgEpBNpyzxnHRWm8erNU1djcf2onsl43
         ttug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m5nRi7wPQfDBR+aWho+WiJK1JJzdCE8Z4uiw0cji+0Y=;
        b=WLsvzv76Rujj7sCY5HVfmH/Kzxr0nHubY/2XlzP4jXXpYBlDpc8AJBrF8id+FDyiuD
         m7t1PyiVgQOu0PtwnvK1xy2PBpI7nB+SpITs65e6KYSURyrnjHyFZs82kD49hV0UyYdd
         +m2tx8nW41sQswet1K7wypuma1LOpy40/fv/7+Tx+NnrjBHlsnmOukqijeDr1tZ+lJOV
         DEqObdUgUcF0xGb6DCmYj13wEs8lA3aLl40uskxN/fKBLG7f9l7ZPYJh8MOKo0QUiOoj
         JPuEztszdpMb12wxb4H6tfkgWUdyplQ7ysxvxGgDRX31Lyrz2Y6Ofd7phNfNMYxDIcL3
         0WOw==
X-Gm-Message-State: AOAM533MKY4NeeR0luLtPqGTFiEroOSdKbm0Wg4pvBDPD3w5TibFIrmd
        kGbUWo0mc9q+S01dJyam+vGiJOaGZh5Yu1FxZna52MVyYYs=
X-Google-Smtp-Source: ABdhPJzW0wOut5QuqNUo5pqwp22wevcqethm2NA7n8nmYhmDae66RzZraJJ8batWBj2eiBwM0i0Zer/covojQ5UPW2w=
X-Received: by 2002:a19:f11e:: with SMTP id p30mr1843561lfh.395.1607571081719;
 Wed, 09 Dec 2020 19:31:21 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mvr6JebH9cr9dO-XbiXdsfBjs=C4WhqkqXUwDCmOY20zA@mail.gmail.com>
 <CAKywueRMTMy7shp_qT3Cu6E1EZ0AwdSvjsWF=MU4KQWkw+YL-A@mail.gmail.com>
 <c885d7a2-4f41-d2c0-51ae-43e8ef9cc2d6@talpey.com> <CAH2r5mtfAzgh4ojq3XxgmVwbU4YnD42O9=G+FqB9r=AqA=qihQ@mail.gmail.com>
 <16b615a1-d499-381e-88ad-7792d105a646@talpey.com>
In-Reply-To: <16b615a1-d499-381e-88ad-7792d105a646@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 9 Dec 2020 21:31:10 -0600
Message-ID: <CAH2r5msb=ocQpc8sP7OkirY66fGb_LWR9CjJkKr5rT42kbjkoQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3.1.1] remove confusing mount warning when no SPNEGO
 info on negprot rsp
To:     Tom Talpey <tom@talpey.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000004718eb05b613cf98"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000004718eb05b613cf98
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Fixed. Included Pavel's comment as well.


On Wed, Dec 9, 2020 at 6:58 PM Tom Talpey <tom@talpey.com> wrote:
>
> Except for the typo "wnich", looks fine.
>
> On 12/9/2020 5:49 PM, Steve French wrote:
> > Changed the comment in followon to:
> >
> > -       /* Make sure that negotiate contexts start after gss security b=
lob */
> > +       /*
> > +        * if SPNEGO blob present (ie the RFC2478 GSS info which indica=
tes
> > +        * wnich security mechanisms the server supports) make sure tha=
t
> > +        * the negotiate contexts start after it
> > +        */
> >
> > On Wed, Dec 9, 2020 at 3:26 PM Tom Talpey <tom@talpey.com> wrote:
> >>
> >> The protocol allows omitting the SPNEGO blob altogether, btw. That
> >> leads to the client deciding how to authenticate, although the Windows
> >> server doesn't offer that.
> >>
> >> So I'd suggest removing the comment, too:
> >>
> >>   >> /* Make sure that negotiate contexts start after gss security blo=
b */
> >>
> >>
> >> On 12/9/2020 12:39 PM, Pavel Shilovsky wrote:
> >>> Looks good.
> >>>
> >>> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> >>>
> >>> --
> >>> Best regards,
> >>> Pavel Shilovsky
> >>>
> >>> =D0=B2=D1=82, 8 =D0=B4=D0=B5=D0=BA. 2020 =D0=B3. =D0=B2 23:23, Steve =
French <smfrench@gmail.com>:
> >>>>
> >>>> Azure does not send an SPNEGO blob in the negotiate protocol respons=
e,
> >>>> so we shouldn't assume that it is there when validating the location
> >>>> of the first negotiate context.  This avoids the potential confusing
> >>>> mount warning:
> >>>>
> >>>>      CIFS: Invalid negotiate context offset
> >>>>
> >>>> CC: Stable <stable@vger.kernel.org>
> >>>> Signed-off-by: Steve French <stfrench@microsoft.com>
> >>>> ---
> >>>>    fs/cifs/smb2misc.c | 11 +++++++----
> >>>>    1 file changed, 7 insertions(+), 4 deletions(-)
> >>>>
> >>>> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> >>>> index d88e2683626e..513507e4c4ad 100644
> >>>> --- a/fs/cifs/smb2misc.c
> >>>> +++ b/fs/cifs/smb2misc.c
> >>>> @@ -109,11 +109,14 @@ static __u32 get_neg_ctxt_len(struct
> >>>> smb2_sync_hdr *hdr, __u32 len,
> >>>>
> >>>>     /* Make sure that negotiate contexts start after gss security bl=
ob */
> >>>>     nc_offset =3D le32_to_cpu(pneg_rsp->NegotiateContextOffset);
> >>>> - if (nc_offset < non_ctxlen) {
> >>>> - pr_warn_once("Invalid negotiate context offset\n");
> >>>> + if (nc_offset + 1 < non_ctxlen) {
> >>>> + pr_warn_once("Invalid negotiate context offset %d\n", nc_offset);
> >>>>     return 0;
> >>>> - }
> >>>> - size_of_pad_before_neg_ctxts =3D nc_offset - non_ctxlen;
> >>>> + } else if (nc_offset + 1 =3D=3D non_ctxlen) {
> >>>> + cifs_dbg(FYI, "no SPNEGO security blob in negprot rsp\n");
> >>>> + size_of_pad_before_neg_ctxts =3D 0;
> >>>> + } else
> >>>> + size_of_pad_before_neg_ctxts =3D nc_offset - non_ctxlen;
> >>>>
> >>>>     /* Verify that at least minimal negotiate contexts fit within fr=
ame */
> >>>>     if (len < nc_offset + (neg_count * sizeof(struct smb2_neg_contex=
t))) {
> >>>>
> >>>> --
> >>>> Thanks,
> >>>>
> >>>> Steve
> >>>
> >
> >
> >



--=20
Thanks,

Steve

--0000000000004718eb05b613cf98
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3.1.1-update-comments-clarifying-SPNEGO-info-in-n.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3.1.1-update-comments-clarifying-SPNEGO-info-in-n.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kiiab1qw0>
X-Attachment-Id: f_kiiab1qw0

RnJvbSBiNTE4MDFmYjc1ZjgwMWU1NDM2ZGMzZjY4ODllMTczMWNhNDcyOGU3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgOSBEZWMgMjAyMCAyMToyNToxMyAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIFNN
QjMuMS4xOiB1cGRhdGUgY29tbWVudHMgY2xhcmlmeWluZyBTUE5FR08gaW5mbyBpbiBuZWdwcm90
CiByZXNwb25zZQoKVHJpdmlhbCBjaGFuZ2VzIHRvIGNsYXJpZnkgY29uZnVzaW5nIGNvbW1lbnQg
KGFuZCBhbHNvIGxlbmd0aCBjb21wYXJpc29ucwppbiBuZWdvdGlhdGUgY29udGV4dCBwYXJzaW5n
LgoKU3VnZ2VzdGVkLWJ5OiBUb20gVGFscGV5IDx0b21AdGFscGV5LmNvbT4KU3VnZ2VzdGVkLWJ5
OiBQYXZlbCBTaGlsb3Zza3kgPHBzaGlsb3ZAbWljcm9zb2Z0LmNvbT4KU2lnbmVkLW9mZi1ieTog
U3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iMm1p
c2MuYyB8IDExICsrKysrKysrKystCiAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm1pc2MuYyBiL2ZzL2NpZnMv
c21iMm1pc2MuYwppbmRleCAyZjg2YzEyMDdhMWYuLjhiZDNiMzNjYzBhZCAxMDA2NDQKLS0tIGEv
ZnMvY2lmcy9zbWIybWlzYy5jCisrKyBiL2ZzL2NpZnMvc21iMm1pc2MuYwpAQCAtMTA3LDggKzEw
NywxNyBAQCBzdGF0aWMgX191MzIgZ2V0X25lZ19jdHh0X2xlbihzdHJ1Y3Qgc21iMl9zeW5jX2hk
ciAqaGRyLCBfX3UzMiBsZW4sCiAJICAgKHBuZWdfcnNwLT5EaWFsZWN0UmV2aXNpb24gIT0gY3B1
X3RvX2xlMTYoU01CMzExX1BST1RfSUQpKSkKIAkJcmV0dXJuIDA7CiAKLQkvKiBNYWtlIHN1cmUg
dGhhdCBuZWdvdGlhdGUgY29udGV4dHMgc3RhcnQgYWZ0ZXIgZ3NzIHNlY3VyaXR5IGJsb2IgKi8K
KwkvKgorCSAqIGlmIFNQTkVHTyBibG9iIHByZXNlbnQgKGllIHRoZSBSRkMyNDc4IEdTUyBpbmZv
IHdoaWNoIGluZGljYXRlcworCSAqIHdoaWNoIHNlY3VyaXR5IG1lY2hhbmlzbXMgdGhlIHNlcnZl
ciBzdXBwb3J0cykgbWFrZSBzdXJlIHRoYXQKKwkgKiB0aGUgbmVnb3RpYXRlIGNvbnRleHRzIHN0
YXJ0IGFmdGVyIGl0CisJICovCiAJbmNfb2Zmc2V0ID0gbGUzMl90b19jcHUocG5lZ19yc3AtPk5l
Z290aWF0ZUNvbnRleHRPZmZzZXQpOworCS8qCisJICogbm9uX2N0eGxlbiBpcyBzaGRyLT5TdHJ1
Y3R1cmVTaXplICsgcGR1LT5TdHJ1Y3R1cmVTaXplMiBhbmQKKwkgKiB0aGUgbGF0dGVyIGlzIDEg
Ynl0ZSBiaWdnZXIgdGhhbiB0aGUgZml4LXNpemVkIGFyZWEgb2YgdGhlCisJICogTkVHT1RJQVRF
IHJlc3BvbnNlCisJICovCiAJaWYgKG5jX29mZnNldCArIDEgPCBub25fY3R4bGVuKSB7CiAJCXBy
X3dhcm5fb25jZSgiSW52YWxpZCBuZWdvdGlhdGUgY29udGV4dCBvZmZzZXQgJWRcbiIsIG5jX29m
ZnNldCk7CiAJCXJldHVybiAwOwotLSAKMi4yNy4wCgo=
--0000000000004718eb05b613cf98--
