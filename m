Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793823142;
	b=uJvhoIjSYt7aN6u8veK+1PMy3sfb/NmkXu76mGOXtAt790y+6Asu7rba8YPant7T+ygG
	 VsEynrED/vdJic2mtBHgBmmoMvQ3KAb9oCw9tWBwUgN13d6x9vD3X3DM9Zu0hYN29fF0j
	 3S44JtZOwBsgWywhtA52tKUMGGv7LMqBG0IvERpEkgHO41/R9Ml8TBQ0eAUfHfxOQ9NA3
	 XE/NTzlbAyFEeY3zYb7k5Y4KGfZFiw+sq/xr7HdefGM+xkTuMhn3SYgvheUs0ouc+ME5o
	 g+xWXiGN/o+vm1ycQb1DTY3fIs25oHejhmmdnudMYt7H8wVlmKz2E32aWQ0USeHv4ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793823142;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
	b=pU4monaSdc93MxabLzzi85gciMadXJrchXuJGpxWfSLKIgdydW3+vUom4KB4vIgPegYR
	 FM8wCqO5ZkZJnkUUBQoz/fnOT3hbk4T7UWRbQXd6qns5CpqtrfTvDqsgo1JG2hwSjY7Q5
	 IFqoncEl8WCcS/rftb1GVNQojlPLupFS/DXrBBul9isjRY8kQdzOJ9uS0GNdPksBq1Sex
	 WGL2uwRREydog6IBAxdk4JsH88XlqsFgawa+9WJ1PY9qvU/RNNwFTo2J+cbHmL/F4v5ei
	 E9pl8NiC/20fsSpO75ivrMRzgCNDb5zbzTVTFp9z+8yQns7Tv2BO1emUX6enhd3+0kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=EGAC4wnj;
	arc=none smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C086A607F296
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 20:12:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C086A607F296
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=EGAC4wnj
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6ae14eecc64so1562831a12.1
        for <linux-cifs@vger.kernel.org>; Wed, 04 Nov 2026 12:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793823140; x=1794427940; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
        b=EGAC4wnj3bpvOzk7TYB6pWoP+dOEhqfiyfBYYus2+YnSuBukbtyp439+Rf9tWph1aw
         OI3fN1R/BJ36z/O26/cr6HjVWRQ8RyFXBysewCK/udaj+i29f5jF8i9/UBXu+7UhaT1I
         Hj8lXZwamduVkyoC1Q6XEncUwPa/qNprCuuUo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793823140; x=1794427940;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
        b=J0HDSUrFpxVThLbMlSa/2wEvtgP7jlaEmyVmazy/OHW0V+HBY1Y1ahx5PXTtuRcHM3
         cEFIDyKVuTa2Gaz/KdxnZgtQJIqn6ONVbosFPcBJGJ6wT0U4zMANKwQHgWLU87gFM6V3
         7j8+Pki7nRYH0QiUeCa6DKkaKC6wuUjCTyu8fheUhWN2L+TrmavGcgMcvlJtxS6k8TxO
         u0LLk0kSQZPJXPd2HTHnrIkbL0fURhhmERhpc/lIlixPgoE0NXVIZe/eGpQzdnjlsryX
         xnWuB+daTdof0ml3F0n1wJny0kTaN/yM2AvMKBtj2f2qgMbbXaREj6bfsm6TiCRTH3Io
         3Tuw==
X-Forwarded-Encrypted: i=1; AKwUvBxYSOHHEZ1u2qDtJdwGTvxU7USNPpKPFYMFNuytHOe+sI3agHc75ZLVxfCpb95RP3pgfAOyLMJnVKY4@vger.kernel.org
X-Gm-Message-State: APuU4Z8RVXehFq24nHpdy1s0K0aoWj+DRHeXeSznQNSztvoac6L1yyhm
	I/amhaGJWnhclCXb8vj/EuceydljLO/AQZLgO7qa8t4foDVL0AS0L3VvPQr3u9h/z3rKjNVUO/d
	3lDCMj2F0Fw==
X-Gm-Gg: AYBFou2c6Pbwld5xh0tCMm84ZGeaRjoV8u/0lefsdsEAF4/EmnZIwJAs0jGCc8Vc5th
	I29u3XLdXJObc7/Lk5r3sjURW7arWj8pAF36FxjPfSPMo/bSCzPmHU4pnbZGLhBK8KZ29IOngGn
	PwgUGv8vrWd78PMfSM4svJvhWbjjQfxrqdS5eYwtgMiQ2NUJy3jzH5leekyY1s2IG/Cz9rl1IV9
	Dn6TmDBquwDMH6urgn0L0tR75beQIf4t1hCBKmwBPdneKQt9kDBns2djh2J4ydiAysSDYeuiU2g
	T3srLhQ5IH13ARmkoAnOAsyRf2+yee1Ny5ldXa4Cj+x2rj8MBiCwOJzDVx78wrQDCgIHzFST3Pc
	EfoHMTH722oU9v0YRFIc7YTp35Z+60+DRM+CQLpnaRGNh0m1k3hMODzjyr5qV73/jGMV2Lr0Y6m
	ebFCvZlcQghfPPWcsVJLu2+G/tDOP7g0i0bgIHF8LaQpNqedlR3s+NDaoFQlO79dQCrVqoi5JTJ
	Rfh3K7XZCAeqA4UFb3blNkJZaqIBRyjC4UJCH1AyolY6hsPDuOPU9XDPOBo5Qkdaqb1DibDtica
	Pe01Ynn6Kuh5mLEYGG6dYnQ4ulrRD74x0xqkBCg3oYdBsCm4hszbMOc5b4OhPDfQWURNfo/Sbsc
	ijQ==
X-Received: by 2002:a05:6402:2809:b0:6b5:63b7:5738 with SMTP id 4fb4d7f45d1cf-6b563b759aemr2416836a12.10.1793823140153;
        Wed, 04 Nov 2026 12:12:20 -0800 (PST)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b55ac5aec7sm1123448a12.20.2026.11.04.12.12.19
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 12:12:20 -0800 (PST)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c418e215671so167692166b.0
        for <linux-cifs@vger.kernel.org>; Wed, 04 Nov 2026 12:12:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxPa65B/vmRgyJExvBrlKBhvyTununz0YzlgvMdVn3hdaUKLPxeIyH2mIkPuEmKAs7Eyc3Wg3IEok16@vger.kernel.org
X-Received: by 2002:a17:907:60c8:b0:c49:a4b1:9cb1 with SMTP id
 a640c23a62f3a-c4ca795fa50mr1973235866b.3.1793822725121; Wed, 04 Nov 2026
 12:05:25 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-v2-0-b45cd5789ac5@brauner> <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Nov 2026 12:05:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj9Y9NcOesBBm+jhPjYa7qO00fD7g7uwX+H-k0-R2difA@mail.gmail.com>
X-Gm-Features: AclHuK9j_YIgrwhhpWOlnull6heAULBd4dgTqoOhUQQjFm_MgoIgrL1vgPfefvI
Message-ID: <CAHk-=wj9Y9NcOesBBm+jhPjYa7qO00fD7g7uwX+H-k0-R2difA@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 00/30] proc: convert the fs, kernel and mm
 entries (Part 5/7)
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, 
	Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net, 
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, 
	samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 4 Nov 2026 at 11:49, Christian Brauner <brauner@kernel.org> wrote:
>
> Part 5/7 of "proc: move procfs to what kernfs does", on top of part 2

Christian - way too many patches, re-sent much too often, cc'd to way
too many people.

Nobody is going to read these repeated resends, and all you are doing
is clogging up peoples mailboxes.

             Linus
