Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB984C9D
	for <linux-cifs@vger.kernel.org>; Wed,  3 Sep 2025 20:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756930744; cv=none; b=kFKlmW1HZ3/MIvvIRaJaMOw+GR/80uJqiVK3q5Wx1lyQ75uPHoNRWgkin/V+hkGs/w4msWpjw/10H7HrLbzWqotFFyXG1MuoWYk4qatk/YDDrWjKiQeI8645Da7DLYdIEyMDG5892gs21uC02K18p74aS4ecT3ngzO+rbIHNn44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756930744; c=relaxed/simple;
	bh=G6dn9Fdk12+kHNCCMwgynI87wbVQU6yNzIuF48Ihf8s=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Axc2szuwpwv2zaxL5D9stQGat0kN6y5yWtmXSR1d1Vi4OaAuOSH04sOK/eRDjy7XZUhVESfEvWcJzwg5f9tJhzsm7ABfilNmvxnzR5R67iJytUxT0PdVjf1KMvmis07/sBM+FX6EvBdqTK9KwVEwurwTzeS4br7Ekpj/S7lzipY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=v9pdeGt1; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="v9pdeGt1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iit+lXatMTj8jrpm70xhXU2hiXMi8WqRX+XuI1GpMlc=; b=v9pdeGt1wOWitB7DwGgH0jD7Ej
	DDPDwpWKyrs6Svgq8LxXATUzm1LPXxJhhPaZBykzbybLvVBHAhwOBYFntaPxLqsPITx2BOGF5wxki
	TwycOOmfhjW0IH+h4qcBSlWgkUVbM22hzkd1F54d6nKam3bqxl33cs6d8BZEDom3/b8xUOvq7MHMm
	2DgAmtW5CbPIOvrhi1AiFUG4J5ABxBmVWWs72X475rgyRzlSAZYTGxTwawugvb5iSyGTZoRzyJocC
	bzOQUa9NF5Qz2+UGQtKHmky3EaTfkryov2mM8sTgWx95Wn3/H97jrnYGcSYn0jwlxhs2lGpA3uIbS
	aso2MVow==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uttwa-00000000mSM-0SHi;
	Wed, 03 Sep 2025 17:19:00 -0300
Message-ID: <ff16f9600e0a8af40b60c79996f049a1@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Boehme <slow@samba.org>, smfrench@gmail.com, Jean-Baptiste Denis
 <jbdenis@pasteur.fr>, Frank Sorenson <sorenson@redhat.com>, Olga
 Kornievskaia <okorniev@redhat.com>, Benjamin Coddington
 <bcodding@redhat.com>, Scott Mayhew <smayhew@redhat.com>,
 linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: fix data loss due to broken rename(2)
In-Reply-To: <CAN05THSWdDsuqBTkdL5H2tjBwNgPeO4k6fYFEqkYS_P3oc0t8Q@mail.gmail.com>
References: <20250902165451.892165-1-pc@manguebit.org>
 <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
 <da2380aa8e3718066bfc151bf60e54ea@manguebit.org>
 <d3702a1b-0dfc-4d56-8f0c-0cd588f151b2@samba.org>
 <faf6c4eaa69a36617d65327b98ed105d@manguebit.org>
 <CAN05THSWdDsuqBTkdL5H2tjBwNgPeO4k6fYFEqkYS_P3oc0t8Q@mail.gmail.com>
Date: Wed, 03 Sep 2025 17:18:59 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

ronnie sahlberg <ronniesahlberg@gmail.com> writes:

> On Thu, 4 Sept 2025 at 04:46, Paulo Alcantara <pc@manguebit.org> wrote:
>>
>> Ralph Boehme <slow@samba.org> writes:
>>
>> > Hi Paulo,
>> >
>> > On 9/2/25 9:09 PM, Paulo Alcantara wrote:
>> >> Ralph Boehme <slow@samba.org> writes:
>> >>
>> >>> Why not simply fail the rename instead of trying to implement some
>> >>> clever but complex and error prone fallback?
>> >>
>> >> We're doing this for SMB1 for a very long time and haven't heard of any
>> >> issues so far.  I've got a "safer" version [1] that does everything a
>> >> single compound request but then implemented this non-compound version
>> >> due to an existing Azure bug that seems to limit the compound in 4
>> >> commands, AFAICT.  Most applications depend on such behavior working,
>> >> which is renaming open files.
>> >
>> > maybe I'm barking of the wrong tree, but you *can* rename open files:
>> >
>> > $ bin/smbclient -U 'USER%PASS' //IP/C\$
>> > smb: \> cd Users\administrator.WINCLUSTER\Desktop\
>> > smb: \Users\administrator.WINCLUSTER\Desktop\> open
>> > t-ph-oplock-b-downgraded-s.cab
>> > open file
>> > \Users\administrator.WINCLUSTER\Desktop\t-ph-oplock-b-downgraded-s.cab:
>> > for read/write fnum 1
>> > smb: \Users\administrator.WINCLUSTER\Desktop\> rename
>> > t-ph-oplock-b-downgraded-s.cab renamed
>> > smb: \Users\administrator.WINCLUSTER\Desktop\>
>> >
>> > ...given the open is with SHARE_DELETE (had to tweak smbclient to
>> > actually allow that).
>>
>> Interesting.
>>
>> cifs.ko will get STATUS_ACCESS_DENIED when attempting to rename the open
>> file.  The file was open with SHARE_READ|SHARE_WRITE|SHARE_DELETE, BTW.
>>
>> Also, note that cifs.ko will not reuse the open handle, rather it will
>> send a compound request of create+set_info(rename)+close to the file
>> which will fail with STATUS_ACCESS_DENIED.
>>
>> What am I missing?
>>
>> > If the rename destination is open and the server rightly fails the
>> > rename for that reason, then masking that error is a mistake imho.
>> >
>> > When doing
>> >
>> > $ mv a b
>> >
>> > the user asked to rename a, he did NOT ask to rename b which becomes
>> > important, because if you do
>> >
>> > rename("b", ".renamehackXXXX")
>> >
>> > under the hood and then reattempt the rename
>> >
>> > rename("a", "b")
>> >
>> > and then the user subsequently does
>> >
>> > $ mv b ..
>> > $ cd ..
>> > $ rmdir DIR
>> >
>> > where DIR is the directory all of the above was performed inside, the
>> > rmdir will fail with ENOTEMPTY and *now* the user is confused.
>>
>> Yes, I understand your point.  That's really confusing.
>>
>> How can we resolve above cases without performing the silly renames
>> then?
>>
>
> I think you can't.  CIFS, without the posix extensions, is basically
> not posix and never will be.
> You can make it close but it will never be perfect and you will have
> to decide on how/what posix semantics you need to give up.

Agreed.

> What compounds the issue is that cifs on linux (without the posix
> extensions) will also always be a second class citizen.
> Genuine windows clients own this protocol and they expect their own
> non-posix semantics for their vfs, so you can't do anything that
> impacts windows clients, they are the first class citizen here.

Yep.

> The two main issues I see with the silly renames are the "-ENOTEMPTY"
> error when trying to delete the "empty" directory, but also
> that you can not hide them from windows clients. And what happens if
> the windows clients start accessing them?

Any potential concurrent opens on the silly-renamed file will fail with
STATUS_DELETE_PENDING.

> I think the only real solution is to say "if you need posix semantics
> then you need to use the posix extensions".

If they expect *full* POSIX semantics, yes, that makes sense.  But if
the protocol allows implementing part of it, why not doing it?
