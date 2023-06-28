Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BC6EB64D7
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Jun 2023 10:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjF1KWi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Jun 2023 06:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbjF1KUh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Jun 2023 06:20:37 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8810FE7E
        for <linux-cifs@vger.kernel.org>; Wed, 28 Jun 2023 03:20:35 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4fb7b2e3dacso4482356e87.0
        for <linux-cifs@vger.kernel.org>; Wed, 28 Jun 2023 03:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687947634; x=1690539634;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8yAYMkhPDVHwZm1SzWnuEFA0EiRDZAwMJiUo4ewVzP4=;
        b=RIyEL9L01EiV1gPMSTzvD37/oSWDWzM9eJ1IbLtXKpUvKjWrhPr0ALeyJCJyT5+ZPS
         y4LiNfACH7aVsTaoMeNMaXCj0cScdwthZVqKIrY0ZvPgX0wUf48phZtcgpFkA0+hEwuN
         rLe+6Ny4Www4evn0bVG2+IxoU/rifCMdw+HX94ALoF8dolzIEJl0XpevyAvl1Nu3WUqW
         AfoOdG5Eze1//WG4DnGI5IqRpfT+0328TsAMJAHlMYz9tcwJUi+acqYDDqrWh2zVGAzq
         RlJMVRriitqHui9QH2jM5RVfG1B3OmRTQKMz6UbsBW2x7VaB4/Qf94xYUX2WLCE/ZFpc
         YfCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687947634; x=1690539634;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8yAYMkhPDVHwZm1SzWnuEFA0EiRDZAwMJiUo4ewVzP4=;
        b=au1bC6OJ3BjlKIGmP3a3dyOnAk/1WgTPOUiWw/OOwv6jxc7YX+r08eRA8b/PADMx7c
         /10ROdbTXplGdTlFb1xSVcYYe076zuYDjwmRMGAnLNtJdujlI5nsBT/lnFHMWnmzVk1D
         //ozsdb+8hSdjtssFlUS8zjCYrRzary0Bg4RF1aD4RynzqrNx2+5wjuXjDLPl50AQgNj
         kUetxArauuzTfw/dahntWOq4OFfEnXHn257zFxL/uZ7XiC6eB//lM+o8ly9Vq+JaluIa
         Wbtqejz3eygOEsCd/4HXLunhIzL5oLIGq5Cj0wIoXoKgt1MSQQxGBDZ5mQ8Lh2PK1LoI
         2CUA==
X-Gm-Message-State: AC+VfDzndt3JEoOtfX8szBucJFOtMfYIq8Yj5WUByhGHAm3xmiGABvpg
        Gc3wyX5vnmwOEthegzYAOesk33FM3BkbYSXld7t59lrH4DkDiA==
X-Google-Smtp-Source: ACHHUZ7H0t38eM7C31hMb+RyGWjLAzAaneMkk6IZNT44GU66qNLzXbC7bBF38cRxP0DOLTXdtSgQBhr9kJqP+TPLbP4=
X-Received: by 2002:a19:8c0d:0:b0:4f8:5696:6bbc with SMTP id
 o13-20020a198c0d000000b004f856966bbcmr20435193lfd.29.1687947633401; Wed, 28
 Jun 2023 03:20:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230609174659.60327-1-sprasad@microsoft.com> <20230609174659.60327-4-sprasad@microsoft.com>
 <nlpmf2nsqosbz5ifzycdpoqmi22tkcoouuk4pjsp4exa2jtyqm@wzdmdh625e5p>
 <CANT5p=oGXceYkn=+7KjbN=9oC14S0ue16LAPB_56hyX588iOXw@mail.gmail.com>
 <CANT5p=rPRPVaRe2S4j=OqJTbOhs9onqR2ZNTMPNE1L_71aNQbw@mail.gmail.com>
 <a38028f0fbc7d6abb1f118f110537f21.pc@manguebit.com> <g6yidp2mk3sseniwodvdz6d3svgq2kt6jzsbuiuh4gb2zmj3g3@yl6cqh37q7bx>
 <CANT5p=qPivH8p+_SXMN0phKPTKqkSoEHdc+omhvM10YckbSvFw@mail.gmail.com>
 <1ca61d08-6e34-48aa-62b2-e246a5bb3ef2@talpey.com> <CANT5p=pW-O7UQgfRKR6XpFnnFka9PVQQ0y1YtOz+DcaQt9yH3Q@mail.gmail.com>
In-Reply-To: <CANT5p=pW-O7UQgfRKR6XpFnnFka9PVQQ0y1YtOz+DcaQt9yH3Q@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 28 Jun 2023 15:50:22 +0530
Message-ID: <CANT5p=qdS6FFj9ay3bDiP+mWnU1b-NJp2TLb0YdAFyvkqZcKFw@mail.gmail.com>
Subject: Re: [PATCH 4/6] cifs: display the endpoint IP details in DebugData
To:     Tom Talpey <tom@talpey.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com, pc@cjr.nz, bharathsm.hsk@gmail.com,
        Shyam Prasad N <sprasad@microsoft.com>
Content-Type: multipart/mixed; boundary="00000000000016b8c205ff2def5f"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000016b8c205ff2def5f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 27, 2023 at 5:47=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Fri, Jun 23, 2023 at 9:24=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote=
:
> >
> > On 6/23/2023 12:21 AM, Shyam Prasad N wrote:
> > > On Mon, Jun 12, 2023 at 8:59=E2=80=AFPM Enzo Matsumiya <ematsumiya@su=
se.de> wrote:
> > >>
> > >> On 06/12, Paulo Alcantara wrote:
> > >>> Shyam Prasad N <nspmangalore@gmail.com> writes:
> > >>>
> > >>>> I had to use kernel_getsockname to get socket source details, not
> > >>>> kernel_getpeername.
> > >>>
> > >>> Why can't you use @server->srcaddr directly?
> > >>
> > >> That's only filled if explicitly passed through srcaddr=3D mount opt=
ion
> > >> (to bind it later in bind_socket()).
> > >>
> > >> Otherwise, it stays zeroed through @server's lifetime.
> > >
> > > Yes. As Enzo mentioned, srcaddr is only useful if the user gave that
> > > mount option.
> > >
> > > Also, here's an updated version of the patch.
> > > kernel_getsockname seems to be a blocking function, and we need to
> > > drop the spinlock before calling it.
> >
> > Why does this not do anything to report RDMA endpoint addresses/ports?
> > Many RDMA protocols employ IP addressing.
> >
> > If it's intended to not report such information, there should be some
> > string emitted to make it clear that this is TCP-specific. But let's
> > not be lazy here, the smbd_connection stores the rdma_cm_id which
> > holds similar information (the "rdma_addr").
> >
> > Tom.
>
> Hi Tom,
>
> As always, thanks for reviewing.
> My understanding of RDMA is very limited. That's the only reason why
> my patch did not contain changes for RDMA.
> Let me dig around to understand what needs to be done here.
>
> --
> Regards,
> Shyam

Here's a version of the patch with changes for RDMA as well.
But I don't know how to test this, as I do not have a setup with RDMA.
@Tom Talpey Can you please review and test out this patch?

--=20
Regards,
Shyam

--00000000000016b8c205ff2def5f
Content-Type: application/octet-stream; 
	name="0001-cifs-display-the-endpoint-IP-details-in-DebugData.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-display-the-endpoint-IP-details-in-DebugData.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ljfkfi050>
X-Attachment-Id: f_ljfkfi050

RnJvbSBhODM1Y2RhMDY5MjY4ODUzODczMDk4MjhkYmNmNWRlZjRjOTkwYTVkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBGcmksIDkgSnVuIDIwMjMgMTI6NDY6MzQgKzAwMDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBkaXNwbGF5IHRoZSBlbmRwb2ludCBJUCBkZXRhaWxzIGluIERlYnVnRGF0YQoKV2l0aCBt
dWx0aWNoYW5uZWwsIGl0IGlzIHVzZWZ1bCB0byBrbm93IHRoZSBzcmMgcG9ydCBkZXRhaWxzCmZv
ciBlYWNoIGNoYW5uZWwuIFRoaXMgY2hhbmdlIHdpbGwgcHJpbnQgdGhlIGlwIGFkZHIgYW5kCnBv
cnQgZGV0YWlscyBmb3IgYm90aCB0aGUgc29ja2V0IGRlc3QgYW5kIHNyYyBlbmRwb2ludHMuCgpT
aWduZWQtb2ZmLWJ5OiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPgotLS0K
IGZzL3NtYi9jbGllbnQvY2lmc19kZWJ1Zy5jIHwgNjggKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCA2NiBpbnNlcnRpb25zKCspLCAyIGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvY2lmc19kZWJ1Zy5jIGIvZnMvc21i
L2NsaWVudC9jaWZzX2RlYnVnLmMKaW5kZXggYmZhODk1MDU0N2UyLi45YjQ2ZWJlODE4YjIgMTAw
NjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvY2lmc19kZWJ1Zy5jCisrKyBiL2ZzL3NtYi9jbGllbnQv
Y2lmc19kZWJ1Zy5jCkBAIC0xMyw2ICsxMyw3IEBACiAjaW5jbHVkZSA8bGludXgvcHJvY19mcy5o
PgogI2luY2x1ZGUgPGxpbnV4L3VhY2Nlc3MuaD4KICNpbmNsdWRlIDx1YXBpL2xpbnV4L2V0aHRv
b2wuaD4KKyNpbmNsdWRlIDxuZXQvaW5ldF9zb2NrLmg+CiAjaW5jbHVkZSAiY2lmc3BkdS5oIgog
I2luY2x1ZGUgImNpZnNnbG9iLmgiCiAjaW5jbHVkZSAiY2lmc3Byb3RvLmgiCkBAIC0xNDcsNiAr
MTQ4LDMyIEBAIGNpZnNfZHVtcF9jaGFubmVsKHN0cnVjdCBzZXFfZmlsZSAqbSwgaW50IGksIHN0
cnVjdCBjaWZzX2NoYW4gKmNoYW4pCiAJCSAgIGluX2ZsaWdodChzZXJ2ZXIpLAogCQkgICBhdG9t
aWNfcmVhZCgmc2VydmVyLT5pbl9zZW5kKSwKIAkJICAgYXRvbWljX3JlYWQoJnNlcnZlci0+bnVt
X3dhaXRlcnMpKTsKKworI2lmZGVmIENPTkZJR19DSUZTX1NNQl9ESVJFQ1QKKwlpZiAoIXNlcnZl
ci0+cmRtYSkKKwkJZ290byBza2lwX3JkbWE7CisKKwlpZiAoc2VydmVyLT5zbWJkX2Nvbm4gJiYg
c2VydmVyLT5zbWJkX2Nvbm4tPmlkKSB7CisJCXN0cnVjdCByZG1hX2FkZHIgKmFkZHIgPQorCQkJ
JnNlcnZlci0+c21iZF9jb25uLT5pZC0+cm91dGUuYWRkcjsKKwkJc2VxX3ByaW50ZihtLCAiXG5c
dFx0SVAgYWRkcjogZHN0OiAlcElTcGMsIHNyYzogJXBJU3BjIiwKKwkJCSAgICZhZGRyLT5kc3Rf
YWRkciwgJmFkZHItPnNyY19hZGRyKTsKKwl9CisKK3NraXBfcmRtYToKKyNlbHNlCisJaWYgKHNl
cnZlci0+c3NvY2tldCkgeworCQlzdHJ1Y3Qgc29ja2FkZHIgc3JjOworCQlpbnQgYWRkcmxlbjsK
KworCQlhZGRybGVuID0ga2VybmVsX2dldHNvY2tuYW1lKHNlcnZlci0+c3NvY2tldCwgJnNyYyk7
CisJCWlmIChhZGRybGVuICE9IHNpemVvZihzdHJ1Y3Qgc29ja2FkZHJfaW4pICYmIGFkZHJsZW4g
IT0gc2l6ZW9mKHN0cnVjdCBzb2NrYWRkcl9pbjYpKQorCQkJcmV0dXJuOworCisJCXNlcV9wcmlu
dGYobSwgIlxuXHRcdElQIGFkZHI6IGRzdDogJXBJU3BjLCBzcmM6ICVwSVNwYyIsICZzZXJ2ZXIt
PmRzdGFkZHIsICZzcmMpOworCX0KKyNlbmRpZgorCiB9CiAKIHN0YXRpYyBpbmxpbmUgY29uc3Qg
Y2hhciAqc21iX3NwZWVkX3RvX3N0cihzaXplX3QgYnBzKQpAQCAtMjYzLDcgKzI5MCw3IEBAIHN0
YXRpYyBpbnQgY2lmc19kZWJ1Z19maWxlc19wcm9jX3Nob3coc3RydWN0IHNlcV9maWxlICptLCB2
b2lkICp2KQogc3RhdGljIGludCBjaWZzX2RlYnVnX2RhdGFfcHJvY19zaG93KHN0cnVjdCBzZXFf
ZmlsZSAqbSwgdm9pZCAqdikKIHsKIAlzdHJ1Y3QgbWlkX3FfZW50cnkgKm1pZF9lbnRyeTsKLQlz
dHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXI7CisJc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAq
c2VydmVyLCAqbnNlcnZlcjsKIAlzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpjaGFuX3NlcnZlcjsK
IAlzdHJ1Y3QgY2lmc19zZXMgKnNlczsKIAlzdHJ1Y3QgY2lmc190Y29uICp0Y29uOwpAQCAtMzE4
LDcgKzM0NSw3IEBAIHN0YXRpYyBpbnQgY2lmc19kZWJ1Z19kYXRhX3Byb2Nfc2hvdyhzdHJ1Y3Qg
c2VxX2ZpbGUgKm0sIHZvaWQgKnYpCiAKIAljID0gMDsKIAlzcGluX2xvY2soJmNpZnNfdGNwX3Nl
c19sb2NrKTsKLQlsaXN0X2Zvcl9lYWNoX2VudHJ5KHNlcnZlciwgJmNpZnNfdGNwX3Nlc19saXN0
LCB0Y3Bfc2VzX2xpc3QpIHsKKwlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoc2VydmVyLCBuc2Vy
dmVyLCAmY2lmc190Y3Bfc2VzX2xpc3QsIHRjcF9zZXNfbGlzdCkgewogCQkvKiBjaGFubmVsIGlu
Zm8gd2lsbCBiZSBwcmludGVkIGFzIGEgcGFydCBvZiBzZXNzaW9ucyBiZWxvdyAqLwogCQlpZiAo
Q0lGU19TRVJWRVJfSVNfQ0hBTihzZXJ2ZXIpKQogCQkJY29udGludWU7CkBAIC0zOTYsNyArNDIz
LDMzIEBAIHN0YXRpYyBpbnQgY2lmc19kZWJ1Z19kYXRhX3Byb2Nfc2hvdyhzdHJ1Y3Qgc2VxX2Zp
bGUgKm0sIHZvaWQgKnYpCiAJCXNlcV9wcmludGYobSwgIlxuTVIgbXJfcmVhZHlfY291bnQ6ICV4
IG1yX3VzZWRfY291bnQ6ICV4IiwKIAkJCWF0b21pY19yZWFkKCZzZXJ2ZXItPnNtYmRfY29ubi0+
bXJfcmVhZHlfY291bnQpLAogCQkJYXRvbWljX3JlYWQoJnNlcnZlci0+c21iZF9jb25uLT5tcl91
c2VkX2NvdW50KSk7CisJCWlmIChzZXJ2ZXItPnNtYmRfY29ubi0+aWQpIHsKKwkJCXN0cnVjdCBy
ZG1hX2FkZHIgKmFkZHIgPQorCQkJCSZzZXJ2ZXItPnNtYmRfY29ubi0+aWQtPnJvdXRlLmFkZHI7
CisJCQlzZXFfcHJpbnRmKG0sICJcbklQIGFkZHI6IGRzdDogJXBJU3BjLCBzcmM6ICVwSVNwYyIs
CisJCQkJICAgJmFkZHItPmRzdF9hZGRyLCAmYWRkci0+c3JjX2FkZHIpOworCQl9CiBza2lwX3Jk
bWE6CisjZWxzZQorCQlpZiAoc2VydmVyLT5zc29ja2V0KSB7CisJCQlzdHJ1Y3Qgc29ja2FkZHIg
c3JjOworCQkJaW50IGFkZHJsZW47CisKKwkJCS8qIGtlcm5lbF9nZXRzb2NrbmFtZSBjYW4gYmxv
Y2suIHNvIGRyb3AgdGhlIGxvY2sgZmlyc3QgKi8KKwkJCXNlcnZlci0+c3J2X2NvdW50Kys7CisJ
CQlzcGluX3VubG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOworCisJCQlhZGRybGVuID0ga2VybmVs
X2dldHNvY2tuYW1lKHNlcnZlci0+c3NvY2tldCwgJnNyYyk7CisJCQlpZiAoYWRkcmxlbiAhPSBz
aXplb2Yoc3RydWN0IHNvY2thZGRyX2luKSAmJiBhZGRybGVuICE9IHNpemVvZihzdHJ1Y3Qgc29j
a2FkZHJfaW42KSkKKwkJCQlnb3RvIHNraXBfYWRkcl9kZXRhaWxzOworCisJCQlzZXFfcHJpbnRm
KG0sICJcbklQIGFkZHI6IGRzdDogJXBJU3BjLCBzcmM6ICVwSVNwYyIsICZzZXJ2ZXItPmRzdGFk
ZHIsICZzcmMpOworCisJCQljaWZzX3B1dF90Y3Bfc2Vzc2lvbihzZXJ2ZXIsIDApOworCQkJc3Bp
bl9sb2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7CisJCX0KKworc2tpcF9hZGRyX2RldGFpbHM6CiAj
ZW5kaWYKIAkJc2VxX3ByaW50ZihtLCAiXG5OdW1iZXIgb2YgY3JlZGl0czogJWQsJWQsJWQgRGlh
bGVjdCAweCV4IiwKIAkJCXNlcnZlci0+Y3JlZGl0cywKQEAgLTQ5NCw3ICs1NDcsMTggQEAgc3Rh
dGljIGludCBjaWZzX2RlYnVnX2RhdGFfcHJvY19zaG93KHN0cnVjdCBzZXFfZmlsZSAqbSwgdm9p
ZCAqdikKIAkJCQlzZXFfcHJpbnRmKG0sICJcblxuXHRFeHRyYSBDaGFubmVsczogJXp1ICIsCiAJ
CQkJCSAgIHNlcy0+Y2hhbl9jb3VudC0xKTsKIAkJCQlmb3IgKGogPSAxOyBqIDwgc2VzLT5jaGFu
X2NvdW50OyBqKyspIHsKKwkJCQkJLyoKKwkJCQkJICoga2VybmVsX2dldHNvY2tuYW1lIGNhbiBi
bG9jayBpbnNpZGUKKwkJCQkJICogY2lmc19kdW1wX2NoYW5uZWwuIHNvIGRyb3AgdGhlIGxvY2sg
Zmlyc3QKKwkJCQkJICovCisJCQkJCXNlcnZlci0+c3J2X2NvdW50Kys7CisJCQkJCXNwaW5fdW5s
b2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7CisKIAkJCQkJY2lmc19kdW1wX2NoYW5uZWwobSwgaiwg
JnNlcy0+Y2hhbnNbal0pOworCisJCQkJCWNpZnNfcHV0X3RjcF9zZXNzaW9uKHNlcnZlciwgMCk7
CisJCQkJCXNwaW5fbG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOworCiAJCQkJCWlmIChDSUZTX0NI
QU5fTkVFRFNfUkVDT05ORUNUKHNlcywgaikpCiAJCQkJCQlzZXFfcHV0cyhtLCAiXHRESVNDT05O
RUNURUQgIik7CiAJCQkJCWlmIChDSUZTX0NIQU5fSU5fUkVDT05ORUNUKHNlcywgaikpCi0tIAoy
LjM0LjEKCg==
--00000000000016b8c205ff2def5f--
