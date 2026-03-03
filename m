Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A150837F006
	for <linux-cifs@vger.kernel.org>; Tue,  3 Mar 2026 18:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772561050; cv=pass; b=PaXUOSu+cIEVi4IGY9Uhl2upYnQCuvl4hJKi46fv5IKbeLpRNT5fMlzwAkq4vRfA8hcEtiXGSVh6LSAcZPiRWOwNe4w2s0/sVVPNzgcEA6scDfcy28fNU1V7Z7jalrSwBO6uM/WQBCKAapHlxioflcEPcHeM4ow+uSiiDTZ6tCc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772561050; c=relaxed/simple;
	bh=A/Q2imQMMeqvsZ5UbZA9rEaEvY2B5iQcoFyt0Je0rcM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VeYoocsJO1u0vJjuDLOP6cWSVngVRLzY6KGu3EUNXekTXoRzHIC6hZBi3yJUl9lxu63EbluQVjYSQZdjVD9vWz9Qt0445ti04PY2XTlpuimOxSngT7fnaAhQFtaLB0pl1kT292eieHbQmZUHBf+yBYbfHgQcBD6MxcBOxAyiq8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hMDSGf1o; arc=pass smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hMDSGf1o"
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-64ad019bbd4so5345458d50.0
        for <linux-cifs@vger.kernel.org>; Tue, 03 Mar 2026 10:04:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772561047; cv=none;
        d=google.com; s=arc-20240605;
        b=anKtK9ACErBzAb/LKQJfDild2Am8ncs12Ef7IudMlyTwbSu8kklYENYEUNMz2T8haE
         OKg/AeoQ8yKcRc+pMgUTbqB4QWk98fR18os/VBaJncPG+bC1oXOT/i6xRlyQ9mlWMRrD
         +M8YdgQW3tM/ViG8MwLX/RDm+3VsaU9FwMM5Lo7X+n9Cmnskn+GG66Ugrd+8jvm1ziLA
         oRjkDbC37Q89hAdAy9w0o7IQwkZ5kFQid/ZZzITpwoj2n52QV4zo1YrI6v/Jr6pY2huM
         FIbTR9o0SIcih5Nwax64ZRCOXeK3wHH29Rrt6e/e5JUsrDOj6Qs0I6fr86tnGzJ015y0
         OJyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=faPW68IFZp86hffteR0tsFCN3/WHEpIKytHbzzwR5pM=;
        fh=8oU3LP3I60gV6BqGePK97zvPwzGtzJNv2Ol/ZxfdUfs=;
        b=g9LSUaGlMuW22tfXAony76JlRV7Ssimlq5Nw6uCxZ5MhiLVDfd0h24cMz7usabPk2l
         9Ay62QEMMvM2OfIX/7BtGDhZaPuDN6YgkNx6CFUpnHePuSE1o6ZaqoOF1LpdE3gqZXO6
         ew6y7b66QrpZj2uA7Y7CidOFU7BCDtfQd9aeT37IMsEcwufN/MDSj+/WaeilUIgvsOT1
         k5YZ+0DpggKb/czw932nNtrWpP0DYvOdYipzdTPb8fR1FUttaY17U6DvW+Yi0ZWoRBJ7
         11ktO4e8k/u5ij7uqabSJ2B5uiujbvij/7MQZ1jRXY7M4Mvj9cxQzKCEOqUZ1ZKmXsBU
         t+HQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772561047; x=1773165847; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=faPW68IFZp86hffteR0tsFCN3/WHEpIKytHbzzwR5pM=;
        b=hMDSGf1oEDmR4KUY4rHYQFICSKHdoiZSu/c8yIlu2M+4DwCPQqM9hxS+/z0dIbUOzS
         WA5Bn/XAqBCI+sxToiitEJ9lLZ8YXx/GLa9mvwR1+3cLOj47jgMNhu4d74dfmF1P+3LZ
         tYLcecoE1DiyzeCXTDijGgQjssRWZIBu2MwKsthj9wFHku4w8bcIqvB7NtYnNRlauPCR
         SP3mi4TVLY+MIyP7i6u8MXQluu5n2COapD/1qfJyPYdzEAgITmFfUjXO9RHg4xZp+F/I
         21JkPw1hHG+Zl57nHeKWHGqpIYp8yi8Bgzwyo5h5BOvXSZzii3uf2VwjIcnc7bnsMZ7z
         iHKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772561047; x=1773165847;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=faPW68IFZp86hffteR0tsFCN3/WHEpIKytHbzzwR5pM=;
        b=fQwMiFmQundaACotyH29FGi/rsXgH3T5qTm7RH7ptE8mDfPggI9vv0yxvrg26piZjg
         q4I2piDtGYvEuyns06vS8A6snNElam8SV+eNyTrNDUPjJU4tCNpEPnu4enfkytaG0hWF
         Hrw2bwXrmdS3SHLHbXvUG/A4U7N2aZ4KpWiboaijCySJ0tJtYTJQ8tNNqxW8Hn3+oVFz
         pF1ug7xk2SZolUj1mP06yeHwrX08pqsGD2nVyY8RsLnn+PrmqxJt0WABGdVA1einATqs
         7/ARqdD3jcBjaT14o4bPfCXqBmBWByDmqn8HJ3EN54qj2vV5YINa3F2xUrMHBz0v+cmz
         X/eg==
X-Forwarded-Encrypted: i=1; AJvYcCVvdYO+Qp/jCM/vHf9Ld65XpV7Hjx9K0vF55D7o9hkWPrlPYme/nqEbbUMAbIjsIqA6jbQ7AevlEmPV@vger.kernel.org
X-Gm-Message-State: AOJu0YzQkxDRDSDKEMUo9es8jA50dMJQP1EsBrBaEvcHXpISS8KoTzIP
	7Cy4NxXR8CCwVya7Q/7r2S1Qrb4ErP7kFY326TtCP73agp8exnaVLLf7tvN3PZLHKEb3grRu5lJ
	HavOIwge0XHSdnI2uPl0YzGJtChbgZPQ=
X-Gm-Gg: ATEYQzx+Smt57gnKKsOU/AztACOb1YQf33IL4sUUVQ22i2fcEjy5T8XkCNqGsnKPNp1
	ydRUikLGyNpUUg5oJ/C88iDiEIhFeVN15Pn2Qdpx2sqF0tK2Si0oGuRn22wpCPPsyl7c4Iao55r
	9KsYjEwLvNmICMrnL6v/SlPUWyvKdAHWO5UwO6YjbC/VPVygDh72Dav0a97izt09wUhL69MvXYZ
	lznKPSD1NuPENS3aIOQhgJama8eC0abaHkNH3/8Pe1s4qU+tCXWXxSBJWHFqJsxxpo/jI635I/h
	l0SRbe7eQL4zfdPw5PxqpFJYoIwItcBnDjNEpyg=
X-Received: by 2002:a05:690e:1a5a:b0:64c:e7c4:3db5 with SMTP id
 956f58d0204a3-64ce7c4415cmr3369793d50.35.1772561047385; Tue, 03 Mar 2026
 10:04:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGypqWyDOfspVUMe3fm5bfQtC_wH2eEzRgppYvWUVDe1RHLy9Q@mail.gmail.com>
 <CANT5p=rRqPFdieYHeLqtOLtC0Jr-e9jMihj7a+SgCqQt3YWqfQ@mail.gmail.com>
In-Reply-To: <CANT5p=rRqPFdieYHeLqtOLtC0Jr-e9jMihj7a+SgCqQt3YWqfQ@mail.gmail.com>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Tue, 3 Mar 2026 10:03:55 -0800
X-Gm-Features: AaiRm53cTYK1SjqTI4hc41PnEDGW4C0KU_faEUumpjdTsni8whGX3MCRLvdn8_g
Message-ID: <CAGypqWwJpjNh6ohj6ymuJhLR8x=Zz9SHNx8Uo6NBJXZKjdN9RA@mail.gmail.com>
Subject: Re: [BUG] [~6.6 Kernel] Corruption when retrying encrypted sync writes
To: Shyam Prasad N <nspmangalore@gmail.com>, David Howells <dhowells@redhat.com>, 
	Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Enzo Matsumiya <ematsumiya@suse.de>, 
	Henrique Carvalho <henrique.carvalho@suse.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>, Shyam Prasad <Shyam.Prasad@microsoft.com>, 
	Bharath S M <bharathsm@microsoft.com>, Greg KH <gregkh@linuxfoundation.org>
Content-Type: multipart/mixed; boundary="000000000000930448064c228737"

--000000000000930448064c228737
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 27, 2026 at 2:25=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Wed, Feb 18, 2026 at 11:30=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.=
com> wrote:
> >
> > We are noticing a data corruption issue in kernels based on stable
> > 6.6.y. Especially, when a synchronous writes retried after a
> > connection reset.
> >
> > Based on investigation so far, it looks like we are having issue in
> > the following code path:
> > When SMB3 encryption is enabled, partial-page buffered writes hit the
> > synchronous write path in cifs_write_end() when the folio is not
> > uptodate (!folio_test_uptodate(folio)), it calls cifs_write() directly
> > with the kmap()'d page cache buffer, bypassing the async writeback
> > path.
> > cifs_write() calls SMB2_write(), which places the write payload in
> > rq_iov[1], pointing directly at the page cache buffer. When
> > smb3_init_transform_rq() builds the encryption request, it shares
> > rq_iov by pointer (new->rq_iov =3D old->rq_iov), and crypt_message()
> > encrypts in-place via aead_request_set_crypt(req, sg, sg, ...). This
> > destroys the original page cache data. If the write gets -EAGAIN after
> > encryption (e.g., connection reset), cifs_write() re-sends the
> > now-ciphertext buffer as if it were plaintext, resulting in
> > double-encrypted garbage on the server. The server accepts it and
> > returns success.
> > Please let me know if you have seen this issue in the past, your
> > comments on the analysis and probable fixes.
> >
> > Repro steps: Attached repro.zip with repro scripts and instructions:
> > 1) Mount with SMB3 encryption enabled
> > 2) Perform buffered writes in a loop (e.g., echo "known_pattern" >> fil=
e)
> > 3) Kill the TCP connection during writes (ss -K dport 445) to force
> > retryable errors
> > 4) Read the file back and compare against expected content
> >
> Looking at the callers, it looks like simple_fallocate_range*
> functions that make use of sync writes are also susceptible to this
> issue.
>
> > Issue can occur when all below conditions met in buffered writes:
> > 1) SMB2 encryption is active
> > 2) Sync write path: Writes reached SMB2_write via cifs_write
> > 3) Retryable network error for writes: When EAGAIN or ECONABORTED
> > returned from  cifs_send_recv().
> >
> > Here is a the sequence of operations leading to issue:
> > write(2) syscall
> >  =E2=94=94=E2=94=80 cifs_write_end()                          [file.c]
> >      =E2=94=94=E2=94=80 cifs_write()                          [file.c]
> >          =E2=94=82  iov[1].iov_base =3D write_data      =E2=86=90 page =
cache pointer enters iov[1]
> >          =E2=94=82
> >          =E2=94=94=E2=94=80 server->ops->sync_write()         [file.c]
> >              =E2=94=94=E2=94=80 smb2_sync_write()             [smb2ops.=
c:]
> >                  =E2=94=94=E2=94=80 SMB2_write()              [smb2pdu.=
c:]
> >                      =E2=94=82  rqst.rq_iov =3D iov     =E2=86=90 rqst =
points to iov[]
> > (with page cache in [1])
> >                      =E2=94=82  rqst.rq_nvec =3D n_vec+1  =E2=86=90 BUG=
: payload in
> > rq_iov, not rq_iter
> >                      =E2=94=82
> >                      =E2=94=94=E2=94=80 cifs_send_recv()      [transpor=
t.c:1305]
> >                          =E2=94=94=E2=94=80 compound_send_recv()  [tran=
sport.c:1071]
> >                              =E2=94=82
> >                              =E2=94=94=E2=94=80 smb_send_rqst()   [tran=
sport.c:427]
> >                                  =E2=94=82  if (flags & CIFS_TRANSFORM_=
REQ)  =E2=86=90
> > YES for SMB3 encryption
> >                                  =E2=94=82
> >                                  =E2=94=94=E2=94=80 server->ops->init_t=
ransform_rq()
> > [smb2ops.c:~4398]
> >                                  =E2=94=82   =3D smb3_init_transform_rq=
()
> >                                  =E2=94=82     new->rq_iov =3D old->rq_=
iov     =E2=86=90
> > SHARES pointer (not copied!)
> >                                  =E2=94=82     size =3D
> > iov_iter_count(old->rq_iter) =3D 0  =E2=86=90 empty, no copy
> >                                  =E2=94=82
> >                                  =E2=94=94=E2=94=80 __smb_send_rqst()  =
[transport.c:272]
> >                                      =E2=94=82  =E2=86=92 crypt_message=
()  [smb2ops.c:~4280]
> >                                      =E2=94=82     =E2=86=92 smb2_get_a=
ead_req()
> > [smb2ops.c:~4196]
> >                                      =E2=94=82        sg =3D scatterwal=
k from rq_iov[0..n]
> >                                      =E2=94=82
> > aead_request_set_crypt(req, sg, sg, ...)
> >                                      =E2=94=82
> >    ^^^  ^^^
> >                                      =E2=94=82
> > src=3Ddst =E2=86=92 IN-PLACE encrypt
> >                                      =E2=94=82
> >                                      =E2=94=82   iov[1] (=3D page cache=
) is now
> > AES ciphertext
> >                                      =E2=94=82
> >                                      =E2=94=94=E2=94=80 kernel_sendmsg(=
) / sock_sendmsg()
> >                                          =E2=86=92 sends encrypted data=
 on wire
> >
> >          =E2=86=90 rc =3D -EAGAIN (connection dropped)
> >
> >          is_replayable_error(rc) =3D=3D true or cifs_write while loop d=
etects EAGAIN
> >          goto replay_again                    =E2=86=90 loops back with=
 corrupted iov[1]
> >              =E2=94=94=E2=94=80 SMB2_write() re-sends...
> >                  =E2=94=94=E2=94=80 smb3_init_transform_rq()  =E2=86=90=
 encrypts ciphertext AGAIN
> >                      =E2=94=94=E2=94=80 crypt_message()       =E2=86=90=
 double-encrypted garbage
> >                          =E2=94=94=E2=94=80 server writes it to disk  =
=E2=86=90  CORRUPTION
> >
> >
> >
> > Modifying SMB2_write function by adding payload to rq_iter seems to
> > help here. Need to further test.
> > With below fix, when rq_iter size > 0 code in smb3_init_transform_rq
> > allocates fresh pages, copies the data via copy_page_from_iter(), and
> > encrypts the copy instead of the original.
> > Please let me know your comments.
> >
> >
> >  rqst.rq_iov =3D iov;
> > -rqst.rq_nvec =3D n_vec + 1;
> > +rqst.rq_nvec =3D 1;
> > +iov_iter_kvec(&rqst.rq_iter, ITER_SOURCE, &iov[1], n_vec,
> > +              io_parms->length);
> > +rqst.rq_iter_size =3D io_parms->length;
>
> Another option is to initialize iov_iter_xarray with rqst.rq_buffer,
> similar to what smb3_init_transform_rq does. But this should work too.
> Changes look good to me. Please submit a formal patch.

Thank you, Attached the patch please review. Also created the minimal
repro script with network disconnects.

Further investigation on this issue indicates that the issue is not
specific to the 6.6 Kernel; instead,
the issue can happen in kernels <6.10 including 6.1, 6.6 and 5.15 and beyon=
d.

On older kernels ~5.15 with deferred closes may reduce exposure
because deferred handles might keep help pages
in memory and which may help writes to avoid sync_write path.
But commit 262b73ef442e (smb3 client: fix open hardlink on deferred
close file error, backported till 6.1) appears to
increase the likelihood of taking the sync_write path because we close
deferred handles aggressively in some cases,
which makes the existing encryption write corruption bug easier to
trigger. The commit does not introduce the bug;
It increases trigger frequency for writes taking sync_write path.

I will send out this patch to the stable mailing list separately.

--000000000000930448064c228737
Content-Type: application/octet-stream; 
	name="0001-smb-client-fix-page-cache-corruption-from-in-place-e.patch"
Content-Disposition: attachment; 
	filename="0001-smb-client-fix-page-cache-corruption-from-in-place-e.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mmavluqd0>
X-Attachment-Id: f_mmavluqd0

RnJvbSBkOWRmMDVjYjVlZGRhZjE2MGEyOTQ3ZjQ1MTA3MjgwOTVmNjJlODczIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCaGFyYXRoIFNNIDxiaGFyYXRoc21AbWljcm9zb2Z0LmNvbT4K
RGF0ZTogVHVlLCAzIE1hciAyMDI2IDE0OjA1OjMwICswMDAwClN1YmplY3Q6IFtQQVRDSF0gc21i
OiBjbGllbnQ6IGZpeCBwYWdlIGNhY2hlIGNvcnJ1cHRpb24gZnJvbSBpbi1wbGFjZQogZW5jcnlw
dGlvbiBpbiBTTUIyX3dyaXRlCgpTTUIyX3dyaXRlKCkgcGFzc2VzIGRhdGEga3ZlY3MgaW5saW5l
IGluIHJxX2lvdiBieSBzZXR0aW5nCnJxc3QucnFfbnZlYyA9IG5fdmVjICsgMS4gV2hlbiBTTUIz
IGVuY3J5cHRpb24gaXMgbmVnb3RpYXRlZCwKc21iM19pbml0X3RyYW5zZm9ybV9ycSgpIC0+IGNy
eXB0X21lc3NhZ2UoKSBlbmNyeXB0cyBkYXRhIGluIHRoZQprdmVjIGJ1ZmZlcnMgaW4tcGxhY2Uu
CgpGb3Igc3luY2hyb25vdXMgd3JpdGVzIHRocm91Z2ggY2lmc193cml0ZSgpLCB0aGUga3ZlYyBi
dWZmZXJzIHBvaW50CmRpcmVjdGx5IGludG8gdGhlIHBhZ2UgY2FjaGUgdmlhIGttYXAoKS4gSW4t
cGxhY2UgZW5jcnlwdGlvbiBvdmVyd3JpdGVzCnRoZSBwYWdlIGNhY2hlIHdpdGggY2lwaGVydGV4
dC4gSWYgdGhlIHNlbmQgZmFpbHMgd2l0aCBhIHJlcGxheWFibGUKZXJyb3Igc3VjaCBhcyAtRUFH
QUlOIChlLmcuLCBmcm9tIGEgY29ubmVjdGlvbiByZXNldCksIFNNQjJfd3JpdGUoKQpyZXRyaWVz
IHRoZSB3cml0ZSB1c2luZyB0aGUgc2FtZSBpb3ZbMV0gYnVmZmVyLiBTaW5jZSBpb3ZbMV0gbm93
CmNvbnRhaW5zIGNpcGhlcnRleHQgZnJvbSB0aGUgZmlyc3QgYXR0ZW1wdCwgdGhlIHJldHJ5IGVu
Y3J5cHRzIGFuZApzZW5kcyBjaXBoZXJ0ZXh0LWFzLWRhdGEgdG8gdGhlIHNlcnZlciwgcmVzdWx0
aW5nIGluIGRhdGEgY29ycnVwdGlvbi4KClRoZSBjb3JydXB0aW9uIGlzIG1vc3QgbGlrZWx5IHRv
IGJlIG9ic2VydmVkIHdoZW4gY29ubmVjdGlvbnMgYXJlCnVuc3RhYmxlLCBhcyByZWNvbm5lY3Rz
IHRyaWdnZXIgd3JpdGUgcmV0cmllcyB0aGF0IHJlLXNlbmQgdGhlCmFscmVhZHktZW5jcnlwdGVk
IHBhZ2UgY2FjaGUgZGF0YS4KClRoZSBzeW5jIHBhdGggY2FuIGJlIHJlYWNoZWQgZHVyaW5nIHBh
cnRpYWwtcGFnZSBPX1dST05MWSB3cml0ZXMgd2hlbgp0aGUgcGFnZSBpcyBub3QgaW4gY2FjaGUg
KGNvbW1vbiBmb3IgYXBwZW5kIHdvcmtsb2FkcyB3aXRoIHJlcGVhdGVkCm9wZW4vd3JpdGUvY2xv
c2UgcGF0dGVybnMpLgoKVGhlIGFzeW5jIHdyaXRlIHBhdGggKHNtYjJfYXN5bmNfd3JpdGV2KSBp
cyBub3QgYWZmZWN0ZWQgYmVjYXVzZSBpdApwYXNzZXMgZGF0YSB2aWEgcnFzdC5ycV9pdGVyLCB3
aGljaCB0aGUgZW5jcnlwdGlvbiBsYXllciBoYW5kbGVzCndpdGhvdXQgbW9kaWZ5aW5nIHRoZSBz
b3VyY2UgYnVmZmVycy4KCkZpeCBieSBzZXR0aW5nIHJxX252ZWMgPSAxIChoZWFkZXIgb25seSkg
YW5kIG1vdmluZyBkYXRhIGt2ZWNzIGludG8KcnFfaXRlciB2aWEgaW92X2l0ZXJfa3ZlYygpLgoK
U2lnbmVkLW9mZi1ieTogQmhhcmF0aCBTTSA8YmhhcmF0aHNtQG1pY3Jvc29mdC5jb20+ClJldmll
d2VkLWJ5OiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29tPgpDYzogc3RhYmxl
QHZnZXIua2VybmVsLm9yZyAjdjYuMX52Ni45Ci0tLQogZnMvc21iL2NsaWVudC9zbWIycGR1LmMg
fCA2ICsrKysrLQogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jIGIvZnMvc21iL2NsaWVudC9z
bWIycGR1LmMKaW5kZXggYTg4OTBhZTIxNzE0Li5hODhhMTlkZWM0OTQgMTAwNjQ0Ci0tLSBhL2Zz
L3NtYi9jbGllbnQvc21iMnBkdS5jCisrKyBiL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jCkBAIC01
MDcyLDcgKzUwNzIsMTEgQEAgU01CMl93cml0ZShjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1
Y3QgY2lmc19pb19wYXJtcyAqaW9fcGFybXMsCiAKIAltZW1zZXQoJnJxc3QsIDAsIHNpemVvZihz
dHJ1Y3Qgc21iX3Jxc3QpKTsKIAlycXN0LnJxX2lvdiA9IGlvdjsKLQlycXN0LnJxX252ZWMgPSBu
X3ZlYyArIDE7CisJcnFzdC5ycV9udmVjID0gMTsKKwlpb3ZfaXRlcl9rdmVjKCZycXN0LnJxX2l0
ZXIsIElURVJfU09VUkNFLCAmaW92WzFdLCBuX3ZlYywKKwkJICAgICAgaW9fcGFybXMtPmxlbmd0
aCk7CisJcnFzdC5ycV9pdGVyX3NpemUgPSBpb19wYXJtcy0+bGVuZ3RoOworCiAKIAlpZiAocmV0
cmllcykKIAkJc21iMl9zZXRfcmVwbGF5KHNlcnZlciwgJnJxc3QpOwotLSAKMi40NS40Cgo=
--000000000000930448064c228737
Content-Type: text/x-sh; charset="US-ASCII"; name="repro_corruption.sh"
Content-Disposition: attachment; filename="repro_corruption.sh"
Content-Transfer-Encoding: base64
Content-ID: <f_mmavm0721>
X-Attachment-Id: f_mmavm0721

IyEvYmluL2Jhc2gNCiMNCiMgUmVwcm9kdWNlciBmb3IgcGFnZSBjYWNoZSBjb3JydXB0aW9uIGNh
dXNlZCBieSBpbi1wbGFjZSBlbmNyeXB0aW9uDQojIGluIFNNQjJfd3JpdGUoKS4NCiMNCiMgU01C
Ml93cml0ZSgpIHBhc3NlcyBwYWdlIGNhY2hlIGRhdGEgaW5saW5lIGluIHJxX2lvdiAocnFfbnZl
YyA9IG5fdmVjICsgMSkuDQojIFdoZW4gU01CMyBlbmNyeXB0aW9uIGlzIGFjdGl2ZSwgY3J5cHRf
bWVzc2FnZSgpIGVuY3J5cHRzIHRoZXNlIGJ1ZmZlcnMNCiMgaW4tcGxhY2UsIG92ZXJ3cml0aW5n
IHBhZ2UgY2FjaGUgd2l0aCBjaXBoZXJ0ZXh0LiBPbiByZXBsYXkgYWZ0ZXIgYQ0KIyByZXBsYXlh
YmxlIHNlbmQgZmFpbHVyZSwgdGhlIGNpcGhlcnRleHQgaXMgcmUtc2VudCBhcyBwbGFpbnRleHQu
DQojIFRoZSBzZXJ2ZXIgc3RvcmVzIGNpcGhlcnRleHQgYXMgZmlsZSBjb250ZW50LiBObyBlcnJv
ciB0byB1c2Vyc3BhY2UuDQojDQojIFRoZSBzeW5jIHdyaXRlIHBhdGggKGNpZnNfd3JpdGVfZW5k
IC0+IGNpZnNfd3JpdGUgLT4gU01CMl93cml0ZSkgaXMgdGFrZW4NCiMgd2hlbiBPX1dST05MWSBw
YXJ0aWFsIHdyaXRlcyBoaXQgYSBub24tdXB0b2RhdGUgcGFnZSBhdCBhIG1pZC1maWxlIG9mZnNl
dC4NCiMNCiMgU3RyYXRlZ3k6IDEwIGNvbmN1cnJlbnQgT19XUk9OTFkgbWlkLWZpbGUgd3JpdGVy
cyArIHBlcmlvZGljIHNzIC1LIHRvDQojIGtpbGwgdGhlIHNvY2tldCBtaWQtZW5jcnlwdC4gVHlw
aWNhbGx5IHJlcHJvZHVjZXMgaW4gMS0zIGN5Y2xlcy4NCiMNCiMgVXNhZ2U6IHN1ZG8gLi90ZXN0
X3NtYjJfd3JpdGVfZW5jcnlwdF9jb3JydXB0aW9uLnNoIC9tbnQvc21ic2hhcmUvdGVzdGRpcg0K
Iw0KDQoNCnNldCAtdQ0KDQpURVNURElSPSIkezE6LS59Ig0KTkZJTEVTPTEwDQpFUlJPUlM9MA0K
DQpjbGVhbnVwKCkgew0KICAgIGtpbGwgLTkgJFBJRFMgMj4vZGV2L251bGwNCiAgICB3YWl0IDI+
L2Rldi9udWxsDQp9DQp0cmFwIGNsZWFudXAgRVhJVA0KDQplY2hvICI9PT0gU01CMl93cml0ZSgp
IGVuY3J5cHRpb24gcGFnZSBjYWNoZSBjb3JydXB0aW9uIHJlcHJvZHVjZXIgPT09Ig0KZWNobyAi
RGlyOiAgICAkVEVTVERJUiINCmVjaG8gIktlcm5lbDogJCh1bmFtZSAtcikiDQplY2hvICJTdGFy
dDogICQoZGF0ZSkiDQplY2hvICIiDQoNCm1rZGlyIC1wICIkVEVTVERJUiINCg0KIyBDcmVhdGUg
ZmlsZXMgZmlsbGVkIHdpdGggYSBrbm93biBsZXR0ZXI6IGYxPSdBJywgZjI9J0InLCAuLi4sIGYx
MD0nSicNCmVjaG8gIkNyZWF0aW5nIHRlc3QgZmlsZXMuLi4iDQpmb3IgZiBpbiAkKHNlcSAxICRO
RklMRVMpOyBkbw0KICAgIEJZVEU9JCgoMHg0MCArIGYpKSAgIyAweDQxPSdBJywgMHg0Mj0nQics
IC4uLiwgMHg0YT0nSicNCiAgICBweXRob24zIC1jICJvcGVuKCckVEVTVERJUi9mJHtmfS5kYXQn
LCd3YicpLndyaXRlKGJ5dGVzKFskQllURV0pKjY1NTM2KSINCmRvbmUNCnN5bmM7IHNsZWVwIDEN
CmVjaG8gIkRvbmUuIg0KDQojIFdyaXRlcjogT19XUk9OTFkgbWlkLWZpbGUgcGFydGlhbCB3cml0
ZXMgKHRyaWdnZXJzIHN5bmMgcGF0aCkNCiMgLSBPX1dST05MWTogd3JpdGVfYmVnaW4oKSBza2lw
cyByZWFkaW5nIHRoZSBwYWdlIC0+IHBhZ2Ugc3RheXMgbm90LXVwdG9kYXRlDQojIC0gTWlkLWZp
bGU6IHdyaXRlX2JlZ2luKCkncyBFT0YgemVyby1maWxsIHNob3J0Y3V0IGRvZXMgbm90IGFwcGx5
DQojIC0gMjAwIGJ5dGVzOiBwYXJ0aWFsIHBhZ2UsIHBhZ2UgbmV2ZXIgbWFya2VkIHVwdG9kYXRl
DQojIC0+IGNpZnNfd3JpdGVfZW5kKCkgdGFrZXMgc3luYyBwYXRoOiBrbWFwIC0+IGNpZnNfd3Jp
dGUgLT4gU01CMl93cml0ZQ0Kd3JpdGVyKCkgew0KICAgIGxvY2FsIGZuYW1lPSQxIGJ5dGU9JDIN
CiAgICB3aGlsZSB0cnVlOyBkbw0KICAgICAgICBweXRob24zIC1jICINCmltcG9ydCBvcywgcmFu
ZG9tDQp0cnk6DQogICAgZmQgPSBvcy5vcGVuKCckZm5hbWUnLCBvcy5PX1dST05MWSkNCiAgICBv
ZmYgPSByYW5kb20ucmFuZGludCgxMDAsIDYwMDAwKQ0KICAgIG9zLmxzZWVrKGZkLCBvZmYsIG9z
LlNFRUtfU0VUKQ0KICAgIG9zLndyaXRlKGZkLCBieXRlcyhbJGJ5dGVdKSAqIDIwMCkNCiAgICBv
cy5jbG9zZShmZCkNCmV4Y2VwdDoNCiAgICBwYXNzDQoiIDI+L2Rldi9udWxsDQogICAgZG9uZQ0K
fQ0KDQplY2hvICJTdGFydGluZyAkTkZJTEVTIHdyaXRlcnMuLi4iDQpQSURTPSIiDQpmb3IgZiBp
biAkKHNlcSAxICRORklMRVMpOyBkbw0KICAgIEJZVEU9JCgoMHg0MCArIGYpKQ0KICAgIHdyaXRl
ciAiJFRFU1RESVIvZiR7Zn0uZGF0IiAkQllURSAmDQogICAgUElEUz0iJFBJRFMgJCEiDQpkb25l
DQoNCmVjaG8gIlJ1bm5pbmcgZGlzcnVwdGlvbiBjeWNsZXMuLi4iDQplY2hvICIiDQpmb3IgY3lj
bGUgaW4gJChzZXEgMSAxNSk7IGRvDQogICAgIyBXYXJtIHVwOiBsZXQgd3JpdGVycyBydW4gbm9y
bWFsbHkNCiAgICBzbGVlcCAzDQoNCiAgICAjIENvbGQgY2FjaGU6IGV2aWN0IHBhZ2VzIHNvIG5l
eHQgd3JpdGVzIGhpdCBub24tdXB0b2RhdGUgcGFnZXMNCiAgICBlY2hvIDMgPiAvcHJvYy9zeXMv
dm0vZHJvcF9jYWNoZXMgMj4vZGV2L251bGwNCg0KICAgICMgTGV0IHdyaXRlcyBhY2N1bXVsYXRl
IG9uIGNvbGQgY2FjaGUgKGFsbCBnbyB0aHJvdWdoIHN5bmMgcGF0aCkNCiAgICBzbGVlcCAyDQoN
CiAgICAjIEtpbGwgc29ja2V0OiBpZiBhIHdyaXRlIGlzIGJldHdlZW4gY3J5cHRfbWVzc2FnZSgp
IGFuZCBUQ1Agc2VuZCwNCiAgICAjIGlvdlsxXSAocGFnZSBjYWNoZSkgaXMgYWxyZWFkeSBlbmNy
eXB0ZWQgaW4tcGxhY2UuIFRoZSBzZW5kIGZhaWxzLA0KICAgICMgcmVwbGF5X2FnYWluIHJlLXNl
bmRzIGNpcGhlcnRleHQgYXMgcGxhaW50ZXh0IHRvIHRoZSBzZXJ2ZXIuDQogICAgIyB3ZSBjYW4g
YWxzbyByZXBsYWNlIHNzIC1LIHdpdGggdGNwa2lsbCBvciBzaW1pbGFyIHRvIHRhcmdldCB0aGUg
c29ja2V0IG1vcmUgcHJlY2lzZWx5LCBidXQgc3MgLUsgaXMgc2ltcGxlciBhbmQgd29ya3Mgd2Vs
bCBlbm91Z2guDQogICAgc3MgLUsgZHBvcnQgPSA0NDUgPiAvZGV2L251bGwgMj4mMQ0KICAgIGVj
aG8gIiAgW2N5Y2xlICRjeWNsZV0gc29ja2V0IGtpbGxlZCBhdCAkKGRhdGUgKyVUKSINCg0KICAg
ICMgV2FpdCBmb3IgcmVjb25uZWN0LCB0aGVuIHJlLXJlYWQgZnJvbSBzZXJ2ZXIgKG5vdCBsb2Nh
bCBjYWNoZSkNCiAgICBzbGVlcCA0DQogICAgZWNobyAzID4gL3Byb2Mvc3lzL3ZtL2Ryb3BfY2Fj
aGVzIDI+L2Rldi9udWxsDQogICAgc2xlZXAgMQ0KDQogICAgIyBWZXJpZnk6IGV2ZXJ5IGJ5dGUg
c2hvdWxkIG1hdGNoIGV4cGVjdGVkIHZhbHVlDQogICAgQ1lDTEVfRVJST1JTPTANCiAgICBmb3Ig
ZiBpbiAkKHNlcSAxICRORklMRVMpOyBkbw0KICAgICAgICBCWVRFPSQoKDB4NDAgKyBmKSkNCiAg
ICAgICAgcHl0aG9uMyAtYyAiDQppbXBvcnQgc3lzDQp0cnk6DQogICAgZGF0YSA9IG9wZW4oJyRU
RVNURElSL2Yke2Z9LmRhdCcsJ3JiJykucmVhZCgpDQpleGNlcHQgT1NFcnJvciBhcyBlOg0KICAg
IHByaW50KGYnICBTS0lQIGYke2Z9LmRhdDoge2V9JykNCiAgICBzeXMuZXhpdCgwKQ0KZm9yIGks
YiBpbiBlbnVtZXJhdGUoZGF0YSk6DQogICAgaWYgYiAhPSAkQllURToNCiAgICAgICAgcHJpbnQo
ZicgIENPUlJVUFRJT04gZiR7Zn0uZGF0IG9mZnNldD0weHtpOnh9IGV4cD0weHskQllURTowMnh9
KHtjaHIoJEJZVEUpfSkgZ290PTB4e2I6MDJ4fScpDQogICAgICAgIHN5cy5leGl0KDEpDQoiDQog
ICAgICAgIGlmIFsgJD8gLW5lIDAgXTsgdGhlbg0KICAgICAgICAgICAgQ1lDTEVfRVJST1JTPSQo
KENZQ0xFX0VSUk9SUyArIDEpKQ0KICAgICAgICAgICAgRVJST1JTPSQoKEVSUk9SUyArIDEpKQ0K
ICAgICAgICBmaQ0KICAgIGRvbmUNCiAgICBlY2hvICIgIFtjeWNsZSAkY3ljbGVdIHZlcmlmaWVk
ICgkQ1lDTEVfRVJST1JTIGVycm9ycykiDQpkb25lDQoNCmVjaG8gIiINCmVjaG8gIlN0b3BwaW5n
IHdyaXRlcnMuLi4iDQpraWxsICRQSURTIDI+L2Rldi9udWxsDQp3YWl0IDI+L2Rldi9udWxsDQoN
CmVjaG8gIiINCmVjaG8gIj09PSBSZXN1bHRzID09PSINCmVjaG8gIkVycm9yczogJEVSUk9SUyIN
CmVjaG8gIkVuZDogICAgJChkYXRlKSINCg0KaWYgWyAkRVJST1JTIC1ndCAwIF07IHRoZW4NCiAg
ICBlY2hvICJGQUlMOiBJbi1wbGFjZSBlbmNyeXB0aW9uIGNvcnJ1cHRlZCBwYWdlIGNhY2hlIGRh
dGEuIg0KICAgIGVjaG8gIkZpeDogcGFzcyBkYXRhIHZpYSBycV9pdGVyIGluc3RlYWQgb2YgaW5s
aW5lIGluIHJxX2lvdi4iDQplbHNlDQogICAgZWNobyAiUEFTUzogTm8gY29ycnVwdGlvbiBkZXRl
Y3RlZC4gVHJ5IHJ1bm5pbmcgYWdhaW4uIg0KZmkNCg0Kcm0gLWYgIiRURVNURElSIi9mKi5kYXQN
Cg==
--000000000000930448064c228737--
