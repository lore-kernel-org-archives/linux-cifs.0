Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2424A35C192
	for <linux-cifs@vger.kernel.org>; Mon,  9 Mar 2026 10:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773052771; cv=pass; b=bs8Tcp/8XxVFNTqMAHdcyRU+hR8KcjpJUeWWzKTjIm0jjge1UuIwb3svLAYLoPbYZR2n/iuLsMXq2J4+6kcE8nu84pg5DmEzGQWDX4uwY1eYczPr/Qnj6A+4G9irfGFa/J4aMFt6S87WJEb7zygEzFiWfUTo2+ArINBg8MftyYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773052771; c=relaxed/simple;
	bh=14WFpGgWsGbhboTHmhXuZivR3dvP9ncjAjLObrvJnT8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rg1po2q29VrkhuRhvsCSLCdTjOjsrVtGTHdRduCjp5zPmxnP8w2GI8hoh7P95rjXMA0ElHkDr56SLVRnkec3DHsUnGcSfoWtT3nBpeKEajP4L1rIXxKXQERVPE7UpFmN8qSuzsNzsmRtU7P64c0vjZ2VAlfU02x/xUZJlmyvNgg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C7vNNXdB; arc=pass smtp.client-ip=74.125.224.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C7vNNXdB"
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-64c9ebd1369so10364761d50.1
        for <linux-cifs@vger.kernel.org>; Mon, 09 Mar 2026 03:39:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773052769; cv=none;
        d=google.com; s=arc-20240605;
        b=BePbQlI0iSdaUe2w2C6uYRmMiGvBwSLupJtWO2wKnrl9uo+ckkhZTTbIB76C7fPAXa
         JzIMix6M6/jHFItBcTWdReurx4LpGuNi9EVzXJsDIl8swn4MqKQHo/Foor+m51vXAQIs
         vp7bWUxPaYCDBPXx47tiT0KTAVMLbY62QwrEM4b8jRv9iXbD16ny8NJ0XeIobwK4CdEn
         sPcpAFOpZGw3fRgjOHycHG6A4UIxbaZxCMunpMNAFPjHyq2xo0Ow5du24KATCbnl1nt0
         6HgPpexFD/A5bDHCOuxXnNcOFyD0G1bNJFNR2MoYx3YqTSBbmO6KjYyWlfHTTZ+aNa5N
         GM0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3kFE19XECYnXCyQUUiIVwor/7DIuXVaRjtWsho/b8+s=;
        fh=KYtF7Oyvo9L7vOxWqSUnibXzOqo4YnL7UZQjWRcTvys=;
        b=F02qB5Q9VrFKsTgJveLdWyUfIIcdGBYvbTfZ2tR+NlnkqOnBOfWHuSsz10/2dy5fVW
         7veT9ZfG9ZggTaapELcKIOdRr+ReQlAz5VkNPp7zEGujoMTELBySD6WKTnUQvJaLFwQa
         qfD2nXUuXohAw4qPs0SzSru1xDibmNFHHopjzvccjjJ6bbPBXxhXExnSsHY32x6DvTfM
         4GEmzSG05C0xbcCIC6pmPs3UMiiMqEw7PUzBbGw7GKpNOC4ellvV3/RAO82NCcIAd3Qh
         cnHW2ROmSple16gDVC0DQBUBLLyWlyaXa8WKMbt95u562ni72cpfaQ7yUR/NI3izv536
         652Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773052769; x=1773657569; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3kFE19XECYnXCyQUUiIVwor/7DIuXVaRjtWsho/b8+s=;
        b=C7vNNXdBaJbq9JDBs1ineYrGa2u576rvZLaYq4jC3Qq8amUuvn7eksJfGRVMEAM5pJ
         sDrXIiqkQhFSB5op1RqKZekRg6CgsgCjpwgHNbE8cmcmdbhO2RAGTrWwXG4gVgPa0JT5
         9gyxCZ2qFSYRHyZWpi55XzgoK9RpvDWFHwg9VojJGhLyHEGIzv3UNGk8tEkYrJpdLdti
         kIVPBfESvZ336hLMeS0q+MscmJCh44VEizi+V9CZRUQbQbSFFdNJROnk6vDJWqnlUFA/
         TmchOP7LKeQmP7Du1mojjCpB8zJ4JO/TeaN6A3PsIKJVHfOLHH+3OXue3u/HPsgpRbT3
         DbEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773052769; x=1773657569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3kFE19XECYnXCyQUUiIVwor/7DIuXVaRjtWsho/b8+s=;
        b=lGADEEcc53/wOe5syIO4txt0XOP7kVdSDBsl12y3BLVOki5DKIFywWpnEf86fdIlOw
         ar5Ag8JBCLCnwv8QIEzJjD+s29odl1JBrYO96Zk2I5ca0fEeufJsa3sE/ZumJ6I0DEa4
         yu8NVCUr5sLrU1kdWNdoOW/1qZBf1QMXJbXkLrwi/rR+36Vjld3osUqK75qvQ88KsPj0
         zxTnaLCY2DSEstgebTITPfd4z94L9TxnpBGVPv21TW8dHKzJdOgSiiZblN3Gq0RUb5X6
         q6VyaPyXXDdMItL5TIBjUs99gve74rgYakGVO/MAbF7wRHhpMkMoY2IJ+6mKSJDD25Oj
         dgzg==
X-Forwarded-Encrypted: i=1; AJvYcCWIPSQWEcDi3DghOwSy3JBGyLkaa3U5za0mCQLr/Fz7VVc/dBzhzJszd2BrtCuxdyG9SUaLGCXj5lTH@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8WGEH/qBlBDzJYypHdt55llcytA0p/frgK5T5IkY2knLRkfYD
	wmt6fAzDeBC7z4zD05k2d1GxINAAiyc9lBRj2VaknwCm0px8GGEto8/NhuCsnOhM4lH8hB+NCm/
	4OFEZGneuwt/2D17BBsGwklrzP3SUsBA=
X-Gm-Gg: ATEYQzzd39IzO4P+UO6G4XfV5sutnz5TENMaEDaggkpuy9QPCBkjzT29qNYnaLtv77O
	UDB7wdSqBOWxYIt5PHRfnDibG/+7ia60d2Fyw4ULnTyJmmYYYveYpBleoThvcst209fLs9ijWhO
	9M62hJ7McYVyd7mu/TZvJVeDOoUG/eWC1tX8kMjvjRxU6XN5BusduZjKPbsM7BfErW6CsRGMkUe
	IVkyjWnJbXSKi14rqh4W5655nT4ql+ynZ3su7hRJB3lG25hE3vsH+A2DNE7BncxHw9N7ZouuzHp
	l+HqqXcl4lkCw56rY5w8SY+DgCCq5kjzxWxG7Nw=
X-Received: by 2002:a05:690e:bcf:b0:64a:d1ac:4528 with SMTP id
 956f58d0204a3-64d14191b4cmr10551804d50.39.1773052769024; Mon, 09 Mar 2026
 03:39:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGypqWyDOfspVUMe3fm5bfQtC_wH2eEzRgppYvWUVDe1RHLy9Q@mail.gmail.com>
 <CANT5p=rRqPFdieYHeLqtOLtC0Jr-e9jMihj7a+SgCqQt3YWqfQ@mail.gmail.com>
 <CAGypqWwJpjNh6ohj6ymuJhLR8x=Zz9SHNx8Uo6NBJXZKjdN9RA@mail.gmail.com> <CANT5p=pqF9Q+633gFj-dYqC8CraDbskKHN=8ZBjDP6RAiE_o7g@mail.gmail.com>
In-Reply-To: <CANT5p=pqF9Q+633gFj-dYqC8CraDbskKHN=8ZBjDP6RAiE_o7g@mail.gmail.com>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Mon, 9 Mar 2026 03:39:18 -0700
X-Gm-Features: AaiRm509hsVVcoATFiQFKlsqdf2obF2xm_PxzER_Yw9XRIRc5vYsb_06rEkFfJo
Message-ID: <CAGypqWyTvjfq2g+26WHOpHugUkvtZ7KEnmn4L7qdT6Yn83FLnw@mail.gmail.com>
Subject: Re: [BUG] [~6.6 Kernel] Corruption when retrying encrypted sync writes
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>, 
	CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@manguebit.com>, 
	Enzo Matsumiya <ematsumiya@suse.de>, Henrique Carvalho <henrique.carvalho@suse.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Shyam Prasad <Shyam.Prasad@microsoft.com>, 
	Bharath S M <bharathsm@microsoft.com>, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Functions in mainline kernel, such as cifs_sfu_make_node() and
smb3_create_mf_symlink() use SMB2_write() to send data and can be
affected by an in-place encryption corruption bug on retry. Submitted
a slightly modified patch titled 'smb: client: fix in-place encryption
corruption in SMB2_write()' to mainline.
Please take a look.

On Wed, Mar 4, 2026 at 12:09=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Tue, Mar 3, 2026 at 11:34=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.c=
om> wrote:
> >
> > On Fri, Feb 27, 2026 at 2:25=E2=80=AFAM Shyam Prasad N <nspmangalore@gm=
ail.com> wrote:
> > >
> > > On Wed, Feb 18, 2026 at 11:30=E2=80=AFPM Bharath SM <bharathsm.hsk@gm=
ail.com> wrote:
> > > >
> > > > We are noticing a data corruption issue in kernels based on stable
> > > > 6.6.y. Especially, when a synchronous writes retried after a
> > > > connection reset.
> > > >
> > > > Based on investigation so far, it looks like we are having issue in
> > > > the following code path:
> > > > When SMB3 encryption is enabled, partial-page buffered writes hit t=
he
> > > > synchronous write path in cifs_write_end() when the folio is not
> > > > uptodate (!folio_test_uptodate(folio)), it calls cifs_write() direc=
tly
> > > > with the kmap()'d page cache buffer, bypassing the async writeback
> > > > path.
> > > > cifs_write() calls SMB2_write(), which places the write payload in
> > > > rq_iov[1], pointing directly at the page cache buffer. When
> > > > smb3_init_transform_rq() builds the encryption request, it shares
> > > > rq_iov by pointer (new->rq_iov =3D old->rq_iov), and crypt_message(=
)
> > > > encrypts in-place via aead_request_set_crypt(req, sg, sg, ...). Thi=
s
> > > > destroys the original page cache data. If the write gets -EAGAIN af=
ter
> > > > encryption (e.g., connection reset), cifs_write() re-sends the
> > > > now-ciphertext buffer as if it were plaintext, resulting in
> > > > double-encrypted garbage on the server. The server accepts it and
> > > > returns success.
> > > > Please let me know if you have seen this issue in the past, your
> > > > comments on the analysis and probable fixes.
> > > >
> > > > Repro steps: Attached repro.zip with repro scripts and instructions=
:
> > > > 1) Mount with SMB3 encryption enabled
> > > > 2) Perform buffered writes in a loop (e.g., echo "known_pattern" >>=
 file)
> > > > 3) Kill the TCP connection during writes (ss -K dport 445) to force
> > > > retryable errors
> > > > 4) Read the file back and compare against expected content
> > > >
> > > Looking at the callers, it looks like simple_fallocate_range*
> > > functions that make use of sync writes are also susceptible to this
> > > issue.
> > >
> > > > Issue can occur when all below conditions met in buffered writes:
> > > > 1) SMB2 encryption is active
> > > > 2) Sync write path: Writes reached SMB2_write via cifs_write
> > > > 3) Retryable network error for writes: When EAGAIN or ECONABORTED
> > > > returned from  cifs_send_recv().
> > > >
> > > > Here is a the sequence of operations leading to issue:
> > > > write(2) syscall
> > > >  =E2=94=94=E2=94=80 cifs_write_end()                          [file=
.c]
> > > >      =E2=94=94=E2=94=80 cifs_write()                          [file=
.c]
> > > >          =E2=94=82  iov[1].iov_base =3D write_data      =E2=86=90 p=
age cache pointer enters iov[1]
> > > >          =E2=94=82
> > > >          =E2=94=94=E2=94=80 server->ops->sync_write()         [file=
.c]
> > > >              =E2=94=94=E2=94=80 smb2_sync_write()             [smb2=
ops.c:]
> > > >                  =E2=94=94=E2=94=80 SMB2_write()              [smb2=
pdu.c:]
> > > >                      =E2=94=82  rqst.rq_iov =3D iov     =E2=86=90 r=
qst points to iov[]
> > > > (with page cache in [1])
> > > >                      =E2=94=82  rqst.rq_nvec =3D n_vec+1  =E2=86=90=
 BUG: payload in
> > > > rq_iov, not rq_iter
> > > >                      =E2=94=82
> > > >                      =E2=94=94=E2=94=80 cifs_send_recv()      [tran=
sport.c:1305]
> > > >                          =E2=94=94=E2=94=80 compound_send_recv()  [=
transport.c:1071]
> > > >                              =E2=94=82
> > > >                              =E2=94=94=E2=94=80 smb_send_rqst()   [=
transport.c:427]
> > > >                                  =E2=94=82  if (flags & CIFS_TRANSF=
ORM_REQ)  =E2=86=90
> > > > YES for SMB3 encryption
> > > >                                  =E2=94=82
> > > >                                  =E2=94=94=E2=94=80 server->ops->in=
it_transform_rq()
> > > > [smb2ops.c:~4398]
> > > >                                  =E2=94=82   =3D smb3_init_transfor=
m_rq()
> > > >                                  =E2=94=82     new->rq_iov =3D old-=
>rq_iov     =E2=86=90
> > > > SHARES pointer (not copied!)
> > > >                                  =E2=94=82     size =3D
> > > > iov_iter_count(old->rq_iter) =3D 0  =E2=86=90 empty, no copy
> > > >                                  =E2=94=82
> > > >                                  =E2=94=94=E2=94=80 __smb_send_rqst=
()  [transport.c:272]
> > > >                                      =E2=94=82  =E2=86=92 crypt_mes=
sage()  [smb2ops.c:~4280]
> > > >                                      =E2=94=82     =E2=86=92 smb2_g=
et_aead_req()
> > > > [smb2ops.c:~4196]
> > > >                                      =E2=94=82        sg =3D scatte=
rwalk from rq_iov[0..n]
> > > >                                      =E2=94=82
> > > > aead_request_set_crypt(req, sg, sg, ...)
> > > >                                      =E2=94=82
> > > >    ^^^  ^^^
> > > >                                      =E2=94=82
> > > > src=3Ddst =E2=86=92 IN-PLACE encrypt
> > > >                                      =E2=94=82
> > > >                                      =E2=94=82   iov[1] (=3D page c=
ache) is now
> > > > AES ciphertext
> > > >                                      =E2=94=82
> > > >                                      =E2=94=94=E2=94=80 kernel_send=
msg() / sock_sendmsg()
> > > >                                          =E2=86=92 sends encrypted =
data on wire
> > > >
> > > >          =E2=86=90 rc =3D -EAGAIN (connection dropped)
> > > >
> > > >          is_replayable_error(rc) =3D=3D true or cifs_write while lo=
op detects EAGAIN
> > > >          goto replay_again                    =E2=86=90 loops back =
with corrupted iov[1]
> > > >              =E2=94=94=E2=94=80 SMB2_write() re-sends...
> > > >                  =E2=94=94=E2=94=80 smb3_init_transform_rq()  =E2=
=86=90 encrypts ciphertext AGAIN
> > > >                      =E2=94=94=E2=94=80 crypt_message()       =E2=
=86=90 double-encrypted garbage
> > > >                          =E2=94=94=E2=94=80 server writes it to dis=
k  =E2=86=90  CORRUPTION
> > > >
> > > >
> > > >
> > > > Modifying SMB2_write function by adding payload to rq_iter seems to
> > > > help here. Need to further test.
> > > > With below fix, when rq_iter size > 0 code in smb3_init_transform_r=
q
> > > > allocates fresh pages, copies the data via copy_page_from_iter(), a=
nd
> > > > encrypts the copy instead of the original.
> > > > Please let me know your comments.
> > > >
> > > >
> > > >  rqst.rq_iov =3D iov;
> > > > -rqst.rq_nvec =3D n_vec + 1;
> > > > +rqst.rq_nvec =3D 1;
> > > > +iov_iter_kvec(&rqst.rq_iter, ITER_SOURCE, &iov[1], n_vec,
> > > > +              io_parms->length);
> > > > +rqst.rq_iter_size =3D io_parms->length;
> > >
> > > Another option is to initialize iov_iter_xarray with rqst.rq_buffer,
> > > similar to what smb3_init_transform_rq does. But this should work too=
.
> > > Changes look good to me. Please submit a formal patch.
> >
> > Thank you, Attached the patch please review. Also created the minimal
> > repro script with network disconnects.
> >
> > Further investigation on this issue indicates that the issue is not
> > specific to the 6.6 Kernel; instead,
> > the issue can happen in kernels <6.10 including 6.1, 6.6 and 5.15 and b=
eyond.
> >
> > On older kernels ~5.15 with deferred closes may reduce exposure
> > because deferred handles might keep help pages
> > in memory and which may help writes to avoid sync_write path.
> > But commit 262b73ef442e (smb3 client: fix open hardlink on deferred
> > close file error, backported till 6.1) appears to
> > increase the likelihood of taking the sync_write path because we close
> > deferred handles aggressively in some cases,
> > which makes the existing encryption write corruption bug easier to
> > trigger. The commit does not introduce the bug;
> > It increases trigger frequency for writes taking sync_write path.
> >
> > I will send out this patch to the stable mailing list separately.
>
> Looks good to me. My RB is already added
>
> --
> Regards,
> Shyam
