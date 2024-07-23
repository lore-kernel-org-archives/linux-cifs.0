Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B464F139CFE
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jul 2024 05:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721711285; cv=none; b=h8RLvwuBnHc+P54CmXVePHoRRLuC7aP0D1h0kR7yMBISufqZnlDWiM2JjqlsBZuxTAg8xCt9aJYnFq2s4GAYO7DzRUVU40/cWLVmVZtkSVOpK29zxvvC3u1o3xlXVqZb80MxdcRePh+yM0y2HR2VkNo/8/gVMVKyW9yuI4Ax4Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721711285; c=relaxed/simple;
	bh=viy8Xk35DCqbKxDZMZslIj10fmEWJTSUP9wlcEt8rXs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=HrETzroX+AzrotjUkkxc+JTyy0y85TWdBKY3Z2TZdTkq5eewg8DAwqEHCcAZM0OfeG5zsiu7SUBswzTNR7ln/BA1eIFJ5CFabcp4JF6voVy3PPFP9I87Z8xdFvjY+uLFyJXVSJMoaBqQ07v+WKq0l2iX3IlvwhOb0Frjxl2/v9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HG7nrWMX; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HG7nrWMX"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-52f04c29588so2250375e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 22 Jul 2024 22:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721711282; x=1722316082; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PqpSyzfOqfBgpniyCbv/7Z74nENzVCrnnHH4dQbwPEk=;
        b=HG7nrWMXMlPnWSkuyTRXPJ6yhg8rDpj873PcY1Dpxa76ThccRCy5OQ3B96qnr06Wuu
         Vfa466CLW51TTCPoVntJvhrNX5uFfuRxXub5hhd8Gq+s57pFqlPxhjtusO8mNtqNgc+e
         0D7nFzXetksqK39xy7c896llsoXnogXc6+bnzcjK9dIK4+d8u/6VfjFk5iHXo69gcYzu
         vF9lDevHPhkPc4HaDc0Ik2pQlc3G4SsBtiJAAp5LA8vwe7aAfcguzVp6BPODMI73YyQz
         cyoCf6W3BTHGLtFsCgE/I4RR0qeY5jdPnzoNBIrNEL+3/bsIDErAWfM5lfQq0/WqA54V
         5OGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721711282; x=1722316082;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PqpSyzfOqfBgpniyCbv/7Z74nENzVCrnnHH4dQbwPEk=;
        b=wzyumtZp85buIAJkJzGIiEueu3x4Njnc98VHesIZ2zVkJF86hAqIFRAsv/LAMbyoEE
         dGm8nuoCBrvjxNR6d2VohUwOgyJ8qEsZZfhChKvabqbEEbWApwxMSoNCluAa1A1WJaSy
         imk3ahxMtLMbyb/IXehajKelfefZ3o7WlypJgWVLPnRvp8gOBkUBgtkV6o4aMhWkY6Mf
         ywp4b/f+tllYDHhySftJVsN9VSX3Yb+u+02OcPnzQh6MSjbbST2S5Xs+kxhuh9nbEpgY
         weDFhoEjENp5+M98jnRBiOFhbDIwApqrXfxyGHuSJkRDPW3FeJwMpMvjSG1b/wkNiJMM
         8DnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVieY5poxVlze8rLUbOcsj40/ZZYx1wlGueWz/VIHVr73mso5j3TS/DvGrSy+NlCKJiobN1S1wYS9KvfScCqYHM2zGcTTvnKGWvig==
X-Gm-Message-State: AOJu0YyceamcYWnduUdQMCec7Q6C2/3euFPp1qyhRswgemj3R2/yr5JO
	zvuABd+3dxwUrkuTbWzFnhGliljmvQzsxXWkQ0Oo/MK2y7asp+P8f2VO4ugfpEzfCsaFKzSvNpI
	RucteK35YCicXFHOF1TBEVWBsNO4tY1QJ
X-Google-Smtp-Source: AGHT+IGFaeQAFoLrUxTqgAbwSwnExwQvEx8ysZRM+N6jejJsr3AfjoUEc5Fmt5oU6JOXIMqMqOS9LInBiS+YhWPdty4=
X-Received: by 2002:a05:6512:2209:b0:52e:f2a6:8e1a with SMTP id
 2adb3069b0e04-52efb7e8103mr6118513e87.29.1721711281502; Mon, 22 Jul 2024
 22:08:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 23 Jul 2024 00:07:50 -0500
Message-ID: <CAH2r5mu2LTRDPX7KbM3V_d7FybuPnvCMRd6YV3__H-7mn1N9uA@mail.gmail.com>
Subject: [PATCH][CIFS] fix reconnect with SMB1 Unix Extensions
To: Andrew Bartlett <abartlet@samba.org>, samba-technical <samba-technical@lists.samba.org>, 
	CIFS <linux-cifs@vger.kernel.org>, Kevin Ottens <kevin.ottens@enioka.com>
Cc: Paulo Alcantara <pc@manguebit.com>
Content-Type: multipart/mixed; boundary="000000000000571cef061de3251f"

--000000000000571cef061de3251f
Content-Type: text/plain; charset="UTF-8"

Andrew had pointed out having problems with SMB1 Unix extensions to
Samba when investigating an unrelated problem, and when I tried it I
noticed a serious reconnect issue with the SMB1 Unix Extensions.

When mounting with the SMB1 Unix Extensions (e.g. mounts
to Samba with vers=1.0), cifs.ko reconnects no longer reset the
Unix Extensions (SetFSInfo SET_FILE_UNIX_BASIC) after tcon so most
operations (e.g. stat, ls, open, statfs) will fail continuously
with:
        "Operation not supported"
if the connection ever resets (e.g. due to brief network disconnect)

Fix attached



-- 
Thanks,

Steve

--000000000000571cef061de3251f
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-reconnect-with-SMB1-UNIX-Extensions.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-reconnect-with-SMB1-UNIX-Extensions.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lyxyflgw0>
X-Attachment-Id: f_lyxyflgw0

RnJvbSAyYTliM2ViMWIwODM4Y2M5OWFhZmRjNTBlMzcxMzg1MzhkNDU5M2JiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjIgSnVsIDIwMjQgMjM6NDA6MDggLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggcmVjb25uZWN0IHdpdGggU01CMSBVTklYIEV4dGVuc2lvbnMKCldoZW4gbW91bnRp
bmcgd2l0aCB0aGUgU01CMSBVbml4IEV4dGVuc2lvbnMgKGUuZy4gbW91bnRzCnRvIFNhbWJhIHdp
dGggdmVycz0xLjApLCByZWNvbm5lY3RzIG5vIGxvbmdlciByZXNldCB0aGUKVW5peCBFeHRlbnNp
b25zIChTZXRGU0luZm8gU0VUX0ZJTEVfVU5JWF9CQVNJQykgYWZ0ZXIgdGNvbiBzbyBtb3N0Cm9w
ZXJhdGlvbnMgKGUuZy4gc3RhdCwgbHMsIG9wZW4sIHN0YXRmcykgd2lsbCBmYWlsIGNvbnRpbnVv
dXNseQp3aXRoOgogICAgICAgICJPcGVyYXRpb24gbm90IHN1cHBvcnRlZCIKaWYgdGhlIGNvbm5l
Y3Rpb24gZXZlciByZXNldHMgKGUuZy4gZHVlIHRvIGJyaWVmIG5ldHdvcmsgZGlzY29ubmVjdCkK
CkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8
c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L2Nvbm5lY3QuYyB8IDE1
ICsrKysrKysrKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDEgZGVs
ZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYyBiL2ZzL3NtYi9j
bGllbnQvY29ubmVjdC5jCmluZGV4IDdhMTZlMTJmNWRhOC4uYjY2ZDhiMDNhMzg5IDEwMDY0NAot
LS0gYS9mcy9zbWIvY2xpZW50L2Nvbm5lY3QuYworKysgYi9mcy9zbWIvY2xpZW50L2Nvbm5lY3Qu
YwpAQCAtMzgwNyw4ICszODA3LDIxIEBAIENJRlNUQ29uKGNvbnN0IHVuc2lnbmVkIGludCB4aWQs
IHN0cnVjdCBjaWZzX3NlcyAqc2VzLAogCQllbHNlCiAJCQl0Y29uLT5GbGFncyA9IDA7CiAJCWNp
ZnNfZGJnKEZZSSwgIlRjb24gZmxhZ3M6IDB4JXhcbiIsIHRjb24tPkZsYWdzKTsKLQl9CiAKKwkJ
LyoKKwkJICogcmVzZXRfY2lmc191bml4X2NhcHMgY2FsbHMgUUZTSW5mbyB3aGljaCByZXF1aXJl
cworCQkgKiBuZWVkX3JlY29ubmVjdCB0byBiZSBmYWxzZSwgYnV0IHdlIHdvdWxkIG5vdCBuZWVk
IHRvIGNhbGwKKwkJICogcmVzZXRfY2FwcyBpZiB0aGlzIHdlcmUgbm90IGEgcmVjb25uZWN0IGNh
c2Ugc28gbXVzdCBjaGVjaworCQkgKiBuZWVkX3JlY29ubmVjdCBmbGFnIGhlcmUuICBUaGUgY2Fs
bGVyIHdpbGwgYWxzbyBjbGVhcgorCQkgKiBuZWVkX3JlY29ubmVjdCB3aGVuIHRjb24gd2FzIHN1
Y2Nlc3NmdWwgYnV0IG5lZWRlZCB0byBiZQorCQkgKiBjbGVhcmVkIGVhcmxpZXIgaW4gdGhlIGNh
c2Ugb2YgdW5peCBleHRlbnNpb25zIHJlY29ubmVjdAorCQkgKi8KKwkJaWYgKHRjb24tPm5lZWRf
cmVjb25uZWN0ICYmIHRjb24tPnVuaXhfZXh0KSB7CisJCQljaWZzX2RiZyhGWUksICJyZXNldHRp
bmcgY2FwcyBmb3IgJXNcbiIsIHRjb24tPnRyZWVfbmFtZSk7CisJCQl0Y29uLT5uZWVkX3JlY29u
bmVjdCA9IGZhbHNlOworCQkJcmVzZXRfY2lmc191bml4X2NhcHMoeGlkLCB0Y29uLCBOVUxMLCBO
VUxMKTsKKwkJfQorCX0KIAljaWZzX2J1Zl9yZWxlYXNlKHNtYl9idWZmZXIpOwogCXJldHVybiBy
YzsKIH0KLS0gCjIuNDMuMAoK
--000000000000571cef061de3251f--
