Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="QxR10dg7"
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D66D9
	for <linux-cifs@vger.kernel.org>; Sun,  3 Dec 2023 16:00:54 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6cc02e77a9cso3905328b3a.0
        for <linux-cifs@vger.kernel.org>; Sun, 03 Dec 2023 16:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1701648054; x=1702252854; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wA9mzrJUkC4Y0SM4FjMDprcAvnu/0rPfrIiWvVZdpKA=;
        b=QxR10dg7EXHlplNY3r4XNgLrbgKDAIC+4hk2ucrxZCRIhKqcucwYl6I9QOl28gEUiv
         32p8f8/bSlR0hbuQ5WNiArUnJ9+dlQNrjs8SKgiOptzbjEUA5lLFlA+ZEzUKinqnsn0M
         AGrm1pUjB/vrr7phnKraZvV1P/0LSoNnRzG1QUxuwog25NK66uF9OtyxQKoruQ2KcOXs
         ImnWtQnVjqXKykITWAu3fGvLFAAOjLMZnXKvg78WA1VZILVYNgojM7GXnFrfkJjNqVAx
         bfJvNRXANviDqmeVazW+X3fWrWOvyR7rA+tCmkFKjQLLla5HH19XESRVaI9eqc/YKNIE
         Tg0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701648054; x=1702252854;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wA9mzrJUkC4Y0SM4FjMDprcAvnu/0rPfrIiWvVZdpKA=;
        b=m8eEZe6yaQzP+PZwfx8KkceNU3nRN1nXJBvtMsmr9JqwPcsESIkLMabr9EOPj1PZK4
         4sIJ4x+UA9rEjfqB6Tv+Q17l8CQn2fQsaTbDlpF1hzwLzK4vMElORdAJrM+GkmFPYkS7
         rDkUkYjukDoVdZwBG1RIFV2ou4I9rL+6XAhcfJMcctt2vqkR6b8OoHZhpD1clvOyLVo1
         3jfhbQcglWYxqF9D62czmCaERVi1B9WiianXDlZMAhQTIdsmylz3QzCIthrRx0WJ0ba+
         Z4PkdOMzSH7/NHjbevzXRlDd6iDxBF0Sv7tYYrwkwN0Typ7VzzFYtvKuyIrBZfVTsBds
         qFPA==
X-Gm-Message-State: AOJu0Yx00RapC/9+qUy0dRRABXOJ5QBDtTJd4iMePmCg2gIOGI3jxU8R
	Daa8DjQ5elqYm5/H/ko3tuHE0w==
X-Google-Smtp-Source: AGHT+IEgi1aLDy6p4K2RqOAGlLrTqzl5tLa4ovdVOOC2E3K5WaL3dOt8jtpIa9XuDDvyMFbVNTVDww==
X-Received: by 2002:a05:6a00:1256:b0:6cb:a434:b58f with SMTP id u22-20020a056a00125600b006cba434b58fmr3914828pfi.33.1701648054085;
        Sun, 03 Dec 2023 16:00:54 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id r9-20020a62e409000000b006cbae51f335sm1538619pfh.144.2023.12.03.16.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Dec 2023 16:00:53 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1r9wOJ-003V6Y-0i;
	Mon, 04 Dec 2023 11:00:51 +1100
Date: Mon, 4 Dec 2023 11:00:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: David Howells <dhowells@redhat.com>
Cc: fstests@vger.kernel.org, darrick.wong@oracle.com,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Subject: Re: generic/304 doesn't seem terminable for cifs
Message-ID: <ZW0Ws9Z3t1WnrNjI@dread.disaster.area>
References: <3876191.1701555260@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3876191.1701555260@warthog.procyon.org.uk>

On Sat, Dec 02, 2023 at 10:14:20PM +0000, David Howells wrote:
> 
> I've been running "-g quick" on a CIFS mount and it got to generic/304... and
> is still there nearly 30 hours later.  The kernel isn't stuck - userspace is
> cranking out BTRFS_IOC_FILE_EXTENT_SAME or FIDEDUPERANGE at a great rate.
> 
> The ps tree looks like:
> 
> S+     0:03       \_ /bin/bash ./check -E .exclude -g quick
> S+     0:00           \_ /bin/bash /root/xfstests-dev/tests/generic/304
> S+     0:00               \_ /bin/bash /root/xfstests-dev/tests/generic/304
> Dl+  316:55               |   \_ /usr/sbin/xfs_io -i -f -c dedupe /xfstest.test/test-304/file0 0 0 9223372036854775807 /xfstest.test/test-

$ printf "0x%x\n" 9223372036854775807
0x7fffffffffffffff
$

So this is asking for dedupe of the entire empty file. The files
are both sparse, so dedupe should be instantenous because there is
nothing to dedupe.


> S+     0:00               \_ /bin/bash /root/xfstests-dev/tests/generic/304
> S+     0:00                   \_ sed -e s/^dedupe:/XFS_IOC_FILE_EXTENT_SAME:/g
> 
> The xfs_io command strace is an endlessly repeated:
> 
> ioctl(4, BTRFS_IOC_FILE_EXTENT_SAME or FIDEDUPERANGE, {src_offset=389438053887770624, src_length=8833933982967005183, dest_count=1, info=[{dest_fd=3, dest_offset=389438053887770624}]} => {info=[{bytes_deduped=1073741824, status=0}]}) = 0
> ioctl(4, BTRFS_IOC_FILE_EXTENT_SAME or FIDEDUPERANGE, {src_offset=389438054961512448, src_length=8833933981893263359, dest_count=1, info=[{dest_fd=3, dest_offset=389438054961512448}]} => {info=[{bytes_deduped=1073741824, status=0}]}) = 0
> ioctl(4, BTRFS_IOC_FILE_EXTENT_SAME or FIDEDUPERANGE, {src_offset=389438056035254272, src_length=8833933980819521535, dest_count=1, info=[{dest_fd=3, dest_offset=389438056035254272}]} => {info=[{bytes_deduped=1073741824, status=0}]}) = 0
> ioctl(4, BTRFS_IOC_FILE_EXTENT_SAME or FIDEDUPERANGE, {src_offset=389438057108996096, src_length=8833933979745779711, dest_count=1, info=[{dest_fd=3, dest_offset=389438057108996096}]}^Cstrace: Process 105030 detache

And this indicates the src_offset is going up by 1GB and the
src_length is going down by 1GB on each pass.

So what is happening here is that either the CIFS client or the
server is only able to process dedupe requests in 1GB chunks, yet
the files are 8EB in size. That's only 8.5 billion round trips to
the server - it should be done in a few thousand years.

So, nothing apparently wrong with the test of xfs_io - it's the
filesystem dedupe max range limits that appear to be the issue.

> 
> with the dest_offset increasing a bit each time.  The log so far is:
> 
> wrote 1/1 bytes at offset 9223372036854775806
> 1.000000 bytes, 1 ops; 0.0000 sec (97.656 KiB/sec and 100000.0000 ops/sec)
> wrote 1/1 bytes at offset 9223372036854775806
> 1.000000 bytes, 1 ops; 0.0000 sec (97.656 KiB/sec and 100000.0000 ops/sec)
> wrote 1/1 bytes at offset 1048575
> 1.000000 bytes, 1 ops; 0.0000 sec (139.509 KiB/sec and 142857.1429 ops/sec)
> 
> Looking in the protocol dump, it's endlessly repeating:
> 
>   190 0.007930488  192.168.6.2 → 192.168.6.1  SMB2 174 SetInfo Request FILE_INFO/SMB2_FILE_ENDOFFILE_INFO
>   191 0.007962785  192.168.6.1 → 192.168.6.2  SMB2 136 SetInfo Response
>   192 0.007974644  192.168.6.2 → 192.168.6.1  SMB2 230 Ioctl Request FILE_SYSTEM Function:0x00d1
>   193 0.008069283  192.168.6.1 → 192.168.6.2  SMB2 182 Ioctl Response FILE_SYSTEM Function:0x00d1

Huh. I think CIFS is complete broken w.r.t. dedupe requests.

The client passes the ->remap_file_range() call to the server via
->duplicate_extents() to execute, but it does not pass any of the
remap flags to the server. One of those remap flags is
REMAP_FILE_DEDUPE, and that tells the filesysetm that it is a dedupe
operation, not a clone operation.

The CIFS client implements this callout in smb2_duplicate_extents(),
which translates to a FSCTL_DUPLICATE_EXTENTS_TO_FILE smb2
operation. The server side takes this operation and calls
vfs_clone_file_range() and/or vfs_copy_file_range(), which means
that the server can only execute a clone operation via this protocol
request. Hence it executes a clone/copy operation on reciept rather
than a dedupe operation and hence is potentially destroying the data
in the destination file.

Yeah, that's bad, but the server is only doing what the client asked
it to do.

Really, this looks like a CIFS client bug - it should not be
advertising support for FIDEDUPERANGE to applications. i.e. the smb2
protocol implementation only appears to support FICLONERANGE
semantics and so the client should be returning -EOPNOTSUPP when
REMAP_FILE_DEDUPE is set in ->remap_file_range().

-Dave.
-- 
Dave Chinner
david@fromorbit.com
