Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE3E7DA6C
	for <linux-cifs@vger.kernel.org>; Tue,  8 Oct 2024 18:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728411516; cv=none; b=CkvJBKDmNa2jp9TbTcFH9+79X954lRewbkEB/8buU4j/Ni3B8xQESRo2nnYgSHcYBjGSrG2kQdjg11IktjHppPErg36LTiYFtliw63hMcab20rtbIiJHcUKmSoCVE/Wu5ARO0Z6/qeTOCEpbzCdMeE7o2XfyVP4BEmvCHah4uhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728411516; c=relaxed/simple;
	bh=qp5doVra2RZS9kcEUodfdEzvMDgAgH2182lIdAPv6bs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gbIwfqk6LR9Gmgl0P/AlrygyKV/9wOM5hEi2zT+EQNDW+6XhVKgwQ7LnSp00Qz7ecl0SRqPLFZIPtRtECRKh/lEAS8UBCQG9NZX/eVZapyjYXsiym5f4QUhZyO0uvKLZM+uTAOvt6ydbMeyu795cgvUPiblzoqGSSBYA97I6JtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TPyq1r7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TPyq1r7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D618FC4CEC7;
	Tue,  8 Oct 2024 18:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728411515;
	bh=qp5doVra2RZS9kcEUodfdEzvMDgAgH2182lIdAPv6bs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TPyq1r7FEDq6SixpMOZwwDSR41kojEEccMs363RhfgOgaGoHPM8yYD33955jYjFdS
	 j8n/0AiRc+OlMZnorYafhlBxN/IJc7/DSC0LFQaEKNyZbFX/8esNid9Qeubip2VNj/
	 hoZjJulnAVv267bd4uXo+CbknVabkQscGwaDxXZjkf38sCBUP3NvllFwkJ/Uw1Me5N
	 cJ9STHMLdIoBIafozqR2IX5bss2JzQu70cPqyLv7APXLGkN+1r+1LPs/gprdDf5XtM
	 b74gaPuaqkJ64uTph/l2+xFdVvMZk/218wdRmmdhP2maXBKoJxiMh9K2PIuMKQAeDu
	 kNrTFdIyntjTQ==
Received: by pali.im (Postfix)
	id 80AD882D; Tue,  8 Oct 2024 20:18:27 +0200 (CEST)
Date: Tue, 8 Oct 2024 20:18:27 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Ralph Boehme <slow@samba.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Subject: Re: SMB2 DELETE vs UNLINK
Message-ID: <20241008181827.cgytk5sssatv6gvl@pali>
References: <20241006103127.4f3mix7lhbgqgutg@pali>
 <01f5a207-7dfe-41f4-b2bf-bc38d48053b7@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <01f5a207-7dfe-41f4-b2bf-bc38d48053b7@samba.org>
User-Agent: NeoMutt/20180716

On Tuesday 08 October 2024 11:40:06 Ralph Boehme wrote:
> On 10/6/24 12:31 PM, Pali Rohár wrote:
> > But starting with Windows 10, version 1709, there is support also
> > for UNLINK operation, via class 64 (FileDispositionInformationEx)
> > [1] where is FILE_DISPOSITION_POSIX_SEMANTICS flag [2] which does
> > UNLINK after CLOSE and let file content usable for all other
> > processes. Internally Windows NT kernel moves this file on NTFS from
> > its directory into some hidden are. Which is de-facto same as what
> > is POSIX unlink. There is also class 65 (FileRenameInformationEx)
> > which is allows to issue POSIX rename (unlink the target if it
> > exists).
> 
> interesting. Thanks for pointing these out!
> 
> > What do you think about using & implementing this functionality for
> > the Linux unlink operation? As the class numbers are already
> > reserved and documented, I think that it could make sense to use
> > them also over SMB on POSIX systems.
> 
> for SMB3 POSIX this will be the behaviour on POSIX handles so we don't
> need an on the wire change. This is part of what will become POSIX-FSA.
> 
> > Also there is another flag
> > FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE which can be useful for
> > unlink. It allows to unlink also file which has read-only attribute
> > set. So no need to do that racy (unset-readonly, set-delete-pending,
> > set-read-only) compound on files with more file hardlinks.
> > 
> > I think that this is something which SMB3 POSIX extensions can use
> > and do not have to invent new extensions for the same functionality.
> 
> same here (taking note to remember to add this to the POSIX-FSA and
> check Samba behaviour).
> 
> -slow

So the behavior when the POSIX extension is active would be same as if
every DELETE_ON_CLOSE and every DELETE_PENDING=true requests would set
those new NT flags FILE_DISPOSITION_POSIX_SEMANTICS and
FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE?
