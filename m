Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793642663;
	b=4VcStdXY0VvQ3C9EpW5OQSgmXHjqmhuD3Pv7rfHTt/fko800b5YRpC26VqCs0Ch+rnpx
	 f392VSyM0Ru39SHIEqPJ2cUd33I5NT72T7XwX66synQbYvBSISn4m271slJwY1KurFH/T
	 4LTUc8ENelIq0zXw00aLFnFd2t+tUq9AHds9XbTtqbTuTVCRh+aKLawXhiYnWUBSuu7So
	 SCULj6+DZpdobAM0yL7oGGzRpHYn1m9HhHRRYoTicSNAnXuHOza13iLswtBlfettpASP/
	 q3JXmeXdBs0oZgzfzHQsY4Tcavpc7SpcwEo3ckwyVV5PquuMckZhSpFAleOsF/Kb3sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793642663;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
	b=33Iy0UmC8uqlOyKDH4RkTDRWNgc5SxyoCrp2UbjY4hzGsxxhrM4xIo32jjNTl/Sgmflb
	 XzsqkuxTJAXZtJCXe6FWl/+sDPckpB3CFWJ/SL0tG+CO5s8nFiJhF6mNyS7CP1N+JnxRU
	 y3V2J0RWwKVtvr1PwloUuB3pcH5F4dDbHrNNu3wT+Cy4DBHETU+2kDq5ZXE5u4EhxlCka
	 XpWVvQvQIRMlLj7IqzLbE6OxuYxaD3+KwPBCtgcip8rbcgldrtM4bqnADngroVELhjau+
	 ZHeHKh4DHxJyix9D70jTH1frEHa2Wa+i9e919Yz309YOhuQpFPU1UuHL8pc3F1kBdPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=MzYT04zw;
	arc=none smtp.remote-ip=209.85.167.51
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B606606A333
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 18:04:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B606606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=MzYT04zw
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5be4fea434bso3800653e87.1
        for <linux-cifs@vger.kernel.org>; Mon, 02 Nov 2026 10:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793642661; x=1794247461; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
        b=MzYT04zwrhnbdxth61FTetzE8V6R6h05wHaLNy105Lz65viSHDmFZMYz2r0Xdy6fEn
         kVPLAZj9ymjlPFLAOwAosGiiS3Hhx+ZCKo2bP9D+c+fLCqlouQtHkRfekl8MUW9OnIh/
         jLOcOuZ5ruCH+B0ilV1Diurp0hdJKaJ4VaLvc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793642661; x=1794247461;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
        b=y+uSft3Isx42R5tljF7PHRSLkxa2Lul4ey/BicfYtQiOhpPQZcKB/KJeahDWCScBsj
         HyZg4L54VBsJGXGmqTfTQTl3oZ+PGnq9sJ+0OjMD3gMPBoCH9vesMrps2VKc/IbFLpje
         E9xUDYsCt122TIa/CwoKPVQ5aax1eOLBSg1LuTGWJn9EV0oETZMN9GBMk/MWJEyFDhrW
         i672oMB93L2QWAX37kcD8of05hV2f8/YTsaey8hJe2Gm9yesOEZMBqsUTh+rAlO20ibM
         5xW7qCBEvKxO/dLFQkZWXoE/jJDoUu6kZXVmcHm7bySC9lG4HonDAntgMJEMNuxo1XtS
         /4Hw==
X-Forwarded-Encrypted: i=1; AKwUvBwXtJivR92cvj05gcX4Ih4NbVUajRmxQB6UoWN8Vz+62N9bsxYH4xTyZYqeYRQUOh2d0hkQF8pMFQMZ@vger.kernel.org
X-Gm-Message-State: APuU4Z9zw2XmVc9FRhi6LxyPHC5D5VGCIaESLrqFzySmhGX+/jHzi8fz
	u4BHIIz6ari3xR/6VflQTkRZ0xzVoy3pfBbFgPk2PbRMxUlX1ho5Y8R0zbnSgP4QMnPhFUHGd8N
	8h8hR/Yu38Q==
X-Gm-Gg: AYBFou3u4rZIWEttZLpTYX4TZ05FSdSr7GF+dmmG8SGRuugGsxNoQOfqr9qYHteQgwH
	bCWsg5vxOmdO/+vIM5zjXWumhgVl5QaKjfwwMJO3DMIa67nuYfO3Ja9c1X06jGSsHXOXq+dJmEh
	PKwrDqKmaO3eWvWraO6Ipai++6NXh5VwtOUNSFZB5nm9tjGIAT7KA9bLYASV3rLbh8gopXPcwwo
	iiT/kOOhoJDVBir7twyZ9tdMcXxSRmRvvDj/BOJypno9ZQ5tgBhct+7eLq0pG1WwW7slimcTj2w
	0qoXj4YMPYyUl3f926oGQSFQHuYbJF2IJq4KQFZ0eYNpNsp7FofH6iEOiMEihGiX2VDVPE9a7Id
	pLHwgs8Gds50Um1pzLOKSsQxa2RI6OS7AE8Cbdh33fLZOnMUWGl0uAgGmYF4TEs2/E7fyFjehDr
	kepg7LOmuzdHAsuendxKE4R7zRFUFxc0HJ2GIfwCQrgZOLKIPoLfmTFl6h86ogpbC+ZUpEy3PhI
	+PRhpwDBn9HCopDswaXZUAFZdNYFoR7eMWw/Fq2eDTtQ2Gfcb8+NCjsabxtDiOQGEyRe28OPQEY
	Qmhki2SzYmWLh86H7m272dYaCoOeNGCSQxfbkhjbQp0L5VtQULXTgY++fnpA+YrLjB9GfmzFTIc
	EJeJQMnOhjqYIX6yk2bQRXcQ=
X-Received: by 2002:a05:6512:2383:b0:5bf:c94d:4b49 with SMTP id 2adb3069b0e04-5bfd11ea1e0mr3747409e87.12.1793642660770;
        Mon, 02 Nov 2026 10:04:20 -0800 (PST)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe0747cc1sm1802193e87.70.2026.11.02.10.04.20
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 10:04:20 -0800 (PST)
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5bfbc25a76aso4762056e87.0
        for <linux-cifs@vger.kernel.org>; Mon, 02 Nov 2026 10:04:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwevgrFLLy1UhCsUbIS2N51HNzpQ5ewrTq35FAH+kXjzbsw3xZOhwM4KVAta+6CFeRm19FvECLLsY5a@vger.kernel.org
X-Received: by 2002:a17:907:d94:b0:c2d:c80e:8366 with SMTP id
 a640c23a62f3a-c4ca7426f6emr874452266b.0.1793642348398; Mon, 02 Nov 2026
 09:59:08 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org> <20261102-work-procfs-bugfixes-v1-1-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-1-59422ed3e465@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Nov 2026 09:58:51 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiSA7-mqmAjTQDaU7UjUyWt0TxYwXHafL8ZAPudy+B_uQ@mail.gmail.com>
X-Gm-Features: AclHuK_qZTBVsLQIdymgRHScSFenC6XsGggUDmcuOugjrSTbuVkeASUmC_hYPZo
Message-ID: <CAHk-=wiSA7-mqmAjTQDaU7UjUyWt0TxYwXHafL8ZAPudy+B_uQ@mail.gmail.com>
Subject: Re: [PATCH RFC 01/38] PCI/proc: don't truncate the position of config
 space accesses
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
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 2 Nov 2026 at 06:22, Christian Brauner <brauner@kernel.org> wrote:
>
> proc_bus_pci_write() truncates the file position to an int. A pwrite()
> at an offset like 0xfffff000 turns it negative [..]

I think this would actually be better with rw_verify_area() just
checking a per-file maxbytes.

We already have that logic for lseek and friends - using that fairly
hacky combination of s_maxbytes and !unsigned_offsets().

We should combine s_maxbytes and unsigned_offsets() at file open time
into f_maxbytes and check that not just at lseek but in
rw_verify_area.

And then things like proc_bus_pci could set it's size limit in one single place.

Hmm?

                   Linus
