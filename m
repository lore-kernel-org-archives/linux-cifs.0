Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5722C0F67
	for <linux-cifs@vger.kernel.org>; Wed,  3 Sep 2025 18:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756925148; cv=none; b=TfQia35kJMZbCMSdJ4aE59tWv+09tW6PVWYfAT6mCzfd3eJ5CrgUC7RWL0001E9eMfo6pzVx/WUbqiCfQt16yCINuB6Stuyv8+/mr9LQsl5pWzsI7YbT9Uj+yfGGNPLAGAJh7DOmcLgyPFjHXZxtiS+FPbcdaV9Lams9RpXBbMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756925148; c=relaxed/simple;
	bh=/aoonQmEgUyE+plmF4LYyTap3VRV+N/jqXQ+rQviaEk=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=F9iDeAKD5xM9hpt3rdnQrqbLI+nZiojXDqLtWpwmd2Nm/6rc7RKW7+8Mr9HTncr8JTC5pY0CpvXzArZyr/Q2gB6je5yRqhkSgwUxKrO8DoGAv8uz8iWOyaVSqGnCLnZxNURUtuhZ+C7cC+CnCk6u9IwuT76Vi0jNzs2bfNazHWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=kDtUH9vy; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="kDtUH9vy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eyvwLFtEdkF+AMBYmwsn6OFPHk8npock6l/PJfy+mTw=; b=kDtUH9vyqOfkTTKHXGVjzmm3as
	laT8Eudw+ewDlaxVweLAyK0vY75siko3Otg7/KqKD3SPRq8dBkcTcpubdhpUEGsrSfUGNw2MOx8xV
	Xkdj1Ma/2LMveLaC/p8Ooq95CxF5o3V0FL6Py+yaaSXVomF4OMxHMY2XiOwNxH6Oc/6exS6j+qdK/
	WhhTFMeq5LiqdQxU4sxycQf7oCozAKPsd3aPKe/SasCAIMEmZl07h5uVdsT5Rjhae8eyI9EV74G3c
	cHF4oq5/yUwNZh5/DE3Mqvl5rLBfLoy0QiSCSUZV8XEiQ0e+QboFD3Gl88V1Qg2Apj8GPibw9rzVJ
	NLuRzYHg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1utsUE-00000000mAv-01AL;
	Wed, 03 Sep 2025 15:45:38 -0300
Message-ID: <faf6c4eaa69a36617d65327b98ed105d@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Ralph Boehme <slow@samba.org>, smfrench@gmail.com
Cc: Jean-Baptiste Denis <jbdenis@pasteur.fr>, Frank Sorenson
 <sorenson@redhat.com>, Olga Kornievskaia <okorniev@redhat.com>, Benjamin
 Coddington <bcodding@redhat.com>, Scott Mayhew <smayhew@redhat.com>,
 linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: fix data loss due to broken rename(2)
In-Reply-To: <d3702a1b-0dfc-4d56-8f0c-0cd588f151b2@samba.org>
References: <20250902165451.892165-1-pc@manguebit.org>
 <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
 <da2380aa8e3718066bfc151bf60e54ea@manguebit.org>
 <d3702a1b-0dfc-4d56-8f0c-0cd588f151b2@samba.org>
Date: Wed, 03 Sep 2025 15:45:37 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ralph Boehme <slow@samba.org> writes:

> Hi Paulo,
>
> On 9/2/25 9:09 PM, Paulo Alcantara wrote:
>> Ralph Boehme <slow@samba.org> writes:
>> 
>>> Why not simply fail the rename instead of trying to implement some
>>> clever but complex and error prone fallback?
>> 
>> We're doing this for SMB1 for a very long time and haven't heard of any
>> issues so far.  I've got a "safer" version [1] that does everything a
>> single compound request but then implemented this non-compound version
>> due to an existing Azure bug that seems to limit the compound in 4
>> commands, AFAICT.  Most applications depend on such behavior working,
>> which is renaming open files.
>
> maybe I'm barking of the wrong tree, but you *can* rename open files:
>
> $ bin/smbclient -U 'USER%PASS' //IP/C\$
> smb: \> cd Users\administrator.WINCLUSTER\Desktop\
> smb: \Users\administrator.WINCLUSTER\Desktop\> open 
> t-ph-oplock-b-downgraded-s.cab
> open file 
> \Users\administrator.WINCLUSTER\Desktop\t-ph-oplock-b-downgraded-s.cab: 
> for read/write fnum 1
> smb: \Users\administrator.WINCLUSTER\Desktop\> rename 
> t-ph-oplock-b-downgraded-s.cab renamed
> smb: \Users\administrator.WINCLUSTER\Desktop\>
>
> ...given the open is with SHARE_DELETE (had to tweak smbclient to 
> actually allow that).

Interesting.

cifs.ko will get STATUS_ACCESS_DENIED when attempting to rename the open
file.  The file was open with SHARE_READ|SHARE_WRITE|SHARE_DELETE, BTW.

Also, note that cifs.ko will not reuse the open handle, rather it will
send a compound request of create+set_info(rename)+close to the file
which will fail with STATUS_ACCESS_DENIED.

What am I missing?

> If the rename destination is open and the server rightly fails the 
> rename for that reason, then masking that error is a mistake imho.
>
> When doing
>
> $ mv a b
>
> the user asked to rename a, he did NOT ask to rename b which becomes 
> important, because if you do
>
> rename("b", ".renamehackXXXX")
>
> under the hood and then reattempt the rename
>
> rename("a", "b")
>
> and then the user subsequently does
>
> $ mv b ..
> $ cd ..
> $ rmdir DIR
>
> where DIR is the directory all of the above was performed inside, the 
> rmdir will fail with ENOTEMPTY and *now* the user is confused.

Yes, I understand your point.  That's really confusing.

How can we resolve above cases without performing the silly renames
then?
