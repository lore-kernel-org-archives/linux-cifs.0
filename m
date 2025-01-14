Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4B6213E61
	for <linux-cifs@vger.kernel.org>; Tue, 14 Jan 2025 23:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736897572; cv=none; b=kDxG08zJ8wwpZ+Yd/0kNLTJdMS25HZS97co6fs6OElQX29U3UkTHExfzAetJVJaW0v8sstz3T4Kaz3UMiPVuSgSFwGNbeAc/A84pmPc29xun90+AHqL4CLv+d1hd/rDEpXjMI5+kl8tbRN96yIkA5GCWMhJHtbr0SUvXgL98k9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736897572; c=relaxed/simple;
	bh=EH4RLqsDVF9zSUks6UrRLaqphy/hbeH6z3cPBC+YP9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K6Sj/yHoEctiqsBihbicqHZnlaSgl+8Pst1Ual6KqExkLTCi093+jjNJavoc4QinBJyRRq3aDeiP2vvvA2Empclu1klJ+lHiHD5sHW1Ia84g5erq11UOfTHUvNKjeS5DlrX9vb4V0v7jGv1Wftx3FiumcxUzW5RKvrmaRDdVoQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=AZRfclU9; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="AZRfclU9"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2163dc5155fso111935975ad.0
        for <linux-cifs@vger.kernel.org>; Tue, 14 Jan 2025 15:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1736897570; x=1737502370; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VPYIbHVE1it102on3lTKA/uIDG+wS+cqUn+a2PGr4p4=;
        b=AZRfclU96UGExG6klDK8eIBDZw4ukmCgX9OCrgqLvkQAaIwcxWlt6y1QSNPiluCu4N
         ceU5Vnm9VUkJ2tNiLl+9OBV21uOoZqM3t2rmhW3r4JlQmPnOALRVHF4WQtKbtANap40d
         UAqK2oHwbAlGbB4rbvztzzCcbtpJ2cNMsd0n9M03QToTuUptm0XgFFztEahxLP+fxBh+
         rMW58r9AYJMVAfdGpHuj9ilQJxUz0SjBuHjoXk2cS8ri+b9PFUXCOIPMrpBy5R0N25Pj
         56d3ISUHIUp8dIWvpvUO9pQEqrmhtWeWhGryE6c6GM5rOp1ACl1hel7rKoZkGMFjczzF
         N8pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736897570; x=1737502370;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VPYIbHVE1it102on3lTKA/uIDG+wS+cqUn+a2PGr4p4=;
        b=aYWyEqhAabtLFZjNQWp5ko8ackOYz6lY1f3izLbEsPpKytmnVnJhKCVoLnuCKEOmnn
         P4o2NelKIu6TQxqWCzVQ2hGpywS7wDUW1o66mZEE82XDFw7N1Wf5bmAXFCNQF/sYrVpE
         gC9QYcvdc0jkIzmb5Bq/QUE8/Mk8Fhay4JPnbBcvQR8XPS351Y5KseLIGrIif5E/Q2aB
         MfQ8vMYunPeyElOEeIjl2bb/m+cx8N0sICoZiP3eMIPKFt7yzNvbt8cHwe33CQ2rUBX5
         T5ht1Dt6Tdqr5rh41A1VoJhTletU6JvBv36X+JkqhRhS1PH43eh2cSaYyfX/qMj5K89f
         UoWw==
X-Forwarded-Encrypted: i=1; AJvYcCXDuZ4o/oFABFcoTFWEmydYc7b92XGfk06TWeJfaIrHinE9Eotb4ZLtnlfH1LxS1kaX1qltBeGoCeSG@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/vUyI2oQffuCZ37IfUeIAsiGsZw81vCNoPOAIih1J7DSBcY18
	mepZMPwyDtI4LnvAV+vSyzCsHBtZceyaYQvJYe4yP0HPGpmvSkdeczk2ozSLbzw=
X-Gm-Gg: ASbGncvLm+ypLGQZGnRe9nlY2NjkoK18xqLOtfJHltY4rrl/KVu4+JBWloZodpA1qPs
	vw867W+JIUBl7z0+ElNMrupAqpvLaOLs/aN5LzFoiJG5ASiFCtvFO5RzJTYcjaFXUUSO3v8pPnG
	NnqNwadYphP4OXwPXorEPlkAiYJFxZzpCxeZLBySTdw1LB7P8qIVOr3sm4GiZcblq/++M0VYxgT
	+qBseeoB/xlU4hz7Ix693yI8h2g3eijIoxJZnrxGUaDr7oOhZtsEKPzQH1jUieIpAYZdnPN/qzO
	zzVZS+BJ7Nh6aMO+KC+yjQ==
X-Google-Smtp-Source: AGHT+IEeG1jpueZQKj48HDOCPZVqrDJXvdVPxFGMLEPy6dXGa9TZnVPJnyPtfMQiw0IPOU1K9JiA7A==
X-Received: by 2002:a17:902:d4cf:b0:216:3466:7414 with SMTP id d9443c01a7336-21a83fcaafdmr420150135ad.44.1736897570399;
        Tue, 14 Jan 2025 15:32:50 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a317a07cce2sm8846186a12.4.2025.01.14.15.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 15:32:49 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tXqOt-00000005wyS-21zj;
	Wed, 15 Jan 2025 10:32:47 +1100
Date: Wed, 15 Jan 2025 10:32:47 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: Immutable vs read-only for Windows compatibility
Message-ID: <Z4b0H5hQv0ocD75j@dread.disaster.area>
References: <20241227121508.nofy6bho66pc5ry5@pali>
 <ckqak3zq72lapwz5eozkob7tcbamrvafqxm4mp5rmevz7zsxh5@xytjbpuj6izz>
 <28f0aa2e-58d7-4b56-bc19-b1b3aa284d8f@oracle.com>
 <20250104-bonzen-brecheisen-8f7088db32b0@brauner>
 <cf0b8342-8a4b-4485-a5d1-0da20e6d14e7@oracle.com>
 <20250114211050.iwvxh7fon7as7sty@pali>
 <0659dfe1-e160-40fd-b95a-5d319ca3504f@oracle.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0659dfe1-e160-40fd-b95a-5d319ca3504f@oracle.com>

On Tue, Jan 14, 2025 at 04:44:55PM -0500, Chuck Lever wrote:
> On 1/14/25 4:10 PM, Pali Rohár wrote:
> > > My thought was to have a consistent API to access these attributes, and
> > > let the filesystem implementers decide how they want to store them. The
> > > Linux implementation of ntfs, for example, probably wants to store these
> > > on disk in a way that is compatible with the Windows implementation of
> > > NTFS.
> > > 
> > > A common API would mean that consumers (like NFSD) wouldn't have to know
> > > those details.
> > > 
> > > 
> > > -- 
> > > Chuck Lever
> > 
> > So, what about introducing new xattrs for every attribute with this pattern?
> > 
> > system.attr.readonly
> > system.attr.hidden
> > system.attr.system
> > system.attr.archive
> > system.attr.temporary
> > system.attr.offline
> > system.attr.not_content_indexed

"attr" is a poor choice for an attribute class (yes, naming is
hard...). It's a windows file attribute class, the name should
reflect that.

However, my main problem with this approach is that it will be
pretty nasty in terms of performance regressions. xattr lookup is
*much* more expensive than reading a field out of the inode itself.

If you want an example of the cost of how a single xattr per file
can affect the performance of CIFS servers, go run dbench (a CIFS
workload simulator) with and without xattrs. The difference in
performance storing a single xattr per file is pretty stark, and it
only gets worse as we add more xattrs. i.e. xattrs like this will
have significant performance implications for all file create,
lookup/stat and unlink operations.

IOWs, If this information is going to be stored as an xattr, it
needs to be a single xattr with a well defined bit field as it's
value (i.e. one bit per attribute). The VFS inode can then cache
that bitfield with minimal addition overhead during the first
lookup/creation/modification for the purpose of fast, low overhead,
statx() operation.

> Yes, all of them could be stored as xattrs for file systems that do
> not already support these attributes.
> 
> But I think we don't want to expose them directly to users, however.
> Some file systems, like NTFS, might want to store these on-disk in a way
> that is compatible with Windows.
> 
> So I think we want to create statx APIs for consumers like user space
> and knfsd, who do not care to know the specifics of how this information
> is stored by each file system.
> 
> The xattrs would be for file systems that do not already have a way to
> represent this information in their on-disk format.

Even the filesystems that store this information natively should
support the xattr interface - they just return the native
information in the xattr format, and then every application has a
common way to change these attributes. (i.e. change the xattr to
modify the attributes, statx to efficiently sample them.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
