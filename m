Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792519120;
	b=mHSElvhYE+5f2WPf05gYwESLT1IMMy0jamGNXiYWENdQzcgIMJS0NKKXPaX+YAVH22KU
	 2nQL9B/M31mCHhT0vyrgUEj3xzdjk8/Pzh+Bof9syyuMK9x8EOtndvApv6iQv1yTXfhTb
	 9j5Pg+QzdNgCplSJilJMQZGamjLDaA/regE24GupepQKNb7Oek1mx4zKUNju3csUpN3dR
	 WfzhsunScWNO16f8ccCwXTATT2/lg1x2V6f5DHY9qIfThBhvto6+iZlviWaz61v+b8GR4
	 yDXXWXkbephAjUueAJJLNzI2+L6QcsHNmUDiqxi2TzL8WANRUzBhllzrC5a3PVLrfWg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792519120;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=kcrZTV4N08Els2qRWHt90sKC/lDaR21OyU/ZHFR17pE=;
	b=QNFKyU2l9RBbQbRLcIr/TvLoOfwEkssKlU5JwOG7uKdaNy6gbwUUA/Kba/XBxMAuqJno
	 GB2AMk9fBaPHpxW/9yvSVgV344dDC3zfDiFCKtQYFC9I8/WWPjMGczAHe+jhhJGnLPHsI
	 4/7UC7rLw7UJFnu/uQ4Cw18qHMaiHmqiFynwdQsCvfemqo5fIOnfRlTpcG+vqkvrVziKd
	 Vhioi19/EyA0k/Voe11M/TraWyHGKMXwWWrLDWmAN7EkJQO7sK2jKVPltdjhJOFuLScwR
	 93SaKgSiPQvEy0gT+OWbrHNLoyLvK3bzfJPNzm9f4y+PaxM6ANFfDftzhLbtG2ROqLw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=a7rxOVVY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.42
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676BD606A321
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 17:58:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 676BD606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=a7rxOVVY
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-6768403e9bbso2590852d50.1
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 10:58:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792519119; cv=none;
        d=google.com; s=arc-20260327;
        b=HWc4XFS2fuujNxxOet+nUlvRYWxS24uep6tPMEqmNoy0CrnSVT7cs94o4pI0VOGu6t
         vpWD/yRuOu019MpK/rY4n20DfZ46i3L3dgSkSn3LPrvngXXenpbAqk2favGLpZlcpprG
         60cBNyWnqLD6wRIWOHcJBChPIozbdTbicxHArKomx68r/MTGssFbry0JApf9Lgvki4vb
         0gKFqbPc4HEBAn2eVkIMgiA7QTzHSYbhiThHfwb9issd6dU/encGTouMSWyCrXN/MQyE
         HxuLwEZSD8i3eAtuwHZWoTS8mzZaFx3B5rhQxrccutd+cURezY19TSnOKbwyxXaUooa+
         9DqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kcrZTV4N08Els2qRWHt90sKC/lDaR21OyU/ZHFR17pE=;
        fh=VWf8lZeTfQjMdpU419BmmO3Q16u//zHZPob0fhVJj4I=;
        b=nkm/V6znNgxAxmuDWbqzrUH/vqBxRS4vcqQ4YBwaae/PCxVPMwwtQ/Ul18mzeaWk4/
         +CNaJf3y44Ezgm0PCwrrbV8xzV/2L4sIh2ijd1UZvDBmTxEnhg+t+VbwEF7fwc8qDZbe
         RPWJ82gu6pzhH/kaz8kZTq7KCBfgPS4nLkkY2HbUhFbA36/hVKklk4rrhtDALPlZjy4p
         UhhAsuam8U//xdp+tdbOP5SFPkadOa+b+D8X3O7RVXzn+qJJG38Zj0D62ZPirdDzw4w/
         tSH7xFZ1X9MMUgExnslBOo4QEpogCRnYjr+dLsRXoulvziafPn+oEgtzqoykH/fwH2yo
         pVjQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792519119; x=1793123919; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kcrZTV4N08Els2qRWHt90sKC/lDaR21OyU/ZHFR17pE=;
        b=a7rxOVVYwNQoNm7X+Z3kkqlfq5yAIJkIsxUhn2GjT2PkNlk3HZMSA30LAVJcWAhanu
         POx5bFDNd57qaGss0ST6V4V8RR9Gk7jHrmvv/JSbx71NJHldnq3IzN5aaMazbwG9yGjw
         zBr/PhBfNf8KopFuA8oelWMysHVnTwmDWR4pl+R3EyAeEtNI9X+m1EevSZy1xLdjUGbj
         tQZd/Tp4cdswHbq6Ic5qlVu3QvMd+lbXbPJvBEpBLVP4rzfigKbLh7qOuXiODcjtaPjz
         wiT74VqqLOWBjPaxYTz0ZueSXCEZ4V2WvyPSq/1WR5uuaqhykQXh+GAfduWUTRMON7U8
         hjxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792519119; x=1793123919;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kcrZTV4N08Els2qRWHt90sKC/lDaR21OyU/ZHFR17pE=;
        b=j1ZcFVs8D03sT6sTUHdFOHSpEuu82I7hllmedmdwNopn4TDleNO/LKb+51I8Ol83vh
         HsN71TgfHEYfVugq8l/9LgDPtofRpBTtA/aQY+dqnknm7T57GiJtu51r5PfhvnjbTbGA
         hTqIPVl9rddulKjugMTBdUIRsDfccyII+h0wCt+gfdigwvDdD0x4+Yi+kdhdtem2SHoe
         vv+8Uaqu0bPXLCLa3cZ/goRiH6y4vARdmmoT504MVZTFbnjcMNS1uTfYcrm8kYYDO+Ag
         g7yCOVGcKvTGPJ12Sz7chDK9lEX/WcWrSY8IRHiU28U9N07RO8KsSZDVtBT93aZEBVb6
         xJiw==
X-Gm-Message-State: AFq9FYIw3SUCrFYJ9swfzsdpyb5n2VVn3oRlQj+Lh+eY2Buz9rmUDFZK
	EGJ9B0EDQxgKzMOlvzX5ho+ktSQZM3LoWzPaQI5cY+F+wpe83ULAwBj0naUAD8u6lsCjyEV0in7
	oG8ifz9A8C9/LckfsgHlRFZqOMNgA/y02gu/v
X-Gm-Gg: AYBFou1fVZ68Q813cpmuHUC25VkIBQAT3rt+w+/4Zj+FXpsVxV0wUuxn+f397kuqPXX
	WrevAHQ3LbxpZwaUNmbzZ4u5ndbJBZFFcryE0oCboC2jY4D3zIdSdlC34TbazncFE+L+UNqKg+v
	75KtcuiFIECwaQVr5MZ4avVW0naXJnr1M4rMNg5bPAQ3fya0P1MzVHyUF7U18/yUcIB4LzL83rj
	MTF8fZLF9V+E2TaJV8OiWuzn6XyLBdXMei62xRmcn+/UgHm8foHcSclNC1JG+oBLjPKEXYA51ID
	DCMag0aSeRMCYJ2697toJtJKCbnpdpaj6LcalW+1Ltzn+Q0WjJjPOblFZVZZejrx2Fqo6szDWf7
	6iL+zO0qhUYDwEPccVcUovac=
X-Received: by 2002:a05:690e:13cb:b0:677:c075:a57a with SMTP id
 956f58d0204a3-679ca9222aamr3644944d50.108.1792519119382; Tue, 20 Oct 2026
 10:58:39 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAD37_9gGnApAuagqOuZ13WB=DW8c_ZpWFBX4cE00YtGhmE2PbQ@mail.gmail.com>
 <CAKYAXd_FXeaK2GBRgskkTNBXVjJc92qNDP0S_39u=Eb19h1rBw@mail.gmail.com>
In-Reply-To: <CAKYAXd_FXeaK2GBRgskkTNBXVjJc92qNDP0S_39u=Eb19h1rBw@mail.gmail.com>
From: Mohammed <mohammed.saad.alquraini@gmail.com>
Date: Tue, 20 Oct 2026 20:58:28 +0300
X-Gm-Features: AclHuK_J5xqqRLd0wMHTkhq_7u7ZWQXtJG7RAlUxkQ9G6Fml8HA1n0SRuPnN5ME
Message-ID: <CAD37_9i9R1rUjBQU-pS83KzP-Ma_gNkfMGJFq5sH-CObYZdnMg@mail.gmail.com>
Subject: Re: [Bug report] ksmbd: fd_limit leaks a slot per durable-handle
 reconnect -> cross-user open DoS
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Namjae,

Yes, this patch fixes the issue. Thanks for the quick response and fix!

Best,
Mohammed Alquraini

On Tue, Oct 20, 2026 at 4:47=E2=80=AFAM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Tue, Oct 20, 2026 at 8:48=E2=80=AFAM Mohammed
> <mohammed.saad.alquraini@gmail.com> wrote:
> >
> > Hello Namjae,
> Hi Mohammed,
>
> >
> > ksmbd's global open-file counter (fd_limit) leaks one slot per durable-=
handle
> > reconnect, so an authenticated user can exhaust the server-wide budget =
and deny
> > other users' opens. Validated end-to-end on an unmodified kernel; every=
 number
> > below is measured. Found with an LLM-assisted code-analysis pipeline (d=
isclosed
> > up front per security-bugs.rst). Low severity -- it needs a non-default=
 config
> > and the cap is already soft (see caveat), so this is a regular bug for =
the
> > public list, not a security@ case.
> Can you check if an attached patch fixes this issue ?
> Thanks for the report.
