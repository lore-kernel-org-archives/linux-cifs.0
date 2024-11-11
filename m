Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C5615666B
	for <linux-cifs@vger.kernel.org>; Mon, 11 Nov 2024 12:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731326649; cv=fail; b=icU8cgRge5DhQOhCfPS775CIB9EZLQlYq+PbtRrYdxLhaMcvA8vA26Teg0z552/cQG1+x3LjlIrP7c/kkNcCn75ajVNHoIGo6lygYrxlM5gTuDegqkQjK6aa0PqxZEN4jUZMI3bf0axlGpUzADIqeoXT4zIso/QDDJHU7X0Kwbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731326649; c=relaxed/simple;
	bh=kvoFiBBs8gXmjAPxqGuQK4zVGm29Jt+7gTMTKf6ctPo=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=JVDZoscdhhBITrLNaRQ7oHyjfmiPE4UFTxW9hB0PfJTDY4oMovcUQc4UhZ0PJH9zyYYHePMZjUvOC2/5Vp7NNYB2+MUVFVzXGkrbwUYNOyQmVe+aY6d+DKmYRQbqqgMLgIbr6GlAF8Woda7slfFOSpZyh8ZqQ9UCF5ODrui14Q4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=gExsD9+u; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="gExsD9+u"
Message-ID: <b8164b0a49ad6d4cd60142fa55ad3566@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731326640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bk7UH2kuN9dzwDFVDSivvcjE08Fbv7fH9vSTXGdc9tc=;
	b=gExsD9+uVc+OXSR80n1g6fT9/xdfYxOP2S66e9U/qcN4U1YWyOYkNpOv3fk0aG8fYEzC5W
	+tLIl+Lupe6/dDSgm0PTZK1QP0ykhtlf5OiQEvglf6N0aXAqzaQFEmbjUOQIT0fmDyIyge
	ynY4a+sqjK3yWyrLKUU9oV4TQ+PqRzY1l3LsVyCkZctij8LAWo1NEW6iLUElqGB12CldI6
	XJLTuTGO7WlafsXmPcvlXT16y84v8dMRVRsBrVJVSp27zIExCRIpyL4ZlR3Okp421ZeIFv
	ccBpBFsv8U9dOJTLBCdYpyGwGdIVg8/W/qnVGhOsWUI8Yo4+NDPkzVcUCXkdpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731326640; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bk7UH2kuN9dzwDFVDSivvcjE08Fbv7fH9vSTXGdc9tc=;
	b=OO2rCIdDgiegq9TM8Z307DSkRtXGvGvh51yytK5W4XD9FnLFROsCIf4G9IpvnbWkiCpSQd
	EyQRcesYHAZnG34G0RW9GJbZF4QEdiVA61HXSlw5Grgu5fh0wJuz/9mhIMjlemGitXTMcB
	RCSqpn6a3YxWfTcj+trQFgaWPJ8mcHnmCz9cYb8q7Hu9ZDy3jImrWrOMJ836CRVcxvwtq2
	npGpknx97u6oqEYwHQ3TY23aQHKVTzxxXj74GfK7StmShJI8wUNHuCgxKcEuLUj68+ifRT
	g9Nrq+8C2JRfV7HvWwwArXmibah3jwyu7pM4PHWLdhv53LXaVfg68+Fpkk4+Gw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1731326640; a=rsa-sha256;
	cv=none;
	b=gjvEAc2yFz3kpeF0mGdnKKdfe5hmCDm5c13WrP8Mink1GF+Hp6ueOBg4LN2To4FE/+pZwl
	3uoz6/xhDjhhfL/Y6X6Szn6w763M1UZEyxZlniiZ/uBUlM1pFV/ZBp2arbUKu3gDWoK5+i
	UnaVAEhkQjCUgYKzyW1lq0WlRBEnLk/Q/TpQTOQOGch80mp8JZXLJDFvoLqt8IUW9a2Qp1
	zqH3CiV6ix2aciSRXiqImYjswT0iRclMZGUvnkxJrGbao9wD+GwSkvMKBNvpOHacZiJDG1
	lBIOzh2hzlj3a9a/PBQS+DAtqNKOWnG6/vbaGkO2vAW0kIu0mnUdF6rq6DB8Gw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
From: Paulo Alcantara <pc@manguebit.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: meetakshisetiyaoss@gmail.com, smfrench@gmail.com, sfrench@samba.org,
 sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
 bharathsm.hsk@gmail.com, Meetakshi Setiya <msetiya@microsoft.com>
Subject: Re: [PATCH 1/2] cifs: during remount, make sure passwords are in sync
In-Reply-To: <CANT5p=pFCbi1H-JzRLx5XqL4Qwy-YbOWAX6XmoWXezSn2i__mQ@mail.gmail.com>
References: <20241030142829.234828-1-meetakshisetiyaoss@gmail.com>
 <1f8a225b0d16fdfa05c417e0f6602489@manguebit.com>
 <CANT5p=rm90eHDeA669yRNdKvT=GL+NE1PVTJVS-htQ8pbfiwUA@mail.gmail.com>
 <CANT5p=pFCbi1H-JzRLx5XqL4Qwy-YbOWAX6XmoWXezSn2i__mQ@mail.gmail.com>
Date: Mon, 11 Nov 2024 09:03:56 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Shyam Prasad N <nspmangalore@gmail.com> writes:

> On Fri, Nov 8, 2024 at 5:47=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail=
.com> wrote:
>> > What about SMB sessions from cifs_tcon::dfs_ses_list?  I don't see the=
ir
>> > password getting updated over remount.
>>
>> This is in our to-do list as well.
>
> I did some code reading around how DFS automount works.
> @Paulo Alcantara Correct me if I'm wrong, but it sounds like we make
> an assumption that when a DFS namespace has a junction to another
> share, the same credentials are to be used to perform the mount of
> that share. Is that always the case?

Yes, it inherits fs_context from the parent mount.  For multiuser
mounts, when uid/gid/cruid are unspecified, we need to update its values
to match real uid/gid from the calling process.

> If we go by that assumption, for password2 to work with DFS mounts, we
> only need to make sure that in cifs_do_automount, cur_ctx passwords
> are synced up to the current ses passwords. That should be quite easy.

Correct.  The fs_context for the automount is dup'ed from the parent
mount.  smb3_fs_context_dup() already dups password2, so it should work.

The 'remount' case isn't still handled, that's why I mentioned it above.
You'd need to set password2 for all sessios in @tcon->dfs_ses_list.

I think we need to update password2 for the multiuser sessions as well
and not only for session from master tcon.
