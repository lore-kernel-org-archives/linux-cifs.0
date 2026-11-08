Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164398;
	b=H8ofUlvtptoR9VD5yl6XLoOY98IKkaO0Bc6I0smVr5BUpDmdHHzLdEJexMOWXP9jBI3W
	 Odw0o77KYwKvx33XU/1vRdc2vIIX/p7tWL2YhPvryGtCoUSVV6tYSZjb3jeTri8Jb+rM3
	 vwPYzuMBRehB1hiG2SmJk08qWwxGwRITxzDCTrECw9FpEOU6mW8bOaXgZL+cFsL/nV5wZ
	 1OSyRKL+UZmezmtF84lOoS8JkCD1PJuRciiay74caYOJC8WY6W1LRs6LGZnM22FS9Z8Qf
	 MMivzPu08uKHI5aOJus3/hodTzhTMlr7O7LxQG7OiFjv0pHGEGdC070F46AREak5iMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164398;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JLhUwzup1lwefYy8NOOFjthYnrByVfTsqIe79kkV+Lk=;
	b=xUnR2qUUu0uBteG8v4aBAKgN3S2A+pLVQBKXiiI1ovoOaDyyTR57niJKENVz+8q8b+St
	 u6gRL5N+BDoxCmHYTPdyrdPSUZ6ho65z3I5Bp8A7koFHkgPWsqn4sqfcD9I9srNzEAbze
	 dM8ijU2Ww0ntzHKHB/0Rr6d0zryIE0++GIwU68zl9nRfANpS3W63u7bI7J1ic0MOv9MNc
	 T8ayo5D7WdII8mtV4Qk6uTvQFlUQDBtAsiJBiEG6lTtcMKI1IMaZNYxy6MgTnJOmgk1G7
	 kmqN96ZDCXKxbNDTFjFaJF+GTjZvOskSpaiziaarm5bN3TVoioG6LMTQHeT0PkzrYGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XrEUEgHU;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40970606D801
	for <linux-cifs@vger.kernel.org>; Sun,  8 Nov 2026 18:59:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40970606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XrEUEgHU
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso1791455e9.1
        for <linux-cifs@vger.kernel.org>; Sun, 08 Nov 2026 10:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794164397; x=1794769197; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JLhUwzup1lwefYy8NOOFjthYnrByVfTsqIe79kkV+Lk=;
        b=XrEUEgHUwv+lt2Z0T4RzlOQuYT1yMbnY/MJrtF5HY2pc8m0ujKE+1IGJbqc3A1SsPJ
         Pz+po0Wh7ECcrOl1hyNdZBme+OsO/r11IeCA1lW9KMbstFhlOkC0Hm7Ef+TTavGsfrDk
         7T2AE8nlcorDhYFpLo0KTCt4xOv09AacMRilfH2h4PS2mZ0iBReAF8XAcgtI3iT+qlRY
         EJQPYUIUlDRCCjadf1+24R8V0flZyhCZpLCroCVsidoQ510350k4POOaAcSXgGRrBTWF
         rbpUnz5O6K0TOR8uz/zwLHiObwDAqnCJFWP0+ssCNYCBYnXJwQ2yMfUqdKkv6ro/lp/q
         XMaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794164397; x=1794769197;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JLhUwzup1lwefYy8NOOFjthYnrByVfTsqIe79kkV+Lk=;
        b=zxzVVgIVnwQr3Brm2jjJFWfE1CPrg91aWKr8kG3/fhfQVmZvDJozY5LqmW6J8q1CcH
         WNhlgEwthZGXBklaotQGE9QITf38SxJwiH5J9u+gAEFehn1r8c6XoSKKFlZFF8/Gsf8q
         VdtYgw564wilIIT3eE47HenbWM96MyW5C5MKYmywUyEUfbUxRVUC8mbmY3r336tbhLG0
         yR8vx73X074tQtIs2i9cM22HnwFO0f5/GHlApLNF26NpECbxaFgbu8K2BP2Ij6l4tjiT
         g0Fi8sPxCcyeEaxZ/R002SqauD5VpFfclMmiHRGaRH28Lved1NLrjLTDYuWNxNeu7bZ7
         enHA==
X-Forwarded-Encrypted: i=1; AL+hErEBx+ctdA+c9AKMahPXTtMsNNNEjK67p/DbePBR1ZTcvQBg7W43UWP/lRwzqtsWtXGd8XshcKoeL5Tc@vger.kernel.org
X-Gm-Message-State: APuU4Z/YuMxHzM02tbeNe6ICoKCDKnxvUJp+qT3xsxheLl2+B6ffqHiP
	5HMlvE8XokWCoJql2SIwVDDaqwQdC2Z53cjqyfTBnlH6mn+NTHqCVSG3
X-Gm-Gg: AYBFou24WKUEUoPl2eLIsIxnR4RXZ56rOggYa2Lxru71ubl88rJ/nxj4+rCIY1kYnIq
	BK9r5JmZrtPGIDwD/6B/cUbSTxLXrxZesppzmGdhDV8KBzyG4xhbl+JfNaJ/pWPONLzSim2BwXd
	BHGQSaoccgixee1KDOts1eAUfjT5iCo1aMlz8xjjmFz+RVpTv3oxzWANN/jfzyUcLvJJduff+2u
	ivN24XKUX3xwRyqGq1Fa4LleLXYLFStN0aohds/rUBUdas80hRMYgDPuNsR3mBVLYhAFHcEH658
	uuT0lhwYacrkkF3h0aY06NgbQAY6mtfUEUnjR9FxrVKTHCtYpQnZxnzGbzuF+DJvCtWR9KabeK7
	HYMTQf7BpPtkZOBaYG2Lv3uRXMeLU3jO77bEi70bBA0wGwvDQJ4FUOSRfCVbt3R8pnGYZLvXwsw
	MZTcx9fRm9/CCPguUUacwXG5Yr8pb+WzGQ4i4c6zBOGqHVaarKLQeSkzufyT+V2N3wRgfKBleK9
	IQG/0HY8+VkPuuPFfYO35yfWV/u3pRTbxr5cZRJlLgMx0F/itLsPYlygbVEklMWHw9nmEexmLfU
	B5GdWkTJ9op9C/ozyr2HlEKo++/mFa+NHMMUF73VS2DqCcgnzHA/o4asaTesNqqz
X-Received: by 2002:a05:600c:468f:b0:4a1:7e77:c382 with SMTP id 5b1f17b1804b1-4b960d9b170mr35982125e9.5.1794164396406;
        Sun, 08 Nov 2026 10:59:56 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b7efb1f3acsm185228445e9.14.2026.11.08.10.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 10:59:56 -0800 (PST)
Date: Sun, 8 Nov 2026 18:59:53 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-fsdevel@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Josef Bacik
 <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, Jeff Layton
 <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet
 <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Al Viro
 <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph
 Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados
 <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara
 <jack@suse.cz>, Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-um@lists.infradead.org,
 linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 netdev@vger.kernel.org, ntfs3@lists.linux.dev,
 platform-driver-x86@vger.kernel.org, coreteam@netfilter.org,
 kexec@lists.infradead.org, linux-pci@vger.kernel.org,
 linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net,
 jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org,
 linux-mm@kvack.org, linux-sh@vger.kernel.org, linux-usb@vger.kernel.org,
 samba-technical@lists.samba.org, sparclinux@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
 Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org, Chuck Lever
 <cel@kernel.org>
Subject: Re: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before
 pinning the entry
Message-ID: <20261108185953.28054fb3@pumpkin>
In-Reply-To: <20261107-akteur-gemieden-eckdaten-21304d085e35@brauner>
References: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
	<CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
	<20261107-akteur-gemieden-eckdaten-21304d085e35@brauner>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 7 Nov 2026 10:48:35 +0100
Christian Brauner <brauner@kernel.org> wrote:

> > While at it, I think it would be good to use this conversion as an
> > opportunity to replace "char *" by "void *", which will probably let
> > you drop several casts from users.  
> 
> So I tried that too. The thing is it drops exactly one u8 * cast in
> ntfs3's label write. 

Since char is now unsigned that one isn't even needed...

David
