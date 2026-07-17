Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85192369D48
	for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2026 03:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784258106; cv=none; b=TvtbX/4cHjnkaj8PUqMJLWm6LsWDr5UVqpl/m5kw/um9rvnSmW4sx1d1twzZNOSKZpw5/hKMdn2qh2uzzvuesWWHz7FR8vb3gTBzY0DlSfWngoRF4rECvsmWlX/nPbdPTLnfnTebQbH9mD1HEf5AxEF/cWXLQC/em7NPCDUEcY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784258106; c=relaxed/simple;
	bh=BJuS0YYPZyHflU3DPVe+FBfxFuTVEH6ELY/xGfl6VYw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YUo7lh2J630vB5yXLdmwhOabUpfnMkLxZ8r9dCpDQsQtyGM5V2OqiJYhhUY5gs+iz1IPBs12/0i0eZNRGwMXtIQlqBhUNA8nKWegpLAwP9VOM80XV0vPHjyUXXBBY/dmL80WxYbxge3GuzXs5o8+u3/zfTmquGpN36aFtJwJ914=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CC2dOrFV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CC2dOrFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292F81F000E9
	for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2026 03:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784258105;
	bh=nAeWg4Nk5xYpBIiu8qeFFLmJy7FREjcWqgxuh4ato40=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CC2dOrFV+D/S2LRVWbcyaDl7oez9k3ga/qVmIaZRGgzo0wWAWjmxJBKMUgzCrrmlm
	 0o6KlRw4AE+DJ5KY1YsVdCglquB3NNCPKuOvkpiaGlJWmTCmEajnpuVlwJI6GnzeG3
	 4KTzN7wUenjOF8PRwHZr8l+ykNPcFfeR5oJNvyl2LlbgOh95VZXDpNNAUyKGaTmb4f
	 sq7+XAH6gAenQLefg7tIrb7y1pxYAc+bjKK0a/rGuALwXrOXMDYugfiD1n4oJPQBJu
	 A0V/RZFPxhNL+p9AC/vuQls57USsdqYMnJugamKIDOAUbSOcj3bIw4J4jvR8JIdB1G
	 2rWlg/fIg8xhQ==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-698562f10e7so10358549a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 20:15:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpLq6uKGOLRbGPezz28TqsdXrMFmDaaKfIsrrBli0PXJWu7+T+vn/xxA7F/40mjMwP3DHxTa//LjHLf@vger.kernel.org
X-Gm-Message-State: AOJu0Yyy3Ry+8eTfnXgBta0dWgqYsgJkETCI4TAVTwm52VekfXMTxRNR
	B3dj823tRT9qgbwoaAO08Xrb02b256bnz1b5J/J0DkV/rVltuqT0GT2G4eBwPKpAbO5LfHHahsw
	cu1rG18WOb15/YLLRFF1Ed4EsVItHE4c=
X-Received: by 2002:a17:906:f58b:b0:c15:fd85:c5f7 with SMTP id
 a640c23a62f3a-c16b46abcefmr21730366b.4.1784258103774; Thu, 16 Jul 2026
 20:15:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPS2u-U9=kiKmL6oebRApGnp6jUMxSQ+zGW1px+A7r1QQny3iA@mail.gmail.com>
In-Reply-To: <CAPS2u-U9=kiKmL6oebRApGnp6jUMxSQ+zGW1px+A7r1QQny3iA@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 17 Jul 2026 12:14:51 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-4MuqT49GwTO2meR0Lt338vTygzTrQ+6xBNpVW7kE0Xg@mail.gmail.com>
X-Gm-Features: AUfX_mxyZJryiR51rz55WYQX7nKUbJYq8OMAk1i8taY6uUG_aLSaJo1R4NC0Xf0
Message-ID: <CAKYAXd-4MuqT49GwTO2meR0Lt338vTygzTrQ+6xBNpVW7kE0Xg@mail.gmail.com>
Subject: Re: [SECURITY] ksmbd: SMB CREATE widens inherited POSIX ACL masks
To: Charles Research <trilobyte777@gmail.com>
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, security@kernel.org
Content-Type: multipart/mixed; boundary="00000000000076c2a00656c5f690"

--00000000000076c2a00656c5f690
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2026 at 6:58=E2=80=AFAM Charles Research <trilobyte777@gmai=
l.com> wrote:
>
> Hello KSMBD maintainers,
Hi Charles,
>
> KSMBD widens an inherited POSIX ACL mask to rwx when an SMB client create=
s a file or directory. A named user or group entry that an administrator in=
tentionally made ineffective with a restrictive mask can therefore become e=
ffective on the new object. For a new directory, KSMBD also installs the wi=
dened ACL as the default ACL, so the exposure propagates to descendants.

Can you confirm if this patch fixes this issue?

Thanks for the report.

--00000000000076c2a00656c5f690
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-ksmbd-preserve-VFS-inherited-POSIX-ACL-mask.patch"
Content-Disposition: attachment; 
	filename="0001-ksmbd-preserve-VFS-inherited-POSIX-ACL-mask.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mrod72kj0>
X-Attachment-Id: f_mrod72kj0

RnJvbSA3ZmM2YTcyN2M2NjU4N2I4MjZiYmRjYmFjOWQ3MWJlZWY1NDE3MTYxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOYW1qYWUgSmVvbiA8bGlua2luamVvbkBrZXJuZWwub3JnPgpE
YXRlOiBGcmksIDE3IEp1bCAyMDI2IDExOjA2OjQ1ICswOTAwClN1YmplY3Q6IFtQQVRDSCAxLzNd
IGtzbWJkOiBwcmVzZXJ2ZSBWRlMgaW5oZXJpdGVkIFBPU0lYIEFDTCBtYXNrCgpUaGUgVkZTIGlu
aXRpYWxpemVzIGEgY2hpbGQncyBQT1NJWCBBQ0wgZnJvbSB0aGUgcGFyZW50J3MgZGVmYXVsdCBB
Q0wgYW5kCnRoZSByZXF1ZXN0ZWQgY3JlYXRpb24gbW9kZS4gRG8gbm90IG11dGF0ZSB0aGUgcGFy
ZW50IEFDTCBvciBvdmVyd3JpdGUgdGhlCmNoaWxkJ3MgVkZTLWNvbXB1dGVkIGFjY2VzcyBhbmQg
ZGVmYXVsdCBBQ0xzIGFmdGVyd2FyZHMuCgpUaGlzIHByZXNlcnZlcyByZXN0cmljdGl2ZSBBQ0xf
TUFTSyBlbnRyaWVzIGFuZCBwcmV2ZW50cyBTTUIgb2JqZWN0IGNyZWF0aW9uCmZyb20gd2lkZW5p
bmcgZWZmZWN0aXZlIHBlcm1pc3Npb25zLgoKUmVwb3J0ZWQtYnk6IENoYXJsZXMgUmVzZWFyY2gg
PHRyaWxvYnl0ZTc3N0BnbWFpbC5jb20+ClNpZ25lZC1vZmYtYnk6IE5hbWphZSBKZW9uIDxsaW5r
aW5qZW9uQGtlcm5lbC5vcmc+Ci0tLQogZnMvc21iL3NlcnZlci92ZnMuYyB8IDI2ICstLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDI1IGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9zZXJ2ZXIvdmZzLmMgYi9mcy9zbWIvc2Vy
dmVyL3Zmcy5jCmluZGV4IGRiYWE4Mzg4Nzc3NS4uODU0YTA5MDIwYTk3IDEwMDY0NAotLS0gYS9m
cy9zbWIvc2VydmVyL3Zmcy5jCisrKyBiL2ZzL3NtYi9zZXJ2ZXIvdmZzLmMKQEAgLTIxNTAsMTAg
KzIxNTAsNiBAQCBpbnQga3NtYmRfdmZzX2luaGVyaXRfcG9zaXhfYWNsKHN0cnVjdCBtbnRfaWRt
YXAgKmlkbWFwLAogCQkJCWNvbnN0IHN0cnVjdCBwYXRoICpwYXRoLCBzdHJ1Y3QgaW5vZGUgKnBh
cmVudF9pbm9kZSkKIHsKIAlzdHJ1Y3QgcG9zaXhfYWNsICphY2xzOwotCXN0cnVjdCBwb3NpeF9h
Y2xfZW50cnkgKnBhY2U7Ci0Jc3RydWN0IGRlbnRyeSAqZGVudHJ5ID0gcGF0aC0+ZGVudHJ5Owot
CXN0cnVjdCBpbm9kZSAqaW5vZGUgPSBkX2lub2RlKGRlbnRyeSk7Ci0JaW50IHJjLCBpOwogCiAJ
aWYgKCFJU19FTkFCTEVEKENPTkZJR19GU19QT1NJWF9BQ0wpKQogCQlyZXR1cm4gLUVPUE5PVFNV
UFA7CkBAIC0yMTYxLDI5ICsyMTU3LDkgQEAgaW50IGtzbWJkX3Zmc19pbmhlcml0X3Bvc2l4X2Fj
bChzdHJ1Y3QgbW50X2lkbWFwICppZG1hcCwKIAlhY2xzID0gZ2V0X2lub2RlX2FjbChwYXJlbnRf
aW5vZGUsIEFDTF9UWVBFX0RFRkFVTFQpOwogCWlmIChJU19FUlJfT1JfTlVMTChhY2xzKSkKIAkJ
cmV0dXJuIC1FTk9FTlQ7Ci0JcGFjZSA9IGFjbHMtPmFfZW50cmllczsKLQotCWZvciAoaSA9IDA7
IGkgPCBhY2xzLT5hX2NvdW50OyBpKyssIHBhY2UrKykgewotCQlpZiAocGFjZS0+ZV90YWcgPT0g
QUNMX01BU0spIHsKLQkJCXBhY2UtPmVfcGVybSA9IDB4MDc7Ci0JCQlicmVhazsKLQkJfQotCX0K
LQotCXJjID0gc2V0X3Bvc2l4X2FjbChpZG1hcCwgZGVudHJ5LCBBQ0xfVFlQRV9BQ0NFU1MsIGFj
bHMpOwotCWlmIChyYyA8IDApCi0JCWtzbWJkX2RlYnVnKFNNQiwgIlNldCBwb3NpeCBhY2woQUNM
X1RZUEVfQUNDRVNTKSBmYWlsZWQsIHJjIDogJWRcbiIsCi0JCQkgICAgcmMpOwotCWlmIChTX0lT
RElSKGlub2RlLT5pX21vZGUpKSB7Ci0JCXJjID0gc2V0X3Bvc2l4X2FjbChpZG1hcCwgZGVudHJ5
LCBBQ0xfVFlQRV9ERUZBVUxULAotCQkJCSAgIGFjbHMpOwotCQlpZiAocmMgPCAwKQotCQkJa3Nt
YmRfZGVidWcoU01CLCAiU2V0IHBvc2l4IGFjbChBQ0xfVFlQRV9ERUZBVUxUKSBmYWlsZWQsIHJj
IDogJWRcbiIsCi0JCQkJICAgIHJjKTsKLQl9CiAKIAlwb3NpeF9hY2xfcmVsZWFzZShhY2xzKTsK
LQlyZXR1cm4gcmM7CisJcmV0dXJuIDA7CiB9CiAKIHZvaWQga3NtYmRfdmZzX3VwZGF0ZV9jb21w
cmVzc2VkX2ZhdHRyKHN0cnVjdCBkZW50cnkgKmRlbnRyeSwgX19sZTMyICpmYXR0cikKLS0gCjIu
MjUuMQoK
--00000000000076c2a00656c5f690--
