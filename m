Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F757254AF5
	for <linux-cifs@vger.kernel.org>; Sun, 28 Dec 2025 19:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766949896; cv=none; b=OVcSd0DYZzpOuP30r2cdp0b43C37ad2HrbZRLRkbNY6cBF7cHIrNQGtFz2noKH8dBfq5kx34wbKR3OLtzV8WykCxQa7FDc2kLQ6PDEahRCk3I6TimqALH2ZEsoB1FpFlL6bt0z6H/vxH48/w/HBvD0a76zY+R5J6F/4P93QBgbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766949896; c=relaxed/simple;
	bh=Pkw5FuuVekqTYC/JO4rSqrb6sdtMN4yv7yOaZLGEn9k=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Fhi620sRP0XSNVDvHUjjF6x+5oR9vPh8ymWWK00Lg5epag9Yfpqn3XgG7CxBXIUxTq8gewVQsEvvLWotczSqQl/wckrkOZ4lYEBBSUH6fhDB1vPn1CSBH3rGNXMADmFs50mz9xkpK8iKftOKJ60hN+FUGBjretulsao5aDgpUyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kvUl+KgY; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kvUl+KgY"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-88059c28da1so81992966d6.2
        for <linux-cifs@vger.kernel.org>; Sun, 28 Dec 2025 11:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766949893; x=1767554693; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=v+GiZ7GUs9uo0y9+KXBkPM+IODvDpMqvIlR4Bv75FaE=;
        b=kvUl+KgYacZEd4bOHRa5jXLqTH45FfAx3k8SnU4+VqfZNg/HbuheUQsowrF+sCNKZf
         1jmKp9xeZ/E4EeCYq6enmHn6m4xo1WzFrCf9jaEnPO9wdDRjmfcE0n2X2+uTav+mTlSH
         PvuA42nEv/eFYx1BhDUDj0Wyl9xy+Xg7ai/djbwQ5/7alxp5m4ljVbGRZBFYM73q3YxQ
         gRv0dMAm510/W3BTEwvxSLl5aMl9e0tJ37qxjBJoUePdfv3tnnavD1GLEIeOkEqvzVzv
         KHNeufMBN5XY+RnXatyu8RWk+4LHhbYfe1ZQ0FhVfRlhS8B1hkWGXwaQZ7b9+ysJdIgx
         dmVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766949893; x=1767554693;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v+GiZ7GUs9uo0y9+KXBkPM+IODvDpMqvIlR4Bv75FaE=;
        b=jIN2M57Nd1MQ+gtgbf0g0+0IiNtnI+j79siy4kjVmQKcb7IiTNwd3uoq+T0Fa4MCSq
         Te1ytxaE+TRSLl7KoAD/7lWEkhnkYvuow16pCdDb+5TB4hHN2RIRoBbRSrNjIa7a5QRE
         qXIihoxPSGw1CO9gyaJnZNIFxm5pIUZgwruC1kNAYpva8HFugXg92tNs8tAByBaz9Lny
         aYJOgb1hskpXvmBbHxELYqgzrx+B7jRoYw2eeHbh/PUOPQqMY1IFaPqOO73ikUy+BlxK
         W8yeNVBKxWmXdOsbsZ4A36J/pRb2eUc/3W7miauUbNDDzc/nlvG1NJaRmah8OU2CZoxs
         h3ig==
X-Gm-Message-State: AOJu0YyAKK/JtgqrgoQ8foZPy73pklkGHbbg74KozrWuQStmzVQKRmj8
	5HA4BY8TZ2GTi2SkbvkkwXuIOuEU9ey1hUKq/6Tdz9CTigVsQS25ZodtRN7v4twwzu/3aC/o9TU
	iEbK/qGIPUSXFaXb4etbNEDqdIRVHpYygz8DI
X-Gm-Gg: AY/fxX6wGVHrHNbN7bVlcNJmVLzgo5Y7a8qlAjP3/MCMYvXP4pxiKM4xoimAEsFlkxM
	u2t9nCX8z4DJazVGU8pfHi/M+mYxzYrzgHBfPzSwsuzgAFntjNVfXUSGZKXvFSM9+o/GvFaJlYI
	N2ONpz4X3a1O+dv4PPwChVFf6Z7BjVEhgrHhnM0HysJP4eZfLnvDgOdNeeAv/T1JAtusasFilyg
	XduVPN96dDukdsOv9Z5Jmu+gV0wg/wuG2kztMzMlrnHPlcsJ5YM36T+Z1WNeAb7OSKHTEdDqbtY
	5vx2Knd4cJRAK9pvnD/qJdGDdk00PHtbsbYK0Dta2BWBBSmYEjv6w/DV17s5UTFFc+UkdAZMp+L
	68RAblSML48dtXIPOtus6CrwdIVZzit10TcEL9ONQWjThNFSz0HHKjP2oUoDuHVpksEvoxtrbHi
	j8Jfc/Mn15VQ==
X-Google-Smtp-Source: AGHT+IF582PFw5vyBLWHCSiY+BtzygDI8JKYC+XQMmog2/lKqDRB60Gqo0eeNNo+kYggHelu6MfBxaAa/+jwBPNnORI=
X-Received: by 2002:a05:6214:1c4a:b0:880:4ed1:ce32 with SMTP id
 6a1803df08f44-88d833b580bmr446304526d6.45.1766949893577; Sun, 28 Dec 2025
 11:24:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 28 Dec 2025 13:24:41 -0600
X-Gm-Features: AQt7F2qqneGtxM0KXeHFWhcpTmCI4mEYfF7LL6vFX2wuINC2uQ4Wuc1ytWIDvE0
Message-ID: <CAH2r5mt8+dgy+OH4=S8YxJoq_T70pO0n3Fd+xr8U_GXZ5G4jtQ@mail.gmail.com>
Subject: [PATCH] smb3 client: add missing tracepoint for unsupported ioctls
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000be9bf106470814b6"

--000000000000be9bf106470814b6
Content-Type: text/plain; charset="UTF-8"

In debugging a recent problem with an xfstest, noticed that we weren't
tracing cases where the ioctl was not supported.  Add dynamic tracepoint:
    "trace-cmd record -e smb3_unsupported_ioctl"
and then after running an app which calls unsupported ioctl,
"trace-cmd show"would display e.g.
      xfs_io-7289    [012] .....  1205.137765: smb3_unsupported_ioctl:
xid=19 fid=0x4535bb84 ioctl cmd=0x801c581f

See attached

-- 
Thanks,

Steve

--000000000000be9bf106470814b6
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-client-add-missing-tracepoint-for-unsupported-i.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-client-add-missing-tracepoint-for-unsupported-i.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mjq4c4nd0>
X-Attachment-Id: f_mjq4c4nd0

RnJvbSA2YzI0ZjEwMzY2ZTU4NDc5NzM3MGZmNjkxZmI3MjlhMTA0MTRjYWQwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgMjcgRGVjIDIwMjUgMTk6NTk6MjAgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzIGNsaWVudDogYWRkIG1pc3NpbmcgdHJhY2Vwb2ludCBmb3IgdW5zdXBwb3J0ZWQgaW9jdGxz
CgpJbiBkZWJ1Z2dpbmcgYSByZWNlbnQgcHJvYmxlbSB3aXRoIGFuIHhmc3Rlc3QsIG5vdGljZWQg
dGhhdCB3ZSB3ZXJlbid0CnRyYWNpbmcgY2FzZXMgd2hlcmUgdGhlIGlvY3RsIHdhcyBub3Qgc3Vw
cG9ydGVkLiAgQWRkIGR5bmFtaWMgdHJhY2Vwb2ludDoKICAgICJ0cmFjZS1jbWQgcmVjb3JkIC1l
IHNtYjNfdW5zdXBwb3J0ZWRfaW9jdGwiCmFuZCB0aGVuIGFmdGVyIHJ1bm5pbmcgYW4gYXBwIHdo
aWNoIGNhbGxzIHVuc3VwcG9ydGVkIGlvY3RsLAoidHJhY2UtY21kIHNob3cid291bGQgZGlzcGxh
eSBlLmcuCiAgICAgIHhmc19pby03Mjg5ICAgIFswMTJdIC4uLi4uICAxMjA1LjEzNzc2NTogc21i
M191bnN1cHBvcnRlZF9pb2N0bDogeGlkPTE5IGZpZD0weDQ1MzViYjg0IGlvY3RsIGNtZD0weDgw
MWM1ODFmCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5j
b20+Ci0tLQogZnMvc21iL2NsaWVudC9pb2N0bC5jIHwgMiArKwogZnMvc21iL2NsaWVudC90cmFj
ZS5oIHwgMSArCiAyIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBh
L2ZzL3NtYi9jbGllbnQvaW9jdGwuYyBiL2ZzL3NtYi9jbGllbnQvaW9jdGwuYwppbmRleCAwYTk5
MzVjZTA1YTUuLjEwNjkwYjBjMWY5MCAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9pb2N0bC5j
CisrKyBiL2ZzL3NtYi9jbGllbnQvaW9jdGwuYwpAQCAtNTg4LDYgKzU4OCw4IEBAIGxvbmcgY2lm
c19pb2N0bChzdHJ1Y3QgZmlsZSAqZmlsZXAsIHVuc2lnbmVkIGludCBjb21tYW5kLCB1bnNpZ25l
ZCBsb25nIGFyZykKIAkJCWJyZWFrOwogCQlkZWZhdWx0OgogCQkJY2lmc19kYmcoRllJLCAidW5z
dXBwb3J0ZWQgaW9jdGxcbiIpOworCQkJdHJhY2Vfc21iM191bnN1cHBvcnRlZF9pb2N0bCh4aWQs
IHBTTUJGaWxlLT5maWQucGVyc2lzdGVudF9maWQsCisJCQkJCQkgICAgIGNvbW1hbmQpOwogCQkJ
YnJlYWs7CiAJfQogY2lmc19pb2NfZXhpdDoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvdHJh
Y2UuaCBiL2ZzL3NtYi9jbGllbnQvdHJhY2UuaAppbmRleCBiMGZiYzJkZjY0MmUuLmE1ODRhNzc0
MzExMyAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC90cmFjZS5oCisrKyBiL2ZzL3NtYi9jbGll
bnQvdHJhY2UuaApAQCAtMTU3OSw2ICsxNTc5LDcgQEAgREVGSU5FX0VWRU5UKHNtYjNfaW9jdGxf
Y2xhc3MsIHNtYjNfIyNuYW1lLCAgXAogCVRQX0FSR1MoeGlkLCBmaWQsIGNvbW1hbmQpKQogCiBE
RUZJTkVfU01CM19JT0NUTF9FVkVOVChpb2N0bCk7CitERUZJTkVfU01CM19JT0NUTF9FVkVOVCh1
bnN1cHBvcnRlZF9pb2N0bCk7CiAKIERFQ0xBUkVfRVZFTlRfQ0xBU1Moc21iM19zaHV0ZG93bl9j
bGFzcywKIAlUUF9QUk9UTyhfX3UzMiBmbGFncywKLS0gCjIuNTEuMAoK
--000000000000be9bf106470814b6--
