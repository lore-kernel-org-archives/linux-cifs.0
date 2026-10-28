Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793231134;
	b=Q+mNqYRzucP//Ag47KL1YAH0WjWN5eRzuRw/UUAxGKT2FvDRFD6aAGZHd6ljwKLJm8Rm
	 jNKfRPuwuc6JhFHL8VJkpHlkORajkzJxfkGC5clU+G95stTyqeqxM8FfIKv+QltLnUVxe
	 V7NQ1yvUSc2KWxsV92CV5caThrbhY3fmyCajUXLKnomkMYctx/atBMC6hbaOaHqDjlgxH
	 4Roe6Q6YB7TEZ9ufg/9kKW/jZR4D85oWGnAJzQr4lDXh0lpv8GMeQBILUvgeXGHkJPP2/
	 ZnH0SI5ZxUwCtFoO1AkSvIusSaAob6sY7cmuYRYnmMAO0NwkOUgsaFVxcE6K9G63UuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793231134;
	h=Received:DKIM-Signature:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 User-Agent;
	bh=WUPH0ksXvw8SPH1x3nCnr5Q8W47Cu9a8DCZlo3sy83Y=;
	b=ElsKfaJRZ/aPdPQU8pWeSk7yf8ZmjuTkjAGTpnSK8KrvxDZu/+aDMhaKO3DKK7a7xTeH
	 DlEjrS5OvM7oZQl1Tih0kORtdNtkeDfJJqCrD1GkRWNLkRqL5LGrO5X33B9oE4uhhNFdw
	 932jmEEsnqYlgf+yKDpd+QUt98jNOuDdLk2lFbZQSzTmUZTCrKcis2Go9O+yvYReDYrDF
	 PZSgTL2w9joSS4NqF69Afb0nQyBG+cY8U9EFtRPwk7Rwbb9QpVt9F4mZTAyVeQDsfATny
	 ePPlv714pk0Wlvz5eqd7r7FsHgIQFWwaUXxnbxBI1cQcH5Fam3ovr+1eLRaJV4H/EgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ak+C9sB4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2F2606A31A;
	Wed, 28 Oct 2026 23:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ak+C9sB4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C1E1F01825;
	Wed, 28 Oct 2026 23:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793231134;
	bh=WUPH0ksXvw8SPH1x3nCnr5Q8W47Cu9a8DCZlo3sy83Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ak+C9sB48Wd8OiZZkJZjeI7c/i40P01YhMG1k2H4rpWKd9Plm9Sb8fZyYnffmz7jL
	 zz6jQFj1j9bF4H90sMbLKMYlRMLsxXDe6hKvUoVogYrAy/j6wrPPuiTDzhCvl9fH/c
	 8y8mOZJ+qp7jYcS5IuaWpvRqkWQ2FxGNye27gOKAc+jbW3vQ5Ds2BUXBbaVRz/gsCs
	 ifYgOMboxK5d9wptzpXBwbc3EKwv8VVTUhO4A7YHK6v15ooUJCaJGSv6UYTpJBpeFD
	 Q7xK8IRx4fshypsL98v+CEMla5xdzNBnXKC+EuHR5YASeEoVDhVRDbVu5Y3PwQwRRM
	 NGW1gJwlTngmw==
Received: by pali.im (Postfix)
	id CCBDE9F5; Thu, 29 Oct 2026 00:45:30 +0100 (CET)
Date: Thu, 29 Oct 2026 00:45:30 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7.3 8/9] cifs: Add support for parsing WSL symlinks in
 version 1 format
Message-ID: <20261028234530.2bnbxbotnegss5ll@pali>
References: <20261026222600.17323-1-pali@kernel.org>
 <20261026222600.17323-9-pali@kernel.org>
 <CAKYAXd-hQXxBLxLQ_dr5omw-_xgL+96fNYfgW_poAihXYqDxmA@mail.gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd-hQXxBLxLQ_dr5omw-_xgL+96fNYfgW_poAihXYqDxmA@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Tuesday 27 October 2026 10:37:45 Namjae Jeon wrote:
...
> > +               oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_READ_DATA,
> > +                                    FILE_OPEN, CREATE_NOT_DIR | OPEN_REPARSE_POINT,
> > +                                    ACL_NO_MODE);
> > +               oparms.fid = &fid;
> Should we pass initialized fid to ->open()? When SMB2/3 leasing is
> enabled, the open path copies fid->lease_key into the outgoing CREATE
> request, potentially disclosing 16 bytes of stale stack data to the
> server ?

I think that I have copied this pattern from somewhere. So maybe the
same issue is in other parts of the code.

> So, how about updating it like this ?
> 
> struct cifs_fid fid = {};
> ...
> if (tcon->ses->server->ops->new_lease_key)
>     tcon->ses->server->ops->new_lease_key(&fid);

I will look at it.

Anyway this series contains various changes and these last two PATCH8
and PATCH9 are not needed for rest of them. So if there is no issue with
PATCH1-7 I would like if we can process at least first 7 without need to
address issues in 8 and 9. I'm waiting for these changes for a longer
time and mostly I'm just resending 1-7 without any modification, just
rebasing them.

> 
> 
> > +               oplock = tcon->ses->server->oplocks ? REQ_OPLOCK : 0;
> > +               rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
> > +               if (rc)
> > +                       goto out;
> > +
> > +               buf_type = CIFS_NO_BUFFER;
> > +               io_parms = (struct cifs_io_parms) {
> > +                       .pid = current->tgid,
> > +                       .tcon = tcon,
> > +                       .offset = 0,
> > +                       .length = symname_utf8_len,
> > +               };
> > +               rc = tcon->ses->server->ops->sync_read(xid, &fid, &io_parms,
> > +                                                      &symname_utf8_len,
> > +                                                      &symname_utf8,
> > +                                                      &buf_type);
> > +               if (!rc && symname_utf8_len != file_size)
> > +                       rc = -EIO;
...
