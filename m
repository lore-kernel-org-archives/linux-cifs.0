Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402EF13CFB7
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jul 2024 05:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721714190; cv=none; b=UYHd3OfjzD2tInDVrF37UJMyNZbMbA1wrANU0cz5YQj6qGNY779xxNROjLVutCyOU71XvkSm3F7WpH3gv6hh/Ua033OIIcSuM72oOrU1/o4ue0HNBOuJwsaeNGmdvqrZo4wbxzzJTH9kdFOCLRvZFHkbEcWMGhDGxRvN0AesvaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721714190; c=relaxed/simple;
	bh=9nejVXi2mwNz/4TMQc7mgbuRaDUffHG639Vo4ppv6i0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=fCj5SuXotseiCHeF6gbD1DOy6OFwkoodGzPTFaeo6Y+XKe4Ikan3n+0HDT7MzSIx6Vgl/NMK4eKoiAdrQ3kT2+8LU4+W3FTOyX1I2MQVPqRxinRCy2hGspc/60/t+2mRYElTvUAcAADNUMxOPQA89tObfsD2pYms5lY9qUDe5U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gPR9YRFX; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gPR9YRFX"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-52ed741fe46so5849121e87.0
        for <linux-cifs@vger.kernel.org>; Mon, 22 Jul 2024 22:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721714187; x=1722318987; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Eyg85J8K9ihH82p0hRx+2qtj9MLkxnAavrxsh5Wv+NE=;
        b=gPR9YRFXt9Qx1LkYvPjkhhUOPImSkqe8Hvwb3KGzSawDcHq34eGJP4fJ33jcpuMOzM
         8+QG91OWIPDdc28CelBx+eBAVYXtLcuZTcY87X205Z6h2rz79rt3REGI6fGWe+fAojgS
         F8brKl/yL+tb6izEoHI2JtqddghPmpYnfTqAcafXhXbNJUQKXKKonPmIANfvzKPVddul
         ZDLXNEMJV5m4DFst3jX5vwC75BNnx+COKMsTo3C6M+1tghNDS/95tyruRDk2odjBWLVY
         0i78TDByMZLxnb6NiH+YVnkO+UYs4Q6kO8jPJ7W3zFcHMqbpXmdwqlrIFMPc/XlIPHqg
         WljQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721714187; x=1722318987;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Eyg85J8K9ihH82p0hRx+2qtj9MLkxnAavrxsh5Wv+NE=;
        b=rU1a32GeMfQzijDpVAycWFoyWq9kR0b4ViyGcQIYE5W4syVX1I+GEJrc9wbGkmIkZX
         SRscxpQw7DcljLnPPmuj/ygt7eG3E+5IXlF2/mhHdUJd47ZROOG5kYTSN8k7ls4HiQg/
         i+kCCUVM6lPyiK5Z3U5QeDDgEOulinYJB7Na1cT3FJH3SmZnPHDQ0MWUAYBLS9Kefvh7
         cg9TPgJXIpnh3snoMsSR+Qs9QeCub+g1yo6e3+BrvD6hwsmTQXpqqcmIIKkJAn2y4n+M
         DYxVsaxhiKvk7x5cCvE7vd5rYGJKGr7kdaBwTj9ST+Qy0yrSbhuJx7DDNsrqOdi1TeX1
         kfHw==
X-Gm-Message-State: AOJu0YxQQC5V5Bui+TNdvvCozVFg38WGWjsVZbHWUoRxmXfWshVNsAN6
	PVjtNY4UXaOBRHsLkv+zwQrGpgpjlvgdakFyQEX5RSegOPYtUKgvPnXaCIC/bnfxXDW+2hDLJvf
	Os5NByJXD6X1sdBjALaSvV3I6Iwy4pERh
X-Google-Smtp-Source: AGHT+IE7ebaVGF0FCj1gjWT7OgagQGgXPXNxI8yTB+YxqCDVea1beFx94JHCQNlZ3cG/eqoEhJFuvr91vfrvReVtKR8=
X-Received: by 2002:a05:6512:2209:b0:52e:f2a6:8e1a with SMTP id
 2adb3069b0e04-52efb7e8103mr6190757e87.29.1721714186771; Mon, 22 Jul 2024
 22:56:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 23 Jul 2024 00:56:15 -0500
Message-ID: <CAH2r5mse9o8tuS9UM9soq02MwweULT9KnUxOzoBHEirHxB3Gog@mail.gmail.com>
Subject: [PATCH][CIFS] mount with "unix" mount option for SMB1 incorrectly handled
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, Andrew Bartlett <abartlet@samba.org>, 
	Kevin Ottens <kevin.ottens@enioka.com>
Cc: Paulo Alcantara <pc@manguebit.com>
Content-Type: multipart/mixed; boundary="00000000000081fa73061de3d20d"

--00000000000081fa73061de3d20d
Content-Type: text/plain; charset="UTF-8"

When Andrew Bartlett mentioned problems using the SMB1 Unix Extensions to Samba
I noticed a couple of client bugs.  This fixes the second problem I noticed.

Although by default we negotiate CIFS Unix Extensions for SMB1 mounts
to Samba (and they work if the user does not specify "unix" or "posix"
or "linux" on mount), and we do properly handle when a user turns them
off with "nounix" mount parm, ... but with the  changes to the mount
API we broke cases where the user explicitly specified the "unix"
option (or equivalently "linux" or "posix") on mount with vers=1.0 to
Samba or other servers which support the CIFS Unix Extensions.

   "mount error(95): Operation not supported"

and logged:

   "CIFS: VFS: Check vers= mount option. SMB3.11 disabled but required
for POSIX extensions"

even though CIFS Unix Extensions are supported for vers=1.0  This
patch fixes the case where the user specifies both "unix" (or
equivalently "posix" or "linux") and "vers=1.0" on mount to a server
which supports the CIFS Unix Extensions.

See attached

-- 
Thanks,

Steve

--00000000000081fa73061de3d20d
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-mount-with-unix-mount-option-for-SMB1-incorrect.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-mount-with-unix-mount-option-for-SMB1-incorrect.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lyy03ev00>
X-Attachment-Id: f_lyy03ev00

RnJvbSA2YmUzNmVlMGFjY2VlZjAzYWI2MTk4NTc4NmNhMjM4YTEzMjcyMWU2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMjMgSnVsIDIwMjQgMDA6NDQ6NDggLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBtb3VudCB3aXRoICJ1bml4IiBtb3VudCBvcHRpb24gZm9yIFNNQjEgaW5jb3JyZWN0bHkK
IGhhbmRsZWQKCkFsdGhvdWdoIGJ5IGRlZmF1bHQgd2UgbmVnb3RpYXRlIENJRlMgVW5peCBFeHRl
bnNpb25zIGZvciBTTUIxIG1vdW50cyB0bwpTYW1iYSAoYW5kIHRoZXkgd29yayBpZiB0aGUgdXNl
ciBkb2VzIG5vdCBzcGVjaWZ5ICJ1bml4IiBvciAicG9zaXgiIG9yCiJsaW51eCIgb24gbW91bnQp
LCBhbmQgd2UgZG8gcHJvcGVybHkgaGFuZGxlIHdoZW4gYSB1c2VyIHR1cm5zIHRoZW0gb2ZmCndp
dGggIm5vdW5peCIgbW91bnQgcGFybS4gIEJ1dCB3aXRoIHRoZSBjaGFuZ2VzIHRvIHRoZSBtb3Vu
dCBBUEkgd2UKYnJva2UgY2FzZXMgd2hlcmUgdGhlIHVzZXIgZXhwbGljaXRseSBzcGVjaWZpZXMg
dGhlICJ1bml4IiBvcHRpb24gKG9yCmVxdWl2YWxlbnRseSAibGludXgiIG9yICJwb3NpeCIpIG9u
IG1vdW50IHdpdGggdmVycz0xLjAgdG8gU2FtYmEgb3Igb3RoZXIKc2VydmVycyB3aGljaCBzdXBw
b3J0IHRoZSBDSUZTIFVuaXggRXh0ZW5zaW9ucy4KCiAibW91bnQgZXJyb3IoOTUpOiBPcGVyYXRp
b24gbm90IHN1cHBvcnRlZCIKCmFuZCBsb2dnZWQ6CgogIkNJRlM6IFZGUzogQ2hlY2sgdmVycz0g
bW91bnQgb3B0aW9uLiBTTUIzLjExIGRpc2FibGVkIGJ1dCByZXF1aXJlZCBmb3IgUE9TSVggZXh0
ZW5zaW9ucyIKCmV2ZW4gdGhvdWdoIENJRlMgVW5peCBFeHRlbnNpb25zIGFyZSBzdXBwb3J0ZWQg
Zm9yIHZlcnM9MS4wICBUaGlzIHBhdGNoIGZpeGVzCnRoZSBjYXNlIHdoZXJlIHRoZSB1c2VyIHNw
ZWNpZmllcyBib3RoICJ1bml4IiAob3IgZXF1aXZhbGVudGx5ICJwb3NpeCIgb3IKImxpbnV4Iikg
YW5kICJ2ZXJzPTEuMCIgb24gbW91bnQgdG8gYSBzZXJ2ZXIgd2hpY2ggc3VwcG9ydHMgdGhlCkNJ
RlMgVW5peCBFeHRlbnNpb25zLgoKQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKU2lnbmVkLW9m
Zi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL3NtYi9j
bGllbnQvY29ubmVjdC5jIHwgNyArKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25z
KCspCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jb25uZWN0LmMgYi9mcy9zbWIvY2xpZW50
L2Nvbm5lY3QuYwppbmRleCBiNjZkOGIwM2EzODkuLmMzZDhkN2I3YjQ2YSAxMDA2NDQKLS0tIGEv
ZnMvc21iL2NsaWVudC9jb25uZWN0LmMKKysrIGIvZnMvc21iL2NsaWVudC9jb25uZWN0LmMKQEAg
LTI2MTQsNiArMjYxNCwxMyBAQCBjaWZzX2dldF90Y29uKHN0cnVjdCBjaWZzX3NlcyAqc2VzLCBz
dHJ1Y3Qgc21iM19mc19jb250ZXh0ICpjdHgpCiAJCQljaWZzX2RiZyhWRlMsICJTZXJ2ZXIgZG9l
cyBub3Qgc3VwcG9ydCBtb3VudGluZyB3aXRoIHBvc2l4IFNNQjMuMTEgZXh0ZW5zaW9uc1xuIik7
CiAJCQlyYyA9IC1FT1BOT1RTVVBQOwogCQkJZ290byBvdXRfZmFpbDsKKwkJfSBlbHNlIGlmIChz
ZXMtPnNlcnZlci0+dmFscy0+cHJvdG9jb2xfaWQgPT0gU01CMTBfUFJPVF9JRCkKKwkJCWlmIChj
YXBfdW5peChzZXMpKQorCQkJCWNpZnNfZGJnKEZZSSwgIlVuaXggRXh0ZW5zaW9ucyByZXF1ZXN0
ZWQgb24gU01CMSBtb3VudFxuIik7CisJCQllbHNlIHsKKwkJCQljaWZzX2RiZyhWRlMsICJTTUIx
IFVuaXggRXh0ZW5zaW9ucyBub3Qgc3VwcG9ydGVkIGJ5IHNlcnZlclxuIik7CisJCQkJcmMgPSAt
RU9QTk9UU1VQUDsKKwkJCQlnb3RvIG91dF9mYWlsOwogCQl9IGVsc2UgewogCQkJY2lmc19kYmco
VkZTLAogCQkJCSJDaGVjayB2ZXJzPSBtb3VudCBvcHRpb24uIFNNQjMuMTEgZGlzYWJsZWQgYnV0
IHJlcXVpcmVkIGZvciBQT1NJWCBleHRlbnNpb25zXG4iKTsKLS0gCjIuNDMuMAoK
--00000000000081fa73061de3d20d--
