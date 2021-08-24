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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96756C4320E
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 16:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77AAF60462
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 16:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238457AbhHXQDl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Aug 2021 12:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238425AbhHXQDe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 Aug 2021 12:03:34 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AADFC061764
        for <linux-cifs@vger.kernel.org>; Tue, 24 Aug 2021 09:02:49 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id i28so38518700ljm.7
        for <linux-cifs@vger.kernel.org>; Tue, 24 Aug 2021 09:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hXg2Ml3SZo28O5nkrCB2Rdk/VnH8vh7JcaznJAO7/1w=;
        b=vA4EAitHX05c5EqQ2yH7pbiwh1aoweDEov4VR/6YhXj12McxpSWnad+0yF/82M8KLB
         7eDdDOfQAUWjfuUA/BYI/JZnA5GE+0qARgEm/+87Q0SBvMScg7UQ+fYXUNowbdm5+kv3
         KfDpVVhpVdZLTPggzYIl6A87qoEDWaKhumgQ1jvjMTF0VfwP3gJ1aXkB5rh90PHzESvI
         bPOseDLNaJrcCApgVECzr08I4XJ0bjBhwpS8Ieg6oJRZrfJnoTmjAMtr5TO4Zt+JJlgz
         xhzwUX+a6ivtBU3N1c4uL0DHdRNgftslbSfB43+9OkFHGZeN2/tYUGRCRaV15DFGoL9p
         nbxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hXg2Ml3SZo28O5nkrCB2Rdk/VnH8vh7JcaznJAO7/1w=;
        b=CUTkOkAiJvQ3trsw1IPjTxjpkO4AO8u7ojTFWKUVau5LzGFw6uaFFuPtMZE2QCpqfq
         0PHlU66v7D31I6fCGE1FlcAGmkMLlAZLbEOqhdk262xTdysqEaRv4CYFx9vhRvvIEvbS
         YrKlpQAgTsGDY9G0auckbeSf0rMPMId0eeBzSpbPD4iw7HBMOGnNHGW8b1JwspWx7YKB
         5xy5CO9PsFUePXw3JIVDmLwSxQ3acBxW7VNeJUY2xiFlwujZwp+lAKkq0+gYBbeY7gQ9
         zqDZMHoIqxcFA6BFjFBUSqaFzgGV43eBKxQasGfVyEg3/f5fORHPfNQsMGGGHhPPr15V
         hEcw==
X-Gm-Message-State: AOAM530GVXkhJ9WdBUhW6sYFX1laIhG9ylu3DiVyARgdr7CdSDFgM3UT
        dYhbdvBJXkCPK9hpmqKFoS790yKb5xlUIYFEkBU=
X-Google-Smtp-Source: ABdhPJz9htFmJZwC3DPn0ncO4HIStdgasUmiUt0V2KVCou5v60H9k92PVsUg0nqf1IepWmpyMH7/DHrbW+xjpbo9KPc=
X-Received: by 2002:a2e:8e39:: with SMTP id r25mr32040435ljk.272.1629820967343;
 Tue, 24 Aug 2021 09:02:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muZqv0Zv415suhAjv5s9a=rU8nMkY1p7doq5koMYU0wBA@mail.gmail.com>
 <20210824115249.gdd3jlf6wi2joxdt@wittgenstein>
In-Reply-To: <20210824115249.gdd3jlf6wi2joxdt@wittgenstein>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 24 Aug 2021 11:02:35 -0500
Message-ID: <CAH2r5mtM2tUUsWfUJLbsVJ-y=XKC-wjbS_fuZYpQedte3_O04A@mail.gmail.com>
Subject: Re: [PATCH][SMB3.1.1] incorrect initialization of the posix
 extensions in new mount API
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: multipart/mixed; boundary="000000000000ce6e0905ca504334"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000ce6e0905ca504334
Content-Type: text/plain; charset="UTF-8"

Yes - the indentation is just cut-n-paste gmail strangeness - you can
see the proper indentation in the attachment


On Tue, Aug 24, 2021 at 6:52 AM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Mon, Aug 23, 2021 at 02:07:22PM -0500, Steve French wrote:
> > We were incorrectly initializing the posix extensions in the
> > conversion to the new mount API.
> >
> > CC: <stable@vger.kernel.org> # 5.11+
> > Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
> > Suggested-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > ---
>
> The indentation looks rather strange to me but maybe that's just mail
> that got garbled. In any case, with the indentation fixed:
>
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>



-- 
Thanks,

Steve

--000000000000ce6e0905ca504334
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-posix-extensions-mount-option.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-posix-extensions-mount-option.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ksq9bcns0>
X-Attachment-Id: f_ksq9bcns0

RnJvbSBiZmI3ZDFiODgwNmZlOGRlY2M5Nzc5NjNiOWVkZGJmOWM0Y2VkOWQ1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjMgQXVnIDIwMjEgMTM6NTI6MTIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggcG9zaXggZXh0ZW5zaW9ucyBtb3VudCBvcHRpb24KCldlIHdlcmUgaW5jb3JyZWN0
bHkgaW5pdGlhbGl6aW5nIHRoZSBwb3NpeCBleHRlbnNpb25zIGluIHRoZQpjb252ZXJzaW9uIHRv
IHRoZSBuZXcgbW91bnQgQVBJLgoKQ0M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiAjIDUuMTEr
ClJlcG9ydGVkLWJ5OiBDaHJpc3RpYW4gQnJhdW5lciA8Y2hyaXN0aWFuLmJyYXVuZXJAdWJ1bnR1
LmNvbT4KU3VnZ2VzdGVkLWJ5OiBOYW1qYWUgSmVvbiA8bmFtamFlLmplb25Ac2Ftc3VuZy5jb20+
ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0t
CiBmcy9jaWZzL2ZzX2NvbnRleHQuYyB8IDExICsrKysrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwg
OSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvZnNf
Y29udGV4dC5jIGIvZnMvY2lmcy9mc19jb250ZXh0LmMKaW5kZXggNDUxNWEwODgzMjYyLi4zMTA5
ZGVmOGUxOTkgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvZnNfY29udGV4dC5jCisrKyBiL2ZzL2NpZnMv
ZnNfY29udGV4dC5jCkBAIC0xMjUyLDEwICsxMjUyLDE3IEBAIHN0YXRpYyBpbnQgc21iM19mc19j
b250ZXh0X3BhcnNlX3BhcmFtKHN0cnVjdCBmc19jb250ZXh0ICpmYywKIAkJCWN0eC0+cG9zaXhf
cGF0aHMgPSAxOwogCQlicmVhazsKIAljYXNlIE9wdF91bml4OgotCQlpZiAocmVzdWx0Lm5lZ2F0
ZWQpCisJCWlmIChyZXN1bHQubmVnYXRlZCkgeworCQkJaWYgKGN0eC0+bGludXhfZXh0ID09IDEp
CisJCQkJcHJfd2Fybl9vbmNlKCJjb25mbGljdGluZyBwb3NpeCBtb3VudCBvcHRpb25zIHNwZWNp
ZmllZFxuIik7CiAJCQljdHgtPmxpbnV4X2V4dCA9IDA7Ci0JCWVsc2UKIAkJCWN0eC0+bm9fbGlu
dXhfZXh0ID0gMTsKKwkJfSBlbHNlIHsKKwkJCWlmIChjdHgtPm5vX2xpbnV4X2V4dCA9PSAxKQor
CQkJCXByX3dhcm5fb25jZSgiY29uZmxpY3RpbmcgcG9zaXggbW91bnQgb3B0aW9ucyBzcGVjaWZp
ZWRcbiIpOworCQkJY3R4LT5saW51eF9leHQgPSAxOworCQkJY3R4LT5ub19saW51eF9leHQgPSAw
OworCQl9CiAJCWJyZWFrOwogCWNhc2UgT3B0X25vY2FzZToKIAkJY3R4LT5ub2Nhc2UgPSAxOwot
LSAKMi4zMC4yCgo=
--000000000000ce6e0905ca504334--
