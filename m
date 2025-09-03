Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A812D9EE2
	for <linux-cifs@vger.kernel.org>; Wed,  3 Sep 2025 20:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756931303; cv=none; b=NlWkIWnUiR2gF4JB/cwJp3Iu0CKgx2LpcmDMUh36sCYcrLMTQMf0vRuyJObFoR64hhKY6Ns3/OY1TUzqkTkyvB4i/gcUW+zpO7if2sxINrtRjaV4gsTjWg/dJ1EJRdGOodFdkRqnpzCjpsvIGFMCl5YByKtMd7BOm4MtPEGEhuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756931303; c=relaxed/simple;
	bh=un1MyGTzNWQqUpOab5xodRvJBSBU7mvi/ppqB9lZVb8=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=X275owan/ZOBsFCGnY3H0edFUhVqYDwRuIcbohNNYYu3D6/ZwLRtu7uUC0EsEKNC7581WeJO2tCHS0+FCZkpuZz0m8I4LtlSqSY9CNbeJ6c4OyJ0GzHpSTv6nz02RxsvcRetQivCfxfOLkEgZg4IJyT9CpssPAjl6PmFr1Lpd9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=1vL17kHK; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="1vL17kHK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xNB5EFKfZYBultzhOWbZyub7bb7MTeI9iHw75pHIJRA=; b=1vL17kHKHddq8JjqiE9e20tiYO
	xneNlBELt1L8FTLFVPUlfJ8RYWThmReUi7wAz9KTozGoqXjqgOoiXgnsIzfWheEBrl+c/npJYBSF5
	qVyxsLrfW1PGfbWAA1w+F9jC2g0H4UVlp/+ZvR7yZvwBEoFwC/g3zVB9qT7sBm11+pdqtOF05d15o
	OG7OiUf0Otns4f9niL6V/poFDspvO0NbUGBEvtoRiqfIbvpwLdr14g0R/MRMjjG0+MG7PV0AuvN6f
	hZdbwamiA4R3qQPIW/dbefCyN0Evs0RXkaWdNujm8KDjuDZrE19qBRCk4KIkHtIt+XaNqY1aRZ7V/
	kmQqnSDA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1utu5a-00000000mVl-28H2;
	Wed, 03 Sep 2025 17:28:18 -0300
Message-ID: <28081fd56fa72705de6616f5c29f3695@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Boehme <slow@samba.org>, smfrench@gmail.com, Jean-Baptiste Denis
 <jbdenis@pasteur.fr>, Frank Sorenson <sorenson@redhat.com>, Olga
 Kornievskaia <okorniev@redhat.com>, Benjamin Coddington
 <bcodding@redhat.com>, Scott Mayhew <smayhew@redhat.com>,
 linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: fix data loss due to broken rename(2)
In-Reply-To: <CAN05THSmQ-75m4dVDBiXoLLNcXnMCJbnCVCK-=ev0F98eDDwxg@mail.gmail.com>
References: <20250902165451.892165-1-pc@manguebit.org>
 <cd16cf45-efc8-4324-9d40-0b92f15f179a@samba.org>
 <da2380aa8e3718066bfc151bf60e54ea@manguebit.org>
 <d3702a1b-0dfc-4d56-8f0c-0cd588f151b2@samba.org>
 <faf6c4eaa69a36617d65327b98ed105d@manguebit.org>
 <CAN05THSWdDsuqBTkdL5H2tjBwNgPeO4k6fYFEqkYS_P3oc0t8Q@mail.gmail.com>
 <CAN05THSmQ-75m4dVDBiXoLLNcXnMCJbnCVCK-=ev0F98eDDwxg@mail.gmail.com>
Date: Wed, 03 Sep 2025 17:28:18 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

ronnie sahlberg <ronniesahlberg@gmail.com> writes:

> On Thu, 4 Sept 2025 at 05:55, ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>>
>> On Thu, 4 Sept 2025 at 04:46, Paulo Alcantara <pc@manguebit.org> wrote:
>> >
>> > Ralph Boehme <slow@samba.org> writes:
>> >
>> > > Hi Paulo,
>> > >
>> > > On 9/2/25 9:09 PM, Paulo Alcantara wrote:
>> > >> Ralph Boehme <slow@samba.org> writes:
>> > >>
>> > >>> Why not simply fail the rename instead of trying to implement some
>> > >>> clever but complex and error prone fallback?
>> > >>
>> > >> We're doing this for SMB1 for a very long time and haven't heard of any
>> > >> issues so far.  I've got a "safer" version [1] that does everything a
>> > >> single compound request but then implemented this non-compound version
>> > >> due to an existing Azure bug that seems to limit the compound in 4
>> > >> commands, AFAICT.  Most applications depend on such behavior working,
>> > >> which is renaming open files.
>> > >
>> > > maybe I'm barking of the wrong tree, but you *can* rename open files:
>> > >
>> > > $ bin/smbclient -U 'USER%PASS' //IP/C\$
>> > > smb: \> cd Users\administrator.WINCLUSTER\Desktop\
>> > > smb: \Users\administrator.WINCLUSTER\Desktop\> open
>> > > t-ph-oplock-b-downgraded-s.cab
>> > > open file
>> > > \Users\administrator.WINCLUSTER\Desktop\t-ph-oplock-b-downgraded-s.cab:
>> > > for read/write fnum 1
>> > > smb: \Users\administrator.WINCLUSTER\Desktop\> rename
>> > > t-ph-oplock-b-downgraded-s.cab renamed
>> > > smb: \Users\administrator.WINCLUSTER\Desktop\>
>> > >
>> > > ...given the open is with SHARE_DELETE (had to tweak smbclient to
>> > > actually allow that).
>> >
>> > Interesting.
>> >
>> > cifs.ko will get STATUS_ACCESS_DENIED when attempting to rename the open
>> > file.  The file was open with SHARE_READ|SHARE_WRITE|SHARE_DELETE, BTW.
>> >
>> > Also, note that cifs.ko will not reuse the open handle, rather it will
>> > send a compound request of create+set_info(rename)+close to the file
>> > which will fail with STATUS_ACCESS_DENIED.
>> >
>> > What am I missing?
>> >
>> > > If the rename destination is open and the server rightly fails the
>> > > rename for that reason, then masking that error is a mistake imho.
>> > >
>> > > When doing
>> > >
>> > > $ mv a b
>> > >
>> > > the user asked to rename a, he did NOT ask to rename b which becomes
>> > > important, because if you do
>> > >
>> > > rename("b", ".renamehackXXXX")
>> > >
>> > > under the hood and then reattempt the rename
>> > >
>> > > rename("a", "b")
>> > >
>> > > and then the user subsequently does
>> > >
>> > > $ mv b ..
>> > > $ cd ..
>> > > $ rmdir DIR
>> > >
>> > > where DIR is the directory all of the above was performed inside, the
>> > > rmdir will fail with ENOTEMPTY and *now* the user is confused.
>> >
>> > Yes, I understand your point.  That's really confusing.
>> >
>> > How can we resolve above cases without performing the silly renames
>> > then?
>> >
>>
>> I think you can't.  CIFS, without the posix extensions, is basically
>> not posix and never will be.
>> You can make it close but it will never be perfect and you will have
>> to decide on how/what posix semantics you need to give up.
>>
>> What compounds the issue is that cifs on linux (without the posix
>> extensions) will also always be a second class citizen.
>> Genuine windows clients own this protocol and they expect their own
>> non-posix semantics for their vfs, so you can't do anything that
>> impacts windows clients, they are the first class citizen here.
>>
>> The two main issues I see with the silly renames are the "-ENOTEMPTY"
>> error when trying to delete the "empty" directory, but also
>> that you can not hide them from windows clients. And what happens if
>> the windows clients start accessing them?
>>
>> I think the only real solution is to say "if you need posix semantics
>> then you need to use the posix extensions".
>
> Another potential issue is about QUERY_INFO.
> Many of the information classes in FSCC return the filename as as part
> of the data.
> What filename should be returned for a silly renamed file?
>
> Maybe it doesn't matter  but maybe there is some obscure windows
> application out there that do care and gets surprised.

I don't think that matters as file deletion is pending on the server and
QUERY_INFO won't work.

What am I missing?
