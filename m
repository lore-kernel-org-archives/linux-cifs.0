Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1E33403E8
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 07:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787037903; cv=none; b=n69SfLY1Bc+T9sm/sToKmqU9PDmN6tWoItpKdrld2NgcdqbIgenMHD8pitzjKNPn5DuG81QO5217pksGNpoTvBL7zS+NtLI+gal3EQviUjwj2glKNIOiE1EnRFBnyL7wcICowA2p5YaGHGQYTg9VJUiuyC52qmcKsWH+6054bXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787037903; c=relaxed/simple;
	bh=rjhuO8sSmUNRck8KQ4aCp/KEIV4i6l2rlYrYM45HPI0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=je1uwdUAvUc1+Ykcxozn2bnVgwQ3tsctJ1Bbv00lVM7mplXp14nTmb8bN8zm52B6hoNlHdNdMvlqpn1lMaM7bBJeSh2LLUPBwznKOmCL4cnTM33Rd7zI9L28ZyUTj9BN2dhiQIwWytpo5xi/J02FXAdEvFvCuI8NbSJobgdrxK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hmjK1P9o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hmjK1P9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F85A1F00A3F
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 07:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787037901;
	bh=rjhuO8sSmUNRck8KQ4aCp/KEIV4i6l2rlYrYM45HPI0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hmjK1P9oTg5GLV6vGyxv3ZZ/jYvPtxVux3s/jCuko4yVwiCreC0QZ9oDgTkAlNYNL
	 hLkltqy9uUBLnucm/CgnEgR7DMPngcYv59pwePg990KrErMCqdLJ06U5zyS14ApzV+
	 s47Uz0JC66BmkQ40Ut8P3hDrIJ0N4HVrkzngfO5QXqsZSDbL8odcoC0QbiKGpUQszD
	 ikLvePZToqnymVw1ypbDUu3I36FJ5oVidM/OMgmkLekXWzfVYf9fsVrLDLzHPIRgJb
	 muQ+tCbI/RYYzASnpHaUEG3fi57kQERH8nHKEMIVHQ6sVqu1HtmgVS0xu5apoKos61
	 xoo1PqFeWYrQA==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c1600d040e4so96712366b.1
        for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 00:25:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp4FL2rSvc6VnQqmqBvKSlexzw/BICQqWcUSs94nEN3ugxOI2OBPivwQSRKtnICb2VZxuRaS2mprHdE@vger.kernel.org
X-Gm-Message-State: AOJu0YwKbFgMwPUwG1QOm+ZNBLsn24pwtBB1QZvX+3EsN/oUIj0QrUn/
	qnlVMLn5h2yZJ81Gd5CiVlc/cSMbsm0yrByfuayYm2wqoqqWEunnKxu/O6mQsekM7DvXFHVKbdl
	LqBgVUujhWCkQpFRJ2+Z5tZT8PkvfWFQ=
X-Received: by 2002:a17:906:eeca:b0:c20:367d:f8b8 with SMTP id
 a640c23a62f3a-c218afaa94emr239298566b.4.1787037900164; Tue, 18 Aug 2026
 00:25:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260814041418.1216774-1-dmantipov@yandex.ru>
In-Reply-To: <20260814041418.1216774-1-dmantipov@yandex.ru>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 16:24:47 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8zH5M0BMoHRA40Hnm9KHDBFNhNmjjEmQAD2Hy64ZAvBQ@mail.gmail.com>
X-Gm-Features: AcwNN1VdvnISNSX-lLX5SzI9PwB0dMi0945mh5KbjsNzu3x38nmuT8QvPce5cCs
Message-ID: <CAKYAXd8zH5M0BMoHRA40Hnm9KHDBFNhNmjjEmQAD2Hy64ZAvBQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: simplify __build_path_from_dentry_optional_prefix()
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2026 at 1:22=E2=80=AFPM Dmitry Antipov <dmantipov@yandex.ru=
> wrote:
>
> Use the convenient 'strreplace()' to simplify
> '__build_path_from_dentry_optional_prefix()'.
>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Will apply it to #for-next.
Thanks!
