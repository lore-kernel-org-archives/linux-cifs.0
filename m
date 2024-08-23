Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30208185922
	for <linux-cifs@vger.kernel.org>; Fri, 23 Aug 2024 13:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419278; cv=none; b=aDq4T5jPPHtNNpzToForBzHiteO5T94JUXt96HQWFBcxVh64XYuZjQ0whZWMSEZKHJ1CH5fYZweGYaTUuuxEB3r7KhiUYDFw9Q3PR2gzIbp1qxkzhlu3xkKKrYtqEqRqBkgpZ/x+v8Guop9snQLRdJN5d4BflUsLssR5SuBjTJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419278; c=relaxed/simple;
	bh=kMji99mxnlYVIYYmZlllvfZ4PYLb0gU2oguSU8Y79Eo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s9Okae/aW51B853CKFuiIrTc6yyshx3N9qWUWcn/Fl4wB/dgHn3GFTUShREnuYYBL91upkhxEgbFdcP5YG3otd/PR7ju4nDPmQvvIoGVEM2WzzX/ohL03UU2FZWep+QAulF7D9WL7WNI5cAk2oqmbOdDA+C9uz2UtvM6oEQX8es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=1Z0YEVmG; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="1Z0YEVmG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=YqubPSbosPV5jgGnAgJ2amswF0hQKABp49RdOjYClVM=; b=1Z0YEVmGV7ty1nYuic+HgOcKqJ
	je2ZyY/eAc4pCsFRlQtO5rJRIwzpjpK4Xzc1jI42Ontp0XSeS9BKef1WrxThXQDiSxoeT00HrpZpJ
	070mbzc03+qPWfLNvQ8Qc2lMBKer5jpLdB8tmclj16a+QOgInP63VISi8acmBw6D7orLnASGHQfeR
	YlSnT/kzc0xxdc/DpbNnynyrbu5QUVu45FjPAZiWY5uRbEmCDyK+aqsWiJW3HuEugOrwvgC+fVtre
	2/5lbxivK6wCZKMvBO1RRao64lCYM+8OCIuQgIIg2DprxieMl3qi7NylyFpbAlNIWEqFuZOeMUfnH
	r57eQ1odXUTL8lEQZraLdVP73+O9mqRrbZc0T+7DcdMzm9gqFVUcJCa9+CVd22dAcgzAYC+7EZvgJ
	L0ayzOHTQ29ha0sbJrgdHIulOtBirMy0pHiksn8Aif0ns+OBPic8Pusi0cHEEXG3FWpVvCbqGrZ69
	39mYHG2ymGbjJ/Daz6tJ8Qcw;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1shUDw-007ojn-2h;
	Fri, 23 Aug 2024 13:21:05 +0000
Date: Fri, 23 Aug 2024 13:20:52 +0000
From: David Disseldorp <ddiss@samba.org>
To: David Howells <dhowells@redhat.com>
Cc: Jeremy Allison <jra@samba.org>, Paulo Alcantara <pc@manguebit.com>, Tom
 Talpey <tom@talpey.com>, ronnie sahlberg <ronniesahlberg@gmail.com>, David
 Howells via samba-technical <samba-technical@lists.samba.org>, Steve French
 <sfrench@samba.org>, linux-cifs@vger.kernel.org
Subject: Re: Bug in Samba's implementation of FSCTL_QUERY_ALLOCATED_RANGES?
Message-ID: <20240823132052.3f591f2f.ddiss@samba.org>
In-Reply-To: <319947.1724365560@warthog.procyon.org.uk>
References: <Zk/ID+Ma3rlbCM1e@jeremy-HP-Z840-Workstation>
	<CAN05THTB+7B0W8fbe_KPkF0C1eKfi_sPWYyuBVDrjQVbufN8Jg@mail.gmail.com>
	<20240522185305.69e04dab@echidna>
	<349671.1716335639@warthog.procyon.org.uk>
	<370800.1716374185@warthog.procyon.org.uk>
	<20240523145420.5bf49110@echidna>
	<CAN05THRuP4_7FvOOrTxHcZXC4dWjjqStRLqS7G_iCAwU5MUNwQ@mail.gmail.com>
	<476489.1716445261@warthog.procyon.org.uk>
	<477167.1716446208@warthog.procyon.org.uk>
	<6ea739f6-640a-4f13-a9a9-d41538be9111@talpey.com>
	<af49124840aa5960107772673f807f88@manguebit.com>
	<319947.1724365560@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Thanks for the follow up ping...

On Thu, 22 Aug 2024 23:26:00 +0100, David Howells wrote:

> >         if (out_output->length > in_max_output) {
> >                 DEBUG(2, ("QAR output len %lu exceeds max %lu\n",
> >                           (unsigned long)out_output->length,
> >                           (unsigned long)in_max_output));
> >                 data_blob_free(out_output);
> >                 return NT_STATUS_BUFFER_TOO_SMALL;
> >         }
> > 
> > I'm guessing in this case we need to just truncate out_output->length
> > to in_max_output and return STATUS_BUFFER_OVERFLOW.  
> 
> Do you perchance have a fix for this?  I'm seeing it cause failures in
> xfstests when running against cifs connected to samba.

I've proposed a fix via
https://gitlab.com/samba-team/samba/-/merge_requests/3775

If you want to try it yourself...

The following changes since commit b0996ed589a931902a304237d6c03efce2b16f6b:

  s3:tests: Fix spelling error (2024-08-22 10:38:09 +0000)

are available in the Git repository at:

  https://gitlab.com/ddiss/samba.git qar_rsp_truncation

for you to fetch changes up to 3c034c4d177ea2367b3131f813381d91c98ab7e1:

  s4:torture/smb2: test FSCTL_QUERY_ALLOCATED_RANGES truncation (2024-08-23 13:06:04 +0000)

----------------------------------------------------------------
David Disseldorp (2):
      smb2_ioctl: truncate FSCTL_QUERY_ALLOCATED_RANGES responses
      s4:torture/smb2: test FSCTL_QUERY_ALLOCATED_RANGES truncation

 source3/smbd/smb2_ioctl.c         |   4 +-
 source3/smbd/smb2_ioctl_filesys.c |  54 ++++++++------
 source4/libcli/smb2/ioctl.c       |   3 +-
 source4/torture/smb2/ioctl.c      | 150 +++++++++++++++++++++++++++++++++++++-
 4 files changed, 187 insertions(+), 24 deletions(-)

