Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE6A1E868
	for <linux-cifs@vger.kernel.org>; Thu,  1 Aug 2024 03:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722481339; cv=none; b=FfYAn62PjpLAwkcGAltt5Kqd6oNXwTVi3+6xGALg7APWl3u7D0lHHfT8iWpp9fzEQbfmr7rF48bBOiz9bYIWxadwFSEuLRxi60cvpk9Z56iRDVY6UOnWrmIGPAuxTPMXGzqLeqqrYMfDgcb3S2Urokxmsh+KfTt6Ihivj5I75bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722481339; c=relaxed/simple;
	bh=O5rXECop1IeduLKINXJAFfTAcxzYyNqv6I5Gq3fYWWc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=FF8xiJUb9B6G4RSpIpA+pxmBaTXqwKUFsU1auxfnY7Ppq4PWFZ/kzLUwnfxMAvpSJcijeKn2HlZ08R6NtM8selwZbJpkBJ7dVir7tKyQXcHMW/bHQbCina44CNAChgUOg+Hi/6Smr+IKYpkjVWqCr3u0VFl00adzOxVoQXRItKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D2Tx31MI; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D2Tx31MI"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2f035ae1083so81678111fa.3
        for <linux-cifs@vger.kernel.org>; Wed, 31 Jul 2024 20:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722481335; x=1723086135; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MTY6Q3TpA8ApF+vz+JDsK7ooMbh4M7GW0SttpptJxS4=;
        b=D2Tx31MID3nZWl1FT/9mdekGnWIWgXfzYQQPUPNhed8MWa/MfsvQVKGN6lNx+4AaNO
         oywJSuZv5RtzLBVdhx+uKGpsSF4Hh00c94voBuC8IYnGe9QV+5mFEY7BgoAeNBzPGM2A
         iFaEtDlY80Jjt/SgOvxD7X8rki0cwVyrq6T4PhxStV73e85p+1/sq62bQtISnsX5TTPe
         MNrX8IQrr9R9WmXyJz4WwnE3sV3Sv0naeEUc5rz6iuctrxGIoewvwW8RaA5vWsdheB7N
         eg0Edw9pTEPjPmsyPJ4hKvtuiESN43zgguJMpQ8to8/2gogkD5YF6DepxfmW3MWSh7dq
         b42g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722481335; x=1723086135;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MTY6Q3TpA8ApF+vz+JDsK7ooMbh4M7GW0SttpptJxS4=;
        b=pbu0VaO5UbkdaKPf/M39i0BJ40EBlXwNydd/TyOgXPqTnpzU06XBb/QB2pgYT08bcj
         kDds1LN9LyG/fTMHy/ApJT1O1qIJjXS8hkijr9Mlekk8Rq7dcdJpCXJGo3D3fCxFaSmR
         bb9c2vghiAfPl5FAGgSVKa7D8l/a+2Jy2s+HO0wvQfuyrWPD//70N9EnKHwpoB3DXrA4
         A2VzTCPzMfjeaGTYZoU03oKECXU+xHkR9cPdWl+GW9mlpYT0e+OGhIFNKDFmLdMKvqnO
         I75yi+kEvfG53Z7pJ6diy3qb/JeockqTBVv/JLZat9TqSfbKwr7vvijfCFlA22+qaQ0N
         aNHQ==
X-Gm-Message-State: AOJu0YweOQPMfJ3LzkjAVYe/NpYhb5NSnmEofgWTlRaA17KOLDzH5xQ8
	wxOcXFfKBGPA77nH1UAvgZqVzumqqSIa79cvyvP56lyhjYDI0RgFL6ggExJ4LTjnTTg3TQiXq0T
	swnCxiQIrDansWyJt52DAR0vebDrTKsAQ
X-Google-Smtp-Source: AGHT+IEEO40IuvVa08R1vAVYWHLn5LWPs6AGMFzDWJ0PpyLT3UgfmZ3S6yDIw2VLshHVBv7Nox0CcT4wz2L1Z7fLffA=
X-Received: by 2002:a2e:8916:0:b0:2ef:32b9:85f6 with SMTP id
 38308e7fff4ca-2f1530edfb0mr6233531fa.11.1722481334988; Wed, 31 Jul 2024
 20:02:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 31 Jul 2024 22:02:03 -0500
Message-ID: <CAH2r5mst9GEtdNNhqUiaYrhX8JbNwy5FMcA7crLtHnZo1A4fJw@mail.gmail.com>
Subject: [PATCH][SMB3 client] fix setting SecurityFlags when encryption is required
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000001acfcd061e967089"

--0000000000001acfcd061e967089
Content-Type: text/plain; charset="UTF-8"

Setting encryption as required in cifs.ko's global security flags was
broken. For example (to require all mounts to be encrypted by setting):

  "echo 0x400c5 > /proc/fs/cifs/SecurityFlags"

would return "Invalid argument" and log "Unsupported security flags"
This patch fixes that (e.g. allowing overriding the default for
SecurityFlags  0x00c5, including 0x40000 to require seal, ie
SMB3.1.1 encryption) so now that works and forces encryption
on subsequent mounts.

-- 
Thanks,

Steve

--0000000000001acfcd061e967089
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-setting-SecurityFlags-when-encryption-is-re.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-setting-SecurityFlags-when-encryption-is-re.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lzaowgfv0>
X-Attachment-Id: f_lzaowgfv0

RnJvbSA2OGQzMDI5ZWY2OTc1N2E2ODhhMDc4ZDM4MzI4ZDU4MjA4YzU3Nzg1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMzEgSnVsIDIwMjQgMjE6Mzg6NTAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggc2V0dGluZyBTZWN1cml0eUZsYWdzIHdoZW4gZW5jcnlwdGlvbiBpcyByZXF1aXJl
ZAoKU2V0dGluZyBlbmNyeXB0aW9uIGFzIHJlcXVpcmVkIGluIHNlY3VyaXR5IGZsYWdzIHdhcyBi
cm9rZW4uCkZvciBleGFtcGxlICh0byByZXF1aXJlIGFsbCBtb3VudHMgdG8gYmUgZW5jcnlwdGVk
IGJ5IHNldHRpbmcpOgoKICAiZWNobyAweDQwMGM1ID4gL3Byb2MvZnMvY2lmcy9TZWN1cml0eUZs
YWdzIgoKV291bGQgcmV0dXJuICJJbnZhbGlkIGFyZ3VtZW50IiBhbmQgbG9nICJVbnN1cHBvcnRl
ZCBzZWN1cml0eSBmbGFncyIKVGhpcyBwYXRjaCBmaXhlcyB0aGF0IChlLmcuIGFsbG93aW5nIG92
ZXJyaWRpbmcgdGhlIGRlZmF1bHQgZm9yClNlY3VyaXR5RmxhZ3MgIDB4MDBjNSwgaW5jbHVkaW5n
IDB4NDAwMDAgdG8gcmVxdWlyZSBzZWFsLCBpZQpTTUIzLjEuMSBlbmNyeXB0aW9uKSBzbyBub3cg
dGhhdCB3b3JrcyBhbmQgZm9yY2VzIGVuY3J5cHRpb24Kb24gc3Vic2VxdWVudCBtb3VudHMuCgpT
aWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQog
RG9jdW1lbnRhdGlvbi9hZG1pbi1ndWlkZS9jaWZzL3VzYWdlLnJzdCB8IDIgKy0KIGZzL3NtYi9j
bGllbnQvY2lmc19kZWJ1Zy5jICAgICAgICAgICAgICAgfCAyICstCiBmcy9zbWIvY2xpZW50L2Np
ZnNnbG9iLmggICAgICAgICAgICAgICAgIHwgNCArKy0tCiBmcy9zbWIvY2xpZW50L3NtYjJwZHUu
YyAgICAgICAgICAgICAgICAgIHwgMyArKysKIDQgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25z
KCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vYWRtaW4tZ3Vp
ZGUvY2lmcy91c2FnZS5yc3QgYi9Eb2N1bWVudGF0aW9uL2FkbWluLWd1aWRlL2NpZnMvdXNhZ2Uu
cnN0CmluZGV4IGZkNGI1NmMwOTk2Zi4uYzA5Njc0YTc1YTllIDEwMDY0NAotLS0gYS9Eb2N1bWVu
dGF0aW9uL2FkbWluLWd1aWRlL2NpZnMvdXNhZ2UucnN0CisrKyBiL0RvY3VtZW50YXRpb24vYWRt
aW4tZ3VpZGUvY2lmcy91c2FnZS5yc3QKQEAgLTc0Miw3ICs3NDIsNyBAQCBTZWN1cml0eUZsYWdz
CQlGbGFncyB3aGljaCBjb250cm9sIHNlY3VyaXR5IG5lZ290aWF0aW9uIGFuZAogCQkJICBtYXkg
dXNlIE5UTE1TU1AgICAgICAgICAgICAgICAJCTB4MDAwODAKIAkJCSAgbXVzdCB1c2UgTlRMTVNT
UCAgICAgICAgICAgCQkJMHg4MDA4MAogCQkJICBzZWFsIChwYWNrZXQgZW5jcnlwdGlvbikJCQkw
eDAwMDQwCi0JCQkgIG11c3Qgc2VhbCAobm90IGltcGxlbWVudGVkIHlldCkgICAgICAgICAgICAg
ICAweDQwMDQwCisJCQkgIG11c3Qgc2VhbCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAweDQwMDQwCiAKIGNpZnNGWUkJCQlJZiBzZXQgdG8gbm9uLXplcm8gdmFsdWUsIGFkZGl0
aW9uYWwgZGVidWcgaW5mb3JtYXRpb24KIAkJCXdpbGwgYmUgbG9nZ2VkIHRvIHRoZSBzeXN0ZW0g
ZXJyb3IgbG9nLiAgVGhpcyBmaWVsZApkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jaWZzX2Rl
YnVnLmMgYi9mcy9zbWIvY2xpZW50L2NpZnNfZGVidWcuYwppbmRleCBjNzFhZTVjMDQzMDYuLjRh
MjBlOTI0NzRiMiAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jaWZzX2RlYnVnLmMKKysrIGIv
ZnMvc21iL2NsaWVudC9jaWZzX2RlYnVnLmMKQEAgLTEwNzIsNyArMTA3Miw3IEBAIHN0YXRpYyBp
bnQgY2lmc19zZWN1cml0eV9mbGFnc19wcm9jX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3Ry
dWN0IGZpbGUgKmZpbGUpCiBzdGF0aWMgdm9pZAogY2lmc19zZWN1cml0eV9mbGFnc19oYW5kbGVf
bXVzdF9mbGFncyh1bnNpZ25lZCBpbnQgKmZsYWdzKQogewotCXVuc2lnbmVkIGludCBzaWduZmxh
Z3MgPSAqZmxhZ3MgJiBDSUZTU0VDX01VU1RfU0lHTjsKKwl1bnNpZ25lZCBpbnQgc2lnbmZsYWdz
ID0gKmZsYWdzICYgKENJRlNTRUNfTVVTVF9TSUdOIHwgQ0lGU1NFQ19NVVNUX1NFQUwpOwogCiAJ
aWYgKCgqZmxhZ3MgJiBDSUZTU0VDX01VU1RfS1JCNSkgPT0gQ0lGU1NFQ19NVVNUX0tSQjUpCiAJ
CSpmbGFncyA9IENJRlNTRUNfTVVTVF9LUkI1OwpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9j
aWZzZ2xvYi5oIGIvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oCmluZGV4IGY2ZDFmMDc1OTg3Zi4u
YmVmZDg0ZjlkZjMwIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2NpZnNnbG9iLmgKKysrIGIv
ZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oCkBAIC0xODkxLDkgKzE4OTEsOSBAQCByZXF1aXJlIHVz
ZSBvZiB0aGUgc3Ryb25nZXIgcHJvdG9jb2wgKi8KICNkZWZpbmUgICBDSUZTU0VDX01VU1RfTlRM
TVYyCTB4MDQwMDQKICNkZWZpbmUgICBDSUZTU0VDX01VU1RfS1JCNQkweDA4MDA4CiAjaWZkZWYg
Q09ORklHX0NJRlNfVVBDQUxMCi0jZGVmaW5lICAgQ0lGU1NFQ19NQVNLICAgICAgICAgIDB4OEYw
OEYgLyogZmxhZ3Mgc3VwcG9ydGVkIGlmIG5vIHdlYWsgYWxsb3dlZCAqLworI2RlZmluZSAgIENJ
RlNTRUNfTUFTSyAgICAgICAgICAweENGMENGIC8qIGZsYWdzIHN1cHBvcnRlZCBpZiBubyB3ZWFr
IGFsbG93ZWQgKi8KICNlbHNlCi0jZGVmaW5lCSAgQ0lGU1NFQ19NQVNLICAgICAgICAgIDB4ODcw
ODcgLyogZmxhZ3Mgc3VwcG9ydGVkIGlmIG5vIHdlYWsgYWxsb3dlZCAqLworI2RlZmluZQkgIENJ
RlNTRUNfTUFTSyAgICAgICAgICAweEM3MEM3IC8qIGZsYWdzIHN1cHBvcnRlZCBpZiBubyB3ZWFr
IGFsbG93ZWQgKi8KICNlbmRpZiAvKiBVUENBTEwgKi8KICNkZWZpbmUgICBDSUZTU0VDX01VU1Rf
U0VBTAkweDQwMDQwIC8qIG5vdCBzdXBwb3J0ZWQgeWV0ICovCiAjZGVmaW5lICAgQ0lGU1NFQ19N
VVNUX05UTE1TU1AJMHg4MDA4MCAvKiByYXcgbnRsbXNzcCB3aXRoIG50bG12MiAqLwpkaWZmIC0t
Z2l0IGEvZnMvc21iL2NsaWVudC9zbWIycGR1LmMgYi9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYwpp
bmRleCA5YTA2YjU1OTQ2NjkuLjgzZmFjYjU0Mjc2YSAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVu
dC9zbWIycGR1LmMKKysrIGIvZnMvc21iL2NsaWVudC9zbWIycGR1LmMKQEAgLTgyLDYgKzgyLDkg
QEAgaW50IHNtYjNfZW5jcnlwdGlvbl9yZXF1aXJlZChjb25zdCBzdHJ1Y3QgY2lmc190Y29uICp0
Y29uKQogCWlmICh0Y29uLT5zZWFsICYmCiAJICAgICh0Y29uLT5zZXMtPnNlcnZlci0+Y2FwYWJp
bGl0aWVzICYgU01CMl9HTE9CQUxfQ0FQX0VOQ1JZUFRJT04pKQogCQlyZXR1cm4gMTsKKwlpZiAo
KChnbG9iYWxfc2VjZmxhZ3MgJiBDSUZTU0VDX01VU1RfU0VBTCkgPT0gQ0lGU1NFQ19NVVNUX1NF
QUwpICYmCisJICAgICh0Y29uLT5zZXMtPnNlcnZlci0+Y2FwYWJpbGl0aWVzICYgU01CMl9HTE9C
QUxfQ0FQX0VOQ1JZUFRJT04pKQorCQlyZXR1cm4gMTsKIAlyZXR1cm4gMDsKIH0KIAotLSAKMi40
My4wCgo=
--0000000000001acfcd061e967089--
