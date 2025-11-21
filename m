Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDD32F7AC5
	for <linux-cifs@vger.kernel.org>; Fri, 21 Nov 2025 23:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763768298; cv=none; b=kyEFNW9xM8pS6KNlegMK0/NuZ8KHZ+ZkBanyzT73j//BbAcBmgRf7YzkJqDhX6l8F3BKD7/IwbGT8HvVumW/cn9dpBCDgN9sWwzZw3vbdDK/rQQS5yny4DYZmL6T2F40Zkvj/sOmIgPa+dwq4VDWeX05a3tf6cLsIttsFc5rAgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763768298; c=relaxed/simple;
	bh=858uwxvz3bY2eV1nRnV8NV5lXePfeFw+kvJgLpfRYH4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=RgCEZvSPQuG5VT9zczZNyYlyXzFSrFztLdD3wJdOzV9v1aKB/BFmCQCbDuugHKH8fNregTUpXe9PskIhNnVL0eBjt5SZNi3ZQvrFb3CA4Lv3p6gktPXmT75Ozmu7FXe5H40iAV6j5WK/Fc45tm2o9da20qH7meTGgNVSGc9XKso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mu2tZ2YG; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mu2tZ2YG"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4eda6a8cc12so26120321cf.0
        for <linux-cifs@vger.kernel.org>; Fri, 21 Nov 2025 15:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763768295; x=1764373095; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5yZR9PZ4cQwCsgTuoYLVZkrtiQUKvHtt143Dw7SbRzw=;
        b=Mu2tZ2YG0TcYWBrGBz0hMPblGq/1wANAMawQRvktTbjF4mYQ9kuFLefFmkQgPAtmvE
         pJgMoEk6he0BZMWcghHmK/nX7mx2redA5JciRSxbqEingtM7L+EW2TgkeKFEOWOMQX5i
         G8ZxnT4vMh2fIQ/39arzRZhy1dSxFivsLGI+pynEp6uHBOOYhfZmysL8jQYfm9bXV1nC
         M4figsti4EYwx+nC5+GPC13Mk1R7JcD9tsWyaP6GZfTT97Q9btA3Cua9rohNGm+xjF+/
         1B1ZBbAqV3p92QuxPM4vso81BmNiyQivwl/QIke7umbnza5lazCtWz+34C88hTFABic3
         UHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763768295; x=1764373095;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5yZR9PZ4cQwCsgTuoYLVZkrtiQUKvHtt143Dw7SbRzw=;
        b=t+gClbqnN9wb7ugVC4wCokHV76VEt6BfPrS85NTAGZzVeTzmo2VJOblid7HIiMlQ9W
         7o1eF44VJ3+jv48PtGcgQUENTnSyA+k9BGW4R+85YcTIIj1AkjjaZepKY1ksBJxENODG
         x0P0hnc6lm0Pp4Ccpp2UjrUVUSVpOp75Tx7OYSyVw8nMERk+F2WOpkOqhZGU83uAmt2p
         pXPrk9VOV4LhBRi/8WWEdLrmGFKHBhN1S0cozayJjmL4G5CNLPavmolleYOkE4A+rJ2n
         h32Dv+sLXiOUqThMCP4zzaR/Im27aWIE9aAe7g89faEis4dP02dInd6VYI5HGiWVvJyY
         0raA==
X-Gm-Message-State: AOJu0YwPSGC2/2kH1mCiclOyQAvdIieGEGkJbbr4DqdpKOVjTI9YeuLz
	QcmQAd73LSmj0qg9nUeAQ14pctzyNDipaFAhC/Du/dhvThftW4vte+ygpOQFFDe9UkKZatMNBSN
	PoXXjWrsM83zWMS59ieLoPyXU79svus36x/Tm
X-Gm-Gg: ASbGnct62djFiws3pPCaugTMn52cj/n0amatVVY0vy+W0E6t71HyUdDrcZpLcK9xAgI
	beEuHTbK0n82dNTnkEJlAm7zAF9KiQd6xygH0zH8yrWGGxzNCLJq3HJRZsbbqAAo7bqvc5FKnRJ
	MhZMhG9uQ1SUfhzpZsIREuJhD2sU9e6CFcOwU6T/X3zJjchMxCMP8kkn/W6Pfl/EjQrWovng2e5
	SNEBieyKY3k3yzL9qf3YS8BMVtwGZhOZ7m0V0K6UEF7gGqBTgyp1AmLmPtP9OW79GthlU1rUH2w
	+0UTFjuLcHnFpN9YT4D8aa62VHValdNZPe2ohE4+gfm/lHF8bxAyRGSfMPu+CR4QVyWTQjkEYoP
	bnRy0Buqp4AkzJ9HkDk7Qre8e73Tc11MS7RbTf1VsXNRRKjDpIk67VuKFHIY+sAFnkgDaNrTKyh
	qG++vdb7Etqw==
X-Google-Smtp-Source: AGHT+IFDIsAYDbXY79i2HogGFE9nTO2FQ0+ZSZhlk5OgkecwtjW9FIDF3of/VCsb4AGwZNmsssiyAKzSd4TmfuTL7o4=
X-Received: by 2002:ac8:7d86:0:b0:4ee:1d76:7341 with SMTP id
 d75a77b69052e-4ee5877ff3dmr60140011cf.0.1763768294770; Fri, 21 Nov 2025
 15:38:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 21 Nov 2025 17:38:03 -0600
X-Gm-Features: AWmQ_bk87nWr6fyL0sErZgefWPCikaLVzZJoSWyRpBO5CaoSgrh8BruwUS_PjE8
Message-ID: <CAH2r5mstHjwg3=Vz_3cPXKGJphGhZ7G0hep=-sSfP_hE_3fd3Q@mail.gmail.com>
Subject: Client and Server patches for upcoming Linux kernel (6.19-rc) merge window
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"

With the merge window for 6.19 Linux kernel likely approaching in ten
days, now would be a good time to collect all of the pending patches
and apply to for-next branch (for the client) or ksmbd-for-next (for
the kernel server).

There are likely many patches that I missed either due to getting
routed to spam or postponed ones.  If you have patches you want us to
consider for upcoming merge window that are not already in for-next
e.g. please email e.g. git link to current version or attachments with
the patches (some e.g. will need to be rebased given the huge amount
of change to fs/smb  in 6.18 so far).

I don't want to accidentally miss good patches due to some patches
getting ignored due to the very busy 6.18 release

-- 
Thanks,

Steve
