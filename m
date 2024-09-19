Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B4C182AE
	for <linux-cifs@vger.kernel.org>; Thu, 19 Sep 2024 01:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726710675; cv=none; b=R05cL4Y1BL1WFjtukoSxL7+ZRP99JzvqPxHq6afKBYh6iewMLFKpW405LNEG4jeJc3nTmPqt4z5ZE/2W/EGx+lAmXIfJcU2Tf72o/m3Qv7dvfBBc4f7vr7BGQutHyqgJkaHZ+3oKfFKfdvYPNHjR5kTJDxWLaINcfqaJ3ijiE5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726710675; c=relaxed/simple;
	bh=Uqbxt8qrO9T3eyGrXtUfywzhTS7ACanenpyAV9NLsy0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=eVXvQ/kQTR1SbY35Dh9yzvIvCxMQiVFwocK/5oOS7kNSORxaouQEtq3hCxcqTWEcrThvivno+IQV7/FWnLzLF5wL6tky07AhlwTSWVtab/RUhTM/Pa2Vhp4kNcPi42RkXlNyxPAkuYRfCkXgCShoU5HgJ/yrsVYZrqJfcddyyR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OYU9xDjs; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OYU9xDjs"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-53659867cbdso432061e87.3
        for <linux-cifs@vger.kernel.org>; Wed, 18 Sep 2024 18:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726710672; x=1727315472; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nrkkztT7w1cV9Fu7bDVSJQ/4r3mWFA0eqS0w90TAvVA=;
        b=OYU9xDjsS70QUv71UZDKlX0x/viVMy7w0REz4fUHigWBAbS8r6Y79kRuORwkweiMNK
         cGBX5YgvK6y4OxMR2HQkUdaYOaUHZ41A5S9LnDee9amoe1NtfmjQ3MdaQ3SxTJlja+BX
         j54Af3rbOKspHfHzDx8rM42QmfVeOAMB97C7qVQHwycG84UZRh6V6DB8jYDFk/xu0xVB
         mJ8Mnjk1Wdav0DRnBi249DQEKHIGmvIV88aJeN5Fss9BQhupj+E5mQcGH82LQCo0z0QH
         hF3XLuubBKCmQHaNtWg8dim4y1GSK9AIpsmeBuWCNmUyRgOjRaJ6xrSnf5IkTPo5IKNs
         MKTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726710672; x=1727315472;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nrkkztT7w1cV9Fu7bDVSJQ/4r3mWFA0eqS0w90TAvVA=;
        b=r1n0D/aoCXcQUps8HqIeGyhI6ul2VoAze9YDHnVo3+3+iPhElyZHcCSdhZCUQgji5T
         Muv+8T9VFMoDom90OslXGm1hP2nRUS+ICj78KpHzHnJt5YudWt4nf1NwIVXs5Wtmx0Vt
         M2pC4taQ5hJZozNXl9WVR84AYtNxGPEwkKPbPgL0C5srjYxBtw/pwcecASh1VcK6448/
         miz7VpPe8jkjV4TgZF6JEngKcE7SCQhjXm+5LXVX351HGLCjT1f5w/V3O5PXYTSnzPZM
         Kv2Z1ZwIuair3zIK6bDof8L3CAMWE8PcD5HzO8wO/g8lda1D0/iRjNvEUfXO/KJ1VOIj
         YD9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVTW1FvGj1xPz6dAgvJbFB7TKWQa0zr4yUFq9dEcAzd41tTXgd3vRIzNzUf7go/l2e30LVbcDkQ22xi@vger.kernel.org
X-Gm-Message-State: AOJu0YxaeXUXgFSiOL7p0ogIfeP2AfVXQTSqPkQUPNNmoBwQkJ6r1bHq
	4yXAhkDPVmHscJ+E9hrT9gXl6GSJ9KCefI17T0l2GrsrYOLEobPRRyuti+hSlJV5G3iegyFCoAg
	7cLIFQkm0KkcuGN5hcY3wyZnGYVUs+Ptu
X-Google-Smtp-Source: AGHT+IFpGEeFclUOdQxNulFGUzQUBciA+e7DYlBYWLs133x9rnnGvxqzaMgrhSaCsFmoZ165O5PpACDMDzil8JZIgWI=
X-Received: by 2002:a05:6512:3a8c:b0:52c:deb9:904b with SMTP id
 2adb3069b0e04-5367ff24cb6mr13029182e87.38.1726710671851; Wed, 18 Sep 2024
 18:51:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 18 Sep 2024 20:50:58 -0500
Message-ID: <CAH2r5muLs97YW12d1C4TWS4wHF-mbphVJCqzVe9LBNE6iYLPKQ@mail.gmail.com>
Subject: Network discovery of nearby Samba servers
To: samba-technical <samba-technical@lists.samba.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Today during one of the presentations at SDC, the Apple developers
mentioned a tool called "Bonjour" ("Avahi" in Linux) that is used to
find nearby file servers to mount to.   Is this (Avahi) possible for
us to use from Linux to find nearby Samba servers to mount to?  I
couldn't find instructions on how to setup Samba for this.

Ideas?

-- 
Thanks,

Steve
