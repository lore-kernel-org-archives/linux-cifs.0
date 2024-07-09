Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B9815383A
	for <linux-cifs@vger.kernel.org>; Tue,  9 Jul 2024 23:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720568737; cv=none; b=nsuZKFR1ysiVQGuOzrsETrNjMMhwjNxuzSCAosj8Qnt3HHevTCRdo5NnAM/jbcxzeRwLvEUmv6bhRaP35ef3Z9Lvxsx9Q3e3uTEIkUrphsjjWmZNw8UuU+j0L0u2CDOQrX42mzPRyqavJIcZ5KytXf7XfA6wLpuyrbpoCqIR5No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720568737; c=relaxed/simple;
	bh=p83bjr3I81UGHQlY1qunVvX8eF4XOCtiBQikExfHx90=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=DTTZx8yj/+QpLsgppUhsJkQrIx/+hld5Lpkij29BwvKkMpGgder56j+9/wo5P3k7GDPIMciWuMt6YTEC/p0avjiTjk3WFg1eJU6BjbhRFxV2wdMJyW+L6FqZQFR+FyNVydZcZi0VI9yj4FXXVQ2hqHnils0cUouHbVp/dgTm9M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZxEAD+sf; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZxEAD+sf"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-52e96d4986bso6087627e87.3
        for <linux-cifs@vger.kernel.org>; Tue, 09 Jul 2024 16:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720568734; x=1721173534; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uwIHQQ4Tbn9y+N0g/1XRLcqqwP65S9jwCGc1fD6Vm9U=;
        b=ZxEAD+sf7YhNgMDf7TRuIBrydhY0sYKhnbPTLjdg77E7dJW5MO/iLRcHaig/JavQgV
         4mSvVOaSTEh5cbUL7Av1+WmZyGzOunf99FyWu2Iq1caGMuKbFZgvye7wvrP00zc6Ef+/
         jX7iUzjb8nkCzSX5yv8jN2oZ7zVGZ88ZdEgxSitQHfN5Rb8hYtdp6QquUIbh5FWBpTme
         BCfJ12MdFKbDnL+5By+HGKyg65jRwXfOoj9PweD0+nnpkM0xji2E3oNykXBJ1eqQSpDX
         4eLJR0+dQAXttr9oXhlMou9FDfGfwFBEliyfVXpkQVuAQT02c/bnCntcnQkFZ3YEzPaD
         CjfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720568734; x=1721173534;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uwIHQQ4Tbn9y+N0g/1XRLcqqwP65S9jwCGc1fD6Vm9U=;
        b=PawPqaCB+mNnC1AVhqDO7WwzGZL1lXpAko6jiL06Gqk/cQAg3lXUxbj2tADgeJFtvx
         QSC4QCRAInlPPlOJNjDUMYj/WMfnwPoC4+8fbu5HkyNYSb4ybkOzgJVIGsZ4YXn0i1tu
         +41Qu4wuFzL9q/Cf1F2ZVHBPjqhg/rVjWMJLIjYLUk23ajhR+AioNafbW4+fUFLTznd5
         jp0zh5hr/cmtG29NaIVSeC3w005c9I0DFjbA2dtKMDhcXjns5nnLbwdSNaS89u07lcP7
         uTJ3sF147GLspA+hl7HeHKv9G4PUlLFi0M0h+GHN+ptS9DiAVEJfnaPB44oyYSuplm65
         bcnw==
X-Gm-Message-State: AOJu0YzP1Rfxk822A7URboCU7GMI2NS76GdoPrsUAV+CTRareLsuhGSP
	9HazR3v0FcVOCIzKf3hTcI/zlQmqwD2RhIdK/huFqMpZgQplSeBtPv5ghvRPnCuqeE1wb4KkVh5
	i2UH6UGaRR3aHQQ+FE+tu/kugJqOuhMEr
X-Google-Smtp-Source: AGHT+IEGY2mdNtjhrf+j6pxoHL80Vrx5Nt1+pzVoK7zpLH4pt/FXNqB8R5/mhUq20jFOWrNehueeeaqUsuVIoD/lV50=
X-Received: by 2002:a05:6512:3dab:b0:52c:9e82:a971 with SMTP id
 2adb3069b0e04-52eb9990fb4mr2700654e87.7.1720568733528; Tue, 09 Jul 2024
 16:45:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 9 Jul 2024 18:45:21 -0500
Message-ID: <CAH2r5mv2V3vdupgmR75WsNGrfdbaPo0Mw+6x82KK9vgUYu5AkQ@mail.gmail.com>
Subject: [PATCH] cifs: fix setting SecurityFlags to true
To: CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000002c8ee6061cd9206c"

--0000000000002c8ee6061cd9206c
Content-Type: text/plain; charset="UTF-8"

If you try to set /proc/fs/cifs/SecurityFlags to 1 it
will set them to CIFSSEC_MUST_NTLMV2 which is obsolete and no
longer checked, and will cause mount to fail, so change this
to set it to a more understandable default (ie include Kerberos
as well).

Also change the description of the SecurityFlags to remove mention
of various flags which are no longer supported (due to removal
of weak security such as lanman and ntlmv1).



-- 
Thanks,

Steve

--0000000000002c8ee6061cd9206c
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-setting-SecurityFlags-to-true.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-setting-SecurityFlags-to-true.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lyf25u0d0>
X-Attachment-Id: f_lyf25u0d0

RnJvbSBlOGU4MjA4Nzc5NjMyN2ExNDBmMzU0MjgyNWY0ZGRlYjdmZDBkZmIwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgOSBKdWwgMjAyNCAxODowNzozNSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IGZpeCBzZXR0aW5nIFNlY3VyaXR5RmxhZ3MgdG8gdHJ1ZQoKSWYgeW91IHRyeSB0byBzZXQg
L3Byb2MvZnMvY2lmcy9TZWN1cml0eUZsYWdzIHRvIDEgaXQKd2lsbCBzZXQgdGhlbSB0byBDSUZT
U0VDX01VU1RfTlRMTVYyIHdoaWNoIGlzIG9ic29sZXRlIGFuZCBubwpsb25nZXIgY2hlY2tlZCwg
YW5kIHdpbGwgY2F1c2UgbW91bnQgdG8gZmFpbCwgc28gY2hhbmdlIHRoaXMKdG8gc2V0IGl0IHRv
IGEgbW9yZSB1bmRlcnN0YW5kYWJsZSBkZWZhdWx0IChpZSBpbmNsdWRlIEtlcmJlcm9zCmFzIHdl
bGwpLgoKQWxzbyBjaGFuZ2UgdGhlIGRlc2NyaXB0aW9uIG9mIHRoZSBTZWN1cml0eUZsYWdzIHRv
IHJlbW92ZSBtZW50aW9uCm9mIGZsYWdzIHdoaWNoIGFyZSBubyBsb25nZXIgc3VwcG9ydGVkLgoK
Q2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxz
dGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIERvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUvY2lm
cy91c2FnZS5yc3QgfCAzNiArKysrKysrKy0tLS0tLS0tLS0tLS0tLS0KIGZzL3NtYi9jbGllbnQv
Y2lmc2dsb2IuaCAgICAgICAgICAgICAgICAgfCAgNCArLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTMg
aW5zZXJ0aW9ucygrKSwgMjcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlv
bi9hZG1pbi1ndWlkZS9jaWZzL3VzYWdlLnJzdCBiL0RvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUv
Y2lmcy91c2FnZS5yc3QKaW5kZXggYWE4MjkwYTI5ZGM4Li5mZDRiNTZjMDk5NmYgMTAwNjQ0Ci0t
LSBhL0RvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUvY2lmcy91c2FnZS5yc3QKKysrIGIvRG9jdW1l
bnRhdGlvbi9hZG1pbi1ndWlkZS9jaWZzL3VzYWdlLnJzdApAQCAtNzIzLDQwICs3MjMsMjYgQEAg
Q29uZmlndXJhdGlvbiBwc2V1ZG8tZmlsZXM6CiA9PT09PT09PT09PT09PT09PT09PT09PSA9PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09CiBTZWN1
cml0eUZsYWdzCQlGbGFncyB3aGljaCBjb250cm9sIHNlY3VyaXR5IG5lZ290aWF0aW9uIGFuZAog
CQkJYWxzbyBwYWNrZXQgc2lnbmluZy4gQXV0aGVudGljYXRpb24gKG1heS9tdXN0KQotCQkJZmxh
Z3MgKGUuZy4gZm9yIE5UTE0gYW5kL29yIE5UTE12MikgbWF5IGJlIGNvbWJpbmVkIHdpdGgKKwkJ
CWZsYWdzIChlLmcuIGZvciBOVExNdjIpIG1heSBiZSBjb21iaW5lZCB3aXRoCiAJCQl0aGUgc2ln
bmluZyBmbGFncy4gIFNwZWNpZnlpbmcgdHdvIGRpZmZlcmVudCBwYXNzd29yZAogCQkJaGFzaGlu
ZyBtZWNoYW5pc21zIChhcyAibXVzdCB1c2UiKSBvbiB0aGUgb3RoZXIgaGFuZAogCQkJZG9lcyBu
b3QgbWFrZSBtdWNoIHNlbnNlLiBEZWZhdWx0IGZsYWdzIGFyZTo6CiAKLQkJCQkweDA3MDA3Ci0K
LQkJCShOVExNLCBOVExNdjIgYW5kIHBhY2tldCBzaWduaW5nIGFsbG93ZWQpLiAgVGhlIG1heGlt
dW0KLQkJCWFsbG93YWJsZSBmbGFncyBpZiB5b3Ugd2FudCB0byBhbGxvdyBtb3VudHMgdG8gc2Vy
dmVycwotCQkJdXNpbmcgd2Vha2VyIHBhc3N3b3JkIGhhc2hlcyBpcyAweDM3MDM3IChsYW5tYW4s
Ci0JCQlwbGFpbnRleHQsIG50bG0sIG50bG12Miwgc2lnbmluZyBhbGxvd2VkKS4gIFNvbWUKLQkJ
CVNlY3VyaXR5RmxhZ3MgcmVxdWlyZSB0aGUgY29ycmVzcG9uZGluZyBtZW51Y29uZmlnCi0JCQlv
cHRpb25zIHRvIGJlIGVuYWJsZWQuICBFbmFibGluZyBwbGFpbnRleHQKLQkJCWF1dGhlbnRpY2F0
aW9uIGN1cnJlbnRseSByZXF1aXJlcyBhbHNvIGVuYWJsaW5nCi0JCQlsYW5tYW4gYXV0aGVudGlj
YXRpb24gaW4gdGhlIHNlY3VyaXR5IGZsYWdzCi0JCQliZWNhdXNlIHRoZSBjaWZzIG1vZHVsZSBv
bmx5IHN1cHBvcnRzIHNlbmRpbmcKLQkJCWxhaW50ZXh0IHBhc3N3b3JkcyB1c2luZyB0aGUgb2xk
ZXIgbGFubWFuIGRpYWxlY3QKLQkJCWZvcm0gb2YgdGhlIHNlc3Npb24gc2V0dXAgU01CLiAgKGUu
Zy4gZm9yIGF1dGhlbnRpY2F0aW9uCi0JCQl1c2luZyBwbGFpbiB0ZXh0IHBhc3N3b3Jkcywgc2V0
IHRoZSBTZWN1cml0eUZsYWdzCi0JCQl0byAweDMwMDMwKTo6CisJCQkJMHgwMEM1CisKKwkJCShO
VExNdjIgYW5kIHBhY2tldCBzaWduaW5nIGFsbG93ZWQpLiAgU29tZSBTZWN1cml0eUZsYWdzCisJ
CQltYXkgcmVxdWlyZSBlbmFibGluZyBhIGNvcnJlc3BvbmRpbmcgbWVudWNvbmZpZyBvcHRpb24u
CiAKIAkJCSAgbWF5IHVzZSBwYWNrZXQgc2lnbmluZwkJCTB4MDAwMDEKIAkJCSAgbXVzdCB1c2Ug
cGFja2V0IHNpZ25pbmcJCQkweDAxMDAxCi0JCQkgIG1heSB1c2UgTlRMTSAobW9zdCBjb21tb24g
cGFzc3dvcmQgaGFzaCkJMHgwMDAwMgotCQkJICBtdXN0IHVzZSBOVExNCQkJCQkweDAyMDAyCiAJ
CQkgIG1heSB1c2UgTlRMTXYyCQkJCTB4MDAwMDQKIAkJCSAgbXVzdCB1c2UgTlRMTXYyCQkJCTB4
MDQwMDQKLQkJCSAgbWF5IHVzZSBLZXJiZXJvcyBzZWN1cml0eQkJCTB4MDAwMDgKLQkJCSAgbXVz
dCB1c2UgS2VyYmVyb3MJCQkJMHgwODAwOAotCQkJICBtYXkgdXNlIGxhbm1hbiAod2VhaykgcGFz
c3dvcmQgaGFzaAkJMHgwMDAxMAotCQkJICBtdXN0IHVzZSBsYW5tYW4gcGFzc3dvcmQgaGFzaAkJ
CTB4MTAwMTAKLQkJCSAgbWF5IHVzZSBwbGFpbnRleHQgcGFzc3dvcmRzCQkJMHgwMDAyMAotCQkJ
ICBtdXN0IHVzZSBwbGFpbnRleHQgcGFzc3dvcmRzCQkJMHgyMDAyMAotCQkJICAocmVzZXJ2ZWQg
Zm9yIGZ1dHVyZSBwYWNrZXQgZW5jcnlwdGlvbikJMHgwMDA0MAorCQkJICBtYXkgdXNlIEtlcmJl
cm9zIHNlY3VyaXR5IChrcmI1KQkJMHgwMDAwOAorCQkJICBtdXN0IHVzZSBLZXJiZXJvcyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgMHgwODAwOAorCQkJICBtYXkgdXNlIE5UTE1TU1AgICAg
ICAgICAgICAgICAJCTB4MDAwODAKKwkJCSAgbXVzdCB1c2UgTlRMTVNTUCAgICAgICAgICAgCQkJ
MHg4MDA4MAorCQkJICBzZWFsIChwYWNrZXQgZW5jcnlwdGlvbikJCQkweDAwMDQwCisJCQkgIG11
c3Qgc2VhbCAobm90IGltcGxlbWVudGVkIHlldCkgICAgICAgICAgICAgICAweDQwMDQwCiAKIGNp
ZnNGWUkJCQlJZiBzZXQgdG8gbm9uLXplcm8gdmFsdWUsIGFkZGl0aW9uYWwgZGVidWcgaW5mb3Jt
YXRpb24KIAkJCXdpbGwgYmUgbG9nZ2VkIHRvIHRoZSBzeXN0ZW0gZXJyb3IgbG9nLiAgVGhpcyBm
aWVsZApkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oIGIvZnMvc21iL2NsaWVu
dC9jaWZzZ2xvYi5oCmluZGV4IDU1N2I2OGU5OWQwYS4uZmNmY2I4NDI5ZDMyIDEwMDY0NAotLS0g
YS9mcy9zbWIvY2xpZW50L2NpZnNnbG9iLmgKKysrIGIvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5o
CkBAIC0xOTE4LDggKzE5MTgsOCBAQCByZXF1aXJlIHVzZSBvZiB0aGUgc3Ryb25nZXIgcHJvdG9j
b2wgKi8KICNkZWZpbmUgICBDSUZTU0VDX01VU1RfU0VBTAkweDQwMDQwIC8qIG5vdCBzdXBwb3J0
ZWQgeWV0ICovCiAjZGVmaW5lICAgQ0lGU1NFQ19NVVNUX05UTE1TU1AJMHg4MDA4MCAvKiByYXcg
bnRsbXNzcCB3aXRoIG50bG12MiAqLwogCi0jZGVmaW5lICAgQ0lGU1NFQ19ERUYgKENJRlNTRUNf
TUFZX1NJR04gfCBDSUZTU0VDX01BWV9OVExNVjIgfCBDSUZTU0VDX01BWV9OVExNU1NQKQotI2Rl
ZmluZSAgIENJRlNTRUNfTUFYIChDSUZTU0VDX01VU1RfTlRMTVYyKQorI2RlZmluZSAgIENJRlNT
RUNfREVGIChDSUZTU0VDX01BWV9TSUdOIHwgQ0lGU1NFQ19NQVlfTlRMTVYyIHwgQ0lGU1NFQ19N
QVlfTlRMTVNTUCB8IENJRlNTRUNfTUFZX1NJR04gfCBDSUZTU0VDX01BWV9TRUFMKQorI2RlZmlu
ZSAgIENJRlNTRUNfTUFYIChDSUZTU0VDX01BWV9LUkI1IHwgQ0lGU1NFQ19ERUYpCiAjZGVmaW5l
ICAgQ0lGU1NFQ19BVVRIX01BU0sgKENJRlNTRUNfTUFZX05UTE1WMiB8IENJRlNTRUNfTUFZX0tS
QjUgfCBDSUZTU0VDX01BWV9OVExNU1NQKQogLyoKICAqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgotLSAKMi40My4wCgo=
--0000000000002c8ee6061cd9206c--
