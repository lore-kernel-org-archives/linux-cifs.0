Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EDD17799B
	for <linux-cifs@vger.kernel.org>; Mon, 29 Apr 2024 20:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714423580; cv=none; b=m0mMaspXk4l5AhdK6RTQX8hNVWG50AWxbC8GBvZ8EGpgHb+6HCrrdf17Bc68VNOa2IKdExB/GCZYN0gVADWLAZDd/0hrFC4XpjWWPGIXWNjF/m+xLGFS7gNVyrTxVaA3h3TY4YsOvsJ45yYEJiSkVQfkCFqqu9otkZ52Ce+4154=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714423580; c=relaxed/simple;
	bh=1udO1/f8UlXM/Jp6Uj2n3BOKBlto0SLoeHVuXsEEi4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E2YsnHbDnVqAiR5irTuMFXI4xIRKxl8OHwm/punsPbXu/VpM2Bpaa9PkiKpYQkvspvoy6rU75/nG1RWjBjd1x+5OAx4Ca/Awz4FnoiJz+AsNGgvonimdZwMgw81PBCLbIK4AW06K157cXnXizcLCw2KzzUU/FdY07/EIgbx8FRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=CiVlnYo7; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="CiVlnYo7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=1udO1/f8UlXM/Jp6Uj2n3BOKBlto0SLoeHVuXsEEi4A=; b=CiVlnYo7D7b28+g4BDRu72g1iE
	oaPYETpD6e8RwYJlD1aguhf+g2iq0jxjOPi4W0KSmMgLXDO1MetD1q6qgB0n1c2hiWF+5lFFxtAjm
	Bx+8sk46BOQft7rJtqf4WoB7EcYwI8OYihlDlQ4XTUlJ0f3Ok99i2AgmGzwLiEDXGDd39Xrn3VwWB
	ibtXG50lwQ2ikP0mrja2XXyuBQeuatYyxDR51A8I/S5t0nMBEm3LqcIlQ4HyRW+VGVG2cIFECkVXw
	EOCt8Sia0vdqWC40sTtJGxdXQx4ysZzmE2dJ6kGilN/7FgiPyCFQrBLrg95zF3xEod6BzzuCRd173
	ob4M3WX7Td2uSJpVjuGRzFhKOWcKurnzxehfQIFFlMpzP4EME3OBJ9KAa7NAr7a7XnSJ2eCOBSCsD
	MjckAHrVOVypNt2tOilO0+uV6FW2uAenRI5S8wh7VQMaRRjY626WYfHRGEetOjxheHfYjSYv1pF6v
	rQnrPj/IOHENDIcT1/w6gnkC;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1s1XtA-008zdg-0R;
	Mon, 29 Apr 2024 20:46:16 +0000
Date: Mon, 29 Apr 2024 13:46:13 -0700
From: Jeremy Allison <jra@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: Ralph Boehme <slow@samba.org>, CIFS <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
Subject: Re: Samba ctime still reported incorrectly
Message-ID: <ZjAHFSxjaYaybUSb@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5muXqpZN1mu=WAhaxXe0yRB7Rib_CaoGo3h15wwcSPZFuw@mail.gmail.com>
 <b40a9f3b-6d2d-4ddc-9ca3-9d8bb21ee0b9@samba.org>
 <Zi/WD7EsxMBilrT0@jeremy-HP-Z840-Workstation>
 <d9f60326-9ddf-485f-81c8-2012b7598484@samba.org>
 <Zi/8DEo+ZiF24LLw@jeremy-HP-Z840-Workstation>
 <CAH2r5mu2Qr5W1eUOz-JFyf4X6Wk9X2Jr4XFza4tJmH+mVVZqLw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5mu2Qr5W1eUOz-JFyf4X6Wk9X2Jr4XFza4tJmH+mVVZqLw@mail.gmail.com>

On Mon, Apr 29, 2024 at 03:16:02PM -0500, Steve French wrote:
>
>Another test to try is xfstest generic/728 (which checks that ctime is
>updated on setxattr)
>and xfstest generic/236 (checking that ctime is updated when hardlink updated,
>where I originally found this bug)

Well remember the time tests are meant only to pass vs a Windows SMB3
server. So we need to make sure everything works there *first*, then
if we need to tweak specific behavior for POSIX+SMB3 we can look
into changes based on a POSIX handle being negotiated.

But that should be a last resort IMHO.
