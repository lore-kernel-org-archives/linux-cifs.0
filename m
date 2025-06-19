Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B35023716B
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 15:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750348691; cv=none; b=MxhE8BWEWWNml2lPZfMS6K0P8CbWbGw4S1dkjSTj3mloxdgBsX3dgrujqMK1mtWdumQIgRtLJigksVvZcT6WA2eJw2WqeD0lrjxIU8bEsqqJ5/F7efI8aSGH+AX/tYfAzjO5AJJY7OQ3j7esxYaFoP78MAiSsO0h6VST4WDku4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750348691; c=relaxed/simple;
	bh=NQ4AJwRocUD8N4e+/vglqYVxd27bGyYFck2sYefjSDo=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=c3VaWpJaMiZTONWjFj8SBkN+qy8D5cx9kx9nCO2fOP4M6+2x0CR081FPmfu1Qq+D5bU+9+UM2cGQg6K0FD+a1UBbChOKPzfTehYL6e0Oa+r1OyS2pJw/67MCLKAOwxAMgOoMBVNqYEGb/pqMNUA1UmIEx9ax5Tl6MKosJ4nGIMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=wLButEac; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="wLButEac"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=NayBgb0+wOs2hpTTa5ymWjCBMcW3KvMsev1hi7yUv9U=; b=wLButEacNMVfCPwzjOGle4vFpK
	+yJw9pbWkpVDS6F0LPzSReX86UyrmrojYu2yfh64D0mOsRvcWMCOUFDw3pPVmOCqjQx2ahWy6Erka
	0+XPJ42j5pKiTwg6rm1x1+rS48vOtgd9TmePPvOk+2K/UIfuAbpHOhi1AWLwDF0Agda5zzIATGE6W
	XOefsXDQYGUDjd9xRMR/h/Ky8Q6d0Vfr01dZ1CXxTvvWsdLAQAUzDfXrgQ3tOzwBKcP4SUrHYjNHR
	BOJQ+9+hNZRtXhWOb/kR9SIAuxzDE7FTXI4YEq6V4wlgXn0PJFXSrCCNcjz/GgH2YvKGFaj06DjnR
	ZlcOTZXw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uSHeG-00000000Hfv-38KL;
	Thu, 19 Jun 2025 12:58:00 -0300
Message-ID: <9bd4fae38c680b0c8a0c8957258f5934@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org,
 smfrench@gmail.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH 7/7] smb: Fix memory allocation and ACL handling in
 cifs_xattr_set
In-Reply-To: <20250619153538.1600500-7-bharathsm@microsoft.com>
References: <20250619153538.1600500-1-bharathsm@microsoft.com>
 <20250619153538.1600500-7-bharathsm@microsoft.com>
Date: Thu, 19 Jun 2025 12:57:56 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: 1.1 (+)

Hi Bharath,

Bharath SM <bharathsm.hsk@gmail.com> writes:

> If set_acl is NULL, then there is a chance that memory allocated
> for pacl memory doesn't get freed. Ensure proper memory deallocation
> for pacl in `cifs_xattr_set` to avoid leaks.

If ->set_acl is NULL, then the following is executed

			} else {
				rc = -EOPNOTSUPP;
			}
			if (rc == 0) /* force revalidate of the inode */
				CIFS_I(inode)->time = 0;
			kfree(pacl);

Can you elaborate where the potential leak is?
