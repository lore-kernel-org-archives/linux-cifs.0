Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144B01946C8
	for <linux-cifs@vger.kernel.org>; Thu, 30 Jan 2025 21:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738272037; cv=none; b=ki4HmqWyA8i3xuA7WDHXRhwhKbJb9vM9camXdyTJxGeb6zpCj4xVSIo+ovfhhtF8DuACA+KsyVPEj3DmWZ6aHenaBAmIAMiEzA1qt2CuY7SYxySD1kgkirninhSwZG6MEEen48X/wLkrZCQAKWI1ulSZoQsbI4kvZiKQ4TTMyts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738272037; c=relaxed/simple;
	bh=HBknriVBy+aKEfI6Hby2whkwYeMRT9LYebw6zdxQF4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KItRLkI0pwpjtFmEQvtyZUtOdauTCh4Ea2izLF2BautFRykh0ujVJrUGchzBQtV/4Xvq31ZRRAYRMTqHe4fPK14ZuEHLRxUT3Sye38mQ9yGxG59OuYvXQd4uLZCac2xvo3FW7oE8u0eOOaNI/gox69gK7mUoLxjN7y91dzdGCHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q9avWksE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q9avWksE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59451C4CED2;
	Thu, 30 Jan 2025 21:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738272036;
	bh=HBknriVBy+aKEfI6Hby2whkwYeMRT9LYebw6zdxQF4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q9avWksET8RwRkGR7cdghm4N1dp3YRiqmPKNkL0h0j39Zor/hRJR8dbVq10/0FcEA
	 Q3jRHnbvU/EtvmjRZIv0VXkS8jGe8C3OKFqPHbQH9WxqKtVfBlm/1FS2eGiqKWtiVZ
	 zja+Ueh9t0d6YFBfgx8XRoFTBONHMt5dDRJl8JS2fEOt0WMVWIh3sY435XCBfcqhXR
	 5ZhADYaaaf77pS13+ZZqss1RDoEMOT8GlKfadzRQmo+SVCm74sXA9iMWyw7hwBRT5s
	 Qv5IeOTueKh0D/lIdD6X+KCGl25sKwGhh8sTqh/Ig7Ko1j+ZP3cGKhPKtO9/v0tXkj
	 0A/GUxMPjo4gA==
Received: by pali.im (Postfix)
	id 1B2F5559; Thu, 30 Jan 2025 22:20:25 +0100 (CET)
Date: Thu, 30 Jan 2025 22:20:24 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@manguebit.com>
Subject: Re: parse_reparse_point confusing function name
Message-ID: <20250130212024.wthp4zsstbqmaqj4@pali>
References: <CAH2r5mvdyi_6OZQ69z5zhiNapJZ778K_ZraY9dVpmAjgr7czSw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mvdyi_6OZQ69z5zhiNapJZ778K_ZraY9dVpmAjgr7czSw@mail.gmail.com>
User-Agent: NeoMutt/20180716

Feel free to change function name. I think that it is always a good idea
to use different names for different things. Just inventing correct or
better name is hard...

On Wednesday 29 January 2025 16:23:38 Steve French wrote:
> Any thoughts on whether the use of two different parse_reparse_point()
> functions with the same name is confusing?  Should we change the name
> of one of them?
> 
> in fs/smb/client/cifsproto.h there is one parse_reparse_point() declaration:
> 
> int parse_reparse_point(struct reparse_data_buffer *buf,
>                         u32 plen, struct cifs_sb_info *cifs_sb,
>                         const char *full_path,
>                         struct cifs_open_info_data *data);
> 
> 
> And in fs/smb/client/cifsglob.h there is a different one;
> smb_version_operation --> parse_reparse_point()
> 
>         int (*parse_reparse_point)(struct cifs_sb_info *cifs_sb,
>                                    const char *full_path,
>                                    struct kvec *rsp_iov,
>                                    struct cifs_open_info_data *data);
> 
> 
> /smb3-kernel$ git grep parse_reparse_point
> fs/smb/client/cifsglob.h:       int (*parse_reparse_point)(struct
> cifs_sb_info *cifs_sb,
> fs/smb/client/cifsproto.h:int parse_reparse_point(struct
> reparse_data_buffer *buf,
> fs/smb/client/inode.c:          } else if (iov &&
> server->ops->parse_reparse_point) {
> fs/smb/client/inode.c:                  rc =
> server->ops->parse_reparse_point(cifs_sb,
> fs/smb/client/reparse.c:int parse_reparse_point(struct reparse_data_buffer *buf,
> fs/smb/client/reparse.c:int smb2_parse_reparse_point(struct
> cifs_sb_info *cifs_sb,
> fs/smb/client/reparse.c:        return parse_reparse_point(buf, plen,
> cifs_sb, full_path, data);
> fs/smb/client/reparse.h:int smb2_parse_reparse_point(struct
> cifs_sb_info *cifs_sb,
> fs/smb/client/smb1ops.c:static int cifs_parse_reparse_point(struct
> cifs_sb_info *cifs_sb,
> fs/smb/client/smb1ops.c:        return parse_reparse_point(buf, plen,
> cifs_sb, full_path, data);
> fs/smb/client/smb1ops.c:        .parse_reparse_point = cifs_parse_reparse_point,
> fs/smb/client/smb2ops.c:        .parse_reparse_point = smb2_parse_reparse_point,
> fs/smb/client/smb2ops.c:        .parse_reparse_point = smb2_parse_reparse_point,
> fs/smb/client/smb2ops.c:        .parse_reparse_point = smb2_parse_reparse_point,
> fs/smb/client/smb2ops.c:        .parse_reparse_point = smb2_parse_reparse_point,
> 
> 
> -- 
> Thanks,
> 
> Steve
