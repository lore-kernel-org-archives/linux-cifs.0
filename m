Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362B139B960;
	Wed, 26 Aug 2026 22:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787784370; cv=none; b=dUpMNE7IDzBSGwJd0ZjJPwYBl2NyNGTrFe0sD5zFwF28i0OPmGrlSnxVPClD77Yo/WDujrtQ+29vt0c3cQtgGxLDk4tECKbtws+LssHVHtnr/Vjk+QaOLrelf5KCapbCBcV12tsr+eeHgm2FnYrWYhX4vN63McmXv5MSAC4PVOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787784370; c=relaxed/simple;
	bh=a/k0oGALKGcR1YG6vIA9R7IM2I+Buj51KyQ5jysoFGU=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=WODg+MqSPV3fk3dZrH5iKBv0HHDoX2dcOIpTK7jB9DhQUz8FG4sV/fkW63iAHglDyQuv79uv4jeK82vkSlCxqkdATM+s2sqnhnNsL/QWeDh2G+NebiYfYMcNehDUae2saKCu8zi4VbH4RqUty6xrMeBkG4v0h9phMJ78FFK1S08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=eXQ1tMeJ; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="eXQ1tMeJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=X/u+WH9V0cxkiHc9PWcoiS8u9bSUsjJuZoNcrK/RAT8=; b=eXQ1tMeJuNASXD+PLvXDACEOrV
	QQGqdUVI8tYA2bKwygpWb5ose7HYrBjAwLKdhtBGQ0DXin8xfmJQTctqWjUEuAmkb9d7HJDVCr9dx
	hfYQ/Rpr4P3Bzw7XhNquhWrTG3eS9WA/wGMAvQidBMcZkhd6ZWda0M2SC/9TCflIhrmyQ9dzNiY2p
	27zKbYG0UzN+g8R7BgxBrM5IwX6sxIx5JMWHzaNBaD7OMIP4MKRUpr/HTOjNsd8Z2hGSd2AhdKZ4f
	u3cLTM0XmvNmiSMw8XivpM1Kej2UKQTUaXFTlyLlJvMTCK6aNfIpTxTlk6o3QzIbWTasKpK1RtQth
	cntYpV6g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wzMNd-000000004DZ-0hZu;
	Wed, 26 Aug 2026 19:46:01 -0300
Message-ID: <59a8b739c6b925fdc4fda0580852f91e@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Namjae Jeon <linkinjeon@kernel.org>, Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, stable@vger.kernel.org, Paulo Alcantara
 <pc@manguebit.com>
Subject: Re: [PATCH v4 1/2] cifs: don't update i_size in cifs_do_truncate()
 without a cached handle
In-Reply-To: <CAKYAXd-st8zvEiMTKw5vggFVTvY_Ln5nA3zeZgThuqQuQxAZtA@mail.gmail.com>
References: <20260821184109.1834871-1-sorenson@redhat.com>
 <20260821184109.1834871-2-sorenson@redhat.com>
 <CAKYAXd-st8zvEiMTKw5vggFVTvY_Ln5nA3zeZgThuqQuQxAZtA@mail.gmail.com>
Date: Wed, 26 Aug 2026 19:46:00 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Namjae Jeon <linkinjeon@kernel.org> writes:

> On Sat, Aug 22, 2026 at 3:41=E2=80=AFAM Frank Sorenson <sorenson@redhat.c=
om> wrote:
>>
>> If find_writable_file() returns NULL, cifs_file_flush() returns 0
>> without issuing set_file_size, and the outer if (!rc) block sets i_size
>> to 0 before the server is told to truncate.  If the subsequent
>> cifs_open() fails, the inode is stranded at size 0 while the server
>> file is unchanged.
>>
>> Move netfs_resize_file() and cifs_setsize() inside the if (cfile) arm
>> so they only run after a successful set_file_size().  In the no-handle
>> else branch, call truncate_inode_pages() to evict stale pages before
>> the O_TRUNC open: cifs_invalidate_cache() is fscache-only and does not
>> touch the VFS page cache, so without it old pages persist and may be
>> served as stale data after a later file extension.
>>
>> Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_=
TRUNC")
>> Cc: stable@vger.kernel.org
>> Cc: Paulo Alcantara <pc@manguebit.com>
>> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
>> ---
>>  fs/smb/client/file.c | 18 ++++++++++++++----
>>  1 file changed, 14 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
>> index 389083f9ce00..05aeb9d94ffe 100644
>> --- a/fs/smb/client/file.c
>> +++ b/fs/smb/client/file.c
>> @@ -1012,10 +1012,20 @@ static int cifs_do_truncate(const unsigned int x=
id, struct dentry *dentry)
>>                         server =3D tcon->ses->server;
>>                         rc =3D server->ops->set_file_size(xid, tcon,
>>                                                         cfile, 0, false);
>> -               }
>> -               if (!rc) {
>> -                       netfs_resize_file(&cinode->netfs, 0, true);
>> -                       cifs_setsize(inode, 0);
>> +                       if (!rc) {
>> +                               netfs_resize_file(&cinode->netfs, 0, tru=
e);
>> +                               cifs_setsize(inode, 0);
>> +                               cifs_invalidate_cache(inode, 0);
>> +                       }
>> +               } else {
>> +                       /*
>> +                        * No cached handle; the server truncates as par=
t of the
>> +                        * O_TRUNC open request that follows.  Evict sta=
le pages
>> +                        * from the page cache now so they cannot be ser=
ved as
>> +                        * stale data after the file is later extended; =
i_size is
>> +                        * updated from the server's open response.
>> +                        */
>> +                       truncate_inode_pages(inode->i_mapping, 0);
> truncate_inode_pages() expects both ->i_rwsem and ->invalidate_lock to
> be held. Please check the comment of truncate_inode_pages().

Frank, please resend with the expected locks held.
