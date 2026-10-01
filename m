Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9634428E0;
	Thu,  1 Oct 2026 02:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790821033; cv=none; b=nhpOF0t0E7Ypmlj7uIjLRuYTOFBMFYu6Hd5h6Mz07Nph+V+/f4hySCQtfFiiu7Ftu+Lr5ebuzjPvca83jmSNUMk8uJM3dfmZq5zw5ZGXutBf6Rw/PSRBUhtKA7UeN6DjPdDWVZUlkGCQAR/6/f4JTYSwNQc8DbH1RH0dFSKa65Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790821033; c=relaxed/simple;
	bh=lz9gvUjHX1LkKy3atzMc9AOirF5pYt/IKHD5THcbOns=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=C32YKxrmaRNCjYsnnffS0pmhaKO4Ie8soVyIJhA8JBcheU3/iZ3mmLppFFJAlwlbc2dVwSECo4HuPEEW9JU3upkKtElRAkQID71C8pUzRxT806eGh/EMYyo62xdCKEOZlVFMp5D/H8L6f5GH1IVIWXPjpaHHMLgDgbTKDsCedzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=7JYhM8Q+; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="7JYhM8Q+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CQxYioWAVQtleKbZ7r56r5Q7N2oMXlHG2OpoPG0IyUE=; b=7JYhM8Q+zDYEOGUnG+HxoImlww
	mHONDolHVBysnnXo6cjGMPxDKzSXiTxBPrYYW3+dqaid/OJZPe312ZuZer+lrGbo3M+AdZNNV11aU
	lQSO6JT0vnpxUw1Pttzl3pDUrxqiJ5Nwno/YXtJPvxsW6jR09FF3K3jMk7FXABZTdKz1B8J5CaQpi
	oe8T/CWuWmvlYi10qeu+UDg37TzreIbu7B7N7VYXohm2az2bza6DFFbKIVlf/LlYY59Gl1OsvkbqS
	Ac5+CuSXDrUh+0sD4XVgT75O3k4Sgmfx06To9nMCmF45ypnnJr1YHDkBpP78THtz+qnYV9Rrv+tyi
	pSl6xpzg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xC6M1-00000002fuA-3tS9;
	Wed, 30 Sep 2026 23:17:01 -0300
Message-ID: <ca32019975be6dfa7347b831b432b50a@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: split cifsFileInfo bitfields to avoid
 shared-byte RMW races
In-Reply-To: <20260930204723.1555769-1-sorenson@redhat.com>
References: <20260930204723.1555769-1-sorenson@redhat.com>
Date: Wed, 30 Sep 2026 23:17:01 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Frank Sorenson <sorenson@redhat.com> writes:

> The invalidHandle, swapfile, oplock_break_cancelled, offload,
> and status_file_deleted fields are stored in the same bitfield byte
> in struct cifsFileInfo, but are updated in different code paths that
> may run simultaneously, and are protected by different locks.  Since
> bitfield assignments generate byte-level read-modify-write operations,
> a modification to one flag can overwrite a concurrent modification to
> another flag.
>
> To avoid these races, convert these flags from a bitfield to
> separate bool fields.
> ...

Applied.
