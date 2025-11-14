Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF172DAFCA
	for <linux-cifs@vger.kernel.org>; Fri, 14 Nov 2025 18:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763145354; cv=none; b=k3U9R6ki5+GnSRV8KwwLdEuFtSJYhbBV0sBvTzT8q1ZVG8IFFvPy/wy+XtyuhOFtFtYcl3pJyRqAe1mfmJfAN0F338e7VhfMFA4YRwY70HBzZm7FtDYpImmvc17XnYPFLIzb9E7yOg05a36K8f1u2KsTD6JhucYvL7TfCn1LxZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763145354; c=relaxed/simple;
	bh=vmpverlYWByUa7QCWSbuQQll5bYAZw2btqiorYQkQH0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cauc2w8zhjpbQQGPCIv1cLO/togIYdYmJiaYiPcJbiCv45kkf4/5KKY1mT9G4IpssUnKFsvVWB1FTNahdOwy13Bh0ZnjqJVwt4TAf2l9PDhoG8HVpQ8DUJ0D3BAYUtG2yewbfvHGgkIQWE/NZGDT/9QkBcRqNIevtMOuvsS775s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xdzu3mBn; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xdzu3mBn"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-880570bdef8so21499356d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 14 Nov 2025 10:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763145351; x=1763750151; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W4H8PZZOpVJdIKF0SSAUTyybStzK+OZZ8HXjEkmPaFc=;
        b=Xdzu3mBn6Bt1l6Z6hlR6s9/FeULuXnPyddWM+141KuVXqW9gfx1x5HG81OMMRgmJP/
         Weyr9Elu8ScblusD7TAB+bYPVkCzKfXphK07+ZBIsimpq3mTtmSZkm0JW34ts1leOhrZ
         KuzA1IkQyYcA6ypWwbnvxFwwJHmKdjB/SlVg3WHkaDWb8AWRVZhrp7b52zuNl82LukQI
         vS1HhFQuiIIsYFvUD9bCXzi/50teFt4zLgPk+1TKuV//VJdJnnzCmN/kf4rxc8vLL15l
         gZrDhDVdkb6jR1eKqQPW0Og7PWNPQGrWLGUSO2IWIaNEfgIg+mfwT9wRjvcURSQQWq3G
         dUpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763145351; x=1763750151;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W4H8PZZOpVJdIKF0SSAUTyybStzK+OZZ8HXjEkmPaFc=;
        b=kiicqbUjA/SksPV58a3BaS9UR5tjjEnHAx1SQNh8IVZu9pqSB3I0t84riH6m0/AJaf
         bnyyyyvQJ7xnYiKy/m116bpfeVwOTObetsc5d7+7HLPKsCSYQojFCNsCKYAo0XVwQk5K
         iTYMboHErIcULiv07nkau+9pZuB0BB49FjSYbbYSJAULxczSZE7BelPwrhvqbCwm0G6e
         khWBrNUMvhIRHChGCwZlH/MqJxrxJRs1kDeELEc2yrn8tTRlP8NDWHS8sBLNBlzgLmqb
         fLi59u77Q8Q521W1n08ungOneuitBDMpjgOwq+5PSKS2ZfnP2rwfFudQNmlnbV7q7OTv
         S23w==
X-Forwarded-Encrypted: i=1; AJvYcCU85nZsLd9DjjsDvRTNc3D27+tBhTAnnGur/AlyWIoFlGTITUlLKjE5KhN15pPOltuzsLLcsSb1uXFx@vger.kernel.org
X-Gm-Message-State: AOJu0YxySA+Vq27fjWr2PKesT9YWdFJDYcKnlvKA81oRhk4F2f4MpbUp
	eBBiDNtAtVH3E9PFN3RidE2XIlUxQV84t4ZJUuzVuTRgN6/TuRNPhlcD25T0RzjidGvmmKpNBEC
	cwmU4GrdmVJR3O9SPdBGkktT6GKV6BJo=
X-Gm-Gg: ASbGncvBuGH4kTdRQQR8mU8+m19HwRXx7QRAvu2W945v/ZwaS0DOjotsBBqGIFLYWMT
	fKQt44jnZxfm3s0n8baUr2kDz0mZlOcX0Gx7c4Bkpk/lj520vPm37uDRaCPh5v35RiBXb0rgsZD
	N2ds1V/ET2U/aF3Cd48U2yr0FMTd4Z/WngHx1qlPPHJ18UUIjcRztyx+T4CNewiImPRPq/6dP5i
	hJA4V0rNHmNEoBp16GvRTd1yjse79BGkezeUbGNqOk/okE09F9l0bzwsNxYCuXJtTxwqXG9BbbM
	Eu5IvmbfkWMl0bpHQvxr8wXQkKQIwuXfUMmKst6aVQ22ZwGU16Hm0IbckKmNMSQbZLEgupqQnl7
	O+BzfSZv9lkxwubf+vLX+rjJx6lJsCAQYUSaXOw==
X-Google-Smtp-Source: AGHT+IEZjLPORvcK+LwmYRjmGNJlXzsQ0IRFSe1NgOpsl2/IX4xp6o9WlommjP3rHUzdj5KG1IU7olqYGkSbTEiHgCo=
X-Received: by 2002:a05:6214:e48:b0:882:3781:e29d with SMTP id
 6a1803df08f44-8829258ed06mr51288006d6.10.1763145351353; Fri, 14 Nov 2025
 10:35:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANT5p=q22P+zXHW2vH-n+W-zRe7ZWNORgh9gvoUOGpV6VMF8Fg@mail.gmail.com>
 <aRdEB6L0_vYwEsNT@laps>
In-Reply-To: <aRdEB6L0_vYwEsNT@laps>
From: Steve French <smfrench@gmail.com>
Date: Fri, 14 Nov 2025 12:35:39 -0600
X-Gm-Features: AWmQ_bmt5SPGCg2obnaq6WrGNW0E0951yE8a8wixEQK_iotVS0awhr5jnUtpk0w
Message-ID: <CAH2r5mus4Cp0jH4y=_5LDCiDftVOEZwVaJb1ZOq3Uze2G4Evpg@mail.gmail.com>
Subject: Re: Request to backport data corruption fix to stable
To: Sasha Levin <sashal@kernel.org>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, 
	David Howells <dhowells@redhat.com>, Bharath SM <bharathsm.hsk@gmail.com>, 
	CIFS <linux-cifs@vger.kernel.org>, Enzo Matsumiya <ematsumiya@suse.de>, 
	Stable <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000005bf917064392441e"

--0000000000005bf917064392441e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sasha,
Also wanted to make sure stable gets this patch from David Howells
that fixes a regression that was mentioned in some of the same email
threads.
It fixes an important stable regression in cifs_readv when cache=3Dnone.
  Bharath has also reviewed and tested it with 6.6 stable. See
attached.


On Fri, Nov 14, 2025 at 9:00=E2=80=AFAM Sasha Levin <sashal@kernel.org> wro=
te:
>
> On Fri, Nov 14, 2025 at 04:42:57PM +0530, Shyam Prasad N wrote:
> >Hi Greg/Sasha,
> >
> >Over the last few months, a few users have reported a data corruption
> >with Linux SMB kernel client filesystem. This is one such report:
> >https://lore.kernel.org/linux-cifs/36fb31bf2c854cdc930a3415f5551dcd@izw-=
berlin.de/
> >
> >The issue is now well understood. Attached is a fix for this issue.
> >I've made sure that the fix is stopping the data corruption and also
> >not regressing other write patterns.
> >
> >The regression seems to have been introduced during a refactoring of
> >this code path during the v6.3 and continued to exist till v6.9,
> >before the code was refactored again with netfs helper library
> >integration in v6.10.
> >
> >I request you to include this change in all stable trees for
> >v6.3..v6.9. I've done my testing on stable-6.6. Please let me know if
> >you want this tested on any other kernels.
>
> I'll queue it up for 6.6, thanks!
>
> --
> Thanks,
> Sasha



--
Thanks,

Steve

--0000000000005bf917064392441e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-Fix-uncached-read-into-ITER_KVEC-iterator.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Fix-uncached-read-into-ITER_KVEC-iterator.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mhz76xu90>
X-Attachment-Id: f_mhz76xu90

RnJvbSA1YzAyNjMzNWVlZjEwODA1YTNiNWQzNjI0YzQ2NGYyMzkzZjg1OWUyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBIb3dlbGxzIDxkaG93ZWxsc0ByZWRoYXQuY29tPgpE
YXRlOiBGcmksIDE0IE5vdiAyMDI1IDA2OjEzOjM1ICswMDAwClN1YmplY3Q6IFtQQVRDSF0gY2lm
czogRml4IHVuY2FjaGVkIHJlYWQgaW50byBJVEVSX0tWRUMgaXRlcmF0b3IKCklmIGEgY2lmcyBz
aGFyZSBpcyBtb3VudGVkIGNhY2hlPW5vbmUsIGludGVybmFsIHJlYWRzIChzdWNoIGFzIGJ5IGV4
ZWMpCndpbGwgcGFzcyBhIEtWRUMgaXRlcmF0b3IgZG93biBmcm9tIF9fY2lmc19yZWFkdigpIHRv
CmNpZnNfc2VuZF9hc3luY19yZWFkKCkgd2hpY2ggd2lsbCB0aGVuIGNhbGwgY2lmc19saW1pdF9i
dmVjX3N1YnNldCgpIHVwb24KaXQgdG8gbGltaXQgdGhlIG51bWJlciBvZiBjb250aWd1b3VzIGVs
ZW1lbnRzIGZvciBSRE1BIHB1cnBvc2VzLiAgVGhpcwpkb2Vzbid0IHdvcmsgb24gbm9uLUJWRUMg
aXRlcmF0b3JzLCBob3dldmVyLgoKRml4IHRoaXMgYnkgZXh0cmFjdGluZyBhIEtWRUMgaXRlcmF0
b3IgaW50byBhIEJWRUMgaXRlcmF0b3IgaW4KX19jaWZzX3JlYWR2KCkgIChpdCB3b3VsZCBiZSBk
dXAnZCBhbnl3YXkgaXQgYXN5bmMpLgoKVGhpcyBjYXVzZWQgdGhlIGZvbGxvd2luZyB3YXJuaW5n
OgoKICBXQVJOSU5HOiBDUFU6IDAgUElEOiA2MjkwIGF0IGZzL3NtYi9jbGllbnQvZmlsZS5jOjM1
NDkgY2lmc19saW1pdF9idmVjX3N1YnNldCsweGUvMHhjMAogIC4uLgogIENhbGwgVHJhY2U6CiAg
IDxUQVNLPgogICBjaWZzX3NlbmRfYXN5bmNfcmVhZCsweDE0Ni8weDJlMAogICBfX2NpZnNfcmVh
ZHYrMHgyMDcvMHgyZDAKICAgX19rZXJuZWxfcmVhZCsweGY2LzB4MTYwCiAgIHNlYXJjaF9iaW5h
cnlfaGFuZGxlcisweDQ5LzB4MjEwCiAgIGV4ZWNfYmlucHJtKzB4NGEvMHgxNDAKICAgYnBybV9l
eGVjdmUucGFydC4wKzB4ZTQvMHgxNzAKICAgZG9fZXhlY3ZlYXRfY29tbW9uLmlzcmEuMCsweDE5
Ni8weDFjMAogICBkb19leGVjdmUrMHgxZi8weDMwCgpGaXhlczogZDA4MDg5ZjY0OWEwICgiY2lm
czogQ2hhbmdlIHRoZSBJL08gcGF0aHMgdG8gdXNlIGFuIGl0ZXJhdG9yIHJhdGhlciB0aGFuIGEg
cGFnZSBsaXN0IikKQWNrZWQtYnk6IEJoYXJhdGggU00gPGJoYXJhdGhzbUBtaWNyb3NvZnQuY29t
PgpUZXN0ZWQtYnk6IEJoYXJhdGggU00gPGJoYXJhdGhzbUBtaWNyb3NvZnQuY29tPgpTaWduZWQt
b2ZmLWJ5OiBEYXZpZCBIb3dlbGxzIDxkaG93ZWxsc0ByZWRoYXQuY29tPgpjYzogc3RhYmxlQGtl
cm5lbC5vcmcgIyB2Ni42fnY2LjkKLS0tCiBmcy9zbWIvY2xpZW50L2ZpbGUuYyB8IDk3ICsrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwg
OTQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xp
ZW50L2ZpbGUuYyBiL2ZzL3NtYi9jbGllbnQvZmlsZS5jCmluZGV4IDEwNTgwNjY5MTNkZC4uNGQz
ODAxMTQxM2EwIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2ZpbGUuYworKysgYi9mcy9zbWIv
Y2xpZW50L2ZpbGUuYwpAQCAtMzcsNiArMzcsODEgQEAKICNpbmNsdWRlICJjaWZzX2lvY3RsLmgi
CiAjaW5jbHVkZSAiY2FjaGVkX2Rpci5oIgogCisvKgorICogQWxsb2NhdGUgYSBiaW9fdmVjIGFy
cmF5IGFuZCBleHRyYWN0IHVwIHRvIHNnX21heCBwYWdlcyBmcm9tIGEgS1ZFQy10eXBlCisgKiBp
dGVyYXRvciBhbmQgYWRkIHRoZW0gdG8gdGhlIGFycmF5LiAgVGhpcyBjYW4gZGVhbCB3aXRoIHZt
YWxsb2MnZCBidWZmZXJzIGFzCisgKiB3ZWxsIGFzIGttYWxsb2MnZCBvciBzdGF0aWMgYnVmZmVy
cy4gIFRoZSBwYWdlcyBhcmUgbm90IHBpbm5lZC4KKyAqLworc3RhdGljIHNzaXplX3QgZXh0cmFj
dF9rdmVjX3RvX2J2ZWMoc3RydWN0IGlvdl9pdGVyICppdGVyLCBzc2l6ZV90IG1heHNpemUsCisJ
CQkJCXVuc2lnbmVkIGludCBiY19tYXgsCisJCQkJCXN0cnVjdCBiaW9fdmVjICoqX2J2LCB1bnNp
Z25lZCBpbnQgKl9iYykKK3sKKwljb25zdCBzdHJ1Y3Qga3ZlYyAqa3YgPSBpdGVyLT5rdmVjOwor
CXN0cnVjdCBiaW9fdmVjICpidjsKKwl1bnNpZ25lZCBsb25nIHN0YXJ0ID0gaXRlci0+aW92X29m
ZnNldDsKKwl1bnNpZ25lZCBpbnQgaSwgYmMgPSAwOworCXNzaXplX3QgcmV0ID0gMDsKKworCWJj
X21heCA9IGlvdl9pdGVyX25wYWdlcyhpdGVyLCBiY19tYXgpOworCWlmIChiY19tYXggPT0gMCkg
eworCQkqX2J2ID0gTlVMTDsKKwkJKl9iYyA9IDA7CisJCXJldHVybiAwOworCX0KKworCWJ2ID0g
a3ZtYWxsb2MoYXJyYXlfc2l6ZShiY19tYXgsIHNpemVvZigqYnYpKSwgR0ZQX05PRlMpOworCWlm
ICghYnYpIHsKKwkJKl9idiA9IE5VTEw7CisJCSpfYmMgPSAwOworCQlyZXR1cm4gLUVOT01FTTsK
Kwl9CisJKl9idiA9IGJ2OworCisJZm9yIChpID0gMDsgaSA8IGl0ZXItPm5yX3NlZ3M7IGkrKykg
eworCQlzdHJ1Y3QgcGFnZSAqcGFnZTsKKwkJdW5zaWduZWQgbG9uZyBrYWRkcjsKKwkJc2l6ZV90
IG9mZiwgbGVuLCBzZWc7CisKKwkJbGVuID0ga3ZbaV0uaW92X2xlbjsKKwkJaWYgKHN0YXJ0ID49
IGxlbikgeworCQkJc3RhcnQgLT0gbGVuOworCQkJY29udGludWU7CisJCX0KKworCQlrYWRkciA9
ICh1bnNpZ25lZCBsb25nKWt2W2ldLmlvdl9iYXNlICsgc3RhcnQ7CisJCW9mZiA9IGthZGRyICYg
flBBR0VfTUFTSzsKKwkJbGVuID0gbWluX3Qoc2l6ZV90LCBtYXhzaXplLCBsZW4gLSBzdGFydCk7
CisJCWthZGRyICY9IFBBR0VfTUFTSzsKKworCQltYXhzaXplIC09IGxlbjsKKwkJcmV0ICs9IGxl
bjsKKwkJZG8geworCQkJc2VnID0gdW1pbihsZW4sIFBBR0VfU0laRSAtIG9mZik7CisJCQlpZiAo
aXNfdm1hbGxvY19vcl9tb2R1bGVfYWRkcigodm9pZCAqKWthZGRyKSkKKwkJCQlwYWdlID0gdm1h
bGxvY190b19wYWdlKCh2b2lkICopa2FkZHIpOworCQkJZWxzZQorCQkJCXBhZ2UgPSB2aXJ0X3Rv
X3BhZ2UoKHZvaWQgKilrYWRkcik7CisKKwkJCWJ2ZWNfc2V0X3BhZ2UoYnYsIHBhZ2UsIGxlbiwg
b2ZmKTsKKwkJCWJ2Kys7CisJCQliYysrOworCisJCQlsZW4gLT0gc2VnOworCQkJa2FkZHIgKz0g
UEFHRV9TSVpFOworCQkJb2ZmID0gMDsKKwkJfSB3aGlsZSAobGVuID4gMCAmJiBiYyA8IGJjX21h
eCk7CisKKwkJaWYgKG1heHNpemUgPD0gMCB8fCBiYyA+PSBiY19tYXgpCisJCQlicmVhazsKKwkJ
c3RhcnQgPSAwOworCX0KKworCWlmIChyZXQgPiAwKQorCQlpb3ZfaXRlcl9hZHZhbmNlKGl0ZXIs
IHJldCk7CisJKl9iYyA9IGJjOworCXJldHVybiByZXQ7Cit9CisKIC8qCiAgKiBSZW1vdmUgdGhl
IGRpcnR5IGZsYWdzIGZyb20gYSBzcGFuIG9mIHBhZ2VzLgogICovCkBAIC00MzE4LDExICs0Mzkz
LDI3IEBAIHN0YXRpYyBzc2l6ZV90IF9fY2lmc19yZWFkdigKIAkJY3R4LT5idiA9ICh2b2lkICop
Y3R4LT5pdGVyLmJ2ZWM7CiAJCWN0eC0+YnZfbmVlZF91bnBpbiA9IGlvdl9pdGVyX2V4dHJhY3Rf
d2lsbF9waW4odG8pOwogCQljdHgtPnNob3VsZF9kaXJ0eSA9IHRydWU7Ci0JfSBlbHNlIGlmICgo
aW92X2l0ZXJfaXNfYnZlYyh0bykgfHwgaW92X2l0ZXJfaXNfa3ZlYyh0bykpICYmCi0JCSAgICFp
c19zeW5jX2tpb2NiKGlvY2IpKSB7CisJfSBlbHNlIGlmIChpb3ZfaXRlcl9pc19rdmVjKHRvKSkg
eworCQkvKgorCQkgKiBFeHRyYWN0IGEgS1ZFQy10eXBlIGl0ZXJhdG9yIGludG8gYSBCVkVDLXR5
cGUgaXRlcmF0b3IuICBXZQorCQkgKiBhc3N1bWUgdGhhdCB0aGUgc3RvcmFnZSB3aWxsIGJlIHJl
dGFpbmVkIGJ5IHRoZSBjYWxsZXI7IGluCisJCSAqIGFueSBjYXNlLCB3ZSBtYXkgb3IgbWF5IG5v
dCBiZSBhYmxlIHRvIHBpbiB0aGUgcGFnZXMsIHNvIHdlCisJCSAqIGRvbid0IHRyeS4KKwkJICov
CisJCXVuc2lnbmVkIGludCBiYzsKKworCQlyYyA9IGV4dHJhY3Rfa3ZlY190b19idmVjKHRvLCBp
b3ZfaXRlcl9jb3VudCh0byksIElOVF9NQVgsCisJCQkJCSZjdHgtPmJ2LCAmYmMpOworCQlpZiAo
cmMgPCAwKSB7CisJCQlrcmVmX3B1dCgmY3R4LT5yZWZjb3VudCwgY2lmc19haW9fY3R4X3JlbGVh
c2UpOworCQkJcmV0dXJuIHJjOworCQl9CisKKwkJaW92X2l0ZXJfYnZlYygmY3R4LT5pdGVyLCBJ
VEVSX0RFU1QsIGN0eC0+YnYsIGJjLCByYyk7CisJfSBlbHNlIGlmIChpb3ZfaXRlcl9pc19idmVj
KHRvKSAmJiAhaXNfc3luY19raW9jYihpb2NiKSkgewogCQkvKgogCQkgKiBJZiB0aGUgb3AgaXMg
YXN5bmNocm9ub3VzLCB3ZSBuZWVkIHRvIGNvcHkgdGhlIGxpc3QgYXR0YWNoZWQKLQkJICogdG8g
YSBCVkVDL0tWRUMtdHlwZSBpdGVyYXRvciwgYnV0IHdlIGFzc3VtZSB0aGF0IHRoZSBzdG9yYWdl
CisJCSAqIHRvIGEgQlZFQy10eXBlIGl0ZXJhdG9yLCBidXQgd2UgYXNzdW1lIHRoYXQgdGhlIHN0
b3JhZ2UKIAkJICogd2lsbCBiZSByZXRhaW5lZCBieSB0aGUgY2FsbGVyOyBpbiBhbnkgY2FzZSwg
d2UgbWF5IG9yIG1heQogCQkgKiBub3QgYmUgYWJsZSB0byBwaW4gdGhlIHBhZ2VzLCBzbyB3ZSBk
b24ndCB0cnkuCiAJCSAqLwotLSAKMi40NS40Cgo=
--0000000000005bf917064392441e--
