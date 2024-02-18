Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545CC7318D
	for <linux-cifs@vger.kernel.org>; Sun, 18 Feb 2024 22:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708297156; cv=none; b=gCa/ljzLWDOWdLAWF9ENu1ePL/6UDnvB2s/+EyOPewkNE2edK7XYBW6/BpiFytZvSYe27pB3Kx2Ub1t17uprkgSTJ7EIx2gtCAZPCcN+V7GxHqwsuU2CN6M70UrZqSuXnEId6C4WwNS6o+8ErNQZ7lzxHtH0O2PchzYxqS75GIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708297156; c=relaxed/simple;
	bh=FHobt3f2OmqeBLIXE2KZQBOVXpzTY/zCxzn4eay6wv0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mf68AA6rowvTwzx8LJJ3RKYB/P+wNoCQn1gREV69GHABuXSL8e1dluyXOz5LP8kgM20RDY3ofqlwL4mK9JmP2Hv21lz9zg332oWjHJHMqXWfJLi2n39Xn/jfKb8Ka2FaO1De7p3Ro9YpC5OpcV7crpWIFnXAtCRbUsqJVVtvoqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HeWoGVds; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HeWoGVds"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-512b42b6697so233558e87.1
        for <linux-cifs@vger.kernel.org>; Sun, 18 Feb 2024 14:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708297152; x=1708901952; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PJStQiGaJ+jH9PubL79gJDxuqbSjwZnORRggih+N8+s=;
        b=HeWoGVdsmPyOiT9Wfkn3wrzfIc8Sfb00yD18C0SQUDE8pjj5qxTRl75zGRDLKYrinM
         Qyrz6NPMQLKH+LOKws8eeaQdNaFd9fJ48QdNRnxutBcaUEfk6UMkvoPyvgfql2CKJHMr
         WA4ummesaxj92d/vhehS5z2GdZYx9lzBvG7+Y0gT5Y316RyJudbPbvltvCDXF93tDtnG
         6u4YyGtEutWDcPOuyMeK2jcypGi5eJjQt793waEVSaIwb0pQ/pHnWBAJjQ5UogPRiT76
         v7xr7qAQg2KNcRmIfg2S27q5a8O1W5f3xWnQLLhxAZv2UCGW1HFlkdyKeyKYi+LJKoLG
         f9oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708297152; x=1708901952;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PJStQiGaJ+jH9PubL79gJDxuqbSjwZnORRggih+N8+s=;
        b=KTComyggtfvf9O4CNxJu/BWG91zreapN9ijGCR4PS53O+S0fijH42dQQMjroXfMFgP
         yynF6TMAz7Pq1AMUCekNVqtu5X18hmGWvlX9Gu7nbnoSBTy1o4qg0eTqutiY1w/+3Gur
         p3V1Saj/7Sc27ur0QBiXjVHoL9joDRf63rzzmyIAsq1NQttpbJAYy7zB3xuGPySPxB3e
         vOqwH9CcO0BLjm/faujOS4aQk2TQGUhOBf5aarmB7ztxrz2krfrK2RxazqGnwLuu9lC2
         odRdeTctAY86Hpbpz0Ghr2Z2KpKAlGlcn+rqsitOnoHkFnLWLfBGqnIdrBBXjaaXrwDE
         gW2w==
X-Forwarded-Encrypted: i=1; AJvYcCXHoNWxtsE0bxj74VuCTNig/U0LIzK6omeUWplvbt6JEPJ23BD6N0LfTcKpK/lwKh85eSGNlQg7pfvtufx3JdMo7CeWe2dxo6aBxg==
X-Gm-Message-State: AOJu0YzadQ12PdH0XV7EA6Z8GSvgwijAAliXFpyN6QZt/XOWW8XkzBc3
	GcZm+Uh21QMkgk27c06LDC0Q8gH2aKwl2GJV3T7QBwW1ErQiCxp3wDhTL6n3a5HQBRI2GMKoNuX
	bSSrzDFbP+LekH4paCoTS3BNfeYk=
X-Google-Smtp-Source: AGHT+IE9B3DeA/q8nwkc6xTaYIVZt6lFyTmxu/9gjnK6Vr+shYELPkszBDeGP7XTy1PHWnm42bQusXJqylXoxtkqtvQ=
X-Received: by 2002:a05:6512:242:b0:511:75a7:1513 with SMTP id
 b2-20020a056512024200b0051175a71513mr6622525lfo.67.1708297152228; Sun, 18 Feb
 2024 14:59:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtUnLDtwbW7or=Uc+AXkzLpHsJoPuoLE7yyjPVYjvZCow@mail.gmail.com>
 <CANT5p=oNRF9BAgybCX7dE+KvYj=k2G3tERa+fMJOY6tsuZ00Hw@mail.gmail.com> <bc2eaf5b9eafe2134820d1ea8c07e43f@manguebit.com>
In-Reply-To: <bc2eaf5b9eafe2134820d1ea8c07e43f@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 18 Feb 2024 16:59:00 -0600
Message-ID: <CAH2r5mtSB0nDKxAJHtnp6USgoeVN7hNF79NaOcX_pnF5MVPFhA@mail.gmail.com>
Subject: Re: [WIP PATCH] allow changing the password on remount in some cases
To: Paulo Alcantara <pc@manguebit.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Bharath S M <bharathsm@microsoft.com>, Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, 
	David Howells <dhowells@redhat.com>, samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000ee07a90611afec49"

--000000000000ee07a90611afec49
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Updated the patch to allow remount to only change the password if
disconnected and the session fails to reconnect due to continued
access denied or password expired errors.

Any thoughts on whether I should add another patch to throttle
repeated session setups after access denied or key expired (currently
looks like repeated every few seconds) maybe double the time
repeatedly (e.g. until a max of 10 or 20 or 30 seconds? between
reconnect attempts) instead of every two seconds.

On Fri, Feb 16, 2024 at 8:41=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > need_recon would also be true in other cases, for example when the
> > network is temporarily disconnected. This patch will allow changing of
> > password even then.
> > We could setup a special flag when the server returns a
> > STATUS_LOGON_FAILURE for SessionSetup. We can make the check for that
> > flag and then allow password change on remount.
>
> Yes.  Allowing password change over remount simply because network is
> disconnected is not a good idea.  The user could mistype the password
> when performing a remount and then everything would stop working.
>
> Not to mention that this patch is only handling a specfic case where a
> mount would have a single SMB session, which isn't true for a DFS mount.
>
> > Another option is to extend the multiuser keyring mechanism for single
> > user use case as well, and use that for password update.
> > Ideally, we should be able to setup multiple passwords in that keyring
> > and iterate through them once to see if SessionSetup goes through.
>
> Yes, sounds like the best approach so far.  It would allow users to
> update their passwords in keyring and sysadmins could drop existing SMB
> sessions from server side and then the client would reconnect by using
> new password from keyring.  This wouldn't even require a remount.
>
> Besides, marking this for -stable makes no sense.



--=20
Thanks,

Steve

--000000000000ee07a90611afec49
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-allow-changing-password-during-remount.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-allow-changing-password-during-remount.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lss3y42n0>
X-Attachment-Id: f_lss3y42n0

RnJvbSAwYWIwYTVmZWQ0NzYzNGNlZjJhNDliODBhMzUxOTc4ODBhYTk2NjU4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMTMgRmViIDIwMjQgMDA6NDA6MDEgLTA2MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBhbGxvdyBjaGFuZ2luZyBwYXNzd29yZCBkdXJpbmcgcmVtb3VudAoKVGhlcmUgYXJlIGNh
c2VzIHdoZXJlIGEgc2Vzc2lvbiBpcyBkaXNjb25uZWN0ZWQgYW5kIHBhc3N3b3JkIGhhcyBjaGFu
Z2VkCm9uIHRoZSBzZXJ2ZXIgKG9yIGV4cGlyZWQpIGZvciB0aGlzIHVzZXIgYW5kIHRoaXMgY3Vy
cmVudGx5IGNhbiBub3QKYmUgZml4ZWQgd2l0aG91dCB1bm1vdW50IGFuZCBtb3VudGluZyBhZ2Fp
bi4gIFRoaXMgcGF0Y2ggYWxsb3dzCnJlbW91bnQgdG8gY2hhbmdlIHRoZSBwYXNzd29yZCB3aGVu
IHRoZSBzZXNzaW9uIGlzIGRpc2Nvbm5lY3RlZAphbmQgdGhlIHVzZXIgY2FuIG5vdCByZWNvbm5l
Y3QgZHVlIHRvIHN0aWxsIHVzaW5nIG9sZCBwYXNzd29yZC4KCkZ1dHVyZSBwYXRjaGVzIHNob3Vs
ZCBhbHNvIGFsbG93IHVzIHRvIHNldHVwIHRoZSBrZXlyaW5nIChjaWZzY3JlZHMpCnRvIGhhdmUg
YW4gImFsdGVybmF0ZSBwYXNzd29yZCIgc28gd2Ugd291bGQgYmUgYWJsZSB0byBjaGFuZ2UKdGhl
IHBhc3N3b3JkIGJlZm9yZSB0aGUgc2Vzc2lvbiBkcm9wcyAod2l0aG91dCB0aGUgcmlzayBvZiBy
YWNlcwpiZXR3ZWVuIHdoZW4gdGhlIHBhc3N3b3JkIGNoYW5nZXMgYW5kIHRoZSBkaXNjb25uZWN0
IG9jY3VycyAtCmllIGNhc2VzIHdoZXJlIHRoZSBvbGQgcGFzc3dvcmQgaXMgc3RpbGwgbmVlZGVk
IGJlY2F1c2UgdGhlIG5ldwpwYXNzd29yZCBoYXMgbm90IGZ1bGx5IHJvbGxlZCBvdXQgdG8gYWxs
IHNlcnZlcnMgeWV0KS4KCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6
IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50
L2NpZnNfZGVidWcuYyB8ICAyICsrCiBmcy9zbWIvY2xpZW50L2NpZnNnbG9iLmggICB8ICAxICsK
IGZzL3NtYi9jbGllbnQvZnNfY29udGV4dC5jIHwgMjMgKysrKysrKysrKysrKysrKysrLS0tLS0K
IGZzL3NtYi9jbGllbnQvc21iMnBkdS5jICAgIHwgIDUgKysrKysKIDQgZmlsZXMgY2hhbmdlZCwg
MjYgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xp
ZW50L2NpZnNfZGVidWcuYyBiL2ZzL3NtYi9jbGllbnQvY2lmc19kZWJ1Zy5jCmluZGV4IDNlNDIw
OWY0MWMxOC4uMjNkMjYyMmI5NjlmIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2NpZnNfZGVi
dWcuYworKysgYi9mcy9zbWIvY2xpZW50L2NpZnNfZGVidWcuYwpAQCAtNDg4LDYgKzQ4OCw4IEBA
IHN0YXRpYyBpbnQgY2lmc19kZWJ1Z19kYXRhX3Byb2Nfc2hvdyhzdHJ1Y3Qgc2VxX2ZpbGUgKm0s
IHZvaWQgKnYpCiAJCQkJc2VzLT5zZXNfY291bnQsIHNlcy0+c2VydmVyT1MsIHNlcy0+c2VydmVy
Tk9TLAogCQkJCXNlcy0+Y2FwYWJpbGl0aWVzLCBzZXMtPnNlc19zdGF0dXMpOwogCQkJfQorCQkJ
aWYgKHNlcy0+ZXhwaXJlZF9wd2QpCisJCQkJc2VxX3B1dHMobSwgInBhc3N3b3JkIG5vIGxvbmdl
ciB2YWxpZCAiKTsKIAkJCXNwaW5fdW5sb2NrKCZzZXMtPnNlc19sb2NrKTsKIAogCQkJc2VxX3By
aW50ZihtLCAiXG5cdFNlY3VyaXR5IHR5cGU6ICVzICIsCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xp
ZW50L2NpZnNnbG9iLmggYi9mcy9zbWIvY2xpZW50L2NpZnNnbG9iLmgKaW5kZXggNTNjNzVjZmIz
M2FiLi5lYzlhMjZiZDA1YTEgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvY2lmc2dsb2IuaAor
KysgYi9mcy9zbWIvY2xpZW50L2NpZnNnbG9iLmgKQEAgLTEwNjYsNiArMTA2Niw3IEBAIHN0cnVj
dCBjaWZzX3NlcyB7CiAJZW51bSBzZWN1cml0eUVudW0gc2VjdHlwZTsgLyogd2hhdCBzZWN1cml0
eSBmbGF2b3Igd2FzIHNwZWNpZmllZD8gKi8KIAlib29sIHNpZ247CQkvKiBpcyBzaWduaW5nIHJl
cXVpcmVkPyAqLwogCWJvb2wgZG9tYWluQXV0bzoxOworCWJvb2wgZXhwaXJlZF9wd2Q7ICAvKiB0
cmFjayBpZiBhY2Nlc3MgZGVuaWVkIG9yIGV4cGlyZWQgcHdkIHNvIGNhbiBrbm93IGlmIG5lZWQg
dG8gdXBkYXRlICovCiAJdW5zaWduZWQgaW50IGZsYWdzOwogCV9fdTE2IHNlc3Npb25fZmxhZ3M7
CiAJX191OCBzbWIzc2lnbmluZ2tleVtTTUIzX1NJR05fS0VZX1NJWkVdOwpkaWZmIC0tZ2l0IGEv
ZnMvc21iL2NsaWVudC9mc19jb250ZXh0LmMgYi9mcy9zbWIvY2xpZW50L2ZzX2NvbnRleHQuYwpp
bmRleCA0YjJmNWFhMmVhMGUuLjk5NzAyYWIwNWY4ZCAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVu
dC9mc19jb250ZXh0LmMKKysrIGIvZnMvc21iL2NsaWVudC9mc19jb250ZXh0LmMKQEAgLTc3Miw3
ICs3NzIsNyBAQCBzdGF0aWMgdm9pZCBzbWIzX2ZzX2NvbnRleHRfZnJlZShzdHJ1Y3QgZnNfY29u
dGV4dCAqZmMpCiAgKi8KIHN0YXRpYyBpbnQgc21iM192ZXJpZnlfcmVjb25maWd1cmVfY3R4KHN0
cnVjdCBmc19jb250ZXh0ICpmYywKIAkJCQkgICAgICAgc3RydWN0IHNtYjNfZnNfY29udGV4dCAq
bmV3X2N0eCwKLQkJCQkgICAgICAgc3RydWN0IHNtYjNfZnNfY29udGV4dCAqb2xkX2N0eCkKKwkJ
CQkgICAgICAgc3RydWN0IHNtYjNfZnNfY29udGV4dCAqb2xkX2N0eCwgYm9vbCBuZWVkX3JlY29u
KQogewogCWlmIChuZXdfY3R4LT5wb3NpeF9wYXRocyAhPSBvbGRfY3R4LT5wb3NpeF9wYXRocykg
ewogCQljaWZzX2Vycm9yZihmYywgImNhbiBub3QgY2hhbmdlIHBvc2l4cGF0aHMgZHVyaW5nIHJl
bW91bnRcbiIpOwpAQCAtNzk4LDggKzc5OCwxMSBAQCBzdGF0aWMgaW50IHNtYjNfdmVyaWZ5X3Jl
Y29uZmlndXJlX2N0eChzdHJ1Y3QgZnNfY29udGV4dCAqZmMsCiAJfQogCWlmIChuZXdfY3R4LT5w
YXNzd29yZCAmJgogCSAgICAoIW9sZF9jdHgtPnBhc3N3b3JkIHx8IHN0cmNtcChuZXdfY3R4LT5w
YXNzd29yZCwgb2xkX2N0eC0+cGFzc3dvcmQpKSkgewotCQljaWZzX2Vycm9yZihmYywgImNhbiBu
b3QgY2hhbmdlIHBhc3N3b3JkIGR1cmluZyByZW1vdW50XG4iKTsKLQkJcmV0dXJuIC1FSU5WQUw7
CisJCWlmIChuZWVkX3JlY29uID09IGZhbHNlKSB7CisJCQljaWZzX2Vycm9yZihmYywKKwkJCQkg
ICAgImNhbiBub3QgY2hhbmdlIHBhc3N3b3JkIG9mIGFjdGl2ZSBzZXNzaW9uIGR1cmluZyByZW1v
dW50XG4iKTsKKwkJCXJldHVybiAtRUlOVkFMOworCQl9CiAJfQogCWlmIChuZXdfY3R4LT5kb21h
aW5uYW1lICYmCiAJICAgICghb2xkX2N0eC0+ZG9tYWlubmFtZSB8fCBzdHJjbXAobmV3X2N0eC0+
ZG9tYWlubmFtZSwgb2xkX2N0eC0+ZG9tYWlubmFtZSkpKSB7CkBAIC04NDMsOSArODQ2LDE0IEBA
IHN0YXRpYyBpbnQgc21iM19yZWNvbmZpZ3VyZShzdHJ1Y3QgZnNfY29udGV4dCAqZmMpCiAJc3Ry
dWN0IHNtYjNfZnNfY29udGV4dCAqY3R4ID0gc21iM19mYzJjb250ZXh0KGZjKTsKIAlzdHJ1Y3Qg
ZGVudHJ5ICpyb290ID0gZmMtPnJvb3Q7CiAJc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiA9
IENJRlNfU0Iocm9vdC0+ZF9zYik7CisJc3RydWN0IGNpZnNfc2VzICpzZXMgPSBjaWZzX3NiX21h
c3Rlcl90Y29uKGNpZnNfc2IpLT5zZXM7CisJYm9vbCBuZWVkX3JlY29uID0gZmFsc2U7CiAJaW50
IHJjOwogCi0JcmMgPSBzbWIzX3ZlcmlmeV9yZWNvbmZpZ3VyZV9jdHgoZmMsIGN0eCwgY2lmc19z
Yi0+Y3R4KTsKKwlpZiAoc2VzLT5leHBpcmVkX3B3ZCkKKwkJbmVlZF9yZWNvbiA9IHRydWU7CisK
KwlyYyA9IHNtYjNfdmVyaWZ5X3JlY29uZmlndXJlX2N0eChmYywgY3R4LCBjaWZzX3NiLT5jdHgs
IG5lZWRfcmVjb24pOwogCWlmIChyYykKIAkJcmV0dXJuIHJjOwogCkBAIC04NTgsNyArODY2LDEy
IEBAIHN0YXRpYyBpbnQgc21iM19yZWNvbmZpZ3VyZShzdHJ1Y3QgZnNfY29udGV4dCAqZmMpCiAJ
U1RFQUxfU1RSSU5HKGNpZnNfc2IsIGN0eCwgVU5DKTsKIAlTVEVBTF9TVFJJTkcoY2lmc19zYiwg
Y3R4LCBzb3VyY2UpOwogCVNURUFMX1NUUklORyhjaWZzX3NiLCBjdHgsIHVzZXJuYW1lKTsKLQlT
VEVBTF9TVFJJTkdfU0VOU0lUSVZFKGNpZnNfc2IsIGN0eCwgcGFzc3dvcmQpOworCWlmIChuZWVk
X3JlY29uID09IGZhbHNlKQorCQlTVEVBTF9TVFJJTkdfU0VOU0lUSVZFKGNpZnNfc2IsIGN0eCwg
cGFzc3dvcmQpOworCWVsc2UgIHsKKwkJa2ZyZWVfc2Vuc2l0aXZlKHNlcy0+cGFzc3dvcmQpOwor
CQlzZXMtPnBhc3N3b3JkID0ga3N0cmR1cChjdHgtPnBhc3N3b3JkLCBHRlBfS0VSTkVMKTsKKwl9
CiAJU1RFQUxfU1RSSU5HKGNpZnNfc2IsIGN0eCwgZG9tYWlubmFtZSk7CiAJU1RFQUxfU1RSSU5H
KGNpZnNfc2IsIGN0eCwgbm9kZW5hbWUpOwogCVNURUFMX1NUUklORyhjaWZzX3NiLCBjdHgsIGlv
Y2hhcnNldCk7CmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYyBiL2ZzL3NtYi9j
bGllbnQvc21iMnBkdS5jCmluZGV4IDYwOGVlMDU0OTFlMi4uYTUwMDM4MGQxYjJlIDEwMDY0NAot
LS0gYS9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYworKysgYi9mcy9zbWIvY2xpZW50L3NtYjJwZHUu
YwpAQCAtMTUzNiw2ICsxNTM2LDExIEBAIFNNQjJfc2Vzc19zZW5kcmVjZWl2ZShzdHJ1Y3QgU01C
Ml9zZXNzX2RhdGEgKnNlc3NfZGF0YSkKIAkJCSAgICAmc2Vzc19kYXRhLT5idWYwX3R5cGUsCiAJ
CQkgICAgQ0lGU19MT0dfRVJST1IgfCBDSUZTX1NFU1NfT1AsICZyc3BfaW92KTsKIAljaWZzX3Nt
YWxsX2J1Zl9yZWxlYXNlKHNlc3NfZGF0YS0+aW92WzBdLmlvdl9iYXNlKTsKKwlpZiAocmMgPT0g
MCkKKwkJc2Vzc19kYXRhLT5zZXMtPmV4cGlyZWRfcHdkID0gZmFsc2U7CisJZWxzZSBpZiAoKHJj
ID09IC1FQUNDRVMpIHx8IChyYyA9PSAtRUtFWUVYUElSRUQpIHx8IChyYyA9PSAtRUtFWVJFVk9L
RUQpKQorCQlzZXNzX2RhdGEtPnNlcy0+ZXhwaXJlZF9wd2QgPSB0cnVlOworCiAJbWVtY3B5KCZz
ZXNzX2RhdGEtPmlvdlswXSwgJnJzcF9pb3YsIHNpemVvZihzdHJ1Y3Qga3ZlYykpOwogCiAJcmV0
dXJuIHJjOwotLSAKMi40MC4xCgo=
--000000000000ee07a90611afec49--
