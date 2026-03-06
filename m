Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885D22F361F;
	Fri,  6 Mar 2026 22:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772837509; cv=none; b=GF4qvT/pgGMeSZyBF0kH6POA/zDHwhGbo2nstkaT85s7+A8e51nnGfkgQcs5HmQNB771W3iPB9i4LjYqZmYLqIFP2CJc/chykbY+7mrXj9apafXVXRj1XeyU32Srf1bq7HyGDwSIYU64rIgMybMv1D2wcY78Y0vlUSoQE/am9Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772837509; c=relaxed/simple;
	bh=hfl+bV3OYaINBb181OlWuBVLGA4mLAjDJST9Z8GqIAQ=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=SEfPiMiPxunR3D4q5Ygy8mf6GOVE9IRXQcsvL2myHnMEwNNMsDAqPfbQ1K0WJsQxVlHr48d71R/ieAgIfwCS4QyGJcKM7VFmEvcif3xnr7JIg5EYGOM5y18xli/5L20HE08miSBYT+QUXd5Yv0I0GvhSLBy6b1UKywuHSzlieWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=bODiCCTS; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="bODiCCTS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3hSzwavHB6NZKvEKnt5LxFHBFnS5kUFqttrSiKePW6w=; b=bODiCCTSg/exLPqIvHDXMc+i+f
	gkcQvy8jlD5lkbnZKJK6M8L9G9vE70M2CJM16oYMuc1jbLIabmmHaDzWuS7wB1YK183GmoT13baNL
	vc5CFIYlH/NG8GOfkDqz2YmyCzEGs/pg7HOD34FLJcW2mZ7c0F22k0Z/yDyLIpoH5zmjyqhXqPGE3
	TDM1Hl0g6xS4CDeLwXeVJw8qm+EIwR24bw86z/40Xb70ueEgfWDhLl3+K4O38JjMZCI8u1fOFEYxT
	UwH0PO2XCQtQMfgc6b5bL1SfPr/5hnqwiM+iuhQAn1EaipD8V+ChsRwV7llTaR+eNidoYHNr1UkKf
	12EMQexA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1vye1J-00000000PGC-0Wqp;
	Fri, 06 Mar 2026 19:51:45 -0300
Message-ID: <353be345dcf906816d61e127583032d2@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: smfrench@gmail.com, Thiago Becker <tbecker@redhat.com>, David Howells
 <dhowells@redhat.com>, linux-cifs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix oops due to uninitialised var in
 smb2_unlink()
In-Reply-To: <r7ojhnxu3jkr42oczp2o5w3hp5bs24ft5yav6nnlcohsybqeuv@zjvwndvvxayc>
References: <20260306005706.830672-1-pc@manguebit.org>
 <r7ojhnxu3jkr42oczp2o5w3hp5bs24ft5yav6nnlcohsybqeuv@zjvwndvvxayc>
Date: Fri, 06 Mar 2026 19:51:44 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Henrique Carvalho <henrique.carvalho@suse.com> writes:

> Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>
>
> We got a lot of those replay uninitialised bugs. Maybe we should prevent
> them by having a replay(func, cond) so we can take advantage of a clean
> stack. Opinions?

Agreed.  No strong opinions.  I'm wondering if that should be
implemented in the transport layer, therefore we could get rid of all
that duplicate code.  Alternatively, having the thing implemented in
netfslib instead.
