Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C303A9D94
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 06:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786948981; cv=none; b=qXoRJZLkEBIAkzfTcx3Hj0b+xqp45mwK3G3mh1xaWBzF0AFsFdOIYjff3VcmYklbeaF8Hx88fnw8Qp/pPet9/awo91p/nLqoIlc93whRdS0fM4zpCL2AVo5cQ2UKorUOgUG+/C33TabeEb+g+LZ2L5ZV6yVBZuR8GIM8ftnhz8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786948981; c=relaxed/simple;
	bh=04KUtheaITtZB5B1rvqdSxlpnkvidWhWVfGQjQ2+CM4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D1s0QGl+Ao2qaH5lHTXzp5NtvAhYviwfT3FXeTgPo5XY7g19B5D6FXTObNQQg+dq1tUHwRKaj1TUQIQFhk0Kyt4FCUvuU4RsMYWh2bP3koD6HfbJq3VGS1B6q/cN3bV6+lbLieoSC7e2AzZ+RDxMJH+Q2++XLPvEYL9+7QzKYlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lUDzIDhi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lUDzIDhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEFD1F00A3D
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 06:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786948979;
	bh=04KUtheaITtZB5B1rvqdSxlpnkvidWhWVfGQjQ2+CM4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lUDzIDhin9qc18g73L410/dNF4kklGbDFbzjLXHYMn+g/nQB4ZurSiRQ3rTP2eHL7
	 aGPNZkzdyO1RyfWuj3vgX5bQVBicpgoOUZmwbWB+LqNbmcGD5vrbAZ+FIFIgvJFZ29
	 JdwIQtr5AlzbmhLrsBtgLfhJ9Kfgiri7yEfWJGrHaVSPkqYo4Db2eM7Qf0eo++FDEB
	 i82nYm1ZxVFb7BIj/6LBwOqfOk3B2PVRiPEwboFzmvFhg/4OzpuPM3NR56ovv7cQ4e
	 0LJMHTxpbNAvEDrNARP++yvdqEPYCvbwv79PC1S7U1e0hIs0IbRhMQD0kjFyOt2tmU
	 I2PxNKnR24oGA==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c15d47266baso340568666b.3
        for <linux-cifs@vger.kernel.org>; Sun, 16 Aug 2026 23:42:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoAt41IXWnyfj8vARxVRMFBpLafYT16FbK0vmR1cb6jIehcXxIu5YvpEvu909HxkS1jxZaqObSIB/kz@vger.kernel.org
X-Gm-Message-State: AOJu0YydHLRwqrzU+q1rYKgQl0S9rTmYTE38/qSkC6RUzKFGBsMoZMkt
	w7wXN2HBd4TmNrUuV2LeBtL4L5bFKmmuGPAC4cb63ZuFAeqf5Npvq5L9dEofcFqfc6k57j409Gi
	ZJFOkfYMPaYlV2Lq+Xl3rCKF4pLd38aE=
X-Received: by 2002:a17:907:e98c:b0:c19:6d4a:425b with SMTP id
 a640c23a62f3a-c212a1d6840mr1036731066b.18.1786948978145; Sun, 16 Aug 2026
 23:42:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260816153922.484091-1-huiwen.he@linux.dev>
In-Reply-To: <20260816153922.484091-1-huiwen.he@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 17 Aug 2026 15:42:46 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_N3i0jvBn0Nw3-K+U1yS528-ynh0PVETrGuLDnGsZV_g@mail.gmail.com>
X-Gm-Features: AcwNN1WXjODM5fj1OYFfZfqJ2GDub9IxSZzSPOcEk_Q_FeHTxmU8pQ6HoBzpXKE
Message-ID: <CAKYAXd_N3i0jvBn0Nw3-K+U1yS528-ynh0PVETrGuLDnGsZV_g@mail.gmail.com>
Subject: Re: [PATCH] smb/client: remove redundant NULL check before kfree()
To: Huiwen He <huiwen.he@linux.dev>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, chenxiaosong@kylinos.cn, 
	linux-cifs@vger.kernel.org, lkp@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 17, 2026 at 12:40=E2=80=AFAM Huiwen He <huiwen.he@linux.dev> wr=
ote:
>
> From: Huiwen He <hehuiwen@kylinos.cn>
>
> kfree() accepts NULL pointers, so checking tmp_cfile before freeing it
> is unnecessary and triggers a Coccinelle warning.
>
> Remove the redundant check. This does not change runtime behavior.
>
> Fixes: 5693347de107 ("smb/client: use writable handle for FS_IOC_SETFLAGS=
 compression")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202608160402.0ffQDoCg-lkp@i=
ntel.com/
> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Applied it to #for-next.
Thanks!
