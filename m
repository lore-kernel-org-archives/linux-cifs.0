Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872315;
	b=bgObStpbc9z0keqMsGOhrJfQ7qiKCUgD071xMa959xNnjaEv62nyXC1IydIb7I7J0kau
	 h9OHv0pIHe8sT7oHz5AEW0/Nz5KFFIqhrWps1rzTqjoGvt8A0RJ4ecqwt+sLZa3VAhtwF
	 6Jm3b5H8WjxY2u9gyHMCAv9/TKpXLZ6Kf91oMzAxx4Ya3DwzlVz+OSj5jToGCQsbyoCnN
	 cCe7PERIA3hoJRSTVkegS/oz4hA7JXRmFb2hpnKJm3IxZgqMtTeml1GV2vIuGyEZeQmbx
	 CMllkG7m5yN8SiP3E4VNk+eFRATFpqcX4/NDV7TzDTFpbp+65wDnPQMECdWMAeCxQvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872315;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=SqrTjgENN7Dfs+HehxbKPgACeb32UvvfMAFijNHd6N4=;
	b=bIvkmZnv4Vig7Eumq9bCr5Y3iVsHaxGh3bIv5NLsnWITRQNn2HfxZJ5NSeAxUtJzIz05
	 FBxSa0NAxLY2EHFF4xvWS2t4po/fNgnfrcmtBWwqAXOJE3eBknj33E204On6eqgMeuI3s
	 Pahjc526kRwRqy1lOK6HiUds4uBk/x8rByC5tcW3wjeP3+HHsmLknjCohZH3bqKSxloho
	 vhBwEaYI9c47XoMSPUfhvAEdbVr+p8PHjegU1MYAqOtMVKcsLLOt7ICM4Pl1e6dlHfRwa
	 NnOdOIzYvVLVhNdknML3D+JB5y8ciURX94Hs5tmMJghtkxEL/7w6kYzvk1uR7JkchTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.222.170
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67D9606D80A
	for <linux-cifs@vger.kernel.org>; Thu,  5 Nov 2026 09:51:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A67D9606D80A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-93f269e335eso195816885a.3
        for <linux-cifs@vger.kernel.org>; Thu, 05 Nov 2026 01:51:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872314; x=1794477114;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SqrTjgENN7Dfs+HehxbKPgACeb32UvvfMAFijNHd6N4=;
        b=SRs1+hNQtkOX7WAMe4AbskNCPX6j5+JtB4zhcv8Uqw75mP4gYeqZh8heUFnIUjOf7H
         /P5F0JXU2ilr8cB3AAdWhDL8wu8gbxpy7x5nHX/t53hvf0RVC2QhQBlqAl1/c+cdvTOm
         tzilEtNYQhgOy+PLbpZA0BJu/HtzijhdsYkxxSDwj08ARsj4K9WTUFafFuSaQj5RtKHd
         2/P6w5DS9NCpidjkzL8p4jconEbEl/P6rK6jDCKl8FUnLOwkKmvtOQI7RbtBncgl9ItL
         1Fak36Cj4qbAbH+SMPBWbymC7lVA8u9rvkUvPNeYhLofIapDsue+GaOsC/8KTQaEWtHF
         OFvg==
X-Forwarded-Encrypted: i=1; AKwUvBwBav3PsCfJS4F0TnanlHi+uYqc9AKPr5bZcISe74UglGK34WqU/bIO5euhXBW8gtvaJUuWtqMEVOU2@vger.kernel.org
X-Gm-Message-State: APuU4Z+/bM4HJF5SZ6qjmYnug/MBYWZiOcaA6s0FSSFkVSzWN3GvHL0i
	Kziyc3o0UUGHeaJQv1tBIj7CEIwUJ7wvn91RbhfzLzE1OdyJ573tWBMu3Lg8Ipu8BW4=
X-Gm-Gg: AYBFou1ai1DWolI4PnOhyzraKb/9XmYEXQQdZptlvkCRryIlmVUbctMkGiNxSMVm/3k
	xy2QXPshyppR9LvU99Uwhf4uYiXHngdPys45all0oXkX5ZvgZ1gZnMzYB9zE5gwBIkfywO99U+a
	FgpVuujkACbbMl9kwNp1OTStNPO8FyNvJbO1z88SNgMDgAgAh/b2QMJD1Jq4Q7LKo1Q7hyGGDIw
	qzXu/a5vj3dCT3QnuTPBALtjeHR1vOanTdo8c7qDUZ4gBvqwehtdoM7lGuQuaD6XwbUTzIUvAiR
	Ila1VJwXL1Sprs/Di7A/73n59V0m0SRf6hObdwYI6n1a2GwK0KMh12t/Ib/Y6oZqEJzCvXks4Rh
	l1d5zQ4uDpvjq5gquipCSuyb5OpaoADoYCLbRcxvZ4hFeke24Qfxmx2yJI1riKXvPiP8Rad48vF
	slGbVn8d+SS8cwTbPD9QPbBU7C6fBWtrCRfHYmBNCp5H445agqbOLa7iZBrJnGpUR8hRD3hibpn
	eE8BiS25w7huNAW7Bon+F661lGFyZAd+okvYfGZoDY4cj8+1tf/g0tKdOh6/r0RBfIldmYaHLc1
	wce9wDyVRnLT2O1RtEvm4jas3n1aAfZEeAABIu5QC8NixT4FOqtkMEIsudR/J2L7nc78ur63NbA
	8J00dVCIulDussms=
X-Received: by 2002:a05:620a:2806:b0:93e:c12c:fbbf with SMTP id af79cd13be357-94421743096mr3179309385a.76.1793872314482;
        Thu, 05 Nov 2026 01:51:54 -0800 (PST)
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com. [209.85.160.176])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91e7dfdfb81sm43424676d6.19.2026.11.05.01.51.53
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 01:51:53 -0800 (PST)
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5365f9a04c5so23463731cf.1
        for <linux-cifs@vger.kernel.org>; Thu, 05 Nov 2026 01:51:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzq2UODnFnQ3jWjeM4dgayO9eMIcwxtKIK6HTP0JeFYviG/GHxr0W+o7qA6fwS4ArvtrJB692lCh2G2@vger.kernel.org
X-Received: by 2002:a05:6102:3ec5:b0:7cc:2bb7:131d with SMTP id
 ada2fe7eead31-7d072baa484mr7324212137.9.1793871885062; Thu, 05 Nov 2026
 01:44:45 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org> <20261104-work-procfs-bugfixes-v2-10-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-10-021c84d852e0@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:44:33 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUy1RYKG0g8OWss3AD-jyYx3DXL0K7ABYkFUdxTxZ9VdQ@mail.gmail.com>
X-Gm-Features: AclHuK9D-nB8icBns0zdoQH8fV1cfUPJ6LOey8o_VlUZpDIGqKC4cFf8-j5-HdE
Message-ID: <CAMuHMdUy1RYKG0g8OWss3AD-jyYx3DXL0K7ABYkFUdxTxZ9VdQ@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 10/51] zorro: size the proc files like what they serve
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

On Wed, 4 Nov 2026 at 20:18, Christian Brauner <brauner@kernel.org> wrote:
> The files under /proc/bus/zorro hand out a struct ConfigDev and seek
> within that, but their size says sizeof(struct zorro_dev). Say
> sizeof(struct ConfigDev).
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
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
