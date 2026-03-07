Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6ED1EA7F4
	for <linux-cifs@vger.kernel.org>; Sat,  7 Mar 2026 02:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772852177; cv=none; b=dUEZKby+ssbrN0Gf55a+IHwYvONNMBqPwcuZAJqmzg0BTgCM6lEPDG5wGypsSYXa22mXO59k+d4HH+6kc1I0KlJKRH0oEn4YlHMwvn2w0ycwP5t6+dV4ENVVrXKtMm4NhJKfxIUGfwWN7jUjYHVxSY6F10023RoTXBooTHOi6Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772852177; c=relaxed/simple;
	bh=uMoy5cv4M97zjZqTbC+Vg10/te9R4xuxVgJKyODEUSg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AVQbhdLPPvyE/0FnP/U62VdH+NMEKep8gBtfjWjBecS1zaPtQ/wuXDeJrpV6x0TZK+I7oW7AL13lIak+Rs5yofqNFz+bVF9sSIfTvtVI2uyaCO+5E/0tzSac1Atp0dJ+nubTudFBmhQmUg9M5ZUXfqs8uBVYMU7mP+j78HlmhBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WzkFx6Zm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WzkFx6Zm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D67C2BC9E
	for <linux-cifs@vger.kernel.org>; Sat,  7 Mar 2026 02:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772852176;
	bh=uMoy5cv4M97zjZqTbC+Vg10/te9R4xuxVgJKyODEUSg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WzkFx6Zmj+v8Zq6bZXPrKSXM4wbEfqQYbFf+4WT6Kv5ENjhBjIwGnoBy9vhp9qCR8
	 TOTJCzQ5ZKIA3s5eVILgIZg7hyF4tgOmj6FPO/b/u7O1qG6mIXGsV8vRuuKD/wr1Va
	 8b718F2tqhf98KBExuTDZdS+k7RGpO//NvRYYCF5QTbINWEEhbHVPN/bXstqcDdkC0
	 2fiunYaXm3fFV7eLVnIlncvz6OUWrIi3nFH81JMoe2drLthADVOAXSRtW5365AoHd1
	 a5LwpCsLKYFmI9eldygYSfyOtzjXuGDUkIhOQV0qToFlw2KgClWafXlsTeQhh6+o9J
	 svHx1kzIG7Yjg==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-661cfb9f3aaso1156124a12.2
        for <linux-cifs@vger.kernel.org>; Fri, 06 Mar 2026 18:56:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWCc3xeAudSX3vfHR/gSV4e7e4c7MjkJp16tsILK/+2c1b5k3/QwRqw+LCOMwJ+bfnw4J4Hks21c0O0@vger.kernel.org
X-Gm-Message-State: AOJu0YwdIkfgmCISIcvQFP3eb4gR0sbHuoGjoI/ilOCcIKIgCTyzOctA
	/50V+D1jPGsLRoYA8QERPeMbB2kddRtOz6sGaKvKVoZ9PNcbi7oGw78X/jlTrwQXkoq/FHn10cY
	04LYcKbUSgLE5MF7YQggrCnQzgJGkRpg=
X-Received: by 2002:a17:907:7f87:b0:b8e:9d66:f5fb with SMTP id
 a640c23a62f3a-b942d5dd2e7mr232731466b.0.1772852175267; Fri, 06 Mar 2026
 18:56:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306144415.3402532-1-arnd@kernel.org>
In-Reply-To: <20260306144415.3402532-1-arnd@kernel.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 7 Mar 2026 11:56:02 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9qOhxSU9cWh007k0FFO10Z1QknqBw+s+4KWWkUqpJM1w@mail.gmail.com>
X-Gm-Features: AaiRm50dj7Fc6fXjLGMHhU_B79lJGb4-mGjkBxtu87rjldnkHeZZ13JcB8Y_gzE
Message-ID: <CAKYAXd9qOhxSU9cWh007k0FFO10Z1QknqBw+s+4KWWkUqpJM1w@mail.gmail.com>
Subject: Re: [PATCH] smb: fix smbdirect link failure
To: Arnd Bergmann <arnd@kernel.org>
Cc: Steve French <sfrench@samba.org>, Stefan Metzmacher <metze@samba.org>, Arnd Bergmann <arnd@arndb.de>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 6, 2026 at 11:44=E2=80=AFPM Arnd Bergmann <arnd@kernel.org> wro=
te:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> When CONFIG_INFINIBAND is set to =3Dm, it is not possible to have SMBDIRE=
CT
> built-in, and it turns into a loadable module, but this does not prevent
> CIFS and SMB_SERVER from being built-in, which in turn causes this
> link error:
>
> ld.lld-22: error: undefined symbol: smbdirect_socket_release
> >>> referenced by smbdirect.c:212 (fs/smb/client/smbdirect.c:212)
> >>>               fs/smb/client/smbdirect.o:(smbd_destroy) in archive vml=
inux.a
> >>> referenced by smbdirect.c:212 (fs/smb/client/smbdirect.c:212)
> >>>               fs/smb/client/smbdirect.o:(smbd_reconnect) in archive v=
mlinux.a
> >>> referenced by smbdirect.c:338 (fs/smb/client/smbdirect.c:338)
> >>>               fs/smb/client/smbdirect.o:(smbd_get_connection) in arch=
ive vmlinux.a
>
> Enforce the dependency at Kconfig level, so that the respective smpdirect
> options are only offered if it's possible to link against the common
> module and infiniband.
>
> Fixes: 28504d6ee127 ("smb: client: make use of smbdirect.ko")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
