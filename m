Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA115C77B61
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Apr 2023 04:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345246AbjD1EZu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Apr 2023 00:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345102AbjD1EZt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Apr 2023 00:25:49 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6679100
        for <linux-cifs@vger.kernel.org>; Thu, 27 Apr 2023 21:25:47 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2a8a5f6771fso92032471fa.3
        for <linux-cifs@vger.kernel.org>; Thu, 27 Apr 2023 21:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682655945; x=1685247945;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lACEz/LTPh/R4+7It4owQdJ6YwkJqEnqAY0dr2TzRjc=;
        b=pE2fJSqUy4XJ35vWvnw9TX++9NyaF05/rBL6+8rYcRrcMLmzZGkivSXbIsBuVNL6Bu
         Zx0kfdiO9WhzXHpMQTG/K7QY52hckD32QXXqUOabKW0M5JPBIHlZvuGWq9VlwENyOb0u
         ftQRVqDtG1Ib/fv1juC4FJAOn7n+p+9nnMvCmpoC66+YazhRJ0BSDhAnCZb2pIDCOtyJ
         vmpnf09cnLVTt8qX8oVrsU77pNklVXKCEBIEesm+Q8pkhApUSDsUfqdNGQhCwsnmq4A4
         n7r0FCurggrM92ESErRrA252alopgB72bM8U8091TclxdRdQnJ/rmkGm9y4A9ACdnhl1
         XrGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682655945; x=1685247945;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lACEz/LTPh/R4+7It4owQdJ6YwkJqEnqAY0dr2TzRjc=;
        b=Qq3u2FIx+0cmKnxBUyZ5cUPAQPklqy9SC7uiMSMEJFHnGqkdE7ong6uletBHskmSlx
         B9mmXL3xJqfIotG9fSz7shrkOqCqq7eUhzyaM61anPXogC/vpyTn6F9FxO/9i1cEV/1a
         F2Y6oopRLZKy9dR9GO0DslBgfuSpUH1Jvk+1c3QUJeOfl5eyxlJMsM05XYOM+V7qwAu/
         peyafHKhilzQlRdAFuFb/qXzSoLJRIU9PqIW3NztWUTtyCsScZQ6r8mJYcC1x9Y55DZF
         j2U7NZrrfkO4zQdF1dVSiBWW3r6CryCwD6UaJaCKHWBdxg7MA1Xg6VCfQbe3kISm/9oE
         9Qxg==
X-Gm-Message-State: AC+VfDygYjkrsxtN3rSAshVQxz/t+aahmngO7ANJflei2+nznmmWXX9G
        kCw4VMQkk1LN4Cti59VLpIkr2hBY7y8Np6Vcs9iF216G
X-Google-Smtp-Source: ACHHUZ4PGg2A8Bp/hUrmeZhA5zvHYvxL6OF7pQWNFKs2GRO88Oe5T0YSTbMI7TA6w9kNhrmLbfDqldeF/jocyNg6rhc=
X-Received: by 2002:a2e:9d0f:0:b0:2ab:510:4ed4 with SMTP id
 t15-20020a2e9d0f000000b002ab05104ed4mr1155290lji.35.1682655944841; Thu, 27
 Apr 2023 21:25:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msM9ayyLmijEWjTQJN_kn-gy_Jp5BQRRYuhc-KYqRqYoA@mail.gmail.com>
In-Reply-To: <CAH2r5msM9ayyLmijEWjTQJN_kn-gy_Jp5BQRRYuhc-KYqRqYoA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 27 Apr 2023 23:25:33 -0500
Message-ID: <CAH2r5mv=cW=SHNu84mXc=mW+JNPjULREc6hqzWtMcEqM-LDroA@mail.gmail.com>
Subject: Re: [PATCH][CIFS] missing lock when updating session status
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000df5ee905fa5ddde1"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000df5ee905fa5ddde1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

lightly updated with Bharath's suggestions of moving cifs_free_ipc()
out of the spinlock

See attached.

On Wed, Apr 26, 2023 at 10:09=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> Coverity noted a place where we were not grabbing
> the ses_lock when setting (and checking) ses_status.
>
> Addresses-Coverity: 1536833 ("Data race condition (MISSING_LOCK)")
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--000000000000df5ee905fa5ddde1
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-missing-lock-when-updating-session-status.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-missing-lock-when-updating-session-status.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lh01w2pu0>
X-Attachment-Id: f_lh01w2pu0

RnJvbSBhOGM2M2FkOWU0NzhhNjA5OWUyMDI3NzAwMWFlYTA3NTYxZDQ1YmVhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMjYgQXByIDIwMjMgMjI6MDE6MzEgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBtaXNzaW5nIGxvY2sgd2hlbiB1cGRhdGluZyBzZXNzaW9uIHN0YXR1cwoKQ292ZXJpdHkg
bm90ZWQgYSBwbGFjZSB3aGVyZSB3ZSB3ZXJlIG5vdCBncmFiYmluZwp0aGUgc2VzX2xvY2sgd2hl
biBzZXR0aW5nIChhbmQgY2hlY2tpbmcpIHNlc19zdGF0dXMuCgpBZGRyZXNzZXMtQ292ZXJpdHk6
IDE1MzY4MzMgKCJEYXRhIHJhY2UgY29uZGl0aW9uIChNSVNTSU5HX0xPQ0spIikKUmV2aWV3ZWQt
Ynk6IEJoYXJhdGggU00gPGJoYXJhdGhzbUBtaWNyb3NvZnQuY29tPgpTaWduZWQtb2ZmLWJ5OiBT
dGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jb25uZWN0
LmMgfCA4ICsrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0
LmMKaW5kZXggMWNiYjkwNTg3OTk1Li43YmZlZjc0MWY3NTggMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
Y29ubmVjdC5jCisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jCkBAIC0xOTE2LDE4ICsxOTE2LDIyIEBA
IHZvaWQgY2lmc19wdXRfc21iX3NlcyhzdHJ1Y3QgY2lmc19zZXMgKnNlcykKIAkvKiBzZXNfY291
bnQgY2FuIG5ldmVyIGdvIG5lZ2F0aXZlICovCiAJV0FSTl9PTihzZXMtPnNlc19jb3VudCA8IDAp
OwogCisJc3Bpbl9sb2NrKCZzZXMtPnNlc19sb2NrKTsKIAlpZiAoc2VzLT5zZXNfc3RhdHVzID09
IFNFU19HT09EKQogCQlzZXMtPnNlc19zdGF0dXMgPSBTRVNfRVhJVElORzsKIAotCWNpZnNfZnJl
ZV9pcGMoc2VzKTsKLQogCWlmIChzZXMtPnNlc19zdGF0dXMgPT0gU0VTX0VYSVRJTkcgJiYgc2Vy
dmVyLT5vcHMtPmxvZ29mZikgeworCQlzcGluX3VubG9jaygmc2VzLT5zZXNfbG9jayk7CisJCWNp
ZnNfZnJlZV9pcGMoc2VzKTsKIAkJeGlkID0gZ2V0X3hpZCgpOwogCQlyYyA9IHNlcnZlci0+b3Bz
LT5sb2dvZmYoeGlkLCBzZXMpOwogCQlpZiAocmMpCiAJCQljaWZzX3NlcnZlcl9kYmcoVkZTLCAi
JXM6IFNlc3Npb24gTG9nb2ZmIGZhaWx1cmUgcmM9JWRcbiIsCiAJCQkJX19mdW5jX18sIHJjKTsK
IAkJX2ZyZWVfeGlkKHhpZCk7CisJfSBlbHNlIHsKKwkJc3Bpbl91bmxvY2soJnNlcy0+c2VzX2xv
Y2spOworCQljaWZzX2ZyZWVfaXBjKHNlcyk7CiAJfQogCiAJc3Bpbl9sb2NrKCZjaWZzX3RjcF9z
ZXNfbG9jayk7Ci0tIAoyLjM0LjEKCg==
--000000000000df5ee905fa5ddde1--
