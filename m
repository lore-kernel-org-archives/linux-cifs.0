Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0833034AB06
	for <linux-cifs@vger.kernel.org>; Fri,  6 Mar 2026 23:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772838274; cv=pass; b=YMtYAHJ+4fjOufvO/vyqTpcHxIjmNN3JeDwOUCBzclDNS/LKAg0h4lO+BKOxo4OQuIpINaWYX7gU0Fj4qh1EqSy1Wr1vbL+5x/vBX3ZMFDBuxN/9XKQq/sUxKdEl4sQq5fQUe4Wrgpmjw/44Rt58EBGGZBVghf7QSfAlwqGaftA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772838274; c=relaxed/simple;
	bh=2aOgEgnoXdmPFhTk8Hp3UGs8bI98yC0p8vJeVWXbTl8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z+qiGLRo3BJrq+w2b0G65/HYX54tBIOq4h3knC5y8yMonb19tOrz8M1c50Cu1ywpdSYUjgZAB7Tkuz0DedouCR9skfuoeWnZcoExhEzBjCrtV3+8Y25XbrAwxY858tPvwQg/soILt5qgLdYa223Dz+neYmJFFXUG0eRG7LuPd1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a3cZukYs; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a3cZukYs"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5069df1dea8so77776651cf.1
        for <linux-cifs@vger.kernel.org>; Fri, 06 Mar 2026 15:04:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772838272; cv=none;
        d=google.com; s=arc-20240605;
        b=TLHOAtbEwBH/qs/CGloshxwIcTMVT9/x7AM595CanBfLjT0hcgBVZ2XRKs05XcWazj
         k7U+VX/ojG7O6C7Y7Jdiv7lu68hLuY1WsCM/4or2T4Q349ZgQlItCIlt4Uszamtd5mDD
         u/Ow5Pq9PWxgXQ6Y8Mit0EXyX+r5NWHVo1Mo5IvsFJ0/e7On0dsRIpnD4zHC9o0CpNc6
         UvkhzWaDnJa+zna4nCIkKlnS6w+mNhryoQU4rX7U1zk+Ygaqmxah+1t7lkl1t7eXjsbb
         35+XvGZdxPUPTwUeGSuBHFgD79O3Ns47ZaYNQrbI954515HO0cEYy/AJnGbFQ3Hz2p5V
         S9QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2aOgEgnoXdmPFhTk8Hp3UGs8bI98yC0p8vJeVWXbTl8=;
        fh=9VwwL3TLF0hxOX9NOSu0Lxt79ldNdVqOleUsO0wClYw=;
        b=A7yJ1xWT9GLUVeR7TL1Av1n554yUfyVDhB00QntlvMywYhQo/a4SYWMYEe8syUGB+U
         C/t6ZuzM2YIip3lKszUc1W8MLWucP4Y1hkVHn/zPxpVOfz24poinYpX21Svv9ZZ3jAZs
         7MgXai3/qN3iV1h0pdY05CboiQj0TL0N8BI0N8Q1P1AN38rAJZBeQ1jHW9zs/IsQlnB9
         +GiPpX6k5dp4xkuSD/h3XdJhE71SwPCRQs8fAF29Cq3JD+TXb4LAj+Mua75c++wQBq4G
         OkG2WAKhNylXDleXLtJIE6FNBoPUaiIIYhkW/31/mR5zV9PjecxLZdE2d6g/pm/3tnDA
         1fPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772838272; x=1773443072; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2aOgEgnoXdmPFhTk8Hp3UGs8bI98yC0p8vJeVWXbTl8=;
        b=a3cZukYs2xR/9V7yIXof9Z7yi0vSIiWGpzoWuVydL+9nT7g++HWptCAI+tI3dQu38g
         y/O2CCtF6V1Xl8UjJYUHGgj2lQx+4UQUkr0BKeRygqgi2dcE3YK7A3t7ajpHfuzL8DqO
         Nhe6OmDdpQSRWEUPLop8EZXEis89KQBsjSdE3t/YeqRQyUXvJTuaqoFYezmkenmSmqrh
         sOfyQ08RB73HQmJGHEJt+tGYqgycBJUVwriJ0xQCCqJMuUizBaLWBpsUVIR1aKZ/w9xH
         veravvePNsWao507hMoQwDOe4/7TAhlVRf2S+UBmVSQprO2aG4R6hax6Z1mT+SrxJ934
         Qwcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772838272; x=1773443072;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2aOgEgnoXdmPFhTk8Hp3UGs8bI98yC0p8vJeVWXbTl8=;
        b=ePJgkMT6yvEe1XoMU90GQXDN2wPSDk1UWrIgu9JODhbB/UXUm4psZnW15eYiSgXj1M
         L/m9jPlYsMZDepUUcTEyyxwYC5IWqsgP/WgJ6hLgwrTCUSfQ8Baz9QEYBsFaJfnW1xSn
         XEW4aHRwBjBE47R2GHHSVxbB4HxeBbEnMdo0DwdsJ8l14hhjNqv1ibdke+QDOCQR2aJx
         JT4bYsxRKEyHOjMkD84vvNQ+UkpqSptaqOxYyiqFEFgiVmzC7W6mOX+IpYk2y+1KmVUd
         WeJmmv+NNJ5B6SkZ9AiWcF/zKkXYxmQFuDXA0hBKoWcY65Lels6oZcCYgli6QOSkAAnI
         90Cw==
X-Forwarded-Encrypted: i=1; AJvYcCU86Ym73iVbu0ruw3FpFl0MVoS4GpRy5RHQ+21/02n7AKOcRSat/+14JwJSSO52lEnxHuwEsUvQYPS+@vger.kernel.org
X-Gm-Message-State: AOJu0YyhPSRGWMF/QQAgpDZMckXtBzcHru9tzgZHPOugc5X8EHKZhPoJ
	4SCsEx7dlAtQvj4tBIDbEEmlef1XmvDTdP96lNasaVQ4R3DZCTtkjN0jL89pCAiqyo0JTSrx7KD
	UszyBrjvDl5uwiE662gfQ6oYWt9Pus1LJHw==
X-Gm-Gg: ATEYQzyhG67brZdCXwKaYEPScBEMbyI8pwdYvjAL9eOV9mQMI+5ToJjMhGcYj6vje7M
	lg2S2v70PtywSUpwnpgZCPqdUDG0bFvw/NIOFYh7sVhtQoYYQeuKdrYaqKAE4Y3yKiKi9ZWxbnq
	nZFI2sqFpz9bGl5ienxTWpH02mMA81F2Rk+MYe1KagOJbKP9uqSqMJlvdO5n0Piy7Ijw+7rSKdq
	VQG91pBA6FoSIHuFJLlqygyCOPzjYaPe/frnthEkunUCHSwXN5TgQryLV2frbCxVpmL/7L5rdZQ
	/miwAxxx/JxzHQQCSn2bDVhR75geAC5ihkRaHwM9H9kmWFNXAnvJH+T7jqzYJMgym51gjV1ChIb
	apfS7nBo49ZUDzGSiyiyVhdoRV8sGBWU827cdHyvCF6qwIj3QPoR+b7GXfQq+5psxB+7G8a4Oak
	95Ogb9vacoJT7FM/2FaVdMcw==
X-Received: by 2002:a05:622a:248f:b0:508:feeb:47e5 with SMTP id
 d75a77b69052e-508feeb4cf8mr20698681cf.7.1772838271828; Fri, 06 Mar 2026
 15:04:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304122910.1612435-1-sprasad@microsoft.com>
 <CANT5p=rk44fGgUL_Swp1pbVUeE80GJS4hxF00U0X4_xUbb-7hw@mail.gmail.com> <4rrxsl6mx3lbpt32l4ly6psg3ni5nsfzgfiufzt4xecsbjh22o@z272atyrzzvh>
In-Reply-To: <4rrxsl6mx3lbpt32l4ly6psg3ni5nsfzgfiufzt4xecsbjh22o@z272atyrzzvh>
From: Steve French <smfrench@gmail.com>
Date: Fri, 6 Mar 2026 17:04:20 -0600
X-Gm-Features: AaiRm51tkhJxpaoxZG8tObG_daJ08heq0mwdolQCzetaiL4HV0W0VAzSCl7hfaI
Message-ID: <CAH2r5mt4mDP+o4FWcJLhiXxcnjou7jxzPzUv1RqvmJxb=OSh6A@mail.gmail.com>
Subject: Re: [PATCH] cifs: implementation id context as negotiate context
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, linux-cifs@vger.kernel.org, pc@manguebit.com, 
	bharathsm@microsoft.com, dhowells@redhat.com, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 6, 2026 at 4:45=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> On Wed, Mar 04, 2026 at 06:04:05PM +0530, Shyam Prasad N wrote: > On Wed,=
 Mar 4, 2026 at 5:59=E2=80=AFPM <nspmangalore@gmail.com> wrote: From: Shyam=
 Prasad N <sprasad@microsoft.com>
> >
> > A proof-of-concept based on this draft from Bharath.
> > Looking for comments on how to improve.
>
> Looks good.
>
> Just one minor thing for now. To me the cifs.ko module version doesn't
> say much as it seems to be not reliable (apologies if I'm mistaken).

It does get incremented every 10 weeks.

> Also, the same version could have different implementations in different
> distributions. modinfo -F srcversion cifs is a better way to
> differentiate cifs versions but not to compare versions. So the solution
> is either remove this or bump it in every change using X.Y.Z.

We do bump the module version every kernel release, e.g. we are at
2.59 in Linux 7.0 (7.0-rc2)
Would bump it when someone does a 'full backport' of most cifs fixes
to an earlier kernel.

> Further, have you thought about how the client can use this in its favor
> other than diagnosing/debugging a faulty server?

I thought this was for the reverse - so the server support team can
get metrics on whether the client is an old client with known bugs

> I think we need to be clear on what is allowed here, to me it seems
> quirks, workarounds and perf tuning? Maybe this can be used to improve
> interaction between linux client and linux server?

presumably primarily for customer support to be able to recognise
known client problems on clients accessing a server


--=20
Thanks,

Steve
