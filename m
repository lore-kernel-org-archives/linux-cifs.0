Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FDE51C48;
	Mon,  8 Jan 2024 15:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="OwA1GDQt"
Message-ID: <88a9efbd0718039e6214fd23978250d1@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1704729533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eITOrU7IqmoWhpytvEyQabfj5gns6LHywe5FDzXfE3I=;
	b=OwA1GDQte2vVJv4t2oEXmyULIMZroyX++8uuhOiq+2vKnQaxlMMxKPzhTEGU7DtucW5Dnd
	RxtGI3f951dUkpvBoQ5DL9mPjVaTRVPSTBMg1ijyBCvE9AOc318hTiHbS+PoiHBAC/Xubh
	/Ahga3oDK2wzRBKzv4FMDo9xCeHOJbQqOZNUSc6scOBzPYpSXLsYXhkVqZzuHMfl/deLg+
	7OVcVz7w2/AJwQb1WuO8GNPZeHobwTZ8t51v/UhgCwZCautNFHaANQteYuPOajA9EyDgVG
	USfYElfJ0KZeSXX1sT7njzmhn/DNAezoPwV9q0pOATTLKVLfdUe1lF7e6t+Bww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1704729533; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eITOrU7IqmoWhpytvEyQabfj5gns6LHywe5FDzXfE3I=;
	b=Rn2nQt5bbJlxsfSwqjECOK7V7iOe5xBSgyFQzqmddIIHDC/BD4wIZ5JA+ycAYVESjA60Lg
	ppdPG3EfuwTkaWJcFpeDdTtr6U6idBEmsUhFnDA6rhb8WhTJh7pYfdxX5LHpTE4jyxVLky
	661uwbwWE9rnlodkiMnFFssNhtLDuHnHxvZC1wRXYXT8cdwU8P/OjGZO0ryYj0BS2GQe3q
	/ERnS3SNJ0FhMEiPZ8wSG4FxTfG1VYYUAAduhysIabGEmELr/KymTYIEECoTLiUkrhxnlz
	JnnIdRaoSxsz2s1zWAJDzQ1N+69ns5vdnLAAPYHaYBoCl+aSiYM/YPiprymEZA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1704729533; a=rsa-sha256;
	cv=none;
	b=FD19sst25bnkqFJXf+jHnwLV2Blhsmi3ur8qASu/5tfZAReRUmcbBuvn04D/331Q2K8LlU
	oISzkU1iKCLOqcwJNhV/Q9VRbgpDvQB1tM30W8vy6OC3ElNXxjERNUGiegphBkZFk7V7Ij
	Zo/sVnTBd04aU3oYtNdvvq03ke81gdeT57nQQpYBtCtUdpAt/GqN/ofJ6iuIIKXVjJF9+9
	iKeJ69GOSkLmSuP8078/HbTgmIw5VRUOMv3ICjt/Wmc6kUfRICdso5uNJfkvGZTsBwmDL9
	5Npw7C1u7kuAQyJL4OAOIIN674GsUgXXgcyAZtUK6C8S5f6+wAHAowx2BdMKpw==
From: Paulo Alcantara <pc@manguebit.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan =?utf-8?B?xIxlcm3DoWs=?= <sairon@sairon.cz>, Leonardo Brondani
 Schenkel
 <leonardo@schenkel.net>, stable@vger.kernel.org,
 regressions@lists.linux.dev, linux-cifs@vger.kernel.org, Mathias
 =?utf-8?Q?Wei=C3=9Fbach?=
 <m.weissbach@info-gate.de>
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
In-Reply-To: <2024010846-hefty-program-09c0@gregkh>
References: <8ad7c20e-0645-40f3-96e6-75257b4bd31a@schenkel.net>
 <7425b05a-d9a1-4c06-89a2-575504e132c3@sairon.cz>
 <446860c571d0699ed664175262a9e84b@manguebit.com>
 <2024010846-hefty-program-09c0@gregkh>
Date: Mon, 08 Jan 2024 12:58:49 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> Why can't we just include eb3e28c1e89b ("smb3: Replace smb2pdu 1-element
> arrays with flex-arrays") to resolve this?

Yep, this is the right way to go.

> I've queued it up now.

Thanks!
