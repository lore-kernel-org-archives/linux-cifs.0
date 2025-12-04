Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6113093D2
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 06:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764828914; cv=none; b=XBlbB9Mfjs9X9yB9I06ocl+njK5jMBuK5c1F5adEpD+rOOIyrMmoZq3Fp7WZH9UkA7D60iggQWc9/e8VhBWsyO289Baz8ziEaRrXGsMy6vVonMNtPWnSbWJyVDCGp10Z3igL4rIOD+uQD03gv5wWjbjMD1si4zhbudzElXda6Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764828914; c=relaxed/simple;
	bh=2iJ9aAEUqPfyb9xNgOSo2GwKBxBeJAG7JTACF98eF0w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ASshwi0b368iVeD3mjkhKhgwiZr+5B78awA1zSLRthBne8GpO2jlC0UnzMLWo9yD5h9XU4jUY7CXcVac1qFVhWXS2SluuEkhmqBTOGOUHMdQIcAij6uOSyBliovNIncjI81r6dhyB5oB+jU65mhrELx9wbGWyMeYtzDnvAschgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fL04aeQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fL04aeQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA97C16AAE
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 06:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764828914;
	bh=2iJ9aAEUqPfyb9xNgOSo2GwKBxBeJAG7JTACF98eF0w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fL04aeQT9WGOHnljjdn0PEeeH6msSeG80wKJdWRXR1UE4EaJJWxebqTa356+w5mRt
	 1jYID9ITGxcCuh/OEuCQ3Uc50GSYhRBUjn+P4tborgxI0+vGB51PlJcwfhSgyF6s50
	 wd1omWjtUk9rwGw7FjqWRSO/hFLSUTf9YNZe36mE9LYrITsDTVzvuNi/4GwDrqJ90g
	 83j+pqG3tXuvHoSFsX4UOPVWc5esenB5XgY8RNrr4l6wADpECXHu4PJZNSWfWiJrws
	 CY3n7k1FHAuUCr512zA+WVqER8xJK8ktkmsJtg8yirCgqFQdbhwKfsaDBSpu2HylK0
	 wf1EfMHavmJ/A==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-640aa1445c3so739972a12.1
        for <linux-cifs@vger.kernel.org>; Wed, 03 Dec 2025 22:15:13 -0800 (PST)
X-Gm-Message-State: AOJu0YwKM7RqYPGR4al9kcNverSPsuGyKDbVI6eZTYn1D1hHV/J4R7q2
	vocBXHP+etZQyLWV5kYZ8gpmlNPizmH/1BbyJhEruKMJWTsmSjce/+lQwfiinaZP/9DErZvBZfF
	gZbsTgfX1rW1DAPCmTFt9Y0sdI/RTRLQ=
X-Google-Smtp-Source: AGHT+IFxtDGpV6cSoBjid7NXl2nNNlvUO22CPgShgaWv2gAPA+BSMjTzEAceAhHyjGEcY2KykD0gNZz0BELIzyBWCSE=
X-Received: by 2002:a05:6402:51c8:b0:640:b06f:87c5 with SMTP id
 4fb4d7f45d1cf-6479c3ed957mr4197603a12.1.1764828912627; Wed, 03 Dec 2025
 22:15:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1764709225.git.metze@samba.org>
In-Reply-To: <cover.1764709225.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 4 Dec 2025 15:15:00 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8Bj0u+eSXBi1Y1GDZyXC_umupM7BK_i++61YtoGtkuAA@mail.gmail.com>
X-Gm-Features: AWmQ_bm0HucYiko1C4C4j8Wn5MpQTju3luFj6zaAqhwTiWK2Ni49drh40mPUyYs
Message-ID: <CAKYAXd8Bj0u+eSXBi1Y1GDZyXC_umupM7BK_i++61YtoGtkuAA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] smb:smbdirect/server: introduce smb_direct_negotiate_recv_work
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 3, 2025 at 6:15=E2=80=AFAM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> Hi,
>
> here's a patchset that implements a better solution
> to the problem that the initial recv completion might
> arrive before the RDMA_CM_EVENT_ESTABLISHED event.
>
> The last patch is not intended to be applied, but
> it helps to see the event flow it generated,
> see the commit message.
>
> This is based on the 4 smbirect patches within
> v6.19-rc-smb-fixes:
>
> dc10cf1368af8cb816dcaa2502ba7d44fff20612
> smb: client: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in recv_done()=
 and smbd_conn_upcall()
> 425c32750b48956a6e156b6a4609d281ee471359
> smb: server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in recv_done()=
 and smb_direct_cm_handler()
> 1adb2dab9727c5beaaf253f67bf4fc2c54ae70e7
> smb: smbdirect: introduce SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
> 1f3fd108c5c5a9885c6c276a2489c49b60a6b90d
> smb: smbdirect: introduce SMBDIRECT_DEBUG_ERR_PTR() helper
>
> I've tested them on top of v6.18 (without the other patches
> in v6.19-rc-smb-fixes).
>
> Sadly there are still problems with Mellanox setups
> as well as irdma (in iwarp mode). I'm trying to
> prepare patches to debug this next.
I have tested with Mellanox NICs.
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
