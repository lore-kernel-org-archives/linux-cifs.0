Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE173A1A35
	for <linux-cifs@vger.kernel.org>; Tue,  6 Oct 2026 20:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791317603; cv=none; b=riD50Q3chV5dDlOAW5IqTplFDn4zH28/5/sXN6A0OX4MUrQfYdub+xexHSdFFnlPHxgkNx556b7MWNEOC8dAoaPspUjMVTVfZ7SWrv21NOnU248OaYg9KSUBDzm9thuGe5klOvnmjrCAqd+Np84xjK4rZGBAEaFWqA/7b+V15s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791317603; c=relaxed/simple;
	bh=pXdBA2owy/s7lJd+pmuSV/qWXIh+rPtOwhDKsHy9DrE=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=hwWtnw9mozFSxw/dqg9plXk332J/grR2tPJ/nVxb/4LqnXRIRByWxE9lExaUzpR1ve6hZDtTfalQ5bmvueaDDjPvBdwCXn22dbM06v4N5p+z2Wi2tYCt6ek7wrWeQIB77HXq15xUz4MwKDq+whv5WfnVu6V/XsilV+Bd3IDM57U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Ec4IYo3Y; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Ec4IYo3Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sIeUIQ1uFLkLx7vtXK0m/1a6EpgvoAj8FITuPM3F+6s=; b=Ec4IYo3YEm5pC1bKc9rc9zx5+n
	m040msSI3teIXqEJIddF5jqLvJXWa6a1Ly+8883e7DHn9t0/itNbVMTypwZuvtDEOQ7Y43gGBk811
	Fg621k7Z6790OLSeImWAzwawTh/8NzqcY69QvxvzR0N31voXilBTd/sMmz+xr9Lr4ijmCzpm6Xel0
	qf1fWGJ42HGFYHPUhFbMGsKfH0d/y6XZGVrhYTkFJF5A8njSnsIvOqjqX9GK3pVOdcD1c6EPh8e5I
	uyBpgrhumQa0R97qmHsq8r3Gy69UXXyY3D0SdGe7xXH+5k7hlATh+eI5SYjvAKBD6Hpe8KmyiCq0p
	k8UPxcBA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xEBXM-000000033Tr-0v9u;
	Tue, 06 Oct 2026 17:13:20 -0300
Message-ID: <b55d16b6a32d5bf148b0bddd3b4a2db4@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
Cc: Tom Talpey <tom@talpey.com>, Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: [PATCH 0/5] smb: client: don't use server->smbd_conn without a
 reference or lock
In-Reply-To: <1111a3da-3eb7-44e0-8c68-4a09bb4615a1@samba.org>
References: <cover.1791225453.git.metze@samba.org>
 <1111a3da-3eb7-44e0-8c68-4a09bb4615a1@samba.org>
Date: Tue, 06 Oct 2026 17:13:19 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Stefan Metzmacher <metze@samba.org> writes:

> I'll address these https://sashiko.dev/#/patchset/cover.1791225453.git.metze%40samba.org
> and resubmit v2 later...

Sounds good.  Thanks for the fixes.

Looking forward to seeing the test results from Tom.
