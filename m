Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B5326AF5;
	Wed, 25 Sep 2024 13:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727272412; cv=none; b=PYPmoWVWbibtotuCGGrwxUxed08BA+eHFoHEHz2/Uc17TWtUtmHHxcPgQ9o/+uWeU7vUFF8k8VFEQ2yfd8vWeSq7KMQFB1s38cA//qk1WsLxo+tw/sNGCCxH6SwHfZDrrST/B/4AUcnWqv+Poz3yjjKnSHRWXGFrQ5AZr3n+A+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727272412; c=relaxed/simple;
	bh=iG2/lTAfEgLjAaRpv4EoM4L/DWaXGYqjJGv5aw2l9SI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mf5aGQ2uj5HiyDYBiHytnv9KVc4t0qZlKSI5VxjaZX73YUuzTQtoSMZ3of2PdKWPHLHPIWm3RNvA79a+HGmeexOrNZBYd6Chspj7t9ioVBDr8ls6tzQK8UdK9bbtcnw/pmaBogrUzG5TggzCAGS/NZj5nFJtynpFFpi5E7wU5tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pXD0LcCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pXD0LcCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E66CC4CEC7;
	Wed, 25 Sep 2024 13:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727272412;
	bh=iG2/lTAfEgLjAaRpv4EoM4L/DWaXGYqjJGv5aw2l9SI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pXD0LcCq772rNuTIJDDjOooo3H1qUN4uilnjWwub6U0A8jeKSseaQ9CcfgmmUcc1K
	 wP6EMiX8i1AX4Orj565pmn558DHjbzcggKad97k6UtIAUsFQtw6MkTXgeJ6WEHnU7I
	 eYsCKWaziqUZmv9O+KybuhfT3PzufyJYDdlSOeQLWvtGyf4XCqO8niDyKn+AhJHCcg
	 keDwN6qOwdM/Df3SSbNVLVtCMql7o5IHRRRHo8jaalc76oB6BbbwnJadBsUplnwC68
	 VxkSr0ACN0KfebDp7kPewgSN9VR8Uq+Ic0aBmaSU5U5MdXg3J9wwmE7ythhqwMO7jB
	 wGZKqpZXw6B6g==
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3e06853e579so3616417b6e.0;
        Wed, 25 Sep 2024 06:53:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVASpDXqAOvlbckvPa3WIoU0DDmhxXmsoD3LRfLWznno9CW85OcTvNs92zIwLrIqdbyKf1uL/fRcxtJ@vger.kernel.org, AJvYcCVZp1q65WbbytzG0QfjHtuHx1dIii78ZJlHcVt+0vFnus2Ue/tjdLyQAO/fFWTlZGCWaXZv9SCG6ujJIoGV@vger.kernel.org
X-Gm-Message-State: AOJu0YzgqYap94pybCoftf2/vg469XUgDzEEXVhE7Q+VZiLYGm0nrC64
	1ZGRRsdHc35VIirLRE5AQbL3fU8t2I4HAbI+Jcx6d/Sl6sY36DJiQy2U2Czna74aWp2RbyznJZ3
	BuweWueKGB1jV/rBuhLvwpraPE2Y=
X-Google-Smtp-Source: AGHT+IElzBEU3s+VBMa7k1g2Urn4DTRJjr0JWICjaq9tn8fBnjdxqevworOBb6UwozmZ8jWB2kDA2hGqzutJm+tOnRg=
X-Received: by 2002:a05:6871:1cd:b0:261:110b:84fd with SMTP id
 586e51a60fabf-286e13810eemr2152155fac.11.1727272411709; Wed, 25 Sep 2024
 06:53:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240925074323.9823-1-shenlichuan@vivo.com>
In-Reply-To: <20240925074323.9823-1-shenlichuan@vivo.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 25 Sep 2024 22:53:19 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-O3zANLJaQpaDc7VsUJTODRG5k08L+HG7sjLAwv7MpGg@mail.gmail.com>
Message-ID: <CAKYAXd-O3zANLJaQpaDc7VsUJTODRG5k08L+HG7sjLAwv7MpGg@mail.gmail.com>
Subject: Re: [PATCH v1] smb: Correct typos in multiple comments across various files
To: Shen Lichuan <shenlichuan@vivo.com>
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	pc@manguebit.com, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	bharathsm@microsoft.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	opensource.kernel@vivo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2024 at 4:43=E2=80=AFPM Shen Lichuan <shenlichuan@vivo.com>=
 wrote:
>
> Fixed some confusing typos that were currently identified witch codespell=
,
> the details are as follows:
>
> -in the code comments:
> fs/smb/common/smb2pdu.h:9: specfication =3D=3D> specification
> fs/smb/common/smb2pdu.h:494: usally =3D=3D> usually
> fs/smb/common/smb2pdu.h:1064: Attrubutes =3D=3D> Attributes
> fs/smb/server/connection.c:28: cleand =3D=3D> cleaned
> fs/smb/server/ksmbd_netlink.h:216: struture =3D=3D> structure
> fs/smb/server/oplock.c:799: conains =3D=3D> contains
> fs/smb/server/oplock.c:1487: containted =3D=3D> contained
> fs/smb/server/server.c:282: proccessing =3D=3D> processing
> fs/smb/server/smb_common.c:491: comforms =3D=3D> conforms
> fs/smb/server/xattr.h:102: ATTRIBUITE =3D=3D> ATTRIBUTE
>
> Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>
Applied it to #ksmbd-for-next-next.
Thanks!
