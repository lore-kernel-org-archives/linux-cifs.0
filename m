Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156C72877FA
	for <linux-cifs@vger.kernel.org>; Tue, 14 Oct 2025 18:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760466462; cv=none; b=Bl78fRjdjjswbt3TNop7atPDbQ1jFJlOLG+73RlSPhqdK6TDrotKWzawMDll7EqqmtjEs0Kt0ePT2sjjU2IYaIWBCoKSCDN7b6AbrThbeJG3b+xmv+bwO8h7k64dayglh2Od/dNubu7pnP9afLJb54f9k74DZn8KrPjXgf3VcpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760466462; c=relaxed/simple;
	bh=RB74I7aLFP9qio5yu8di8G1iTGBsm2anqMXvHShWuJM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n810yCYXAmu3i/6Hj+kN2jIqzETZq8M0wnyy14HSs50w7eIe2iomt7eK5SiG4StZWMAdbsBIA0Ac/J8mBFm1GprjxW75PtEEu3hy9nXSaYeQNKlGTHhx0plDDA8ec1v3S1lt8xM/Cko98NjVsQq2d6lgJ9kfO3vn4QzWqy59bQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PRX7ddMY; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PRX7ddMY"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-791fd6bffbaso88142896d6.3
        for <linux-cifs@vger.kernel.org>; Tue, 14 Oct 2025 11:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760466458; x=1761071258; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tSfTQUEeojQQB/O4AumuztWKmGZiVkZuY+HewObt1DM=;
        b=PRX7ddMYMmH5UjMSvlec7gbIoWkdzrabslLufLYe1hkjMH56gfmaRi0Et2DsFQLKaL
         Mu75410tlrPqwEX6wG6a3D90VZyZplLi6iIOw4VC++d0wYppFM7uOGpt7GIBc25G0hSj
         7459r/HKJZdiw5FHGIOBuHvw8H6yEPNGP3dnTNS282lI9chf4fBCMMPJZwLtauuvp7Yc
         S/9l2TvCUan4OdDaERCqn7mRNvhx0QT/GvyjP9zb7P4Yoln153KGfp17UHH6MnvJnJYc
         PLf1rT49hCcDo8NaVAuwlhOTpxSnScbHY/gEpMiH0kWixgHssIvEtVN6EHJufpgYXWYW
         c1Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760466458; x=1761071258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tSfTQUEeojQQB/O4AumuztWKmGZiVkZuY+HewObt1DM=;
        b=ljLYDlpAGuOnL117Huqx/Jem5fQjMcn3kxiwd5MC2uiWTgPhM9et7QqoVJDROsppeW
         VOwPGja6PDnsxIG6XSUG42bApDjQNQFFpSx2Bv7GRDglscsrOj9VppPGH1v/BPRgBOeN
         mm87zkFS30+FMVmC2pAD+aOREq1Wqf5f/c1h3Ml4qpMNMJaG/+zOtAvFKDVNF3YiNfo5
         asRo3i4NnVKXGdZ+LT7Z3tPQZ5sM31u9EJx0YHDElIIoZmjaO8aeufG9KcGC16hh/ml9
         bSHlTHUTxkKuC7PQtGdtxz2MsxRFssnkrvn5M++VK2XVEVvCYyR0M/uuYF0c0i/tsxMb
         68xQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4hCrmSYXLvFzcie8ZTJw6wo941/tFSLvQR4WbU110luVk8HDW/t1yxYT09jAPdODiA6dhofqTy51d@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2K2sIJK1Ky2WFQq8zUbiMfXZ9URSode4WqCjQipbEUUjBjhWC
	cy2urAA9xUqi1iY8MOADAwiQkkDEXTa97Ea8lDU2lCu8XY8z+nWcq1DaY4aVRDMhzHkrQs+R9mm
	xx0CPN5pfwA2N4a2JSMbkWNcGycF8HqA=
X-Gm-Gg: ASbGncttg0mFNkE9qC3ohnf0Y8V6B/QuTLGjKswMiDh71g5qmQadezpbFP6KfWORv6g
	oft19+tsIomGLMCC9Ifbj5EW27QzbZugJBwWklsR4zclj/k+Bn3LHRcHXfe/zhUXFfyNT7IzbAZ
	I1prb7xWMTEk6VvxGVNPP0uiwXLnNrCaNSQoeF+WOeCJ7MX4pSiNjHpq2Mh1l5ZH8I31oa3Demy
	Kj1bI3cSpXAV7lBJziWsc82H3lGNEd6O/ISFTCdpgF9fsRD4ucW5S5dwK5uFeVcXaRoXlucPJ6l
	4c34O+wHezLM9Or7JCmNxuVroyn0A3v2QU2fetFSHwNqTDn20UPtZxXEmezIFVs7M+FqU1suN8o
	rQhjZ/ztQE8zgZjOxSTOHn9pbZIp/xLZeWAFBYZA=
X-Google-Smtp-Source: AGHT+IFU6XFIR+qGieXOiN15wCcKNp7saGyGYeqcKac09vSAanvqo/pyqL6UQId++kEk6bi2MHN+oNsiaYZwxnbnOWI=
X-Received: by 2002:a05:6214:f6b:b0:804:19ef:45dd with SMTP id
 6a1803df08f44-87b2101d85amr393750166d6.25.1760466457838; Tue, 14 Oct 2025
 11:27:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251014133551.82642-1-dhowells@redhat.com>
In-Reply-To: <20251014133551.82642-1-dhowells@redhat.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 14 Oct 2025 13:27:26 -0500
X-Gm-Features: AS18NWDSIxnc3mGWD21jCuzZgR1tbiQpCXCnv_rdJ8bZ8-EdEWCR6tu4SyA_6UY
Message-ID: <CAH2r5muBUFcGWZ+-d8OteT=k7xVk1sK97URmKfwF5saq4ms2Zw@mail.gmail.com>
Subject: Re: [PATCH 0/2] vfs, afs, bash: Fix miscomparison of foreign user IDs
 in the VFS
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <christian@brauner.io>, 
	Marc Dionne <marc.dionne@auristor.com>, Jeffrey Altman <jaltman@auristor.com>, 
	Steve French <sfrench@samba.org>, linux-afs@lists.infradead.org, 
	openafs-devel@openafs.org, linux-cifs@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Additionally, filesystems (CIFS being a notable example) may also have us=
er
identifiers that aren't simple integers

Yes - this is a bigger problem for cifs.ko (although presumably NFS
since they use user@domain for NFSv4.1 and 4.2, instead of small 32
bit uids, could have some overlapping issues as well).

In the protocols, users are represented (e.g. in ACLs and in ownership
info returned by the server) as globally unique "SIDs" which are much
larger than UIDs and so can be safely mapped across large numbers of
systems.

On Tue, Oct 14, 2025 at 8:36=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
> Hi Al, Christian,
>
> Here's a pair of fixes that deal with some places the VFS mishandles
> foreign user ID checks.  By "foreign" I mean that the user IDs from the
> filesystem do not belong in the same number space as the system's user ID=
s.
> Network filesystems are prime examples of this, but it may also impact
> things like USB drives or cdroms.
>
> Take AFS as example: Whilst each file does have a numeric user ID, the fi=
le
> may be accessed from a world-accessible public-facing server from some
> other organisation with its own idea of what that user ID refers to.  IDs
> from AFS may also collide with the system's own set of IDs and may also b=
e
> unrepresentable as a 32-bit UID (in the case of AuriStor servers).
>
> Further, kAFS uses a key containing an authentication token to specify th=
e
> subject doing an RPC operation to the server - and, as such, this needs t=
o
> be used instead of current_fsuid() in determining whether the current use=
r
> has ownership rights over a file.
>
> Additionally, filesystems (CIFS being a notable example) may also have us=
er
> identifiers that aren't simple integers.
>
> Now the problem in the VFS is that there are a number of places where it
> assumes it can directly compare i_uid (possibly id-mapped) to either than
> on another inode or a UID drawn from elsewhere (e.g. current_uid()) - but
> this doesn't work right.
>
> This causes the write-to-sticky check to work incorrectly for AFS (though
> this is currently masked by a workaround in bash that is slated to be
> removed) whereby open(O_CREAT) of such a file will fail when it shouldn't=
.
>
> Two patches are provided:
>
>  (1) Add a pair of inode operations, one to compare the ownership of a pa=
ir
>      of inodes and the other to see if the current process has ownership
>      rights over an inode.  Usage of this is then extended out into the
>      VFS, replacing comparisons between i_uid and i_uid and between i_uid
>      and current_fsuid().  The default, it the inode ops are unimplemente=
d,
>      is to do those direct i_uid comparisons.
>
>  (2) Fixes the bash workaround issue with regard to AFS, overriding the
>      checks as to whether two inodes have the same owner and the check as
>      to whether the current user owns an inode to work within the AFS
>      model.
>
> kAFS uses the result of a status-fetch with a suitable key to determine
> file ownership (if the ADMINISTER bit is set) and just compares the 64-bi=
t
> owner IDs to determine if two inodes have the same ownership.
>
> Note that chown may also need modifying in some way - but that can't
> necessarily supply the information required (for instance, an AuriStor YF=
S ID
> is 64 bits, but chown can only handle a 32-bit integer; CIFS might use a
> GUID).
>
> The patches can be found here:
>
>         https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs=
.git/log/?h=3Dafs-sticky-2
>
> Thanks,
> David
>
> David Howells (2):
>   vfs: Allow filesystems with foreign owner IDs to override UID checks
>   afs, bash: Fix open(O_CREAT) on an extant AFS file in a sticky dir
>
>  Documentation/filesystems/vfs.rst |  21 ++++
>  fs/afs/dir.c                      |   2 +
>  fs/afs/file.c                     |   2 +
>  fs/afs/internal.h                 |   3 +
>  fs/afs/security.c                 |  46 +++++++++
>  fs/attr.c                         |  58 ++++++-----
>  fs/coredump.c                     |   2 +-
>  fs/inode.c                        |  11 +-
>  fs/internal.h                     |   1 +
>  fs/locks.c                        |   7 +-
>  fs/namei.c                        | 161 ++++++++++++++++++++++++------
>  fs/remap_range.c                  |  20 ++--
>  include/linux/fs.h                |   6 +-
>  13 files changed, 269 insertions(+), 71 deletions(-)
>
>


--=20
Thanks,

Steve
