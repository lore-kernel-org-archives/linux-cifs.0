Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDC61F3BB7
	for <linux-cifs@vger.kernel.org>; Wed, 19 Feb 2025 13:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739972996; cv=none; b=k+2YYwurFbLUq+w8G5FnlZ4WDFEhTxINbSaB6x0gr7mFS9vCP8V4dUjENNYkCM/XPF+SlXdMmzDnpmXDekCavfz591c42K7wZkiQY4hbRGbxs4yZq2PLDH/F7hN6OrtLVD6QEaWymfxTIiSXg0zlM/HmBdiQIc+cPDWpE9B00sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739972996; c=relaxed/simple;
	bh=jJrlmPqpy81oPbe+e6W+ugkEomRKlJ+2NMIdk0ylnmI=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=XuaLPpx4SwLBOMPym+tAHGQkm1XCgaQX8uryy0ExJWcMO2+yDFVapG8ySAMruNl54HsG6qsAQhnX1I/JuZtkKAgaD302GmeQMwTNVDituWkrmLdzlHEeMDbgOLFzF90uNJeWPNTH8rUBEc2tYjDp+zeeP1DK7tZjF1DMdkL5cAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=LGeBNxJQ; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="LGeBNxJQ"
Message-ID: <47b814ccbd2eda970c13f1b68d1ff53b@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1739972984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PeIKYjUaS6snpPval2P+pmcxk4RzkMLycu/WkQRZgng=;
	b=LGeBNxJQxLO1DfPm2v4V7PUMneEkdOOqhlgJb44Y939L+S5cDUHpMFAtOCn9w1gf64+rmV
	gNXjW8+UJ26+OJiJoMyarc3acygStXpgtsZ/+cyT08UfAekZz38LiiESBvddfbw6dUpzwb
	SJ1PADB6SCbIntTb4+sGMamC+Zk7af2foMT3Ut+qu9M3TY2nb+WczE+b8BlhqV3+HU5HjY
	jpvRD+vihYZo8VANeTOmp2KMqOkG21PdWJWNIfTk4hS/PzfrYomWti0GzwtifewvLrWiZm
	5RXuhgPddHQBg00+LRZWgyV1pFU7HPIoZMxm6zT6AVHDnwnCuMbDcrkJsqk7Wg==
From: Paulo Alcantara <pc@manguebit.com>
To: "Reiterer, Horst" <horst.reiterer@fabasoft.com>, Steve French
 <smfrench@gmail.com>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: RE: [PATCH] smb: client: fix chmod(2) regression with ATTR_READONLY
In-Reply-To: <08e226c8df7246fbaf710f36b39ead4a@fabasoft.com>
References: <08e226c8df7246fbaf710f36b39ead4a@fabasoft.com>
Date: Wed, 19 Feb 2025 10:49:39 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

"Reiterer, Horst" <horst.reiterer@fabasoft.com> writes:

> thanks, Steve and Paulo! Considering the severity (chmod does not take effect anymore) and the fact that this regression was caused by dropping a condition in two lines of code that is merely being restored by the fix (basically, it's a partial revert), is there any way to prioritize this change as there's no production-ready workaround? It's difficult to avoid updating to 6.6+ at this point.
>

It has been marked for -stable, so it's expected that stable team will
pick it up for v6.6+ once the fix is released in v6.14-rc4.  If for some
reason they miss it, I'll ping them to make sure it goes into the stable
trees.
