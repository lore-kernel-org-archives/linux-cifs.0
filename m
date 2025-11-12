Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A892D73B0
	for <linux-cifs@vger.kernel.org>; Wed, 12 Nov 2025 17:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762967403; cv=none; b=QzfgBA82DehQk7d14HyjYRDfJ9EA7Ow7KGD40Hq2reeUJLtN6SffyyoNxUDbDieyFz+VTlpDlyhqxFWZu96WW/FNw5jOmgk0/ocoRnVQ/dS3nwKjAZf64Mxtqu8nL2eKTC+NKmhI7Mw8mA4iRWlDxct2HvypNWN17KoG6eNIuu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762967403; c=relaxed/simple;
	bh=4hokEcsRoc20BT4AcUnh7SLzTiXcjDKdatE8nxo3dOM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C0HPSW2HShC4Uv/A7Zm8AzjT0O7oEu2844EInRMaY9zNkT2L+PWzHhiBogGTUVEiLHo3YCH6aBKkvsxCjfGxrmjbMqF1WD3ErW6jC48SJVUwdQmwoeAD0X3YaAYRgC0DvvC9VvSJcOoTtjLPBxuaNaZsL9K0YyIOXkniZkkAcyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AK4rxDyh; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AK4rxDyh"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b7277324204so200315466b.0
        for <linux-cifs@vger.kernel.org>; Wed, 12 Nov 2025 09:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762967399; x=1763572199; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uu4f/xDzxTzDEtu1yLkNy7MkpJpsWjnIJTN0CAhKShk=;
        b=AK4rxDyhkAF8wVX3cXVtvBP/Lcc2lfUIHQ56cMFeKtwi7yqyEHcp4j61p6CrWFblt3
         /LStMsz1OjejQBqH0vNFxNEIZuE6WBYpO5seN4m34BrxNekNMEhgG3jEuxKSF3sXQmYW
         D4FdAkQdP0m/kA4/WHZ2SMFsbE9wUjHHL5l7A2MC/5waWbEjPtqhh1F+Q3toRTFZc9i6
         Cr+2pAan6V/yCsRn8tjgaabUcRvJb7GsufIPXZP0aDbdpFxB9weY3GBMEXa2MPUr3BIR
         T5MblgpgbZqqNyaeRTApXEkd3h6yIfuGzwJP3QSbsu5G3Hw/cvANqLuzd03h/B89e0qF
         IfjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762967399; x=1763572199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uu4f/xDzxTzDEtu1yLkNy7MkpJpsWjnIJTN0CAhKShk=;
        b=ByyGl5q1K79HkBFsAt6fhBUxl/AzZ+WDUZEXvO4k9vZEwbk0lWtrb9lPyypx/2QK3X
         5oCF04tOtpi8UPFTnjrT3vGRiufeDmpM9AIO378ESzvD+tFJYqPv4N1n1x6RZQ9xYLVu
         4U2gfnjnkpMu7Pl1vh+fM7zSZcCLG0LHnKm+Vvmf1gkZx4L5VE7syRZpUecZbSgRf57h
         msXPUSXrU9LYTMLCqQmluHFnQGon/EbQpmPnSv573ZRL9cugu3ugAHHCz/dq5xEc7OLn
         2LOX8nBP3sXCyuQqlGFyux94VJYmTAhUqHo57nvOitYGK65iBHnPwnk/QuxwWJ0Pa1uY
         m9Fg==
X-Forwarded-Encrypted: i=1; AJvYcCUvCGa4k/USAteaTv6IxaTZsNbbbmrO0IEylmPtw3+JKp/GpwV9Ofw09F9qeYJRBBEb+SyTOOW1aqpy@vger.kernel.org
X-Gm-Message-State: AOJu0YxJpmcA35L1o5X5yg6VUjDM4WCh01j4xxNjSTC2fZLsGOdgaEkN
	VGrbS3eRopKkh7gwVj6gl5zr/+S/kMD8itSP7NyUHsT4tnPYKEOv46bqAXSuss4dDjqppRtBlQZ
	tBZcupFbu+qF+iZBXHzpptTOro/IXde1+W2Ue
X-Gm-Gg: ASbGnct1ntDiFeHKbA7ciOyjKOwkKoiXUXLJuotNagExQeBRdU2bimfIHNjbhPqX06Z
	89GkYt7IMYFgWn/lxZi5AMBFGGUko9d9bzR1a6xGhsXavfIjaEgLNSfueYEGVIHRatG94xhlFFH
	x3+PoWuSPkwQTuk+7MgPp7WLjRa3Xvxymu5CFzZujFbxDxBnqds6I491KbvMcPSD1yg5eSs4CSK
	OIoQgQLzzQV4twdUezyCDxN9RhHtw0Q5zaXaMctS+3BVC06G9zG5/dJBh/hbrW4DcPNzA==
X-Google-Smtp-Source: AGHT+IE0KgSQakwmOt0/qw8Tihayjti/ZGBD2f1bZL6HKHZqB4APNT9l1x7xnw+WriYeJOr+snmTiCcB7RCPUsjq810=
X-Received: by 2002:a17:906:4794:b0:b73:42df:27a with SMTP id
 a640c23a62f3a-b7342df0b7emr105322866b.1.1762967398462; Wed, 12 Nov 2025
 09:09:58 -0800 (PST)
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
 <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com>
 <958479.1762852948@warthog.procyon.org.uk> <CANT5p=rh7BQBnwNYLxHtFw=YUhAGVnskJ=33i6Eg4porU-X+5A@mail.gmail.com>
In-Reply-To: <CANT5p=rh7BQBnwNYLxHtFw=YUhAGVnskJ=33i6Eg4porU-X+5A@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Wed, 12 Nov 2025 22:39:47 +0530
X-Gm-Features: AWmQ_bnBHYxEN5P1_UHGg_ByktOspwiTXxVhVdi3nFXxCDCYGhJ2m7vTDia_AKk
Message-ID: <CANT5p=px8Lh1C2O0F8i1htoMACWZbLPfw0NEzUco5Njss2c7pQ@mail.gmail.com>
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

On Tue, Nov 11, 2025 at 4:09=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Tue, Nov 11, 2025 at 2:52=E2=80=AFPM David Howells <dhowells@redhat.co=
m> wrote:
> >
> > Okay, the patch isn't good from a quick scan of it.
> >
> > > +                     if (folio_test_writeback(folio)) {
> > > +                             /*
> > > +                              * For data-integrity syscalls (fsync()=
, msync()) we must wait for
> > > +                              * the I/O to complete on the page.
> > > +                              * For other cases (!sync), we can just=
 skip this page, even if
> > > +                              * it's dirty.
> > > +                              */
> > > +                             if (!sync) {
> > > +                                     stop =3D false;
> > > +                                     goto unlock_next;
> > > +                             } else {
> > > +                                     folio_wait_writeback(folio);
> >
> > You can't sleep here.  The RCU read lock is held.  There's no actual ne=
ed to
> > sleep here anyway - you can just stop and leave the function (well, set
> > stop=3Dtrue and break so that the accumulated batch is processed).
> >
> > The way the code is meant to work is that cifs_write_back_from_locked_f=
olio()
> > locks and waits for the first folio, then calls cifs_extend_writeback()=
 to add
> > more folios to the writeout - if it doesn't need to wait for them.  You=
 cannot
> > skip any folios as the set has to be contiguous.  If you skip one, you'=
ll
> > corrupt the file.
> >
> > Once a set of folios has been dispatched, cifs_writepages_begin() *shou=
ld*
> > begin with the next folio that hasn't been sent - quite possibly one ju=
st
> > rejected by cifs_extend_writeback().  But at this point
> > cifs_write_back_from_locked_folio() will wait for it.
> >
> > This should[*] work correctly, even in sync mode, because it should eve=
ntually
> > wait for any folio that's already undergoing writeback - though it migh=
t be
> > less efficient because if there are competing writebacks, they may end =
up
> > forcing each other to produce very small writes (there's no
> > writeback-vs-writeback locking apart from the individual folio locks).
> >
> > [*] At least as far as the design goes; that's not to say there isn't a=
 bug in
> >     the implementation.
> >
> > That said, in sync mode, you might actually want cifs_extend_writeback(=
) to
> > wait - but in that case, you have to drop the RCU read lock before you =
do the
> > wait and then reset the iteration correctly... and beware that doing th=
at
> > might advance[**] the iterator state.
> >
> > [**] It's possible that this is the actual cause of the bug - and that =
we're
> >      skipping the rejected folio because the xa_state isn't been correc=
tly
> >      rewound.
> >
> > David
> >
>
> Hi David,
>
> Thanks for the detailed review and explanation.
>
> Based on your explanation, the continue when folio_try_get fails seems
> out of place. Should that be a break instead?
> https://elixir.bootlin.com/linux/v6.9.12/source/fs/smb/client/file.c#L275=
8
> -------------------------
> if (!folio_try_get(folio)) {
> xas_reset(xas);
> continue;    <<<<<<<<<<<<<<<<
> }
> -------------------------
> However, that does not seem to be the cause of the corruption here.
> But can that cause an unnecessary spin loop?
>
> Enzo noted in his patch:
> -------------------------
> - Pointer arguments are updated before bound checking (actual root cause)
> @_len and @_count are updated with the current folio values before
> actually checking if the current
> values fit in their boundaries, so by the time the function exits, the
> caller (only
> cifs_write_back_from_locked_folio(), that BTW doesn't do any further
> checks) those arguments might
> have crossed bounds and extra data (zeroes) are added as padding.
> Later, with those offsets marked as 'done', the real actual data that
> should've been written into
> those offsets are skipped, making the final file corrupt.
> -------------------------
> However, I have a hard time understanding why the zero padding would happ=
en.

I think I understand what's going on here, and why Enzo's patch works
to prevent it.
I think what's going on is that cifs_extend_writeback can pick up a
folio on an extending write which has been dirtied, but we have a
clamp on the writeback to an i_size local variable, which can cause
short writes, yet mark the page as clean.

As an example, consider this scenario:
1. First write to the file happens offset 0 len 5k.
2. Writeback starts for the range (0-5k).
3. Writeback locks page 1 in cifs_writepages_begin. But does not lock
page 2 yet.
4. Page 2 is now written to by the next write, which extends the file
by another 5k. Page 2 and 3 are now marked dirty.
5. Now we reach cifs_extend_writeback, where we extend to include the
next folio (even if it should be partially written). We will mark page
2 for writeback.
6. But after exiting cifs_extend_writeback, we will clamp the
writeback to i_size, which was 5k when it started. So we write only 1k
bytes in page 2.
7. We still will now mark page 2 as flushed and mark it clean. So
remaining contents of page 2 will not be written to the server (hence
the hole in that gap, unless that range gets overwritten).

With the proposed patch, it skips the partially written folio in
cifs_extend_writeback, which should take care of the issue.

@David Howells / @Enzo Matsumiya / @Steve French : The above is just a
theory. I need to prove it. Please review.
I'm working on a revised patch (doing the boundary checking like
Enzo's change did, but addressing David's review comments). Depending
on how the testing goes, I think we should be able to submit the patch
tomorrow.

>
> The bound checking does happen after the _count and _len are updated.
> Which would mean that _len can go above max_len and _count can go
> negative.
> https://elixir.bootlin.com/linux/v6.9.12/source/fs/smb/client/file.c#L279=
3
> -------------------------
> index +=3D nr_pages;
> *_count -=3D nr_pages; <<<<<<<<<<<<<< updated first
> *_len +=3D len; <<<<<<<<<<<<<<<< then bound check
> if (max_pages <=3D 0 || *_len >=3D max_len || *_count <=3D 0)  <<<<<<<<<<=
<<
> bound check
> stop =3D true;
>
> if (!folio_batch_add(&batch, folio)) <<<<<<<<<<<<<<<<< folio batch add
> break;
> if (stop)
> break;
> }
> -------------------------
> But that would just mean that an extra folio could be added to the
> batch (and marked for writeback), causing the batch to contain more
> len than max_len (which is likely wsize).
> If I follow the code further, adjust_credits can then be called with
> wdata->bytes > wsize, and smb2_adjust_credits can then return
> EOPNOTSUPP, causing us to fail the write:
> https://elixir.bootlin.com/linux/v6.9.12/source/fs/smb/client/smb2ops.c#L=
295
> -------------------------
> if (credits->value < new_val) {
> trace_smb3_too_many_credits(server->CurrentMid,
> server->conn_id, server->hostname, 0, credits->value - new_val, 0);
> cifs_server_dbg(VFS, "request has less credits (%d) than required (%d)",
> credits->value, new_val);
>
> return -EOPNOTSUPP;
> }
> -------------------------
>
> However, Enzo's patch *does work* to prevent data corruption as
> verified by Mark and Bharath.
> (There's a WARNING that gets thrown, but that's probably due to a
> required check that Enzo missed in his change)
> What am I missing here?
>
> --
> Regards,
> Shyam



--=20
Regards,
Shyam
