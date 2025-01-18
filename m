Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B91136327
	for <linux-cifs@vger.kernel.org>; Sat, 18 Jan 2025 18:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737225776; cv=none; b=WPqs1fbS2UZrvxYKmIBsBmx4Ut7JqIYi0Jj1h07Gf4oePAlgEPADWykkHw5f5PrAJHmCKtpLlBrUr1mqwxerUvoGqmymDbgmnnOMTBqWvHStgGVDIVu9lJPCOHxGGgISHex+htxR09wk3Inl85FKXVju39eY0+Ax7+pumptqH7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737225776; c=relaxed/simple;
	bh=70UXL9BtlPmcec6keZNyBYUYFEdLbRHvg5AuuA7nRhs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TnyrjX+cSqlTll1ojsHhjz97FUsGoj/Hf/bXI0jkrsoB5O8LTDPRhIpWqVIJiqqpSoGNBx6kQsN5LgL98w7s8gPcg2WN+V1NUR6H1ANYhR+YU1ILMW4nEGvXL38mu2QQ93tKwUecIQNvtckZgsutlXXTMypBEeQA9yyEgJyW81M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W2i//QQI; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W2i//QQI"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-54026562221so3183908e87.1
        for <linux-cifs@vger.kernel.org>; Sat, 18 Jan 2025 10:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737225773; x=1737830573; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EKZm5MEL4e/2Q4INIIvJ46XgPiLHkxe+XUQcwsRafag=;
        b=W2i//QQI9UBXbjPGVnUkGxQL7/Fkme59lkP2dB9we4KXj3KorIh3rRpxSl5zA9tFR0
         yd/oaRh0+jNvOMuEVp5MVxVe7UAz6D+gbPh7vggXyeTZCNXtxJ3+4DunrVPDaM7aaAzL
         trlcXvA2YX+srohHXqOPI5YsX8bv+OV+XBPtEpuqxv0kzdQYHoWfaqxTTuJYqeKhKg1s
         sxrMXWCJ0Nm7fRyWe4eEdT1QaShGEtrk7j0TWQcchASksg3COBo4n1YoRitph40DDnxp
         8YBDf5PeNKIZ8gea3GEH2TJ2MVhdqWI5YjzcvmEKfI6boRA2nfEmJUDa9oX3KnqTD1EO
         uNCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737225773; x=1737830573;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EKZm5MEL4e/2Q4INIIvJ46XgPiLHkxe+XUQcwsRafag=;
        b=qzyTRP4+zlxchQNS4Fi/LcL7zzOHJyq6SC2A3kf5Y6yxz3RZNv7AHp3cMHiLq/2ZjY
         RilrQNUQvw2txO+7e2Rp9ZenuyzFMHNZSRLdAo9Kv4NnFYDI3rzfjb9UcUqdpY/Htt+s
         MU0O6S1RTld4mgP8NksGcpMsAMwbQdNPL87Y/ycCIpn/x8M4tBpAudDIZ/F3rijoJsvW
         kGSQLiwlfHRLAnFue6nZ2z38edjxoNbdqAqNLpjMBF4FaypQJ8SOlXKn1G6t3IVgz7lK
         xnMYSG54WW5Fy+T7w6Eq3dQUTWZWA8T6QT/M01gEizxne8WW/K3CVQkJpRc7lpiooknM
         1bFw==
X-Gm-Message-State: AOJu0Yz/ObkccmKOHX4AXMlrkaKngyJaESwFmYwusQO4w3OATiCZ0K0g
	nQuLvhv2y8WaBcBDhsaJHuP1ssJjLRZqyrddlDSNq8GWgmnE9UtxtIbb1uJXQl//FLeVz9jhJ2t
	z/g0a3sgGUM5HP+/ZSFj1N9UbSNE=
X-Gm-Gg: ASbGncswgX81WWNO+4Tu6zMzscaXd569fySteZGoYQWyIHjDO49jQ4lbHhpdoyhsceW
	96N7K006+5KGjJkLsxDuk5LXCVdSvJZ7i7EppGTFlQIDN/+EUDw1TN2Kzu9zZxQmWeWuRa/YjoW
	YzhH7and9j8w==
X-Google-Smtp-Source: AGHT+IFqCqAGgU30nXTTDF+Lv2CiW5WDpgQXemseo17qbB9BAPu8zkdVQvA/n5rH9Tks2G9dZMKDeE1fv16lgYLAnOk=
X-Received: by 2002:a05:6512:ad5:b0:542:8d45:cb3e with SMTP id
 2adb3069b0e04-5439c241016mr2712107e87.18.1737225772910; Sat, 18 Jan 2025
 10:42:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250116172903.666243-1-pc@manguebit.com> <CAH2r5mugqpmkbh5=TThZqp6XWGGCsOOdfQWvei2JjbKST-J0Nw@mail.gmail.com>
 <90151ee469458d74e7ada8b1fb2e85a0@manguebit.com>
In-Reply-To: <90151ee469458d74e7ada8b1fb2e85a0@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 18 Jan 2025 12:42:40 -0600
X-Gm-Features: AbW1kvZYXdzWp5qUvUkU_MhU7AFnhBQC2ihedPLfUhfSwDTM515Yi-Pqbo1OJ-M
Message-ID: <CAH2r5msO64YgexOJUr7cVaQ_tm+cCHMW-v7hBh5bCYgTqdwH5w@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix oops due to unset link speed
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, Shyam Prasad N <nspmangalore@gmail.com>, 
	Tom Talpey <tom@talpey.com>, Frank Sorenson <sorenson@redhat.com>, Jay Shin <jaeshin@redhat.com>
Content-Type: multipart/mixed; boundary="000000000000173692062bff65cf"

--000000000000173692062bff65cf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It tests to make sure the number of expected channels is setup
(basically does a mount, and checks to make sure two connected
channels).  IIRC written by Ronnie

On Sat, Jan 18, 2025 at 12:16=E2=80=AFPM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>
> Steve French <smfrench@gmail.com> writes:
>
> > With current for-next which includes this patch I noticed xfstest
> > cifs/104 now failing
>
> I can't find cifs/104 in xfstests.  What does this test do?



--=20
Thanks,

Steve

--000000000000173692062bff65cf
Content-Type: application/octet-stream; name="104.out"
Content-Disposition: attachment; filename="104.out"
Content-Transfer-Encoding: base64
Content-ID: <f_m62jclvy0>
X-Attachment-Id: f_m62jclvy0

UUEgb3V0cHV0IGNyZWF0ZWQgYnkgMTA0CgkJW0NPTk5FQ1RFRF0KCQlbQ09OTkVDVEVEXQo=
--000000000000173692062bff65cf
Content-Type: application/octet-stream; name=104
Content-Disposition: attachment; filename=104
Content-Transfer-Encoding: base64
Content-ID: <f_m62jclw91>
X-Attachment-Id: f_m62jclw91

IyEvYmluL2Jhc2gKIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMAojCiMgRlMgUUEg
VGVzdCBOby4gY2lmcy8xMDQKIwojIENoZWNrIHdlIGdldCAyIGNoYW5uZWxzIGZvciBtdWx0aWNo
YW5uZWwKIwpzZXE9YGJhc2VuYW1lICQwYApzZXFyZXM9JFJFU1VMVF9ESVIvJHNlcQplY2hvICJR
QSBvdXRwdXQgY3JlYXRlZCBieSAkc2VxIgoKaGVyZT1gcHdkYAp0bXA9L3RtcC8kJApzdGF0dXM9
MQkjIGZhaWx1cmUgaXMgdGhlIGRlZmF1bHQhCgojIGdldCBzdGFuZGFyZCBlbnZpcm9ubWVudCwg
ZmlsdGVycyBhbmQgY2hlY2tzCi4gLi9jb21tb24vcmMKLiAuL2NvbW1vbi9maWx0ZXIKCiMgcmVh
bCBRQSB0ZXN0IHN0YXJ0cyBoZXJlCl9zdXBwb3J0ZWRfZnMgY2lmcwpfcmVxdWlyZV90ZXN0Cgoj
IGNyZWF0ZSBhIHRlc3QgZmlsZQpjYXQgL3Byb2MvZnMvY2lmcy9EZWJ1Z0RhdGEgfCBncmVwIENP
Tk5FQ1RFRAoKc3RhdHVzPTAKZXhpdAo=
--000000000000173692062bff65cf--
