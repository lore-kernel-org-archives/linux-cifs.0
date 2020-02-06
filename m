Return-Path: <SRS0=edh0=32=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85D2C35247
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 22:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7048B217BA
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 22:12:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qzcI5OmM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgBFWMS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Feb 2020 17:12:18 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:33065 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbgBFWMS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Feb 2020 17:12:18 -0500
Received: by mail-il1-f194.google.com with SMTP id s18so54292iln.0
        for <linux-cifs@vger.kernel.org>; Thu, 06 Feb 2020 14:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vb8Hk+lv5IGavlCdvrn+gCHAJTohJeFomhDL6hts7L0=;
        b=qzcI5OmMExYPzLZ8CiukQNTqQvVbrmHDYwCczLXQgdD4Y9dM2EzHWXrpsOsGHecHWo
         U2VUX86PfZxQUxtI8CTwxH37mlJkvoAGfBZ46+LFfPlUoDpVAQKlvDhEsODk50yybK2A
         lHvSSijundx3zP1sPqV+Ubh+4mO7bovkzHGhX01iZvwFIaMW9Z6hQJ59Ez9+ZeOaxySf
         +jd62/YfJZQ9xyfgOqdoPgQyCqQojyHQ/kj2MzJJOqSKH6YaO5DtI15v3bwCudlIafWx
         9CbsmZ/+giFIHbLV/1vaW93OQ0S8G/s96ksbAER3LCgxICpTq/fQH4LfREwaajMVspV2
         PzDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vb8Hk+lv5IGavlCdvrn+gCHAJTohJeFomhDL6hts7L0=;
        b=i/XGvUSqKogI07tijsh4y4suIWI7eca9sg/ZZpiNlZ+tXntSjrhJvBi9q307re0hCE
         o8V3i3OseZjkWiRfc4c/RA5u5IxIaUgBFkMusgSjwCizLNjB5d0uHYml5eCv3E5ZEGlL
         Ngk0Q0aeEQT2C0edYLGO+HF4xgB2xqDKoHXx5C4BwuQ7H705tzUabFsXTxo2rPae2i3u
         eymDb/Rn7z1FsPt6xVoIqbsFoXatNLR0UU3HcEFDCT6tygVe4wHoQzvzdwddWBOKct53
         k1K0ijxUdmMQRA3qBvIXv115TWr172UtI0TdtoyBMYnA4MexRmkj7GnA4WZtny9AdlT8
         YETw==
X-Gm-Message-State: APjAAAUCuR2DS9tMc8Ag3+SnSm2CEOVp7cY9vPoLI4SWhSbdqePKWY/S
        F63EqOYcQshXJjq8qPkfe/5og7ezjcKaj8ARnlk=
X-Google-Smtp-Source: APXvYqxVAltEGyibAHt1D8OxykbVSoiSJO0lacMQGRmGe4n3J91qrOneCc3XfT4dxPqlWCtqqmK7lYw/NngJMsH+pAU=
X-Received: by 2002:a92:9f1b:: with SMTP id u27mr6332622ili.173.1581027137404;
 Thu, 06 Feb 2020 14:12:17 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mu985seFnTzTLM197oO1K012NjSwYY=ey=xc5PsWfCUsA@mail.gmail.com>
 <CAKywueRLK1pFgQj5+FRzdxwma5KR=+q43Y-bTuPHRCnYapjeKA@mail.gmail.com>
In-Reply-To: <CAKywueRLK1pFgQj5+FRzdxwma5KR=+q43Y-bTuPHRCnYapjeKA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 6 Feb 2020 16:12:06 -0600
Message-ID: <CAH2r5mv+9Jo+MQ8dcVyD_G2ReJJP_b3MAkSirHEtdmdLAOWQtA@mail.gmail.com>
Subject: Re: [CIFS][PATCH] Add dynamic trace points for flush and fsync
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Oleg Kravtsov <oleg@tuxera.com>
Content-Type: multipart/mixed; boundary="000000000000e83e30059def9012"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e83e30059def9012
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

cifs_strict_fsync already gets traced for most cases for entry and
exit since we have a dynamic trace point in get_xid and free_xid (for
enter and exit) ie trace_smb3_enter and trace_smb3_exit and
trace_smb3_exit_err




On Thu, Feb 6, 2020 at 12:17 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D1=81=D1=80, 5 =D1=84=D0=B5=D0=B2=D1=80. 2020 =D0=B3. =D0=B2 16:32, Stev=
e French <smfrench@gmail.com>:
> >
> > Makes it easier to debug errors on writeback that happen later,
> > and are being returned on flush or fsync
> >
> > For example:
> >   writetest-17829 [002] .... 13583.407859: cifs_flush_err: ino=3D90 rc=
=3D-28
>
> The patch is missing to add a similar tracepoint to cifs_strict_fsync().
>
> --
> Best regards,
> Pavel Shilovsky



--=20
Thanks,

Steve

--000000000000e83e30059def9012
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-one-more-dynamic-tracepoint-missing-from-st.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-one-more-dynamic-tracepoint-missing-from-st.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k6baq74s0>
X-Attachment-Id: f_k6baq74s0

RnJvbSAyNDI4OTFjNGQ2ZTIzZDA1MTc0NDFjYzQ5YWMxMzFhOWU1YmIzNzkxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgNiBGZWIgMjAyMCAxNjowNDo1OSAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGFkZCBvbmUgbW9yZSBkeW5hbWljIHRyYWNlcG9pbnQgbWlzc2luZyBmcm9tIHN0cmljdAog
ZnN5bmMgcGF0aAoKV2UgZGlkbid0IGhhdmUgYSBkeW5hbWljIHRyYWNlIHBvaW50IGZvciBjYXRj
aGluZyBlcnJvcnMgaW4KZmlsZV93cml0ZV9hbmRfd2FpdF9yYW5nZSBlcnJvciBjYXNlcyBpbiBj
aWZzX3N0cmljdF9mc3luYy4KClNpbmNlIG5vdCBhbGwgYXBwcyBjaGVjayBmb3Igd3JpdGUgYmVo
aW5kIGVycm9ycywgaXQgY2FuIGJlCmltcG9ydGFudCBmb3IgZGVidWdnaW5nIHRvIGJlIGFibGUg
dG8gdHJhY2UgdGhlc2UgZXJyb3IKcGF0aHMuCgpTdWdnZXN0ZWQtYW5kLXJldmlld2VkLWJ5OiBQ
YXZlbCBTaGlsb3Zza3kgPHBzaGlsb3ZAbWljcm9zb2Z0LmNvbT4KU2lnbmVkLW9mZi1ieTogU3Rl
dmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvZmlsZS5jIHwg
NCArKystCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpk
aWZmIC0tZ2l0IGEvZnMvY2lmcy9maWxlLmMgYi9mcy9jaWZzL2ZpbGUuYwppbmRleCA5OWVhN2Iy
YTA2YTUuLmJjOTUxNmFiNGIzNCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9maWxlLmMKKysrIGIvZnMv
Y2lmcy9maWxlLmMKQEAgLTI1OTMsOCArMjU5MywxMCBAQCBpbnQgY2lmc19zdHJpY3RfZnN5bmMo
c3RydWN0IGZpbGUgKmZpbGUsIGxvZmZfdCBzdGFydCwgbG9mZl90IGVuZCwKIAlzdHJ1Y3QgY2lm
c19zYl9pbmZvICpjaWZzX3NiID0gQ0lGU19TQihpbm9kZS0+aV9zYik7CiAKIAlyYyA9IGZpbGVf
d3JpdGVfYW5kX3dhaXRfcmFuZ2UoZmlsZSwgc3RhcnQsIGVuZCk7Ci0JaWYgKHJjKQorCWlmIChy
YykgeworCQl0cmFjZV9jaWZzX2ZzeW5jX2Vycihpbm9kZS0+aV9pbm8sIHJjKTsKIAkJcmV0dXJu
IHJjOworCX0KIAogCXhpZCA9IGdldF94aWQoKTsKIAotLSAKMi4yMC4xCgo=
--000000000000e83e30059def9012--
