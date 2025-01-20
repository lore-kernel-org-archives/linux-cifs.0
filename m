Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011A610F9
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jan 2025 16:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737388961; cv=none; b=M07p5MH7mkvgQKs4X28RkFgurnc65TkHeTOFzLA9ctXrFSpk/YKp3P62rbjMcxjRb9uJRimSSSbJn26CCs6fKFgGcxROwhTbdNinwIGPZKfkMkwVPVWVP6aAiI4HVvd0sR9s5Aw6yeyHIaP9ZVzq+BMKH6rpvaCk+WUIaxLJ3Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737388961; c=relaxed/simple;
	bh=/KfRUi1XNthhCF5LgShq/ikeEko1dhfbNJHBqzMVCdU=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=cjeZ3IqAQd8wa17gmp9tFGNiLvGk9B4Y9bEYjyDBSV030rcZn76NlVwC7PKqu5sY3MkhSfKALQmlKLAe6zndWBWTV9qhkPYVCLm82ULIy7knvv11/Oh9+Qqz3SloglI9bOUi/FQv+lS13ywK4Zu/T47gaC+rp+gj9sx5U9UndM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=dCL9x2F/; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="dCL9x2F/"
Message-ID: <9975ccb4c73dfd859556158e1421427d@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1737388952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qvagM9axRNwM4RapUtZ17zCkDCfAdfPNGnhprqZ1anw=;
	b=dCL9x2F/pDdWlF64wxToQ5NOBZXLqH+N62LfaONY60UJKV1oL5wOhPMzVp7fc/qkGyQFyN
	Y0fPTVTCXxZKT14+zgvv0aR90z62hQF3WrRotmSR3JLmCW9iB9ut0faV+TGoflfUW2rFQS
	YnsVazbIAPMmm96HvtTLEct+xD4wFHFLUoQbp64eQexvPFF79KxfvB4RIlkCdIKqGyMpyY
	fe5iV4NX9wqQ40LBkuMWJYSFWIOCWwsvBY8rLbYaRzsffWg9FkbN+Dud+OVNxuGGQshd32
	NoDAoPpNEKQrzaBqL+dgidags1N+qkFdVUEcTU7YFUe2XJBfutF892CeDn9TzQ==
From: Paulo Alcantara <pc@manguebit.com>
To: tbecker@redhat.com, linux-cifs@vger.kernel.org, Pavel Shilovsky
 <piastryyy@gmail.com>
Cc: Thiago Becker <tbecker@redhat.com>
Subject: Re: [PATCH 1/2] cifscreds: use continue instead of break when
 matching commands
In-Reply-To: <20250114203449.172749-1-tbecker@redhat.com>
References: <20250114203449.172749-1-tbecker@redhat.com>
Date: Mon, 20 Jan 2025 13:02:28 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

tbecker@redhat.com writes:

> From: Thiago Becker <tbecker@redhat.com>
>
> While matching the commands in cifscreds, continue attempting to
> match to detect ambiguous commands.
>
> Signed-off-by: Thiago Becker <tbecker@redhat.com>
> ---
>  cifscreds.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
