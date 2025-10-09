Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6914E220F5C
	for <linux-cifs@vger.kernel.org>; Thu,  9 Oct 2025 18:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760035943; cv=none; b=QbA33qYwVCzgna6+lwM/XLZIXwMzmtre5Pqtw108xrjX881QuoiOAqtJrW6haX0tU07TYL7oBuUgmED0O8treMp41/373xi0z2nXl43pQxulKkQfzYyHAxwznY4s/GXV3kfXB3Nf9yj6R/KfnIpXkjue5w7afQLB8T6ZfgRLSwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760035943; c=relaxed/simple;
	bh=y8MYh882MiItsdlyscn0kP+121LCNzbtSe5azW5cXu0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=t9BjrRrD2w1P1B1XJexGcj3tKyI/IGEpaj9IghQlMSYm/F70UcgAMA6VKTdwVc8HTXi4RZnGggfJhjJT8A1P6QDGA26TR0K+og32XvDD+36L47o9j00oVMs+WqHMiLn08JRZjCVZ3CetJK7FQ7e2Co2EpeZR8Wx6wr7YW39KEe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EFwNgOdK; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EFwNgOdK"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4da894db6e9so12449931cf.0
        for <linux-cifs@vger.kernel.org>; Thu, 09 Oct 2025 11:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760035941; x=1760640741; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7/P70kNAldz617OeosgymoW8lUA1yYQLGepZtuNRccQ=;
        b=EFwNgOdK8q+dRtOmjKkcQVO8JRaWeMMYItxrBP2b/k3bOIvGEnQRndFJM3q8HD0kiv
         G8FSCJjuMPY/YwMhXdTjNrAZoLBadUcH3EHorCjZlWRfmmDU71CCFdxPJo8cSQRq00NW
         xKM0SLHx6yLVraaX4YVPKaT4ZPWQ29AO9tWgos1td/2S31aFuVZFguFZWiLOrFZ4Oe4Q
         wFUOqeY5PT6EpLzyYc9R1k7hzEhUCqVQT4AtHmLUccXG44vBqlS1h39oJ6C+CnV/vGmS
         roX71SOojFZxqfBYfWwDRSZ53lNa9GZKh9OjQ54G/AdbjlO03QTIDItsPM1zlBKtZtvv
         QSww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760035941; x=1760640741;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7/P70kNAldz617OeosgymoW8lUA1yYQLGepZtuNRccQ=;
        b=mq18vNiJkAF2+SixnaIZqYe5HEVLpjTctwHvizi6YySfNqSozpXRjdNdE4f73pI8vG
         /F2GZaMVEZWxnHTXr/J7Y2Pim/AvSUrMD1lL2zqV1eIz5jBWUsaluDRazY4obzHUoEuz
         2ODrwyCXXk1pgB5c9ZkyW2I0TEoHhWP+WPmvRGVkBhdFBDjeqky004M/HgreeFMKMUyo
         yKYYz/8emv/ppQtAXd02Kk8MR81cBb5kf/OsYmiVmQS+i9seOmXTUI2UN3VNK1qlGmwt
         WUirYMhBBsOLJMG85pPCnKIRby139NRgzsb6BeoXxVIui+4+No0sv+39Ua1pjc0SuwID
         2Eiw==
X-Gm-Message-State: AOJu0YxCv+MYOks6BqYCX4YpmeZsaeEVkEdRpjhMO2S4WUaxRuqZtkep
	+auXN9QmwbKk+N2gOSznAcPqtOxOC06rY3huA1/V0KWiE3/QRhiNFh6MoJ3IW/gA8hPYTrxbUHX
	LGZpCWZ6fS8/3aJjYK2pUJ1u3hD5NWiI=
X-Gm-Gg: ASbGncthRbnVhiv/OBQAqeUWw+tuu5vL/vk7hN1XFIms34DYf/WQ2u3gjK1Nax84JBF
	zfj4Zilqyo3Tqz2OmfcCDXlqtQH/KnQZ1G+VipVxSOas0nQfBdUkvvbFea1e93kLJre/77auVOA
	Ao9NCsd7m/W5sgmm2nofQCY71mFtxB7X3bNCOxJ/XE0VkTIuEk6wPx1tVMofDo0HG3LVCqQN8jA
	OBErAFg0aVikS7BjdeLlf1cupMQr58BE2tR1vokbpMej14i5kdqGRbXld8/ZhDpF1XbpKxaVu9/
	HlBm9cJWF+m3e5sK1tXxCY0d4CmH0iVemwBzK+uKNPJchkDpSqPOgKsKhgkier92CpeBc/Zb8JI
	oL3h4RlNIWq8aV7Qj9KFRqkpHCxFqu+IhOQA/lBZOZjyLsA==
X-Google-Smtp-Source: AGHT+IFm09eTUy3FMJGiOihDK2GRYcL+2JI/igDQD8eKLhBnZYuxbppA4FAftnQ99fhvfX/ddeXEe51N98unR63pDdE=
X-Received: by 2002:ac8:678b:0:b0:4e0:a152:6feb with SMTP id
 d75a77b69052e-4e6eb041d80mr79665971cf.12.1760035941106; Thu, 09 Oct 2025
 11:52:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 9 Oct 2025 13:52:14 -0500
X-Gm-Features: AS18NWDhYJBVvw6jeH2Qc3-6v8z3iNIjQ5XiOjk1jGwkojcrp27kvWVlnYXDhyQ
Message-ID: <CAH2r5muZ8KPXD8-KN+PsAfrhJzJXtR7EdVhtSbS+M5TCvyPEfA@mail.gmail.com>
Subject: directory lease patch series
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: CIFS <linux-cifs@vger.kernel.org>, Bharath S M <bharathsm@microsoft.com>, 
	Henrique Carvalho <henrique.carvalho@suse.com>
Content-Type: text/plain; charset="UTF-8"

Enzo,
Was running tests with your 20 patch directory lease series (with
mainline from a few days ago) and noticed a HUGE slowdown in
generic/165 (run to Samba) it went from taking 41 seconds, to taking
over 31 minutes (and thus timing out).  I also noticed that more than
1/3 of the tests were also running much slower - e.g. test cifs/105
went from 4 seconds to 39 seconds (but only from Samba, didn't have
this problem to older Windows), generic/014 to Azure was about 50%
slower, generic/109 (to Windows) went from 15-->25 seconds,
generic/129 to Azure was about 40% slower, generic/138 and 139 and 140
(all three to Samba) slowed down as well going from 5 seconds to about
40 seconds when run with the patches, generic/142 (to Samba) went from
5 seconds to 4:46, generic/143 (to Samba) went from 26 seconds to
5:06, generic/144 (to Samba) went from 5 seconds to 41 seconds.
Similarly tests generic/145, 147, 148, 149, 150, 151, 153, 155 (to
Samba) were about 20x slower run with Enzo's patches

Do you notice this perf degradation?
-- 
Thanks,

Steve
