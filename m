Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC877331ECC;
	Sat,  5 Sep 2026 23:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788650534; cv=none; b=KeTdku4lxUY93h/rOPqaFJWsJWufqzt1I0pgu03P9PbTm8Hj2FSX0CJualYT40spsc/7SmHyyXsfK1woOzMTzVElSqFPI2MwJh2ZV+o/kA+eOQQb4O/oSyTo4SYltZUlGeKYwQzCHjGTwl451ec2Qk1YF6F+cVrpAOnNErmL2XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788650534; c=relaxed/simple;
	bh=VHd6liGn73odL+6VuqdQ/ezwUO5anEQov1l4ZP/kjJ4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=fAPAjWozk6U0eIK31ps8Te3gzyvYRNioOMAXzwSwL4i1WADWAdgBoAmklgJUP3j9rXOJPY0xy0zgmar5PeTPMnghBmA381PqM1DnnqXICn67JJUMG3ZFfkON5pvVklxaSmzls085SKNJqXbNEG/tOlFDPq8SbMRXVotFyrkul4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=MMB2XAjq; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="MMB2XAjq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VHd6liGn73odL+6VuqdQ/ezwUO5anEQov1l4ZP/kjJ4=; b=MMB2XAjqag60CXKaGE8XqikXN0
	Az6TgMJPfb5LRLH9Z1hZ/L+Kl2bKEbT7cUU40kNATvRYODmX1vcC+SSqYf46VstdThyIVk6OPZHx/
	7HUFy7ojTjLtnLYVVRwhRpM+c2/4sE4rynhyioEkMgj6cmlOTta46Rk5OtoyzCriifHuCXN1852qt
	nZTsctTg9Q3z2yQPrhIsCevg5Fe+UpfgR+rdjbGsaWzYfEECFmi59Uk4OOmKwxVDi+XJUIRC/CQDT
	zmuNNuPpKHt+sQvxu+KxozcP6uTb1mw+UWwlD6D1yl6TItvYP0wnKr2Y9gK+yXoqhKREyWARvLYv1
	H+H68WCA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x2zi1-00000000lV9-39Dm;
	Sat, 05 Sep 2026 20:22:05 -0300
Message-ID: <0bc4a437a08431e16549c4e64409b16d@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Fan Wu <fanwu01@zju.edu.cn>, linux-cifs@vger.kernel.org
Cc: sfrench@samba.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Fan Wu <fanwu01@zju.edu.cn>, Song Li
 <songl@zju.edu.cn>
Subject: Re: [PATCH] smb: client: fix cifsFileInfo reference leak in
 deferred close
In-Reply-To: <20260904134811.338427-1-fanwu01@zju.edu.cn>
References: <20260904134811.338427-1-fanwu01@zju.edu.cn>
Date: Sat, 05 Sep 2026 20:22:05 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Fan Wu <fanwu01@zju.edu.cn> writes:

> When cifs_close() defers a close, it hands the cifsFileInfo reference
> of the closing struct file to the queued work. Each execution of
> smb2_deferred_work_close() drops one such reference.
>
> deferred_close_scheduled can be false while the work is pending: the
> workqueue clears PENDING when the callback starts to run, before the
> callback clears the flag under deferred_lock. A close in that
> interval requeues the running work, and the callback then clears the
> flag, leaving the requeued work pending with the flag down. A later
> cifs_open() can reuse the handle and its cifs_close() reaches the
> same branch: queue_delayed_work() fails because the work is still
> pending, but cifs_close() returns without dropping the closing file's
> reference. The cifsFileInfo count stays pinned and its tlink, dentry
> and server handle are leaked.
>
> Check the return value and hand off the reference only when work was
> actually queued. Otherwise, use the shared _cifsFileInfo_put(), like
> the mod_delayed_work() branch above: the pending execution already
> owns its reference.
> ...

Applied.
