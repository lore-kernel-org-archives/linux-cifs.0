Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D8320012D
	for <linux-cifs@vger.kernel.org>; Fri, 21 Feb 2025 16:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740155725; cv=none; b=Idp/2ENAF+COHVyDU6Rkokp1C0S5VNcdBH31bpdvK3rWpKujuXd9Nee0EUAiR7ItcwCs4PCvS/Y0EgbtoscPa/wqFrfaehfsDMbxDSXNCXVnO/4z+Df1g9OPqzvc+6bAIcPt/+iAuRBSftVUHxi+EG+yFpjLkayFQIFggZZfUDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740155725; c=relaxed/simple;
	bh=XUjICYhOnWMpHEXd6+Gzp0FAN67Q7nD2DhYPj12yrII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a5kOEa/r/8TWYdOqMB/41clSWmZmG8cGiQ1GUP0n1W21A0mbNPFLa79dmWBOskHdOVoJ+mrZ6fMs7k6osDK4QSv1Kwx6Aqmcqst9aVMldHa2A5ihjckEMedHf/Mi/x5nFZFiUmkutbdkVYvcfLYN+tz0KVPgPtYs129yrh4hk90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from trampoline.thunk.org (pool-173-48-114-12.bstnma.fios.verizon.net [173.48.114.12])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 51LGYhLV006504
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Feb 2025 11:34:44 -0500
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id AA2FB2E011A; Fri, 21 Feb 2025 11:34:43 -0500 (EST)
Date: Fri, 21 Feb 2025 11:34:43 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Dave Chinner <david@fromorbit.com>, Eric Biggers <ebiggers@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Steve French <sfrench@samba.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] fs: Add FS_XFLAG_COMPRESSED & FS_XFLAG_ENCRYPTED
 for FS_IOC_FS[GS]ETXATTR API
Message-ID: <20250221163443.GA2128534@mit.edu>
References: <20250216183432.GA2404@sol.localdomain>
 <CAOQ4uxigYpzpttfaRc=xAxJc=f2bz89_eCideuftf3egTiE+3A@mail.gmail.com>
 <20250216202441.d3re7lfky6bcozkv@pali>
 <CAOQ4uxj4urR70FmLB_4Qwbp1O5TwvHWSW6QPTCuq7uXp033B7Q@mail.gmail.com>
 <Z7Pjb5tI6jJDlFZn@dread.disaster.area>
 <CAOQ4uxh6aWO7Emygi=dXCE3auDcZZCmDP+jmjhgdffuz1Vx6uQ@mail.gmail.com>
 <20250218192701.4q22uaqdyjxfp4p3@pali>
 <Z7UQHL5odYOBqAvo@dread.disaster.area>
 <20250218230643.fuc546ntkq3nnnom@pali>
 <CAOQ4uxiAU7UorH1FLcPgoWMXMGRsOt77yRQ12Xkmzcxe8qYuVw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiAU7UorH1FLcPgoWMXMGRsOt77yRQ12Xkmzcxe8qYuVw@mail.gmail.com>

I think a few people were talking past each other, because there are two
fileds in struct fileattr --- flags, and fsx_xflags.  The flags field
is what was originally used by FS_IOC_EXT2_[GS]ETFLAGS, which later
started getting used by many other file systems, starting with
resierfs and btrfs, and so it became FS_IOC_[GS]ETFLAGS.  The bits in
that flags word were both the ioctl ABI and the on-disk encoding, and
because we were now allowing multiple file systems to allocate bits,
and we needed to avoid stepping on each other (for example since btrfs
started using FS_NOCOW_FL, that bit position wouldn't be used by ext4,
at least not for a publically exported flag).

So we started running out of space in the FS_FLAG_*_FL namespace, and
that's why we created FS_IOC_[GS]ETXATTR and the struct fsxattr.  The
FS_XFLAG_*_FL space has plenty of space; there are 14 unassigned bit
positions, by my count.

As far as the arguments about "proper interface design", as far as
Linux is concerned, backwards compatibility trumps "we should have
done if it differently".  The one and only guarantee that we have that
FS_IOC_GETXATTR followed by FS_IOC_SETXATTR will work.  Nothing else.

The use case of "what if a backup program wants to backup the flags
and restore on a different file system" is one that hasn't been
considered, and I don't think any backup programs do it today.  For
that matter, some of the flags, such as the NODUMP flag, are designed
to be instructions to a dump/restore system, and not really one that
*should* be backed up.  Again, the only semantic that was guaranteed
is GETXATTR or GETXATTR followed by SETXATTR.

We can define some new interface for return what xflags are supported
by a particular file system.  This could either be the long-debated,
but never implemented statfsx() system call.  Or it could be extending
what gets returned by FS_IOC_GETXATTR by using one of the fs_pad
fields in struct fsxattr.  This is arguably the simplest way of
dealing with the problem.

I suppose the field could double as the bitmask field when
FS_IOC_SETXATTR is called, but that just seems to be an overly complex
set of semantics.  If someone really wants to do that, I wouldn't
really complain, but then what we would actually call the field
"flags_supported_on_get_bitmask_on_set" would seem a bit wordy.  :-)

				      	     - Ted
