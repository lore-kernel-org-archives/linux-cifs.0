Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6D916B72E
	for <linux-cifs@vger.kernel.org>; Thu, 11 Jul 2024 15:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720712431; cv=none; b=nqFAGqi+7KSe+2Cht6EJooXIQTA5sZQsiYUxq1++/obqnWh9aCdxBMqDtXNZ/khAYSA+8Mwmk0Y8VmhSyS5YMAk5iFYSF6qcJwDrsm0nB9C2+KP2z8ul3yrp2qId34TjVnT0zgGRxjSXxhi1GWq2HWFtRCkc5mL0VrfmvlsgOG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720712431; c=relaxed/simple;
	bh=E7C01iMUSf/KlhHI9Jn33TmjH/fcXbfTItg1oocnAkE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sBxJSDUaiDlBx4eQSHFo5KIzSpJtrjnqoI2svCVIIFNhmq01EooeX1/QPQpKpZR+I9qlgC3U2Dd8Kf+c6EB4fRO4XEjFNQolz3d0r9+TazxKeKdvG29naNX2n9JsvRtbIhJEP+wbQ0Il3rdsHIAaH87/ps0c2YNs0HMNsbDGp4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i0Ml9irD; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i0Ml9irD"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52ea2ce7abaso1857557e87.0
        for <linux-cifs@vger.kernel.org>; Thu, 11 Jul 2024 08:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720712428; x=1721317228; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=C9DBrAj0rHxRTqeEt2LhDGpKVNFnN0Gir9oIKhbF93g=;
        b=i0Ml9irD6yYEObuTwvSI5SEC6wd0E3kG6/aQx13FF6E74wXCz8QHbPGvNZeBI1UOih
         CVaH4miuqzCB8d1yCjS5oj9HZYUKjA1Q0I7xXtmXp/vwKl9fEzl4iHJBM2iU3Y4LR0hj
         h5aA3IPpn3lpMJ1dJAtK0I15jf+OnHauJ8dgSbgg/eYx/+Evoa/hPeQUvgGSEX6/+R9Y
         rlxE3V4A/VvUiKnpkfjGr27sQ5q88SyvtQ+ZTJlrxMmyR0REKzJCLUJ8++3oAWBchoeL
         mW+c6U4TfSjjzB1EoZcj2+k9VdAGpJ/p/s/MmTLiGG+ZNFVZbruJ0WyxoUd21t7bMl3R
         QoiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720712428; x=1721317228;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C9DBrAj0rHxRTqeEt2LhDGpKVNFnN0Gir9oIKhbF93g=;
        b=bogB5Nl6LJjHlTvs+g0vy2AcCIQw8MbqGYsW+1UKQs+3QEaEmSSKxjh/W2UId+SN8L
         AuEWLua/p7rseg6RO0K4O0Vk0UrKmYdJ9tUFHu4/sHBHb9GQJQ/CNCGRv408OyQPQDkW
         bYLpbsxSDNUZY8gpdR8WHePhhJbxbtPckW4mA8LyWMe63WO2mweIuAsj44jOLiAIcTA+
         EpucqS14G6KRWLD7lR0tR83H/jAxQqPDLp8eTgLtEVUpiMDUA9D6iIZsOY+gIvI5Eeh8
         pFLoRaWxVtj5X4g9SnPGO2gkxKv+5HpV8ZoWiQK9nezjHiP/o/AUk9OLTmgaGAVQrwhR
         eN/Q==
X-Gm-Message-State: AOJu0Yyl3pp0HpAq98/Qi6LnDBYSj5WacQVHycjmy/OiXWgeRPr0VVqS
	9JY8ykErNXNcSsymoNlHNugwsltAmQk9driOkpqK6NzwXSam/z/P6w5yem2QkcnlO4bYvxWIboB
	KEyOIX9hGG1D8etWlgJwQ4s2IzN3jtko5
X-Google-Smtp-Source: AGHT+IGgz9eFMCRsDmzcRU3isK7q1k/7+zpQstHSEUmxnVf930LhPJDqnYx8AykSGPO99s66YUTNhMI81W3r735zMdo=
X-Received: by 2002:a05:6512:10ce:b0:52c:842b:c276 with SMTP id
 2adb3069b0e04-52eb99d1ff7mr7218451e87.53.1720712427852; Thu, 11 Jul 2024
 08:40:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mv2V3vdupgmR75WsNGrfdbaPo0Mw+6x82KK9vgUYu5AkQ@mail.gmail.com>
In-Reply-To: <CAH2r5mv2V3vdupgmR75WsNGrfdbaPo0Mw+6x82KK9vgUYu5AkQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 11 Jul 2024 10:40:16 -0500
Message-ID: <CAH2r5msriif9aOTVa57n2PnEjUHYgpimuz7vTG8deS=KOZt3hw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix setting SecurityFlags to true
To: CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="00000000000005fbe8061cfa95a1"

--00000000000005fbe8061cfa95a1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

V2 of patch

    If you try to set /proc/fs/cifs/SecurityFlags to 1 it
    will set them to CIFSSEC_MUST_NTLMV2 which no longer is
    relevant (the less secure ones like lanman have been removed
    from cifs.ko) and is also missing some flags (like for
    signing and encryption) and can even cause mount to fail,
    so change this to set it to Kerberos in this case.

    Also change the description of the SecurityFlags to remove mention
    of flags which are no longer supported.

On Tue, Jul 9, 2024 at 6:45=E2=80=AFPM Steve French <smfrench@gmail.com> wr=
ote:
>
> If you try to set /proc/fs/cifs/SecurityFlags to 1 it
> will set them to CIFSSEC_MUST_NTLMV2 which is obsolete and no
> longer checked, and will cause mount to fail, so change this
> to set it to a more understandable default (ie include Kerberos
> as well).
>
> Also change the description of the SecurityFlags to remove mention
> of various flags which are no longer supported (due to removal
> of weak security such as lanman and ntlmv1).
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--00000000000005fbe8061cfa95a1
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-setting-SecurityFlags-to-true.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-setting-SecurityFlags-to-true.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lyhfqqx20>
X-Attachment-Id: f_lyhfqqx20

RnJvbSBlNjk2YWExYzA4NWNkZTg5YzMzZTc1OWM3ZmFkZTU5ZTgwYTdmMGNkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgOSBKdWwgMjAyNCAxODowNzozNSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IGZpeCBzZXR0aW5nIFNlY3VyaXR5RmxhZ3MgdG8gdHJ1ZQoKSWYgeW91IHRyeSB0byBzZXQg
L3Byb2MvZnMvY2lmcy9TZWN1cml0eUZsYWdzIHRvIDEgaXQKd2lsbCBzZXQgdGhlbSB0byBDSUZT
U0VDX01VU1RfTlRMTVYyIHdoaWNoIG5vIGxvbmdlciBpcwpyZWxldmFudCAodGhlIGxlc3Mgc2Vj
dXJlIG9uZXMgbGlrZSBsYW5tYW4gaGF2ZSBiZWVuIHJlbW92ZWQKZnJvbSBjaWZzLmtvKSBhbmQg
aXMgYWxzbyBtaXNzaW5nIHNvbWUgZmxhZ3MgKGxpa2UgZm9yCnNpZ25pbmcgYW5kIGVuY3J5cHRp
b24pIGFuZCBjYW4gZXZlbiBjYXVzZSBtb3VudCB0byBmYWlsLApzbyBjaGFuZ2UgdGhpcyB0byBz
ZXQgaXQgdG8gS2VyYmVyb3MgaW4gdGhpcyBjYXNlLgoKQWxzbyBjaGFuZ2UgdGhlIGRlc2NyaXB0
aW9uIG9mIHRoZSBTZWN1cml0eUZsYWdzIHRvIHJlbW92ZSBtZW50aW9uCm9mIGZsYWdzIHdoaWNo
IGFyZSBubyBsb25nZXIgc3VwcG9ydGVkLgoKQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKU2ln
bmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIERv
Y3VtZW50YXRpb24vYWRtaW4tZ3VpZGUvY2lmcy91c2FnZS5yc3QgfCAzNiArKysrKysrKy0tLS0t
LS0tLS0tLS0tLS0KIGZzL3NtYi9jbGllbnQvY2lmc2dsb2IuaCAgICAgICAgICAgICAgICAgfCAg
NCArLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgMjcgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9hZG1pbi1ndWlkZS9jaWZzL3VzYWdlLnJzdCBi
L0RvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUvY2lmcy91c2FnZS5yc3QKaW5kZXggYWE4MjkwYTI5
ZGM4Li5mZDRiNTZjMDk5NmYgMTAwNjQ0Ci0tLSBhL0RvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUv
Y2lmcy91c2FnZS5yc3QKKysrIGIvRG9jdW1lbnRhdGlvbi9hZG1pbi1ndWlkZS9jaWZzL3VzYWdl
LnJzdApAQCAtNzIzLDQwICs3MjMsMjYgQEAgQ29uZmlndXJhdGlvbiBwc2V1ZG8tZmlsZXM6CiA9
PT09PT09PT09PT09PT09PT09PT09PSA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09CiBTZWN1cml0eUZsYWdzCQlGbGFncyB3aGljaCBjb250cm9s
IHNlY3VyaXR5IG5lZ290aWF0aW9uIGFuZAogCQkJYWxzbyBwYWNrZXQgc2lnbmluZy4gQXV0aGVu
dGljYXRpb24gKG1heS9tdXN0KQotCQkJZmxhZ3MgKGUuZy4gZm9yIE5UTE0gYW5kL29yIE5UTE12
MikgbWF5IGJlIGNvbWJpbmVkIHdpdGgKKwkJCWZsYWdzIChlLmcuIGZvciBOVExNdjIpIG1heSBi
ZSBjb21iaW5lZCB3aXRoCiAJCQl0aGUgc2lnbmluZyBmbGFncy4gIFNwZWNpZnlpbmcgdHdvIGRp
ZmZlcmVudCBwYXNzd29yZAogCQkJaGFzaGluZyBtZWNoYW5pc21zIChhcyAibXVzdCB1c2UiKSBv
biB0aGUgb3RoZXIgaGFuZAogCQkJZG9lcyBub3QgbWFrZSBtdWNoIHNlbnNlLiBEZWZhdWx0IGZs
YWdzIGFyZTo6CiAKLQkJCQkweDA3MDA3Ci0KLQkJCShOVExNLCBOVExNdjIgYW5kIHBhY2tldCBz
aWduaW5nIGFsbG93ZWQpLiAgVGhlIG1heGltdW0KLQkJCWFsbG93YWJsZSBmbGFncyBpZiB5b3Ug
d2FudCB0byBhbGxvdyBtb3VudHMgdG8gc2VydmVycwotCQkJdXNpbmcgd2Vha2VyIHBhc3N3b3Jk
IGhhc2hlcyBpcyAweDM3MDM3IChsYW5tYW4sCi0JCQlwbGFpbnRleHQsIG50bG0sIG50bG12Miwg
c2lnbmluZyBhbGxvd2VkKS4gIFNvbWUKLQkJCVNlY3VyaXR5RmxhZ3MgcmVxdWlyZSB0aGUgY29y
cmVzcG9uZGluZyBtZW51Y29uZmlnCi0JCQlvcHRpb25zIHRvIGJlIGVuYWJsZWQuICBFbmFibGlu
ZyBwbGFpbnRleHQKLQkJCWF1dGhlbnRpY2F0aW9uIGN1cnJlbnRseSByZXF1aXJlcyBhbHNvIGVu
YWJsaW5nCi0JCQlsYW5tYW4gYXV0aGVudGljYXRpb24gaW4gdGhlIHNlY3VyaXR5IGZsYWdzCi0J
CQliZWNhdXNlIHRoZSBjaWZzIG1vZHVsZSBvbmx5IHN1cHBvcnRzIHNlbmRpbmcKLQkJCWxhaW50
ZXh0IHBhc3N3b3JkcyB1c2luZyB0aGUgb2xkZXIgbGFubWFuIGRpYWxlY3QKLQkJCWZvcm0gb2Yg
dGhlIHNlc3Npb24gc2V0dXAgU01CLiAgKGUuZy4gZm9yIGF1dGhlbnRpY2F0aW9uCi0JCQl1c2lu
ZyBwbGFpbiB0ZXh0IHBhc3N3b3Jkcywgc2V0IHRoZSBTZWN1cml0eUZsYWdzCi0JCQl0byAweDMw
MDMwKTo6CisJCQkJMHgwMEM1CisKKwkJCShOVExNdjIgYW5kIHBhY2tldCBzaWduaW5nIGFsbG93
ZWQpLiAgU29tZSBTZWN1cml0eUZsYWdzCisJCQltYXkgcmVxdWlyZSBlbmFibGluZyBhIGNvcnJl
c3BvbmRpbmcgbWVudWNvbmZpZyBvcHRpb24uCiAKIAkJCSAgbWF5IHVzZSBwYWNrZXQgc2lnbmlu
ZwkJCTB4MDAwMDEKIAkJCSAgbXVzdCB1c2UgcGFja2V0IHNpZ25pbmcJCQkweDAxMDAxCi0JCQkg
IG1heSB1c2UgTlRMTSAobW9zdCBjb21tb24gcGFzc3dvcmQgaGFzaCkJMHgwMDAwMgotCQkJICBt
dXN0IHVzZSBOVExNCQkJCQkweDAyMDAyCiAJCQkgIG1heSB1c2UgTlRMTXYyCQkJCTB4MDAwMDQK
IAkJCSAgbXVzdCB1c2UgTlRMTXYyCQkJCTB4MDQwMDQKLQkJCSAgbWF5IHVzZSBLZXJiZXJvcyBz
ZWN1cml0eQkJCTB4MDAwMDgKLQkJCSAgbXVzdCB1c2UgS2VyYmVyb3MJCQkJMHgwODAwOAotCQkJ
ICBtYXkgdXNlIGxhbm1hbiAod2VhaykgcGFzc3dvcmQgaGFzaAkJMHgwMDAxMAotCQkJICBtdXN0
IHVzZSBsYW5tYW4gcGFzc3dvcmQgaGFzaAkJCTB4MTAwMTAKLQkJCSAgbWF5IHVzZSBwbGFpbnRl
eHQgcGFzc3dvcmRzCQkJMHgwMDAyMAotCQkJICBtdXN0IHVzZSBwbGFpbnRleHQgcGFzc3dvcmRz
CQkJMHgyMDAyMAotCQkJICAocmVzZXJ2ZWQgZm9yIGZ1dHVyZSBwYWNrZXQgZW5jcnlwdGlvbikJ
MHgwMDA0MAorCQkJICBtYXkgdXNlIEtlcmJlcm9zIHNlY3VyaXR5IChrcmI1KQkJMHgwMDAwOAor
CQkJICBtdXN0IHVzZSBLZXJiZXJvcyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgMHgwODAw
OAorCQkJICBtYXkgdXNlIE5UTE1TU1AgICAgICAgICAgICAgICAJCTB4MDAwODAKKwkJCSAgbXVz
dCB1c2UgTlRMTVNTUCAgICAgICAgICAgCQkJMHg4MDA4MAorCQkJICBzZWFsIChwYWNrZXQgZW5j
cnlwdGlvbikJCQkweDAwMDQwCisJCQkgIG11c3Qgc2VhbCAobm90IGltcGxlbWVudGVkIHlldCkg
ICAgICAgICAgICAgICAweDQwMDQwCiAKIGNpZnNGWUkJCQlJZiBzZXQgdG8gbm9uLXplcm8gdmFs
dWUsIGFkZGl0aW9uYWwgZGVidWcgaW5mb3JtYXRpb24KIAkJCXdpbGwgYmUgbG9nZ2VkIHRvIHRo
ZSBzeXN0ZW0gZXJyb3IgbG9nLiAgVGhpcyBmaWVsZApkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVu
dC9jaWZzZ2xvYi5oIGIvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oCmluZGV4IDU1N2I2OGU5OWQw
YS4uMTQzOTljYjliNGFmIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2NpZnNnbG9iLmgKKysr
IGIvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oCkBAIC0xOTE4LDggKzE5MTgsOCBAQCByZXF1aXJl
IHVzZSBvZiB0aGUgc3Ryb25nZXIgcHJvdG9jb2wgKi8KICNkZWZpbmUgICBDSUZTU0VDX01VU1Rf
U0VBTAkweDQwMDQwIC8qIG5vdCBzdXBwb3J0ZWQgeWV0ICovCiAjZGVmaW5lICAgQ0lGU1NFQ19N
VVNUX05UTE1TU1AJMHg4MDA4MCAvKiByYXcgbnRsbXNzcCB3aXRoIG50bG12MiAqLwogCi0jZGVm
aW5lICAgQ0lGU1NFQ19ERUYgKENJRlNTRUNfTUFZX1NJR04gfCBDSUZTU0VDX01BWV9OVExNVjIg
fCBDSUZTU0VDX01BWV9OVExNU1NQKQotI2RlZmluZSAgIENJRlNTRUNfTUFYIChDSUZTU0VDX01V
U1RfTlRMTVYyKQorI2RlZmluZSAgIENJRlNTRUNfREVGIChDSUZTU0VDX01BWV9TSUdOIHwgQ0lG
U1NFQ19NQVlfTlRMTVYyIHwgQ0lGU1NFQ19NQVlfTlRMTVNTUCB8IENJRlNTRUNfTUFZX1NFQUwp
CisjZGVmaW5lICAgQ0lGU1NFQ19NQVggKENJRlNTRUNfTUFZX1NJR04gfCBDSUZTU0VDX01VU1Rf
S1JCNSB8IENJRlNTRUNfTUFZX1NFQUwpCiAjZGVmaW5lICAgQ0lGU1NFQ19BVVRIX01BU0sgKENJ
RlNTRUNfTUFZX05UTE1WMiB8IENJRlNTRUNfTUFZX0tSQjUgfCBDSUZTU0VDX01BWV9OVExNU1NQ
KQogLyoKICAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKgotLSAKMi40My4wCgo=
--00000000000005fbe8061cfa95a1--
