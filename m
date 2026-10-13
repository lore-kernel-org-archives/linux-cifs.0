Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321243AEB2D
	for <linux-cifs@vger.kernel.org>; Tue, 13 Oct 2026 09:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885403; cv=none; b=Raz1u+EErTht361lPN9rXUTQioypm0j2lgyUtfJqdEYlVMptEBWWoOl4RA9f7AMln7oUOsY6u3Dumng3s02weTmW4cZ2B2Wrht/jCooC1dKLqG+YAQku4Ahtr7Rus6+mnEIc3D816zXzmNUuHTzW7svoCbwnGSWKJNHEfPOiab0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885403; c=relaxed/simple;
	bh=HFJ4UjRCkhaihkIH92sybsRJA7S5NLo3OntK/t8+1bY=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=PawlDWLLlXc4KtxLqZ7crqKEY5nd35bpWl1vznkAvlJFhhEJS584NBD6M0RAQB+g7on50Gn9dzeq1jGvUp1yytO3ul7VHiWgwtmwrHgimgac5rS08DrRw/YNRYNAAJklvv3VnBBKQxMWrANZAG2fnLncSfeZ56jpPLD6c38FD+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=innovatrics.com; spf=pass smtp.mailfrom=innovatrics.com; dkim=pass (1024-bit key) header.d=innovatrics.com header.i=@innovatrics.com header.b=f2qTN+IP; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=innovatrics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=innovatrics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=innovatrics.com header.i=@innovatrics.com header.b="f2qTN+IP"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a171b677d2so16280895e9.0
        for <linux-cifs@vger.kernel.org>; Tue, 13 Oct 2026 02:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=innovatrics.com; s=google; t=1791885399; x=1792490199; darn=vger.kernel.org;
        h=content-type:mime-version:date:references:in-reply-to:message-id
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=St+5KkhKptBQbmhWMvm7sQZJ2JL6wlGqGqKQDJo/9iM=;
        b=f2qTN+IPbgAf9AFTnqIFnA0+EFd9chhkqWbo9ujAYlUoIIB6b94DVLEFvuMMx4MDht
         rDU7HE0clCOb2uv2Ax05WtETaT+AAYaHDmmY2vekq4etv11VynKz/Uhw/cEtYcYLnVSJ
         +0JDljA8j7m5b9RdH1PAEZPDC3Xf6DttepzLE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791885399; x=1792490199;
        h=content-type:mime-version:date:references:in-reply-to:message-id
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=St+5KkhKptBQbmhWMvm7sQZJ2JL6wlGqGqKQDJo/9iM=;
        b=qB61HwPgcDyCzqZtJSUPQcvyfkmS/JcbYDxgX9qYpcLziI203Yn5yrfOPczATQvf8X
         pII0eSg2dmLcAdBKA3Mm2J6XhJzC5OGkTo8uPokTOfxxGfJvIiaLMi4GPpOw4Lj88UUX
         V89weZt66xu/iqY3heoaOdmyJt8Pf6QSX2ABsWzVtAAeq8gAtFpHkCf5vqRiDJiceZht
         0pksocZwMvZF8RcH/OaXO9Ju/isD1m9vznd3E/XQ5gDUDIucHyjGU9ukLJ+Q43XrXfS9
         tkLrdx2y+Ozp7VUtvfcTR5wnLAySMxfW+NxxvI3NmIVPwZoM8xjtiD6Ztc8eNuYQ/j6u
         qKsA==
X-Forwarded-Encrypted: i=1; AKwUvByr4ZbtxPCs9RBhrmj4QD4twSV8CnqhWWa6ChYuxcxrAzIse/jgzDVbR/N/MAVg7z1xQlG0R5nVHgSw@vger.kernel.org
X-Gm-Message-State: AFq9FYL3so37Ocv9M73oABpT0LRNgrfPhTd1ut5tiXLjQv9BlNyx8JYX
	JJHWoIiLELJWe/kLD/x+aGkjrLR/XUc2S5D7kcm72cY2tgLPq5XKt66KrYNr5g9C4w==
X-Gm-Gg: AYBFou0FNkU3A3TWbarcItAclNbpjhhuHHAAUAoA9oGqAEVlv3h9dmIF4CmKV0Y2P0C
	TIcqR5Q+dMcpuY3M5+Bp61v4B2SuZJMEf5bp3Q/OhOAVjTYStPOCZj+AIb7aAZNUWYS5tdvGZ5w
	An99BNujqyzZsd/zsnZmG820S4QmsiQhdqn3KQ7Td6g57HhJcfXCmTeJiJObPHb+nfCR9do+Sl1
	Lp2JINLK8bkyiwP6MC0s61Yxd+YOGbhWKByMh87VHR6jO3Y55ECLQiLheLiaMtcLef7JkggnO45
	TlBOQfT79Dwb5l1gSnv/JX26pxp3PlWrOraU1gMjbv6Kf302f+BrAePw4wYivsh4fRQmsBbuLj3
	bS2qvV018QDZr9u6xXVlJ7pXnSL1GrSyIettNue5YOb66fhNZHXupriT5HD+GnL56ScGCcusObV
	1m3/jz4NLDRQOctKGbspSTsGjpLTdb0sOo21wfYv8ymF9262l95vxhD9GguDdFhB/6g+L/CfMYK
	B+NcZbW5kU4kcvwMPCq8Iko64bnlGqhNFiwFqxGy5eXH4WC/vfCMv4DeLoaa3e950b8ZV/ATJh8
	t8LlrYXfw1POjfkPu0HI0SvQMPjPiD4=
X-Received: by 2002:a05:600c:1c07:b0:4a1:b044:9ccd with SMTP id 5b1f17b1804b1-4a1b0449d00mr3292955e9.28.1791885399299;
        Tue, 13 Oct 2026 02:56:39 -0700 (PDT)
Received: from [10.11.72.5] (bip-static-148.213-81-147.telecom.sk. [213.81.147.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a19f249692sm289830295e9.3.2026.10.13.02.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:56:38 -0700 (PDT)
From: Petr Chmelar <petr.chmelar@innovatrics.com>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>,
    Paulo Alcantara <pc@manguebit.org>,
    Matthew Wilcox <willy@infradead.org>,
    Namjae Jeon <linkinjeon@kernel.org>,
    Marc Dionne <marc.dionne@auristor.com>,
    Stefan Metzmacher <metze@samba.org>,
    Eric Van Hensbergen <ericvh@kernel.org>,
    Dominique Martinet <asmadeus@codewreck.org>,
    Ilya Dryomov <idryomov@gmail.com>,
    netfs@lists.linux.dev,
    linux-afs@lists.infradead.org,
    linux-cifs@vger.kernel.org,
    linux-nfs@vger.kernel.org,
    ceph-devel@vger.kernel.org,
    v9fs@lists.linux.dev,
    linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 4/5] cachefiles: Don't rely on backing fs storage map
 for most use cases
Message-ID: <20261013.cachefiles-partial-zeros-trace.pchmelar@innovatrics.com>
In-Reply-To: <1655268.1791878098@warthog.procyon.org.uk>
References: <20260910220242.2165023-1-dhowells@redhat.com>
 <20260910220242.2165023-5-dhowells@redhat.com>
 <20261011.cachefiles-partial-zeros.pchmelar@innovatrics.com>
 <1655268.1791878098@warthog.procyon.org.uk>
Date: Tue, 13 Oct 2026 09:56:37 +0000
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"

David Howells <dhowells@redhat.com> wrote:

> Unfortunately, I can't reproduce this.  Can you get me some tracing?

Thanks for looking.  The trace shows reads served from the cache over
ranges that were never written to it; details below.

I think the reason you don't see it is how the file gets into the cache,
which I should have said in the report.  In your run, fio lays the file
out through the mount, so the client fills its cache sequentially and the
object ends up CONTENT_ALL.  In ours, the client never writes the file:
it is written on the server side beforehand, and the client's cache fills
only as the client reads it, at random offsets, so the object stays
BACKFS_MAP.  That is how our training nodes use the cache: they read data
sets that they didn't write, mostly at random offsets.

I reran it on 9f8b64f66 over 9p with your tracepoints enabled, with the
same result: 936 of 4096 64 KiB blocks wrong, 825 of them zeros, first
wrong blocks 10, 13, 15, 24, 26 and 27.  I'm sending you the trace
off-list; it is 790 KB as bzip2.

What the trace shows:

 - After the random reads the object is set to BACKFS_MAP:

     cachefiles_coherency: o=00000001 SET ok   B=c4 oz=10000000 c=3

   After dropping the page cache it is looked up again (o=00000002 OK,
   c=3) and set to c=4.

 - Before the full read, WRIT TERM subrequests cover 2048 of the 4096
   64 KiB blocks, as expected for half the file.

 - During the full read, READ subrequests from the cache cover 2143
   blocks, and 936 of those never had a WRIT: the same count as the wrong
   blocks, starting with the same blocks, 10, 13, 15, 24, 26 and 27.
   For example this one read:

     R=0000285a[1] READ TERM  f=110 s=7c000 7c000/7c000 s=7 e=0

   covers 0xa0000-0xb0000, 0xd0000-0xe0000 and 0xf0000-0xf8000, and no
   write ever reached those ranges.  The writes around it were:

     R=00002291[3] WRIT TERM  f=100 s=70000 20000/20000 s=6 e=0
     R=000024dc[1] WRIT TERM  f=100 s=90000 10000/10000 s=16 e=0
     R=00002291[4] WRIT TERM  f=100 s=b0000 20000/20000 s=9 e=0
     R=000024dc[2] WRIT TERM  f=100 s=e0000 10000/10000 s=3 e=0

So for the BACKFS_MAP object, the occupancy the read is based on treats
the holes between those writes as data.

> One further question occurs to me: does the entire 256M file fit in the
> test VM's memory?

Yes.  The VM has 7946 MiB of memory with 7498 MiB available, and the page
cache is dropped before the full read.

The setup, for reference:

 - 9f8b64f66 with netfs, fscache, cachefiles, 9p and 9p fscache built in;
   QEMU without KVM, 4 vCPUs, 8 GiB RAM
 - 9p: QEMU virtfs local, security_model=none, the host directory on XFS;
   mounted with trans=virtio,version=9p2000.L,cache=fscache,msize=1048576
 - part.bin: 256 MiB from /dev/urandom, written on the host before the
   mount
 - cache: XFS on a loop device in the guest, cachefilesd 0.10.10

The trace analysis was done with LLM assistance.

Thanks,
Petr
