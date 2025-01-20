Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82485BE4A
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jan 2025 01:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337735; cv=none; b=RBGQzDHd8xjZVEcPgbqQUJlofvkNu1PLNEhtmdcIDOxtSJRykL8WgaSPiLdyZPBHirp6r2qWebs20GFbDTu01oImvHry/Cow32xPKEW1RwTsA9nkmZF5jRcdmUeev2vehXLot+BISaSD3F1UcoPbQbzn/hFAEKqloueubV3uKus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337735; c=relaxed/simple;
	bh=6V7JqKBHNJ5lSDdipVKGDgdYtAqUFrPVZp7ZDlRCwp8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=u+6ijO1AHtHps9QPoOr+i9lJ1Xx4fTyh5zTENB00h74aSO35hSWwHXrp/5HiROgiVfuKpyNTEr38QIQFAqgvTJZiW9uKK3imLQyfVD7+Lk6jBqz4oGIbx2p5F5APtYJ/IkmwoqypTxzNjJGf4GhaOTsm1FNnJwth0JiCHCiFajk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l0ftW+/x; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l0ftW+/x"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5401bd6cdb7so3799598e87.2
        for <linux-cifs@vger.kernel.org>; Sun, 19 Jan 2025 17:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737337731; x=1737942531; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Xf98GyAdie4SfKgORppb7AAbGu2pyVw7mK348IGm1GY=;
        b=l0ftW+/xVra/x3EhsctqWTBSti6efq8Yh++taJxJ6H74emdI1RN9xjn4AW91ODz0RR
         x9TkchFgZHCiA+tF6z8cEiQQjqQal54GeIUxwy1tBvx+23jldTLAZwJ0R17qv2xXpB9a
         LJfOOcoJgvGNJFT+1DtjNACq8Nxb1EvYJOdyhPbvOm/4RArpdwLEK/WIuvanmkXI+OAd
         n3LSx5uLTLHW9ulsXSxR4cNeo+wt+7scNv7aZ9ZQyu8d9e8HY2d0xEPM1kRxjU7ixPmy
         vT1N2IVT/rfZ2VoM8yqM5FMjWhzj7raHT+hScGfEtPdfjEFNStGClEo49fzDYJhV6Op9
         C09A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737337731; x=1737942531;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xf98GyAdie4SfKgORppb7AAbGu2pyVw7mK348IGm1GY=;
        b=gRkNohwYEf9oVJc8g5WBIQKZMfkB3ZSRSrf3jVTFf/cidMVrL1P9FRVX6qW01ntnZi
         2vk3ErJ2nw0cFsNGJSny78i1Ew4OHxunTDrWyvQXd/iT7jM1oNHfHLvMtgp4NydDQ/Yg
         eyb+vS0EGGQUTxLp8jn5KpZ4us5nmCxWv2JEd85zNyBR69PNtyn4hckL8vGa+6NeEWDn
         n4zjeX6FO9x6LAe2oLq/MR0wYhfWvb4xVwVb698Nke0B+NKbvkZSBellPYbQlYg3E3wl
         7moiFnn/y/r9Dy712q36atleLd0X66ygWbcFqTEOy14rjGomIxLL77pXPt3th4xH4p1P
         iqvQ==
X-Gm-Message-State: AOJu0Yw3/7w7VaL+vC6Hlc0ImraefBDCbv/a7gntgLdCQL8/5+t3pDOk
	q2tUV6HOVN756CZwTBNcJUSJya9RgCIVtPwbAbqMFn7cAZIekDh8ijoDJA9WAldmNEDeiu6bX+h
	t39D5SJpGdxrJ5S2CrxJWnfNYYDAr5ojX
X-Gm-Gg: ASbGncsv+tENHGfb4SqxqTbIO/uZXqj+9OBVT8yywKpDp9eoMApuxAX5C5gZhRcJHLp
	/7WyCAK6KNQFFCpdAD4mzuI/5+2lFEKvUFkN0qjDyllYII21iZiJXQaw4oPcHfaOdUAvB3R9wdg
	ioBukFCm4jZQ==
X-Google-Smtp-Source: AGHT+IGhzzP4UeBXT/UJ94U+n35AkpNQwT4Noc9VZmppWWbMvGX8wcZZxe6rwLgwn7aLKUIrbQaWsMpTwCW38Oj2540=
X-Received: by 2002:a05:6512:b99:b0:53e:94f9:8c86 with SMTP id
 2adb3069b0e04-5439c269828mr4346250e87.35.1737337731029; Sun, 19 Jan 2025
 17:48:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 19 Jan 2025 19:48:39 -0600
X-Gm-Features: AbW1kvalQ7S0BwkX_MDoPIG6gfucAW2tRl1os7vF-9fgMOfCVSnQda0-OfFSwd8
Message-ID: <CAH2r5msUp2xqY062MRRXkNApwekZ_CJYL3q_J0boGFPzw4W1LQ@mail.gmail.com>
Subject: [PATCH] cifs: Fix printing Status code into dmesg
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: multipart/mixed; boundary="0000000000005043ce062c1976bc"

--0000000000005043ce062c1976bc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Any thoughts on the attached patch (which is tentatively in
cifs-2.6.git for-next)?

NT Status code is 32-bit number, so for comparing two NT Status codes is
needed to check all 32 bits, and not just low 24 bits.

Before this change kernel printed message:
"Status code returned 0x8000002d NT_STATUS_NOT_COMMITTED"

It was incorrect as because NT_STATUS_NOT_COMMITTED is defined as
0xC000002d and 0x8000002d has defined name NT_STATUS_STOPPED_ON_SYMLINK.

With this change kernel prints message:
"Status code returned 0x8000002d NT_STATUS_STOPPED_ON_SYMLINK"

Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>


--=20
Thanks,

Steve

--0000000000005043ce062c1976bc
Content-Type: text/x-patch; charset="UTF-8"; 
	name="0042-cifs-Fix-printing-Status-code-into-dmesg.patch"
Content-Disposition: attachment; 
	filename="0042-cifs-Fix-printing-Status-code-into-dmesg.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m64e02zn0>
X-Attachment-Id: f_m64e02zn0

RnJvbSA2ZmE5ZDhhM2NiMjFmZjIxZGJmYTU3NTU1ZjZhNDE2MTViODI5NTI1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/UGFsaT0yMFJvaD1DMz1BMXI/PSA8cGFsaUBr
ZXJuZWwub3JnPgpEYXRlOiBUaHUsIDI2IERlYyAyMDI0IDE0OjI3OjE2ICswMTAwClN1YmplY3Q6
IFtQQVRDSCA0Mi83MV0gY2lmczogRml4IHByaW50aW5nIFN0YXR1cyBjb2RlIGludG8gZG1lc2cK
TUlNRS1WZXJzaW9uOiAxLjAKQ29udGVudC1UeXBlOiB0ZXh0L3BsYWluOyBjaGFyc2V0PVVURi04
CkNvbnRlbnQtVHJhbnNmZXItRW5jb2Rpbmc6IDhiaXQKCk5UIFN0YXR1cyBjb2RlIGlzIDMyLWJp
dCBudW1iZXIsIHNvIGZvciBjb21wYXJpbmcgdHdvIE5UIFN0YXR1cyBjb2RlcyBpcwpuZWVkZWQg
dG8gY2hlY2sgYWxsIDMyIGJpdHMsIGFuZCBub3QganVzdCBsb3cgMjQgYml0cy4KCkJlZm9yZSB0
aGlzIGNoYW5nZSBrZXJuZWwgcHJpbnRlZCBtZXNzYWdlOgoiU3RhdHVzIGNvZGUgcmV0dXJuZWQg
MHg4MDAwMDAyZCBOVF9TVEFUVVNfTk9UX0NPTU1JVFRFRCIKCkl0IHdhcyBpbmNvcnJlY3QgYXMg
YmVjYXVzZSBOVF9TVEFUVVNfTk9UX0NPTU1JVFRFRCBpcyBkZWZpbmVkIGFzCjB4QzAwMDAwMmQg
YW5kIDB4ODAwMDAwMmQgaGFzIGRlZmluZWQgbmFtZSBOVF9TVEFUVVNfU1RPUFBFRF9PTl9TWU1M
SU5LLgoKV2l0aCB0aGlzIGNoYW5nZSBrZXJuZWwgcHJpbnRzIG1lc3NhZ2U6CiJTdGF0dXMgY29k
ZSByZXR1cm5lZCAweDgwMDAwMDJkIE5UX1NUQVRVU19TVE9QUEVEX09OX1NZTUxJTksiCgpTaWdu
ZWQtb2ZmLWJ5OiBQYWxpIFJvaMOhciA8cGFsaUBrZXJuZWwub3JnPgotLS0KIGZzL3NtYi9jbGll
bnQvbmV0bWlzYy5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvbmV0bWlzYy5jIGIvZnMv
c21iL2NsaWVudC9uZXRtaXNjLmMKaW5kZXggMGZmM2NjYzdhMzU2Li40ODMyYmM5ZGE1OTggMTAw
NjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvbmV0bWlzYy5jCisrKyBiL2ZzL3NtYi9jbGllbnQvbmV0
bWlzYy5jCkBAIC03NzUsMTAgKzc3NSwxMCBAQCBjaWZzX3ByaW50X3N0YXR1cyhfX3UzMiBzdGF0
dXNfY29kZSkKIAlpbnQgaWR4ID0gMDsKIAogCXdoaWxlIChudF9lcnJzW2lkeF0ubnRfZXJyc3Ry
ICE9IE5VTEwpIHsKLQkJaWYgKCgobnRfZXJyc1tpZHhdLm50X2VycmNvZGUpICYgMHhGRkZGRkYp
ID09Ci0JCSAgICAoc3RhdHVzX2NvZGUgJiAweEZGRkZGRikpIHsKKwkJaWYgKG50X2VycnNbaWR4
XS5udF9lcnJjb2RlID09IHN0YXR1c19jb2RlKSB7CiAJCQlwcl9ub3RpY2UoIlN0YXR1cyBjb2Rl
IHJldHVybmVkIDB4JTA4eCAlc1xuIiwKIAkJCQkgIHN0YXR1c19jb2RlLCBudF9lcnJzW2lkeF0u
bnRfZXJyc3RyKTsKKwkJCXJldHVybjsKIAkJfQogCQlpZHgrKzsKIAl9Ci0tIAoyLjQzLjAKCg==
--0000000000005043ce062c1976bc--
