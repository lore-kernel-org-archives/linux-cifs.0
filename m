Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE36F36308E;
	Tue, 25 Aug 2026 20:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787689580; cv=none; b=Wv4ou8n0ihPE0Q/wNTUZ8zw5iWNpx4C4biIG47Nj7JNuPKtlKB6wBTpUAIEkA9/Ke10JQ5Jns0/wzIrGbGF6O2l6ErXIJCgeHty/7NZrYZdhwBXDU71osRxNPyny1tdsYoVtn7WSWVA2nCoNJA0CtLJ8bsUZQxZLFiuB948KXuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787689580; c=relaxed/simple;
	bh=reKvN9qhJPoczuCPFJOgh7Pr8UwQor27cVeyyQvVoIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nGNykhEdBGAVtd6iu1g/sIW1cF4yTCVTZashv75FAMJfA+t5PgTRVqPVonyn/XaMz+sZcBqxsftldFgW4Qh5IxgtrbKRCkZue6ImFevbpUnGKOmV0q8/CQTTxqWh5IHDS378tifcCxgnlsDd46RR3NQEAu1ZXVNuV2Na/+P9oAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LazKZzYY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LazKZzYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9CD1F000E9;
	Tue, 25 Aug 2026 20:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787689579;
	bh=4Z7Lgl7eF8IotZCDfpZ3DELD/+DIA66u/q5aTmilq7A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LazKZzYYYY0EZgLwtXWmXWDkNeOSHUBxa8SY04t1KYcOJTHQAuOR1DSE6iNaulLXN
	 3yGtSv0TA3csfkFVPFQsRSmZKy4tOAAOyB3TfJvESAEvUBQE6FV8greztLn+iRwpp6
	 8qmpYlY3kvFBVi0R+QmIfM23UaNv2qgM4mUXQoK1FCRVjthOtKUqbyKrX4/t07G5Os
	 4loH0AwxSfpzfPC4ORdBdLb9pkA8ijsbBaVMO6l+rFwRpMa6ycWSxeQdQYzrGbCRLN
	 JlBk/ibJZb+RlDWaoEdy7JjhoPgl3V1h2ctm1JkTkct+UjqaP8/fatUeJ+bqKw2nrT
	 HuPHPNKpjJREg==
Received: by pali.im (Postfix)
	id 071D64EE; Tue, 25 Aug 2026 22:26:18 +0200 (CEST)
Date: Tue, 25 Aug 2026 22:26:18 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 00/11] cifs: Various changes
Message-ID: <20260825202618.jspdleye55tlliab@pali>
References: <20260706184819.22124-1-pali@kernel.org>
 <20260821214722.q7rkflclyyugdxll@pali>
 <CAKYAXd-pq4SXp4252h8tM7WO0ARRzMgpHs==N=30snzfO-JzCw@mail.gmail.com>
 <20260822133112.s3qd7z7u4m7xfv5n@pali>
 <29dba9c0231e36829219259338bfa18c@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <29dba9c0231e36829219259338bfa18c@manguebit.org>
User-Agent: NeoMutt/20180716

On Monday 24 August 2026 19:45:39 Paulo Alcantara wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > On Saturday 22 August 2026 22:28:26 Namjae Jeon wrote:
> >> On Sat, Aug 22, 2026 at 6:47 AM Pali Rohár <pali@kernel.org> wrote:
> >> >
> >> > Hello, could you look at other of changes in these series?
> >> > Steve already merged few of them and others I have rebased (cleanly) on
> >> > top of v7.2 release and pushed to my cifs branch:
> >> > https://git.kernel.org/pub/scm/linux/kernel/git/pali/linux.git/log/?h=cifs
> >> Okay, I will check them. BTW, Do you know why Steve only picked a few patches?
> >
> > It was late -rc cycle and I wrote to Steve that all changes could wait
> > for next merge window.
> 
> Steve asked me to review the remaining patches while ago and I didn't
> have time to do so.
> 
> Please rebase it against #cifs-next and then resend.

I tried to fetch cifs-next from the new git repo specified in
MAINTAINERS file but it is failing...

$ git fetch https://git.manguebit.org/linux.git cifs-next
fatal: unable to access 'https://git.manguebit.org/linux.git/': Failed to connect to git.manguebit.org port 443: Connection refused

I tried it many times but I'm getting still same error.

Do you have some other mirror of the cifs-next branch from which I can fetch?

Or... is not the rebase on top of the v7.2 tag sufficient?
Because I have already did that rebase pm v7.2.
