Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF1337703C
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 23:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773273059; cv=pass; b=X+miAXgK7Z2gTSzL0tg0SYd5MyuWbGuaO9If4lS92cH+xLZ/RjOhN1/gNRi957R0kyoESSLNU1rBvTaU7QXLoFu6z2FzBL658oGkJUHN3k9NqjZzgSfBD6xzRb30Pohl7Jzh2gfJU50SLieF8DPZJujzJYLs+2Zw9zVi8QJBLew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773273059; c=relaxed/simple;
	bh=gWawahk801ps2C/kREBDW+eT0ObrlHIPwJU+/Hx5CEw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lYZrwCI3QUE7326nTbpgAw7mVOUetsbFHO04HmSUKY7Ly8Cdvv3VZ97N01Y12vwW6QviXDVrRSu85uLtc7OqwTEEEC/6eM7klBriDm9IdNgb2vR2K9DZJ0Dkn3XKWi8ef9H85iJgq7sogtcoagE2N9CIgbfI9U3VNgir24Vjhr8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KI/RBs2r; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KI/RBs2r"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-661d929219bso419938a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 16:50:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773273057; cv=none;
        d=google.com; s=arc-20240605;
        b=O19QEuSMW7MDfjdYf4DCD5UbZxovtAajuf4TtCJZBwib8ezC7CjdkKiSjAEbASaxL3
         oPRbXp1ll8fFW9jYyuy2sV0oR6TAy9iL2jyg3yUJEiD17eAzl/pGEFAKKE5ULbQNtufL
         VSqSD1lCT2HrqoqoGJOmPmJ8JAWy/41Tuq9BDwrMetXVuqTg31fVwPRAFYDjEePXI5+D
         gyNZ0ImPrZYwERXcoCjUJSEoLI+kxK0ZRNb/hJfVZSXzlrd4G+4QCJfp1+hoiX4GH4NF
         UrR5DiWNNnK/wwc/ziappIHbb2tTGXpeGraKVrfEeZV5inClRua4TxO7mdzSu6XI/5Yo
         4NOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gWawahk801ps2C/kREBDW+eT0ObrlHIPwJU+/Hx5CEw=;
        fh=iIHYYH5wBLswoSxYyVuj+EnCIDMzX8XRiOQ+TJRNO8M=;
        b=beGPntskpQIqkT/F6kYT4rhnqNAXAk1At5zUQ1qjM521ioi2T5m1zi3vtmG/yWq7Gb
         uMfL4SCUUl81MUE2bMKugPH8LfmhDID2e/OdOGIVppEl8V2FIBT1+OsnlMHKM7EnURbu
         hwFoQOKOg1MXiTn99W4QWZ06Hx3LOkLXRb5W/EaqhVJ69Q68s/R27DdYUTG6A0S62nQp
         hr3MeypqqxOxD39TWwZ2V25z6EoMnsR2HhQjUnQ4KxIOxS+4UAzBr3tyFzVngj9w6vjZ
         vWUjr0IrOwKadujcNi0FB9dZ5RfSQCqyBF0PWGEOLtMGxtJ28YO2/XHPaETNLWEC3z/G
         NyJg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773273057; x=1773877857; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gWawahk801ps2C/kREBDW+eT0ObrlHIPwJU+/Hx5CEw=;
        b=KI/RBs2rCosf/xJSKO6lcocFKB9DmR//SuwB/Nn+Ukgl2632mV4kHsMuJ46wjpapgX
         haQc3nusa/hZiS2/LnFs+HFLP4tnEU9hdgplRlYg3I3feBPAINejTWYEZ9YLxUGPIgSa
         8vLXjEVJGBPFMRn2/RAJ1epfW1G/6IVpNBaIGmVLLJPLpW84A+lFlPeO1vPppl5tgLum
         cHQuqSq3/nCurDLEteGneeXVAPnSdlOvPe7L2/1LzCtRBqSWRx3zRQiPkbUowEmEstkA
         wFSr6awvgnkFUSKWoNpWCm0/M1pJNQbXuZRZoIbxSZZEq9ih/Vepdc97tSc9UxQe37N9
         mNVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773273057; x=1773877857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gWawahk801ps2C/kREBDW+eT0ObrlHIPwJU+/Hx5CEw=;
        b=pTGUTSxnZ0tsKm3GhVeHubbRoNEXWmVctxduQ2QXq7Rz17h6yLIKcXfkG3DW38uo3N
         xiMUcu0CBx+I+r+29mfh0ARKvyzXwsKVYmzh1pG2y8jHpZySTDkrA5GcDf3u3iyhS7gP
         J8sAMLZXQbT+/tMOw44qPmHmFLW12OiHUKBHafP5K/Rcxy76RFBDt5Fq5Omuey7ss0kA
         KOL2z0sduLZ+kgNqbac+pL8JWoLfR8b33jjqXVFVMG5TY4n9lHKng32AKwaoKyykWfvp
         Kb9TV7rXwMGvb//t9TM7lGeFzRfjaRGiMGv8qiJI/leQwubZ2Ft/y0gCT4ewzSsOM3Gx
         x+wg==
X-Gm-Message-State: AOJu0Yz6+yY4LHRqXy11VGLmwppU9VuYpXGcmaHSkAUrG2b7oIGruX3M
	7Q6EgMGZZqAHmWRfxzQqUCEPdZm4RDduhuxQ2PjpInzErQDVyZj7T/gAEoQkNPggW+9yLS7b3j3
	9y9tLY57WN3j6MqRN1SMQ5JNLn39MbxNW+C2e
X-Gm-Gg: ATEYQzxnYMC4mC73lk/hfzOPnUXA2XEfR/NSGUmFMUfT7eduJnhJlezyi2Z+GWM9Gtj
	vaCEQYgCYTEhjmWoznScrq0IrKBlbAP0euE826jWusFTZiLSqQNGBxmnwv00cJqSV4KllG6bIvN
	4sX+6I07ur/0lltaC0JsOyGrRyjwn5OU4VukAHhPypy/l29IPua0VybJRKGzNp4NQplxIh+b28R
	hD8A5dPoWWg4TEkvJEN9l9kQ0tS6QAmclJmXE8m6fPMs4hYWcOB+xoNvyVZECqaq/He8SC3WFYT
	qwUmDQ==
X-Received: by 2002:a05:6402:1d48:b0:661:8bc1:2735 with SMTP id
 4fb4d7f45d1cf-663197cdfacmr2351387a12.13.1773273056741; Wed, 11 Mar 2026
 16:50:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304122910.1612435-1-sprasad@microsoft.com>
 <aea738fc-e422-4671-9e0a-429988fe026a@samba.org> <CANT5p=p3V0Ap3EmZuh1ZYvg+-SgjyH-ZMmsakCdbzMMSL3KwJw@mail.gmail.com>
 <031b8f1e-bd28-42e3-bcde-9bf73fe59b63@samba.org>
In-Reply-To: <031b8f1e-bd28-42e3-bcde-9bf73fe59b63@samba.org>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 12 Mar 2026 05:20:45 +0530
X-Gm-Features: AaiRm51PrLDI5LdxuqIv9bPQuriNVj5C4ERtjJa4yLw8SfvPrtvzXsPSYf1ZCy0
Message-ID: <CANT5p=q4YSD4jqvw0Ckx1dbvceMz405sh7L6mTZpkFBuNpPDRg@mail.gmail.com>
Subject: Re: [PATCH] cifs: implementation id context as negotiate context
To: Ralph Boehme <slow@samba.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	bharathsm@microsoft.com, dhowells@redhat.com, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 9, 2026 at 11:05=E2=80=AFPM Ralph Boehme <slow@samba.org> wrote=
:
>
> Hi Shyam,
>
> On 3/9/26 5:37 PM, Shyam Prasad N wrote:
> > This can be useful for servers like Azure SMB servers, where it is not
> > easy to explain client side behaviour without knowing what exact
> > version of the code is running on the client.
> so it is planned that MS is going to implement this in their servers?
>
> I was kind of assuming this which made me wonder why is this made an
> community extension instead of a protocol feature will full MS backing
> including inclusion in MS-SMB2.
>
> Thanks!
> -slow
>

Hi Ralph,

We are working with the responsible team to get it into MS-SMB2.
However, we also wanted to get an early POC and review comments on the
proposed draft and the client changes.

--=20
Regards,
Shyam
