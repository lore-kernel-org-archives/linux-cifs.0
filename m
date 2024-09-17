Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDD918E058;
	Tue, 17 Sep 2024 20:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726605894; cv=none; b=dWfo5ulqmMSXirCU/PmfeeYr0IzYNnk+3ZY+fbbDbaRSTzIZPMTxAwQQT/fzarD5/+VNiRtDDNZfBMk2AG+orVbT8usw1wILohNS9NUauGCWfHd29SpAnKp70Dt/I3Zw4K1x5TogJKQ11oPl6fsCXyIByeroHADfXHsmcxjKYxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726605894; c=relaxed/simple;
	bh=y9ZCFoRsgVSoyCZ/lO7+beEwbLdY5MNGEy6YE4HCaZ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FUlNIR1KMeUwqE7s7iKI7Z5lDdr4Qbzo7e2FE1DXtNcSWV9ZcbVzSm+Qy1yimCgmWm5kj6pw/wnIfUDJydxwJDRc9rC811dPE2VBxWfhT4Nb7l1r/GBmMNqZLGwhVff656YY/70esqC+Tn1HIsYH+wZx4T4EFUr4uh+rzpKhpkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ciOc5NmE; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ciOc5NmE"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7178df70f28so4614534b3a.2;
        Tue, 17 Sep 2024 13:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726605892; x=1727210692; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y9ZCFoRsgVSoyCZ/lO7+beEwbLdY5MNGEy6YE4HCaZ8=;
        b=ciOc5NmEK+ylbWvJsdc4QPF574rONLTXgHtG79pZGHU+83PQL2L6YSRpX9MQBINHyG
         VkhYlHn+XLw8Wp7GZVcCW3TCjglj/YBTef9/zKBBTOY4PEOTDYoEACFREGeYAT4kG5mI
         sx88PN7w9+MB5vUPy6x8CZMSqoRDEs61aVM161iaFwI6zZJzNUrXpZmQHO5G4HEEVZM0
         q/iIxPbQVH/ofMqqeyzg7C3fGhSb9gSc5OQAlvT//1as6o5uOss5aHB5w49LRWtmcW7e
         iNAQdIQpyvLSltIMnaXWuRykKOMRB2W1+oUHjGdIrWbEslR5dl+sASB8BoQfY1ie8oy6
         arkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726605892; x=1727210692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y9ZCFoRsgVSoyCZ/lO7+beEwbLdY5MNGEy6YE4HCaZ8=;
        b=MY3PTwXveNRf05JXFLU10G1LpjBJb9KISzA/fv67Jwnob+49WXL7F+tBqonIMU4+dD
         CpzlhIQxIj+mSD+AyOah1eYhjU55AeMbQ+n1kLomXZaaZ3VlNCbcBIII7WQ0ubzoVFEj
         ZeslWyZuq/pp/P1WJqAw32ZfvW+AKZkWJZLJ9tINX3ecRPfETQdpnDzAhGhTHXfb7BHl
         TvFvFhvEGj+up78yk4hIDDlAL9/GD7wT9wJX+RLCnfFapgfjZl/1JL3QSwXNb+9q2BYS
         FxyhGCGlbIVmfvMpqT6RpOMX2ghF7FlwD/6xL5yvnmH/rO9Ge53fcWuSVaA/ixaDMR8/
         tOjQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4tkyIYSRDPIQDRifjM9d+E9/eP/Pa7dSUTwI4wSFYtPl6FyiHscj6enY78VTLweDWlJzeEU8SzMiL7Vjb@vger.kernel.org, AJvYcCW59hJY32TcksntSlVIcz3uFaiNMgebefMeHjs2CUofFHvjBvtZU9i8hEaFwh91GHOj8Vs04me9E2nl@vger.kernel.org
X-Gm-Message-State: AOJu0YwpafHSJ3WM9CDMa/9kxtSykp7VyZ9+lupQGGwuoo7TZq4F7YjI
	QUoTyC4ugQJXUBq+9Ntg5BoKZ2FFZUmpZ6B4AzOmbl3vlzdoC65yDIlRokkBd8PLrr9zsIbfLql
	BQ8x0Np46+Vrpdo9iXp4mqW0k1a0=
X-Google-Smtp-Source: AGHT+IG0g8lx8pLhQYQAzmm/v3Q72OnecVsY7M8CKb1x/pdBYlfzldhNQEySVszX6NNQ9veDkKUQ0tv++WOucCx8BF0=
X-Received: by 2002:a05:6a00:1810:b0:717:9296:b45f with SMTP id
 d2e1a72fcca58-7192606d0f3mr29372208b3a.8.1726605891508; Tue, 17 Sep 2024
 13:44:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240913200204.10660-1-pali@kernel.org> <20240913201041.cwueaflcxhewnvwj@pali>
 <20240917200600.6smfxhrppkyjuyku@pali> <ZunlTDxPLn4yryW3@jeremy-rocky-laptop.localdomain>
 <20240917202921.ty32zzmhrg33knpy@pali> <ZunnGhOogEQU2Hje@jeremy-rocky-laptop.localdomain>
 <20240917203431.w5dejuwfkmabrewz@pali>
In-Reply-To: <20240917203431.w5dejuwfkmabrewz@pali>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Wed, 18 Sep 2024 06:44:39 +1000
Message-ID: <CAN05THTVav8HOCk6V+5eg-BTESZDBx2BuQOF1c=Vn2dFv_UNxw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix getting reparse points from server without WSL support
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Jeremy Allison <jra@samba.org>, Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Sept 2024 at 06:37, Pali Roh=C3=A1r <pali@kernel.org> wrote:
>
> On Tuesday 17 September 2024 13:31:22 Jeremy Allison wrote:
> > On Tue, Sep 17, 2024 at 10:29:21PM +0200, Pali Roh=C3=A1r wrote:
> > > On Tuesday 17 September 2024 13:23:40 Jeremy Allison wrote:
> > > > On Tue, Sep 17, 2024 at 10:06:00PM +0200, Pali Roh=C3=A1r wrote:
> > > > > And seems that SMB2_OP_QUERY_WSL_EA is useful not only for repars=
e
> > > > > points, but also for any regular file or directory as it can cont=
ain
> > > > > UNIX mode and UID/GID ownership.
> > > >
> > > > uid/gid should *never* be exposed over the wire for SMB.
> > > >
> > > > That way lies madness.
> > >
> > > Hello Jeremy, if I understood wsl_to_fattr() function correctly then =
it
> > > is already doing it, it fills uid/gid for stat() from data which were
> > > exposed over the wire for SMB. Could you check that function if it is
> > > truth?
> >
> > I'm sure the Windows implementation is doing it - however, any Linux
> > server implementations should not do this (IMHO).
> >
> > It will break all SID -> uid / gid mapping that servers must
> > carefully set up.
> >
> > On the wire - SIDs must be the only source of identity.
>
> Ok. But then I do not understand why Linux client parses and uses uid
> and gids which are sent over the wire. If you are saying that the SIDs
> must be the only source of truth then Linux client should rather ignore
> uid and gid values?

What I think Jeremy is refering to is that mixing uids and sids in the
protocol itself is
a protocol design mistake.
Because this means that some PDUs in the protocol operate on SIDs but
others operate on
UID/GIDs and this means there is great risk of mistakes and have the
sid<->uid mapping return
different results depending on the actual PDU.

Sometimes the sid<->uid mapping happens in the server, at other times
the mapping happens in the client
and it is very difficult to guarantee that the mapping is consistent
across PDUs in the protocol
as well as across different clients.

>
