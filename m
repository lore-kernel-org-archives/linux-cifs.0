Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9887323BE
	for <linux-cifs@vger.kernel.org>; Mon,  4 Mar 2024 00:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709510682; cv=none; b=Cxy8a6Oqrx23RZ2ol0j79OQtwiW4OcTPRog+f17ggZcmIcbm2znhEvfNmrTcDLxVbujgeOe9I0I2tJZUth1jS5vsCYfuIwKKFb5Hv/sOuY0ivDcQD8ZIlnN//RRomDeFLuTG293nPzI4NJDZtERXAZR2TIpZh4IW8TcJz4E02wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709510682; c=relaxed/simple;
	bh=17CGikz0VR6A5EZQTJTdtltrHDfsN5kE8KuTuZl8cdg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=iDjfq2Tr5O6aY4+OmLblC8CzCsCl/DW2VLvzmjcq4okQk8M8Wyz4GfbQt+ATn2+u5QLl25CY2xbAFS737UgVMhH6lWILC6XpIBDNE+GewGptvsivcynmtAa664w1tGpT2s6YvqyAPvlxbrOaDGrOITONyc6VNSBPS6ZG/n8eAco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DPaic30G; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DPaic30G"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2d204e102a9so39303361fa.0
        for <linux-cifs@vger.kernel.org>; Sun, 03 Mar 2024 16:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709510679; x=1710115479; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uEFM3tIddoI4VsuZDzMXEw7q6ghGDqLz2kopdTACJro=;
        b=DPaic30GiLjUeJ1zjK6rfH/7yefFgw2KTFyizQsTa7lY2ASfAeVPD8KBJ7T0HEHpxd
         pOwona8v315B9W+6vh7Zh43RzmB8RTRgS/lZcucg+s5DTr2F9HlIyPbYfAtkPTCND3Lq
         RszHNzDqAbTIPDzNonvwKIZBXlvMHkE0tQ7uSAt8w0mLwr4NhHhULpuwnYUus7L316Dw
         t1hbJ95+eC0rf3h7YT91vGIHvnKoewA84xWWE9JPrhCosU+74RfhFdFLmXASo18RJI8K
         2AadFcvwtE23Kd8qA2sImJCOtxHvtjtvEdbJ4GSAaoZwp6AB6FlflMqWtoSS1SQgtPeZ
         wzeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709510679; x=1710115479;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uEFM3tIddoI4VsuZDzMXEw7q6ghGDqLz2kopdTACJro=;
        b=LLkaG41R4IWSLc6jL9ohDNITvPrh7uZD0ry6RmcaMI/aIciV7aSsQP7d0rQAsOUmq+
         BJFE3T1h3aN9/9QruQDDNue0wbctuHhVH6XCl+EIivbJWI/88q49CrAx/+/d+WoaephX
         Q1nlXMR7wDOS/xPU8CB+fRsJCq3jPGsmx6r6DvKoM654dlkXuYUDjw4HgbCn6OIJso3N
         abKsJkz9Ea1Ttprnbw45P/jmoZoBiHgkjJnOu7QWWyA0Sv6sipALZ/KXoho49/C5aTIJ
         sklj0GrWYYOf3QQ93tWERT+gchuWwI33W5KPFgrJM4Jdz/eDdJsLvzOCaCi9DTcowl+k
         /zKQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3f6Oh8y5ng5ihMqjglWsBF1DbC5DnrMdRlKWWTkP9c5GZhbj5mELQrCS/2vjr3zJAg1TswSsjlnixAvsgdw1KfRE32zFFLL2Yiw==
X-Gm-Message-State: AOJu0YyoRrIYLFv4mVzprxepjq4cUoYISNfE5wcOGbo3xe8k6xAV3CUb
	E/2oV/uQyJmll67PEwB/HJ7WL7vzRh4MM8W5sJY3U9Ip3cr9FtbTLTT8Ebj1KO3std8+WEz4R0t
	BWcdnUYzsH9x63ZBJpID3UPPk3no=
X-Google-Smtp-Source: AGHT+IG47zBRlwY6Dw7jPfx9phyhXKcCEsFYDNmEH1gBpKHleOvr6iVV8xZnNTE5DpcKAkw0fWkAnu4PQuuQw+02FgA=
X-Received: by 2002:a2e:9254:0:b0:2d2:4637:63f with SMTP id
 v20-20020a2e9254000000b002d24637063fmr4912340ljg.45.1709510678398; Sun, 03
 Mar 2024 16:04:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 3 Mar 2024 18:04:24 -0600
Message-ID: <CAH2r5ms4UVc2Lzp+171j_d_ZDXrXNhu4=EFyyiub2+gVmyHQPQ@mail.gmail.com>
Subject: file size bug with some configurations for test generic/586
To: Paulo Alcantara <pc@manguebit.com>, David Howells <dhowells@redhat.com>, 
	Shyam Prasad N <nspmangalore@gmail.com>, Bharath S M <bharathsm@microsoft.com>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Noticed an interesting bug with test generic/586 where the file size
can be reset smaller (shrinking the file) due to being sent too late
(after the last write, instead of before it).

Trying it to Samba e.g. if I use default mount parms it works, I see
write of 1MB at 1MB, then filesize shrinks to 1MB, then write of 1MB
against at 1MB so file size up at its expected value (2MB) at end of
test, but when mounting with cifsacl (perhaps due to lease breaks) I
see different ordering of the final write and  set file size so the
final set file size shrinks it to 1MB.

The test is intended to test:
"Race an appending aio dio write to the second block of a file while
simultaneously fallocating to the first block."
so it is plausible that we are missing a lock somewhere.

Any ideas?

-- 
Thanks,

Steve
