Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFFF19004A
	for <linux-cifs@vger.kernel.org>; Tue, 15 Jul 2025 01:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752543976; cv=none; b=MeyW8FII4Id9GBItT7W38FqF+ciYshJVw+7Pj+4mMivkZAEqaelIJE9PcXeCvWE0K0zwr6eeJYyJqfVJCZAzX4oQ6VAOlD6que+MxQiNv7+R9ANLBW5wbEsayG10hxxJfiSLQaooQED4PkdItODTeMQT9HGw6Jfo/TcuNpVXNa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752543976; c=relaxed/simple;
	bh=fxqt0nVUvEODIasl5Wzqf86Ncoa3F/LOjLYpkNgnIVU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sM6LMq4gS6fYCgJopz1Gy29McCjpY77GvxIyBC7AvxnLwA48JBZQQ/0c7pNWX6WQ8X0MefcRwqbzDa4n7hzvQkaS/LbOjXwv+qRvfuX50MUFRo8VGnqpjd9SUoYxZ+Kgs00fYWONQZcCO0a1DBNDbKZpxuVBA6vLhakOjxWpjgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PgOws74j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PgOws74j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB014C4CEF0
	for <linux-cifs@vger.kernel.org>; Tue, 15 Jul 2025 01:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752543975;
	bh=fxqt0nVUvEODIasl5Wzqf86Ncoa3F/LOjLYpkNgnIVU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PgOws74jVOEChN2VXghwcd7fqiQKoEA/07+eI8RhDr7QVFO5WOxXtwTpxJTQPQ8kv
	 ZrXOfdijy5bOIwyo83CB92HgJCKE0WBSRlA/xiXmlLxMDsSzTvMgyQsNG/+I8xcGLQ
	 8OOMc5BQxvnXr7ESMydhyvf9o8yPazsHfv/3/HvBp6mSvIo7+9I9rAsFjdSLDn0eAa
	 TkxOmmKFFe1AZbKbA36bWM5TAwg02fQk5EeLUpajG3UxkzaORR3AewJ3VbT5xYd3Xi
	 U2Vzt8+TARrrvO6o1kWrJ5JNBSv9W82RswL61BRsJUncyomhE1yOvj/w9NL5Ep0Rcd
	 e0NTD2/LM0mRA==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ae3ec622d2fso859221366b.1
        for <linux-cifs@vger.kernel.org>; Mon, 14 Jul 2025 18:46:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWYoJXf4qRTF9gAG9f5SnU+hNTgtMHMHvZzP6qd1sJq+ffEd9RBjzbOGiyA6zlWkfGxXMoQbcf4jMjf@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7q9jL5RH8mKTpMxu5s/RnyVWmMJ+W0c03x/hv6AAy7fYpAoPC
	uIfeu26huRk6w7XMraIHBXAuSZ7jYEAkc3DzDRVHOvI6Ra9iOIRNchU0oDKSjrZFViE4gFqYusE
	GVYR4g5YPkmH3ZdDpuHt/d01aLbiObuM=
X-Google-Smtp-Source: AGHT+IHWCy7biLPxxLXoIx/NZehqG3VPyNKw9vhqWL4ikBJ9IbD9f+VEtVQAZMbH3Q062GBKEXnVtOiVUtnuVXlAMfU=
X-Received: by 2002:a17:907:9308:b0:ade:8d5a:cf37 with SMTP id
 a640c23a62f3a-ae6fc37efd1mr1512578966b.44.1752543974281; Mon, 14 Jul 2025
 18:46:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250608125507.934032-1-sashal@kernel.org> <20250608125507.934032-2-sashal@kernel.org>
 <CAB5c7xoe98HomEgfOx4z_H5zS5AYz4ZSYz-ZV2DES-M8cE30iA@mail.gmail.com>
In-Reply-To: <CAB5c7xoe98HomEgfOx4z_H5zS5AYz4ZSYz-ZV2DES-M8cE30iA@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 15 Jul 2025 10:46:03 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-ssk9AhJDtF50v0AaE28Ojt+A-ghVB2s9ac3iRG6rsOg@mail.gmail.com>
X-Gm-Features: Ac12FXwb_wUuMU6l0cI4jterN0-d8X6i8FMQ7cBlfnDmZF_6UDGFQYCPwKtdjt0
Message-ID: <CAKYAXd-ssk9AhJDtF50v0AaE28Ojt+A-ghVB2s9ac3iRG6rsOg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.12 02/10] ksmbd: provide zero as a unique ID to
 the Mac client
To: Andrew Walker <andrew.walker@truenas.com>
Cc: Sasha Levin <sashal@kernel.org>, Justin Turner Arthur <justinarthur@gmail.com>, 
	Steve French <stfrench@microsoft.com>, smfrench@gmail.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2025 at 10:23=E2=80=AFAM Andrew Walker
<andrew.walker@truenas.com> wrote:
>
> On Sun, Jun 8, 2025 at 7:55=E2=80=AFAM Sasha Levin <sashal@kernel.org> wr=
ote:
> >
> > From: Namjae Jeon <linkinjeon@kernel.org>
> >
> > [ Upstream commit 571781eb7ffefa65b0e922c8031e42b4411a40d4 ]
> >
> > The Mac SMB client code seems to expect the on-disk file identifier
> > to have the semantics of HFS+ Catalog Node Identifier (CNID).
> > ksmbd provides the inode number as a unique ID to the client,
> > but in the case of subvolumes of btrfs, there are cases where different
> > files have the same inode number, so the mac smb client treats it
> > as an error. There is a report that a similar problem occurs
> > when the share is ZFS.
> > Returning UniqueId of zero will make the Mac client to stop using and
> > trusting the file id returned from the server.
>
> Doesn't returning a zero fileid just cause the MacOS client to assign
> a fileid based on a hash of the file's path? In this case it doesn't
> really make the problem go away, it just makes the problem more
> unpredictable. In the past I was also able to reproduce the MacOS data
> corruption issue with Windows server by mounting multiple NTFS volumes
> within the same share. Windows servers identify mounted volumes via
> reparse point: https://learn.microsoft.com/en-us/windows/win32/fileio/det=
ermining-whether-a-directory-is-a-volume-mount-point
> and the last time I checked the MacOS SMB client wasn't handling it
> right (I reported the issue to Apple a couple of years ago). IIRC,
> minimally some versions of the Linux SMB client may also hit the same
> issue (two files in the same SMB share with the same inode number).
Could you please explain what issues there are when applying this patch
between ksmbd and mac smb client, other than Windows server case?
Justin confirmed that the issue is fixed in the latest Mac client.

Thanks.
>
> Andrew
