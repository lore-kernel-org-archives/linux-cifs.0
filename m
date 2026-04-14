Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DD81D5CC6
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 00:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776126531; cv=none; b=NfXQ0WwXj4B8VNxcjng/ccIFTeYPEM38kGarpggsVBC6kmlZ3ySg3KGVFuvV3QjkVm+6UR3pXfyu8qquGTXrMrvIWI34HSEbudQi/GVBCmfM4CIbL2wSu0Dn282JJuYfdWAuQ7PZcwvDuyZ0rNdJ6uYWcZ+e4rynC6ZJ2T2EfTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776126531; c=relaxed/simple;
	bh=ON6eDxO2izcL87dKFXw6+9gP7Q8tfr2EETSD6x4NQ8A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dVctTKmqB91KLEA1have+udtBk4NhPYvrK/J2UDUji3nJSnLrrYMx+1adAMJ7ShiCEjK1Itdu2JFtUGS0Kw7JhIA7NDdvCp4ZuRr4zQLuWIqF3kQsMawhiE9Uh2+IvW4GzGhZ9E+DiNGbg6OXaR5pH6UiO1TyEuMIXjIM/EZxBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CQpsVdqf; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CQpsVdqf"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b8d7f22d405so755053966b.0
        for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 17:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1776126528; x=1776731328; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ezkY5wXIq5gr0yozTp/BMIOu1oWek9YfxChZEQI+X28=;
        b=CQpsVdqfxY/pnvlDhMzL9OplpdibLa4GrLOhesEzUkWP2EpimDQN/thpHE3g7ZohzQ
         VxAZKogMdTwnHmt1TVqi4mW1YKTm/VO1/0G7EYmMu7u+1FtQWud87het4P5tAqJELYz9
         By9dw+JEyfACN8dh92PVNxv1hCa/9wFcB7k7Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776126528; x=1776731328;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ezkY5wXIq5gr0yozTp/BMIOu1oWek9YfxChZEQI+X28=;
        b=JeDjxeVWwXt7eCqA/l3vqpnXSa90SVngpSaBLKlGXVw8uhXI+2MsOTSwWAYSgF7QGC
         GkWL0E0zmk74m/jF5H7hqOtVgV1XkoGnHHynDagWV3ioB7nUQCRSbiDolmK2HJFKONat
         XqhX7NKzGttEJw4upIXwztJhL4txfzg1qPP+ddfSwmOXxsEIDTHxdgZJuVzfSAnhSXos
         UImh5BMfgRGr6XOYRWJmGEtTn2wLDfiiduvD1zf2G2hPth+48AOKZpcYjVwkHMnjeUtX
         hzy5uM14IYoHUlnQ2+SM8YntW5tXGUlHaqHWXVVfZaNbC4WQJnAtigXMHRK3Wkoy8HOq
         b2GA==
X-Forwarded-Encrypted: i=1; AFNElJ/iOB6K2slRNkzHucKsCXkjBEwyT/+ar/bNAnYBjN1UU3qlQV2XsGqhzWdeEiitpU32IK7v4TbPsr2z@vger.kernel.org
X-Gm-Message-State: AOJu0Ywhd3uPvhmVJQ+u9O19Yy31bjKDyQmLo4DGgTwGivKG6Ws8W+zL
	YkalKUN74+OHjAXFwloedtZuQ751aKuNcxksyqTkmE4xJRRrphJT202jJ66e70t27GiGXqqRhlf
	wIZZxOKo=
X-Gm-Gg: AeBDieuf5RiUxwUZES4MDWmP4BdWNYFSc7VhxGnkeCjNHeKZrARVU/VQoAx0Z4ddNuO
	BtO0sh9ODUdrN2qPDGOWqKhMHeApk4vraBObib/PpYBUcLEFN7BFZKTUaVzqSl2fR76AFL0sc8p
	uIRNABtSu5E5FWGUzQ67ofh6kTxG5FIvzGA2ItGtl7dNoDC7QUKQaqBlfXiQ0OBbnwzkC+9nRr+
	RB2zAhfejQVnmNMSMEVG+3++w0pn9vuS57wUZKDzl8hVGxEBXCGllhP8MkL2rqdDofx1QmRyJci
	m5QLceBbcxopqrHQUHN87YAXQw8wUPmcmhcXjf4C4ZeyuH7uA8ylGYjko69Q1D2IiqCs7zIqyLZ
	tC5yfttxdc36g5PGXm8hvsHIYiSs8FdRMq+nYuwlTznBvBPfMafo9dBSJ3ubB/oE5FDJU7LjbpS
	NqTLdoUPFTi5btZ/OdrO54K5EWDBt1MGvOqbZ/XKPicMnSfN1V2wX8WIMl8hIVLmaNtR/Pl0wA
X-Received: by 2002:a17:907:3e88:b0:b97:c684:57db with SMTP id a640c23a62f3a-b9d72792a5dmr906364366b.12.1776126528241;
        Mon, 13 Apr 2026 17:28:48 -0700 (PDT)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9d6e7f1765sm341296966b.56.2026.04.13.17.28.47
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2026 17:28:47 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so938849266b.2
        for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 17:28:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ86AixvdQHkWtrfu3baroXm/eQG5ce+fV8vIz9N6oqN7ZJmSaqTQkhNMvCs/yJGnukX+PWlnMqFJj7I@vger.kernel.org
X-Received: by 2002:a17:907:3e84:b0:b9b:6581:d8ea with SMTP id
 a640c23a62f3a-b9d7267a8abmr840611266b.4.1776126527071; Mon, 13 Apr 2026
 17:28:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muW_D8eDN0iN7kzFV0km+QBVZn087+AGHTeSHm0E-KqYw@mail.gmail.com>
In-Reply-To: <CAH2r5muW_D8eDN0iN7kzFV0km+QBVZn087+AGHTeSHm0E-KqYw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 13 Apr 2026 17:28:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgerpUKCDhdzKH0FEdLyfhj3doc9t+kO9Yb6rSsTp7hdQ@mail.gmail.com>
X-Gm-Features: AQROBzBuz3b24YaI4EWnwCULY29_wICZ6JKSqJjrhNDegI4EgcUI_nX7q7JOJcI
Message-ID: <CAHk-=wgerpUKCDhdzKH0FEdLyfhj3doc9t+kO9Yb6rSsTp7hdQ@mail.gmail.com>
Subject: Re: [GIT PULL] smb3 client fixes
To: Steve French <smfrench@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 13 Apr 2026 at 15:06, Steve French <smfrench@gmail.com> wrote:
>
>   git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc1-part1-smb3-client-fixes

I've pulled this, but then looking at the dcache changes I noted the
big forest of BUG_ON() which really isn't valid. Error handling is a
thing - BUG_ON() is *not* error handling.

And then looking at verifying the length of the name - one of the
things checked for in that forest of BUG_ON() calls - the call site is
an unreadable mess.

You have this:

        size_t size = CIFS_TMPNAME_LEN + 1;

fifty lines earlier, and then you do

        d_mark_tmpfile_name(file, &QSTR_LEN(name, size - 1));

which is not just illegible, it's also illogical. That "size" is just
voodoo. The string is generated by

                scnprintf(name, size,
                          CIFS_TMPNAME_PREFIX "%0*x",
                          CIFS_TMPNAME_COUNTER_LEN,
                          atomic_inc_return(&cifs_tmpcounter));

which uses several other magic #define's, and yes, I'm sure it all
adds up to CIFS_TMPNAME_LEN in the end, but this is basically all just
line noise.

PLEASE write this legibly instead, and make that new dentry helper
actually do error handling, not BUG_ON().

Because this kind of mess is simply not acceptable.

I don't even understand why you use a variable for an insane constant.
The code *could* have done something like this:

        namelen = scnprintf(name, size,
                          CIFS_TMPNAME_PREFIX "%0*x",
                          CIFS_TMPNAME_COUNTER_LEN,
                          atomic_inc_return(&cifs_tmpcounter));

and it would all have actually made sense. But stating the final size
like that really doesn't - not without at least a big comment on how
those random things are interrelated.

So this is in my tree now, but I expect it to be cleaned up and made sensible.

                Linus
