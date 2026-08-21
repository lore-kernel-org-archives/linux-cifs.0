Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E8B35E1B8;
	Fri, 21 Aug 2026 17:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787331845; cv=none; b=X2hzKKzIt8hP8JYkxUii1D6tpxfdWJ3RAt/jB+UZwdbOBvyCb2BTSM/8ArJplFO20KSN6S+/JafMWgEm3o7r7tFIiYHBF7wkH1x5dcUI7JVXY9hKfsRC997S0O4LuUiozfEuY4vQmi94Rpfj+IWAXsfFHgu6qmLGArSQnY16aj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787331845; c=relaxed/simple;
	bh=l9mAFc1i380exrgOBYgZK6jNuPPImMF2IJva41Y9cA0=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=hvHKHDGpjaOp5gtI2ps4l07uvjI7jvdO9RsKqNI9v4f4bYcVk6D5ZwCmdLdvOeOesdGRzVSi+zOTZe3/mK81ry7VqamIAJUIz/x1xZXn7bkfv0bP8YWiVwMiepgEjkAGiah2HYhGyOPFTEm0qohQYoNB5YZmKdX7HG3ib2nJ3zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=SJCn6eCL; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="SJCn6eCL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cHR6qmFlUjQOp934DBy6RRFUDUD8SLV1r9YBiejFCYI=; b=SJCn6eCLTlGwQlBbyPsm7lcwO2
	+q+hhzoXpqjYcm4uJyuUaYYD2TlM3GK4COfyMujfvwsDi+9x7XI4cdd0bwCJqnw7acvVW4uHHDnB1
	Y2lyt8rEnWS2TM5T4jsymPaL/d+UGcIfEvCfryhrxuk8+bp550Ek2yi5giJEpxjsJIO6uM8D+2a9s
	4QDPfGfqPjc/GOK0Z6GUe82hYgkQZZIuLrQlTCwz0U1SbT/fxBtuREYfd0TsNlBWjTqA/uwiAqucG
	okMGDHHmV7S6dGpNAHAc1HXK1zlcvWpyXLC0sUnT3FNYzfqNa2fX/Jqr/Vm5Xj9kkQ2SEGT/ZG8AF
	Fw71aaRw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wxSeu-00000000Php-2Nxw;
	Fri, 21 Aug 2026 14:04:00 -0300
Message-ID: <33b9415f0837a11512011c472f5421cf@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: hexlabsecurity@proton.me, Steve French <sfrench@samba.org>
Cc: linux-kernel@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
 David Howells <dhowells@redhat.com>, samba-technical@lists.samba.org,
 Bharath SM <bharathsm@microsoft.com>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, Tom Talpey
 <tom@talpey.com>
Subject: Re: [PATCH] smb: client: restore the data_offset bound in
 is_valid_oplock_break()
In-Reply-To: <20260728-b4-disp-22baa716-v1-1-f8325242fd13@proton.me>
References: <20260728-b4-disp-22baa716-v1-1-f8325242fd13@proton.me>
Date: Fri, 21 Aug 2026 14:04:00 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
writes:

> From: Bryam Vargas <hexlabsecurity@proton.me>
>
> Commit 83bfbd0bb902 ("cifs: Remove the RFC1002 header from smb_hdr")
> changed the quantity this bound is measured against.  It used to be
> srv->total_read minus the 4-byte RFC1002 preamble that total_read then
> included, so it was the SMB message length.  The same commit stopped
> counting the preamble, and the mechanical substitution to
> srv->total_read - srv->pdu_size left an expression that is identically
> zero: standard_receive3() reads MID_HEADER_SIZE() bytes and then exactly
> pdu_length - MID_HEADER_SIZE() more, adding both to total_read.
>
> len is therefore 0, the subtraction below it wraps, and no __u32
> DataOffset can exceed the result, so the check from commit 097f5863b1a0
> ("cifs: read overflow in is_valid_oplock_break()") no longer rejects
> anything.  Use total_read, which is now the message length on its own.
> ...

Applied.
