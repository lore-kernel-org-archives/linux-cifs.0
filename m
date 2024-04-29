Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109B22AE93
	for <linux-cifs@vger.kernel.org>; Mon, 29 Apr 2024 17:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714411030; cv=none; b=sGVHdFc0BctajgLDBbPf/SrUbs098IYuyl8hIQnXRstSv4fnD5Dlp98mxoN0AjXHFjrtEb6xtL9pH/T2uOdNqDoc9cBTSe44O5TzlwdpTGumrNeH3jifT9lmjK3iS0tRVYfkgu7oOh4SJK7xtCUej5Q3XFvqVZsKnSTULEbZA2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714411030; c=relaxed/simple;
	bh=hd8lTLWo7aeW3fOpJ3wM0xx5kSkej1CbhpLhhEs8GWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A9HSHHQdAIAlCavp3+5w9vsrmCgg5s0u4Jqn2IobRhlJfVjvOXDlrvKsjdtU9jrUoGzka27nxgl0Z/SvU+z5lSRIznjzLg4pshVdhM4d844b9RdetScNgsh/E8Gc2UR+vurjMD6CKExtB1vgWmFDFmlVXQiBYwP+1EEsB4X/K3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ysU78YWy; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ysU78YWy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=RjEQWBHoZ0zZnoVtfOmdzxbT0U72qNEGw0dJoEOJAAg=; b=ysU78YWyv57eeavk2pxJHcQkrc
	njE6BuKCz58AUKUJVHwOEWHVee4O8DsxbfTRh3/FmnXtzooVXO4Sf1TEDYcbqYQ1Y2g6vc+AMXIE6
	ADRIUxa7M8gWEG+ESQILKirh+26rdhyGMq3pGHa5+MDxKiF2OWGJunNR+63U9ZFvqQxbch2yFASaB
	+CfpTKoX7sFnkyVLYkaJv6cvcUpctUt5QHs2ZSv74PR42A8bjJAwvV6NplmrMMKzJLQ2wld1tHIgD
	7/SzdBGQq1vWRa46St6j3mGy0fWgVguEUGqmJL399EIlW2sVfG29NgLW2tc9nmo5zUY8k6xwS9iv6
	+Fc2FtmVpy8sUAxtKG+S0neiMrQnE6gomJGGzkKqizycaBu0EvuigYHMH92ax18r1lz1sHlgHERD0
	gDt6gEqgbppFU8OwkYEgkjG93Fk/BBgAX0pWzf3OeVAzU9iYdIKl3MREO2MdN97t2YHo8bVAsOXme
	F3Gz/jD+Jk8W/+219B8h5n2J;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1s1Uck-008yMJ-0o;
	Mon, 29 Apr 2024 17:17:06 +0000
Date: Mon, 29 Apr 2024 10:17:03 -0700
From: Jeremy Allison <jra@samba.org>
To: Ralph Boehme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
Subject: Re: Samba ctime still reported incorrectly
Message-ID: <Zi/WD7EsxMBilrT0@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5muXqpZN1mu=WAhaxXe0yRB7Rib_CaoGo3h15wwcSPZFuw@mail.gmail.com>
 <b40a9f3b-6d2d-4ddc-9ca3-9d8bb21ee0b9@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b40a9f3b-6d2d-4ddc-9ca3-9d8bb21ee0b9@samba.org>

On Mon, Apr 29, 2024 at 10:51:21AM +0200, Ralph Boehme wrote:
>Hi Steve,
>
>On 4/28/24 9:41 PM, Steve French via samba-technical wrote:
>>I did another test of the Samba server ctime bug on Samba master
>>(4.21.0pre1) and Samba server is still broken in how it reports ctime.
>>An example scenario is simple, creating a hardlink is supposed to
>>update ctime on a file (and this works fine to Windows server and
>>ksmbd etc) but Samba server mistakenly reports ctime as mtime (unless
>>you mount with the "posix" mount option).  This e.g. breaks xfstest
>>generic/236 when run to Samba
>>
>>More information is at:
>>https://bugzilla.samba.org/show_bug.cgi?id=10883
>
>I wonder if this is a bug going back as far as 
>c9dca82ed7757f4745edf6ee6048bd94d86c4dbc
>
>@Jeremy: do you remember why you chose to return mtime in 
>get_change_timespec() and not ctime?

If you look closely at that commit, you'll see
that it's actually not changing the logic that
previously existed :-).

-       put_long_date_timespec(p, m_timespec); /* change time */
+       put_long_date_timespec(p, c_timespec); /* change time */

Previously we were using m_timespec as change time,
and c_timespec in this change now comes from:

+       c_timespec = get_change_timespec(fsp, smb_fname);

+struct timespec get_change_timespec(struct files_struct *fsp,
+                               const struct smb_filename *smb_fname)
+{
+       return smb_fname->st.st_ex_mtime;
+}

So I actually wasn't changing what we already were
doing :-).

Now as to *why* we were using m_time instead of c_time,
my guess is that we were trying to emulate NTFS
semantics which were not documented or well understood at the
time (where "the time" is probably prior to 2009 :-).
