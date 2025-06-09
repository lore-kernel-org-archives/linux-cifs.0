Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BA3193062
	for <linux-cifs@vger.kernel.org>; Mon,  9 Jun 2025 21:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749502918; cv=none; b=HA9TskmfjtzrndzCLMD8SQ13PRR01yHoW7oFKAKjgaLCjeIrI5k1coUoGunsi9G0GSgKOlxYp8//BUKvNObLGmTB7A8Q2qGfcSQTBB0YDlyNBtKyA0Gc408GFwXu4C8C4CxtDHMKGT4vscznIS5dZ6wxJIY8Uo5s9J67KAyZ/kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749502918; c=relaxed/simple;
	bh=J4DkXTYwW5Ep8DUHJ5uF89cdrUl3k3cbZQbOzQO0YiM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NsHkFHZL56SQUs2jFt7MMA/7ZCiy+G+mYXh8cAJ1/+HTbnBxFzgaBcYiiZ3vUbjxS0drcpgo3zSa5uXdQK87KjbF5rYkFGzfEbzsq+dgxfnoHxD9FCPTYSuax+udumgnp3Bu6iAhN2OPknsGMg37VlQBP+GnoqC3KUEwC6lzYIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dHogn+oI; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dHogn+oI"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-3105ef2a071so51043961fa.1
        for <linux-cifs@vger.kernel.org>; Mon, 09 Jun 2025 14:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749502915; x=1750107715; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J4DkXTYwW5Ep8DUHJ5uF89cdrUl3k3cbZQbOzQO0YiM=;
        b=dHogn+oINTThP9YpsDhTuK7B58GgtwRdvqNKZ8VZgrThNEwKcAD9hMyqNlO3Cu0pp9
         S62Cad4vnqy0oEcfQ3DKCRZCI/99ji4+wTMpBLsjqyzDW2LfStbU3VBUj4c+6LAupxff
         1eXFK6s2DgdfkFb6Cp02An8RJcWAN0qRkvu6NFLKMDrlcBC3324nH/QO1QY0occxZ7ZW
         hMXBUjWMccKM+GPBuvVdJrXuR3SVYuVnB83wAS7GQBAnD8N7QKYkt9eRIv9GgsZh1H4m
         N6Kv0JQKMXJf6UgafTRlNiTz823cNZGxEH6pmDgIFvTOCKvmlnlyGfh6Tez59hUIG9rv
         gzlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749502915; x=1750107715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J4DkXTYwW5Ep8DUHJ5uF89cdrUl3k3cbZQbOzQO0YiM=;
        b=NB0BKZLE7X+bY3U09WiAtZAfpp2VORvBQfgT5IRW8/oezWmlpKXJ9E6yNPv1L7Udq6
         hCOUDjNRIBKH6PgzWzVtSFg2E8FQysR+61Fk++ZAVpnttl8F0Wyaanl96jppR5jV4ofb
         z94qIo4i2vlYzqGvcP4ZwBv/G6yT/drqL3k/I+B+9fnVj+eIBAiocFgOLmrajxB2QNGa
         XVOijwgA/MAFC/DKOQuSkKoFZSDv6YWjaRJl9hDXFMCxYosZPrFQp7GM9UC5N1nCus05
         A/fqp+VvXZEdCdazsHo+g8agxVvcVo9kkj37v2XOMkjqsijgAEp0VqBQU9dO2ee6IZX5
         CgkA==
X-Forwarded-Encrypted: i=1; AJvYcCVl0tn9IUAr10yrIU5fkacX/0M69Do8u54nH/Yy6Oa7DkEu3tevRqAB012/H2Tc5whHFq6Rp9zvboxn@vger.kernel.org
X-Gm-Message-State: AOJu0YxrJaKrtQFfJAAEDaX25z8at3S6GjaWyNWfvX1+JhOMGfQz7xKQ
	M+TWozfUVk9NByih40qauwKEOvNTvYYaMhrBIeYxxYRaOe0zlryJVHaP1IlIa/1prhNMC+GQh2b
	oRuTep72Rlv7hVsTj2TjDYV59eZ9B5fHDrg==
X-Gm-Gg: ASbGncumLC6W0k+PDz/unwSbIVIjW44OzzhiogiHUG6nQjHyx853tdRZCwUgwAFRRmy
	ctRcYkIL6NxF2WPAp/B5kjsZZFyPgCaU/8QUwle6PdF7pz8tSrP54X9a7Rsji6yuk3Yb+i9o5aE
	2Iv7HOz9OYjycDwTYKWCXWfS7B5NBksZy8ufw7sn3tEB6mPvKKg3UHWZO3LHdLUlIkQCU06AMp/
	LrlCBNpjji2sM9l
X-Google-Smtp-Source: AGHT+IHsCNHegqYNX+NPCF7HkCmAPSw+rq6dTGq/CFkeKLnS5BehJ6U+698wb4S2U1xIj2rKm2kqH5fsLFXEE+/PhoM=
X-Received: by 2002:a05:651c:108:b0:32a:66f7:8a15 with SMTP id
 38308e7fff4ca-32adfed5cd4mr27233801fa.39.1749502914351; Mon, 09 Jun 2025
 14:01:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250608185900.439023-1-pkerling@rx2.rx-server.de> <CAKYAXd-SjnnTtYp2NNvRuMWp39-MhcPa-+8xVCYKxDpGHLGsCQ@mail.gmail.com>
In-Reply-To: <CAKYAXd-SjnnTtYp2NNvRuMWp39-MhcPa-+8xVCYKxDpGHLGsCQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 9 Jun 2025 16:01:42 -0500
X-Gm-Features: AX0GCFu2a_Ne83XmZE7MAd372CX3Rsa0q3FW0YPqFq5S-WkG8GWgwsyOi4GGSgo
Message-ID: <CAH2r5mv+3xhiD+CdKOdnSNSz_TuR4i=9s0rViHm_ObhxDyd50w@mail.gmail.com>
Subject: Re: [PATCH] smb: client: disable path remapping with POSIX extensions
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Philipp Kerling <pkerling@casix.org>, linux-cifs@vger.kernel.org, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending additional
testing and review

On Mon, Jun 9, 2025 at 12:51=E2=80=AFAM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Mon, Jun 9, 2025 at 3:59=E2=80=AFAM Philipp Kerling <pkerling@casix.or=
g> wrote:
> >
> > If SMB 3.1.1 POSIX Extensions are available and negotiated, the client
> > should be able to use all characters and not remap anything. Currently,=
 the
> > user has to explicitly request this behavior by specifying the "nomappo=
six"
> > mount option.
> >
> > Link: https://lore.kernel.org/4195bb677b33d680e77549890a4f4dd3b474ceaf.=
camel@rx2.rx-server.de
> > Signed-off-by: Philipp Kerling <pkerling@casix.org>
> Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
>
> Thanks.



--=20
Thanks,

Steve
