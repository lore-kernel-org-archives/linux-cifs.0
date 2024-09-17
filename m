Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C73374EA;
	Tue, 17 Sep 2024 21:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726607964; cv=none; b=oELSN77IySgw66L84OmnaVaVbAmwP5yL/SvgVGTgfzoNMndaG55DSyugVcnQkY1bv0FH5tAb73RmrL15Fz8dtKcT2ArJ4iUXrbmIUtY9rNF1hWdvqo3o8OlLJqoJQtO1vCG0fXqRM7P0sKpd5AJb3j1w+F56+8S45c+IvNatLZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726607964; c=relaxed/simple;
	bh=dEbXOV60Wugkdiy4Te8PUdRhJbMDZIXOnYYYzgC++6s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TQaZxXuuf/ZIGXNPIBW9hCUBGYkqilmccFc3Gek/DrEabWDlQXgfcb1KFtVt/+in/Zc7S21Uvei+EwAixr2+kArsCt32Sp1PqAJX+05nl0wYQqBBIYPB9L+In4AK8F9qfL75PRFjL1XygkoLRLptqTVHY4U4BJX9eVkwQK5hgYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F4vOm8MO; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F4vOm8MO"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-536584f6c84so7669537e87.0;
        Tue, 17 Sep 2024 14:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726607961; x=1727212761; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DSFe/iW5o5gwNqC2pwlFf+wzuvo/FkQkHqTQ1qcpT8w=;
        b=F4vOm8MOlNhvMtO9sojQr4IWC8wXxKvvaGNdhFZfFJO9OlLJtQXtuDtwEJyxS5O6XU
         NVoMWCBsUqOITB085wB6RFo1hdnWv98mIT/qE3M7dQ0SDAKJeTvaT3wdf7sc2HjxlWk7
         k6SfuKjvQWxm8LYPzoQvUy0yB9b9pN2t1pVVYZUn5ifdfcOiUJCc1KgK9rucS7QfMSHd
         LsiptDdshnkEa0UWQW8MXcmqlCEHo0iIMdrBs38L7YAOr7skwr9ORZK47fpk8rSXqLVj
         1kQHDZB0ZOsXbOGH8HjG+CcwhpJn/ti/jHQnNdJs8FaWnEIhGoGf7g3GczQHxiZvsxlc
         F0xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726607961; x=1727212761;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DSFe/iW5o5gwNqC2pwlFf+wzuvo/FkQkHqTQ1qcpT8w=;
        b=fWMPHgjDB4IhGHKNB5V0XyiMd2Obqd9u0C49JEny2n5wUYvhqIX3czzpuYg1d0l0Zr
         i1gha58aIC7JmFeMvGlKBcps5oH/tD86jOTDl2OUXXdHXKhX/gnS6whXkxqjoWWF6GCC
         MKQR2Rf/s4ccjpx/j1l8P+hHqE7RzLI7Az81bTpaduie4Qg7gvaVIp3f7RZ3Fla9ICUT
         Ced3oNwJ5RuAso6+wgUqpP7/L+oQN/Y+zMouo1eycafcNYqjWA0KYqS1sO5FeHBjpjO+
         qecvxlpmzD26IF3LA26nxfpUWsnkx4MJJUlMwHhjyTFPcSThvenXkFPBslzE/LrYcaF1
         IsYA==
X-Forwarded-Encrypted: i=1; AJvYcCW7gaceX+VnfZ/rEYVGmxyX/AK0HXywWYBd0BibBrULqG326LqyR/mZUGphp7e5r1TX937Myqrt1z/N@vger.kernel.org, AJvYcCWKEsBAYe38RyKX3DoeUkAZMlUmCwWaOjA+RuWHAFmemC3ZND2PGr4y+ehF6KKqcFsHXUIxuPxSZa/rph7Z@vger.kernel.org
X-Gm-Message-State: AOJu0YyouIqj68uFMpkwOlFgICzwhRkKTAg0xju9Krmd6X+m2crvPL0H
	NdZjAeJHQRkiL6hrlIzfMgFAiV+5PtY7eAKyiyGbpUY/KM93/HsdptlDbu+21Chp7FdEI+veuNY
	6HrqbQNyahp2rDPoIHNkJI07Jewo=
X-Google-Smtp-Source: AGHT+IH7xCngP7AE4CrasrgiQ/2UegqnHcUeP1pESMscM7CDm7IgYgzxhLNB3gU0xHvvveWcYDp7lu/pC+SfF3Hf2As=
X-Received: by 2002:ac2:4c48:0:b0:52f:c27b:d572 with SMTP id
 2adb3069b0e04-53678ff6301mr12432287e87.59.1726607960813; Tue, 17 Sep 2024
 14:19:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240913200204.10660-1-pali@kernel.org> <20240913201041.cwueaflcxhewnvwj@pali>
 <20240917200600.6smfxhrppkyjuyku@pali> <ZunlTDxPLn4yryW3@jeremy-rocky-laptop.localdomain>
 <20240917202921.ty32zzmhrg33knpy@pali> <ZunnGhOogEQU2Hje@jeremy-rocky-laptop.localdomain>
 <20240917203431.w5dejuwfkmabrewz@pali> <CAN05THTVav8HOCk6V+5eg-BTESZDBx2BuQOF1c=Vn2dFv_UNxw@mail.gmail.com>
In-Reply-To: <CAN05THTVav8HOCk6V+5eg-BTESZDBx2BuQOF1c=Vn2dFv_UNxw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 17 Sep 2024 16:19:08 -0500
Message-ID: <CAH2r5muUioziUN7mRFUAOV3tGPMLnb949j70GKYnRM2LygAWVQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix getting reparse points from server without WSL support
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Jeremy Allison <jra@samba.org>, Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 17, 2024 at 3:45=E2=80=AFPM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Wed, 18 Sept 2024 at 06:37, Pali Roh=C3=A1r <pali@kernel.org> wrote:
> >
> > On Tuesday 17 September 2024 13:31:22 Jeremy Allison wrote:
> > > On Tue, Sep 17, 2024 at 10:29:21PM +0200, Pali Roh=C3=A1r wrote:
> > > > On Tuesday 17 September 2024 13:23:40 Jeremy Allison wrote:
> > > > > On Tue, Sep 17, 2024 at 10:06:00PM +0200, Pali Roh=C3=A1r wrote:
> > > > > > And seems that SMB2_OP_QUERY_WSL_EA is useful not only for repa=
rse
> > > > > > points, but also for any regular file or directory as it can co=
ntain
> > > > > > UNIX mode and UID/GID ownership.
> > > > >
> > > > > uid/gid should *never* be exposed over the wire for SMB.
> > > > >
> > > > > That way lies madness.
> > > >
> > > > Hello Jeremy, if I understood wsl_to_fattr() function correctly the=
n it
> > > > is already doing it, it fills uid/gid for stat() from data which we=
re
> > > > exposed over the wire for SMB. Could you check that function if it =
is
> > > > truth?
> > >
> > > I'm sure the Windows implementation is doing it - however, any Linux
> > > server implementations should not do this (IMHO).
> > >
> > > It will break all SID -> uid / gid mapping that servers must
> > > carefully set up.
> > >
> > > On the wire - SIDs must be the only source of identity.
> >
> > Ok. But then I do not understand why Linux client parses and uses uid
> > and gids which are sent over the wire. If you are saying that the SIDs
> > must be the only source of truth then Linux client should rather ignore
> > uid and gid values?
>
> What I think Jeremy is refering to is that mixing uids and sids in the
> protocol itself is
> a protocol design mistake.
> Because this means that some PDUs in the protocol operate on SIDs but
> others operate on
> UID/GIDs and this means there is great risk of mistakes and have the
> sid<->uid mapping return
> different results depending on the actual PDU.
>
> Sometimes the sid<->uid mapping happens in the server, at other times
> the mapping happens in the client
> and it is very difficult to guarantee that the mapping is consistent
> across PDUs in the protocol as well as across different clients.

Yes - agreed.

SIDs are globally unique and should always be used/sent over the wire
(never send or use the local uid/gid which is not guaranteed to be
unique).  Whether retrieving ownership information via
the SMB ACL or via an SMB3.1.1 POSIX response, the SID is the correct
thing to send/use in the protocol.  For cases where the client is not
domain joined, the UID/GID can be encoded in the SID, for cases that
are domain joined the Linux UIDs/GIDs can be mapped consistently via
the SID.

--=20
Thanks,

Steve
