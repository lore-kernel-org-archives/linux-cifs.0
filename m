Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE41233D9E
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 12:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777464776; cv=pass; b=M4Gbnrk70seZQ40p0dUtBtqP8hOA3Ta4D4goc4m9MhxAm4l7KNjf9inD4NMUAV/P+IJZcli2MBrA0+6GdDmNB4lwBFWc0YtaKFU2kdoBytJXixZJUPWt9TExmErrKWVHDsnb7aNlFK+N1FYUoGmyU1oFhQRIFNXm2rwmfX6pp5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777464776; c=relaxed/simple;
	bh=AHdErlLreySV673yRF0MYcmKA2UeEjb9XqMwZY+IY9Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iFI3emrE5mifSIroVrjxl+ckmep2bc04fNOulX0Ay+FRxGLnkZ3SBj4w2OcVACyJWH9wwwhpc3FC6DWXSzXQPuapYpQ+5zkdVySzKUn0pZF6LOQWv237jQZhiDxyFiOzLE7zWEymLF601DmPWWu6lQBiFA5BgZ8Vli+QVXV4VoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W5/4gXDi; arc=pass smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W5/4gXDi"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-65019c1dc32so1385869d50.1
        for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 05:12:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777464774; cv=none;
        d=google.com; s=arc-20240605;
        b=ClIHa9/FpD12El68FPBu9NIi79YDMWbTrcDab5tYrIw/zYsi770rSIyFCOZ7LhfvZt
         L0yjbrehAP3vxkpQW2zv9lrDOwZvJIFSQTkrGd7ZmSZo2EFltufhsKeoz9xdD5gi95L1
         SKcFiRyAwvMJyxDx5HME4sM+dulkKi8v+K23bzuZgG6g8pD4x9BGrmAkc0mB74v3JblN
         pCXXj8Yo9aAzxx1mzjc5MITUmCsnRQ3LYINk7q7h1x8LEVRDw+6bdIEKakIB8KwQ0G1h
         +lAqKzmMnFoUwApzQJmiO+M0oIPRt1lqFfuC7J7laIGrlHS+EJhiJdZ/XpYYtlf9WjSh
         TOwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D1Pyw1p1EmGwoc6a+NeyAV5SApnCtRHwKX0dxphf/iw=;
        fh=hCL7wPO103ryRGWvN0eEfQBGhDaaF1YjQI0Zz1N8oAU=;
        b=QM7NRiSJuwgqywYArtiVgB/RINy0XI02HqG1yXC5lmsi/jIXsQNFnQHA8N5Bz3Qe+b
         WM4Q3yJYgc2WqmivWV0XEzM5vIhuRRVzqgcJk91rM4hLPDG77NheajBgap0nEHJ7nmPp
         TFtlqLLUQJANm1QVGnRbFc5hx6MkmtIKu6diH3whrLTe/dH2Yx8mzU0gldFXZA0OwNJ0
         eC3TTfTMl9atiF890239Z5UcGGTRipfGBg03eaIwm3OhACl8bgunWWAH0nj5vGJ61udG
         uED5s2bLQWqVlJJaKXipeD68GTYtGzPAEFBEpWPgzRb2f2PEx0lo1J+6IaNiN6ZRKVA/
         3Q9g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777464774; x=1778069574; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D1Pyw1p1EmGwoc6a+NeyAV5SApnCtRHwKX0dxphf/iw=;
        b=W5/4gXDilU30t11WoUDiK6T7vfXs5tP6aRLxiptS3DyzRfz8PObbH2QRNzSKO0gVvO
         CU83ZuTA6JqMdge8UADGJ/yqXVKoL5N+ZTiUW4AkOdSvibHlmiGG93+664ZVvnX2vsBW
         G0KKr5dyKiPkwEDNHmn0BwkSKo9VDbRYiJv4iVK5uEsaHyv8PSi7IhYjOp7igXtC2xDa
         GcCUMpXYIUFcHYEM5pp6y0WvI+9qJw03RukUjOR35wHL8b1jsqstWKXVlqE0N6CVDyhP
         uyioVNAvLwrBb2lV3EGoo8glnqJLriJRXmVpBVE7gvBtNPtc9lgdh/Imc9W0qEzfFIuT
         A27Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777464774; x=1778069574;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D1Pyw1p1EmGwoc6a+NeyAV5SApnCtRHwKX0dxphf/iw=;
        b=qewR0gaDtpAn+kRBflL2vgrw4lxyv65WGqF+yZzKjZPAONuuwq6BcH7dWH+5M0X9tm
         VhgIi6HGVFUD1MdhCImxcIIo+5k1GhjPd9bBbZB2Bk5XTVqjb2p/pn7Xgl9qd80cYFwi
         ZjTWxWLdmR4JjhfqitCHWkQB57G+Pesz6whG39y4diB/69lUdsni2sqWdaNhn3nG/RLT
         D/GlDItZaXQsGzQgnA/jkYn/LFdInIxXtR2OW/pSrBadKkcLanQo/1mf8KuQfrxAywKG
         uq7OYb1NJO/L6Qfc9FcqzeTRVXOe+I9FS1pU2bNh7tt5LVStkCsDjIr99ZFvKtTis0hv
         tmcw==
X-Forwarded-Encrypted: i=1; AFNElJ8AZSHY6l1AiZy3nL9ad3JmD+/RL+8d2sz9A1fjU5/xrB5o/tKM0bRmjLol7OrrHT+AG6aQpuPQpSEF@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/fPV66wB5slSoyzI+JUjkRlk6lQmucvJ+HCUkw1LfBRhM+qt0
	yqm/ECX1JpwG5Zp0Wp41QqmTik6szpwdk+Dl1ukWfsVDQRbzX0SCmYDHRTcN+Gekama+Dh5pQz+
	ymY+bwvkVLjIFR9vTnoLQBnqTbNn+Olo=
X-Gm-Gg: AeBDieu/hp70n0zRkIXjtdoCGuQkz6M4HdmLlSpr7j/DMwNb0PsnjLZP1ES7Hp8885J
	JtFQ3kLl6btzsYD1/fqkO/0orGl8cIsWurNEGSakXUZ6I4mV4xS3q7TWXj0XAtn52hS5CpE+27+
	tXwbes/iSqSpLqjGTpLRrF+Avtt0sDn6SSPyPtL19lvMfcFUEvo6m3nt4sDz+5uZP0EDuSqIREi
	T0eisuRv9BJYCKv7hQ1VgSyNs8PZDLEwJWXu4XrEE7bPeo0P5S3NwLsqYRvJV8KxEiKjfQxvsU4
	0dAJohJUmfAxG4jzpyvI3jJ/l4H9vbI=
X-Received: by 2002:a05:690e:43c7:b0:64e:acda:c126 with SMTP id
 956f58d0204a3-65be0983eb3mr3470667d50.4.1777464773819; Wed, 29 Apr 2026
 05:12:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416151839.3315696-1-charsyam@gmail.com> <20260416204539.3536168-1-charsyam@gmail.com>
 <CAEY6_V1pbh05BWHtsudj3XAdsAEM1Mcj=KFH9We4mg7oD9fv1Q@mail.gmail.com>
In-Reply-To: <CAEY6_V1pbh05BWHtsudj3XAdsAEM1Mcj=KFH9We4mg7oD9fv1Q@mail.gmail.com>
From: CharSyam <charsyam@gmail.com>
Date: Wed, 29 Apr 2026 21:12:42 +0900
X-Gm-Features: AVHnY4JJjcdaV6P-aSBs47QXK8sw_Prq2tTaV4hWry3LRQSoXivcODWYI7q9_f8
Message-ID: <CAMrLSE4QisJz3tToV-ct41yzPD1wO-jJvVSeoRxam=TAq7Zc9g@mail.gmail.com>
Subject: Re: [PATCH v3] smb/client: fix state corruption in smb3_reconfigure
 multichannel path
To: RAJASI MANDAL <rajasimandalos@gmail.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	rajasimandal@microsoft.com, henrique.carvalho@suse.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Rajasi,

Thanks a lot for the careful review =E2=80=94 you're right, that read of
ses->chan_max was unprotected and races with chan_lock writers in
cifs_try_adding_channels() / cifs_chan_skip_or_disable().

v4 fixes this by folding the read into smb3_sync_ses_chan_max()
itself: the helper now returns the previous chan_max value, so the
read+write happens atomically under chan_lock. The caller no longer
reads ses->chan_max outside the lock. I also switched the helper's
parameter/return type to size_t to match struct cifs_ses::chan_max.

While I was at it, I also restored ctx->multichannel_specified and
ctx->max_channels_specified together
with multichannel / max_channels on the rollback path,
so the user-specified flags don't end up out of sync with
the restored values once smb3_fs_context_dup() copies the ctx back.
v4 just went out =E2=80=94 would appreciate another look when you get a cha=
nce.

Thanks,
DaeMyung


2026=EB=85=84 4=EC=9B=94 29=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 12:17, =
RAJASI MANDAL <rajasimandalos@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> Hi DaeMyung,
>
> Thanks for the v3. One minor suggestion
>
> > + old_chan_max =3D ses->chan_max;
> > + /* Synchronize ses->chan_max with the new mount context */
> > + smb3_sync_ses_chan_max(ses, ctx->max_channels);
>
> This reads ses->chan_max without holding chan_lock.
> smb3_sync_ses_chan_max() itself takes chan_lock for the write, and
> cifs_try_adding_channels() / cifs_chan_skip_or_disable() also access
> chan_max under chan_lock. So there is a potential data race between
> this unlocked read and a concurrent reconnect path writing chan_max.
>
> Other than that, this  patch looks good to me.
>
> Thanks,
> Rajasi
