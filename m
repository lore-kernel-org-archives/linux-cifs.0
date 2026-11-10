Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794273623;
	b=qYi/nwpISz+6dn2gZgDW7WPQ43p4oZ04p80GRz5H5dqRgmxe7EpHIW3YA/R3VkfbXafA
	 3fMPArYVK1AWLNZm4BDK2loYuDBcElY7UKHYk9k3KA+ZXVCzBdTwFpktlTLccb6vcfjQC
	 izA4G+ax2wdRVOLIYO9bTxFgMZRh+pQ8AISsg/SXAE0/AbfqBetbr96NC+G68Pz2XYbt6
	 zwgnDRoGSsNe+dVr1fHbTUEZhAVu0t3nUQOd1e5eoT/xDmZOCyScGu0daAuaXcv/AUF7b
	 NSsxqWdxZ3SJpxP7ASy+CcVnpmGiyLNl7Tbve7x4jl+iklZRiXRGjuiUOmQnYC+PF+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794273623;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=m2qXctBTC0OPADf0V2KkMb6r2GA0JgabIuFAMe6ERzQ=;
	b=ZvS7P2Tan+05LuFtLgtarkgkJ1mEAT8OyHjAhO6XINIveQf2THiTKfiL9HRD9QfrJw8E
	 dHT0MckpYSmaVfEvoof7RcjPGl4DEDYBq1wthFZKeO/21Sq56nkH4ytOgSpJGeO1zLtVK
	 Xhh60RnxjUJn89itHNAfqQiTpJjzqjzpiukHbR87MdqE6SoUKhfC7SeaMI6IePa7piib6
	 9+r7CQjqLU/86G26zkh2xUQ+0fhIUHD3ityg655+WxMq7B/6alwTIllMiDa/qqCbBmXRt
	 2QrppueFftqiv1UrZQwlFP7Ow0NsN+ah1hUuQERPBGUIvLHm6plMyINmDub3FPlOWsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=Xe8uxG32;
	arc=none smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA6A606A33F
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 01:20:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1AA6A606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=Xe8uxG32
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c4d2b741ed9so242293366b.2
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2026 17:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794273621; x=1794878421; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m2qXctBTC0OPADf0V2KkMb6r2GA0JgabIuFAMe6ERzQ=;
        b=Xe8uxG32+435zcpAQpCGPXZ2DXTO5tACgpTpUPc3D3Qz915e9SsQZWCH178bpde/EO
         lBUEbO9I3FARDQIl09WDlgW9dui2z8lgNy+m+GiW9PoXEkvwhjVcaJXe7lylULPtteEK
         Gpj/S6iqUQGOuKD+r9aIayzLdJsWC4nSYtE24=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794273621; x=1794878421;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=m2qXctBTC0OPADf0V2KkMb6r2GA0JgabIuFAMe6ERzQ=;
        b=dyUhZQhleeGD+87hmIFJ8yBUxDUdULdjv7vNNcHeuENNvWTCDs7eDJLG3V3sVgMK4s
         SkvEKM2IuIWxU+b/CJsqVWusMxERnI77tzHaZwPbokc0hcmC776ULNEHTWF/9YAI3RUw
         8ZkHny60j+g94iN6tYfvqMj6p2r5R6pwNdo+VkIXF69cFGgJfg0jPrOU7vVScHhZaXd4
         h920bdk5UA510bpYA8OQ1wykK5Zm3K569ka6PqL9Hgin/O9Ih7JYYt2etbunVi8hmFe0
         JzEdGvjSd7nOtHbcTVngMvbtUDnKTaQWrQqPAEyo+BmjlRvbtLz0mNmnO2y0a8nd6J81
         dkvA==
X-Forwarded-Encrypted: i=1; AL+hErFyqf6N23t4ITVq2Z0JuUydBx//sVuOnJ1LLBq2T2THfPmnSZnQAHFfln+DRBv7nsDTRy+ykhOHwixE@vger.kernel.org
X-Gm-Message-State: APuU4Z/g1Tu5lxGPDItcPQd2jmXB0Ikd+XusuZl2PB6IVmw3EVzS2Qyr
	02waPQp2ft9h8eTi+zW8ktHbkpbty9UlkP6c6/igy8ybO8ZOKl4DpopImyJPDQHEZH6V5Qo/HEM
	MfFQMlMqUjw==
X-Gm-Gg: AYBFou1Q1v3TjMkS3c4PNnW3cc8BAYfy6cCxklL7SfVtA8MtH5SvNFn3GcDtkwc5zR/
	A/6ysaAvJYQUhkA8utVon2ECjaIVxSwBalt1eY84gAqjwuwLz3gxleQvg2aYnSUEYcjmqKDz5Os
	xxc35bPiPcwYNdjgIRsZwbyu7ZmDehkNqL/gAz7bF4iGGWrK9qSn9qLQAAxnHE11usIl0BYszig
	nqr9x54QujVtmgV62FYVP8xrFiqQuzN86aF6zytfzn47ddpAzyXaj+sKki0HSvXpJqWlYPEdaBg
	7Uxzk7Dr3ddLCbQhiYbGSxjaDdWfuII07tXmCSDGt2UMEHz7nZml95V3cSCgbcwn6hCphCAk4b8
	VZ26Cw979+38S9KdoUpAgGq1IvPufudT7WxMdz9riyU6thkW4GtC/yNbyPjw+IkEuMJ5h7M/htj
	ReiBZ5gjBDXgGx/oyDvEjE5zFztuJJ8s9kPGXIYe7+aQTI1Xc98WrAQuV9ZAT6urJfzJGOtwSy6
	C2cFJhd2yuF+ytk8X3r/nU136cnkon/49NhZ8iz4JTpXyT3jhAaRkM4gwB9UIiX8UZnbxP7uRXn
	TjuSgysSUae1awVSGqm89iYUT63oLn7ujn9SrAjVGiik2AcIjd8mnch+xfW6QlHhyNawuSsGj2x
	6bw==
X-Received: by 2002:a17:906:f58d:b0:c25:4f7c:8ec5 with SMTP id a640c23a62f3a-c504965537dmr77074966b.23.1794273621501;
        Mon, 09 Nov 2026 17:20:21 -0800 (PST)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c504a6723e4sm40683166b.74.2026.11.09.17.20.21
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 17:20:21 -0800 (PST)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c450ab1483cso245736466b.3
        for <linux-cifs@vger.kernel.org>; Mon, 09 Nov 2026 17:20:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEYa5qJyX0IjGs/LO/DY2ieXKYCkfksN+uBmSc6hST7y11DJs8FzBcj2wZt85EosTFEztiErrT0z78O@vger.kernel.org
X-Received: by 2002:a17:907:9451:b0:c41:1750:59a2 with SMTP id
 a640c23a62f3a-c50495dfbd5mr87253466b.12.1794273275844; Mon, 09 Nov 2026
 17:14:35 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
 <CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
 <20261107-akteur-gemieden-eckdaten-21304d085e35@brauner> <20261108185953.28054fb3@pumpkin>
 <alpine.DEB.2.21.2611090504170.17804@angie.orcam.me.uk> <20261109214558.0d9d5228@pumpkin>
In-Reply-To: <20261109214558.0d9d5228@pumpkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Nov 2026 17:14:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=whsA3tKcUCBJDj_vmJ11rVGT9rivgnKjGRgMO21CPmCxg@mail.gmail.com>
X-Gm-Features: AclHuK-x8jcOOQUqd2amGoGEAKER9jIFGaeL4LxxWAd0cGV7dz_RR64PtDogpPU
Message-ID: <CAHk-=whsA3tKcUCBJDj_vmJ11rVGT9rivgnKjGRgMO21CPmCxg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before
 pinning the entry
To: David Laight <david.laight.linux@gmail.com>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>, Christian Brauner <brauner@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, linux-fsdevel@vger.kernel.org, 
	Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
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

On Mon, 9 Nov 2026 at 13:46, David Laight <david.laight.linux@gmail.com> wrote:
>
> Just that the cast would have to be:
>         u8 *foo = (u8 *)bar;
> where 'bar' is 'char *', and I don't think you need a cast there when
> char is unsigned.

.. and just to clarify: 'char' is always unsigned in the kernel on all
architectures since commit 3bc753c06dd0 ("kbuild: treat char as always
unsigned") back four years ago...

            Linus
