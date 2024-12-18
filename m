Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE39615854A
	for <linux-cifs@vger.kernel.org>; Wed, 18 Dec 2024 15:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734534635; cv=none; b=Q2WYbfCBrtKCG9861Em767TZKoZLb5DpB7qX3ULHis/hQyDv8DKFDGKpT3nE/zY2hsQAOi8F7kspKivvHE5bcCx8ZSBMOu+hjBZ6KAfShOpg0ri7JBXv6gQC6MlUzg3Y0RcEJCb3DB00ejW4t161A/scjALJEpdBASbQaAflwns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734534635; c=relaxed/simple;
	bh=dJ5MgtcOdIkkXX2Gd0V5R5VUbYMOC+PpISay7kYQ4G0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XqbngZdK3iqLozznPhW+ztS4+eJUep5Z+baQ91yx1K6/BIr0Z/8HwVSYdfp62qLmy2OyqVp8+7Vao2L7kYxnqDMK0GQLMlg1gou7mCvZ9z+6bavXsldFZ5QBAhyqJVzp3j+e7gMU0GS2lwn0unYvmVyQK3aXSWOVP2Rhhk2MoO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VbnHJs4w; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VbnHJs4w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734534632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rq13+spy+qCFhDJsgxiTRuvUnBVAzO08weFgvcvuB7I=;
	b=VbnHJs4wxrbSt6BFVIUDwtCfE3hTW5zf21sE4LQ3WTZuWv1Vb9OfJICLBCEoUgLg94kEq9
	HMJI11Gl95F2WfzIJlynDMpv9GcieUSuP2VyLByujawkAC8m9yjyGwOU8UIdLoXWtMnatx
	Wcsuh8RaEVGZpDsYAPckEGOrBfVbRtQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-B7KcHiS5P-KvQk0dL7E4Iw-1; Wed, 18 Dec 2024 10:10:31 -0500
X-MC-Unique: B7KcHiS5P-KvQk0dL7E4Iw-1
X-Mimecast-MFC-AGG-ID: B7KcHiS5P-KvQk0dL7E4Iw
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5d3bf75bbf1so1067170a12.1
        for <linux-cifs@vger.kernel.org>; Wed, 18 Dec 2024 07:10:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734534630; x=1735139430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rq13+spy+qCFhDJsgxiTRuvUnBVAzO08weFgvcvuB7I=;
        b=qEQiAoJgNeWzxMF4o7fMlZ1HJrlFIn9+Q/Z48Z4OMs6S+Qplxru/CEOm0t5pUCde3o
         SjTK2YYJ7Fhhi6KiCyAy8RM15UfaUIjl4sqNXlGAkaJuyHeTBLOIe82jsI0qT3FUI6J1
         gkQjMzUQK69e/8Nf1W1A874YQ9IE+ILwt7m7/xxHHQ13qbF7M2BE15SLZWHCRFtzuOGD
         KIKhKAFxIfWMOMAYc3IcEFswkx2bUjtvXbPhaimgBbt6GR4tFsQU7HGOC5+ZcswQp79o
         FzENFF2VtUsWXV+qwJ/Kjj0lpNYiyUZ2MPOQxjEQ3viAH7Aa8lJjmqP4AOIVJIeCtgI7
         u2Gw==
X-Forwarded-Encrypted: i=1; AJvYcCWVICbM5kpMF0RFdd8dvBFNNZom2zTVFuj6dFTf14QFiQa+G4g+A26bFAgN1WsIW7HzyNLX7aT5tEJ0@vger.kernel.org
X-Gm-Message-State: AOJu0YxQ1CVLRy36lFCvTnYJ3Qtx58tfJUxnlSsfZFueX4JUaqlmhNAN
	vbPlMOnD3pxcmk+J9bDhey2JjNJj2dD5Tm3tzRd4aU9A5lvXUUrBXxEMaFkE8Lx4S5nSlexxHV8
	i0l/uTSN1qW7WPkVmspTpnBnrmnw4TLJfmu47/7go+eGmg0hVQAoRi/Ez0SP7wOKwoEa4bQ/5uI
	dEjYFsgq+uU5FKHD/aEjEFkLHcAw8FLIAUdw==
X-Gm-Gg: ASbGncubda7pbXZUrKlyCfNeEWwVeZpSlwfP02xvdn9P/UCVJCFPAAsiUwQdRWuHR9K
	qd85xErHXaKjPjOBZle0YZNf5ezQVQNU3gOWPmw==
X-Received: by 2002:a05:6402:4341:b0:5d3:e58c:25e2 with SMTP id 4fb4d7f45d1cf-5d7d556a032mr7458435a12.2.1734534630099;
        Wed, 18 Dec 2024 07:10:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGPXB4Hx123hIFkjF3f0ABZNjkTu8BSyACv9a6CvqUYXqkqjaQQ+sXVlOZWB1mhhZKOt1MoxEBCl6ooO9B/teI=
X-Received: by 2002:a05:6402:4341:b0:5d3:e58c:25e2 with SMTP id
 4fb4d7f45d1cf-5d7d556a032mr7458383a12.2.1734534629616; Wed, 18 Dec 2024
 07:10:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241213135013.2964079-1-dhowells@redhat.com> <2964553.1734098664@warthog.procyon.org.uk>
In-Reply-To: <2964553.1734098664@warthog.procyon.org.uk>
From: Alex Markuze <amarkuze@redhat.com>
Date: Wed, 18 Dec 2024 17:10:18 +0200
Message-ID: <CAO8a2ShjqL=-jk8_8Lk5+V13Tf60B+c8K6XovXEQH7F-gPP4-Q@mail.gmail.com>
Subject: Re: ceph xfstests failures [was Re: [PATCH 00/10] netfs, ceph, nfs,
 cachefiles: Miscellaneous fixes/changes]
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, Ilya Dryomov <idryomov@gmail.com>, 
	Max Kellermann <max.kellermann@ionos.com>, Xiubo Li <xiubli@redhat.com>, 
	Trond Myklebust <trondmy@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, netfs@lists.linux.dev, linux-afs@lists.infradead.org, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey David.
Thanks, for the find. I've seen your mail, but it was a busy week.
If you can, please open a https://tracker.ceph.com/ bug and assign it to me=
.

On Fri, Dec 13, 2024 at 4:05=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> David Howells <dhowells@redhat.com> wrote:
>
> > With these patches, I can run xfstest -g quick to completion on ceph wi=
th a
> > local cache.
>
> I should qualify that.  The thing completes and doesn't hang, but I get 6
> failures:
>
>     Failures: generic/604 generic/633 generic/645 generic/696 generic/697=
 generic/732
>
> Though these don't appear to be anything to do with netfslib (see attache=
d).
> There are two cases where the mount is busy and the rest seems to be due =
to
> id-mapped mounts and/or user namespaces.
>
> The xfstest local.config file looks something like:
>
>     export FSTYP=3Dceph
>     export TEST_DEV=3D<ipaddr>:/test
>     export TEST_DIR=3D/xfstest.test
>     TEST_FS_MOUNT_OPTS=3D'-o name=3Dadmin,mds_namespace=3Dtest,fs=3Dtest,=
fsc'
>     export SCRATCH_DEV=3D<ipaddr>:/scratch
>     export SCRATCH_MNT=3D/xfstest.scratch
>     export MOUNT_OPTIONS=3D'-o name=3Dadmin,mds_namespace=3Dscratch,fs=3D=
scratch,fsc=3Dscratch'
>
> David
> ---
> # ./check -E .exclude generic/604 generic/633 generic/645 generic/696 gen=
eric/697 generic/732
> FSTYP         -- ceph
> PLATFORM      -- Linux/x86_64 andromeda 6.13.0-rc2-build3+ #5311 SMP Fri =
Dec 13 09:03:34 GMT 2024
> MKFS_OPTIONS  -- <ipaddr>:/scratch
> MOUNT_OPTIONS -- -o name=3Dadmin,mds_namespace=3Dscratch,fs=3Dscratch,fsc=
=3Dscratch -o context=3Dsystem_u:object_r:root_t:s0 <ipaddr>:/scratch /xfst=
est.scratch
>
> generic/604 2s ... [failed, exit status 1]- output mismatch (see /root/xf=
stests-dev/results//generic/604.out.bad)
>     --- tests/generic/604.out   2024-09-12 12:36:14.187441830 +0100
>     +++ /root/xfstests-dev/results//generic/604.out.bad 2024-12-13 13:18:=
51.910900871 +0000
>     @@ -1,2 +1,4 @@
>      QA output created by 604
>     -Silence is golden
>     +mount error 16 =3D Device or resource busy
>     +mount -o name=3Dadmin,mds_namespace=3Dscratch,fs=3Dscratch,fsc=3Dscr=
atch -o context=3Dsystem_u:object_r:root_t:s0 <ipaddr>:/scratch /xfstest.sc=
ratch failed
>     +(see /root/xfstests-dev/results//generic/604.full for details)
>     ...
>     (Run 'diff -u /root/xfstests-dev/tests/generic/604.out /root/xfstests=
-dev/results//generic/604.out.bad'  to see the entire diff)
> generic/633       [failed, exit status 1]- output mismatch (see /root/xfs=
tests-dev/results//generic/633.out.bad)
>     --- tests/generic/633.out   2024-09-12 12:36:14.187441830 +0100
>     +++ /root/xfstests-dev/results//generic/633.out.bad 2024-12-13 13:18:=
55.958979531 +0000
>     @@ -1,2 +1,4 @@
>      QA output created by 633
>      Silence is golden
>     +idmapped-mounts.c: 307: tcore_create_in_userns - Input/output error =
- failure: open file
>     +vfstest.c: 2418: run_test - Success - failure: create operations in =
user namespace
>     ...
>     (Run 'diff -u /root/xfstests-dev/tests/generic/633.out /root/xfstests=
-dev/results//generic/633.out.bad'  to see the entire diff)
> generic/645       [failed, exit status 1]- output mismatch (see /root/xfs=
tests-dev/results//generic/645.out.bad)
>     --- tests/generic/645.out   2024-09-12 12:36:14.191441810 +0100
>     +++ /root/xfstests-dev/results//generic/645.out.bad 2024-12-13 13:19:=
25.526908024 +0000
>     @@ -1,2 +1,4 @@
>      QA output created by 645
>      Silence is golden
>     +idmapped-mounts.c: 6671: nested_userns - Invalid argument - failure:=
 sys_mount_setattr
>     +vfstest.c: 2418: run_test - Invalid argument - failure: test that ne=
sted user namespaces behave correctly when attached to idmapped mounts
>     ...
>     (Run 'diff -u /root/xfstests-dev/tests/generic/645.out /root/xfstests=
-dev/results//generic/645.out.bad'  to see the entire diff)
> generic/696       - output mismatch (see /root/xfstests-dev/results//gene=
ric/696.out.bad)
>     --- tests/generic/696.out   2024-09-12 12:36:14.195441791 +0100
>     +++ /root/xfstests-dev/results//generic/696.out.bad 2024-12-13 13:19:=
30.254804087 +0000
>     @@ -1,2 +1,6 @@
>      QA output created by 696
>     +idmapped-mounts.c: 7763: setgid_create_umask_idmapped - Input/output=
 error - failure: create
>     +vfstest.c: 2418: run_test - Success - failure: create operations by =
using umask in directories with setgid bit set on idmapped mount
>     +idmapped-mounts.c: 7763: setgid_create_umask_idmapped - Input/output=
 error - failure: create
>     +vfstest.c: 2418: run_test - Success - failure: create operations by =
using umask in directories with setgid bit set on idmapped mount
>      Silence is golden
>     ...
>     (Run 'diff -u /root/xfstests-dev/tests/generic/696.out /root/xfstests=
-dev/results//generic/696.out.bad'  to see the entire diff)
>
> HINT: You _MAY_ be missing kernel fix:
>       ac6800e279a2 fs: Add missing umask strip in vfs_tmpfile 1639a49ccdc=
e fs: move S_ISGID stripping into the vfs_*() helpers
>
> generic/697       - output mismatch (see /root/xfstests-dev/results//gene=
ric/697.out.bad)
>     --- tests/generic/697.out   2024-09-12 12:36:14.195441791 +0100
>     +++ /root/xfstests-dev/results//generic/697.out.bad 2024-12-13 13:19:=
31.749225548 +0000
>     @@ -1,2 +1,4 @@
>      QA output created by 697
>     +idmapped-mounts.c: 8218: setgid_create_acl_idmapped - Input/output e=
rror - failure: create
>     +vfstest.c: 2418: run_test - Success - failure: create operations by =
using acl in directories with setgid bit set on idmapped mount
>      Silence is golden
>     ...
>     (Run 'diff -u /root/xfstests-dev/tests/generic/697.out /root/xfstests=
-dev/results//generic/697.out.bad'  to see the entire diff)
>
> HINT: You _MAY_ be missing kernel fix:
>       1639a49ccdce fs: move S_ISGID stripping into the vfs_*() helpers
>
> generic/732 1s ... [failed, exit status 1]- output mismatch (see /root/xf=
stests-dev/results//generic/732.out.bad)
>     --- tests/generic/732.out   2024-09-12 12:36:14.195441791 +0100
>     +++ /root/xfstests-dev/results//generic/732.out.bad 2024-12-13 13:19:=
34.482858235 +0000
>     @@ -1,2 +1,5 @@
>      QA output created by 732
>      Silence is golden
>     +mount error 16 =3D Device or resource busy
>     +mount -o name=3Dadmin,mds_namespace=3Dscratch,fs=3Dscratch,fsc=3Dscr=
atch -o context=3Dsystem_u:object_r:root_t:s0 <ipaddr>:/scratch /xfstest.te=
st/mountpoint2-732 failed
>     +(see /root/xfstests-dev/results//generic/732.full for details)
>     ...
>     (Run 'diff -u /root/xfstests-dev/tests/generic/732.out /root/xfstests=
-dev/results//generic/732.out.bad'  to see the entire diff)
> Ran: generic/604 generic/633 generic/645 generic/696 generic/697 generic/=
732
> Failures: generic/604 generic/633 generic/645 generic/696 generic/697 gen=
eric/732
> Failed 6 of 6 tests
>
>

