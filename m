Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A6F3101C7
	for <linux-cifs@vger.kernel.org>; Fri, 14 Nov 2025 11:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763118792; cv=none; b=gig7jtxLGLx2sBePm3dSFQd+sGLb2Us886/ar7g62TjIGto5ifMMJVtYiYOzeRt5Kb8gtQPDP43s2zSTrkvTk9K0ZO+LNnb5fvn2f2490SavvKE05xZxq1eZMbVlMM1CgKbMhiYrCMgNVHjhyTMShs7rkvDsky8xKO4DIDqi3e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763118792; c=relaxed/simple;
	bh=bAgORK140BCOoPts81bvdOCQ4xebZQtHJ6ukEdn/87o=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=qjxVk9cRFDmeMIYTj8bMpCq/GHeqfYBMjEovFCGcNDYEGXFbPT/0I9DhvhZN0Kwig8gkMjHid2UukWYWHiADiD8o5yjXkyUjEoqQXbxandSREI1tQR9Q8F4MuzxR8uWPcn742pxOPjczmh7T4U3mk2P7s4NfEa66SreU0aYYDTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DyuuoSSu; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DyuuoSSu"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b728a43e410so288835366b.1
        for <linux-cifs@vger.kernel.org>; Fri, 14 Nov 2025 03:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763118789; x=1763723589; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Mh4Mk1yxckbu/p0rvDobdu9WJsmny3IThhR3JaUCccU=;
        b=DyuuoSSuvreOYenc4ZZzSNqdVmA8MU2iMFs3GIAqJY/5IGbU9xlS1vKgzIOUumi0RZ
         3yMdFBjXu3fbC3PvqPH7hqXOldiBxogFqUDfxKJzEr5tyZRYu2PJ0h4BILW03qa1FLSQ
         VZweFExToglKTWCegyLvGnKyutQQfDJUhrLyrBXrsuxnOZVsH9xk2zdwUZfAP/7ofjpZ
         o5qUqrRv3QD/ErR3Hcm32+n6xl3xEny9+OFhTp5XVWjYZUFeNvz25ahllMxdNOdiNM8g
         1oryA8wALvAoppDNWadENIWHXct0KY+72SUM1MuMhLXy8aezYI1QZpS0ILPH1+KSGv2K
         qKCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763118789; x=1763723589;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mh4Mk1yxckbu/p0rvDobdu9WJsmny3IThhR3JaUCccU=;
        b=KHafDg4v+QxmCkARx4h9o02m4ocxXEos58lGiAma6tGoqBBiDRGfYPPZDHSe/k3eM7
         Zl2uSaSSXoZOh7C69kZ6923kLYLZhJ7Ews03fJ4MR9+QZMxx0ElNeeIBuMPQefW4Ta8j
         i7GLO01wLzfA7ch03/ml+jT9WbxkQ84YJ0kxRpzJjUnmjEWxx64rgILG2lKvqOAinsXV
         WNiYXSTxtU350oaoUdiWP1cRYWUv9lUKO4wpB6k/rB8/Q0t1eSvBjtR60L9ddbrXgUKU
         V2knfPL/Kv5aC5xw8geVSjImQHtfOWLcBueo6nacvw1bvItQ7YCp+kBHArFxKO4GkKM4
         YuEg==
X-Forwarded-Encrypted: i=1; AJvYcCXvMc7oRq9Cc0qjgjohs/Cw8aEaDqCsFonrlp7bl6mfOMDCMGDZ+siKalHrwRI+ZsMPK/qyZj6a/AFp@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6NUdAw2sEiABwxPQp5mKWTYhNxqHWvLrFaeRZUeBJsUDZWI/Z
	cRo7haX16t3FhYjn/qR9H50Qbz92dJch4L/dIngwa1MdQRrtAB7w8JV47XHpGLcRBkSiKm6ay7d
	ShP65dc6GwCIZedzz9o/cLrqfIw3CL8w=
X-Gm-Gg: ASbGnct8M3Vb2xRMuOwGe0gu3rBG2oUZWU6NaFGubgHETo9dSjq5OF3y583qzhV5Asq
	wOTVqoR34sTOrOo1u1Vv6tsJLZArJyngni9KLGqcqOTo1g6OsX6aEozm/mWOGiPp0A1GmSCNtx0
	VM5g9FVo9tu6VuAYSk9qRj3ppi/yenvzLJiGTfLNVzMcQuXfqqXr74+cpFZx2urNuuL9IVBOFIQ
	o3ren9en7zEGN/RWVpT/6DEest3ouFX7xm7Mx4N65lZxbFo4XZr/aylQrk=
X-Google-Smtp-Source: AGHT+IGXrbTEAb+PBdpHLmmrI+IoFY0SrYRM/lkGoa9ng52CX6HL4inNcJmvChl5zf8PR1QVXEmLmLc41jRdlBj7fNM=
X-Received: by 2002:a17:907:3f93:b0:b72:9d0b:defa with SMTP id
 a640c23a62f3a-b7367b8e1c7mr229443366b.41.1763118788694; Fri, 14 Nov 2025
 03:13:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 14 Nov 2025 16:42:57 +0530
X-Gm-Features: AWmQ_bkx5qCvGqr2U3QJg2wGAW6axzR8qwaJl3s7Zh3obH1YcHwp2KC4TNUNWLs
Message-ID: <CANT5p=q22P+zXHW2vH-n+W-zRe7ZWNORgh9gvoUOGpV6VMF8Fg@mail.gmail.com>
Subject: Request to backport data corruption fix to stable
To: Greg KH <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc: David Howells <dhowells@redhat.com>, Bharath SM <bharathsm.hsk@gmail.com>, 
	Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Enzo Matsumiya <ematsumiya@suse.de>
Content-Type: multipart/mixed; boundary="000000000000191e0806438c1524"

--000000000000191e0806438c1524
Content-Type: text/plain; charset="UTF-8"

Hi Greg/Sasha,

Over the last few months, a few users have reported a data corruption
with Linux SMB kernel client filesystem. This is one such report:
https://lore.kernel.org/linux-cifs/36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de/

The issue is now well understood. Attached is a fix for this issue.
I've made sure that the fix is stopping the data corruption and also
not regressing other write patterns.

The regression seems to have been introduced during a refactoring of
this code path during the v6.3 and continued to exist till v6.9,
before the code was refactored again with netfs helper library
integration in v6.10.

I request you to include this change in all stable trees for
v6.3..v6.9. I've done my testing on stable-6.6. Please let me know if
you want this tested on any other kernels.

-- 
Regards,
Shyam

--000000000000191e0806438c1524
Content-Type: application/octet-stream; 
	name="0001-cifs-stop-writeback-extension-when-change-of-size-is.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-stop-writeback-extension-when-change-of-size-is.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mhyre4l60>
X-Attachment-Id: f_mhyre4l60

RnJvbSBjNDQ5NGY3YWQ3YzBkZDQ2YjY3ZGM2NzA1ODUwNzI3OGU1NmM5MzExIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBGcmksIDE0IE5vdiAyMDI1IDE0OjMwOjU1ICswNTMwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogc3RvcCB3cml0ZWJhY2sgZXh0ZW5zaW9uIHdoZW4gY2hhbmdlIG9mIHNpemUgaXMKIGRl
dGVjdGVkCgpjaWZzX2V4dGVuZF93cml0ZWJhY2sgY2FuIHBpY2sgdXAgYSBmb2xpbyBvbiBhbiBl
eHRlbmRpbmcgd3JpdGUgd2hpY2gKaGFzIGJlZW4gZGlydGllZCwgYnV0IHdlIGhhdmUgYWNsYW1w
IG9uIHRoZSB3cml0ZWJhY2sgdG8gYW4gaV9zaXplCmxvY2FsIHZhcmlhYmxlLCB3aGljaCBjYW4g
Y2F1c2Ugc2hvcnQgd3JpdGVzLCB5ZXQgbWFyayB0aGUgcGFnZSBhcyBjbGVhbi4KVGhpcyBjYW4g
Y2F1c2UgYSBkYXRhIGNvcnJ1cHRpb24uCgpBcyBhbiBleGFtcGxlLCBjb25zaWRlciB0aGlzIHNj
ZW5hcmlvOgoxLiBGaXJzdCB3cml0ZSB0byB0aGUgZmlsZSBoYXBwZW5zIG9mZnNldCAwIGxlbiA1
ay4KMi4gV3JpdGViYWNrIHN0YXJ0cyBmb3IgdGhlIHJhbmdlICgwLTVrKS4KMy4gV3JpdGViYWNr
IGxvY2tzIHBhZ2UgMSBpbiBjaWZzX3dyaXRlcGFnZXNfYmVnaW4uIEJ1dCBkb2VzIG5vdCBsb2Nr
CnBhZ2UgMiB5ZXQuCjQuIFBhZ2UgMiBpcyBub3cgd3JpdHRlbiB0byBieSB0aGUgbmV4dCB3cml0
ZSwgd2hpY2ggZXh0ZW5kcyB0aGUgZmlsZQpieSBhbm90aGVyIDVrLiBQYWdlIDIgYW5kIDMgYXJl
IG5vdyBtYXJrZWQgZGlydHkuCjUuIE5vdyB3ZSByZWFjaCBjaWZzX2V4dGVuZF93cml0ZWJhY2ss
IHdoZXJlIHdlIGV4dGVuZCB0byBpbmNsdWRlIHRoZQpuZXh0IGZvbGlvIChldmVuIGlmIGl0IHNo
b3VsZCBiZSBwYXJ0aWFsbHkgd3JpdHRlbikuIFdlIHdpbGwgbWFyayBwYWdlCjIgZm9yIHdyaXRl
YmFjay4KNi4gQnV0IGFmdGVyIGV4aXRpbmcgY2lmc19leHRlbmRfd3JpdGViYWNrLCB3ZSB3aWxs
IGNsYW1wIHRoZQp3cml0ZWJhY2sgdG8gaV9zaXplLCB3aGljaCB3YXMgNWsgd2hlbiBpdCBzdGFy
dGVkLiBTbyB3ZSB3cml0ZSBvbmx5IDFrCmJ5dGVzIGluIHBhZ2UgMi4KNy4gV2Ugc3RpbGwgd2ls
bCBub3cgbWFyayBwYWdlIDIgYXMgZmx1c2hlZCBhbmQgbWFyayBpdCBjbGVhbi4gU28KcmVtYWlu
aW5nIGNvbnRlbnRzIG9mIHBhZ2UgMiB3aWxsIG5vdCBiZSB3cml0dGVuIHRvIHRoZSBzZXJ2ZXIg
KGhlbmNlCnRoZSBob2xlIGluIHRoYXQgZ2FwLCB1bmxlc3MgdGhhdCByYW5nZSBnZXRzIG92ZXJ3
cml0dGVuKS4KCldpdGggdGhpcyBwYXRjaCwgd2Ugd2lsbCBtYWtlIHN1cmUgbm90IGV4dGVuZCB0
aGUgd3JpdGViYWNrIGFueW1vcmUKd2hlbiBhIGNoYW5nZSBpbiB0aGUgZmlsZSBzaXplIGlzIGRl
dGVjdGVkLgoKVGhpcyBmaXggYWxzbyBjaGFuZ2VzIHRoZSBlcnJvciBoYW5kbGluZyBvZiBjaWZz
X2V4dGVuZF93cml0ZWJhY2sgd2hlbgphIGZvbGlvIGdldCBmYWlscy4gV2Ugd2lsbCBub3cgc3Rv
cCB0aGUgZXh0ZW5zaW9uIHdoZW4gYSBmb2xpbyBnZXQgZmFpbHMuCgpDYzogc3RhYmxlQGtlcm5l
bC5vcmcgIyB2Ni4zfnY2LjkKU2lnbmVkLW9mZi1ieTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRA
bWljcm9zb2Z0LmNvbT4KQWNrZWQtYnk6IERhdmlkIEhvd2VsbHMgPGRob3dlbGxzQHJlZGhhdC5j
b20+ClJlcG9ydGVkLWJ5OiBNYXJrIEEgV2hpdGluZyA8d2hpdGluZ21Ab3BlbnRleHQuY29tPgpT
aWduZWQtb2ZmLWJ5OiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPgotLS0K
IGZzL3NtYi9jbGllbnQvZmlsZS5jIHwgMTggKysrKysrKysrKysrKysrLS0tCiAxIGZpbGUgY2hh
bmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9z
bWIvY2xpZW50L2ZpbGUuYyBiL2ZzL3NtYi9jbGllbnQvZmlsZS5jCmluZGV4IDdhMmI4MWZiZDlj
ZmQuLmNjMmJhMmIxOGM4ZDQgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvZmlsZS5jCisrKyBi
L2ZzL3NtYi9jbGllbnQvZmlsZS5jCkBAIC0yNzQ3LDggKzI3NDcsMTAgQEAgc3RhdGljIHZvaWQg
Y2lmc19leHRlbmRfd3JpdGViYWNrKHN0cnVjdCBhZGRyZXNzX3NwYWNlICptYXBwaW5nLAogCQkJ
CSAgbG9mZl90IHN0YXJ0LAogCQkJCSAgaW50IG1heF9wYWdlcywKIAkJCQkgIGxvZmZfdCBtYXhf
bGVuLAotCQkJCSAgc2l6ZV90ICpfbGVuKQorCQkJCSAgc2l6ZV90ICpfbGVuLAorCQkJCSAgdW5z
aWduZWQgbG9uZyBsb25nIGlfc2l6ZSkKIHsKKwlzdHJ1Y3QgaW5vZGUgKmlub2RlID0gbWFwcGlu
Zy0+aG9zdDsKIAlzdHJ1Y3QgZm9saW9fYmF0Y2ggYmF0Y2g7CiAJc3RydWN0IGZvbGlvICpmb2xp
bzsKIAl1bnNpZ25lZCBpbnQgbnJfcGFnZXM7CkBAIC0yNzc5LDcgKzI3ODEsNyBAQCBzdGF0aWMg
dm9pZCBjaWZzX2V4dGVuZF93cml0ZWJhY2soc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcs
CiAKIAkJCWlmICghZm9saW9fdHJ5X2dldChmb2xpbykpIHsKIAkJCQl4YXNfcmVzZXQoeGFzKTsK
LQkJCQljb250aW51ZTsKKwkJCQlicmVhazsKIAkJCX0KIAkJCW5yX3BhZ2VzID0gZm9saW9fbnJf
cGFnZXMoZm9saW8pOwogCQkJaWYgKG5yX3BhZ2VzID4gbWF4X3BhZ2VzKSB7CkBAIC0yNzk5LDYg
KzI4MDEsMTUgQEAgc3RhdGljIHZvaWQgY2lmc19leHRlbmRfd3JpdGViYWNrKHN0cnVjdCBhZGRy
ZXNzX3NwYWNlICptYXBwaW5nLAogCQkJCXhhc19yZXNldCh4YXMpOwogCQkJCWJyZWFrOwogCQkJ
fQorCisJCQkvKiBpZiBmaWxlIHNpemUgaXMgY2hhbmdpbmcsIHN0b3AgZXh0ZW5kaW5nICovCisJ
CQlpZiAoaV9zaXplX3JlYWQoaW5vZGUpICE9IGlfc2l6ZSkgeworCQkJCWZvbGlvX3VubG9jayhm
b2xpbyk7CisJCQkJZm9saW9fcHV0KGZvbGlvKTsKKwkJCQl4YXNfcmVzZXQoeGFzKTsKKwkJCQli
cmVhazsKKwkJCX0KKwogCQkJaWYgKCFmb2xpb190ZXN0X2RpcnR5KGZvbGlvKSB8fAogCQkJICAg
IGZvbGlvX3Rlc3Rfd3JpdGViYWNrKGZvbGlvKSkgewogCQkJCWZvbGlvX3VubG9jayhmb2xpbyk7
CkBAIC0yOTMwLDcgKzI5NDEsOCBAQCBzdGF0aWMgc3NpemVfdCBjaWZzX3dyaXRlX2JhY2tfZnJv
bV9sb2NrZWRfZm9saW8oc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcsCiAKIAkJCWlmICht
YXhfcGFnZXMgPiAwKQogCQkJCWNpZnNfZXh0ZW5kX3dyaXRlYmFjayhtYXBwaW5nLCB4YXMsICZj
b3VudCwgc3RhcnQsCi0JCQkJCQkgICAgICBtYXhfcGFnZXMsIG1heF9sZW4sICZsZW4pOworCQkJ
CQkJICAgICAgbWF4X3BhZ2VzLCBtYXhfbGVuLCAmbGVuLAorCQkJCQkJICAgICAgaV9zaXplKTsK
IAkJfQogCX0KIAlsZW4gPSBtaW5fdCh1bnNpZ25lZCBsb25nIGxvbmcsIGxlbiwgaV9zaXplIC0g
c3RhcnQpOwotLSAKMi40My4wCgo=
--000000000000191e0806438c1524--
