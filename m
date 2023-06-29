Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1931CEB64D9
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Jun 2023 15:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjF2Pfe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Jun 2023 11:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjF2Pfd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Jun 2023 11:35:33 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6918F19BA
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jun 2023 08:35:31 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2b69ea3b29fso12598521fa.3
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jun 2023 08:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688052929; x=1690644929;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MmEOJEV70UPAzuqfN01h3DL259+DhyUe1RfX7LhWfMk=;
        b=l/jPf125+LbzSG5RbHlG3eTWRG03Vlb6qKnovT/Gd5q/RX1rude77h1IB8H3tNad7T
         DM3VP5Qrw1DDTMJg+xYDmQGY0xNWedd8BhKfYy3pGEY0Qah9C9F08ZwXmwbmMZ2cwXSp
         DZTiyhZB/39cpTs5iLFodqONYVSK9Ueq9gPsVOtv+p3FWvWWcEG2e2MYx3F0BXtp03y6
         Jy/WKKmZFVEdmpa4JU2Vgd86tuuPrTavcdQ2OVzKNHH9znHb0yo7mRcceoNSRVcfjg2g
         gs4fBYs9cYXGNTD9bSttAo/eii51cMj1r5Nbrxj1IEzv6MHWOSXnl3ByaIik+NS+4sYI
         MYeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688052929; x=1690644929;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MmEOJEV70UPAzuqfN01h3DL259+DhyUe1RfX7LhWfMk=;
        b=K0bZzkYniwHPjX1UCH2/+yZvP7T+HiiezD0tGeN+x/heN9l+bKxC/aQs5OKEh/TxBV
         6Y2NyXjAViO4RLpYTqTTjLgQ/9srLUOCagWCDZ+986tZvRkO/bGMTRudQzZjCBToFBhw
         OxLN0TEQobfZEbQL9B8cZ2WFWW5zCUChFc6WAoHMqP/zp32/bp0r7LsGuD/HdlSWKSrI
         atT00ui47ZdhoMHaoXxXxa1tHvhFvtPcEH/OTYSvqtS/0yEEmXt6/BaD7UgsuAxjisId
         uAleGgEZ/NWyuHNTnKdNFSOeWBGLL5CeKX9rE8x9jrL9OuquY7hF5EIgN0ae3jXJOltE
         Q7hw==
X-Gm-Message-State: ABy/qLawzg5tDboT4ZyVLRXBdmX0ZHsOxtQPFeLvLUwemmsNDrlkW6BX
        3SWAYIUwoVg/zhRQd2DXT0EV6WimC1gpqrnYWV4=
X-Google-Smtp-Source: APBJJlGyUT0DRre32Gc5C3G+L5y6ISuXg6OW37MeL/yI2onHFlKeea5X9U+KcknViexsv6XuSjVgIGQiQ4yyMCUxjow=
X-Received: by 2002:a2e:88ca:0:b0:2b5:7b4a:cf8f with SMTP id
 a10-20020a2e88ca000000b002b57b4acf8fmr100699ljk.10.1688052929095; Thu, 29 Jun
 2023 08:35:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230609174659.60327-1-sprasad@microsoft.com> <20230609174659.60327-4-sprasad@microsoft.com>
 <nlpmf2nsqosbz5ifzycdpoqmi22tkcoouuk4pjsp4exa2jtyqm@wzdmdh625e5p>
 <CANT5p=oGXceYkn=+7KjbN=9oC14S0ue16LAPB_56hyX588iOXw@mail.gmail.com>
 <CANT5p=rPRPVaRe2S4j=OqJTbOhs9onqR2ZNTMPNE1L_71aNQbw@mail.gmail.com>
 <a38028f0fbc7d6abb1f118f110537f21.pc@manguebit.com> <g6yidp2mk3sseniwodvdz6d3svgq2kt6jzsbuiuh4gb2zmj3g3@yl6cqh37q7bx>
 <CANT5p=qPivH8p+_SXMN0phKPTKqkSoEHdc+omhvM10YckbSvFw@mail.gmail.com>
 <1ca61d08-6e34-48aa-62b2-e246a5bb3ef2@talpey.com> <CANT5p=pW-O7UQgfRKR6XpFnnFka9PVQQ0y1YtOz+DcaQt9yH3Q@mail.gmail.com>
 <CANT5p=qdS6FFj9ay3bDiP+mWnU1b-NJp2TLb0YdAFyvkqZcKFw@mail.gmail.com> <CAH2r5mvweFgQeZJsprx372ae9d8KLcmBiGawnHKhWO=74B6VMQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvweFgQeZJsprx372ae9d8KLcmBiGawnHKhWO=74B6VMQ@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 29 Jun 2023 21:05:17 +0530
Message-ID: <CANT5p=rg7Q-z=9LSRjMvkBHkYk4X2t0eQCT04+myYgdGZeJP8w@mail.gmail.com>
Subject: Re: [PATCH 4/6] cifs: display the endpoint IP details in DebugData
To:     Steve French <smfrench@gmail.com>
Cc:     Tom Talpey <tom@talpey.com>, Enzo Matsumiya <ematsumiya@suse.de>,
        Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org,
        pc@cjr.nz, bharathsm.hsk@gmail.com,
        Shyam Prasad N <sprasad@microsoft.com>
Content-Type: multipart/mixed; boundary="000000000000337f3f05ff4673b8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000337f3f05ff4673b8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 28, 2023 at 10:41=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> also removed an extra colon in two places (IP addr dst: ..." then
> "src:" already had the colon so didn't need "IP addr: dst: ..."
>
> On Wed, Jun 28, 2023 at 5:20=E2=80=AFAM Shyam Prasad N <nspmangalore@gmai=
l.com> wrote:
> >
> > On Tue, Jun 27, 2023 at 5:47=E2=80=AFPM Shyam Prasad N <nspmangalore@gm=
ail.com> wrote:
> > >
> > > On Fri, Jun 23, 2023 at 9:24=E2=80=AFPM Tom Talpey <tom@talpey.com> w=
rote:
> > > >
> > > > On 6/23/2023 12:21 AM, Shyam Prasad N wrote:
> > > > > On Mon, Jun 12, 2023 at 8:59=E2=80=AFPM Enzo Matsumiya <ematsumiy=
a@suse.de> wrote:
> > > > >>
> > > > >> On 06/12, Paulo Alcantara wrote:
> > > > >>> Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > > >>>
> > > > >>>> I had to use kernel_getsockname to get socket source details, =
not
> > > > >>>> kernel_getpeername.
> > > > >>>
> > > > >>> Why can't you use @server->srcaddr directly?
> > > > >>
> > > > >> That's only filled if explicitly passed through srcaddr=3D mount=
 option
> > > > >> (to bind it later in bind_socket()).
> > > > >>
> > > > >> Otherwise, it stays zeroed through @server's lifetime.
> > > > >
> > > > > Yes. As Enzo mentioned, srcaddr is only useful if the user gave t=
hat
> > > > > mount option.
> > > > >
> > > > > Also, here's an updated version of the patch.
> > > > > kernel_getsockname seems to be a blocking function, and we need t=
o
> > > > > drop the spinlock before calling it.
> > > >
> > > > Why does this not do anything to report RDMA endpoint addresses/por=
ts?
> > > > Many RDMA protocols employ IP addressing.
> > > >
> > > > If it's intended to not report such information, there should be so=
me
> > > > string emitted to make it clear that this is TCP-specific. But let'=
s
> > > > not be lazy here, the smbd_connection stores the rdma_cm_id which
> > > > holds similar information (the "rdma_addr").
> > > >
> > > > Tom.
> > >
> > > Hi Tom,
> > >
> > > As always, thanks for reviewing.
> > > My understanding of RDMA is very limited. That's the only reason why
> > > my patch did not contain changes for RDMA.
> > > Let me dig around to understand what needs to be done here.
> > >
> > > --
> > > Regards,
> > > Shyam
> >
> > Here's a version of the patch with changes for RDMA as well.
> > But I don't know how to test this, as I do not have a setup with RDMA.
> > @Tom Talpey Can you please review and test out this patch?
> >
> > --
> > Regards,
> > Shyam
>
>
>
> --
> Thanks,
>
> Steve

Here's the updated patch with the correct fixes to the problems
suggested by the bot. And also a correction in refcount drop.

--=20
Regards,
Shyam

--000000000000337f3f05ff4673b8
Content-Type: application/octet-stream; 
	name="0001-cifs-display-the-endpoint-IP-details-in-DebugData.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-display-the-endpoint-IP-details-in-DebugData.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ljhb4clm0>
X-Attachment-Id: f_ljhb4clm0

RnJvbSAyNWJiYmRlN2YwZWFiN2RjYmRiMjg0NDk0YTU5M2NlMTE1OGEzMDExIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBGcmksIDkgSnVuIDIwMjMgMTI6NDY6MzQgKzAwMDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBkaXNwbGF5IHRoZSBlbmRwb2ludCBJUCBkZXRhaWxzIGluIERlYnVnRGF0YQoKV2l0aCBt
dWx0aWNoYW5uZWwsIGl0IGlzIHVzZWZ1bCB0byBrbm93IHRoZSBzcmMgcG9ydCBkZXRhaWxzCmZv
ciBlYWNoIGNoYW5uZWwuIFRoaXMgY2hhbmdlIHdpbGwgcHJpbnQgdGhlIGlwIGFkZHIgYW5kCnBv
cnQgZGV0YWlscyBmb3IgYm90aCB0aGUgc29ja2V0IGRlc3QgYW5kIHNyYyBlbmRwb2ludHMuCgpT
aWduZWQtb2ZmLWJ5OiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPgotLS0K
IGZzL3NtYi9jbGllbnQvY2lmc19kZWJ1Zy5jIHwgNzQgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCA3MiBpbnNlcnRpb25zKCspLCAyIGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvY2lmc19kZWJ1Zy5jIGIvZnMvc21i
L2NsaWVudC9jaWZzX2RlYnVnLmMKaW5kZXggYmZhODk1MDU0N2UyLi5lN2JhY2E0MTA5ODggMTAw
NjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvY2lmc19kZWJ1Zy5jCisrKyBiL2ZzL3NtYi9jbGllbnQv
Y2lmc19kZWJ1Zy5jCkBAIC0xMyw2ICsxMyw3IEBACiAjaW5jbHVkZSA8bGludXgvcHJvY19mcy5o
PgogI2luY2x1ZGUgPGxpbnV4L3VhY2Nlc3MuaD4KICNpbmNsdWRlIDx1YXBpL2xpbnV4L2V0aHRv
b2wuaD4KKyNpbmNsdWRlIDxuZXQvaW5ldF9zb2NrLmg+CiAjaW5jbHVkZSAiY2lmc3BkdS5oIgog
I2luY2x1ZGUgImNpZnNnbG9iLmgiCiAjaW5jbHVkZSAiY2lmc3Byb3RvLmgiCkBAIC0xNDcsNiAr
MTQ4LDMzIEBAIGNpZnNfZHVtcF9jaGFubmVsKHN0cnVjdCBzZXFfZmlsZSAqbSwgaW50IGksIHN0
cnVjdCBjaWZzX2NoYW4gKmNoYW4pCiAJCSAgIGluX2ZsaWdodChzZXJ2ZXIpLAogCQkgICBhdG9t
aWNfcmVhZCgmc2VydmVyLT5pbl9zZW5kKSwKIAkJICAgYXRvbWljX3JlYWQoJnNlcnZlci0+bnVt
X3dhaXRlcnMpKTsKKworI2lmZGVmIENPTkZJR19DSUZTX1NNQl9ESVJFQ1QKKwlpZiAoIXNlcnZl
ci0+cmRtYSkKKwkJZ290byBza2lwX3JkbWE7CisKKwlpZiAoc2VydmVyLT5zbWJkX2Nvbm4gJiYg
c2VydmVyLT5zbWJkX2Nvbm4tPmlkKSB7CisJCXN0cnVjdCByZG1hX2FkZHIgKmFkZHIgPQorCQkJ
JnNlcnZlci0+c21iZF9jb25uLT5pZC0+cm91dGUuYWRkcjsKKwkJc2VxX3ByaW50ZihtLCAiXG5c
dFx0SVAgYWRkcjogZHN0OiAlcElTcGMsIHNyYzogJXBJU3BjIiwKKwkJCSAgICZhZGRyLT5kc3Rf
YWRkciwgJmFkZHItPnNyY19hZGRyKTsKKwl9CisKK3NraXBfcmRtYToKKyNlbmRpZgorCWlmIChz
ZXJ2ZXItPnNzb2NrZXQpIHsKKwkJc3RydWN0IHNvY2thZGRyIHNyYzsKKwkJaW50IGFkZHJsZW47
CisKKwkJYWRkcmxlbiA9IGtlcm5lbF9nZXRzb2NrbmFtZShzZXJ2ZXItPnNzb2NrZXQsICZzcmMp
OworCQlpZiAoYWRkcmxlbiAhPSBzaXplb2Yoc3RydWN0IHNvY2thZGRyX2luKSAmJgorCQkgICAg
YWRkcmxlbiAhPSBzaXplb2Yoc3RydWN0IHNvY2thZGRyX2luNikpCisJCQlyZXR1cm47CisKKwkJ
c2VxX3ByaW50ZihtLCAiXG5cdFx0SVAgYWRkcjogZHN0OiAlcElTcGMsIHNyYzogJXBJU3BjIiwK
KwkJCSAgICZzZXJ2ZXItPmRzdGFkZHIsICZzcmMpOworCX0KKwogfQogCiBzdGF0aWMgaW5saW5l
IGNvbnN0IGNoYXIgKnNtYl9zcGVlZF90b19zdHIoc2l6ZV90IGJwcykKQEAgLTI2Myw3ICsyOTEs
NyBAQCBzdGF0aWMgaW50IGNpZnNfZGVidWdfZmlsZXNfcHJvY19zaG93KHN0cnVjdCBzZXFfZmls
ZSAqbSwgdm9pZCAqdikKIHN0YXRpYyBpbnQgY2lmc19kZWJ1Z19kYXRhX3Byb2Nfc2hvdyhzdHJ1
Y3Qgc2VxX2ZpbGUgKm0sIHZvaWQgKnYpCiB7CiAJc3RydWN0IG1pZF9xX2VudHJ5ICptaWRfZW50
cnk7Ci0Jc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyOworCXN0cnVjdCBUQ1BfU2VydmVy
X0luZm8gKnNlcnZlciwgKm5zZXJ2ZXI7CiAJc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqY2hhbl9z
ZXJ2ZXI7CiAJc3RydWN0IGNpZnNfc2VzICpzZXM7CiAJc3RydWN0IGNpZnNfdGNvbiAqdGNvbjsK
QEAgLTMxOCw3ICszNDYsNyBAQCBzdGF0aWMgaW50IGNpZnNfZGVidWdfZGF0YV9wcm9jX3Nob3co
c3RydWN0IHNlcV9maWxlICptLCB2b2lkICp2KQogCiAJYyA9IDA7CiAJc3Bpbl9sb2NrKCZjaWZz
X3RjcF9zZXNfbG9jayk7Ci0JbGlzdF9mb3JfZWFjaF9lbnRyeShzZXJ2ZXIsICZjaWZzX3RjcF9z
ZXNfbGlzdCwgdGNwX3Nlc19saXN0KSB7CisJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKHNlcnZl
ciwgbnNlcnZlciwgJmNpZnNfdGNwX3Nlc19saXN0LCB0Y3Bfc2VzX2xpc3QpIHsKIAkJLyogY2hh
bm5lbCBpbmZvIHdpbGwgYmUgcHJpbnRlZCBhcyBhIHBhcnQgb2Ygc2Vzc2lvbnMgYmVsb3cgKi8K
IAkJaWYgKENJRlNfU0VSVkVSX0lTX0NIQU4oc2VydmVyKSkKIAkJCWNvbnRpbnVlOwpAQCAtMzk2
LDggKzQyNCwzOSBAQCBzdGF0aWMgaW50IGNpZnNfZGVidWdfZGF0YV9wcm9jX3Nob3coc3RydWN0
IHNlcV9maWxlICptLCB2b2lkICp2KQogCQlzZXFfcHJpbnRmKG0sICJcbk1SIG1yX3JlYWR5X2Nv
dW50OiAleCBtcl91c2VkX2NvdW50OiAleCIsCiAJCQlhdG9taWNfcmVhZCgmc2VydmVyLT5zbWJk
X2Nvbm4tPm1yX3JlYWR5X2NvdW50KSwKIAkJCWF0b21pY19yZWFkKCZzZXJ2ZXItPnNtYmRfY29u
bi0+bXJfdXNlZF9jb3VudCkpOworCQlpZiAoc2VydmVyLT5zbWJkX2Nvbm4tPmlkKSB7CisJCQlz
dHJ1Y3QgcmRtYV9hZGRyICphZGRyID0KKwkJCQkmc2VydmVyLT5zbWJkX2Nvbm4tPmlkLT5yb3V0
ZS5hZGRyOworCQkJc2VxX3ByaW50ZihtLCAiXG5JUCBhZGRyOiBkc3Q6ICVwSVNwYywgc3JjOiAl
cElTcGMiLAorCQkJCSAgICZhZGRyLT5kc3RfYWRkciwgJmFkZHItPnNyY19hZGRyKTsKKwkJfQog
c2tpcF9yZG1hOgogI2VuZGlmCisJCWlmIChzZXJ2ZXItPnNzb2NrZXQpIHsKKwkJCXN0cnVjdCBz
b2NrYWRkciBzcmM7CisJCQlpbnQgYWRkcmxlbjsKKworCQkJLyoga2VybmVsX2dldHNvY2tuYW1l
IGNhbiBibG9jay4gc28gZHJvcCB0aGUgbG9jayBmaXJzdCAqLworCQkJc2VydmVyLT5zcnZfY291
bnQrKzsKKwkJCXNwaW5fdW5sb2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7CisKKwkJCWFkZHJsZW4g
PSBrZXJuZWxfZ2V0c29ja25hbWUoc2VydmVyLT5zc29ja2V0LCAmc3JjKTsKKwkJCWlmIChhZGRy
bGVuICE9IHNpemVvZihzdHJ1Y3Qgc29ja2FkZHJfaW4pICYmCisJCQkgICAgYWRkcmxlbiAhPSBz
aXplb2Yoc3RydWN0IHNvY2thZGRyX2luNikpIHsKKwkJCQljaWZzX3B1dF90Y3Bfc2Vzc2lvbihz
ZXJ2ZXIsIDApOworCQkJCXNwaW5fbG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOworCisJCQkJZ290
byBza2lwX2FkZHJfZGV0YWlsczsKKwkJCX0KKworCQkJc2VxX3ByaW50ZihtLCAiXG5JUCBhZGRy
OiBkc3Q6ICVwSVNwYywgc3JjOiAlcElTcGMiLAorCQkJCSAgICZzZXJ2ZXItPmRzdGFkZHIsICZz
cmMpOworCisJCQljaWZzX3B1dF90Y3Bfc2Vzc2lvbihzZXJ2ZXIsIDApOworCQkJc3Bpbl9sb2Nr
KCZjaWZzX3RjcF9zZXNfbG9jayk7CisJCX0KKworc2tpcF9hZGRyX2RldGFpbHM6CiAJCXNlcV9w
cmludGYobSwgIlxuTnVtYmVyIG9mIGNyZWRpdHM6ICVkLCVkLCVkIERpYWxlY3QgMHgleCIsCiAJ
CQlzZXJ2ZXItPmNyZWRpdHMsCiAJCQlzZXJ2ZXItPmVjaG9fY3JlZGl0cywKQEAgLTQ5NCw3ICs1
NTMsMTggQEAgc3RhdGljIGludCBjaWZzX2RlYnVnX2RhdGFfcHJvY19zaG93KHN0cnVjdCBzZXFf
ZmlsZSAqbSwgdm9pZCAqdikKIAkJCQlzZXFfcHJpbnRmKG0sICJcblxuXHRFeHRyYSBDaGFubmVs
czogJXp1ICIsCiAJCQkJCSAgIHNlcy0+Y2hhbl9jb3VudC0xKTsKIAkJCQlmb3IgKGogPSAxOyBq
IDwgc2VzLT5jaGFuX2NvdW50OyBqKyspIHsKKwkJCQkJLyoKKwkJCQkJICoga2VybmVsX2dldHNv
Y2tuYW1lIGNhbiBibG9jayBpbnNpZGUKKwkJCQkJICogY2lmc19kdW1wX2NoYW5uZWwuIHNvIGRy
b3AgdGhlIGxvY2sgZmlyc3QKKwkJCQkJICovCisJCQkJCXNlcnZlci0+c3J2X2NvdW50Kys7CisJ
CQkJCXNwaW5fdW5sb2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7CisKIAkJCQkJY2lmc19kdW1wX2No
YW5uZWwobSwgaiwgJnNlcy0+Y2hhbnNbal0pOworCisJCQkJCWNpZnNfcHV0X3RjcF9zZXNzaW9u
KHNlcnZlciwgMCk7CisJCQkJCXNwaW5fbG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOworCiAJCQkJ
CWlmIChDSUZTX0NIQU5fTkVFRFNfUkVDT05ORUNUKHNlcywgaikpCiAJCQkJCQlzZXFfcHV0cyht
LCAiXHRESVNDT05ORUNURUQgIik7CiAJCQkJCWlmIChDSUZTX0NIQU5fSU5fUkVDT05ORUNUKHNl
cywgaikpCi0tIAoyLjM0LjEKCg==
--000000000000337f3f05ff4673b8--
