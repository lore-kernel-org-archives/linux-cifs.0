Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2787C37F737;
	Thu, 27 Aug 2026 02:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787796402; cv=none; b=kPqUxarVAOcRPi19/nEqrV1SyHAFUOlqXeAjXoEZG45YHGBWI26uraMsVdLHvqSDhDEI5+Kzv8YA2Z0vSQsV+38FLI7s/o4i/mnGfrfKk7ELckWdz6dJqJyvENjLy4UQxPsxL58aLWcYc8nMJn4lW8QpnYY6w5Ek3+mSWHZtMyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787796402; c=relaxed/simple;
	bh=eR7eoNGxFKC1fU1sbFCyQffESZSbzvartEISZkjTVvw=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=RF7eJy/v5QP/3lEyX8oSiJUYBLcYUYuKY9Osub57Pzboy5yqduvV4AAghTcG5y2VmQ67pWGx4iXxTmFZwVSuV96VuT6B5ZImUJc3ek0YujMcOtOwPHLNCpA8y5mJfzQc7B/K5X9gesW9/cVOYi4QoiCSLswe2QEUYumYAS+84Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=iJGdm+Gs; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="iJGdm+Gs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eR7eoNGxFKC1fU1sbFCyQffESZSbzvartEISZkjTVvw=; b=iJGdm+GsjPHVb7Yg07Z2B+MnKG
	wyd/j0VlfdFk8FpN9tp/x7FG2bUUuhQs1fFD0fFg5RASM6t9jbGZxpydF0/TmJ6MDFyQJaI4eG3Jp
	WwuWYSyvgOFPLMP1mPxjzU9g2PrUscFdtctoCXAtE2ko7mJ85O6nSaF8XjJrkGwQz6YSL6Tc1n8rh
	E9j76iVSmdPI4Uyk1CNqgCIXEVOHQkgf4P7wt2V1NYU4Z+TyM/8a3bmttTr0ggYFkFIenzIkKgQy5
	gsXYtuUgiNtIvEZ6UXBsfN2jH6Sokv5T02pt0VmqWQcMZj5okknGhfGyRnAktsB7VF3WKX4MBd0IV
	Ry6fRKPQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wzPVm-000000004ez-1mpY;
	Wed, 26 Aug 2026 23:06:38 -0300
Message-ID: <0e2ba79f73560a635d07aecf400e7cf8@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] cifs: add revalidation on FSCTL failure in
 smb2_duplicate_extents()
In-Reply-To: <20260823232646.3170915-1-sorenson@redhat.com>
References: <20260823232646.3170915-1-sorenson@redhat.com>
Date: Wed, 26 Aug 2026 23:06:38 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Frank Sorenson <sorenson@redhat.com> writes:

> smb2_duplicate_extents() has no handling for
> FSCTL_DUPLICATE_EXTENTS_TO_FILE failure: when the FSCTL fails, local
> inode metadata may be stale from the pre-extension or from concurrent
> remote writes, but is never refreshed.
>
> Force revalidation on FSCTL failure and use i_size_read() for the
> pre-extension check.
> ...

Applied.
