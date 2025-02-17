Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0516B81E;
	Mon, 17 Feb 2025 04:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739766412; cv=none; b=AEtVyVN4U5wdjIlc6VkY8dRTGLvggjqMopERuCT7+WT6AD5CKp9lbtsA0G7IHM+ZplU2AzYrqmHz5jMlrGI7YBcAMXkFxQ0Vb4778mfu8J0ys7fuZo3zO++8MkuTQoruvqIjhBCiQnmLy4rspdGCxzZVNFvGYnkdgMprzrC4O50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739766412; c=relaxed/simple;
	bh=Je4qMd8uH868SAaJ3kXnO1UyGOhEPE3/E1kfSyE4EVU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TllzBpX9+9QYDmW/APqLv5euNNAgfvLOOwBOGpSTq/wIe2lkLmnt+fr7+I3z8QRc2aJE6F3HHg1uM5N6ja4jxx3Nu8qyD/oDarVhNmn0uR8I/vNOqvQLXB5ijbpBwExKDwAmreJiEv0LwBKWOUgZAj0zm8+wNCZIM9XNeY4pu+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OXDR5IjG; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OXDR5IjG"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5439e331cceso4709264e87.1;
        Sun, 16 Feb 2025 20:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739766409; x=1740371209; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AAnCoc/ealkT3eEmQbJGFEG9pfRpmLAEj8exnbx1OaU=;
        b=OXDR5IjG2de5Fb1WpYQH++7kLgQKLocIKBMMlNrewY4uxU4sQM+KlWXO8U9wHMlkwm
         8jV5GYkLs9f7SRVnlRalLQ9wi9N4OO2vUhJeu+kRVn3tvK+YDTgZE5MOn3vJvUa6MjoT
         4NSK/oFnDA3Ez8m+ShnPcF7Huzvv9ZFcGEfUkZQ/YAB5NjuY+IRltK/UEsWsD++kba9K
         mXTfoOXTP+Ll78+zanLujNQ39GdjvEx01SvkkpVZgqgpU2JqGmIG4QMTdgeuVxYO2+Kw
         yqkfvwFz1Q4Z3h3FWxzrSMT4rMRLec5vMlZa26XwPI1Df7EVLnl2rkNROr5eXLIGtEoF
         AAqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739766409; x=1740371209;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AAnCoc/ealkT3eEmQbJGFEG9pfRpmLAEj8exnbx1OaU=;
        b=uA7IogkaE5GcUBwT6iq5zCQnnGu3RJoQ893uFU5c8JUmJGArTnWMrJtCw+D3zyHIk8
         gvMFX7BKdAiEi9TtJqTXxhUz8PXKKgy206foUlgYHySH/zjN3Eds1mWbfqbQj6+SGlFp
         aP44fJBHpqmsWkOCjThPArWO6H4bEoul4EHcMxFw1wKulU7xW4fo1sHi59VlFPb/uCmj
         X6CRy4Szb1IifnAI7/SKPC+IAGfNtCf5y7eEgBNe1wGPkTAJGY0rPgJDrVgj9FIuD2KC
         vLq43r6UlxNszirPoFPpv/1+pQdU34Uh8qSF+rVPRLM39H7OsEsavFy9wlqjVZzm8OiI
         mPsw==
X-Forwarded-Encrypted: i=1; AJvYcCWYcnavwrqzg5r1q+LO4c3XuYtBV5Vrv3drNB7TguMa0LBhYBRCy7OFN1Y8N/8yVtiRjUHPgM/FmXUORSE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnA8s1o/fHXftoAnGc3uubNjFHOiHZbNstdvMLeWn2Rxel9MCc
	EgQp8n/WEI6gkTx8Abzip8s5CcohcdgrK5ejD3ZVAMeWijceeB5pIFXV0ejYAPcveMjDUi4BjpH
	f2fMIldpkYkziwHzdSTKH6XkuwOV4MA==
X-Gm-Gg: ASbGncv+mmUPkh/outtCpbbLRInD7mK8P9WzMJQfbaHTPACn5BBkrPG1Ybxby1BOXX4
	hdFqMMrIRgomqG4pWEtmeShc6nzMb7tSuGlz7vfFb9KFlZJbbM/mpJn42VzItVygp0ENMSWWpJe
	kfMjxQNG7K78h84tpMowFjvRexklBK/OI=
X-Google-Smtp-Source: AGHT+IFh+DGORDLqNcQMLOJ8ut4vThStw/QPnw/VLePjL6L8sO676dwFaZ0tfkraDhJ++E2q+VHoB87YU3EvuHjcWpA=
X-Received: by 2002:a05:6512:34cd:b0:545:3037:a73a with SMTP id
 2adb3069b0e04-5453037a749mr1845577e87.13.1739766408625; Sun, 16 Feb 2025
 20:26:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPhCUnV5ocw5HfW+jNRaRPgntoM4uXeHNcC03XL00wLZjSm1Vw@mail.gmail.com>
In-Reply-To: <CAPhCUnV5ocw5HfW+jNRaRPgntoM4uXeHNcC03XL00wLZjSm1Vw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 16 Feb 2025 22:26:36 -0600
X-Gm-Features: AWEUYZmefMo6Pfyz08OXuz6lmMAMKGswFgrp6gcNOSABsqTsrunyD2lzwkVt4SY
Message-ID: <CAH2r5muHVDfWM6vmRx85S2zfgh6v7mjc-ekOpkqJaLFvV9x1mA@mail.gmail.com>
Subject: Re: Bug in getting file attributes with SMB3.1.1 and posix
To: Oleh Nykyforchyn <oleh.nyk@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000c75c81062e4eeef6"

--000000000000c75c81062e4eeef6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Oleh,
Good catch, and sorry about the delay (email had gotten missed).

Here is a fix (see attached) for the problem you reported.  Let me
know if it also works for you or if you see any problems with it.

This is important fix for SMB3.1.1 POSIX Extensions client implementation.


On Wed, Jan 1, 2025 at 11:05=E2=80=AFAM Oleh Nykyforchyn <oleh.nyk@gmail.co=
m> wrote:
>
> Hello,
>
> I encountered a funny bug when a share is mounted with vers=3D3.1.1, posi=
x,... If a file size has bits 0x410 =3D ATTR_DIRECTORY | ATTR_REPARSE =3D 1=
040 set, then the file is regarded as a directory and its open fails. A sim=
plest test example is any file 1040 bytes long.
>
> The cause of this bug is that Attributes field in smb2_file_all_info stru=
ct occupies the same place that EndOfFile field in smb311_posix_qinfo, and =
sometimes the latter struct is incorrectly processed as if it was the first=
 one. I attach an example patch that solves the problem for me, obviously n=
ot ready for submission, but just to show which places in the code are subj=
ect to problems. The patch is against linux-6.12.6 kernel, but, AFAICS, not=
hing has changed since then in relevant places. If I have guessed more or l=
ess correctly what the intended functionality is, please feel free to use m=
y patch as a basis for corrections.
>
> Best regards
>
> Olen Nykyforchyn



--=20
Thanks,

Steve

--000000000000c75c81062e4eeef6
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb311-failure-to-open-files-of-length-1040-when-mou.patch"
Content-Disposition: attachment; 
	filename="0001-smb311-failure-to-open-files-of-length-1040-when-mou.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m78jyr6y0>
X-Attachment-Id: f_m78jyr6y0

RnJvbSA1NDBiMGViZDE3NmFkMzQyNjQ0Nzk4OTQ3MTUzYWVkMzVkNWI5Y2FiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMTYgRmViIDIwMjUgMjI6MTc6NTQgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzMTE6IGZhaWx1cmUgdG8gb3BlbiBmaWxlcyBvZiBsZW5ndGggMTA0MCB3aGVuIG1vdW50aW5n
CiB3aXRoIFNNQjMuMS4xIFBPU0lYIGV4dGVuc2lvbnMKCklmIGEgZmlsZSBzaXplIGhhcyBiaXRz
IDB4NDEwID0gQVRUUl9ESVJFQ1RPUlkgfCBBVFRSX1JFUEFSU0Ugc2V0CnRoZW4gZHVyaW5nIHF1
ZXJ5aW5mbyAoc3RhdCkgdGhlIGZpbGUgaXMgcmVnYXJkZWQgYXMgYSBkaXJlY3RvcnkKYW5kIHN1
YnNlcXVlbnQgb3BlbnMgY2FuIGZhaWwuIEEgc2ltcGxlIHRlc3QgZXhhbXBsZSBpcyB0cnlpbmcK
dG8gb3BlbiBhbnkgZmlsZSAxMDQwIGJ5dGVzIGxvbmcgd2hlbiBtb3VudGluZyB3aXRoICJwb3Np
eCIKKFNNQjMuMS4xIFBPU0lYL0xpbnV4IEV4dGVuc2lvbnMpLgoKVGhlIGNhdXNlIG9mIHRoaXMg
YnVnIGlzIHRoYXQgQXR0cmlidXRlcyBmaWVsZCBpbiBzbWIyX2ZpbGVfYWxsX2luZm8Kc3RydWN0
IG9jY3VwaWVzIHRoZSBzYW1lIHBsYWNlIHRoYXQgRW5kT2ZGaWxlIGZpZWxkIGluCnNtYjMxMV9w
b3NpeF9xaW5mbywgYW5kIHNvbWV0aW1lcyB0aGUgbGF0dGVyIHN0cnVjdCBpcyBpbmNvcnJlY3Rs
eQpwcm9jZXNzZWQgYXMgaWYgaXQgd2FzIHRoZSBmaXJzdCBvbmUuCgpSZXBvcnRlZC1ieTogT2xl
aCBOeWt5Zm9yY2h5biA8b2xlaC5ueWtAZ21haWwuY29tPgpDYzogc3RhYmxlQHZnZXIua2VybmVs
Lm9yZwpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
Ci0tLQogZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oICB8ICAxICsKIGZzL3NtYi9jbGllbnQvcmVw
YXJzZS5oICAgfCAyOCArKysrKysrKysrKysrKysrKysrKysrLS0tLS0tCiBmcy9zbWIvY2xpZW50
L3NtYjJpbm9kZS5jIHwgIDQgKysrKwogZnMvc21iL2NsaWVudC9zbWIyb3BzLmMgICB8ICAzICsr
LQogNCBmaWxlcyBjaGFuZ2VkLCAyOSBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvY2lmc2dsb2IuaCBiL2ZzL3NtYi9jbGllbnQvY2lmc2ds
b2IuaAppbmRleCBhYzFmODkwYTBkNTQuLmZjYzVkOTVlZDJjZCAxMDA2NDQKLS0tIGEvZnMvc21i
L2NsaWVudC9jaWZzZ2xvYi5oCisrKyBiL2ZzL3NtYi9jbGllbnQvY2lmc2dsb2IuaApAQCAtMjUz
LDYgKzI1Myw3IEBAIHN0cnVjdCBjaWZzX2NyZWQgewogc3RydWN0IGNpZnNfb3Blbl9pbmZvX2Rh
dGEgewogCWJvb2wgYWRqdXN0X3R6OwogCWJvb2wgcmVwYXJzZV9wb2ludDsKKwlib29sIGNvbnRh
aW5zX3Bvc2l4X2ZpbGVfaW5mbzsKIAlzdHJ1Y3QgewogCQkvKiBpb2N0bCByZXNwb25zZSBidWZm
ZXIgKi8KIAkJc3RydWN0IHsKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvcmVwYXJzZS5oIGIv
ZnMvc21iL2NsaWVudC9yZXBhcnNlLmgKaW5kZXggNWE3NTNmZWM3ZTJjLi5jMGJlNWFiNDVhNzgg
MTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvcmVwYXJzZS5oCisrKyBiL2ZzL3NtYi9jbGllbnQv
cmVwYXJzZS5oCkBAIC05OSwxNCArOTksMzAgQEAgc3RhdGljIGlubGluZSBib29sIHJlcGFyc2Vf
aW5vZGVfbWF0Y2goc3RydWN0IGlub2RlICppbm9kZSwKIAogc3RhdGljIGlubGluZSBib29sIGNp
ZnNfb3Blbl9kYXRhX3JlcGFyc2Uoc3RydWN0IGNpZnNfb3Blbl9pbmZvX2RhdGEgKmRhdGEpCiB7
Ci0Jc3RydWN0IHNtYjJfZmlsZV9hbGxfaW5mbyAqZmkgPSAmZGF0YS0+Zmk7Ci0JdTMyIGF0dHJz
ID0gbGUzMl90b19jcHUoZmktPkF0dHJpYnV0ZXMpOworCXUzMiBhdHRyczsKIAlib29sIHJldDsK
IAotCXJldCA9IGRhdGEtPnJlcGFyc2VfcG9pbnQgfHwgKGF0dHJzICYgQVRUUl9SRVBBUlNFKTsK
LQlpZiAocmV0KQotCQlhdHRycyB8PSBBVFRSX1JFUEFSU0U7Ci0JZmktPkF0dHJpYnV0ZXMgPSBj
cHVfdG9fbGUzMihhdHRycyk7CisJaWYgKGRhdGEtPmNvbnRhaW5zX3Bvc2l4X2ZpbGVfaW5mbykg
eworCQlzdHJ1Y3Qgc21iMzExX3Bvc2l4X3FpbmZvICpmaSA9ICZkYXRhLT5wb3NpeF9maTsKKwor
CQlhdHRycyA9IGxlMzJfdG9fY3B1KGZpLT5Eb3NBdHRyaWJ1dGVzKTsKKwkJaWYgKGRhdGEtPnJl
cGFyc2VfcG9pbnQpIHsKKwkJCWF0dHJzIHw9IEFUVFJfUkVQQVJTRTsKKwkJCWZpLT5Eb3NBdHRy
aWJ1dGVzID0gY3B1X3RvX2xlMzIoYXR0cnMpOworCQl9CisKKwl9IGVsc2UgeworCQlzdHJ1Y3Qg
c21iMl9maWxlX2FsbF9pbmZvICpmaSA9ICZkYXRhLT5maTsKKworCQlhdHRycyA9IGxlMzJfdG9f
Y3B1KGZpLT5BdHRyaWJ1dGVzKTsKKwkJaWYgKGRhdGEtPnJlcGFyc2VfcG9pbnQpIHsKKwkJCWF0
dHJzIHw9IEFUVFJfUkVQQVJTRTsKKwkJCWZpLT5BdHRyaWJ1dGVzID0gY3B1X3RvX2xlMzIoYXR0
cnMpOworCQl9CisJfQorCisJcmV0ID0gYXR0cnMgJiBBVFRSX1JFUEFSU0U7CisKIAlyZXR1cm4g
cmV0OwogfQogCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L3NtYjJpbm9kZS5jIGIvZnMvc21i
L2NsaWVudC9zbWIyaW5vZGUuYwppbmRleCA1ZGZiMzBiMGE4NTIuLjgyNmI1N2E1YTJhOCAxMDA2
NDQKLS0tIGEvZnMvc21iL2NsaWVudC9zbWIyaW5vZGUuYworKysgYi9mcy9zbWIvY2xpZW50L3Nt
YjJpbm9kZS5jCkBAIC02NTAsNiArNjUwLDcgQEAgc3RhdGljIGludCBzbWIyX2NvbXBvdW5kX29w
KGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCXN3aXRj
aCAoY21kc1tpXSkgewogCQljYXNlIFNNQjJfT1BfUVVFUllfSU5GTzoKIAkJCWlkYXRhID0gaW5f
aW92W2ldLmlvdl9iYXNlOworCQkJaWRhdGEtPmNvbnRhaW5zX3Bvc2l4X2ZpbGVfaW5mbyA9IGZh
bHNlOwogCQkJaWYgKHJjID09IDAgJiYgY2ZpbGUgJiYgY2ZpbGUtPnN5bWxpbmtfdGFyZ2V0KSB7
CiAJCQkJaWRhdGEtPnN5bWxpbmtfdGFyZ2V0ID0ga3N0cmR1cChjZmlsZS0+c3ltbGlua190YXJn
ZXQsIEdGUF9LRVJORUwpOwogCQkJCWlmICghaWRhdGEtPnN5bWxpbmtfdGFyZ2V0KQpAQCAtNjcz
LDYgKzY3NCw3IEBAIHN0YXRpYyBpbnQgc21iMl9jb21wb3VuZF9vcChjb25zdCB1bnNpZ25lZCBp
bnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJYnJlYWs7CiAJCWNhc2UgU01CMl9P
UF9QT1NJWF9RVUVSWV9JTkZPOgogCQkJaWRhdGEgPSBpbl9pb3ZbaV0uaW92X2Jhc2U7CisJCQlp
ZGF0YS0+Y29udGFpbnNfcG9zaXhfZmlsZV9pbmZvID0gdHJ1ZTsKIAkJCWlmIChyYyA9PSAwICYm
IGNmaWxlICYmIGNmaWxlLT5zeW1saW5rX3RhcmdldCkgewogCQkJCWlkYXRhLT5zeW1saW5rX3Rh
cmdldCA9IGtzdHJkdXAoY2ZpbGUtPnN5bWxpbmtfdGFyZ2V0LCBHRlBfS0VSTkVMKTsKIAkJCQlp
ZiAoIWlkYXRhLT5zeW1saW5rX3RhcmdldCkKQEAgLTc3MCw2ICs3NzIsNyBAQCBzdGF0aWMgaW50
IHNtYjJfY29tcG91bmRfb3AoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNv
biAqdGNvbiwKIAkJCQlpZGF0YSA9IGluX2lvdltpXS5pb3ZfYmFzZTsKIAkJCQlpZGF0YS0+cmVw
YXJzZS5pby5pb3YgPSAqaW92OwogCQkJCWlkYXRhLT5yZXBhcnNlLmlvLmJ1ZnR5cGUgPSByZXNw
X2J1ZnR5cGVbaSArIDFdOworCQkJCWlkYXRhLT5jb250YWluc19wb3NpeF9maWxlX2luZm8gPSBm
YWxzZTsgLyogQkIgVkVSSUZZICovCiAJCQkJcmJ1ZiA9IHJlcGFyc2VfYnVmX3B0cihpb3YpOwog
CQkJCWlmIChJU19FUlIocmJ1ZikpIHsKIAkJCQkJcmMgPSBQVFJfRVJSKHJidWYpOwpAQCAtNzkx
LDYgKzc5NCw3IEBAIHN0YXRpYyBpbnQgc21iMl9jb21wb3VuZF9vcChjb25zdCB1bnNpZ25lZCBp
bnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQljYXNlIFNNQjJfT1BfUVVFUllfV1NM
X0VBOgogCQkJaWYgKCFyYykgewogCQkJCWlkYXRhID0gaW5faW92W2ldLmlvdl9iYXNlOworCQkJ
CWlkYXRhLT5jb250YWluc19wb3NpeF9maWxlX2luZm8gPSBmYWxzZTsKIAkJCQlxaV9yc3AgPSBy
c3BfaW92W2kgKyAxXS5pb3ZfYmFzZTsKIAkJCQlkYXRhWzBdID0gKHU4ICopcWlfcnNwICsgbGUx
Nl90b19jcHUocWlfcnNwLT5PdXRwdXRCdWZmZXJPZmZzZXQpOwogCQkJCXNpemVbMF0gPSBsZTMy
X3RvX2NwdShxaV9yc3AtPk91dHB1dEJ1ZmZlckxlbmd0aCk7CmRpZmYgLS1naXQgYS9mcy9zbWIv
Y2xpZW50L3NtYjJvcHMuYyBiL2ZzL3NtYi9jbGllbnQvc21iMm9wcy5jCmluZGV4IGVjMzZiZWQ1
NGIwYi4uMjNlMGM4YmU3ZmI1IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L3NtYjJvcHMuYwor
KysgYi9mcy9zbWIvY2xpZW50L3NtYjJvcHMuYwpAQCAtMTAwMSw2ICsxMDAxLDcgQEAgc3RhdGlj
IGludCBzbWIyX3F1ZXJ5X2ZpbGVfaW5mbyhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3Qg
Y2lmc190Y29uICp0Y29uLAogCQlpZiAoIWRhdGEtPnN5bWxpbmtfdGFyZ2V0KQogCQkJcmV0dXJu
IC1FTk9NRU07CiAJfQorCWRhdGEtPmNvbnRhaW5zX3Bvc2l4X2ZpbGVfaW5mbyA9IGZhbHNlOwog
CXJldHVybiBTTUIyX3F1ZXJ5X2luZm8oeGlkLCB0Y29uLCBmaWQtPnBlcnNpc3RlbnRfZmlkLCBm
aWQtPnZvbGF0aWxlX2ZpZCwgJmRhdGEtPmZpKTsKIH0KIApAQCAtNTE0Niw3ICs1MTQ3LDcgQEAg
aW50IF9fY2lmc19zZnVfbWFrZV9ub2RlKHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBpbm9kZSAq
aW5vZGUsCiAJCQkgICAgIEZJTEVfQ1JFQVRFLCBDUkVBVEVfTk9UX0RJUiB8CiAJCQkgICAgIENS
RUFURV9PUFRJT05fU1BFQ0lBTCwgQUNMX05PX01PREUpOwogCW9wYXJtcy5maWQgPSAmZmlkOwot
CisJaWRhdGEuY29udGFpbnNfcG9zaXhfZmlsZV9pbmZvID0gZmFsc2U7CiAJcmMgPSBzZXJ2ZXIt
Pm9wcy0+b3Blbih4aWQsICZvcGFybXMsICZvcGxvY2ssICZpZGF0YSk7CiAJaWYgKHJjKQogCQln
b3RvIG91dDsKLS0gCjIuNDMuMAoK
--000000000000c75c81062e4eeef6--
