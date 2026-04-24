Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC74A36164B
	for <linux-cifs@vger.kernel.org>; Fri, 24 Apr 2026 13:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777036856; cv=pass; b=BoaPrYKBOU5XAgZI4NoNVUEdLBr1AWTnO5nLl/7gzwmIROb1GFtoMQESFJXeXW5y/3jFxcWtdEkmyQIM9Mot4MNKsrc5YB6GLgg9CzWEHqZOKuKEW7n7Ybv+j8GWQhp+67QTuCW0VFOgOejpUIov5bpBk3sYefTP8O88hl2oFvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777036856; c=relaxed/simple;
	bh=ASS3cGIUH/I1kiBf/Dy1WJ4mFG1Z1t92cIyj895Uf5Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FwnvsuHsGMM8L/dbyMwk4QFqAOiTBqM7N1VQ4wDbJ626gzW/LAUnVZADyLi7Y3nvGgGCUh/VD5v+tefdDdpO3VtXhSHvfuwhEIWn1kld207toLZNvE36uF6G2FDEUp5fxeVblsqBHfNXuTgDPrKCAtJx9ZX7kSde0nXtrDR/2YM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G3G0GFTL; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G3G0GFTL"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b9c01854477so286569566b.0
        for <linux-cifs@vger.kernel.org>; Fri, 24 Apr 2026 06:20:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777036853; cv=none;
        d=google.com; s=arc-20240605;
        b=Fe7UPqGimnIlNl3rVHosxs2VP4Zi9lsT/uD+zHcmVim4GBUU5uaHYclV4UTy95gvbx
         jakHfEpB1upJmjbT0020ovUVwerrstEgK6fWDMRFH5TRbHjAzbjh4xgCoLVV+YJHd0Rh
         YFiAS/FYv7eRJkR4nocKgHKdLu9xcYCFNQEGmxfskJdNf33mHoXJXu7syfitx9YLH09o
         I6UH8bTwL9x6EkMujrEHmdw7Ca+8OBS3xAaO8XmxSFrqJbpTWxJEmMUrYP0HCWPdKMog
         B4kyvgBhtnpa2Kxn637Z/V/MYNjtO+1xz0gPkjbl4DOTifRm0xNbbpnTV/ux8pEWI3qL
         votA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ASS3cGIUH/I1kiBf/Dy1WJ4mFG1Z1t92cIyj895Uf5Y=;
        fh=aukQmxF5n6BaSZqtxsT6mgkOwheMEaR/cjO+Su6Ahiw=;
        b=GDhHDYYiGs8p4FZ3Lw/i5H0nlo0soqqsVvVkshtDbb/nfJSqTlRe0jZQxhy37Ks0uT
         cWZukSrKDZJVr4ArDX4uFSn8ROv3vMu7Tie7Dlu80LKa2wElUhwe4RuG4+O3Qh8lqirI
         ZmK8Ot6atW+XCutHOwfM3XF6jRbRUf8Uvee24vZ1GiDQZWXnkAHw5eZICKx5/FW/RiYh
         PajBL7PHLQz/RwqbvT6mgtzNaJwzWkJssFNlUX2kwIg9Bhy9OaCM2bSKkleCm2timsKO
         Srj6M8rB+3+vSmSVI2pzovur1ozB6J/C5aVt6mZAaUWI2J/cuFlFUT56L6CKBJTCebW+
         ZWuw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777036853; x=1777641653; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ASS3cGIUH/I1kiBf/Dy1WJ4mFG1Z1t92cIyj895Uf5Y=;
        b=G3G0GFTL8u6BieWBwXnTVyAyWJiob4JW74lnONgl+e4w4W4lKn/RmQsIK+x/VI4jf6
         NflDdA9V7x2/E2VOhTJCyxMY2IlDLxXYpn5tWoNRP4mCQgmI76SyDsvGSy2aIe4oGum9
         CyvKTJ8cfXbhRVNWtmQYkBX8SCACLg1Q6FzvCAFmHimbNIJPGNmFExiWQRhmRelE9p/d
         zvMFrunzBsepClEnkPIlDR0+FrxO+PcLHFhiIpLaC4blZZErZmfQyFQy0K/Wk1Zop/87
         Bkj52UvHHwffn+oHTSkNfRracpkSIuzoS80cM+VHPK47b3nW7MCCHWIJacyaVmgo3u9f
         6qCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777036853; x=1777641653;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ASS3cGIUH/I1kiBf/Dy1WJ4mFG1Z1t92cIyj895Uf5Y=;
        b=q7OvUHaXaQf7I7APEn6gEzeBK4oqkWHr1HKGOs+VI9KzqUmVjPH2PgvpYtuLucGzMg
         aH95HjzzHkQC5fk2eUp4082VhbnGe9A3vGnjgxywk+/lGhlMEvr2I/zDLsmwlNs8xHGg
         B5SExpMRye0sl/kLjEBC13QhT6wooWOMZRTzuuvzcb9N9uBlStamH3g7V43GKKQdbeDq
         u1KvGTa4GaFb9uJu8lCsq/VeaJAhpGhj44WXhxVi0jyRde7GxzlK4LIghxqWaV6APjIx
         gJx87k33wpTPxpvNrg73FMiY1JhxWAC2vkXdCALqbNXUe4CVL2IMgT3Zupq5cFN/t9e4
         mcvQ==
X-Forwarded-Encrypted: i=1; AFNElJ9zKJ+EcTPgM9MlQdoNtvy83x/8wmxYmOK4xeQAPl1Dtrm321O5zYkqtbloRiEHGUzWF6WtSyYNvfgp@vger.kernel.org
X-Gm-Message-State: AOJu0YywQKCZ3sUHHabq37Kuz1jV5PFJpeSEcDa4YDAXExvBjmrx3tPh
	Q/3G2jjjXxz30wSqZjRXxLvmoJt55s2HQWBOFD5S5iDtKFta6RGFGUpyK1d+/DkAtZxxIIPQX1U
	wsz2+qOtQe8R5EYnchhizpJ30iTVQe6A=
X-Gm-Gg: AeBDietOBpC3PqR+vh412nQIDw7fWZXuwaFaWXPb+soGyzCW3jj8X2w/kkt1klvcYL6
	XXiY2u9C7V0ssMY9Fa3cPQgwOERkXsqmI9mGzNrJUTd35QGxZ+wprtk6mgece2qjHubRLoTA5u0
	8kfC9oCzWXLg88E/UBgFj+/ajyDigqTmW6c6AbakSTZdmQ+qNWZDcodP743Mizi6J414as3Lr5I
	ukqOyziayscMdtMe7OuVvd35KJSnNK1x5OcBMQcdklsvzj1D85S/ZcoKQPbOKZCLpFB9tFgFU2N
	NsY2nUlxRdcnDQUh
X-Received: by 2002:a17:907:c1e:b0:bad:d21f:904d with SMTP id
 a640c23a62f3a-badd21f9640mr134660466b.31.1777036851676; Fri, 24 Apr 2026
 06:20:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANT5p=oV8kcE6hXPoUVQAYGaiz+2OERoSRLAS6X+q9KJ_8w8YQ@mail.gmail.com>
 <438478a7-c965-4a2a-9c4a-84b5f77d6dbe@samba.org>
In-Reply-To: <438478a7-c965-4a2a-9c4a-84b5f77d6dbe@samba.org>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 24 Apr 2026 18:50:40 +0530
X-Gm-Features: AQROBzAWgiHMPutXPKosmS70CLbZfFyKsRjxdv-KyVf-hd6DFXM_DKprRPT5BlM
Message-ID: <CANT5p=ortwT7ensa+kKoCa=wMnGETpqaQuBnhDWMSNu82KsqFg@mail.gmail.com>
Subject: Re: "Intent" of VFS lookups
To: Ralph Boehme <slow@samba.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 23, 2026 at 11:13=E2=80=AFPM Ralph Boehme <slow@samba.org> wrot=
e:
>
> On 4/23/26 7:01 PM, Shyam Prasad N wrote:
> > Wanted to understand if this is a problem for other filesystems or if
> > it is specific to SMB protocol?
> > SMB2+ protocol mandate that open call specifies if the file being
> > opened is a directory or not (regular file).
> sure? From memory (though the logic has always kind of escaped me) if
> you neither specify FILE_DIRECTORY_FILE nor FILE_NON_DIRECTORY_FILE the
> server is supposed to open the object regardless of the type.

Hi Ralph,

That's interesting. The spec does not seem to define this. Perhaps purposel=
y?
Will try and prototype a change to verify.

--=20
Regards,
Shyam
