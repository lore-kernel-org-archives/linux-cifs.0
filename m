Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE12FEB64D7
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Jun 2023 04:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjFWEWH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Jun 2023 00:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjFWEWF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Jun 2023 00:22:05 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7C11FED
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 21:22:04 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4f8792d2e86so149860e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 21:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687494123; x=1690086123;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YESE9mv7JL+cKBzLHy11Gy/DS1zpbmpFeLXHy5SML6o=;
        b=iMYK7WRG8ZCzsn5IflKI93cOKcH7WrV8ekb7GQThBQ8TjLM/rCj9RT6Aj4tSmpaiXz
         MXn2WdzSvEg73ZXiTrrGPzPx4SXO6J4mZ+VUJhgbYmK0QG2OunjFK6WUArykYx4uQNEP
         cS4Z5IM5oTh0v9MjAS2BushuWoMhDZA6Y3nQ7gCv0bisU3xkr0NBqcFgw3kz9wyydnJA
         9XlfwTd7d55bsCM6XS3WApOmQ8BqaJx72UWPqG55VlkVbewR0RGfvkXZxbM/oWwzpoiP
         6NT4JmBCP0ovsOdYE6UbT/IPHo0MBjIFgekbq03UWK3F+whZyRhcd6Q11cjTUonA5So3
         l1XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687494123; x=1690086123;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YESE9mv7JL+cKBzLHy11Gy/DS1zpbmpFeLXHy5SML6o=;
        b=PfaZjKSE17RFrFpEjdx4NNGD98Gvu0PSwbLpzNBe6fi6lInZDytW3/rDd0218YSBg3
         Kv+TBvI+j9ZP80wiMyr8nKt1rNCjFfjru5WmkVY4LFhLRO4FFu7Yes8+TZrpe+TgQm2l
         p021Hin4mDSHKT1bc/YhwSOwsyKP4fUWzxhm1y7XiBkasvhrBzjhejSisiKsBBViKQ8z
         SI5zBYLFPjdpWTMMhdtcbrLGBYzhCWcNGW99GhMfdeL7U//hci8YRH/AhwkxY7LJbt8c
         V2ITHqgl5EYjlWV6bwllSgDXgw4oQVvBmCiT6QnWpQgSvYN/9VbKgv9xaJUnY3VOnFry
         YbKA==
X-Gm-Message-State: AC+VfDzauoo07Wz6ToteciZahI84pUC/9LlBRamaDX/LH6XBKbDcRRWe
        j+aZsQX1FMv0pgVU0uiwsHXAMtvG0A3zLot3mYArKcvkIgW70A==
X-Google-Smtp-Source: ACHHUZ7goZxdwvp9bYvm1MNPbPvzB7IgwrYOlqb5RRO9gKRrxXCqqGFOJ24HRb7b58NbGHp1iTSKhQVuU9XqDYBbmAM=
X-Received: by 2002:a05:6512:450:b0:4f9:5887:5218 with SMTP id
 y16-20020a056512045000b004f958875218mr4545426lfk.35.1687494122802; Thu, 22
 Jun 2023 21:22:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230609174659.60327-1-sprasad@microsoft.com> <20230609174659.60327-4-sprasad@microsoft.com>
 <nlpmf2nsqosbz5ifzycdpoqmi22tkcoouuk4pjsp4exa2jtyqm@wzdmdh625e5p>
 <CANT5p=oGXceYkn=+7KjbN=9oC14S0ue16LAPB_56hyX588iOXw@mail.gmail.com>
 <CANT5p=rPRPVaRe2S4j=OqJTbOhs9onqR2ZNTMPNE1L_71aNQbw@mail.gmail.com>
 <a38028f0fbc7d6abb1f118f110537f21.pc@manguebit.com> <g6yidp2mk3sseniwodvdz6d3svgq2kt6jzsbuiuh4gb2zmj3g3@yl6cqh37q7bx>
In-Reply-To: <g6yidp2mk3sseniwodvdz6d3svgq2kt6jzsbuiuh4gb2zmj3g3@yl6cqh37q7bx>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 23 Jun 2023 09:51:51 +0530
Message-ID: <CANT5p=qPivH8p+_SXMN0phKPTKqkSoEHdc+omhvM10YckbSvFw@mail.gmail.com>
Subject: Re: [PATCH 4/6] cifs: display the endpoint IP details in DebugData
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com, pc@cjr.nz, bharathsm.hsk@gmail.com,
        tom@talpey.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: multipart/mixed; boundary="000000000000c029d205fec4574e"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000c029d205fec4574e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 12, 2023 at 8:59=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> On 06/12, Paulo Alcantara wrote:
> >Shyam Prasad N <nspmangalore@gmail.com> writes:
> >
> >> I had to use kernel_getsockname to get socket source details, not
> >> kernel_getpeername.
> >
> >Why can't you use @server->srcaddr directly?
>
> That's only filled if explicitly passed through srcaddr=3D mount option
> (to bind it later in bind_socket()).
>
> Otherwise, it stays zeroed through @server's lifetime.

Yes. As Enzo mentioned, srcaddr is only useful if the user gave that
mount option.

Also, here's an updated version of the patch.
kernel_getsockname seems to be a blocking function, and we need to
drop the spinlock before calling it.

--
Regards,
Shyam

--000000000000c029d205fec4574e
Content-Type: application/octet-stream; 
	name="0001-cifs-display-the-endpoint-IP-details-in-DebugData.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-display-the-endpoint-IP-details-in-DebugData.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lj82f7za0>
X-Attachment-Id: f_lj82f7za0

RnJvbSBjOWRiNTA3NGM0MDkyNjRiNjg5MmZmOTJmMjU0OWU2MTM4ZTU4OWE1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBGcmksIDkgSnVuIDIwMjMgMTI6NDY6MzQgKzAwMDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBkaXNwbGF5IHRoZSBlbmRwb2ludCBJUCBkZXRhaWxzIGluIERlYnVnRGF0YQoKV2l0aCBt
dWx0aWNoYW5uZWwsIGl0IGlzIHVzZWZ1bCB0byBrbm93IHRoZSBzcmMgcG9ydCBkZXRhaWxzCmZv
ciBlYWNoIGNoYW5uZWwuIFRoaXMgY2hhbmdlIHdpbGwgcHJpbnQgdGhlIGlwIGFkZHIgYW5kCnBv
cnQgZGV0YWlscyBmb3IgYm90aCB0aGUgc29ja2V0IGRlc3QgYW5kIHNyYyBlbmRwb2ludHMuCgpT
aWduZWQtb2ZmLWJ5OiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPgotLS0K
IGZzL3NtYi9jbGllbnQvY2lmc19kZWJ1Zy5jIHwgNTIgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCA1MCBpbnNlcnRpb25zKCspLCAyIGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvY2lmc19kZWJ1Zy5jIGIvZnMvc21i
L2NsaWVudC9jaWZzX2RlYnVnLmMKaW5kZXggYjI3OWY3NDU0NjZlLi4wNzljMWRmMDkxNzIgMTAw
NjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvY2lmc19kZWJ1Zy5jCisrKyBiL2ZzL3NtYi9jbGllbnQv
Y2lmc19kZWJ1Zy5jCkBAIC0xMyw2ICsxMyw3IEBACiAjaW5jbHVkZSA8bGludXgvcHJvY19mcy5o
PgogI2luY2x1ZGUgPGxpbnV4L3VhY2Nlc3MuaD4KICNpbmNsdWRlIDx1YXBpL2xpbnV4L2V0aHRv
b2wuaD4KKyNpbmNsdWRlIDxuZXQvaW5ldF9zb2NrLmg+CiAjaW5jbHVkZSAiY2lmc3BkdS5oIgog
I2luY2x1ZGUgImNpZnNnbG9iLmgiCiAjaW5jbHVkZSAiY2lmc3Byb3RvLmgiCkBAIC0xNDcsNiAr
MTQ4LDIyIEBAIGNpZnNfZHVtcF9jaGFubmVsKHN0cnVjdCBzZXFfZmlsZSAqbSwgaW50IGksIHN0
cnVjdCBjaWZzX2NoYW4gKmNoYW4pCiAJCSAgIGluX2ZsaWdodChzZXJ2ZXIpLAogCQkgICBhdG9t
aWNfcmVhZCgmc2VydmVyLT5pbl9zZW5kKSwKIAkJICAgYXRvbWljX3JlYWQoJnNlcnZlci0+bnVt
X3dhaXRlcnMpKTsKKworI2lmbmRlZiBDT05GSUdfQ0lGU19TTUJfRElSRUNUCisJaWYgKHNlcnZl
ci0+c3NvY2tldCkgeworCQlzdHJ1Y3Qgc29ja2FkZHIgc3JjOworCQlpbnQgYWRkcmxlbjsKKwor
CQlhZGRybGVuID0ga2VybmVsX2dldHNvY2tuYW1lKHNlcnZlci0+c3NvY2tldCwgJnNyYyk7CisJ
CWlmIChhZGRybGVuICE9IHNpemVvZihzdHJ1Y3Qgc29ja2FkZHJfaW4pICYmIGFkZHJsZW4gIT0g
c2l6ZW9mKHN0cnVjdCBzb2NrYWRkcl9pbjYpKQorCQkJZ290byBza2lwX2FkZHJfZGV0YWlsczsK
KworCQlzZXFfcHJpbnRmKG0sICJcblx0XHRJUCBhZGRyOiBkc3Q6ICVwSVNwYywgc3JjOiAlcElT
cGMiLCAmc2VydmVyLT5kc3RhZGRyLCAmc3JjKTsKKwl9CisKK3NraXBfYWRkcl9kZXRhaWxzOgor
I2VuZGlmCisKIH0KIAogc3RhdGljIGlubGluZSBjb25zdCBjaGFyICpzbWJfc3BlZWRfdG9fc3Ry
KHNpemVfdCBicHMpCkBAIC0yNjMsNyArMjgwLDcgQEAgc3RhdGljIGludCBjaWZzX2RlYnVnX2Zp
bGVzX3Byb2Nfc2hvdyhzdHJ1Y3Qgc2VxX2ZpbGUgKm0sIHZvaWQgKnYpCiBzdGF0aWMgaW50IGNp
ZnNfZGVidWdfZGF0YV9wcm9jX3Nob3coc3RydWN0IHNlcV9maWxlICptLCB2b2lkICp2KQogewog
CXN0cnVjdCBtaWRfcV9lbnRyeSAqbWlkX2VudHJ5OwotCXN0cnVjdCBUQ1BfU2VydmVyX0luZm8g
KnNlcnZlcjsKKwlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsICpuc2VydmVyOwogCXN0
cnVjdCBUQ1BfU2VydmVyX0luZm8gKmNoYW5fc2VydmVyOwogCXN0cnVjdCBjaWZzX3NlcyAqc2Vz
OwogCXN0cnVjdCBjaWZzX3Rjb24gKnRjb247CkBAIC0zMTgsNyArMzM1LDcgQEAgc3RhdGljIGlu
dCBjaWZzX2RlYnVnX2RhdGFfcHJvY19zaG93KHN0cnVjdCBzZXFfZmlsZSAqbSwgdm9pZCAqdikK
IAogCWMgPSAwOwogCXNwaW5fbG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOwotCWxpc3RfZm9yX2Vh
Y2hfZW50cnkoc2VydmVyLCAmY2lmc190Y3Bfc2VzX2xpc3QsIHRjcF9zZXNfbGlzdCkgeworCWxp
c3RfZm9yX2VhY2hfZW50cnlfc2FmZShzZXJ2ZXIsIG5zZXJ2ZXIsICZjaWZzX3RjcF9zZXNfbGlz
dCwgdGNwX3Nlc19saXN0KSB7CiAJCS8qIGNoYW5uZWwgaW5mbyB3aWxsIGJlIHByaW50ZWQgYXMg
YSBwYXJ0IG9mIHNlc3Npb25zIGJlbG93ICovCiAJCWlmIChDSUZTX1NFUlZFUl9JU19DSEFOKHNl
cnZlcikpCiAJCQljb250aW51ZTsKQEAgLTM5Niw2ICs0MTMsMjYgQEAgc3RhdGljIGludCBjaWZz
X2RlYnVnX2RhdGFfcHJvY19zaG93KHN0cnVjdCBzZXFfZmlsZSAqbSwgdm9pZCAqdikKIAkJCWF0
b21pY19yZWFkKCZzZXJ2ZXItPnNtYmRfY29ubi0+bXJfcmVhZHlfY291bnQpLAogCQkJYXRvbWlj
X3JlYWQoJnNlcnZlci0+c21iZF9jb25uLT5tcl91c2VkX2NvdW50KSk7CiBza2lwX3JkbWE6Cisj
ZWxzZQorCQlpZiAoc2VydmVyLT5zc29ja2V0KSB7CisJCQlzdHJ1Y3Qgc29ja2FkZHIgc3JjOwor
CQkJaW50IGFkZHJsZW47CisKKwkJCS8qIGtlcm5lbF9nZXRzb2NrbmFtZSBjYW4gYmxvY2suIHNv
IGRyb3AgdGhlIGxvY2sgZmlyc3QgKi8KKwkJCXNlcnZlci0+c3J2X2NvdW50Kys7CisJCQlzcGlu
X3VubG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOworCisJCQlhZGRybGVuID0ga2VybmVsX2dldHNv
Y2tuYW1lKHNlcnZlci0+c3NvY2tldCwgJnNyYyk7CisJCQlpZiAoYWRkcmxlbiAhPSBzaXplb2Yo
c3RydWN0IHNvY2thZGRyX2luKSAmJiBhZGRybGVuICE9IHNpemVvZihzdHJ1Y3Qgc29ja2FkZHJf
aW42KSkKKwkJCQlnb3RvIHNraXBfYWRkcl9kZXRhaWxzOworCisJCQlzZXFfcHJpbnRmKG0sICJc
bklQIGFkZHI6IGRzdDogJXBJU3BjLCBzcmM6ICVwSVNwYyIsICZzZXJ2ZXItPmRzdGFkZHIsICZz
cmMpOworCisJCQljaWZzX3B1dF90Y3Bfc2Vzc2lvbihzZXJ2ZXIsIDApOworCQkJc3Bpbl9sb2Nr
KCZjaWZzX3RjcF9zZXNfbG9jayk7CisJCX0KKworc2tpcF9hZGRyX2RldGFpbHM6CiAjZW5kaWYK
IAkJc2VxX3ByaW50ZihtLCAiXG5OdW1iZXIgb2YgY3JlZGl0czogJWQsJWQsJWQgRGlhbGVjdCAw
eCV4IiwKIAkJCXNlcnZlci0+Y3JlZGl0cywKQEAgLTQ5Myw3ICs1MzAsMTggQEAgc3RhdGljIGlu
dCBjaWZzX2RlYnVnX2RhdGFfcHJvY19zaG93KHN0cnVjdCBzZXFfZmlsZSAqbSwgdm9pZCAqdikK
IAkJCQlzZXFfcHJpbnRmKG0sICJcblxuXHRFeHRyYSBDaGFubmVsczogJXp1ICIsCiAJCQkJCSAg
IHNlcy0+Y2hhbl9jb3VudC0xKTsKIAkJCQlmb3IgKGogPSAxOyBqIDwgc2VzLT5jaGFuX2NvdW50
OyBqKyspIHsKKwkJCQkJLyoKKwkJCQkJICoga2VybmVsX2dldHNvY2tuYW1lIGNhbiBibG9jayBp
bnNpZGUKKwkJCQkJICogY2lmc19kdW1wX2NoYW5uZWwuIHNvIGRyb3AgdGhlIGxvY2sgZmlyc3QK
KwkJCQkJICovCisJCQkJCXNlcnZlci0+c3J2X2NvdW50Kys7CisJCQkJCXNwaW5fdW5sb2NrKCZj
aWZzX3RjcF9zZXNfbG9jayk7CisKIAkJCQkJY2lmc19kdW1wX2NoYW5uZWwobSwgaiwgJnNlcy0+
Y2hhbnNbal0pOworCisJCQkJCWNpZnNfcHV0X3RjcF9zZXNzaW9uKHNlcnZlciwgMCk7CisJCQkJ
CXNwaW5fbG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOworCiAJCQkJCWlmIChDSUZTX0NIQU5fTkVF
RFNfUkVDT05ORUNUKHNlcywgaikpCiAJCQkJCQlzZXFfcHV0cyhtLCAiXHRESVNDT05ORUNURUQg
Iik7CiAJCQkJCWlmIChDSUZTX0NIQU5fSU5fUkVDT05ORUNUKHNlcywgaikpCi0tIAoyLjM0LjEK
Cg==
--000000000000c029d205fec4574e--
