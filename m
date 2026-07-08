Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB71A3B52EE
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 05:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783488038; cv=none; b=pF5t0WZS/26Cj1TV971fe71kYnYgogjm1di8vL877XzdvT7yl/BOyBkMrZDuLln50DgjQ0aV+xEgvAaIEX/19WRuVLrgYKDo6VY2EVgWBVQfF+nBYADLbHRK4m4NTSZtlTWBXtUp09gczdsCzjYt+jNgFQ3v6UVXB/VPKUNrQNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783488038; c=relaxed/simple;
	bh=vZqBlK7fABsrleVh6wtUi8Dh8pzgRroAbrfAHXyxiWE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s5Hoz7BNpbQjtAJJr4gJCkIC0+MdQoOLUEyHYOCzpnc6rCU0RVqyAPR1wb5CAfCdJ8md4a+FU3/6mNB5q7ZGtZTqKDHzspotC+tC35DtOjCy1D3pcZQN1pVZiYG36DbroEAiF/AFL8+Ksy/n0plfhfbu+j0qy9Fva34lSgkEEOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mFiQJ+Ol; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mFiQJ+Ol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F0B1F00A3A
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 05:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783488037;
	bh=Kq8r3VYESMW3CbIY+k7nlsJQCg7502+BEAhTxvTE9S0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mFiQJ+OlZhc1LM6a3mxnFrblLKqo0ysjfetQplyTrAyxqcKswJEj+iRkGIP+L8XJ8
	 DATWkZWIMHq7ucyMlGcTsMeCeOavJB0HNJzpkbO1YieFKlOx9BH3kk9n11Zy1xycR1
	 eEDIm8BQPsctR2PznV5f2UeGawJVWJLXJKmw8mXgrJ8iAdjMUkLdTuTmGVOfqxFIxT
	 PIeZ68YZCpKVRoC/BVxs20Pb65qpCV5GElMcuRgf5zYYmXIcmmpFY6ZDE4b+Yu9ANl
	 jqDFHBKzPmvVWXtdVKFKzNQvqqbw0BbBd0u8ftiG0OcviyGAhp0F4ERgwH7pyzCpUR
	 AxEFP+MgIq5ow==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c12a1a3cdb9so23322066b.0
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 22:20:37 -0700 (PDT)
X-Gm-Message-State: AOJu0YyV8DsQhgtpe/W+S1viSFhDR6Zol7SwmbQzgOmV9ll/TnoWzDTH
	TuydYbw9X/LsUGGGjVLj+UBsoW8v7GdajOTjaEiPAHQSUmmfaNWl/bm28IUW5rts+09mNM7vPIj
	G5wD2x6NeUqL4kyPo9XpRfWTg2b9HDwg=
X-Received: by 2002:a17:907:3ea7:b0:c12:5bf7:4ac2 with SMTP id
 a640c23a62f3a-c15cde8c696mr46717366b.8.1783488035728; Tue, 07 Jul 2026
 22:20:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707100129.47563-1-g.blivet@me.com> <20260707100129.47563-5-g.blivet@me.com>
In-Reply-To: <20260707100129.47563-5-g.blivet@me.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 8 Jul 2026 14:20:23 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9R7mwnB4uL-E7DbGNdKRqwpGay3ZMzbJ1cOaF3TJY1KA@mail.gmail.com>
X-Gm-Features: AVVi8CfTesRQT2LcnazCCz_aoRiZ-Sh3r1AGQgaYBwgGYRheBbFI0BUpqUzwTLs
Message-ID: <CAKYAXd9R7mwnB4uL-E7DbGNdKRqwpGay3ZMzbJ1cOaF3TJY1KA@mail.gmail.com>
Subject: Re: [PATCH 4/5] ksmbd: defer CHANGE_NOTIFY completion instead of STATUS_NOT_IMPLEMENTED
To: =?UTF-8?Q?Ga=C3=ABl_Blivet=2DBailly?= <gael.blivet@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> +       /*
> +        * Transfer ownership of the async id to in_work; it stays reserved
> +        * until in_work is freed after the deferred response is sent on
> +        * close, so it can't be reused for an unrelated async response.
> +        */
> +       in_work->async_id = work->async_id;
> +       work->async_id = 0;
> +       release_async_work(work);
I have one concern about the CHANGE_NOTIFY async lifecycle and CANCEL handling.
The notify request is registered as async and then released
immediately. After that, the deferred response is kept only on the fp
pending list.
However, SMB2 CANCEL lookup walks only conn async_requests. Because of
this, a client-issued SMB2 CANCEL cannot find and cancel the deferred
CHANGE_NOTIFY anymore. The request remains pending until file close...

> +
> +       spin_lock(&fp->f_lock);
> +       list_add_tail(&in_work->notify_entry, &fp->notify_pendings);
> +       spin_unlock(&fp->f_lock);
> +
> +       ksmbd_fd_put(work, fp);
> +       work->send_no_response = 1;
> +       return 0;
>  }
