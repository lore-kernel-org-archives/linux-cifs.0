Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA092580F2
	for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 01:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789088697; cv=none; b=r/MCxTQ8Vx7sAvN19XpTC6GqySleRoaV+Tlp+0kJWIMR9WMrXpZk3A83egkSCrPQ/h2okiEfjWhGuB934QTC2tfVTSrZuw3nVTof13vEFm93Mna/SqNIEzXFaH5tF7JCtHSwZLt3P1xEBdP8CwJUovYAHY0cLvOht9GaWqAuLog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789088697; c=relaxed/simple;
	bh=40Lu2wRqdfrtqMAY7zIJIS5t314kE0EHdzhMCpzObd0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IESrJgxbq6ilXNMnVbF4ML4c+xrh074MUIx+ZWCgzPDjK9za4v1TFtC4XDbNd/p575YLh95oi+0VnhJ33Ic8lJA8c8qGVLJ5IFTRJWdUYpEBOFqN9ZitP8DWh8Gr2E7DQOQdJGdN6lps3CbdNUzffd47dBoeaxToiXaWa6rocaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VAxQ5xON; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VAxQ5xON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656A01F00893
	for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 01:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789088695;
	bh=40Lu2wRqdfrtqMAY7zIJIS5t314kE0EHdzhMCpzObd0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VAxQ5xONjv3ztUEcYy7yDo+iCH7TGm6/Xvu0LrQtuaYb7CeWB/ZaVKBp4sXcL/JP5
	 iLxslT+w0+5W40sGuyoD4sE8JDQk1+2RR6jjmlof2jRtHC46PcrG6StWou+CEujdvx
	 xVCC6Zsk/VEuZ54ol26x+gV2SpB12M8P0RAXrKcZlfsE2R0BwxW2uO2j3YBQkWl1Lc
	 e72iYafvmwp7H6rxgVQSVdVrQSX4Jm13Xr+GM7h79uA+4iygAHTFW9/SJ7EJuxDpe8
	 jyCKP4c18bbESK9RTg36Ej8Yfaw6luiFepIjVa8yBNKqMIhbU2AM/+Ly75SA8huX10
	 dZu1UMN5E+10w==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c2637dd37c1so57166466b.0
        for <linux-cifs@vger.kernel.org>; Thu, 10 Sep 2026 18:04:55 -0700 (PDT)
X-Gm-Message-State: AFuF++lfgoYQQnEpj041jjt9s4qk942Jk6gho10aZcfHX1kOWUxooePL
	QqTW71/1g5mwXfu/brk0cH9hv6G5XfXgBgRFqY4PNMVXz70+dGnVQOVGp53wQHVXHVlEEfeTddF
	1ST2pY/q7RY2Lqbva3+P4M/wsXaGJCVA=
X-Received: by 2002:a17:907:961a:b0:c28:ec7c:27ae with SMTP id
 a640c23a62f3a-c29666bfe90mr53903566b.25.1789088694040; Thu, 10 Sep 2026
 18:04:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260910051649.3806214-1-april.cardenas@canonical.com>
In-Reply-To: <20260910051649.3806214-1-april.cardenas@canonical.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 11 Sep 2026 10:04:41 +0900
X-Gmail-Original-Message-ID: <CAKYAXd829H6zq5g+n6Ue40cW96PfFaPu3kAXe+i5WZhp6E9u=w@mail.gmail.com>
X-Gm-Features: AcwNN1XpUYrtKTZJ2AXoyTyNrttIcCISwwbTIIFxmObetxMzLHFFFo8SvJuZfwM
Message-ID: <CAKYAXd829H6zq5g+n6Ue40cW96PfFaPu3kAXe+i5WZhp6E9u=w@mail.gmail.com>
Subject: Re: [PATCH] smb/client: send lease break ACKs thru correct session
 for multiuser mounts
To: April Cardenas <april.cardenas@canonical.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 10, 2026 at 2:17=E2=80=AFPM April Cardenas
<april.cardenas@canonical.com> wrote:
>
> Currently, when cifs_oplock_break handles a break request from the server
> it searches for the appropriate tlink to handle the request
> but incorrectly uses the current fsuid as the search key, eventually
> causing read errors for users with multiuser mounts on NetApp.
> Fix this by using the tlink from the cfile struct instead to respond
> through the correct session.
>
> As breaks are handled in a worker thread, the current fsuid
> isn't guaranteed to match the session that the break is intended for.
> This means that cifs_sb_tlink may search the rbtree using the wrong fsuid=
,
> and return a tlink with an incorrect session than
> the lease break was intended for. As a result, the breaks
> may be ACKed through an incorrect session.
>
> While it seems that Samba/Windows Servers 2016-2025 ignore this as long a=
s
> the lease key is correct, we ran into a case where if you're using
> NetApp ONTAP or Azure NetApp Files they will reject the ACK
> and return `STATUS_LOCK_NOT_GRANTED` errors on any future read requests
> a user may initiate through their still held open file handle,
> and the server will eventually close the file.
>
> In the dmesg logs, the user may see errors like these:
>
> CIFS: Status code returned 0xc0000128 STATUS_FILE_CLOSED
> CIFS: VFS: Send error in read =3D -9
>
> With a multiuser mount using NetApp, this issue is really easy
> for users to hit on a wide variety of kernel versions
> by attempting to copy a file from the share
> to the local machine through GNOME Files/Nautilus.
> This copy will always result in Nautilus throwing
> a `Bad File Descriptor` error to the user and fail.
> With this fix, you can copy files through Nautilus without issue.
>
> From looking at the traces, it seems that glib will
> open the file first, and call listxattr before actually attempting
> to copy the file data. The listxattr call always triggers a break,
> causing the copy to fail.
>
> The proposed fix returns to the way the client grabbed the tlink before
> commit e8f5f849ffce2 ("cifs: fix potential oops in cifs_oplock_break").
>
> The bulk of that commit (checking for list empty) remains untouched, and
> I think the change to using cifs_sb_tlink was intended to avoid a
> NULL/ERR deference on the tlink as well as update the reference count.
>
> I believe this fix should preserve those safety properties, but of course
> I'd appreciate any corrections here.
>
> Fixes: e8f5f849ffce2 ("cifs: fix potential oops in cifs_oplock_break")
> Cc: stable@vger.kernel.org
> Signed-off-by: April Cardenas <april.cardenas@canonical.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks.
