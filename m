Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7725A19D881;
	Sun,  1 Dec 2024 12:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733056664; cv=none; b=EQMP/rjo+SJlUT1ORWscSsjFDUkVjSAtS/M50pWiEnR9coUSWRT8lm16PyK/dSEJRioavkC24OjNREh7f1G7sVw7TUErWiKOOmj4zRnz+LypXKSX+k6b6+hHCKfv+VVx2FzWYo9zuqst1sughitLfW9jEer8g2ikj3X8RQ0/FSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733056664; c=relaxed/simple;
	bh=SyhOwGg/tG1tw43QpvwtWWOKCOtYIrnX4vFWv77DiZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BzXpght1wli7u72P1sKMLc1XUcwaDlxB4HAmc4riHBaNqpo4Qi4L+78ZcjicukGCKMFlN/t12vYVpumZoBdU6ILVLHYnv/9QLIZCUenMPJz7v4WNm9B9KY8DWbtbzbgV0TByE7/MUYBrq5tRk2mc0sQIpGfGHPPJr+BlvNe9hlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nZfRzKFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZfRzKFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38131C4CECF;
	Sun,  1 Dec 2024 12:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733056664;
	bh=SyhOwGg/tG1tw43QpvwtWWOKCOtYIrnX4vFWv77DiZw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nZfRzKFOl6946UqcK4qI2xcllOm+RTFnaBQI3WazDccMOLQmHW19tX0iTNPt1KoH2
	 gTio/6hsoiO4l8Z5BYO05gJDq3kqUDqSZWVQximP0rgoiIgimXMMZsFi06uZT3eMuD
	 9Bt20YuFFpL7naoPfL/XnNreSauJb43JqNelPQU1bj1TH5E4KIn1He8lyzmNsNfoHp
	 eI828BJP202+6r7KkxUbxZBqfZbyM6p1+zntRGGnIk3jZU12JdV/v5jZgnqHOR4DTM
	 yPO9kIKnx2Ml6qTtMqlhpke7tdzDcF6VNOu4NS14/DTvc07P/O0qAF6W5nTXirt8QD
	 1XyFu9vErZNbQ==
Received: by pali.im (Postfix)
	id 518A075F; Sun,  1 Dec 2024 13:37:35 +0100 (CET)
Date: Sun, 1 Dec 2024 13:37:35 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Mahmoud Adam <mngyadam@amazon.com>
Cc: gregkh@linuxfoundation.org, stfrench@microsoft.com,
	stable@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix buffer overflow when parsing NFS reparse points
Message-ID: <20241201123735.ssqp4v6q57ygmxt5@pali>
References: <20241122134410.124563-1-mngyadam@amazon.com>
 <20241123122050.23euwjcjsuqwiodx@pali>
 <lrkyqmshny9qt.fsf@dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <lrkyqmshny9qt.fsf@dev-dsk-mngyadam-1c-a2602c62.eu-west-1.amazon.com>
User-Agent: NeoMutt/20180716

On Monday 25 November 2024 09:54:02 Mahmoud Adam wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > On Friday 22 November 2024 14:44:10 Mahmoud Adam wrote:
> >> From: Pali Rohár <pali@kernel.org>
> >> 
> >> upstream e2a8910af01653c1c268984855629d71fb81f404 commit.
> >> 
> >> ReparseDataLength is sum of the InodeType size and DataBuffer size.
> >> So to get DataBuffer size it is needed to subtract InodeType's size from
> >> ReparseDataLength.
> >> 
> >> Function cifs_strndup_from_utf16() is currentlly accessing buf->DataBuffer
> >> at position after the end of the buffer because it does not subtract
> >> InodeType size from the length. Fix this problem and correctly subtract
> >> variable len.
> >> 
> >> Member InodeType is present only when reparse buffer is large enough. Check
> >> for ReparseDataLength before accessing InodeType to prevent another invalid
> >> memory access.
> >> 
> >> Major and minor rdev values are present also only when reparse buffer is
> >> large enough. Check for reparse buffer size before calling reparse_mkdev().
> >> 
> >> Fixes: d5ecebc4900d ("smb3: Allow query of symlinks stored as reparse points")
> >> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> >> Signed-off-by: Pali Rohár <pali@kernel.org>
> >> Signed-off-by: Steve French <stfrench@microsoft.com>
> >> [use variable name symlink_buf, the other buf->InodeType accesses are
> >> not used in current version so skip]
> >> Signed-off-by: Mahmoud Adam <mngyadam@amazon.com>
> >> ---
> >> This fixes CVE-2024-49996, and applies cleanly on 5.4->6.1, 6.6 and
> >> later already has the fix.
> >
> > Interesting... I have not know that there is CVE number for this issue.
> > Have you asked for assigning CVE number? Or was it there before?
> >
> Nope, It was assigned a CVE here:
>  https://lore.kernel.org/all/2024102138-CVE-2024-49996-0d29@gregkh/
> 
> -MNAdam

I did not know that somebody already assigned it there.
It would be nice in future to inform people involved in the change about
assigning CVE number for the change.
