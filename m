Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D36224EA;
	Tue, 24 Dec 2024 07:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735025911; cv=none; b=ozOvFoFZncLpARrr5vEcB6SRbiowMAkWzjFilgSrT6rIacQGHYWYvhQ6KGgMAD+6p6jjkaly6O15wY7q0HVzEaMUFFXUxrzoEfhg72qrA3tO1lXStNri/JWH1rjQSbQKqAaIqmqWsXWxxzXCAsBfnMrSQ+GDmmKPCgYIucB/UEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735025911; c=relaxed/simple;
	bh=JVTsvtfoxGXrKqCRKpAV4tetFQXcyTUAx0sQ1jqySiA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dEtZByzM+ijPmxd7RDcVPT4UDmvOvyFIqk/xnHqyEbOTbSmqWjk8C2UWprcwxdLhVVwDw+MXWWdN4ydWAZldxnFfxVKI+Nuvg4DBNPbv142fO4T6l3abBbEyrr/W/DIVeOqhFOgv8CsLIaAUnl4ic7qxvopzFHq5mgmZabVNLhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fk47ExJZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fk47ExJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8818C4CEDF;
	Tue, 24 Dec 2024 07:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735025910;
	bh=JVTsvtfoxGXrKqCRKpAV4tetFQXcyTUAx0sQ1jqySiA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Fk47ExJZuzvmdSVfznNOt/dAjL7JCD/Gae92dVw3Gcp5Wt2UN3wdvnYHWJt1cwbp9
	 16ghL0LG/+L4QykiHCWyGI0kP0arX2fNpHXNxnoaMvMBFb78B0QcRxVIieZgj8+sLn
	 xrkN6Qvej8QivDbDitAJvxO/q9pASxFYIOkIHgCztqEny4RF6iRMmldp00w69tmPI7
	 1EAWH0ZHf7Y2Tv3aSy8oUfAYJfKKJOVb8QSjO6Yve6k9HeBpMfxA3wQVvmYGW7SOCR
	 ATnIbGJY1ztINv6s6IOkbJFjwdQHx4psxRl29zVFn5ssvxdfzFbYWSdzOlnmMYYB4N
	 QAYHve7EBRANQ==
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3eb98b3b63dso1051498b6e.1;
        Mon, 23 Dec 2024 23:38:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXA9CqJ/CYOec3WFIDw/A50VFRDjW8N/n7RK4z9eE1dxwnTIyyO2vyaBCiN66HBvBWmNrxtgwzFNRFN@vger.kernel.org, AJvYcCXa2wn36JV7RHtc3iRW472E3Ert740SOrNwfi9GtdarKHBR3nPvLLto4hH00K9tjdFF3oW0QItRlgQ2Etxl@vger.kernel.org
X-Gm-Message-State: AOJu0YwSOdCxLPDpWwfrTnjup84YD0ENKzOCMR7sGpB0FvRBmCd0Io4h
	O4nitwckoF41mT+zbM6Gn9o78eyqRCWQBeAajGnxiNKSRdqZ0IxoFWqPWNzlvYZaGothgCJZokw
	zEsKYzkgBIY83jtPhYbz8pa9x2oM=
X-Google-Smtp-Source: AGHT+IE8h2Pv0Iw2lJmL1rbeRrsaaqIWzyTOh4iZWsL8DHElbbulBFk085ecsfqr7XoaFKKYjgzvkHuPhwREmK4A9bc=
X-Received: by 2002:a05:6808:f08:b0:3eb:52b1:5b8d with SMTP id
 5614622812f47-3ed88ecee0amr8155960b6e.2.1735025910208; Mon, 23 Dec 2024
 23:38:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241222172404.24755-1-pali@kernel.org>
In-Reply-To: <20241222172404.24755-1-pali@kernel.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 24 Dec 2024 16:38:19 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8Ewe2ZceLkwnSwS-mqvYU51LY+s-QFzXJ4-aitnG6pCw@mail.gmail.com>
Message-ID: <CAKYAXd8Ewe2ZceLkwnSwS-mqvYU51LY+s-QFzXJ4-aitnG6pCw@mail.gmail.com>
Subject: Re: [PATCH 0/3] cifs: Cleanup of duplicated structures
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 23, 2024 at 2:24=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> This patch series contains only code cleanup of few duplicates structures
> and enums between smb/common and smb/client subdirs. No function change.
>
> Can be useful also for ksmbd server part.
>
> Pali Roh=C3=A1r (3):
>   cifs: Remove struct reparse_posix_data from struct cifs_open_info_data
>   cifs: Remove duplicate struct reparse_symlink_data and
>     SYMLINK_FLAG_RELATIVE
>   cifs: Rename struct reparse_posix_data to reparse_nfs_data_buffer and
>     move to common/smb2pdu.h
Looks good to me:)
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
>
>  fs/smb/client/cifsglob.h |  5 +----
>  fs/smb/client/cifspdu.h  | 30 ------------------------------
>  fs/smb/client/reparse.c  | 15 +++++++--------
>  fs/smb/common/smb2pdu.h  | 14 +++++++++++++-
>  4 files changed, 21 insertions(+), 43 deletions(-)
>
> --
> 2.20.1
>
