Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2540B1F09A5;
	Tue,  7 Apr 2026 03:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775531001; cv=none; b=X+MXZ+4YG/csciayx71SRqPhUOAJWg0y+qhT3K26rp0ENnWQ//MVmuDquqrHLtVqznWI5lB+tR2HpE5TWlBCpcQZw7aNz724G9sRs6L39yGz8xUuO2/D0KN70HTIVhh6JvgFt/Sq+VfmBE8fQAWCdkFMck9XBBUVEFrcfUFL30Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775531001; c=relaxed/simple;
	bh=5VC3SXNJMBDbofTVHru/ld2xz/AXNeBtVaPZyx+4+1c=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=b8KIlRWhKcgqas+pCzhemmjOSH8NxKa1ZFL+2S2pfLm+JGhqagGi6OuyFagKbqpsiQD3gx81zA3UxdR9zzdCobjIJVZYp/qrCfS0/CQyYIyDi6tBF4CmYmBtnbvHD+MnolCrYRIKBjSLoNxLdL6jqds1FPN5r6yJokvm16EnW2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=8EiHIFsH; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="8EiHIFsH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=t4n1bX7/fTIqNg1EppRsTrm+a/ZsF9A+tAQe1d5H31U=; b=8EiHIFsH4xnFyJfTk6ApOV24dJ
	Qt3yNDsmeoZtFTap5tZ/Lr0fVd7DlDJ+mDTX7XrUmi6b49Fo7JI/oo9gP80lCddFtsKyb8FXTiWqX
	sGxsMfOoSo2ef0jGPTRNmTR8Swd/4qQroDq//8GLKR3rSrFE6rixi6nu3d6I4ZM+TzpnONLvnvrFq
	3xoOM7i7GylqKEGQeWqw9l3E+HtZAyPl/KEXirCzN3BszBwQ4ZkmtWh6+e49lprD6CYPIpMR8UkWJ
	aRHSqQHmfQ8xKoKUacDlKanLH6KVksPStn5/3128PfT6ibKJgSWiRs1Tj5i19rNYnGcsh/6c+PpWy
	OdmTQx9w==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w9wig-00000002KJt-3klJ;
	Tue, 07 Apr 2026 00:03:14 -0300
Message-ID: <e50b019e071d66509cc24f98c7900fee@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Steve French <sfrench@samba.org>, Ronnie
 Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>
Subject: Re: [PATCH 0/2] smb: some potential bugfixes
In-Reply-To: <2026040635-banking-unsoiled-3250@gregkh>
References: <2026040635-banking-unsoiled-3250@gregkh>
Date: Tue, 07 Apr 2026 00:03:14 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> I spent the time exercising some new fuzzing tools on the ksmbd and smb
> code purely because it's something that is simple to set up and test
> locally with virtual machines, and in doing so, potentially found some
> minor problems for when you have an "untrusted" client.
>
> Here's some fixes for what I happened to notice.  They pass my very
> limited testing here, but please don't trust them at all and verify that
> I'm not just making this all up before accepting them.

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
