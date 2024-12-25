Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754871CA81
	for <linux-cifs@vger.kernel.org>; Wed, 25 Dec 2024 14:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735138073; cv=none; b=gM5WTJLgdzpDojU/3JcBj3qvxIeNFe6u32TgCTsyRKp4M8FRByiuyy5v7G/OxCB29kuGDGAbRgbIFEcJETkzMhWDNYBr8K1e5yNrJ529pFaGtx+6yT5iuUNlT8YhXlamBI4qtqv7X8UOFp1OVRvVSPlooL7+JrbR7YoQeidvP7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735138073; c=relaxed/simple;
	bh=9jvbF1yGF8xC5fl4/s5wZreZW1tG5/yv872AIQ9eTGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o62z7lNynHzueV6ibQ/W30MKHdwnKhIyX8z4ZucDvTFRfoTg6hFuRvJRGnq1lpCECtDsOovkGWt0uLdtZapcMhXV9SF4fvz4USTvKm33dfxbxopHf8ATmdmf8QNJ/3PYlJeEOIY6CzbOWw2f3WTWisNsFsTz13UguEjtDcyLKzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tz0pWUas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tz0pWUas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9427C4CECD;
	Wed, 25 Dec 2024 14:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735138072;
	bh=9jvbF1yGF8xC5fl4/s5wZreZW1tG5/yv872AIQ9eTGk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tz0pWUas5aa4bOhsN9Nrud7URWY6vlvf0D5Q9J3NnrzlU5egnd7Q0tL279tg1c5j5
	 MhWrLAAnB1HBM5HV87mhDm2oHQPKpvr0c939rhyCbHPKF8e9JTxsbkJItRoPwXFCi9
	 e821u3I9JLLmh/MX8s7sxgHIL7a7dbVh3eHtxBFxGWKP3DZ+PmyPYQfPZnFURYiVH7
	 u+eEIoIfDnKMkswuvHIyK1OKZ0r/ZNXrT/XuzawUfEwQHgy0Ts9JSkXb80vnKoIict
	 qfV+UmF0y9HuarG7Unx78Uq+6r8azcCyKgSq1y83LZcDmlrmKY8LF+B0lGUYnk7V30
	 8mCr/+BWIYShA==
Received: by pali.im (Postfix)
	id 7AF4878E; Wed, 25 Dec 2024 15:47:42 +0100 (CET)
Date: Wed, 25 Dec 2024 15:47:42 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Subject: Re: SMB2 DELETE vs UNLINK
Message-ID: <20241225144742.zef64foqrc6752o7@pali>
References: <20241006103127.4f3mix7lhbgqgutg@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241006103127.4f3mix7lhbgqgutg@pali>
User-Agent: NeoMutt/20180716

On Sunday 06 October 2024 12:31:27 Pali Rohár wrote:
> Hello,
> 
> Windows NT systems and SMB2 protocol support only DELETE operation which
> unlinks file from the directory after the last client/process closes the
> opened handle.
> 
> So when file is opened by more client/processes and somebody wants to
> unlink that file, it stay in the directory until the last client/process
> stop using it.
> 
> This DELETE operation can be issued either by CLOSE request on handle
> opened by DELETE_ON_CLOSE flag, or by SET_INFO request with class 13
> (FileDispositionInformation) and with set DeletePending flag.
> 
> 
> But starting with Windows 10, version 1709, there is support also for
> UNLINK operation, via class 64 (FileDispositionInformationEx) [1] where
> is FILE_DISPOSITION_POSIX_SEMANTICS flag [2] which does UNLINK after
> CLOSE and let file content usable for all other processes. Internally
> Windows NT kernel moves this file on NTFS from its directory into some
> hidden are. Which is de-facto same as what is POSIX unlink. There is
> also class 65 (FileRenameInformationEx) which is allows to issue POSIX
> rename (unlink the target if it exists).
> 
> What do you think about using & implementing this functionality for the
> Linux unlink operation? As the class numbers are already reserved and
> documented, I think that it could make sense to use them also over SMB
> on POSIX systems.
> 
> 
> Also there is another flag FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE
> which can be useful for unlink. It allows to unlink also file which has
> read-only attribute set. So no need to do that racy (unset-readonly,
> set-delete-pending, set-read-only) compound on files with more file
> hardlinks.
> 
> I think that this is something which SMB3 POSIX extensions can use and
> do not have to invent new extensions for the same functionality.
> 
> 
> [1] - https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/wdm/ne-wdm-_file_information_class
> [2] - https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntddk/ns-ntddk-_file_disposition_information_ex
> [3] - https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntifs/ns-ntifs-_file_rename_information

And now I figured out that struct FILE_FS_ATTRIBUTE_INFORMATION which
has member FileSystemAttributes contains new documented bit:

0x00000400 - FILE_SUPPORTS_POSIX_UNLINK_RENAME
The file system supports POSIX-style delete and rename operations.

See Windows NT spec:
https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntifs/ns-ntifs-_file_fs_attribute_information

Interesting is that this struct FILE_FS_ATTRIBUTE_INFORMATION is
available over SMB protocol too but bit value 0x00000400 is not
documented in [MS-FSCC] section 2.5.1 FileFsAttributeInformation:
https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/ebc7e6e5-4650-4e54-b17c-cf60f6fbeeaa

So it really looks like that POSIX unlink is prepared for SMB, just is
not documented or implemented in Windows yet.

Maybe somebody could ask Microsoft documentation team for more details?
