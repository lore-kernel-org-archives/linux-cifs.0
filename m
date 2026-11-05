Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872533;
	b=IGNi2GUtrEQPwVm2qAKSoxxtDROUo/Fr4SHt/MQHI5YVdXoPZNXX+IiCSExZUpY9zBWp
	 xhGexCeHXMlz61fSDTj9Y/epW73+2HX227vV38N4ZzgIVQOK9zMIYHa3dgYX5+bxeBPKC
	 ZA3Cswzn1LJDHnQ2tzx1iMxwOVFp+NzKTba5ANQe3kdltwm7QqihQp8D2K+ExUBTyt3tE
	 z+jiOOA4ZWKxrpqnsHXXhwM8FAwniJennjPiwvbD8rbpiDcjBhRp0nBiutoewjz8iPvWj
	 3rI3TpyPGGXeDwfaszq8Vlg3BXiihaD2owCBklIwu2O6XBD2WC6iTLG52ynLfPE+cOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872533;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=LrgDMUrSYXpYgkAhfsYKg0ebb/uLgOfOMhqzX4yL0j4=;
	b=F5NCmoFLbsQFeI2bWf6rjJXR5qthvtT4akYSUOs4yoMdACHkUd/p0CO+mtM5XghCZFGh
	 YEeK2cvxl9j62JWzob1tyZJzcQYh2XcLupQnbZ/0ElzyN9kLECrgA7ePvwIeGR3+JQcPc
	 G9g3PB7S/WXewuLdsHP40KPiam1SUcgjSlzRbjVEQDwk5x05cLSkHLd/7DfJPZM3tE9Ad
	 kPoqMpXZn05xEt0vZSI/XczP+0cb43It10ctyPU58cKR1xIrIB43KnOjl8yqk4OgsMn7A
	 unjyOoZEmp6roJ9wDs6l8KcM3EUbygxgKZzrVBx7Vf3+fRoHAbuQJdJ/amM1+N1pVsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.217.43
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB61606A330
	for <linux-cifs@vger.kernel.org>; Thu,  5 Nov 2026 09:55:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BB61606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-7ccb2ffe333so1098296137.2
        for <linux-cifs@vger.kernel.org>; Thu, 05 Nov 2026 01:55:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872532; x=1794477332;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LrgDMUrSYXpYgkAhfsYKg0ebb/uLgOfOMhqzX4yL0j4=;
        b=Z1FlipC0IMa/ySyP0i3DIBH2JH0GY2wxNQLZgUxAxpUSz+PwgTZFwf4fevO4T44SD2
         Z9iKQxn1pK+20jwouU1CE1m8+7N5AjDH9rEX878Zyf93JGjhKFRnakA5lUoDoyl3wXZe
         C0Pt27jH9H1xw7LjYMBCtRZpU/Ozr8CNAmBuzs4xr8GGcbiEp92e/SAhDthWJmAWZYXK
         lq7RWZtovJmys8SycvJgDupDjLTqNdRicolZzQdnMeC35oBeAnaQnNZ5Kju/ZNTW3I/6
         VMbIPGMRb5qLhJ1Okrw3SzxmYVpiLlzc0Kh3L0PDDGIGwxEP1Hx8XBOtj7jWTqd0OEJU
         9bJA==
X-Forwarded-Encrypted: i=1; AKwUvBzxX8zw0NMVZzCc8F8R3xRi5M0XOACjHRGgHnP9yqVMSu6UBhh1ESgvHPZ1ns9ssqTc7pltm5okG1p/@vger.kernel.org
X-Gm-Message-State: APuU4Z9mo6yO69C1tju+HZcx43sL8b003H8uHiGIkJ3usrG7OGs9RiFL
	1sYEHxI+tizDI1mZYhexLtxzi6Tov12CAhlKBwv5KjzYQ/HOqtD3BN6AYIS4LKb176Q=
X-Gm-Gg: AYBFou1RE+b3TQfSx1iTE3ZMEddCJRWKdyGHmFyWqHAg8bJuLMltARo2afq8pPyfrv4
	pAYO5/Sy7CE4ypq+6TBi/WUIqexU8CYGeLacqc0cArvxVvXIWuo33HlEj4D0Kz8mI0twl6PmmBK
	YTNKIjP/yGopPkCleZ0YlQ3O69obc46uw7EgMr1JLLFWdUFwk7bkSg0NJXB+ZsHSO7VybXWdoOY
	fHjWwM6w48jI/CxeazF3xF8RQaTHhFePfNcV9CAsFlJjx0r7LGDyJpBW8scp3QfdR/Frlp8T75i
	faPxP4ylhm7SJWLPk400vEFIsDHnEHwtZPuenZ5uk99RHjZJ+sVZ2A4VOi0xoviTlIInPErwiyR
	/lbfuTP9flNNWZgtiabdpT4hF7mlZj90beif5i2oDMUy8+0yK1Q5R//7zgd0aZlpP/qQfXANWpR
	5wIi7eu0/Wj+vMdEug8D/Jvwx939jmdp88j607oxogefX2ckERBHVQDoiZ4NwWWg/7jYiiOkOXT
	TOQDuS6myHhEFNDF/T7J5J1I/t9Kq7hqw8NgaYx6IG81JL2UHNCEFxrcMeFT0LFubiuru7gvwNe
	QT+r3RTB7Dn8tB4EELncQxLgMxx7+U89vMhXcR7VYlCGZ6SADSq/iAi+fpsntf009nurPF64OXB
	xmmjur5lkB/k=
X-Received: by 2002:a05:6102:6cc:b0:7d0:6f1c:b3fc with SMTP id ada2fe7eead31-7d072519890mr9144397137.0.1793872532127;
        Thu, 05 Nov 2026 01:55:32 -0800 (PST)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d28a073cbesm1351840137.4.2026.11.05.01.55.26
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 01:55:29 -0800 (PST)
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-980c4258105so913232241.2
        for <linux-cifs@vger.kernel.org>; Thu, 05 Nov 2026 01:55:26 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwwBL9b/si1HOHIDjOwzSCW5m9hcHXGwv0WoqTNw4hCTw27zvBNyYjFZu83YR4tpeKYPZ1C2HO4WkQB@vger.kernel.org
X-Received: by 2002:a05:6102:5108:b0:7cc:56a:58e5 with SMTP id
 ada2fe7eead31-7d072d84a58mr8269567137.37.1793872526219; Thu, 05 Nov 2026
 01:55:26 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org> <20261104-work-procfs-drivers-v2-2-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-2-245e54e87116@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:55:15 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVHxQvKnJyKHrOZhaOg9Rn2hMeRU1JnMFFEEi31FPZaGg@mail.gmail.com>
X-Gm-Features: AclHuK_UsJ1nGicdWEWcMLQAICTi1A7pGF3yhNkxXkXRPqohle17eXAHHNBsR6k
Message-ID: <CAMuHMdVHxQvKnJyKHrOZhaOg9Rn2hMeRU1JnMFFEEi31FPZaGg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 02/26] zorro: let procfs copy out reads
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, 
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

On Wed, 4 Nov 2026 at 20:43, Christian Brauner <brauner@kernel.org> wrote:
> Implement ->proc_read_buf() so procfs copies what is read from
> /proc/bus/zorro/<slot> to userspace after it unpinned the entry.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
