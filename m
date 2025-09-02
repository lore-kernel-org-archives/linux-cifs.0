Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F141C68F
	for <linux-cifs@vger.kernel.org>; Tue,  2 Sep 2025 19:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756840240; cv=none; b=rY6ygpwDiPrEzVNo79TbgxEgCk8YfVa3U6LNktMuXLXmWmbNYSpxjWfzCmGGrGzAM3t2LjKQxPYMEGTj1hKtoXu79k8CFK0C+zCUyRiQD9Ieh6gN6+jbisBmoQ27laavdea8XKjLpZm8JDjZplTgm21WE8IOS7A2B73tRBIXZaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756840240; c=relaxed/simple;
	bh=XTiSi+WiLk1H4RFnSADN//GIu5KGeqej9UIJ8VObfz0=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=EPr38+tvNl9QfsQa5WAjmH5zruKNnq/GvwD++5gOhffKfdgbCauCWfY32fKLiZOaZEvy5Xi+jvc0Gn/R6mqWmrFeWUEDwEYa8Ntu8BY4zRkfWRXFIBe6NfXqO1LzOaFUA6QlF+9EY3lhomWwSxP3KDmTRM729BFsqRae3MoE48M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=vxWBGmLz; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="vxWBGmLz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=L6/YPyW2RlD6QdniVsq5IxJAZcIeGkKgLfrQs7j/6EU=; b=vxWBGmLz+9NM143o7c6vxKA7tx
	s0EQZr8xA/+Q7jWcsawZeh0180JS/SXVLhBmkKb/iB9+4wkbvPnR7GFvLT+3NdKx9IeROV1igCaym
	4yYcEP2znQhuJKciDr9Z3sS4kUAGr4keYCht7TI7H1dXsXadELmzcxgpy8LJHw6e41RiK2bNBfcg/
	IeWAwfn8zPCLtNsltH2oZtm6DaMerfV0kSUvccPb/D29wfZyM/C2sCbAYharCPw0EHpdPuO3woA4v
	A3R12KmCrqaHXD55Fs8RfFOBBHS9B0MxygOezLsxFn5LqkYUW2xURWjHkqU/X1WkQSl1BypAZehqE
	dMB6I+VA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1utWOq-00000000iGl-2epp;
	Tue, 02 Sep 2025 16:10:36 -0300
Message-ID: <4b026267bc7d48f141b08247a03ec858@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Ralph Boehme <slow@samba.org>, smfrench@gmail.com
Cc: Jean-Baptiste Denis <jbdenis@pasteur.fr>, Frank Sorenson
 <sorenson@redhat.com>, Olga Kornievskaia <okorniev@redhat.com>, Benjamin
 Coddington <bcodding@redhat.com>, Scott Mayhew <smayhew@redhat.com>,
 linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: fix data loss due to broken rename(2)
In-Reply-To: <notmuch-sha1-4fd369d43684b0739d61e9e931e63ca8c7e2a82c>
References: <20250902165451.892165-1-pc@manguebit.org>
 <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
Date: Tue, 02 Sep 2025 16:10:36 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.org> writes:

> We're doing this for SMB1 for a very long time and haven't heard of any
> issues so far.  I've got a "safer" version [1] that does everything a
> single compound request but then implemented this non-compound version
> due to an existing Azure bug that seems to limit the compound in 4
> commands, AFAICT.  Most applications depend on such behavior working,
> which is renaming open files.

[1] https://git.manguebit.org/linux.git/commit/?h=cifs.rename
