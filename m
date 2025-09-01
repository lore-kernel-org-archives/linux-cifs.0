Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A2A32F777;
	Mon,  1 Sep 2025 17:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756746178; cv=none; b=jAn+YXVC/6IrK3+bMo4UCTLJnIBy4809A3GLy7IqeXB9cneAknheWLskl1ZGmZtD0wV9S4qvn1j7JIWUgeC6DYtOS7RAiFKeljOBn09bzLQE2Z35uO4/ww6Skcno4d+4Usv9e/aLbpEw932lm+egVIozGdR7153o+j8oci4zInQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756746178; c=relaxed/simple;
	bh=Mia/xDpMi2KaskL83NHZqheX+zhVtceAPCQiz2ekhVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HI7jHng9eqjXoga1MwTwWWExy379v3+Mva6jZkE3xdIbJ8j+fs/qhH1wR7SrqS/lZwJy0mh5uLoWZ5GsMA0gHpslNqkmrlTJsrbTs2OJthi7Zs4qMF7+EgvbIBi8NnW5pk+N5XV9FBEnAN58AlfvK9egjOWOtvZJD6LS2jBZv9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iy5EHgqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iy5EHgqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB26C4CEF1;
	Mon,  1 Sep 2025 17:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756746177;
	bh=Mia/xDpMi2KaskL83NHZqheX+zhVtceAPCQiz2ekhVM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Iy5EHgqW5aXEt+t6fw4ZfT70/uWtgztA+RaODRcNK6hqyVb2UAFnd/HQ0lmWWMnWP
	 wc0v/6wDjPpe9K+PBQ5czicG4QH7Y/gxaVnJe8PpqoHMB2/e7+3fzTnHptyld89vIa
	 pgD99WqfKxROb8fb5TcA6XRK43DocGynjgnwWGUgN2aqy5WTdpoUnGSLb+awumUxv2
	 kHeeXx89ua0lKd/+XYYWYQv2PoFtCkG69ALaKGFPn4Z2sCBn2QAfPqyeuRkPH/0+JH
	 7rJr+veUlU7nqfp7jITCifKFDaFrDNvIxIP5t1iUbwqM9HVHha7EUK/HRS0+gVKvSf
	 nT5VR0W7piaJw==
Received: by pali.im (Postfix)
	id 16D0131D; Mon,  1 Sep 2025 19:02:54 +0200 (CEST)
Date: Mon, 1 Sep 2025 19:02:53 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>,
	Ralph =?utf-8?B?QsO2aG1l?= <slow@samba.org>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/35] cifs: Fix SMB rmdir() and unlink() against Windows
 SMB servers
Message-ID: <20250901170253.mv63jewqkdo5yqj7@pali>
References: <20250831123602.14037-1-pali@kernel.org>
 <dfa557ed-eb34-4eaf-9e17-7cae221e74fd@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfa557ed-eb34-4eaf-9e17-7cae221e74fd@samba.org>
User-Agent: NeoMutt/20180716

Hello!

On Monday 01 September 2025 09:55:45 Stefan Metzmacher wrote:
> Hi Pali,
> 
> > This patch series improves Linux rmdir() and unlink() syscalls called on
> > SMB mounts exported from Windows SMB servers which do not implement
> > POSIX semantics of the file and directory removal.
> > 
> > This patch series should have no impact and no function change when
> > communicating with the POSIX SMB servers, as they should implement
> > proper rmdir and unlink logic.
> 
> Please note that even servers implementing posix/unix extensions,
> may also have windows clients connected operating on the same files/directories.
> And in that case even posix clients will see the windows behaviour
> of DELETE_PENDING for set disposition or on rename
> NT_STATUS_ACCESS_DENIED or NT_STATUS_DIRECTORY_NOT_EMPTY.

Ok. So does it mean that the issue described here applies also for POSIX
SMB server?

If yes, then I would propose to first fix the problem with
Windows/non-POSIX SMB server and then with others. So it is not too big.

> > When issuing remove path command against non-POSIX / Windows SMB server,
> > it let the directory entry which is being removed in the directory until
> > all users / clients close all handles / references to that path.
> > 
> > POSIX requires from rmdir() and unlink() syscalls that after successful
> > call, the requested path / directory entry is released and allows to
> > create a new file or directory with that name. This is currently not
> > working against non-POSIX / Windows SMB servers.
> > 
> > To workaround this problem fix and improve existing cifs silly rename
> > code and extend it also to SMB2 and SMB3 dialects when communicating
> > with Windows SMB servers. Silly rename is applied only when it is
> > necessary (when some other client has opened file or directory).
> > If no other client has the file / dir open then silly rename is not
> > used.
> 
> If I 'git grep -i silly fs/smb/client' there's no hit, can you
> please explain what code do you mean with silly rename?

Currently (without this patch series) it is CIFSSMBRenameOpenFile()
function when called with NULL as 3rd argument.

Cleanup is done in PATCH 11/35, where are more details.

Originally the "Silly rename" is the term used by NFS client, when it
does rename instead of unlink when the path is in use.
I reused this term.


So for SMB this "silly rename" means:
- open path with DELETE access and get its handle
- rename path (via opened handle) to some unique (auto generated) name
- set delete pending state on the path (via opened handle)
- close handle

(plus some stuff around to remove READ_ONLY attr which may disallow to
open path with DELETE ACCESS)

So above silly rename means that the original path is not occupied
anymore (thanks to rename) and the original file / dir is removed after
all clients / users release handles (thanks to set delete pending).

It is clear now clear? Or do you need to explain some other steps?
Sometimes some parts are too obvious for me and I unintentionally omit
description for something which is important. And seems that this is
such case. So it is my mistake, I should have explain it better.
