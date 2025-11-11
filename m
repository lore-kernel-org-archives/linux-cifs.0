Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3887434DB54
	for <linux-cifs@vger.kernel.org>; Tue, 11 Nov 2025 10:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762857574; cv=none; b=GPi+4qLojiVE3btjSEvxpum5P+dWKZxKvezRzWVho0RGcxezyy57odF6LBPdwzft82OXjsYgTJBMmLAclac2ZT913o2PSSHg1X6gFPUvYpzfH2BbVDbdly5zFi3hs5xS/YAvl5kGUZBejA8R2/i+gFKQIqP9FB9Uzhil7agx8Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762857574; c=relaxed/simple;
	bh=V1xi4wZp79WYbmsxVdcyCRKtx4O9XmbAwt7bqZyz4M8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dXoS6wfS+sMHIenmQ5fccnVYSztfDnt9JhhTuUPb203GxBOp+eYcnClymnNClLGFzDsq5gEm2Ht40oEC/OTFlu5CXFl8zyUTWe4Ki3zqAaQBJInt03an3hcIOp055SHB5B4Mh2ZYdpeAUP8WGL5MAA8qdJCUSCnCW2AXIAeIcso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=isb6pvka; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="isb6pvka"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b472842981fso523217366b.1
        for <linux-cifs@vger.kernel.org>; Tue, 11 Nov 2025 02:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762857570; x=1763462370; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JjWKcRO+2b+ndJ2XljKkgDsj61sT++Z6j1qUmNjzl/A=;
        b=isb6pvkaHWu3dkgmjrPcW9O/EacCQRIe/MdP979IjydiccQFSRDTbi/hnRmfShHRRI
         HMSpTHYebz0A+Jpww0EvlPWOB9m4UIhuWzCBZpxLTemulFrlsi9U3yoQTUBzlXpI7Mmi
         QmQDbOM0YNhC4KR1E8G1sd7oRI1GQqI/xYZo2Y/G6Ku5toTKm6wPRycPZdrizTDhsvWR
         P7C0EeCBDc5ohU9OzQ214uCmi08qhMytUtxO0QnG20N6HQLZAM3aUjAqFd8vSCVhaUSG
         7rBkqVNyj9Dwh+msACx6x4iM7qXyijc15JfKt79927VXYHzUcriGi71BSyWGEosbCbWx
         agrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762857570; x=1763462370;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JjWKcRO+2b+ndJ2XljKkgDsj61sT++Z6j1qUmNjzl/A=;
        b=DS1V93HT6pLD0D5hSYsqCcjSk4klu8JQESTJAUUkRaR1queLLxD9TKYXNb1i9VHQqm
         zotRXnO5rBmlBIAs8Q+WLOQLxFAVUVFvpMThs2LcqqQkgHDkBCwIsurVcG6gWYE+c1K1
         fl7rtOlKc48hIZEis07/qP4x2oUMIWQER5EdXtzt+JFx2YizkBTy3W/I/mnACokjZPFr
         2SrhAMQdkPtUPfdV1mccLlf2kBfZO8PP2h+edgZM1TMiEQbLOnvdC60NLBSWCsb53DGK
         KOqhyckG0g5rwGXLcaPK/ctFDKdd/La5yS/5yeomdfMtGdnTqvRYJMbDbLlQcPrXN+eQ
         eqUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTNSR9TGvwoRHa0klk/FmZvKvHJzFTK7hT9/pUV2YtK2+gD9njU8Bsj0Pz6sNybRC4vGqdbjvUrLem@vger.kernel.org
X-Gm-Message-State: AOJu0YwVTcE8D5ca3FVF0YKG1jLmUJqNjOQNnkQHW8zwkTjDfP3EgNw1
	oV9T4jia0BY7C1RBIYu/fjfLThjJLQCNB38Cev+JCrkJOX1/IxuvMbwXGouWSCh1e+0WoPdxtiN
	I2uJ981QvCYf6tm+t7tAztF5zdBZbjtU=
X-Gm-Gg: ASbGncu7VG0km9B+WdZJFSDvjJQyoClbRh6UX2TCTJa0uu8+2p9jZQcgIQMwPl0NH1q
	ksqdE66IpHoM/7VfSm4kgfSjbHfw+TVer5nuwxv9Zld2omQIYDG1mqmuduL3ztDK/a0OiVLwATg
	XmhOPCXo3f4XV0uL37tBQOmzuoIYcv+sVhAaHwxLaVFC7I75EhYXQR3xDdxtrlDOFAo1G6DbUxW
	Q2og+9YqHIkx42uEO9SC4WXAFVvwznf5G6cIjyzOBk9RORhsquTPRd76hw=
X-Google-Smtp-Source: AGHT+IEWM/lPCLkXzS7sjuMMmVA9nkDCg2nqlJ6qiMZ+twylPt8tk7cp28fe51bsIQ31I+9LTom69b0ldoEyrmLcMik=
X-Received: by 2002:a17:907:5c6:b0:b72:6fec:5d0e with SMTP id
 a640c23a62f3a-b72e02ca0e1mr1062204766b.13.1762857570078; Tue, 11 Nov 2025
 02:39:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de> <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com>
 <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu>
 <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop>
 <YT1PR01MB9451A0F623371F50E77CC1C9B3AD2@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com> <958479.1762852948@warthog.procyon.org.uk>
In-Reply-To: <958479.1762852948@warthog.procyon.org.uk>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 11 Nov 2025 16:09:18 +0530
X-Gm-Features: AWmQ_bkiLijVXeOQbJ5_ryJIcwTEDEN9SxZsZIPLUpK7y6yCSzQQ2FHWw6aVhEk
Message-ID: <CANT5p=rh7BQBnwNYLxHtFw=YUhAGVnskJ=33i6Eg4porU-X+5A@mail.gmail.com>
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing,
 x86_64, kernel 6.6.71
To: David Howells <dhowells@redhat.com>
Cc: Bharath SM <bharathsm.hsk@gmail.com>, Mark A Whiting <whitingm@opentext.com>, 
	henrique.carvalho@suse.com, Enzo Matsumiya <ematsumiya@suse.de>, 
	Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@manguebit.org>, 
	"Heckmann, Ilja" <heckmann@izw-berlin.de>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 11, 2025 at 2:52=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> Okay, the patch isn't good from a quick scan of it.
>
> > +                     if (folio_test_writeback(folio)) {
> > +                             /*
> > +                              * For data-integrity syscalls (fsync(), =
msync()) we must wait for
> > +                              * the I/O to complete on the page.
> > +                              * For other cases (!sync), we can just s=
kip this page, even if
> > +                              * it's dirty.
> > +                              */
> > +                             if (!sync) {
> > +                                     stop =3D false;
> > +                                     goto unlock_next;
> > +                             } else {
> > +                                     folio_wait_writeback(folio);
>
> You can't sleep here.  The RCU read lock is held.  There's no actual need=
 to
> sleep here anyway - you can just stop and leave the function (well, set
> stop=3Dtrue and break so that the accumulated batch is processed).
>
> The way the code is meant to work is that cifs_write_back_from_locked_fol=
io()
> locks and waits for the first folio, then calls cifs_extend_writeback() t=
o add
> more folios to the writeout - if it doesn't need to wait for them.  You c=
annot
> skip any folios as the set has to be contiguous.  If you skip one, you'll
> corrupt the file.
>
> Once a set of folios has been dispatched, cifs_writepages_begin() *should=
*
> begin with the next folio that hasn't been sent - quite possibly one just
> rejected by cifs_extend_writeback().  But at this point
> cifs_write_back_from_locked_folio() will wait for it.
>
> This should[*] work correctly, even in sync mode, because it should event=
ually
> wait for any folio that's already undergoing writeback - though it might =
be
> less efficient because if there are competing writebacks, they may end up
> forcing each other to produce very small writes (there's no
> writeback-vs-writeback locking apart from the individual folio locks).
>
> [*] At least as far as the design goes; that's not to say there isn't a b=
ug in
>     the implementation.
>
> That said, in sync mode, you might actually want cifs_extend_writeback() =
to
> wait - but in that case, you have to drop the RCU read lock before you do=
 the
> wait and then reset the iteration correctly... and beware that doing that
> might advance[**] the iterator state.
>
> [**] It's possible that this is the actual cause of the bug - and that we=
're
>      skipping the rejected folio because the xa_state isn't been correctl=
y
>      rewound.
>
> David
>

Hi David,

Thanks for the detailed review and explanation.

Based on your explanation, the continue when folio_try_get fails seems
out of place. Should that be a break instead?
https://elixir.bootlin.com/linux/v6.9.12/source/fs/smb/client/file.c#L2758
-------------------------
if (!folio_try_get(folio)) {
xas_reset(xas);
continue;    <<<<<<<<<<<<<<<<
}
-------------------------
However, that does not seem to be the cause of the corruption here.
But can that cause an unnecessary spin loop?

Enzo noted in his patch:
-------------------------
- Pointer arguments are updated before bound checking (actual root cause)
@_len and @_count are updated with the current folio values before
actually checking if the current
values fit in their boundaries, so by the time the function exits, the
caller (only
cifs_write_back_from_locked_folio(), that BTW doesn't do any further
checks) those arguments might
have crossed bounds and extra data (zeroes) are added as padding.
Later, with those offsets marked as 'done', the real actual data that
should've been written into
those offsets are skipped, making the final file corrupt.
-------------------------
However, I have a hard time understanding why the zero padding would happen=
.

The bound checking does happen after the _count and _len are updated.
Which would mean that _len can go above max_len and _count can go
negative.
https://elixir.bootlin.com/linux/v6.9.12/source/fs/smb/client/file.c#L2793
-------------------------
index +=3D nr_pages;
*_count -=3D nr_pages; <<<<<<<<<<<<<< updated first
*_len +=3D len; <<<<<<<<<<<<<<<< then bound check
if (max_pages <=3D 0 || *_len >=3D max_len || *_count <=3D 0)  <<<<<<<<<<<<
bound check
stop =3D true;

if (!folio_batch_add(&batch, folio)) <<<<<<<<<<<<<<<<< folio batch add
break;
if (stop)
break;
}
-------------------------
But that would just mean that an extra folio could be added to the
batch (and marked for writeback), causing the batch to contain more
len than max_len (which is likely wsize).
If I follow the code further, adjust_credits can then be called with
wdata->bytes > wsize, and smb2_adjust_credits can then return
EOPNOTSUPP, causing us to fail the write:
https://elixir.bootlin.com/linux/v6.9.12/source/fs/smb/client/smb2ops.c#L29=
5
-------------------------
if (credits->value < new_val) {
trace_smb3_too_many_credits(server->CurrentMid,
server->conn_id, server->hostname, 0, credits->value - new_val, 0);
cifs_server_dbg(VFS, "request has less credits (%d) than required (%d)",
credits->value, new_val);

return -EOPNOTSUPP;
}
-------------------------

However, Enzo's patch *does work* to prevent data corruption as
verified by Mark and Bharath.
(There's a WARNING that gets thrown, but that's probably due to a
required check that Enzo missed in his change)
What am I missing here?

--=20
Regards,
Shyam
