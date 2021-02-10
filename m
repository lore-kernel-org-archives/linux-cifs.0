Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C20C433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Feb 2021 06:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DF8D64E2E
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Feb 2021 06:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhBJGRP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Feb 2021 01:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbhBJGRF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Feb 2021 01:17:05 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE94C06174A
        for <linux-cifs@vger.kernel.org>; Tue,  9 Feb 2021 22:09:40 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id p193so903469yba.4
        for <linux-cifs@vger.kernel.org>; Tue, 09 Feb 2021 22:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/XraRbxSOnPM2jhJ3YBWG9fNzpcQJ13OYSd1WAOoyY0=;
        b=UQuPQp4RAf9goiqkvVe3vnidOKtxAx9UCHwy2Roq6rr9aYeA8dJtWrvvLzTpldDyhL
         MwsotdtxVLs8GuBWXDuFjpHe7f4d3OyzSvt6WX8n7TknT2uD7O0xjF+C4AYPT7dNM+0d
         l6/o1Ow9qKvejXKPmVgZasQzTWPdlAMqXCt+wUas4L8NYDNlFD8NDhzn/SUQSnxk8VyW
         dGcdttMAEjTReTqzLV8HQQuCggVJEqxjT4F3NNomroJ7a6G3KDJs6qMx4ksCizudbu32
         z3Zf6qs3Dp8JPJ8RcAZPxQMZHsPgJLKQGdnai0kJr+CmvjSzeqCb5Dy6DmT8yQep5eY4
         S0TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/XraRbxSOnPM2jhJ3YBWG9fNzpcQJ13OYSd1WAOoyY0=;
        b=Lvnjco389XQkd3aJ1+iYZ7rEojEyiDUoa8PbnZZ9wE7NDwGLiwzCltsTG4G5X/jX0B
         jWM2LshWPxv3Vd1Zy6wjyCvdSkDKHG612HbOcXw5IWlYPW88uk2ee4iS0+SzegRZo9Jc
         X77r2dBRgz+mQgVn88KiksQ7/e4oqrM+Lw0ft3Dn8m6e8u8iAkzo2VAVuJweOIGo9m2L
         2QGSLDheUJsENProqYEqhEM9Z8q8RqvcQI6SpFrji0BzaOCp1XoHcnBfFaPnh+CPeV4Q
         Vq3/cepZYuYCmyqkx+6MJ7jwwQxiHzcL2WGSv2MaYC8X9VWj4WjHWIbuFBBGLT+bIKfB
         SgxQ==
X-Gm-Message-State: AOAM533vqY58wmA13cDhR4AO0xxwhjnw0R3M0Yxr5c+BFMgu9p39D89V
        LJ1T/aCOL16YiPFxCSqbcRtBVB3rYtCJg7OZYe8=
X-Google-Smtp-Source: ABdhPJyjFugkPUIOO3YFuDHJFGyKnlIfznj3uTWINWkRVBNBBYRPbychH9wR0rT87/wQV6Hoz3j2Fwt2hvg+MYNRGFo=
X-Received: by 2002:a25:442:: with SMTP id 63mr2105478ybe.131.1612937379392;
 Tue, 09 Feb 2021 22:09:39 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=qrx1bKAcJGG=hGBkvwHjQWLgTH3kJ+g-YdZL0yfBtA9A@mail.gmail.com>
 <87mtwkno7q.fsf@suse.com> <CANT5p=qeEBwivE_Fc-Y4gj17d9nkU+ROPnZL=0BD3v_yRNBFtA@mail.gmail.com>
 <87blctmqo0.fsf@suse.com> <CAKywueRd1u_7F6qRkSRCtg5exPeNBSXANUiFTrUfcigJGMeP3Q@mail.gmail.com>
 <CAH2r5msowQaXTi+3K0UeyFdVVzHz_LLk-Cdr5XBANYz6SmqymQ@mail.gmail.com>
 <CAKywueTxA6URL-2YEkuJAr1=XXPtA1PTzqwioFR6k47Y2Rri-A@mail.gmail.com> <CANT5p=qSaXShm0_iZmWJzUNkSc=xSjtr-w43UQVJnvoiFsFeHg@mail.gmail.com>
In-Reply-To: <CANT5p=qSaXShm0_iZmWJzUNkSc=xSjtr-w43UQVJnvoiFsFeHg@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 9 Feb 2021 22:09:28 -0800
Message-ID: <CANT5p=rcNAWY-yj_-z0F1NCvRp9+sp6K86MvWoH5iYUXevX01Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] cifs: New optype for session operations.
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000008b8aba05baf53fd5"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000008b8aba05baf53fd5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Attaching updated patch.

On Tue, Feb 9, 2021 at 9:47 PM Shyam Prasad N <nspmangalore@gmail.com> wrot=
e:
>
> Yes. I'll put a comment to avoid confusion.
>
> Regards,
> Shyam
>
> On Tue, Feb 9, 2021 at 12:08 PM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > Yes, missed them in the first place. Then I would suggest to list them
> > in order to avoid confusion.
> > --
> > Best regards,
> > Pavel Shilovsky
> >
> > =D0=B2=D1=82, 9 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 12:06, St=
eve French <smfrench@gmail.com>:
> > >
> > > On Tue, Feb 9, 2021 at 1:58 PM Pavel Shilovsky <piastryyy@gmail.com> =
wrote:
> > > >
> > > > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > > > index 50fcb65920e8..1a1f9f4ae80a 100644
> > > > --- a/fs/cifs/cifsglob.h
> > > > +++ b/fs/cifs/cifsglob.h
> > > > @@ -1704,7 +1704,8 @@ static inline bool is_retryable_error(int err=
or)
> > > >  #define   CIFS_ECHO_OP      0x080    /* echo request */
> > > >  #define   CIFS_OBREAK_OP   0x0100    /* oplock break request */
> > > >  #define   CIFS_NEG_OP      0x0200    /* negotiate request */
> > > > -#define   CIFS_OP_MASK     0x0380    /* mask request type */
> > > > +#define   CIFS_SESS_OP     0x2000    /* session setup request */
> > > > +#define   CIFS_OP_MASK     0x2380    /* mask request type */
> > > >
> > > > Why skipping 0x400, 0x800 and 0x1000 flags?
> > >
> > > They were already reserved.  See cifsglob.h
> > >
> > > #define   CIFS_HAS_CREDITS 0x0400    /* already has credits */
> > > #define   CIFS_TRANSFORM_REQ 0x0800    /* transform request before se=
nding */
> > > #define   CIFS_NO_SRV_RSP    0x1000    /* there is no server response=
 */
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
>
>
>
> --
> Regards,
> Shyam



--=20
Regards,
Shyam

--0000000000008b8aba05baf53fd5
Content-Type: application/octet-stream; 
	name="0001-cifs-New-optype-for-session-operations.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-New-optype-for-session-operations.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kkz19ead0>
X-Attachment-Id: f_kkz19ead0

RnJvbSA3NTE3ZjU1ZWExYzY5YmE1ZDRkMGRiZDhlZDg5NTJjMzBjZDExMmNmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBXZWQsIDMgRmViIDIwMjEgMjI6NDk6NTIgLTA4MDAKU3ViamVjdDogW1BBVENIIDEv
NF0gY2lmczogTmV3IG9wdHlwZSBmb3Igc2Vzc2lvbiBvcGVyYXRpb25zLgoKV2UgdXNlZCB0byBz
aGFyZSB0aGUgQ0lGU19ORUdfT1AgZmxhZyBiZXR3ZWVuIG5lZ290aWF0ZSBhbmQKc2Vzc2lvbiBh
dXRoZW50aWNhdGlvbi4gVGhlcmUgd2FzIGFuIGFzc3VtcHRpb24gaW4gdGhlIGNvZGUgdGhhdApD
SUZTX05FR19PUCBpcyB1c2VkIGJ5IG5lZ290aWF0ZSBvbmx5LiBTbyBpbnRyb2N1ZGVkIENJRlNf
U0VTU19PUAphbmQgdXNlZCBpdCBmb3Igc2Vzc2lvbiBzZXR1cCBvcHR5cGVzLgoKU2lnbmVkLW9m
Zi1ieTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZz
L2NpZnNnbG9iLmggIHwgNCArKystCiBmcy9jaWZzL3NtYjJvcHMuYyAgIHwgMiArLQogZnMvY2lm
cy9zbWIycGR1LmMgICB8IDIgKy0KIGZzL2NpZnMvdHJhbnNwb3J0LmMgfCA0ICsrLS0KIDQgZmls
ZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRleCA1MGZjYjY1OTIw
ZTguLjMxNTI2MDFhNjA4YiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xvYi5oCisrKyBiL2Zz
L2NpZnMvY2lmc2dsb2IuaApAQCAtMTcwNCw3ICsxNzA0LDkgQEAgc3RhdGljIGlubGluZSBib29s
IGlzX3JldHJ5YWJsZV9lcnJvcihpbnQgZXJyb3IpCiAjZGVmaW5lICAgQ0lGU19FQ0hPX09QICAg
ICAgMHgwODAgICAgLyogZWNobyByZXF1ZXN0ICovCiAjZGVmaW5lICAgQ0lGU19PQlJFQUtfT1Ag
ICAweDAxMDAgICAgLyogb3Bsb2NrIGJyZWFrIHJlcXVlc3QgKi8KICNkZWZpbmUgICBDSUZTX05F
R19PUCAgICAgIDB4MDIwMCAgICAvKiBuZWdvdGlhdGUgcmVxdWVzdCAqLwotI2RlZmluZSAgIENJ
RlNfT1BfTUFTSyAgICAgMHgwMzgwICAgIC8qIG1hc2sgcmVxdWVzdCB0eXBlICovCisvKiBMb3dl
ciBiaXRtYXNrIHZhbHVlcyBhcmUgcmVzZXJ2ZWQgYnkgb3RoZXJzIGJlbG93LiAqLworI2RlZmlu
ZSAgIENJRlNfU0VTU19PUCAgICAgMHgyMDAwICAgIC8qIHNlc3Npb24gc2V0dXAgcmVxdWVzdCAq
LworI2RlZmluZSAgIENJRlNfT1BfTUFTSyAgICAgMHgyMzgwICAgIC8qIG1hc2sgcmVxdWVzdCB0
eXBlICovCiAKICNkZWZpbmUgICBDSUZTX0hBU19DUkVESVRTIDB4MDQwMCAgICAvKiBhbHJlYWR5
IGhhcyBjcmVkaXRzICovCiAjZGVmaW5lICAgQ0lGU19UUkFOU0ZPUk1fUkVRIDB4MDgwMCAgICAv
KiB0cmFuc2Zvcm0gcmVxdWVzdCBiZWZvcmUgc2VuZGluZyAqLwpkaWZmIC0tZ2l0IGEvZnMvY2lm
cy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYwppbmRleCBmMTkyNzQ4NTcyOTIuLjQzMzMx
NTU1ZmNjNSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMKKysrIGIvZnMvY2lmcy9zbWIy
b3BzLmMKQEAgLTg0LDcgKzg0LDcgQEAgc21iMl9hZGRfY3JlZGl0cyhzdHJ1Y3QgVENQX1NlcnZl
cl9JbmZvICpzZXJ2ZXIsCiAJCXByX3dhcm5fb25jZSgic2VydmVyIG92ZXJmbG93ZWQgU01CMyBj
cmVkaXRzXG4iKTsKIAl9CiAJc2VydmVyLT5pbl9mbGlnaHQtLTsKLQlpZiAoc2VydmVyLT5pbl9m
bGlnaHQgPT0gMCAmJiAob3B0eXBlICYgQ0lGU19PUF9NQVNLKSAhPSBDSUZTX05FR19PUCkKKwlp
ZiAoc2VydmVyLT5pbl9mbGlnaHQgPT0gMCAmJiAob3B0eXBlICYgQ0lGU19PUF9NQVNLKSAhPSBD
SUZTX05FR19PUCAmJiAob3B0eXBlICYgQ0lGU19PUF9NQVNLKSAhPSBDSUZTX1NFU1NfT1ApCiAJ
CXJjID0gY2hhbmdlX2NvbmYoc2VydmVyKTsKIAkvKgogCSAqIFNvbWV0aW1lcyBzZXJ2ZXIgcmV0
dXJucyAwIGNyZWRpdHMgb24gb3Bsb2NrIGJyZWFrIGFjayAtIHdlIG5lZWQgdG8KZGlmZiAtLWdp
dCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggZTEzOTFiZDky
NzY4Li40YmJiNjEyNmIxNGQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5jCisrKyBiL2Zz
L2NpZnMvc21iMnBkdS5jCkBAIC0xMjYxLDcgKzEyNjEsNyBAQCBTTUIyX3Nlc3Nfc2VuZHJlY2Vp
dmUoc3RydWN0IFNNQjJfc2Vzc19kYXRhICpzZXNzX2RhdGEpCiAJCQkgICAgY2lmc19zZXNfc2Vy
dmVyKHNlc3NfZGF0YS0+c2VzKSwKIAkJCSAgICAmcnFzdCwKIAkJCSAgICAmc2Vzc19kYXRhLT5i
dWYwX3R5cGUsCi0JCQkgICAgQ0lGU19MT0dfRVJST1IgfCBDSUZTX05FR19PUCwgJnJzcF9pb3Yp
OworCQkJICAgIENJRlNfTE9HX0VSUk9SIHwgQ0lGU19TRVNTX09QLCAmcnNwX2lvdik7CiAJY2lm
c19zbWFsbF9idWZfcmVsZWFzZShzZXNzX2RhdGEtPmlvdlswXS5pb3ZfYmFzZSk7CiAJbWVtY3B5
KCZzZXNzX2RhdGEtPmlvdlswXSwgJnJzcF9pb3YsIHNpemVvZihzdHJ1Y3Qga3ZlYykpOwogCmRp
ZmYgLS1naXQgYS9mcy9jaWZzL3RyYW5zcG9ydC5jIGIvZnMvY2lmcy90cmFuc3BvcnQuYwppbmRl
eCA0YTJiODM2ZWIwMTcuLjQxMjIzYTllZTA4NiAxMDA2NDQKLS0tIGEvZnMvY2lmcy90cmFuc3Bv
cnQuYworKysgYi9mcy9jaWZzL3RyYW5zcG9ydC5jCkBAIC0xMTcxLDcgKzExNzEsNyBAQCBjb21w
b3VuZF9zZW5kX3JlY3YoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfc2VzICpz
ZXMsCiAJLyoKIAkgKiBDb21wb3VuZGluZyBpcyBuZXZlciB1c2VkIGR1cmluZyBzZXNzaW9uIGVz
dGFibGlzaC4KIAkgKi8KLQlpZiAoKHNlcy0+c3RhdHVzID09IENpZnNOZXcpIHx8IChvcHR5cGUg
JiBDSUZTX05FR19PUCkpCisJaWYgKChzZXMtPnN0YXR1cyA9PSBDaWZzTmV3KSB8fCAob3B0eXBl
ICYgQ0lGU19ORUdfT1ApIHx8IChvcHR5cGUgJiBDSUZTX1NFU1NfT1ApKQogCQlzbWIzMTFfdXBk
YXRlX3ByZWF1dGhfaGFzaChzZXMsIHJxc3RbMF0ucnFfaW92LAogCQkJCQkgICBycXN0WzBdLnJx
X252ZWMpOwogCkBAIC0xMjM2LDcgKzEyMzYsNyBAQCBjb21wb3VuZF9zZW5kX3JlY3YoY29uc3Qg
dW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfc2VzICpzZXMsCiAJLyoKIAkgKiBDb21wb3Vu
ZGluZyBpcyBuZXZlciB1c2VkIGR1cmluZyBzZXNzaW9uIGVzdGFibGlzaC4KIAkgKi8KLQlpZiAo
KHNlcy0+c3RhdHVzID09IENpZnNOZXcpIHx8IChvcHR5cGUgJiBDSUZTX05FR19PUCkpIHsKKwlp
ZiAoKHNlcy0+c3RhdHVzID09IENpZnNOZXcpIHx8IChvcHR5cGUgJiBDSUZTX05FR19PUCkgfHwg
KG9wdHlwZSAmIENJRlNfU0VTU19PUCkpIHsKIAkJc3RydWN0IGt2ZWMgaW92ID0gewogCQkJLmlv
dl9iYXNlID0gcmVzcF9pb3ZbMF0uaW92X2Jhc2UsCiAJCQkuaW92X2xlbiA9IHJlc3BfaW92WzBd
Lmlvdl9sZW4KLS0gCjIuMjUuMQoK
--0000000000008b8aba05baf53fd5--
