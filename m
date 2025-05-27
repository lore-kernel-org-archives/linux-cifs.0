Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D0F1990A7
	for <linux-cifs@vger.kernel.org>; Tue, 27 May 2025 19:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748372787; cv=none; b=Wz7yS9RgWaEeGNDjtDoct1vWlg78hDfVmsEiv40bSWz1R6G8bsyNLXGAs2AbqVK39X534NYRaanrhE5jL5j/iVoBeWI2tLBrYDeYpcn3z2d/vlvylUMwKd4+5FBnJMXZw5rP1B10OoSUDXVAN3gwWEDa2GO7J7l+vurWv3jiRBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748372787; c=relaxed/simple;
	bh=dG4awddJr9/ukmtqMFug7tutbZ5YyAFipfc4yoYGxo0=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=N5HRcHCJL2Gqzer0OSxiyWXJJYvz4p9kXVckWPKmgBuRefn4N8RhHGVC4sZJdtPHoxfEu/hDIwEREtQ9Pzz6qc+Z3gtkbCsS2EOJ28l7FTiM/l5KNqUKiTfo5WwDL8y2+uu6FA+4kmOcIa93x9WHMe0UYkN59HTdjNUhNOqhnjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=aBzf0GFz; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="aBzf0GFz"
Message-ID: <44fb26b3d061287bf1cf8ec458adc8a2@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1748372776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0dfL4dB2Yw3qzwWxGTK5WKzmw7OclsyTAo6OVOMBFvA=;
	b=aBzf0GFzSXjL4wnv75zUe6vg9gT9Tq43kzai6/8ZAM++PJSGyYD0Z9S10r2G7WmAoZoxv4
	da9ngxAfSY0PbFK11j6WMepDpgHRoiSzgBcrCLey3Ry/AGGIhPjccV+M02fsvTEmwynDo4
	kLpnNAwkUt0AbOaP5xsA4pjAElF/b/LysoU8RNITH96iglmP4cR0vZztG+QIfUtYqH/9ZB
	9dcc734U5MxzUCXp9q6G5o70oH9N7o2LWRFilFYjri71e6PTFsx48DTo73/vb2mEKFcSH9
	kU9nDxIw4H1MUAfUEiYSgJc3hK9RoFScpfrLO+VK6V7RSh/NJUSKf10OBPr00w==
From: Paulo Alcantara <pc@manguebit.com>
To: Henrique Carvalho <henrique.carvalho@suse.com>, smfrench@gmail.com
Cc: ematsumiya@suse.de, sprasad@microsoft.com, paul@darkrain42.org,
 bharathsm@microsoft.com, linux-cifs@vger.kernel.org, Henrique Carvalho
 <henrique.carvalho@suse.com>
Subject: Re: [PATCH v3] smb: client: fix race in smb2_close_cached_fid()
In-Reply-To: <20250527184213.101642-1-henrique.carvalho@suse.com>
References: <20250527184213.101642-1-henrique.carvalho@suse.com>
Date: Tue, 27 May 2025 16:06:01 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Henrique Carvalho <henrique.carvalho@suse.com> writes:

> find_or_create_cached_dir() could grab a new reference after kref_put()
> had seen the refcount drop to zero but before cfid_list_lock is acquired
> in smb2_close_cached_fid(), leading to use-after-free.
>
> Switch to kref_put_lock() so cfid_release() runs with cfid_list_lock
> held, closing that gap.

Does this mean that SMB2_close() will be called with @cfid_list_lock
held?  If so, that's wrong.
