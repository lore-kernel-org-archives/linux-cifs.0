Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763883DFC93
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 08:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779178551; cv=none; b=fwzkUWMFT3rDv3JasZ067D34U7AWUIsPDTIM4rcrfNk+Gmli3fjyQIESI3VGglq97NE3urRY4ynv2Wss6Dp1VmyQQuJb6tbjtSabFSjIxRl+5MFbhUrAtN1c7I+cyt0K+uzo1HsR35z++wu2cyWIqOgsv767bV+QlaYu64HCbAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779178551; c=relaxed/simple;
	bh=ukNhp2SUe+V00i+CScbinEy01SmNCkigc3dUv72ANDo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JaAwi87kLsuh+HqgyskMqV/5a7pttRU4nP5yEZFB4BgWmOBwjEy22F5XRdrVJAP3xs7inH24uEE3JOwfTT1+3plPe4d+dkZCnplpK2YuagQaxCfKHj8750LwnHXxh1Y+jbAHjjBFlGE4RxtBQ7Sw2KU1BpTvQVN1GULiJ5YY74Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WaynMlMF; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WaynMlMF"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-441209fb77eso1883037f8f.1
        for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 01:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779178548; x=1779783348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gq7q4q44H1XtbreNnGBa/qXoQQzGGv2LByvvEOVI2FM=;
        b=WaynMlMFRuGTf8CvtKr5WJkga/2vuFLI4Z9hDGY2zHP4FUL/W1w8/z5fO03EraWi0k
         zekysh4ooH3cwk8tMdVKmYd5G8IP80btK8Yhk5SHzuSCv5HNBAerLX9MSP8LjS3gkgEA
         ivAtRVU/b4BDUVFd3zZS1V8zCW41ny0gc0s0lFjZrSV1HL7nYMJ64ke1uoPlaLmv/Su2
         BXawho+iOHQkDKHzJt9a4tSgXH4Nrbp+SJ/MGjog7pHL3YzdCjdfbf165Z2OOgucdGGX
         Abh/0uCTzxumg1RP3Mk44o90cDLwgXWGWzXlrMgSOjxMdTwS8GBuDixjlSejq9c+uBO4
         46wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779178548; x=1779783348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gq7q4q44H1XtbreNnGBa/qXoQQzGGv2LByvvEOVI2FM=;
        b=CbHeKhlaUt8epjQjWuxhPYwuYfS1G3vMLBEkNWqupO7/QpHem4dCYRIzlAsZtonk8z
         C/8kBi/99cQXUArXKREnV01qrnw4hKJWuHAQogX1fIitabsgsowfwzRL/oFgpQE32cA8
         FoeOVUKpYjz9X6tebXyCVaF0X7fT3mD5dsrbzZvqXQq5tWZz0fHh64gvpdgnMLHO3Fnp
         pPFmMdjRzx+/lduEpUDKKofeEgLlOOFwUV3NsHBKLDCBKzoZwGmSntWRJwjEDShF7VNy
         3Pxa0N+XLmt0tZ0M1EtQP9cpZ2p5L/WLw7ladHx2Rgqf0MVWoKVI+9YRBMYDPK+8W71d
         J5UA==
X-Forwarded-Encrypted: i=1; AFNElJ8dEibIj8bJGY6nTdMrgb/r3uCJX+JuN4MzIfzHQi3JQ5lef+GEAC7jk9Rk2yUMg7HcLFh68S3/ES2C@vger.kernel.org
X-Gm-Message-State: AOJu0YwxZGKZhdBaiNa7aKrzJ+vO/nl7V0gXLzdyMkrCoJ2wqYmowJO3
	E9FSle9Og66IiLoI8pVrdoG6itVetH8W5+uTCP8dDf8tDTc19sbmKaOV
X-Gm-Gg: Acq92OGtZ6OT8cDV0Pc9CMmmsRLfSNFhmOhjsnIMUqtUsiFmXCsKXf4MvKsO0zDPclb
	+bvM8ub9avbZ+HYoOIF2z9FP2Q87l4lDBUOntrX8xWLrK4yi2tdIURbIklfLw771+1CyTVbZqfM
	TmOxB45T8856eTaE/kPmY/4osctAoxfO7lPTK/p/Tkt8NhzwpzruKzKAJo1nruGFfCVj5VEYbRO
	rQRTXAReI+wW8Xu0WgpuIt4+pJ44H1DrvLnOzNc8Ct19ouO1F/+QGn0URgHE2UU6pThvZ/YpK2g
	eziZOjhLbrfk9pGxu4zXWIZnP23Be/SxLvCjSbvPyspvWJ+/HxjYwHpxG13mvcBhJAfH6+Mt6v2
	AoOqDwJ8CMfzpz6jH/LEUiNYFTOmy7b9LTDlQIjfVqtiydF55ET/27UuaEdFaKTn7XwI1dkyx4L
	YBZ/5FtiNpQ7UVHNhM7PvUKQIs2eRkb8SBHnVR8RTGUo72ssUZOP28AK2dKNjHKPiP
X-Received: by 2002:a5d:4577:0:b0:450:b883:dd3c with SMTP id ffacd0b85a97d-45d9352412cmr26263969f8f.20.1779178547828;
        Tue, 19 May 2026 01:15:47 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45e7c22d8b7sm14602897f8f.6.2026.05.19.01.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 01:15:47 -0700 (PDT)
Date: Tue, 19 May 2026 09:15:45 +0100
From: David Laight <david.laight.linux@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, Matthew Wilcox
 <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, Paulo
 Alcantara <pc@manguebit.org>, Jens Axboe <axboe@kernel.dk>, Leon Romanovsky
 <leon@kernel.org>, Steve French <sfrench@samba.org>, ChenXiaoSong
 <chenxiaosong@chenxiaosong.com>, Marc Dionne <marc.dionne@auristor.com>,
 Eric Van Hensbergen <ericvh@kernel.org>, Dominique Martinet
 <asmadeus@codewreck.org>, Ilya Dryomov <idryomov@gmail.com>, Trond
 Myklebust <trondmy@kernel.org>, netfs@lists.linux.dev,
 linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
 v9fs@lists.linux.dev, linux-erofs@lists.ozlabs.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/21] netfs: Keep track of folios in a segmented
 bio_vec[] chain
Message-ID: <20260519091545.171c4b85@pumpkin>
In-Reply-To: <20260518222959.488126-1-dhowells@redhat.com>
References: <20260518222959.488126-1-dhowells@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 18 May 2026 23:29:32 +0100
David Howells <dhowells@redhat.com> wrote:

> Hi Christian,
> 
> Could you add these patches to the VFS tree for next?
> 
> The patches get rid of folio_queue, rolling_buffer and ITER_FOLIOQ,
> replacing the folio queue construct used to manage buffers in netfslib with
> one based around a segmented chain of bio_vec arrays instead.  There are
> three main aims here:
> 
>  (1) The kernel file I/O subsystem seems to be moving towards consolidating
>      on the use of bio_vec arrays, so embrace this by moving netfslib to
>      keep track of its buffers for buffered I/O in bio_vec[] form.
> 
>  (2) Netfslib already uses a bio_vec[] to handle unbuffered/DIO, so the
>      number of different buffering schemes used can be reduced to just a
>      single one.
> 
>  (3) Always send an entire filesystem RPC request message to a TCP socket
>      with single kernel_sendmsg() call as this is faster, more efficient
>      and doesn't require the use of corking as it puts the entire
>      transmission loop inside of a single tcp_sendmsg().
> 
> For the replacement of folio_queue, a segmented chain of bio_vec arrays
> rather than a single monolithic array is provided:
> 
> 	struct bvecq {
> 		struct bvecq		*next;
> 		struct bvecq		*prev;
> 		unsigned long long	fpos;
> 		refcount_t		ref;
> 		u32			priv;
> 		u16			nr_segs;
> 		u16			max_segs;
> 		enum bvecq_mem		mem_type:2;
> 		bool			inline_bv:1;
> 		bool			discontig:1;

There doesn't seem to be any point using bitfields.
There is a massive hole here anyway.

> 		struct bio_vec		*bv;
> 		struct bio_vec		__bv[];
> 	};
> 
> The fields are:
> 
>  (1) next, prev - Link segments together in a list.  I want this to be
>      NULL-terminated linear rather than circular to make it possible to
>      arbitrarily glue bits on the front.

Do you ever need to follow the list backwards?
If not making prev point to the pointer to the entry (probably a tailq?)
makes the logic simpler (and safer) because you can remove an item without
knowing whether it is the head or which list it is on.

> 
>  (2) fpos, discontig - Note the current file position of the first byte of
>      the segment; all the bio_vecs in ->bv[] must be contiguous in the file
>      space.  The fpos can be used to find the folio by file position rather
>      then from the info in the bio_vec.

Should fpos be off_t (or u64) rather than 'long long' (they are all the
same underlying type).

>      If there's a discontiguity, this should break over into a new bvecq
>      segment with the discontig flag set (though this is redundant if you
>      keep track of the file position).  Note that the beginning and end
>      file positions in a segment need not be aligned to any filesystem
>      block size.

At this point you lose me :-)

-- David
