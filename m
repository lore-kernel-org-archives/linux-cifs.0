Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D3C181B94
	for <linux-cifs@vger.kernel.org>; Sun, 23 Jun 2024 15:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719155168; cv=none; b=jGYXc4aOdaDd4JDho5c3hjnBRIV+7q6qedDGGzl/TkA+zL0pZHR70lkqCdSkSwsTFx8wH5Tnlle8+zCyf/2ZU8ECou7h/wql7OzUn+y0pxqjRiPTPyWXy4MAdgmxigcz2Wd161rxj7pvkZ8knc3NNyiPCKLaSF2bKu5QMT1F+10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719155168; c=relaxed/simple;
	bh=AcukNjBMQ8sYI0piHVK0jaJow1Tro2bkO7uODOypLOg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XDtRMs26FBAPuYEczekJa9x8eBD3RFsdB+MvearJnCTiFTVfkb8RhLiR9tVCMVnRrkUCagfUSncMA5dSp5wpnMT+ypvz4PgJ/033mmz7jILtxzkx0ZT/brb0MBbQ3mgeYfzt9WczNd7lT0nz39zf3MIgU2sbHdUI1ueUI4+Ik9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jb8cFQcK; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jb8cFQcK"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a724e067017so35781766b.0
        for <linux-cifs@vger.kernel.org>; Sun, 23 Jun 2024 08:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1719155163; x=1719759963; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NFE0BNL2HJ1hECpEi2pNqya/PSGrZUX20RQ/1dd8MiY=;
        b=Jb8cFQcK/Sm6J51O5hDIloo1F04orYwZnPIlcGcJvqx2QQ3kITwHvyMt04D5l1Wttq
         tE2A6STiNN3OnGexj2jT6ONOa3iqi4iLBSqtNeV57YsGT620t7auFgfSsph8o6XR6I2l
         iOdTz3CsrLb0q0IHEKRChEElkWbTEd6E1cOJY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719155163; x=1719759963;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NFE0BNL2HJ1hECpEi2pNqya/PSGrZUX20RQ/1dd8MiY=;
        b=CmdzaglrbunAu7qjVtYlMEwGWGQMnkB5+Z3FBx0CwEG/ea7qgXozVuvd87cGrAQ13P
         g1Am2xWuD8hodFzv4eYkJDVmhnxRuX0iAsj9LRQoF5okTDouGaoQ+A6DYKcZnftlbf+s
         lU1OT+ddTO9zvWuugG7Mcx+KMcC965NW8+BWId3vHHGi2q7Gdq5dxEoEUqxSAIC31v4O
         bSRM2AloCT3MDJLYyYH8vdr5QPbwGFugPDbxYJJmSzhkhflcBHgrWOGOKMzDImDGEHNC
         PEqogSUKeXreKZWEABK/46ppkZHAld3If49zKytyY2zzYkZ9+am2Y90QESvBq5p4zNh+
         CCdw==
X-Forwarded-Encrypted: i=1; AJvYcCU+eBt4MfjjJTGskkGkYmMabP+zUeePag+A1YJ//yvALRkI3GbvX4nwIsKDHEjg/Yf7T9UFDmbtEQeXqc/Gazxwm0qZqS6/sDV/9g==
X-Gm-Message-State: AOJu0YzzTeuO4EdJ42zbhWqkHa2sT1zhAfLI5H9opVGRY7h3e1g/mN8t
	gSqCyzvw7ZHXtyfFDTbkOgIqgMddNaj052k8S7sQYMtguhqgbRuVlNEKsE4SHFjvbuQ2i7ZhTtE
	2pZue+Q==
X-Google-Smtp-Source: AGHT+IH0ZpUyzY0Af1N2x+e8dbp4ccV7391VjoUzmgX89/OGPcbtqu1ov5vIZieEmiZ9s49pJMIinw==
X-Received: by 2002:a17:907:a707:b0:a72:4f3a:b58c with SMTP id a640c23a62f3a-a724f3abcf5mr57457666b.5.1719155162830;
        Sun, 23 Jun 2024 08:06:02 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7251ace5besm37587366b.179.2024.06.23.08.06.01
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Jun 2024 08:06:01 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-57d1782679fso4025798a12.0
        for <linux-cifs@vger.kernel.org>; Sun, 23 Jun 2024 08:06:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXyUJg7gU5OoYT1Ty8Ppe+7UnUYOMSsNZLD3FB+F6g41vR3SPx39TeG46YV9yN0a6In/bHDB6OOh6uBqbAGtzLsFRSKgEXd4I27Kw==
X-Received: by 2002:a50:bac8:0:b0:57a:2a46:701 with SMTP id
 4fb4d7f45d1cf-57d4bd80e1dmr1524437a12.19.1719155161338; Sun, 23 Jun 2024
 08:06:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muEks4khtNFc_rE=ywU15-6FfACkohXfxNGNvkdZ=0ovQ@mail.gmail.com>
In-Reply-To: <CAH2r5muEks4khtNFc_rE=ywU15-6FfACkohXfxNGNvkdZ=0ovQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 23 Jun 2024 11:05:44 -0400
X-Gmail-Original-Message-ID: <CAHk-=wjdSe1GkAA2tKEXyjtTZkXALjHjiJ=AptLf1Qmu17OktA@mail.gmail.com>
Message-ID: <CAHk-=wjdSe1GkAA2tKEXyjtTZkXALjHjiJ=AptLf1Qmu17OktA@mail.gmail.com>
Subject: Re: [GIT PULL] smb3 client fixes
To: Steve French <smfrench@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 23 Jun 2024 at 02:45, Steve French <smfrench@gmail.com> wrote:
>
>   git://git.samba.org/smfrench/cifs-2.6.git 6.10-rc4-smb3-client-fixes

No such thing.

Your gmail may be "smfrench", but on samba.org you go by "sfrench".

Git request-pull _should_ have warned you about how you pointed to
something that didn't exist..

I fixed it up and made it work.

                 Linus
