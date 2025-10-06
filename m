Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40779196C7C
	for <linux-cifs@vger.kernel.org>; Mon,  6 Oct 2025 17:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759770310; cv=none; b=pSG0DaD/S/4DQ1FQysl1fyDzEL+fnEJOdl68vPqBu1M8M7y/igJGNrXbVWMOj6oB+odUtqJWHNEU70bRmjyrOQw32C5K5UZ/Dh0Pwb8hzQXAHaOi6IXHKzocgctyyhKKo2CgKCaANhkfyoNfeRE9DpOtQuipDChIMRcX4n2JSK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759770310; c=relaxed/simple;
	bh=O6DRmLk4gx6k287kGWrrk4QeAT2UcJhg5vFN6cluwVc=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=JJsp74aFGmyZlkhN/YHiWZh5Ir040oUXozdqs4kaRvNc0S+7xraZk7JioK0cUos7rhDsG9QFmE5o/2c2XlSFy4QThXFZSeK6N+JlmeXsBNXNcQ0fK/uF4Hujo1Qnf0CT5nvnSzHBmi2JZ3zt6AE83ucRNFopg0V5CWeFQU0cBxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=burZ51Af; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="burZ51Af"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vQrQfjUd1v+yeuQIkb5K+jbwfQjynFSFTeimikBhdMM=; b=burZ51AfTIj37JOR22b++0LGnt
	9Ubx8bRjVU2K8849aIhoXTiXlnI1PCpkl/bxcqTZafX4ZpRFRd6dYXiGRvp2dklzLU/TjtwXoOr6P
	9aDHCtxlwOWFYebiqSvu5+QeHOATVsBMdVgpGtjpThvq17tSzvaRWPh3FFDIwXrUX6V5EMXhqSi5p
	qiVZbaw9YH/kIyhGAguzgs1HPmlFrJCejUNive1VwrvLeIDcTb+1tl+qWgZO95cjP0ZhTVUXsS0do
	a1IsLPQbneTRgZlvDJVuMxr5x77IaD35vi09oVseJW0h4En0yZQcE4A1s7SrpB853gu/Jl5r53Rgp
	KLWKVYWA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1v5oe2-00000000qOG-0GoV;
	Mon, 06 Oct 2025 14:05:07 -0300
Message-ID: <4c6d465a16a0b37f4601d418a11738d1@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Ralph Boehme <slow@samba.org>, smfrench@gmail.com
Cc: Frank Sorenson <sorenson@redhat.com>, David Howells
 <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH 1/3] smb: client: fix missing timestamp updates with
 O_TRUNC
In-Reply-To: <1262e7b6-9086-404e-b9a5-e9c6208b8120@samba.org>
References: <20251006164220.67333-1-pc@manguebit.org>
 <1262e7b6-9086-404e-b9a5-e9c6208b8120@samba.org>
Date: Mon, 06 Oct 2025 14:05:06 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ralph Boehme <slow@samba.org> writes:

> Fwiw, I have a patch in-flight that disables sticky write time behavour 
> on POSIX handles in Samba.

Awesome!  Thanks for letting me know.
