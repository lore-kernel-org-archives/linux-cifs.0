Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8A4335062
	for <linux-cifs@vger.kernel.org>; Mon,  1 Dec 2025 17:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764610544; cv=none; b=aU18tzL+NXHSl3FjCR+EBITrADPS5bCgweBtzcnzUEr2sovugP2dr1U5OhrTE6KqmbAZLw+mt7HbvPeUpt8d4m1lbSBenq33ZTL9I1bWhELSsR3k79qNtxFHuMj1ijB8H/G8+oqD9yp5dpPns1BMZt+p+OUuWeocQZjw9QPjoF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764610544; c=relaxed/simple;
	bh=eitB0Ewc0MdOVk+VVEbumRbVjIswfqxxBLxqowWkvFI=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=hStFF8H06DUxiKKcaQ58DKOvuwR1JJ7x1ma4DUCQ6QO6evo4s5pkCPYVgVmYbyYGNUdanfYgpaakriJSjgRS7QXrkgBHdEQ3fgZK0navMIAh5vw2ol25LNumnFslxau2iNu9jEeuXT/wGussXP8f9S1NpUijVloQa9mJ8mekNhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=1+d6EWgd; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="1+d6EWgd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eitB0Ewc0MdOVk+VVEbumRbVjIswfqxxBLxqowWkvFI=; b=1+d6EWgdBdq5wtk2wq5c1WnC7Z
	WMEqLdvqnqS4QlHIB9q9yA0m4dWBkD/tA/zA7+umKgo9vbl6JRlN6qB2+KkC7dHgCAbGsL0FTx6xs
	XVYnYuy3qb5fVi7c0jhjSltukZ1o2W7a7pz1lNJvqReLvoexPe0vjrzcmaZrC28Dfco/UfbjZvDbg
	steCnX4yilMvnG/PjcxT3c4IQEy+yk+EYWcJKc15khm2Y8ScL8dlZ02fuq/C7SzntS+IA0dbwi3VR
	LPjTBA+nuO8E31Ujjfg7Yvojg6NneQWyoxBHnxhz28jPv4eZkGOSbgnnqswp7Z4yR5tD1er86/jLJ
	TEuqCecQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99)
	id 1vQ7oE-000000003sT-1V72;
	Mon, 01 Dec 2025 14:35:34 -0300
Message-ID: <e9903fcc981492ca3474c0d95c734f02@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Pavel Shilovsky <piastryyy@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Xiaoli Feng <xifeng@redhat.com>, Jay
 Shin <jaeshin@redhat.com>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifscreds: fix parsing of commands and parameters
In-Reply-To: <CAKywueTatO7NNZ=020B27vFCLvA1yb0rsWGMgnB8PKV2-Pb=oQ@mail.gmail.com>
References: <20251125195541.1701938-1-pc@manguebit.org>
 <CAH2r5mutuLO4s6azh8g7D6Xs286mW_NyptEkF_6X3Uy4kY=FBw@mail.gmail.com>
 <615273d4ee88f4414d859e3e06d2afdd@manguebit.org>
 <CAKywueTatO7NNZ=020B27vFCLvA1yb0rsWGMgnB8PKV2-Pb=oQ@mail.gmail.com>
Date: Mon, 01 Dec 2025 14:35:34 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Pavel Shilovsky <piastryyy@gmail.com> writes:

> Is the fix urgent enough to make a release?

Yes.
