Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACD67FBD4
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jan 2024 17:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706116642; cv=none; b=VEnsuV3M23JZj4F78uTJV1QWL9ZRdd8EXGWjSaTPwzZmwZEXJr8QxPW7hE/QXX8ZwRRNW4lmocyTaX7TAM+vVLqHHXjbAXxnnU66ZM1p5O5HDC/EYMJJ7Dc8+hSVWVHKb6Sndlb6QAr5+sSOIznfaTbO/BoUSss+cxQt0XJJaAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706116642; c=relaxed/simple;
	bh=Jw1jhDOOlVKCSjYzHGSFidKxJuavLJcIMtw7yHZ71tk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=gLEp6aasVtGaF3sLZerKKwgJptWhRD/cDxAimarC+DU7v/GAwjC7rff9w7vMlLx8x3U2i6Q4tvqCR0Rp3yDJXtzlT86Actz8Zx35qiZCFyooO/4yqzOu0/AKf5g5eiuteU1IUCBsZk9H0/3WM0oS47+lzb9CZ1btx0AilDle9pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BggRYlj0; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BggRYlj0"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2cddb0ee311so62643581fa.0
        for <linux-cifs@vger.kernel.org>; Wed, 24 Jan 2024 09:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706116638; x=1706721438; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Jw1jhDOOlVKCSjYzHGSFidKxJuavLJcIMtw7yHZ71tk=;
        b=BggRYlj0duOD/MxG7wjPc7ntK19KbZqlzSW5hRluYnU6hIgs0MGRJpJvDYrSioQbhp
         F+RVbnr3WBpALX+7GHaA3FPDCYlKiGIYK2Ek8yHmDfEyauGuwmA9mlBE6vSfv+LuRtLL
         IGnjlLy9nNw/mzd/nL+bmfSdkDDnpy8Nq3OMMwJtyGxNhs7a/pseuyR73ddJkcqXIGxu
         TflW4ZzeodmidTKakK+nDy/JWIHdWFuJvEG9SB8wLGqx/HN8IChJULgt45ToCin4Iun2
         vNwPqA4D/fsJCBFWNYxr/rIkylFYctUZMNP9ROXgFd9Lyzr3Pe53dGa+WFaroZb0xBps
         KoXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706116638; x=1706721438;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jw1jhDOOlVKCSjYzHGSFidKxJuavLJcIMtw7yHZ71tk=;
        b=GZUSi5oevgPe7NnsakiD1l/Oie2AHJ/rShEfynuqo8Su+FlV4GnAkXAz9KBW6pOqQ9
         S5DWA+pqy/9Nmyaa3F+rxk3dGTnG9zLb57Qv90yckYTFz4mg4IE0G2z5BFEg8142dj5f
         V4TEJ5GF5g0jVy2JsbUh6ou2GKxLb4rMR6+ZYej96I+WDhKATNyQNMLhgBQe61XKt0eZ
         Q1S22bM5wcul4v3twsPCTiIa/Mj9hHQSmMld8CJ46jFOwE0nh/oKrLYQ/d35gywDcxeK
         pWSoLvUuRVqe4FcFkgtMYa7M/QvhjItwLyo8IfnCXIdjVwvlHgv2/PtBsNfJIT9Uwl1K
         c3nw==
X-Gm-Message-State: AOJu0YxHM9ma7N04/TZG8uCHoQe7hkPtG7ce+R1CxiUSSh17e3ItGSaS
	nSZ0GsBXHVocls2ccBR95izbIJVVqtizqmOWgryhSlOTbP4MJ5+bMS29coy9j3CctlXZYIhNIsv
	t2snRUEnojx8hy3NEAzjHdJT17HbppsFrlY8=
X-Google-Smtp-Source: AGHT+IFHMowi1aba2T0JoTHGSvgiSVnInSX31zVQCXNTrklMgogajDZP5Nhojc8k0vTSaRGcrJVbPWe2y0JN3Cq30H8=
X-Received: by 2002:a05:651c:2224:b0:2cf:1033:c74b with SMTP id
 y36-20020a05651c222400b002cf1033c74bmr590001ljq.94.1706116638138; Wed, 24 Jan
 2024 09:17:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Tashrif <tashrifbillah@gmail.com>
Date: Wed, 24 Jan 2024 12:17:07 -0500
Message-ID: <CAHgtwXSTxL=bj7u2rSvOgoEuWtq0eMtSUacy88GV3N8+LT7dJA@mail.gmail.com>
Subject: multiuser mount not working in CentOS 9
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

As root, this works fine:

$ mount -t cifs -o
credentials=/etc/creds,vers=1.0,multiuser,sec=ntlmss
//example.host.org/pnl /data/pnl/
$ ls /data/pnl/
(all files are listed)

But as unprivileged user abc, this does not work:

$ cifscreds add -u abc example.host.org
$ ls /data/pnl/
ls: cannot access '/data/pnl/': Permission denied

===

In /var/log/messages, I get the unhelpful error log:

CIFS: Status code returned 0xc000006d NT_STATUS_LOGON_FAILURE
CIFS: VFS: \\erisonefs.partners.org Send error in SessSetup = -13

===

Observations contradictory to the above:

(1) The above multiuser mount worked fine in CentOS 7. The problem is
happening after upgrade to CentOS 9 Stream.

(2) Direct mount as abc works fine:

mount -t cifs -o user=abc,vers=1.0 //example.host.org/pnl /data/pnl/
ls /data/pnl/
(all files are listed)

===

Can I get some help?
Thanks,
Tashrif
