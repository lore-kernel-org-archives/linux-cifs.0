Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F327D285CB9
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 00:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787011246; cv=none; b=oGXiqhYhKqWZ3A91kI1LRr53Jtu8me31o+g0cwduUuvA7GCkOVlawADYTU4QvgmYz/gHvDGLZnerEAnw1gIE8FFXRIjmRlWpzWSNmzHCLygb7z3/JRJx/CDHaFHoarJ+2Os2nw6MkpYmgnfR9QBjlXtb7lJsFld6ZUgKpB9jg4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787011246; c=relaxed/simple;
	bh=ytj5ujcC8TcJDZgIhyBzqrocKJH9J0D+xJBSZJM8Atw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CffH47taC7SH1V6nSMQY1RgML5zRmwbvaaCg/EMb+WZ4zw1lSYZEz0d+nOO2KuigymihUh31of0Yo00soameg2Q/sLLT8noNgAoJiQbB5Kp84YmrTsuFHIsWlXo8lHvRSt0VM9Figg6heUzHlMKatrmYK/2FGZydwdMsAXR9YgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lXccHndy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lXccHndy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7B81F00ADF
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 00:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787011244;
	bh=jvg7Qel8kPi1+BA3DkE77LkZUtjRlpucRqS8kRlFnoU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lXccHndybdpjyUukgbdw8IWdJpwC6i0cos/DhELbtJgmcHrWwtjihefDqvVJxRxH3
	 4Us6KdzIcuRJLdhnITJElqipQ1Jc69oeHpF8WqFZLFeeJKcmpTSiYw+Tf2az65CY1B
	 U/SXq9bb1rtNl6QJU9FXU8d6xI8bMrMxGWCM4mXvPv52vJzZpb5AzcZxS9UNoeE3HE
	 miW+b56xhFqSZ3y0htl5Wu24CtrHE4jC9yhnZXUebUIKU2QYZ8XYO1fcedO+sWHEn2
	 gaVpp3jRhdSq5YItYPWfHZvXmgjv37bnHm6v7sB3EVbIesPr9T+rBF+3LGdEiQG0gu
	 xkw7YmHIxOHjg==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a17c04563fso5900518a12.3
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 17:00:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpABe5RAyRSR1bt+RSPgFZJDjeR730CjBEUs4Bhf4lGXopjdVdALPvtBL3rAWzpkUeYc5FvUTUXg3/P@vger.kernel.org
X-Gm-Message-State: AOJu0YzA+rLKBFvfQpC4nYSzxhpfHW/rsiZ1sB7gppSWagCCn0j6/giF
	v49It6bLGxVj7v/sbrKoBHqDB0qDBCh7xEtTh1bmgh8g2zfu/OQqDrtNztF1XEVjBV3Y9y2OLKh
	EMA3LKK5nwQJCmzYkFUCAkdBPv8CRDkw=
X-Received: by 2002:a17:907:c1f:b0:c1c:4a7d:c501 with SMTP id
 a640c23a62f3a-c2129a9a26dmr1220629566b.1.1787011243252; Mon, 17 Aug 2026
 17:00:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260728-b4-disp-6b8e68d4-v1-1-e69277237297@proton.me>
In-Reply-To: <20260728-b4-disp-6b8e68d4-v1-1-e69277237297@proton.me>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 09:00:30 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9pNtfDCSt8+5fM5m1maww_gVeoEzmZpOD_mhGo6dEewg@mail.gmail.com>
X-Gm-Features: AcwNN1VUUw-3OQ3bcN43Skd9Jbww6cMCjhNzGkxInDuH_Oz_-autcpuwpSaQLKw
Message-ID: <CAKYAXd9pNtfDCSt8+5fM5m1maww_gVeoEzmZpOD_mhGo6dEewg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: reject a tree connect response whose byte
 count is too small
To: hexlabsecurity@proton.me
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Shyam Prasad N <sprasad@microsoft.com>, samba-technical@lists.samba.org, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Jeff Layton <jlayton@kernel.org>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 29, 2026 at 3:12=E2=80=AFAM Bryam Vargas via B4 Relay
<devnull+hexlabsecurity.proton.me@kernel.org> wrote:
>
> From: Bryam Vargas <hexlabsecurity@proton.me>
Hi Bryam,
>
> CIFSTCon() bounds its strnlen() over the byte area with the server's
> ByteCount minus two, which for ByteCount 0 or 1 goes negative as an int
> and converts to a huge size_t.  The later subtraction then wraps __u16
> bytes_left, and that is what bounds cifs_strndup_from_utf16().
>
> pByteArea() scales with the response's WordCount, also server-chosen, so
> the walk can start past everything the request itself wrote, of which
> cifs_buf_get() clears only the first 67 bytes.  KMSAN reports the read of
> uninitialised heap, and the bytes reach userspace through
> tcon->nativeFileSystem in /proc/fs/cifs/DebugData.
>
> Reject a byte area too small for what the parser consumes.  A response
> carrying a service string has at least two bytes there, so nothing valid
> is rejected, and both subtractions are then safe.
>
> Fixes: cc20c031bb06 ("cifs: convert CIFSTCon to use new unicode helper fu=
nctions")
> Cc: stable@kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Can you check the build warning that was reported by the kernel test robot =
?

All warnings (new ones prefixed by >>):

>> fs/smb/client/cifssmb.c:1791:19: warning: implicit conversion from 'int'=
 to 'enum smb_eio_trace' changes value from 128 to -128 [-Wconstant-convers=
ion]
    1791 |                         return smb_EIO(smb_eio_trace_write_too_f=
ar);
         |                                ~~~~~~~ ^~~~~~~~~~~~~~~~~~~~~~~~~=
~~
   fs/smb/client/cifssmb.c:1982:17: warning: implicit conversion from
'int' to 'enum smb_eio_trace' changes value from 128 to -128
[-Wconstant-conversion]
    1982 |                         rc =3D smb_EIO(smb_eio_trace_write_too_f=
ar);
         |                              ~~~~~~~ ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/smb/client/cifssmb.c:2074:19: warning: implicit conversion from
'int' to 'enum smb_eio_trace' changes value from 128 to -128
[-Wconstant-conversion]
    2074 |                         return smb_EIO(smb_eio_trace_write_too_f=
ar);
         |                                ~~~~~~~ ^~~~~~~~~~~~~~~~~~~~~~~~~=
~~
   3 warnings generated.
