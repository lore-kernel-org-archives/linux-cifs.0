Received: from mail.der-he.de (mail.der-he.de [188.68.35.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EDF264628
	for <linux-cifs@vger.kernel.org>; Fri,  1 Aug 2025 14:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.35.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754057107; cv=none; b=uAiGLVDlcSoE3TzpJs6UvqQ54zWrZktix06VMK7Xf2XRHE8qllP9jkw2FMS5jkj4Avt2LhwyZhlqLNI7umn/Pv0OYhXVw59YL5wAt3j/gQVh+HBSG1FDH1zFz1hw3SjvqWOAMNMTX8VVfInbJD3n0Ex7Y6W1WMAiIbKf17SKVM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754057107; c=relaxed/simple;
	bh=AzrzGK+jUTnXjTiUWKsWmeqw/EL7GKLfByd7S/h4y7I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vEPMHp+YL9jW3GQiTxoPuWFLkOkitOazeUJ3vaVLrEx/AAXAcqoTWDaJEQXPDrHEhT2H5B/uku0upWfOFEpQDey12YiKeK5jxvGS8i2LcWVAQjrYVmh491OuR1O1VzU/puagzooFM/eoCIJ8SQaCliyaZmJDGSsv0XnIZfYj7Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=der-he.de; spf=pass smtp.mailfrom=der-he.de; arc=none smtp.client-ip=188.68.35.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=der-he.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=der-he.de
Received: from homekolab.der-he.de (unknown [IPv6:2001:9e8:46cf:3e00:2ff:2bff:fe1c:3849])
	by mail.der-he.de (Postfix) with ESMTPS id 3F345DFED7;
	Fri,  1 Aug 2025 15:58:32 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at der-he.de
Date: Fri, 1 Aug 2025 15:58:27 +0200
From: hede <debian452@der-he.de>
To: Ralph Boehme <slow@samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, samba@lists.samba.org
Subject: Re: [Samba] delayed mtime updates: configurable?
Message-ID: <20250801155827.36e722ef@hpusdt5.der-he.de>
In-Reply-To: <d0508d0a-fb13-4a40-b27b-e55e30fa33d4@samba.org>
References: <20250727184517.577dd1f0@hpusdt5.der-he.de>
	<20250801113523.76290fc7@hpusdt5.der-he.de>
	<d0508d0a-fb13-4a40-b27b-e55e30fa33d4@samba.org>
Organization: der-he.de
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 1 Aug 2025 12:18:43 +0200 Ralph Boehme <slow@samba.org> wrote:

> no idea what the client is doing here, but from a server perspective, 
> with current Samba, the write will *immediately* update the mtime on 
> disk and report this updated value whenever it is queried. When the 
> handle is closed, the server doesn't update the mtime.

According to a net-trace it seems the client updates mtime several times for a single write event. The last seems done _after_ flushing and before closing the file, so the last mtime change will get flushed not until the deferred close finishes. (i.e. closetimeo seconds after the final write and after closing the file on client-side)

If I comment out the following:

##### in fs/smb/client/file.c in function cifs_close() #####

/*
if (test_and_clear_bit(CIFS_INO_MODIFIED_ATTR, &cinode->flags)) {
        inode->i_ctime = inode->i_mtime = current_time(inode);
}
*/

##### 

... then I do not have problems with vim on client side. 
(my initial problem was that vim complains for a remotely changed file after consecutive writes)

Still, on server side, even then the mtime gets changed not before the final (deferred) close operation has finished.

Btw: Even with this functionality in affect, i.e. not commented out, the mtime update is deferred until the real closing. 
So instead of changing ctime&mtime to current_time() here, maybe some kind of a "flush-command" would be helpful. 

-

Additionally some different thing:

##### in fs/smb/client/file.c in function cifs_readpage_worker()

/* we do not want atime to be less than mtime, it broke some apps */
file_inode(file)->i_atime = current_time(file_inode(file));
if (timespec64_compare(&(file_inode(file)->i_atime), &(file_inode(file)->i_mtime)))
        file_inode(file)->i_atime = file_inode(file)->i_mtime;
else
        file_inode(file)->i_atime = current_time(file_inode(file));

#####

... is it intended to call the same function twice for the "else" case?
And btw.: the same comment and functionality seems to be already in cifs_fattr_to_inode() in fs/smb/client/inode.c 

(I'm not a software developer so please apologise if I do have dumb ideas or questions.)

I tested this with linux 6.1 / cifs 2.40 (Debian Stable) and linux 6.15 / cifs 2.54 (Arch Linux), not with the current master branch.

hede
