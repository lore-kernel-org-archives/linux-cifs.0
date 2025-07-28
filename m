Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A219274B53
	for <linux-cifs@vger.kernel.org>; Mon, 28 Jul 2025 17:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753724248; cv=none; b=KDgcMkK7/hnxAHeG7gvfCztm895yYHsXDOnqpu6OuGFngjGgo37BIx8013aU0HDjArsHlf50rortAHxCWcJJWI1ND27Iwxsp2hdbF+KJKFYhKSC6F9+DAtZc9A8sMR7JZV+yt8lPXA0YkL1QU1FFzCm77UBdl175fMJo03zhiHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753724248; c=relaxed/simple;
	bh=fottRo6fuvHWN0jSiajGgI+LH/8lJAE6yS2m8GnE/tU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=F+J9Yzox2tjtj5n4MEqQe5LlIytWm0QYR6P5QLwK5ELWDtaULSi3LbPvlRAxzZ4GUL1JjwwdXMNmtL2o98935NgQSe+wRH+eDeHIJ0l2ZPrY3i3AxPCgsLkF/+Da3iDvC2NzoviWadHo8RuGlsP61AOvTtMoIh1QZfMY0ehq85s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R/B4lryj; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R/B4lryj"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-702cbfe860cso39399976d6.1
        for <linux-cifs@vger.kernel.org>; Mon, 28 Jul 2025 10:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753724245; x=1754329045; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zjysJ+Wmx3VAfCQ/zZ7a9pBQD5yaulKDzspwdDkFPlQ=;
        b=R/B4lryjEkrWtxee27OgiNi46zLHbxncNiGK6HS4zVMh2ZTioJeEbAEAKYnnwNkP5t
         C3Dh4SsI4ePdRntgpj2DuJzzbCKjtedmxggb7sxWj3zkdSXh+cYxqNGdtdTv3NFbzaNf
         cWBek+Kl95DgiALXaykUcyatDAQo96/kPMbLiLUA0FOyHAScuLuY0xef+rhBdnjl8wg5
         rwkQVB6lYDQCnZsRzHU48khMNxqul6mUq8CHEjZ0CeqTxOq+/zury8c1ffM5p6bzndkC
         C28SQ7yZpeEoDt2FK7x5SCA5TRboSz5r9y3Uutq9OPtDazxS1EnwFU6TD1tr4PwGGj02
         QYAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753724245; x=1754329045;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zjysJ+Wmx3VAfCQ/zZ7a9pBQD5yaulKDzspwdDkFPlQ=;
        b=qRgm3j69V3B48Ka9l744wyd7NTBijRtShDQWwaamKwfAgZ0lhvm9oce5oCo2osIj4j
         nmCwlBI5Hhn9SVdt9KMA4g4WEoGp/wzZPlku6T/mmlGFIbJEMCqmM58b4d+/k833V722
         23To/HQWgbd8KkiTUG5YagzPLGg1IDIfkOcEMMbrhaRoGhttmIENchc4ZAcVQvsac0Na
         Z07MoDuMZWqSs5hFKJBynzRFA4vZGdCpmPYcVtlq0ew637MhExwsIO/6NXQWJtKKqx1T
         I5Ghx802MXK8376F0uBhTt0OJHN8uwvXJEiYDdCVsOAcyxZ7nBYc/boA8t8LRCBshnbW
         bEAw==
X-Gm-Message-State: AOJu0YwYLHC9Z9jwerWZpowOr8wz3hbn2pvi6PCLZcoX/AkSvGU2ZAuJ
	JaBDalOWvFDp/fd+ulOsl0+CQN/qW1npCK/7uWXf1jbDAMsZsA1qF7Nagj5dKRcy9rGKbIYOwvr
	lqbBMfCQdGZ/DotVRYze3kkZrmWhbFjII8W25j6w=
X-Gm-Gg: ASbGnctNN4/NPsltkM9WsJlpm3OtJ5AV+nPr8mK5qNleq7LiFINtycmHPSRA2Xlvm+r
	L3X4lhpIQ78KxirjcRDYwCwvns4w8hDR0dkce6f5zHSByyfb70ksi6tFtZZnwPqt7Eb9KeufRVi
	Xlv0b9xA1X28LqyHMGtKY3cf36z1d7Dkfbq2QeOGX72CfB4vpu9PziRREJuOs/Ffbwos/QV8kyX
	PipTzHcFT9a0tDrMrtg4+Novs9uLCf7x9FCBi2M3A==
X-Google-Smtp-Source: AGHT+IGQOZmeIK6IGMsPsPBNZIEgWFjmp/cP1ww3qtTjGE1AOBsemK+elxYJD+GNAg3+2MO8REeYLl7CHbyZ6LjA6oc=
X-Received: by 2002:ad4:5de6:0:b0:704:f7d8:edfe with SMTP id
 6a1803df08f44-7072060de4emr157880136d6.51.1753724244810; Mon, 28 Jul 2025
 10:37:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 28 Jul 2025 12:37:13 -0500
X-Gm-Features: Ac12FXwP0oGDocTGq_crO4Gmi3J2T6jzzs0Fisac37meN_gLF9Bm4v4QepHDp_g
Message-ID: <CAH2r5msG+FxsTBot9RAz-tALK3S49nDpsfzigGTKaBaQtwheng@mail.gmail.com>
Subject: [PATCH][SMB3 client] add way to show directory leases for improved debugging
To: CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>, 
	Henrique Carvalho <henrique.carvalho@suse.com>, Bharath S M <bharathsm@microsoft.com>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000a5b637063b00be26"

--000000000000a5b637063b00be26
Content-Type: text/plain; charset="UTF-8"

When looking at performance issues around directory caching, or debugging
directory lease issues, it is helpful to be able to display the current
directory leases (as we can e.g. or open files).  Create pseudo-file
/proc/fs/cifs/open_dirs that displays current directory leases.  Here
is sample output:

 cat /proc/fs/cifs/open_dirs
   Version:1
   Format:
   <tree id> <sess id> <persistent fid> <path>
  Num entries: 3
  0xce4c1c68 0x7176aa54 0xd95ef58e     \dira      valid file info, valid dirents
  0xce4c1c68 0x7176aa54 0xd031e211     \dir5      valid file info, valid dirents
  0xce4c1c68 0x7176aa54 0x96533a90     \dir1      valid file info

See attached patch
-- 
Thanks,

Steve

--000000000000a5b637063b00be26
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-client-add-way-to-show-directory-leases-for-imp.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-client-add-way-to-show-directory-leases-for-imp.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mdne4h0q0>
X-Attachment-Id: f_mdne4h0q0

RnJvbSA3OGQyMDI0Yzk2NzZlZDdkNTNkMmVkN2YyZWUyYTQ2MjYxYzBkNzYwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjggSnVsIDIwMjUgMTI6MzI6NTMgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzIGNsaWVudDogYWRkIHdheSB0byBzaG93IGRpcmVjdG9yeSBsZWFzZXMgZm9yIGltcHJvdmVk
CiBkZWJ1Z2dpbmcKCldoZW4gbG9va2luZyBhdCBwZXJmb3JtYW5jZSBpc3N1ZXMgYXJvdW5kIGRp
cmVjdG9yeSBjYWNoaW5nLCBvciBkZWJ1Z2dpbmcKZGlyZWN0b3J5IGxlYXNlIGlzc3VlcywgaXQg
aXMgaGVscGZ1bCB0byBiZSBhYmxlIHRvIGRpc3BsYXkgdGhlIGN1cnJlbnQKZGlyZWN0b3J5IGxl
YXNlcyAoYXMgd2UgY2FuIGUuZy4gb3Igb3BlbiBmaWxlcykuICBDcmVhdGUgcHNldWRvLWZpbGUK
L3Byb2MvZnMvY2lmcy9vcGVuX2RpcnMgdGhhdCBkaXNwbGF5cyBjdXJyZW50IGRpcmVjdG9yeSBs
ZWFzZXMuICBIZXJlCmlzIHNhbXBsZSBvdXRwdXQ6CgpjYXQgL3Byb2MvZnMvY2lmcy9vcGVuX2Rp
cnMKIFZlcnNpb246MQogRm9ybWF0OgogPHRyZWUgaWQ+IDxzZXNzIGlkPiA8cGVyc2lzdGVudCBm
aWQ+IDxwYXRoPgpOdW0gZW50cmllczogMwoweGNlNGMxYzY4IDB4NzE3NmFhNTQgMHhkOTVlZjU4
ZSAgICAgXGRpcmEgICAgICB2YWxpZCBmaWxlIGluZm8sIHZhbGlkIGRpcmVudHMKMHhjZTRjMWM2
OCAweDcxNzZhYTU0IDB4ZDAzMWUyMTEgICAgIFxkaXI1ICAgICAgdmFsaWQgZmlsZSBpbmZvLCB2
YWxpZCBkaXJlbnRzCjB4Y2U0YzFjNjggMHg3MTc2YWE1NCAweDk2NTMzYTkwICAgICBcZGlyMSAg
ICAgIHZhbGlkIGZpbGUgaW5mbwoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5j
aEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5oIHwgIDEgLQog
ZnMvc21iL2NsaWVudC9jaWZzX2RlYnVnLmMgfCA1MyArKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCA1MyBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jYWNoZWRfZGlyLmggYi9mcy9zbWIv
Y2xpZW50L2NhY2hlZF9kaXIuaAppbmRleCAyYzI2Mjg4MWI3YjEuLjQ2YjVhMmZkZjE1YiAxMDA2
NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jYWNoZWRfZGlyLmgKKysrIGIvZnMvc21iL2NsaWVudC9j
YWNoZWRfZGlyLmgKQEAgLTE0LDcgKzE0LDYgQEAgc3RydWN0IGNhY2hlZF9kaXJlbnQgewogCWNo
YXIgKm5hbWU7CiAJaW50IG5hbWVsZW47CiAJbG9mZl90IHBvczsKLQogCXN0cnVjdCBjaWZzX2Zh
dHRyIGZhdHRyOwogfTsKIApkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jaWZzX2RlYnVnLmMg
Yi9mcy9zbWIvY2xpZW50L2NpZnNfZGVidWcuYwppbmRleCAzZmRmNzU3MzdkNDMuLmYxY2VhMzY1
YjZmMSAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jaWZzX2RlYnVnLmMKKysrIGIvZnMvc21i
L2NsaWVudC9jaWZzX2RlYnVnLmMKQEAgLTI2LDYgKzI2LDcgQEAKICNpbmNsdWRlICJzbWJkaXJl
Y3QuaCIKICNlbmRpZgogI2luY2x1ZGUgImNpZnNfc3duLmgiCisjaW5jbHVkZSAiY2FjaGVkX2Rp
ci5oIgogCiB2b2lkCiBjaWZzX2R1bXBfbWVtKGNoYXIgKmxhYmVsLCB2b2lkICpkYXRhLCBpbnQg
bGVuZ3RoKQpAQCAtMjgwLDYgKzI4MSw1NCBAQCBzdGF0aWMgaW50IGNpZnNfZGVidWdfZmlsZXNf
cHJvY19zaG93KHN0cnVjdCBzZXFfZmlsZSAqbSwgdm9pZCAqdikKIAlyZXR1cm4gMDsKIH0KIAor
c3RhdGljIGludCBjaWZzX2RlYnVnX2RpcnNfcHJvY19zaG93KHN0cnVjdCBzZXFfZmlsZSAqbSwg
dm9pZCAqdikKK3sKKwlzdHJ1Y3QgbGlzdF9oZWFkICpzdG1wLCAqdG1wLCAqdG1wMTsKKwlzdHJ1
Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXI7CisJc3RydWN0IGNpZnNfc2VzICpzZXM7CisJc3Ry
dWN0IGNpZnNfdGNvbiAqdGNvbjsKKwlzdHJ1Y3QgY2FjaGVkX2ZpZHMgKmNmaWRzOworCXN0cnVj
dCBjYWNoZWRfZmlkICpjZmlkOworCUxJU1RfSEVBRChlbnRyeSk7CisKKwlzZXFfcHV0cyhtLCAi
IyBWZXJzaW9uOjFcbiIpOworCXNlcV9wdXRzKG0sICIjIEZvcm1hdDpcbiIpOworCXNlcV9wdXRz
KG0sICIjIDx0cmVlIGlkPiA8c2VzcyBpZD4gPHBlcnNpc3RlbnQgZmlkPiA8cGF0aD5cbiIpOwor
CisJc3Bpbl9sb2NrKCZjaWZzX3RjcF9zZXNfbG9jayk7CisJbGlzdF9mb3JfZWFjaChzdG1wLCAm
Y2lmc190Y3Bfc2VzX2xpc3QpIHsKKwkJc2VydmVyID0gbGlzdF9lbnRyeShzdG1wLCBzdHJ1Y3Qg
VENQX1NlcnZlcl9JbmZvLAorCQkJCSAgICB0Y3Bfc2VzX2xpc3QpOworCQlsaXN0X2Zvcl9lYWNo
KHRtcCwgJnNlcnZlci0+c21iX3Nlc19saXN0KSB7CisJCQlzZXMgPSBsaXN0X2VudHJ5KHRtcCwg
c3RydWN0IGNpZnNfc2VzLCBzbWJfc2VzX2xpc3QpOworCQkJbGlzdF9mb3JfZWFjaCh0bXAxLCAm
c2VzLT50Y29uX2xpc3QpIHsKKwkJCQl0Y29uID0gbGlzdF9lbnRyeSh0bXAxLCBzdHJ1Y3QgY2lm
c190Y29uLCB0Y29uX2xpc3QpOworCQkJCWNmaWRzID0gdGNvbi0+Y2ZpZHM7CisJCQkJc3Bpbl9s
b2NrKCZjZmlkcy0+Y2ZpZF9saXN0X2xvY2spOyAvKiBjaGVjayBsb2NrIG9yZGVyaW5nICovCisJ
CQkJc2VxX3ByaW50ZihtLCAiTnVtIGVudHJpZXM6ICVkXG4iLCBjZmlkcy0+bnVtX2VudHJpZXMp
OworCQkJCWxpc3RfZm9yX2VhY2hfZW50cnkoY2ZpZCwgJmNmaWRzLT5lbnRyaWVzLCBlbnRyeSkg
eworCQkJCQlzZXFfcHJpbnRmKG0sICIweCV4IDB4JWxseCAweCVsbHggICAgICVzIiwKKwkJCQkJ
CXRjb24tPnRpZCwKKwkJCQkJCXNlcy0+U3VpZCwKKwkJCQkJCWNmaWQtPmZpZC5wZXJzaXN0ZW50
X2ZpZCwKKwkJCQkJCWNmaWQtPnBhdGgpOworCQkJCQlpZiAoY2ZpZC0+ZmlsZV9hbGxfaW5mb19p
c192YWxpZCkKKwkJCQkJCXNlcV9wcmludGYobSwgIlx0dmFsaWQgZmlsZSBpbmZvIik7CisJCQkJ
CWlmIChjZmlkLT5kaXJlbnRzLmlzX3ZhbGlkKQorCQkJCQkJc2VxX3ByaW50ZihtLCAiLCB2YWxp
ZCBkaXJlbnRzIik7CisJCQkJCXNlcV9wcmludGYobSwgIlxuIik7CisJCQkJfQorCQkJCXNwaW5f
dW5sb2NrKCZjZmlkcy0+Y2ZpZF9saXN0X2xvY2spOworCisKKwkJCX0KKwkJfQorCX0KKwlzcGlu
X3VubG9jaygmY2lmc190Y3Bfc2VzX2xvY2spOworCXNlcV9wdXRjKG0sICdcbicpOworCXJldHVy
biAwOworfQorCiBzdGF0aWMgX19hbHdheXNfaW5saW5lIGNvbnN0IGNoYXIgKmNvbXByZXNzaW9u
X2FsZ19zdHIoX19sZTE2IGFsZykKIHsKIAlzd2l0Y2ggKGFsZykgewpAQCAtODYzLDYgKzkxMiw5
IEBAIGNpZnNfcHJvY19pbml0KHZvaWQpCiAJcHJvY19jcmVhdGVfc2luZ2xlKCJvcGVuX2ZpbGVz
IiwgMDQwMCwgcHJvY19mc19jaWZzLAogCQkJY2lmc19kZWJ1Z19maWxlc19wcm9jX3Nob3cpOwog
CisJcHJvY19jcmVhdGVfc2luZ2xlKCJvcGVuX2RpcnMiLCAwNDAwLCBwcm9jX2ZzX2NpZnMsCisJ
CQljaWZzX2RlYnVnX2RpcnNfcHJvY19zaG93KTsKKwogCXByb2NfY3JlYXRlKCJTdGF0cyIsIDA2
NDQsIHByb2NfZnNfY2lmcywgJmNpZnNfc3RhdHNfcHJvY19vcHMpOwogCXByb2NfY3JlYXRlKCJj
aWZzRllJIiwgMDY0NCwgcHJvY19mc19jaWZzLCAmY2lmc0ZZSV9wcm9jX29wcyk7CiAJcHJvY19j
cmVhdGUoInRyYWNlU01CIiwgMDY0NCwgcHJvY19mc19jaWZzLCAmdHJhY2VTTUJfcHJvY19vcHMp
OwpAQCAtOTA3LDYgKzk1OSw3IEBAIGNpZnNfcHJvY19jbGVhbih2b2lkKQogCiAJcmVtb3ZlX3By
b2NfZW50cnkoIkRlYnVnRGF0YSIsIHByb2NfZnNfY2lmcyk7CiAJcmVtb3ZlX3Byb2NfZW50cnko
Im9wZW5fZmlsZXMiLCBwcm9jX2ZzX2NpZnMpOworCXJlbW92ZV9wcm9jX2VudHJ5KCJvcGVuX2Rp
cnMiLCBwcm9jX2ZzX2NpZnMpOwogCXJlbW92ZV9wcm9jX2VudHJ5KCJjaWZzRllJIiwgcHJvY19m
c19jaWZzKTsKIAlyZW1vdmVfcHJvY19lbnRyeSgidHJhY2VTTUIiLCBwcm9jX2ZzX2NpZnMpOwog
CXJlbW92ZV9wcm9jX2VudHJ5KCJTdGF0cyIsIHByb2NfZnNfY2lmcyk7Ci0tIAoyLjQzLjAKCg==
--000000000000a5b637063b00be26--
