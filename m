Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD397082D
	for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 01:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758333485; cv=none; b=l5d/D+k8w1nGpfUihU3PSUFK0UqNx5os79mLP4iyfAXAYOBY1RO6Zkl9o/lwoFIstnV/Z3J1M0lPKgscV/zfGuYmgdaAuhlK8Bi8Er3adDGMVelhCKHUSalb8Foy0rVz6fvNnsqyUdS02v49/f1khnJlA7bRmAozbWW5ilJUS+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758333485; c=relaxed/simple;
	bh=WrSkMvVgkQNzMvCxVUTSK+7vdP4vvRibyvRZZt1fXbg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=rOzvB3GQxfmdwGkPeWgrs450S6IPY+peMSdJNmQG6zcX33+a8FVUChTSOnR5QIamXtYyZHXr0DUFp/tptCwQwVPgMaP91iyYMUz+R9KIv42eO7gzt4VXzYIEKxtekArOiSD0xYugtGhPQB7zB1Dl+7+MY1EUk9ouqv6AFFoXftw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cyfL/ovd; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cyfL/ovd"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-78f30dac856so31987136d6.2
        for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 18:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758333483; x=1758938283; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+IeYdDwGM3XWQ3ytBnc48jBI8s0G65WWqY2pGYrExtE=;
        b=cyfL/ovdZRQ5mD1Kx4/iz2ip2cH7riEThMjOola5MOrlKEKiWoOsVRWqMMJ10b+/pY
         aSJxd1XHtJlZmtuLoXoEuaTePZn+Zv5OFNs8DsZmFqmfvXvnJXaT/F7xJHGUAGOq0EpM
         1JoHl4hTcVwVBXVHSpyxQzhLMrAcA5oKp4oUx5SMsjIZBTxc08dkmNqdzTky2OHviqQh
         RniTYE8tJwBZBHA4tsc/aODOG6ikkhF0keFUUaBV3m3iiFCwVnSzbxdNQIBiYjF6091U
         Mj0lX0sAex4RTdKe0aXu2Dsa1N4oRuvf4ePiz1diIENfzH5zLeRAIYCpti8j1wKfaICh
         m6ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758333483; x=1758938283;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+IeYdDwGM3XWQ3ytBnc48jBI8s0G65WWqY2pGYrExtE=;
        b=X8an0HcflHLS1B5yiUHsP7YqSOlbC8zer45aJx3+biXC0xSIAnfnx6L5FoP4CPuYrw
         /j3vg3c7jXz+VEbbAJJVhk8uyQT/A5gbrbxCqV2QmERqoSjC0LTlebnSyEqR+6iPQ/Hd
         kVqdImajfUchG1ylETBiJ6fAQMJZOcQgmUsytlfx2/jtzi/0VROM0IIz61w5vXnXqFRw
         2nBOACvYpiEh8AXmJvX12ta7LrbtR8cES7hBDAt8iNVm8ISYbMCHQOoLjeomdEzC8y70
         MKG85feyOlKvzrbWGogu1o3K3TjOXtK2+XM3KdVhje3KCU29ttTfD6ZVy4HW9x74iMxE
         8Jnw==
X-Forwarded-Encrypted: i=1; AJvYcCXfIZWKSX2f72lvnjP4yK+AcGOwwM8OLtfbiNRmIxuvTRjd0phmYrHPzGg7rWzAObZ3+JPDSvgLZVXp@vger.kernel.org
X-Gm-Message-State: AOJu0YzGAwM8a/GDqJJenht4srCyv56x8xKziehyAoCg0rpK3olddYv4
	ZWiyuHs+kn8+9M7GntWGfJ4rskrUcs7biGidgOFX5fL05Mc/t/TS/cRtz/YSUeibXDyNuwmpvBp
	rEtDkYWfqAiRl13Fp4h4puga9txVcDQ4=
X-Gm-Gg: ASbGncsvhrZvrgZMaBVDD2VmP9vphwxV/+87TK8Da7e1rIAwsAjH7u44siu/dLlXoKK
	efCAN12Bs59xRDKnyyia6Sw/D1vxEzCs6VhB0o+Xte7HQrdDICpAvulcMXh3Wdhax3LfaPoH1mX
	eIVWS48I3y5LbMqdRl7qW8ezW2iGQCgtDnbSO9og6t314GIgHn/9fb0O/77WmjHnbokaq9Kd55Q
	kb6QJip09odfsDygKVdvdWJOAzn6fahi2yX7gRBN/rJyRvV4gxpvq3OCiwK19FJ4VlntccaIgIj
	Hx2Al2yuPqqeZYRSDcHko59fdMMLb0FdPL2oytO9SraV95xKOyC29owLbWOFRN21Y1AnQkHbwk+
	qYX0vemo07H4IC4enONFDCg==
X-Google-Smtp-Source: AGHT+IE5ZXnEkJZJ2o6wIvV1X6khaeULVfo9GNm67tS5a9PM/7HklawdEsggzdlDdW2B9ZR6odz39aZpsVAAwG/QFnU=
X-Received: by 2002:a05:6214:c2d:b0:793:9d56:3f8b with SMTP id
 6a1803df08f44-79912980f98mr58763566d6.17.1758333483062; Fri, 19 Sep 2025
 18:58:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 19 Sep 2025 20:57:49 -0500
X-Gm-Features: AS18NWB_aXPFSagMdzo-_5qY1311xAjemTBwOjJ-6PdPqVhA6yImxtDNUQ5y2jw
Message-ID: <CAH2r5mtPs4=gUB02r12MN29kwK57+qJ_ugAsN6=83_vhA5aDCA@mail.gmail.com>
Subject: smbdirect/RDMA patches for 6.18
To: "Stefan (metze) Metzmacher" <metze@samba.org>
Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

I have rebased the very large set of RDMA/smbdirect patches from Metze
on current mainline from today (and the patches in ksmbd-for-next and
for-next).

https://git.samba.org/?p=sfrench/cifs-2.6.git;a=shortlog;h=refs/heads/for-next-next;pg=1

Testing and review would be very welcome.   There was a lot of
discussion and testing of these at the SMB3 test event at the annual
Storage Developer Conference this week (and they look VERY promising),
but it is a very large set, so more reviews and testing will be
helpful.

-- 
Thanks,

Steve
