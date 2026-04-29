Received: from o4.p38.mailjet.com (o4.p38.mailjet.com [185.250.237.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C161DFDE
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 10:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.250.237.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777456831; cv=none; b=e8+zZtxhgzRHV5cttk0rwn38mAN3gk3bg2QgxyXbWkkJ1Ab7+MTzAaThg7d3yy64HQHkjMyOiuwFaaEE6NF9iQcRCvLyNCiVGx2gPc/h+a7nx16QEda0qzJKlGFLSapltCXW/YjsSbkVsRKEI+ZY6Rg/s7wEqdBIJg3jOBML52w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777456831; c=relaxed/simple;
	bh=vxjuH98lz95r5OFYrZlc34xqxhXWg4UjUYUzzX5mptw=;
	h=Message-Id:MIME-Version:From:To:Subject:Date:Cc; b=hDL62aq8Efm6yjVpB5GB2+yHMmQOuBxB0BTJ/SohMxybBaBnC3Q8mnFJ4iYzIDsE4/xS0yhR1/TO8ygm1DZtwUin4VxdCkH0j+FCa/9/D/ugECJDsGJjaGBFPpfj+6zOVF/c6ye3v6hAgsd0paciUKXGderUBU9nnJxn7SvzWBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yikuo.dev; spf=pass smtp.mailfrom=a3119462.bnc3.mailjet.com; dkim=pass (2048-bit key) header.d=yikuo.dev header.i=yi@yikuo.dev header.b=gMrUbgBP; arc=none smtp.client-ip=185.250.237.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yikuo.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=a3119462.bnc3.mailjet.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yikuo.dev header.i=yi@yikuo.dev header.b="gMrUbgBP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; q=dns/txt;
  d=yikuo.dev; i=yi@yikuo.dev; s=mailjet; t=1777456827; x=1777464027;
  h=Message-Id: MIME-Version: From: To: Subject: Date:
   List-Unsubscribe: List-Unsubscribe-Post: Cc: Feedback-Id:
   X-CSA-Complaints: X-MJ-Mid: X-MJ-SMTPGUID:
   X-REPORT-ABUSE-TO: Content-Transfer-Encoding: To: From:
   Sender: Subject: Date;
  bh=R6D6QMuIFoaRvx2O2b0MppS8qCJC9ITDHlDI6jdA3+w=;
  b=gMrUbgBPEbGeIea45WzGVAYc0OYeorBWwDzJJK6RFUOHIO/gW8DUYz+UP
 /tQ5FPc9E9o1YPzHvIpurHlziP9amI3qNJsX7Kw51zWg/5HlY5tcy+B1gi9b
 HaX35Dx5Eo4ifroBmv3T2ALq1w6n6zqeB3wYORKQDE1D4gADvoUAv6xwIniL
 7EWdVtdLUhxErrmoDgzRw9v+sE6e136T8sYItVmJbomxwZJcT5HseYX7pmP6
 fDL4Um8jCdJQen7CYlXPaX5JDS14XBhTmvVubvRokFXpO2UJXJytNfCSmv3f
 JtGRemP1tE0xcDPsVH3LkhIjj0ddcfHTvwt0T6mEfPcLQ==
Message-Id: <3b7c8ef4.AUYAAJeLWk8AAAAAAAAABAMtJJMAAYKKIjQAAAAAAC-ZZgBp8da6@mailjet.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Yi Kuo <yi@yikuo.dev>
To: smfrench@gmail.com, linkinjeon@kernel.org
Subject: [PATCH v2] smb: smbdirect: fix MR registration for coalesced SG
 lists
Date: Wed, 29 Apr 2026 18:00:11 +0800
List-Unsubscribe-Post: List-Unsubscribe=One-Click
Cc: metze@samba.org, tom@talpey.com, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, Yi Kuo
	<yi@yikuo.dev>
Feedback-Id: 42.3119462.2858555:MJ
X-CSA-Complaints: csa-complaints@eco.de
X-MJ-Mid:
	AUYAAJeLWk8AAAAAAAAABAMtJJMAAYKKIjQAAAAAAC-ZZgBp8da6rX6_3ItuSmeTpgv5zbMWAwArnjs
X-MJ-SMTPGUID: 4535d1d9-c888-4a3f-91d4-e9f99aa9a4d7
X-REPORT-ABUSE-TO: Message sent by Mailjet please report to
	abuse@mailjet.com with a copy of the message
Content-Transfer-Encoding: quoted-printable

ib_dma_map_sg() modifies the provided scatterlist and returns the
number of mapped entries, which can be fewer than the requested
mr->sgt.nents if the DMA controller coalesces contiguous memory
segments. Passing the original, uncoalesced count to ib_map_mr_sg()
causes memory registration failures if coalescing actually occurs.

Capture the actual mapped count returned by ib_dma_map_sg() and pass it
to ib_map_mr_sg() to ensure correct MR registration.

Also update the ib_dma_map_sg() error logging to drop the error
pointer formatting, since the return value is an integer count
rather than an error code.

Ensure a proper error code (-EIO) is assigned when DMA mapping or
MR registration fails.

Fixes: de5ef8ec3c46 ("smb: smbdirect: introduce smbdirect_mr.c with client =
mr code")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D221408
Signed-off-by: Yi Kuo <yi@yikuo.dev>
---
v2:
- Add proper -EIO error assignment on mapping/registration failures.
- Add Fixes and Closes tags.

 fs/smb/smbdirect/mr.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/smb/smbdirect/mr.c b/fs/smb/smbdirect/mr.c
index 5228e699cd5d..5a428ff1b369 100644
--- a/fs/smb/smbdirect/mr.c
+++ b/fs/smb/smbdirect/mr.c
@@ -269,7 +269,7 @@ smbdirect_connection_register_mr_io(struct smbdirect_so=
cket *sc,
 {
 	const struct smbdirect_socket_parameters *sp =3D &sc->parameters;
 	struct smbdirect_mr_io *mr;
-	int ret, num_pages;
+	int ret, num_pages, num_mapped;
 	struct ib_reg_wr *reg_wr;
=20
 	num_pages =3D iov_iter_npages(iter, sp->max_frmr_depth + 1);
@@ -300,19 +300,22 @@ smbdirect_connection_register_mr_io(struct smbdirect_=
socket *sc,
 		num_pages, iov_iter_count(iter), sp->max_frmr_depth);
 	smbdirect_iter_to_sgt(iter, &mr->sgt, sp->max_frmr_depth);
=20
-	ret =3D ib_dma_map_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
-	if (!ret) {
+	num_mapped =3D ib_dma_map_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->=
dir);
+	if (!num_mapped) {
 		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
-			"ib_dma_map_sg num_pages=3D%u dir=3D%x ret=3D%d (%1pe)\n",
-			num_pages, mr->dir, ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
+			"ib_dma_map_sg num_pages=3D%u dir=3D%x num_mapped=3D%d\n",
+			num_pages, mr->dir, num_mapped);
+		ret =3D -EIO;
 		goto dma_map_error;
 	}
=20
-	ret =3D ib_map_mr_sg(mr->mr, mr->sgt.sgl, mr->sgt.nents, NULL, PAGE_SIZE)=
;
-	if (ret !=3D mr->sgt.nents) {
+	ret =3D ib_map_mr_sg(mr->mr, mr->sgt.sgl, num_mapped, NULL, PAGE_SIZE);
+	if (ret !=3D num_mapped) {
 		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
-			"ib_map_mr_sg failed ret =3D %d nents =3D %u\n",
-			ret, mr->sgt.nents);
+			"ib_map_mr_sg failed ret =3D %d num_mapped =3D %u\n",
+			ret, num_mapped);
+		if (ret >=3D 0)
+			ret =3D -EIO;
 		goto map_mr_error;
 	}
=20
--=20
2.54.0

=
