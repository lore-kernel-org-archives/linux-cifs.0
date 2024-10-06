Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8547F6
	for <linux-cifs@vger.kernel.org>; Sun,  6 Oct 2024 10:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728210695; cv=none; b=LUPHTIFhQVIGzdhIQ9EUCldyZjB/+fTpY8DjmrOnHztmiV4oFCv4wkX/V34x31W9j8TEhriv6GqOBTjoymDZliMLKm0kxIu7qEW2VS2v1ngftiteUNEJtzn6ikgTcMVENnEVT/gB2l6UEnPvG+6C7EEd0dvDW4g/1jN8OFdZMe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728210695; c=relaxed/simple;
	bh=+AEGwHQWfyfvLRNC4uCKWffltyQWNeNxLPcJEWXCTMk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=O+s5/ixtTFVsb8YwDDFBXS05tLWwQfZaQmjYbYu0sFP0FAFiQ4OvpXx/PrEcDGJY+pZ6HYBT+XpLFhv0Rhk+bhq/THfXhIY2f+oiaVmB3LI76/biqB7oVbQHgCWqz93iSitfd0U4oU5mPo8iTbXAEVNbCaRd8BAGt0I7cPJUyV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2nd0Cza; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2nd0Cza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668CDC4CEC5;
	Sun,  6 Oct 2024 10:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728210694;
	bh=+AEGwHQWfyfvLRNC4uCKWffltyQWNeNxLPcJEWXCTMk=;
	h=Date:From:To:Cc:Subject:From;
	b=U2nd0CzaRvt4b9k7iQIBnqm5NJFRpikiCIgsjBN2Lxa3hFePf4hwJKuFM9zFGeFww
	 qfzRqwiqWWCtDh1pCcTcqZJivV8h7/1LOkmWZVelZJjE2p4rbpXbZJlpubJToa6LZ4
	 PISD0vqlESs0s3t/HlyszLwinT2HN4q03e2OBKCso6ErSCpl4xYK/6Y2yG+DHjjvhJ
	 ej9WQBhI+wUHzz3t3mVmyneA1oTYXVcSclnqy51Y+rr5i2kBHFPd5H7wUweZGjlUv/
	 JE1bwlLVqhZ+NOnFkT2Fw2BdaN1NfMxEpxdxTFocxYogqB4OzWBNP7mY+BUlNwKaer
	 egPnM9plWVbLw==
Received: by pali.im (Postfix)
	id 0F3CE81A; Sun,  6 Oct 2024 12:31:27 +0200 (CEST)
Date: Sun, 6 Oct 2024 12:31:27 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Subject: SMB2 DELETE vs UNLINK
Message-ID: <20241006103127.4f3mix7lhbgqgutg@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716

Hello,

Windows NT systems and SMB2 protocol support only DELETE operation which
unlinks file from the directory after the last client/process closes the
opened handle.

So when file is opened by more client/processes and somebody wants to
unlink that file, it stay in the directory until the last client/process
stop using it.

This DELETE operation can be issued either by CLOSE request on handle
opened by DELETE_ON_CLOSE flag, or by SET_INFO request with class 13
(FileDispositionInformation) and with set DeletePending flag.


But starting with Windows 10, version 1709, there is support also for
UNLINK operation, via class 64 (FileDispositionInformationEx) [1] where
is FILE_DISPOSITION_POSIX_SEMANTICS flag [2] which does UNLINK after
CLOSE and let file content usable for all other processes. Internally
Windows NT kernel moves this file on NTFS from its directory into some
hidden are. Which is de-facto same as what is POSIX unlink. There is
also class 65 (FileRenameInformationEx) which is allows to issue POSIX
rename (unlink the target if it exists).

What do you think about using & implementing this functionality for the
Linux unlink operation? As the class numbers are already reserved and
documented, I think that it could make sense to use them also over SMB
on POSIX systems.


Also there is another flag FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE
which can be useful for unlink. It allows to unlink also file which has
read-only attribute set. So no need to do that racy (unset-readonly,
set-delete-pending, set-read-only) compound on files with more file
hardlinks.

I think that this is something which SMB3 POSIX extensions can use and
do not have to invent new extensions for the same functionality.


[1] - https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/wdm/ne-wdm-_file_information_class
[2] - https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntddk/ns-ntddk-_file_disposition_information_ex
[3] - https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntifs/ns-ntifs-_file_rename_information
