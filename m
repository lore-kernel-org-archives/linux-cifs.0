Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872495;
	b=jJWplQGUtzFGObZv622HTR0DErwZeuc9gkY+6zxv6YmrvaXHOLRc9ARwfS7aj3/ef8yW
	 MprJ8qDuHiV7p2qS/G3gJpbvlJMe0yOpRpG3CM9J8VqYJmIEv5MwErDtvGzHiMsVAXAs3
	 f1ynyXy/jjJsutnn+29Qr23N5OzWPq7xtPxGtWwURB0lt7dxtCfrmEIy0kkaLLKwXdVoC
	 GBA1FQY5xRlwgB3F9NYdMhyxsebHocuhvIzynIXov+dBETXRRyoDrPFwHz+lToQ8h+gXo
	 cCpJ+pyzbFzE/13PQIKqB3XsH8shST+zY53J1JR38yNOg9xRc0sC5+9N4lJpuU+gThg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872495;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=n+1lmuZTLENNkpqKh8T8PUriZ63OKZ7RGcjsYNzzAGM=;
	b=yKpzA22JYKiRx8EvFZiTO99aOiEGOL7+3f3/R2dAfWMrWR75qLYdkduuUmmQSOk055oc
	 BhS6ELLflz5QQhPrUcCvbuM5dqb5tj2N7VEymxvR0zMaV4APhaaRP7OywtxXbBf7xUhqo
	 uUeY6lIHfiI4nk1s7QGDiROPUXB7GCLI7RUGgT4IPGJ5hFSfqHlZ8VFBT2D7oxboRS5Ws
	 7wgio5YKo62lucMK0MFXo1d80SHsTIe9u96OB/46EsNheKbykp/U7S3d/iIwwN9nAHTeN
	 11Q3a49pJglVnZNT7q3Ng6TrvyeqYODaHBkE1tUWK1D7pBOxD4wmSJ2wvJb7YEIK/SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.221.179
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9008F606A326
	for <linux-cifs@vger.kernel.org>; Thu,  5 Nov 2026 09:54:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9008F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5e948e56af3so587179e0c.2
        for <linux-cifs@vger.kernel.org>; Thu, 05 Nov 2026 01:54:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872494; x=1794477294;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n+1lmuZTLENNkpqKh8T8PUriZ63OKZ7RGcjsYNzzAGM=;
        b=KhuUEFZ3PnDZnnAJ7IzYZZ6tmSbH3w4+sHyBnZ5KEGPNOyu6VSH/iuHlFVW/71VjCK
         A1Az7ZpVevH/qPSpNiWXJVLSGOAO0KnJuVI/hgGg6xiam+LmaOZtRYGV5hRACOMWyx9I
         72ZrNYRWuJCtviF2jfgGxhuan7/VjuTYNPFnepD2747/ipOCnspdOh1tqhktSBuKelKG
         dBg3Ihv2axXOuV+N6qoElOy/Cj9Ig6NrI6woq29boQWVYw3QPTa/roP1gR+z0RX26pVs
         0vZq9dAlmVKUzF5NxmkUByEjeYZxBc9+CccLBv7ePANXs9QonDi6sipLWfm1JBAMoXLg
         3ZcQ==
X-Forwarded-Encrypted: i=1; AKwUvBx3RvEdkk6H68e3BZIaFqNp8UCJyNYzXVfu0kfO9U5QSmk6XobE4HIZbJLx1M4Q4SENhrwNUHqtHSo9@vger.kernel.org
X-Gm-Message-State: APuU4Z9tjJPgpAdR2OCaYXHgOOvRujgVKkHshnnd33pUcXaVuji4BdFM
	EPQ1u7+7DR9BLZZfwD8CW5I1WL2dw/y3Ae5KE+VIQo2plStilOUZx0CbzFh+qK8mr2M=
X-Gm-Gg: AYBFou0983QsLcpuDulpz1zSwfaSe1bL+JRMbVz3vAkckx69/a/ML45CCkDbkBAEnU3
	xO/rNjzqT84qWX7doyo5r0JI9UHOGeR7Zn9e/OxI7hIHagRro+Is83sZYI957M+k8hWseql1GaP
	xcUIUlgJS5wR/tWbyE0Ow1rBwv4+zlNg8JQMwtUAo4qutSLiJ5ZqtO1vT+0726RcGZenEKm3jXC
	/03IBeRHFDxUuROUTMIk2XTRJ2RdQqtNyOA0FCsbTYPKwy9q9fND6XppRnv8EfCC/SD8Fcw5Ucv
	Ibc9TnUq4iCuNSO/4/u71CMSNN9N1q/uY3lVoWK61Y9CvSH/FVxUoyReiQKFTv1cvMCmdG8sPKl
	Ra74DDuP2rOve91KPo5AILYf+E2psfmOYIrXdVUoYlKhr4uciRb01ep5EKxAStGHvoiSEBLyzpj
	fMqD9OVg6VU1TDuE/SuSQ3Rel7fkuDEEcXcsOmw6eKIMVJYNc7YsqlLp/6FLOVcGR0aymkrH2cZ
	u8Lu4xN07N1TwvoRe6Xod0/pMjgTU6ArkYZJblGlADgQbFRf5K1nontI85gniOXjxKUXs4stBv1
	HWj0VyXQU2JJzs7nnOBB7H6T4XnlWDhHJrnZXOhw4qUvf1bDc66rCh8/GSK5AOWdoUU3fQ==
X-Received: by 2002:a05:6122:32d5:b0:5c9:a60d:3279 with SMTP id 71dfb90a1353d-5ec6895502bmr8338609e0c.13.1793872494515;
        Thu, 05 Nov 2026 01:54:54 -0800 (PST)
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com. [209.85.221.182])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eca89b6568sm3952480e0c.1.2026.11.05.01.54.52
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 01:54:53 -0800 (PST)
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5eac6c5f927so682891e0c.0
        for <linux-cifs@vger.kernel.org>; Thu, 05 Nov 2026 01:54:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBy8zynwrGVGM9H/yODN2X93UdMAHw4dZfRtmavdNBMAle6sraEPsJlf2bKL189GyvtlZ1UhxD4mZAEw@vger.kernel.org
X-Received: by 2002:a05:6102:6449:b0:7cb:bc5e:7dad with SMTP id
 ada2fe7eead31-7d072baa450mr7614890137.10.1793872492413; Thu, 05 Nov 2026
 01:54:52 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org> <20261104-work-procfs-arch-v2-4-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-4-2aeb952c9597@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:54:40 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUNBs_NyhFpXonirMXkYptUWsAizMvVpGHUDLzto1LGJg@mail.gmail.com>
X-Gm-Features: AclHuK_RsrcE7hVRjmpZezBV5tMd490Mza2XAQiqUTgUNqAiHAzRP5z7NIbtMh8
Message-ID: <CAMuHMdUNBs_NyhFpXonirMXkYptUWsAizMvVpGHUDLzto1LGJg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 04/23] m68k/bootinfo: let procfs copy out reads
 of /proc/bootinfo
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

On Wed, 4 Nov 2026 at 20:36, Christian Brauner <brauner@kernel.org> wrote:
> Implement ->proc_read_buf() so procfs copies what is read to userspace
> after it unpinned the entry.
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
