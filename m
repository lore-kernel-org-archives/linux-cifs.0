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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367D9C2B9F4
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 17:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2193A6008E
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 17:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhFVRMA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 13:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbhFVRL7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Jun 2021 13:11:59 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D3BC061574;
        Tue, 22 Jun 2021 10:09:43 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id j2so37156517lfg.9;
        Tue, 22 Jun 2021 10:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ySPSembMv+uHnA5CCIgoX4hVhYvQujW4L2TxPO+7lCY=;
        b=h/0Vfwy0JI7VYdXN5ammCJwNTYRhIqQPL5zyIxVLudRefHgb4NNNVjixxD994A4Pc3
         t11i4CKz/q9EiRmPLxoAixu0ZorCDTVNZxapplCc6R4LoXGBkU3BUlBPS9Yyp3Gwc7db
         IdEPTcpdZR2uub7Xp/JxnQN27MAchUowr2sKAelU4o2Zdf4rzJzU3nEgBmwxr7ULur+I
         rn0VHsZQSjYoBLQPJ8F+27AlQwXjXIBaHnQHfcM0RU3AP7wjHfEYYdBk5Zwe6uUlPbD4
         Ivon30ZRyvM+cu9j+xXAy5k7wQfrWsk6npnNCXvhx88ipkr2pSDnIAl2kdEQehZohTok
         ThUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ySPSembMv+uHnA5CCIgoX4hVhYvQujW4L2TxPO+7lCY=;
        b=grlW84ZsV2C6Ihb4kg2Z8QySf8R3JonxcmF9Vozbyz/OD6tgwgzqMt/sVNIcIy8u4y
         WGWY82Su+z1LYCvo65KzHj8eJ1nDAzy7cERc/1I6jkUuE+M79RUqlYxA9rJat3XCloEG
         mEeYAj2mnqR6vKTO8NGRFjYozvN1F5ZrJGaJA5+fSIudk2shxn1BtKxEj0fvt1eIf7Yv
         HHGAXfvY0IpuS24f9J2jPwrlOnaQw/ySINAvTFUgJXiZWuURc6w+bcu7R/uTQLjpVwN1
         F8zVF2puf4um3TJM6BSqNkYN1CH4BZhd895O30xH210PP3qySqExl1G76oYzZ97c5RG7
         2XOw==
X-Gm-Message-State: AOAM530ZGlR0FGuL1fO+P2pffNqwI7W3/6VG5tBh1NnvJoAa1N4FxA67
        iv3tpKMTrfGoq84ZKrIdDuKOl0BAA0TSJfF74dI=
X-Google-Smtp-Source: ABdhPJxRNG1LG/kkbhgyu2c1Sz+D6p2aQdnE4fbSxEP1CuEKmynZElMrrY1FHxC0x+PJ4KT2FVkZowGNAMdKVcCiGfo=
X-Received: by 2002:a19:6712:: with SMTP id b18mr3798678lfc.184.1624381780260;
 Tue, 22 Jun 2021 10:09:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msOSLaZT42-jFMjJrB1YiYTZBzdM18ieqQY2v=YwXzcrA@mail.gmail.com>
 <1241844c-c9ab-2055-a363-80db63a4dd22@talpey.com>
In-Reply-To: <1241844c-c9ab-2055-a363-80db63a4dd22@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 22 Jun 2021 12:09:28 -0500
Message-ID: <CAH2r5muyH4HSWcYZSZMD_TNtF-Gw4Z13FvQ7H9NmmqWetYKZUQ@mail.gmail.com>
Subject: Re: [SMBDIRECT][PATCH] missing rc checks while waiting for SMB3 over
 RDMA events
To:     Tom Talpey <tom@talpey.com>
Cc:     Long Li <longli@microsoft.com>, CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000fe696805c55dda18"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000fe696805c55dda18
Content-Type: text/plain; charset="UTF-8"

patch updated with Tom's suggestions - let me know if I have missed anything.


On Tue, Jun 22, 2021 at 10:18 AM Tom Talpey <tom@talpey.com> wrote:
>
> On 6/21/2021 5:32 PM, Steve French wrote:
> >      There were two places where we weren't checking for error
> >      (e.g. ERESTARTSYS) while waiting for rdma resolution.
> >
> >      Addresses-Coverity: 1462165 ("Unchecked return value")
> >     Signed-off-by: Steve French <stfrench@microsoft.com>
> >
> > diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> > index 10dfe5006792..ae07732f750f 100644
> > --- a/fs/cifs/smbdirect.c
> > +++ b/fs/cifs/smbdirect.c
> > @@ -572,8 +572,11 @@ static struct rdma_cm_id *smbd_create_id(
> >                  log_rdma_event(ERR, "rdma_resolve_addr() failed %i\n", rc);
> >                  goto out;
> >          }
> > -       wait_for_completion_interruptible_timeout(
> > +       rc = wait_for_completion_interruptible_timeout(
> >                  &info->ri_done, msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
> > +       /* -ERESTARTSYS, returned when interrupted, is the only rc mentioned */
>
> Suggest the same comment text as the one below, this one seems uncertain.
>
> > +       if (rc < 0)
> > +               goto out;
> >          rc = info->ri_rc;
> >          if (rc) {
> >                  log_rdma_event(ERR, "rdma_resolve_addr() completed %i\n", rc);
> > @@ -586,8 +589,10 @@ static struct rdma_cm_id *smbd_create_id(
> >                  log_rdma_event(ERR, "rdma_resolve_route() failed %i\n", rc);
> >                  goto out;
> >          }
> > -       wait_for_completion_interruptible_timeout(
> > +       rc = wait_for_completion_interruptible_timeout(
> >                  &info->ri_done, msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT));
> > +       if (rc < 0)  /* e.g. if interrupted and returns -ERESTARTSYS */
>
> delete "and"?
>
> > +               goto out
>
> Missing a semicolon.     ^^^
>
> >          rc = info->ri_rc;
> >          if (rc) {
> >                  log_rdma_event(ERR, "rdma_resolve_route() completed %i\n", rc);
> >
> >
>
> One meta-comment. There's no message logged for these ERESTARTSYS cases.
> That might be confusing in the log, if they lead to failure.
>
> Reviewed-By: Tom Talpey <tom@talpey.com>
>
> Tom.



-- 
Thanks,

Steve

--000000000000fe696805c55dda18
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smbdirect-missing-rc-checks-while-waiting-for-rdma-e.patch"
Content-Disposition: attachment; 
	filename="0001-smbdirect-missing-rc-checks-while-waiting-for-rdma-e.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kq8ayoso0>
X-Attachment-Id: f_kq8ayoso0

RnJvbSAwNTU1YjIyMTUyOGU5Y2IxMWY1NzY2ZGNkZWUxOWM4MDkxODdlNDJlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjEgSnVuIDIwMjEgMTY6MjU6MjAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWJkaXJlY3Q6IG1pc3NpbmcgcmMgY2hlY2tzIHdoaWxlIHdhaXRpbmcgZm9yIHJkbWEgZXZlbnRz
CgpUaGVyZSB3ZXJlIHR3byBwbGFjZXMgd2hlcmUgd2Ugd2VyZW4ndCBjaGVja2luZyBmb3IgZXJy
b3IKKGUuZy4gRVJFU1RBUlRTWVMpIHdoaWxlIHdhaXRpbmcgZm9yIHJkbWEgcmVzb2x1dGlvbi4K
CkFkZHJlc3Nlcy1Db3Zlcml0eTogMTQ2MjE2NSAoIlVuY2hlY2tlZCByZXR1cm4gdmFsdWUiKQpS
ZXZpZXdlZC1ieTogVG9tIFRhbHBleSA8dG9tQHRhbHBleS5jb20+ClJldmlld2VkLWJ5OiBMb25n
IExpIDxsb25nbGlAbWljcm9zb2Z0LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxz
dGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvc21iZGlyZWN0LmMgfCAxNCArKysr
KysrKysrKystLQogMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWJkaXJlY3QuYyBiL2ZzL2NpZnMvc21iZGlyZWN0
LmMKaW5kZXggMTBkZmU1MDA2NzkyLi4zMWVmNjRlYjdmYmIgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
c21iZGlyZWN0LmMKKysrIGIvZnMvY2lmcy9zbWJkaXJlY3QuYwpAQCAtNTcyLDggKzU3MiwxMyBA
QCBzdGF0aWMgc3RydWN0IHJkbWFfY21faWQgKnNtYmRfY3JlYXRlX2lkKAogCQlsb2dfcmRtYV9l
dmVudChFUlIsICJyZG1hX3Jlc29sdmVfYWRkcigpIGZhaWxlZCAlaVxuIiwgcmMpOwogCQlnb3Rv
IG91dDsKIAl9Ci0Jd2FpdF9mb3JfY29tcGxldGlvbl9pbnRlcnJ1cHRpYmxlX3RpbWVvdXQoCisJ
cmMgPSB3YWl0X2Zvcl9jb21wbGV0aW9uX2ludGVycnVwdGlibGVfdGltZW91dCgKIAkJJmluZm8t
PnJpX2RvbmUsIG1zZWNzX3RvX2ppZmZpZXMoUkRNQV9SRVNPTFZFX1RJTUVPVVQpKTsKKwkvKiBl
LmcuIGlmIGludGVycnVwdGVkIHJldHVybnMgLUVSRVNUQVJUU1lTICovCisJaWYgKHJjIDwgMCkg
eworCQlsb2dfcmRtYV9ldmVudChFUlIsICJyZG1hX3Jlc29sdmVfYWRkciB0aW1lb3V0IHJjOiAl
aVxuIiwgcmMpOworCQlnb3RvIG91dDsKKwl9CiAJcmMgPSBpbmZvLT5yaV9yYzsKIAlpZiAocmMp
IHsKIAkJbG9nX3JkbWFfZXZlbnQoRVJSLCAicmRtYV9yZXNvbHZlX2FkZHIoKSBjb21wbGV0ZWQg
JWlcbiIsIHJjKTsKQEAgLTU4Niw4ICs1OTEsMTMgQEAgc3RhdGljIHN0cnVjdCByZG1hX2NtX2lk
ICpzbWJkX2NyZWF0ZV9pZCgKIAkJbG9nX3JkbWFfZXZlbnQoRVJSLCAicmRtYV9yZXNvbHZlX3Jv
dXRlKCkgZmFpbGVkICVpXG4iLCByYyk7CiAJCWdvdG8gb3V0OwogCX0KLQl3YWl0X2Zvcl9jb21w
bGV0aW9uX2ludGVycnVwdGlibGVfdGltZW91dCgKKwlyYyA9IHdhaXRfZm9yX2NvbXBsZXRpb25f
aW50ZXJydXB0aWJsZV90aW1lb3V0KAogCQkmaW5mby0+cmlfZG9uZSwgbXNlY3NfdG9famlmZmll
cyhSRE1BX1JFU09MVkVfVElNRU9VVCkpOworCS8qIGUuZy4gaWYgaW50ZXJydXB0ZWQgcmV0dXJu
cyAtRVJFU1RBUlRTWVMgKi8KKwlpZiAocmMgPCAwKSAgeworCQlsb2dfcmRtYV9ldmVudChFUlIs
ICJyZG1hX3Jlc29sdmVfYWRkciB0aW1lb3V0IHJjOiAlaVxuIiwgcmMpOworCQlnb3RvIG91dDsK
Kwl9CiAJcmMgPSBpbmZvLT5yaV9yYzsKIAlpZiAocmMpIHsKIAkJbG9nX3JkbWFfZXZlbnQoRVJS
LCAicmRtYV9yZXNvbHZlX3JvdXRlKCkgY29tcGxldGVkICVpXG4iLCByYyk7Ci0tIAoyLjMwLjIK
Cg==
--000000000000fe696805c55dda18--
