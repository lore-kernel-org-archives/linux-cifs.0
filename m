Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AA323B632
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 15:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776353880; cv=none; b=K0VyJIskqfd8tDTXuGJsja5EwNKUV4QzE9NmnugLR876qJBWZSRvizS2CmJFNjC1Z31uEx7Rwmnxs1YhUqZRL57xP2rpPfvCdxwVy62rlMaUFRlbEa5CmcMSJtu2easaWn15RuKY02y1J0R7l8Nd5xzLu7BHeuiIqhkYV0W826I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776353880; c=relaxed/simple;
	bh=AC0no222pyuJabhY/h0SqDNjDmabcz86F7hXkNC0Uc4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qQ9rSZxLi7ynZifjUH0HiuImlZCm/5GAnVzD6wHT6Hc++6vlx1v7gEfJqaHnzmnkBmdZ5vAeI8ggizc0UB8wr5W7YTS4h90dRk7Bbrlb3zmOiajQ87scl1d4gT8wfv9iv5WcT9XgmDUmptNub0viK0s/DQ7H9JQwIpM/fKS5pZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SF4yUZYG; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SF4yUZYG"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6729c6f0ca7so608771a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 08:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1776353877; x=1776958677; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=L9c3Exw/YRvoMVTnE3/VHAjwHw40F1AdnWP9lcAfExw=;
        b=SF4yUZYGf8+ztOLo/w7SESoqk6iWoh9JXzajew0HSDTK01FGdipQFvz1oBt1+keNKN
         4uJuOMlJZG+x4Gdl41ZrYMMymQni1kMFKuPFZs4Gg/FhoMnUCwvCNZJv5TPUEUkBYtWl
         DezoUnILA2Oz6DODH0Ke6q2XxO+9TG1ZaHu34=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776353877; x=1776958677;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L9c3Exw/YRvoMVTnE3/VHAjwHw40F1AdnWP9lcAfExw=;
        b=gnk2qSUpOQ/mc3vH6OkVYAJ+5tloKwB4Hokj+mO7TyrO5fwDluJnFjwXWHyndpA1br
         LTqUmAhRcCit9Km7Tzp1gwb9g60EMHjwzhS8xqLZjDQz3SbYsJxYucbnwR6o1/Oh4LyS
         wsyQImNHzo6SqcKOXpA/tCgfnSnbxDnU1WFoa+B5VTn21YUN224iE4chNibAcGdfNo7D
         d99bK7vg9IpFBoosKX20XD+cqziiUVk1w5spG7Rrn/Su57P3peaSTW9mdpoUb3fyeIjs
         /IKj2iVfYnpYyW01m/4F8vbdlgAY5L9RvMCJjXxzdSiSj4dy05QEsNNkrFOxEHqxvXMa
         +KCA==
X-Forwarded-Encrypted: i=1; AFNElJ92+4SP2hObb4kbBTpErkx6FBtNsw678+WrWEs4FBqL4Tr9VJxwxWeXGChrPhkPFhjfU/CXm8kFSvGz@vger.kernel.org
X-Gm-Message-State: AOJu0YxqDV6mvyp8FUhpEIYhEfMZZzR9mRXDOAb7OFaKxQ4Q+ce96/g1
	nAAe56gyHWzi11xGjRE5XHNU0lab8u3WmX7DjYgldtyd5/Ff6QEH0DOkYLn/NalQdgT87i2E7we
	hgnxhF2gX3g==
X-Gm-Gg: AeBDietGNr04BBue+TvEV4m+tUQ4zAE1gBavJ0EewAZSmik7izPcDto2OQo93kB69Pe
	aMQDZELoXTKN9520t1Iwl/YYHL+n7Muv0JBAedFqP2Z3kdZyYflCFTQHE/JA3jZIBkh2u+kFs2p
	LDAOFd4xi1bdIvLOjO/ihbwkwdp6x4Axbfpo7zhUQOAWEqUzkigBQVRwqgGNElE3oeIvQHuU0BS
	HITENwchOJwUUzXjOIbQ/aFQMPSovwHzZ6wzIRq7hNFeb2E9xvugVL+HW3FtQ4NJtLzISxYjQ33
	svNyQRuSx945OvvETQnfKLBi24rLSJ/ccsFZRLoheTUL/epmfFk2fiZcmsb0vTG6C3mJX7hi/Y1
	P/9hCy06gnh9gg2UEecGfgccZtFAasH8U43c7QE11f3YFayLoMn4mZG9nOXnqsn1+CoI5Jnq04c
	SofT+4qAfL6KMfwDSO/TKa510NvaVBT8IAbSkc2XAIrL4YbpMDahUxqyUpBTzW6HKcNNsFPHxS
X-Received: by 2002:a17:907:3c85:b0:b9c:fe2c:3a57 with SMTP id a640c23a62f3a-b9d7249608amr1496652966b.20.1776353877337;
        Thu, 16 Apr 2026 08:37:57 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba173b2383asm178892166b.21.2026.04.16.08.37.56
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 08:37:57 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b9c280322e0so1005877766b.0
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 08:37:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+c/ZpqcHg1JD5/USqDVyqc5e+3Q3PBb84N2JdSPlqRc5Y3LiIq/zfBkwhmylNblY8+1y+7MPDHoMSY@vger.kernel.org
X-Received: by 2002:a17:907:94d5:b0:b97:1d24:c004 with SMTP id
 a640c23a62f3a-b9d724960f5mr1682161066b.21.1776353876373; Thu, 16 Apr 2026
 08:37:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mu2+PGJER79PJpPVCysoEEgCsyuzuCKCD9LzZSHQnhOSQ@mail.gmail.com>
In-Reply-To: <CAH2r5mu2+PGJER79PJpPVCysoEEgCsyuzuCKCD9LzZSHQnhOSQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Apr 2026 08:37:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=whmue3PVi88K0UZLZO0at22QhQZ-yu+qO2TOKyZpGqecw@mail.gmail.com>
X-Gm-Features: AQROBzDZwpbP92e8M4X6-Wb_4mgUEYXroEGJpD6ABQEgGSBF7AgHjs7GIA3JYcA
Message-ID: <CAHk-=whmue3PVi88K0UZLZO0at22QhQZ-yu+qO2TOKyZpGqecw@mail.gmail.com>
Subject: Re: [GIT PULL] smbdirect ksmbd and cifs changes
To: Steve French <smfrench@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 16 Apr 2026 at 08:04, Steve French <smfrench@gmail.com> wrote:
>
> Move smbdirect server and client code to common

Pulled.

I did want to ask why you ended up with that very odd directory
structure? Not that it's a problem - I don't expect that I'll ever end
up doing a lot of pathname autocompletion in this all - but it just
looks so strangely convoluted...

Just to pick on the biggest file in there ("it's not fat, it just has
thicc code") that also has the longest name:

   fs/smb/common/smbdirect/smbdirect_connection.c

why the redundant and complicated naming? The *point* of a directory
structure is to structure your directory contents so that you don't
need to name your files odd ways..

And yes, it's "common" code, but it's a big subsystem of its own, and
got its own subdirectory anyway and it all could just have been

   fs/smb/smbdirect/connection.c

which would seem to be the much more straightforward and obvious pathname...

Again - it's not like I'll ever really care, but it just looked so
_odd_ to me in the diffstat with all the redundant pathnames...

               Linus
