Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F3214E2F8
	for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 17:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714067597; cv=none; b=W3d33iSKo82ThQY7vmuPwbXdLISEHKvF4doQOz3I8YhzcHQMtXD3Zh1N+yfIUixB/nuVGl9N35/RD50nc4+TSIbY6PdIEnsQvIxOhBppfFJdVAUWfGOEnIKpxbK2tZe8HhN0T6sbElf9xNwwhDp7TGuWwzzgZiKUo+nTf3/2hUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714067597; c=relaxed/simple;
	bh=jePIY0GWTHS5NevjdpMkRw73tLdLucyLgoR6rQ3OsK8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b2UxbxmKkO6wdSwaY1VjSvKaS+ig+LKr5FWq5iEEkBGbspy8atf8R8XrNZJjmZu0P41UhPYObAvtGh2Zo+0Z7UOF/aUvPVb2pRpV4/sfLkTwsqTl5NnLVsALeaFUw3vAZK9Jk+RX8kJC9BuTUeCw6JruClPRQT8eL6xy7yHObCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mWHn2cOb; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mWHn2cOb"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-51acb95b892so1584487e87.2
        for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 10:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714067594; x=1714672394; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bmr3ZtLJo2znmdgAUICAgu9O85UOhrp8OGxzM/2OO/4=;
        b=mWHn2cObGBKMlu1bqNgsiQ3/S/yy2Uj64QyzLFtvCDiYcEWbfl8Bmfoh43XbkkXzBG
         5s6AWmC7R/pbkvm2cxIdUZZWz+LajVsUsRvKf1/rGBm4yUxR9qn7LKxreDKsckI+3p5H
         qBFkLc3pd9odeUWU/t3Ix6SwEvN0/g/jtS0iq5K/3TBiH4PelZY+67hKUGNXxRR9ccsQ
         NhRBR5ccwzYcldubbqR5bM2fuf6Wt2etRwNgpJTkewTLZdeqeVTUNQWtlT+mQ83RyTYz
         2R+oNZ5tlWo5eC325f9ty9YdXx1YfQaF0MzbhY38Uz9Ere39b1rY0aPNphLEpIeeIa2v
         oKZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714067594; x=1714672394;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bmr3ZtLJo2znmdgAUICAgu9O85UOhrp8OGxzM/2OO/4=;
        b=Bqrpe4xrKc+SbRf/k30LUPSFvtGRhVnQY/dSEc3ihMdoGCBgohoTsehzmcO4q43Iaj
         JAaNlrMdUfrxwldkX2ehdNA4usIZBJyk2MwQn/nxcJ8CNxx0VhkaNAeDzo6xnZRIVJhQ
         GqUf19B9TrU2jd31/g0XQ35t8s3gF4e6lrgDXey0fR4wYwUr0B0Y3fSuZET7kwpvtW5w
         a9tbTEVlcfISfNeNRUNmU2hPbqO+eeuy8iEB+6/R92hoZa4P7PfesuOr6k5NqNF3XmNG
         epAISyS1b2SqQekvKVke7BcwjviqPWW8Jh8BIY19S9f803eN3roFGnCYgvoVpetUuuJx
         y0Rw==
X-Gm-Message-State: AOJu0Yw3aF1pxlqT7ntRG2SOgoQ+BNRxPG7vkYDJSwoBEdnbKcM7tXe+
	0zF/qWIQPrUpJsp2SkFJ3cetYn9q6x2avHoop8NALJY1g5BZ7oudunoglJfvEtu5tGFWzcsCyT2
	SO/yUzphQGs8ZLzHRnGOQpQTfcduM+A==
X-Google-Smtp-Source: AGHT+IFmr//pinTC+20XMd3uXCMaIkzhlU2dUKF4+R7A1ultctOelN9NDqnV4hbzcQ1hBDDFzY4SPInt19TWOUsUpGM=
X-Received: by 2002:a19:5e09:0:b0:516:c5c2:cba8 with SMTP id
 s9-20020a195e09000000b00516c5c2cba8mr60740lfb.12.1714067593697; Thu, 25 Apr
 2024 10:53:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtJuttkzHDQB=-U3o=bBnv5U9r2w+JG-mXg1TPBT1wFog@mail.gmail.com>
 <CANT5p=qE_6xA7qML6f5i+0i7ZpD43QcT6vKsWqm+wdpc8VyoRQ@mail.gmail.com>
In-Reply-To: <CANT5p=qE_6xA7qML6f5i+0i7ZpD43QcT6vKsWqm+wdpc8VyoRQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 25 Apr 2024 12:53:00 -0500
Message-ID: <CAH2r5msVPRhSEAte28KZpZa_6S7thwUS4L7gDEK_-1hiwESDhQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] fix potential deadlock in cifs_sync_mid_result
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Enzo Matsumiya <ematsumiya@suse.de>, 
	Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000000b3c4a0616ef7640"

--0000000000000b3c4a0616ef7640
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Minor update to patch (shrink slightly by using a goto)


On Thu, Apr 25, 2024 at 12:44=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail=
.com> wrote:
>
> On Wed, Apr 24, 2024 at 9:16=E2=80=AFAM Steve French <smfrench@gmail.com>=
 wrote:
> >
> > Coverity spotted that the cifs_sync_mid_result function could deadlock
> > since cifs_server_dbg graps the srv_lock while we are still holding
> > the mid_lock
> >
> > "Thread deadlock (ORDER_REVERSAL) lock_order: Calling spin_lock acquire=
s
> > lock TCP_Server_Info.srv_lock while holding lock TCP_Server_Info.mid_lo=
ck"
> >
> > Addresses-Coverity: 1590401 ("Thread deadlock (ORDER_REVERSAL)")
> >
> > See attached patch
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
> Looks good to me.
>
> --
> Regards,
> Shyam



--=20
Thanks,

Steve

--0000000000000b3c4a0616ef7640
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-lock-ordering-potential-deadlock-in-cifs_sy.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-lock-ordering-potential-deadlock-in-cifs_sy.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lvfjkv7t0>
X-Attachment-Id: f_lvfjkv7t0

RnJvbSA4ODYxZmQ1MTgwNDc2ZjQ1ZjllODg1M2RiMTU0NjAwNDY5YTAyODRmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjUgQXByIDIwMjQgMTI6NDk6NTAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBmaXggbG9jayBvcmRlcmluZyBwb3RlbnRpYWwgZGVhZGxvY2sgaW4KIGNpZnNfc3luY19t
aWRfcmVzdWx0CgpDb3Zlcml0eSBzcG90dGVkIHRoYXQgdGhlIGNpZnNfc3luY19taWRfcmVzdWx0
IGZ1bmN0aW9uIGNvdWxkIGRlYWRsb2NrCgoiVGhyZWFkIGRlYWRsb2NrIChPUkRFUl9SRVZFUlNB
TCkgbG9ja19vcmRlcjogQ2FsbGluZyBzcGluX2xvY2sgYWNxdWlyZXMKbG9jayBUQ1BfU2VydmVy
X0luZm8uc3J2X2xvY2sgd2hpbGUgaG9sZGluZyBsb2NrIFRDUF9TZXJ2ZXJfSW5mby5taWRfbG9j
ayIKCkFkZHJlc3Nlcy1Db3Zlcml0eTogMTU5MDQwMSAoIlRocmVhZCBkZWFkbG9jayAoT1JERVJf
UkVWRVJTQUwpIikKQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKUmV2aWV3ZWQtYnk6IFNoeWFt
IFByYXNhZCBOIDxzcHJhc2FkQG1pY3Jvc29mdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZy
ZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L3RyYW5zcG9y
dC5jIHwgMyArKysKIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQg
YS9mcy9zbWIvY2xpZW50L3RyYW5zcG9ydC5jIGIvZnMvc21iL2NsaWVudC90cmFuc3BvcnQuYwpp
bmRleCBlMWE3OWUwMzFiMjguLmRkZjFhM2FhZmVlNSAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVu
dC90cmFuc3BvcnQuYworKysgYi9mcy9zbWIvY2xpZW50L3RyYW5zcG9ydC5jCkBAIC05MDksMTIg
KzkwOSwxNSBAQCBjaWZzX3N5bmNfbWlkX3Jlc3VsdChzdHJ1Y3QgbWlkX3FfZW50cnkgKm1pZCwg
c3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQogCQkJbGlzdF9kZWxfaW5pdCgmbWlkLT5x
aGVhZCk7CiAJCQltaWQtPm1pZF9mbGFncyB8PSBNSURfREVMRVRFRDsKIAkJfQorCQlzcGluX3Vu
bG9jaygmc2VydmVyLT5taWRfbG9jayk7CiAJCWNpZnNfc2VydmVyX2RiZyhWRlMsICIlczogaW52
YWxpZCBtaWQgc3RhdGUgbWlkPSVsbHUgc3RhdGU9JWRcbiIsCiAJCQkgX19mdW5jX18sIG1pZC0+
bWlkLCBtaWQtPm1pZF9zdGF0ZSk7CiAJCXJjID0gLUVJTzsKKwkJZ290byBzeW5jX21pZF9kb25l
OwogCX0KIAlzcGluX3VubG9jaygmc2VydmVyLT5taWRfbG9jayk7CiAKK3N5bmNfbWlkX2RvbmU6
CiAJcmVsZWFzZV9taWQobWlkKTsKIAlyZXR1cm4gcmM7CiB9Ci0tIAoyLjQwLjEKCg==
--0000000000000b3c4a0616ef7640--
