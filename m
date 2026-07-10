Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BF78F49
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 00:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783642979; cv=none; b=Cw4q9JE+jrvTT7J1i1Ny7yid1ryGzSfMb5UYWeeC0qH5gJTOzINypo/ZQstIEAnI5MS65R1/ySQXCOBEKAg8XDfutoz1DozjljcI2eHabbSee3Z1x74vkkVOuhTgFvkVJfxYtj7ByHZuPPKc/dH3N7R4tQtOsgJ/LcLEJju8olE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783642979; c=relaxed/simple;
	bh=ywO+gV1iKOb1iARVqvG+3nzbClS+2bB4TTLQHNKQJH4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cwfhrh7hlc2R6gG6SZgczfJz8ICTmOlTa/7MqEovGQ7zNQuxKygGm00LzsAP5uobaq5xhxYolb3tCGL5O9yv+iDRrzkruUTAzDP+Bj8qm+fh9QeJgxKf71PLMwlXx+NXKpHgm0eQGZRX+jrDT719aiT2W8HckuAif3qPZwagQro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OhmPmqPx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OhmPmqPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7281F000E9
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 00:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783642978;
	bh=ywO+gV1iKOb1iARVqvG+3nzbClS+2bB4TTLQHNKQJH4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OhmPmqPxokcfWIxW+N6fcQOrkhAygW0GQXOvsUCbNRFwYkoIhaI5EWygKphR7/7KK
	 ZgsaVSouEhqSmvpkU1xoWYtGzXP+RhHoF+hmuzWc2PwrG11kj6+gFcLcTLaGH757M1
	 dTrppSuBxtLfcjF/vXSULT7i42MdlnE98zT1LnOLW+rDMV1olgX1aPR14hgPbYxY0F
	 Z9BaDOBRHNRBCP2wlmaPvwFURliJ1IMlgEc2Hp/Hs7N9WB0qApdEPARdVHvKO2ZyLF
	 uNLw1F30gA0e1MTBMDbIt1i7cdmIi/ZuiWgmfY9BMk3dmiz7cu1YeXEhvmkrvUHlCw
	 FCySrM/Oto5ng==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c15ca7a7ca9so42038566b.0
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 17:22:58 -0700 (PDT)
X-Gm-Message-State: AOJu0YwyJhMJOfdVGl9rUJIKKyq7Qp2y/aUOWKoErP95Ez9Ekk0nY4G4
	FbL0wlz3rT/zA+mn3ovLOuapu5/AQpklddYOHva6LpjYSQ4UzTUFXvXs2Znw1pcMXrQucRDTw/D
	ikBwiYtRM+yGFeKOMxz9qA+cYmDpedHg=
X-Received: by 2002:a17:906:a955:b0:bed:6e53:bb1a with SMTP id
 a640c23a62f3a-c15ce10900bmr295749866b.48.1783642976941; Thu, 09 Jul 2026
 17:22:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709165141.2111-1-g.blivet@me.com> <20260709165141.2111-3-g.blivet@me.com>
In-Reply-To: <20260709165141.2111-3-g.blivet@me.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 10 Jul 2026 09:22:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_eHRx8nm3V=qcp2yE24JBQa1+OHOtEkxHfH5-Cy6X40Q@mail.gmail.com>
X-Gm-Features: AUfX_mzlevTLFdMQ9zwJO4xQbYZexLTGIb1_9uaWTs1sxi8PDOH1JXjMkhDguDw
Message-ID: <CAKYAXd_eHRx8nm3V=qcp2yE24JBQa1+OHOtEkxHfH5-Cy6X40Q@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: report actual xattr value length in stream enumeration
To: =?UTF-8?Q?Ga=C3=ABl_Blivet=2DBailly?= <gael.blivet@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 10, 2026 at 1:51=E2=80=AFAM Ga=C3=ABl Blivet-Bailly
<gael.blivet@gmail.com> wrote:
>
> From: Gael Blivet <gael.blivet@gmail.com>
>
> get_file_stream_info() (FileStreamInformation QUERY_INFO) reported
> each enumerated stream's StreamSize/StreamAllocationSize as
> stream_name_len -- the byte length of the stream's *name*, not its
> data. This is the same bug class already fixed for EndOfFile/
> AllocationSize on an open stream handle (ksmbd_stream_eof()), just
> missed at this second site: a client enumerating streams sees a size
> derived from the name string length instead of the stream's actual
> content length, inconsistent with what querying the same stream by
> handle reports.
>
> Compute the real value length the same way ksmbd_stream_eof() does,
> via ksmbd_vfs_casexattr_len() on the already-known xattr key.
>
> Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!
