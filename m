Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C793B230270
	for <linux-cifs@vger.kernel.org>; Wed, 17 Sep 2025 17:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758128914; cv=none; b=J7KRkIjMbo1UnZ7tW8poX9Mkb9ybEo+GZbT6mTcx8xmRzJ2vCgXy0wX/BQ/3rJedHTjELxeLG7I/5eqEPXQgVolfSP3Dd9g8hUANA6WDyZ18EYKNJMvNDTR/ooPm0V+/zxvTpBsRg/w+0cH30iB+eNfoXf2qVJwpACFTPGqFn8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758128914; c=relaxed/simple;
	bh=+eBlr6lbjjyWiMgj1aI5r2TFtGk7DBUeBtrG9FnimBo=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=P6VISb6zvnPheCVCntGCPSJ/bFKVdZtGA+3lqu4jfPDdeUOUiBqNQhuVVvCdqy3H/YzdEQABDofOy/9iuUKqSL91AIf2m4cTWVpyUZGhOe5D7u9dBYZZ3IJbee+ylbFPnX0JoUFHDwJbH8nImASDU1YCv0/YTdsw2VAZi/TXQUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=xsnRNdZo; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="xsnRNdZo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0joLoM7cx5YGDppQOA6ZY6sVtWbCc671X57BtI3G1TA=; b=xsnRNdZolElI58uG14THvDyTaV
	tCMxMAO0/7YMXA8t9D/A8qgrNmTNIeJLeBVAjzBwcFo/CzZGJGvXEG0Bd0nHeuf6HqNVMLKnC/Vz9
	mVpzhILm1Hiio+4bv5hbuH/06uPPeJvbYTh3X2nDfUrqKjiTFuqcKl1XRPJizAmfA8YWWQCSkSE9D
	tB/46yeivuh8bnXX8HnSLuUyuwQhFfTiB5xModC7gV/nOPLyz1s+shBBNHAmOGD9H5QsglMh0OF1U
	owOZ8oklLEtg2A1yfwUrmoMkRlZylrn93AwanR35z/nT7FtFy7M9d42911sAmEWllkUw0uufaOQjm
	vyzqNOCA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uyvds-00000001bYl-2o5z;
	Wed, 17 Sep 2025 14:08:28 -0300
Message-ID: <4ac91f6d900fd1766bd6f5317a4199ea@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: smfrench@gmail.com, Frank Sorenson <sorenson@redhat.com>, David Howells
 <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix filename matching of deferred files
In-Reply-To: <6crvzn6sgy7ia35jeim3wpvliww3alxkaije6sh55ggyvhitwm@nefxffuhgn3z>
References: <20250917003701.694520-1-pc@manguebit.org>
 <6crvzn6sgy7ia35jeim3wpvliww3alxkaije6sh55ggyvhitwm@nefxffuhgn3z>
Date: Wed, 17 Sep 2025 14:08:28 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Enzo Matsumiya <ematsumiya@suse.de> writes:

> On 09/16, Paulo Alcantara wrote:
>>Fix the following case where the client would end up closing both
>>deferred files (foo.tmp & foo) after unlink(foo) due to strstr() call
>>in cifs_close_deferred_file_under_dentry():
>>
>>  fd1 = openat(AT_FDCWD, "foo", O_WRONLY|O_CREAT|O_TRUNC, 0666);
>>  fd2 = openat(AT_FDCWD, "foo.tmp", O_WRONLY|O_CREAT|O_TRUNC, 0666);
>>  close(fd1);
>>  close(fd2);
>>  unlink("foo");
>
> Good catch, but since you're at it, wouldn't it be more elegant to
> replace @path with @dentry and just compare cfile->dentry == dentry?
>
> Would also improve performance by saving calls to
> build_path_from_dentry().

Sounds good, thanks.
