Return-Path: <SRS0=r6gO=B4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B5DAC433DF
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Aug 2020 16:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 146272076E
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Aug 2020 16:25:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LTMN5UbW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgHRQY7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Aug 2020 12:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbgHRQYu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Aug 2020 12:24:50 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F211EC061342
        for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2020 09:24:49 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id e187so11708985ybc.5
        for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2020 09:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=5JghGaEeO9JthKlJk4KLq3fQjlL5Rjv22iMzkXYUNpU=;
        b=LTMN5UbWRobg/vltkp2/vKqdB2uLeT3TvEq3d/fECKiaPry4iljdG6CbkUrpcXpa0l
         1XyOlGfOzhXDyYyyGjQefsGopxzXVa0ygrh9sN+ALqae9znk0USjK6xX/yA6f5VVPBW5
         zIlsPnvhx4Zce7HZroaIVh3Eg4FmwvR0qQWARA42n/xSQjjNmemmaz3bXTLJIM888436
         2YDUKeHET57CqyMBKCzdNCl4Bg4Eo0D6bzY+1clyMfmlBN2ssb5ZGA7QZdZ6VcGbOIDU
         lw4ldEhxouoc9lQe/gectI3RE271RUxIytOFJxEhFlSwoQ6+fjiXT3R68v9zvL3+5oei
         AgiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=5JghGaEeO9JthKlJk4KLq3fQjlL5Rjv22iMzkXYUNpU=;
        b=OZ/tLQz/I2E6n55V9qSuFNgL8wg4wSIAMQkt+/m581UDFQ4SYhEuYunaOcAkW0CJxi
         RKEuLdS1lTfauS612M9FPJ/jsR5AjAIYlWq5mLyBAXyBECzwJIlwTgSUJsNJhRI38N/G
         w7lbScDGI6YUUdh8gWcjcGWqKg70JK4w0NZOKB4QrtsAN9HouV8N1StqtAKiDL8VgO2E
         QdobpxR2S8AtdXsJbPkRxDpwDaL6nkW4770xZo4cONGvkT+2ADdwqVlnlBD+49UKg8a8
         QSllKX9KvxDWwn2p9NYHSVqK0rGjcJ9ydtCwjkLGcBPjmzVN9DURbnaYaj+0QycIlhqq
         1dFg==
X-Gm-Message-State: AOAM533GMN3bu9x8D1A/xjkTsGKop5bHYPfEhiUxrh/Cnz4JkXS4fFZ2
        G0Z2frq0tUttc0G8hzH4csbXqpTrkbi14WKsVOUwDNKCI7M=
X-Google-Smtp-Source: ABdhPJyMt05Mv9kqNfLKUqRPe0xTbANyuyNTvVrAGlosXbPImAFU68nPPbsy0TvSo99uKXE7YjTkuRCLzXED64TwDJo=
X-Received: by 2002:a25:ab11:: with SMTP id u17mr27673586ybi.327.1597767888929;
 Tue, 18 Aug 2020 09:24:48 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=p55m0D2VsoXUPDw3qQmVHWKTVtcyZuf7sNAbsFCqEn2Q@mail.gmail.com>
In-Reply-To: <CANT5p=p55m0D2VsoXUPDw3qQmVHWKTVtcyZuf7sNAbsFCqEn2Q@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 18 Aug 2020 21:54:37 +0530
Message-ID: <CANT5p=qmiFfR4qvrW6+GsZGVc_pAeVz7pL00RpXUReescT_d_Q@mail.gmail.com>
Subject: Re: [PATCH][SMB3] cifs: Fix unix perm bits to cifsacl conversion for
 "other" bits.
To:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000007424b605ad295331"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000007424b605ad295331
Content-Type: text/plain; charset="UTF-8"

Sorry. Forgot to attach the patch. :)

On Tue, Aug 18, 2020 at 9:53 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi all,
>
> Recently, I hit a bug while testing out the cifsacl mount option. The
> "other" bits were getting replicated to "owner" and "group" bits,
> after sometime (I'm thinking after actimeo expires).
>
> Attaching patch with fixes for perm bits to DACL mapping and reverse mapping.
> Please review and let me know what you think.
>
> As indicated in the commit message, there could be further
> optimizations to reduce the number of ACEs in the file DACL. I've not
> yet figured out a good way to figure out the more "restrictive" perm.
> --
> -Shyam



-- 
-Shyam

--0000000000007424b605ad295331
Content-Type: application/octet-stream; 
	name="0001-cifs-Fix-unix-perm-bits-to-cifsacl-conversion-for-ot.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Fix-unix-perm-bits-to-cifsacl-conversion-for-ot.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ke05qlsi0>
X-Attachment-Id: f_ke05qlsi0

RnJvbSBlNTRiY2FmYzg2YjhlMjI1ZTllMzU3MGRjZDZmNjQzZDNkM2IyODhiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBNb24sIDE3IEF1ZyAyMDIwIDAzOjIzOjEyIC0wNzAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogRml4IHVuaXggcGVybSBiaXRzIHRvIGNpZnNhY2wgY29udmVyc2lvbiBmb3IgIm90aGVy
IgogYml0cy4KCldpdGggdGhlICJjaWZzYWNsIiBtb3VudCBvcHRpb24sIHRoZSBtb2RlIGJpdHMg
c2V0IG9uIHRoZSBmaWxlL2RpcgppcyBjb252ZXJ0ZWQgdG8gY29ycmVzcG9uZGluZyBBQ0VzIGlu
IERBQ0wuIEhvd2V2ZXIsIG9ubHkgdGhlCkFMTE9XRUQgQUNFcyB3ZXJlIGJlaW5nIHNldCBmb3Ig
Im93bmVyIiBhbmQgImdyb3VwIiBTSURzLiBTaW5jZQpvd25lciBpcyBhIHN1YnNldCBvZiBncm91
cCwgYW5kIGdyb3VwIGlzIGEgc3Vic2V0IG9mCmV2ZXJ5b25lL3dvcmxkIFNJRCwgaW4gb3JkZXIg
dG8gcHJvcGVybHkgZW11bGF0ZSB1bml4IHBlcm0gZ3JvdXBzLAp3ZSBuZWVkIHRvIGFkZCBERU5J
RUQgQUNFcyBhZnRlciBib3RoIG93bmVyIGFuZCBncm91cCBBTExPV0VEIEFDRXMuCklmIHdlIGRv
bid0IGRvIHRoYXQsICJvd25lciIgYW5kICJncm91cCIgU0lEcyBjb3VsZCBnZXQgbW9yZQphY2Nl
c3MgcmlnaHRzIHRoYW4gdGhleSBzaG91bGQuIFdoaWNoIHdhcyB3aGF0IHdhcyBoYXBwZW5pbmcu
CgpGdXJ0aGVyLCBhcyBwZXIgdGhlIGRvY3VtZW50OgpodHRwOi8vdGVjaG5ldC5taWNyb3NvZnQu
Y29tL2VuLXVzL2xpYnJhcnkvYmI0NjMyMTYuYXNweAouLi4gb24gd2hpY2ggY2lmc2FjbCBtb3Vu
dCBvcHRpb24gaXMgbW9kZWxsZWQgdXBvbiwKd2UgY291bGQgZnVydGhlciBoYW5kbGUgdGhlIGNh
c2VzIG9mOgoKMS4gb3duZXIgU0lEID09IGdyb3VwIFNJRC4gSW4gdGhpcyBjYXNlLCB1c2UgdGhl
IG1vcmUgcmVzdHJpY3RpdmUKYW1vbmcgdGhlIHR3byBwZXJtIGJpdHMgYW5kIGNvbnZlcnQgdGhl
bSB0byBBQ0VzLgoKMi4gQWRkIHRoZSBERU5JRUQgQUNFcyBvbmx5IHdoZW4gdGhlIG93bmVyIG9y
IGdyb3VwIHBlcm0gYml0cyBhcmUKbW9yZSByZXN0cmljdGl2ZSB0aGFuIHRoZSBuZXh0IHNldC4K
CkkgaGF2ZSBub3QgeWV0IGFkZGVkIHRoZXNlIG9wdGltaXphdGlvbnMuCk1heWJlIEknbGwgc3Vi
bWl0IHBhdGNoZXMgZm9yIHRoZXNlIHNvb24uCgpBbHNvLCBmb3IgcmV2ZXJzZSBtYXBwaW5nLCBp
LmUuIHRvIGNvbnZlcnQgQUNMIHRvIHVuaXggcGVybSBiaXRzLApmb3IgdGhlICJvdGhlcnMiIGJp
dHMsIHdlIG5lZWRlZCB0byBhZGQgdGhlIG1hc2tlZCBiaXRzIG9mIHRoZQpvd25lciBhbmQgZ3Jv
dXAgbWFza3MgdG8gb3RoZXJzIG1hc2suCi0tLQogZnMvY2lmcy9jaWZzYWNsLmMgfCA3MiArKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5n
ZWQsIDQ3IGluc2VydGlvbnMoKyksIDI1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2Np
ZnMvY2lmc2FjbC5jIGIvZnMvY2lmcy9jaWZzYWNsLmMKaW5kZXggZmNmZjE0ZWYxYzcwLi4zZjE2
ZmYyZTBkZmUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2FjbC5jCisrKyBiL2ZzL2NpZnMvY2lm
c2FjbC5jCkBAIC02MzcsMTMgKzYzNywxMyBAQCBzdGF0aWMgdm9pZCBtb2RlX3RvX2FjY2Vzc19m
bGFncyh1bW9kZV90IG1vZGUsIHVtb2RlX3QgYml0c190b191c2UsCiB9CiAKIHN0YXRpYyBfX3Ux
NiBmaWxsX2FjZV9mb3Jfc2lkKHN0cnVjdCBjaWZzX2FjZSAqcG50YWNlLAotCQkJY29uc3Qgc3Ry
dWN0IGNpZnNfc2lkICpwc2lkLCBfX3U2NCBubW9kZSwgdW1vZGVfdCBiaXRzKQorCQkJY29uc3Qg
c3RydWN0IGNpZnNfc2lkICpwc2lkLCBfX3U2NCBubW9kZSwgdW1vZGVfdCBiaXRzLCBfX3U4IGFj
Y2Vzc190eXBlKQogewogCWludCBpOwogCV9fdTE2IHNpemUgPSAwOwogCV9fdTMyIGFjY2Vzc19y
ZXEgPSAwOwogCi0JcG50YWNlLT50eXBlID0gQUNDRVNTX0FMTE9XRUQ7CisJcG50YWNlLT50eXBl
ID0gYWNjZXNzX3R5cGU7CiAJcG50YWNlLT5mbGFncyA9IDB4MDsKIAltb2RlX3RvX2FjY2Vzc19m
bGFncyhubW9kZSwgYml0cywgJmFjY2Vzc19yZXEpOwogCWlmICghYWNjZXNzX3JlcSkKQEAgLTc2
NywyNiArNzY3LDM5IEBAIHN0YXRpYyB2b2lkIHBhcnNlX2RhY2woc3RydWN0IGNpZnNfYWNsICpw
ZGFjbCwgY2hhciAqZW5kX29mX2FjbCwKIAkJCQlmYXR0ci0+Y2ZfbW9kZSB8PQogCQkJCQlsZTMy
X3RvX2NwdShwcGFjZVtpXS0+c2lkLnN1Yl9hdXRoWzJdKTsKIAkJCQlicmVhazsKLQkJCX0gZWxz
ZSBpZiAoY29tcGFyZV9zaWRzKCYocHBhY2VbaV0tPnNpZCksIHBvd25lcnNpZCkgPT0gMCkKLQkJ
CQlhY2Nlc3NfZmxhZ3NfdG9fbW9kZShwcGFjZVtpXS0+YWNjZXNzX3JlcSwKLQkJCQkJCSAgICAg
cHBhY2VbaV0tPnR5cGUsCi0JCQkJCQkgICAgICZmYXR0ci0+Y2ZfbW9kZSwKLQkJCQkJCSAgICAg
JnVzZXJfbWFzayk7Ci0JCQllbHNlIGlmIChjb21wYXJlX3NpZHMoJihwcGFjZVtpXS0+c2lkKSwg
cGdycHNpZCkgPT0gMCkKLQkJCQlhY2Nlc3NfZmxhZ3NfdG9fbW9kZShwcGFjZVtpXS0+YWNjZXNz
X3JlcSwKLQkJCQkJCSAgICAgcHBhY2VbaV0tPnR5cGUsCi0JCQkJCQkgICAgICZmYXR0ci0+Y2Zf
bW9kZSwKLQkJCQkJCSAgICAgJmdyb3VwX21hc2spOwotCQkJZWxzZSBpZiAoY29tcGFyZV9zaWRz
KCYocHBhY2VbaV0tPnNpZCksICZzaWRfZXZlcnlvbmUpID09IDApCi0JCQkJYWNjZXNzX2ZsYWdz
X3RvX21vZGUocHBhY2VbaV0tPmFjY2Vzc19yZXEsCi0JCQkJCQkgICAgIHBwYWNlW2ldLT50eXBl
LAotCQkJCQkJICAgICAmZmF0dHItPmNmX21vZGUsCi0JCQkJCQkgICAgICZvdGhlcl9tYXNrKTsK
LQkJCWVsc2UgaWYgKGNvbXBhcmVfc2lkcygmKHBwYWNlW2ldLT5zaWQpLCAmc2lkX2F1dGh1c2Vy
cykgPT0gMCkKLQkJCQlhY2Nlc3NfZmxhZ3NfdG9fbW9kZShwcGFjZVtpXS0+YWNjZXNzX3JlcSwK
LQkJCQkJCSAgICAgcHBhY2VbaV0tPnR5cGUsCi0JCQkJCQkgICAgICZmYXR0ci0+Y2ZfbW9kZSwK
LQkJCQkJCSAgICAgJm90aGVyX21hc2spOworCQkJfSBlbHNlIHsKKwkJCQlpZiAoY29tcGFyZV9z
aWRzKCYocHBhY2VbaV0tPnNpZCksIHBvd25lcnNpZCkgPT0gMCkgeworCQkJCQlhY2Nlc3NfZmxh
Z3NfdG9fbW9kZShwcGFjZVtpXS0+YWNjZXNzX3JlcSwKKwkJCQkJCQlwcGFjZVtpXS0+dHlwZSwK
KwkJCQkJCQkmZmF0dHItPmNmX21vZGUsCisJCQkJCQkJJnVzZXJfbWFzayk7CisJCQkJCS8qIAor
CQkJCQkgKiBDbGVhciB0aGUgYml0cyB3aGljaCB3ZXJlIGNsZWFyZWQgaW4gdXNlcl9tYXNrLgor
CQkJCQkgKi8KKwkJCQkJb3RoZXJfbWFzayAmPSAodXNlcl9tYXNrIHwgflNfSVJXWFUpOworCQkJ
CX0KKworCQkJCWlmIChjb21wYXJlX3NpZHMoJihwcGFjZVtpXS0+c2lkKSwgcGdycHNpZCkgPT0g
MCkgeworCQkJCQlhY2Nlc3NfZmxhZ3NfdG9fbW9kZShwcGFjZVtpXS0+YWNjZXNzX3JlcSwKKwkJ
CQkJCQlwcGFjZVtpXS0+dHlwZSwKKwkJCQkJCQkmZmF0dHItPmNmX21vZGUsCisJCQkJCQkJJmdy
b3VwX21hc2spOworCQkJCQkvKiAKKwkJCQkJICogQ2xlYXIgdGhlIGJpdHMgd2hpY2ggd2VyZSBj
bGVhcmVkIGluIGdyb3VwX21hc2suCisJCQkJCSAqLworCQkJCQlvdGhlcl9tYXNrICY9IChncm91
cF9tYXNrIHwgflNfSVJXWEcpOworCQkJCX0gZWxzZSBpZiAoY29tcGFyZV9zaWRzKCYocHBhY2Vb
aV0tPnNpZCksICZzaWRfZXZlcnlvbmUpID09IDApIHsKKwkJCQkJYWNjZXNzX2ZsYWdzX3RvX21v
ZGUocHBhY2VbaV0tPmFjY2Vzc19yZXEsCisJCQkJCQkJcHBhY2VbaV0tPnR5cGUsCisJCQkJCQkJ
JmZhdHRyLT5jZl9tb2RlLAorCQkJCQkJCSZvdGhlcl9tYXNrKTsKKwkJCQl9IGVsc2UgaWYgKGNv
bXBhcmVfc2lkcygmKHBwYWNlW2ldLT5zaWQpLCAmc2lkX2F1dGh1c2VycykgPT0gMCkgeworCQkJ
CQlhY2Nlc3NfZmxhZ3NfdG9fbW9kZShwcGFjZVtpXS0+YWNjZXNzX3JlcSwKKwkJCQkJCQlwcGFj
ZVtpXS0+dHlwZSwKKwkJCQkJCQkmZmF0dHItPmNmX21vZGUsCisJCQkJCQkJJm90aGVyX21hc2sp
OworCQkJCX0KKwkJCX0KIAogCiAvKgkJCW1lbWNweSgodm9pZCAqKSgmKGNpZnNjcmVkLT5hY2Vz
W2ldKSksCkBAIC04ODksMTMgKzkwMiwyMiBAQCBzdGF0aWMgaW50IHNldF9jaG1vZF9kYWNsKHN0
cnVjdCBjaWZzX2FjbCAqcG5kYWNsLCBzdHJ1Y3QgY2lmc19zaWQgKnBvd25lcnNpZCwKIAl9CiAK
IAlzaXplICs9IGZpbGxfYWNlX2Zvcl9zaWQoKHN0cnVjdCBjaWZzX2FjZSAqKSAoKGNoYXIgKilw
bm5kYWNsICsgc2l6ZSksCi0JCQkJCXBvd25lcnNpZCwgbm1vZGUsIFNfSVJXWFUpOworCQkJCQlw
b3duZXJzaWQsIG5tb2RlLCBTX0lSV1hVLCBBQ0NFU1NfQUxMT1dFRCk7CisJbnVtX2FjZXMrKzsK
KwlzaXplICs9IGZpbGxfYWNlX2Zvcl9zaWQoKHN0cnVjdCBjaWZzX2FjZSAqKSgoY2hhciAqKXBu
bmRhY2wgKyBzaXplKSwKKwkJCQkJcG93bmVyc2lkLCBubW9kZSwgU19JUldYRywgQUNDRVNTX0RF
TklFRCk7CisJbnVtX2FjZXMrKzsKKwlzaXplICs9IGZpbGxfYWNlX2Zvcl9zaWQoKHN0cnVjdCBj
aWZzX2FjZSAqKSgoY2hhciAqKXBubmRhY2wgKyBzaXplKSwKKwkJCQkJcGdycHNpZCwgbm1vZGUs
IFNfSVJXWEcsIEFDQ0VTU19BTExPV0VEKTsKKwludW1fYWNlcysrOworCXNpemUgKz0gZmlsbF9h
Y2VfZm9yX3NpZCgoc3RydWN0IGNpZnNfYWNlICopKChjaGFyICopcG5uZGFjbCArIHNpemUpLAor
CQkJCQlwb3duZXJzaWQsIG5tb2RlLCBTX0lSV1hPLCBBQ0NFU1NfREVOSUVEKTsKIAludW1fYWNl
cysrOwogCXNpemUgKz0gZmlsbF9hY2VfZm9yX3NpZCgoc3RydWN0IGNpZnNfYWNlICopKChjaGFy
ICopcG5uZGFjbCArIHNpemUpLAotCQkJCQlwZ3Jwc2lkLCBubW9kZSwgU19JUldYRyk7CisJCQkJ
CXBncnBzaWQsIG5tb2RlLCBTX0lSV1hPLCBBQ0NFU1NfREVOSUVEKTsKIAludW1fYWNlcysrOwog
CXNpemUgKz0gZmlsbF9hY2VfZm9yX3NpZCgoc3RydWN0IGNpZnNfYWNlICopKChjaGFyICopcG5u
ZGFjbCArIHNpemUpLAotCQkJCQkgJnNpZF9ldmVyeW9uZSwgbm1vZGUsIFNfSVJXWE8pOworCQkJ
CQkgJnNpZF9ldmVyeW9uZSwgbm1vZGUsIFNfSVJXWE8sIEFDQ0VTU19BTExPV0VEKTsKIAludW1f
YWNlcysrOwogCiAJcG5kYWNsLT5udW1fYWNlcyA9IGNwdV90b19sZTMyKG51bV9hY2VzKTsKLS0g
CjIuMjUuMQoK
--0000000000007424b605ad295331--
