Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B371CF7CF;
	Wed, 30 Oct 2024 05:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730266604; cv=none; b=FcZIF7JkFRNLGL3uj3MBQdc6KkXMeQmkGmXgyIowZ3/Uv3xnNI10r6Ir6xr2zjSNaLsbi0I69921QHbdnw6CAdDuLWQ66SQgJa0IOHveJ+qXOYByCauc6Y8aX/uDeEL8eAad63PC8Ic3gjypK2FzGjr/JO7FqAe2Y+NSkRwNZs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730266604; c=relaxed/simple;
	bh=KeESUc5K0y6lVscZ7yRQDwbqZ25f4QAcmJfnW/JLiYw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z191IfnUg6hKt5h00HV2LbChhFndrTOHyxrimmOmMjfAd+U1KX7DfPPyWkXCpxv6E779ekbEG/u1n2W0+Q6UeY9jQ/cPZuhcupFZlPGZNYLqlPWTZvAMC/X5gq87oru7hYWOEo4jPAXJpjmoZTSapuzg0vvC9tGidWIutOUIFrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G6r6ZAax; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G6r6ZAax"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-6e38ebcc0abso73834907b3.2;
        Tue, 29 Oct 2024 22:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730266601; x=1730871401; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KeESUc5K0y6lVscZ7yRQDwbqZ25f4QAcmJfnW/JLiYw=;
        b=G6r6ZAaxKJU/PaX37imaRdQWX/Ldv+Iwmoyr9Ly3GpnO8qS1mycEpUmHaMw01nXxRm
         gMFTvioU0JQkNyoR0fpmuntPh9TTXsfXKVtD3qTQ3RTyUjf6TcQTIqSZvqrtM8eq5E48
         BJTs3b5NhiHkcW5EzCiHy9eGnmcx14IPXMKlpwRw6r5KDz8ALTZZkyVmof4ko4eIRudh
         WKIo2KkaRlCCxRRU8WykGaI7Hvp7Q8KLpSFJa0/dEX/Q3PcpdXJ+8FE70ZD1N/ru5rvL
         5OccT7rv64tWYuZ7W9OqUSl5S1MtHg3bbLi5zMkB4InmfQ8V4WXl4Jc9bkBbMnayIjCR
         7gpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730266601; x=1730871401;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KeESUc5K0y6lVscZ7yRQDwbqZ25f4QAcmJfnW/JLiYw=;
        b=k7WJrNUjweFgtHVsOULYE7y+5OSEPTzS9SnwvyR5TScUUmSgfoPP5Avd2tj8KjXeK3
         Mb4MHZy3ng2RdjHZvS7buiRVby9Nw8T2lAlp7XjnOu7HhyByC/du/k5QkNhQyBCvcghL
         /w2ZiUl5PEHvod/o4cUChwP1+yt4xIyaI53X0k/qRp8HNOeBJGQboJO7vdYUf4FJQ+Yf
         5C77T+hEJKJs1dCSyqkgZL3liAesvTl1BqDK6acV8yof3Sbg47WhcW4387oW9c2Np4xT
         ovGnVcSsCsk56KDb+IMGAkNUSuaABTVk9K8qBNP4q7XQoz2KngIS6PS9FctIPIHWOmbI
         NlMw==
X-Forwarded-Encrypted: i=1; AJvYcCVdfZD3LU8GpejHjiq2xRBRWr1d8FT51eD3TeCK8vHJ0KJiLazl6SalgNZ1ghq3wMKqgKyRaopSxqka0tAn@vger.kernel.org, AJvYcCXB6UVuo660P2FYkOstBLBkTD3YiHyld/UA2c056S98CDxd2jRlCYuQsCVgi/u6UAINembrRES6IR6b@vger.kernel.org
X-Gm-Message-State: AOJu0YybKeDXL91Wbe/Lcb/Qzoj3cGf1RiwVMMiucp+vCx8r0iy8EY3Z
	/NvOAAu2uP0+VIBFF7pbf5Dy/Mj9yku6CWAa3CODnul3iWc/QuL7thlZOrFaqXc1e5i1tOmvH9g
	2ylknLH3Ldz2W6Nfh1p6c5JylaW+P6w==
X-Google-Smtp-Source: AGHT+IEC1vApiz0SeWbm0I8kDNI3alH1leHE5c61sHrb8sBNGAjf7q3LhzxWWsPcy6W4djptJm1sZ0P1WEy6hmanZVk=
X-Received: by 2002:a05:690c:10c:b0:6e7:de90:315f with SMTP id
 00721157ae682-6e9d8aa57d6mr115380287b3.28.1730266601457; Tue, 29 Oct 2024
 22:36:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241005154817.20676-1-pali@kernel.org> <20241028104229.29736-1-pali@kernel.org>
In-Reply-To: <20241028104229.29736-1-pali@kernel.org>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Wed, 30 Oct 2024 11:06:30 +0530
Message-ID: <CAGypqWxRv+3q3gXqGtKH+5rb+pPwNrCz-933xOk29eku38qosg@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: Change translation of STATUS_DELETE_PENDING to -EBUSY
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 28, 2024 at 4:12=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> STATUS_DELETE_PENDING error is returned when trying to open a file which =
is
> in delete pending state. Linux SMB client currently translates this error
> to -ENOENT. So Linux application trying to open a file which still exists
> will receive -ENOENT error. This is confusing as -ENONET means that
> directory entry does not exist.
>
> File on SMB server can be in delete pending state for an indefinite long
> period. Moreover it does not have to final state before the real deleting=
,
> as any SMB client who still have opened handle to such file can revert fi=
le
> from delete pending state back to normal state. And therefore client can
> cancel any scheduled file removal.
>
> So change translation of STATUS_DELETE_PENDING error to -EBUSY. -EBUSY is
> used also for STATUS_SHARING_VIOLATION error which is similar case, when
> opening a file was disallowed by server due to concurrent usage.
>

My worry is that, change in error code mapping might break some
applications compatibility.
