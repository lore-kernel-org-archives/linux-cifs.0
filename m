Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6273B3EBF13
	for <linux-cifs@vger.kernel.org>; Wed, 18 Feb 2026 18:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771437628; cv=pass; b=p2ngN7TvgVxAD9Ymv88yYyXMZzW5zI27E94pCAAhB344qiFpZUCTpQ3EYH50XTZDJgjeytJSFgCyNpdKGbWH63IzGNIZodB5vE6nCgin+zVewvWyXZrb95zAGIoO6jKJ9iZzOwdR0Y/rUxgvhIdudScuNx0I10jJ2sWZmwo4P4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771437628; c=relaxed/simple;
	bh=5k1bcddflTE556Fq/4FL3grtoVGkqD7OXyksXyt08cw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=BbknhG02oSTtuRkAmQ756P0MByNbreAevW2efLMAbQRWfYG9Gxu4b4eeHGRUh5EjEvHIffLU2/IcXA1l3WHX4nN/Kw2j4Oe82kJs5hjxfFfnelnJDjZ82Az4kg4C9YsnwbKe0LhdY4rX7froe6CRj7LYmZb31r9lVet5BMZxeRA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W+CTZ/8Q; arc=pass smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W+CTZ/8Q"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-790884840baso1114347b3.0
        for <linux-cifs@vger.kernel.org>; Wed, 18 Feb 2026 10:00:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771437626; cv=none;
        d=google.com; s=arc-20240605;
        b=E7+2CsfxUzsocEFoXt3b6HAjtC6iZG4qIpBaXnK95Wr372Z9OYkRexuwVkfltETfnL
         LcUAcyCZbH1wKtGYcyBqF2OfnDUu4KHrobuAvzTLAxoDKUWJFBN9VQWLv+/75reEFLm6
         Kq6c+ZN9ZzPvH888iO4tCq+zn2cLP85PlulIipvM+PEwjXhgxGtsM6MnlntdzFnbRJxt
         PaX3rkzpnvgy0lhRkKLbIQjI8VhZtshQr6Kxz2ZEFDGkD2TMx5f/G+rhxu7A6lZnY4uV
         N13bP9heyxfZ7rui3jxHGy6XKSOtz1t3K6pXmCVRNrzq+p1BQqjMHssjDXRimauZrAfg
         g2IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=jESUhagQHyjgiw4+SaF1wSDtzsdEwJJrdskfjfI2PAg=;
        fh=TPG+v16e3Yeo0NEmcOaQ8VF3v7OBvtTQWZGJgvmlvqQ=;
        b=jj93BAEbow1bpCGRfn4W+fg4i6s18r/oLISahLcBqmfhUKXvKICdf11mVbhtlAe5U2
         7jRsotjLz4hpjrc6QRpPP0VNM41cVIe2y6g8IweFrDr0pV9R90ihB/qFJZSdGxAwqAGB
         ICVp6Fye+bt/Awn2PXAadHQyA79Bp52gui5Mi3DX3Kq3Qpbidu8/WH8kFz1AzTQDMAZ2
         /Kj1PkWCRPHvE+0F4G4t+w7DjHyUfu9IIlCtOYjHGrJQ8DVPts0brbApVdsK1VBhVlqS
         d3UYUAT6BE6YzTGJfzN++o92U1Cp3TeHUwvUAZE8XZ4cScGttC9WvB/SGBp3KGU1UjDS
         9Z/w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771437626; x=1772042426; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jESUhagQHyjgiw4+SaF1wSDtzsdEwJJrdskfjfI2PAg=;
        b=W+CTZ/8QBw9eQ/KONRi76RAO52suMFClEiV9JReqbzphfAPE4LxrUEtOBUCP+1U3fY
         K4lvWEIxbaq2e2XZSZlxfLODGiBikmiWCt461g3cc54C2jS7hHwZGmXRDn9nvxR9qNHs
         7ozLXku0dZoeCIIprb3Ehd3Jtp/WYkWwDpVCmpbzHQ4pKtGOglo1WRNGg9VOJZRULw1E
         H2w4eGd+dstYg9pL3WgGbqILlaMts6qh7IVQUO/cNgEHuOb6uNqnxzqCETEHdumVq2HW
         9NLiXZyZCSfBzIZi1YmZE2qsQCOAf0luIVRz1MirEZiJ3LYzaUEVJ5HTwvqiGVJiDzw/
         CVMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771437626; x=1772042426;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jESUhagQHyjgiw4+SaF1wSDtzsdEwJJrdskfjfI2PAg=;
        b=Q0Z2XQRCN3OiFrBsnfHNgD2sMT2DUlYKuj+M0+V5SLsgRhDA1GMhseHGmIPHhRfRNN
         sR0IhihyqoO6JJ2nEeMnndHJ54NIBrhVD5i1vBBMZTIMgOGAu+k/c7i5+xm6IX3w0tCT
         3BxOnvq6Jy4QUaLkkQyu+jxAtMWyX6kP8eNRVesHwnWfEKnxo9WlZALNzDPDQEiCNrry
         28huJoDLgsaN49qfq1SubU6lhiHpm/GTVPAo0eTigU7g5AOUhLCcVc8YRqNqsv2Gj+Bn
         L3RMomQ2arxTeQZ3yXOeJtOrXdNMjS8IV5tYME7Ft96uczfr4CDDlNdC+dfGwxExYMgS
         i2pg==
X-Forwarded-Encrypted: i=1; AJvYcCUpYCRaiDxB8OTxOOFLYcWyboJeC8/z6YOXijNJmH5tCh1I7t2JObPd+CS/PFtfFk9phYp9Vbvp9lPz@vger.kernel.org
X-Gm-Message-State: AOJu0YyceD+Kql/RdbMl8nieuWIbsDYxiiRwwTDrye8N8O7j4UKGN0wq
	5IbMiyRGNgXW1eUe5qXobfhjzyIv+Tgz1ygEowGTx92N0lY6yOJ1LnLoB4sFmiNoLJarCBSNrpD
	wNe9v9FcIq/94c4lqeXxtxIUe7m5+VBY=
X-Gm-Gg: AZuq6aIVpv2bDjSAsuscnio0ILdLCtyuvLdmNNTbGmkSvaVxrF9Gx+SsB4tV/wdxFaQ
	L8tg+zvNJVpEWFYNNkcu+LvL4Iud/TfbV3Evatd6bCzcpecnE6ZNd/k3Q5HaxOy4NcSlbh+GDDh
	k724AyBJwwYYEaDL0reJq2cJRE3typd9M+WjfHh1j/36vjdYorl9U4YJ/qWckG07jbMXI2cf8jo
	TGeWZU7lVWmmfwNBQXMzt8TvcNO8Ya0N0N+JfeEBbCncn1llQ18is7qlukP7paMYre1ZTb+rpNw
	PMfmd9nDrKiXuSIiuqs9bvuc9Xt7gtoPZ6bQYM0=
X-Received: by 2002:a05:690c:368e:b0:796:45d4:9e2d with SMTP id
 00721157ae682-797a0cf98e5mr147786147b3.53.1771437625927; Wed, 18 Feb 2026
 10:00:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Wed, 18 Feb 2026 10:00:14 -0800
X-Gm-Features: AaiRm525T-561CV67xe7zvCcw8HEm-oxtjHQ5F9sFTZ_SVIl-wPxIUWrqZu-FfM
Message-ID: <CAGypqWyDOfspVUMe3fm5bfQtC_wH2eEzRgppYvWUVDe1RHLy9Q@mail.gmail.com>
Subject: [BUG] [~6.6 Kernel] Corruption when retrying encrypted sync writes
To: David Howells <dhowells@redhat.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Shyam Prasad <Shyam.Prasad@microsoft.com>, Steve French <smfrench@gmail.com>, 
	CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@manguebit.com>, 
	Enzo Matsumiya <ematsumiya@suse.de>, Henrique Carvalho <henrique.carvalho@suse.com>, 
	Bharath S M <bharathsm@microsoft.com>
Content-Type: multipart/mixed; boundary="0000000000006fdeac064b1cf63d"

--0000000000006fdeac064b1cf63d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We are noticing a data corruption issue in kernels based on stable
6.6.y. Especially, when a synchronous writes retried after a
connection reset.

Based on investigation so far, it looks like we are having issue in
the following code path:
When SMB3 encryption is enabled, partial-page buffered writes hit the
synchronous write path in cifs_write_end() when the folio is not
uptodate (!folio_test_uptodate(folio)), it calls cifs_write() directly
with the kmap()'d page cache buffer, bypassing the async writeback
path.
cifs_write() calls SMB2_write(), which places the write payload in
rq_iov[1], pointing directly at the page cache buffer. When
smb3_init_transform_rq() builds the encryption request, it shares
rq_iov by pointer (new->rq_iov =3D old->rq_iov), and crypt_message()
encrypts in-place via aead_request_set_crypt(req, sg, sg, ...). This
destroys the original page cache data. If the write gets -EAGAIN after
encryption (e.g., connection reset), cifs_write() re-sends the
now-ciphertext buffer as if it were plaintext, resulting in
double-encrypted garbage on the server. The server accepts it and
returns success.
Please let me know if you have seen this issue in the past, your
comments on the analysis and probable fixes.

Repro steps: Attached repro.zip with repro scripts and instructions:
1) Mount with SMB3 encryption enabled
2) Perform buffered writes in a loop (e.g., echo "known_pattern" >> file)
3) Kill the TCP connection during writes (ss -K dport 445) to force
retryable errors
4) Read the file back and compare against expected content

Issue can occur when all below conditions met in buffered writes:
1) SMB2 encryption is active
2) Sync write path: Writes reached SMB2_write via cifs_write
3) Retryable network error for writes: When EAGAIN or ECONABORTED
returned from  cifs_send_recv().

Here is a the sequence of operations leading to issue:
write(2) syscall
 =E2=94=94=E2=94=80 cifs_write_end()                          [file.c]
     =E2=94=94=E2=94=80 cifs_write()                          [file.c]
         =E2=94=82  iov[1].iov_base =3D write_data      =E2=86=90 page cach=
e pointer enters iov[1]
         =E2=94=82
         =E2=94=94=E2=94=80 server->ops->sync_write()         [file.c]
             =E2=94=94=E2=94=80 smb2_sync_write()             [smb2ops.c:]
                 =E2=94=94=E2=94=80 SMB2_write()              [smb2pdu.c:]
                     =E2=94=82  rqst.rq_iov =3D iov     =E2=86=90 rqst poin=
ts to iov[]
(with page cache in [1])
                     =E2=94=82  rqst.rq_nvec =3D n_vec+1  =E2=86=90 BUG: pa=
yload in
rq_iov, not rq_iter
                     =E2=94=82
                     =E2=94=94=E2=94=80 cifs_send_recv()      [transport.c:=
1305]
                         =E2=94=94=E2=94=80 compound_send_recv()  [transpor=
t.c:1071]
                             =E2=94=82
                             =E2=94=94=E2=94=80 smb_send_rqst()   [transpor=
t.c:427]
                                 =E2=94=82  if (flags & CIFS_TRANSFORM_REQ)=
  =E2=86=90
YES for SMB3 encryption
                                 =E2=94=82
                                 =E2=94=94=E2=94=80 server->ops->init_trans=
form_rq()
[smb2ops.c:~4398]
                                 =E2=94=82   =3D smb3_init_transform_rq()
                                 =E2=94=82     new->rq_iov =3D old->rq_iov =
    =E2=86=90
SHARES pointer (not copied!)
                                 =E2=94=82     size =3D
iov_iter_count(old->rq_iter) =3D 0  =E2=86=90 empty, no copy
                                 =E2=94=82
                                 =E2=94=94=E2=94=80 __smb_send_rqst()  [tra=
nsport.c:272]
                                     =E2=94=82  =E2=86=92 crypt_message()  =
[smb2ops.c:~4280]
                                     =E2=94=82     =E2=86=92 smb2_get_aead_=
req()
[smb2ops.c:~4196]
                                     =E2=94=82        sg =3D scatterwalk fr=
om rq_iov[0..n]
                                     =E2=94=82
aead_request_set_crypt(req, sg, sg, ...)
                                     =E2=94=82
   ^^^  ^^^
                                     =E2=94=82
src=3Ddst =E2=86=92 IN-PLACE encrypt
                                     =E2=94=82
                                     =E2=94=82   iov[1] (=3D page cache) is=
 now
AES ciphertext
                                     =E2=94=82
                                     =E2=94=94=E2=94=80 kernel_sendmsg() / =
sock_sendmsg()
                                         =E2=86=92 sends encrypted data on =
wire

         =E2=86=90 rc =3D -EAGAIN (connection dropped)

         is_replayable_error(rc) =3D=3D true or cifs_write while loop detec=
ts EAGAIN
         goto replay_again                    =E2=86=90 loops back with cor=
rupted iov[1]
             =E2=94=94=E2=94=80 SMB2_write() re-sends...
                 =E2=94=94=E2=94=80 smb3_init_transform_rq()  =E2=86=90 enc=
rypts ciphertext AGAIN
                     =E2=94=94=E2=94=80 crypt_message()       =E2=86=90 dou=
ble-encrypted garbage
                         =E2=94=94=E2=94=80 server writes it to disk  =E2=
=86=90  CORRUPTION



Modifying SMB2_write function by adding payload to rq_iter seems to
help here. Need to further test.
With below fix, when rq_iter size > 0 code in smb3_init_transform_rq
allocates fresh pages, copies the data via copy_page_from_iter(), and
encrypts the copy instead of the original.
Please let me know your comments.


 rqst.rq_iov =3D iov;
-rqst.rq_nvec =3D n_vec + 1;
+rqst.rq_nvec =3D 1;
+iov_iter_kvec(&rqst.rq_iter, ITER_SOURCE, &iov[1], n_vec,
+              io_parms->length);
+rqst.rq_iter_size =3D io_parms->length;

--0000000000006fdeac064b1cf63d
Content-Type: application/x-zip-compressed; name="repro.zip"
Content-Disposition: attachment; filename="repro.zip"
Content-Transfer-Encoding: base64
Content-ID: <f_mlsbfi0j0>
X-Attachment-Id: f_mlsbfi0j0

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
--0000000000006fdeac064b1cf63d--
