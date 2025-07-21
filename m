Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84031163
	for <linux-cifs@vger.kernel.org>; Mon, 21 Jul 2025 00:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753056344; cv=none; b=naPtd0u/C7UunMazbxJ/5I95cmCYmU7JJgAeK/96kRbxY5cSBaERy4bc+AbX4m97j4JkuN7W4j2H9JJX44TGdGuQURT34LDTkbzPNz0cQQlYQagybP3Tyy4TCQsvxkLQlACaKXn/4TeTu30VQuneDSMw8AyczFnyv+7cxE/owyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753056344; c=relaxed/simple;
	bh=/4JWT4wvV6o6suAJJHTjgXVsyUgR2jrvIGoUMEOKJ8g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YrsyOep7744N9Dm5l+5MDHFN5ZPs3uubcRDFCMnb/GeHHYf2Z2IgAC+etechUWoBWP/YtFqpIstnOLpqA/A36YQ8/WSX7B72YCTpQIZ+kMvUbvL22wtE0PZu79bBKk1QizQ6N0AuOXTi3Z7kFT32sYz9rpW4nTpg1Z65zfPNpQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nMjZOjIb; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nMjZOjIb"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6face367320so35801896d6.3
        for <linux-cifs@vger.kernel.org>; Sun, 20 Jul 2025 17:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753056341; x=1753661141; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tXeIerK3aV86uaA4LpJJ4yTl1PsEdK0JH+Lx0S4zs2U=;
        b=nMjZOjIbRsCu/IB1T8IvkVjWkSEi/1vud6h9y9qxcrgrEen4V0PYzWYIz9Wdg5nSkM
         3xoqHinEEeGsB4vOY04AmbzUv7nA5cq6jfyclifXg9V7KGTYIm6AGzl5iaPhdz/iKYvn
         UMEhcx1vocn0YPelWMXPbnTUa6OWBvtIBTjXoq0GZu1IhzeOU/fXIf9pp/trCrXutczO
         DKskRZvVoP8ghivg1wE4j9unNobTGqyaM/FIjXktsdV9PTAntfefB904V0rHBnC+wfNZ
         6ufIFgc8vtMxuaKaNBP2cvhNn4xe+DUUXPNQulhdeZiHoTwBLdXa2PlP3LsFsbSHowsi
         KGcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753056341; x=1753661141;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tXeIerK3aV86uaA4LpJJ4yTl1PsEdK0JH+Lx0S4zs2U=;
        b=oJCseU1V0+nyBCS/sMDQugVkXqcslWVMedy7bTJ8CdE7vFrJQ3l9AlCpjkQbHMqd9e
         jva1UHBaqgdWGEs2pOmJwyI5NwOAlEWmD+DPyLrX5D8tG2WNXEVjPGdra1BfmNkJh0Qu
         RXYtFXTVGByA3fR6FHheSWSrth2YQvaYrS+CVmAEXguPwSDMOfXwMX5iGn1Y+msiddc3
         mBAnlpxt0/snnPJ0UITldQf+a51CxriAj6G7OxTiOio/OLapS+UnSvisF88oExRp4f7h
         PC4FGT2GMRMTsFgoR4TBTal1xNaj/6at5qV09aZjm0t+Hb7Kj32+zhfGOQUytiYuHRzE
         xWcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVb7+pz3sXTLSMhNDlDugo/dhXIj0H5XDEkfCPJOS68denXW0EGuDCJIwJfJSdHS+j2eQm5cNeMvB4M@vger.kernel.org
X-Gm-Message-State: AOJu0YxBOafq8D0UrYrxsQj58SYzbXIRZHJhyDXxyrxEtjZK9mimqK2i
	ru7+lONcufybN9UjYbQP3egU0njaeDg0NGyBekTo1l0OlVyS3lTfrgjV9+aKYN8O/mpCPpi9cRs
	O0HicwgtGHNC0kTRg7b8+CyG3HmV+H0s=
X-Gm-Gg: ASbGnctoCv7pjklUgRCJHCwh/eVaVjMs6Q903wdtTeRCAt1sQE/ApcbwJIrNW6+NMmI
	tIyGcGbecY9zZvyqNn1I5AcD2edAR8ogZ2dzMYDWmcmihu66ZbLUIfEzqGeo+wKvndZQq2rNXSr
	UejLa6n6cbTh0wUw+DudVyOlPadbV/4a1JGTfAhvxZivArdkX9jPKXiwLwriCafCy4apixScQc5
	EUUOVV42NPLJhdBdLR9b3ZCT+iXbJQW4R23Y9+5XQ==
X-Google-Smtp-Source: AGHT+IHePbFOpLuF7+RUEbbDVGapIzqTm/b+9jYm+LsYMqtfu5B0kKTrbqoarPUFQ92f75P9L5zw+TnV3ctwEEm+Nss=
X-Received: by 2002:ad4:5bef:0:b0:702:d6e7:18bf with SMTP id
 6a1803df08f44-704f69eb3d0mr251942066d6.3.1753056341224; Sun, 20 Jul 2025
 17:05:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5msVdabcDudGyR47StT_VoKazD_A0kdAaGMRh+UD060PhQ@mail.gmail.com>
In-Reply-To: <CAH2r5msVdabcDudGyR47StT_VoKazD_A0kdAaGMRh+UD060PhQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 20 Jul 2025 19:05:29 -0500
X-Gm-Features: Ac12FXxPGouuhGf3Zg338WxXL4xxpSJSyzePBFIUGWQ6reALM5UfwW6v0ANev9A
Message-ID: <CAH2r5mtQ1CnAph8mvuFQ3bhhPwHqiCM4OZ74cuf_55PmUYZvKA@mail.gmail.com>
Subject: Re: Updated SMB3.1.1 POSIX testing results to Samba
To: samba-technical <samba-technical@lists.samba.org>, CIFS <linux-cifs@vger.kernel.org>
Cc: =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: multipart/mixed; boundary="0000000000007e2c83063a653c38"

--0000000000007e2c83063a653c38
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I have also done a detailed test run of all tests to ksmbd with
"linux" (SMB3.1.1 POSIX Extensions) with current mainline and 215 test
cases pass (some different than what pass and fail to Samba so likely
some SMB3.1.1 POSIX extensions server bugs in both ksmbd and Samba,
not just client bugs).  A large number of the client test case
failures look to be related to a possible deferred close client bug
which causes "directory not empty" at the end of various tests.

Here is the detailed test results to Samba with SMB3.1.1 POSIX Extensions:
  https://wiki.samba.org/index.php/Xfstest-results-Samba-Linux

and here for comparison is the detailed results to ksmbd with the
SMB3.1.1 POSIX Extensions
  https://wiki.samba.org/index.php/Xfstest-results-ksmbd

Both are obviously much better than previous releases so there has
been much improvement.  Very promising.

Also attached are two scripts - one to run all tests that are expected
to pass to Samba, and the other which runs all tests that are expected
to pass to ksmb.  I will be updating the 'buildbot' regression testing
suite based on this so we don't have any regressions slip through as
implementation of the SMB3.1.1 POSIX Extensions continues to improve.


On Thu, Jul 17, 2025 at 11:07=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> I have done a detailed update of the passing and failing and skipped
> (e.g. when test only relevant to local filesystems) tests, and updated
> the wiki page so others can add their observations etc.  See below:
>
>     https://wiki.samba.org/index.php/Xfstest-results-Samba-Linux
>
> There are 231 currently passing xfstests from current Linux client to
> current Samba which is very good news.
>
> Attached is a script ("run-smb311-linux-tests) which will run all 231
> passing tests.
>
> The failing tests are listed clearly in the wiki, and likely many of
> them are going to be easy fixes (especially those failing with
> incorrect mode bits or unexpected access denied).  Fixes welcome,
> since there are about 140 tests to dig into more (many of which may
> eventually turn out not to be relevant).
>
> As we fix additional of these, I plan to remove the "experimental"
> warning that log during mount with "linux" (or "posix") for smb3.1.1
> client mounts, since I am seeing huge benefits with the SMB3.1.1
> Linux/POSIX extensions already.
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

--0000000000007e2c83063a653c38
Content-Type: application/octet-stream; name=run-smb311-linux-tests-ksmbd
Content-Disposition: attachment; filename=run-smb311-linux-tests-ksmbd
Content-Transfer-Encoding: base64
Content-ID: <f_mdccemm20>
X-Attachment-Id: f_mdccemm20

Li9jaGVjayAtY2lmcyBjaWZzLzAwMSBnZW5lcmljLzAwMSBnZW5lcmljLzAwMiBnZW5lcmljLzAw
NSBnZW5lcmljLzAwNiBnZW5lcmljLzAwNyBnZW5lcmljLzAwOCBnZW5lcmljLzAxMCBnZW5lcmlj
LzAxMSBnZW5lcmljLzAxMyBnZW5lcmljLzAxNCBnZW5lcmljLzAyMCBnZW5lcmljLzAyMyBnZW5l
cmljLzAyNCBnZW5lcmljLzAyOCBnZW5lcmljLzAyOSBnZW5lcmljLzAzMCBnZW5lcmljLzAzMiBn
ZW5lcmljLzAzMyBnZW5lcmljLzAzNiBnZW5lcmljLzAzNyBnZW5lcmljLzA0MyBnZW5lcmljLzA0
NCBnZW5lcmljLzA0NSBnZW5lcmljLzA0NiBnZW5lcmljLzA0NyBnZW5lcmljLzA0OCBnZW5lcmlj
LzA0OSBnZW5lcmljLzA1MSBnZW5lcmljLzA2OSBnZW5lcmljLzA3MCBnZW5lcmljLzA3MSBnZW5l
cmljLzA3MiBnZW5lcmljLzA3NCBnZW5lcmljLzA4MCBnZW5lcmljLzA4NCBnZW5lcmljLzA4NiBn
ZW5lcmljLzA5MSBnZW5lcmljLzA5NSBnZW5lcmljLzA5OCBnZW5lcmljLzEwMCBnZW5lcmljLzEw
MyBnZW5lcmljLzEwOSBnZW5lcmljLzExMCBnZW5lcmljLzExMSBnZW5lcmljLzExMiBnZW5lcmlj
LzExMyBnZW5lcmljLzExNSBnZW5lcmljLzExNiBnZW5lcmljLzExNyBnZW5lcmljLzExOCBnZW5l
cmljLzExOSBnZW5lcmljLzEyNCBnZW5lcmljLzEyNSBnZW5lcmljLzEyNyBnZW5lcmljLzEyOSBn
ZW5lcmljLzEzMCBnZW5lcmljLzEzMiBnZW5lcmljLzEzMyBnZW5lcmljLzEzNCBnZW5lcmljLzEz
NSBnZW5lcmljLzEzOCBnZW5lcmljLzEzOSBnZW5lcmljLzE0MCBnZW5lcmljLzE0MSBnZW5lcmlj
LzE0MiBnZW5lcmljLzE0MyBnZW5lcmljLzE0NCBnZW5lcmljLzE0NiBnZW5lcmljLzE0OCBnZW5l
cmljLzE0OSBnZW5lcmljLzE1MCBnZW5lcmljLzE1MSBnZW5lcmljLzE1MiBnZW5lcmljLzE1MyBn
ZW5lcmljLzE1NCBnZW5lcmljLzE1NSBnZW5lcmljLzE2OSBnZW5lcmljLzE3OCBnZW5lcmljLzE3
OSBnZW5lcmljLzE4MCBnZW5lcmljLzE4MSBnZW5lcmljLzE5OCBnZW5lcmljLzIwNyBnZW5lcmlj
LzIwOCBnZW5lcmljLzIwOSBnZW5lcmljLzIxMCBnZW5lcmljLzIxMiBnZW5lcmljLzIxNCBnZW5l
cmljLzIxNSBnZW5lcmljLzIyMSBnZW5lcmljLzIyNSBnZW5lcmljLzIyOCBnZW5lcmljLzIzNiBn
ZW5lcmljLzIzOSBnZW5lcmljLzI0MSBnZW5lcmljLzI0NSBnZW5lcmljLzI0NiBnZW5lcmljLzI0
NyBnZW5lcmljLzI0OCBnZW5lcmljLzI0OSBnZW5lcmljLzI1NSBnZW5lcmljLzI1NyBnZW5lcmlj
LzI1OCBnZW5lcmljLzI4NSBnZW5lcmljLzMwOCBnZW5lcmljLzMwOSBnZW5lcmljLzMxMCBnZW5l
cmljLzMxMyBnZW5lcmljLzMxNSBnZW5lcmljLzMxNiBnZW5lcmljLzMyMyBnZW5lcmljLzMzNyBn
ZW5lcmljLzMzOSBnZW5lcmljLzM0MCBnZW5lcmljLzM0NCBnZW5lcmljLzM0NSBnZW5lcmljLzM0
NiBnZW5lcmljLzM1NCBnZW5lcmljLzM2MCBnZW5lcmljLzM2MiBnZW5lcmljLzM2NCBnZW5lcmlj
LzM2NiBnZW5lcmljLzM3NyBnZW5lcmljLzM3OCBnZW5lcmljLzM5MSBnZW5lcmljLzM5MiBnZW5l
cmljLzM5MyBnZW5lcmljLzM5NCBnZW5lcmljLzQwNiBnZW5lcmljLzQwNyBnZW5lcmljLzQxMiBn
ZW5lcmljLzQxNyBnZW5lcmljLzQyMCBnZW5lcmljLzQyMiBnZW5lcmljLzQyOCBnZW5lcmljLzQz
MCBnZW5lcmljLzQzMSBnZW5lcmljLzQzMiBnZW5lcmljLzQzMyBnZW5lcmljLzQzNiBnZW5lcmlj
LzQzNyBnZW5lcmljLzQzOCBnZW5lcmljLzQzOSBnZW5lcmljLzQ0MyBnZW5lcmljLzQ0NSBnZW5l
cmljLzQ0NiBnZW5lcmljLzQ0OCBnZW5lcmljLzQ1MSBnZW5lcmljLzQ1MiBnZW5lcmljLzQ2MCBn
ZW5lcmljLzQ2MSBnZW5lcmljLzQ2MyBnZW5lcmljLzQ2NCBnZW5lcmljLzQ2NSBnZW5lcmljLzQ2
OCBnZW5lcmljLzQ2OSBnZW5lcmljLzQ3MSBnZW5lcmljLzQ3NCBnZW5lcmljLzQ3NiBnZW5lcmlj
LzQ5MCBnZW5lcmljLzQ5MSBnZW5lcmljLzQ5OSBnZW5lcmljLzUwNCBnZW5lcmljLzUyMyBnZW5l
cmljLzUyNCBnZW5lcmljLzUyNSBnZW5lcmljLzUyOCBnZW5lcmljLzUzMiBnZW5lcmljLzUzMyBn
ZW5lcmljLzU1MSBnZW5lcmljLzU2NyBnZW5lcmljLzU2OCBnZW5lcmljLzU3MSBnZW5lcmljLzU5
MCBnZW5lcmljLzU5MSBnZW5lcmljLzU5OSBnZW5lcmljLzYwNCBnZW5lcmljLzYwOSBnZW5lcmlj
LzYxMCBnZW5lcmljLzYxMiBnZW5lcmljLzYxNSBnZW5lcmljLzYxNiBnZW5lcmljLzYxNyBnZW5l
cmljLzYxOCBnZW5lcmljLzYzMiBnZW5lcmljLzYzNyBnZW5lcmljLzYzOCBnZW5lcmljLzYzOSBn
ZW5lcmljLzY0MiBnZW5lcmljLzY0NiBnZW5lcmljLzY0NyBnZW5lcmljLzY1MCBnZW5lcmljLzY3
NiBnZW5lcmljLzY3OCBnZW5lcmljLzY5NCBnZW5lcmljLzcwMSBnZW5lcmljLzcwNiBnZW5lcmlj
LzcwNyBnZW5lcmljLzcwOCBnZW5lcmljLzcyOCBnZW5lcmljLzcyOSBnZW5lcmljLzczNiBnZW5l
cmljLzczNyBnZW5lcmljLzc0MiBnZW5lcmljLzc0OCBnZW5lcmljLzc0OSBnZW5lcmljLzc1MCBn
ZW5lcmljLzc1MSBnZW5lcmljLzc1NSBnZW5lcmljLzc1OCBnZW5lcmljLzc1OSBnZW5lcmljLzc2
MCBnZW5lcmljLzc2MSBnZW5lcmljLzc2Mwo=
--0000000000007e2c83063a653c38
Content-Type: application/octet-stream; name=run-smb311-linux-tests-samba
Content-Disposition: attachment; filename=run-smb311-linux-tests-samba
Content-Transfer-Encoding: base64
Content-ID: <f_mdccewuz1>
X-Attachment-Id: f_mdccewuz1

Li9jaGVjayAtY2lmcyBjaWZzLzAwMSBnZW5lcmljLzAwMSBnZW5lcmljLzAwMiBnZW5lcmljLzAw
NSBnZW5lcmljLzAwNiBnZW5lcmljLzAwNyBnZW5lcmljLzAwOCBnZW5lcmljLzAxMCBnZW5lcmlj
LzAxMSBnZW5lcmljLzAxMiBnZW5lcmljLzAxMyBnZW5lcmljLzAxNCBnZW5lcmljLzAxNiBnZW5l
cmljLzAyMCBnZW5lcmljLzAyMSBnZW5lcmljLzAyMiBnZW5lcmljLzAyMyBnZW5lcmljLzAyNCBn
ZW5lcmljLzAyOCBnZW5lcmljLzAyOSBnZW5lcmljLzAzMCBnZW5lcmljLzAzMSBnZW5lcmljLzAz
MiBnZW5lcmljLzAzMyBnZW5lcmljLzAzNiBnZW5lcmljLzAzNyBnZW5lcmljLzA0MyBnZW5lcmlj
LzA0NCBnZW5lcmljLzA0NSBnZW5lcmljLzA0NiBnZW5lcmljLzA0NyBnZW5lcmljLzA0OCBnZW5l
cmljLzA0OSBnZW5lcmljLzA1MSBnZW5lcmljLzA2NCBnZW5lcmljLzA2OCBnZW5lcmljLzA2OSBn
ZW5lcmljLzA3MCBnZW5lcmljLzA3MSBnZW5lcmljLzA3MiBnZW5lcmljLzA3NCBnZW5lcmljLzA3
NSBnZW5lcmljLzA4MCBnZW5lcmljLzA4NCBnZW5lcmljLzA4NiBnZW5lcmljLzA5MSBnZW5lcmlj
LzA5NSBnZW5lcmljLzA5OCBnZW5lcmljLzEwMCBnZW5lcmljLzEwMyBnZW5lcmljLzEwOSBnZW5l
cmljLzExMCBnZW5lcmljLzExMSBnZW5lcmljLzExMiBnZW5lcmljLzExMyBnZW5lcmljLzExNSBn
ZW5lcmljLzExNiBnZW5lcmljLzExNyBnZW5lcmljLzExOCBnZW5lcmljLzExOSBnZW5lcmljLzEy
NCBnZW5lcmljLzEyNSBnZW5lcmljLzEyNyBnZW5lcmljLzEyOSBnZW5lcmljLzEzMCBnZW5lcmlj
LzEzMiBnZW5lcmljLzEzMyBnZW5lcmljLzEzNCBnZW5lcmljLzEzNSBnZW5lcmljLzEzOCBnZW5l
cmljLzEzOSBnZW5lcmljLzE0MCBnZW5lcmljLzE0MSBnZW5lcmljLzE0MiBnZW5lcmljLzE0MyBn
ZW5lcmljLzE0NCBnZW5lcmljLzE0NSBnZW5lcmljLzE0NiBnZW5lcmljLzE0NyBnZW5lcmljLzE0
OCBnZW5lcmljLzE0OSBnZW5lcmljLzE1MCBnZW5lcmljLzE1MSBnZW5lcmljLzE1MiBnZW5lcmlj
LzE1MyBnZW5lcmljLzE1NCBnZW5lcmljLzE1NSBnZW5lcmljLzE2OSBnZW5lcmljLzE3OCBnZW5l
cmljLzE3OSBnZW5lcmljLzE4MCBnZW5lcmljLzE4MSBnZW5lcmljLzE4NCBnZW5lcmljLzE5OCBn
ZW5lcmljLzIwNyBnZW5lcmljLzIwOCBnZW5lcmljLzIwOSBnZW5lcmljLzIxMCBnZW5lcmljLzIx
MiBnZW5lcmljLzIxNCBnZW5lcmljLzIxNSBnZW5lcmljLzIyMSBnZW5lcmljLzIyNSBnZW5lcmlj
LzIyOCBnZW5lcmljLzIzNiBnZW5lcmljLzIzOSBnZW5lcmljLzI0MSBnZW5lcmljLzI0NSBnZW5l
cmljLzI0NiBnZW5lcmljLzI0NyBnZW5lcmljLzI0OCBnZW5lcmljLzI0OSBnZW5lcmljLzI1NSBn
ZW5lcmljLzI1NyBnZW5lcmljLzI1OCBnZW5lcmljLzI2MyBnZW5lcmljLzI5NCBnZW5lcmljLzMw
NiBnZW5lcmljLzMwOCBnZW5lcmljLzMwOSBnZW5lcmljLzMxMCBnZW5lcmljLzMxMyBnZW5lcmlj
LzMxNSBnZW5lcmljLzMxNiBnZW5lcmljLzMyMyBnZW5lcmljLzMzNyBnZW5lcmljLzMzOSBnZW5l
cmljLzM0MCBnZW5lcmljLzM0NCBnZW5lcmljLzM0NSBnZW5lcmljLzM0NiBnZW5lcmljLzM1NCBn
ZW5lcmljLzM2MCBnZW5lcmljLzM2MiBnZW5lcmljLzM2NCBnZW5lcmljLzM2NiBnZW5lcmljLzM3
NyBnZW5lcmljLzM5MCBnZW5lcmljLzM5MSBnZW5lcmljLzM5MiBnZW5lcmljLzM5MyBnZW5lcmlj
LzM5NCBnZW5lcmljLzQwNiBnZW5lcmljLzQwNyBnZW5lcmljLzQxMiBnZW5lcmljLzQxNyBnZW5l
cmljLzQyMCBnZW5lcmljLzQyMiBnZW5lcmljLzQyMyBnZW5lcmljLzQyOCBnZW5lcmljLzQzMCBn
ZW5lcmljLzQzMSBnZW5lcmljLzQzMiBnZW5lcmljLzQzMyBnZW5lcmljLzQzNCBnZW5lcmljLzQz
NiBnZW5lcmljLzQzNyBnZW5lcmljLzQzOCBnZW5lcmljLzQzOSBnZW5lcmljLzQ0MyBnZW5lcmlj
LzQ0NSBnZW5lcmljLzQ0NiBnZW5lcmljLzQ0OCBnZW5lcmljLzQ1MSBnZW5lcmljLzQ1MiBnZW5l
cmljLzQ2MCBnZW5lcmljLzQ2MSBnZW5lcmljLzQ2MyBnZW5lcmljLzQ2NCBnZW5lcmljLzQ2NSBn
ZW5lcmljLzQ2OSBnZW5lcmljLzQ3MSBnZW5lcmljLzQ3NCBnZW5lcmljLzQ3NiBnZW5lcmljLzQ5
MSBnZW5lcmljLzQ5OSBnZW5lcmljLzUwNCBnZW5lcmljLzUyMyBnZW5lcmljLzUyNCBnZW5lcmlj
LzUyNSBnZW5lcmljLzUyOCBnZW5lcmljLzUzMiBnZW5lcmljLzUzMyBnZW5lcmljLzU1MSBnZW5l
cmljLzU2NCBnZW5lcmljLzU2NSBnZW5lcmljLzU2NyBnZW5lcmljLzU2OCBnZW5lcmljLzU3MSBn
ZW5lcmljLzU4NiBnZW5lcmljLzU5MCBnZW5lcmljLzU5MSBnZW5lcmljLzU5OSBnZW5lcmljLzYw
NCBnZW5lcmljLzYwOSBnZW5lcmljLzYxMCBnZW5lcmljLzYxMiBnZW5lcmljLzYxNSBnZW5lcmlj
LzYxNiBnZW5lcmljLzYxNyBnZW5lcmljLzYxOCBnZW5lcmljLzYyMyBnZW5lcmljLzYzMiBnZW5l
cmljLzYzOCBnZW5lcmljLzYzOSBnZW5lcmljLzY0MiBnZW5lcmljLzY0NiBnZW5lcmljLzY0NyBn
ZW5lcmljLzY1MCBnZW5lcmljLzY3NiBnZW5lcmljLzY3OCBnZW5lcmljLzY4MCBnZW5lcmljLzY5
NCBnZW5lcmljLzcwMSBnZW5lcmljLzcwNSBnZW5lcmljLzcwNiBnZW5lcmljLzcwOCBnZW5lcmlj
LzcyOCBnZW5lcmljLzcyOSBnZW5lcmljLzczNiBnZW5lcmljLzczNyBnZW5lcmljLzc0MiBnZW5l
cmljLzc0OCBnZW5lcmljLzc0OSBnZW5lcmljLzc1MSBnZW5lcmljLzc1NSBnZW5lcmljLzc1OCBn
ZW5lcmljLzc1OSBnZW5lcmljLzc2MCBnZW5lcmljLzc2MSBnZW5lcmljLzc2MyAK
--0000000000007e2c83063a653c38--
