Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C0F3A542F
	for <linux-cifs@vger.kernel.org>; Sun, 14 Jun 2026 16:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781456331; cv=none; b=L/rAu4xihJ5rrw1DalGH0Kw/6ZOMNvxvUT/zYZejgRZrHxqIEnESJDspllL/0XuKW51xARNEE6AKj21/Iokp3He/fcHeXt3ktUUYfB2TriDbF91AEnimaximkzyT/uN94Hl12zlaLM73uccFlhtVd0I2QmyY91GgORVnLsX8f50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781456331; c=relaxed/simple;
	bh=VOXniTR3wXI4Znh06OqzaeFf6jWoOm0HsEDyrV97PWA=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=teLvEp0DarvlwVjFx/MmE6YTH0WydNxw08LLkS1KQSz1gpODAqtkHaQ54R/SQNFcrfoh+RXdOmCorzdYtCX+rBdR3vqyfVqqoMbxpRj9AV8/C8rysxQCXy6LjrhayVPlQLAA5SE7yGEM8hOoFPzG1yJd6LCAtVaGnCbBBQFpUNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=gWloa08C; arc=none smtp.client-ip=195.121.94.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="gWloa08C"
X-KPN-MessageId: 27584a23-6812-11f1-8ff8-005056999439
Received: from mta.kpnmail.nl (unknown [10.31.161.188])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 27584a23-6812-11f1-8ff8-005056999439;
	Sun, 14 Jun 2026 18:57:40 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.189])
	by mta.kpnmail.nl (Halon) with ESMTP
	id 2756a90a-6812-11f1-8109-00505699693e;
	Sun, 14 Jun 2026 18:57:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=8QohWqedXEeL1TjwRMSoT2NjvDlan4ueM7ovpK8w9RE=;
	b=gWloa08C5gaFS9ud2Q0xM2Xsu4VKUpUTA+ufwNuiznXADhjKWfhdOyY9dzmFMjE+qmrnmb0IsXyNS
	 FCqytTOlKeeqcoMiq05YJEFFc/jRJBtSbcJf3JYg2uV6ydIiiRUJtViXpcxaEnTW2n2MslFZeAEqem
	 ua7KXMSX7MoNl8VXWsLia6fJy8gAzom9apjB6MwBtpcQ1CGid7tiKYj424juEQ8zmK2+DG8H85KVTD
	 wFyHKA1mCh+eSZzKGJvllFqkwGTKq0FIY/8ES1Szk+Udb44gfoB9Y6Iy6hIFBBAKS4zK+hcNxqN9KV
	 6hbxBzAN7YM9OtOMVuXuwF12xMHjPEw==
X-KPN-MID: 33|WA/m+4GktEN280KBfl3QFsgU6gzhNMkExpta0zjBzacYOw9gn7Zjw6kO2rFvin8
 X7f7oCEsHTk2T6gLppSQa/e7SUcT/zShMxmenuMfVsmM=
X-CMASSUN: 33|WxgGnbtgBvFfzMziWWYcQtZAS2NyP2d3HJaExX35KIR9s4FhmWGTiG7u0krSLCz
 zzvfhzLZWtU8e6few/pLSzQ==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh01 (cpxoxapps-mh01.personalcloud.so.kpn.org [10.128.135.207])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id 274b0c4b-6812-11f1-94b1-00505699eff2;
	Sun, 14 Jun 2026 18:57:40 +0200 (CEST)
Date: Sun, 14 Jun 2026 18:57:40 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: NeilBrown <neil@brown.name>, NeilBrown <neilb@ownmail.net>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Steve French <sfrench@samba.org>, Steve French <smfrench@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-ID: <586018010.1683063.1781456260309@kpc.webmail.kpnmail.nl>
In-Reply-To: <178131507850.3002522.16819279282508142089@noble.neil.brown.name>
References: <20260611145733.43776-1-jkoolstra@xs4all.nl>
 <178131507850.3002522.16819279282508142089@noble.neil.brown.name>
Subject: Re: [RFC PATCH 0/1] vfs: pass S_IFDIR mode to vfs_prepare_mode()
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal


> Op 13-06-2026 03:44 CEST schreef NeilBrown <neilb@ownmail.net>:
> 
>  
> On Fri, 12 Jun 2026, Jori Koolstra wrote:
> > There is a comment in vfs_prepare_mode() that says:
> > 
> >   Note that it's currently valid for @type to be 0 if a directory is
> >   created. Filesystems raise that flag individually and we need to check
> >   whether each filesystem can deal with receiving S_IFDIR from the vfs
> >   before we enforce a non-zero type.
> > 
> > This is a bit challenging since there are many filesystems. Claude Opus
> > 4.8 was used to generate the context for each mkdir implementation from
> > which it can be judged whether passing S_IFDIR is safe. The result was
> > then verified by hand by looking at how the mode argument is used in
> > each case. To check whether all mkdir implementations are convered,
> > 'rg "\.mkdir" ' was used and checked against the list of uses Claude
> > found.
> > 
> > The only mkdir implementation that I am not as sure of is
> > cifs_mkdir(). So this goes cc to the cifs people. But of course, I might
> > have made errors in other places (except probably not for the A list as
> > those are all just mode | S_IFDIR cases without other uses of mode
> > besides logging)
> 
> I agree that cifs_mkdir() is not obviously safe.
> I think coda_mkdir() and fuse_mkdir() at also not obviously safe.
> In all three cases the mode, which now has S_IFDIR included, is sent
> unchanged to something outside of Linux - either user-space or over at
> network connection.

You are (of course) right. I missed to mention coda. Also, I missed that
for FUSE inarg.mode = mode; is set, and this is passed, despite the mode
in create_new_entry(idmap, fm, &args, dir, entry, S_IFDIR); being hardwired
to S_IFDIR.

> 
> I think you patch which adds S_IFDIR to mode should mask it back out in
> those three functions.  Then we could be certain it is safe.
> The maintainers of those filesystems might then choose to remove the
> mask if they know it to be safe to do so

That seems like a good idea, agreed.

> 
> Thanks,
> NeilBrown
