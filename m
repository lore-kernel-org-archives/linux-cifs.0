Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D962E370D5A;
	Fri, 12 Jun 2026 12:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781266746; cv=none; b=nEYomwO3rqcCMVpAcCdGcGfMRdxctO01n4eUS1Acv1hWEP/ajL2AigVFl+F7cCGU8HgwD7iDutz5FROg/1EQ5JmMejizwlp2R67eVAvr8YuY5Sz6mf/DY97dUHQ8MXO+1wU++QGz9Ru7a3ij0oo+q6Q4UJPCF6OKxO6435o0TsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781266746; c=relaxed/simple;
	bh=1l0rFnrX25bcDADvh/n7RyDXM2YgvNap+9EAAx8Lnek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VyoHAv+F1JvxawQ9YTF79fLKKaW5jUvQURYOTmFNif5j/NDfMzj4PBmnoKA/shPUrrURLceTZEjIx05iUZ2w1ecKE1EJKMtRXhCN5NEdZic1sYMwItXVQA56fDe1yDQkb76wtkSMOSQaKU4yuAdZdgk9xstvktNKQlZMTC9cEfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gsDTO58D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gsDTO58D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C3A1F00A3A;
	Fri, 12 Jun 2026 12:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781266745;
	bh=vYtOrK4Dq5zpikk3Pl2z6fn8G44xM4GUjAwqmUordCw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gsDTO58DU87H5WHkJ9FoT+wX00LrkGXxk9DoEaAyu/VRjyDm+BV+EURNQfgLQmeAQ
	 dwNJfjTAFztIf4sbCFgmovQP7WSseN5HOBRA9qg2qaI05MORk7ZnCmm2VTaCJnuu1m
	 bzof0i3eByH3T2eBLmnv9KI6F7ygHzrV13C53j+2MRsDIcMKvGSSAG0EZit9DKmMdn
	 e3rVSF8TGrTQVT+1yG6P4LsaErI7doknqKPS4kbHMBD9m7QFr74SIdPd+9xbO96ozi
	 623Ncg0KemwHgPAhmUXy/BYegOumfTuOzR5FOdWveO1CHVSLi1n2J9MwioTavVbrAU
	 2OKiVTtY1v04w==
Date: Fri, 12 Jun 2026 14:19:00 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Jori Koolstra <jkoolstra@xs4all.nl>, Steve French <sfrench@samba.org>, 
	Steve French <smfrench@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, NeilBrown <neil@brown.name>, 
	Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/1] vfs: pass S_IFDIR mode to vfs_prepare_mode()
Message-ID: <20260612-sturz-infizieren-heckscheibe-76f3ed250ea8@brauner>
References: <20260611145733.43776-1-jkoolstra@xs4all.nl>
 <7iocwlr7jg2jiyx53q7lxaccrybu6fpv6ch36u64igdmddafdk@3ejeqvr4e7rh>
 <987538907.1434294.1781209240897@kpc.webmail.kpnmail.nl>
 <vt6zmgnwz3n5jc3opm5i3bckkocfmzcysrbivbin52nudayus5@5stfgorwnob7>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <vt6zmgnwz3n5jc3opm5i3bckkocfmzcysrbivbin52nudayus5@5stfgorwnob7>

On Fri, Jun 12, 2026 at 12:33:53PM +0200, Jan Kara wrote:
> On Thu 11-06-26 22:20:40, Jori Koolstra wrote:
> > Hi Jan,
> > 
> > > Op 11-06-2026 17:33 CEST schreef Jan Kara <jack@suse.cz>:
> > > 
> > > For the filesystems I know this looks sound. Thanks for the cleanup. But
> > > this series should then follow with the removal of now-pointless "|
> > > S_IFDIR" statements.
> > > 
> > 
> > Right, perhaps it should. But wouldn't that be too much churn? I know Al can
> > really be on the brake sometimes with regards to that. But it isn't a lot of
> > effort, so I am fine with it.
> 
> I agree it will be more churn but leaving the now-pointless | S_IFDIR in
> the filesystems is confusing for code readers which isn't good either. So
> at least for filesystems I maintain I would like that cleanup to be done.

Jan is (as usual) right.
