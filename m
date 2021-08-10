Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E0BDC4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 17:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18749600EF
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 17:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbhHJR3y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Aug 2021 13:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhHJR3x (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Aug 2021 13:29:53 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75907C0613C1
        for <linux-cifs@vger.kernel.org>; Tue, 10 Aug 2021 10:29:30 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id x9so28313391ljj.2
        for <linux-cifs@vger.kernel.org>; Tue, 10 Aug 2021 10:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mGIBoBVCFk+SrZ91F25YGShMtPzzD6tCEBXEV+UeGtk=;
        b=jrTu5hvdVktLpuchbw8PXL1yGlt4AoBJ3q39YSt54KEgxtILS20FiWoUS/SSXSmTPj
         M9GQO4A93bI89SoSaTrPjWVHMa3QUstWzXHVLGLSJzFgGCpiwuTqgykGq4YoxZ7Qh8QA
         u1NCStyKt7zD67qt77RAy+ukWoWF6ufZ52bVOSi4ytvZocWjaZabILQLL1Mkd5Aw1TDD
         h/EK8FqpXpf/g4ya2PzSMGzFp4WYxhovR9tDNjCQYP8f7sj5LxQA0OACwnrIudn4H9b0
         wWV82Cp7YiOk3yCXQv4NxrJeohZmxHLga7S2kovsUdadkva5pGpIPPdaLBg1ziWmq/nA
         8xJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mGIBoBVCFk+SrZ91F25YGShMtPzzD6tCEBXEV+UeGtk=;
        b=UO28CILY40anfsWGPHLqZUJ72a5bp3IagmVzTAR9h/uxsF68evAoxVVS+p0ciWa/jW
         UkYN0qS4/xBxkDdKzO1grKMoq0MJJRuyFSiDUEv73Bft3Z4IM6zHQyF8WVd+kYyVMXMi
         pMfytEwCygUtzSaStyALAVkhqJB9e76UWzaeDSSvbPud4y9eQU/q9YM08k3hRsM5W8v8
         uimZLa5x3H62NuCNU4K8Ttb1M6d/86hNJS+2OpGvU9xY/o/VOIAhuk3OH3bkfsJCyFvr
         xVEBkBxiMT1nQBbnc/mS9W4NFvxtkBJW7JYYwLBV7hXIrDml7+WBW/a+RaPBz1jLYX/w
         D6pw==
X-Gm-Message-State: AOAM53153kMpohkFj3x1hwytYJxgbCvH+g5Pon35AjxrzCQ7jYJYZL4r
        CdO1SEn1q70VCRSzeEKstSQqECrJ1Cjanp2yP1A=
X-Google-Smtp-Source: ABdhPJxxlOWaTawcpY15+Inqj5s0KX8iamU7BvOy5wu3NXUvkbnDyR+aJBn1QwNctWgT+ypzMgaEYqhbMmm/EmLg8o4=
X-Received: by 2002:a2e:95c1:: with SMTP id y1mr20265799ljh.71.1628616568877;
 Tue, 10 Aug 2021 10:29:28 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0Z4rDEGsi02+0DJnw2EoTV2CSC-jDN-SyDhKz0WcGZoAQ@mail.gmail.com>
 <CANT5p=rN_ogRccKmYpE+17qz=zRyUJChcKo5+cJiwDTFq_cBJw@mail.gmail.com>
In-Reply-To: <CANT5p=rN_ogRccKmYpE+17qz=zRyUJChcKo5+cJiwDTFq_cBJw@mail.gmail.com>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Tue, 10 Aug 2021 22:59:17 +0530
Message-ID: <CACdtm0aGGqtSsv1t2=VTGZZTBD52JvOsWD_oqXuUnejeDCVJFw@mail.gmail.com>
Subject: Re: [PATCH][CIFS]Call close synchronously during unlink/rename/lease break.
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000001051e505c937d882"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000001051e505c937d882
Content-Type: text/plain; charset="UTF-8"

Hi All,

Have updated the patch to fix the memleak.

Regards,
Rohith

On Tue, Aug 10, 2021 at 5:18 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Already gave my review comments along with this one to the other email.
>
> Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
>
> On Mon, Aug 9, 2021 at 3:28 PM Rohith Surabattula
> <rohiths.msft@gmail.com> wrote:
> >
> > Hi Steve/All,
> >
> > During unlink/rename/lease break, deferred work for close is
> > scheduled immediately but in asynchronous manner which might
> > lead to race with actual(unlink/rename) commands.
> >
> > This change will schedule close synchronously which will avoid
> > the race conditions with other commands.
> >
> > Regards,
> > Rohith
>
>
>
> --
> Regards,
> Shyam

--0000000000001051e505c937d882
Content-Type: application/octet-stream; 
	name="cifs-Call-close-synchronously-during-unlink-rename-l.patch"
Content-Disposition: attachment; 
	filename="cifs-Call-close-synchronously-during-unlink-rename-l.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ks6c8v2b0>
X-Attachment-Id: f_ks6c8v2b0

RnJvbSAzNDhjZDg5MWNmNTI0NjYyOGU1ZGU5Y2JmNDE5Y2Q4MWEzMmNlODU1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0
LmNvbT4KRGF0ZTogTW9uLCA5IEF1ZyAyMDIxIDA5OjMyOjQ2ICswMDAwClN1YmplY3Q6IFtQQVRD
SF0gY2lmczogQ2FsbCBjbG9zZSBzeW5jaHJvbm91c2x5IGR1cmluZyB1bmxpbmsvcmVuYW1lL2xl
YXNlCiBicmVhay4KCkR1cmluZyB1bmxpbmsvcmVuYW1lL2xlYXNlIGJyZWFrLCBkZWZlcnJlZCB3
b3JrIGZvciBjbG9zZSBpcwpzY2hlZHVsZWQgaW1tZWRpYXRlbHkgYnV0IGluIGFzeW5jaHJvbm91
cyBtYW5uZXIgd2hpY2ggbWlnaHQKbGVhZCB0byByYWNlIHdpdGggYWN0dWFsKHVubGluay9yZW5h
bWUpIGNvbW1hbmRzLgoKVGhpcyBjaGFuZ2Ugd2lsbCBzY2hlZHVsZSBjbG9zZSBzeW5jaHJvbm91
c2x5IHdoaWNoIHdpbGwgYXZvaWQKdGhlIHJhY2UgY29uZGl0aW9ucyB3aXRoIG90aGVyIGNvbW1h
bmRzLgoKU2lnbmVkLW9mZi1ieTogUm9oaXRoIFN1cmFiYXR0dWxhIDxyb2hpdGhzQG1pY3Jvc29m
dC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzZ2xvYi5oIHwgIDUgKysrKysKIGZzL2NpZnMvZmlsZS5j
ICAgICB8IDM1ICsrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tCiBmcy9jaWZzL21p
c2MuYyAgICAgfCA0NiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0t
LS0tCiAzIGZpbGVzIGNoYW5nZWQsIDU2IGluc2VydGlvbnMoKyksIDMwIGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRl
eCBjMGJmYzJmMDEwMzAuLmM2YTk1NDJjYTI4MSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xv
Yi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtMTYxMSw2ICsxNjExLDExIEBAIHN0cnVj
dCBkZnNfaW5mbzNfcGFyYW0gewogCWludCB0dGw7CiB9OwogCitzdHJ1Y3QgZmlsZV9saXN0IHsK
KwlzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7CisJc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGU7Cit9
OworCiAvKgogICogY29tbW9uIHN0cnVjdCBmb3IgaG9sZGluZyBpbm9kZSBpbmZvIHdoZW4gc2Vh
cmNoaW5nIGZvciBvciB1cGRhdGluZyBhbgogICogaW5vZGUgd2l0aCBuZXcgaW5mbwpkaWZmIC0t
Z2l0IGEvZnMvY2lmcy9maWxlLmMgYi9mcy9jaWZzL2ZpbGUuYwppbmRleCAwYTcyODQwYTg4ZjEu
LmJiOThmYmRkMjJhOSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9maWxlLmMKKysrIGIvZnMvY2lmcy9m
aWxlLmMKQEAgLTQ4NDcsMTcgKzQ4NDcsNiBAQCB2b2lkIGNpZnNfb3Bsb2NrX2JyZWFrKHN0cnVj
dCB3b3JrX3N0cnVjdCAqd29yaykKIAkJY2lmc19kYmcoVkZTLCAiUHVzaCBsb2NrcyByYyA9ICVk
XG4iLCByYyk7CiAKIG9wbG9ja19icmVha19hY2s6Ci0JLyoKLQkgKiByZWxlYXNpbmcgc3RhbGUg
b3Bsb2NrIGFmdGVyIHJlY2VudCByZWNvbm5lY3Qgb2Ygc21iIHNlc3Npb24gdXNpbmcKLQkgKiBh
IG5vdyBpbmNvcnJlY3QgZmlsZSBoYW5kbGUgaXMgbm90IGEgZGF0YSBpbnRlZ3JpdHkgaXNzdWUg
YnV0IGRvCi0JICogbm90IGJvdGhlciBzZW5kaW5nIGFuIG9wbG9jayByZWxlYXNlIGlmIHNlc3Np
b24gdG8gc2VydmVyIHN0aWxsIGlzCi0JICogZGlzY29ubmVjdGVkIHNpbmNlIG9wbG9jayBhbHJl
YWR5IHJlbGVhc2VkIGJ5IHRoZSBzZXJ2ZXIKLQkgKi8KLQlpZiAoIWNmaWxlLT5vcGxvY2tfYnJl
YWtfY2FuY2VsbGVkKSB7Ci0JCXJjID0gdGNvbi0+c2VzLT5zZXJ2ZXItPm9wcy0+b3Bsb2NrX3Jl
c3BvbnNlKHRjb24sICZjZmlsZS0+ZmlkLAotCQkJCQkJCSAgICAgY2lub2RlKTsKLQkJY2lmc19k
YmcoRllJLCAiT3Bsb2NrIHJlbGVhc2UgcmMgPSAlZFxuIiwgcmMpOwotCX0KIAkvKgogCSAqIFdo
ZW4gb3Bsb2NrIGJyZWFrIGlzIHJlY2VpdmVkIGFuZCB0aGVyZSBhcmUgbm8gYWN0aXZlCiAJICog
ZmlsZSBoYW5kbGVzIGJ1dCBjYWNoZWQsIHRoZW4gc2NoZWR1bGUgZGVmZXJyZWQgY2xvc2UgaW1t
ZWRpYXRlbHkuCkBAIC00ODY1LDE3ICs0ODU0LDI3IEBAIHZvaWQgY2lmc19vcGxvY2tfYnJlYWso
c3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogCSAqLwogCXNwaW5fbG9jaygmQ0lGU19JKGlub2Rl
KS0+ZGVmZXJyZWRfbG9jayk7CiAJaXNfZGVmZXJyZWQgPSBjaWZzX2lzX2RlZmVycmVkX2Nsb3Nl
KGNmaWxlLCAmZGNsb3NlKTsKKwlzcGluX3VubG9jaygmQ0lGU19JKGlub2RlKS0+ZGVmZXJyZWRf
bG9jayk7CiAJaWYgKGlzX2RlZmVycmVkICYmCiAJICAgIGNmaWxlLT5kZWZlcnJlZF9jbG9zZV9z
Y2hlZHVsZWQgJiYKIAkgICAgZGVsYXllZF93b3JrX3BlbmRpbmcoJmNmaWxlLT5kZWZlcnJlZCkp
IHsKLQkJLyoKLQkJICogSWYgdGhlcmUgaXMgbm8gcGVuZGluZyB3b3JrLCBtb2RfZGVsYXllZF93
b3JrIHF1ZXVlcyBuZXcgd29yay4KLQkJICogU28sIEluY3JlYXNlIHRoZSByZWYgY291bnQgdG8g
YXZvaWQgdXNlLWFmdGVyLWZyZWUuCi0JCSAqLwotCQlpZiAoIW1vZF9kZWxheWVkX3dvcmsoZGVm
ZXJyZWRjbG9zZV93cSwgJmNmaWxlLT5kZWZlcnJlZCwgMCkpCi0JCQljaWZzRmlsZUluZm9fZ2V0
KGNmaWxlKTsKKwkJaWYgKGNhbmNlbF9kZWxheWVkX3dvcmsoJmNmaWxlLT5kZWZlcnJlZCkpIHsK
KwkJCV9jaWZzRmlsZUluZm9fcHV0KGNmaWxlLCBmYWxzZSwgZmFsc2UpOworCQkJZ290byBvcGxv
Y2tfYnJlYWtfZG9uZTsKKwkJfQogCX0KLQlzcGluX3VubG9jaygmQ0lGU19JKGlub2RlKS0+ZGVm
ZXJyZWRfbG9jayk7CisJLyoKKwkgKiByZWxlYXNpbmcgc3RhbGUgb3Bsb2NrIGFmdGVyIHJlY2Vu
dCByZWNvbm5lY3Qgb2Ygc21iIHNlc3Npb24gdXNpbmcKKwkgKiBhIG5vdyBpbmNvcnJlY3QgZmls
ZSBoYW5kbGUgaXMgbm90IGEgZGF0YSBpbnRlZ3JpdHkgaXNzdWUgYnV0IGRvCisJICogbm90IGJv
dGhlciBzZW5kaW5nIGFuIG9wbG9jayByZWxlYXNlIGlmIHNlc3Npb24gdG8gc2VydmVyIHN0aWxs
IGlzCisJICogZGlzY29ubmVjdGVkIHNpbmNlIG9wbG9jayBhbHJlYWR5IHJlbGVhc2VkIGJ5IHRo
ZSBzZXJ2ZXIKKwkgKi8KKwlpZiAoIWNmaWxlLT5vcGxvY2tfYnJlYWtfY2FuY2VsbGVkKSB7CisJ
CXJjID0gdGNvbi0+c2VzLT5zZXJ2ZXItPm9wcy0+b3Bsb2NrX3Jlc3BvbnNlKHRjb24sICZjZmls
ZS0+ZmlkLAorCQkJCQkJCSAgICAgY2lub2RlKTsKKwkJY2lmc19kYmcoRllJLCAiT3Bsb2NrIHJl
bGVhc2UgcmMgPSAlZFxuIiwgcmMpOworCX0KK29wbG9ja19icmVha19kb25lOgogCV9jaWZzRmls
ZUluZm9fcHV0KGNmaWxlLCBmYWxzZSAvKiBkbyBub3Qgd2FpdCBmb3Igb3Vyc2VsZiAqLywgZmFs
c2UpOwogCWNpZnNfZG9uZV9vcGxvY2tfYnJlYWsoY2lub2RlKTsKIH0KZGlmZiAtLWdpdCBhL2Zz
L2NpZnMvbWlzYy5jIGIvZnMvY2lmcy9taXNjLmMKaW5kZXggY2RiMWVjMTQ2MWRlLi5mMjM1YThk
NDJlMzcgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvbWlzYy5jCisrKyBiL2ZzL2NpZnMvbWlzYy5jCkBA
IC03MjMsMjAgKzcyMywzMiBAQCB2b2lkCiBjaWZzX2Nsb3NlX2RlZmVycmVkX2ZpbGUoc3RydWN0
IGNpZnNJbm9kZUluZm8gKmNpZnNfaW5vZGUpCiB7CiAJc3RydWN0IGNpZnNGaWxlSW5mbyAqY2Zp
bGUgPSBOVUxMOworCXN0cnVjdCBmaWxlX2xpc3QgKnRtcF9saXN0OworCXN0cnVjdCBsaXN0X2hl
YWQgZmlsZV9oZWFkOwogCiAJaWYgKGNpZnNfaW5vZGUgPT0gTlVMTCkKIAkJcmV0dXJuOwogCisJ
SU5JVF9MSVNUX0hFQUQoJmZpbGVfaGVhZCk7CisJc3Bpbl9sb2NrKCZjaWZzX2lub2RlLT5vcGVu
X2ZpbGVfbG9jayk7CiAJbGlzdF9mb3JfZWFjaF9lbnRyeShjZmlsZSwgJmNpZnNfaW5vZGUtPm9w
ZW5GaWxlTGlzdCwgZmxpc3QpIHsKIAkJaWYgKGRlbGF5ZWRfd29ya19wZW5kaW5nKCZjZmlsZS0+
ZGVmZXJyZWQpKSB7Ci0JCQkvKgotCQkJICogSWYgdGhlcmUgaXMgbm8gcGVuZGluZyB3b3JrLCBt
b2RfZGVsYXllZF93b3JrIHF1ZXVlcyBuZXcgd29yay4KLQkJCSAqIFNvLCBJbmNyZWFzZSB0aGUg
cmVmIGNvdW50IHRvIGF2b2lkIHVzZS1hZnRlci1mcmVlLgotCQkJICovCi0JCQlpZiAoIW1vZF9k
ZWxheWVkX3dvcmsoZGVmZXJyZWRjbG9zZV93cSwgJmNmaWxlLT5kZWZlcnJlZCwgMCkpCi0JCQkJ
Y2lmc0ZpbGVJbmZvX2dldChjZmlsZSk7CisJCQlpZiAoY2FuY2VsX2RlbGF5ZWRfd29yaygmY2Zp
bGUtPmRlZmVycmVkKSkgeworCQkJCXRtcF9saXN0ID0ga21hbGxvYyhzaXplb2Yoc3RydWN0IGZp
bGVfbGlzdCksIEdGUF9BVE9NSUMpOworCQkJCWlmICh0bXBfbGlzdCA9PSBOVUxMKQorCQkJCQlj
b250aW51ZTsKKwkJCQl0bXBfbGlzdC0+Y2ZpbGUgPSBjZmlsZTsKKwkJCQlsaXN0X2FkZF90YWls
KCZ0bXBfbGlzdC0+bGlzdCwgJmZpbGVfaGVhZCk7CisJCQl9CiAJCX0KIAl9CisJc3Bpbl91bmxv
Y2soJmNpZnNfaW5vZGUtPm9wZW5fZmlsZV9sb2NrKTsKKworCWxpc3RfZm9yX2VhY2hfZW50cnko
dG1wX2xpc3QsICZmaWxlX2hlYWQsIGxpc3QpIHsKKwkJX2NpZnNGaWxlSW5mb19wdXQodG1wX2xp
c3QtPmNmaWxlLCB0cnVlLCBmYWxzZSk7CisJCWxpc3RfZGVsKCZ0bXBfbGlzdC0+bGlzdCk7CisJ
CWtmcmVlKHRtcF9saXN0KTsKKwl9CiB9CiAKIHZvaWQKQEAgLTc0NCwyMCArNzU2LDMwIEBAIGNp
ZnNfY2xvc2VfYWxsX2RlZmVycmVkX2ZpbGVzKHN0cnVjdCBjaWZzX3Rjb24gKnRjb24pCiB7CiAJ
c3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGU7CiAJc3RydWN0IGxpc3RfaGVhZCAqdG1wOworCXN0
cnVjdCBmaWxlX2xpc3QgKnRtcF9saXN0OworCXN0cnVjdCBsaXN0X2hlYWQgZmlsZV9oZWFkOwog
CisJSU5JVF9MSVNUX0hFQUQoJmZpbGVfaGVhZCk7CiAJc3Bpbl9sb2NrKCZ0Y29uLT5vcGVuX2Zp
bGVfbG9jayk7CiAJbGlzdF9mb3JfZWFjaCh0bXAsICZ0Y29uLT5vcGVuRmlsZUxpc3QpIHsKIAkJ
Y2ZpbGUgPSBsaXN0X2VudHJ5KHRtcCwgc3RydWN0IGNpZnNGaWxlSW5mbywgdGxpc3QpOwogCQlp
ZiAoZGVsYXllZF93b3JrX3BlbmRpbmcoJmNmaWxlLT5kZWZlcnJlZCkpIHsKLQkJCS8qCi0JCQkg
KiBJZiB0aGVyZSBpcyBubyBwZW5kaW5nIHdvcmssIG1vZF9kZWxheWVkX3dvcmsgcXVldWVzIG5l
dyB3b3JrLgotCQkJICogU28sIEluY3JlYXNlIHRoZSByZWYgY291bnQgdG8gYXZvaWQgdXNlLWFm
dGVyLWZyZWUuCi0JCQkgKi8KLQkJCWlmICghbW9kX2RlbGF5ZWRfd29yayhkZWZlcnJlZGNsb3Nl
X3dxLCAmY2ZpbGUtPmRlZmVycmVkLCAwKSkKLQkJCQljaWZzRmlsZUluZm9fZ2V0KGNmaWxlKTsK
KwkJCWlmIChjYW5jZWxfZGVsYXllZF93b3JrKCZjZmlsZS0+ZGVmZXJyZWQpKSB7CisJCQkJdG1w
X2xpc3QgPSBrbWFsbG9jKHNpemVvZihzdHJ1Y3QgZmlsZV9saXN0KSwgR0ZQX0FUT01JQyk7CisJ
CQkJaWYgKHRtcF9saXN0ID09IE5VTEwpCisJCQkJCWNvbnRpbnVlOworCQkJCXRtcF9saXN0LT5j
ZmlsZSA9IGNmaWxlOworCQkJCWxpc3RfYWRkX3RhaWwoJnRtcF9saXN0LT5saXN0LCAmZmlsZV9o
ZWFkKTsKKwkJCX0KIAkJfQogCX0KIAlzcGluX3VubG9jaygmdGNvbi0+b3Blbl9maWxlX2xvY2sp
OworCisJbGlzdF9mb3JfZWFjaF9lbnRyeSh0bXBfbGlzdCwgJmZpbGVfaGVhZCwgbGlzdCkgewor
CQlfY2lmc0ZpbGVJbmZvX3B1dCh0bXBfbGlzdC0+Y2ZpbGUsIHRydWUsIGZhbHNlKTsKKwkJbGlz
dF9kZWwoJnRtcF9saXN0LT5saXN0KTsKKwkJa2ZyZWUodG1wX2xpc3QpOworCX0KIH0KIAogLyog
cGFyc2VzIERGUyByZWZmZXJhbCBWMyBzdHJ1Y3R1cmUKLS0gCjIuMzAuMgoK
--0000000000001051e505c937d882--
